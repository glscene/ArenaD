unit gui;

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
   
  GLScene,
  GLObjects,
  GLVectorTypes,
  GLWin32Viewer,
  GLMaterial,
  GLTexture,
  GLKeyboard,
  GLCoordinates,
  GLCrossPlatform,
  GLBaseClasses,
  GLGraph;

type
  TForm1 = class(TForm)
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
  numberstars = 4096; // [32, 4096]
  fieldsize = 200;
  halffieldsize = 100;

var
  Form1: TForm1;
  vx, vy: Integer;
  StarField: array [0 .. numberstars] of TObject;

implementation

{$R *.dfm}

procedure TForm1.GLSceneViewer1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  vx := X;
  vy := Y;
end;

procedure TForm1.GLSceneViewer1MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if Shift <> [ssLeft] then
    Exit;
  GLCamera1.MoveAroundTarget(vy - Y, vx - X);
  vx := X;
  vy := Y;
end;

procedure TForm1.Loadstars;
var
  X: Integer;
begin
  for X := 0 to numberstars do
    StarField[X] := GLScene1.Objects.AddNewChild(TGLSprite);
  Randomize;
  for X := 0 to numberstars do
    with (StarField[X] as TGLSprite) do
    begin
      Position.X := Random(fieldsize) - halffieldsize;
      Position.Y := Random(fieldsize) - halffieldsize;
      Position.Z := Random(fieldsize) - halffieldsize;
      Material := Form1.GLMaterialLibrary1.Materials.Items[0].Material;
    end;
end;

procedure TForm1.Checkstars;
var
  X: Integer;
begin
  for X := 0 to numberstars do
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

procedure TForm1.FormCreate(Sender: TObject);
begin
  Image1.Picture.LoadFromFile('star.bmp');
  GLMaterialLibrary1.Materials[0].Material.Texture.Image.Assign(Image1.Picture);
  Loadstars;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  if IsKeyDown(38) then      // Up
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
  else if IsKeyDown(40) then   // Down
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
  Checkstars;
end;

end.
