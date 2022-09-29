unit Sensors;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DB, ADODB, Choose, Buttons, Grids, DBGrids, Menus;

type
  TForm2 = class(TForm)
    Edit1: TEdit;
    Label1: TLabel;
    Edit2: TEdit;
    Label2: TLabel;
    Button1: TButton;
    Label3: TLabel;
    Edit3: TEdit;
    Label4: TLabel;
    Edit4: TEdit;
    Button2: TButton;
    Label5: TLabel;
    ComboBox1: TComboBox;
    GroupBox1: TGroupBox;
    ComboBox2: TComboBox;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    Button3: TButton;
    Button4: TButton;
    Edit5: TEdit;
    Label6: TLabel;
    Label7: TLabel;
    Edit6: TEdit;
    ADOQuery1: TADOQuery;
    SpeedButton1: TSpeedButton;
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    ADOQuery2: TADOQuery;
    ADOQuery2id: TAutoIncField;
    ADOQuery2Date: TDateField;
    ADOQuery2id_Sens: TIntegerField;
    ADOQuery2T1_I: TFloatField;
    ADOQuery2T1_Val: TFloatField;
    ADOQuery2T2_I: TFloatField;
    ADOQuery2T2_Val: TFloatField;
    ADOQuery2EnableEditAIN: TBooleanField;
    ADOQuery2F_Poverka: TBooleanField;
    CheckBox3: TCheckBox;
    Edit7: TEdit;
    Button5: TButton;
    procedure Button4Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DBGrid1KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ADOQuery2BeforePost(DataSet: TDataSet);
    procedure Button5Click(Sender: TObject);
  private
    { Private declarations }
  public
    idSens:Variant;
    id:integer;
    NameSens:string;
    TagName, id_tree, id_tagEd, TypeMeas, IDSensFiltr :String;
    Enable, Broadcast:String;
    PSens:record
      id_PSens, SensNumber, YBuild, id_typeSens:String;
    end;
    par1,par2:string;
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

uses Main, AddPSens;

{$R *.dfm}

procedure TForm2.Button4Click(Sender: TObject);
begin
  Close;
end;

procedure TForm2.FormShow(Sender: TObject);
begin
  ADOQuery2.Active:=false;
  ComboBox2.ItemIndex:=0;
  Label6.Caption:='Параметр 1';
  Label7.Caption:='Параметр 2';
  Label6.Enabled:=false;
  Label7.Enabled:=false;
  Edit5.Text:=''; Edit5.Enabled:=false;
  Edit6.Text:=''; Edit6.Enabled:=false;
  Edit7.Text:=''; Edit7.Visible:=false;
  Button5.Visible:=false;
  ComboBox1.Items.Clear;
  ComboBox1.Items.Add('');
  idSens:=null;
  TagName:='NULL';
  Psens.id_typeSens:='NULL';Psens.id_PSens:='NULL';
  DBGrid1.Enabled:=false;
  try
    ADOQuery1.Active:=false;
    ADOQuery1.SQL.Clear;
    ADOQuery1.SQL.Add('SELECT Shorten FROM Ed');
    ADOQuery1.Active:=true;
    while not(ADOQuery1.Eof) do begin
      ComboBox1.Items.Add(ADOQuery1.Fields[0].AsString);
      ADOQuery1.Next;
    end;
  except
    ADOQuery1.Destroy;
    ADOQuery1:=TADOQuery.Create(self);
    ADOQuery1.ConnectionString:=Form1.ConStr;
  end;
  ComboBox1.ItemIndex:=0;
  Edit1.Text:='';
  Edit2.Text:='';
  Edit3.Text:='';
  Edit4.Text:='';
  Label3.Caption:=Form1.SQLvsTree[id].Tree.Text;
  id_tree:=inttostr(Form1.SQLvsTree[id].SQL);
  CheckBox1.Checked:=true;
  CheckBox2.Checked:=true;
  if NameSens<>'' then begin
    try
      ADOQuery1.Active:=false;
      ADOQuery1.SQL.Clear;
      ADOQuery1.SQL.Add('SELECT Sensors.id,Sensors.Name,TagName,Physical_Sensor.id_typeSens,Sensors.id_tree,id_tagEd,Physical_Sensor.NumberSens,[Enable]'+
                        ',TypeMeas,[Status],Broadcast,TypeSens.Name, NotConnectVisibl, Physical_Sensor.id FROM Sensors,Physical_Sensor,TypeSens'+
                        ' where id_tree = '+id_tree+' and Sensors.Name = '+chr(39)+NameSens+chr(39)+
                        ' and TypeSens.id=Physical_Sensor.id_typeSens and Physical_Sensor.id=Sensors.id_PSens');
      ADOQuery1.Active:=true;
      idSens:=ADOQuery1.Fields[0].AsInteger;
      PSens.id_PSens:=ADOQuery1.Fields[13].AsString;
      Edit1.Text:=ADOQuery1.Fields[1].AsString;
      Edit2.Text:=ADOQuery1.Fields[11].AsString;
      Edit3.Text:=ADOQuery1.Fields[6].AsString;
      CheckBox1.Checked:=ADOQuery1.Fields[7].AsBoolean;
      CheckBox2.Checked:=ADOQuery1.Fields[10].AsBoolean;
      CheckBox3.Checked:=ADOQuery1.Fields[12].AsBoolean;
      ComboBox2.ItemIndex:=ADOQuery1.Fields[8].AsInteger;
      ComboBox2Change(self);
      ComboBox1.ItemIndex:=ADOQuery1.Fields[5].AsInteger;
      PSens.id_typeSens:=ADOQuery1.Fields[3].AsString;
      if ADOQuery1.Fields[2].AsVariant<>null then begin Edit4.Text:=ADOQuery1.Fields[2].AsString; TagName:= ADOQuery1.Fields[2].AsString; end;
    except
      ADOQuery1.Destroy;
      ADOQuery1:=TADOQuery.Create(self);
      ADOQuery1.ConnectionString:=Form1.ConStr;
    end;
    if (ComboBox2.ItemIndex<>0) and (ComboBox2.ItemIndex<>4) then begin
      try
        ADOQuery1.Active:=false;
        ADOQuery1.SQL.Clear;
        if ComboBox2.ItemIndex=1 then ADOQuery1.SQL.Add('SELECT error_time_limit FROM Measure_Status where ID='+VarToStr(idSens));
        if ComboBox2.ItemIndex=2 then ADOQuery1.SQL.Add('SELECT ok_din_status FROM Measure_DIN where ID='+VarToStr(idSens));
        if ComboBox2.ItemIndex=3 then ADOQuery1.SQL.Add('SELECT min_below_zero_limit ,max_below_zero_limit FROM Measure_AIN where ID='+VarToStr(idSens));
        if ComboBox2.ItemIndex=5 then ADOQuery1.SQL.Add('SELECT Period FROM Measure_Period where ID='+VarToStr(idSens));
        if ComboBox2.ItemIndex=6 then ADOQuery1.SQL.Add('SELECT error_time_limit FROM Measure_Status where ID='+VarToStr(idSens));
        if ComboBox2.ItemIndex=8 then ADOQuery1.SQL.Add('SELECT [min_below_zero_limit],[max_below_zero_limit],(select Name from sensors where id=Measure_FILTR.SensID),Measure_FILTR.SensID '+
                                                        ' FROM Measure_AIN, Measure_FILTR where Measure_AIN.id = Measure_FILTR.id and Measure_AIN.id='+VarToStr(idSens));
        ADOQuery1.Active:=true;
        if ComboBox2.ItemIndex=1 then Edit5.Text:=ADOQuery1.Fields[0].AsString;
        if ComboBox2.ItemIndex=2 then Edit5.Text:=ADOQuery1.Fields[0].AsString;
        if ComboBox2.ItemIndex=3 then begin Edit5.Text:=ADOQuery1.Fields[0].AsString; Edit6.Text:=ADOQuery1.Fields[1].AsString; end;
        if ComboBox2.ItemIndex=5 then Edit5.Text:=ADOQuery1.Fields[0].AsString;
        if ComboBox2.ItemIndex=6 then Edit5.Text:=ADOQuery1.Fields[0].AsString;
        if ComboBox2.ItemIndex=8 then begin Edit5.Text:=ADOQuery1.Fields[0].AsString; Edit6.Text:=ADOQuery1.Fields[1].AsString; Edit7.Text:=ADOQuery1.Fields[2].AsString; IDSensFiltr:=ADOQuery1.Fields[3].AsString; end;
      except
        ADOQuery1.Destroy;
        ADOQuery1:=TADOQuery.Create(self);
        ADOQuery1.ConnectionString:=Form1.ConStr;
      end;
    end;
    try
      ADOQuery2.Active:=false;
      ADOQuery2.SQL.Clear;
      ADOQuery2.SQL.Add( 'SELECT id, Date, id_PSens, T1_I, T1_Val, T2_I, T2_Val, EnableEditAIN,F_Poverka FROM Poverka '+
                         'where id_PSens = '+PSens.id_PSens+
                         ' order by Date');
      ADOQuery2.Active:=true;
      DBGrid1.Enabled:=true;
      except
        ADOQuery2.Destroy;
        ADOQuery2:=TADOQuery.Create(self);
        ADOQuery2.ConnectionString:=Form1.ConStr;
      end;
  end;
end;

procedure TForm2.ComboBox2Change(Sender: TObject);
begin
  Edit7.Visible:=false;
  Button5.Visible:=false;
  if (ComboBox2.ItemIndex=0) or (ComboBox2.ItemIndex=4) or (ComboBox2.ItemIndex=7) then begin
    Label6.Caption:='Параметр 1';
    Label7.Caption:='Параметр 2';
    Label6.Enabled:=false;
    Label7.Enabled:=false;
    Edit5.Text:=''; Edit5.Enabled:=false;
    Edit6.Text:=''; Edit6.Enabled:=false;
  end;
  if ComboBox2.ItemIndex=1 then begin
    Label6.Caption:='Лимит опроса объекта (мин)';
    Label7.Caption:='Параметр 2';
    Label6.Enabled:=true;
    Label7.Enabled:=false;
    Edit5.Text:=''; Edit5.Enabled:=true;
    Edit6.Text:=''; Edit6.Enabled:=false;
  end;
  if ComboBox2.ItemIndex=2 then begin
    Label6.Caption:='Нормальное состоятие дат. (Bool)';
    Label7.Caption:='Параметр 2';
    Label6.Enabled:=true;
    Label7.Enabled:=false;
    Edit5.Text:=''; Edit5.Enabled:=true;
    Edit6.Text:=''; Edit6.Enabled:=false;
  end;
  if ComboBox2.ItemIndex=3 then begin
    Label6.Caption:='Допуск нижней границы (%)';
    Label7.Caption:='Допуск верхней границы (%)';
    Label6.Enabled:=true;
    Label7.Enabled:=true;
    Edit5.Text:=''; Edit5.Enabled:=true;
    Edit6.Text:=''; Edit6.Enabled:=true;
  end;
  if ComboBox2.ItemIndex=5 then begin
    Label6.Caption:='Интервал цикла опроса (мин)';
    Label7.Caption:='Параметр 2';
    Label6.Enabled:=true;
    Label7.Enabled:=false;
    Edit5.Text:=''; Edit5.Enabled:=true;
    Edit6.Text:=''; Edit6.Enabled:=false;
  end;
  if ComboBox2.ItemIndex=6 then begin
    Label6.Caption:='Лимит опроса объекта (мин)';
    Label7.Caption:='Параметр 2';
    Label6.Enabled:=true;
    Label7.Enabled:=false;
    Edit5.Text:=''; Edit5.Enabled:=true;
    Edit6.Text:=''; Edit6.Enabled:=false;
  end;
  if ComboBox2.ItemIndex=8 then begin
    Edit7.Visible:=true;
    Button5.Visible:=true;
    Label6.Caption:='Допуск нижней границы (%)';
    Label7.Caption:='Допуск верхней границы (%)';
    Label6.Enabled:=true;
    Label7.Enabled:=true;
    Edit5.Text:=''; Edit5.Enabled:=true;
    Edit6.Text:=''; Edit6.Enabled:=true;
  end;
end;

procedure TForm2.Button3Click(Sender: TObject);
var valtag:string;
    Ftest:Double;
    stop,DeletePSens:boolean;
    TypeSens:integer;
    f1,f2:string;
    p1,p2:integer;
begin
  stop:=false;
  DeletePSens:=false;
  NameSens:=Chr(39)+Edit1.Text+Chr(39);
  if ComboBox1.ItemIndex=0 then id_tagEd:='NULL' else id_tagEd:=inttostr(ComboBox1.ItemIndex);
  TypeMeas:=inttostr(ComboBox2.ItemIndex);
  try
    Enable:=booltostr(CheckBox1.Checked);
    Broadcast:=booltostr(CheckBox2.Checked);
    par1:=Edit5.Text; par2:=Edit6.Text;
    if (ComboBox2.ItemIndex=1) or
       (ComboBox2.ItemIndex=2) or
       (ComboBox2.ItemIndex=3) or
       (ComboBox2.ItemIndex=5)
    then Ftest:=StrToFloat(par1);
    if ComboBox2.ItemIndex=3
    then Ftest:=StrToFloat(par2);
  except
    stop:=true;
  end;
 if (Psens.id_typeSens='NULL') and (Psens.id_PSens='NULL') then stop:=true;
 if not(stop) then begin
  if Psens.id_PSens='NULL' then begin
    try
      ADOQuery1.Active:=false;
      ADOQuery1.SQL.Clear;
      ADOQuery1.SQL.Add('insert into Physical_Sensor (id_typeSens, NumberSens, BuildDate) values '+
                        '('+Psens.id_typeSens+', '+chr(39)+Psens.SensNumber+chr(39)+', '+chr(39)+Psens.YBuild+chr(39)+')');
      ADOQuery1.ExecSQL;

      ADOQuery1.Active:=false;
      ADOQuery1.SQL.Clear;
      ADOQuery1.SQL.Add('select IDENT_CURRENT('+chr(39)+'Physical_Sensor'+chr(39)+')');
      ADOQuery1.Active:=True;
      Psens.id_PSens:=ADOQuery1.Fields[0].AsString;
    except
      ADOQuery1.Destroy;
      ADOQuery1:=TADOQuery.Create(self);
      ADOQuery1.ConnectionString:=Form1.ConStr;
    end;
  end;
  if idSens=Null then begin
    try
      ADOQuery1.Active:=false;
      ADOQuery1.SQL.Clear;
      ADOQuery1.SQL.Add('insert into Sensors (Name, TagName, id_tagEd, Enable, TypeMeas, Broadcast, id_tree, NotConnectVisibl, id_PSens) values '+
                        '('+NameSens+', '+chr(39)+TagName+chr(39)+', '+id_tagEd+', '+Enable+', '+TypeMeas+', '+Broadcast+', '+id_tree+', '+BoolToStr(CheckBox3.Checked)+', '+Psens.id_PSens+')');
      ADOQuery1.ExecSQL;

      ADOQuery1.Active:=false;
      ADOQuery1.SQL.Clear;
      ADOQuery1.SQL.Add('select id from Sensors where Name = '+NameSens+' and id_tree = '+ id_tree);
      ADOQuery1.Active:=true;
      idSens:=ADOQuery1.Fields[0].AsInteger;

      ADOQuery1.Active:=false;
      ADOQuery1.SQL.Clear;

      if ComboBox2.ItemIndex=1 then ADOQuery1.SQL.Add('insert into Measure_Status(id,error_time_limit) VALUES ('+VarToStr(idSens)+ ','+par1+')');
      if ComboBox2.ItemIndex=2 then ADOQuery1.SQL.Add('insert into Measure_DIN(id,ok_din_status) VALUES ('+VarToStr(idSens)+ ','+par1+')');
      if ComboBox2.ItemIndex=3 then ADOQuery1.SQL.Add('insert into Measure_AIN(id, min_below_zero_limit,max_below_zero_limit) VALUES ('+VarToStr(idSens)+','+par1+','+par2+')');
      if ComboBox2.ItemIndex=5 then ADOQuery1.SQL.Add('insert into Measure_Period (id,Period,LastUpdate) VALUES ('+VarToStr(idSens)+ ','+par1+',getdate())');
      if ComboBox2.ItemIndex=6 then ADOQuery1.SQL.Add('insert into Measure_Status(id,error_time_limit) VALUES ('+VarToStr(idSens)+ ','+par1+')');
      if ComboBox2.ItemIndex=8 then begin ADOQuery1.SQL.Add('insert into Measure_AIN(id, min_below_zero_limit,max_below_zero_limit) VALUES ('+VarToStr(idSens)+','+par1+','+par2+')');
                                          ADOQuery1.SQL.Add('insert into Measure_FILTR (id, SensID) VALUES ('+VarToStr(idSens)+','+IDSensFiltr+')');
                                    end;
      if ADOQuery1.SQL.text<>'' then ADOQuery1.ExecSQL;

      ADOQuery1.Active:=false;
      ADOQuery1.SQL.Clear;
      ADOQuery1.SQL.Add('DECLARE @idSens int, @TN varchar(512), @TV varchar(256), @TS datetime '+
                        'DECLARE @NewValue varchar(256), @Status int '+
                        'SET @idSens = '+VarToStr(idSens)+' '+
                        'select top 1 @TN = TagName, @TV = [Value],  @TS = TagTimeStamp from [dbo].[BufferVectorTag] '+
                        'where TagName = (select top 1 TagName from [dbo].[Sensors] where id = @idSens) '+
                        'exec [GetAndSetSensorValueAndStatus] @TN, @TV, @TS, @idSens, @NewValue OUTPUT, @Status OUTPUT');
      ADOQuery1.ExecSQL;

    except
      ADOQuery1.Destroy;
      ADOQuery1:=TADOQuery.Create(self);
      ADOQuery1.ConnectionString:=Form1.ConStr;
    end;
  end else begin
    try
      ADOQuery1.Active:=false;
      ADOQuery1.SQL.Clear;
      ADOQuery1.SQL.Add('select TypeMeas from Sensors where id = '+VarToStr(idSens));
      ADOQuery1.Active:=true;
      TypeSens:=ADOQuery1.Fields[0].AsInteger;

      ADOQuery1.Active:=false;
      ADOQuery1.SQL.Clear;
      ADOQuery1.SQL.Add('update Sensors set Name = '+NameSens+', TagName = '+chr(39)+TagName+chr(39)+',id_tagEd = '+id_tagEd+',Enable = '+Enable+
                        ',TypeMeas = '+TypeMeas+',Broadcast = '+Broadcast+',NotConnectVisibl = '+BoolToStr(CheckBox3.Checked)+
                        ',id_PSens = '+Psens.id_PSens+
                        ' where id = '+VarToStr(idSens));
      ADOQuery1.ExecSQL;
      ADOQuery1.SQL.Clear;
      if TypeSens=ComboBox2.ItemIndex then begin
        if ComboBox2.ItemIndex=1 then ADOQuery1.SQL.Add('update Measure_Status set error_time_limit = '+par1+' where ID='+VarToStr(idSens));
        if ComboBox2.ItemIndex=2 then ADOQuery1.SQL.Add('update Measure_DIN set ok_din_status = '+par1+' where ID='+VarToStr(idSens));
        if ComboBox2.ItemIndex=3 then ADOQuery1.SQL.Add('update Measure_AIN set min_below_zero_limit = '+par1+' ,max_below_zero_limit = '+par2+' where ID='+VarToStr(idSens));
        if ComboBox2.ItemIndex=5 then ADOQuery1.SQL.Add('update Measure_Period set Period = '+par1+',LastUpdate = getdate() where ID='+VarToStr(idSens));
        if ComboBox2.ItemIndex=6 then ADOQuery1.SQL.Add('update Measure_Status set error_time_limit = '+par1+' where ID='+VarToStr(idSens));
        if ComboBox2.ItemIndex=8 then begin ADOQuery1.SQL.Add('update Measure_AIN set min_below_zero_limit = '+par1+' ,max_below_zero_limit = '+par2+' where ID='+VarToStr(idSens));
                                            ADOQuery1.SQL.Add('update Measure_FILTR set SensID = '+IDSensFiltr+' where ID='+VarToStr(idSens));
                                      end;
        if ADOQuery1.SQL.text<>'' then ADOQuery1.ExecSQL;
      end else begin
        if TypeSens=1 then ADOQuery1.SQL.Add('delete Measure_Status where id='+VarToStr(idSens));
        if TypeSens=2 then ADOQuery1.SQL.Add('delete Measure_DIN where id='+VarToStr(idSens));
        if TypeSens=3 then ADOQuery1.SQL.Add('delete Measure_AIN where id='+VarToStr(idSens));
        if TypeSens=5 then ADOQuery1.SQL.Add('delete Measure_Period  where id='+VarToStr(idSens));
        if TypeSens=6 then ADOQuery1.SQL.Add('delete Measure_Status where id='+VarToStr(idSens));
        if TypeSens=8 then begin ADOQuery1.SQL.Add('delete Measure_AIN where id='+VarToStr(idSens));
                                 ADOQuery1.SQL.Add('delete Measure_FILTR where id='+VarToStr(idSens));
                           end;
        if ComboBox2.ItemIndex=1 then ADOQuery1.SQL.Add('insert into Measure_Status(id,error_time_limit) VALUES ('+VarToStr(idSens)+ ','+par1+')');
        if ComboBox2.ItemIndex=2 then ADOQuery1.SQL.Add('insert into Measure_DIN(id,ok_din_status) VALUES ('+VarToStr(idSens)+ ','+par1+')');
        if ComboBox2.ItemIndex=3 then ADOQuery1.SQL.Add('insert into Measure_AIN(id, min_below_zero_limit,max_below_zero_limit,NewVal) VALUES ('+VarToStr(idSens)+','+par1+','+par2+',0)');
        if ComboBox2.ItemIndex=5 then ADOQuery1.SQL.Add('insert into Measure_Period (id,Period,LastUpdate)  VALUES ('+VarToStr(idSens)+ ','+par1+',getdate())');
        if ComboBox2.ItemIndex=6 then ADOQuery1.SQL.Add('insert into Measure_Status(id,error_time_limit) VALUES ('+VarToStr(idSens)+ ','+par1+')');
        if ComboBox2.ItemIndex=8 then begin ADOQuery1.SQL.Add('insert into Measure_AIN(id, min_below_zero_limit,max_below_zero_limit,NewVal) VALUES ('+VarToStr(idSens)+','+par1+','+par2+',0)');
                                            ADOQuery1.SQL.Add('insert into Measure_FILTR (id, SensID) VALUES ('+VarToStr(idSens)+','+IDSensFiltr+')');
                                      end;
        if ADOQuery1.SQL.text<>'' then ADOQuery1.ExecSQL;

      end;

      ADOQuery1.Active:=false;
      ADOQuery1.SQL.Clear;
      ADOQuery1.SQL.Add('DECLARE @idSens int, @TN varchar(512), @TV varchar(256), @TS datetime '+
                        'DECLARE @NewValue varchar(256), @Status int '+
                        'SET @idSens = '+VarToStr(idSens)+' '+
                        'select top 1 @TN = TagName, @TV = TagValue,  @TS = TagTimeStamp from [dbo].[Sensors] '+
                        'where id = @idSens '+
                        'exec [GetAndSetSensorValueAndStatus] @TN, @TV, @TS, @idSens, @NewValue OUTPUT, @Status OUTPUT');
      ADOQuery1.ExecSQL;

    except
      ADOQuery1.Destroy;
      ADOQuery1:=TADOQuery.Create(self);
      ADOQuery1.ConnectionString:=Form1.ConStr;
    end;
  end;
  Form2.Close;
 end else ShowMessage('Ошибка преобразования типа'+#10+#13+'или'+#10+#13+'Введены не все данные');
end;

procedure TForm2.Button1Click(Sender: TObject);
begin
  Form5.Left:=Form2.Left;
  Form5.Top:=Form2.Top;
  Form5.ShowModal;
end;

procedure TForm2.Button2Click(Sender: TObject);
begin
  Form3.Caption:='Поиск тегов';
  Form3.sqltext:='SELECT TagName,Value,NULL FROM BufferVectorTag';
  Form3.Left:=Form2.Left;
  Form3.Top:=Form2.Top;
  Form3.ListView1.Columns[0].Caption:='Имя';
  Form3.ListView1.Columns[1].Caption:='Значение';
  Form3.ShowModal;
end;

procedure TForm2.SpeedButton1Click(Sender: TObject);
begin
  TagName:='NULL';id_tagEd:='NULL';Edit4.Text:='';ComboBox1.ItemIndex:=0;
end;

procedure TForm2.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ADOQuery2.Active:=false;
end;

procedure TForm2.DBGrid1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key=46 then ADOQuery2.Delete;
end;

procedure TForm2.ADOQuery2BeforePost(DataSet: TDataSet);
var a:integer;
begin
  ADOQuery2id_Sens.AsInteger:=StrToInt(PSens.id_PSens);
end;

procedure TForm2.Button5Click(Sender: TObject);
begin
  Form3.Caption:='Поиск тегов исходные данные для фильтра';
  Form3.sqltext:='SELECT Name,TagName,id FROM Sensors where id_tree='+id_tree;
  Form3.Left:=Form2.Left;
  Form3.Top:=Form2.Top;
  Form3.ListView1.Columns[0].Caption:='Имя';
  Form3.ListView1.Columns[1].Caption:='Значение';
  Form3.ShowModal;
end;

end.
