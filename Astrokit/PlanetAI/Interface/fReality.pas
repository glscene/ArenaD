{
  ai.planet
  http://aiplanet.sourceforge.net
  Created by Dave Kerr (kerrd@hotmail.com)
  $Id: fReality.pas,v 1.46 2003/10/01 00:55:09 aidave Exp $
}
unit fReality;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Controls,Forms, Dialogs,
  Menus, Vcl.ComCtrls,ExtCtrls, Vcl.StdCtrls,Vcl.Buttons, ToolWin, ImgList, cAIReality,
  Contnrs, fManager, fMiniForm;

  //JvComponent, JvBaseDlg, JvTipOfDay,
  //geTipofDay

const
  cInstructionExit = 0;
  cInstructionLoadFile = 1;

type
  TfmReality = class(TMiniForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Quit1: TMenuItem;
    Run1: TMenuItem;
    Add1: TMenuItem;
    menuGo: TMenuItem;
    menuStop: TMenuItem;
    Set1: TMenuItem;
    TimeMode1: TMenuItem;
    menuSetTimeTicking: TMenuItem;
    menuSetTimeFlowing: TMenuItem;
    Object1: TMenuItem;
    AI1: TMenuItem;
    Apple1: TMenuItem;
    Orange1: TMenuItem;
    Panel2: TPanel;
    Panel4: TPanel;
    btnGo: TBitBtn;
    btnStop: TBitBtn;
    Panel16: TPanel;
    radTicking: TRadioButton;
    radFlowing: TRadioButton;
    menuMonitor: TMenuItem;
    menuMonitorSingle: TMenuItem;
    menuMonitorDouble: TMenuItem;
    View1: TMenuItem;
    Net1: TMenuItem;
    AllowInterNetTravel1: TMenuItem;
    AllowCommunication1: TMenuItem;
    menuEnvironmentName: TMenuItem;
    Names1: TMenuItem;
    menuSave: TMenuItem;
    menuCreatorName: TMenuItem;
    About1: TMenuItem;
    About2: TMenuItem;
    Panel1: TPanel;
    Panel17: TPanel;
    laBspeed: TLabel;
    Label1: TLabel;
    trackSpeed: TTrackBar;
    Panel3: TPanel;
    panRealityT: TPanel;
    panRealityTime: TPanel;
    panRealityTime1: TPanel;
    Load1: TMenuItem;
    SaveAs1: TMenuItem;
    menuNewReality: TMenuItem;
    menuReadme: TMenuItem;
    RealityClock: TTimer;
    menuViewManager: TMenuItem;
    menuViewSpace: TMenuItem;
    menuViewEvents: TMenuItem;
    menuViewLists: TMenuItem;
    menuTutorial: TMenuItem;
    odLoadReality: TOpenDialog;
    sdSaveReality: TSaveDialog;
    menuKeyboard: TMenuItem;
    menuMax: TMenuItem;
    menuSettings: TMenuItem;
    labRoundTime: TLabel;
    Panel5: TPanel;
    btnExit: TBitBtn;
    ime1: TMenuItem;
    Construction1: TMenuItem;
    Restore1: TMenuItem;
    ipoftheDay1: TMenuItem;
    ReloadDNA1: TMenuItem;
    btn20: TBitBtn;
    cbCollisions: TCheckBox;
    cbAI: TCheckBox;
    AAsteroids1: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    procedure FormShow(Sender: TObject);
    procedure menuSetTimeTickingClick(Sender: TObject);
    procedure menuSetTimeFlowingClick(Sender: TObject);
    procedure btnGoClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure radTickingClick(Sender: TObject);
    procedure radFlowingClick(Sender: TObject);
    procedure menuMonitorSingleClick(Sender: TObject);
    procedure menuMonitorDoubleClick(Sender: TObject);
    procedure menuGoClick(Sender: TObject);
    procedure menuStopClick(Sender: TObject);
    procedure trackSpeedChange(Sender: TObject);
    procedure Quit1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure menuEnvironmentNameClick(Sender: TObject);
    procedure menuCreatorNameClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure About2Click(Sender: TObject);
    procedure menuReadmeClick(Sender: TObject);
    procedure RealityClockTimer(Sender: TObject);
    procedure menuViewManagerClick(Sender: TObject);
    procedure menuViewSpaceClick(Sender: TObject);
    procedure menuViewEventsClick(Sender: TObject);
    procedure menuViewListsClick(Sender: TObject);
    procedure Load1Click(Sender: TObject);
    procedure menuSaveClick(Sender: TObject);
    procedure menuNewRealityClick(Sender: TObject);
    procedure SaveAs1Click(Sender: TObject);
    procedure menuTutorialClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure menuKeyboardClick(Sender: TObject);
    procedure menuMaxClick(Sender: TObject);
    procedure menuSettingsClick(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Restore1Click(Sender: TObject);
    procedure ipoftheDay1Click(Sender: TObject);
    procedure ReloadDNA1Click(Sender: TObject);
    procedure btn20Click(Sender: TObject);
    procedure cbCollisionsClick(Sender: TObject);
    procedure cbAIClick(Sender: TObject);
    procedure AAsteroids1Click(Sender: TObject);
  private
     
    fReality: AIReality;
    fManagerForm: TfmManager;
    fPaused: boolean;

    fFileName: string;
    fExitInstruction: integer;

    procedure MyMinimize(Sender: TObject; var state: TMiniState);
    procedure MyMaximize(Sender: TObject; var state: TMiniState);
  public
     
    property Reality: AIReality read fReality;
    property ManagerForm: TfmManager read fManagerForm;
    property Paused: boolean read fPaused write fPaused;
    property FileName: string read fFileName write fFileName;
    property ExitInstruction: integer read fExitInstruction write fExitInstruction;

    procedure RefreshAll;
    procedure RefreshInterface;
    procedure RefreshTickers;

    procedure StartReality;
    procedure StopReality;

    procedure Advance;
    procedure VerifyWindows;

    function  SaveRealityToFile(aFileName: string): boolean;

    procedure AddEvent(aEvent: string);

    procedure StartUp(aFileName: string);
    procedure ShutDown;

    procedure FlipOnOffSwitch; // switches the reality on/off
    procedure ShowTipOfTheDay;
  end;

var
  fmReality: TfmReality;

implementation

uses cAIThings, fSpirit, cUtilities, fEditLine, cAISpace, fImages,
  fFirstForm, fAbout, fIntro, fNewReality, fTutorial, fKeyboard, fMaximums,
  fSettings, frmTip;

{$R *.DFM}

// -----------------------------------------------------------------------------
// --------------------------- FORM LOGIC --------------------------------------
// -----------------------------------------------------------------------------
procedure TfmReality.FormCreate(Sender: TObject);
begin
  OnMinimize := MyMinimize;
  OnMaximize := MyMaximize;

  fExitInstruction := cInstructionExit;

  if fmFirstForm.UserSettings.TipOfTheDay then RealityClock.Enabled := false;
end;

procedure TfmReality.RefreshInterface;
begin
  RealityClock.Interval := Reality.ClockStagger;
  trackSpeed.Position := Reality.ClockStagger;

  btnGo.Enabled := not RealityClock.Enabled;
  btnStop.Enabled := RealityClock.Enabled;

  menuSetTimeTicking.Checked := Reality.TimeIsTicking;
  menuSetTimeFlowing.Checked := Reality.TimeIsFlowing;
  radTicking.Checked := Reality.TimeIsTicking;
  radFlowing.Checked := Reality.TimeIsFlowing;

  menuSetTimeTicking.Enabled := not RealityClock.Enabled;
  menuSetTimeFlowing.Enabled := not RealityClock.Enabled;
  radTicking.Enabled := not RealityClock.Enabled;
  radFlowing.Enabled := not RealityClock.Enabled;

  labRoundTime.Caption := IntToStr(RealityClock.Interval) + ' ms';

  if RealityClock.Enabled then
    Application.Title := 'Artificial Planet (Go)'
  else
    Application.Title := 'Artificial Planet (Stop)';

  cbCollisions.Checked := Reality.Environment.Things.Collisions;
  cbAI.Checked := Reality.Environment.Things.AI;
  cbCollisions.Visible := fmFirstForm.UserSettings.AdvancedMode;
  cbAI.Visible := fmFirstForm.UserSettings.AdvancedMode;

  RefreshTickers;
end;

procedure TfmReality.RefreshAll;
begin
  RefreshInterface;
  ManagerForm.Advance;
end;

procedure TfmReality.FormShow(Sender: TObject);
begin
  if fmFirstForm.UserSettings.TipOfTheDay then RealityClock.Enabled := true;

  fmFirstForm.Construction.AddEvent('Running...');

  RefreshAll;
  Align := alTop;

  ManagerForm.Show;
  ManagerForm.PopSpace;
  if (ManagerForm.SpaceForm.Width>=1024) or (ManagerForm.SpaceForm.Height>=728) then
  begin
    ManagerForm.SpaceForm.UnStickyFit;
    ManagerForm.SpaceForm.Width := 1024;
    ManagerForm.SpaceForm.Height := 728;
  end;

  fmFirstForm.Construction.AddEvent('Still running...');
end;

procedure TfmReality.menuSetTimeTickingClick(Sender: TObject);
begin
  Reality.SetTimeTicking;
  RefreshInterface;
end;

procedure TfmReality.menuSetTimeFlowingClick(Sender: TObject);
begin
  Reality.SetTimeFlowing;
  RefreshInterface;
end;

procedure TfmReality.btnGoClick(Sender: TObject);
begin
  StartReality;
  RefreshInterface;
  if ManagerForm.SpaceForm.Visible then
    ManagerForm.SpaceForm.SetFocus;
end;

procedure TfmReality.btnStopClick(Sender: TObject);
begin
  StopReality;
  RefreshInterface;
  if ManagerForm.SpaceForm.Visible then
    ManagerForm.SpaceForm.SetFocus;
end;

procedure TfmReality.StartReality;
begin
  if Reality.TimeIsFlowing then
  begin
    fmFirstForm.Construction.AddEvent('Started time flowing.');
    AddEvent(Reality.Creator + ' started time flowing.');
    RealityClock.Enabled := true;
    ManagerForm.SpaceForm.InformOfStart;
  end
  else
  begin
    fmFirstForm.Construction.AddEvent('Ticked time.');
    AddEvent(Reality.Creator + ' ticked time.');
    Advance;
  end;
  RefreshAll;
end;

procedure TfmReality.StopReality;
begin
  RealityClock.Enabled := false;
  ManagerForm.SpaceForm.InformOfStop;

  AddEvent(Reality.Creator + ' stopped time.');
  fmFirstForm.Construction.AddEvent('Stopped time.');

  RefreshAll;
end;

procedure TfmReality.radTickingClick(Sender: TObject);
begin
  Reality.SetTimeTicking;
  RefreshInterface;
end;

procedure TfmReality.radFlowingClick(Sender: TObject);
begin
  Reality.SetTimeFlowing;
  RefreshInterface;
end;

procedure TfmReality.menuMonitorSingleClick(Sender: TObject);
begin
//  MultipleMonitors := false;
  RefreshInterface;
end;

procedure TfmReality.menuMonitorDoubleClick(Sender: TObject);
begin
//  MultipleMonitors := true;
  RefreshInterface;
end;

procedure TfmReality.menuGoClick(Sender: TObject);
begin
  btnGoClick(Sender);
end;

procedure TfmReality.menuStopClick(Sender: TObject);
begin
  btnStopClick(Sender);
end;

procedure TfmReality.trackSpeedChange(Sender: TObject);
begin
  Reality.ClockStagger := trackSpeed.Position;
  RefreshInterface;
end;

procedure TfmReality.Quit1Click(Sender: TObject);
begin
  StopReality;
  Close;
end;

procedure TfmReality.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if Reality.IsRunning then
    StopReality;
  CanClose := true;
end;

procedure TfmReality.menuEnvironmentNameClick(Sender: TObject);
var
  myfmEditLine: TfmEditLine;
begin
  myfmEditLine := TfmEditLine.Create(self);

  myfmEditLine.edLine.Text := Reality.Environment.Name;

  if myfmEditLine.ShowModal = mrOK then
    Reality.Environment.Name := myfmEditLine.edLine.Text;

  myfmEditLine.Free;

  ManagerForm.SpaceForm.Caption := Reality.Environment.Name;

  RefreshAll;
end;

procedure TfmReality.menuCreatorNameClick(Sender: TObject);
var
  myfmEditLine: TfmEditLine;
begin
  myfmEditLine := TfmEditLine.Create(self);

  myfmEditLine.edLine.Text := Reality.Creator;

  if myfmEditLine.ShowModal = mrOK then
    Reality.Creator := myfmEditLine.edLine.Text;

  myfmEditLine.Free;

  RefreshAll;
end;

procedure TfmReality.AddEvent(aEvent: string);
begin
  ManagerForm.EventsForm.AddEvent(aEvent);
end;

procedure TfmReality.About2Click(Sender: TObject);
var
  myfmAbout: TfmAbout;
begin
  myfmAbout := TfmAbout.Create(self);

  myfmAbout.ShowModal;

  myfmAbout.Free;
end;

procedure TfmReality.menuReadmeClick(Sender: TObject);
var
  myfmIntro: TfmIntro;
begin
  myfmIntro := TfmIntro.Create(self);

  myfmIntro.Monitors := fmFirstForm.Monitors;
  myfmIntro.ShowModal;

  myfmIntro.Free;
end;

procedure TfmReality.MyMinimize(Sender: TObject; var state: TMiniState);
begin
  SetFocus;
  ManagerForm.BigHide;
  ManagerForm.Hide;

  state:= tmAll; // minimize all windows
end;

procedure TfmReality.MyMaximize(Sender: TObject; var state: TMiniState);
begin
  Show;
  ManagerForm.Show;
  ManagerForm.BigRestore;
  SetFocus;
end;

procedure TfmReality.Advance;
begin
  // HACK FOR RESTORING FROM MINIMIZED STATE
  if not (WindowState = wsMinimized)
    and not ManagerForm.Visible
    then
  begin
    Show;
    ManagerForm.BigRestore;
    SetFocus;
  end;

  Reality.TickTock;
  RefreshTickers;
  ManagerForm.Advance;
end;

procedure TfmReality.RefreshTickers;
begin
  panRealityTime1.Caption := IntToStr(Reality.Time);
end;

procedure TfmReality.RealityClockTimer(Sender: TObject);
begin
  Advance;
end;

procedure TfmReality.menuViewManagerClick(Sender: TObject);
begin
  if not ManagerForm.Visible then
  begin
    ManagerForm.Show;
    ManagerForm.BigRestore;
  end
  else
    ManagerForm.Hide;
end;

procedure TfmReality.menuViewSpaceClick(Sender: TObject);
begin
  ManagerForm.PopSpace;
end;

procedure TfmReality.menuViewEventsClick(Sender: TObject);
begin
  ManagerForm.PopEvents;
end;

procedure TfmReality.menuViewListsClick(Sender: TObject);
begin
  ManagerForm.PopLists;
end;

procedure TfmReality.Load1Click(Sender: TObject);
begin
  odLoadReality.InitialDir := ExtractFilePath(ParamStr(0)) + '\worlds';
  odLoadReality.FileName := '*.air';
  if odLoadReality.Execute then
  begin
    if Reality.ValidFile(odLoadReality.FileName) then
    begin
      StopReality;
      fFileName := odLoadReality.FileName;
      fExitInstruction := cInstructionLoadFile;
      Close;
    end
    else
      ShowMessage('Invalid file version');
  end;
  SetCurrentDir(ExtractFilePath(ParamStr(0)));
end;

procedure TfmReality.menuSaveClick(Sender: TObject);
begin
  if SaveRealityToFile(FileName) then
    ShowMessage('Reality saved (' + FileName + ')')
  else
    ShowMessage('Failed to save reality.');
  SetCurrentDir(ExtractFilePath(ParamStr(0)));
end;

function TfmReality.SaveRealityToFile(aFileName: string): boolean;
var
  myFile: TextFile;
begin
  AssignFile(myFile, aFileName);
  Rewrite(myFile);

  Reality.SaveToFile(myFile);
  fmFirstForm.UserSettings.WorkingFile := aFileName;

  writeln(myFile, 'Saved at: ' + DateToStr(Now) + ' ' + TimeToStr(Now));

  CloseFile(myFile);

  FileName := aFileName;
  result := true;
end;

procedure TfmReality.menuNewRealityClick(Sender: TObject);
var
  myNewReality: TfmNewReality;
begin
  StopReality;

  myNewReality := TfmNewReality.Create(self);

  if (myNewReality.ShowModal = mrOK) then
  begin
    ManagerForm.DropAll;

    SetCurrentDir(ExtractFilePath(ParamStr(0)));

    Reality.Clean;
    myNewReality.ExtractValues(Reality);
    Reality.SaveReality('new.air');

    fExitInstruction := cInstructionLoadFile;
    fFileName := 'new.air';
    Close;
  end;

  myNewReality.Free;
end;

procedure TfmReality.SaveAs1Click(Sender: TObject);
begin
  sdSaveReality.InitialDir := ExtractFilePath(ParamStr(0)) + '\worlds';
  sdSaveReality.FileName := '*.air';
  if sdSaveReality.Execute then
  begin
    if SaveRealityToFile(sdSaveReality.FileName) then
      ShowMessage('World saved as (' + FileName + ')')
    else
      ShowMessage('Failed to save world.');
  end;
  SetCurrentDir(ExtractFilePath(ParamStr(0)));
end;

procedure TfmReality.menuTutorialClick(Sender: TObject);
var
  myfmTutorial: TfmTutorial;
begin
  myfmTutorial := TfmTutorial.Create(self);

  myfmTutorial.ShowModal;

  myfmTutorial.Free;
end;

procedure TfmReality.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ManagerForm.DropAll;
  if Reality.IsRunning then
    StopReality;
end;

procedure TfmReality.menuKeyboardClick(Sender: TObject);
var
  myfmKeyboard: TfmKeyboard;
begin
  myfmKeyboard := TfmKeyboard.Create(self);

  myfmKeyboard.ShowModal;

  myfmKeyboard.Free;
end;

procedure TfmReality.menuMaxClick(Sender: TObject);
var
  myfmMaximums: TfmMaximums;
begin
  myfmMaximums := TfmMaximums.Create(self);

  myfmMaximums.ShowModal;

  myfmMaximums.Free;
end;

procedure TfmReality.menuSettingsClick(Sender: TObject);
var
  myfmSettings: TfmSettings;
begin
  myfmSettings := TfmSettings.Create(self);

  myfmSettings.UserSettings := fmFirstForm.UserSettings;
  myfmSettings.ShowModal;

  myfmSettings.Free;
end;

procedure TfmReality.btnExitClick(Sender: TObject);
begin
  StopReality;
  Close;
end;

procedure TfmReality.VerifyWindows;
//var
//  myFocus: TForm;
begin
  // make sure all windows are on top
  if not Visible then exit;
  if Focused then exit;

//  myFocus := ManagerForm.FocusForm;

//  Show;
  ManagerForm.BigRestore;
//  myFocus.SetFocus;
end;

procedure TfmReality.FormActivate(Sender: TObject);
begin
//  ManagerForm.BringToFront;
//  BringToFront;
//  ManagerForm.BigRestore;
end;

procedure TfmReality.StartUp(aFileName: string);
begin
  fReality := AIReality.Create;
  fFileName := 'current.air';

  // try to load a file
  if (aFileName <> '') and FileExists(aFileName) then
  begin
    fFileName := aFileName;
    if Reality.LoadReality(aFileName) then
    begin
      fmFirstForm.UserSettings.WorkingFile := fFileName;
      fmFirstForm.UserSettings.SaveToRegistry;
    end;
  end;
  
  fManagerForm := TfmManager.Create(self);

  ManagerForm.SpaceForm.Environment := Reality.Environment;
  ManagerForm.SpaceForm.BuildGalaxy;

  RefreshInterface;
end;

procedure TfmReality.ShutDown;
begin
  // if autosave on exit, then save
  if fmFirstForm.UserSettings.AutoSave then
  begin
    fmFirstForm.UserSettings.WorkingFile := FileName;
    SaveRealityToFile(FileName);
  end;

  fManagerForm.Free;

  fReality.Free;
end;

procedure TfmReality.FlipOnOffSwitch; // switches the reality on/off
begin
  if RealityClock.Enabled then
    StopReality
  else
    StartReality;
end;

procedure TfmReality.Restore1Click(Sender: TObject);
begin
  ManagerForm.SpaceForm.RestoreScene;
end;

procedure TfmReality.ReloadDNA1Click(Sender: TObject);
begin
  Reality.Environment.Things.LoadForms;
  ShowMessage('Base DNAs Reloaded');
end;

procedure TfmReality.btn20Click(Sender: TObject);
begin
  trackSpeed.Position := 40;
  Reality.ClockStagger := trackSpeed.Position;
  RefreshInterface;
end;

procedure TfmReality.cbCollisionsClick(Sender: TObject);
begin
  Reality.Environment.Things.Collisions := cbCollisions.Checked;
  RefreshInterface;
  if cbCollisions.Checked then
    fmFirstForm.Construction.AddEvent('Turned collisions on.')
  else
    fmFirstForm.Construction.AddEvent('Turned collisions off.');
end;

procedure TfmReality.ipoftheDay1Click(Sender: TObject);
begin
//  StopReality;
  ShowTipOfTheDay;
end;

procedure TfmReality.ShowTipOfTheDay;
var
  myTip: TformGETip;
begin
  myTip := TformGETip.Create(self);

  myTip.LoadTipFile(ExtractFilePath(ParamStr(0)) + '\data\tips.txt');
  myTip.cbxShowTips.Checked := fmFirstForm.UserSettings.TipOfTheDay;
  myTip.RandomTip;
  myTip.ShowModal;
  Application.ProcessMessages;

  fmFirstForm.UserSettings.TipOfTheDay := myTip.cbxShowTips.Checked;
  fmFirstForm.UserSettings.SaveToRegistry;

  myTip.Free;
end;

procedure TfmReality.cbAIClick(Sender: TObject);
begin
  Reality.Environment.Things.AI := cbAI.Checked;
  RefreshInterface;
  if cbAI.Checked then
    fmFirstForm.Construction.AddEvent('Turned artificial intelligence on.')
  else
    fmFirstForm.Construction.AddEvent('Turned artificial intelligence off.');
end;

procedure TfmReality.AAsteroids1Click(Sender: TObject);
var
  myfmEditLine: TfmEditLine;
begin
  myfmEditLine := TfmEditLine.Create(self);

  myfmEditLine.edLine.Text := IntToStr(Reality.Environment.Space.Asteroids);

  if myfmEditLine.ShowModal = mrOK then
    Reality.Environment.Space.Asteroids := StrToInt(myfmEditLine.edLine.Text);

  myfmEditLine.Free;

  ManagerForm.SpaceForm.Caption := Reality.Environment.Name;

  RefreshAll;
end;

end.


