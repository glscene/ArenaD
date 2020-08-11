unit f_Main;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Math,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Vcl.Buttons,

  GLS.SceneViewer,
  
  GLS.BaseClasses,
  GLS.Scene,
  GLS.VectorFileObjects,
  GLS.Cadencer,
  GLS.Objects,
  GLS.Coordinates,
  GLS.VectorGeometry,
  GLS.FileOBJ,

  u_Graph;

type
  TRaycastForm = class(TForm)
    GLScene1: TGLScene;
    vp: TGLSceneViewer;
    cam: TGLCamera;
    dc: TGLDummyCube;
    ff: TGLFreeForm;
    pts: TGLPoints;
    cad: TGLCadencer;
    Panel1: TPanel;
    Image1: TImage;
    Image5: TImage;
    fps_lbl: TLabel;
    ray1: TSpeedButton;
    ray2: TSpeedButton;
    Label1: TLabel;
    procedure cadProgress(Sender: TObject; const deltaTime, newTime: Double);
    procedure FormCreate(Sender: TObject);
    procedure ray1Click(Sender: TObject);
  private
    graph: c_FPSGraph;
  end;

const
  ray_cnt = 4000;
  ray_start: TVector = (X: 0; Y: 2.5; Z: 0; W: 0);

var
  RaycastForm: TRaycastForm;

//====================================================================
implementation
//====================================================================

{$R *.dfm}

procedure TRaycastForm.FormCreate;
begin
  clientWidth := 1024;
  clientHeight := 512 + 48;
  ff.LoadFromFile('scn.obj');
  ff.Scale.Scale(4 / ff.BoundingSphereRadius);
  ff.BuildOctree(2);
  graph := c_FPSGraph.CreateAsChild(GLScene1.Objects);
  graph.interval := 25;
  Panel1.DoubleBuffered := true;
  ray1Click(ray1);
end;

procedure TRaycastForm.cadProgress;
begin
  dc.Turn(-deltaTime * 10);
  fps_lbl.Caption := format('%.2f', [graph.fps]);
end;

procedure TRaycastForm.ray1Click;
var
  i: integer;
  v: TVector;

begin
  pts.Positions.Clear;
  for i := 1 to ray_cnt do
  begin
    SetVector(v, dc.LocalToAbsolute(VectorSubtract(VectorMake(random * 8 - 3,
      -2, random * 8 - 4), ray_start)));
    if Sender = ray1 then
    begin
      if ff.RayCastIntersect(ray_start, v, @v) then
        pts.Positions.Add(dc.AbsoluteToLocal(v));
    end
    else if ff.OctreeRayCastIntersect(ray_start, v, @v) then
      pts.Positions.Add(dc.AbsoluteToLocal(v));
  end;
end;

end.
