unit umain;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Forms,
  Vcl.Imaging.jpeg,
  Vcl.Dialogs,
  Vcl.Controls,
   
  GLS.OpenGLTokens,
  GLS.VectorGeometry,
  GLS.VectorTypes,
  GLS.Cadencer,
  GLS.Material,
  GLS.SceneViewer,
  
  GLS.BaseClasses,
  GLS.Scene,
  GLS.AsyncTimer,
  GLS.Coordinates,
  GLS.Objects,
  GLS.Keyboard,
  GLS.VectorFileObjects,
  GLS.HUDObjects,
  GLS.FPSMovement,
  GLS.Navigator,
  GLS.File3DS,
  GLS.ShadowPlane;

type
  TForm1 = class(TForm)
    GLScene1: TGLScene;
    vp: TGLSceneViewer;
    MatLib: TGLMaterialLibrary;
    Cadencer: TGLCadencer;
    dc_cam: TGLDummyCube;
    cam: TGLCamera;
    AsyncTimer1: TGLAsyncTimer;
    ff_scn: TGLFreeForm;
    dc_world: TGLDummyCube;
    back: TGLHUDSprite;
    GLS.FPSMovementManager1: TGLS.FPSMovementManager;
    GLNavigator1: TGLNavigator;
    ff_mask: TGLFreeForm;
    ff_ani: TGLActor;
    light: TGLLightSource;
    GLShadowPlane1: TGLShadowPlane;
    dc_light: TGLDummyCube;
    light01: TGLLightSource;
    light02: TGLLightSource;
    procedure AsyncTimer1Timer(Sender: TObject);
    procedure CadencerProgress(Sender: TObject;
      const deltaTime, newTime: Double);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure vpMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  end;

var
  Form1: TForm1;

  m_pos: TPoint;
  m_turn: boolean;
  pl: TGLBFPSMovement;
  pl_dy: single;

implementation

{$R *.dfm}

// setup
//
procedure TForm1.FormCreate(Sender: TObject);
var
  m: TGLLibMaterial;
begin
  ff_scn.LoadFromFile('scn.3ds');
  ff_mask.LoadFromFile('mask.3ds');
  ff_mask.BuildOctree;

  ff_ani.LoadFromFile('ani.3ds');
  with ff_ani.Animations.Add do
  begin
    EndFrame := 99;
    name := 'ani';
  end;
  ff_ani.SwitchToAnimation('ani');
  pl := GetFPSMovement(dc_cam);
  m := MatLib.LibMaterialByName('fire');
  if m <> nil then
  begin
    m.Material.FrontProperties.Emission.SetColor(1, 1, 1, 1);
    m.Material.FrontProperties.Diffuse.SetColor(1, 1, 1, 1);
  end;
  vGLFile3DS_EnableAnimation := true;
end;

// cadProgress
//
procedure TForm1.CadencerProgress(Sender: TObject;
  const deltaTime, newTime: Double);
var
  spd: single;
  v: TVector;
begin
  back.Width := vp.Width + 2;
  back.Height := vp.Height + 2;
  back.Position.SetPoint(vp.Width div 2, vp.Height div 2, 0);

  if m_turn then
  begin
    with mouse.CursorPos do
    begin
      dc_cam.Turn((X - screen.Width div 2) * 0.2);
      cam.PitchAngle := ClampValue(cam.PitchAngle + (screen.Height div 2 - Y) *
        0.2, -90, 90);
    end;
    if not IsKeyDown(vk_lbutton) then
    begin
      m_turn := false;
      showCursor(true);
    end;
    SetCursorPos(screen.Width div 2, screen.Height div 2);
  end;
  spd := 100 * deltaTime;
  if IsKeyDown(vk_lshift) then
    spd := spd * 3;

  if IsKeyDown(ord('W')) or IsKeyDown(vk_up) then
    pl.MoveForward(-1 * spd);
  if IsKeyDown(ord('S')) or IsKeyDown(vk_down) then
    pl.MoveForward(0.85 * spd);
  if IsKeyDown(ord('A')) or IsKeyDown(vk_left) then
    pl.StrafeHorizontal(0.7 * spd);
  if IsKeyDown(ord('D')) or IsKeyDown(vk_right) then
    pl.StrafeHorizontal(-0.7 * spd);

  ff_mask.OctreeRayCastIntersect(dc_cam.AbsolutePosition,
    VectorMake(0, -1, 0), @v);

  pl_dy := pl_dy + deltaTime;
  if dc_cam.Position.Y - 25 - pl_dy < v.Y then
  begin
    dc_cam.Position.Y := v.Y + 25;
    pl_dy := 0;
    if IsKeyDown(vk_space) then
      pl_dy := -0.65;
  end
  else
    dc_cam.Position.Y := dc_cam.Position.Y - pl_dy * deltaTime * 250;

  light01.Shining := ff_ani.CurrentFrame > 10;
  light01.Position.SetPoint(random * 500 - 1000, 50 + random * 200,
    random * 500);
  light02.Shining := ff_ani.CurrentFrame > 14;
  light02.Position.SetPoint(random * 500 - 1000, 50 + random * 200,
    random * 500);

  vp.Refresh;
  if IsKeyDown(vk_escape) then
    Close;
  // ff_ani.
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  Cadencer.Enabled := true;
end;

procedure TForm1.vpMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = TMouseButton.mbLeft then
  begin
    m_turn := true;
    SetCursorPos(screen.Width div 2, screen.Height div 2);
    showCursor(false);
  end;
end;

procedure TForm1.AsyncTimer1Timer(Sender: TObject);
begin
  Caption := 'RayFire Demo: ' + vp.FramesPerSecondText(2);
  vp.ResetPerformanceMonitor;
end;

end.
