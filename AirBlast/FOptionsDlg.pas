unit FOptionsDlg;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.UITypes,
  System.SysUtils,
  System.Classes,
  VCL.Graphics,
  VCL.Controls,
  VCL.Forms,
  VCL.Dialogs,
  VCL.ComCtrls,
  VCL.ToolWin,
  VCL.StdCtrls,
  VCL.ExtCtrls;


type
  TOptionsDlg = class(TForm)
    ToolBar1: TToolBar;
    TBApply: TToolButton;
    TBSpacer: TToolButton;
    TBCancel: TToolButton;
    Shape1: TShape;
    Panel1: TPanel;
    PageControl: TPageControl;
    TSGameplay: TTabSheet;
    Label11: TLabel;
    Label12: TLabel;
    CBDifficulty: TComboBox;
    CBSpeed: TComboBox;
    TSVideo: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    CBVideoMode: TComboBox;
    CBFSAA: TComboBox;
    CBTerrain: TComboBox;
    CBParticles: TComboBox;
    TSAudio: TTabSheet;
    Label6: TLabel;
    Label9: TLabel;
    Label7: TLabel;
    TBMasterVolume: TTrackBar;
    TBEngineVolume: TTrackBar;
    TBVoiceVolume: TTrackBar;
    TSControls: TTabSheet;
    Label8: TLabel;
    Label10: TLabel;
    CBJoystick: TCheckBox;
    TBJoystickDeadzone: TTrackBar;
    BUConfigureKeyboard: TButton;
    CBKeyboardLayout: TComboBox;
    CBVSync: TCheckBox;
    TBMusicVolume: TTrackBar;
    Label13: TLabel;
    procedure BUConfigureKeyboardClick(Sender: TObject);
    procedure CBDifficultyChange(Sender: TObject);
    procedure CBVideoModeChange(Sender: TObject);
    procedure TBApplyClick(Sender: TObject);
    procedure TBCancelClick(Sender: TObject);
  private
    { Private declarations }
    FRestartRequired : Boolean;
    FChanged : Boolean;
    procedure LoadOptions(data : TStrings);
    procedure StoreOptions(data : TStrings);
    procedure EnumerateKeyConfigs(dest : TStrings);
  public
    { Public declarations }
    function Execute(const optionsFile : String) : Boolean;
  end;

var
  OptionsDlg: TOptionsDlg;

implementation

uses
    FConfigControls;

{$R *.dfm}

// ------------------
// ------------------ TOptionsDlg ------------------
// ------------------

// Execute
//
function TOptionsDlg.Execute(const optionsFile : String) : Boolean;
var
   sl : TStringList;
begin
   sl:=TStringList.Create;
   if FileExists(optionsFile) then
      sl.LoadFromFile(optionsFile);
   LoadOptions(sl);
   
   FChanged:=False;
   FRestartRequired:=False;
   PageControl.ActivePageIndex:=0;

   Result:=(ShowModal=mrOk);
   if Result then begin
      StoreOptions(sl);
      sl.SaveToFile(optionsFile);
   end;
   sl.Free;
end;

// LoadOptions
//
procedure TOptionsDlg.LoadOptions(data : TStrings);
begin
   // Gameplay
   CBDifficulty.ItemIndex:=StrToIntDef(data.Values['Difficulty'], 2);
   CBSpeed.ItemIndex:=StrToIntDef(data.Values['Speed'], 2);
   // Video
   CBVideoMode.ItemIndex:=CBVideoMode.Items.IndexOf(data.Values['VideoMode']);
   if CBVideoMode.ItemIndex=-1 then CBVideoMode.ItemIndex:=0;
   CBVSync.Checked:=(data.Values['VSync']='Y');
   CBFSAA.ItemIndex:=StrToIntDef(data.Values['FSAA'], 0);
   CBTerrain.ItemIndex:=StrToIntDef(data.Values['TerrainQuality'], 1);
   CBParticles.ItemIndex:=StrToIntDef(data.Values['Particles'], 1);
   // Audio
   TBMasterVolume.Position:=StrToIntDef(data.Values['MasterVolume'], 100);
   TBEngineVolume.Position:=StrToIntDef(data.Values['EnginesVolume'], 100);
   TBMusicVolume.Position:=StrToIntDef(data.Values['MusicVolume'], 100);
   TBVoiceVolume.Position:=StrToIntDef(data.Values['VoiceVolume'], 100);
   // Controls
   EnumerateKeyConfigs(CBKeyboardLayout.Items);
   CBKeyboardLayout.Text:=data.Values['KeyboardLayout'];
   CBJoystick.Checked:=(data.Values['Joystick']='Y');
   TBJoystickDeadzone.Position:=StrToIntDef(data.Values['JoystickDeadZone'], 10);
end;

// StoreOptions
//
procedure TOptionsDlg.StoreOptions(data : TStrings);
begin
   // Gameplay
   data.Values['Difficulty']:=IntToStr(CBDifficulty.ItemIndex);
   data.Values['Speed']:=IntToStr(CBSpeed.ItemIndex);
   // Video
   data.Values['VideoMode']:=CBVideoMode.Text;
   if CBVSync.Checked then
      data.Values['VSync']:='Y'
   else data.Values['VSync']:='N';
   data.Values['FSAA']:=IntToStr(CBFSAA.ItemIndex);
   data.Values['TerrainQuality']:=IntToStr(CBTerrain.ItemIndex);
   data.Values['Particles']:=IntToStr(CBParticles.ItemIndex);
   // Audio
   data.Values['MasterVolume']:=IntToStr(TBMasterVolume.Position);
   data.Values['EnginesVolume']:=IntToStr(TBEngineVolume.Position);
   data.Values['MusicVolume']:=IntToStr(TBMusicVolume.Position);
   data.Values['VoiceVolume']:=IntToStr(TBVoiceVolume.Position);
   // Controls
   data.Values['KeyboardLayout']:=CBKeyboardLayout.Text;
   if CBJoystick.Checked then
      data.Values['Joystick']:='Y'
   else data.Values['Joystick']:='N';
   data.Values['JoystickDeadZone']:=IntToStr(TBJoystickDeadzone.Position);
end;

// EnumerateKeyConfigs
//
procedure TOptionsDlg.EnumerateKeyConfigs(dest : TStrings);
var
   sr : TSearchRec;
begin
   dest.Clear;
   {$WARNINGS OFF}
   if FindFirst('*.keys', faArchive, sr)=0 then begin
   {$WARNINGS ON}
      repeat
         dest.Add(ChangeFileExt(ExtractFileName(sr.Name), ''));
      until FindNext(sr)<>0;
      FindClose(sr);
   end;
end;

procedure TOptionsDlg.BUConfigureKeyboardClick(Sender: TObject);
var
   fSelected, fCustom : String;
begin
   fCustom:=ExtractFilePath(Application.ExeName)+'Custom.keys';
   fSelected:=ExtractFilePath(Application.ExeName)+CBKeyboardLayout.Text+'.keys';
   if fCustom<>fSelected then
      CopyFile(PChar(fSelected), PChar(fCustom), False);
   if ConfigControls.Execute('', fCustom) then begin
      CBKeyboardLayout.Text:='Custom';
      FChanged:=True;
   end;
end;

procedure TOptionsDlg.CBDifficultyChange(Sender: TObject);
begin
   FChanged:=True;
end;

procedure TOptionsDlg.CBVideoModeChange(Sender: TObject);
begin
   FChanged:=True;
   FRestartRequired:=True;
end;

procedure TOptionsDlg.TBApplyClick(Sender: TObject);
begin
   if FRestartRequired then
      ShowMessage( 'Some of you changes will only be applied'#13#10
                  +'after restarting the game.');
   ModalResult:=mrOk;
end;

procedure TOptionsDlg.TBCancelClick(Sender: TObject);
begin
   if FChanged then
      if MessageDlg('Abandon changes?', mtConfirmation, [mbYes, mbNo], 0)<>mrYes then
         Exit;
   ModalResult:=mrCancel;
end;

end.
