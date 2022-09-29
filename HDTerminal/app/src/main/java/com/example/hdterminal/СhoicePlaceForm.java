package com.example.hdterminal;

import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.TextView;

import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

import static com.example.hdterminal.MainActivity.GetNodebyNameAttribute;

public class СhoicePlaceForm extends AppCompatActivity {

    private static final String TAG = "My LOG";

    Button button5;
    Button button6;
    Button button7;
    EditText editText2;
    LinearLayout linerLayout1;
    FrameLayout frameLayout2;
    ViewGroup.LayoutParams frameLayout2_params;
    RadioGroup radioGroup;
    RadioButton radioButton;
    RadioButton radioButton2;
    ListView dynamic;
    ListView dynamic2;
//  Переменные для XML
    String r_date = "";
    String r_res = "";
    String r_cod_place = "";
    String r_type_place = "";
    String r_place = "";
    String r_equ_del = "Нет";
    String cab_code = "";
    String cab_name = "";
//  Переменные для XML

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_place_form);
        button5 = findViewById(R.id.button5);
        button6 = findViewById(R.id.button6);
        button7 = findViewById(R.id.button7);
        editText2 = findViewById(R.id.editText2);
        linerLayout1 = findViewById(R.id.linerLayout1);
        frameLayout2 = findViewById(R.id.frameLayout2);
        frameLayout2_params = frameLayout2.getLayoutParams();
        frameLayout2_params.height = 0;
//        frameLayout2.setVisibility(View.INVISIBLE);
        radioButton = findViewById(R.id.radioButton);
        radioButton2 = findViewById(R.id.radioButton2);
        radioGroup = findViewById(R.id.radioGroup);
        dynamic = findViewById(R.id.dynamic);
        dynamic2 = findViewById(R.id.dynamic2);

        final ArrayList <String> wplaseName = new ArrayList<>();
        final ArrayList <String> wplaseCode = new ArrayList<>();

        final ArrayList<String> CabSourse =  (ArrayList<String>) MainActivity.places_name.clone();

        final ArrayAdapter<String> adapter = new ArrayAdapter <>(this,
                R.layout.list_item, CabSourse);

        final ArrayAdapter<String> adapter2 = new ArrayAdapter <>(this,
                R.layout.list_item, wplaseName);

        dynamic.setChoiceMode(ListView.CHOICE_MODE_SINGLE);
        dynamic.setAdapter(adapter);

        dynamic2.setChoiceMode(ListView.CHOICE_MODE_SINGLE);
        dynamic2.setAdapter(adapter2);

        dynamic.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View itemClicked, int position, long id) {
//                Toast.makeText(getApplicationContext(), ((TextView) itemClicked).getText()+" - "+Integer.toString(position),Toast.LENGTH_SHORT).show();
                int IndexPlace = MainActivity.places_name.indexOf(((TextView) itemClicked).getText());
                if (IndexPlace>-1){
                    NodeList placeNode = MainActivity.places.get(IndexPlace).getChildNodes();
                    r_cod_place = MainActivity.GetValueNode(GetNodebyNameAttribute(placeNode,"Property","name","cod"));
                    r_type_place = "0";
                    r_place = MainActivity.GetValueNode(GetNodebyNameAttribute(placeNode,"Property","name","name"));
                    cab_code = r_cod_place;
                    cab_name = r_place;
                    wplaseName.clear();
                    wplaseCode.clear();
                    Node wplaceNode = GetNodebyNameAttribute(placeNode,"Property","name","work_place").getChildNodes().item(1);
                    if (wplaceNode.hasChildNodes()) {
                        NodeList wplaceNodeL = wplaceNode.getChildNodes();
                        for(int i =0;i<wplaceNodeL.getLength();i++){
                            if (wplaceNodeL.item(i).hasAttributes()) {
                                wplaseName.add(MainActivity.GetValueNode(GetNodebyNameAttribute(wplaceNodeL.item(i).getChildNodes(), "Property", "name", "name"))+
                                        " ("+MainActivity.GetValueNode(GetNodebyNameAttribute(wplaceNodeL.item(i).getChildNodes(), "Property", "name", "work_place"))+")");
                                wplaseCode.add(MainActivity.GetValueNode(GetNodebyNameAttribute(wplaceNodeL.item(i).getChildNodes(), "Property", "name", "cod")));
                            }
                        }
                    }
                    if (dynamic2.getCheckedItemPosition() > -1) dynamic2.setItemChecked(dynamic2.getCheckedItemPosition(), false);
                    adapter2.notifyDataSetChanged();
                    //frameLayout2.setVisibility(View.VISIBLE);
                    frameLayout2_params.height = -1;
                }
            }
        });

        dynamic2.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View itemClicked, int position, long id) {
                r_cod_place = wplaseCode.get(position);
                r_type_place = "1";
                r_place = cab_name + "\\" + wplaseName.get(position);
            }
        });

        button7.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (dynamic2.getCheckedItemPosition() > -1) {
                    dynamic2.setItemChecked(dynamic2.getCheckedItemPosition(), false);
                    r_cod_place = cab_code;
                    r_type_place = "0";
                    r_place = cab_name;
                }
            }
        });

        button6.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });

        button5.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                SimpleDateFormat sdf = new SimpleDateFormat("dd.MM.yyyy HH:mm:ss");
                r_date = sdf.format(new Date());
                r_res = "Нет";
//                Toast.makeText(getApplicationContext(), "r_date - "+r_date+", r_res - "+r_res+", r_cod_place - "+r_cod_place+", r_type_place - "+r_type_place+", r_place - "+r_place+", r_equ_del - "+r_equ_del,
//                        Toast.LENGTH_SHORT).show();
                NodeList equipment_val = MainActivity.equipments.get(MainActivity.IndexEquipment).getChildNodes();
                if (r_equ_del == "Да") {
                    MainActivity.SetValueNode(MainActivity.GetNodebyNameAttribute(equipment_val,"Property","name","r_date"),r_date);
                    MainActivity.SetValueNode(MainActivity.GetNodebyNameAttribute(equipment_val,"Property","name","r_res"),r_res);
                    MainActivity.SetValueNode(MainActivity.GetNodebyNameAttribute(equipment_val,"Property","name","r_equ_del"),r_equ_del);
                }
                else {
                    MainActivity.SetValueNode(MainActivity.GetNodebyNameAttribute(equipment_val,"Property","name","r_date"),r_date);
                    MainActivity.SetValueNode(MainActivity.GetNodebyNameAttribute(equipment_val,"Property","name","r_res"),r_res);
                    MainActivity.SetValueNode(MainActivity.GetNodebyNameAttribute(equipment_val,"Property","name","r_equ_del"),r_equ_del);
                    MainActivity.SetValueNode(MainActivity.GetNodebyNameAttribute(equipment_val,"Property","name","r_cod_place"),r_cod_place);
                    MainActivity.SetValueNode(MainActivity.GetNodebyNameAttribute(equipment_val,"Property","name","r_type_place"),r_type_place);
                    MainActivity.SetValueNode(MainActivity.GetNodebyNameAttribute(equipment_val,"Property","name","r_place"),r_place);
                }
                MainActivity.FoundInfo();
                finish();
            }
        });

        editText2.addTextChangedListener(new TextWatcher() {
            @Override
            public void onTextChanged(CharSequence arg0, int arg1, int arg2, int arg3) {
                // TODO Auto-generated method stub
                //adapter.getFilter().filter(arg0);
                //if (catNames.size()>0) catNames.remove(0);
                //Log.d(TAG,arg0.toString());
                UnCheckedLV(dynamic);
                CabSourse.clear();
                for(int i = 0; i < MainActivity.places_name.size(); i++){
                    if (MainActivity.places_name.get(i).matches(".*"+arg0.toString()+".*")) CabSourse.add(MainActivity.places_name.get(i));
                    //Log.d(TAG, MainActivity.places_name.get(i)+" ["+Boolean.toString(MainActivity.places_name.get(i).matches(".*"+arg0.toString()+".*"))+"]");
                }
                adapter.notifyDataSetChanged();
            }

            @Override
            public void beforeTextChanged(CharSequence arg0, int arg1, int arg2, int arg3) {
                // TODO Auto-generated method stub

            }

            @Override
            public void afterTextChanged(Editable arg0) {
                // TODO Auto-generated method stub

            }
        });

        radioGroup.setOnCheckedChangeListener(new RadioGroup.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(RadioGroup group, int checkedId) {
                switch (checkedId) {
                    case R.id.radioButton:
                        linerLayout1.setVisibility(View.INVISIBLE);
                        r_equ_del = "Да";
                        break;
                    case R.id.radioButton2:
                        linerLayout1.setVisibility(View.VISIBLE);
                        r_equ_del = "Нет";
                        break;
                }
            }
        });

    }

    private void UnCheckedLV (ListView lv) {
        if (lv.getCheckedItemPosition() > -1) {
            lv.setItemChecked(lv.getCheckedItemPosition(), false);
            r_cod_place = "";
            r_type_place = "";
            r_place = "";
            cab_code = r_cod_place;
            cab_name = r_place;
            //frameLayout2.setVisibility(View.INVISIBLE);
            frameLayout2_params.height = 0;
            if (dynamic2.getCheckedItemPosition() > -1)
                dynamic2.setItemChecked(dynamic2.getCheckedItemPosition(), false);
        }
    }

}
