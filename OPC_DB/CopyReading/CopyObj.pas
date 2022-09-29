unit CopyObj;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, DB, ADODB, Menus, CLIPBrd;

type
  TForm4 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    CheckBox1: TCheckBox;
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Edit3: TEdit;
    Button2: TButton;
    CheckBox2: TCheckBox;
    Edit4: TEdit;
    ListView1: TListView;
    ADOQuery1: TADOQuery;
    ADOQuery2: TADOQuery;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
  private
    procedure CreateParams(var Params: TCreateParams); override;
    { Private declarations }
  public
    id_tree_sour,id_tree_dest:integer;
    tree_dest:TTreeNode;
    { Public declarations }
  end;

var
  Form4: TForm4;

implementation

uses Main;

{$R *.dfm}

procedure TForm4.CreateParams(var Params: TCreateParams);
begin
  inherited;
  with Params do ExStyle := ExStyle or WS_EX_APPWINDOW;
end;

procedure TForm4.FormShow(Sender: TObject);
begin
  Form1.RunForm4:=true;
  Edit4.Text:='Выберите объект в основной форме...';
  ListView1.Items.Clear;
  Edit1.Text:='%';
  CheckBox1.Checked:=true;
  CheckBox2.Checked:=false;
  Edit2.Text:='';
  Edit3.Text:='';
end;

procedure TForm4.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Form1.RunForm4:=false;
end;

procedure TForm4.Button1Click(Sender: TObject);
var i:integer;
begin
  try
    ADOQuery1.Active:=false;
    ADOQuery1.SQL.Clear;
    ADOQuery1.SQL.Add('SELECT TagName,[Value] FROM [BufferVectorTag] where TagName like '+chr(39)+Edit1.Text+chr(39));
    ADOQuery1.Active:=true;
    ListView1.Items.Clear;
    i:=0;
    while not(ADOQuery1.Eof) do begin
      ListView1.Items.Add;
      ListView1.Items[i].Caption:=ADOQuery1.Fields[0].AsString;
      ListView1.Items[i].SubItems.Add(ADOQuery1.Fields[1].AsString);
      i:=i+1;
      ADOQuery1.Next;
    end;
  except
    ADOQuery1.Destroy;
    ADOQuery1:=TADOQuery.Create(self);
    ADOQuery1.ConnectionString:=Form1.ConStr;
  end;
end;

procedure TForm4.Button2Click(Sender: TObject);
var NewTagName:string;
  procedure FoundCopyTagName(str,old_like,new_like:string; var NTagName:string);
  begin
    NTagName:='';
    try
      ADOQuery2.Active:=false;
      ADOQuery2.SQL.Clear;
      ADOQuery2.SQL.Add('SELECT TagName FROM Sensors where [Name] = '+chr(39)+str+chr(39)+' and id_tree='+inttostr(id_tree_sour));
      ADOQuery2.Active:=true;
      if ADOQuery2.RecordCount>0 then NTagName:=StringReplace(ADOQuery2.Fields[0].AsString,old_like,new_like,[]);
    Except
      ADOQuery2.Destroy;
      ADOQuery2:=TADOQuery.Create(self);
      ADOQuery2.ConnectionString:=Form1.ConStr;
    end;
  end;

begin
  if Edit4.Text='Выберите объект в основной форме...' then ShowMessage('Не выбран источник') else begin
  try
    ADOQuery1.Active:=false;
    ADOQuery1.SQL.Clear;
    ADOQuery1.SQL.Add('EXEC CopyObject '+inttostr(id_tree_sour)+', '+inttostr(id_tree_dest)+', '+BoolToStr(CheckBox2.Checked));
    ADOQuery1.ExecSQL;

    if CheckBox1.Checked then begin
      ADOQuery1.SQL.Clear;
      ADOQuery1.SQL.Add('select id, Name from Sensors where TagName is null and id_tree='+inttostr(id_tree_dest));
      ADOQuery1.Active:=true;
      while not(ADOQuery1.Eof) do begin
        FoundCopyTagName(ADOQuery1.Fields[1].AsString,Edit2.Text,Edit3.Text,NewTagName);
        if NewTagName<>'' then begin
          try
            ADOQuery2.Active:=false;
            ADOQuery2.SQL.Clear;
            ADOQuery2.SQL.Add('UPDATE Sensors SET TagName = '+chr(39)+NewTagName+chr(39)+' WHERE id = '+ ADOQuery1.Fields[0].AsString);
            ADOQuery2.ExecSQL;
            ADOQuery2.Active:=false;
            ADOQuery2.SQL.Clear;
            ADOQuery2.SQL.Add('DECLARE @idSens int, @TN varchar(512), @TV varchar(256), @TS datetime '+
                        'DECLARE @NewValue varchar(256), @Status int '+
                        'SET @idSens = '+ADOQuery1.Fields[0].AsString+' '+
                        'select top 1 @TN = TagName, @TV = [Value],  @TS = TagTimeStamp from [dbo].[BufferVectorTag] '+
                        'where TagName = (select top 1 TagName from [dbo].[Sensors] where id = @idSens) '+
                        'exec [GetAndSetSensorValueAndStatus] @TN, @TV, @TS, @idSens, @NewValue OUTPUT, @Status OUTPUT');
            ADOQuery2.ExecSQL;
          except
            ADOQuery2.Destroy;
            ADOQuery2:=TADOQuery.Create(self);
            ADOQuery2.ConnectionString:=Form1.ConStr;
          end;
        end;
        ADOQuery1.Next;
      end;
    end;
  except
    ADOQuery1.Destroy;
    ADOQuery1:=TADOQuery.Create(self);
    ADOQuery1.ConnectionString:=Form1.ConStr;
  end;
  Form1.TreeView1.Selected:=tree_dest;
  Form1.Button1Click(form1);
  close;
  end;
end;

procedure TForm4.N1Click(Sender: TObject);
begin
  if ListView1.Selected<>nil then
    Clipboard.AsText:=ListView1.Selected.Caption;
end;

end.
