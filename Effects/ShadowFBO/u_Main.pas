unit u_Main;

interface

uses
  Winapi.Windows,
  System.SysUtils,
  System.Classes,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Imaging.jpeg,

  GLS.VectorTypes,
  
  GLS.BaseClasses,
  GLS.Scene,
  GLS.SceneViewer,
  GLS.Material,
  GLS.Keyboard,
  GLS.Objects,
  GLS.Coordinates,
  GLS.HUDObjects,
  GLS.GeomObjects,
  GLS.FBORenderer,
  GLS.Cadencer,
  GLS.RenderContextInfo,
  GLSL.CustomShader,
  GLSL.Shader,
  GLS.AsyncTimer,
  GLS.SpaceText,
  GLS.VectorGeometry,
  GLS.ProjectedTextures;

type
  TForm1 = class(TForm)
    vp: TGLSceneViewer;
    GLScene1: TGLScene;
    matlib: TGLMaterialLibrary;
    GLCamera1: TGLCamera;
    GLHUDSprite1: TGLHUDSprite;
    GLTorus1: TGLTorus;
    GLLightSource1: TGLLightSource;
    GLCamera2: TGLCamera;
    cad: TGLCadencer;
    GLSLShader1: TGLSLShader;
    GLPlane1: TGLPlane;
    at: TGLAsyncTimer;
    fbo: TGLFBORenderer;
    GLCube1: TGLCube;
    GLCube2: TGLCube;
    GLSpaceText1: TGLSpaceText;
    texemit: TGLTextureEmitter;
    GLProjectedTextures1: TGLProjectedTextures;
    GLSphere1: TGLSphere;
    dc_cam: TGLDummyCube;
    hud_mouse: TGLHUDSprite;
    dc: TGLDummyCube;
    procedure cadProgress(Sender: TObject; const deltaTime,
      newTime: Double);
    procedure atTimer(Sender: TObject);
    procedure fboBeforeRender(Sender: TObject; var rci: TGLRenderContextInfo);
    procedure fboAfterRender(Sender: TObject; var rci: TGLRenderContextInfo);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure vpMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
  public
    procedure newMat(obj:TGLSceneObject; m:String='' );
  end;

var
  Form1: TForm1;
  zoom: integer = 0;


implementation

{$R *.dfm}

procedure TForm1.FormCreate;
var
    f: single;
begin
  f := glcamera1.FocalLength;
  texemit.FOVy := 2020 / f - 8400 / f / f;
end;


procedure TForm1.newMat(obj:TGLSceneObject; m:String='');
begin
  obj.Material.LibMaterialName := m;
end;


procedure TForm1.fboAfterRender;
begin
  newMat(glcube1);
  newMat(glcube2);
  newMat(gltorus1);
  newMat(glspacetext1);

  glplane1.Visible := true;
  vp.Buffer.BackgroundColor := $f0caa5;
end;


procedure TForm1.fboBeforeRender;
begin
  newMat(glcube1, 'glsl');
  newMat(glcube2, 'glsl');
  newMat(gltorus1, 'glsl');
  newMat(glspacetext1, 'glsl');
  glplane1.Visible := false;
  vp.Buffer.BackgroundColor := $ffffff;
end;


procedure TForm1.FormMouseWheel;
begin
  zoom := WheelDelta;
end;


procedure TForm1.vpMouseDown;
begin
  hud_mouse.Position.SetPoint(x,y,0);
  hud_mouse.Visible := true;
end;


procedure TForm1.cadProgress;
var
    p: TPoint;
begin
  gltorus1.Turn(deltatime * 30);
  dc_cam.TurnAngle := newtime * 4;
  texemit.PointTo(dc_cam, vectorNegate(YHmgVector));
  if hud_mouse.Visible then begin
    with hud_mouse.Position do begin
      p := screentoclient(Mouse.CursorPos);
      glcamera2.MoveAroundTarget((y - p.Y) * deltatime, (x - p.X) * deltatime);
    end;
    if not iskeydown(vk_rbutton) then
      hud_mouse.Visible := false;
  end;
  glcamera2.AdjustDistanceToTarget(1 - zoom * deltatime);
  zoom := 0;
end;


procedure TForm1.atTimer(Sender: TObject);
begin
  caption := 'SimpleShadow: ' + vp.FramesPerSecondText(2);
  vp.ResetPerformanceMonitor;
end;


end.
