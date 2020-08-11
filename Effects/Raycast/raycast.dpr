program RayCast;

uses
  Forms,
  f_Main in 'f_Main.pas' {RaycastForm},
  u_Graph in 'u_Graph.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TRaycastForm, RaycastForm);
  Application.Run;
end.
