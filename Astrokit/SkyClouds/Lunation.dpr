program Lunation;

uses
  Forms,
  fLunation in 'fLunation.pas' {FormLunation};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormLunation, FormLunation);
  Application.Run;
end.
