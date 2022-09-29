<?
    define("NO_KEEP_STATISTIC", true);
    define("NO_AGENT_CHECK", true);
    define('PUBLIC_AJAX_MODE', true);
    require($_SERVER["DOCUMENT_ROOT"]."/bitrix/modules/main/include/prolog_before.php");
    $_SESSION["SESS_SHOW_INCLUDE_TIME_EXEC"]="N";
    $APPLICATION->ShowIncludeStat = false;

    CModule::IncludeModule('iblock');
    $BS = new CIBlockSection;

    function FoundObjOnUID($UID,$arrIn){
        $res = null;
        if (isset($arrIn)) {
            foreach ($arrIn as $v) {
                if ($v->UID==$UID) $res = $v;
                if ($res!=null) return $res;
                if (count($v->Tree)>0) {
                    $res = FoundObjOnUID($UID,$v->Tree);
                    if ($res!=null) return $res;
                }
            }
        }
        return $res;
    }

    function UpdateDep($arrIn,$ipPar){
        global $BS;
        global $OutputObj;
        if (isset($arrIn)) {
            foreach ($arrIn as $v) {
                if (isset($v->UPDATE)) {
                    if ($ipPar!=$v->UPDATE['ID_PARENT']) $BS->Update($v->UPDATE['ID'],array('IBLOCK_ID'=>2,'IBLOCK_SECTION_ID'=>(string)$ipPar));
                        $ID_BX = $v->UPDATE['ID'];
                } else {
                    $arFields = array('IBLOCK_ID'=>2,'ACTIVE'=>'Y','UF_1C_UID'=>$v->UID,'NAME'=>$v->Name,'IBLOCK_SECTION_ID'=>(string)$ipPar);
                    if (isset($v->Telephone)) $arFields['UF_PHONE'] = $v->Telephone;
                    if (isset($v->Email)) $arFields['UF_EMAIL'] = $v->Email;
                    if (isset($v->Fax)) $arFields['UF_FAX'] = $v->Fax;
                    $ID_BX=$BS->Add($arFields);
                    if ($BS->LAST_ERROR) {
                        if ($OutputObj->Error == 'Ошибок нет') $OutputObj->Error = 'Подразделение UID - '.$v->UID.', ошибка: '.$BS->LAST_ERROR;
                        else $OutputObj->Error .= ', Подразделение UID - '.$v->UID.', ошибка: '.$BS->LAST_ERROR;
                    }                    
                }
                if ($v->Tree>0) UpdateDep($v->Tree,$ID_BX);
            }
        }
    }
    
    $OutputObj = new stdClass();
    $OutputObj->Error = "Ошибок нет";
    if (isset($_POST['param'])) {
        file_put_contents('dep_log.txt', $_POST['param']);
        $InData = json_decode($_POST['param']);
        if (json_last_error()==JSON_ERROR_NONE) {
            $dbRes = CIBlockSection::GetList(array(), array('IBLOCK_ID'=>2), false, array('ID','ACTIVE','NAME','IBLOCK_SECTION_ID','XML_ID','UF_BASE_DN','UF_PHONE','UF_EMAIL','UF_FAX','UF_1C_UID'));
            while($arItem=$dbRes->Fetch()) {
                if ($arItem['UF_1C_UID']!=null) {                    
                    $Found1C = FoundObjOnUID($arItem['UF_1C_UID'],$InData);                    
                    if ($Found1C!=Null) {
                        $Found1C->UPDATE = array('ID'=>$arItem['ID'],'ID_PARENT'=>$arItem['IBLOCK_SECTION_ID']);
                        $arFields = array('IBLOCK_ID'=>2);
                        if ($arItem['ACTIVE']=='N') $arFields['ACTIVE']='Y';
                        if ($Found1C->Name!=$arItem['NAME']) $arFields['NAME'] = $Found1C->Name;
                        if (isset($Found1C->Telephone)) {if ($Found1C->Telephone!=$arItem['UF_PHONE']) $arFields['UF_PHONE'] = $Found1C->Telephone;}
                        if (isset($Found1C->Email)) {if ($Found1C->Email!=$arItem['UF_EMAIL']) $arFields['UF_EMAIL'] = $Found1C->Email;}
                        if (isset($Found1C->Fax)) {if ($Found1C->Fax!=$arItem['UF_FAX']) $arFields['UF_FAX'] = $Found1C->Fax;}
                        if (count($arFields)>1) $BS->Update($arItem['ID'],$arFields);
                    } else {
                        $BS->Update($arItem['ID'],array('IBLOCK_ID'=>2,'ACTIVE'=>'N'));
                        if ($BS->LAST_ERROR) {
                            if ($OutputObj->Error == 'Ошибок нет') $OutputObj->Error = 'Подразделение UID - '.$Found1C->UID.', ошибка: '.$BS->LAST_ERROR;
                            else $OutputObj->Error .= ', Подразделение UID - '.$Found1C->UID.', ошибка: '.$BS->LAST_ERROR;
                        }                    
    
                    }
                }
            }
            UpdateDep($InData,null);
        } else $OutputObj->Error = "Ошибка декодирования JSON: ".$_POST['param'];
    } else $OutputObj->Error = "Нет входных данных";

    echo json_encode($OutputObj,JSON_UNESCAPED_UNICODE);

    require($_SERVER["DOCUMENT_ROOT"]."/bitrix/modules/main/include/epilog_after.php");
?>