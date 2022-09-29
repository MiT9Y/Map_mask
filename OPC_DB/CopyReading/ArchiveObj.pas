unit ArchiveObj;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls, DB, ADODB, Menus, Clipbrd;

type
  TForm6 = class(TForm)
    StringGrid1: TStringGrid;
    ADOQuery1: TADOQuery;
    PopupMenu1: TPopupMenu;
    R1: TMenuItem;
    K1: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    procedure FormShow(Sender: TObject);
    procedure StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure StringGrid1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure OnClickPMenu (Sender: TObject);
    procedure StringGrid1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    ObjName: string;
    SensName: array of record
                idSens:integer;
                Name,Ed:string;
                visible, enable:boolean;
              end;
    Data:array of array of string;
    { Public declarations }
  end;

  TErrorGrid = class
    Arr:array of record
                   Col,Row:integer;
                   Status:Byte;
                 end;
    Constructor Create;
    Destructor Destroy;
    procedure AddCell(Col,Row:integer; St:byte);
    function GetStatus(Col,Row:integer):byte;
  end;

var
  Form6: TForm6;
  ErrorGrid1: TErrorGrid;
  Px,Py:integer;

implementation

uses Main;

{$R *.dfm}

    procedure CopyStringToClipboard(const Value: String);
    const
      RusLocale = (SUBLANG_DEFAULT shl $A) or LANG_RUSSIAN;
    var
      hMem: THandle;
      pData: Pointer;
    begin
      Clipboard.Open;
      try
        Clipboard.AsText := '';
        Clipboard.AsText := Value;
        hMem := GlobalAlloc(GMEM_MOVEABLE, SizeOf(DWORD));
        try
          pData := GlobalLock(hMem);
          try
            DWORD(pData^) := RusLocale;
          finally
            GlobalUnlock(hMem);
          end;
            Clipboard.SetAsHandle(CF_LOCALE, hMem);
        finally
          GlobalFree(hMem);
        end;
      finally
        Clipboard.Close;
      end;
      Clipboard.Destroy;
    end;

procedure TForm6.FormShow(Sender: TObject);
var i,j:integer;
    idSens:integer;
    Name,Ed:string;
    ResStr:string;
    TTMin,TTMax:TDateTime;
    History_Sens_id:string;
begin
  ErrorGrid1:= TErrorGrid.Create;
  Left:=0; Top:=0;
  self.Caption:='Архивные данные по объекту: '+ ObjName;
  self.WindowState:=wsMaximized;
  StringGrid1.ColCount:=1;StringGrid1.RowCount:=2;
  try
    ADOQuery1.Active:=false;
    ADOQuery1.SQL.Clear;
    ADOQuery1.SQL.Add('select top 1 id from [dbo].[YearArchive] order by id desc');
    ADOQuery1.Active:=true;
    History_Sens_id:=ADOQuery1.Fields[0].AsString;
  except
    ADOQuery1.Destroy;
    ADOQuery1:=TADOQuery.Create(self);
    ADOQuery1.ConnectionString:=Form1.ConStr;
  end;

  try
    ADOQuery1.Active:=false;
    ADOQuery1.SQL.Clear;
    ADOQuery1.SQL.Add('select Sensors.id, Name, '+
                      '(select top 1 Shorten from dbo.Ed where Ed.id = (select top 1 Ed from dbo.TypeSens where TypeSens.id=(select top 1 id_typeSens from dbo.Physical_Sensor where Physical_Sensor.id = Sensors.id_PSens)))'+
                      ', Enable from dbo.Sensors where '+
                      '(Sensors.id in (select idSens from dbo.History_Sens) or Sensors.id in (select idSens from dbo.History_Sens'+History_Sens_id+')) '+
                      'and Sensors.id_tree = (select top 1 dbo.TreeObj.id from dbo.TreeObj where Name = '+chr(39)+ObjName+chr(39)+') order by Name');
    ADOQuery1.Active:=true;
    StringGrid1.ColCount:=ADOQuery1.RecordCount+1;
    SetLength(SensName,ADOQuery1.RecordCount+1);
    SetLength(Data,ADOQuery1.RecordCount*2,1);
    SensName[0].idSens:=-1;
    SensName[0].Name:='TagTime';
    SensName[0].Ed:='Null';
    SensName[0].visible:=true;
    SensName[0].enable:=true;
    i:=1;
    while not(ADOQuery1.Eof) do begin
      Data[(i-1)*2,0]:=ADOQuery1.Fields[1].AsString+'('+ADOQuery1.Fields[2].AsString+')';
      Data[((i-1)*2)+1,0]:=ADOQuery1.Fields[1].AsString+'(Time)';
      SensName[i].idSens:=ADOQuery1.Fields[0].AsInteger;
      SensName[i].Name:=ADOQuery1.Fields[1].AsString;
      SensName[i].Ed:=ADOQuery1.Fields[2].AsString;
      SensName[i].visible:=true;
      SensName[i].enable:=ADOQuery1.Fields[3].AsBoolean;
      StringGrid1.Cols[i].Clear;
      ADOQuery1.Next;i:=i+1;
    end;
    for i:=0 to Length(SensName)-1 do begin
       StringGrid1.Cells[i,0]:=SensName[i].Name;
    end;
    ADOQuery1.Active:=false;
  except
    ADOQuery1.Destroy;
    ADOQuery1:=TADOQuery.Create(self);
    ADOQuery1.ConnectionString:=Form1.ConStr;
  end;

  try
    ResStr:='';
    ADOQuery1.Active:=false;
    ADOQuery1.SQL.Clear;
    ADOQuery1.SQL.Add('SELECT [idSens],[TagTime],[SensVal],[Status] FROM [dbo].[History_Sens] '+
                      'where [idSens] in (select id from dbo.Sensors where id_tree = (select top 1 id from dbo.TreeObj where Name = '+chr(39)+ObjName+chr(39)+')) '+
                      'UNION '+
                      'SELECT [idSens],[TagTime],[SensVal],[Status] FROM [dbo].[History_Sens'+History_Sens_id+'] '+
                      'where [idSens] in (select id from dbo.Sensors where id_tree = (select top 1 id from dbo.TreeObj where Name = '+chr(39)+ObjName+chr(39)+')) '+
                      'order by [TagTime] desc');
    ADOQuery1.Active:=true;
    i:=1;StringGrid1.Rows[i].Text:='';
    TTMin:=ADOQuery1.Fields[1].AsDateTime;TTMax:=ADOQuery1.Fields[1].AsDateTime;
    SetLength(Data,Length(Data),Length(Data[0])+1);
    while not(ADOQuery1.Eof) do begin
//      StringGrid1.Cells[0,i]:=ADOQuery1.Fields[1].AsString;
      for j:=0 to Length(SensName)-1 do begin
        if SensName[j].idSens=ADOQuery1.Fields[0].AsInteger then begin
          if Pos(SensName[j].Name, ResStr)>0 then begin
            SetLength(Data,Length(Data),Length(Data[0])+1);
            StringGrid1.Cells[0,i]:=DateTimeToStr(TTMin)+#13+DateTimeToStr(TTMax);
            i:=i+1;
            ResStr:='';
            StringGrid1.RowCount:=StringGrid1.RowCount+1;
            StringGrid1.Rows[i].Text:='';
            TTMin:=ADOQuery1.Fields[1].AsDateTime;TTMax:=ADOQuery1.Fields[1].AsDateTime;
            if SensName[j].Ed = '' then Data[(j-1)*2,i]:=ADOQuery1.Fields[2].AsString else
              Data[(j-1)*2,i]:=StringReplace(ADOQuery1.Fields[2].AsString,'.',',',[rfReplaceAll]);
            Data[((j-1)*2)+1,i]:=ADOQuery1.Fields[1].AsString;
            StringGrid1.Cells[j,i]:=ADOQuery1.Fields[2].AsString+' '+SensName[j].Ed+#13+ADOQuery1.Fields[1].AsString;
            if ADOQuery1.Fields[3].AsInteger = 1 then ErrorGrid1.AddCell(j,i,1);
            if ADOQuery1.Fields[3].AsInteger = 2 then ErrorGrid1.AddCell(j,i,2);
            if ADOQuery1.Fields[3].AsInteger = 4 then ErrorGrid1.AddCell(j,i,3);
            Break;
          end else ResStr:=ResStr+SensName[j].Name;
//          if SensName[j].enable=false then begin ErrorGrid1.AddCell(j,i,3); StringGrid1.Cells[j,i]:='Отключён' end
//          else begin
            if SensName[j].Ed = '' then Data[(j-1)*2,i]:=ADOQuery1.Fields[2].AsString else
              Data[(j-1)*2,i]:=StringReplace(ADOQuery1.Fields[2].AsString,'.',',',[rfReplaceAll]);
            Data[((j-1)*2)+1,i]:=ADOQuery1.Fields[1].AsString;
            StringGrid1.Cells[j,i]:=ADOQuery1.Fields[2].AsString+' '+SensName[j].Ed+#13+ADOQuery1.Fields[1].AsString;
            if ADOQuery1.Fields[3].AsInteger = 1 then ErrorGrid1.AddCell(j,i,1);
            if ADOQuery1.Fields[3].AsInteger = 2 then ErrorGrid1.AddCell(j,i,2);
            if ADOQuery1.Fields[3].AsInteger = 4 then ErrorGrid1.AddCell(j,i,3);
            if TTMin>ADOQuery1.Fields[1].AsDateTime then TTMin:=ADOQuery1.Fields[1].AsDateTime;
            if TTMax<ADOQuery1.Fields[1].AsDateTime then TTMax:=ADOQuery1.Fields[1].AsDateTime;
            Break;
//          end;
        end;
      end;
      ADOQuery1.Next;
      StringGrid1.Cells[0,i]:=DateTimeToStr(TTMin)+#13+DateTimeToStr(TTMax);
    end;
    ADOQuery1.Active:=false;
  except
    ADOQuery1.Destroy;
    ADOQuery1:=TADOQuery.Create(self);
    ADOQuery1.ConnectionString:=Form1.ConStr;
  end;
end;

procedure TForm6.StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
  var St:Byte;
  Format: Word;
  C: array[0..255] of Char;
begin
  Format:=DT_LEFT or DT_WORDBREAK;
  (Sender as TStringGrid).Canvas.FillRect(Rect);
  if ARow=0 then begin
//      StringGrid1.Canvas.FillRect(Rect);
      StringGrid1.Canvas.Font.Style:=[fsBold];
//      StringGrid1.Canvas.TextOut(Rect.Left+2, Rect.Top+4, StringGrid1.Cells[ACol, ARow]);
      StrPCopy(C,(Sender as TStringGrid).Cells[ACol,ARow]);
      DrawText((Sender as TStringGrid).Canvas.Handle,C,StrLen(C),Rect,Format);
      Exit;
  end;
  St:=ErrorGrid1.GetStatus(ACol,ARow);
  if St=1 then begin
//      StringGrid1.Canvas.FillRect(Rect);
      StringGrid1.Canvas.Font.Color:=clRed;
      StringGrid1.Canvas.Font.Style:=[fsBold];
//      StringGrid1.Canvas.TextOut(Rect.Left, Rect.Top, StringGrid1.Cells[ACol, ARow]); //Текст
  end;
  if St=2 then begin
//      StringGrid1.Canvas.FillRect(Rect);
      StringGrid1.Canvas.Font.Color:=clOlive;
      StringGrid1.Canvas.Font.Style:=[fsBold];
//      StringGrid1.Canvas.TextOut(Rect.Left, Rect.Top, StringGrid1.Cells[ACol, ARow]); //Текст
  end;
  if St=3 then begin
//      StringGrid1.Canvas.FillRect(Rect);
      StringGrid1.Canvas.Font.Color:=clDkGray;
      StringGrid1.Canvas.Font.Style:=[fsBold];
//      StringGrid1.Canvas.TextOut(Rect.Left, Rect.Top, StringGrid1.Cells[ACol, ARow]); //Текст
  end;
  StrPCopy(C,(Sender as TStringGrid).Cells[ACol,ARow]);
  DrawText((Sender as TStringGrid).Canvas.Handle,C,StrLen(C),Rect,Format);
end;

{ TErrorGrid }

procedure TErrorGrid.AddCell(Col, Row: integer; St:byte);
var i:integer;
begin
  if Arr = Nil then begin i:=0; SetLength(Arr,i+1); end
               else begin i:=Length(Arr); SetLength(Arr,i+1); end;
  Arr[i].Col:=Col;
  Arr[i].Row:=Row;
  Arr[i].Status:=St;
end;

function TErrorGrid.GetStatus(Col, Row: integer):byte;
var i:integer;
    Res:byte; //статус 0 - норма, 1 - Авария, 2 - границы датчика, 3 - датчик отключён;
begin
  Res:=0;
  for i:=0 to Length(Arr)-1 do begin
    if (Arr[i].Col=Col) and (Arr[i].Row=Row) then begin Res:=Arr[i].Status; Break; end;
  end;
  Result:=Res;
end;

constructor TErrorGrid.Create;
begin
  inherited;
  Arr:=Nil;
end;

destructor TErrorGrid.Destroy;
begin
  Arr:=Nil;
  inherited;
end;

procedure TForm6.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ErrorGrid1.Free;
end;

procedure TForm6.StringGrid1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var P: TPoint;
    Items:array of TMenuItem;
    i:integer;
begin
  P:=GetClientOrigin;
  if Button = mbRight then begin
    Px:=X+P.X+StringGrid1.Left;
    Py:=Y+P.Y+StringGrid1.Top;

    PopupMenu1.Items.Clear;
    SetLength(Items,Length(SensName)+5);

    Items[0]:=TMenuItem.Create(Self);
    Items[0].Caption:='Выбор видимости';
    Items[0].OnClick:=OnClickPMenu;
    Items[1]:=TMenuItem.Create(Self);
    Items[1].Caption:='-';
    Items[1].OnClick:=OnClickPMenu;
    for i:=0 to Length(SensName)-1 do begin
      Items[2+i]:=TMenuItem.Create(Self);
      Items[2+i].Caption:=SensName[i].Name;
      Items[2+i].Checked:=SensName[i].visible;
      Items[2+i].OnClick:=OnClickPMenu;
    end;
    Items[2+i]:=TMenuItem.Create(Self);
    Items[2+i].Caption:='-';
    Items[2+i].OnClick:=OnClickPMenu;
    Items[3+i]:=TMenuItem.Create(Self);
    Items[3+i].Caption:='Копировать';
    Items[3+i].OnClick:=OnClickPMenu;
    Items[4+i]:=TMenuItem.Create(Self);
    Items[4+i].Caption:='Принять';
    Items[4+i].OnClick:=OnClickPMenu;
    PopupMenu1.Items.Add(Items);
    PopupMenu1.Popup(Px,Py);
  end;
end;

procedure TForm6.OnClickPMenu(Sender: TObject);

var S:TMenuItem;
    i,j,a,b:integer;
    ResSt:string;
    St:String;

begin
  S:=(Sender as TMenuItem);
  if S.Checked then S.Checked:=false else S.Checked:=true;
  if S.Caption='Выбор видимости' then S.Checked:=false;
  if S.Caption='Копировать' then begin
{    for i:=StringGrid1.Selection.Top to StringGrid1.Selection.Bottom do
      St:=St+StringGrid1.Rows[i].Text;}
    St:='';
    for j:=0 to Length(Data)-1 do if SensName[trunc(j/2)+1].visible then St:=St+Data[j,0]+#9;
    St:=St+#13;
    for i:=StringGrid1.Selection.Top to StringGrid1.Selection.Bottom do begin
      for j:=0 to Length(Data)-1 do if SensName[trunc(j/2)+1].visible then St:=St+Data[j,i]+#9;
      St:=St+#13;
    end;
    CopyStringToClipboard(St);
  end;
  if not((S.Caption='Принять') or (S.Caption='Копировать')) then PopupMenu1.Popup(Px,Py)
  else begin
    for i:=2 to Length(SensName)+1 do begin
      SensName[i-2].visible:=PopupMenu1.Items.Items[i].Checked;
      if SensName[i-2].visible then StringGrid1.ColWidths[i-2]:=120 else StringGrid1.ColWidths[i-2]:=-1;
      for a:=0 to StringGrid1.RowCount-1 do begin
        ResSt:='';
        for b:=0 to StringGrid1.ColCount-1 do
          if StringGrid1.ColWidths[b]<>-1 then ResSt:=ResSt+StringGrid1.Cells[b,a];
        if ResSt='' then StringGrid1.RowHeights[a]:=-1 else StringGrid1.RowHeights[a]:=30;
      end;
    end;
  end;
end;

procedure TForm6.StringGrid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
  var St:String;
  i,j:integer;
begin
  if ([ssCtrl] = Shift) and ((Key = Ord('c')) or (Key = Ord('C'))) then begin
    St:='';
    for j:=0 to Length(Data)-1 do if SensName[trunc(j/2)+1].visible then St:=St+Data[j,0]+#9;
    St:=St+#13;
    for i:=StringGrid1.Selection.Top to StringGrid1.Selection.Bottom do begin
      for j:=0 to Length(Data)-1 do if SensName[trunc(j/2)+1].visible then St:=St+Data[j,i]+#9;
      St:=St+#13;
    end;
    CopyStringToClipboard(St);
  end;
end;

end.
