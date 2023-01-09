unit fMainD;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Classes,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.ComCtrls,
  Vcl.ExtCtrls,
  Vcl.StdCtrls,
  Vcl.Imaging.Jpeg,
  Vcl.Menus,

  GLS.SceneViewer,
  GLS.PersistentClasses,

  GLS.Scene,
  GLS.Context,
  GLS.State,
  GLS.Objects,
  GLS.GeomObjects,
  GLS.Cadencer,
  GLS.Extrusion,
  GLS.VectorGeometry,
  GLS.VectorTypes,
  GLS.GeometryBB,
  GLS.File3DS,
  GLS.FileSTL,

  GLS.VectorFileObjects,
  GLS.Coordinates,
  GLS.BaseClasses,
  GLS.RenderContextInfo,
  GLS.AsyncTimer,
  GLS.SimpleNavigation,
  GLS.Material,
  GLS.Color,
  GLS.SkyDome,
  GLS.Keyboard,
  GLS.FireFX,
  GLS.FileObj,
  GLS.Atmosphere,
  GLS.LensFlare,
  frParamsD;

type
  TForm1 = class(TForm)
    Scene: TGLScene;
    SceneViewer: TGLSceneViewer;
    PanelLeft: TPanel;
    TreeView: TTreeView;
    Camera: TGLCamera;
    LightSource: TGLLightSource;
    Cadencer: TGLCadencer;
    Mercury: TGLSphere;
    sys_dogl: TGLDirectOpenGL;
    SolarSystem: TGLDummyCube;
    axis_lines: TGLLines;
    bb_lines: TGLLines;
    AsyncTimer: TGLAsyncTimer;
    SaturnRing: TGLDisk;
    SimpleNavigation: TGLSimpleNavigation;
    Sun: TGLSphere;
    MatLib: TGLMaterialLibrary;
    dcEarth: TGLDummyCube;
    Earth: TGLSphere;
    dcMoon: TGLDummyCube;
    Moon: TGLSphere;
    dcMars: TGLDummyCube;
    Mars: TGLSphere;
    MarsOrbit: TGLTorus;
    dcMercury: TGLDummyCube;
    dcSaturn: TGLDummyCube;
    dcVenus: TGLDummyCube;
    Venus: TGLSphere;
    dcJupiter: TGLDummyCube;
    Saturn: TGLSphere;
    Jupiter: TGLSphere;
    dcUranus: TGLDummyCube;
    dcNeptune: TGLDummyCube;
    dcPluto: TGLDummyCube;
    Uranus: TGLSphere;
    Neptune: TGLSphere;
    Pluto: TGLSphere;
    Charon: TGLSphere;
    SkyDome: TGLSkyDome;
    FireFXManager: TGLFireFXManager;
    Europa: TGLSphere;
    dcEuropa: TGLDummyCube;
    dcTitan: TGLDummyCube;
    dcEnceladus: TGLDummyCube;
    Titan: TGLSphere;
    dcPhobos: TGLDummyCube;
    dcDeimos: TGLDummyCube;
    Enceladus: TGLSphere;
    NeptuneRing: TGLDisk;
    dcGanymede: TGLDummyCube;
    Ganymede: TGLSphere;
    dcIo: TGLDummyCube;
    Io: TGLSphere;
    dcCallisto: TGLDummyCube;
    Callisto: TGLSphere;
    dcTitania: TGLDummyCube;
    dcMiranda: TGLDummyCube;
    Titania: TGLSphere;
    Miranda: TGLSphere;
    dcTriton: TGLDummyCube;
    Triton: TGLSphere;
    dcCharon: TGLDummyCube;
    JupiterOrbit: TGLTorus;
    MercuryOrbit: TGLTorus;
    SaturnOrbit: TGLTorus;
    VenusOrbit: TGLTorus;
    UranusOrbit: TGLTorus;
    NeptuneOrbit: TGLTorus;
    PlutoOrbit: TGLTorus;
    EarthOrbit: TGLTorus;
    UranusRing: TGLDisk;
    HabitableZone: TGLDisk;
    MainMenu: TMainMenu;
    PanelRight: TPanel;
    Window1: TMenuItem;
    miInnerCore: TMenuItem;
    miOrbitLines: TMenuItem;
    miHidePanels: TMenuItem;
    N1: TMenuItem;
    File1: TMenuItem;
    New1: TMenuItem;
    Open1: TMenuItem;
    Save1: TMenuItem;
    SaveAs1: TMenuItem;
    Exit1: TMenuItem;
    N2: TMenuItem;
    Edit1: TMenuItem;
    Undo1: TMenuItem;
    Repeat1: TMenuItem;
    Cut1: TMenuItem;
    Copy1: TMenuItem;
    Paste1: TMenuItem;
    PasteSpecial1: TMenuItem;
    Find1: TMenuItem;
    Replace1: TMenuItem;
    GoTo1: TMenuItem;
    Links1: TMenuItem;
    Object1: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    Help1: TMenuItem;
    Contents1: TMenuItem;
    About1: TMenuItem;
    stPickObject: TStaticText;
    FrameParams: TFrameParams;
    cbOrbit: TCheckBox;
    Splitter1: TSplitter;
    cbHabitableZone: TCheckBox;
    MemoInfo: TMemo;
    cbRotation: TCheckBox;
    N7: TMenuItem;
    OpenDialog: TOpenDialog;
    Phobos: TGLFreeForm;
    Deimos: TGLFreeForm;
    procedure CadencerProgress(Sender: TObject;
      const deltaTime, newTime: Double);
    procedure FormCreate(Sender: TObject);
    procedure Sys_doglRender(Sender: TObject; var rci: TGLRenderContextInfo);
    procedure SceneViewerMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure AsyncTimerTimer(Sender: TObject);
    procedure TreeViewChange(Sender: TObject; Node: TTreeNode);

    procedure cbOrbitClick(Sender: TObject);
    procedure cbRotationClick(Sender: TObject);
    procedure cbHabitableZoneClick(Sender: TObject);

    procedure Open1Click(Sender: TObject);
    procedure TreeViewClick(Sender: TObject);
    procedure miHidePanelsClick(Sender: TObject);
    procedure miInnerCoreClick(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  public
    PickObject: TGLBaseSceneObject;
    procedure UpdateTreeView;
    procedure AddBBox;  // Bounding Box
    procedure UpdateBBox;
  private
    newPickObject: TGLBaseSceneObject;
    Core: TGLSPhere;
    Crust: TGLDisk;
    Mantle: TGLDisk;
    Atmosphere: TGLAtmosphere;
    procedure GetObjects(ParentNode: TTreeNode; SceneObject: TGLBaseSceneObject);
  end;

var
  Form1: TForm1;
const
  cOmega = 10;  // angular velocity

//-----------------------------------------------------
implementation
//-----------------------------------------------------

{$R *.dfm}

// FormCreate
//
procedure TForm1.FormCreate;
var
  FileName: TFileName;
begin
  SetCurrentDir(ExtractFilePath(ParamStr(0)));
  FileName := GetCurrentDir() + '\Assets\Maps\';
  SetCurrentDir(FileName);

  Sun.Material.Texture.Image.LoadFromFile('starg.jpg');
  Mercury.Material.Texture.Image.LoadFromFile('mercury.jpg');
    Venus.Material.Texture.Image.LoadFromFile('venus.jpg');
  Earth.Material.Texture.Image.LoadFromFile('earth.jpg');
    Moon.Material.Texture.Image.LoadFromFile('moon.jpg');
  Mars.Material.Texture.Image.LoadFromFile('mars.jpg');
    Phobos.LoadFromFile('..\Models\phobos.obj');
    Phobos.Material.Texture.Image.LoadFromFile('phobos.jpg');
    Phobos.Scale.Scale(0.05 / Phobos.BoundingSphereRadius);
    Deimos.LoadFromFile('..\Models\deimos.obj');
    Deimos.Material.Texture.Image.LoadFromFile('deimos.jpg');
    Deimos.Scale.Scale(0.05 / Deimos.BoundingSphereRadius);

  Jupiter.Material.Texture.Image.LoadFromFile('jupiter.jpg');
    Io.Material.Texture.Image.LoadFromFile('io.jpg');
    Europa.Material.Texture.Image.LoadFromFile('europa.jpg');
    Ganymede.Material.Texture.Image.LoadFromFile('ganymede.jpg');
    Callisto.Material.Texture.Image.LoadFromFile('callisto.jpg');
  Saturn.Material.Texture.Image.LoadFromFile('saturn.jpg');
    Titan.Material.Texture.Image.LoadFromFile('titan.jpg');
    Enceladus.Material.Texture.Image.LoadFromFile('enceladus.jpg');
    SaturnRing.Material.Texture.Image.LoadFromFile('saturnring.jpg');

  Uranus.Material.Texture.Image.LoadFromFile('uranus.jpg');
    Titania.Material.Texture.Image.LoadFromFile('titania.jpg');
    Miranda.Material.Texture.Image.LoadFromFile('miranda.jpg');
  Neptune.Material.Texture.Image.LoadFromFile('neptune.jpg');
    NeptuneRing.Material.Texture.Image.LoadFromFile('neptunering.jpg');
    Triton.Material.Texture.Image.LoadFromFile('triton.jpg');
  Pluto.Material.Texture.Image.LoadFromFile('pluto.jpg');
    Charon.Material.Texture.Image.LoadFromFile('charon.jpg');


  Delete(FileName, Length(FileName)-4, 5);
//  FileName := FileName + 'Data\Yale_BSC.stars';
  FileName := FileName + 'Data\hipparcos_9.stars';
  SkyDome.Bands.Clear;
  if FileExists(FileName) then
    SkyDome.Stars.LoadStarsFile(FileName);

  UpdateTreeView;
  TreeView.Select(TreeView.Items[0]); // goto to the first node
(*
//  ffAsteroid.LoadFromFile('asteroid.3ds');
//  ffComet.LoadFromFile('comet.3ds');
*)
  TreeView.FullExpand;
  Atmosphere := TGLAtmosphere.Create(Self);
  SceneViewer.Buffer.RenderingContext.Activate;
end;

// FormShow
//
procedure TForm1.FormShow(Sender: TObject);
begin
  cbOrbitClick(Self);
  cbRotationClick(Self);
  cbHabitableZoneClick(Self);
  UpdateBBox; // ?
end;

// Hide Panels
//
procedure TForm1.miHidePanelsClick(Sender: TObject);
begin
   PanelLeft.Visible := not PanelLeft.Visible;
   PanelRight.Visible := not PanelRight.Visible;
   miHidePanels.Checked := not miHidePanels.Checked;
   if miHidePanels.Checked then
     miHidePanels.Caption := 'Hide Panels'
   else
    miHidePanels.Caption := 'Show Panels';
end;

procedure TForm1.miInnerCoreClick(Sender: TObject);
begin
  miInnerCore.Checked := not miInnerCore.Checked;
  TreeViewClick(Self);
  SceneViewer.Invalidate;
end;

// Open File dialog
//
procedure TForm1.Open1Click(Sender: TObject);
begin
  //
end;

// CadencerProgress
//
procedure TForm1.CadencerProgress(Sender: TObject;
      const deltaTime, newTime: Double);
begin
  //SolarSystem.Turn(deltaTime * cOmega);
  Sun.Turn(deltaTime * cOmega);
  dcMercury.Turn(deltaTime * 50);
    Mercury.Turn(deltaTime * cOmega);
  dcVenus.Turn(deltaTime * 35);
    Venus.Turn(deltaTime * cOmega);

  dcEarth.Turn(deltaTime * 30);
    Earth.Turn(deltaTime * 100);
  (**)
    dcMoon.Turn(deltaTime * 50);
  dcMars.Turn(deltaTime * 24);
    Mars.Turn(deltaTime * 100);
    dcPhobos.Turn(deltaTime * 200);
    dcDeimos.Turn(deltaTime * cOmega);
  dcJupiter.Turn(deltaTime * 14);
    Jupiter.Turn(deltaTime * 80);
    dcIo.Turn(deltaTime * 180);
    dcEuropa.Turn(deltaTime * 140);
    dcGanymede.Turn(deltaTime * 100);
    dcCallisto.Turn(deltaTime * 60);
  dcSaturn.Turn(deltaTime * cOmega);
  Saturn.Turn(deltaTime * 50);
    Saturnring.Roll(deltaTime * 50);
    dcEnceladus.Turn(deltaTime * 50);
    dcTitan.Turn(deltaTime * 20);
  dcUranus.Turn(deltaTime * 14);
    Uranus.Turn(deltaTime * 50);
    dcTitania.Turn(deltaTime * 100);
    dcMiranda.Turn(deltaTime * 50);
  dcNeptune.Turn(deltaTime * 12);
    Neptune.Turn(deltaTime * 50);
    dcTriton.Turn(deltaTime * 120);
  dcPluto.Turn(deltaTime * cOmega);
    Pluto.Turn(deltaTime * 50);
    dcCharon.Turn(deltaTime * 100);
end;

// Show Orbit Lines
//
procedure TForm1.cbOrbitClick(Sender: TObject);
begin
  MercuryOrbit.Visible := cbOrbit.Checked;
  VenusOrbit.Visible := cbOrbit.Checked;
  EarthOrbit.Visible := cbOrbit.Checked;
  MarsOrbit.Visible := cbOrbit.Checked;
  JupiterOrbit.Visible := cbOrbit.Checked;
  SaturnOrbit.Visible := cbOrbit.Checked;
  UranusOrbit.Visible := cbOrbit.Checked;
  NeptuneOrbit.Visible := cbOrbit.Checked;
  PlutoOrbit.Visible := cbOrbit.Checked;
  SceneViewer.Invalidate;
end;

// Rotate Solar System
//
procedure TForm1.cbRotationClick(Sender: TObject);
begin
  Cadencer.Enabled := cbRotation.Checked;
  SceneViewer.Invalidate;
end;

// Show Habitable Zone
//
procedure TForm1.cbHabitableZoneClick(Sender: TObject);
begin
  HabitableZone.Visible := cbHabitableZone.Checked;
end;

// TreeViewChange
//
procedure TForm1.TreeViewChange(Sender: TObject; Node: TTreeNode);
begin
  if Node <> nil then
  begin
    PickObject := TGLBaseSceneObject(Node.Data);
    stPickObject.Caption := PickObject.Name;
    MemoInfo.Text := PickObject.Name + ': ' + PickObject.ClassName;
    FrameParams.ShowParams;
  end;
end;

// TreeViewClick
//
procedure TForm1.TreeViewClick(Sender: TObject);
var
  i: integer;
begin
  // Solar System ===============
  if (TreeView.Selected.Text = SolarSystem.Name) then
  begin
    Camera.MoveTo(SolarSystem);
    Camera.TargetObject := SolarSystem;
    Camera.Position.X := 10;
    Camera.Position.Y := 10;
    Camera.Position.Z := 10;
  end;
  //  Sun ===================
  if (TreeView.Selected.Text = Sun.Name) then
  begin
    Camera.MoveTo(Sun);
    Camera.TargetObject := Sun;
    Camera.Position.X := 1;
    Camera.Position.Y := 1;
    Camera.Position.Z := 1;
  end;
  //  Mercury ===================
  if (TreeView.Selected.Text = Mercury.Name) then
  begin
    Camera.MoveTo(Mercury);
    Camera.TargetObject := Mercury;
    Camera.Position.X := 0.5;
    Camera.Position.Y := 1;
    Camera.Position.Z := 0.5;
    if miInnerCore.Checked then
    begin
      // Mercury.Radius := 0.32;
      (PickObject as TGLSphere).Stop := 180;
      // Core
      Core := TGLSphere.CreateAsChild(Mercury);
      Core.Radius := 0.1;
      Core.Material.FrontProperties.Diffuse.Color := clrCoral;
      // Mantle
      Mantle := TGLDisk.CreateAsChild(Mercury);
      Mantle.InnerRadius := 0.1;
      Mantle.OuterRadius := 0.3;
      Mantle.Material.FrontProperties.Diffuse.Color := clrBrown;
      Mantle.NormalDirection := ndInside;
      Mantle.Slices := 64;
      Mantle.TurnAngle := 90;
      // Crust
      Crust := TGLDisk.CreateAsChild(Mercury);
      Crust.InnerRadius := 0.3;
      Crust.OuterRadius := 0.32;
      Crust.Material.FrontProperties.Diffuse.Color := clrYellow;
      Crust.NormalDirection := ndInside;
      Crust.Slices := 64;
      Crust.TurnAngle := 90;
    end
    else
    begin
      Mercury.Stop := 360;
      Core.Free;
      Crust.Free;
      Mantle.Free;
    end;
  end;
  // Venus ==================
  if (TreeView.Selected.Text = Venus.Name) then
  begin
    Camera.MoveTo(Venus);
    Camera.TargetObject := Venus;
    Camera.Position.X := 1;
    Camera.Position.Y := 1;
    Camera.Position.Z := 1;
    if miInnerCore.Checked then
    begin
      // Venus.Radius := 0.75;
      (PickObject as TGLSphere).Stop := 180;
      // Core
      Core := TGLSphere.CreateAsChild(Venus);
      Core.Radius := 0.2;
      Core.Material.FrontProperties.Diffuse.Color := clrRed;
      // Mantle
      Mantle := TGLDisk.CreateAsChild(Venus);
      Mantle.InnerRadius := 0.2;
      Mantle.OuterRadius := 0.7;
      Mantle.Material.FrontProperties.Diffuse.Color := clrBrown;
      Mantle.NormalDirection := ndInside;
      Mantle.Slices := 64;
      Mantle.TurnAngle := 90;
      // Crust
      Crust := TGLDisk.CreateAsChild(Venus);
      Crust.InnerRadius := 0.7;
      Crust.OuterRadius := 0.75;
      Crust.Material.FrontProperties.Diffuse.Color := clrCoral;
      Crust.NormalDirection := ndInside;
      Crust.Slices := 64;
      Crust.TurnAngle := 90;
    end
    else
    begin
      Venus.Stop := 360;
      Core.Free;
      Crust.Free;
      Mantle.Free;
    end;
  end;
  // Earth ====================
  if (TreeView.Selected.Text = Earth.Name) or
     (TreeView.Selected.Text = Moon.Name) then
  begin
    Atmosphere.MoveTo(Earth);
    Atmosphere.Sun := LightSource;
    Atmosphere.Opacity := 5;
    Atmosphere.PlanetRadius := Earth.Radius;
    Atmosphere.AtmosphereRadius := Earth.Radius + 0.05;
    if PickObject = Earth then
    begin
      Camera.MoveTo(Earth);
      Camera.TargetObject := Earth;
      Camera.Position.X := -1.2;
      Camera.Position.Y := 1;
      Camera.Position.Z := -1.2;
    end;
    if PickObject = Moon then
    begin
      Camera.MoveTo(Moon);
      Camera.TargetObject := Moon;
      Camera.Position.X := -0.6;
      Camera.Position.Y := 1;
      Camera.Position.Z := -0.6;
    end;

    if miInnerCore.Checked then
    begin
      // Earth.Radius := 0.8;
      Earth.Stop := 180;
      // a half map of Earth
      Earth.Material.Texture.Image.LoadFromFile('eartheast.jpg');
      // Core
      Core := TGLSphere.CreateAsChild(Earth);
      Core.Radius := 0.3;
      Core.Material.FrontProperties.Diffuse.Color := clrRed;
      // Mantle
      Mantle := TGLDisk.CreateAsChild(Earth);
      Mantle.InnerRadius := 0.3;
      Mantle.OuterRadius := 0.7;
      Mantle.Material.FrontProperties.Diffuse.Color := clrBrown;
      Mantle.NormalDirection := ndInside;
      Mantle.Slices := 64;
      Mantle.TurnAngle := 90;
      // Crust
      Crust := TGLDisk.CreateAsChild(Earth);
      Crust.InnerRadius := 0.7;
      Crust.OuterRadius := 0.8;
      Crust.Material.FrontProperties.Diffuse.Color := clrCoral;
      Crust.NormalDirection := ndInside;
      Crust.Slices := 64;
      Crust.TurnAngle := 90;
    end
    else
    begin
      Earth.Stop := 360;
      Earth.Material.Texture.Image.LoadFromFile('earth.jpg'); // full map
      Core.Free;
      Crust.Free;
      Mantle.Free;
    end;
  end;

  // Mars ===================
  if (TreeView.Selected.Text = Mars.Name) or
     (TreeView.Selected.Text = Phobos.Name) or
     (TreeView.Selected.Text = Deimos.Name) then
  begin
    if PickObject = Mars then
    begin
      Camera.MoveTo(Mars);
      Camera.TargetObject := Mars;
      Camera.Position.X := -0.8;
      Camera.Position.Y := 1;
      Camera.Position.Z := 0.8;
    end;
    if PickObject = Phobos then
    begin
      Camera.MoveTo(dcPhobos);
      Camera.TargetObject := Phobos;
      Camera.Position.X := -1;
      Camera.Position.Y := 1;
      Camera.Position.Z := 1;
    end;
    if (TreeView.Selected.Text = Deimos.Name) then
    begin
      Camera.MoveTo(dcDeimos);
      Camera.TargetObject := Deimos;
      Camera.Position.X := 1;
      Camera.Position.Y := 1;
      Camera.Position.Z := 1;
    end;
    if miInnerCore.Checked then
    begin
      // Mars.Radius := 0.4;
      Mars.Stop := 180;   // Half sphere
      Mars.Material.Texture.Image.LoadFromFile('marseast.jpg');
      // Core
      Core := TGLSphere.CreateAsChild(Mars);
      Core.Radius := 0.1;
      Core.Material.FrontProperties.Diffuse.Color := clrRed;
      // Mantle
      Mantle := TGLDisk.CreateAsChild(Mars);
      Mantle.InnerRadius := 0.1;
      Mantle.OuterRadius := 0.3;
      Mantle.Material.FrontProperties.Diffuse.Color := clrBrown;
      Mantle.NormalDirection := ndInside;
      Mantle.Slices := 64;
      Mantle.TurnAngle := 90;
      // Crust
      Crust := TGLDisk.CreateAsChild(Mars);
      Crust.InnerRadius := 0.3;
      Crust.OuterRadius := 0.4;
      Crust.Material.FrontProperties.Diffuse.Color := clrCoral;
      Crust.NormalDirection := ndInside;
      Crust.Slices := 64;
      Crust.TurnAngle := 90;
    end
    else
    begin
      Mars.Stop := 360;
      Mars.Material.Texture.Image.LoadFromFile('mars.jpg');
      Core.Free;
      Crust.Free;
      Mantle.Free;
    end;
  end;

  // Jupiter ==================
  if (TreeView.Selected.Text = Jupiter.Name) or
     (TreeView.Selected.Text = Io.Name) or
     (TreeView.Selected.Text = Europa.Name) or
     (TreeView.Selected.Text = Ganymede.Name) or
     (TreeView.Selected.Text = Callisto.Name) then
  begin
    if PickObject = Jupiter then
    begin
      Camera.MoveTo(Jupiter);
      Camera.TargetObject := Jupiter;
      Camera.Position.X := 7;
      Camera.Position.Y := 1;
      Camera.Position.Z := 7;
    end
    else   // for Jupiter moons
    begin
      Camera.Position.X := 1;
      Camera.Position.Y := 1;
      Camera.Position.Z := 1;
    end;
    if PickObject = Io then
    begin
      Camera.MoveTo(Io);
      Camera.TargetObject := Io;
    end;
    if PickObject = Europa then
    begin
      Camera.MoveTo(Europa);
      Camera.TargetObject := Europa;
    end;
    if PickObject = Ganymede then
    begin
      Camera.MoveTo(Ganymede);
      Camera.TargetObject := Ganymede;
    end;
    if PickObject = Callisto then
    begin
      Camera.MoveTo(Callisto);
      Camera.TargetObject := Callisto;
    end;
  end;

  //  Saturn ====================
  if (TreeView.Selected.Text = Saturn.Name) or
     (TreeView.Selected.Text = Titan.Name) or
     (TreeView.Selected.Text = Enceladus.Name) then
  begin
    if PickObject = Saturn then
    begin
      Camera.MoveTo(Saturn);
      Camera.TargetObject := Saturn;
      Camera.Position.X := 5;
      Camera.Position.Y := 0;
      Camera.Position.Z := 5;
    end
    else   // for Saturn moons
    begin
      Camera.Position.X := 1;
      Camera.Position.Y := 1;
      Camera.Position.Z := 1;
    end;
    if PickObject = Enceladus then
    begin
      Camera.MoveTo(Enceladus);
      Camera.TargetObject := Enceladus;
    end;
    if PickObject = Titan then
    begin
      Camera.MoveTo(Titan);
      Camera.TargetObject := Titan;
    end;
  end;

  // Uranus ====================
  if (TreeView.Selected.Text = Uranus.Name) or
     (TreeView.Selected.Text = Titania.Name) or
     (TreeView.Selected.Text = Miranda.Name) then
  begin
    if PickObject = Uranus then
    begin
      Camera.MoveTo(Uranus);
      Camera.TargetObject := Uranus;
      Camera.Position.X := 5;
      Camera.Position.Y := 0;
      Camera.Position.Z := 5;
    end
    else   // for Uranus moons
    begin
      Camera.Position.X := 1;
      Camera.Position.Y := 1;
      Camera.Position.Z := 1;
    end;
    if PickObject = Miranda then
    begin
      Camera.MoveTo(Miranda);
      Camera.TargetObject := Miranda;
    end;
    if PickObject = Titania then
    begin
      Camera.MoveTo(Titania);
      Camera.TargetObject := Titania;
    end;
  end;

  // Neptune ====================
  if TreeView.Selected.Text = Neptune.Name then
  begin
    Camera.MoveTo(Neptune);
    Camera.TargetObject := Neptune;
    Camera.Position.X := 5;
    Camera.Position.Y := 0;
    Camera.Position.Z := 5;
  end;

  // Pluto ====================
  if TreeView.Selected.Text = Pluto.Name then
  begin
    Camera.MoveTo(Pluto);
    Camera.TargetObject := Pluto;
    Camera.Position.X := 1;
    Camera.Position.Y := 0;
    Camera.Position.Z := 1;
  end;
  SceneViewer.Invalidate;
end;

// MouseDown
//
procedure TForm1.SceneViewerMouseDown;
begin
  newPickObject := SceneViewer.Buffer.GetPickedObject(X, Y);
  if newPickObject is TGLLines then
    exit;
  if newPickObject = nil then
    TreeView.Select(TreeView.Items[0])
  else
    TreeView.Select(TTreeNode(newPickObject.TagObject));
end;


// GetObjects
//
procedure TForm1.GetObjects(ParentNode: TTreeNode; SceneObject: TGLBaseSceneObject);
var
  n: Integer;
  Node: TTreeNode;
begin
  if SceneObject.Pickable then
  begin
    if (SceneObject.Name <> Camera.Name) then
    begin
      Node := TreeView.Items.AddChildObject(ParentNode, SceneObject.Name, SceneObject);
      SceneObject.TagObject := Node;
      for n := 0 to SceneObject.Count - 1 do
        GetObjects(Node, SceneObject.Children[n]);
    end;
  end;
end;

// UpdateTreeView
//
procedure TForm1.UpdateTreeView;

begin
  TreeView.Items.Clear;
  GetObjects(TreeView.TopItem, SolarSystem);
end;

// AddBBox
//
procedure TForm1.AddBBox;
const
  c = 0.5;
  d = 0.3;

begin
  with bb_lines.Nodes do
  begin
    AddNode(c, c, c);
    AddNode(c, c, d);
    AddNode(c, c, -c);
    AddNode(c, c, -d);
    AddNode(-c, c, c);
    AddNode(-c, c, d);
    AddNode(-c, c, -c);
    AddNode(-c, c, -d);
    AddNode(c, -c, c);
    AddNode(c, -c, d);
    AddNode(c, -c, -c);
    AddNode(c, -c, -d);
    AddNode(-c, -c, c);
    AddNode(-c, -c, d);
    AddNode(-c, -c, -c);
    AddNode(-c, -c, -d);

    AddNode(c, c, c);
    AddNode(c, d, c);
    AddNode(c, -c, c);
    AddNode(c, -d, c);
    AddNode(-c, c, c);
    AddNode(-c, d, c);
    AddNode(-c, -c, c);
    AddNode(-c, -d, c);
    AddNode(c, c, -c);
    AddNode(c, d, -c);
    AddNode(c, -c, -c);
    AddNode(c, -d, -c);
    AddNode(-c, c, -c);
    AddNode(-c, d, -c);
    AddNode(-c, -c, -c);
    AddNode(-c, -d, -c);

    AddNode(c, c, c);
    AddNode(d, c, c);
    AddNode(-c, c, c);
    AddNode(-d, c, c);
    AddNode(c, -c, c);
    AddNode(d, -c, c);
    AddNode(-c, -c, c);
    AddNode(-d, -c, c);
    AddNode(c, c, -c);
    AddNode(d, c, -c);
    AddNode(-c, c, -c);
    AddNode(-d, c, -c);
    AddNode(c, -c, -c);
    AddNode(d, -c, -c);
    AddNode(-c, -c, -c);
    AddNode(-d, -c, -c);
  end;
end;

// UpdateBBox
//
procedure TForm1.UpdateBBox;
var
  v1, v2: TVector3f;

begin
  if PickObject = nil then
    Exit;
  if bb_lines.Nodes.Count = 0 then
    AddBBox;
  bb_lines.Matrix^ := PickObject.AbsoluteMatrix;
  if PickObject is TGLFreeForm then
  begin
    TGLFreeForm(PickObject).MeshObjects.GetExtents(v1, v2);
    v1 := VectorTransform(v1, PickObject.Matrix^);
    v2 := VectorTransform(v2, PickObject.Matrix^);
    bb_lines.Position.SetPoint(vectorlerp(v1, v2, 0.5));
    bb_lines.Scale.SetVector(PickObject.BoundingBox(false).BBox[0]);
    bb_lines.Scale.Scale(2);
  end
  else
  begin
    bb_lines.Scale.SetVector(PickObject.BoundingBox(false).BBox[0]);
    bb_lines.Scale.Scale(2.1);
  end;
  axis_lines.Matrix^ := PickObject.AbsoluteMatrix;
end;

// Sys_doglRender
//
procedure TForm1.Sys_doglRender;
begin
  if PickObject <> nil then
  begin
    rci.GLStates.DepthFunc := cfAlways;
    UpdateBBox;
    axis_lines.Render(rci);
    bb_lines.Render(rci);
  end;
end;

// AsyncTimerTimer
//
procedure TForm1.AsyncTimerTimer;
begin
  Caption := 'Solar System / ' + SceneViewer.FramesPerSecondText(2);
  SceneViewer.ResetPerformanceMonitor;
end;

// About
//
procedure TForm1.About1Click(Sender: TObject);
begin
  ShowMessage('A freeware program based on GLScene...'#13#10#13#10 +
    'to show planets of the Solar System!');
end;

// Exit
//
procedure TForm1.Exit1Click(Sender: TObject);
begin
  Close;
end;

// Form Close
//
procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Atmosphere.Free;
end;

end.
