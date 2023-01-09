(*
  Original project
  Created by Dave Kerr (kerrd@hotmail.com)
  http://aiplanet.sourceforge.net
  $ Id: fFirstForm.pas, v 1.16 2003/09/03 00:14:16 aidave Exp $
*)
unit fFirstForm;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Imaging.Jpeg,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.ExtCtrls,
  fReality,
  vSplashScreen,
  cUserSettings,
  fConstruction,
  cAIReality,
  fNewReality;

  //JvComponent, JvBaseDlg, JvTipOfDay

type
  TfmFirstForm = class(TForm)
    ShowTimer: TTimer;
    imgSplash: TImage;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ShowTimerTimer(Sender: TObject);
    procedure FormPaint(Sender: TObject);
  private
     
    fRealityForm: TfmReality;
    fDetectedMonitors: integer;
    fMonitors: integer;
    fScreen: TScreen;
    fUserSettings: TUserSettings;
    fConstruction: TfmConstruction;
    fErrorCount: integer;
  public
     
    property Screen: TScreen read fScreen;
    property DetectedMonitors: integer read fDetectedMonitors;
    property Monitors: integer read fMonitors write fMonitors;
    property UserSettings: TUserSettings read fUserSettings;
    property Construction: TfmConstruction read fConstruction;
    property RealityForm: TfmReality read fRealityForm;

    function MultipleMonitors: boolean;
    procedure AppException(Sender: TObject; E: Exception);

    procedure ShowIntro;
    procedure ShowSplash;
  end;

var
  fmFirstForm: TfmFirstForm;

implementation

uses
  fIntro, fSplash, cAIThings, cGlobals, fError, fAbout;

{$R *.DFM}

procedure TfmFirstForm.FormCreate(Sender: TObject);
begin
  fErrorCount := 0;

  Application.OnException := Self.AppException;

  SetCurrentDir(ExtractFilePath(ParamStr(0)));

  gVersion := 960;
  
  fConstruction := TfmConstruction.Create(self);

  Width := imgSplash.Picture.Bitmap.Width;
  Height := imgSplash.Picture.Bitmap.Height;
  SetWindowRgn(Handle, BitmapToRegion(imgSplash.Picture.Bitmap.Handle, clBlack, 10), True);

  fScreen := TScreen.Create(self);
  fDetectedMonitors := Screen.MonitorCount;
  Monitors := DetectedMonitors;

  Construction.AddEvent('Detected monitors = ' + IntToStr(Monitors));

  fUserSettings := TUserSettings.Create;
  Construction.AddEvent('Loading settings...');
  UserSettings.LoadFromRegistry;
  Construction.AddEventSuccess(' done.');

  if UserSettings.SplashStart then
    ShowSplash;

  if UserSettings.SplashExit then
    ShowTimer.Interval := 1500
  else
    ShowTimer.Interval := 1;

  // create and go to reality form (goes to Manager Form, then Space Form)
  fRealityForm := TfmReality.Create(self);
end;

procedure TfmFirstForm.FormDestroy(Sender: TObject);
begin
  Construction.AddEvent('Saving settings...');
  UserSettings.SaveToRegistry;
  Construction.AddEventSuccess(' done.');

  fUserSettings.Free;
  fScreen.Free;

  Construction.AddEventSuccess('Goodbye! :)');
  fConstruction.Free;
end;

procedure TfmFirstForm.FormShow(Sender: TObject);
var
  myFileName: string;
  myLoadTemp: boolean;
begin
  myFileName := '';
  myLoadTemp := false;
  SetCurrentDir(ExtractFilePath(ParamStr(0)));

  if ParamCount > 0 then
  begin
    if FileExists(ParamStr(1)) then
      myFileName := ParamStr(1);
  end
  else
  // check to see if load last planet on startup
  if UserSettings.LoadOnStartup then
  begin
    myFileName := UserSettings.WorkingFile;
    myLoadTemp := true;
    UserSettings.LoadOnStartup := false;
    UserSettings.SaveToRegistry;
  end;

  RealityForm.StartUp(myFileName);

  if myLoadTemp then
  begin
    UserSettings.LoadOnStartup := true;
    UserSettings.SaveToRegistry;
  end;

  RealityForm.ShowModal;

  while (RealityForm.ExitInstruction <> cInstructionExit) do
  begin
    case RealityForm.ExitInstruction of
      cInstructionLoadFile:
      begin
        myFileName := RealityForm.FileName;
        RealityForm.ShutDown;
        fRealityForm.Free;
        SetCurrentDir(ExtractFilePath(ParamStr(0)));
        fRealityForm := TfmReality.Create(self);
        RealityForm.StartUp(myFileName);
        if myFileName = 'new.air' then
          RealityForm.StartReality
        else
          RealityForm.StopReality;
        RealityForm.ShowModal;
      end;
    end; // case
  end;

  RealityForm.ShutDown;
  fRealityForm.Free;

  ShowTimer.Enabled := true;
end;

procedure TfmFirstForm.ShowIntro;
var
  myfmIntro: TfmIntro;
begin
  myfmIntro := TfmIntro.Create(self);
  myfmIntro.Monitors := Monitors;
  myfmIntro.ShowModal;
  myfmIntro.Free;
end;

procedure TfmFirstForm.ShowSplash;
var
  mySplash: TfmSplash;
begin
  mySplash := TfmSplash.Create(self);
  mySplash.ShowModal;
  mySplash.Refresh;
  mySplash.Free;
end;

function TfmFirstForm.MultipleMonitors: boolean;
begin
  result := Monitors > 1;
end;

procedure TfmFirstForm.ShowTimerTimer(Sender: TObject);
begin
  Close;
end;

procedure TfmFirstForm.FormPaint(Sender: TObject);
begin
  Canvas.Draw(0, 0, imgSplash.Picture.Bitmap);
end;

procedure TfmFirstForm.AppException(Sender: TObject; E: Exception);
var
  myfmError: TfmError;
  myAbout: TAboutInfo;
begin
  fErrorCount := fErrorCount + 1;
  if fErrorCount > 4 then begin halt; exit; end;
  if fErrorCount > 1 then begin Close; exit; end;

  RealityForm.RealityClock.Enabled := false;
  RealityForm.ManagerForm.SpaceForm.GLCadencer.Enabled := false;
  myfmError := TfmError.Create(self);
  myAbout := TAboutInfo.Create(ParamStr(0));
  myfmError.Error := E;
  with myfmError.memReport.Lines do
  begin
    Clear;
    Add('artificial planet v' + myAbout.FileVersion);
    Add('');
    Add('Exception Type: ' + E.ClassName);
    Add('Application Name: ' + ExtractFileName(ParamStr(0)) + '.');
    Add('Error Message: ' + E.Message);
    Add('Registry settings: ' + UserSettings.OneLineDisplay);
    Add('Construction-------');
    AddStrings(fConstruction.redStatus.Lines);
    RealityForm.Reality.Environment.Things.DisplayCounts(myfmError.memReport.Lines);
    Add('LastAction: ' + RealityForm.ManagerForm.SpaceForm.LastActivity + ' at '
      + IntToStr(RealityForm.ManagerForm.SpaceForm.LastTime));
    //Add('3DView-----');
    //RealityForm.ManagerForm.SpaceForm.FullDisplay(myfmError.memReport.Lines);
  end;
  myAbout.Free;
  myfmError.ShowModal;
  myfmError.Free;
  RealityForm.ExitInstruction := cInstructionExit;
  RealityForm.Close;
end;

end.
