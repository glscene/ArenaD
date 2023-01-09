unit fAtoms;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.Menus,
  Vcl.ComCtrls,
  Vcl.ExtCtrls,
  Vcl.StdCtrls,

  GLS.VectorTypes,
  GLS.Scene,
  GLS.VectorGeometry,
  GLS.Cadencer,
  GLS.Particles,
  GLS.ParticleFX,
  GLS.FireFX,
  GLS.ExplosionFx, {Dropship explosion}
  GLS.VectorFileObjects,
  GLS.Texture,
  GLS.SceneViewer,
  GLS.Objects,
  GLS.Coordinates,
  GLS.PersistentClasses,
  
  GLS.File3DS,
  GLS.BaseClasses, GLS.SimpleNavigation;

// const  PIXELS_PER_INCH :double = 50; from original Stereo mode

type
  // struct used to hold stage coordinates
  ElementStageInfo = Record
    elements: Integer;
    rot_x, rot_y, rot_z: Double;// 3*32 =96, 156 elements so why 120?
    x, y, z: array [0 .. 31] of Double; // x[120]; y[120]; z[120];
  end;

  ProgramState = record // a lot of this is not used by me
    w, // Could be the Stereo mode is wrong...
    h, solidmodel: Integer;
    RotationY, // GLdouble;
    eye, // used to change/store eye distance
    zscreen, znear, zfar, RotationIncrement: Double;
    bStereo, // toggle stereo mode
    bInterlaced, bServerMode: Boolean;
  end;

  TAAtomForm = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    View1: TMenuItem;
    Level71: TMenuItem;
    Hydrogen1: TMenuItem;
    Helium1: TMenuItem;
    Lithium1: TMenuItem;
    Beryllium1: TMenuItem;
    Boron1: TMenuItem;
    Carbon1: TMenuItem;
    Nitrogen1: TMenuItem;
    Oxygen1: TMenuItem;
    Fluorine1: TMenuItem;
    Neon1: TMenuItem;
    Magnesium1: TMenuItem;
    Aluminum1: TMenuItem;
    Silicon1: TMenuItem;
    Phosphorus1: TMenuItem;
    Sulfur1: TMenuItem;
    Chlorine1: TMenuItem;
    Argon1: TMenuItem;
    Potassium1: TMenuItem;
    Calcium1: TMenuItem;
    Scandium1: TMenuItem;
    Titanium1: TMenuItem;
    Vanadium1: TMenuItem;
    Chromium1: TMenuItem;
    Manganese1: TMenuItem;
    Iron1: TMenuItem;
    Cobalt1: TMenuItem;
    Nickel1: TMenuItem;
    Copper1: TMenuItem;
    Zinc1: TMenuItem;
    Gallium1: TMenuItem;
    StatusBar1: TStatusBar;
    Exit1: TMenuItem;
    Help1: TMenuItem;
    About1: TMenuItem;
    GLCadencer1: TGLCadencer;
    Timer1: TTimer;
    GLScene1: TGLScene;
    DummyCube1: TGLDummyCube;
    GLCamera1: TGLCamera;
    GLSceneViewer1: TGLSceneViewer;
    StaticText1: TStaticText;
    Germanium1: TMenuItem;
    Arsenic1: TMenuItem;
    Selenium1: TMenuItem;
    Bromine1: TMenuItem;
    Krypton1: TMenuItem;
    Rubidium1: TMenuItem;
    Strontium1: TMenuItem;
    Yttrium1: TMenuItem;
    Zirconium1: TMenuItem;
    Niobium1: TMenuItem;
    Molybdenum1: TMenuItem;
    Technetium1: TMenuItem;
    Ruthenium1: TMenuItem;
    Rhodium1: TMenuItem;
    Palladium1: TMenuItem;
    Silver1: TMenuItem;
    Cadmium1: TMenuItem;
    Indium1: TMenuItem;
    Tin1: TMenuItem;
    Antimony1: TMenuItem;
    Tellurium1: TMenuItem;
    Iodine1: TMenuItem;
    Xenon1: TMenuItem;
    Cesium1: TMenuItem;
    Barium1: TMenuItem;
    Lanthanum1: TMenuItem;
    Cerium1: TMenuItem;
    Neodymium1: TMenuItem;
    Promethium1: TMenuItem;
    Samarium1: TMenuItem;
    Europium1: TMenuItem;
    Gadolinium1: TMenuItem;
    Terbium1: TMenuItem;
    Dysprosium1: TMenuItem;
    Holmium1: TMenuItem;
    Erbium1: TMenuItem;
    Thulium1: TMenuItem;
    Ytterbium1: TMenuItem;
    Lutetium1: TMenuItem;
    Hafnium1: TMenuItem;
    Tantalum1: TMenuItem;
    Tungsten1: TMenuItem;
    Rhenium1: TMenuItem;
    Osmium1: TMenuItem;
    Iridium1: TMenuItem;
    Platinum1: TMenuItem;
    Gold1: TMenuItem;
    Mercury1: TMenuItem;
    Thallium1: TMenuItem;
    Lead1: TMenuItem;
    Bismuth1: TMenuItem;
    Polonium1: TMenuItem;
    Astatine1: TMenuItem;
    Radon1: TMenuItem;
    Francium1: TMenuItem;
    Radium1: TMenuItem;
    Actinium1: TMenuItem;
    Thorium1: TMenuItem;
    Protactinium1: TMenuItem;
    Uranium1: TMenuItem;
    Neptunium1: TMenuItem;
    Plutonium1: TMenuItem;
    Americium1: TMenuItem;
    Curium1: TMenuItem;
    Berkelium1: TMenuItem;
    Californium1: TMenuItem;
    Einsteinium1: TMenuItem;
    Fermium1: TMenuItem;
    Mendelevium1: TMenuItem;
    Nobelium1: TMenuItem;
    Lawrencium1: TMenuItem;
    Rutherfordium1: TMenuItem;
    Dubnium1: TMenuItem;
    Bohrium1: TMenuItem;
    Seaborgium1: TMenuItem;
    Hassium1: TMenuItem;
    Meitnerium1: TMenuItem;
    Ununnilium1: TMenuItem;
    Unununium1: TMenuItem;
    Ununbium1: TMenuItem;
    Ununquadium1: TMenuItem;
    Ununhexium1: TMenuItem;
    Ununoctium1: TMenuItem;
    UnRealium1: TMenuItem;
    N1: TMenuItem;
    View2D1: TMenuItem;
    View3D1: TMenuItem;
    Stereo1: TMenuItem;
    RotationCommand: TMenuItem;
    N2: TMenuItem;
    sphBlue: TGLSphere;
    WhiteLight: TGLLightSource;
    DummyCube2: TGLDummyCube;
    DummyCube3: TGLDummyCube;
    DummyCube4: TGLDummyCube;
    DummyCube5: TGLDummyCube;
    DummyCube6: TGLDummyCube;
    DummyCube7: TGLDummyCube;
    DummyCubeRed1: TGLDummyCube;
    DummyCubeRed2: TGLDummyCube;
    DummyCubeRed3: TGLDummyCube;
    DummyCubeRed4: TGLDummyCube;
    DummyCubeRed5: TGLDummyCube;
    DummyCubeRed6: TGLDummyCube;
    DummyCubeRed7: TGLDummyCube;
    sphRed: TGLSphere;
    N3: TMenuItem;
    LittleBlue: TGLSphere;
    LittleRed: TGLSphere;
    Lines1: TGLLines;
    DropMesh: TGLFreeForm;
    Level11: TMenuItem;
    Level21: TMenuItem;
    Level31: TMenuItem;
    Sodium1: TMenuItem;
    Level41: TMenuItem;
    Level51: TMenuItem;
    Level61: TMenuItem;
    Lanthanide1: TMenuItem;
    Actinide1: TMenuItem;
    UraGasium1: TMenuItem;
    ToggleFPSDisplay1: TMenuItem;
    GLSimpleNavigation1: TGLSimpleNavigation;
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure SetCheck(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure Contents1Click(Sender: TObject);
    procedure OnHelp1Click(Sender: TObject);
    procedure Menu1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure GLCadencer1Progress(Sender: TObject;
      const deltaTime, newTime: Double);
    procedure DoLevelLineLevel;
    procedure AddToTrail(const p: TGLVector);
    procedure View2D1Click(Sender: TObject);
    procedure Stereo1Click(Sender: TObject);
    procedure RotationCommandClick(Sender: TObject);
    procedure BuildAtom(AtomVal: Integer);
    procedure BuildStageX(n: Integer);
    procedure BuildStageY(n: Integer);
    procedure BuildStageZ(n: Integer);
    procedure SetRotateMethod(i: Integer);
    procedure LoadAtom(i: Integer);
    procedure PaintAtoms;
    procedure CastColor(Leveled: Integer; NewColor: TColor);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ToggleFPSDisplay1Click(Sender: TObject);
  end;

var
  AAtomForm: TAAtomForm;
  isFPSDisplayed, Explosion, LevelLine, flat: Boolean;
  ExplosionCount, LevelLineLevel, MaxLines, Total, StageDistance,
    CurrentAtom: Integer;
  Rotator, rotate, speed, SpeedDemon: Double;
  Name: String[18]; // Atom name displayed in Status bar
  Symbol: String[4]; // Atom symbol displayed in Status bar
  Group: String[2];  // Atom symbol displayed in Status bar
  MetalState: String[2]; // State: Solid, Liquid, Gas, Not found in nature
  { SM  Solid Metal }     // Metal / NonMetal
  AaMass: String[6]; // 123.56 Average atomic mass
  stage: array [1 .. 9] of ElementStageInfo;
  ps: ProgramState;
  Cache: TGLMeshObjectList;
  exp: TGLBExplosionFx;

implementation

uses
  fAbout,
  fAtomicRotation;

{$R *.DFM}

procedure TAAtomForm.FormCreate(Sender: TObject);
var
  i: Integer;
  Sphere: TGLSphere;
begin
  Timer1.Enabled := False;
  GLCadencer1.Enabled := False;
  sphRed.Visible := False;
  if FileExists(ExtractFilePath(ParamStr(0)) + 'sphere.3ds') then
  begin // Needs app directory to load a mesh
    DropMesh.LoadFromFile(ExtractFilePath(ParamStr(0)) + 'sphere.3ds');
    Cache := TGLMeshObjectList.Create; // cache information
    Cache.Assign(DropMesh.MeshObjects);
    // Default settings
    exp := TGLBExplosionFx(DropMesh.effects.items[0]);
    ExplosionCount := 0; { REAL variables set in the click e event }
    exp.MaxSteps := 200; { 1..200 }
    exp.speed := 3.9; { .1 .. 2 ..? }
  end
  else
    ShowMessage('sphere.3ds missing No e !');
  { DropMesh.Visible:=True; } { Allows display for size/scale correction }
  // create Sphere as child of the dummycube
  { NotRealOne	XXX	2 8 18 32 32 32 32 }
  { 7 Dummycubes ~32 spheres each  156 max total }
  { the Paint procedure is used to repaint for Stereo mode }
  for i := 0 to 1 do
  begin
    Sphere := TGLSphere(DummyCube1.AddNewChild(TGLSphere));
    Sphere.Assign(LittleRed);
    Sphere := TGLSphere(DummyCubeRed1.AddNewChild(TGLSphere));
    Sphere.Assign(LittleBlue);
  end;
  for i := 0 to 7 do
  begin
    Sphere := TGLSphere(DummyCube2.AddNewChild(TGLSphere));
    Sphere.Assign(LittleRed);
    Sphere := TGLSphere(DummyCubeRed2.AddNewChild(TGLSphere));
    Sphere.Assign(LittleBlue);
  end;
  for i := 0 to 17 do
  begin
    Sphere := TGLSphere(DummyCube3.AddNewChild(TGLSphere));
    Sphere.Assign(LittleRed);
    Sphere := TGLSphere(DummyCubeRed3.AddNewChild(TGLSphere));
    Sphere.Assign(LittleBlue);
  end;
  for i := 0 to 31 do
  begin
    Sphere := TGLSphere(DummyCube4.AddNewChild(TGLSphere));
    Sphere.Assign(LittleRed);
    Sphere := TGLSphere(DummyCubeRed4.AddNewChild(TGLSphere));
    Sphere.Assign(LittleBlue);
  end;
  for i := 0 to 31 do
  begin
    Sphere := TGLSphere(DummyCube5.AddNewChild(TGLSphere));
    Sphere.Assign(LittleRed);
    Sphere := TGLSphere(DummyCubeRed5.AddNewChild(TGLSphere));
    Sphere.Assign(LittleBlue);
  end;
  for i := 0 to 31 do
  begin
    Sphere := TGLSphere(DummyCube6.AddNewChild(TGLSphere));
    Sphere.Assign(LittleRed);
    Sphere := TGLSphere(DummyCubeRed6.AddNewChild(TGLSphere));
    Sphere.Assign(LittleBlue);
  end;
  for i := 0 to 31 do
  begin
    Sphere := TGLSphere(DummyCube7.AddNewChild(TGLSphere));
    Sphere.Assign(LittleRed);
    Sphere := TGLSphere(DummyCubeRed7.AddNewChild(TGLSphere));
    Sphere.Assign(LittleBlue);
  end;

  Rotator := 0; // global to maintain where its at 0..360
  rotate := 0; // passing time difference
  StageDistance := 6; // Distance between stages.. atom Level
  speed := 1; // * , added to rotate to increase speed of rotation
  SpeedDemon := 0; // an absolute speed incrementer
  Explosion := False;
  LevelLineLevel := 1; // Set on TAtomicRotationForm
  LevelLine := False;
  MaxLines := 36; // kinda useless, was used to do lines on all
  flat := False; // 2d.. 3d toggle  start in 3D
  { animation:=False; } // switch to increase speed +rotate from original
  CurrentAtom := 46; // Selected atom  Carbon
  Total := 46; // atom electron spheres
  ps.eye := 5.0; // Maintains Stereo mode object distance
  ps.bStereo := False; // Boolean Stereo on toggle
  ps.zscreen := 10.0; // The rest of these are from original
  ps.znear := 0.1; // Not used yet
  ps.zfar := 1000000.0;
  ps.RotationY := 0.0;
  ps.RotationIncrement := 4.0;
  ps.solidmodel := 1;
  ps.bInterlaced := true;
  isFPSDisplayed := False;
  BuildAtom(CurrentAtom);
  Lines1.AddNode(0, 0, 0);
  Lines1.ObjectStyle := Lines1.ObjectStyle + [osDirectDraw];
  Timer1.Enabled := true;
  GLCadencer1.Enabled := true;
  GLSceneViewer1.ResetPerformanceMonitor;
end;

procedure TAAtomForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Timer1.Enabled := False;
  GLCadencer1.Enabled := False;
  Application.processmessages;
  Application.processmessages;
  Application.processmessages;
  // Allows program to stop Cadencing then delete spheres
  DummyCube1.DeleteChildren;
  DummyCube2.DeleteChildren;
  DummyCube3.DeleteChildren;
  DummyCube4.DeleteChildren;
  DummyCube5.DeleteChildren;
  DummyCube6.DeleteChildren;
  DummyCube7.DeleteChildren;
  DummyCubeRed1.DeleteChildren;
  DummyCubeRed2.DeleteChildren;
  DummyCubeRed3.DeleteChildren;
  DummyCubeRed4.DeleteChildren;
  DummyCubeRed5.DeleteChildren;
  DummyCubeRed6.DeleteChildren;
  DummyCubeRed7.DeleteChildren;
  { GLSphereBlue.DeleteChildren; }
  Cache.free;
  { DropMesh.free; }
end;

procedure TAAtomForm.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TAAtomForm.FormResize(Sender: TObject);
begin
  // This lines take cares of auto-zooming.
  // magic numbers explanation :  from caterpillar demo
  // 250 is a form width where things looks good when focal length is 50,
  // ie. when form width is 250, uses 38 as focal length,
  // when form is 500, uses 76, etc...
  GLCamera1.FocalLength := Width * 38 / 250;
  { Do some ps. ? stuff }
  GLSceneViewer1.ResetPerformanceMonitor;
end;

procedure TAAtomForm.Contents1Click(Sender: TObject);
begin
  About1Click(Sender);
  // Application.HelpContext(0);
end;

procedure TAAtomForm.OnHelp1Click(Sender: TObject);
begin
  Application.HelpCommand(HELP_HELPONHELP, 0);
end;

procedure TAAtomForm.Menu1Click(Sender: TObject);
begin
  About1Click(Sender);
  // Application.HelpContext(1);
end;

{ For this program the About box contains a memo with Help hints }
procedure TAAtomForm.About1Click(Sender: TObject);
begin
  AboutBox := TAboutBox.Create(Self);
  try
    AboutBox.ShowModal;
  finally
    AboutBox.free;
  end;
end;

procedure TAAtomForm.Timer1Timer(Sender: TObject);
begin
  // update FPS and reset counter for the next second
  If isFPSDisplayed then
  begin
    StaticText1.Caption := 'Electrons: ' + Inttostr(Total) + ', ' +
      Format('FPS: %.1f', [GLSceneViewer1.FramesPerSecond])
    { +', '+ Format('Time: %.1f', [Rotate]) } { Timing Checker }
      ;
  end;
  GLSceneViewer1.ResetPerformanceMonitor;
end;

procedure TAAtomForm.GLCadencer1Progress(Sender: TObject;
  const deltaTime, newTime: Double);
begin
  // for all planes (all childs of the dummycubes)
  // roll them accordingly to our stage reference
  { Maintain rotation to clock NOT Cpu }
  { do something with total to slow down if very few...
    No, rotation is per second not displayed atoms }
  { Should this be   Rotator+(deltaTime*Speed)+SpeedDemon }
  { Rotator:=Rotator+(deltaTime)+Speed; }
  { Speed can even be 'backwards" }
  Rotator := Rotator + ((deltaTime * speed) { *(156/total) } ) + SpeedDemon;
  { Jerks sometimes...? } { Obvious I do not know 3D Geometry... }
  If ((Rotator > 360) or (Rotator < -360)) { 360 degree circles }
  then
    Rotator := 0; { safety catch, still limit keyboard reverse spin }

  { For Stereo mode it should draw with 2 (red/Blue)sets of Cameras / Lights
    Each on with its Spheres visible or not and individual Views per Cameras??? }
  { But it DOES NOT yet... }
  If (ps.bStereo) then { Rotate both sets of spheres }
  begin
    if (stage[1].elements > 0) then
    begin
      DummyCubeRed1.PitchAngle := stage[1].rot_x * (Rotator);
      DummyCubeRed1.RollAngle := stage[1].rot_y * (Rotator);
      DummyCubeRed1.TurnAngle := stage[1].rot_z * (Rotator);
    end;
    if (stage[2].elements > 0) then
    begin
      DummyCubeRed2.PitchAngle := stage[2].rot_x * (Rotator);
      DummyCubeRed2.RollAngle := stage[2].rot_y * (Rotator);
      DummyCubeRed2.TurnAngle := stage[2].rot_z * (Rotator);
    end;
    if (stage[3].elements > 0) then
    begin
      DummyCubeRed3.PitchAngle := stage[3].rot_x * (Rotator);
      DummyCubeRed3.RollAngle := stage[3].rot_y * (Rotator);
      DummyCubeRed3.TurnAngle := stage[3].rot_z * (Rotator);
    end;
    if (stage[4].elements > 0) then
    begin
      DummyCubeRed4.PitchAngle := stage[4].rot_x * (Rotator);
      DummyCubeRed4.RollAngle := stage[4].rot_y * (Rotator);
      DummyCubeRed4.TurnAngle := stage[4].rot_z * (Rotator);
    end;
    if (stage[5].elements > 0) then
    begin
      DummyCubeRed5.PitchAngle := stage[5].rot_x * (Rotator);
      DummyCubeRed5.RollAngle := stage[5].rot_y * (Rotator);
      DummyCubeRed5.TurnAngle := stage[5].rot_z * (Rotator);
    end;
    if (stage[6].elements > 0) then
    begin
      DummyCubeRed6.PitchAngle := stage[6].rot_x * (Rotator);
      DummyCubeRed6.RollAngle := stage[6].rot_y * (Rotator);
      DummyCubeRed6.TurnAngle := stage[6].rot_z * (Rotator);
    end;
    if (stage[7].elements > 0) then
    begin
      DummyCubeRed7.PitchAngle := stage[7].rot_x * (Rotator);
      DummyCubeRed7.RollAngle := stage[7].rot_y * (Rotator);
      DummyCubeRed7.TurnAngle := stage[7].rot_z * (Rotator);
    end;
  end; { of Stero Mode }
  { For now this draws the other set...
    It should switch Stereo or This
    when Stereo mode draws BOTH sets of spheres }
  if (stage[1].elements > 0) then
  begin
    DummyCube1.PitchAngle := stage[1].rot_x * (Rotator);
    DummyCube1.RollAngle := stage[1].rot_y * (Rotator);
    DummyCube1.TurnAngle := stage[1].rot_z * (Rotator);
  end;
  if (stage[2].elements > 0) then
  begin
    DummyCube2.PitchAngle := stage[2].rot_x * (Rotator);
    DummyCube2.RollAngle := stage[2].rot_y * (Rotator);
    DummyCube2.TurnAngle := stage[2].rot_z * (Rotator);
  end;
  if (stage[3].elements > 0) then
  begin
    DummyCube3.PitchAngle := stage[3].rot_x * (Rotator);
    DummyCube3.RollAngle := stage[3].rot_y * (Rotator);
    DummyCube3.TurnAngle := stage[3].rot_z * (Rotator);
  end;
  if (stage[4].elements > 0) then
  begin
    DummyCube4.PitchAngle := stage[4].rot_x * (Rotator);
    DummyCube4.RollAngle := stage[4].rot_y * (Rotator);
    DummyCube4.TurnAngle := stage[4].rot_z * (Rotator);
  end;
  if (stage[5].elements > 0) then
  begin
    DummyCube5.PitchAngle := stage[5].rot_x * (Rotator);
    DummyCube5.RollAngle := stage[5].rot_y * (Rotator);
    DummyCube5.TurnAngle := stage[5].rot_z * (Rotator);
  end;
  if (stage[6].elements > 0) then
  begin
    DummyCube6.PitchAngle := stage[6].rot_x * (Rotator);
    DummyCube6.RollAngle := stage[6].rot_y * (Rotator);
    DummyCube6.TurnAngle := stage[6].rot_z * (Rotator);
  end;
  if (stage[7].elements > 0) then
  begin
    DummyCube7.PitchAngle := stage[7].rot_x * (Rotator);
    DummyCube7.RollAngle := stage[7].rot_y * (Rotator);
    DummyCube7.TurnAngle := stage[7].rot_z * (Rotator);
  end;

  { The Lines connecting the Spheres }
  If LevelLine then
  begin
    rotate := rotate + deltaTime;
    If rotate > 0.2 then { 0.1 might work better ... timing ? }
    begin
      DoLevelLineLevel;
      rotate := 0;
    end;
  end;

  { Explode the hidden .3ds sphere when 'e' is pressed }
  If Explosion then
    ExplosionCount := TGLBExplosionFx(DropMesh.effects.items[0]).Step;
  If (ExplosionCount = 199) then { to turn off when finished }
  begin { 199 1 less than MaxSteps so it can stop  DropMesh }
    // reset simulation
    Explosion := False; // showmessage('explosion off');
    ExplosionCount := 0;
    DropMesh.Visible := False;
    TGLBExplosionFx(DropMesh.effects.items[0]).Enabled := False;
    TGLBExplosionFx(DropMesh.effects.items[0]).Reset;
    // restore the mesh
    DropMesh.MeshObjects.Assign(Cache);
    DropMesh.StructureChanged;
  end;
end;

procedure TAAtomForm.DoLevelLineLevel;
var
  i: Integer;
  pPoint: TGLVector;
begin
  Case LevelLineLevel of
    0:
      begin
        for i := 0 to MaxLines do { Suck em up bro, hide inside the Blue }
        begin
          SetVector(pPoint, sphBlue.AbsolutePosition);
          AddToTrail(pPoint);
          Lines1.Nodes.Last.AsVector := sphBlue.AbsolutePosition;
        end;
      end;
    1:
      for i := 0 to stage[1].elements - 1 do
      begin
        SetVector(pPoint, (DummyCube1.Children[i] as TGLSphere)
          .AbsolutePosition);
        AddToTrail(pPoint);
        Lines1.Nodes.Last.AsVector := (DummyCube1.Children[i] as TGLSphere)
          .AbsolutePosition;
      end;
    2:
      for i := 0 to stage[2].elements - 1 do
      begin
        SetVector(pPoint, (DummyCube2.Children[i] as TGLSphere)
          .AbsolutePosition);
        AddToTrail(pPoint);
        Lines1.Nodes.Last.AsVector := (DummyCube2.Children[i] as TGLSphere)
          .AbsolutePosition;
      end;
    3:
      for i := 0 to stage[3].elements - 1 do
      begin
        SetVector(pPoint, (DummyCube3.Children[i] as TGLSphere)
          .AbsolutePosition);
        AddToTrail(pPoint);
        Lines1.Nodes.Last.AsVector := (DummyCube3.Children[i] as TGLSphere)
          .AbsolutePosition;
      end;
    4:
      for i := 0 to stage[4].elements - 1 do
      begin
        SetVector(pPoint, (DummyCube4.Children[i] as TGLSphere)
          .AbsolutePosition);
        AddToTrail(pPoint);
        Lines1.Nodes.Last.AsVector := (DummyCube4.Children[i] as TGLSphere)
          .AbsolutePosition;
      end;
    5:
      for i := 0 to stage[5].elements - 1 do
      begin
        SetVector(pPoint, (DummyCube5.Children[i] as TGLSphere)
          .AbsolutePosition);
        AddToTrail(pPoint);
        Lines1.Nodes.Last.AsVector := (DummyCube5.Children[i] as TGLSphere)
          .AbsolutePosition;
      end;
    6:
      for i := 0 to stage[6].elements - 1 do
      begin
        SetVector(pPoint, (DummyCube6.Children[i] as TGLSphere)
          .AbsolutePosition);
        AddToTrail(pPoint);
        Lines1.Nodes.Last.AsVector := (DummyCube6.Children[i] as TGLSphere)
          .AbsolutePosition;
      end;
    7:
      for i := 0 to stage[7].elements - 1 do
      begin
        SetVector(pPoint, (DummyCube7.Children[i] as TGLSphere)
          .AbsolutePosition);
        AddToTrail(pPoint);
        Lines1.Nodes.Last.AsVector := (DummyCube7.Children[i] as TGLSphere)
          .AbsolutePosition;
      end;
    { This tried turning em all on...
      need to SKIP drawing the last of one level and the first of the next...
      Atom Class will have 1 Line object per level... }
    9:
      Begin
        for i := 0 to stage[1].elements - 1 do
        begin
          SetVector(pPoint, (DummyCube1.Children[i] as TGLSphere)
            .AbsolutePosition);
          AddToTrail(pPoint);
          Lines1.Nodes.Last.AsVector := (DummyCube1.Children[i] as TGLSphere)
            .AbsolutePosition;
        end;
        for i := 0 to stage[2].elements - 1 do
        begin
          SetVector(pPoint, (DummyCube2.Children[i] as TGLSphere)
            .AbsolutePosition);
          AddToTrail(pPoint);
          Lines1.Nodes.Last.AsVector := (DummyCube2.Children[i] as TGLSphere)
            .AbsolutePosition;
        end;
        for i := 0 to stage[3].elements - 1 do
        begin
          SetVector(pPoint, (DummyCube3.Children[i] as TGLSphere)
            .AbsolutePosition);
          AddToTrail(pPoint);
          Lines1.Nodes.Last.AsVector := (DummyCube3.Children[i] as TGLSphere)
            .AbsolutePosition;
        end;
        for i := 0 to stage[4].elements - 1 do
        begin
          SetVector(pPoint, (DummyCube4.Children[i] as TGLSphere)
            .AbsolutePosition);
          AddToTrail(pPoint);
          Lines1.Nodes.Last.AsVector := (DummyCube4.Children[i] as TGLSphere)
            .AbsolutePosition;
        end;
        for i := 0 to stage[5].elements - 1 do
        begin
          SetVector(pPoint, (DummyCube5.Children[i] as TGLSphere)
            .AbsolutePosition);
          AddToTrail(pPoint);
          Lines1.Nodes.Last.AsVector := (DummyCube5.Children[i] as TGLSphere)
            .AbsolutePosition;
        end;
        for i := 0 to stage[6].elements - 1 do
        begin
          SetVector(pPoint, (DummyCube6.Children[i] as TGLSphere)
            .AbsolutePosition);
          AddToTrail(pPoint);
          Lines1.Nodes.Last.AsVector := (DummyCube6.Children[i] as TGLSphere)
            .AbsolutePosition;
        end;
        for i := 0 to stage[7].elements - 1 do
        begin
          SetVector(pPoint, (DummyCube7.Children[i] as TGLSphere)
            .AbsolutePosition);
          AddToTrail(pPoint);
          Lines1.Nodes.Last.AsVector := (DummyCube7.Children[i] as TGLSphere)
            .AbsolutePosition;
        end;
      End; { Big 9 }
  end; { Case }
end;

procedure TAAtomForm.AddToTrail(const p: TGLVector);
var
  i, k: Integer;
begin
  Lines1.Nodes.Last.AsVector := p;
  Lines1.AddNode(0, 0, 0);
  if Lines1.Nodes.Count > MaxLines then // limit trail to ?? points
    Lines1.Nodes[0].free;

  for i := 0 to MaxLines - 1 do
  begin
    k := Lines1.Nodes.Count - i - 1;
    if k >= 0 then
      TGLLinesNode(Lines1.Nodes[k]).Color.Alpha := 0.95 - i * 0.05;
  end;
end;

{ Menu items have a Tag property,
  used to process which atom was selected }
procedure TAAtomForm.SetCheck(Sender: TObject);
var
  Item: TMenuItem;
  i, Swicheroo: Integer;
begin
  Item := Sender as TMenuItem;
  { Radioitem Menu does not work for me...
    this uncheck/checks them }
  for i := 0 to Level11.Count - 1 do
    Level11.items[i].Checked := False;
  for i := 0 to Level21.Count - 1 do
    Level21.items[i].Checked := False;
  for i := 0 to Level31.Count - 1 do
    Level31.items[i].Checked := False;
  for i := 0 to Level41.Count - 1 do
    Level41.items[i].Checked := False;
  for i := 0 to Level51.Count - 1 do
    Level51.items[i].Checked := False;
  for i := 0 to Level61.Count - 1 do
    Level61.items[i].Checked := False;
  for i := 0 to Lanthanide1.Count - 1 do
    Lanthanide1.items[i].Checked := False;
  for i := 0 to Level71.Count - 1 do
    Level71.items[i].Checked := False;
  for i := 0 to Actinide1.Count - 1 do
    Actinide1.items[i].Checked := False;
  Item.Checked := true;
  Swicheroo := Item.Tag;
  BuildAtom(Swicheroo);
end;

// *****************************************************************
// procedure: BuildAtom(AtomVal:Integer);
// Description: calls BuildStage() to build each stage of the atom.
// *****************************************************************
procedure TAAtomForm.BuildAtom(AtomVal: Integer);
var
  i, Counter: Integer;
begin
  CurrentAtom := AtomVal; // sets the current atom value
  SetRotateMethod(AtomVal); // sets the rotation axis for each stage
  LoadAtom(AtomVal); // loads in the specified element parameters
  if (flat) then { 2d }
  begin { Flat circles rotating clock-counter-clockwise }
    if (stage[1].elements > 0) then
      BuildStageZ(1);
    if (stage[2].elements > 0) then
      BuildStageZ(2);
    if (stage[3].elements > 0) then
      BuildStageZ(3);
    if (stage[4].elements > 0) then
      BuildStageZ(4);
    if (stage[5].elements > 0) then
      BuildStageZ(5);
    if (stage[6].elements > 0) then
      BuildStageZ(6);
    if (stage[7].elements > 0) then
      BuildStageZ(7);
  end
  else
  begin { 3d }{ Variations in 3 planes of rotation }
    if (stage[1].elements > 0) then
      BuildStageY(1);
    if (stage[2].elements > 0) then
      BuildStageX(2);
    if (stage[3].elements > 0) then
      BuildStageZ(3);
    if (stage[4].elements > 0) then
      BuildStageY(4);
    if (stage[5].elements > 0) then
      BuildStageX(5);
    if (stage[6].elements > 0) then
      BuildStageY(6);
    if (stage[7].elements > 0) then
      BuildStageX(7);
  end;
  { Set Position for ALL,
    could split If Stereo but only called when atom is changed }
  Counter := -1;
  if (stage[1].elements > 0) then { Eric says this is redundant }
  begin
    for i := 0 to stage[1].elements - 1 do { Could be my lousy counting error }
    begin
      inc(Counter);
      (DummyCube1.Children[Counter] as TGLSphere).Position.x := stage[1].x[i];
      (DummyCube1.Children[Counter] as TGLSphere).Position.y := stage[1].y[i];
      (DummyCube1.Children[Counter] as TGLSphere).Position.z := stage[1].z[i];
      (DummyCubeRed1.Children[Counter] as TGLSphere).Position.x :=
        stage[1].x[i];
      (DummyCubeRed1.Children[Counter] as TGLSphere).Position.y :=
        stage[1].y[i];
      (DummyCubeRed1.Children[Counter] as TGLSphere).Position.z :=
        stage[1].z[i];
    end;
  end;
  Counter := -1;
  if (stage[2].elements > 0) then
  begin
    for i := 0 to stage[2].elements - 1 do
    begin
      inc(Counter);
      (DummyCube2.Children[Counter] as TGLSphere).Position.x := stage[2].x[i];
      (DummyCube2.Children[Counter] as TGLSphere).Position.y := stage[2].y[i];
      (DummyCube2.Children[Counter] as TGLSphere).Position.z := stage[2].z[i];
      (DummyCubeRed2.Children[Counter] as TGLSphere).Position.x :=
        stage[2].x[i];
      (DummyCubeRed2.Children[Counter] as TGLSphere).Position.y :=
        stage[2].y[i];
      (DummyCubeRed2.Children[Counter] as TGLSphere).Position.z :=
        stage[2].z[i];
    end;
  end;
  Counter := -1;
  if (stage[3].elements > 0) then
  begin
    for i := 0 to stage[3].elements - 1 do
    begin
      inc(Counter);
      (DummyCube3.Children[Counter] as TGLSphere).Position.x := stage[3].x[i];
      (DummyCube3.Children[Counter] as TGLSphere).Position.y := stage[3].y[i];
      (DummyCube3.Children[Counter] as TGLSphere).Position.z := stage[3].z[i];
      (DummyCubeRed3.Children[Counter] as TGLSphere).Position.x :=
        stage[3].x[i];
      (DummyCubeRed3.Children[Counter] as TGLSphere).Position.y :=
        stage[3].y[i];
      (DummyCubeRed3.Children[Counter] as TGLSphere).Position.z :=
        stage[3].z[i];
    end;
  end;
  Counter := -1;
  if (stage[4].elements > 0) then
  begin
    for i := 0 to stage[4].elements - 1 do
    begin
      inc(Counter);
      (DummyCube4.Children[Counter] as TGLSphere).Position.x := stage[4].x[i];
      (DummyCube4.Children[Counter] as TGLSphere).Position.y := stage[4].y[i];
      (DummyCube4.Children[Counter] as TGLSphere).Position.z := stage[4].z[i];
      (DummyCubeRed4.Children[Counter] as TGLSphere).Position.x :=
        stage[4].x[i];
      (DummyCubeRed4.Children[Counter] as TGLSphere).Position.y :=
        stage[4].y[i];
      (DummyCubeRed4.Children[Counter] as TGLSphere).Position.z :=
        stage[4].z[i];
    end;
  end;
  Counter := -1;
  if (stage[5].elements > 0) then
  begin
    for i := 0 to stage[5].elements - 1 do
    begin
      inc(Counter);
      (DummyCube5.Children[Counter] as TGLSphere).Position.x := stage[5].x[i];
      (DummyCube5.Children[Counter] as TGLSphere).Position.y := stage[5].y[i];
      (DummyCube5.Children[Counter] as TGLSphere).Position.z := stage[5].z[i];
      (DummyCubeRed5.Children[Counter] as TGLSphere).Position.x :=
        stage[5].x[i];
      (DummyCubeRed5.Children[Counter] as TGLSphere).Position.y :=
        stage[5].y[i];
      (DummyCubeRed5.Children[Counter] as TGLSphere).Position.z :=
        stage[5].z[i];
    end;
  end;
  Counter := -1;
  if (stage[6].elements > 0) then
  begin
    for i := 0 to stage[6].elements - 1 do
    begin
      inc(Counter);
      (DummyCube6.Children[Counter] as TGLSphere).Position.x := stage[6].x[i];
      (DummyCube6.Children[Counter] as TGLSphere).Position.y := stage[6].y[i];
      (DummyCube6.Children[Counter] as TGLSphere).Position.z := stage[6].z[i];
      (DummyCubeRed6.Children[Counter] as TGLSphere).Position.x :=
        stage[6].x[i];
      (DummyCubeRed6.Children[Counter] as TGLSphere).Position.y :=
        stage[6].y[i];
      (DummyCubeRed6.Children[Counter] as TGLSphere).Position.z :=
        stage[6].z[i];
    end;
  end;
  Counter := -1;
  if (stage[7].elements > 0) then
  begin
    for i := 0 to stage[7].elements - 1 do
    begin
      inc(Counter);
      (DummyCube7.Children[Counter] as TGLSphere).Position.x := stage[7].x[i];
      (DummyCube7.Children[Counter] as TGLSphere).Position.y := stage[7].y[i];
      (DummyCube7.Children[Counter] as TGLSphere).Position.z := stage[7].z[i];
      (DummyCubeRed7.Children[Counter] as TGLSphere).Position.x :=
        stage[7].x[i];
      (DummyCubeRed7.Children[Counter] as TGLSphere).Position.y :=
        stage[7].y[i];
      (DummyCubeRed7.Children[Counter] as TGLSphere).Position.z :=
        stage[7].z[i];
    end;
  end;
end; // build atom()

// ******************************************************************************
// build_stage_x, y, and z are similar, but do different planes
// ******************************************************************************
// Function: build_stage_x()
// Description: computes the value of each 'electron' in a stage around the x-axis
// ******************************************************************************/
procedure TAAtomForm.BuildStageX(n: Integer);
var
  i, radius: Integer;
  two_pi, angle, angle_size: Double;
begin
  angle := 0.001;
  two_pi := 3.1415926535 * 2;
  angle_size := 360 / stage[n].elements;
  radius := n * StageDistance;

  for i := 0 to stage[n].elements - 1 do
  begin
    if (angle > 180) then
    begin
      stage[n].y[i] := (cos((two_pi * angle) / 360)) * radius;
      stage[n].z[i] :=
        sqrt(((radius * radius) - (stage[n].y[i] * stage[n].y[i])));
      stage[n].x[i] := 0;
    end
    else
    begin
      stage[n].y[i] := (cos((two_pi * angle) / 360)) * radius;
      stage[n].z[i] := (-1) *
        sqrt(((radius * radius) - (stage[n].y[i] * stage[n].y[i])));
      stage[n].x[i] := 0;
    end;
    angle := angle + angle_size;
  end; // end for
End; // end build_stage_x()

/// ******************************************************************************
// Function: void build_stage_y(int n)
// Description: computes the value of each 'electron' in a stage around the y-axis
// ******************************************************************************/
procedure TAAtomForm.BuildStageY(n: Integer);
var
  i, radius: Integer;
  two_pi, angle, angle_size: Double;
begin
  angle := 0.001;
  two_pi := 3.1415926535 * 2;
  angle_size := 360 / stage[n].elements;
  radius := n * StageDistance;
  for i := 0 to stage[n].elements - 1 do
  begin
    if (angle > 180) then
    begin
      stage[n].x[i] := (cos((two_pi * angle) / 360)) * radius;
      stage[n].z[i] :=
        sqrt(((radius * radius) - (stage[n].x[i] * stage[n].x[i])));
      stage[n].y[i] := 0;
    end
    else
    begin
      stage[n].x[i] := (cos((two_pi * angle) / 360)) * radius;
      stage[n].z[i] := (-1) *
        sqrt(((radius * radius) - (stage[n].x[i] * stage[n].x[i])));
      stage[n].y[i] := 0;
    end;
    angle := angle + angle_size;
    If (angle > 360) then
      angle := 0;
  end; // end for
End; // end build_stage_y()

// ******************************************************************************
// Function:void build_stage_z(int n)
// Description: computes the value of each 'electron' in a stage around the z-axis
// ******************************************************************************/
procedure TAAtomForm.BuildStageZ(n: Integer);
var
  i, radius: Integer;
  two_pi, angle, angle_size: Double;
begin
  angle := 0.000;
  two_pi := 3.1415926535 * 2;
  angle_size := 360 / stage[n].elements;
  radius := n * StageDistance;
  for i := 0 to stage[n].elements - 1 do
  begin
    if (angle > 180) then
    begin
      stage[n].y[i] := (cos((two_pi * angle) / 360)) * radius;
      stage[n].x[i] :=
        sqrt(((radius * radius) - (stage[n].y[i] * stage[n].y[i])));
      stage[n].z[i] := 0;
    End
    else
    begin
      stage[n].y[i] := (cos((two_pi * angle) / 360)) * radius;
      stage[n].x[i] := (-1) *
        sqrt(((radius * radius) - (stage[n].y[i] * stage[n].y[i])));
      stage[n].z[i] := 0;
    End;
    angle := angle + angle_size;
  End; // end for
End; // end build_stage_z()

// ******************************************************************************
// Function: void set_rotate_method()
// Description: sets the rotation of each stage
// ******************************************************************************/
procedure TAAtomForm.SetRotateMethod(i: Integer);
begin
  if (flat) then
  begin { 2d } { front-back }       { Clockwise }        { on itself }
    stage[1].rot_x := 0.0;
    stage[1].rot_y := 1.0;
    stage[1].rot_z := 0.0;
    stage[2].rot_x := 0.0;
    stage[2].rot_y := -1.0;
    stage[2].rot_z := 0.0;
    stage[3].rot_x := 0.0;
    stage[3].rot_y := 1.0;
    stage[3].rot_z := 0.0;
    stage[4].rot_x := 0.0;
    stage[4].rot_y := -1.0;
    stage[4].rot_z := 0.0;
    stage[5].rot_x := 0.0;
    stage[5].rot_y := 1.0;
    stage[5].rot_z := 0.0;
    stage[6].rot_x := 0.0;
    stage[6].rot_y := -1.0;
    stage[6].rot_z := 0.0;
    stage[7].rot_x := 0.0;
    stage[7].rot_y := 1.0;
    stage[7].rot_z := 0.0;
  End
  else
  begin { 3d } { front-back }       { Clockwise }        { on itself }
    stage[1].rot_x := 1.0;
    stage[1].rot_y := 1.0;
    stage[1].rot_z := 0.0;
    stage[2].rot_x := -1.0;
    stage[2].rot_y := -1.0;
    stage[2].rot_z := 0.0;
    stage[3].rot_x := 1.0;
    stage[3].rot_y := -1.0;
    stage[3].rot_z := 1.0;
    stage[4].rot_x := -1.0;
    stage[4].rot_y := -1.0;
    stage[4].rot_z := 1.0;
    stage[5].rot_x := 1.0;
    stage[5].rot_y := 1.0;
    stage[5].rot_z := 1.0;
    stage[6].rot_x := -1.0;
    stage[6].rot_y := -1.0;
    stage[6].rot_z := -1.0;
    stage[7].rot_x := 1.0;
    stage[7].rot_y := 1.0;
    stage[7].rot_z := 0.0;
  End;
End; // end set_rotate_method();

procedure TAAtomForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_ESCAPE) then
    Close;
end;

procedure TAAtomForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  case Key of
    ',':
      GLCadencer1.SleepLength := GLCadencer1.SleepLength + 1;
    '.':
      GLCadencer1.SleepLength := GLCadencer1.SleepLength - 1;
    // limit -0 revolution to limit reset from -360 to 0
    'j':
      if (SpeedDemon > -1) then
        SpeedDemon := SpeedDemon - 1.0;
    ';':
      SpeedDemon := SpeedDemon + 1.0;
    'm':
      if (speed > -1) then
        speed := speed - 0.1;
    '/':
      speed := speed + 0.1;
    'k':
      if (speed > -1) then
        speed := speed - 1.0;
    'l':
      speed := speed + 1.0;
    'r':
      begin { Reset speed to default }
        speed := 1;
        SpeedDemon := 0;
        GLCadencer1.SleepLength := -1;
      end;
    'p':
      begin
        Timer1.Enabled := False;
        GLCadencer1.Enabled := False;
      end;
    'o':
      begin
        Timer1.Enabled := true;
        GLCadencer1.Enabled := true;
      end;
    's':
      Stereo1Click(Self); // stereo toggle
    'g':
      begin
        ps.eye := ps.eye - 0.1; // move eye distance
        sphRed.Position.x := 0;
        sphBlue.Position.x := ps.eye;
        DummyCubeRed1.Position.x := ps.eye;
        DummyCubeRed2.Position.x := ps.eye;
        DummyCubeRed3.Position.x := ps.eye;
        DummyCubeRed4.Position.x := ps.eye;
        DummyCubeRed5.Position.x := ps.eye;
        DummyCubeRed6.Position.x := ps.eye;
        DummyCubeRed7.Position.x := ps.eye;
      end;
    'h':
      begin
        ps.eye := ps.eye + 0.1; // move eye distance
        sphRed.Position.x := 0;
        sphBlue.Position.x := ps.eye;
        DummyCubeRed1.Position.x := ps.eye;
        DummyCubeRed2.Position.x := ps.eye;
        DummyCubeRed3.Position.x := ps.eye;
        DummyCubeRed4.Position.x := ps.eye;
        DummyCubeRed5.Position.x := ps.eye;
        DummyCubeRed6.Position.x := ps.eye;
        DummyCubeRed7.Position.x := ps.eye;
      end;
    '2':
      GLCamera1.MoveAroundTarget(3, 0);
    '4':
      GLCamera1.MoveAroundTarget(0, -3);
    '6':
      GLCamera1.MoveAroundTarget(0, 3);
    '8':
      GLCamera1.MoveAroundTarget(-3, 0);
    '-':
      GLCamera1.AdjustDistanceToTarget(1.1);
    '+':
      GLCamera1.AdjustDistanceToTarget(1 / 1.1);
    'f':
      GLCamera1.FocalLength := GLCamera1.FocalLength + 10;
    // Camera focus plane foward */
    'v':
      GLCamera1.FocalLength := GLCamera1.FocalLength - 10;
    // Camera focus plane back */
    'd':
      GLCamera1.DepthOfView := GLCamera1.DepthOfView + 10;
    // Camera DepthOfView foward */
    'c':
      GLCamera1.DepthOfView := GLCamera1.DepthOfView - 10;
    // Camera DepthOfView back */
    'e':
      begin { Explode the Central atom...  DropMesh }
        DropMesh.Visible := true;
        TGLBExplosionFx(DropMesh.effects.items[0]).MaxSteps := 200;
        TGLBExplosionFx(DropMesh.effects.items[0]).speed := 3.9;
        Explosion := true;
        TGLBExplosionFx(DropMesh.effects.items[0]).Enabled := true;
      end;
  end; // end keyboard
end;

procedure TAAtomForm.View2D1Click(Sender: TObject);
begin { Clears }  { Rotator:=0; }
  View2D1.Checked := (not View2D1.Checked);
  If (View2D1.Checked) then
  begin
    View3D1.Checked := False;
    flat := true;
  end
  else
  begin
    View3D1.Checked := true;
    flat := False; // (flat = 0) then 3d
  end;
  DummyCube1.ResetRotations;
  DummyCube2.ResetRotations;
  DummyCube3.ResetRotations;
  DummyCube4.ResetRotations;
  DummyCube5.ResetRotations;
  DummyCube6.ResetRotations;
  DummyCube7.ResetRotations;
  DummyCubeRed1.ResetRotations;
  DummyCubeRed2.ResetRotations;
  DummyCubeRed3.ResetRotations;
  DummyCubeRed4.ResetRotations;
  DummyCubeRed5.ResetRotations;
  DummyCubeRed6.ResetRotations;
  DummyCubeRed7.ResetRotations;
  BuildAtom(CurrentAtom);
end;

{ In Non-Stereo mode the Blue sphere is in center of Red atoms
  Stereo: Red/red and Blue/blue spheres }
procedure TAAtomForm.Stereo1Click(Sender: TObject);
begin
  ps.bStereo := (not ps.bStereo);
  Stereo1.Checked := ps.bStereo;
  If ps.bStereo then
  begin
    ps.bStereo := true;
    sphRed.Visible := true;
    ps.eye := 5.0;
    sphRed.Position.x := 0;
    sphBlue.Position.x := ps.eye;
    DummyCubeRed1.Position.x := ps.eye;
    DummyCubeRed2.Position.x := ps.eye;
    DummyCubeRed3.Position.x := ps.eye;
    DummyCubeRed4.Position.x := ps.eye;
    DummyCubeRed5.Position.x := ps.eye;
    DummyCubeRed6.Position.x := ps.eye;
    DummyCubeRed7.Position.x := ps.eye;
    PaintAtoms; { Make sure they are back to Default }
  end
  else
  begin
    ps.bStereo := False;
    ps.eye := 0.0;
    sphRed.Position.x := 0;
    sphBlue.Position.x := ps.eye;
    sphRed.Visible := False;
  end;
  BuildAtom(CurrentAtom);
end;

procedure TAAtomForm.ToggleFPSDisplay1Click(Sender: TObject);
begin
  ToggleFPSDisplay1.Checked := (not ToggleFPSDisplay1.Checked);
  If (ToggleFPSDisplay1.Checked) then
    isFPSDisplayed := true
  else
    isFPSDisplayed := False;
  StaticText1.Visible := isFPSDisplayed;
end;

procedure TAAtomForm.RotationCommandClick(Sender: TObject);
begin
  { just for fun... AVI recorder later? }
  AtomicRotationForm.Show;
end;

// ***************************************************************
// void load_atom(int i)
// Description: loads the specified atom
// Atomic Weight, other possible things ?
// ****************************************************************
procedure TAAtomForm.LoadAtom(i: Integer);
begin
  // Fill for errors
  name := 'Hydrogen';
  Symbol := 'H';
  Group := '1A';
  MetalState := 'MG';
  AaMass := '1.0079';
  case i of
    1: // Hydrogen		H	1 0 0 0 0 0 0
      begin
        name := 'Hydrogen';
        Symbol := 'H';
        Group := '1A';
        MetalState := 'MG'; { NSM  SLGN }
        AaMass := '1.0079';
        stage[1].elements := 1;
        stage[2].elements := 0;
        stage[3].elements := 0;
        stage[4].elements := 0;
        stage[5].elements := 0;
        stage[6].elements := 0;
        stage[7].elements := 0;
      end;
    2: // Helium		He	2 0 0 0 0 0 0
      begin
        name := 'Helium';
        Symbol := 'He';
        Group := '0';
        MetalState := 'NG'; { NSM  SLGN }
        AaMass := '4.0026';
        stage[1].elements := 2;
        stage[2].elements := 0;
        stage[3].elements := 0;
        stage[4].elements := 0;
        stage[5].elements := 0;
        stage[6].elements := 0;
        stage[7].elements := 0;
      end;
    3: // Lithium		Li	2 1 0 0 0 0 0
      begin
        name := 'Lithium';
        Symbol := 'Li';
        Group := '1A';
        MetalState := 'MS'; { NSM  SLGN }
        AaMass := '6.941';
        stage[1].elements := 2;
        stage[2].elements := 1;
        stage[3].elements := 0;
        stage[4].elements := 0;
        stage[5].elements := 0;
        stage[6].elements := 0;
        stage[7].elements := 0;
      end;
    4: // Beryllium	Be	2 2 0 0 0 0 0
      begin
        name := 'Beryllium';
        Symbol := 'Be';
        Group := '2A';
        MetalState := 'SS'; { NSM  SLGN }
        AaMass := '9.0122';
        stage[1].elements := 2;
        stage[2].elements := 2;
        stage[3].elements := 0;
        stage[4].elements := 0;
        stage[5].elements := 0;
        stage[6].elements := 0;
        stage[7].elements := 0;
      end;
    5: // Boron		B	2 3 0 0 0 0 0
      begin
        name := 'Boron';
        Symbol := 'B';
        Group := '3A';
        MetalState := 'SS'; { NSM  SLGN }
        AaMass := '10.81';
        stage[1].elements := 2;
        stage[2].elements := 3;
        stage[3].elements := 0;
        stage[4].elements := 0;
        stage[5].elements := 0;
        stage[6].elements := 0;
        stage[7].elements := 0;
      end;
    6: // Carbon		C	2 4 0 0 0 0 0
      begin
        name := 'Carbon';
        Symbol := 'C';
        Group := '4A';
        MetalState := 'NS'; { NSM  SLGN }
        AaMass := '12.011';
        stage[1].elements := 2;
        stage[2].elements := 4;
        stage[3].elements := 0;
        stage[4].elements := 0;
        stage[5].elements := 0;
        stage[6].elements := 0;
        stage[7].elements := 0;
      end;
    7: // Nitrogen	N	2 5 0 0 0 0 0
      begin
        name := 'Nitrogen';
        Symbol := 'N';
        Group := '5A';
        MetalState := 'NG'; { NSM  SLGN }
        AaMass := '14.007';
        stage[1].elements := 2;
        stage[2].elements := 5;
        stage[3].elements := 0;
        stage[4].elements := 0;
        stage[5].elements := 0;
        stage[6].elements := 0;
        stage[7].elements := 0;
      end;
    8:
      Begin { Oxygen		O	2 6 0 0 0 0 0 }
        name := 'Oxygen';
        Symbol := 'O';
        Group := '6A';
        MetalState := 'NG'; { NSM  SLGN }
        AaMass := '15.999';
        stage[1].elements := 2;
        stage[2].elements := 6;
        stage[3].elements := 0;
        stage[4].elements := 0;
        stage[5].elements := 0;
        stage[6].elements := 0;
        stage[7].elements := 0;
      end;
    9:
      Begin { Fluorine	F	2 7 0 0 0 0 0 }
        name := 'Fluorine';
        Symbol := 'F';
        Group := '7A';
        MetalState := 'NG'; { NSM  SLGN }
        AaMass := '18.998';
        stage[1].elements := 2;
        stage[2].elements := 7;
        stage[3].elements := 0;
        stage[4].elements := 0;
        stage[5].elements := 0;
        stage[6].elements := 0;
        stage[7].elements := 0;
      end;
    10:
      Begin { Neon		Ne	2 8 0 0 0 0 0 }
        name := 'Neon';
        Symbol := 'Ne';
        Group := '0';
        MetalState := 'NG'; { NSM  SLGN }
        AaMass := '20.179';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 0;
        stage[4].elements := 0;
        stage[5].elements := 0;
        stage[6].elements := 0;
        stage[7].elements := 0;
      end;
    11:
      Begin { Sodium		Na	2 8 1 0 0 0 0 }
        name := 'Sodium';
        Symbol := 'Na';
        Group := '1A';
        MetalState := 'MS'; { NSM  SLGN }
        AaMass := '22.990';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 0;
        stage[4].elements := 0;
        stage[5].elements := 0;
        stage[6].elements := 0;
        stage[7].elements := 0;
      end;
    12:
      Begin { Magnesium	Mg	2 8 2 0 0 0 0 }
        name := 'Magnesium';
        Symbol := 'Mg';
        Group := '2A';
        MetalState := 'MS'; { NSM  SLGN }
        AaMass := '24.305';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 2;
        stage[4].elements := 0;
        stage[5].elements := 0;
        stage[6].elements := 0;
        stage[7].elements := 0;
      end;
    13:
      Begin { Aluminum	Al	2 8 3 0 0 0 0 }
        name := 'Aluminum';
        Symbol := 'Al';
        Group := '3A';
        MetalState := 'SS'; { NSM  SLGN }
        AaMass := '26.982';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 3;
        stage[4].elements := 0;
        stage[5].elements := 0;
        stage[6].elements := 0;
        stage[7].elements := 0;
      end;
    14:
      Begin { Silicon		Si	2 8 4 0 0 0 0 }
        name := 'Silicon';
        Symbol := 'Si';
        Group := '4A';
        MetalState := 'SS'; { NSM  SLGN }
        AaMass := '28.066';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 3;
        stage[4].elements := 0;
        stage[5].elements := 0;
        stage[6].elements := 0;
        stage[7].elements := 0;
      end;
    15:
      Begin { Phosphorus	P	2 8 5 0 0 0 0 }
        name := 'Phosphorus';
        Symbol := 'P';
        Group := '5A';
        MetalState := 'NS'; { NSM  SLGN }
        AaMass := '30.974';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 5;
        stage[4].elements := 0;
        stage[5].elements := 0;
        stage[6].elements := 0;
        stage[7].elements := 0;
      end;
    16:
      Begin { Sulfur		S	2 8 6 0 0 0 0 }
        name := 'Sulfur';
        Symbol := 'S';
        Group := '6A';
        MetalState := 'NS'; { NSM  SLGN }
        AaMass := '32.060';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 6;
        stage[4].elements := 0;
        stage[5].elements := 0;
        stage[6].elements := 0;
        stage[7].elements := 0;
      end;
    17:
      Begin { Chlorine	Cl	2 8 7 0 0 0 0 }
        name := 'Chlorine';
        Symbol := 'Cl';
        Group := '7A';
        MetalState := 'NG'; { NSM  SLGN }
        AaMass := '35.453';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 6;
        stage[4].elements := 0;
        stage[5].elements := 0;
        stage[6].elements := 0;
        stage[7].elements := 0;
      end;
    18:
      Begin { Argon		Ar	2 8 8 0 0 0 0 }
        name := 'Argon';
        Symbol := 'Ar';
        Group := '0';
        MetalState := 'NG'; { NSM  SLGN }
        AaMass := '39.948';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 8;
        stage[4].elements := 0;
        stage[5].elements := 0;
        stage[6].elements := 0;
        stage[7].elements := 0;
      end;
    19:
      Begin { Potassium	K	2 8 8 1 0 0 0 }
        name := 'Potassium';
        Symbol := 'K';
        Group := '1A';
        MetalState := 'MS'; { NSM  SLGN }
        AaMass := '39.098';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 8;
        stage[4].elements := 1;
        stage[5].elements := 0;
        stage[6].elements := 0;
        stage[7].elements := 0;
      end;
    20:
      Begin { Calcium		Ca	2 8 8 2 0 0 0 }
        name := 'Calcium';
        Symbol := 'Ca';
        Group := '2A';
        MetalState := 'MS'; { NSM  SLGN }
        AaMass := '40.080';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 8;
        stage[4].elements := 2;
        stage[5].elements := 0;
        stage[6].elements := 0;
        stage[7].elements := 0;
      end;
    21:
      Begin { Scandium	Sc	2 8 9 2 0 0 0 }
        name := 'Scandium';
        Symbol := 'Sc';
        Group := '3B';
        MetalState := 'MS'; { NSM  SLGN }
        AaMass := '44.956';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 9;
        stage[4].elements := 2;
        stage[5].elements := 0;
        stage[6].elements := 0;
        stage[7].elements := 0;
      end;
    22:
      Begin { Titanium	Ti	2 8 10 2 0 0 0 }
        name := 'Titanium';
        Symbol := 'Ti';
        Group := '4B';
        MetalState := 'MS'; { NSM  SLGN }
        AaMass := '47.900';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 10;
        stage[4].elements := 2;
        stage[5].elements := 0;
        stage[6].elements := 0;
        stage[7].elements := 0;
      end;
    23:
      Begin { Vanadium	V	2 8 11 2 0 0 0 }
        name := 'Vanadium';
        Symbol := 'V';
        Group := '5B';
        MetalState := 'MS'; { NSM  SLGN }
        AaMass := '50.941';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 11;
        stage[4].elements := 2;
        stage[5].elements := 0;
        stage[6].elements := 0;
        stage[7].elements := 0;
      end;
    24:
      Begin { Chromium	Cr	2 8 13 1 0 0 0 }
        name := 'Chromium';
        Symbol := 'Cr';
        Group := '6B';
        MetalState := 'MS'; { NSM  SLGN }
        AaMass := '51.996';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 13;
        stage[4].elements := 1;
        stage[5].elements := 0;
        stage[6].elements := 0;
        stage[7].elements := 0;
      end;
    25:
      Begin { Manganese	Mn	2 8 13 2 0 0 0 }
        name := 'Manganese';
        Symbol := 'Mn';
        Group := '7B';
        MetalState := 'MS'; { NSM  SLGN }
        AaMass := '54.938';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 13;
        stage[4].elements := 2;
        stage[5].elements := 0;
        stage[6].elements := 0;
        stage[7].elements := 0;
      end;
    26:
      Begin { Iron		Fe	2 8 14 3 0 0 0 }
        name := 'Iron';
        Symbol := 'Fe';
        Group := '8B';
        MetalState := 'MS'; { NSM  SLGN }
        AaMass := '55.847';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 14;
        stage[4].elements := 3;
        stage[5].elements := 0;
        stage[6].elements := 0;
        stage[7].elements := 0;
      end;
    27:
      Begin { Cobalt		Co	2 8 15 2 0 0 0 }
        name := 'Cobalt';
        Symbol := 'Co';
        Group := '8B';
        MetalState := 'MS'; { NSM  SLGN }
        AaMass := '58.933';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 15;
        stage[4].elements := 2;
        stage[5].elements := 0;
        stage[6].elements := 0;
        stage[7].elements := 0;
      end;
    28:
      Begin { Nickel		Ni	2 8 16 2 0 0 0 }
        name := 'Nickel';
        Symbol := 'Ni';
        Group := '8B';
        MetalState := 'MS'; { NSM  SLGN }
        AaMass := '58.71';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 16;
        stage[4].elements := 2;
        stage[5].elements := 0;
        stage[6].elements := 0;
        stage[7].elements := 0;
      end;
    29:
      Begin { Copper		Cu	2 8 18 1 0 0 0 }
        name := 'Copper';
        Symbol := 'Cu';
        Group := '1B';
        MetalState := 'MS'; { NSM  SLGN }
        AaMass := '63.546';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 18;
        stage[4].elements := 1;
        stage[5].elements := 0;
        stage[6].elements := 0;
        stage[7].elements := 0;
      end;
    30:
      Begin { Zinc		Zn	2 8 18 2 0 0 0 }
        name := 'Zinc';
        Symbol := 'Zn';
        Group := '2B';
        MetalState := 'MS'; { NSM  SLGN }
        AaMass := '65.380';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 18;
        stage[4].elements := 2;
        stage[5].elements := 0;
        stage[6].elements := 0;
        stage[7].elements := 0;
      end;
    31:
      Begin { Gallium		Ga	2 8 18 3 0 0 0 }
        name := 'Gallium';
        Symbol := 'Ga';
        Group := '3A';
        MetalState := 'MS'; { NSM  SLGN }
        AaMass := '69.72';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 18;
        stage[4].elements := 3;
        stage[5].elements := 0;
        stage[6].elements := 0;
        stage[7].elements := 0;
      end;
    32:
      Begin { Germanium	Ge	2 8 18 4 0 0 0 }
        name := 'Germanium';
        Symbol := 'Ge';
        Group := '4A';
        MetalState := 'SS'; { NSM  SLGN }
        AaMass := '72.590';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 18;
        stage[4].elements := 4;
        stage[5].elements := 0;
        stage[6].elements := 0;
        stage[7].elements := 0;
      end;
    33:
      Begin { Arsenic		As	2 8 18 5 0 0 0 }
        name := 'Arsenic';
        Symbol := 'As';
        Group := '5A';
        MetalState := 'SS'; { NSM  SLGN }
        AaMass := '74.922';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 18;
        stage[4].elements := 5;
        stage[5].elements := 0;
        stage[6].elements := 0;
        stage[7].elements := 0;
      end;
    34:
      Begin { Selenium	Se	2 8 18 6 0 0 0 }
        name := 'Selenium';
        Symbol := 'Se';
        Group := '6A';
        MetalState := 'NS'; { NSM  SLGN }
        AaMass := '78.960';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 18;
        stage[4].elements := 6;
        stage[5].elements := 0;
        stage[6].elements := 0;
        stage[7].elements := 0;
      end;
    35:
      Begin { Bromine		Br	2 8 18 7 0 0 0 }
        name := 'Bromine';
        Symbol := 'Br';
        Group := '7A';
        MetalState := 'NL'; { NSM  SLGN }
        AaMass := '79.904';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 18;
        stage[4].elements := 7;
        stage[5].elements := 0;
        stage[6].elements := 0;
        stage[7].elements := 0;
      end;
    36:
      Begin { Krypton		Kr	2 8 18 8 0 0 0 }
        name := 'Krypton';
        Symbol := 'Kr';
        Group := '0';
        MetalState := 'NG'; { NSM  SLGN }
        AaMass := '84.800';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 18;
        stage[4].elements := 8;
        stage[5].elements := 0;
        stage[6].elements := 0;
        stage[7].elements := 0;
      end;
    37:
      Begin { Rubidium	Rb	2 8 18 8 1 0 0 }
        name := 'Rubidium';
        Symbol := 'Rb';
        Group := '1A';
        MetalState := 'MS'; { NSM  SLGN }
        AaMass := '85.468';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 18;
        stage[4].elements := 8;
        stage[5].elements := 1;
        stage[6].elements := 0;
        stage[7].elements := 0;
      end;
    38:
      Begin { Strontium	Sr	2 8 18 8 2 0 0 }
        name := 'Strontium';
        Symbol := 'Sr';
        Group := '2A';
        MetalState := 'MS'; { NSM  SLGN }
        AaMass := '87.620';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 18;
        stage[4].elements := 8;
        stage[5].elements := 2;
        stage[6].elements := 0;
        stage[7].elements := 0;
      end;
    39:
      Begin { Yttrium		Y	2 8 18 9 2 0 0 }
        name := 'Yttrium';
        Symbol := 'Y';
        Group := '3B';
        MetalState := 'MS'; { NSM  SLGN }
        AaMass := '88.906';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 18;
        stage[4].elements := 9;
        stage[5].elements := 2;
        stage[6].elements := 0;
        stage[7].elements := 0;
      end;
    40:
      Begin { Zirconium	Zr	2 8 18 10 2 0 0 }
        name := 'Zirconium';
        Symbol := 'Zr';
        Group := '4B';
        MetalState := 'MS'; { NSM  SLGN }
        AaMass := '91.22';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 18;
        stage[4].elements := 10;
        stage[5].elements := 2;
        stage[6].elements := 0;
        stage[7].elements := 0;
      end;
    41:
      Begin { Niobium		Nb	2 8 18 12 1 0 0 }
        name := 'Niobium';
        Symbol := 'Nb';
        Group := '5B';
        MetalState := 'MS'; { NSM  SLGN }
        AaMass := '92.906';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 18;
        stage[4].elements := 12;
        stage[5].elements := 1;
        stage[6].elements := 0;
        stage[7].elements := 0;
      end;
    42:
      Begin { Molybdenum	Mo	2 8 18 13 1 0 0 }
        name := 'Molybdenum';
        Symbol := 'Mo';
        Group := '6B';
        MetalState := 'MS'; { NSM  SLGN }
        AaMass := '95.940';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 18;
        stage[4].elements := 13;
        stage[5].elements := 1;
        stage[6].elements := 0;
        stage[7].elements := 0;
      end;
    43:
      Begin { Technetium	Tc	2 8 18 14 1 0 0 }
        name := 'Technetium';
        Symbol := 'Tc';
        Group := '7B';
        MetalState := 'MS'; { NSM  SLGN }
        AaMass := '97.000';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 18;
        stage[4].elements := 14;
        stage[5].elements := 1;
        stage[6].elements := 0;
        stage[7].elements := 0;
      end;
    44:
      Begin { Ruthenium	Ru	2 8 18 15 1 0 0 }
        name := 'Ruthenium';
        Symbol := 'Ru';
        Group := '8B';
        MetalState := 'MS'; { NSM  SLGN }
        AaMass := '101.07';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 18;
        stage[4].elements := 15;
        stage[5].elements := 1;
        stage[6].elements := 0;
        stage[7].elements := 0;
      end;
    45:
      Begin { Rhodium		Rh	2 8 18 16 1 0 0 }
        name := 'Rhodium';
        Symbol := 'Rh';
        Group := '8B';
        MetalState := 'MS'; { NSM  SLGN }
        AaMass := '102.91';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 18;
        stage[4].elements := 16;
        stage[5].elements := 1;
        stage[6].elements := 0;
        stage[7].elements := 0;
      end;
    46:
      Begin { Palladium	Pd	2 8 18 18 0 0 0 }
        name := 'Palladium';
        Symbol := 'Pd';
        Group := '8B';
        MetalState := 'MS'; { NSM  SLGN }
        AaMass := '106.4';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 18;
        stage[4].elements := 18;
        stage[5].elements := 0;
        stage[6].elements := 0;
        stage[7].elements := 0;
      end;
    47:
      Begin { Silver		Ag	2 8 18 18 1 0 0 }
        name := 'Silver';
        Symbol := 'Ag';
        Group := '1B';
        MetalState := 'MS'; { NSM  SLGN }
        AaMass := '107.87';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 18;
        stage[4].elements := 18;
        stage[5].elements := 1;
        stage[6].elements := 0;
        stage[7].elements := 0;
      end;
    48:
      Begin { Cadmium		Cd	2 8 18 18 2 0 0 }
        name := 'Cadmium';
        Symbol := 'Cd';
        Group := '2B';
        MetalState := 'MS'; { NSM  SLGN }
        AaMass := '112.41';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 18;
        stage[4].elements := 18;
        stage[5].elements := 2;
        stage[6].elements := 0;
        stage[7].elements := 0;
      end;
    49:
      Begin { Indium		In	2 8 18 18 3 0 0 }
        name := 'Indium';
        Symbol := 'In';
        Group := '3A';
        MetalState := 'MS'; { NSM  SLGN }
        AaMass := '114.82';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 18;
        stage[4].elements := 18;
        stage[5].elements := 3;
        stage[6].elements := 0;
        stage[7].elements := 0;
      end;
    50:
      Begin { Tin		Sn	2 8 18 18 4 0 0 }
        name := 'Tin';
        Symbol := 'Sn';
        Group := '4A';
        MetalState := 'MS'; { NSM  SLGN }
        AaMass := '118.69';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 18;
        stage[4].elements := 18;
        stage[5].elements := 4;
        stage[6].elements := 0;
        stage[7].elements := 0;
      end;
    51:
      Begin { Antimony	Sb	2 8 18 18 5 0 0 }
        name := 'Antimony';
        Symbol := 'Sb';
        Group := '5A';
        MetalState := 'SS'; { NSM  SLGN }
        AaMass := '121.75';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 18;
        stage[4].elements := 18;
        stage[5].elements := 5;
        stage[6].elements := 0;
        stage[7].elements := 0;
      end;
    52:
      Begin { Tellurium	Te	2 8 18 18 6 0 0 }
        name := 'Tellurium';
        Symbol := 'Te';
        Group := '6A';
        MetalState := 'SS'; { NSM  SLGN }
        AaMass := '127.60';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 18;
        stage[4].elements := 18;
        stage[5].elements := 6;
        stage[6].elements := 0;
        stage[7].elements := 0;
      end;
    53:
      Begin { Iodine		I	2 8 18 18 7 0 0 }
        name := 'Iodine';
        Symbol := 'I';
        Group := '7A';
        MetalState := 'NS'; { NSM  SLGN }
        AaMass := '126.90';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 18;
        stage[4].elements := 18;
        stage[5].elements := 7;
        stage[6].elements := 0;
        stage[7].elements := 0;
      end;
    54:
      Begin { Xenon		Xe	2 8 18 18 8 0 0 }
        name := 'Xenon';
        Symbol := 'Xe';
        Group := '0';
        MetalState := 'NG'; { NSM  SLGN }
        AaMass := '131.30';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 18;
        stage[4].elements := 18;
        stage[5].elements := 8;
        stage[6].elements := 0;
        stage[7].elements := 0;
      end;
    55:
      Begin { Cesium		Cs	2 8 18 18 8 1 0 }
        name := 'Cesium';
        Symbol := 'Cs';
        Group := '1A';
        MetalState := 'MS'; { NSM  SLGN }
        AaMass := '132.91';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 18;
        stage[4].elements := 18;
        stage[5].elements := 8;
        stage[6].elements := 1;
        stage[7].elements := 0;
      end;
    56:
      Begin { Barium		Ba	2 8 18 18 8 2 0 }
        name := 'Barium';
        Symbol := 'Ba';
        Group := '2A';
        MetalState := 'MS'; { NSM  SLGN }
        AaMass := '137.33';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 18;
        stage[4].elements := 18;
        stage[5].elements := 8;
        stage[6].elements := 2;
        stage[7].elements := 0;
      end;
    57:
      Begin { Lanthanum	La	2 8 28 28 9 2 0 }
        name := 'Lanthanum';
        Symbol := 'La';
        Group := '3B';
        MetalState := 'MS'; { NSM  SLGN }
        AaMass := '138.91';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 18; { 28; }
        stage[4].elements := 18; { 28; }
        stage[5].elements := 9;
        stage[6].elements := 2;
        stage[7].elements := 0;
      end;
    58:
      Begin { Cerium		Ce	2 8 18 20 8 2 0 }
        name := 'Cerium';
        Symbol := 'Ce';
        Group := '3B';
        MetalState := 'MS'; { NSM  SLGN }
        AaMass := '140.12';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 18;
        stage[4].elements := 20;
        stage[5].elements := 8;
        stage[6].elements := 2;
        stage[7].elements := 0;
      end;
    59:
      Begin { Praseodymium	Pr	2 8 18 21 8 2 0 }
        name := 'Praseodymium';
        Symbol := 'Pr';
        Group := '3B';
        MetalState := 'MS'; { NSM  SLGN }
        AaMass := '140.91';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 18;
        stage[4].elements := 21;
        stage[5].elements := 8;
        stage[6].elements := 2;
        stage[7].elements := 0;
      end;
    60:
      Begin { Neodymium	Nd	2 8 18 22 8 2 0 }
        name := 'Neodymium';
        Symbol := 'Nd';
        Group := '3B';
        MetalState := 'MS'; { NSM  SLGN }
        AaMass := '144.24';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 18;
        stage[4].elements := 22;
        stage[5].elements := 8;
        stage[6].elements := 2;
        stage[7].elements := 0;
      end;
    61:
      Begin { Promethium	Pm	2 8 18 23 8 2 0 }
        name := 'Promethium';
        Symbol := 'Pm';
        Group := '3B';
        MetalState := 'MS'; { NSM  SLGN }
        AaMass := '145.00';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 18;
        stage[4].elements := 23;
        stage[5].elements := 8;
        stage[6].elements := 2;
        stage[7].elements := 0;
      end;
    62:
      Begin { Samarium	Sm	2 8 18 24 8 2 0 }
        name := 'Samarium';
        Symbol := 'Sm';
        Group := '3B';
        MetalState := 'MS'; { NSM  SLGN }
        AaMass := '150.40';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 18;
        stage[4].elements := 24;
        stage[5].elements := 8;
        stage[6].elements := 2;
        stage[7].elements := 0;
      end;
    63:
      Begin { Europium	Eu	2 8 18 25 8 2 0 }
        name := 'Europium';
        Symbol := 'Eu';
        Group := '3B';
        MetalState := 'MS'; { NSM  SLGN }
        AaMass := '151.96';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 18;
        stage[4].elements := 25;
        stage[5].elements := 8;
        stage[6].elements := 2;
        stage[7].elements := 0;
      end;
    64:
      Begin { Gadolinium	Gd	2 8 18 25 9 2 0 }
        name := 'Gadolinium';
        Symbol := 'Gd';
        Group := '3B';
        MetalState := 'MS'; { NSM  SLGN }
        AaMass := '157.25';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 18;
        stage[4].elements := 25;
        stage[5].elements := 9;
        stage[6].elements := 2;
        stage[7].elements := 0;
      end;
    65:
      Begin { Terbium		Tb	2 8 18 27 8 2 0 }
        name := 'Terbium';
        Symbol := 'Tb';
        Group := '3B';
        MetalState := 'MS'; { NSM  SLGN }
        AaMass := '158.93';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 18;
        stage[4].elements := 27;
        stage[5].elements := 8;
        stage[6].elements := 2;
        stage[7].elements := 0;
      end;
    66:
      Begin { Dysprosium	Dy	2 8 18 28 8 2 0 }
        name := 'Dysprosium';
        Symbol := 'Dy';
        Group := '3B';
        MetalState := 'MS'; { NSM  SLGN }
        AaMass := '162.50';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 18;
        stage[4].elements := 28;
        stage[5].elements := 8;
        stage[6].elements := 2;
        stage[7].elements := 0;
      end;
    67:
      Begin { Holmium		Ho 	2 8 18 29 8 2 0 }
        name := 'Holmium';
        Symbol := 'Ho';
        Group := '3B';
        MetalState := 'MS'; { NSM  SLGN }
        AaMass := '164.93';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 18;
        stage[4].elements := 29;
        stage[5].elements := 8;
        stage[6].elements := 2;
        stage[7].elements := 0;
      end;
    68:
      Begin { Erbium		Er 	2 8 18 30 8 2 0 }
        name := 'Erbium';
        Symbol := 'Er';
        Group := '3B';
        MetalState := 'MS'; { NSM  SLGN }
        AaMass := '167.26';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 18;
        stage[4].elements := 30;
        stage[5].elements := 8;
        stage[6].elements := 2;
        stage[7].elements := 0;
      end;
    69:
      Begin { Thulium		Tm	2 8 18 31 8 2 0 }
        name := 'Thulium';
        Symbol := 'Tm';
        Group := '3B';
        MetalState := 'MS'; { NSM  SLGN }
        AaMass := '168.93';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 18;
        stage[4].elements := 31;
        stage[5].elements := 8;
        stage[6].elements := 2;
        stage[7].elements := 0;
      end;
    70:
      Begin { Ytterbium	Yb	2 8 18 32 8 2 0 }
        name := 'Ytterbium';
        Symbol := 'Yb';
        Group := '3B';
        MetalState := 'MS'; { NSM  SLGN }
        AaMass := '173.04';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 18;
        stage[4].elements := 32;
        stage[5].elements := 8;
        stage[6].elements := 2;
        stage[7].elements := 0;
      end;
    71:
      Begin { Lutetium	Lu	2 8 18 32 9 2 0 }
        name := 'Lutetium';
        Symbol := 'Lu';
        Group := '3B';
        MetalState := 'MS'; { NSM  SLGN }
        AaMass := '174.97';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 18;
        stage[4].elements := 32;
        stage[5].elements := 9;
        stage[6].elements := 2;
        stage[7].elements := 0;
      end;
    72:
      Begin { Hafnium		Hf	2 8 18 32 10 2 0 }
        name := 'Hafnium';
        Symbol := 'Hf';
        Group := '4B';
        MetalState := 'MS'; { NSM  SLGN }
        AaMass := '178.49';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 18;
        stage[4].elements := 32;
        stage[5].elements := 10;
        stage[6].elements := 2;
        stage[7].elements := 0;
      end;
    73:
      Begin { Tantalum	Ta	2 8 18 32 11 2 0 }
        name := 'Tantalum';
        Symbol := 'Ta';
        Group := '5B';
        MetalState := 'MS'; { NSM  SLGN }
        AaMass := '180.95';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 18;
        stage[4].elements := 32;
        stage[5].elements := 11;
        stage[6].elements := 2;
        stage[7].elements := 0;
      end;
    74:
      Begin { Tungsten	W	2 8 18 32 12 2 0 }
        name := 'Tungsten';
        Symbol := 'W';
        Group := '6B';
        MetalState := 'MS'; { NSM  SLGN }
        AaMass := '183.85';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 18;
        stage[4].elements := 32;
        stage[5].elements := 12;
        stage[6].elements := 2;
        stage[7].elements := 0;
      end;
    75:
      Begin { Rhenium		Re	2 8 18 32 13 2 0 }
        name := 'Rhenium';
        Symbol := 'Re';
        Group := '7B';
        MetalState := 'MS'; { NSM  SLGN }
        AaMass := '186.21';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 18;
        stage[4].elements := 32;
        stage[5].elements := 13;
        stage[6].elements := 2;
        stage[7].elements := 0;
      end;
    76:
      Begin { Osmium		Os	2 8 18 32 14 2 0 }
        name := 'Osmium';
        Symbol := 'Os';
        Group := '8B';
        MetalState := 'MS'; { NSM  SLGN }
        AaMass := '190.20';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 18;
        stage[4].elements := 32;
        stage[5].elements := 14;
        stage[6].elements := 2;
        stage[7].elements := 0;
      end;
    77:
      Begin { Iridium		Ir	2 8 18 32 15 2 0 }
        name := 'Iridium';
        Symbol := 'Ir';
        Group := '8B';
        MetalState := 'MS'; { NSM  SLGN }
        AaMass := '192.22';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 18;
        stage[4].elements := 32;
        stage[5].elements := 15;
        stage[6].elements := 2;
        stage[7].elements := 0;
      end;
    78:
      Begin { Platinum	Pt	2 8 18 32 17 1 0 }
        name := 'Platinum';
        Symbol := 'Pt';
        Group := '8B';
        MetalState := 'MS'; { NSM  SLGN }
        AaMass := '195.09';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 18;
        stage[4].elements := 32;
        stage[5].elements := 17;
        stage[6].elements := 1;
        stage[7].elements := 0;
      end;
    79:
      Begin { Gold		Au	2 8 18 32 18 1 0 }
        name := 'Gold';
        Symbol := 'Au';
        Group := '1B';
        MetalState := 'MS'; { NSM  SLGN }
        AaMass := '196.97';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 18;
        stage[4].elements := 32;
        stage[5].elements := 18;
        stage[6].elements := 1;
        stage[7].elements := 0;
      end;
    80:
      Begin { Mercury		Hg	2 8 18 32 18 2 0 }
        name := 'Mercury';
        Symbol := 'Hg';
        Group := '2B';
        MetalState := 'ML'; { NSM  SLGN }
        AaMass := '200.59';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 18;
        stage[4].elements := 32;
        stage[5].elements := 18;
        stage[6].elements := 2;
        stage[7].elements := 0;
      end;
    81:
      Begin { Thallium	Tl	2 8 18 32 18 3 0 }
        name := 'Thallium';
        Symbol := 'Tl';
        Group := '3A';
        MetalState := 'MS'; { NSM  SLGN }
        AaMass := '204.37';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 18;
        stage[4].elements := 32;
        stage[5].elements := 18;
        stage[6].elements := 3;
        stage[7].elements := 0;
      end;
    82: // Lead		Pb	2 8 18 32 18 4 0
      begin
        name := 'Lead';
        Symbol := 'Pb';
        Group := '4A';
        MetalState := 'MS'; { NSM  SLGN }
        AaMass := '207.20';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 18;
        stage[4].elements := 32;
        stage[5].elements := 18;
        stage[6].elements := 4;
        stage[7].elements := 0;
      end;
    83:
      Begin { Bismuth		Bi	2 8 18 32 18 5 0 }
        name := 'Bismuth';
        Symbol := 'Bi';
        Group := '5A';
        MetalState := 'MS'; { NSM  SLGN }
        AaMass := '208.98';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 18;
        stage[4].elements := 32;
        stage[5].elements := 18;
        stage[6].elements := 5;
        stage[7].elements := 0;
      end;
    84: // Polonium	Po	2 8 18 32 18 6 0
      begin
        name := 'Polonium';
        Symbol := 'Po';
        Group := '6A';
        MetalState := 'SS'; { NSM  SLGN }
        AaMass := '209.00';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 18;
        stage[4].elements := 32;
        stage[5].elements := 18;
        stage[6].elements := 6;
        stage[7].elements := 0;
      end;
    85:
      Begin { Astatine	At	2 8 18 32 18 7 0 }
        name := 'Astatine';
        Symbol := 'At';
        Group := '7A';
        MetalState := 'SS'; { NSM  SLGN }
        AaMass := '210.00';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 18;
        stage[4].elements := 32;
        stage[5].elements := 18;
        stage[6].elements := 7;
        stage[7].elements := 0;
      end;
    86:
      Begin { Radon		Rn	2 8 18 32 18 8 0 }
        name := 'Radon';
        Symbol := 'Rn';
        Group := '0';
        MetalState := 'NG'; { NSM  SLGN }
        AaMass := '222.00';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 18;
        stage[4].elements := 32;
        stage[5].elements := 18;
        stage[6].elements := 8;
        stage[7].elements := 0;
      end;
    87:
      Begin { Francium	Fr	2 8 18 32 18 8 1 }
        name := 'Francium';
        Symbol := 'Fr';
        Group := '1A';
        MetalState := 'MS'; { NSM  SLGN }
        AaMass := '223.00';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 18;
        stage[4].elements := 32;
        stage[5].elements := 18;
        stage[6].elements := 8;
        stage[7].elements := 1;
      end;
    88:
      Begin { Radium		Ra	2 8 18 32 18 8 2 }
        name := 'Radium';
        Symbol := 'Ra';
        Group := '2A';
        MetalState := 'MS'; { NSM  SLGN }
        AaMass := '226.03';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 18;
        stage[4].elements := 32;
        stage[5].elements := 18;
        stage[6].elements := 8;
        stage[7].elements := 2;
      end;
    89:
      Begin { Actinium	Ac	2 8 18 32 18 9 2 }
        name := 'Actinium';
        Symbol := 'Ac';
        Group := '3B';
        MetalState := 'MS'; { NSM  SLGN }
        AaMass := '227.00';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 18;
        stage[4].elements := 32;
        stage[5].elements := 18;
        stage[6].elements := 9;
        stage[7].elements := 2;
      end;
    90: // Thorium		Th	2 8 18 32 18 10 2
      begin
        name := 'Thorium';
        Symbol := 'Th';
        Group := '3B';
        MetalState := 'MS'; { NSM  SLGN }
        AaMass := '232.04';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 18;
        stage[4].elements := 32;
        stage[5].elements := 18;
        stage[6].elements := 10;
        stage[7].elements := 2;
      end;
    91: // Protactinium	Pa	2 8 18 32 20 9 2
      begin
        name := 'Protactinium';
        Symbol := 'Pa';
        Group := '3B';
        MetalState := 'MS'; { NSM  SLGN }
        AaMass := '231.04';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 18;
        stage[4].elements := 32;
        stage[5].elements := 20;
        stage[6].elements := 9;
        stage[7].elements := 2;
      end;
    92: // Uranium		U	2 8 18 32 21 8 2
      begin
        name := 'Uranium';
        Symbol := 'U';
        Group := '3B';
        MetalState := 'MS'; { NSM  SLGN }
        AaMass := '238.03';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 18;
        stage[4].elements := 32;
        stage[5].elements := 21;
        stage[6].elements := 8;
        stage[7].elements := 2;
      end;
    93: // Neptunium	Np	2 8 18 32 23 8 2
      begin
        name := 'Neptunium';
        Symbol := 'Np';
        Group := '3B';
        MetalState := 'MS'; { NSM  SLGN }
        AaMass := '237.05';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 18;
        stage[4].elements := 32;
        stage[5].elements := 23;
        stage[6].elements := 8;
        stage[7].elements := 2;
      end;
    94: // Plutonium	Pu	2 8 18 32 24 8 2
      Begin
        name := 'Plutonium';
        Symbol := 'Pu';
        Group := '3B';
        MetalState := 'MS'; { NSM  SLGN }
        AaMass := '244.00';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 18;
        stage[4].elements := 32;
        stage[5].elements := 24;
        stage[6].elements := 8;
        stage[7].elements := 2;
      end;
    95: // Americium	Am	2 8 18 32 25 8 2
      begin
        name := 'Americium';
        Symbol := 'Am';
        Group := '3B';
        MetalState := 'MS'; { NSM  SLGN }
        AaMass := '243.00';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 18;
        stage[4].elements := 32;
        stage[5].elements := 25;
        stage[6].elements := 8;
        stage[7].elements := 2;
      end;
    96: // Curium		Cm	2 8 18 32 25 9 2
      begin
        name := 'Curium';
        Symbol := 'Cm';
        Group := '3B';
        MetalState := 'MS'; { NSM  SLGN }
        AaMass := '247.00';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 18;
        stage[4].elements := 32;
        stage[5].elements := 25;
        stage[6].elements := 9;
        stage[7].elements := 2;
      end;
    97: // Berkelium	Bk	2 8 18 32 26 9 2
      begin
        name := 'Berkelium';
        Symbol := 'Bk';
        Group := '3B';
        MetalState := 'MS'; { NSM  SLGN }
        AaMass := '247.00';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 18;
        stage[4].elements := 32;
        stage[5].elements := 26;
        stage[6].elements := 9;
        stage[7].elements := 2;
      end;
    98: // Californium	Cf	2 8 18 32 28 8 2
      begin
        name := 'Californium';
        Symbol := 'Cf';
        Group := '3B';
        MetalState := 'MS'; { NSM  SLGN }
        AaMass := '251.00';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 18;
        stage[4].elements := 32;
        stage[5].elements := 28;
        stage[6].elements := 8;
        stage[7].elements := 2;
      end;
    99: // Einsteinium	Es	2 8 18 32 29 8 2
      begin
        name := 'Einsteinium';
        Symbol := 'Es';
        Group := '3B';
        MetalState := 'MS'; { NSM  SLGN }
        AaMass := '254.00';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 18;
        stage[4].elements := 32;
        stage[5].elements := 29;
        stage[6].elements := 8;
        stage[7].elements := 2;
      end;
    100: // Fermium		Fm	2 8 18 32 30 8 2
      begin
        name := 'Fermium';
        Symbol := 'Fm';
        Group := '3B';
        MetalState := 'MS'; { NSM  SLGN }
        AaMass := '257.00';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 18;
        stage[4].elements := 32;
        stage[5].elements := 30;
        stage[6].elements := 8;
        stage[7].elements := 2;
      end;
    101: // Mendelevium	Md	2 8 18 32 31 8 2
      begin
        name := 'Mendelevium';
        Symbol := 'Md';
        Group := '3B';
        MetalState := 'MS'; { NSM  SLGN }
        AaMass := '258.00';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 18;
        stage[4].elements := 32;
        stage[5].elements := 31;
        stage[6].elements := 8;
        stage[7].elements := 2;
      end;
    102: // Nobelium	No	2 8 18 32 32 8 2
      begin
        name := 'Nobelium';
        Symbol := 'No';
        Group := '3B';
        MetalState := 'MS'; { NSM  SLGN }
        AaMass := '259.00';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 18;
        stage[4].elements := 32;
        stage[5].elements := 32;
        stage[6].elements := 8;
        stage[7].elements := 2;
      end;
    103:
      begin // Lawrencium	Lr	2 8 18 32 32 9 2
        name := 'Lawrencium';
        Symbol := 'Lr';
        Group := '3B';
        MetalState := 'MS'; { NSM  SLGN }
        AaMass := '260.00';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 18;
        stage[4].elements := 32;
        stage[5].elements := 32;
        stage[6].elements := 9;
        stage[7].elements := 2;
      end;
    104: // Rutherfordium	Rf	2 8 18 32 32 10 2
      begin
        name := 'Rutherfordium';
        Symbol := 'Rf';
        Group := '4B';
        MetalState := 'MS'; { NSM  SLGN }
        AaMass := '261.00';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 18;
        stage[4].elements := 32;
        stage[5].elements := 32;
        stage[6].elements := 10;
        stage[7].elements := 2;
      end;
    105: // Dubnium		Db	2 8 18 32 32 11 2
      begin
        name := 'Dubnium';
        Symbol := 'Db';
        Group := '5B';
        MetalState := 'MS'; { NSM  SLGN }
        AaMass := '262.00';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 18;
        stage[4].elements := 32;
        stage[5].elements := 32;
        stage[6].elements := 11;
        stage[7].elements := 2;
      end;
    106: // Bohrium		Bh	2 8 18 32 32 12 2
      begin
        name := 'Bohrium';
        Symbol := 'Bh';
        Group := '6B';
        MetalState := 'MS'; { NSM  SLGN }
        AaMass := '263.00';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 18;
        stage[4].elements := 32;
        stage[5].elements := 32;
        stage[6].elements := 12;
        stage[7].elements := 2;
      end;
    107: // Seaborgium	Sg	2 8 18 32 32 13 2
      begin
        name := 'Seaborgium';
        Symbol := 'Sg';
        Group := '7B';
        MetalState := 'MS'; { NSM  SLGN }
        AaMass := '264.00';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 18;
        stage[4].elements := 32;
        stage[5].elements := 32;
        stage[6].elements := 13;
        stage[7].elements := 2;
      end;
    108: // Hassium		Hs	2 8 18 32 32 14 2
      begin
        name := 'Hassium';
        Symbol := 'Hs';
        Group := '8B';
        MetalState := 'MS'; { NSM  SLGN }
        AaMass := '265.00';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 18;
        stage[4].elements := 32;
        stage[5].elements := 32;
        stage[6].elements := 14;
        stage[7].elements := 2;
      end;
    109:
      Begin { Meitnerium	Mt	2 8 18 32 32 15 2 }
        name := 'Meitnerium';
        Symbol := 'Mt';
        Group := '8B';
        MetalState := 'MS'; { NSM  SLGN }
        AaMass := '266.00';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 18;
        stage[4].elements := 32;
        stage[5].elements := 32;
        stage[6].elements := 15;
        stage[7].elements := 2;
      end;
    110:
      Begin { Ununnilium	Uun	2 8 18 32 32 17 2 }
        name := 'Ununnilium';
        Symbol := 'Uun';
        Group := '8B';
        MetalState := 'MS'; { NSM  SLGN }
        AaMass := '268.00';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 18;
        stage[4].elements := 32;
        stage[5].elements := 32;
        stage[6].elements := 17;
        stage[7].elements := 2;
      end;
    111:
      Begin { Unununium 	Uuu	2 8 18 32 32 18 1 }
        name := 'Unununium';
        Symbol := 'Uuu';
        Group := '1B';
        MetalState := 'MS'; { NSM  SLGN }
        AaMass := '269.00';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 18;
        stage[4].elements := 32;
        stage[5].elements := 32;
        stage[6].elements := 18;
        stage[7].elements := 1;
      end;
    112:
      Begin { Ununbium 	Uub	2 8 18 32 32 18 2 }
        name := 'Ununbium';
        Symbol := 'Uub';
        Group := '2B';
        MetalState := 'MS'; { NSM  SLGN }
        AaMass := '270.00';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 18;
        stage[4].elements := 32;
        stage[5].elements := 32;
        stage[6].elements := 18;
        stage[7].elements := 2;
      end;
    113:
      Begin { Ununquadium 	Uuq	2 8 18 32 32 18 4 }
        name := 'Ununquadium';
        Symbol := 'Uuq';
        Group := '3A';
        MetalState := 'MS'; { NSM  SLGN }
        AaMass := '272.00';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 18;
        stage[4].elements := 32;
        stage[5].elements := 32;
        stage[6].elements := 18;
        stage[7].elements := 4;
      end;
    114:
      begin { Ununhexium 	Uuh	2 8 18 32 32 18 6 }
        name := 'Ununhexium';
        Symbol := 'Uuh';
        Group := '4A';
        MetalState := 'MS'; { NSM  SLGN }
        AaMass := '274.00';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 18;
        stage[4].elements := 32;
        stage[5].elements := 32;
        stage[6].elements := 18;
        stage[7].elements := 6;
      end;
    115:
      begin { Ununoctium 	Uuo	2 8 18 32 32 18 8 }
        name := 'Ununoctium';
        Symbol := 'Uuo';
        Group := '6A';
        MetalState := 'MS'; { NSM  SLGN }
        AaMass := '276.00';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 18;
        stage[4].elements := 32;
        stage[5].elements := 32;
        stage[6].elements := 18;
        stage[7].elements := 8;
      end;
    116:
      begin { NotRealOne	XXX	2 8 18 32 32 32 32 }
        name := 'UnRealium';
        Symbol := 'Uux';
        Group := '7A';
        MetalState := 'SS'; { NSM  SLGN }
        AaMass := '286.00';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 18;
        stage[4].elements := 32;
        stage[5].elements := 32;
        stage[6].elements := 18;
        stage[7].elements := 18;
      end;
    117:
      begin { NotRealOne	XXX	2 8 18 32 32 32 32 }
        name := 'UraGasium';
        Symbol := 'Uug';
        Group := '0';
        MetalState := 'SG'; { NSM  SLGN }
        AaMass := '318.00';
        stage[1].elements := 2;
        stage[2].elements := 8;
        stage[3].elements := 18;
        stage[4].elements := 32;
        stage[5].elements := 32;
        stage[6].elements := 32;
        stage[7].elements := 32;
      end
  else
    begin { NotRealOne	XXX	2 8 18 32 32 32 32 }
      name := 'Unknown';
      Symbol := 'xxx';
      Group := 'X';
      MetalState := 'XX'; { NSM  SLGN }
      AaMass := '318.00';
      stage[1].elements := 2;
      stage[2].elements := 8;
      stage[3].elements := 18;
      stage[4].elements := 32;
      stage[5].elements := 32;
      stage[6].elements := 32;
      stage[7].elements := 32;
    end;
  end; // Case

  Total := stage[1].elements + stage[2].elements + stage[3].elements +
    stage[4].elements + stage[5].elements + stage[6].elements +
    stage[7].elements;

  StatusBar1.SimpleText :=
  { 'Atom Name: '+ } name
  { +', Symbol: ' } + ' : ' + Symbol + ' : ' + Group + ' : ' + MetalState +
    ', Electrons: ' + IntToStr(stage[1].elements) + ', ' +
    Inttostr(stage[2].elements) + ', ' + Inttostr(stage[3].elements) + ', ' +
    Inttostr(stage[4].elements) + ', ' + Inttostr(stage[5].elements) + ', ' +
    Inttostr(stage[6].elements) + ', ' + Inttostr(stage[7].elements) +
    ', Total: ' + Inttostr(Total) + ', ~: ' + AaMass;
  Application.processmessages;
  { NotRealOne	XXX	2 8 18 32 32 32 32 }
  { 7 Dummycubes ~32 spheres each }
  { Display or Hide them depending on ATOM }
  for i := 0 to 1 do
  begin
    If i < stage[1].elements then
      (DummyCube1.Children[i] as TGLSphere).Visible := true
    else
      (DummyCube1.Children[i] as TGLSphere).Visible := False;
    If ((i < stage[1].elements) and (ps.bStereo)) then
      (DummyCubeRed1.Children[i] as TGLSphere).Visible := true
    else
      (DummyCubeRed1.Children[i] as TGLSphere).Visible := False;
  end;
  for i := 0 to 7 do
  begin
    If i < stage[2].elements then
      (DummyCube2.Children[i] as TGLSphere).Visible := true
    else
      (DummyCube2.Children[i] as TGLSphere).Visible := False;
    If ((i < stage[2].elements) and (ps.bStereo)) then
      (DummyCubeRed2.Children[i] as TGLSphere).Visible := true
    else
      (DummyCubeRed2.Children[i] as TGLSphere).Visible := False;
  end;
  for i := 0 to 17 do
  begin
    If i < stage[3].elements then
      (DummyCube3.Children[i] as TGLSphere).Visible := true
    else
      (DummyCube3.Children[i] as TGLSphere).Visible := False;
    If ((i < stage[3].elements) and (ps.bStereo)) then
      (DummyCubeRed3.Children[i] as TGLSphere).Visible := true
    else
      (DummyCubeRed3.Children[i] as TGLSphere).Visible := False;
  end;
  for i := 0 to 31 do
  begin
    If i < stage[4].elements then
      (DummyCube4.Children[i] as TGLSphere).Visible := true
    else
      (DummyCube4.Children[i] as TGLSphere).Visible := False;
    If ((i < stage[4].elements) and (ps.bStereo)) then
      (DummyCubeRed4.Children[i] as TGLSphere).Visible := true
    else
      (DummyCubeRed4.Children[i] as TGLSphere).Visible := False;
  end;
  for i := 0 to 31 do
  begin
    If i < stage[5].elements then
      (DummyCube5.Children[i] as TGLSphere).Visible := true
    else
      (DummyCube5.Children[i] as TGLSphere).Visible := False;
    If ((i < stage[5].elements) and (ps.bStereo)) then
      (DummyCubeRed5.Children[i] as TGLSphere).Visible := true
    else
      (DummyCubeRed5.Children[i] as TGLSphere).Visible := False;
  end;
  for i := 0 to 31 do
  begin
    If i < stage[6].elements then
      (DummyCube6.Children[i] as TGLSphere).Visible := true
    else
      (DummyCube6.Children[i] as TGLSphere).Visible := False;
    If ((i < stage[6].elements) and (ps.bStereo)) then
      (DummyCubeRed6.Children[i] as TGLSphere).Visible := true
    else
      (DummyCubeRed6.Children[i] as TGLSphere).Visible := False;
  end;
  for i := 0 to 31 do
  begin
    If i < stage[7].elements then
      (DummyCube7.Children[i] as TGLSphere).Visible := true
    else
      (DummyCube7.Children[i] as TGLSphere).Visible := False;
    If ((i < stage[7].elements) and (ps.bStereo)) then
      (DummyCubeRed7.Children[i] as TGLSphere).Visible := true
    else
      (DummyCubeRed7.Children[i] as TGLSphere).Visible := False;
  end;
end; // end load_atom()


// ***************************************************************
{ NotRealOne	XXX	2 8 18 32 32 32 32 }
{ 7 Dummycubes ~32 spheres each }
{ Now used to reset spheres to Red / Blue for Stereo }
// ***************************************************************
procedure TAAtomForm.PaintAtoms;
var
  i: Integer;
begin
  for i := 0 to 1 do
  begin
    // If i <= stage[1].elements then begin
    with (DummyCube1.Children[i] as TGLSphere) do
    begin { PaintColor }{ <0.012 0.012 0.175 0.550>   :=  coloris; }
      { This works and saves code, as there is a Template sphere }
      Material.FrontProperties.Ambient.Assign
        (sphRed.Material.FrontProperties.Ambient);
      Material.FrontProperties.Diffuse.Assign
        (sphRed.Material.FrontProperties.Diffuse);
      Material.FrontProperties.Specular.Assign
        (sphRed.Material.FrontProperties.Specular);

      { Material.FrontProperties.Ambient.Alpha:=0.55;
        Material.FrontProperties.Ambient.Blue:=0.01175;
        Material.FrontProperties.Ambient.Green:=0.01175;
        Material.FrontProperties.Ambient.Red:=0.1745;
        Material.FrontProperties.Diffuse.Alpha:=0.55;
        Material.FrontProperties.Diffuse.Blue:=0.04136;
        Material.FrontProperties.Diffuse.Green:=0.04136;
        Material.FrontProperties.Diffuse.Red:=0.61424;
        Material.FrontProperties.Specular.Alpha:=0.55;
        Material.FrontProperties.Specular.Blue:=0.626959;
        Material.FrontProperties.Specular.Green:=0.626959;
        Material.FrontProperties.Specular.Red:=0.727811; }
      Material.FrontProperties.Shininess := 76;
    end;
    with (DummyCubeRed1.Children[i] as TGLSphere) do
    begin // Green
      Material.FrontProperties.Ambient.Assign
        (sphBlue.Material.FrontProperties.Ambient);
      Material.FrontProperties.Diffuse.Assign
        (sphBlue.Material.FrontProperties.Diffuse);
      Material.FrontProperties.Specular.Assign
        (sphBlue.Material.FrontProperties.Specular);
      { Material.FrontProperties.Ambient.Alpha:=0.55;
        Material.FrontProperties.Ambient.Blue:=0.1745;
        Material.FrontProperties.Ambient.Green:=0.01175;
        Material.FrontProperties.Ambient.Red:=0.01175;
        Material.FrontProperties.Diffuse.Alpha:=0.55;
        Material.FrontProperties.Diffuse.Blue:=0.61424;
        Material.FrontProperties.Diffuse.Green:=0.04136;
        Material.FrontProperties.Diffuse.Red:=0.04136;
        Material.FrontProperties.Specular.Alpha:=0.55;
        Material.FrontProperties.Specular.Blue:=0.727811;
        Material.FrontProperties.Specular.Green:=0.626959;
        Material.FrontProperties.Specular.Red:=0.626959; }
      Material.FrontProperties.Shininess := 76;
    end;
  end;
  { end; }
  for i := 0 to 7 do
  begin
    // If i <= stage[2].elements then begin
    with (DummyCube2.Children[i] as TGLSphere) do
    begin
      Material.FrontProperties.Ambient.Alpha := 0.55;
      Material.FrontProperties.Ambient.Blue := 0.01175;
      Material.FrontProperties.Ambient.Green := 0.01175;
      Material.FrontProperties.Ambient.Red := 0.1745;
      Material.FrontProperties.Diffuse.Alpha := 0.55;
      Material.FrontProperties.Diffuse.Blue := 0.04136;
      Material.FrontProperties.Diffuse.Green := 0.04136;
      Material.FrontProperties.Diffuse.Red := 0.61424;
      Material.FrontProperties.Specular.Alpha := 0.55;
      Material.FrontProperties.Specular.Blue := 0.626959;
      Material.FrontProperties.Specular.Green := 0.626959;
      Material.FrontProperties.Specular.Red := 0.727811;
      Material.FrontProperties.Shininess := 76;
    end;
    with (DummyCubeRed2.Children[i] as TGLSphere) do
    begin // Green
      Material.FrontProperties.Ambient.Alpha := 0.55;
      Material.FrontProperties.Ambient.Blue := 0.1745;
      Material.FrontProperties.Ambient.Green := 0.01175;
      Material.FrontProperties.Ambient.Red := 0.01175;
      Material.FrontProperties.Diffuse.Alpha := 0.55;
      Material.FrontProperties.Diffuse.Blue := 0.61424;
      Material.FrontProperties.Diffuse.Green := 0.04136;
      Material.FrontProperties.Diffuse.Red := 0.04136;
      Material.FrontProperties.Specular.Alpha := 0.55;
      Material.FrontProperties.Specular.Blue := 0.727811;
      Material.FrontProperties.Specular.Green := 0.626959;
      Material.FrontProperties.Specular.Red := 0.626959;
      Material.FrontProperties.Shininess := 76;
    end;
  end;
  { end; }
  for i := 0 to 17 do
  begin
    // If i <= stage[3].elements then begin
    with (DummyCube3.Children[i] as TGLSphere) do
    begin
      Material.FrontProperties.Ambient.Alpha := 0.55;
      Material.FrontProperties.Ambient.Blue := 0.01175;
      Material.FrontProperties.Ambient.Green := 0.01175;
      Material.FrontProperties.Ambient.Red := 0.1745;
      Material.FrontProperties.Diffuse.Alpha := 0.55;
      Material.FrontProperties.Diffuse.Blue := 0.04136;
      Material.FrontProperties.Diffuse.Green := 0.04136;
      Material.FrontProperties.Diffuse.Red := 0.61424;
      Material.FrontProperties.Specular.Alpha := 0.55;
      Material.FrontProperties.Specular.Blue := 0.626959;
      Material.FrontProperties.Specular.Green := 0.626959;
      Material.FrontProperties.Specular.Red := 0.727811;
      Material.FrontProperties.Shininess := 76;
    end;
    with (DummyCubeRed3.Children[i] as TGLSphere) do
    begin { Green }
      Material.FrontProperties.Ambient.Alpha := 0.55;
      Material.FrontProperties.Ambient.Blue := 0.1745;
      Material.FrontProperties.Ambient.Green := 0.01175;
      Material.FrontProperties.Ambient.Red := 0.01175;
      Material.FrontProperties.Diffuse.Alpha := 0.55;
      Material.FrontProperties.Diffuse.Blue := 0.61424;
      Material.FrontProperties.Diffuse.Green := 0.04136;
      Material.FrontProperties.Diffuse.Red := 0.04136;
      Material.FrontProperties.Specular.Alpha := 0.55;
      Material.FrontProperties.Specular.Blue := 0.727811;
      Material.FrontProperties.Specular.Green := 0.626959;
      Material.FrontProperties.Specular.Red := 0.626959;
      Material.FrontProperties.Shininess := 76;
    end;
  end;
  { end; }
  for i := 0 to 31 do
  begin
    // If i <= stage[4].elements then begin
    with (DummyCube4.Children[i] as TGLSphere) do
    begin
      Material.FrontProperties.Ambient.Alpha := 0.55;
      Material.FrontProperties.Ambient.Blue := 0.01175;
      Material.FrontProperties.Ambient.Green := 0.01175;
      Material.FrontProperties.Ambient.Red := 0.1745;
      Material.FrontProperties.Diffuse.Alpha := 0.55;
      Material.FrontProperties.Diffuse.Blue := 0.04136;
      Material.FrontProperties.Diffuse.Green := 0.04136;
      Material.FrontProperties.Diffuse.Red := 0.61424;
      Material.FrontProperties.Specular.Alpha := 0.55;
      Material.FrontProperties.Specular.Blue := 0.626959;
      Material.FrontProperties.Specular.Green := 0.626959;
      Material.FrontProperties.Specular.Red := 0.727811;
      Material.FrontProperties.Shininess := 76;
    end;
    with (DummyCubeRed4.Children[i] as TGLSphere) do
    begin { Green }
      Material.FrontProperties.Ambient.Alpha := 0.55;
      Material.FrontProperties.Ambient.Blue := 0.1745;
      Material.FrontProperties.Ambient.Green := 0.01175;
      Material.FrontProperties.Ambient.Red := 0.01175;
      Material.FrontProperties.Diffuse.Alpha := 0.55;
      Material.FrontProperties.Diffuse.Blue := 0.61424;
      Material.FrontProperties.Diffuse.Green := 0.04136;
      Material.FrontProperties.Diffuse.Red := 0.04136;
      Material.FrontProperties.Specular.Alpha := 0.55;
      Material.FrontProperties.Specular.Blue := 0.727811;
      Material.FrontProperties.Specular.Green := 0.626959;
      Material.FrontProperties.Specular.Red := 0.626959;
      Material.FrontProperties.Shininess := 76;
    end;
  end;
  { end; }
  for i := 0 to 31 do
  begin
    { If i <= stage[5].elements then begin }
    with (DummyCube5.Children[i] as TGLSphere) do
    begin
      Material.FrontProperties.Ambient.Alpha := 0.55;
      Material.FrontProperties.Ambient.Blue := 0.01175;
      Material.FrontProperties.Ambient.Green := 0.01175;
      Material.FrontProperties.Ambient.Red := 0.1745;
      Material.FrontProperties.Diffuse.Alpha := 0.55;
      Material.FrontProperties.Diffuse.Blue := 0.04136;
      Material.FrontProperties.Diffuse.Green := 0.04136;
      Material.FrontProperties.Diffuse.Red := 0.61424;
      Material.FrontProperties.Specular.Alpha := 0.55;
      Material.FrontProperties.Specular.Blue := 0.626959;
      Material.FrontProperties.Specular.Green := 0.626959;
      Material.FrontProperties.Specular.Red := 0.727811;
      Material.FrontProperties.Shininess := 76;
    end;
    with (DummyCubeRed5.Children[i] as TGLSphere) do
    begin { Green }
      Material.FrontProperties.Ambient.Alpha := 0.55;
      Material.FrontProperties.Ambient.Blue := 0.1745;
      Material.FrontProperties.Ambient.Green := 0.01175;
      Material.FrontProperties.Ambient.Red := 0.01175;
      Material.FrontProperties.Diffuse.Alpha := 0.55;
      Material.FrontProperties.Diffuse.Blue := 0.61424;
      Material.FrontProperties.Diffuse.Green := 0.04136;
      Material.FrontProperties.Diffuse.Red := 0.04136;
      Material.FrontProperties.Specular.Alpha := 0.55;
      Material.FrontProperties.Specular.Blue := 0.727811;
      Material.FrontProperties.Specular.Green := 0.626959;
      Material.FrontProperties.Specular.Red := 0.626959;
      Material.FrontProperties.Shininess := 76;
    end;
  end;
  { end; }
  for i := 0 to 31 do
  begin
    { If i <= stage[6].elements then begin }
    with (DummyCube6.Children[i] as TGLSphere) do
    begin
      Material.FrontProperties.Ambient.Alpha := 0.55;
      Material.FrontProperties.Ambient.Blue := 0.01175;
      Material.FrontProperties.Ambient.Green := 0.01175;
      Material.FrontProperties.Ambient.Red := 0.1745;
      Material.FrontProperties.Diffuse.Alpha := 0.55;
      Material.FrontProperties.Diffuse.Blue := 0.04136;
      Material.FrontProperties.Diffuse.Green := 0.04136;
      Material.FrontProperties.Diffuse.Red := 0.61424;
      Material.FrontProperties.Specular.Alpha := 0.55;
      Material.FrontProperties.Specular.Blue := 0.626959;
      Material.FrontProperties.Specular.Green := 0.626959;
      Material.FrontProperties.Specular.Red := 0.727811;
      Material.FrontProperties.Shininess := 76;
    end;
    with (DummyCubeRed6.Children[i] as TGLSphere) do
    begin { Green }
      Material.FrontProperties.Ambient.Alpha := 0.55;
      Material.FrontProperties.Ambient.Blue := 0.1745;
      Material.FrontProperties.Ambient.Green := 0.01175;
      Material.FrontProperties.Ambient.Red := 0.01175;
      Material.FrontProperties.Diffuse.Alpha := 0.55;
      Material.FrontProperties.Diffuse.Blue := 0.61424;
      Material.FrontProperties.Diffuse.Green := 0.04136;
      Material.FrontProperties.Diffuse.Red := 0.04136;
      Material.FrontProperties.Specular.Alpha := 0.55;
      Material.FrontProperties.Specular.Blue := 0.727811;
      Material.FrontProperties.Specular.Green := 0.626959;
      Material.FrontProperties.Specular.Red := 0.626959;
      Material.FrontProperties.Shininess := 76;
    end;
  end;
  { end; }
  for i := 0 to 31 do
  begin
    // If i <= stage[7].elements then begin
    with (DummyCube7.Children[i] as TGLSphere) do
    begin
      Material.FrontProperties.Ambient.Alpha := 0.55;
      Material.FrontProperties.Ambient.Blue := 0.01175;
      Material.FrontProperties.Ambient.Green := 0.01175;
      Material.FrontProperties.Ambient.Red := 0.1745;
      Material.FrontProperties.Diffuse.Alpha := 0.55;
      Material.FrontProperties.Diffuse.Blue := 0.04136;
      Material.FrontProperties.Diffuse.Green := 0.04136;
      Material.FrontProperties.Diffuse.Red := 0.61424;
      Material.FrontProperties.Specular.Alpha := 0.55;
      Material.FrontProperties.Specular.Blue := 0.626959;
      Material.FrontProperties.Specular.Green := 0.626959;
      Material.FrontProperties.Specular.Red := 0.727811;
      Material.FrontProperties.Shininess := 76;
    end;
    with (DummyCubeRed7.Children[i] as TGLSphere) do
    begin { Green }
      Material.FrontProperties.Ambient.Alpha := 0.55;
      Material.FrontProperties.Ambient.Blue := 0.1745;
      Material.FrontProperties.Ambient.Green := 0.01175;
      Material.FrontProperties.Ambient.Red := 0.01175;
      Material.FrontProperties.Diffuse.Alpha := 0.55;
      Material.FrontProperties.Diffuse.Blue := 0.61424;
      Material.FrontProperties.Diffuse.Green := 0.04136;
      Material.FrontProperties.Diffuse.Red := 0.04136;
      Material.FrontProperties.Specular.Alpha := 0.55;
      Material.FrontProperties.Specular.Blue := 0.727811;
      Material.FrontProperties.Specular.Green := 0.626959;
      Material.FrontProperties.Specular.Red := 0.626959;
      Material.FrontProperties.Shininess := 76;
    end;
  end;
  { end; }
end;

// ***************************************************************
//{ 0.01175; } { 0.1745; }{ .098 }   { 768 }
//{ 0.04136; }  { 0.61424; } { .69696 }
//{ 0.626959; } { 0.727811; } { 1.981729 }
// ***************************************************************
(*
  Called from Rotate form, this paints a Levels color
  This works for Primary colors...
  Get ratio of R~G~B, Which is larger,
*)
procedure TAAtomForm.CastColor(Leveled: Integer; NewColor: TColor);
var
  i: Integer;
Begin
  Case (Leveled) of
    1:
      for i := 0 to 1 do
      begin { NotRealOne	XXX	2 8 18 32 32 32 32 }
        with (DummyCube1.Children[i] as TGLSphere) do
        begin
          Material.FrontProperties.Ambient.Alpha := 0.55;
          Material.FrontProperties.Ambient.Blue :=
            ((GetBValue(NewColor) / 256) / 5); { 0.01175; }
          Material.FrontProperties.Ambient.Green :=
            ((GetGValue(NewColor) / 256) / 5); { 0.01175; }
          Material.FrontProperties.Ambient.Red :=
            ((GetRValue(NewColor) / 256) / 5); { 0.1745; }
          Material.FrontProperties.Diffuse.Alpha := 0.55;
          Material.FrontProperties.Diffuse.Blue := ((GetBValue(NewColor) / 256)
            ); { 0.04136; }
          Material.FrontProperties.Diffuse.Green := ((GetGValue(NewColor) / 256)
            ); { 0.04136; }
          Material.FrontProperties.Diffuse.Red := ((GetRValue(NewColor) / 256));
          { 0.61424; }
          Material.FrontProperties.Specular.Alpha := 0.55;
          Material.FrontProperties.Specular.Blue :=
            ((GetRValue(NewColor) + GetGValue(NewColor) + GetBValue(NewColor) +
            GetBValue(NewColor)) / 768); { 0.626959; }
          Material.FrontProperties.Specular.Green :=
            ((GetRValue(NewColor) + GetGValue(NewColor) + GetGValue(NewColor) +
            GetBValue(NewColor)) / 768); { 0.626959; }
          Material.FrontProperties.Specular.Red :=
            ((GetRValue(NewColor) + GetGValue(NewColor) + GetRValue(NewColor) +
            GetBValue(NewColor)) / 768); { 0.727811; }
          Material.FrontProperties.Shininess := 76;
        end;
      end;
    2:
      for i := 0 to 7 do
      begin { NotRealOne	XXX	2 8 18 32 32 32 32 }
        with (DummyCube2.Children[i] as TGLSphere) do
        begin
          Material.FrontProperties.Ambient.Alpha := 0.55;
          Material.FrontProperties.Ambient.Blue :=
            ((GetBValue(NewColor) / 256) / 5); { 0.01175; }
          Material.FrontProperties.Ambient.Green :=
            ((GetGValue(NewColor) / 256) / 5); { 0.01175; }
          Material.FrontProperties.Ambient.Red :=
            ((GetRValue(NewColor) / 256) / 5); { 0.1745; }
          Material.FrontProperties.Diffuse.Alpha := 0.55;
          Material.FrontProperties.Diffuse.Blue := ((GetBValue(NewColor) / 256)
            ); { 0.04136; }
          Material.FrontProperties.Diffuse.Green := ((GetGValue(NewColor) / 256)
            ); { 0.04136; }
          Material.FrontProperties.Diffuse.Red := ((GetRValue(NewColor) / 256));
          { 0.61424; }
          Material.FrontProperties.Specular.Alpha := 0.55;
          Material.FrontProperties.Specular.Blue :=
            ((GetRValue(NewColor) + GetGValue(NewColor) + GetBValue(NewColor) +
            GetBValue(NewColor)) / 768); { 0.626959; }
          Material.FrontProperties.Specular.Green :=
            ((GetRValue(NewColor) + GetGValue(NewColor) + GetGValue(NewColor) +
            GetBValue(NewColor)) / 768); { 0.626959; }
          Material.FrontProperties.Specular.Red :=
            ((GetRValue(NewColor) + GetGValue(NewColor) + GetRValue(NewColor) +
            GetBValue(NewColor)) / 768); { 0.727811; }
          Material.FrontProperties.Shininess := 76;
        end;
      end;
    3:
      for i := 0 to 17 do
      begin { NotRealOne	XXX	2 8 18 32 32 32 32 }
        with (DummyCube3.Children[i] as TGLSphere) do
        begin
          Material.FrontProperties.Ambient.Alpha := 0.55;
          Material.FrontProperties.Ambient.Blue :=
            ((GetBValue(NewColor) / 256) / 5); { 0.01175; }
          Material.FrontProperties.Ambient.Green :=
            ((GetGValue(NewColor) / 256) / 5); { 0.01175; }
          Material.FrontProperties.Ambient.Red :=
            ((GetRValue(NewColor) / 256) / 5); { 0.1745; }
          Material.FrontProperties.Diffuse.Alpha := 0.55;
          Material.FrontProperties.Diffuse.Blue := ((GetBValue(NewColor) / 256)
            ); { 0.04136; }
          Material.FrontProperties.Diffuse.Green := ((GetGValue(NewColor) / 256)
            ); { 0.04136; }
          Material.FrontProperties.Diffuse.Red := ((GetRValue(NewColor) / 256));
          { 0.61424; }
          Material.FrontProperties.Specular.Alpha := 0.55;
          Material.FrontProperties.Specular.Blue :=
            ((GetRValue(NewColor) + GetGValue(NewColor) + GetBValue(NewColor) +
            GetBValue(NewColor)) / 768); { 0.626959; }
          Material.FrontProperties.Specular.Green :=
            ((GetRValue(NewColor) + GetGValue(NewColor) + GetGValue(NewColor) +
            GetBValue(NewColor)) / 768); { 0.626959; }
          Material.FrontProperties.Specular.Red :=
            ((GetRValue(NewColor) + GetGValue(NewColor) + GetRValue(NewColor) +
            GetBValue(NewColor)) / 768); { 0.727811; }
          Material.FrontProperties.Shininess := 76;
        end;
      end;
    4:
      for i := 0 to 31 do
      begin { NotRealOne	XXX	2 8 18 32 32 32 32 }
        with (DummyCube4.Children[i] as TGLSphere) do
        begin
          Material.FrontProperties.Ambient.Alpha := 0.55;
          Material.FrontProperties.Ambient.Blue :=
            ((GetBValue(NewColor) / 256) / 5); { 0.01175; }
          Material.FrontProperties.Ambient.Green :=
            ((GetGValue(NewColor) / 256) / 5); { 0.01175; }
          Material.FrontProperties.Ambient.Red :=
            ((GetRValue(NewColor) / 256) / 5); { 0.1745; }
          Material.FrontProperties.Diffuse.Alpha := 0.55;
          Material.FrontProperties.Diffuse.Blue := ((GetBValue(NewColor) / 256)
            ); { 0.04136; }
          Material.FrontProperties.Diffuse.Green := ((GetGValue(NewColor) / 256)
            ); { 0.04136; }
          Material.FrontProperties.Diffuse.Red := ((GetRValue(NewColor) / 256));
          { 0.61424; }
          Material.FrontProperties.Specular.Alpha := 0.55;
          Material.FrontProperties.Specular.Blue :=
            ((GetRValue(NewColor) + GetGValue(NewColor) + GetBValue(NewColor) +
            GetBValue(NewColor)) / 768); { 0.626959; }
          Material.FrontProperties.Specular.Green :=
            ((GetRValue(NewColor) + GetGValue(NewColor) + GetGValue(NewColor) +
            GetBValue(NewColor)) / 768); { 0.626959; }
          Material.FrontProperties.Specular.Red :=
            ((GetRValue(NewColor) + GetGValue(NewColor) + GetRValue(NewColor) +
            GetBValue(NewColor)) / 768); { 0.727811; }
          Material.FrontProperties.Shininess := 76;
        end;
      end;
    5:
      for i := 0 to 31 do
      begin { NotRealOne	XXX	2 8 18 32 32 32 32 }
        with (DummyCube5.Children[i] as TGLSphere) do
        begin
          Material.FrontProperties.Ambient.Alpha := 0.55;
          Material.FrontProperties.Ambient.Blue :=
            ((GetBValue(NewColor) / 256) / 5); { 0.01175; }
          Material.FrontProperties.Ambient.Green :=
            ((GetGValue(NewColor) / 256) / 5); { 0.01175; }
          Material.FrontProperties.Ambient.Red :=
            ((GetRValue(NewColor) / 256) / 5); { 0.1745; }
          Material.FrontProperties.Diffuse.Alpha := 0.55;
          Material.FrontProperties.Diffuse.Blue := ((GetBValue(NewColor) / 256)
            ); { 0.04136; }
          Material.FrontProperties.Diffuse.Green := ((GetGValue(NewColor) / 256)
            ); { 0.04136; }
          Material.FrontProperties.Diffuse.Red := ((GetRValue(NewColor) / 256));
          { 0.61424; }
          Material.FrontProperties.Specular.Alpha := 0.55;
          Material.FrontProperties.Specular.Blue :=
            ((GetRValue(NewColor) + GetGValue(NewColor) + GetBValue(NewColor) +
            GetBValue(NewColor)) / 768); { 0.626959; }
          Material.FrontProperties.Specular.Green :=
            ((GetRValue(NewColor) + GetGValue(NewColor) + GetGValue(NewColor) +
            GetBValue(NewColor)) / 768); { 0.626959; }
          Material.FrontProperties.Specular.Red :=
            ((GetRValue(NewColor) + GetGValue(NewColor) + GetRValue(NewColor) +
            GetBValue(NewColor)) / 768); { 0.727811; }
          Material.FrontProperties.Shininess := 76;
        end;
      end;
    6:
      for i := 0 to 31 do
      begin { NotRealOne	XXX	2 8 18 32 32 32 32 }
        with (DummyCube6.Children[i] as TGLSphere) do
        begin
          Material.FrontProperties.Ambient.Alpha := 0.55;
          Material.FrontProperties.Ambient.Blue :=
            ((GetBValue(NewColor) / 256) / 5); { 0.01175; }
          Material.FrontProperties.Ambient.Green :=
            ((GetGValue(NewColor) / 256) / 5); { 0.01175; }
          Material.FrontProperties.Ambient.Red :=
            ((GetRValue(NewColor) / 256) / 5); { 0.1745; }
          Material.FrontProperties.Diffuse.Alpha := 0.55;
          Material.FrontProperties.Diffuse.Blue := ((GetBValue(NewColor) / 256)
            ); { 0.04136; }
          Material.FrontProperties.Diffuse.Green := ((GetGValue(NewColor) / 256)
            ); { 0.04136; }
          Material.FrontProperties.Diffuse.Red := ((GetRValue(NewColor) / 256));
          { 0.61424; }
          Material.FrontProperties.Specular.Alpha := 0.55;
          Material.FrontProperties.Specular.Blue :=
            ((GetRValue(NewColor) + GetGValue(NewColor) + GetBValue(NewColor) +
            GetBValue(NewColor)) / 768); { 0.626959; }
          Material.FrontProperties.Specular.Green :=
            ((GetRValue(NewColor) + GetGValue(NewColor) + GetGValue(NewColor) +
            GetBValue(NewColor)) / 768); { 0.626959; }
          Material.FrontProperties.Specular.Red :=
            ((GetRValue(NewColor) + GetGValue(NewColor) + GetRValue(NewColor) +
            GetBValue(NewColor)) / 768); { 0.727811; }
          Material.FrontProperties.Shininess := 76;
        end;
      end;
    7:
      for i := 0 to 31 do
      begin { NotRealOne	XXX	2 8 18 32 32 32 32 }
        with (DummyCube7.Children[i] as TGLSphere) do
        begin
          Material.FrontProperties.Ambient.Alpha := 0.55;
          Material.FrontProperties.Ambient.Blue :=
            ((GetBValue(NewColor) / 256) / 5); { 0.01175; }
          Material.FrontProperties.Ambient.Green :=
            ((GetGValue(NewColor) / 256) / 5); { 0.01175; }
          Material.FrontProperties.Ambient.Red :=
            ((GetRValue(NewColor) / 256) / 5); { 0.1745; }
          Material.FrontProperties.Diffuse.Alpha := 0.55;
          Material.FrontProperties.Diffuse.Blue := ((GetBValue(NewColor) / 256)
            ); { 0.04136; }
          Material.FrontProperties.Diffuse.Green := ((GetGValue(NewColor) / 256)
            ); { 0.04136; }
          Material.FrontProperties.Diffuse.Red := ((GetRValue(NewColor) / 256));
          { 0.61424; }
          Material.FrontProperties.Specular.Alpha := 0.55;
          Material.FrontProperties.Specular.Blue :=
            ((GetRValue(NewColor) + GetGValue(NewColor) + GetBValue(NewColor) +
            GetBValue(NewColor)) / 768); { 0.626959; }
          Material.FrontProperties.Specular.Green :=
            ((GetRValue(NewColor) + GetGValue(NewColor) + GetGValue(NewColor) +
            GetBValue(NewColor)) / 768); { 0.626959; }
          Material.FrontProperties.Specular.Red :=
            ((GetRValue(NewColor) + GetGValue(NewColor) + GetRValue(NewColor) +
            GetBValue(NewColor)) / 768); { 0.727811; }
          Material.FrontProperties.Shininess := 76;
        end;
      end; { case }
  end;
end;

end.
