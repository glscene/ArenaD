program RelogioD;

uses
  Forms,
  fRelogioD in 'fRelogioD.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
