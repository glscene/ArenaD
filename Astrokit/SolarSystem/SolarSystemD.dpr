program SolarSystemD;

uses
  Forms,
  fMainD in 'Source\fMainD.pas' {Form1},
  frParamsD in 'Source\frParamsD.pas' {FrameParams: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
