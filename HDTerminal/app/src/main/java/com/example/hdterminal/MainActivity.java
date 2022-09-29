package com.example.hdterminal;

import android.Manifest;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.PackageManager;
import android.os.Build;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.v7.app.AppCompatActivity;
import android.text.Html;
import android.text.method.ScrollingMovementMethod;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.TextView;
import android.widget.Toast;

import com.nbsp.materialfilepicker.MaterialFilePicker;
import com.nbsp.materialfilepicker.ui.FilePickerActivity;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.w3c.dom.Text;
import org.xml.sax.SAXException;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

public class MainActivity extends AppCompatActivity {

    private static final String TAG = "My LOG";
    SharedPreferences sPref;
    Button button;
    Button button2;
    Button button3;
    Button button4;
    Button button8;
    ImageButton imageButton;
    ImageButton imageButton2 ;
    TextView textView;
    static TextView main_content;
    public static EditText editText;

    static Document data_1C;
    static DOMSource data_1C_source = null;
    static StreamResult data_1C_result = null;
    static ArrayList <String> equipments_cod = new <String> ArrayList();
    static ArrayList <Node> equipments = new <Node> ArrayList();
    static ArrayList <String> places_name = new <String> ArrayList();
    static ArrayList <Node> places = new <Node> ArrayList();
    public static Integer IndexEquipment = -1;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        Log.d(TAG, "Programm run");

        setContentView(R.layout.activity_main);
        button = findViewById(R.id.button);
        button2 = findViewById(R.id.button2);
        button3 = findViewById(R.id.button3);
        button4 = findViewById(R.id.button4);
        button8 = findViewById(R.id.button8);
        imageButton = findViewById(R.id.imageButton);
        imageButton2 = findViewById(R.id.imageButton2);
        textView = findViewById(R.id.textView);
        main_content = findViewById(R.id.mainContent);
        main_content.setMovementMethod(new ScrollingMovementMethod());
        editText = findViewById(R.id.editText);

        if (Build.VERSION.SDK_INT > Build.VERSION_CODES.M && checkSelfPermission(Manifest.permission.WRITE_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
            requestPermissions(new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE}, 1001);
        }
        if (Build.VERSION.SDK_INT > Build.VERSION_CODES.M && checkSelfPermission(Manifest.permission.CAMERA) != PackageManager.PERMISSION_GRANTED) {
            requestPermissions(new String[]{Manifest.permission.CAMERA}, 1001);
        }

        sPref = getPreferences(MODE_PRIVATE);
        String filePath = sPref.getString("FilePath", "");
        data_1C = LoadXMLFile(filePath);
        Set_data_1C(filePath);

        imageButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                startActivity(new Intent(MainActivity.this,QRScanForm.class));
            }
        });

        imageButton2.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                new MaterialFilePicker()
                        .withActivity(MainActivity.this)
                        .withRequestCode(1000)
                        //.withFilter(Pattern.compile(".*\\.txt$")) // Filtering files and directories by file name using regexp
                        //.withFilterDirectories(true) // Set directories filterable (false by default)
                        .withHiddenFiles(true) // Show hidden files and folders
                        .start();
            }
        });

        button.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                FoundInfo();
            }
        });

        button3.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (IndexEquipment>-1){
                    NodeList equipment_val = equipments.get(IndexEquipment).getChildNodes();
                    SimpleDateFormat sdf = new SimpleDateFormat("dd.MM.yyyy HH:mm:ss");
                    SetValueNode(GetNodebyNameAttribute(equipment_val,"Property","name","r_date"),sdf.format(new Date()));
                    SetValueNode(GetNodebyNameAttribute(equipment_val,"Property","name","r_res"),"Да");
                    SetValueNode(GetNodebyNameAttribute(equipment_val,"Property","name","r_equ_del"),"Нет");
                    FoundInfo();
//                    Save_data_1C();
                } else main_content.setText(Html.fromHtml("<font color=#FF0000>Операция запрещена пока не выбрано оборудование.</font>"));
            }
        });

        button4.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (IndexEquipment>-1){
                    NodeList equipment_val = equipments.get(IndexEquipment).getChildNodes();
                    SetValueNode(GetNodebyNameAttribute(equipment_val,"Property","name","r_date"),"");
                    SetValueNode(GetNodebyNameAttribute(equipment_val,"Property","name","r_res"),"");
                    SetValueNode(GetNodebyNameAttribute(equipment_val,"Property","name","r_cod_place"),"");
                    SetValueNode(GetNodebyNameAttribute(equipment_val,"Property","name","r_type_place"),"");
                    SetValueNode(GetNodebyNameAttribute(equipment_val,"Property","name","r_place"),"");
                    SetValueNode(GetNodebyNameAttribute(equipment_val,"Property","name","r_equ_del"),"");
                    FoundInfo();
//                    Save_data_1C();
                } else main_content.setText(Html.fromHtml("<font color=#FF0000>Операция запрещена пока не выбрано оборудование.</font>"));
            }
        });
        button2.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (IndexEquipment>-1) startActivity(new Intent(MainActivity.this, СhoicePlaceForm.class));
                else main_content.setText(Html.fromHtml("<font color=#FF0000>Операция запрещена пока не выбрано оборудование.</font>"));
            }
        });

        button8.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Save_data_1C();
            }
        });

    }

    private void Set_data_1C(String fileName){
        data_1C_source = null;
        data_1C_result = null;
        if (data_1C != null) {
            data_1C_source = new DOMSource(data_1C);
            data_1C_result = new StreamResult(new File(fileName));
        }
    }

    private Document LoadXMLFile(String fileName){
        Document Res = null;
        equipments_cod.clear();
        equipments.clear();
        places_name.clear();
        places.clear();
        textView.setText("Файл с данными:" + fileName);
        try {
            DocumentBuilderFactory builderFactory = DocumentBuilderFactory.newInstance();
            DocumentBuilder docBuilder = builderFactory.newDocumentBuilder();
            Res = docBuilder.parse(new File(fileName));
        } catch (ParserConfigurationException e) {
            Toast.makeText(this, e.getMessage(), Toast.LENGTH_SHORT).show();
        } catch (IOException e) {
            Toast.makeText(this, e.getMessage(), Toast.LENGTH_SHORT).show();
        } catch (SAXException e) {
            Toast.makeText(this, e.getMessage(), Toast.LENGTH_SHORT).show();
        }
        if (Res!=null){
            String StDateCreate = GetValueNode(this.GetNodebyNameAttribute(Res.getFirstChild().getChildNodes(),"Property","name","datecreate"));
            if (!StDateCreate.equals("")) textView.setText(textView.getText() + System.getProperty("line.separator") + "Дата создания файла: " + StDateCreate.replace("T", " "));
            else textView.setText(textView.getText() + System.getProperty("line.separator") + "Дата создания файла: нет данных");
            Node equipment = this.GetNodebyNameAttribute(Res.getFirstChild().getChildNodes(),"Property","name","equipments");
            if (equipment!=null) {
                NodeList equipments = equipment.getChildNodes().item(1).getChildNodes();
                for(int i =0;i<equipments.getLength();i++){
                    if (equipments.item(i).hasAttributes()) {
                        this.equipments_cod.add(GetValueNode(this.GetNodebyNameAttribute(equipments.item(i).getChildNodes(), "Property", "name", "cod")));
                        this.equipments.add(equipments.item(i));
                    }
                }
            }
            Node placesNode = this.GetNodebyNameAttribute(Res.getFirstChild().getChildNodes(),"Property","name","places");
            if (placesNode!=null) {
                NodeList placeNode = placesNode.getChildNodes().item(1).getChildNodes();
                for(int i =0;i<placeNode.getLength();i++){
                    if (placeNode.item(i).hasAttributes()) {
                        this.places_name.add(GetValueNode(this.GetNodebyNameAttribute(placeNode.item(i).getChildNodes(), "Property", "name", "name")));
                        this.places.add(placeNode.item(i));
                    }
                }
            }
            textView.setText(textView.getText() + System.getProperty("line.separator") + "Загружено "+Integer.toString(this.equipments_cod.size())+" ед. оборудования");
        } else {textView.setText(textView.getText() + System.getProperty("line.separator")+"Файл не загружен. Не верный формат данных.");}
        return Res;
    }

    private void Save_data_1C(){
        if (data_1C_source != null && data_1C_result != null) {
            try {
                TransformerFactory transformerFactory = TransformerFactory.newInstance();
                Transformer transformer = transformerFactory.newTransformer();
                transformer.transform(data_1C_source,data_1C_result);
            } catch (TransformerConfigurationException e) {
                Toast.makeText(this, e.getMessage(), Toast.LENGTH_SHORT).show();
            } catch (TransformerException e) {
                Toast.makeText(this, e.getMessage(), Toast.LENGTH_SHORT).show();
            }
        }
    }

    protected static Node GetNodebyNameAttribute(NodeList Sourse, String TagName, String AttributeName, String AttributeValue){
        Node Res = null;
        for(int i =0;i<Sourse.getLength();i++){
            if (Sourse.item(i).hasAttributes()) if (Sourse.item(i).getNodeName().equals(TagName)) {
                Node NodeAttr  = Sourse.item(i).getAttributes().getNamedItem(AttributeName);
                if (NodeAttr != null) if (NodeAttr.getNodeValue().equals(AttributeValue)) {
                    Res = Sourse.item(i);
                    break;
                }
            }
        }
        return Res;
    }

    protected static String GetValueNode(Node Sourse){
        String Res = "";
        if (Sourse != null) {
            Element ESourse = (Element) Sourse;
            if (ESourse.getElementsByTagName("Value").item(0).hasChildNodes())
                Res = ESourse.getElementsByTagName("Value").item(0).getFirstChild().getNodeValue();
        }
        return Res;
    }

    protected static void SetValueNode(Node Sourse, String Val) {
        if (Sourse != null) {
            Element ESourse = (Element) Sourse;
            if (ESourse.getElementsByTagName("Value").item(0).hasChildNodes())
                ESourse.getElementsByTagName("Value").item(0).getFirstChild().setNodeValue(Val);
            else {
                Text text = data_1C.createTextNode(Val);
                ESourse.getElementsByTagName("Value").item(0).appendChild(text);
            }
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

        if (requestCode == 1000 && resultCode == RESULT_OK) {
            String filePath = data.getStringExtra(FilePickerActivity.RESULT_FILE_PATH);
            textView.setText(filePath);
            sPref = getPreferences(MODE_PRIVATE);
            SharedPreferences.Editor ed = sPref.edit();
            ed.putString("FilePath",filePath);
            ed.commit();
            data_1C = LoadXMLFile(filePath);
            Set_data_1C(filePath);
            Toast.makeText(MainActivity.this, "New path save",Toast.LENGTH_SHORT).show();
        }
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        switch (requestCode){
            case 1001: {
                if (grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                    Toast.makeText(this,"Permission granted!", Toast.LENGTH_SHORT).show();
                } else {
                    Toast.makeText(this,"Permission not granted!", Toast.LENGTH_SHORT).show();
                    finish();
                }
            }

        }
    }

    public static void FoundInfo() {
        if (data_1C!=null){
            IndexEquipment = equipments_cod.indexOf(editText.getText().toString());
            if (IndexEquipment>-1) {
                String equipmentText = "<big>Оборудование</big><br>";
                NodeList equipment_val = equipments.get(IndexEquipment).getChildNodes();
                equipmentText += "Код 1C: "+editText.getText().toString()+"<br>";
                equipmentText += "Серийный номер: <b>"+GetValueNode(GetNodebyNameAttribute(equipment_val,"Property","name","serial"))+"</b><br>";
                equipmentText += "Тип оборудования: <b>"+GetValueNode(GetNodebyNameAttribute(equipment_val,"Property","name","type"))+"</b><br>";
                equipmentText += "Инвентарный номер: <b>"+GetValueNode(GetNodebyNameAttribute(equipment_val,"Property","name","inventory"))+"</b><br>";
                equipmentText += "Статус оборудования: "+GetValueNode(GetNodebyNameAttribute(equipment_val,"Property","name","status"))+"<br><small><br></small>";
                String TempStr;
                if (GetValueNode(GetNodebyNameAttribute(equipment_val,"Property","name","type_place")).equals("1")) {
                    equipmentText += "<big>Рабочее место</big><br>";
                    TempStr = GetValueNode(GetNodebyNameAttribute(equipment_val,"Property","name","work_place"));
                    if (TempStr.equals("")) TempStr = "нет данных";
                    equipmentText += "Сотрудник: <b>"+TempStr+"</b><br>";
                } else equipmentText += "<big>Кабинет</big><br>";
                TempStr = GetValueNode(GetNodebyNameAttribute(equipment_val,"Property","name","res_place"));
                if (TempStr.equals("")) TempStr = "нет данных";
                equipmentText += "Ответственны за кабинет: <b>"+TempStr+"</b><br>";
                equipmentText += "Место установки оборудования: <b>"+GetValueNode(GetNodebyNameAttribute(equipment_val,"Property","name","place"))+"</b><br><small><br></small>";
                equipmentText += "<big>Последние данные о проверке</big><br>";
                TempStr = GetValueNode(GetNodebyNameAttribute(equipment_val,"Property","name","r_date"));
                if (TempStr.equals(""))  equipmentText += "Проверка не проводилась"; else {
                    equipmentText += "Дата проверки: <b>" + TempStr + "</b><br>";
                    if (GetValueNode(GetNodebyNameAttribute(equipment_val,"Property","name","r_res")).equals("Да"))
                        equipmentText += "Результат: <b><font color=#00FF00>местоположение корректно</font></b><br>";
                    else {
                        equipmentText += "Результат: <b><font color=#FF0000>местоположение некорректно</font></b><br>";
                        TempStr = GetValueNode(GetNodebyNameAttribute(equipment_val,"Property","name","r_equ_del"));
                        if (TempStr.equals("Да")) equipmentText += "Причина: списание оборудования<br>"; else {
                            equipmentText += "Причина: перемещение оборудования<br>";
                            TempStr = GetValueNode(GetNodebyNameAttribute(equipment_val,"Property","name","r_place"));
                            if (TempStr.equals(""))  TempStr = "нет данных";
                            equipmentText += "Новое местоположение: <b>"+TempStr+"<b><br>";
                        }
                    }
                }
                main_content.setText(Html.fromHtml(equipmentText));
            } else main_content.setText(Html.fromHtml("<font color=#FF0000>Оборудование по коду:"+editText.getText().toString()+" не найдено.</font>"));
        }
    }

    @Override
    protected void onStop() {
        Save_data_1C();
        super.onStop();
    }

}
