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
  Vcl.Imaging.JPEG,

  GLS.Scene,
  GLS.Objects,
  GLS.Cadencer,
  GLS.SceneViewer,
  GLS.VectorTypes,
  GLS.Texture,
  GLS.VectorFileObjects,
  GLS.Keyboard,
  GLS.VectorGeometry,
  GLS.File3DS,
  GLS.BitmapFont,
  GLS.WindowsFont,
  GLS.HUDObjects,
  GLS.FireFX,
  GLS.GeomObjects,
  GLS.Coordinates,
  
  GLS.BaseClasses;

type
  TForm1 = class(TForm)
    GLSceneViewer1: TGLSceneViewer;
    GLScene1: TGLScene;
    GLCadencer1: TGLCadencer;
    gloPlayer: TGLDummyCube;
    gloPlayerShip: TGLDummyCube;
    GLCamera1: TGLCamera;
    GLSphere1: TGLSphere;
    GLCube1: TGLCube;
    gloShip: TGLTeapot;
    GLLightSource1: TGLLightSource;
    GLSphere2: TGLSphere;
    gloTXTSpeed: TGLHUDText;
    gloHUDCube: TGLDummyCube;
    GLWindowsBitmapFont1: TGLWindowsBitmapFont;
    GLFireFXManager1: TGLFireFXManager;
    GLSprite1: TGLSprite;
    gloTXTfps: TGLHUDText;
    gloTXTInstructions: TGLHUDText;
    GLCamera2: TGLCamera;
    GLCamera3: TGLCamera;
    GLCamera4: TGLCamera;
    procedure GLCadencer1Progress(Sender: TObject;
      const deltaTime, newTime: Double);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  // Vectors for the control of the teapot
  AccelerationVector: TVector4f;
  VelocityVector: TVector4f;

const
  // Movement constants
  MaxVelocity = 5;
  EnginePower = 0.1;
  TurnSpeed = 40;

implementation

{$R *.dfm}

procedure TForm1.GLCadencer1Progress(Sender: TObject;
  const deltaTime, newTime: Double);
var
  Position: TVector4f;
  Speed: single;
begin

  // Change the camera
  if isKeyDown(VK_F1) then
    GLSceneViewer1.Camera := GLCamera1;
  if isKeyDown(VK_F2) then
    GLSceneViewer1.Camera := GLCamera2;
  if isKeyDown(VK_F3) then
    GLSceneViewer1.Camera := GLCamera3;
  if isKeyDown(VK_F4) then
    GLSceneViewer1.Camera := GLCamera4;

  // Thrust forward
  if isKeyDown(VK_UP) then
    // Set the acceleration vector based on the engine power
    AccelerationVector := VectorScale(gloPlayerShip.Direction.AsVector,
      ((EnginePower / 5) * deltaTime));
  // Thrust backward
  if isKeyDown(VK_DOWN) then
    // Set the negative acceleration vector based on the engine power
    AccelerationVector :=
      VectorNegate(VectorScale(gloPlayerShip.Direction.AsVector,
      ((EnginePower / 5) * deltaTime)));
  // Change direction
  if isKeyDown(VK_LEFT) then
    gloPlayerShip.Turn(-(TurnSpeed * 2) * deltaTime);
  // Change direction
  if isKeyDown(VK_RIGHT) then
    gloPlayerShip.Turn((TurnSpeed * 2) * deltaTime);

  // Calculate the new velocity by adding the
  // acceleration to the old velocity
  AddVector(VelocityVector, AccelerationVector);
  // Get the new speed
  Speed := VectorLength(VelocityVector);
  // Check if the speed is too high,
  // then resize the speed vector if needed
  // (we use scalevector to keep the vector orientation)
  if Speed > (MaxVelocity * deltaTime) then
    ScaleVector(VelocityVector, (MaxVelocity * deltaTime) / Speed);

  // Set the new position by adding
  // the velocity vector to the ship position
  Position := gloPlayer.AbsolutePosition;
  AddVector(Position, VelocityVector);
  gloPlayer.AbsolutePosition := Position;

  // Reset the acceleration vector
  // so the ship won'taccelerate forever
  MakeVector(AccelerationVector, 0, 0, 0);

  // Show the current speed
  gloTXTSpeed.Text := 'Current Speed : ' + FloatToStr(Speed);
  // Show the framerate
  gloTXTfps.Text := 'FPS : ' + FloatToStr(GLSceneViewer1.FramesPerSecond);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  // Initialize the speed vector (this is where
  // you can give the initial thrust to the ship)
  MakeVector(VelocityVector, 0, 0, 0);

  // Load the materials for the sun
  GLSphere2.Material.Texture.Image.LoadFromFile('textures\suntex.jpg');
  GLSprite1.Material.Texture.Image.LoadFromFile('textures\sunburst2.jpg');
end;

end.
