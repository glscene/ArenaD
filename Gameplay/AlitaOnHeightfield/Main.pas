unit Main;

interface

uses
  Winapi.OpenGL,
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Classes,
  System.Math,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.Imaging.Jpeg,
  Vcl.ExtCtrls,
  Vcl.StdCtrls,
  Vcl.ExtDlgs,
  Vcl.Buttons,
  Vcl.ComCtrls,

  GLS.Scene,
  GLS.Objects,
  GLS.Cadencer,
  GLS.VectorTypes,
  GLS.VectorFileObjects,
  GLS.Keyboard,
  GLS.Graph,
  GLS.VectorGeometry,
  GLS.FireFX,
  GLS.SkyDome,
  GLS.Texture,
  GLS.Material,
  GLS.Coordinates,

  GLS.BaseClasses,
  GLS.SceneViewer,
  GLS.FileMD2;

type
  TFormMain = class(TForm)
    Panel1: TPanel;
    Cadencer: TGLCadencer;
    lblTime: TLabel;
    CBAnimations: TComboBox;
    DistanceBar: TTrackBar;
    SBPlay: TSpeedButton;
    SBStop: TSpeedButton;
    SBFrameToFrame: TSpeedButton;
    SceneViewer: TGLSceneViewer;
    Scene: TGLScene;
    LightSource: TGLLightSource;
    Camera: TGLCamera;
    Actress: TGLActor;
    ActorCube: TGLDummyCube;
    imgHeightmap: TImage;
    imgTexturemap: TImage;
    HeightField: TGLHeightField;
    AllObjects: TGLDummyCube;
    CameraCube: TGLDummyCube;
    FireFXM: TGLFireFXManager;
    SkyDome: TGLSkyDome;
    AfterSky: TGLDummyCube;
    FogBox: TCheckBox;
    Label1: TLabel;
    Label2: TLabel;
    Memo1: TMemo;
    Plane: TGLPlane;
    SphereFire: TGLSphere;
    MatLib: TGLMaterialLibrary;
    Timer1: TTimer;
    OpenPicDlg: TOpenPictureDialog;
    SphereOuter: TGLSphere;
    SphereInner: TGLSphere;
    chbActorCamera: TCheckBox;
    procedure HandleKeys(const deltaTime: Double);
    procedure CadencerProgress(Sender: TObject;
      const deltaTime, newTime: Double);
    procedure FormCreate(Sender: TObject);
    procedure SBPlayClick(Sender: TObject);
    procedure SBStopClick(Sender: TObject);
    procedure SBFrameToFrameClick(Sender: TObject);
    procedure CBAnimationsChange(Sender: TObject);
    procedure SceneViewerMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SceneViewerMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure DistanceBarChange(Sender: TObject);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure ActorDo(action: string; perform: Boolean);
    procedure FogBoxClick(Sender: TObject);
    procedure imgTexturemapDblClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure imgHeightmapDblClick(Sender: TObject);
    procedure HeightFieldGetHeight(const X, Y: Single; var z: Single;
      var Color: TVector4f; var TexPoint: TTexPoint);
    procedure chbActorCameraClick(Sender: TObject);
  public
    snowyMapActive: Boolean;
  end;

var
  FormMain: TFormMain;
  mx, my, mx2, my2: Integer;

implementation

{$R *.DFM}

procedure TFormMain.FormCreate(Sender: TObject);
begin
  SetCurrentDir(ExtractFilePath(ParamStr(0)));
  // ----Load the main Actor and skin----
  Actress.LoadFromFile('.\alita\tris.md2');
  Actress.Material.Texture.Image.LoadFromFile('.\alita\alita2.jpg');
  Actress.Scale.SetVector(0.05, 0.05, 0.05, 0);
  Actress.Animations.SetToStrings(CBAnimations.Items);
  CBAnimations.ItemIndex := 0;
  CBAnimationsChange(Self);

  imgHeightmap.Picture.LoadFromFile('terrain.bmp');
  imgTexturemap.Picture.LoadFromFile('snow512.jpg');
  snowyMapActive := True;

  HeightField.Material.Texture.Image.Assign(imgTexturemap.Picture.Graphic);
  HeightField.Material.Texture.Disabled := False;

  SphereOuter.Material.Texture.Image.Assign(imgTexturemap.Picture.Graphic);
  SphereOuter.Material.Texture.Disabled := False;
  SphereInner.Material.Texture.Image.Assign(imgTexturemap.Picture.Graphic);
  SphereInner.Material.Texture.Disabled := False;


  // ----The Heightmap image can double as cloud-cover
  // ----It is tiled onto a large, transparent plane-object in the sky
  // ----(Its a cheap trick, I know, but it gives a good result with very little effort)
  MatLib.Materials[0].Material.Texture.Image.Assign(imgHeightmap.Picture);
end;

(*
procedure TFormMain.HandleKeys(const deltaTime: Double);
var
  moving: String;
  boost: Single;
begin
  // This function uses asynchronous keyboard check (see GLS.Keyboard.pas)
  if IsKeyDown('A') then
  begin
    CBMouseLook.Checked := True;
    CBMouseLookClick(Self);
  end;
  if IsKeyDown('D') then
  begin
    CBMouseLook.Checked := False;
    CBMouseLookClick(Self);
  end;
  // Change Cameras
  if IsKeyDown(VK_F7) then
  begin
    GLSceneViewer1.Camera := GLCamera1;
    Actor1.Visible := True;
    Label4.Font.Style := Label4.Font.Style - [fsBold];
    Label3.Font.Style := Label3.Font.Style + [fsBold];
  end;
  if IsKeyDown(VK_F8) then
  begin
    GLSceneViewer1.Camera := GLCamera2;
    Actor1.Visible := False;
    Label4.Font.Style := Label4.Font.Style + [fsBold];
    Label3.Font.Style := Label3.Font.Style - [fsBold];
  end;
  // Move Actor in the scene
  // if nothing specified, we are standing
  moving := 'stand';
  // first, are we running ? if yes give animation & speed a boost
  if IsKeyDown(VK_SHIFT) then
  begin
    Actor1.Interval := 100;
    boost := cRunBoost * deltaTime
  end
  else
  begin
    Actor1.Interval := 150;
    boost := deltaTime;
  end;
  Actor2.Interval := Actor1.Interval;
  // are we advaning/backpedaling ?
  if IsKeyDown(VK_UP) then
  begin
    GLNavigator1.MoveForward(cWalkStep * boost);
    moving := 'run';
  end;
  if IsKeyDown(VK_DOWN) then
  begin
    GLNavigator1.MoveForward(-cWalkStep * boost);
    moving := 'run';
  end;

  // slightly more complex, depending on CTRL key, we either turn or strafe
  if IsKeyDown(VK_LEFT) then
  begin
    if IsKeyDown(VK_CONTROL) then
      GLNavigator1.StrafeHorizontal(-cStrafeStep * boost)
    else
      GLNavigator1.TurnHorizontal(-cRotAngle * boost);
    moving := 'run';
  end;
  if IsKeyDown(VK_RIGHT) then
  begin
    if IsKeyDown(VK_CONTROL) then
      GLNavigator1.StrafeHorizontal(cStrafeStep * boost)
    else
      GLNavigator1.TurnHorizontal(cRotAngle * boost);
    moving := 'run';
  end;

  // update animation (if required)
  // you can use faster methods (such as storing the last value of "moving")
  // but this ones shows off the brand new "CurrentAnimation" function :)
  if Actor1.CurrentAnimation <> moving then
  begin
    Actor1.SwitchToAnimation(moving);
    Actor2.Synchronize(Actor1);
  end;
end;
*)

procedure TFormMain.HandleKeys(const deltaTime: Double);
const
  cTurnSpeed = 100;
  cMoveSpeed = 9;
var
  hgt: Single;
  HV: THomogeneousFltVector;
  tp: TTexPoint;
  xpos, zpos: Single;
begin
  if IsKeyDown(VK_ESCAPE) then
    Close;
  if IsKeyDown(VK_SPACE) then
     Camera.TagObject := ActorCube
  else
     Camera.TagObject := SphereInner;
  if IsKeyDown(VK_LEFT) then
    ActorCube.Turn(-cTurnSpeed * deltaTime); // rotate actor left
  if IsKeyDown(VK_RIGHT) then
    ActorCube.Turn(cTurnSpeed * deltaTime); // rotate actor right

  if (IsKeyDown(VK_UP) or IsKeyDown(VK_DOWN)) then
  begin
    if IsKeyDown(VK_UP) then
      ActorCube.Move(cMoveSpeed * deltaTime)
    else
      ActorCube.Move(-cMoveSpeed * deltaTime);
    xpos := -(ActorCube.position.X / HeightField.Scale.X);
    // calc actors position on heightfield
    zpos := (ActorCube.position.z / HeightField.Scale.Y);
    HeightFieldGetHeight(xpos, zpos, hgt, HV, tp);
    // get hgt ---this is the same procedure used to get the heightfieds heights
    ActorCube.position.Y := (hgt * HeightField.Scale.z) +
      (HeightField.position.Y) + 1.2; // place actor just above heightfield
    CameraCube.position := ActorCube.position; // move camera to actors position
    ActorDo('run0', True); // play 'run0' animation
  end
  else
    ActorDo('run0', False); // stop playing 'run0' animation

  // ----   Move camera around the target.
  // ----   This code is placed here so the camera-movements would not cause the Actor to pause
  if ((mx <> mx2) or (my <> my2)) then
  begin
    Camera.MoveAroundTarget(my - my2, mx - mx2);
    // move the camera around the target if mouse was dragged
    mx := mx2;
    my := my2;
  end;
end;

procedure TFormMain.ActorDo(action: string; perform: Boolean);
begin
  if ((action <> Actress.CurrentAnimation) and (perform = True)) then
    Actress.SwitchToAnimation(action);
  if ((action = Actress.CurrentAnimation) and (perform = False)) then
    Actress.SwitchToAnimation('stand0');
end;

procedure TFormMain.CadencerProgress(Sender: TObject;
  const deltaTime, newTime: Double);
begin
  HandleKeys(deltaTime);
///   lblTime.Caption := IntToStr(Round(deltaTime * 10000))
  MatLib.Materials[0].TextureOffset.AddScaledVector(deltaTime * 0.05, XVector);
end;

procedure TFormMain.SBPlayClick(Sender: TObject);
begin
  Actress.AnimationMode := aamLoop;
  SBPlay.Enabled := False;
  SBStop.Enabled := True;
  SBFrameToFrame.Enabled := False;
end;

procedure TFormMain.SBStopClick(Sender: TObject);
begin
  Actress.AnimationMode := aamNone;
  SBPlay.Enabled := True;
  SBStop.Enabled := False;
  SBFrameToFrame.Enabled := True;
end;

procedure TFormMain.SBFrameToFrameClick(Sender: TObject);
begin
  Actress.NextFrame;
end;

procedure TFormMain.CBAnimationsChange(Sender: TObject);
begin
  Actress.SwitchToAnimation(CBAnimations.Text);
end;

procedure TFormMain.chbActorCameraClick(Sender: TObject);
begin
//  Camera.TagObject
  chbActorCamera.Checked := not chbActorCamera.Checked;
end;

procedure TFormMain.SceneViewerMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  mx := X;
  my := Y;
  mx2 := X;
  my2 := Y;
end;

procedure TFormMain.SceneViewerMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if ssLeft in Shift then
  begin
    mx2 := X;
    my2 := Y;
  end;
end;

procedure TFormMain.DistanceBarChange(Sender: TObject);
var
  Dist, NewDist, cx, cy, cz: Single;
begin
  Dist := Camera.DistanceToTarget;
  cx := Camera.position.X;
  cy := Camera.position.Y;
  cz := Camera.position.z;
  NewDist := DistanceBar.position;
  Camera.position.X := cx / Dist * NewDist;
  Camera.position.Y := cy / Dist * NewDist;
  Camera.position.z := cz / Dist * NewDist;
end;

procedure TFormMain.HeightFieldGetHeight(const X, Y: Single; var z: Single;
  var Color: TVector4f; var TexPoint: TTexPoint);
var
  val: Integer;
  xi, yi: Integer;
begin
  xi := Round(X * (imgHeightmap.Picture.Width - 1));
  // translate heightmap coordinate to imgHeightmap pixel number
  yi := Round((1 - Y) * (imgHeightmap.Picture.Height - 1));
  val := (imgHeightmap.Picture.Bitmap.Canvas.Pixels[xi, yi]) AND $000000FF;
  // use brightness of heightmap pixel to calculate height of point x,y
  z := val * 0.05; // return the height of the landscape in z  at position x,y
end;

procedure TFormMain.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  Camera.AdjustDistanceToTarget(Power(1.1, WheelDelta / 120));
  // Adjust Camera distance with mousewheel
end;

procedure TFormMain.FogBoxClick(Sender: TObject);
begin
  SceneViewer.Buffer.FogEnable := FogBox.Checked; // enable or disable fog
  Plane.Visible := not FogBox.Checked; // remove clouds when fog is on
end;

procedure TFormMain.imgTexturemapDblClick(Sender: TObject);
begin
  if OpenPicDlg.Execute then
    imgTexturemap.Picture.LoadFromFile(OpenPicDlg.FileName);
  HeightField.Material.Texture.Image.Assign(imgTexturemap.Picture.Graphic);
end;

procedure TFormMain.imgHeightmapDblClick(Sender: TObject);
begin
  if OpenPicDlg.Execute then
    imgHeightmap.Picture.LoadFromFile(OpenPicDlg.FileName);
  HeightField.StructureChanged;
end;

procedure TFormMain.Timer1Timer(Sender: TObject);
begin
  FormMain.Caption := Format('%.1f FPS', [SceneViewer.FramesPerSecond]);
  SceneViewer.ResetPerformanceMonitor;
end;

end.
