(* Basic terrain rendering demo.

   The base terrain renderer uses a hybrid ROAM/brute-force approach to
   rendering terrain, by requesting height data tiles, then rendering them
   using either triangle strips (for those below "QualityDistance") or ROAM
   tessellation.
   Controls:<ul>
   Direction keys move the came nora (shift to speedup)
   PageUp/PageDown move the camera up and down
   Orient the camera freely by holding down the left button
   Toggle wireframe mode with 'w'
   Increase/decrease the viewing distance with '+'/'-'.
   Increase/decrease CLOD precision with '*' and '/'.
   Increase/decrease QualityDistance with '9' and '8'.


   When increasing the range, or moving after having increased the range you
   may notice a one-time slowdown, this originates in the base height data
   being duplicated to create the illusion of an "infinite" terrain (at max
   range the visible area covers 1024x1024 height samples, and with tiles of
   size 16 or less, this is a lot of tiles to prepare).
*)
unit Unit1;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.UITypes,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.ExtCtrls,
  Vcl.StdCtrls,
  Vcl.Imaging.jpeg,

  GLS.Keyboard,
  GLS.VectorTypes,
  GLS.Scene,
  GLS.TerrainRenderer,
  GLS.Objects,
  GLS.HeightData,
  GLS.Material,
  GLS.Cadencer,
  GLS.Texture,
  GLS.HUDObjects,
  GLS.BitmapFont,
  GLS.SkyDome,
  GLS.SceneViewer,
  GLS.VectorGeometry,
  GLS.Mesh,
  GLS.VectorFileObjects,
  GLS.State,
  GLS.FireFX,
  GLS.Coordinates,
  
  GLS.BaseClasses,
  GLS.File3DS;

type
  TForm1 = class(TForm)
    GLSceneViewer1: TGLSceneViewer;
    GLBitmapHDS1: TGLBitmapHDS;
    GLScene1: TGLScene;
    GLCamera1: TGLCamera;
    GLDummyCube1: TGLDummyCube;
    GLTerrainRenderer1: TGLTerrainRenderer;
    Timer1: TTimer;
    GLCadencer1: TGLCadencer;
    GLMaterialLibrary1: TGLMaterialLibrary;
    GLSkyDome1: TGLSkyDome;
    GLFreeForm1: TGLFreeForm;
    GLFireFXManager1: TGLFireFXManager;
    DGLummyCube2: TGLDummyCube;
    procedure GLSceneViewer1MouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure GLSceneViewer1MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure Timer1Timer(Sender: TObject);
    procedure GLCadencer1Progress(Sender: TObject; const deltaTime,
      newTime: Double);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
  public
    mx, my : Integer;
    aFullScreen : Boolean;
    FCamHeight : Single;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
begin
  aFullScreen := false;
//  SetCurrentDir(ExtractFilePath(ParamStr(0)));
  SetCurrentDir(ExtractFilePath(Application.ExeName));
  // 8 MB height data cache
  // Note this is the data size in terms of elevation samples, it does not
  // take into account all the data required/allocated by the renderer
  GLBitmapHDS1.MaxPoolSize := 8 * 1024 * 1024;
  // specify height map data
  GLBitmapHDS1.Picture.LoadFromFile('terrain.bmp');
  // load the texture maps
  GLMaterialLibrary1.Materials[0].Material.Texture.Image.LoadFromFile('snow512.jpg');
  GLMaterialLibrary1.Materials[1].Material.Texture.Image.LoadFromFile('detailmap.jpg');
  // apply texture map scale (our heightmap size is 256)
  GLTerrainRenderer1.TilesPerTexture := 256 / GLTerrainRenderer1.TileSize;
  // Could've been done at design time, but it the, it hurts the eyes ;)
  GLSceneViewer1.Buffer.BackgroundColor := clBlack;
  // Move camera starting point to an interesting hand-picked location
  GLDummyCube1.Position.X := 570;
  GLDummyCube1.Position.Z := -385;
  GLDummyCube1.Turn(90);
  // Initial camera height offset (controled with pageUp/pageDown)
  FCamHeight := 10;
  with GLSkyDome1 do
  begin
    Bands[1].StopColor.AsWinColor := RGB(0, 0, 16);
    Bands[1].StartColor.AsWinColor := RGB(0, 0, 8);
    Bands[0].StopColor.AsWinColor := RGB(0, 0, 8);
    Bands[0].StartColor.AsWinColor := RGB(0, 0, 0);
    with Stars do
    begin
      AddRandomStars(700, clWhite, True); // many white stars
      AddRandomStars(100, RGB(255, 200, 200), True); // some redish ones
      AddRandomStars(100, RGB(200, 200, 255), True); // some blueish ones
      AddRandomStars(100, RGB(255, 255, 200), True); // some yellowish ones
    end;
    GLSceneViewer1.Buffer.BackgroundColor := clBlack;
    with GLSceneViewer1.Buffer.FogEnvironment do
    begin
      FogColor.AsWinColor := clBlack;
      FogStart := -FogStart; // Fog is used to make things darker
    end;
  end;
  GLFreeForm1.LoadFromFile('ship.3ds');
  GLFreeForm1.Material.Texture.Image.LoadFromFile('avion512.jpg');
end;

procedure TForm1.GLCadencer1Progress(Sender: TObject; const deltaTime, newTime: Double);
var
  speed: Single;
begin
  // handle keypresses
  { if IsKeyDown(VK_SHIFT) then
    speed:=300*deltaTime
    else }
  speed := 150 * deltaTime;
  // with GLCamera1.Position do begin
  GLDummyCube1.Translate(GLFreeForm1.direction.Z * speed, -GLFreeForm1.direction.Y * speed, -GLFreeForm1.direction.X * speed);
  if IsKeyDown(VK_UP) then
  begin
    GLFreeForm1.Pitch(1);
    GLCamera1.Pitch(1);
    // GLCamera1.MoveAroundTarget(-1, 0);
  end;
  if IsKeyDown(VK_DOWN) then
  begin
    GLFreeForm1.Pitch(-1);
    GLCamera1.Pitch(-1);
    // GLCamera1.MoveAroundTarget(1, 0);
  end;
  if IsKeyDown(VK_LEFT) then
  begin
    // DummyCube1.Translate(-X*speed, 0, -Z*speed);
    // GLfreeform1.Turn(-1);
    GLFreeForm1.Roll(-1);
    GLCamera1.Roll(1);
    // GLCamera1.MoveAroundTarget(0, 1);
  end;
  if IsKeyDown(VK_RIGHT) then
  begin
    // DummyCube1.Translate(X*speed, 0, Z*speed);
    // GLfreeform1.Turn(1);
    GLFreeForm1.Roll(1);
    GLCamera1.Roll(-1);
    // GLCamera1.MoveAroundTarget(0, -1);
  end;
  { if IsKeyDown(VK_PRIOR) then
    FCamHeight:=FCamHeight+10*speed;
    if IsKeyDown(VK_NEXT) then
    FCamHeight:=FCamHeight-10*speed; }
  if IsKeyDown(VK_ESCAPE) then
    Close;
  // end;
  // don't drop through terrain!

  with GLDummyCube1.Position do
    if Y < GLTerrainRenderer1.InterpolatedHeight(AsVector) then
      Y := GLTerrainRenderer1.InterpolatedHeight(AsVector) + FCamHeight;
end;

// Standard mouse rotation & FPS code below

procedure TForm1.GLSceneViewer1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  mx := X;
  my := Y;
end;

procedure TForm1.GLSceneViewer1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  if ssLeft in Shift then
  begin
    // GLCamera1.MoveAroundTarget(my-y, mx-x);
    mx := X;
    my := Y;
  end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  GLSceneViewer1.ResetPerformanceMonitor;
end;

procedure TForm1.FormKeyPress(Sender: TObject; var Key: Char);
begin
  case Key of
    'w', 'W':
      with GLMaterialLibrary1.Materials[0].Material do
      begin
        if PolygonMode = pmLines then
          PolygonMode := pmFill
        else
          PolygonMode := pmLines;
      end;
    '+':
      if GLCamera1.DepthOfView < 2000 then
      begin
        GLCamera1.DepthOfView := GLCamera1.DepthOfView * 1.2;
        with GLSceneViewer1.Buffer.FogEnvironment do
        begin
          FogEnd := FogEnd * 1.2;
          FogStart := FogStart * 1.2;
        end;
      end;
    '-':
      if GLCamera1.DepthOfView > 300 then
      begin
        GLCamera1.DepthOfView := GLCamera1.DepthOfView / 1.2;
        with GLSceneViewer1.Buffer.FogEnvironment do
        begin
          FogEnd := FogEnd / 1.2;
          FogStart := FogStart / 1.2;
        end;
      end;
    '*':
      with GLTerrainRenderer1 do
        if CLODPrecision > 20 then
          CLODPrecision := Round(CLODPrecision * 0.8);
    '/':
      with GLTerrainRenderer1 do
        if CLODPrecision < 1000 then
          CLODPrecision := Round(CLODPrecision * 1.2);
    '8':
      with GLTerrainRenderer1 do
        if QualityDistance > 40 then
          QualityDistance := Round(QualityDistance * 0.8);
    '9':
      with GLTerrainRenderer1 do
        if QualityDistance < 1000 then
          QualityDistance := Round(QualityDistance * 1.2);
  end;

  Key := #0;
end;

end.
