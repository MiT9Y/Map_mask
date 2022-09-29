unit UserAccess;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DB, ADODB;

type
  TForm7 = class(TForm)
    Label1: TLabel;
    ComboBox1: TComboBox;
    Label2: TLabel;
    Edit1: TEdit;
    Button1: TButton;
    ADOQuery1: TADOQuery;
    procedure FormShow(Sender: TObject);
    procedure GetUsersList(Name: string);
    procedure ComboBox1KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ComboBox1KeyPress(Sender: TObject; var Key: Char);
    procedure Button1Click(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    UserName:string;
    { Private declarations }
  public
    UserAccess:boolean;
    { Public declarations }
  end;

var
  Form7: TForm7;

implementation

uses Main;

{$R *.dfm}

procedure TForm7.GetUsersList(Name: string);
begin
  try
    ADOQuery1.Active:=false;
    ADOQuery1.SQL.Clear;
    ADOQuery1.SQL.Add('Select [Name] from [Users] where [Name] like '+chr(39)+Name+'%'+chr(39)+' order by [Name]');
    ADOQuery1.Active:=true;
    ComboBox1.Items.Clear;
    if ADOQuery1.RecordCount>0 then ComboBox1.Text:=ADOQuery1.Fields[0].AsString else ComboBox1.Text:=Name;
    while not(ADOQuery1.Eof) do begin
      ComboBox1.Items.Add(ADOQuery1.Fields[0].AsString);
      ADOQuery1.Next;
    end;
  except
    ADOQuery1.Destroy;
    ADOQuery1:=TADOQuery.Create(self);
    ADOQuery1.ConnectionString:=Form1.ConStr;
  end;
  ComboBox1.SetFocus();
  ComboBox1.SelStart := Length(Name);
  ComboBox1.SelLength := Length(ComboBox1.Text) - ComboBox1.SelStart;
end;

procedure TForm7.FormShow(Sender: TObject);
var Width, Height: Integer;
begin
  UserName:='';
  UserAccess:=false;
  Width:=GetDeviceCaps(GetDC(0),HORZRES);
  Height:=GetDeviceCaps(GetDC(0),VERTRES);
  Self.Left:=round((Width-Self.Width)/2);
  Self.Top:=round((Height-Self.Top)/2);
  ComboBox1.Text:='';
  Edit1.Text:='';
  GetUsersList(UserName);
end;

procedure TForm7.ComboBox1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
  var st:string;
begin
  GetUsersList(UserName);
end;

procedure TForm7.ComboBox1KeyPress(Sender: TObject; var Key: Char);
  var st:string;
begin
  if (Ord(Key)=8) and (Length(UserName)>0) then SetLength(UserName,Length(UserName)-1);
  if not((Ord(Key)=8) or (Ord(Key)=13)) then UserName:=UserName+Key;
  if Ord(Key)=13 then Button1Click(Form7);
end;

procedure TForm7.Button1Click(Sender: TObject);
begin
  Self.Caption:=ComboBox1.Text+','+Edit1.Text;
  try
    ADOQuery1.Active:=false;
    ADOQuery1.SQL.Clear;
    ADOQuery1.SQL.Add('Select [id], [Password], HASHBYTES('+chr(39)+'MD5'+chr(39)+','+chr(39)+Edit1.Text+chr(39)+') '+
                      'from [Users] where [Name] = '+chr(39)+ComboBox1.Text+chr(39));
    ADOQuery1.Active:=true;
    if ADOQuery1.RecordCount>0 then begin
      Form1.UserID := ADOQuery1.Fields[0].AsInteger;
      if ADOQuery1.Fields[1].AsString = ADOQuery1.Fields[2].AsString then begin UserAccess:=true; Self.Close; end
      else ShowMessage('Пароль введён не верно.');
    end else ShowMessage('Пользователь не найден.');
  except
    ADOQuery1.Destroy;
    ADOQuery1:=TADOQuery.Create(self);
    ADOQuery1.ConnectionString:=Form1.ConStr;
  end;
end;

procedure TForm7.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if Ord(Key)=13 then Button1Click(Form7);
end;

procedure TForm7.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if not(UserAccess) then
    if MessageDlg('Авторизация не выполнена, закрыть программу?', mtConfirmation, [mbOk, mbCancel], 0) = mrCancel then
      Action := caNone else Form1.Close;
end;

end.
