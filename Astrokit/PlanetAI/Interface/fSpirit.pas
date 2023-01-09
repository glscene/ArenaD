unit fSpirit;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Contnrs,
  System.Math,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.ComCtrls,
  Vcl.ExtCtrls,
  Vcl.StdCtrls,
  cAILink,
  Vcl.Buttons,
  ColorGrd,
  Vcl.ToolWin,
  Vcl.Menus,

  GLS.Scene,
  GLS.VectorTypes,
  GLS.Coordinates,
  GLS.SceneViewer;

type
  TRefreshMethod = procedure of object;

  TfmSpirit = class(TForm)
    Panel2: TPanel;
    Panel4: TPanel;
    tbTools: TToolBar;
    tbTrack: TToolButton;
    FullDisplay: TMemo;
    tbModify: TToolButton;
    ModifyMenu: TPopupMenu;
    Stop1: TMenuItem;
    Kill1: TMenuItem;
    Heal1: TMenuItem;
    Reposition1: TMenuItem;
    tbWindow: TToolButton;
    WindowMenu: TPopupMenu;
    Refresh1: TMenuItem;
    Close1: TMenuItem;
    Scrollbars1: TMenuItem;
    OnTop1: TMenuItem;
    Die1: TMenuItem;
    GLSceneTracker: TGLSceneViewer;
    cbView: TCheckBox;
    ViewSplitter: TSplitter;
    LockCamera1: TMenuItem;
    Wordwrap1: TMenuItem;
    menuDNA: TMenuItem;
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure tbTrackClick(Sender: TObject);
    procedure Heal1Click(Sender: TObject);
    procedure Kill1Click(Sender: TObject);
    procedure Close1Click(Sender: TObject);
    procedure Refresh1Click(Sender: TObject);
    procedure Scrollbars1Click(Sender: TObject);
    procedure OnTop1Click(Sender: TObject);
    procedure Stop1Click(Sender: TObject);
    procedure Die1Click(Sender: TObject);
    procedure GLSceneTrackerMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure GLSceneTrackerMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure cbViewClick(Sender: TObject);
    procedure LockCamera1Click(Sender: TObject);
    procedure Wordwrap1Click(Sender: TObject);
    procedure GLSceneTrackerMouseEnter(Sender: TObject);
    procedure menuDNAClick(Sender: TObject);
    procedure Reposition1Click(Sender: TObject);
  private
    fTarget: AILink;
    fSpiritHolder: pointer;
    tempString: TStringList;
    fDead: boolean;
    fDeletion: boolean;
    mx, my : Integer;
    myCamera: TGLCamera;
    LockCamera: boolean;
    procedure StartViewer;
    procedure StopViewer;
  public
    procedure RefreshAll;
    procedure Advance;
    property Target: AILink read fTarget;
    property SpiritHolder: pointer read fSpiritHolder write fSpiritHolder;
    property Deletion: boolean read fDeletion;
  end;

var
  fmSpirit: TfmSpirit;

implementation

{$R *.DFM}

uses
  fEditLine, fReality, cUtilities, fImages, fManager,
  vSpiritManager, cGlobals, cAIThings, fFirstForm, cAILife,
  vInterfaceClasses, GLS.VectorGeometry, fDNA, fPosition, cAIDNA;

procedure TfmSpirit.Advance;
begin
  if Target.ValidTarget then
  begin
    LockWindowUpdate(FullDisplay.Handle);
    tempString.Clear;
    AIThing(Target.Target).FullDisplay(tempString);
    FullDisplay.Lines.Clear;
    FullDisplay.Lines.Add(tempString.Text);
    LockWindowUpdate(0);
  end
  else
  begin
    if not fDead then
    begin
      FullDisplay.Lines.Add('DEAD');
      Caption := Caption + ' Dead';
    end;
    fDead := true;
    StopViewer;
    cbView.Enabled := false;
  end;

  if GLSceneTracker.Visible then
  begin
//    if myCamera.DistanceToTarget > 5 then
//      myCamera.AdjustDistanceToTarget(0.98);
    // sets the camera to rotate properly around top of target
    myCamera.Up := myCamera.TargetObject.Position;
    if LockCamera then
      myCamera.MoveAroundTarget(-25, 0);
  end;
end;

procedure TfmSpirit.RefreshAll;
var
  myThing: AIThing;
begin
  if Target.ValidTarget then
  begin
    myThing := Target.Target;
//    panName.Caption := myThing.Name + ' ' + IntToStr(myThing.Handle);
    Caption := myThing.Name + ' ' + IntToStr(myThing.Handle);
  end;
end;

procedure TfmSpirit.FormShow(Sender: TObject);
begin
  if Target.ValidTarget then
  begin
    if (myCamera=nil)
    and fmFirstForm.UserSettings.Auto3DView
    and (Target.Target.Crossover<>nil) then
      StartViewer;
    menuDNA.Enabled := Target.Target.HasDNA;
  end;

  RefreshAll;
  Advance;
end;

procedure TfmSpirit.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if not fDeletion and fDead then
  begin
    if OnTop1.Checked then OnTop1.Click;
    if (MessageDlg('Target is dead. Remove window?',
     mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
    fDeletion := true;
  end;

  CanClose := false;
  TSpiritHolder(SpiritHolder).Hide;
end;

procedure TfmSpirit.FormCreate(Sender: TObject);
begin
  fTarget := gEnvironment.References.NewLink(gReality);
  tempString := TStringList.Create;
  fDead := false;
  fDeletion := false;
  LockCamera := false;
end;

procedure TfmSpirit.FormDestroy(Sender: TObject);
begin
  gEnvironment.References.Remove(fTarget);
  tempString.Free;

  if myCamera<>nil then
///   fmFirstForm.RealityForm.ManagerForm.SpaceForm.GLScene.CurrentCamera.Remove(myCamera, false);
end;

procedure TfmSpirit.tbTrackClick(Sender: TObject);
begin
  if Target.ValidTarget then
    fmFirstForm.RealityForm.ManagerForm.SpaceForm.FindTarget(Target.Target);
end;

procedure TfmSpirit.Heal1Click(Sender: TObject);
var
  myThing: AIThing;
begin
  if Target.ValidTarget then
  begin
    myThing := Target.Target;
    if myThing is AILivingThing then
      AILivingThing(myThing).Health := AILivingThing(myThing).Health + 256;
  end;
end;

procedure TfmSpirit.Kill1Click(Sender: TObject);
var
  myThing: AIThing;
begin
  if Target.ValidTarget then
  begin
    myThing := Target.Target;
    myThing.Cease;
  end;
end;

procedure TfmSpirit.Close1Click(Sender: TObject);
begin
  fDeletion := true;
  Close;
end;

procedure TfmSpirit.Refresh1Click(Sender: TObject);
begin
  Advance;
end;

procedure TfmSpirit.Scrollbars1Click(Sender: TObject);
begin
  Scrollbars1.Checked := not Scrollbars1.Checked;

  if Scrollbars1.Checked then
    FullDisplay.ScrollBars := ssBoth
  else
    FullDisplay.ScrollBars := ssNone;
end;

procedure TfmSpirit.OnTop1Click(Sender: TObject);
begin
  OnTop1.Checked := not OnTop1.Checked;

  if OnTop1.Checked then
    FormStyle := fsStayOnTop
  else
    FormStyle := fsNormal;
end;

procedure TfmSpirit.Stop1Click(Sender: TObject);
var
  myThing: AIThing;
begin
  if Target.ValidTarget then
  begin
    myThing := Target.Target;
    myThing.Position.Velocity.Zero;
    myThing.Position.Acceleration.Zero;
  end;
end;

procedure TfmSpirit.Die1Click(Sender: TObject);
var
  myThing: AIThing;
begin
  if Target.ValidTarget then
  begin
    myThing := Target.Target;
    if myThing is AILivingThing then
      AILivingThing(myThing).Die;
  end;
end;

procedure TfmSpirit.StartViewer;
var
  myCrossover: TCrossover;
begin
  // enable view
  GLSceneTracker.Visible := true;
  // enable splitter
  ViewSplitter.Visible := true;

  // already started?
  if myCamera <> nil then
    exit;

  // trackable target?
  if not Target.ValidTarget then
    exit;

  // must have visual crossover
  myCrossover := TCrossover(Target.Target.Crossover);
  if myCrossover=nil then
  begin
    StopViewer;
    cbView.Enabled := false;
    ShowMessage('Unable to open 3D view for this thing.');
    exit;
  end;

  // create a camera
///  myCamera := TGLCamera(fmFirstForm.RealityForm.ManagerForm.SpaceForm.GLScene.CurrentCamera.AddNewChild(TGLCamera));
  myCamera.NearPlaneBias := 0.001;

  GLSceneTracker.Camera := myCamera;

  // track the target
  myCamera.TargetObject := TGLBaseSceneObject(myCrossover.SubVisuals.Items[0]);
  // position the camera above the target
  myCamera.Position := myCamera.TargetObject.Position;
  myCamera.Position.AddScaledVector(0.5, myCamera.TargetObject.Position.AsAffineVector);
  myCamera.MoveAroundTarget(0,0.1);

  cbView.Checked := true;
end;

procedure TfmSpirit.StopViewer;
begin
  ViewSplitter.Visible := false;
  GLSceneTracker.Visible := false;
  cbView.Checked := false;
end;

procedure TfmSpirit.GLSceneTrackerMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   mx:=x; my:=y;
end;

procedure TfmSpirit.GLSceneTrackerMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if not GLSceneTracker.Visible then exit;

   if Shift<>[] then begin
      myCamera.MoveAroundTarget(my-y, mx-x);
      mx:=x; my:=y;
   end;
end;

procedure TfmSpirit.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  if not GLSceneTracker.Visible then exit;

	myCamera.AdjustDistanceToTarget(Power(1.1, WheelDelta/-512));
end;

procedure TfmSpirit.cbViewClick(Sender: TObject);
begin
  if cbView.Checked then
    StartViewer
  else
    StopViewer;
end;

procedure TfmSpirit.LockCamera1Click(Sender: TObject);
begin
  LockCamera1.Checked := not LockCamera1.Checked;
  LockCamera := LockCamera1.Checked;
end;

procedure TfmSpirit.Wordwrap1Click(Sender: TObject);
begin
  Wordwrap1.Checked := not Wordwrap1.Checked;

  FullDisplay.WordWrap := Wordwrap1.Checked;
end;

procedure TfmSpirit.GLSceneTrackerMouseEnter(Sender: TObject);
begin
  GLSceneTracker.SetFocus;
end;

procedure TfmSpirit.menuDNAClick(Sender: TObject);
var
  myfmDNA: TfmDNA;
  myThing: AIThing;
begin
  // make sure our target has DNA
  if not Target.ValidTarget then exit;
  myThing := Target.Target;
  if not (myThing.HasDNA) then exit;
  // stop reality (in case target dies)
  fmFirstForm.RealityForm.StopReality;
  // edit DNA
  myfmDNA := TfmDNA.Create(self);
  myfmDNA.DNA := AIDNA(myThing.GetDNA);
  myfmDNA.panID.Caption := myThing.Name + ' ' + IntToStr(myThing.Handle);
  myfmDNA.ShowModal;
  myfmDNA.Free;
  // refresh
  Advance;
end;

procedure TfmSpirit.Reposition1Click(Sender: TObject);
var
  myfmPosition: TfmPosition;
  myThing: AIThing;
begin
  // make sure our target has Position
  if not Target.ValidTarget then exit;
  myThing := Target.Target;
  // stop reality (in case target dies)
  fmFirstForm.RealityForm.StopReality;
  // edit Position
  myfmPosition := TfmPosition.Create(self);
  myfmPosition.Position := myThing.Position;
  myfmPosition.panID.Caption := myThing.Name + ' ' + IntToStr(myThing.Handle);
  myfmPosition.ShowModal;
  myfmPosition.Free;
  // refresh
  Advance;
end;

end.
