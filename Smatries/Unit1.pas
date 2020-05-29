unit Unit1;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  GLWin32Viewer,
  GLScene,
  GLObjects,
  GLGeomObjects,
  GLCoordinates,
  GLCrossPlatform,
  GLBaseClasses, GLCadencer;

type
  TForm1 = class(TForm)
    GLScene1: TGLScene;
    GLSceneViewer1: TGLSceneViewer;
    GLCamera1: TGLCamera;
    GLLightSource1: TGLLightSource;
    DummyCube1: TGLDummyCube;
    Cyl: TGLCylinder;
    Timer1: TTimer;
    oeil1: TGLSphere;
    oeil2: TGLSphere;
    Tete: TGLSphere;
    Cone1: TGLCone;
    cheveu1: TGLCylinder;
    levres: TGLTorus;
    Sourcil1: TGLTorus;
    Pupil1: TGLSphere;
    Pupil2: TGLSphere;
    Panel1: TPanel;
    GLCadencer1: TGLCadencer;
    rgRotationAngle: TRadioGroup;
    procedure GLSceneViewer1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure GLSceneViewer1MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure Timer1Timer(Sender: TObject);
    procedure GLCadencer1Progress(Sender: TObject; const deltaTime,
      newTime: Double);
    procedure rgRotationAngleClick(Sender: TObject);
  public
    mx, my: single;
    dx: single;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.GLCadencer1Progress(Sender: TObject; const deltaTime,
  newTime: Double);
begin
  GLsceneViewer1.Invalidate;
  DummyCube1.Turn(deltaTime*40);
end;

procedure TForm1.GLSceneViewer1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  mx := X;
  my := Y;
end;

procedure TForm1.GLSceneViewer1MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if ssleft in Shift then
    GLCamera1.MoveAroundTarget(my - Y, mx - X);
  mx := X;
  my := Y;
end;

procedure TForm1.rgRotationAngleClick(Sender: TObject);
begin
  case rgRotationAngle.ItemIndex of
    0: begin
         DummyCube1.Turn(0);
         DummyCube1.PitchAngle := 0.0;
         DummyCube1.RollAngle := 0.0;
         DummyCube1.TurnAngle := 0.0;
         DummyCube1.Up.X := 0;  DummyCube1.Up.Y := 1; DummyCube1.Up.Z := 0;
         DummyCube1.Direction.X := 0;
         DummyCube1.Direction.Y := 0;
         DummyCube1.Direction.Z := 1;
         Tete.Material.FrontProperties.Emission.AsWinColor := RGB(151, 119, 0);
       end;
    1: begin
         DummyCube1.TurnAngle := 0;
         Tete.Material.FrontProperties.Emission.AsWinColor := RGB(8, 140, 0);
       end;
    2: begin
         DummyCube1.PitchAngle := 0;
         Tete.Material.FrontProperties.Emission.AsWinColor := RGB(160, 0, 0);
       end;
    3: begin
         DummyCube1.RollAngle := 0;
         Tete.Material.FrontProperties.Emission.AsWinColor := RGB(34, 79, 198);
       end;
  end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  Cyl.Scale.X := 1 + 0.7 * sin(GetTickCount / 120);
  Cyl.Scale.Z := 1 + 0.5 * sin(GetTickCount / 140);
  oeil1.Scale.Y := 1 + 0.4 * sin(GetTickCount / 400);
  oeil1.Scale.Z := 1 + 0.4 * sin(GetTickCount / 430);
  oeil2.Scale.Y := 1 + 0.4 * sin(GetTickCount / 400);
  oeil2.Scale.Z := 1 + 0.4 * sin(GetTickCount / 430);
  Pupil1.Scale.Y := 1 + 0.4 * sin(GetTickCount / 430);
  Pupil1.Scale.Z := 1 + 0.4 * sin(GetTickCount / 400);
  Pupil2.Scale.Y := 1 + 0.4 * sin(GetTickCount / 430);
  Pupil2.Scale.Z := 1 + 0.4 * sin(GetTickCount / 400);

  case rgRotationAngle.ItemIndex of
    0: DummyCube1.Turn(0);
    1: DummyCube1.TurnAngle := GetTickCount * 0.1;
    2: DummyCube1.PitchAngle := GetTickCount * 0.1;
    3: DummyCube1.RollAngle := GetTickCount * 0.1;
  end;


end;

end.
