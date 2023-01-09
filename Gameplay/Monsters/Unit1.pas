unit Unit1;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  Winapi.OpenGL,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.ExtCtrls,
  Vcl.Imaging.Jpeg,

  GLS.SceneViewer,
  GLS.Scene,
  GLS.Objects,
  GLS.Cadencer,
  GLS.Texture,
  GLS.VectorGeometry,
  GLS.VectorTypes,
  GLS.VectorFileObjects,
  GLS.File3DS,
  GLS.AsyncTimer,
  GLS.GeomObjects,
  GLS.TerrainRenderer,
  GLS.HeightData,
  GLS.Keyboard,
  GLS.Coordinates,
  GLS.RenderContextInfo,
  
  GLS.BaseClasses,
  GLS.Material;

type
  TForm1 = class(TForm)
    GLScene1: TGLScene;
    vp: TGLSceneViewer;
    cad: TGLCadencer;
    dc_cam: TGLDummyCube;
    cam: TGLCamera;
    DOGL: TGLDirectOpenGL;
    ffObject: TGLFreeForm;
    at: TGLAsyncTimer;
    light: TGLLightSource;
    terra: TGLTerrainRenderer;
    hds: TGLBitmapHDS;
    MatLib: TGLMaterialLibrary;
    procedure FormCreate(Sender: TObject);
    procedure cadProgress(Sender: TObject; const deltaTime, newTime: Double);
    procedure atTimer(Sender: TObject);
    procedure DOGLRender(Sender: TObject; var rci: TGLRenderContextInfo);
    procedure FormShow(Sender: TObject);
  private
  public
  end;

type
  TMonster = record
    pos: TGLVector;
    vel: single;
  end;

var
  Form1: TForm1;
  _m: array [0 .. 100] of TMonster;
  _dt: single = 0;

implementation

{$R *.dfm}

procedure TForm1.FormCreate;
var
  i: integer;
  a, r: single;
begin
  MatLib.LibMaterialByName('default').Material.Texture.Image.LoadFromFile('default.bmp');
  MatLib.LibMaterialByName('grass').Material.Texture.Image.LoadFromFile('grass.jpg');
  MatLib.LibMaterialByName('hmap').Material.Texture.Image.LoadFromFile('hmap.bmp');
  MatLib.LibMaterialByName('light').Material.Texture.Image.LoadFromFile('light.bmp');
  hds.Picture.LoadFromFile('hmap.bmp');
  ffObject.LoadFromFile('monster.3ds');
  ffObject.Scale.Scale(4 / ffObject.BoundingSphereRadius);
  Randomize;
  for i := 0 to high(_m) do
  begin
    a := random * 6.2832;
    r := 100 + random(800);
    SetVector(_m[i].pos, r * sin(a), 0, r * cos(a));
    _m[i].vel := 3 + random;
  end;
  SetCursorPos(width div 2, Height div 2);
end;

procedure TForm1.cadProgress;
var
  spd: single;
begin
  _dt := deltaTime;
  with mouse.CursorPos, cam, screen do
  begin
    dc_cam.Turn((X - (width div 2)) * 0.2);
    PitchAngle := ClampValue(PitchAngle + ((Height div 2) - Y) * 0.2, -90, 90);
    SetCursorPos(width div 2, Height div 2);
  end;

  if IsKeyDown(vk_lshift) then
    spd := 200 * _dt
  else
    spd := 50 * _dt;
  if IsKeyDown(ord('W')) or IsKeyDown(vk_up) then
    dc_cam.Move(-1 * spd);
  if IsKeyDown(ord('S')) or IsKeyDown(vk_down) then
    dc_cam.Move(0.85 * spd);
  if IsKeyDown(ord('A')) or IsKeyDown(vk_left) then
    dc_cam.Slide(0.7 * spd);
  if IsKeyDown(ord('D')) or IsKeyDown(vk_right) then
    dc_cam.Slide(-0.7 * spd);

  dc_cam.Position.Y := terra.InterpolatedHeight(dc_cam.AbsolutePosition);
  if IsKeyDown(vk_escape) then
    close;
end;

procedure TForm1.atTimer;
begin
  caption := vp.FramesPerSecondText(2);
  vp.ResetPerformanceMonitor;
end;

procedure TForm1.DOGLRender;
var
  i: integer;
  v1, v2: TGLVector;
begin
  for i := 0 to high(_m) do
  begin
    // direction
    v1 := vectorsubtract(dc_cam.AbsolutePosition, _m[i].pos);
    v1 := vectornormalize(vectormake(v1.X, 0, v1.Z));
    // velocity
    v1 := vectorscale(v1, _m[i].vel * _dt * 10);
    v2 := vectoradd(_m[i].pos, v1);
    // distance
    if vectorlength(vectorsubtract(dc_cam.AbsolutePosition, v2)) > 25 then
      SetVector(_m[i].pos, v2);

    // render
    with ffObject do
    begin
      Direction.SetVector(v1);
      Up.SetVector(0, 1, 0);
      _m[i].pos.Y := terra.InterpolatedHeight(_m[i].pos);
      Position.SetPoint(_m[i].pos);
      Render(rci);
    end;
  end;
end;

procedure TForm1.FormShow;
begin
  cad.Enabled := true;
end;

end.
