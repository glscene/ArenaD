program bubbles;

uses
  Forms,
  uMain in 'uMain.pas' {Form1},
  uVBOvni in 'uVBOvni.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
