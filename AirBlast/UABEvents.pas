unit UABEvents;

(* AirBlast game events *)

interface

uses
  System.Classes,
  UAirBlastEngine,
  UGameEngine,
  GLS.PersistentClasses;

type

  // TABGameEvent
  //
  { : Base class for AirBlast game events. }
  TABGameEvent = class(TGameEvent)
  private
    { Private Properties }
  protected
    { Protected Properties }
   public
    { Public Properties }
    function ABEngine: TAirBlastEngine;
  end;

  // TABEventCondition
  //
  TABEventCondition = class(TObject)
  private
    { Private Properties }
    FABEngine: TAirBlastEngine;
  protected
    { Protected Properties }
  public
    { Public Properties }
    constructor Create(engine: TAirBlastEngine; const params: String); virtual;
    function ConditionMet: Boolean; virtual;
    procedure CreateDebugStuff; dynamic;
    property ABEngine: TAirBlastEngine read FABEngine;
  end;

  TABEventConditionClass = class of TABEventCondition;

  // TABEventActions
  //
  { : List of AB actions. }
  TABEventActions = class(TABGameEvent)
  private
    { Private Properties }
    FConditions: TStrings;
    FActions: TStrings;
    FConditionObjs: TGLPersistentObjectList;
  protected
    { Protected Properties }
    procedure PrepareConditionObjs;
  public
    { Public Properties }
    constructor Create;
    destructor Destroy; override;

    function Triggered: Boolean; override;
    procedure Trigger; override;
    procedure CreateDebugStuff;

    procedure SaveToStrings(data: TStrings); override;
    procedure LoadFromStrings(data: TStrings); override;

    property Conditions: TStrings read FConditions write FConditions;
    property Actions: TStrings read FActions write FActions;
  end;

procedure RegisterEventConditionClass(const aName: String;
  const aClass: TABEventConditionClass);
function EventConditionClass(const aName: String): TABEventConditionClass;

// ------------------------------------------------------------------
// ------------------------------------------------------------------
// ------------------------------------------------------------------
implementation

// ------------------------------------------------------------------
// ------------------------------------------------------------------
// ------------------------------------------------------------------

uses
  System.SysUtils,
  UABUtils,
  UABActions;

var
  vRegisteredConditions: TStringList;

  // RegisterEventConditionClass
  //
procedure RegisterEventConditionClass(const aName: String;
  const aClass: TABEventConditionClass);
begin
  if not Assigned(vRegisteredConditions) then
    vRegisteredConditions := TStringList.Create;
  vRegisteredConditions.AddObject(aName, TObject(aClass));
end;

// EventConditionClass
//
function EventConditionClass(const aName: String): TABEventConditionClass;
var
  i: Integer;
begin
  Result := nil;
  if Assigned(vRegisteredConditions) then
  begin
    i := vRegisteredConditions.IndexOf(aName);
    if i >= 0 then
      Result := TABEventConditionClass(vRegisteredConditions.Objects[i]);
  end;
end;

// ------------------
// ------------------ TABGameEvent ------------------
// ------------------

// ABEngine
//
function TABGameEvent.ABEngine: TAirBlastEngine;
begin
  Result := (GameEngine as TAirBlastEngine);
end;

// ------------------
// ------------------ TABEventActions ------------------
// ------------------

// Create
//
constructor TABEventActions.Create;
begin
  inherited;
  FActions := TStringList.Create;
  FConditions := TStringList.Create;
end;

// Destroy
//
destructor TABEventActions.Destroy;
begin
  inherited;
  FActions.Free;
  FConditions.Free;
  FConditionObjs.CleanFree;
end;

// Triggered
//
function TABEventActions.Triggered: Boolean;
var
  i: Integer;
  cond: TABEventCondition;
begin
  Result := inherited Triggered;
  if Result then
  begin
    if not Assigned(FConditionObjs) then
      PrepareConditionObjs;
    for i := 0 to FConditionObjs.Count - 1 do
    begin
      cond := TABEventCondition(FConditionObjs[i]);
      if not cond.ConditionMet then
      begin
        Result := False;
        Break;
      end;
    end;
  end;
end;

// Trigger
//
procedure TABEventActions.Trigger;
var
  envVars: TStringList;
begin
  envVars := TStringList.Create;
  PerformABActions(ABEngine, Actions, envVars);
  Completed := (envVars.Values['Completed'] = 'Y');
  envVars.Free;
end;

// CreateDebugStuff
//
procedure TABEventActions.CreateDebugStuff;
var
  i: Integer;
begin
  for i := 0 to FConditionObjs.Count - 1 do
    TABEventCondition(FConditionObjs[i]).CreateDebugStuff;
end;

// SaveToStrings
//
procedure TABEventActions.SaveToStrings(data: TStrings);
begin
  inherited;
  data.Values['Conditions'] := Conditions.CommaText;
  data.Values['Actions'] := Actions.CommaText;
end;

// LoadFromStrings
//
procedure TABEventActions.LoadFromStrings(data: TStrings);
begin
  inherited;
  Conditions.CommaText := data.Values['Conditions'];
  Actions.CommaText := data.Values['Actions'];
  PrepareConditionObjs;
end;

// PrepareConditionObjs
//
procedure TABEventActions.PrepareConditionObjs;
var
  i, p, p2: Integer;
  cmd, params: String;
  condClass: TABEventConditionClass;
  condObj: TABEventCondition;
begin
  FConditionObjs.CleanFree;
  FConditionObjs := TGLPersistentObjectList.Create;
  for i := 0 to FConditions.Count - 1 do
  begin
    cmd := FConditions[i];
    p := Pos(' ', cmd);
    p2 := Pos(',', cmd);
    if (p2 > 0) then
      if (p2 < p) or (p < 1) then
        p := p2;
    if p > 0 then
    begin
      params := Copy(cmd, p + 1, MaxInt);
      SetLength(cmd, p - 1);
    end
    else
      params := '';
    if Trim(cmd) = '' then
      continue;
    condClass := EventConditionClass(cmd);
    if condClass <> nil then
    begin
      condObj := condClass.Create(ABEngine, params);
      FConditionObjs.Add(condObj);
    end
    else
      Assert(False, 'Unknown condition ' + FConditions[i]);
  end;
end;

// ------------------
// ------------------ TABEventCondition ------------------
// ------------------

// Create
//
constructor TABEventCondition.Create(engine: TAirBlastEngine;
  const params: String);
begin
  inherited Create;
  FABEngine := engine;
end;

// ConditionMet
//
function TABEventCondition.ConditionMet: Boolean;
begin
  Result := True;
end;

// CreateDebugStuff
//
procedure TABEventCondition.CreateDebugStuff;
begin
  // nothing here
end;

// ------------------------------------------------------------------
// ------------------------------------------------------------------
// ------------------------------------------------------------------
initialization

// ------------------------------------------------------------------
// ------------------------------------------------------------------
// ------------------------------------------------------------------

RegisterGameEventClass(TABEventActions);

end.
