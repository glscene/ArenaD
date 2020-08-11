//
//Reflection Demo by Thor - Remaked by Ast (P&G3D)
//
program ReflectionDemo;

uses
  Forms,
  mainUnit in 'mainUnit.pas' {DemoFrm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TDemoFrm, DemoFrm);
  Application.Run;
end.
