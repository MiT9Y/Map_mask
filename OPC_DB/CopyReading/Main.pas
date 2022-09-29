unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ImgList, Menus, StdCtrls, DB, ADODB, ExtCtrls, OpcServerUnit,Sensors,
  frxClass, frxDBSet, frxRich, frxExportPDF, frxExportBIFF;

type
  TForm1 = class(TForm)
    TreeView1: TTreeView;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    ImageList1: TImageList;
    N5: TMenuItem;
    ADOQuery1: TADOQuery;
    ListView1: TListView;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Timer1: TTimer;
    ADOQueryTimer1: TADOQuery;
    ADOQueryOPC: TADOQuery;
    ADOQuery2: TADOQuery;
    Button1: TButton;
    Button2: TButton;
    Memo1: TMemo;
    Button3: TButton;
    Label1: TLabel;
    PopupMenu2: TPopupMenu;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    CheckBox1: TCheckBox;
    Edit1: TEdit;
    Label2: TLabel;
    N10: TMenuItem;
    N11: TMenuItem;
    N12: TMenuItem;
    N15: TMenuItem;
    frxReport1: TfrxReport;
    N14: TMenuItem;
    frxDBDataset1: TfrxDBDataset;
    ADOQuery3: TADOQuery;
    frxDBDataset2: TfrxDBDataset;
    ADOQuery4: TADOQuery;
    N13: TMenuItem;
    N16: TMenuItem;
    frxBIFFExport1: TfrxBIFFExport;
    frxPDFExport1: TfrxPDFExport;
    procedure FormCreate(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TreeView1Change(Sender: TObject; Node: TTreeNode);
    procedure Timer1Timer(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure PopupMenu2Popup(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure N10Click(Sender: TObject);
    procedure N9Click(Sender: TObject);
    procedure N11Click(Sender: TObject);
    procedure N12Click(Sender: TObject);
    procedure ADOQuery3AfterScroll(DataSet: TDataSet);
    procedure N16Click(Sender: TObject);
  private
    { Private declarations }
  public
    UserID:Integer;
    ConStr:String;
    RunForm4:boolean;
    TimeEnable:boolean;
    OPCTags: array of record
                        i,j:integer;
                        Name:string;
                      end;
    SQLvsTree: array of record
                          SQL:integer;
                          Tree:TTreeNode;
                          statusObj:string;
                          Name:string;
                          location:string;
                          Sensors: array of record
                                             Name,NumberSens:string;
                                             TagValue,OPCValue:Variant;
                                             TagEd,OPCEd:string;
                                             EnableFlag:boolean;
                                             Img:integer;
                                             TypeMes:integer;
                                             Broadcast:boolean;
                                             id_rwtag:integer;
                                             id_sens:integer;
                                             TagName, TypeSens:string;
                                             NotConnectVisibl:boolean;
                                             TagTimeStamp:string;
                                           end;
                        end;
    procedure LoadTree(WithStatusObj:boolean);
    function GetFullNameTree(Node:TTreeNode):String;
    procedure SetStatusObject(idV:Variant);
    function FoundIDonNode(Node:TTreeNode):integer;
    function FoundIDonSQL(SQL:integer):integer;
    function FoundSensonName(tree:integer; SName:String):integer;
    function StrToFloatSafe(const aStr : String) : Double;
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses Choose, CopyObj, AddPSens, ArchiveObj, UserAccess;

{$R *.dfm}

function TForm1.StrToFloatSafe(const aStr : String) : Double;
const
  //Множество возможных разделителей целой и дробной части в записи числа.
  D = ['.', ','];
var
  S : String;
  i : Integer;
begin
  S := aStr;
  for i := 1 to Length(S) do
    if S[i] in D then begin
      S[i] := DecimalSeparator;
      Break;
    end;
  Result := StrToFloat(S);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Form1.Top:=0;
  Form1.Left:=0;
  UserID:=-1;
end;

procedure TForm1.N2Click(Sender: TObject);
var v:string;
begin
  if (TreeView1.Selected<>nil) then
    if (TreeView1.Selected.ImageIndex=0) then begin
      if InputQuery('Input text','Введите имя узла',v) then
        TreeView1.Items.AddChild(TreeView1.Selected,v);
    end else ShowMessage('У Объекта не может быть потомков');
end;

procedure TForm1.N5Click(Sender: TObject);
var v:string;
begin
  if InputQuery('Input text','Введите имя узла',v) then
    TreeView1.Items.AddChild(nil,v);
end;

procedure TForm1.N1Click(Sender: TObject);
var v,l:string;
    ThisItem:TTreeNode;
begin
  ThisItem:=nil;
  l:='';
  if (TreeView1.Selected<>nil) then
    if TreeView1.Selected.ImageIndex=0 then begin
      if InputQuery('Input text','Введите имя объекта',v) then
         begin
           InputQuery('Input text','Введите локацию объекта',l);
           try
             ADOQuery1.Active:=false;
             ADOQuery1.SQL.Clear;
             ADOQuery1.SQL.Add('insert into TreeObj (Name,Location) values ('+chr(39)+GetFullNameTree(TreeView1.Selected)+'.'+v+chr(39)+', '+chr(39)+l+chr(39)+')');
             ADOQuery1.ExecSQL;
             if Timer1.Enabled then LoadTree(true) else LoadTree(false);
           except
             ThisItem.Delete;
             ADOQuery1.Destroy;
             ADOQuery1:=TADOQuery.Create(self);
             ADOQuery1.ConnectionString:=ConStr;
           end;
        end;
    end else ShowMessage('У Объекта не может быть потомков');
end;

procedure TForm1.N3Click(Sender: TObject);
var v,l:string;
    err:boolean;
    OldText,OldName:string;
    id:integer;

procedure UpdateTree(Node:TTreeNode);
var aNode:TTreeNode;
    st:string;
begin
  aNode:=Node.getFirstChild;
  if aNode=nil then begin
    try
      st:=GetFullNameTree(Node);
      ADOQuery1.Active:=false;
      ADOQuery1.SQL.Clear;
      if id=-1 then
        ADOQuery1.SQL.Add('update TreeObj set Name = '+chr(39)+Copy(OldText, 0, length(OldText)-length(OldName))+v+
                         Copy(st, length(OldText)+1, length(st)-length(OldText)+1)+chr(39)
                         +' where Name ='+chr(39)+st+chr(39))
      else
        ADOQuery1.SQL.Add('update TreeObj set Name = '+chr(39)+Copy(OldText, 0, length(OldText)-length(OldName))+v+
                         Copy(st, length(OldText)+1, length(st)-length(OldText)+1)+chr(39)+
                         ',Location = '+chr(39)+l+chr(39)+' where Name ='+chr(39)+st+chr(39));
      ADOQuery1.ExecSQL;
    except
      err:=true;
      ADOQuery1.Destroy;
      ADOQuery1:=TADOQuery.Create(self);
      ADOQuery1.ConnectionString:=ConStr;
    end;
  end else begin
    while aNode<>nil do begin
      UpdateTree(aNode);
      aNode:=aNode.GetNextChild(aNode);
    end;
  end;
end;

begin
  err:=false;
  if TreeView1.Selected<>nil then begin
    id:=FoundIDonNode(TreeView1.Selected);
    if id>-1 then v:=SQLvsTree[id].Name else v:=TreeView1.Selected.Text;
    OldName:=v;
    if InputQuery('Update text','Введите новое имя объекта',v) then begin
      if id>-1 then begin
        l:=SQLvsTree[id].location;
        InputQuery('Update text','Введите новую локацию объекта',l)
      end;
      OldText:=GetFullNameTree(TreeView1.Selected);
      UpdateTree(TreeView1.Selected);
{      if (err=false) or (id=-1) then TreeView1.Selected.Text:=v else}
      if Timer1.Enabled then LoadTree(true) else LoadTree(false);
    end;
  end;
end;

procedure TForm1.N4Click(Sender: TObject);
begin
if MessageBox(handle,PChar('Вы уверены, что хотите удалить объект?'+#13#10), PChar('Внимание'), 36)=ID_YES then begin
  if TreeView1.Selected<>nil then
    if TreeView1.Selected.ImageIndex=0 then
      if TreeView1.Selected.getFirstChild=nil then TreeView1.Selected.Delete else ShowMessage('         Не могу удалить.'+#10+#13+'Есть зависимые элементы.')
      else begin
        try
          ADOQuery1.Active:=false;
          ADOQuery1.SQL.Clear;
          ADOQuery1.SQL.Add('declare @bufidpsens table(id int)');
          ADOQuery1.SQL.Add('insert into @bufidpsens select id_PSens from Sensors where id_tree in ('+'select id from TreeObj where Name ='+chr(39)+GetFullNameTree(TreeView1.Selected)+chr(39)+')');
          ADOQuery1.SQL.Add('delete from Sensors where id_tree in ('+'select id from TreeObj where Name ='+chr(39)+GetFullNameTree(TreeView1.Selected)+chr(39)+')');
          ADOQuery1.SQL.Add('delete from [Physical_Sensor] where id in (select id from @bufidpsens)');
          ADOQuery1.SQL.Add('delete from TreeObj where Name ='+chr(39)+GetFullNameTree(TreeView1.Selected)+chr(39));
          ADOQuery1.ExecSQL;
          if Timer1.Enabled then LoadTree(true) else LoadTree(false);
        except
          ADOQuery1.Destroy;
          ADOQuery1:=TADOQuery.Create(self);
          ADOQuery1.ConnectionString:=ConStr;
        end;
      end;
end;
end;

function TForm1.GetFullNameTree(Node:TTreeNode):String;
var whispoint:string;
    id:integer;
begin
  if Node <> nil then begin
    id := FoundIDonNode(Node);
    if id>-1 then begin
       whispoint:=SQLvsTree[id].Name+'.';
       if Node.Parent <> nil then Node:=Node.Parent;
    end else whispoint:='';
    while Node.Parent <> nil do
     begin
       whispoint:=Node.Text + '.' + whispoint;
       Node:=Node.Parent;
     end;
    whispoint:=Node.Text + '.' + whispoint;
    Delete(whispoint,Length(whispoint),1);
  end;
  Result:=whispoint;
end;

procedure TForm1.FormShow(Sender: TObject);
var server,DB,UserID,Pas,Access,TE,time,Useraccess:string;
    f: Textfile;
begin
    RunForm4:=false;
    TimeEnable:=false;
    form1.WindowState:=wsMaximized;
    AssignFile(f, ExtractFileDir(ParamStr(0))+'\db.cfg');
    Reset(f);
    Readln(f, Server);Server:=Copy(Server,8,Length(Server)-7);
    Readln(f, DB);DB:=Copy(DB,4,Length(DB)-3);
    Readln(f, UserID);UserID:=Copy(UserID,8,Length(UserID)-7);
    Readln(f, Pas);Pas:=Copy(Pas,5,Length(Pas)-4);
    Readln(f, Access);if not(Access = 'Access=AdminSA') then begin PopupMenu2.Destroy; PopupMenu1.Items[1].Enabled:=false; end;
    Readln(f, time);time:=Copy(time,6,Length(time)-5);
    Edit1.Text:=time;Timer1.Interval:=strtoint(time)*1000;
    Readln(f, TE);if TE = 'TimeEnable=True' then begin TimeEnable:=true; CheckBox1.Checked:=true; end;
    Readln(f, Useraccess);
    Closefile(f);

    ConStr:='Provider=SQLNCLI10.1;Password='+Pas+';'+
    'Persist Security Info=True;User ID='+UserID+';Initial Catalog='+DB+';'+
    'Data Source='+server+';Use Procedure for Prepare=1;Auto Translate=True;'+
    'Packet Size=4096;Workstation ID=ASUS_ION;Use Encryption for Data=False;'+
    'Tag with column collation when possible=False;MARS Connection=False;DataTypeCompatibility=0;'+
    'Trust Server Certificate=False';
    ADOQuery1.ConnectionString:=ConStr;
    ADOQuery2.ConnectionString:=ConStr;
    ADOQuery3.ConnectionString:=ConStr;
    ADOQuery4.ConnectionString:=ConStr;
    ADOQueryTimer1.ConnectionString:=ConStr;
    ADOQueryOPC.ConnectionString:=ConStr;
    Form2.ADOQuery1.ConnectionString:=ConStr;
    Form2.ADOQuery2.ConnectionString:=ConStr;
    Form3.ADOQuery1.ConnectionString:=Form1.ConStr;
    Form4.ADOQuery1.ConnectionString:=Form1.ConStr;
    Form4.ADOQuery2.ConnectionString:=Form1.ConStr;
    Form5.ADOQuery1.ConnectionString:=Form1.ConStr;
    Form6.ADOQuery1.ConnectionString:=Form1.ConStr;
    Form7.ADOQuery1.ConnectionString:=Form1.ConStr;

    Form7.UserAccess:=true;
    if Useraccess = 'User=true' then Form7.ShowModal;

    if Form7.UserAccess then begin
      Timer1.Enabled:=false;
      if TimeEnable then Timer1.Enabled:=true;
      if Timer1.Enabled then LoadTree(true) else LoadTree(false);
    end;

end;

procedure TForm1.LoadTree(WithStatusObj:boolean);
var NameNode,s:string;
    aNode:TTreeNode;
    i:integer;
    x,y:integer;
    SaveExpand: record
                  c:integer;
                  Name:array of String
                end;

  procedure CutOfPoint(var s,name:string);
    var p:integer;
  begin
    p:=Pos('.', s);
    if p=0 then name:=''
    else begin
      name:=Copy(s,1,p-1);
      s:=Copy(s,p+1,length(s));
    end;
  end;

  function FoundNode(fNode:TTreeNode; Name:string):TTreeNode;
    var Res,aNode:TTreeNode;
  begin
    Res:=nil;
    if fNode=nil then begin
      aNode:=TreeView1.Items.GetFirstNode;
      while ((Res=nil) and (aNode<>nil)) do begin
        if aNode.Text=Name then Res:=aNode;
        aNode:=aNode.GetNextChild(aNode);
      end;
      if Res=nil then Res:=TreeView1.Items.AddChild(nil,Name);
    end else begin
      aNode:=fNode.getFirstChild;

      while ((Res=nil) and (aNode<>nil)) do begin
        if aNode.Text=Name then Res:=aNode;
        aNode:=aNode.GetNextChild(aNode);
      end;
      if Res=nil then Res:=TreeView1.Items.AddChild(fNode,Name);
    end;
    Result:=Res;
  end;

  procedure AddObjectTree(Node:TTreeNode; Name:string);
  begin
    SQLvsTree[i].SQL:=ADOQuery1.Fields[0].AsInteger;
    SQLvsTree[i].Name:=Name;
    SQLvsTree[i].location:=ADOQuery1.Fields[2].AsString;
    if ADOQuery1.Fields[2].AsString='' then Node:=TreeView1.Items.AddChild(Node,Name)
                                       else Node:=TreeView1.Items.AddChild(Node,Name+'['+ADOQuery1.Fields[2].AsString+']');
    Node.ImageIndex:=1;
    Node.SelectedIndex:=1;
    SQLvsTree[i].Tree:=Node;
    i:=i+1;
  end;

  procedure UpBranch(Node:TTreeNode);
  var NNode,NoChildrenNode:TTreeNode;
      i:integer;
  begin
    NNode:=Node;
    NoChildrenNode:=nil;
    while NNode<>nil do begin
      if NNode.getFirstChild<>nil then UpBranch(NNode.getFirstChild);
      if (NNode.getFirstChild=nil)and(NoChildrenNode=nil) then NoChildrenNode:=NNode;
      if (NoChildrenNode<>nil)and(NNode.getFirstChild<>nil)then begin
        i:=FoundIDonNode(NNode);
        i:=FoundIDonNode(NoChildrenNode);
        NNode.MoveTo(NoChildrenNode, naInsert);
        i:=FoundIDonNode(NNode);
        i:=FoundIDonNode(NoChildrenNode);
      end;
      NNode:=NNode.getNextSibling;
    end;
  end;

begin
  i:=0;
  try
    ADOQuery1.Active:=false;
    ADOQuery1.SQL.Clear;
    if UserID = -1 then ADOQuery1.SQL.Add('Select id,Name,Location from TreeObj order by Name')
                   else ADOQuery1.SQL.Add('Select id,Name,Location from TreeObj where id in ('+
                                          'Select [id_TreeObj] from [VisibleObjinGroup], [Users] where [id_AccessGroup] = [Users].[AccessGroup] and [Users].id = '+IntToStr(UserID)+
                                          ') order by Name');
    ADOQuery1.Active:=true;
    SetLength(SQLvsTree,ADOQuery1.RecordCount);
//
    SaveExpand.c:=0;
    SetLength(SaveExpand.Name,TreeView1.Items.Count);
    for x:=0 to TreeView1.Items.Count-1 do
      if TreeView1.Items[x].getFirstChild<>nil then
        if TreeView1.Items[x].Expanded then begin
          SaveExpand.Name[SaveExpand.c]:=GetFullNameTree(TreeView1.Items[x]);
          SaveExpand.c:=SaveExpand.c+1;
        end;
//
    TreeView1.Items.Clear;
    while not(ADOQuery1.Eof) do begin
      s:=ADOQuery1.Fields[1].AsString;
      CutOfPoint(s,NameNode);
      aNode:=nil;
      while NameNode<>'' do begin
        aNode:=FoundNode(aNode,NameNode);
        CutOfPoint(s,NameNode);
      end;
      AddObjectTree(aNode,s);
      ADOQuery1.Next;
    end;
  except
    ADOQuery1.Destroy;
    ADOQuery1:=TADOQuery.Create(self);
    ADOQuery1.ConnectionString:=ConStr;
  end;
  ADOQuery1.Active:=false;
  if WithStatusObj then SetStatusObject(Null);
  UpBranch(TreeView1.Items.GetFirstNode);
  for x:=0 to TreeView1.Items.Count-1 do 
    if TreeView1.Items[x].getFirstChild<>nil then TreeView1.Items[x].Expanded:=false;
  if SaveExpand.c>0 then
    for x:=0 to TreeView1.Items.Count-1 do
      for y:=0 to SaveExpand.c-1 do
        if GetFullNameTree(TreeView1.Items[x]) = SaveExpand.Name[y] then TreeView1.Items[x].Expanded:=true;
end;

function TForm1.FoundSensonName(tree:integer; SName:String):integer;
var i,r:integer;
begin
  r:=-1;
  for i:=0 to Length(SQLvsTree[tree].Sensors)-1 do begin
    if SQLvsTree[tree].Sensors[i].Name=SName then begin r:=i; Break; end;
  end;
  Result:=r;
end;

function TForm1.FoundIDonNode(Node:TTreeNode):integer;
var r,i:integer;
begin
  r:=-1;
  for i:=0 to Length(SQLvsTree)-1 do begin
    if SQLvsTree[i].Tree=Node then begin r:=i; Break; end;
  end;
  Result:=r;
end;

function TForm1.FoundIDonSQL(SQL:integer):integer;
var r:integer;
    i:integer;
begin
  r:=-1;
  for i:=0 to Length(SQLvsTree)-1 do begin
    if SQLvsTree[i].SQL=SQL then begin r:=i; Break; end;
  end;
  Result:=r;
end;

procedure TForm1.SetStatusObject(idV:Variant);
var res:string;//00000 [1] - статус связи, [2] - есть ли отключенные датчики, [3] - авария, [4] - предупреждение, [5] - норма
    i,j,id,SensCount,idSQL:integer;
    globalcount:integer;
    FullTreeName, FoundTimerName:string;
    foundtimer:integer;

  procedure InitParametrs();
    var a:integer;
        FlagEof:boolean;
  begin
      idSQL:=ADOQuery1.Fields[16].AsInteger;
      FlagEof:=false;
      res:='00000';i:=0;
      SensCount := 0;
      while not(ADOQuery1.Eof) and (idSQL=ADOQuery1.Fields[16].AsInteger) do begin
         SensCount := SensCount+1;
         ADOQuery1.Next;
      end;
      if ADOQuery1.Eof and (idV=Null) then FlagEof:=true;
      for a:=0 to SensCount-1 do ADOQuery1.Prior;
      if FlagEof then ADOQuery1.Next;
      id:=FoundIDonSQL(idSQL);
      SetLength(SQLvsTree[id].Sensors,SensCount);
      SQLvsTree[id].Tree.ImageIndex:=1;SQLvsTree[id].Tree.SelectedIndex:=1;
  end;

  procedure SetStatusThisObject();
    var i:integer;
  begin
      SQLvsTree[id].statusObj:=res;
      if  res[1]='1' then begin
        SQLvsTree[id].Tree.ImageIndex:=21;SQLvsTree[id].Tree.SelectedIndex:=21;
        for i:=0 to length(SQLvsTree[id].Sensors)-1 do begin
          SQLvsTree[id].Sensors[i].Img:=17;
          if ((SQLvsTree[id].Sensors[i].TypeMes=2) or
              (SQLvsTree[id].Sensors[i].TypeMes=3) or
              (SQLvsTree[id].Sensors[i].TypeMes=7) or
              (SQLvsTree[id].Sensors[i].TypeMes=8)) and
              (VarToStr(SQLvsTree[id].Sensors[i].OPCValue)<>'Отключен') and
              not(SQLvsTree[id].Sensors[i].NotConnectVisibl)
              then SQLvsTree[id].Sensors[i].OPCValue:='Cвязь потеряна';
        end;
      end else begin
        if res='01100'then begin SQLvsTree[id].Tree.ImageIndex:=2;SQLvsTree[id].Tree.SelectedIndex:=2; end;
        if res='01010'then begin SQLvsTree[id].Tree.ImageIndex:=3;SQLvsTree[id].Tree.SelectedIndex:=3; end;
        if res='01001'then begin SQLvsTree[id].Tree.ImageIndex:=4;SQLvsTree[id].Tree.SelectedIndex:=4; end;
        if res='01110'then begin SQLvsTree[id].Tree.ImageIndex:=5;SQLvsTree[id].Tree.SelectedIndex:=5; end;
        if res='01101'then begin SQLvsTree[id].Tree.ImageIndex:=6;SQLvsTree[id].Tree.SelectedIndex:=6; end;
        if res='01011'then begin SQLvsTree[id].Tree.ImageIndex:=7;SQLvsTree[id].Tree.SelectedIndex:=7; end;
        if res='01111'then begin SQLvsTree[id].Tree.ImageIndex:=8;SQLvsTree[id].Tree.SelectedIndex:=8; end;
        if res='00100'then begin SQLvsTree[id].Tree.ImageIndex:=10;SQLvsTree[id].Tree.SelectedIndex:=10; end;
        if res='00010'then begin SQLvsTree[id].Tree.ImageIndex:=11;SQLvsTree[id].Tree.SelectedIndex:=11; end;
        if res='00001'then begin SQLvsTree[id].Tree.ImageIndex:=12;SQLvsTree[id].Tree.SelectedIndex:=12; end;
        if res='00110'then begin SQLvsTree[id].Tree.ImageIndex:=13;SQLvsTree[id].Tree.SelectedIndex:=13; end;
        if res='00101'then begin SQLvsTree[id].Tree.ImageIndex:=14;SQLvsTree[id].Tree.SelectedIndex:=14; end;
        if res='00011'then begin SQLvsTree[id].Tree.ImageIndex:=15;SQLvsTree[id].Tree.SelectedIndex:=15; end;
        if res='00111'then begin SQLvsTree[id].Tree.ImageIndex:=16;SQLvsTree[id].Tree.SelectedIndex:=16; end;
      end;
  end;

  procedure SetSensorStatus();
  begin
      SQLvsTree[id].Sensors[i].Name:=ADOQuery1.Fields[4].AsString;
      if ADOQuery1.Fields[5].AsString='' then SQLvsTree[id].Sensors[i].NumberSens:='б/н'
                                         else SQLvsTree[id].Sensors[i].NumberSens:=ADOQuery1.Fields[5].AsString;
      SQLvsTree[id].Sensors[i].TagValue:=ADOQuery1.Fields[6].AsVariant;
      SQLvsTree[id].Sensors[i].TagEd:=ADOQuery1.Fields[7].AsString;
      SQLvsTree[id].Sensors[i].OPCEd:=ADOQuery1.Fields[9].AsString;
      SQLvsTree[id].Sensors[i].EnableFlag:=True;
      SQLvsTree[id].Sensors[i].Img:=20;
      SQLvsTree[id].Sensors[i].TypeMes:=ADOQuery1.Fields[2].AsInteger;
      SQLvsTree[id].Sensors[i].Broadcast:=ADOQuery1.Fields[10].AsBoolean;
      SQLvsTree[id].Sensors[i].id_rwtag:=ADOQuery1.Fields[0].AsInteger;
      SQLvsTree[id].Sensors[i].id_sens:=ADOQuery1.Fields[11].AsInteger;
      SQLvsTree[id].Sensors[i].TagName:=ADOQuery1.Fields[12].AsString;
      SQLvsTree[id].Sensors[i].TypeSens:=ADOQuery1.Fields[13].AsString;
      SQLvsTree[id].Sensors[i].NotConnectVisibl:=ADOQuery1.Fields[14].AsBoolean;
      SQLvsTree[id].Sensors[i].TagTimeStamp:=ADOQuery1.Fields[15].AsString;

      if (ADOQuery1.Fields[12].AsVariant='NULL') or (ADOQuery1.Fields[12].AsVariant=Null) or (ADOQuery1.Fields[1].AsBoolean=False) then
        begin
          if SQLvsTree[id].Sensors[i].TypeMes<>5 then res[2]:='1';
          SQLvsTree[id].Sensors[i].OPCValue:='Отключен';
          SQLvsTree[id].Sensors[i].EnableFlag:=false;
          SQLvsTree[id].Sensors[i].Img:=17;
        end
      else
        case ADOQuery1.Fields[2].AsInteger of
          1,2,6:SQLvsTree[id].Sensors[i].OPCValue:=StrToBool(ADOQuery1.Fields[8].AsString);
          3,8:SQLvsTree[id].Sensors[i].OPCValue:=StrToFloatSafe(ADOQuery1.Fields[8].AsString);
          else SQLvsTree[id].Sensors[i].OPCValue:=ADOQuery1.Fields[8].AsString;
        end;

      if ((ADOQuery1.Fields[2].AsInteger=1) and (ADOQuery1.Fields[3].AsInteger=0))or
         ((ADOQuery1.Fields[2].AsInteger=6) and (ADOQuery1.Fields[3].AsInteger=0))
        and not((ADOQuery1.Fields[12].AsVariant='NULL') or (ADOQuery1.Fields[12].AsVariant=Null) or (ADOQuery1.Fields[1].AsBoolean=False)) then
        begin
          res[1]:='1';
          res[3]:='0';
          res[4]:='0';
          res[5]:='0';
        end;
      if not((ADOQuery1.Fields[12].AsVariant='NULL') or (ADOQuery1.Fields[12].AsVariant=Null) or (ADOQuery1.Fields[1].AsBoolean=False)) then begin
        if ADOQuery1.Fields[3].AsInteger=1 then begin res[3]:='1';SQLvsTree[id].Sensors[i].Img:=18;end;
        if ADOQuery1.Fields[3].AsInteger=2 then begin res[4]:='1';SQLvsTree[id].Sensors[i].Img:=19;end;
        if ADOQuery1.Fields[3].AsInteger=3 then begin res[5]:='1';end;
      end;
      i:=i+1;
  end;

begin
 try
  ADOQuery1.Active:=false;
  ADOQuery1.SQL.Clear;
  if idV = Null then ADOQuery1.SQL.Add('exec GetObjStatus NULL, '+IntToStr(UserID))
                else ADOQuery1.SQL.Add('exec GetObjStatus '+inttostr(SQLvsTree[integer(idV)].SQL));
  ADOQuery1.Active:=True;
  if ADOQuery1.RecordCount=0 then
    if idV = Null then for i:=0 to Length(SQLvsTree)-1 do SetLength(SQLvsTree[i].Sensors,0)
                  else SetLength(SQLvsTree[integer(idV)].Sensors,0)
  else begin
    InitParametrs();
   while not(ADOQuery1.Eof) do begin
    if idSQL<>ADOQuery1.Fields[16].AsInteger then begin
      SetStatusThisObject();
      InitParametrs();
      SetSensorStatus();
    end else begin
      SetSensorStatus();
    end;
    ADOQuery1.Next;
   end;
   SetStatusThisObject();
  end;
 except
  ADOQuery1.Destroy;
  ADOQuery1:=TADOQuery.Create(self);
  ADOQuery1.ConnectionString:=ConStr;
 end;

// Раздел для OPC Сервера начало
      globalcount:=0;
      for i:=0 to length(SQLvsTree)-1 do
        globalcount:=globalcount+length(SQLvsTree[i].Sensors);
      if globalcount>0 then SetLength(OPCTags,globalcount);
      globalcount:=0;
      for i:=0 to length(SQLvsTree)-1 do begin
        FullTreeName:=Form1.GetFullNameTree(Form1.SQLvsTree[i].Tree);
        for j:=0 to length(SQLvsTree[i].Sensors)-1 do begin
          OPCTags[globalcount].Name:=FullTreeName+'.'+Form1.SQLvsTree[i].Sensors[j].Name;
          OPCTags[globalcount].i:=i;OPCTags[globalcount].j:=j;
          globalcount:=globalcount+1;
        end;
      end;
// Раздел для OPC Сервера конец
end;

procedure TForm1.TreeView1Change(Sender: TObject; Node: TTreeNode);
  function GetCountChildren(Node:TTreeNode):string;
  var count:integer;
    procedure NextNode(nNode:TTreeNode);
    var afNode:TTreeNode;
    begin
      afNode:=nNode.getFirstChild;
      while afNode<>nil do begin
        if afNode.getFirstChild=nil then count:=count+1
        else NextNode(afNode);
        afNode:=afNode.getNextSibling;
      end;
    end;
  begin
    count:=0;
    NextNode(Node);
    Result:=inttostr(count);
  end;
var firstNode:TTreeNode;
    id,i:integer;
begin
  firstNode:=TreeView1.Selected;
  ListView1.Items.Clear;
  Memo1.Lines.Clear;
  Memo1.Enabled:=false;
  Button3.Enabled:=false;
  Label1.Caption:='';
  if (firstNode<>Nil) then begin
    while firstNode.Parent<>nil do
      firstNode:=firstNode.Parent;
    GroupBox2.Caption:=firstNode.Text+' - '+ GetCountChildren(firstNode)+' объектов в узле';
    id:=FoundIDonNode(TreeView1.Selected);
    if (TreeView1.Selected.getFirstChild=nil) and (id<>-1) then begin
      Memo1.Enabled:=true;
      Button3.Enabled:=true;
      try
        ADOQuery1.Active:=false;
        ADOQuery1.SQL.Clear;
        ADOQuery1.SQL.Add('select Comment, Address from TreeObj where id='+inttostr(SQLvsTree[id].SQL));
        ADOQuery1.Active:=True;
        Memo1.Lines.Add(ADOQuery1.Fields[0].AsString);
        Label1.Caption:=GetFullNameTree(TreeView1.Selected)+' ['+ADOQuery1.Fields[1].AsString+']';
        Label1.Caption:=StringReplace(Label1.Caption, chr(13), '', [rfReplaceAll]);
        Label1.Caption:=StringReplace(Label1.Caption, chr(10), '', [rfReplaceAll]);
      except
        ADOQuery1.Destroy;
        ADOQuery1:=TADOQuery.Create(self);
        ADOQuery1.ConnectionString:=ConStr;
      end;

      for i:=0 to Length(SQLvsTree[id].Sensors)-1 do begin
        ListView1.Items.Add;
        ListView1.Items[i].Caption:=SQLvsTree[id].Sensors[i].Name;
        ListView1.Items[i].SubItems.Add(SQLvsTree[id].Sensors[i].TypeSens);
        ListView1.Items[i].SubItems.Add(SQLvsTree[id].Sensors[i].NumberSens);
        if SQLvsTree[id].Sensors[i].TagValue<>null then ListView1.Items[i].SubItems.Add(SQLvsTree[id].Sensors[i].TagValue)
        else ListView1.Items[i].SubItems.Add('');
        ListView1.Items[i].SubItems.Add(SQLvsTree[id].Sensors[i].TagEd);
        if SQLvsTree[id].Sensors[i].OPCValue<>null then ListView1.Items[i].SubItems.Add(SQLvsTree[id].Sensors[i].OPCValue)
        else ListView1.Items[i].SubItems.Add('');
        ListView1.Items[i].SubItems.Add(SQLvsTree[id].Sensors[i].OPCEd);
        if not(SQLvsTree[id].Sensors[i].EnableFlag) then ListView1.Items[i].SubItems.Add('Отключен')
                                                    else ListView1.Items[i].SubItems.Add('Подключен');
        if SQLvsTree[id].Sensors[i].Broadcast then ListView1.Items[i].SubItems.Add('Тег передается')
                                                    else ListView1.Items[i].SubItems.Add('Внутренний тег');
        ListView1.Items[i].SubItems.Add(SQLvsTree[id].Sensors[i].TagName);
        ListView1.Items[i].SubItems.Add(SQLvsTree[id].Sensors[i].TagTimeStamp);
        ListView1.Items[i].ImageIndex:=SQLvsTree[id].Sensors[i].Img;
      end;
    end;
  end;
  if RunForm4 then begin
    form4.id_tree_sour:=SQLvsTree[FoundIDonNode(TreeView1.Selected)].SQL;
    form4.Edit4.Text:=GetFullNameTree(TreeView1.Selected);
  end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var i:integer;
begin
  Button2Click(Self);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  SetStatusObject(FoundIDonNode(TreeView1.Selected));
  TreeView1Change(nil,nil);
end;

procedure TForm1.Button2Click(Sender: TObject);
var name:string;
    i:integer;
begin
  if TreeView1.Selected<>nil then name:=GetFullNameTree(TreeView1.Selected);
  LoadTree(true);
  TreeView1Change(nil,nil);
  for i:=0 to TreeView1.Items.Count-1 do
    if GetFullNameTree(TreeView1.Items[i])=name then begin
      TreeView1.Selected:=TreeView1.Items[i];
      Break;
    end;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  if TreeView1.Selected<>nil then begin
    try
      ADOQuery1.Active:=false;
      ADOQuery1.SQL.Clear;
      ADOQuery1.SQL.Add('update TreeObj  set Comment='+chr(39)+Memo1.Text+chr(39)+' where id='+inttostr(SQLvsTree[FoundIDonNode(TreeView1.Selected)].SQL));
      ADOQuery1.ExecSQL;
    except
      ADOQuery1.Destroy;
      ADOQuery1:=TADOQuery.Create(self);
      ADOQuery1.ConnectionString:=ConStr;
    end;
  end;
end;

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
  Timer1.Enabled:=CheckBox1.Checked;
end;

procedure TForm1.Edit1Change(Sender: TObject);
begin
  try
    Timer1.Enabled:=false;
    CheckBox1.Checked:=false;
    Timer1.Interval:=strtoint(Edit1.Text)*1000;
  Except
  end;
end;

procedure TForm1.N6Click(Sender: TObject);
begin
  Form2.id:=FoundIDonNode(TreeView1.Selected);
  Form2.NameSens:='';
  Form2.ShowModal;
  Button1Click(self);
end;

procedure TForm1.PopupMenu2Popup(Sender: TObject);
var foo: TPoint;
begin
  GetCursorPos(foo);
  Form2.Top:=foo.Y;
  Form2.Left:=foo.X;
  N6.Enabled:=false;
  N7.Enabled:=false;
  N8.Enabled:=false;
  N9.Enabled:=false;
  N10.Enabled:=false;
  if TreeView1.Selected<>Nil then
    if TreeView1.Selected.getFirstChild=nil then begin
      N6.Enabled:=true;
      N9.Enabled:=true;
      if ListView1.Selected<>nil then begin
        N7.Enabled:=true;
        N8.Enabled:=true;
        N10.Enabled:=true;
      end;
    end;
end;

procedure TForm1.N7Click(Sender: TObject);
begin
  Form2.id:=FoundIDonNode(TreeView1.Selected);
  Form2.NameSens:=ListView1.Selected.Caption;
  Form2.ShowModal;
  Button1Click(self);
end;

procedure TForm1.N8Click(Sender: TObject);
var id,id_sens:integer;
    type_sens, idPsens:integer;
begin
  id:=FoundIDonNode(TreeView1.Selected);
  id_sens:=SQLvsTree[id].Sensors[FoundSensonName(id,ListView1.Selected.Caption)].id_sens;
  try
    Form2.ADOQuery1.Active:=false;
    Form2.ADOQuery1.SQL.Clear;
    Form2.ADOQuery1.SQL.Add('select TypeMeas, id_Psens from Sensors where id = '+inttostr(id_sens));
    Form2.ADOQuery1.Active:=True;
    type_sens:=Form2.ADOQuery1.Fields[0].AsInteger;
    idPsens:=Form2.ADOQuery1.Fields[1].AsInteger;

    Form2.ADOQuery1.Active:=false;
    Form2.ADOQuery1.SQL.Clear;
    if type_sens=1 then begin
      Form2.ADOQuery1.SQL.Add('delete Measure_Status where id='+inttostr(id_sens));
      Form2.ADOQuery1.ExecSQL;
      Form2.ADOQuery1.SQL.Clear;
    end;
    if type_sens=2 then begin
      Form2.ADOQuery1.SQL.Add('delete Measure_DIN where id='+inttostr(id_sens));
      Form2.ADOQuery1.ExecSQL;
      Form2.ADOQuery1.SQL.Clear;
    end;
    if type_sens=3 then begin
      Form2.ADOQuery1.SQL.Add('delete Measure_AIN where id='+inttostr(id_sens));
      Form2.ADOQuery1.ExecSQL;
      Form2.ADOQuery1.SQL.Clear;
    end;
    if type_sens=5 then begin
      Form2.ADOQuery1.SQL.Add('delete Measure_Period where id='+inttostr(id_sens));
      Form2.ADOQuery1.ExecSQL;
      Form2.ADOQuery1.SQL.Clear;
    end;
    if type_sens=8 then begin
      Form2.ADOQuery1.SQL.Add('delete Measure_FILTR where id='+inttostr(id_sens));
      Form2.ADOQuery1.ExecSQL;
      Form2.ADOQuery1.SQL.Clear;
    end;
    Form2.ADOQuery1.SQL.Add('delete Sensors where id='+inttostr(id_sens));
    Form2.ADOQuery1.SQL.Add('BEGIN TRY delete from dbo.Physical_Sensor where id='+inttostr(idPsens)+'	END TRY	BEGIN CATCH END CATCH');
    Form2.ADOQuery1.ExecSQL;
  except
    Form2.ADOQuery1.Destroy;
    Form2.ADOQuery1:=TADOQuery.Create(self);
    Form2.ADOQuery1.ConnectionString:=Form1.ConStr;
  end;
  Button1Click(self);
end;

procedure TForm1.N10Click(Sender: TObject);
var
  i,j,a,ih:integer;
  v:string;
begin
  i:=FoundIDonNode(TreeView1.Selected);
  for a:=0 to length(SQLvsTree[i].Sensors)-1 do
    if SQLvsTree[i].Sensors[a].Name=ListView1.Selected.Caption then begin
      j:=a;
      Break;
    end;
  for a:=0 to length(OPCTags)-1 do
    if (OPCTags[a].i=i)and(OPCTags[a].j=j) then begin
      ih:=a;
      Break;
    end;
  if (SQLvsTree[i].Sensors[j].TypeMes=4) or (SQLvsTree[i].Sensors[j].TypeMes=5) then begin
    if InputQuery('New Value','Введите новое значение',v) then CROPC.SetItemValue(ih,v); end
  else ShowMessage('Тег не предназначен для записи');
end;

procedure TForm1.N9Click(Sender: TObject);
var foo: TPoint;
begin
  GetCursorPos(foo);
  Form4.Top:=foo.Y;
  Form4.Left:=foo.X;

  form4.tree_dest:=TreeView1.Selected;
  form4.id_tree_dest:=SQLvsTree[FoundIDonNode(TreeView1.Selected)].SQL;
  form4.Show;
end;

procedure TForm1.N11Click(Sender: TObject);
  var F:string;
      stop:boolean;
      FirstTree, NextTree:TTreeNode;
begin
  if InputQuery('Input text','Найти объект',F) then begin
    stop:=false;
    if TreeView1.Selected<>nil then FirstTree:=TreeView1.Selected else FirstTree:=TreeView1.Items[0];
    if FirstTree<>nil then begin
      if FirstTree.GetNext<>nil then NextTree:=FirstTree.GetNext else NextTree:=TreeView1.Items[0];
      repeat
        if Pos(F,NextTree.Text)>0 then begin
          TreeView1.SetFocus;
          TreeView1.Selected:=NextTree;
          stop:=true;
        end;
        if NextTree = FirstTree then stop:=true;
        if not(stop) then if NextTree.GetNext<>nil then NextTree:=NextTree.GetNext else NextTree:=TreeView1.Items[0];
      until stop;
    end;
  end;
end;

procedure TForm1.N12Click(Sender: TObject);
begin
  if TreeView1.Selected<>nil then
    if TreeView1.Selected.getFirstChild=nil then begin
      ADOQuery4.Active:=false;
      ADOQuery3.Active:=false;
      ADOQuery3.SQL.Clear;
      ADOQuery3.SQL.Add('SELECT Name, Address ,id FROM TreeObj Where id  in (select id from TreeObj where Name ='+chr(39)+GetFullNameTree(TreeView1.Selected)+chr(39)+')');
      ADOQuery3.Active:=true;
      ADOQuery4.Active:=true;
      frxReport1.ShowReport();
    end;
end;

procedure TForm1.ADOQuery3AfterScroll(DataSet: TDataSet);
begin
  ADOQuery4.Active:=false;
  ADOQuery4.Parameters.ParamByName('id_obj1').Value:=ADOQuery3.Fields[2].AsInteger;
  ADOQuery4.Active:=true;
end;

procedure TForm1.N16Click(Sender: TObject);
begin
  if TreeView1.Selected<>nil then
    if TreeView1.Selected.getFirstChild=nil then begin
    Form6.ObjName:=GetFullNameTree(TreeView1.Selected);
    Form6.ShowModal;
    end;
end;

end.
