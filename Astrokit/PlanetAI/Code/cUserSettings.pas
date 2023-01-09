{
  ai.planet
  http://aiplanet.sourceforge.net
  Created by Dave Kerr (kerrd@hotmail.com)
  $Id: cUserSettings.pas,v 1.12 2003/10/01 00:54:52 aidave Exp $
}
unit cUserSettings;

interface

const
  cRegistryKey = 'Software\aiplanet';

type

// *****************************************************************************
TUserSettings = class(TObject)
private
  fLoadOnStartup: boolean;
  fAutoSave: boolean;
  fWorkingFile: string;
  fSplashStart: boolean;
  fSplashExit: boolean;
  fInvertMouse: boolean;
  fInvertPlanet: boolean;
  fAuto3DView: boolean;
  fInvertMouseWheel: boolean;
  fTipOfTheDay: boolean;
  fRememberView: boolean;
  fViewAligned: boolean;
  fViewSizeX: integer;
  fViewSizeY: integer;
  fAdvancedMode: boolean;
public
  property LoadOnStartup: boolean read fLoadOnStartup write fLoadOnStartup;
  property AutoSave: boolean read fAutoSave write fAutoSave;
  property WorkingFile: string read fWorkingFile write fWorkingFile;
  property SplashStart: boolean read fSplashStart write fSplashStart;
  property SplashExit: boolean read fSplashExit write fSplashExit;
  property InvertMouse: boolean read fInvertMouse write fInvertMouse;
  property InvertPlanet: boolean read fInvertPlanet write fInvertPlanet;
  property Auto3DView: boolean read fAuto3DView write fAuto3DView;
  property InvertMouseWheel: boolean read fInvertMouseWheel write fInvertMouseWheel;
  property TipOfTheDay: boolean read fTipOfTheDay write fTipOfTheDay;
  property RememberView: boolean read fRememberView write fRememberView;
  property AdvancedMode: boolean read fAdvancedMode write fAdvancedMode;

  property ViewAligned: boolean read fViewAligned write fViewAligned;
  property ViewSizeX: integer read fViewSizeX write fViewSizeX;
  property ViewSizeY: integer read fViewSizeY write fViewSizeY;

  procedure LoadFromRegistry;
  procedure SaveToRegistry;

  function OneLineDisplay: string;
end;

implementation

uses Registry, cGlobals, cUtilities, SysUtils;

// -----------------------------------------------------------------------------
procedure TUserSettings.LoadFromRegistry;
var
  myRegistry: TRegistry;
begin
  myRegistry := TRegistry.Create;
  myRegistry.CreateKey(cRegistryKey);
  myRegistry.OpenKey(cRegistryKey, false);

  if myRegistry.ValueExists('LoadOnStartup') then
    fLoadOnStartup := myRegistry.ReadBool('LoadOnStartup')
  else
    fLoadOnStartup := false;

  if myRegistry.ValueExists('AutoSave') then
    fAutoSave := myRegistry.ReadBool('AutoSave')
  else
    fAutoSave := false;

  if myRegistry.ValueExists('WorkingFile') then
    fWorkingFile := myRegistry.ReadString('WorkingFile')
  else
    fWorkingFile := 'current.air';

  if myRegistry.ValueExists('SplashStart') then
    fSplashStart := myRegistry.ReadBool('SplashStart')
  else
    fSplashStart := true;

  if myRegistry.ValueExists('SplashExit') then
    fSplashExit := myRegistry.ReadBool('SplashExit')
  else
    fSplashExit := true;

  if myRegistry.ValueExists('InvertMouse') then
    fInvertMouse := myRegistry.ReadBool('InvertMouse')
  else
    fInvertMouse := false;

  if myRegistry.ValueExists('InvertPlanet') then
    fInvertPlanet := myRegistry.ReadBool('InvertPlanet')
  else
    fInvertPlanet := false;

  if myRegistry.ValueExists('Auto3DView') then
    fAuto3DView := myRegistry.ReadBool('Auto3DView')
  else
    fAuto3DView := false;

  if myRegistry.ValueExists('InvertMouseWheel') then
    fInvertMouseWheel := myRegistry.ReadBool('InvertMouseWheel')
  else
    fInvertMouseWheel := false;

  if myRegistry.ValueExists('TipOfTheDay') then
    fTipOfTheDay := myRegistry.ReadBool('TipOfTheDay')
  else
    fTipOfTheDay := false;

  if myRegistry.ValueExists('ViewAligned') then
    ViewAligned := myRegistry.ReadBool('ViewAligned')
  else
    ViewAligned := true;

  if myRegistry.ValueExists('ViewSizeX') then
    ViewSizeX := myRegistry.ReadInteger('ViewSizeX')
  else
    ViewSizeX := 640;

  if myRegistry.ValueExists('ViewSizeY') then
    ViewSizeY := myRegistry.ReadInteger('ViewSizeY')
  else
    ViewSizeY := 480;

  if myRegistry.ValueExists('RememberView') then
    RememberView := myRegistry.ReadBool('RememberView')
  else
  begin
    RememberView := true;
    ViewAligned := true;
  end;

  if myRegistry.ValueExists('AdvancedMode') then
    AdvancedMode := myRegistry.ReadBool('AdvancedMode')
  else
    AdvancedMode := false;

  if myRegistry.ValueExists('Version') then
  if myRegistry.ReadInteger('Version') <> gVersion then
  begin
    fSplashStart := true;
    fSplashExit := true;
    fLoadOnStartup := false;
    fAutoSave := false;
    fTipOfTheDay := false;
  end;

  myRegistry.Free;
end;

// -----------------------------------------------------------------------------
procedure TUserSettings.SaveToRegistry;
var
  myRegistry: TRegistry;
begin
  myRegistry := TRegistry.Create;
  myRegistry.CreateKey(cRegistryKey);
  myRegistry.OpenKey(cRegistryKey, false);

  myRegistry.WriteBool('LoadOnStartup', fLoadOnStartup);
  myRegistry.WriteBool('AutoSave', fAutoSave);
  myRegistry.WriteString('WorkingFile', fWorkingFile);
  myRegistry.WriteBool('SplashStart', fSplashStart);
  myRegistry.WriteBool('SplashExit', fSplashExit);
  myRegistry.WriteBool('InvertMouse', fInvertMouse);
  myRegistry.WriteBool('InvertPlanet', fInvertPlanet);
  myRegistry.WriteInteger('Version', gVersion);
  myRegistry.WriteBool('Auto3DView', fAuto3DView);
  myRegistry.WriteBool('InvertMouseWheel', fInvertMouseWheel);
  myRegistry.WriteBool('TipOfTheDay', fTipOfTheDay);
  myRegistry.WriteBool('RememberView', fRememberView);
  myRegistry.WriteBool('ViewAligned', fViewAligned);
  myRegistry.WriteInteger('ViewSizeX', fViewSizeX);
  myRegistry.WriteInteger('ViewSizeY', fViewSizeY);
  myRegistry.WriteBool('AdvancedMode', fAdvancedMode);

  myRegistry.Free;
end;

// -----------------------------------------------------------------------------
function TUserSettings.OneLineDisplay: string;
begin
  result := '';
  result := result + '-LoadOnStartup=' + BoolToYesNoStr(fLoadOnStartup);
  result := result + '-AutoSave=' + BoolToYesNoStr(fAutoSave);
  result := result + '-SplashStart=' + BoolToYesNoStr(fSplashStart);
  result := result + '-SplashExit=' + BoolToYesNoStr(fSplashExit);
  result := result + '-InvertMouse=' + BoolToYesNoStr(fInvertMouse);
  result := result + '-InvertPlanet=' + BoolToYesNoStr(fInvertPlanet);
  result := result + '-Version=' + IntToStr(gVersion);
  result := result + '-WorkingFile=' + fWorkingFile;
  result := result + '-InvertMouseWheel=' + BoolToYesNoStr(fInvertMouseWheel);
  result := result + '-Auto3DView=' + BoolToYesNoStr(fAuto3DView);
  result := result + '-TipOfTheDay=' + BoolToYesNoStr(fTipOfTheDay);
  result := result + '-RememberView=' + BoolToYesNoStr(fRememberView);
  result := result + '-ViewAligned=' + BoolToYesNoStr(fViewAligned);
  result := result + '-ViewSizeX=' + IntToStr(fViewSizeX);
  result := result + '-ViewSizeY=' + IntToStr(fViewSizeY);
  result := result + '-AdvancedMode=' + BoolToYesNoStr(fAdvancedMode);
end;

end.
