unit u_Main;

interface

uses
  Winapi.OpenGL,
  Winapi.Windows,
  Winapi.Messages,
  System.Types,
  System.SysUtils,
  System.Classes,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Graphics,

  GLVectorTypes,
  GLTexture,
  GLTextureFormat,
  GLScene,
  GLMaterial,
  GLCoordinates,
  GLCrossPlatform,
  GLWin32Viewer,
  GLBaseClasses,
  GLObjects,
  GLAsyncTimer,
  GLFileTGA;

type

  TForm1 = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormDblClick(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  public
    scn: TGLScene;
    dc_clock: TGLDummyCube;
    plane: array [0 .. 3] of TGLPlane;
    mvp: TGLMemoryViewer;
    cam: TGLCamera;
    matlib: TGLMaterialLibrary;
    timer: TGLAsyncTimer;
    procedure doRender();
    procedure vpMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure onTimer(Sender: TObject);
  end;

const
  mat_name: array [0 .. 3] of string = ('Fon', 'Hour', 'Min', 'Sec');
  mat_tex: array [0 .. 3] of string = ('Fon.tga', 'Hour.tga', 'Min.tga',
    'Sec.tga');
  plane_sz: array [0 .. 3] of array [0 .. 1] of single = ((1, 1), (0.3, 0.6),
    (0.35, 0.7), (0.4, 0.8));

var
  Form1: TForm1;
  mdx, mdy: Integer;
  dw: Integer = 256;
  dh: Integer = 256;

  bf: TBlendFunction = (BlendOp: AC_SRC_OVER; BlendFlags: 0;
    SourceConstantAlpha: 255; AlphaFormat: AC_SRC_ALPHA);

implementation

{$R *.dfm}

procedure TForm1.FormCreate;
var
  i: Integer;

begin
  clientWidth := dw;
  clientHeight := dh;

  scn := TGLScene.Create(self);
  dc_clock := TGLDummyCube.CreateAsChild(scn.Objects);
  cam := TGLCamera.CreateAsChild(scn.Objects);
  cam.TargetObject := dc_clock;
  cam.Position.Z := 2;
  cam.NearPlaneBias := 0.1;

  mvp := TGLMemoryViewer.Create(self);
  mvp.Buffer.BackgroundColor := 0;
  mvp.Buffer.BackgroundAlpha := 0;
  mvp.Width := dw;
  mvp.Height := dh;
  mvp.Camera := cam;

  OnMouseMove := vpMouseMove;
  matlib := TGLMaterialLibrary.Create(self);
  for i := 0 to high(plane) do
  begin
    with matlib.AddTextureMaterial(mat_name[i], mat_tex[i]).Material do
    begin
      BlendingMode := bmTransparency;
      FaceCulling := fcNoCull;
      MaterialOptions := [moNoLighting];
      Texture.FilteringQuality := tfAnisotropic;
    end;
    plane[i] := TGLPlane.CreateAsChild(dc_clock);
    with plane[i] do
    begin
      Material.MaterialLibrary := matlib;
      Material.LibMaterialName := mat_name[i];
      Width := plane_sz[i][0];
      Height := plane_sz[i][1];
      Position.Z := i * 0.01;
    end;
  end;
  timer := TGLAsyncTimer.Create(self);
  timer.Interval := 100;
  timer.Enabled := true;
  timer.onTimer := onTimer;
  timer.onTimer(timer);
  SetWindowLong(Handle, GWL_EXSTYLE, GetWindowLong(Handle, GWL_EXSTYLE) or
    WS_EX_LAYERED);
end;

procedure TForm1.vpMouseMove;
begin
  if Shift = [ssLeft] then
    cam.MoveAroundTarget(mdy - Y, mdx - X);
  mdx := X;
  mdy := Y;
  doRender();
end;

procedure TForm1.FormMouseDown;
begin
  if Shift = [ssRight, ssLeft] then
  begin
    ReleaseCapture;
    SendMessage(Handle, WM_SYSCOMMAND, 61458, 0);
  end;
end;

procedure TForm1.onTimer;
var
  Present: TDateTime;
  Hour, Min, Sec, MSec: Word;
begin
  Present := Now;
  DecodeTime(Present, Hour, Min, Sec, MSec);
  plane[3].RollAngle := -6 * Sec;
  plane[2].RollAngle := -(6 * Min) - (Sec / 20);
  plane[1].RollAngle := -(30 * (Hour mod 12)) - (Min / 2);
  doRender();
end;

procedure TForm1.doRender;
  procedure UpdWnd(bmp: TBitmap);
  var
    p1, p2: TPoint;
    sz: TSize;
  begin
    p1 := Point(Left, Top);
    p2 := Point(0, 0);
    sz.cx := bmp.Width;
    sz.cy := bmp.Height;
    UpdateLayeredWindow(Handle, GetDC(0), @p1, @sz, bmp.Canvas.Handle, @p2, 0,
      @bf, ULW_ALPHA);
    bmp.Free;
  end;

begin
  mvp.Render;
  UpdWnd(mvp.Buffer.CreateSnapShotBitmap);
end;

procedure TForm1.FormDblClick;
begin
  Close;
end;

end.
