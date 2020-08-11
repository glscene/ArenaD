program FireFlows;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  Uplasma in 'Uplasma.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
