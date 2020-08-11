unit uMain;

interface

uses
  System.SysUtils,
  System.Classes,
  Vcl.Controls,
  Vcl.Forms,

  GLS.SceneViewer,
  
  GLS.BaseClasses,
  GLS.Scene,
  GLS.Objects,
  GLS.Coordinates,
  GLS.Cadencer,
  GLS.Material,
  GLS.AsyncTimer,
  GLS.VectorGeometry,
  GLS.VectorTypes,
  GLS.CompositeImage,
  GLS.FileDDS,

  uVBOvni;

type
  TForm1 = class(TForm)
    GLScene1: TGLScene;
    vp: TGLSceneViewer;
    cam: TGLCamera;
    cad: TGLCadencer;
    dc_cam: TGLDummyCube;
    AsyncTimer1: TGLAsyncTimer;
    dc_world: TGLDummyCube;
    procedure FormCreate(Sender: TObject);
    procedure cadProgress(Sender: TObject; const deltaTime, newTime: Double);
    procedure AsyncTimer1Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
  public
    procedure createGeometry;
  end;

const
  BCnt = 15000; // bubbles
  DCnt = 30; // predefined directions for transparency sorting

var
  Form1: TForm1;

  vbo: TVBO;

implementation

{$R *.dfm}

//
// setup
//
procedure TForm1.FormCreate;
begin
  setCurrentDir('data');
  vp.Buffer.RenderingContext.Activate;

  vbo := TVBO.CreateAsChild(dc_world, 'bubble');
  with vbo.Material do
  begin
    BlendingMode := bmTransparency;
    with Texture do
    begin
      Disabled := false;
      ImageClassName := 'TGLCompositeImage';
      Image.LoadFromFile('bubble.dds');
    end;
  end;
  createGeometry;
end;

//
// cadProgress
//
procedure TForm1.cadProgress;
begin
  dc_cam.TurnAngle := dc_cam.TurnAngle + deltaTime * 5;
  dc_cam.Position.X := 20 * sin(newTime / 3);
  dc_cam.Position.Y := 10 * cos(newTime / 5);
  vbo.camLook := round((360 + dc_cam.TurnAngle) / 360 * DCnt) mod DCnt;
end;

//
// createGeometry
//
procedure TForm1.createGeometry;
var
  i, j: integer;
  v: TVector3f;

procedure sort(n: integer; px, py, pz: single);
var
  a1, a2, a3, a4, a5, a6, i, k: integer;
  darr: array [0 .. BCnt - 1] of integer;
begin
  for i := 0 to High(darr) do
    with vbo.garr[i * 4] do
      darr[i] := round((v.X - px) * (v.X - px) + (v.Y - py) * (v.Y - py) +
        (v.Z - pz) * (v.Z - pz));
  a2 := Length(darr);
  a3 := a2 div 2;
  while a3 > 0 do
  begin
    for a1 := 0 to a2 - a3 - 1 do
    begin
      a4 := a1;
      while (a4 >= 0) and (darr[a4] < darr[a4 + a3]) do
      begin
        k := darr[a4];
        darr[a4] := darr[a4 + a3];
        darr[a4 + a3] := k;
        a5 := a4 * 4;
        a6 := a5 + a3 * 4;
        k := vbo.iarr[n, a5];
        vbo.iarr[n, a5] := vbo.iarr[n, a6];
        vbo.iarr[n, a6] := k;
        k := vbo.iarr[n, a5 + 1];
        vbo.iarr[n, a5 + 1] := vbo.iarr[n, a6 + 1];
        vbo.iarr[n, a6 + 1] := k;
        k := vbo.iarr[n, a5 + 2];
        vbo.iarr[n, a5 + 2] := vbo.iarr[n, a6 + 2];
        vbo.iarr[n, a6 + 2] := k;
        k := vbo.iarr[n, a5 + 3];
        vbo.iarr[n, a5 + 3] := vbo.iarr[n, a6 + 3];
        vbo.iarr[n, a6 + 3] := k;
        if a4 > a3 then
          a4 := a4 - a3
        else
          a4 := 0;
      end;
    end;
    a3 := a3 div 2;
  end;
end;

begin
  randomize;
  vbo.setSize(BCnt * 4, DCnt, BCnt * 4);
  for i := 0 to BCnt - 1 do
  begin
    repeat
      SetVector(v, Random * 60 - 30, Random * 60 - 30, Random * 60 - 30);
    until vectorlength(v) < 30;
    if VectorLength(v) > 25 then
      v := VectorScale(vectorNormalize(v), 25);
    vbo.garr[i * 4].v := v;
    SetVector(vbo.garr[i * 4].n, 0, 0, 0);
    vbo.garr[i * 4 + 1].v := v;
    SetVector(vbo.garr[i * 4 + 1].n, 1, 0, 1);
    vbo.garr[i * 4 + 2].v := v;
    SetVector(vbo.garr[i * 4 + 2].n, 2, 0.25, 1);
    vbo.garr[i * 4 + 3].v := v;
    SetVector(vbo.garr[i * 4 + 3].n, 3, 0.25, 0);
    for j := 0 to DCnt - 1 do
    begin
      vbo.iarr[j, i * 4] := i * 4;
      vbo.iarr[j, i * 4 + 1] := i * 4 + 1;
      vbo.iarr[j, i * 4 + 2] := i * 4 + 2;
      vbo.iarr[j, i * 4 + 3] := i * 4 + 3;
    end;
  end;
  for i := 0 to DCnt - 1 do
    sort(i, 100 * sin(i * PI / DCnt * 2), 0, 100 * cos(i * PI / DCnt * 2));
  vbo.init;
end;

//
// timer
//
procedure TForm1.AsyncTimer1Timer(Sender: TObject);
begin
  Caption := 'Bubbles[' + inttostr(BCnt) + ']: ' + vp.FramesPerSecondText(2);
  vp.ResetPerformanceMonitor;
end;

//
// show
//
procedure TForm1.FormShow;
begin
  cad.Enabled := true;
end;

end.
