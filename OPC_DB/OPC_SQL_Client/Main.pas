unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ADODB, ShellAPI, StdCtrls, ExtCtrls, ComCtrls, dOPCIntf,
  dOPCComn, dOPC, dOPCDlgServerSelect, dOPCDA;

type
  MyString = string[255];
  TForm1 = class(TForm)
    Memo1: TMemo;
    Timer1: TTimer;
    Button1: TButton;
    Button2: TButton;
    ADOQuery1: TADOQuery;
    ADOQuery2: TADOQuery;
    Button3: TButton;
    OPCServerMy: TdOPCServer;
    Timer2: TTimer;
    Procedure ControlWindow(Var Msg:TMessage); message WM_SYSCOMMAND;
    Procedure IconMouse(var Msg:TMessage); message WM_USER+1;
    Procedure Ic(n:Integer;Icon:TIcon);
    procedure Timer1Timer(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure OPCServerDatachange(Sender: TObject;
      ItemList: TdOPCItemList);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button3Click(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
  private
    procedure ConnectToOPC();
    procedure DisConnectToOPC();
    procedure UpdateTagValue(TagName, NewValue:string; TagTime:TDateTime);
    procedure CheckLimit(L:TStrings; limit:integer);
    { Private declarations }
  public
     OPCServerName:String;
     ConStr:String;
     countTags:integer;
     Tags:^MyString;
     GlobalTagsName:TStrings;
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
procedure TForm1.CheckLimit(L:TStrings; limit:integer);
begin
  while L.Count>limit do begin
    L.Move(0,L.Count-1);
    L.Delete(L.Count-1);
  end;
end;

procedure TForm1.DisConnectToOPC();
begin
  Timer1.Enabled:=false;
  Timer2.Enabled:=false;
  OPCServerMy.OPCGroups[0].IsActive:=false;
  OPCServerMy.OPCGroups[0].OPCItems.RemoveAll;
  OPCServerMy.Active:=false;
  FreeMem(Tags, countTags * SizeOf(MyString));
  Form1.Caption:='Не подключен к OPC';
end;

procedure TForm1.ConnectToOPC();
procedure GetAllItems(Browser: TdOPCBrowser; Level: integer = 0);
var
  i          : integer;
  Items      : TdOPCBrowseItems;
  BrowseItem : TdOPCBrowseItem;
  TagsName   : String;
begin
  Browser.Browse;                        // get all Branches and Items in this level from OPC Server
  Items  := TdOPCBrowseItems.Create;     // create a new list
  Items.Assign(Browser.Items);           // save and copy Items in new List
  TagsName:= '';

  for i := 0 to Items.Count-1 do         // for all items in current path
  begin
     BrowseItem := Items[i];
     if BrowseItem.IsItem then begin           // if browse item is not a folder
        OPCServerMy.OPCGroups[0].OPCItems.AddItem(BrowseItem.ItemId);
        countTags:=countTags+1;
     end else
     begin                                      // if it is a folder
       if Browser.MoveDown(BrowseItem) then     // one Level down
       begin
         GetAllItems(Browser,Level+1); // recursive call
         Browser.MoveUp;                       // back to old Level
       end;
     end;
  end;

  Items.Free;
end;

begin
  OPCServerMy.ServerName:=OPCServerName;
  try
     GlobalTagsName := TStringList.Create;
     GlobalTagsName.Clear;
     OPCServerMy.Active := true;
     countTags:=0;
     GetAllItems(OPCServerMy.Browser);
     GetMem(Tags, countTags * SizeOf(MyString));
     OPCServerMy.OPCGroups[0].IsActive:=true;
     Form1.Caption:='Подкючен к OPC - '+OPCServerName;
     Timer1.Enabled:=true;
     Timer2.Enabled:=true;
     Memo1.Lines.Add(FormatDateTime('yyyy/mm/dd hh:mm:ss',now)+' Соединение с OPC сервером установлено');
     CheckLimit(Memo1.Lines,1024);
  except on E : Exception do begin
       Memo1.Lines.Add(FormatDateTime('yyyy/mm/dd hh:mm:ss',now)+' Ошибка соединения с OPC сервером: '+E.Message);
       CheckLimit(Memo1.Lines,1024);
       OPCServerMy.Active:=false;
       Timer1.Enabled:=false;
       Timer2.Enabled:=false;
     end;
  end;
end;

{======================================}
{Методы для добавления программы в трей}
{======================================}
procedure TForm1.IconMouse(var Msg:TMessage);
Var p:tpoint;
begin
 GetCursorPos(p); // Запоминаем координаты курсора мыши
 Case Msg.LParam OF  // Проверяем какая кнопка была нажата
  WM_LBUTTONUP,WM_LBUTTONDBLCLK: {Действия, выполняемый по одинарному или двойному щелчку левой кнопки мыши на значке. В нашем случае это просто активация приложения}
                   Begin
                    Ic(2,Application.Icon);  // Удаляем значок из трея
                    ShowWindow(Application.Handle,SW_SHOW); // Восстанавливаем кнопку программы
                    ShowWindow(Handle,SW_SHOW); // Восстанавливаем окно программы
                    Update;
                   End;
//  WM_RBUTTONUP: {Действия, выполняемый по одинарному щелчку правой кнопки мыши}
{   Begin
    SetForegroundWindow(Handle);  // Восстанавливаем программу в качестве переднего окна
    pmTreyMenu.Popup(p.X,p.Y);  // Заставляем всплыть наше PopMenu
    PostMessage(Handle,WM_NULL,0,0);
   end;}
 End;
end;

Procedure TForm1.ControlWindow(Var Msg:TMessage);
Begin
 IF Msg.WParam=SC_MINIMIZE then
  Begin
   Ic(1,Application.Icon);                    // Добавляем значок в трей
   ShowWindow(Handle,SW_HIDE);                // Скрываем программу
   ShowWindow(Application.Handle,SW_HIDE);  // Скрываем кнопку с TaskBar'а
 End
 else inherited;
End;

Procedure TForm1.Ic(n:Integer;Icon:TIcon);
Var Nim:TNotifyIconData;
begin
 With Nim do
  Begin
   cbSize:=SizeOf(Nim);
   Wnd:=Self.Handle;
   uID:=1;
   uFlags:=NIF_ICON or NIF_MESSAGE or NIF_TIP;
   hicon:=Icon.Handle;
   uCallbackMessage:=wm_user+1;
   StrPCopy(szTip, OPCServerName);
  End;
 Case n OF
  1: Shell_NotifyIcon(Nim_Add,@Nim);
  2: Shell_NotifyIcon(Nim_Delete,@Nim);
  3: Shell_NotifyIcon(Nim_Modify,@Nim);
 End;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var Item:TdOPCItem;
    str:string;
begin
  ADOQuery2.SQL.Clear;
  ADOQuery2.SQL.Add('SELECT TagName, Value FROM BufferWriteTag where TagName like '+chr(39)+'%'+OPCServerMy.ServerCaption+'.%'+chr(39)+
                    ' delete from BufferWriteTag where TagName like '+chr(39)+'%'+OPCServerMy.ServerCaption+'.%'+chr(39));
  try
    ADOQuery2.Active:=true;
    while not(ADOQuery2.Eof) do begin
      str:=ADOQuery2.Fields[0].AsString;
      delete(str,1,length(OPCServerName)+1);
      Item:=OPCServerMy.OPCGroups[0].OPCItems.FindOPCItem(str);
      try
        Memo1.Lines.Add(FormatDateTime('yyyy/mm/dd hh:mm:ss',now)+': Значение тега - '+ADOQuery2.Fields[0].AsString+
                        ' изменено с '+Item.ValueStr+' на '+ADOQuery2.Fields[1].AsString);
        CheckLimit(Memo1.Lines,1024);
        if VarType(Item.Value) = 7 then Item.WriteSync(ADOQuery2.Fields[1].AsDateTime)
                                   else Item.WriteSync(ADOQuery2.Fields[1].AsVariant);
      except on E : Exception do begin
          Memo1.Lines.Add(FormatDateTime('yyyy/mm/dd hh:mm:ss',now)+' Перезаписать тег '+ADOQuery2.Fields[0].AsString+' неудалось - '+E.Message);
          CheckLimit(Memo1.Lines,1024);
        end;
      end;
      ADOQuery2.Next;
    end;
  except on E : Exception do begin
      Memo1.Lines.Add(FormatDateTime('yyyy/mm/dd hh:mm:ss',now)+' Ошибка соединения с базой: '+E.Message);
      CheckLimit(Memo1.Lines,1024);
      ADOQuery2.Destroy;
      ADOQuery2:=TADOQuery.Create(self);
      ADOQuery2.ConnectionString:=ConStr;
    end;
  end;
  ADOQuery2.Active:=false;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  DisConnectToOPC();
  ConnectToOPC();
end;

procedure TForm1.UpdateTagValue(TagName, NewValue:string; TagTime:TDateTime);
var NW: string;
begin
    NW:=chr(39)+TagName+chr(39)+','+chr(39)+NewValue+chr(39)+','+chr(39)+FormatDateTime('dd/mm/yyyy hh:mm:ss.zzz',TagTime)+chr(39);
    GlobalTagsName.Add('insert into BufferReadTag(TagName,Value,TagTimeStamp) values ('+NW+') ');
end;

procedure TForm1.Button1Click(Sender: TObject);
var i:integer;
begin
  for i:=0 to OPCServerMy.OPCGroups[0].OPCItems.Count-1 do
    UpdateTagValue(OPCServerMy.ServerCaption+'.'+OPCServerMy.OPCGroups[0].OPCItems.Items[i].ItemID, OPCServerMy.OPCGroups[0].OPCItems.Items[i].ValueStr, OPCServerMy.OPCGroups[0].OPCItems.Items[i].TimeStamp);
end;

procedure TForm1.FormShow(Sender: TObject);
var server,DB,UserID,Pas,OPCInterval,RTagInterval,WTagInterval:string;
    f: Textfile;
    today:TDateTime;
begin
    today:=Now;
    AssignFile (f, 'c:\test.txt');
    Rewrite (f);
    WriteLn (f, 'текущее время - '+TimeToStr(today));
    CloseFile(f);

    OPCServerMy :=TdOPCServer.Create(self);
    OPCServerMy.OPCGroups.Add('Root');

    form1.WindowState:=wsMaximized;
    AssignFile(f, ExtractFileDir(ParamStr(0))+'\db.cfg');
    Reset(f);
    Readln(f, OPCServerName);OPCServerName:=Copy(OPCServerName,AnsiPos('=',OPCServerName)+1,AnsiPos(';',OPCServerName)-AnsiPos('=',OPCServerName)-1);
    Readln(f, Server);Server:=Copy(Server,AnsiPos('=',Server)+1,AnsiPos(';',Server)-AnsiPos('=',Server)-1);
    Readln(f, DB);DB:=Copy(DB,AnsiPos('=',DB)+1,AnsiPos(';',DB)-AnsiPos('=',DB)-1);
    Readln(f, UserID);UserID:=Copy(UserID,AnsiPos('=',UserID)+1,AnsiPos(';',UserID)-AnsiPos('=',UserID)-1);
    Readln(f, Pas);Pas:=Copy(Pas,AnsiPos('=',Pas)+1,AnsiPos(';',Pas)-AnsiPos('=',Pas)-1);
    Readln(f, OPCInterval);OPCInterval:=Copy(OPCInterval,AnsiPos('=',OPCInterval)+1,AnsiPos(';',OPCInterval)-AnsiPos('=',OPCInterval)-1);
    OPCServerMy.OPCGroups[0].UpdateRate:=strtoint(OPCInterval);
    Readln(f, RTagInterval);RTagInterval:=Copy(RTagInterval,AnsiPos('=',RTagInterval)+1,AnsiPos(';',RTagInterval)-AnsiPos('=',RTagInterval)-1);
    Timer2.Interval:=strtoint(RTagInterval);
    Readln(f, WTagInterval);WTagInterval:=Copy(WTagInterval,AnsiPos('=',WTagInterval)+1,AnsiPos(';',WTagInterval)-AnsiPos('=',WTagInterval)-1);
    Timer1.Interval:=strtoint(WTagInterval);
    Closefile(f);

    ConStr:='Provider=SQLNCLI10.1;Password='+Pas+';'+
    'Persist Security Info=True;User ID='+UserID+';Initial Catalog='+DB+';'+
    'Data Source='+server+';Use Procedure for Prepare=1;Auto Translate=True;'+
    'Packet Size=4096;Workstation ID=ASUS_ION;Use Encryption for Data=False;'+
    'Tag with column collation when possible=False;MARS Connection=False;DataTypeCompatibility=0;'+
    'Trust Server Certificate=False';

    ADOQuery1.ConnectionString:=ConStr;
    ADOQuery2.ConnectionString:=ConStr;

    ConnectToOPC();
end;

procedure TForm1.OPCServerDatachange(Sender: TObject;
  ItemList: TdOPCItemList);
var i:integer;
    pTag:^MyString;
begin
   for i:=0 to ItemList.Count-1 do begin
    pTag:=pointer(dword(Tags)+(SizeOf(Mystring)*ItemList.Items[i].index));
    if pTag^<>ItemList.Items[i].ValueStr then begin
      pTag^:=ItemList.Items[i].ValueStr;
      UpdateTagValue(OPCServerMy.ServerCaption+'.'+ItemList.Items[i].ItemID, ItemList.Items[i].ValueStr, ItemList.Items[i].TimeStamp);
    end;
   end;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  OPCServerMy.Active:=false;
end;

procedure TForm1.Button3Click(Sender: TObject);
var SList:TStringList;
begin
  if dOPCSelectDAServerDlg(OPCServerMy) then begin
    DisConnectToOPC();
    SList:=TStringList.Create;
    SList.LoadFromFile(ExtractFileDir(ParamStr(0))+'\db.cfg');
    SList[0]:='OPC='+OPCServerMy.ServerCaption+';';
    SList.SaveToFile(ExtractFileDir(ParamStr(0))+'\db.cfg');
    OPCServerName:=OPCServerMy.ServerCaption;
    ConnectToOPC();
  end;
end;

procedure TForm1.Timer2Timer(Sender: TObject);
begin
  if GlobalTagsName.Text<>'' then begin
    try
      ADOQuery1.Active:=false;ADOQuery1.SQL.Clear;
      ADOQuery1.SQL.AddStrings(GlobalTagsName);
      ADOQuery1.ExecSQL;
      GlobalTagsName.Clear;
      Memo1.Lines.Add(FormatDateTime('yyyy/mm/dd hh:mm:ss',now)+' Данные переданы в БД');
      CheckLimit(Memo1.Lines,1024);
    except on E : Exception do begin
        Memo1.Lines.Add(FormatDateTime('yyyy/mm/dd hh:mm:ss',now)+' Ошибка соединения с базой: '+E.Message);
        CheckLimit(Memo1.Lines,1024);
        ADOQuery1.Destroy;
        ADOQuery1:=TADOQuery.Create(self);
        ADOQuery1.ConnectionString:=ConStr;
        ADOQuery1.ParamCheck:=false;
      end;
    end;
  end;
end;

end.
