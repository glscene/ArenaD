program EarthPilot;

{$R *.dres}

uses
  Forms,
  uGlobals in 'uGlobals.pas',
  FSkyPilot in 'FSkyPilot.pas' {SkyPilotFrm};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'SkyPilot';
  Application.CreateForm(TSkyPilotFrm, SkyPilotFrm);
  Application.Run;
end.
