program StarFlight;

uses
  Vcl.Forms,
  fStarFlight in 'fStarFlight.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormStarFlight, FormStarFlight);
  Application.Run;
end.
