unit Choose;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Menus, DB, ADODB;

type
  TForm3 = class(TForm)
    Edit1: TEdit;
    Label1: TLabel;
    Button1: TButton;
    ListView1: TListView;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    ADOQuery1: TADOQuery;
    procedure N1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ListView1Change(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure ListView1DblClick(Sender: TObject);
  private
    { Private declarations }
  public
    sqltext:string;
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

uses Main, Sensors;

{$R *.dfm}

procedure TForm3.N1Click(Sender: TObject);
begin
  if ListView1.ItemFocused<>nil then begin
    if Caption= 'Поиск тегов' then begin
      Form2.Edit4.Text:=ListView1.ItemFocused.Caption;
      Form2.TagName:=ListView1.ItemFocused.Caption;
    end;
    if Caption= 'Поиск тегов исходные данные для фильтра' then begin
      Form2.Edit7.Text:=ListView1.ItemFocused.Caption;
      Form2.IDSensFiltr:=ListView1.ItemFocused.SubItems[1];
    end;
    Close;
  end;
end;

procedure TForm3.Button1Click(Sender: TObject);
var i:integer;
begin
  try
    ADOQuery1.Active:=false;
    ADOQuery1.SQL.Clear;
    if Caption= 'Поиск тегов' then ADOQuery1.SQL.Add(sqltext+' where TagName like '+chr(39)+Edit1.Text+chr(39));
    if Caption= 'Поиск тегов исходные данные для фильтра' then ADOQuery1.SQL.Add(sqltext+' and Name like '+chr(39)+Edit1.Text+chr(39));
    ADOQuery1.Active:=true;
    ListView1.Items.Clear;
    i:=0;
    while not(ADOQuery1.Eof) do begin
      ListView1.Items.Add;
      ListView1.Items[i].Caption:=ADOQuery1.Fields[0].AsString;
      ListView1.Items[i].SubItems.Add(ADOQuery1.Fields[1].AsString);
      ListView1.Items[i].SubItems.Add(ADOQuery1.Fields[2].AsString);
      i:=i+1;
      ADOQuery1.Next;
    end;
  except
    ADOQuery1.Destroy;
    ADOQuery1:=TADOQuery.Create(self);
    ADOQuery1.ConnectionString:=Form1.ConStr;
  end;
end;

procedure TForm3.FormShow(Sender: TObject);
begin
  Edit1.Text:='%';
  ListView1.Items.Clear;
end;

procedure TForm3.ListView1Change(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
//  if Item<>

end;

procedure TForm3.ListView1DblClick(Sender: TObject);
begin
  N1Click(Self);
end;

end.
