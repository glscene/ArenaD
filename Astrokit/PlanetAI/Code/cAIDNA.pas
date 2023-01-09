unit cAIDNA;
(*
  Orig: cAIDNA.pas,v 1.15 2003/07/30 04:37:43 aidave
*)

interface

uses
  System.Classes,
  System.SysUtils,
  System.IniFiles,
  cAICreature,
  cAIThings,
  cAILife,
  cAILink;

const
  cDNA = 0;

type

// ============================================================================
AIDNA = class(TObject)
private
  fMutation: single;
  fGrowthRate: single;
  fSizeMax: single;
  fMassMax: single;
  fBuoyancy: single;
  fBounce: single;
  fPreferredFood: integer;
  // color (0 to 1)
  fRed: single;
  fBlue: single;
  fGreen: single;
protected
  procedure SetBounce(aValue: single);
  procedure SetBuoyancy(aValue: single);
  procedure SetRed(aValue: single);
  procedure SetBlue(aValue: single);
  procedure SetGreen(aValue: single);
  procedure SetPreferredFood(aValue: integer);
public
  constructor Create;
  destructor Destroy; override;
  property Mutation: single read fMutation write fMutation;
  property GrowthRate: single read fGrowthRate write fGrowthRate;
  property SizeMax: single read fSizeMax write fSizeMax;
  property MassMax: single read fMassMax write fMassMax;
  property Buoyancy: single read fBuoyancy write SetBuoyancy;
  property Bounce: single read fBounce write SetBounce;
  property PreferredFood: integer read fPreferredFood write SetPreferredFood;
  property Red: single read fRed write SetRed;
  property Blue: single read fBlue write SetBlue;
  property Green: single read fGreen write SetGreen;
  // combine two DNA values into one
  procedure Combine(FatherDNA, MotherDNA: AIDNA);
  procedure CopyFrom(aDNA: AIDNA);
  // file load/save routines
  procedure SaveToFile(var aFile: TextFile);
  procedure LoadFromFile(var aFile: TextFile);
  procedure LoadFromINI(aFileName: string);
  function SaveToINI(aFileName: string): boolean;
  // display routines
  function OneLineDisplay: string;
  procedure FullDisplay(aList: TStrings);
end;

implementation

uses
  cUtilities, cGlobals, cAIVibes, cAIPosition;

// ----------------------------------------------------------------------------
constructor AIDNA.Create;
begin
  inherited Create;

  fMutation := 1;
end;

// ----------------------------------------------------------------------------
destructor AIDNA.Destroy;
begin

  inherited Destroy;
end;

// ----------------------------------------------------------------------------
procedure AIDNA.SaveToFile(var aFile: TextFile);
begin
  writeln(aFile, fMutation);
  writeln(aFile, fBuoyancy);
  writeln(aFile, fBounce);
  writeln(aFile, fPreferredFood);
  writeln(aFile, fRed);
  writeln(aFile, fBlue);
  writeln(aFile, fGreen);
end;

// ----------------------------------------------------------------------------
procedure AIDNA.LoadFromFile(var aFile: TextFile);
begin
  readln(aFile, fMutation);
  readln(aFile, fBuoyancy);       SetBuoyancy(fBuoyancy);
  readln(aFile, fBounce);         SetBounce(fBounce);
  readln(aFile, fPreferredFood);  SetPreferredFood(fPreferredFood);
  readln(aFile, fRed);            SetRed(fRed);
  readln(aFile, fBlue);           SetBlue(fBlue);
  readln(aFile, fGreen);          SetGreen(fGreen);
end;

// ----------------------------------------------------------------------------
function AIDNA.OneLineDisplay: string;
begin
  result := 'DNA';
end;

// ----------------------------------------------------------------------------
procedure AIDNA.FullDisplay(aList: TStrings);
begin
  aList.Add('DNA ----------');
  aList.Add(Format('Mutation: %0.4f', [fMutation]));
  aList.Add(Format('Buoyancy: %0.4f', [fBuoyancy]));
  aList.Add(Format('Bounce: %0.4f', [fBounce]));
  aList.Add(Format('PreferredFood: %d (%s)', [fPreferredFood, ThingName(fPreferredFood)]));
  aList.Add(Format('Red: %0.4f', [fRed]));
  aList.Add(Format('Blue: %0.4f', [fBlue]));
  aList.Add(Format('Green: %0.4f', [fGreen]));
end;

// ----------------------------------------------------------------------------
procedure AIDNA.Combine(FatherDNA, MotherDNA: AIDNA);
var
  myRate: single;
begin
  fMutation := (FatherDNA.Mutation + MotherDNA.Mutation)/2;
  myRate := 1 + (RandomPolarity * fMutation);

  GrowthRate := myRate*(FatherDNA.GrowthRate + MotherDNA.GrowthRate)/2;
  SizeMax := myRate*(FatherDNA.SizeMax + MotherDNA.SizeMax)/2;
  MassMax := myRate*(FatherDNA.MassMax + MotherDNA.MassMax)/2;
  Buoyancy := myRate*(FatherDNA.Buoyancy + MotherDNA.Buoyancy)/2;
  Bounce := myRate*(FatherDNA.Bounce + MotherDNA.Bounce)/2;
  Red := myRate*(FatherDNA.Red + MotherDNA.Red)/2;
  Blue := myRate*(FatherDNA.Blue + MotherDNA.Blue)/2;
  Green := myRate*(FatherDNA.Green + MotherDNA.Green)/2;

  if Random(2)=0 then
    PreferredFood := FatherDNA.PreferredFood
  else
    PreferredFood := MotherDNA.PreferredFood;
end;

// ----------------------------------------------------------------------------
procedure AIDNA.LoadFromINI(aFileName: string);
var
  Ini: TIniFile;
begin
  FormatSettings.DecimalSeparator := '.';
  if not FileExists(aFileName) then exit;
  Ini := TIniFile.Create(aFileName);
  try
    Mutation := Ini.ReadFloat('DNA', 'Mutation', 0.1);
    Buoyancy := Ini.ReadFloat('DNA', 'Buoyancy', 0.5);
    Bounce := Ini.ReadFloat('DNA', 'Bounce', 0.5);
    PreferredFood := Ini.ReadInteger('DNA', 'PreferredFood', cApple);
    Red := Ini.ReadFloat('DNA', 'Red', 0.5);
    Blue := Ini.ReadFloat('DNA', 'Blue', 0.5);
    Green := Ini.ReadFloat('DNA', 'Green', 0.5);
  finally
    Ini.Free;
  end;
end;

// ----------------------------------------------------------------------------
function AIDNA.SaveToINI(aFileName: string): boolean;
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(aFileName);
  try
    Ini.WriteFloat('DNA', 'Mutation', Mutation);
    Ini.WriteFloat('DNA', 'Buoyancy', Buoyancy);
    Ini.WriteFloat('DNA', 'Bounce', Bounce);
    Ini.WriteInteger('DNA', 'PreferredFood', PreferredFood);
    Ini.WriteFloat('DNA', 'Red', Red);
    Ini.WriteFloat('DNA', 'Blue', Blue);
    Ini.WriteFloat('DNA', 'Green', Green);
    result := true;
  finally
    Ini.Free;
  end;
end;

// ----------------------------------------------------------------------------
procedure AIDNA.CopyFrom(aDNA: AIDNA);
begin
  Mutation := aDNA.Mutation;
  Buoyancy := aDNA.Buoyancy;
  Bounce := aDNA.Bounce;
  PreferredFood := aDNA.PreferredFood;
  Red := aDNA.Red;
  Blue := aDNA.Blue;
  Green := aDNA.Green;
end;

// ----------------------------------------------------------------------------
procedure AIDNA.SetBounce(aValue: single);
begin
  fBounce := aValue;
  if fBounce < 0.0 then fBounce := 0.0;
  if fBounce > 1.0 then fBounce := 1.0;
end;

// ----------------------------------------------------------------------------
procedure AIDNA.SetBuoyancy(aValue: single);
begin
  fBuoyancy := aValue;
  if fBuoyancy < 0.0 then fBuoyancy := 0.0;
  if fBuoyancy > 1.0 then fBuoyancy := 1.0;
end;

// ----------------------------------------------------------------------------
procedure AIDNA.SetRed(aValue: single);
begin
  fRed := aValue;
  if fRed < 0.0 then fRed := 0.0;
  if fRed > 1.0 then fRed := 1.0;
end;

// ----------------------------------------------------------------------------
procedure AIDNA.SetBlue(aValue: single);
begin
  fBlue := aValue;
  if fBlue < 0.0 then fBlue := 0.0;
  if fBlue > 1.0 then fBlue := 1.0;
end;

// ----------------------------------------------------------------------------
procedure AIDNA.SetGreen(aValue: single);
begin
  fGreen := aValue;
  if fGreen < 0.0 then fGreen := 0.0;
  if fGreen > 1.0 then fGreen := 1.0;
end;

// ----------------------------------------------------------------------------
procedure AIDNA.SetPreferredFood(aValue: integer);
begin
  fPreferredFood := aValue;
  if fPreferredFood < 0 then fPreferredFood := 0;
  if fPreferredFood > cLastThing then fPreferredFood := cLastThing;
end;

end.
