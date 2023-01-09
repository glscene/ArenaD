unit fLunation;

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

  GLS.SceneViewer,
  GLS.BaseClasses,
  GLS.Scene,
  GLS.Objects,
  GLS.SkyDome,
  GLS.Coordinates,
  GLS.SimpleNavigation,
  GLS.VectorTypes,
  GLS.VectorGeometry,
  GLS.FileDDS;

type
  TFormLunation = class(TForm)
    GLScene1: TGLScene;
    GLSceneViewer1: TGLSceneViewer;
    GLCamera1: TGLCamera;
    GLSkyDome1: TGLSkyDome;
    dc_cam: TGLDummyCube;
    GLPlane1: TGLPlane;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
  end;

var
  FormLunation: TFormLunation;

implementation

{$R *.dfm}

//
// setup
//
procedure TFormLunation.FormCreate;
const
  c1: TVector3b = (X: 100; Y: 100; Z: 100);
  c2: TVector3b = (X: 255; Y: 255; Z: 255);
var
  i: integer;
  v: TVector3f;
begin
  GLSkyDome1.Stars.AddRandomStars(2500, rgb(100, 100, 100), True);
  GLSkyDome1.Stars.AddRandomStars(500, c1, c2, 2.5, 5, True);

  for i := GLSkyDome1.Stars.Count - 1 downto 0 do
    if (abs(GLSkyDome1.Stars[i].Dec - 35) < 6) and
      (abs(GLSkyDome1.Stars[i].RA - 135) < 6) then
      GLSkyDome1.Stars.Delete(i);

  DDSTex(GLPlane1.Material.Texture, 'moon_alpha_256.dds');
end;

//
// resize
//
procedure TFormLunation.FormResize;
begin
  GLSceneViewer1.FieldOfView := 154;
end;

end.
