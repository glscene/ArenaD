unit UABControlerUI;

(* UI controler(s) (keyboard, joystick, etc.) *)

interface

uses
  System.Types,
  System.Classes,
  System.Math,
  Winapi.Windows,
  Winapi.MMSystem,
  UAirBlastControler,
  GLS.VectorGeometry,
  UGameEngine;

type

  TVirtualKeyCode = Integer;

  // TABUIControl
  //
  TABUIControl = (uicLeft, uicRight, uicUp, uicDown, uicFirePrimary,
    uicFireAlternate, uicWeaponNext, uicWeaponPrevious, uicTargetNext,
    uicTargetPrevious, uicTargetNearestEnemy, uicTargetAimed, uicDropDecoy,
    uicFireControl, uicAirBrake, uicWingmanFollowMe, uicWingmanEngageTarget,
    uicWingmanCoverMe, uicThrottle10, uicThrottle20, uicThrottle30,
    uicThrottle40, uicThrottle50, uicThrottle60, uicThrottle70, uicThrottle80,
    uicThrottle90, uicThrottle100, uicThrottleIncrease, uicThrottleDecrease,
    uicThrottleAfterBurner, uicCycleCamera);
  TABUIControls = array [TABUIControl] of TVirtualKeyCode;
  TABUIDualControls = array [0 .. 1] of TABUIControls;
  TJoystickPresence = array [1 .. 2] of Boolean;
  TJoystickCaps = array [1 .. 2] of TJoyCaps;

const
  cDefaultUIControls: TABUIControls = (VK_LEFT, VK_RIGHT, VK_UP, VK_DOWN,
    VK_SPACE, VK_RETURN, VK_NEXT, VK_PRIOR, Ord('U'), Ord('Y'), Ord('R'),
    Ord('T'), Ord('D'), Ord('F'), Ord('B'), Ord('V'), Ord('X'), Ord('C'),
    Ord('1'), Ord('2'), Ord('3'), Ord('4'), Ord('5'), Ord('6'), Ord('7'),
    Ord('8'), Ord('9'), Ord('0'), VK_ADD, VK_SUBTRACT, VK_TAB, VK_F1);
  cUIControlNames: array [TABUIControl] of String = ('Left', 'Right', 'Up',
    'Down', 'Fire Primary', 'Fire Alternate', 'Weapon Next', 'Weapon Previous',
    'Target Next', 'Target Previous', 'Target Nearest Enemy', 'Target Aimed',
    'Drop Decoy', 'Fire Control', 'AirBrake', 'Wingman Follow Me',
    'Wingman Engage Target', 'Wingman Cover Me', 'Throttle 10%', 'Throttle 20%',
    'Throttle 30%', 'Throttle 40%', 'Throttle 50%', 'Throttle 60%',
    'Throttle 70%', 'Throttle 80%', 'Throttle 90%', 'Throttle 100%',
    'Throttle Increase', 'Throttle Decrease', 'Throttle AfterBurner',
    'Cycle Camera');

type
  // TABControlerUI
  //
  { : Controler that reacts to UI (keyboard, joystick...).<p> }
  TABControlerUI = class(TABControler)
  private
    { Private Properties }
    FControlsLastState, FControlsState: array [TABUIControl] of Boolean;
    FControls: TABUIDualControls;
    FThrottle: Single;
    FJoystickPresent: TJoystickPresence;
    FJoystickCaps: TJoystickCaps;
    FUseJoystick: Integer;
    FJoystickDeadZone: Single;
    FUseMouse: Boolean;
    FActive: Boolean;

  protected
    { Protected Properties }
    procedure SetMobile(aMobile: TMobile); override;

    procedure UpdateControlsState;
    function IsActive(aControl: TABUIControl): Boolean;
    function WasActivated(aControl: TABUIControl): Boolean;

  public
    { Public Properties }
    constructor Create;

    procedure Progress(const deltaTime: Double); override;

    procedure ApplyGameEngineOptions;
    procedure SaveToStrings(data: TStrings); override;
    procedure LoadFromStrings(data: TStrings); override;

    property Active: Boolean read FActive write FActive;
    property Controls: TABUIDualControls read FControls write FControls;

    property CurrentThrottle: Single read FThrottle write FThrottle;

    property JoystickPresent: TJoystickPresence read FJoystickPresent;
    // 0 = no joystick
    property UseJoystick: Integer read FUseJoystick write FUseJoystick;
    // dead zone in [0..1] range
    property JoystickDeadZone: Single read FJoystickDeadZone
      write FJoystickDeadZone;

    property UseMouse: Boolean read FUseMouse write FUseMouse;
  end;

procedure SaveControls(const Controls: TABUIDualControls; data: TStrings);
procedure LoadControls(var Controls: TABUIDualControls; data: TStrings);

// ------------------------------------------------------------------
// ------------------------------------------------------------------
// ------------------------------------------------------------------
implementation

// ------------------------------------------------------------------
// ------------------------------------------------------------------
// ------------------------------------------------------------------

uses
  System.SysUtils,
  System.DateUtils,
  UAirBlastEngine,
  GLS.Keyboard;

// SaveControls
//
procedure SaveControls(const Controls: TABUIDualControls; data: TStrings);
var
  i: TABUIControl;
begin
  for i := Low(TABUIControl) to High(TABUIControl) do
    data.Values[cUIControlNames[i]] := IntToStr(Controls[0][i]) + ',' +
      IntToStr(Controls[1][i]);
end;

// LoadControls
//
procedure LoadControls(var Controls: TABUIDualControls; data: TStrings);
var
  i: TABUIControl;
  p: Integer;
  buf: String;
begin
  for i := Low(TABUIControl) to High(TABUIControl) do
  begin
    buf := data.Values[cUIControlNames[i]];
    p := Pos(',', buf);
    Controls[0][i] := StrToIntDef(Copy(buf, 1, p - 1), 0);
    Controls[1][i] := StrToIntDef(Copy(buf, p + 1, MaxInt), 0);
  end;
end;

// ------------------
// ------------------ TABControlerUI ------------------
// ------------------

// Create
//
constructor TABControlerUI.Create;
var
  joyInfoEx: TJoyInfoEx;
  i: Integer;
begin
  inherited;
  FActive := True;

  FControls[0] := cDefaultUIControls;

  FJoystickDeadZone := 0.1;
  FUseJoystick := 1;

  // Detect Joystick
  ZeroMemory(@joyInfoEx, SizeOf(joyInfoEx));
  joyInfoEx.dwSize := SizeOf(joyInfoEx);
  for i := 1 to 2 do
  begin
    FJoystickPresent[i] := (joyGetPosEx(JOYSTICKID1, @joyInfoEx)
      = JOYERR_NOERROR);
    if FJoystickPresent[i] then
      joyGetDevCaps(JOYSTICKID1 + (i - 1), @FJoystickCaps[i], SizeOf(TJoyCaps));
  end;
end;

// Progress
//
procedure TABControlerUI.Progress(const deltaTime: Double);
var
  ctrl: TABUIControl;
  roll, pitch, yaw: Single;
  joyInfoEx: TJoyInfoEx;
  joyCaps: TJoyCaps;
  mp, screenSize: TPoint;
  viewerCam: TABViewerCam;
begin
  inherited;
  UpdateControlsState;
  if not Active then
    Exit;

  roll := 0;
  if IsActive(uicLeft) then
    roll := 1;
  if IsActive(uicRight) then
    roll := -1;

  pitch := 0;
  if IsActive(uicUp) then
    pitch := -1;
  if IsActive(uicDown) then
    pitch := 1;

  yaw := 0;

  for ctrl := uicThrottle10 to uicThrottle100 do
    if IsActive(ctrl) then
      FThrottle := (Integer(ctrl) - Integer(uicThrottle10) + 1) * 0.1;
  if WasActivated(uicThrottleIncrease) then
    FThrottle := ClampValue(FThrottle + 0.1, 0, 1);
  if WasActivated(uicThrottleDecrease) then
    FThrottle := ClampValue(FThrottle + 0.1, 0, 1);

  if (UseJoystick > 0) and JoystickPresent[UseJoystick] then
  begin
    joyCaps := FJoystickCaps[UseJoystick];
    ZeroMemory(@joyInfoEx, SizeOf(joyInfoEx));
    joyInfoEx.dwSize := SizeOf(joyInfoEx);
    joyInfoEx.dwFlags := JOY_RETURNALL;
    joyGetPosEx(JOYSTICKID1, @joyInfoEx);
    roll := -2 * ((joyInfoEx.wXpos - joyCaps.wXmin) /
      (joyCaps.wXmax + 1) - 0.5);
    if Abs(roll) < JoystickDeadZone then
      roll := 0;
    pitch := 2 * ((joyInfoEx.wYpos - joyCaps.wYmin) /
      (joyCaps.wYmax + 1) - 0.5);
    if Abs(pitch) < JoystickDeadZone then
      pitch := 0;
    // Throttle control
    if (joyCaps.wCaps and JOYCAPS_HASZ) <> 0 then
      FThrottle := 1 - (joyInfoEx.wZpos - joyCaps.wZmin) / (joyCaps.wZmax + 1);
    // Roll/Yaw control
    if (joyCaps.wCaps and JOYCAPS_HASR) <> 0 then
    begin
      yaw := 2 * ((joyInfoEx.dwRpos - joyCaps.wRmin) /
        (joyCaps.wRmax + 1) - 0.5);
      if Abs(yaw) < JoystickDeadZone then
        yaw := 0;
    end;
    // POV hat control
    if (joyCaps.wCaps and JOYCAPS_HASPOV) <> 0 then
    begin
      viewerCam := Airplane.ABEngine.ViewerCamForMobile(Airplane.Name);
      if viewerCam <> nil then
      begin
        viewerCam.POVActive := (joyInfoEx.dwPOV <> 65535);
        viewerCam.POV := joyInfoEx.dwPOV * 0.01;
      end;
    end;

    FControlsState[uicFirePrimary] := FControlsState[uicFirePrimary] or
      ((joyInfoEx.wButtons and JOY_BUTTON1) <> 0);
    FControlsState[uicFireAlternate] := FControlsState[uicFireAlternate] or
      ((joyInfoEx.wButtons and JOY_BUTTON2) <> 0);
    FControlsState[uicThrottleAfterBurner] := FControlsState
      [uicThrottleAfterBurner] or ((joyInfoEx.wButtons and JOY_BUTTON3) <> 0);
    FControlsState[uicTargetAimed] := FControlsState[uicTargetAimed] or
      ((joyInfoEx.wButtons and JOY_BUTTON4) <> 0);
  end;
  if UseMouse then
  begin
    GetCursorPos(mp);
    screenSize.X := GetSystemMetrics(SM_CXSCREEN) div 2;
    screenSize.Y := GetSystemMetrics(SM_CYSCREEN) div 2;

    roll := -(mp.X - screenSize.X) / screenSize.X;
    roll := Sign(roll) * ClampValue(1.5 * Abs(roll) - 0.1, 0, 1);
    yaw := -roll;

    pitch := -(mp.Y - screenSize.Y) / screenSize.Y;
    pitch := Sign(pitch) * ClampValue(1.5 * Abs(pitch) - 0.1, 0, 1);
  end;

  yaw := ClampValue(yaw - roll * 0.5, -1, 1);

  Steer(roll, pitch, yaw);

  if IsActive(uicThrottleAfterBurner) then
    Throttle(3)
  else
    Throttle(FThrottle);

  if Copy(Airplane.CurrentWeaponGroup, 1, 1) = '!' then
  begin
    // weapon groups with '!' have continuous fire
    if IsActive(uicFirePrimary) then
      Fire(True);
    if IsActive(uicFireAlternate) then
      Fire(False);
  end
  else
  begin
    if WasActivated(uicFirePrimary) then
      Fire(True);
    if WasActivated(uicFireAlternate) then
      Fire(False);
  end;

  if WasActivated(uicWeaponNext) then
    CycleWeapons(True);
  if WasActivated(uicWeaponPrevious) then
    CycleWeapons(False);

  if WasActivated(uicTargetNext) then
    CycleTargets(True);
  if WasActivated(uicTargetPrevious) then
    CycleTargets(False);
  if WasActivated(uicTargetNearestEnemy) then
    TargetNearestEnemy;
  if WasActivated(uicTargetAimed) then
    TargetAimed;

  if WasActivated(uicDropDecoy) then
    DropDecoy;
  if WasActivated(uicFireControl) then
    FireControl;

  if IsActive(uicAirBrake) then
    AirBrake;

  if WasActivated(uicWingmanFollowMe) then
    WingLeaderOrder(wloFollowMe);
  if WasActivated(uicWingmanEngageTarget) then
    WingLeaderOrder(wloEngageMyTarget);
  if WasActivated(uicWingmanCoverMe) then
    WingLeaderOrder(wloCoverMe);

  if WasActivated(uicCycleCamera) then
    Airplane.ABEngine.CycleCameraForMobile(Mobile.Name);
end;

// ApplyGameEngineOptions
//
procedure TABControlerUI.ApplyGameEngineOptions;
begin
  with Airplane.ABEngine do
  begin
    Self.LoadFromFile(Options.Values['KeyboardLayout'] + '.keys');
    if Options.Values['Joystick'] = 'Y' then
      Self.UseJoystick := 1
    else
      Self.UseJoystick := 0;
    Self.JoystickDeadZone := StrToIntDef(Options.Values['JoystickDeadZone'],
      10) * 0.01;
  end;
end;

// SaveToStrings
//
procedure TABControlerUI.SaveToStrings(data: TStrings);
begin
  inherited;
  SaveControls(FControls, data);
end;

// LoadFromStrings
//
procedure TABControlerUI.LoadFromStrings(data: TStrings);
begin
  inherited;
  LoadControls(FControls, data);
end;

// UpdateControlsState
//
procedure TABControlerUI.UpdateControlsState;
var
  ctrl: TABUIControl;
  i, i2: Integer;
  buf: TKeyboardState;
begin
  GetKeyboardState(buf);
  if vLastWheelDelta > 0 then
    buf[VK_F23] := $FF;
  if vLastWheelDelta < 0 then
    buf[VK_F24] := $FF;
  vLastWheelDelta := 0;
  for ctrl := Low(TABUIControl) to High(TABUIControl) do
  begin
    FControlsLastState[ctrl] := FControlsState[ctrl];
    i := (FControls[0][ctrl] and $FF);
    i2 := (FControls[1][ctrl] and $FF);
    FControlsState[ctrl] := ((buf[i] and $80) <> 0) or ((buf[i2] and $80) <> 0);
  end;
end;

// SetMobile
//
procedure TABControlerUI.SetMobile(aMobile: TMobile);
begin
  inherited;
  if aMobile is TABAirplane then
    FThrottle := TABAirplane(aMobile).Throttle;
end;

// IsActive
//
function TABControlerUI.IsActive(aControl: TABUIControl): Boolean;
begin
  Result := FControlsState[aControl];
end;

// WasActivated
//
function TABControlerUI.WasActivated(aControl: TABUIControl): Boolean;
begin
  Result := FControlsState[aControl] and (not FControlsLastState[aControl]);
end;

end.
