{
  ai.planet
  http://aiplanet.sourceforge.net
  Created by Dave Kerr (kerrd@hotmail.com)
  $Id: fSettings.pas,v 1.7 2003/10/01 00:55:09 aidave Exp $
}
unit fSettings;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls,Forms,
  Dialogs, Vcl.StdCtrls,Vcl.Buttons, Vcl.ExtCtrls,cUserSettings;

type
  TfmSettings = class(TForm)
    cbLoadOnStartup: TCheckBox;
    cbAutosave: TCheckBox;
    Label3: TLabel;
    panButtonBar: TPanel;
    panOKButton: TPanel;
    btnOK: TBitBtn;
    Label1: TLabel;
    cbSplashStart: TCheckBox;
    cbSplashExit: TCheckBox;
    cbInvertMouse: TCheckBox;
    Label2: TLabel;
    cbInvertPlanet: TCheckBox;
    cbAuto3DView: TCheckBox;
    cbInvertMouseWheel: TCheckBox;
    cbTipOfTheDay: TCheckBox;
    cbRememberView: TCheckBox;
    cbAdvancedMode: TCheckBox;
    procedure FormShow(Sender: TObject);
    procedure cbLoadOnStartupClick(Sender: TObject);
    procedure cbAutosaveClick(Sender: TObject);
    procedure cbSplashStartClick(Sender: TObject);
    procedure cbSplashExitClick(Sender: TObject);
    procedure cbInvertMouseClick(Sender: TObject);
    procedure cbInvertPlanetClick(Sender: TObject);
    procedure cbAuto3DViewClick(Sender: TObject);
    procedure cbInvertMouseWheelClick(Sender: TObject);
    procedure cbTipOfTheDayClick(Sender: TObject);
    procedure cbRememberViewClick(Sender: TObject);
    procedure cbAdvancedModeClick(Sender: TObject);
  private
     
    fUserSettings: TUserSettings;
  public
     
    property UserSettings: TUserSettings read fUserSettings write fUserSettings;
  end;

var
  fmSettings: TfmSettings;

implementation

uses fFirstForm;

{$R *.dfm}

procedure TfmSettings.FormShow(Sender: TObject);
begin
  cbLoadOnStartup.Checked := UserSettings.LoadOnStartup;
  cbAutosave.Checked := UserSettings.AutoSave;
  cbSplashStart.Checked := UserSettings.SplashStart;
  cbSplashExit.Checked := UserSettings.SplashExit;
  cbInvertMouse.Checked := UserSettings.InvertMouse;
  cbInvertPlanet.Checked := UserSettings.InvertPlanet;
  cbAuto3DView.Checked := UserSettings.Auto3DView;
  cbInvertMouseWheel.Checked := UserSettings.InvertMouseWheel;
  cbTipOfTheDay.Checked := UserSettings.TipOfTheDay;
  cbRememberView.Checked := UserSettings.RememberView;
  cbAdvancedMode.Checked := UserSettings.AdvancedMode;
end;

procedure TfmSettings.cbLoadOnStartupClick(Sender: TObject);
begin
  UserSettings.LoadOnStartup := cbLoadOnStartup.Checked;
  UserSettings.SaveToRegistry;
end;

procedure TfmSettings.cbAutosaveClick(Sender: TObject);
begin
  UserSettings.AutoSave := cbAutosave.Checked;
  UserSettings.SaveToRegistry;
end;

procedure TfmSettings.cbSplashStartClick(Sender: TObject);
begin
  UserSettings.SplashStart := cbSplashStart.Checked;
  UserSettings.SaveToRegistry;
end;

procedure TfmSettings.cbSplashExitClick(Sender: TObject);
begin
  UserSettings.SplashExit := cbSplashExit.Checked;
  UserSettings.SaveToRegistry;
  if UserSettings.SplashExit then
    fmFirstForm.ShowTimer.Interval := 1500
  else
    fmFirstForm.ShowTimer.Interval := 1;
end;

procedure TfmSettings.cbInvertMouseClick(Sender: TObject);
begin
  UserSettings.InvertMouse := cbInvertMouse.Checked;
  UserSettings.SaveToRegistry;
end;

procedure TfmSettings.cbInvertPlanetClick(Sender: TObject);
begin
  UserSettings.InvertPlanet := cbInvertPlanet.Checked;
  UserSettings.SaveToRegistry;
end;

procedure TfmSettings.cbAuto3DViewClick(Sender: TObject);
begin
  UserSettings.Auto3DView := cbAuto3DView.Checked;
  UserSettings.SaveToRegistry;
end;

procedure TfmSettings.cbInvertMouseWheelClick(Sender: TObject);
begin
  UserSettings.InvertMouseWheel := cbInvertMouseWheel.Checked;
  UserSettings.SaveToRegistry;
end;

procedure TfmSettings.cbTipOfTheDayClick(Sender: TObject);
begin
  UserSettings.TipOfTheDay := cbTipOfTheDay.Checked;
  UserSettings.SaveToRegistry;
end;

procedure TfmSettings.cbRememberViewClick(Sender: TObject);
begin
  UserSettings.RememberView := cbRememberView.Checked;
  UserSettings.SaveToRegistry;
end;

procedure TfmSettings.cbAdvancedModeClick(Sender: TObject);
begin
  UserSettings.AdvancedMode := cbAdvancedMode.Checked;
  UserSettings.SaveToRegistry;
  fmFirstForm.RealityForm.RefreshInterface;
end;

end.
