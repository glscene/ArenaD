unit Main;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Classes,
  System.Math,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.Buttons,
  Vcl.ComCtrls,
  Vcl.ExtCtrls,
  Vcl.StdCtrls,
  Vcl.Imaging.Jpeg,

  GLS.VectorTypes,
  GLS.Scene,
  GLS.Objects,
  GLS.Cadencer,
  GLS.VectorFileObjects,
  GLS.Keyboard,
  GLS.VectorGeometry,
  GLS.Texture,
  GLS.SceneViewer,
  GLS.Behaviours,
  GLS.FireFX,
  GLS.GeomObjects,
  GLS.FileMD2,
  GLS.HUDObjects,
  GLS.BitmapFont,
  GLS.WindowsFont,
  GLS.Coordinates,
  
  GLS.BaseClasses;

type
  TForm1 = class(TForm)
    GLCadencer1: TGLCadencer;
    GLSceneViewer1: TGLSceneViewer;
    GLScene1: TGLScene;
    GLLightSource1: TGLLightSource;
    GLCamera1: TGLCamera;
    Actor1: TGLActor;
    ActorCube: TGLDummyCube;
    CameraCube: TGLDummyCube;
    Esfera: TGLSphere;
    EnemyCube: TGLDummyCube;
    Actor2: TGLActor;
    CentroCube: TGLDummyCube;
    AnguloCube: TGLDummyCube;
    Walls: TGLCylinder;
    Ground: TGLDisk;
    GLFireFXManager1: TGLFireFXManager;
    ScreenFont: TGLWindowsBitmapFont;
    Help: TGLHUDText;
    Button1: TButton;
    procedure HandleKeys(const deltaTime: Double);
    procedure GLCadencer1Progress(Sender: TObject;
      const deltaTime, newTime: Double);
    procedure FormCreate(Sender: TObject);
    procedure GLSceneViewer1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure GLSceneViewer1MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure ActorDo(action: string; perform: Boolean);
    procedure Button1Click(Sender: TObject);
    procedure EsferaProgress(Sender: TObject; const deltaTime, newTime: Double);
  private
  end;

var
  Form1: TForm1;
  mx, my, mx2, my2: Integer;
  Dead: Boolean = False;
  Points: Integer = 10;

const
  HELP_TEXT = 'Use WASD keys to move'#13#10 + 'Use Ctrl key to attack';

implementation

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
begin
  SetCurrentDir(ExtractFilePath(ParamStr(0)));

  // loading the actor
  Actor1.LoadFromFile('.\Beast.md2');
  Actor1.Material.Texture.Image.LoadFromFile('.\Beast-ck.jpg');
  Actor1.Material.Texture.Disabled := False;
  Actor1.AnimationMode := aamLoop;
  Actor1.Scale.SetVector(0.05, 0.05, 0.05, 0);

  // loading the enemy
  Actor2.LoadFromFile('.\Mauler.md2');
  EnemyCube.PointTo(CentroCube, YHmgVector);
  Actor2.Material.Texture.Image.LoadFromFile('.\Mauler.jpg');
  Actor2.Material.Texture.Disabled := False;
  Actor2.Scale.SetVector(0.05, 0.05, 0.05, 0);
  Actor2.AnimationMode := aamLoop;
  Actor2.SwitchToAnimation('walk', True);

  Help.Text := HELP_TEXT;
end;

procedure TForm1.HandleKeys(const deltaTime: Double);
const
  cTurnSpeed = 100;
  cMoveSpeed = 9;
begin
  If not Dead then
  begin
    if IsKeyDown('a') or IsKeyDown(VK_LEFT) then
      ActorCube.Turn(-cTurnSpeed * deltaTime);
    if IsKeyDown('d') or IsKeyDown(VK_RIGHT) then
      ActorCube.Turn(cTurnSpeed * deltaTime);

    If IsKeyDown(VK_CONTROL) then
    begin
      // If not Esfera.Visible then
      begin
        Esfera.Position := ActorCube.Position;
        Esfera.Position.Y := 2;
        Esfera.Visible := True;
        ActorDo('attack', True);
      end;
    end
    else
      ActorDo('attack', False);

    if (IsKeyDown(VK_UP) or IsKeyDown(VK_DOWN)) or
       (IsKeyDown('w') or IsKeyDown('s')) then
    begin
      if (IsKeyDown(VK_UP)) or (IsKeyDown('w')) then
      begin
        ActorCube.Move(cMoveSpeed * deltaTime);
        If ActorCube.DistanceTo(CentroCube) > 23 then
        // check that one does not leave circle
          ActorCube.Move(-cMoveSpeed * deltaTime);
      end
      else
      begin
        ActorCube.Move(-cMoveSpeed * deltaTime);
        If ActorCube.DistanceTo(CentroCube) > 23 then
        // check that one does not leave circle
          ActorCube.Move(cMoveSpeed * deltaTime);
      end;
      CameraCube.Position := ActorCube.Position;
      ActorDo('walk', True);
    end
    else
      ActorDo('walk', False);

    if Actor2.Visible then
      if Actor1.DistanceTo(Actor2) < 4 then
      // checked that we do not hit the enemy
      begin
        if (Actor2.CurrentAnimation <> '2attack') then
        begin
          Actor2.SwitchToAnimation('2attack'); // enemy kills the small lizard
          Actor1.SwitchToAnimation('death');
          Actor1.AnimationMode := aamPlayOnce;
          TGLBInertia(CentroCube.Behaviours.Behaviour[0]).TurnSpeed := 0;
          TGLBInertia(AnguloCube.Behaviours.Behaviour[0]).TurnSpeed := 0;
        end;
        Dead := True;
      end
      else
        // if Esfera.Visible then
        if Actor2.DistanceTo(Esfera) < 3 then
        // checked if we already killed the enemy
        begin
          TGLBInertia(CentroCube.Behaviours.Behaviour[0]).TurnSpeed := 0;
          TGLBInertia(AnguloCube.Behaviours.Behaviour[0]).TurnSpeed := 0;
          GLFireFXManager1.RingExplosion(8, 10, 5, XVector, ZVector);
          Actor2.Visible := False;
          Points := Points + 10;
          Form1.Caption := 'Points: ' + inttostr(Points);
        end
        else if not(Actor2.CurrentAnimation = 'walk') then
          Actor2.SwitchToAnimation('walk');
  end;

  if ((mx <> mx2) or (my <> my2)) then
  begin
    GLCamera1.MoveAroundTarget(my - my2, mx - mx2);
    mx := mx2;
    my := my2;
  end;
end;

procedure TForm1.ActorDo(action: string; perform: Boolean);
begin
  if ((action <> Actor1.CurrentAnimation) and (perform = True)) then
    Actor1.SwitchToAnimation(action);
  if ((action = Actor1.CurrentAnimation) and (perform = False)) then
    Actor1.SwitchToAnimation('idle');
end;

procedure TForm1.GLCadencer1Progress(Sender: TObject;
  const deltaTime, newTime: Double);
begin
  HandleKeys(deltaTime);
end;

procedure TForm1.GLSceneViewer1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  mx := X;
  my := Y;
  mx2 := X;
  my2 := Y;
end;

procedure TForm1.GLSceneViewer1MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if ssLeft in Shift then
  begin
    mx2 := X;
    my2 := Y;
  end;
end;

procedure TForm1.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  GLCamera1.AdjustDistanceToTarget(Power(1.1, WheelDelta / 120));
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  if not Actor2.Visible then
    Actor2.Visible := True
  else
  begin
    Dead := False;
    Actor1.AnimationMode := aamLoop;
    Actor1.SwitchToAnimation('idle');
    ActorCube.Position.X := Random(20);
    ActorCube.Position.Z := Random(20);
  end;
  TGLBInertia(CentroCube.Behaviours.Behaviour[0]).TurnSpeed := 25;
  TGLBInertia(AnguloCube.Behaviours.Behaviour[0]).TurnSpeed := 50;
end;

procedure TForm1.EsferaProgress(Sender: TObject;
  const deltaTime, newTime: Double);
begin
  if Esfera.Visible then
  begin
    Esfera.Direction := ActorCube.Direction;
    If Esfera.DistanceTo(CentroCube) < 25 then
    begin
      Esfera.Move(3);
    end;
  end;
end;

end.
