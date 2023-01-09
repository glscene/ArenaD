unit vSpiritManager;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Types,
  System.Classes,
  System.Contnrs,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.ComCtrls,
  Vcl.ToolWin,
  Vcl.ExtCtrls,
  Vcl.StdCtrls,
  cAIThings,
  fSpirit,
  vInterfaceClasses;

type

  // *****************************************************************************
  TSpiritHolder = class(TObject)
  private
    fSpiritForm: TfmSpirit;
    fSpiritButton: TDynamicToolButton;
    fThing: AIThing;
    fVisible: boolean;
    fParentList: TObjectList;
    procedure CreateSpiritForm(aManager: TForm);
    procedure CreateSpiritButton(aSpiritBar: TToolBar);
  public
    Constructor Create(aParentList: TObjectList; aManager: TForm;
      aSpiritBar: TToolBar; aThing: AIThing);
    Destructor Destroy; override;
    property ParentList: TObjectList read fParentList;
    property Thing: AIThing read fThing;
    property SpiritForm: TfmSpirit read fSpiritForm;
    property SpiritButton: TDynamicToolButton read fSpiritButton;
    property Visible: boolean read fVisible;
    procedure Show;
    procedure Hide;
    procedure OnDown(Sender: TObject);
  end;

  // *****************************************************************************
  TSpiritList = class(TObjectList)
  private
    fManager: TForm;
    fSpiritBar: TToolBar;
    fForceSpaceAdvance: boolean;
    // use this to force the space window to advance
    // procedure NewSpiritWindow(aSpirit: AISpirit);
  public
    Constructor Create(aManager: TForm; aSpiritBar: TToolBar);
    property Manager: TForm read fManager;
    property SpiritBar: TToolBar read fSpiritBar;
    property ForceSpaceAdvance: boolean read fForceSpaceAdvance
      write fForceSpaceAdvance;
    procedure AdvanceAll;
    procedure HideAll;
    procedure AddSpirit(aThing: AIThing; aVisible: boolean);
    procedure RemoveSpirit(aSpiritHolder: TSpiritHolder);
  end;

  // ==============================================
implementation

uses
  fFirstForm,
  fManager,
  cGlobals,
  fImages;

Constructor TSpiritHolder.Create(aParentList: TObjectList; aManager: TForm;
  aSpiritBar: TToolBar; aThing: AIThing);
begin
  inherited Create;

  fParentList := aParentList;
  fThing := aThing;

  CreateSpiritButton(aSpiritBar);
  CreateSpiritForm(aManager);

  fVisible := false;
end;

Destructor TSpiritHolder.Destroy;
begin
  fSpiritForm.Free;

  inherited Destroy;
end;

procedure TSpiritHolder.CreateSpiritForm(aManager: TForm);
begin
  fSpiritForm := TfmSpirit.Create(aManager);
  SpiritForm.SpiritHolder := self;
  SpiritForm.Target.AssignTarget(Thing);
  // assign icon to form
  fmImages.imgIcons.GetIcon(ThingImageIndex(Thing.Kind), SpiritForm.Icon);
end;

procedure TSpiritHolder.CreateSpiritButton(aSpiritBar: TToolBar);
begin
  fSpiritButton := TDynamicToolButton.Create(aSpiritBar);

  SpiritButton.Caption := Thing.Name + ' ' + IntToStr(Thing.Handle) +
    '                ';
  SpiritButton.Hint := 'View ' + Thing.Name + ' ' + IntToStr(Thing.Handle);
  SpiritButton.ShowHint := true;
  SpiritButton.Down := false;
  SpiritButton.Grouped := false;
  SpiritButton.Style := tbsCheck;
  SpiritButton.OnClick := OnDown;
  // SpiritButton.PopupMenu := TfmManager(SpiritForm.Parent).ManagerPopupMenu;

  SpiritButton.ImageIndex := ThingImageIndex(Thing.Kind);

  SpiritButton.SetLinkToolBar(aSpiritBar);

  aSpiritBar.Width := aSpiritBar.Width + 1;
  aSpiritBar.Width := aSpiritBar.Width - 1;
end;

procedure TSpiritHolder.OnDown(Sender: TObject);
begin
  if SpiritButton.Down then
  begin
    Show;
    SpiritForm.SetFocus;
  end
  else
    Hide;
end;

procedure TSpiritHolder.Show;
begin
  SpiritForm.Show;
  SpiritButton.Down := true;
  fVisible := true;
  // SpiritForm.Top := SpiritForm.Top + fmFirstForm.Screen.Monitors[1].Top;
  // SpiritForm.Left := SpiritForm.Left + fmFirstForm.Screen.Monitors[1].Left;
end;

procedure TSpiritHolder.Hide;
begin
  SpiritForm.Hide;
  SpiritButton.Down := false;
  fVisible := false;
end;

Constructor TSpiritList.Create(aManager: TForm; aSpiritBar: TToolBar);
begin
  inherited Create(true);

  fManager := aManager;
  fSpiritBar := aSpiritBar;
end;

procedure TSpiritList.AdvanceAll;
var
  mySpiritHolder: TSpiritHolder;
  i: integer;
begin
  fForceSpaceAdvance := false;

  for i := 0 to Count - 1 do
  begin
    mySpiritHolder := TSpiritHolder(Items[i]);
    // advance visible forms
    if mySpiritHolder.Visible then
    begin
      mySpiritHolder.SpiritForm.Advance;
      // check to see if spaceform is not visible
      // if the spiritform is in 3d mode, then the spaceform needs to advance
      // so advance it only once per round
      if not fForceSpaceAdvance and not fmFirstForm.RealityForm.ManagerForm.
        SpaceForm.Visible and mySpiritHolder.SpiritForm.GLSceneTracker.Visible
      then
      begin
        fmFirstForm.RealityForm.ManagerForm.SpaceForm.Advance;
        fForceSpaceAdvance := true; // do not advance more than once per round
      end;
    end;
    // delete form if user Removes it
    if mySpiritHolder.SpiritForm.Deletion then
    begin
      fSpiritBar.RemoveControl(mySpiritHolder.SpiritButton);
      Delete(i);
      break;
    end;
  end;
end;

procedure TSpiritList.HideAll;
var
  mySpiritHolder: TSpiritHolder;
  i: integer;
begin
  for i := 0 to Count - 1 do
  begin
    mySpiritHolder := TSpiritHolder(Items[i]);
    mySpiritHolder.Hide;
  end;
end;

procedure TSpiritList.AddSpirit(aThing: AIThing; aVisible: boolean);
var
  mySpiritHolder: TSpiritHolder;
  i: integer;
  duplicate: boolean;
begin
  // check for valid thing
  if gThings.IndexOf(aThing) = -1 then
    exit;

  // check for existing window
  duplicate := false;
  for i := 0 to Count - 1 do
  begin
    mySpiritHolder := TSpiritHolder(Items[i]);
    if (mySpiritHolder.SpiritForm.Target.ValidTarget) and
      (mySpiritHolder.SpiritForm.Target.Target = aThing) then
    begin
      mySpiritHolder.Show;
      duplicate := true;
    end;
  end;
  if duplicate then
    exit;

  mySpiritHolder := TSpiritHolder.Create(self, Manager, SpiritBar, aThing);
  Add(mySpiritHolder);

  if aVisible then
    mySpiritHolder.Show;
end;

procedure TSpiritList.RemoveSpirit(aSpiritHolder: TSpiritHolder);
begin
  aSpiritHolder.Hide;
  Remove(aSpiritHolder);
  aSpiritHolder.Free;
end;

end.
