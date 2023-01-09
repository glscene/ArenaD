{
  ai.planet
  http://aiplanet.sourceforge.net
  by David Kerr
  $Id: cAILearningCreature.pas,v 1.8 2003/09/03 00:14:14 aidave Exp $
  A learning creature.
  Everytime it eats something, it remembers facts about its food.
  It then finds the optimal food from its memory, based on
  how much it liked the food from before.  It finds the food based
  on how much "weight" it gives the food, divided by distance to food.  
}
unit cAILearningCreature;

interface

uses
  System.Classes,
  System.Contnrs,
  cAIBaseObject,
  cAIThings,
  cAIThingReferenceList,
  cAIPosition,
  cAILife,
  cAILink,
  cAICreature,
  cAIReportCard;

type

// ============================================================================
// an individual LearningCreature
AILearningCreature = Class(AICreature)
private
  fMemory: AIReportList;          // memory of eaten things
  fSenses: AIThingReferenceList;  // list of nearby things
  fTimer: integer;                // timer, measures effort to get food
  fSenseMemory: TStringList;      // text-version of fSenses
protected
  // look for food anywhere
  procedure LookForSomethingToEat; overload;
  // look for food in water, land, air, etc
  procedure LookForSomethingToEat(aBinding: integer); overload;
  // give up on a target
  procedure GiveUp;
public
  Constructor Create(aParent: pointer);
  Destructor Destroy; override;

  property Memory: AIReportList read fMemory;
  property Senses: AIThingReferenceList read fSenses;
  property SenseMemory: TStringList read fSenseMemory;
  property Timer: integer read fTimer;

  function Eat(const JawSize: integer): boolean; override;
  function FavoriteFood: integer;
  function YuckiestFood: integer;

  procedure FullDisplay(aList: TStrings); override;
  procedure SaveToFile(var aFile: TextFile); override;
  procedure LoadFromFile(var aFile: TextFile); override;
end;

implementation

uses
  cAIReality, System.SysUtils, cGlobals, cAIVibes;

// ----------------------------------------------------------------------------
Constructor AILearningCreature.Create(aParent: pointer);
begin
  inherited Create(aParent);

  fMemory := AIReportList.Create(true);
  fSenses := AIThingReferenceList.Create(self);
  fSenseMemory := TStringList.Create;
end;

// ----------------------------------------------------------------------------
destructor AILearningCreature.Destroy;
begin
  fMemory.Free;
  fSenses.Free;
  fSenseMemory.Free;

  inherited Destroy;
end;

// ----------------------------------------------------------------------------
procedure AILearningCreature.FullDisplay(aList: TStrings);
begin
  inherited FullDisplay(aList);

  aList.Add('MEMORY------------------------------');
  fMemory.FullDisplay(aList);
  aList.Add('SENSES------------------------------');
//  aList.AddStrings(fSenseMemory);
end;

// ----------------------------------------------------------------------------
procedure AILearningCreature.LookForSomethingToEat;
var
  i: integer;
  myThing: AIThing;
  myTarget: AIThing;
  BestWeight, ReportWeight: single;
begin
  fSenses.Clear;
  gThings.Tangibles.NearestNeighbours(Position, 10, fSenses);
  fSenseMemory.Clear;
  fSenses.FullDisplay(fSenseMemory);  // store for display
  myTarget := nil;
  BestWeight := -1;

  for i := 0 to fSenses.Count - 1 do
  begin
    myThing := AIThing(fSenses.Items[i]);
    // make sure its not the same kind
    if not (myThing.Kind = Kind) then
    begin
      ReportWeight := fMemory.ReportWeight(myThing.Kind) / Position.DistancePlusHeightTo(myThing.Position);
      fTimer := gReality.Time;
      if ReportWeight > BestWeight then
      begin
        BestWeight := ReportWeight;
        myTarget := myThing;
      end;
    end;
  end;

  if myTarget <> nil then
    Eyes.AssignTarget(myTarget);
end;

// ----------------------------------------------------------------------------
procedure AILearningCreature.LookForSomethingToEat(aBinding: integer);
var
  i: integer;
  myThing: AIThing;
  myTarget: AIThing;
  BestWeight, ReportWeight: single;
begin
  fSenses.Clear;
  gThings.Tangibles.NearestNeighbours(Position, 10, fSenses);
  fSenseMemory.Clear;
  fSenses.FullDisplay(fSenseMemory);  // store for display
  myTarget := nil;
  BestWeight := -1;

  for i := 0 to fSenses.Count - 1 do
  begin
    myThing := AIThing(fSenses.Items[i]);
    // make sure its not the same kind
    if not (myThing.Kind = Kind) and (myThing.Position.Binding = aBinding) then
    begin
      ReportWeight := fMemory.ReportWeight(myThing.Kind) / Position.DistancePlusHeightTo(myThing.Position);
      fTimer := gReality.Time;
      if ReportWeight > BestWeight then
      begin
        BestWeight := ReportWeight;
        myTarget := myThing;
      end;
    end;
  end;

  if myTarget <> nil then
    Eyes.AssignTarget(myTarget);
end;

// ----------------------------------------------------------------------------
procedure AILearningCreature.LoadFromFile(var aFile: TextFile);
begin
  inherited LoadFromFile(aFile);
  readln(aFile, fTimer);
  fMemory.LoadFromFile(aFile);
end;

// ----------------------------------------------------------------------------
procedure AILearningCreature.SaveToFile(var aFile: TextFile);
begin
  inherited SaveToFile(aFile);
  writeln(aFile, fTimer);
  fMemory.SaveToFile(aFile);
end;

// ----------------------------------------------------------------------------
// try to eat whatever the creature is holding
function AILearningCreature.Eat(const JawSize: integer): boolean;
var
  myThing: AIThing;
  myPreviousHealth: integer;
  myChange: integer;
begin
  myThing := Grabber.Target;
  // remember last health
  myPreviousHealth := Health;

  result := inherited Eat(JawSize);

  myChange := Health - myPreviousHealth;

  if myChange > 0 then
    fMemory.AddReport(myThing.Kind, true, myChange, gReality.Time-fTimer+1)
  else
  begin
    fMemory.AddReport(myThing.Kind, false, myChange, gReality.Time-fTimer+1);
    Talk('"This ' + ThingName(myThing.Kind) + ' is yucky."', 10, 32);
    Drop;
  end;
end;

// ----------------------------------------------------------------------------
procedure AILearningCreature.GiveUp;
var
  myThing: AIThing;
begin
  if Eyes.ValidTarget then
  begin
    myThing := Eyes.Target;
    Talk('"I couldnt catch that ' + ThingName(Eyes.Target.Kind) + '."', 10, 32);
    fMemory.AddReport(myThing.Kind, false, 1, gReality.Time-fTimer+1)
  end;
end;

// ----------------------------------------------------------------------------
function AILearningCreature.FavoriteFood: integer;
begin
  result := Memory.HighestWeight;
end;

// ----------------------------------------------------------------------------
function AILearningCreature.YuckiestFood: integer;
begin
  result := Memory.LowestWeight;
end;

end.

