unit OpcServerUnit;

interface

uses
  SysUtils, Classes, prOpcServer, prOpcTypes, prOpcClient, ADODB;

type
  TCROPC = class(TOpcItemServer)
  private
  protected
    function Options: TServerOptions; override;
  public
//    rNode:TItemIdList;
    procedure ListItemIds(List: TItemIDList); override;
    function GetItemInfo(const ItemID: String; var AccessPath: string; var AccessRights: TAccessRights): Integer; override;
    function GetItemValue(ItemHandle: TItemHandle; var Quality: Word): OleVariant; override;
    procedure SetItemValue(ItemHandle: TItemHandle; const Value: OleVariant); override;
  end;

var CROPC:TCROPC;

implementation
uses
  prOpcError, Windows, Main, Variants;


procedure TCROPC.ListItemIDs(List: TItemIDList);
var i:integer;
begin
  for i:=0 to length(Form1.OPCTags)-1 do
    if Form1.SQLvsTree[Form1.OPCTags[i].i].Sensors[Form1.OPCTags[i].j].Broadcast then
        List.AddItemId(Form1.OPCTags[i].Name, AllAccess, varVariant);
end;

function TCROPC.Options: TServerOptions;
begin
  Result:= [soHierarchicalBrowsing, soAlwaysAllocateErrorArrays]
end;

function TCROPC.GetItemInfo(const ItemID: String; var AccessPath: string;
       var AccessRights: TAccessRights): Integer;
var i:Integer;
    e:boolean;
begin
  e:=true;

  for i:=0 to length(Form1.OPCTags)-1 do
    if Form1.SQLvsTree[Form1.OPCTags[i].i].Sensors[Form1.OPCTags[i].j].Broadcast then
        if SameText(ItemID, Form1.OPCTags[i].Name) then begin
          Result:=i;
          e:=false;
        end;

  if e then raise EOpcError.Create(OPC_E_INVALIDITEMID);
end;

function TCROPC.GetItemValue(ItemHandle: TItemHandle;
                           var Quality: Word): OleVariant;
begin
  if (ItemHandle>=0)and(ItemHandle<=length(Form1.OPCTags)-1) then begin
    Quality:=192; Result:=Form1.SQLvsTree[Form1.OPCTags[ItemHandle].i].Sensors[Form1.OPCTags[ItemHandle].j].OPCValue;
  end else raise EOpcError.Create(OPC_E_INVALIDHANDLE);
end;

procedure TCROPC.SetItemValue(ItemHandle: TItemHandle; const Value: OleVariant);
var err:boolean;
    varstr:string;
    idSens:integer;
begin
  err:=True;
  varstr:=VarAsType(Value, varString);
  if (ItemHandle>=0)and(ItemHandle<=length(Form1.OPCTags)-1) then begin
      if Form1.SQLvsTree[Form1.OPCTags[ItemHandle].i].Sensors[Form1.OPCTags[ItemHandle].j].TypeMes=4 then begin
        try
          form1.ADOQueryOPC.Active:=false;
          form1.ADOQueryOPC.SQL.Clear;
          form1.ADOQueryOPC.SQL.Add('insert into BufferWriteTag (Value, TagName) values ('+chr(39)+varstr+chr(39)+
                                    ', '+chr(39)+Form1.SQLvsTree[Form1.OPCTags[ItemHandle].i].Sensors[Form1.OPCTags[ItemHandle].j].TagName+chr(39)+')');
          form1.ADOQueryOPC.ExecSQL;
          err:=false;
        except
          form1.ADOQueryOPC.Destroy;
          form1.ADOQueryOPC:=TADOQuery.Create(form1);
          form1.ADOQueryOPC.ConnectionString:=form1.ConStr;
        end;
      end;
      if Form1.SQLvsTree[Form1.OPCTags[ItemHandle].i].Sensors[Form1.OPCTags[ItemHandle].j].TypeMes=5 then begin
        try
          idSens:= Form1.SQLvsTree[Form1.OPCTags[ItemHandle].i].Sensors[Form1.OPCTags[ItemHandle].j].id_sens;
          form1.ADOQueryOPC.Active:=false;
          form1.ADOQueryOPC.SQL.Clear;
          form1.ADOQueryOPC.SQL.Add('update Measure_Period set Period = '+varstr+', LastUpdate = getdate() where id = '+VarToStr(idSens)+
                                    ' DECLARE @idSens int, @TN varchar(512), @TV varchar(256), @TS datetime '+
                                    'DECLARE @NewValue varchar(256), @Status int '+
                                    'SET @idSens = '+VarToStr(idSens)+' '+
                                    'select top 1 @TN = TagName, @TV = [Value],  @TS = TagTimeStamp from [dbo].[BufferVectorTag] '+
                                    'where TagName = (select top 1 TagName from [dbo].[Sensors] where id = @idSens) '+
                                    'exec [GetAndSetSensorValueAndStatus] @TN, @TV, @TS, @idSens, @NewValue OUTPUT, @Status OUTPUT'
          );
          form1.ADOQueryOPC.ExecSQL;
          err:=false;
        except
          form1.ADOQueryOPC.Destroy;
          form1.ADOQueryOPC:=TADOQuery.Create(form1);
          form1.ADOQueryOPC.ConnectionString:=form1.ConStr;
        end;
      end;
    end;
  if err then raise EOpcError.Create(OPC_E_INVALIDHANDLE);
end;

const
  ServerGuid: TGUID = '{b40dcdc8-2874-434a-8df1-af72fd646020}';
  ServerVersion = 2;
  ServerDesc = 'CopyReading OPC Server by Chmyhov';
  ServerVendor = 'Bryansk_Obl_Gaz';

initialization
  CROPC:=TCROPC.Create;
  RegisterOPCServer(ServerGUID, ServerVersion, ServerDesc, ServerVendor, CROPC)
end.
