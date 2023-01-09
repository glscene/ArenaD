unit cAILife;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Contnrs,
  System.Types,
  cAIThings,
  cAIThingReferenceList;

type

  AILivingThing = class(AIThing)
  private
    fWater: single;
    fRot: integer;
    fHealth: integer;
    fAlive: boolean;
    procedure SetAlive(aValue: boolean);
    procedure SetHealth(aValue: integer);
  public
    constructor Create(aParent: pointer);
    property Water: single read fWater write fWater;
    property Health: integer read fHealth write SetHealth;
    property Rot: integer read fRot write fRot;
    property Alive: boolean read fAlive write SetAlive;
    // Modify
    procedure HealthIncrease(aAmount: integer);
    function Dead: boolean;
    function Rotten: boolean;
    function Digest(const aAmount: integer): integer; override;
    procedure Fuel; override;
    procedure Die; virtual;
    procedure Cease; override;
    procedure Decompose;
    procedure Damage(aAmount: integer); override;
    function OneLineDisplay: string; override;
    procedure FullDisplay(aList: TStrings); override;
    procedure SaveToFile(var aFile: TextFile); override;
    procedure LoadFromFile(var aFile: TextFile); override;
  end;

  // ============================================================================
  AILivingGroup = class(AIThing)
  private
    fMembers: AIThingReferenceList;
    fMaximum: integer;
    fFull: boolean;
  protected
    procedure CalculateFull;
  public
    constructor Create(aParent: pointer);
    destructor Destroy; override;
    property Members: AIThingReferenceList read fMembers;
    property Maximum: integer read fMaximum write fMaximum;
    property Full: boolean read fFull;
    function AddMember(aMember: AIThing): boolean; virtual;
    procedure RemoveMember(aMember: AIThing);
    function Vacancy: boolean;
    procedure Fuel; override;
    function OneLineDisplay: string; override;
    procedure FullDisplay(aList: TStrings); override;
    procedure SaveToFile(var aFile: TextFile); override;
    procedure LoadFromFile(var aFile: TextFile); override;
  end;

  // ============================================================================
implementation

uses
  cUtilities;

// ----------------------------------------------------------------------------
Constructor AILivingThing.Create(aParent: pointer);
begin
  inherited Create(aParent);

  fHealth := 1024;
  fRot := 0;
  fAlive := true;
end;

// ----------------------------------------------------------------------------
procedure AILivingThing.Die;
begin
  fAlive := false;
  fHealth := 0;
  fRot := 1;
end;

// ----------------------------------------------------------------------------
procedure AILivingThing.Fuel;
begin
  inherited Fuel;

  // decrease health every round
  if fHealth > 0 then
  begin
    fHealth := fHealth - 1;
    // if fHealth > 10000 then
    // fHealth := 10000;
  end
  else
  // if health is < 0 then begin rotting
  begin
    if Alive then
      Die;
    Decompose;
  end;
end;

// ----------------------------------------------------------------------------
function AILivingThing.Dead: boolean;
begin
  result := not(Alive);
end;

// ----------------------------------------------------------------------------
function AILivingThing.Rotten: boolean;
begin
  result := (Rot >= 512);
end;

// ----------------------------------------------------------------------------
procedure AILivingThing.Decompose;
begin
  fRot := fRot + 1;
  if Rotten then
    Cease;
end;

// ----------------------------------------------------------------------------
procedure AILivingThing.Damage(aAmount: integer);
begin
  inherited Damage(aAmount);

  fHealth := fHealth - aAmount;
end;

// ----------------------------------------------------------------------------
Constructor AILivingGroup.Create(aParent: pointer);
begin
  inherited Create(aParent);

  fMembers := AIThingReferenceList.Create(self);
  fMaximum := 64;
  CalculateFull;
end;

// ----------------------------------------------------------------------------
destructor AILivingGroup.Destroy;
begin
  fMembers.Free;

  inherited Destroy;
end;

// ----------------------------------------------------------------------------
procedure AILivingGroup.Fuel;
begin
  inherited Fuel;

  if Members.Count = 0 then
    Cease;
end;

// ----------------------------------------------------------------------------
procedure AILivingThing.SaveToFile(var aFile: TextFile);
begin
  inherited SaveToFile(aFile);
  writeln(aFile, fWater);
  writeln(aFile, fHealth);
  writeln(aFile, fRot);
  // writeFileBoolean(aFile, fEdible);
end;

// ----------------------------------------------------------------------------
procedure AILivingThing.LoadFromFile(var aFile: TextFile);
begin
  inherited LoadFromFile(aFile);
  readln(aFile, fWater);
  readln(aFile, fHealth);
  readln(aFile, fRot);
  // fEdible := readFileBoolean(aFile);
end;

// ----------------------------------------------------------------------------
function AILivingThing.OneLineDisplay: string;
begin
  result := GetName + ' ' + IntToStr(Handle) + ' Health=' + IntToStr(fHealth) +
    Position.OneLineDisplay;
end;

// ----------------------------------------------------------------------------
// returns true if the member was added,
// returns false if group is full
function AILivingGroup.AddMember(aMember: AIThing): boolean;
begin
  result := false;
  if not fFull and (Members.IndexOf(aMember) = -1) then
  begin
    Members.Add(aMember);
    result := true;
    CalculateFull;
  end;
end;

// ----------------------------------------------------------------------------
procedure AILivingGroup.RemoveMember(aMember: AIThing);
begin
  Members.Remove(aMember);
  CalculateFull;
end;

// ----------------------------------------------------------------------------
procedure AILivingGroup.SaveToFile(var aFile: TextFile);
begin
  inherited SaveToFile(aFile);
  writeln(aFile, fMaximum);
end;

// ----------------------------------------------------------------------------
procedure AILivingGroup.LoadFromFile(var aFile: TextFile);
begin
  inherited LoadFromFile(aFile);
  readln(aFile, fMaximum);
end;

// ----------------------------------------------------------------------------
procedure AILivingThing.FullDisplay(aList: TStrings);
begin
  inherited FullDisplay(aList);

  aList.Add('Alive: ' + BoolToYesNoStr(Alive));
  aList.Add('Health: ' + IntToStr(fHealth));
  aList.Add(Format('Water: %0.2f', [fWater]));
  aList.Add('Rot: ' + IntToStr(fRot));
end;

// ----------------------------------------------------------------------------
procedure AILivingGroup.FullDisplay(aList: TStrings);
var
  i: integer;
  myMember: AIThing;
begin
  inherited FullDisplay(aList);

  aList.Add('Count: ' + IntToStr(Members.Count));
  aList.Add('Maximum: ' + IntToStr(fMaximum));
  aList.Add('Full: ' + BoolToYesNoStr(fFull));
  for i := 0 to fMembers.Count - 1 do
  begin
    myMember := AIThing(fMembers[i]);
    aList.AddObject(IntToStr(i + 1) + ': ' + myMember.OneLineDisplay, myMember);
  end;
end;

// ----------------------------------------------------------------------------
function AILivingGroup.OneLineDisplay: string;
begin
  result := GetName + Format(' %d Members=%d/%d ',
    [Handle, Members.Count, fMaximum]);
end;

// ----------------------------------------------------------------------------
procedure AILivingGroup.CalculateFull;
begin
  fFull := (fMembers.Count >= fMaximum);
end;

// ----------------------------------------------------------------------------
function AILivingGroup.Vacancy: boolean;
begin
  result := not fFull;
end;

// ----------------------------------------------------------------------------
procedure AILivingThing.SetAlive(aValue: boolean);
begin
  if aValue = fAlive then
    exit;
  fAlive := aValue;

  // kill
  if fAlive = false then
  begin
    Die;
  end
  else // revive
  begin
    fRot := 0;
    if fHealth <= 0 then
      fHealth := 1;
  end;
end;

// ----------------------------------------------------------------------------
procedure AILivingThing.Cease;
begin
  if Exists and Alive then
    Die;

  inherited Cease;
end;

// ----------------------------------------------------------------------------
function AILivingThing.Digest(const aAmount: integer): integer;
begin
  result := aAmount;
  if aAmount > Health then
    result := Health;
  Health := Health - result;
  if not Alive then
    Cease;
end;

// ----------------------------------------------------------------------------
procedure AILivingThing.SetHealth(aValue: integer);
begin
  fHealth := aValue;
  if fHealth <= 0 then
    Die;
end;

// ----------------------------------------------------------------------------
procedure AILivingThing.HealthIncrease(aAmount: integer);
begin
  Health := Health + aAmount;
end;

end.
