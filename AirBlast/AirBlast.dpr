program AirBlast;

uses
  System.SysUtils,
  VCL.Forms,
  GLS.LinePFX,
  FMain in 'FMain.pas' {Main},
  UAirplane in 'UAirplane.pas',
  UAirBlastEngine in 'UAirBlastEngine.pas',
  UAirBlastControler in 'UAirBlastControler.pas',
  UABControlerUI in 'UABControlerUI.pas',
  FConfigControls in 'FConfigControls.pas' {ConfigControls},
  FEnterKey in 'FEnterKey.pas' {EnterKey},
  FOptionsDlg in 'FOptionsDlg.pas' {OptionsDlg},
  UGameEngine in 'UGameEngine.pas',
  UABUtils in 'UABUtils.pas',
  UABEquipments in 'UABEquipments.pas',
  UABVoice in 'UABVoice.pas',
  DToolBox in 'DToolBox.pas' {DMToolBox: TDataModule},
  UABEvents in 'UABEvents.pas',
  UABConditions in 'UABConditions.pas',
  UABActions in 'UABActions.pas',
  UABMobiles in 'UABMobiles.pas';

{$R *.res}

begin
  Application.Initialize;
  FormatSettings.DecimalSeparator:='.';
  Application.Title := 'AirBlast';
  Application.CreateForm(TDMToolBox, DMToolBox);
  Application.CreateForm(TMain, Main);
  Application.CreateForm(TConfigControls, ConfigControls);
  Application.CreateForm(TEnterKey, EnterKey);
  Application.CreateForm(TOptionsDlg, OptionsDlg);
  Application.Run;
end.
