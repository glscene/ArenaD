// USMD Stuff unit demo by Mrqzzz (mrqzzz@yahoo.it)
// ------------------------------------------------
// Just a demo of my little USMDStuff.pas unit
// Feel free to use it.

unit FGlsSmdQc;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Classes,
  Vcl.Buttons,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.Samples.Spin,
  Vcl.ComCtrls,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,

  GLVectorGeometry,
  GLVectorFileObjects,
  GLScene,
  GLObjects,
  GLTexture,
  GLCadencer,
  GLWin32Viewer,
  GLGraph,
  GLVectorTypes,
  GLMaterial,
  GLCoordinates,
  GLCrossPlatform,
  GLBaseClasses;

type
  TGlsSmdQcFrm = class(TForm)
    GLScene1: TGLScene;
    GLSceneViewer1: TGLSceneViewer;
    GLCamera1: TGLCamera;
    GLLightSource1: TGLLightSource;
    Actor1: TGLActor;
    DummyCube1: TGLDummyCube;
    GLMaterialLibrary1: TGLMaterialLibrary;
    Timer1: TTimer;
    GLCadencer1: TGLCadencer;
    Panel1: TPanel;
    CheckBox1: TCheckBox;
    XYZGrid1: TGLXYZGrid;
    OpenDialog1: TOpenDialog;
    Button1: TButton;
    cboAnimations: TComboBox;
    Cube1: TGLCube;
    TrackBar1: TTrackBar;
    TrackBar2: TTrackBar;
    TrackBar3: TTrackBar;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    TrackBar4: TTrackBar;
    TrackBar5: TTrackBar;
    TrackBar6: TTrackBar;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Cube2: TGLCube;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    TrackBar7: TTrackBar;
    Label14: TLabel;
    Label1: TLabel;
    TrackBar8: TTrackBar;
    Label15: TLabel;
    HelpBtn: TSpeedButton;
    ExitBtn: TSpeedButton;

    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure ExitBtnClick(Sender: TObject);
    procedure DoCcOpen(const fileName: String);
    procedure HelpBtnClick(Sender: TObject);

    procedure GLSceneViewer1MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure GLSceneViewer1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Timer1Timer(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure GLCadencer1Progress(Sender: TObject;
      const deltaTime, newTime: Double);
    procedure Button1Click(Sender: TObject);
    procedure cboAnimationsChange(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure TrackBar4Change(Sender: TObject);
    procedure Panel2MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);

  private
        
  public
        
    baseAnimation: String;
    mx, my: Integer;

    AlreadyLoaded: boolean;

    // The Spine Rotations
    aaS, bbS, ccS: single;

    // The Head Rotations
    aaH, bbH, ccH: single;

    // The Bones we want to Rotate
    BoneIndex_Spine, BoneIndex_Head: Integer;

  end;

var
  GlsSmdQcFrm: TGlsSmdQcFrm;

implementation

uses
  uGlobals, uSMDStuff;

{$R *.DFM}

procedure TGlsSmdQcFrm.FormCreate(Sender: TObject);
begin
  top := GlsSmdQcFormY;
  left := GlsSmdQcFormX;
  Timer1.Enabled := False;
  GLCadencer1.Enabled := False;
end;

procedure TGlsSmdQcFrm.FormShow(Sender: TObject);
begin
  Timer1.Enabled := False;
  GLCadencer1.Enabled := False;
  GlsSmdQcFrm.Cursor := crDefault;
end;

procedure TGlsSmdQcFrm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Timer1.Enabled := False;
  GLCadencer1.Enabled := False;
  { NoGLRunning:=True; }
  GlsSmdQcFormY := GlsSmdQcFrm.top;
  GlsSmdQcFormX := GlsSmdQcFrm.left;

end;

procedure TGlsSmdQcFrm.FormHide(Sender: TObject);
begin
  Timer1.Enabled := False;
  GLCadencer1.Enabled := False;
end;

procedure TGlsSmdQcFrm.ExitBtnClick(Sender: TObject);
begin
  Close; { ModalResult:=mrOK; }
end;

procedure TGlsSmdQcFrm.HelpBtnClick(Sender: TObject);
begin
  Application.HelpContext(8000);
end;

procedure TGlsSmdQcFrm.CheckBox1Click(Sender: TObject);
begin
  Actor1.OverlaySkeleton := CheckBox1.Checked;
end;

procedure TGlsSmdQcFrm.GLSceneViewer1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  mx := X;
  my := Y;
end;

procedure TGlsSmdQcFrm.GLSceneViewer1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if Shift <> [] then
  begin
    Actor1.Roll(mx - X);
  end;
  mx := X;
  my := Y;
end;

procedure TGlsSmdQcFrm.Timer1Timer(Sender: TObject);
begin
  Caption := Format('%.1f FPS', [GLSceneViewer1.FramesPerSecond]);
  GLSceneViewer1.ResetPerformanceMonitor;
end;

procedure TGlsSmdQcFrm.GLCadencer1Progress(Sender: TObject;
  const deltaTime, newTime: Double);
begin
  if AlreadyLoaded then
  begin
    // IDEAL SPINE ROTATION
    GetIdealBoneRotationLookingAt(Actor1, BoneIndex_Spine, 0,
      Cube1.AbsolutePosition, aaS, bbS, ccS);
    // ROTATE SPINE
    RotateBone(Actor1, BoneIndex_Spine, aaS, bbS, ccS, TrackBar7.Position / 100,
      2, -2, 1, -1, 1, -1);

    // IDEAL HEAD ROTATION
    GetIdealBoneRotationLookingAt(Actor1, BoneIndex_Head, 0,
      Cube2.AbsolutePosition, aaH, bbH, ccH);
    // ROTATE HEAD
    RotateBone(Actor1, BoneIndex_Head, aaH - aaS, bbH - bbS, ccH - ccS,
      TrackBar8.Position / 100, 2, -2, 1, -1, 1, -1);

  end;
  GLScene1.NotifyChange(nil);
end;

{ (Use Milkshape to decompile a H-L SMD character)
  http://www.milkshape3d.com }
{ (Loading will be slow if there are many animations) }
procedure TGlsSmdQcFrm.Button1Click(Sender: TObject);
begin
  OpenDialog1.Filter := 'lifeless (*.qc)|*.qc';
  { OpenDialog1.InitialDir := TigerPath; }
  OpenDialog1.fileName := '*.qc';
  if OpenDialog1.Execute then
    DoCcOpen(OpenDialog1.fileName);
end;

procedure TGlsSmdQcFrm.DoCcOpen(const fileName: String);
var
  t: Integer;
begin
  { TigerPath:=ExtractFilePath(FileName); }
  Application.ProcessMessages;
  GlsSmdQcFrm.Cursor := crHourGlass;
  Timer1.Enabled := True;
  GLCadencer1.Enabled := True;
  // LOAD THE Filename, into Actor1, with MODEL, + with ANIMATIONS
  LoadQC(fileName, Actor1, True, True);

  BoneIndex_Spine := GetBoneIndexByName(Actor1, 'Bip01 Spine');
  BoneIndex_Head := GetBoneIndexByName(Actor1, 'Bip01 Head');

  for t := 1 to Actor1.Animations.Count - 1 do
  begin
    cboAnimations.Items.Add(Actor1.Animations[t].Name);
  end;

  Actor1.OverlaySkeleton := False;
  Actor1.Interval := 50;

  Actor1.SwitchToAnimation(Actor1.Animations[1]);

  cboAnimations.ItemIndex := cboAnimations.Items.IndexOf
    (Actor1.Animations[1].Name);

  AlreadyLoaded := True;

  GlsSmdQcFrm.Cursor := crDefault;

end;

procedure TGlsSmdQcFrm.cboAnimationsChange(Sender: TObject);
begin
  Timer1.Enabled := True; { Just in case its been hiding... }
  GLCadencer1.Enabled := True;
  Actor1.SwitchToAnimation(cboAnimations.Text, True);
end;

procedure TGlsSmdQcFrm.TrackBar1Change(Sender: TObject);
begin
  Cube1.Position.SetPoint(TrackBar1.Position, TrackBar2.Position,
    TrackBar3.Position);
end;

procedure TGlsSmdQcFrm.TrackBar4Change(Sender: TObject);
begin
  Cube2.Position.SetPoint(TrackBar4.Position, TrackBar5.Position,
    TrackBar6.Position);
end;

procedure TGlsSmdQcFrm.Panel2MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  Tb1, Tb2: TTrackBar;
begin
  // JUST AN EASY WAY FOR MOVING THE CUBES AROUND...
  // -----------------------------------------------
  if Sender = Panel2 then
  begin
    Tb2 := TrackBar1;
    Tb1 := TrackBar2;
  end
  else if Sender = Panel3 then
  begin
    Tb2 := TrackBar2;
    Tb1 := TrackBar3;
  end
  else if Sender = Panel4 then
  begin
    Tb2 := TrackBar4;
    Tb1 := TrackBar5;
  end
  else
  begin
    Tb2 := TrackBar5;
    Tb1 := TrackBar6;
  end;

  if Shift <> [] then
  begin
    Tb1.Position := (TPanel(Sender).Width div 2) - X;
    Tb2.Position := (TPanel(Sender).Height div 2) - Y;
  end;
end;

end.
