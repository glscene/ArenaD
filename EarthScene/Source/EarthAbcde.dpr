program EarthAbcde;

uses
  Forms,
  FABCreator in 'FABCreator.pas' {ABCreatorFrm},
  USahObjects in 'USahObjects.pas',
  USolarSystem in 'USolarSystem.pas' {,
  UGLImposter in 'UGLImposter.pas'};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Earth Creator';
  Application.CreateForm(TABCreatorFrm, ABCreatorFrm);
  Application.Run;
end.
