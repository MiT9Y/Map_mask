<?
    define("NO_KEEP_STATISTIC", true);
    define("NO_AGENT_CHECK", true);
    define('PUBLIC_AJAX_MODE', true);
    require($_SERVER["DOCUMENT_ROOT"]."/bitrix/modules/main/include/prolog_before.php");
    $_SESSION["SESS_SHOW_INCLUDE_TIME_EXEC"]="N";
    $APPLICATION->ShowIncludeStat = false;
    ini_set('max_execution_time', 900);

    function AddUser($new_data){
        global $ObjUser;
        global  $OutputObj;
        $InputLine = array();
        if (property_exists($new_data, 'Фотография')) {
            $pic_arr = CFile::MakeFileArray(__DIR__.'\\import\\'.$new_data->Фотография);
            if (isset($pic_arr)) $InputLine['PERSONAL_PHOTO'] = $pic_arr;            
        }
        $arGroups = array(2,5);
        if ($new_data->ПризнакРуководителя) $arGroups[]=12;
        $InputLine['GROUP_ID']=$arGroups;
        $InputLine['LOGIN'] = GetLogin($new_data->Фамилия);
        $InputLine['PASSWORD']='1234User';
        $InputLine['UF_NEW_PASS'] = true;
        $InputLine['LAST_NAME'] = $new_data->Фамилия;
        $InputLine['NAME'] = $new_data->Имя;
        $InputLine['SECOND_NAME'] = $new_data->Отчество;
        $InputLine['UF_1C_USER_UID'] = $new_data->ФизЛицоUID;
        $InputLine['WORK_FAX'] = $new_data->ВнутреннийТелефон;
        $InputLine['WORK_PHONE'] = $new_data->ГородскойТелефон;
        $InputLine['EMAIL'] = $new_data->ЭлПочта;
        $work_position = '';
        $DEPARTMENT_ARR = array();
        $DepIDFirst = null;
        foreach ($new_data->Подразделения as $v) {
            $work_position .= ', '.$v->Должность;
            $DepID = FoundDepBy1CUID($v->ПодразделениеUID);
            if (isset($DepID)) {
                if (!isset($DepIDFirst)) $DepIDFirst = $DepID;
                $DEPARTMENT_ARR[] = $DepID;
            }
        }
        if (strlen($work_position)>0) $work_position = substr($work_position, 2);
        $InputLine['UF_DEPARTMENT'] = $DepIDFirst;
        $InputLine['WORK_POSITION'] = $work_position;
        $InputLine['UF_DEPARTMENT_ARR'] = $DEPARTMENT_ARR;              
        $InputLine['WORK_DEPARTMENT'] = GetFullDep($DepIDFirst);
        $ObjUser->Add($InputLine);
        if ($ObjUser->LAST_ERROR) {
//            echo '----------<br>';echo '----------<br>';
//            echo '<pre>';var_dump($InputLine);echo '</pre>';
//            echo '----------<br>';
//            echo '<pre>';var_dump($new_data);echo '</pre>';
//            echo '----------<br>';echo '----------<br>';
            if ($OutputObj->Error == 'Ошибок нет') $OutputObj->Error = 'Сотрудник UID - '.$new_data->Фамилия.', ошибка: '.$ObjUser->LAST_ERROR;
            else $OutputObj->Error .= ', Сотрудник UID - '.$new_data->Фамилия.', ошибка: '.$ObjUser->LAST_ERROR;
        }
    }

    function UpdateUser($old_data,$new_data){
        global $ObjUser;
        global  $OutputObj;
        $InputLine = array();
        if ($old_data['PERSONAL_PHOTO']>0) CFile::Delete($old_data['PERSONAL_PHOTO']);
        if (property_exists($new_data, 'Фотография')) {
            $pic_arr = CFile::MakeFileArray(__DIR__.'\\import\\'.$new_data->Фотография);
            if (isset($pic_arr)) $InputLine['PERSONAL_PHOTO'] = $pic_arr;            
        }
        if ($old_data['ACTIVE']!='Y') $InputLine['ACTIVE'] = 'Y';
        if ($old_data['LAST_NAME'] != $new_data->Фамилия) $InputLine['LAST_NAME'] = $new_data->Фамилия;
        if ($old_data['NAME'] != $new_data->Имя) $InputLine['NAME'] = $new_data->Имя;
        if ($old_data['SECOND_NAME'] != $new_data->Отчество) $InputLine['SECOND_NAME'] = $new_data->Отчество;
        if ($old_data['UF_1C_USER_UID'] != $new_data->ФизЛицоUID) $InputLine['UF_1C_USER_UID'] = $new_data->ФизЛицоUID;
        if ($old_data['WORK_FAX'] != $new_data->ВнутреннийТелефон && $new_data->ВнутреннийТелефон !='') $InputLine['WORK_FAX'] = $new_data->ВнутреннийТелефон;
        if ($old_data['WORK_PHONE'] != $new_data->ГородскойТелефон && $new_data->ГородскойТелефон !='') $InputLine['WORK_PHONE'] = $new_data->ГородскойТелефон;
        if ($old_data['EMAIL'] != $new_data->ЭлПочта && $new_data->ЭлПочта !='') $InputLine['EMAIL'] = $new_data->ЭлПочта;
        if (!mb_stristr(str_replace("ё", "е", $old_data['LOGIN']),str_replace("ё", "е", $new_data->Фамилия))) {
            $InputLine['LOGIN'] = GetLogin($new_data->Фамилия);
            $InputLine['UF_NEW_PASS'] = true;
        }
        $arGroups = CUser::GetUserGroup($old_data['ID']);        
        if (array_diff(array(5),$arGroups)) {$arGroups[]=5;$InputLine['GROUP_ID']=$arGroups;}
        if ($new_data->ПризнакРуководителя && !array_search(12,$arGroups)) {$arGroups[]=12;$InputLine['GROUP_ID']=$arGroups;}
        if (!$new_data->ПризнакРуководителя && array_search(12,$arGroups)) {$arGroups = array_diff($arGroups, array(12));$InputLine['GROUP_ID']=$arGroups;}
        if (count($new_data->Подразделения)>0) {
            $work_position = '';
            $DEPARTMENT_ARR = array();
            $DepIDFirst = null;
            foreach ($new_data->Подразделения as $v) {
                $work_position .= ', '.$v->Должность;
                $DepID = FoundDepBy1CUID($v->ПодразделениеUID);
                if (isset($DepID)) {
                    if (!isset($DepIDFirst)) $DepIDFirst = $DepID;
                    $DEPARTMENT_ARR[] = $DepID;
                }
            }
            if (strlen($work_position)>0) $work_position = substr($work_position, 2);
            if ($old_data['UF_DEPARTMENT']!=$DepIDFirst) {$InputLine['UF_DEPARTMENT'] = $DepIDFirst; $InputLine['WORK_DEPARTMENT'] = GetFullDep($DepIDFirst);}
            if ($old_data['WORK_POSITION']!=$work_position) $InputLine['WORK_POSITION']=$work_position;
            if (!$old_data['UF_DEPARTMENT_ARR']) $old_data['UF_DEPARTMENT_ARR'] = array();
            if (array_diff($old_data['UF_DEPARTMENT_ARR'], $DEPARTMENT_ARR) || array_diff($DEPARTMENT_ARR, $old_data['UF_DEPARTMENT_ARR'])) $InputLine['UF_DEPARTMENT_ARR']=$DEPARTMENT_ARR;
        }
        if ($InputLine) {
            $ObjUser->Update($old_data['ID'], $InputLine);
            if ($ObjUser->LAST_ERROR) {
                if ($OutputObj->Error == 'Ошибок нет') $OutputObj->Error = 'Сотрудник UID - '.$new_data->Фамилия.', ошибка: '.$ObjUser->LAST_ERROR;
                else $OutputObj->Error .= ', Сотрудник UID - '.$new_data->Фамилия.', ошибка: '.$ObjUser->LAST_ERROR;
            }            
        }
    }

    function FoundDepBy1CUID($uid){
        $dbRes = CIBlockSection::GetList(array(), array('IBLOCK_ID'=>2,'UF_1C_UID'=>$uid), false, array('ID'));
        if ($dbRes->result->num_rows>0) return $dbRes->Fetch()['ID']; else return null;
    }

    function FoundByUID($uid1C,$idata){
        foreach ($idata as $v) {
            if ($uid1C==$v->ФизЛицоUID) return true;
        }
        return false;
    }

    function foundUserByUID($uid){
        global $AllUsers;
        foreach ($AllUsers as $v) {
            if ($v['UF_1C_USER_UID']==$uid) return $v;
        }
        return null;
    }

    function foundUserByFIO($f,$i,$o){
        global $AllUsers;
        foreach ($AllUsers as $v) {
            if ($v['UF_1C_USER_UID']==null && $v['LAST_NAME']==$f && $v['NAME']==$i && $v['SECOND_NAME']==$o) return $v;
        }
        return null;
    }

    function GetLogin($f){
        global $AllUsers;
        $Index=array();
        $f_ed = str_replace("ё", "е", $f);
        foreach ($AllUsers as $v) {
            $login_ed = str_replace("ё", "е", $v['LOGIN']);
            if (mb_stristr($login_ed,$f_ed)) {
                $Index[str_replace(mb_strtolower($f_ed),'',mb_strtolower($login_ed))] = true;
            }
        }
        if (!$Index) return $f.'1';
        $i=1;
        while ($i) {
            if (!isset($Index[$i])) return $f.$i;
            $i++;
        }
    }

    function GenerateNewPas($oUser){
        global $OutputObj;
        global $ObjUser;
//        if ($oUser['ID']==46) {
            $NewPassword = dechex(mt_rand (0,16777214));
            $InputLine = array();
            $InputLine['PASSWORD'] = $NewPassword;
            $InputLine['UF_NEW_PASS'] = '0';
            $ObjUser->Update($oUser['ID'], $InputLine);
            if ($ObjUser->LAST_ERROR) {
                if ($OutputObj->Error == 'Ошибок нет') $OutputObj->Error = 'Сотрудник UID - '.$oUser['UF_1C_USER_UID'].', ошибка: '.$ObjUser->LAST_ERROR;
                else $OutputObj->Error .= ', Сотрудник UID - '.$oUser['UF_1C_USER_UID'].', ошибка: '.$ObjUser->LAST_ERROR;
            }            
            if ($oUser['EMAIL']) {
                $subject = "УЧЕТНЫЕ ДАННЫЕ ЛИЧНОГО КАБИНЕТА PORTAL.GRO32.RU";
                $message = "<h1>Новые учётные данные пользователя</h1><br>";
                $message .= "Пользователь - <b>".$oUser['LAST_NAME'].' '.$oUser['NAME'].' '.$oUser['SECOND_NAME']."</b><br>";
                $message .= "Email - <b>".$oUser['EMAIL']."</b><br>";
                $message .= "LOGIN - <b>".$oUser['LOGIN']."</b><br>";
                $message .= "PASSWORD - <b>".$NewPassword.'</b><br>*(<a href="http://portal.gro32.ru/company/profile.php">Пароль можно изменить в личном кабинете</a>)<br>';
                $message .= "<br><br><br>Данное письмо сгенерировано автоматически";
                $headers  = 'MIME-Version: 1.0'."\r\n";
                $headers .= 'Content-type: text/html; charset=UTF-8'."\r\n";
                $headers .= 'From:portal_robot@gro32.ru'."\r\n";
                mail($oUser['EMAIL'],$subject,$message,$headers);
            }
//        }
    }

    function GetFullDep ($id){
        $dbRes = CIBlockSection::GetList(array(), array('IBLOCK_ID'=>2,'ID'=>$id), false, array("NAME","IBLOCK_SECTION_ID"));
        if ($dbRes->result->num_rows>0) {
            $arDep = $dbRes->Fetch();
            if (isset($arDep['IBLOCK_SECTION_ID'])) return GetFullDep($arDep['IBLOCK_SECTION_ID']).'\\'.$arDep['NAME'];
            else return $arDep['NAME'];
        }
        else return '';
    }

    function rmRec($path) {
        if (is_file($path)) return unlink($path);
        if (is_dir($path)) {
          foreach(scandir($path) as $p) if (($p!='.') && ($p!='..'))
            rmRec($path.DIRECTORY_SEPARATOR.$p);
          return rmdir($path); 
          }
        return false;
    }    

    CModule::IncludeModule('iblock');
    $ObjUser = new CUser;
    $OutputObj = new stdClass();
    $OutputObj->Error = "Ошибок нет";
    $AllUsers = array();
    $select["SELECT"] = array('UF_1C_USER_UID','UF_DEPARTMENT','UF_DEPARTMENT_ARR','UF_NEW_PASS');
    $select["FIELDS"] = array('ID','ACTIVE','LAST_NAME','NAME','SECOND_NAME','work_phone','work_fax','email','work_position','LOGIN','PERSONAL_PHOTO');
    $rsUsers = CUser::GetList(($by="personal_country"), ($order="desc"), array(),$select);
    while($arUser=$rsUsers->Fetch()){
        $AllUsers[] =  $arUser;
//        echo $arUser["LOGIN"].'<br>';
    }

    if (file_exists('./import/')===FALSE) mkdir('./import/');

    if (isset($_FILES["datafile"])) {
        copy($_FILES["datafile"]["tmp_name"],'./import/'.$_FILES["datafile"]["name"]);
//        echo '<pre>';var_dump($_FILES);echo '</pre>';
        if ($_GET['last_file']==TRUE) {
            $index = strpos($_FILES["datafile"]["name"],'.');
            $name_file_part = substr($_FILES["datafile"]["name"],$index);
            if ($index!==FALSE){
                $index = substr($_FILES["datafile"]["name"],0,$index);
                if (is_numeric($index)){
                    $filename = './import/import.zip';
                    file_put_contents($filename,"");
                    for ($i = 1; $i <= $index; $i++) {
                        file_put_contents($filename, file_get_contents('./import/'.$i.$name_file_part), FILE_APPEND);                    
                    }
                    if (pathinfo($filename, PATHINFO_EXTENSION)=='zip') {
                        $zip = new ZipArchive;
                        if ($zip->open($filename)) { 
                            $zip->extractTo('./import/');
                            $zip->close();

                            if ($json_file = file_get_contents(__DIR__.'/import/import.json')) {
                                file_put_contents('user_log.txt', $json_file);
                                $json_file = substr($json_file,strpos($json_file, "["));
                                $InData = json_decode($json_file);
                                if (json_last_error()==JSON_ERROR_NONE) {

                                    foreach ($InData as $v) {
                                        $oUser = foundUserByUID($v->ФизЛицоUID);
                                        if (isset($oUser)) UpdateUser($oUser,$v); else {
                                            $oUser = foundUserByFIO($v->Фамилия,$v->Имя,$v->Отчество);
                                            if (isset($oUser)) UpdateUser($oUser,$v); else AddUser($v);
                                        }
                                    }
                                    //Отключение пользователей которых нет в 1С (Проверка сброса пароля) НАЧАЛО
                                    $select["SELECT"] = array('UF_1C_USER_UID','UF_NEW_PASS');
                                    $select["FIELDS"] = array('ID','ACTIVE','LOGIN','LAST_NAME','NAME','SECOND_NAME','email');
                                    $filter = array('GROUPS_ID'=>5);
                                    $rsUsers = CUser::GetList(($by="personal_country"), ($order="desc"), $filter,$select);
                                    while($arUser=$rsUsers->Fetch()){
                                        if ($arUser['UF_NEW_PASS']&&$arUser['EMAIL']!='') GenerateNewPas($arUser);
                                        if (isset($arUser["UF_1C_USER_UID"]))
                                            if (!FoundByUID($arUser["UF_1C_USER_UID"],$InData) && $arUser["ACTIVE"]=='Y') {
                                                $ObjUser->Update($arUser['ID'], array('ACTIVE'=>'N'));
                                            }
                                    }
                        
                                } else $OutputObj->Error = 'Ошибка декодирования JSON файла';
                            } else $OutputObj->Error =  'Не найден файл с данными';
                 
                            rmRec('import');
                        } else $OutputObj->Error = 'Error open zip archive';
                    } else $OutputObj->Error = 'Error TYPE file (not zip)';
                } else $OutputObj->Error = 'Error index';
            } else $OutputObj->Error = 'Error TYPE file (not index)';
        }
    }

/*    if (isset($_POST['param'])) {
        file_put_contents('user_log.txt', $_POST['param']);
        $InData = json_decode($_POST['param']);
        if (json_last_error()==JSON_ERROR_NONE) {
//            echo '<pre>';var_dump($InData);echo '</pre>';
            foreach ($InData as $v) {
                $oUser = foundUserByUID($v->ФизЛицоUID);
                if (isset($oUser)) UpdateUser($oUser,$v); else {
                    $oUser = foundUserByFIO($v->Фамилия,$v->Имя,$v->Отчество);
                    if (isset($oUser)) UpdateUser($oUser,$v); else AddUser($v);
                }
            }
            //Отключение пользователей которых нет в 1С (Проверка сброса пароля) НАЧАЛО
            $select["SELECT"] = array('UF_1C_USER_UID','UF_NEW_PASS');
            $select["FIELDS"] = array('ID','ACTIVE','LOGIN','LAST_NAME','NAME','SECOND_NAME','email');
            $filter = array('GROUPS_ID'=>5);
            $rsUsers = CUser::GetList(($by="personal_country"), ($order="desc"), $filter,$select);
            while($arUser=$rsUsers->Fetch()){
                if ($arUser['UF_NEW_PASS']&&$arUser['EMAIL']!='') GenerateNewPas($arUser);
                if (isset($arUser["UF_1C_USER_UID"]))
                    if (!FoundByUID($arUser["UF_1C_USER_UID"],$InData) && $arUser["ACTIVE"]=='Y') {
                        $ObjUser->Update($arUser['ID'], array('ACTIVE'=>'N'));
                    }
            }
            //Отключение пользователей которых нет в 1С (Проверка сброса пароля) КОНЕЦ
        } else $OutputObj->Error = "Ошибка декодирования JSON: ".$_POST['param'];
    } else $OutputObj->Error = "Нет входных данных";*/

    echo json_encode($OutputObj,JSON_UNESCAPED_UNICODE);

    require($_SERVER["DOCUMENT_ROOT"]."/bitrix/modules/main/include/epilog_after.php");
?>