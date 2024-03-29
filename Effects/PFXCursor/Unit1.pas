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

  GLS.Cadencer,
  GLS.Texture,
  GLS.SceneViewer,
  GLS.Scene,
  GLS.VectorGeometry,
  GLS.Graphics,
  GLS.Keyboard,
  GLS.ParticleFX,
  GLS.Objects,
  GLS.HUDObjects,
  GLS.AsyncTimer,
  GLS.PerlinPFX,
  GLS.Material,
  GLS.Coordinates,
  
  GLS.BaseClasses, GLS.FireFX, GLS.GeomObjects, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    GLScene1: TGLScene;
    GLMaterialLibrary1: TGLMaterialLibrary;
    cad: TGLCadencer;
    pfx1: TGLPointLightPFXManager;
    cur: TGLHUDSprite;
    dc_cur: TGLDummyCube;
    AsyncTimer1: TGLAsyncTimer;
    rend: TGLParticleFXRenderer;
    dc1: TGLDummyCube;
    dc2: TGLDummyCube;
    GLPointLightPFXManager2: TGLPointLightPFXManager;
    GLPointLightPFXManager3: TGLPointLightPFXManager;
    pfx2: TGLCustomSpritePFXManager;
    vp: TGLSceneViewer;
    dc3: TGLDummyCube;
    pfx3: TGLCustomSpritePFXManager;
    GLDummyCube3: TGLDummyCube;
    GLCone1: TGLCone;
    GLDummyCube1: TGLDummyCube;
    GLCone2: TGLCone;
    GLDummyCube2: TGLDummyCube;
    Light1: TGLLightSource;
    Panel1: TPanel;
    RadioGroup1: TRadioGroup;
    RadioGroup2: TRadioGroup;
    GLCamera1: TGLCamera;
    GLPerlinPFXManager1: TGLPerlinPFXManager;
    GLFireFXManager1: TGLFireFXManager;
    GLParticleFXRenderer1: TGLParticleFXRenderer;
    procedure cadProgress(Sender: TObject; const deltaTime, newTime: Double);
    procedure pfx2PrepareTextureImage(Sender: TObject; destBmp32: TGLImage;
      var texFormat: Integer);
    procedure pfx3PrepareTextureImage(Sender: TObject; destBmp32: TGLImage;
      var texFormat: Integer);
    procedure AsyncTimer1Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure RadioGroup2Click(Sender: TObject);
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.cadProgress;
var
  m: TPoint;
  v: TVector;
begin
  with mouse.CursorPos do
    cur.Position.SetPoint(x - left, y - top, 0);
  cur.Rotation := cur.Rotation - deltaTime * 50;
  v := cur.AbsolutePosition;
  v.y := vp.Height - v.y;
  vp.Buffer.ScreenVectorIntersectWithPlaneXY(v, 0, v);
  dc_cur.AbsolutePosition := v;
  dc1.Visible := iskeydown(vk_lbutton);
  dc2.Visible := iskeydown(vk_rbutton);
  dc3.Visible := iskeydown(vk_mbutton);
  GLDummyCube3.Turn(1.5 * deltaTime * 60);
end;

//
// skull
//
procedure TForm1.pfx2PrepareTextureImage;
var
  bmp: TBitmap;
begin
  bmp := TBitmap.Create;
  bmp.LoadFromFile('skull.bmp');
  destBmp32.Assign(bmp);
  bmp.Free;
end;

//
// rose
//
procedure TForm1.pfx3PrepareTextureImage;
var
  bmp: TBitmap;
begin
  bmp := TBitmap.Create;
  bmp.LoadFromFile('rose.bmp');
  destBmp32.Assign(bmp);
  bmp.Free;
end;

procedure TForm1.RadioGroup1Click(Sender: TObject);
begin
  if RadioGroup1.ItemIndex = 0 then
    GLFireFXManager1.Disabled := False
  else
    GLFireFXManager1.Disabled := True;
end;

procedure TForm1.RadioGroup2Click(Sender: TObject);
begin
  if RadioGroup2.ItemIndex = 0 then
    GLPerlinPFXManager1.Renderer.Visible := True
  else
    GLPerlinPFXManager1.Renderer.Visible := False;
end;

//
// fps
//
procedure TForm1.AsyncTimer1Timer(Sender: TObject);
begin
  caption := 'PFX Cursor Demo: ' + vp.FramesPerSecondText(2) +
    ' / use the mouse left and right buttons';
  vp.ResetPerformanceMonitor;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  cad.Enabled := true;
end;

end.
