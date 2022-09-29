program CopyReading;

uses
  Forms,
  Main in 'Main.pas' {Form1},
  OpcServerUnit in 'OpcServerUnit.pas',
  Sensors in 'Sensors.pas' {Form2},
  Choose in 'Choose.pas' {Form3},
  CopyObj in 'CopyObj.pas' {Form4},
  AddPSens in 'AddPSens.pas' {Form5},
  ArchiveObj in 'ArchiveObj.pas' {Form6},
  UserAccess in 'UserAccess.pas' {Form7};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm3, Form3);
  Application.CreateForm(TForm4, Form4);
  Application.CreateForm(TForm5, Form5);
  Application.CreateForm(TForm6, Form6);
  Application.CreateForm(TForm7, Form7);
  Application.Run;
end.
