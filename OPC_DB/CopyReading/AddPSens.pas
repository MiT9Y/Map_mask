unit AddPSens;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Menus, DB, ADODB;

type
  TForm5 = class(TForm)
    GroupBox1: TGroupBox;
    ListView1: TListView;
    Edit1: TEdit;
    Button1: TButton;
    Edit2: TEdit;
    Label1: TLabel;
    GroupBox2: TGroupBox;
    ListView2: TListView;
    Button3: TButton;
    Button4: TButton;
    CheckBox1: TCheckBox;
    Label2: TLabel;
    Edit3: TEdit;
    CheckBox2: TCheckBox;
    Label3: TLabel;
    Label4: TLabel;
    Edit4: TEdit;
    Button2: TButton;
    Edit5: TEdit;
    Button5: TButton;
    ADOQuery1: TADOQuery;
    GroupBox3: TGroupBox;
    CheckBox3: TCheckBox;
    Label5: TLabel;
    Edit6: TEdit;
    Label6: TLabel;
    Edit7: TEdit;
    procedure GroupBox2MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure GroupBox1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure GroupBox3MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form5: TForm5;

implementation

uses Main, Sensors;

{$R *.dfm}

procedure TForm5.GroupBox2MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  CheckBox1.Checked:=false;CheckBox2.Checked:=true;CheckBox3.Checked:=false;
end;

procedure TForm5.GroupBox1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  CheckBox1.Checked:=true;CheckBox2.Checked:=false;CheckBox3.Checked:=false;
end;

procedure TForm5.FormShow(Sender: TObject);
begin
  Form2.Psens.id_typeSens:='NULL';{Form2.Psens.id_PSens:='NULL';}
  Edit5.Text:='%'+Form1.GetFullNameTree(Form1.SQLvsTree[Form1.FoundIDonNode(Form1.TreeView1.Selected)].Tree)+'%';
  ListView1.Items.Clear;
  ListView2.Items.Clear;
  Edit1.Text:='%';Edit2.Text:='';
  Edit3.Text:='';Edit4.Text:='%';
  Edit6.Text:='';Edit7.Text:='';
  if Form2.PSens.id_PSens = 'NULL' then begin
    GroupBox3.Enabled:=false;
    CheckBox1.Checked:=true;
    CheckBox3.Checked:=false;
    CheckBox3.Visible:=false;
    label5.Enabled:=false; label6.Enabled:=false;
    Edit1.SetFocus;
  end else begin
    GroupBox3.Enabled:=true;
    CheckBox1.Checked:=false;
    CheckBox3.Checked:=true;
    CheckBox3.Visible:=true;
    label5.Enabled:=true; label6.Enabled:=true;
    Edit6.SetFocus;
    try
      ADOQuery1.Active:=false;
      ADOQuery1.SQL.Clear;
      ADOQuery1.SQL.Add('select NumberSens, BuildDate from Physical_Sensor where id='+Form2.PSens.id_PSens);
      ADOQuery1.Active:=true;
      Edit6.Text:=ADOQuery1.Fields[0].AsString;
      Edit7.Text:=ADOQuery1.Fields[1].AsString;
    except
      ADOQuery1.Destroy;
      ADOQuery1:=TADOQuery.Create(self);
      ADOQuery1.ConnectionString:=Form1.ConStr;
    end;
  end;

end;

procedure TForm5.Button3Click(Sender: TObject);
begin
  //inttostr(Form2.idSensP);-- Датчик для редактирования
end;

procedure TForm5.Button1Click(Sender: TObject);
var i:integer;
begin
  try
    ADOQuery1.Active:=false;
    ADOQuery1.SQL.Clear;
    ADOQuery1.SQL.Add('SELECT TypeSens.id,TypeSens.Name, Shorten FROM TypeSens LEFT OUTER JOIN Ed on Ed.id=TypeSens.Ed where TypeSens.Name like '+chr(39)+Edit1.Text+chr(39));
    ADOQuery1.Active:=true;
    ListView1.Items.Clear;
    i:=0;
    while not(ADOQuery1.Eof) do begin
      ListView1.Items.Add;
      ListView1.Items[i].Caption:=ADOQuery1.Fields[1].AsString;
      ListView1.Items[i].SubItems.Add(ADOQuery1.Fields[2].AsString);
      ListView1.Items[i].SubItems.Add(ADOQuery1.Fields[0].AsString);
      i:=i+1;
      ADOQuery1.Next;
    end;
  except
    ADOQuery1.Destroy;
    ADOQuery1:=TADOQuery.Create(self);
    ADOQuery1.ConnectionString:=Form1.ConStr;
  end;
end;

procedure TForm5.Button2Click(Sender: TObject);
var i:integer;
begin
  try
    ADOQuery1.Active:=false;
    ADOQuery1.SQL.Clear;
    ADOQuery1.SQL.Add('select Physical_Sensor.id, Physical_Sensor.NumberSens, '+
                      '(select top 1 Name from TypeSens where Physical_Sensor.id_typeSens=TypeSens.id), '+
                      '(select top 1 Shorten from Ed, TypeSens  where Ed.id=TypeSens.Ed and Physical_Sensor.id_typeSens=TypeSens.id), '+
                      '(select top 1 Name from TreeObj where TreeObj.id=Physical_Sensor.id_treeobj), '+
                      '(select top 1 Name from Sensors where Sensors.id_PSens=Physical_Sensor.id), '+
                      'Physical_Sensor.id_typeSens '+
                      'from Physical_Sensor '+
                      'where Physical_Sensor.NumberSens like '+chr(39)+Edit4.Text+chr(39));
    ADOQuery1.Active:=true;
    ListView2.Items.Clear;
    i:=0;
    while not(ADOQuery1.Eof) do begin
      ListView2.Items.Add;
      ListView2.Items[i].Caption:=ADOQuery1.Fields[1].AsString;
      ListView2.Items[i].SubItems.Add(ADOQuery1.Fields[2].AsString);
      ListView2.Items[i].SubItems.Add(ADOQuery1.Fields[3].AsString);
      ListView2.Items[i].SubItems.Add(ADOQuery1.Fields[4].AsString);
      ListView2.Items[i].SubItems.Add(ADOQuery1.Fields[5].AsString);
      ListView2.Items[i].SubItems.Add(ADOQuery1.Fields[0].AsString);
      ListView2.Items[i].SubItems.Add(ADOQuery1.Fields[6].AsString);
      i:=i+1;
      ADOQuery1.Next;
    end;
  except
    ADOQuery1.Destroy;
    ADOQuery1:=TADOQuery.Create(self);
    ADOQuery1.ConnectionString:=Form1.ConStr;
  end;
end;

procedure TForm5.Button5Click(Sender: TObject);
var i:integer;
begin
  try
    ADOQuery1.Active:=false;
    ADOQuery1.SQL.Clear;
    ADOQuery1.SQL.Add('select Physical_Sensor.id, Physical_Sensor.NumberSens, '+
              	      '(select top 1 Name from TypeSens where Physical_Sensor.id_typeSens=TypeSens.id), '+
                      '(select top 1 Shorten from Ed, TypeSens  where Ed.id=TypeSens.Ed and Physical_Sensor.id_typeSens=TypeSens.id), '+
	                    'TreeObj.Name, (select top 1 Name from Sensors where Sensors.id_PSens=Physical_Sensor.id), '+
                      'Physical_Sensor.id_typeSens '+
                      'from Physical_Sensor,TreeObj,Sensors '+
                      'where Sensors.[id_PSens] = Physical_Sensor.id and TreeObj.id=Sensors.[id_tree] and TreeObj.Name like'+chr(39)+Edit5.Text+chr(39));
    ADOQuery1.Active:=true;
    ListView2.Items.Clear;
    i:=0;
    while not(ADOQuery1.Eof) do begin
      ListView2.Items.Add;
      ListView2.Items[i].Caption:=ADOQuery1.Fields[1].AsString;
      ListView2.Items[i].SubItems.Add(ADOQuery1.Fields[2].AsString);
      ListView2.Items[i].SubItems.Add(ADOQuery1.Fields[3].AsString);
      ListView2.Items[i].SubItems.Add(ADOQuery1.Fields[4].AsString);
      ListView2.Items[i].SubItems.Add(ADOQuery1.Fields[5].AsString);
      ListView2.Items[i].SubItems.Add(ADOQuery1.Fields[0].AsString);
      ListView2.Items[i].SubItems.Add(ADOQuery1.Fields[6].AsString);
      i:=i+1;
      ADOQuery1.Next;
    end;
  except
    ADOQuery1.Destroy;
    ADOQuery1:=TADOQuery.Create(self);
    ADOQuery1.ConnectionString:=Form1.ConStr;
  end;
end;

procedure TForm5.GroupBox3MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  CheckBox1.Checked:=false;CheckBox2.Checked:=false;CheckBox3.Checked:=true;
end;

procedure TForm5.Button4Click(Sender: TObject);
begin
  if CheckBox3.Checked then begin
    try
      ADOQuery1.Active:=false;
      ADOQuery1.SQL.Clear;
      ADOQuery1.SQL.Add('UPDATE Physical_Sensor set NumberSens = '+chr(39)+Edit6.Text+chr(39)+', BuildDate = '+chr(39)+Edit7.Text+chr(39)+
                        ' where id='+Form2.PSens.id_PSens);
      ADOQuery1.ExecSQL;
      Form2.Edit3.Text:=Edit6.Text;
      Form5.Close;
    except
      ADOQuery1.Destroy;
      ADOQuery1:=TADOQuery.Create(self);
      ADOQuery1.ConnectionString:=Form1.ConStr;
    end;
  end;
  if CheckBox1.Checked then begin
    if ListView1.ItemFocused<>nil then begin
      form2.PSens.id_typeSens:=ListView1.ItemFocused.SubItems[1];
      form2.PSens.id_PSens:='NULL';
      form2.PSens.SensNumber:=Edit3.Text; form2.PSens.YBuild:=Edit2.Text;
      Form2.Edit2.Text:=ListView1.ItemFocused.Caption;
      Form2.Edit3.Text:=Edit3.Text;
      Form5.Close;
    end;
  end;
  if CheckBox2.Checked then begin
    if ListView2.ItemFocused<>nil then begin
      form2.PSens.id_PSens:=ListView2.ItemFocused.SubItems[4];
      Form2.Edit3.Text:=ListView2.ItemFocused.Caption;
      Form2.Edit2.Text:=ListView2.ItemFocused.SubItems[0];
      Form5.Close;
    end;
  end;
end;

end.
