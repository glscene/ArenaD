unit fStarFlight;

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
  Vcl.ExtCtrls,
   
  GLS.Scene,
  GLS.Objects,
  GLS.VectorTypes,
  GLS.SceneViewer,
  GLS.Material,
  GLS.Texture,
  GLS.Keyboard,
  GLS.Coordinates,
  GLS.SkyDome,
  
  GLS.BaseClasses,
  GLS.Graph;

type
  TFormStarFlight = class(TForm)
    GLScene1: TGLScene;
    GLSceneViewer1: TGLSceneViewer;
    GLDummyCube1: TGLDummyCube;
    GLCamera1: TGLCamera;
    GLMaterialLibrary1: TGLMaterialLibrary;
    Image1: TImage;
    GLLightSource1: TGLLightSource;
    Timer1: TTimer;
    GLXYZGrid1: TGLXYZGrid;
    procedure GLSceneViewer1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure GLSceneViewer1MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    procedure Loadstars;
    procedure Checkstars;
  public
  end;

const
  NumberStars = 1048;
  FieldSize = 128;
  HalfFieldSize = 50;

var
  FormStarFlight: TFormStarFlight;
  vx, vy: Integer;
  StarField: array [0 .. NumberStars] of TObject;

implementation

{$R *.dfm}

procedure TFormStarFlight.FormCreate(Sender: TObject);
begin
  Image1.Picture.LoadFromFile('star.bmp');
  GLMaterialLibrary1.Materials[0].Material.Texture.Image.Assign(Image1.Picture);
  loadstars;
end;


procedure TFormStarFlight.GLSceneViewer1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  vx := X;
  vy := Y;
end;

procedure TFormStarFlight.GLSceneViewer1MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if Shift <> [ssLeft] then
    exit;
  GLCamera1.MoveAroundTarget(vy - Y, vx - X);
  vx := X;
  vy := Y;
end;

procedure TFormStarFlight.Loadstars;
var
  X: Integer;
begin
  for X := 0 to NumberStars do
    StarField[X] := GLScene1.Objects.AddNewChild(TGLSprite);
  Randomize;
  for X := 0 to NumberStars do
    with (StarField[X] as TGLSprite) do
    begin
      Position.X := Random(FieldSize) - HalffieldSize;
      Position.Y := Random(FieldSize) - HalffieldSize;
      Position.Z := Random(FieldSize) - HalffieldSize;
      Material := FormStarFlight.GLMaterialLibrary1.Materials.Items[0].Material;
    end;
end;

procedure TFormStarFlight.Checkstars;
var
  X: Integer;
begin
  for X := 0 to NumberStars do
    with (StarField[X] as TGLSprite) do
    begin
      if abs(Position.X - GLDummyCube1.Position.X) > halffieldsize then
        Position.X := Position.X - 2 * (Position.X - GLDummyCube1.Position.X);
      if abs(Position.Y - GLDummyCube1.Position.Y) > halffieldsize then
        Position.Y := Position.Y - 2 * (Position.Y - GLDummyCube1.Position.Y);
      if abs(Position.Z - GLDummyCube1.Position.Z) > halffieldsize then
        Position.Z := Position.Z - 2 * (Position.Z - GLDummyCube1.Position.Z);
    end;
end;


procedure TFormStarFlight.Timer1Timer(Sender: TObject);
begin
  if IsKeyDown(38) then
  begin
    GLDummyCube1.Position.X := GLDummyCube1.Position.X +
      GLSceneViewer1.Buffer.ScreenToVector(GLSceneViewer1.Width div 2,
      GLSceneViewer1.Height div 2).X;
    GLDummyCube1.Position.Y := GLDummyCube1.Position.Y +
      GLSceneViewer1.Buffer.ScreenToVector(GLSceneViewer1.Width div 2,
      GLSceneViewer1.Height div 2).Y;
    GLDummyCube1.Position.Z := GLDummyCube1.Position.Z +
      GLSceneViewer1.Buffer.ScreenToVector(GLSceneViewer1.Width div 2,
      GLSceneViewer1.Height div 2).Z;
  end
  else if IsKeyDown(40) then
  begin
    GLDummyCube1.Position.X := GLDummyCube1.Position.X -
      GLSceneViewer1.Buffer.ScreenToVector(GLSceneViewer1.Width div 2,
      GLSceneViewer1.Height div 2).X;
    GLDummyCube1.Position.Y := GLDummyCube1.Position.Y -
      GLSceneViewer1.Buffer.ScreenToVector(GLSceneViewer1.Width div 2,
      GLSceneViewer1.Height div 2).Y;
    GLDummyCube1.Position.Z := GLDummyCube1.Position.Z -
      GLSceneViewer1.Buffer.ScreenToVector(GLSceneViewer1.Width div 2,
      GLSceneViewer1.Height div 2).Z;
  end;
  CheckStars;
end;

end.
