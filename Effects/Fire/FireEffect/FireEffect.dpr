// MRQZZZ 5/5/2003
// simple "flame" test
// using "TFireFxDummyCubeBase" in "UFireFxBase" class
program FireEffect;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  UFireFxBase in 'UFireFxBase.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
