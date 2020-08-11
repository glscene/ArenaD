program StereoRendering;

uses
  Forms,
  StereoFrm in 'StereoFrm.pas' {AaStereoForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TAaStereoForm, AaStereoForm);
  Application.Run;
end.
