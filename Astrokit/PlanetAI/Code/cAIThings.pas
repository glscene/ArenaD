{
  ai.planet
  http://aiplanet.sourceforge.net
  Created by Dave Kerr (kerrd@hotmail.com)
  $Id: cAIThings.pas,v 1.92 2003/10/01 00:54:52 aidave Exp $
}
unit cAIThings;

interface

uses
  System.Classes,
  System.Types,
  System.Contnrs,

  GLS.VectorGeometry,
  GLS.VectorTypes,
  cAIBaseObject,
  cAIGrid,
  cAICoordinates,
  cAIThingReferenceList,
  cAIPosition;

const
  cNothing = -1;
  cApple = 0;
  cOrange = 1;
  cAppleTree = 2;
  cOrangeTree = 3;
  cAppleSeed = 4;
  cOrangeSeed = 5;
  cBird = 6;
  cFish = 7;
  cDuck = 8;
  cCrab = 9;
  cHawk = 10;
  cTurtle = 11;
  cCloud = 12;
  cIceberg = 13;
  cLadybug = 14;
  cAnt = 15;
  cSun = 16;
  cMoon = 17;
  cCommunity = 18;
  cAsteroid = 19;
  cShark = 20;
  cAquaPlant = 21;
  cBot = 22;
  cExplosion = 23;
  cFlock = 24;
  cBall = 25;
  cBomb = 26;
  cGrazer = 27;
  cTrex = 28;
  cVibe = 29;
  cWeapon = 30;
  cLightning = 31;
  cBeacon = 32;
  cTerrier = 33;
  cFox = 34;
  cRabbit = 35;
  cGrass = 36;
  cMouse = 37;
  cTiger = 38;
  cDolphin = 39;
  cEarthquake = 40;
  cEvolvingTree = 41;
  cEvolvingFruit = 42;
  cEvolvingSeed = 43;
  cFireTree = 44;
  cSpeech = 45;
  cMissileDefence = 46;
  cMissile = 47;
  cLastThing = 47;  // same number as the last thing

type

AIIntegerList = array of integer;
AIThing = class;
AIClass = class of AIThing;

// ============================================================================
AIThing = Class(AIBaseObject)
private
  fKind: integer;
  fPosition: AIPosition;
  fExists: boolean;
  fBirthday: integer;
protected
  procedure SetName(aName: string); virtual;
  function GetName: string; virtual;
  function GetAge: integer;
public
  constructor Create(aParent: pointer);
  destructor Destroy; override;
  property Name: string read GetName write SetName;
  property Kind: integer read fKind write fKind;
  property Position: AIPosition read fPosition;
  property Age: integer read GetAge;
  property Birthday: integer read fBirthday;
  property Exists: boolean read fExists;
  // queue for deletion
  procedure Cease; virtual;
  // take damage
  procedure Damage(aAmount: integer); virtual;
  // perform an activity
  procedure Perform(aActivity: integer); virtual;
  // make a vibe
  procedure Vibrate(aEffectType, aEffectIndex, aTimerDeath: integer);
  // make a noise vibe
  procedure Noise(aEffectIndex, aTimerDeath: integer);
  // what happens when its eaten?
  function Digest(const aAmount: integer): integer; virtual;
  // play happiness value
  function Play(aPlaymate: AIThing): integer;
  function Tickle: integer; virtual;
  // talk
  procedure Talk(aText: string; aRadius: single; aTimerDeath: integer);
  procedure Report;
  // subclass information
  function HasDNA: boolean; virtual;
  function GetDNA: pointer; virtual;
  function IsPlant: boolean; virtual;
  function IsFruit: boolean; virtual;
  function IsPrey: boolean; virtual;      // small prey
  function IsPredator: boolean; virtual;  // predators that chase the prey
  procedure Fuel; virtual; // add time
  procedure OnCollide(aCollider: AIThing); virtual;
  function OneLineDisplay: string; override;
  procedure FullDisplay(aList: TStrings); override;
  procedure SaveToFile(var aFile: TextFile); override;
  procedure LoadFromFile(var aFile: TextFile); override;
end;

// ----------------------------------------------------------------------------
AIThingList = Class(AIBaseContainer)
private
  fMaximums:  AIIntegerList;          // maximum amounts
  fCounters:  AIIntegerList;          // counters
  fExistents: AIThingReferenceList;   // list of things that exist
  fCradle:    AIThingReferenceList;   // list of new things
  fPurgatory: AIThingReferenceList;   // list of things condemned to deletion
  fTrash:     AIThingReferenceList;   // list of things to delete
  fTables:    AIThingTables;          // handy lists sorted by thing Kind
  fForms:     AIBaseContainer;        // a base model of each things DNA
  fFruits:    AIThingReferenceList;   // list of all fruits
  fPrey:      AIThingReferenceList;   // list of all prey
  fPredators: AIThingReferenceList;   // list of all predators
  fColliders: AIThingReferenceList;   // list of all colliding objects
  fTangibles: AIThingReferenceList;   // list of Position.Fueled objects
  fCollisions: boolean;               // collisions on or off?
  fAI:        boolean;                // call ai code?
  function NewApple: AIThing;
  function NewAppleTree: AIThing;
  function NewAppleSeed: AIThing;
  function NewOrange: AIThing;
  function NewOrangeTree: AIThing;
  function NewOrangeSeed: AIThing;
protected
  procedure CreateTables;
  procedure DestroyTables;
  procedure ClearTables;
  procedure GenerateForms;
  function  CreateThing(aKind: integer): AIThing;
  procedure CheckCollisions;
public
  constructor Create(aEnvironment: pointer);
  destructor Destroy; override;
  property Existents: AIThingReferenceList read fExistents;
  property Cradle:    AIThingReferenceList read fCradle;
  property Purgatory: AIThingReferenceList read fPurgatory;
  property Trash:     AIThingReferenceList read fTrash;
  property Fruits:    AIThingReferenceList read fFruits;
  property Prey:      AIThingReferenceList read fPrey;
  property Predators: AIThingReferenceList read fPredators;
  property Colliders: AIThingReferenceList read fColliders;
  property Tangibles: AIThingReferenceList read fTangibles;
  property Tables:    AIThingTables read fTables;
  property Forms:     AIBaseContainer read fForms;
  property Maximums:  AIIntegerList read fMaximums;
  property Counters:  AIIntegerList read fCounters;
  property Collisions: boolean read fCollisions write fCollisions;
  property AI: boolean read fAI write fAI;
  function NewThing(aKind: integer): AIThing; overload;
  function NewThing(aKind: integer; aLocation: AIGrid): AIThing; overload;
  function Exists(aKind: integer): boolean;
  function Connection(aKind: integer): AIThing;
  procedure JoinAllCommunities;
  procedure FuelEverything;
  procedure BringOutYourDead;
  procedure EmptyCradle;
  procedure EmptyPurgatory;   // dangerous...!
  procedure EmptyTrash;       // dangerous
  function CanTreeGrowHere(aPosition: AIPosition): boolean;
  function  CanAdd(aKind: integer): boolean;
  procedure DefaultMaximums;
  procedure ResetCounters;
  procedure Clean;
  procedure LoadForms;
  procedure DisplayCounts(aList: TStrings);
  procedure SaveToFile(var aFile: TextFile);
  procedure LoadFromFile(var aFile: TextFile);
end;

function ThingName(aKind: integer): string;
function ThingNamePlural(aKind: integer): string;

//=========================================
implementation
//=========================================

uses
  cAIReality, cAIEnvironment, System.SysUtils, cAITrees, cAISatellites,
  cAIFish, cAIBird, cAIExplosions, cAILife, cUtilities, cAIBot,
  cAICrab, cAIHawk, cAIGrazer, cAITrex, cAIVibes, cAICreature,
  cAITool, cGlobals, cAIWeather, cAIShark, cAITurtle, cAITerrier,
  cAIFox, cAIRabbit, cAIGrass, cAIMouse, cAITiger, cAIDuck, cAICommunity,
  cAIDolphin, cAILadybug, cAIAnt, cAIDNA, cAIEvolvingTrees,
  cAIFireTree, cAIMissileDefence;

// ----------------------------------------------------------------------------
Constructor AIThingList.Create(aEnvironment: pointer);
begin
  inherited Create(aEnvironment);
  gThings := self;
  fExistents := AIThingReferenceList.Create(self);
  fCradle :=    AIThingReferenceList.Create(self);
  fPurgatory := AIThingReferenceList.Create(self);
  fTrash :=     AIThingReferenceList.Create(self);
  fFruits :=    AIThingReferenceList.Create(self);
  fPredators := AIThingReferenceList.Create(self);
  fPrey :=      AIThingReferenceList.Create(self);
  fColliders := AIThingReferenceList.Create(self);
  fTangibles := AIThingReferenceList.Create(self);
  fForms :=     AIBaseContainer.Create(self);
  fCollisions := true;
  fAI := true;
  SetLength(fMaximums, 64); // saved
  SetLength(fCounters, 64); // dynamic
  CreateTables;
  DefaultMaximums;
  ResetCounters;
  GenerateForms;
  LoadForms;
end;

// ----------------------------------------------------------------------------
Destructor AIThingList.Destroy;
begin
  fExistents.Free;
  fCradle.Free;
  fPurgatory.Free;
  fTrash.Free;
  fFruits.Free;
  fPredators.Free;
  fPrey.Free;
  fColliders.Free;
  fTangibles.Free;
  fForms.Free;
  DestroyTables;
  inherited Destroy;
end;

// ----------------------------------------------------------------------------
Constructor AIThing.Create(aParent: pointer);
begin
  inherited Create(aParent);

  Handle := UniqueHandle;

  fBirthday := gReality.Time;
  fPosition := AIPosition.Create(self);
  fExists := true;
end;

// ----------------------------------------------------------------------------
Destructor AIThing.Destroy;
begin
  // if this still Exists, then it might be linked
  if Exists then
    gEnvironment.Snip(Handle);

  fPosition.Free;

  inherited Destroy;
end;

// ----------------------------------------------------------------------------
procedure AIThingList.DefaultMaximums;
var
  i: integer;
begin
  // set all to 128 as a default
  for i := 0 to 64-1 do
    Maximums[i] := 128;

  // set specific defaults
  Maximums[cApple] := 512;
  Maximums[cOrange] := 512;
  Maximums[cAppleTree] := 256;
  Maximums[cOrangeTree] := 256;
  Maximums[cAppleSeed] := 512;
  Maximums[cOrangeSeed] := 512;
  Maximums[cSun] := 4;
  Maximums[cMoon] := 32;
  Maximums[cCloud] := 512;
  Maximums[cFish] := 1024;
  Maximums[cBird] := 1024;
  Maximums[cAsteroid] := 128;
  Maximums[cExplosion] := 64;
  Maximums[cBot] := 16;

  Maximums[cBall] := 64;
  Maximums[cFlock] := 64;
  Maximums[cBomb] := 64;
  Maximums[cCrab] := 128;
  Maximums[cHawk] := 64;
  Maximums[cGrazer] := 128;
  Maximums[cTrex] := 16;
  Maximums[cVibe] := 64;
  Maximums[cWeapon] := 16;
  Maximums[cLightning] := 8;
  Maximums[cShark] := 64;
  Maximums[cTurtle] := 64;
  Maximums[cBeacon] := 32;
  Maximums[cTerrier] := 8;
  Maximums[cFox] := 1024;
  Maximums[cRabbit] := 5000;
  Maximums[cGrass] := 256;
  Maximums[cIceberg] := 0;
  Maximums[cMouse] := 256;
  Maximums[cTiger] := 8; // match terrier
  Maximums[cDuck] := 128; // ducks are orange eating equivalents of turtles
  Maximums[cCommunity] := 64;
  Maximums[cDolphin] := 32;
  Maximums[cAquaPlant] := 128;
  Maximums[cLadybug] := 128;
  Maximums[cAnt] := 128;
  Maximums[cEarthquake] := 1;
  Maximums[cEvolvingTree] := 256;
  Maximums[cEvolvingFruit] := 512;
  Maximums[cEvolvingSeed] := 512;
  Maximums[cFireTree] := 5000;
  Maximums[cSpeech] := 64;
  Maximums[cMissileDefence] := 32;
  Maximums[cMissile] := 64;
end;

// ----------------------------------------------------------------------------
procedure AIThingList.ResetCounters;
var
  i: integer;
begin
  for i := 0 to 64-1 do
    Counters[i] := Existents.AmountOfKind(i);
end;

// ----------------------------------------------------------------------------
function AIThingList.CanAdd(aKind: integer): boolean;
begin
  result := (Maximums[aKind] > Counters[aKind]);
end;

// ----------------------------------------------------------------------------
procedure AIThingList.Clean;
begin
  Clear;
  Existents.Clear;
  Cradle.Clear;
  Purgatory.Clear;
  ClearTables;
  ResetCounters;
end;

// ----------------------------------------------------------------------------
function ThingName(aKind: integer): string;
begin
  case aKind of
    cApple:       result := 'Apple';
    cOrange:      result := 'Orange';
    cAppleTree:   result := 'Apple Tree';
    cOrangeTree:  result := 'Orange Tree';
    cAppleSeed:   result := 'Apple Seed';
    cOrangeSeed:  result := 'Orange Seed';
    cSun:         result := 'Sun';
    cMoon:        result := 'Moon';
    cCloud:       result := 'Cloud';
    cFish:        result := 'Fish';
    cBird:        result := 'Bird';
    cBot:         result := 'Bot';
    cBall:        result := 'Ball';
    cCrab:        result := 'Crab';
    cHawk:        result := 'Hawk';
    cTrex:        result := 'Trex';
    cGrazer:      result := 'Grazer';
    cAsteroid:    result := 'Asteroid';
    cExplosion:   result := 'Explosion';
    cFlock:       result := 'Flock';
    cLightning:   result := 'Lightning';
    cShark:       result := 'Shark';
    cTurtle:      result := 'Turtle';
    cBeacon:      result := 'Beacon';
    cTerrier:     result := 'Terrier';
    cVibe:        result := 'Vibe';
    cBomb:        result := 'Bomb';
    cWeapon:      result := 'Weapon';
    cFox:         result := 'Fox';
    cRabbit:      result := 'Rabbit';
    cGrass:       result := 'Grass';
    cIceberg:     result := 'Iceberg';
    cMouse:       result := 'Mouse';
    cTiger:       result := 'Tiger';
    cDuck:        result := 'Duck';
    cCommunity:   result := 'Community';
    cDolphin:     result := 'Dolphin';
    cAquaPlant:   result := 'Aqua Plant';
    cLadybug:     result := 'LadyBug';
    cAnt:         result := 'Ant';
    cEarthquake:  result := 'Earthquake';
    cEvolvingTree:  result := 'Evolving Tree';
    cEvolvingFruit: result := 'Evolving Fruit';
    cEvolvingSeed:  result := 'Evolving Seed';
    cFireTree:    result := 'Forest Tree';
    cSpeech:      result := 'Speech';
    cMissileDefence: result := 'Defence Station';
    cMissile:     result := 'Missile';
    cNothing:     result := 'Nothing';
  else
    result := 'Unnamed';
  end;
end;

// ----------------------------------------------------------------------------
function ThingNamePlural(aKind: integer): string;
begin
  case aKind of
    cFish:        result := 'Fish';
    cTrex:        result := 'Trexes';
    cLightning:   result := 'Lightning';
    cFox:         result := 'Foxes';
    cGrass:       result := 'Grass';
    cMouse:       result := 'Mice';
    cCommunity:   result := 'Communities';
    cSpeech:      result := 'Speeches';
    cNothing:     result := 'Nothing';
  else
    result := ThingName(aKind) + 's';
  end;
end;

// ----------------------------------------------------------------------------
function AIThing.GetName: string;
begin
  result := ThingName(Kind);
end;

// ----------------------------------------------------------------------------
procedure AIThing.SetName(aName: string);
begin
  // do nothing
end;

// ----------------------------------------------------------------------------
function AIThing.OneLineDisplay: string;
begin
  result := Name + ' ' + IntToStr(Handle) + ' ' + Position.OneLineDisplay;
end;

// ----------------------------------------------------------------------------
procedure AIThing.Fuel;
begin
//  fAge := fAge + 1;
end;

// ----------------------------------------------------------------------------
procedure AIThing.Cease;
begin
  if fExists then
  begin
    // no longer exists
    fExists := false;
    // move to purgatory
    gThings.Purgatory.Add(self);
    // remove links to this thing
//    gEnvironment.Snip(Handle);
  end;
end;

// ----------------------------------------------------------------------------
function AIThingList.NewThing(aKind: integer; aLocation: AIGrid): AIThing;
var
  myThing: AIThing;
begin
  if not CanAdd(aKind) then
  begin
    result := nil;
    exit;
  end;

  myThing := AIThing(NewThing(aKind));
  myThing.Position.SetToCoordinates(aLocation.Coordinates);
  myThing.Position.RandomizeOffset;
  myThing.Position.Fuel;
  if myThing.Position.Height < myThing.Position.HighestHeight + 5 then
    myThing.Position.Height := myThing.Position.HighestHeight + 5;
  result := myThing;
end;

// ----------------------------------------------------------------------------
function AIThingList.NewThing(aKind: integer): AIThing;
begin
  result := nil;

  // check to see if we can add this or not
  if not CanAdd(aKind) then
    exit;

  result := CreateThing(aKind);

  // add to owned thing list
  // if its a living group, then push to the top of list
  //  this is a trick to make communities fuel before their members move
  if not (AIThing(result) is AILivingGroup) then
    Add(result)
  else
    Insert(0, result);
  // add 1 to counters
  Counters[aKind] := Counters[aKind] + 1;
  // add to quick tables
  Tables[aKind].Add(result);
  // add to cradle
  Cradle.Add(result);
  // add to existents
  Existents.Add(result);
  // fruit table
  if result.IsFruit then Fruits.Add(result);
  // prey table
  if result.IsPrey then Prey.Add(result);
  // predator table
  if result.IsPredator then Predators.Add(result);
  // tangible table
  if result.Position.Tangible then Tangibles.Add(result);
  // colliders table
  if result.Position.Collider then Colliders.Add(result);

  // if its tangible, add to collision list
//  if result.Position.Tangible then
//    Colliders.Add(result);
end;


// ----------------------------------------------------------------------------
function AIThingList.CreateThing(aKind: integer): AIThing;
begin
  case aKind of
    cApple:       result := NewApple;
    cOrange:      result := NewOrange;
    cAppleTree:   result := NewAppleTree;
    cOrangeTree:  result := NewOrangeTree;
    cAppleSeed:   result := NewAppleSeed;
    cOrangeSeed:  result := NewOrangeSeed;
    cSun:         result := AISun.Create(self);
    cMoon:        result := AIMoon.Create(self);
    cCloud:       result := AICloud.Create(self);
    cFish:        result := AIFish.Create(self);
    cBird:        result := AIBird.Create(self);
    cAsteroid:    result := AIAsteroid.Create(self);
    cExplosion:   result := AIExplosion.Create(self);
    cFlock:       result := AIFlock.Create(self);
    cBot:         result := AIBot.Create(self);
    cBall:       result := AIBall.Create(self);
    cBomb:       result := AIBomb.Create(self);
    cCrab:       result := AICrab.Create(self);
    cHawk:       result := AIHawk.Create(self);
    cGrazer:     result := AIGrazer.Create(self);
    cTrex:       result := AITrex.Create(self);
    cVibe:       result := AIVibe.Create(self);
    cWeapon:     result := AIWeapon.Create(self);
    cLightning:  result := AILightning.Create(self);
    cShark:      result := AIShark.Create(self);
    cTurtle:     result := AITurtle.Create(self);
    cBeacon:     result := AIBeacon.Create(self);
    cTerrier:    result := AITerrier.Create(self);
    cFox:        result := AIFox.Create(self);
    cRabbit:     result := AIRabbit.Create(self);
    cGrass:      result := AIGrass.Create(self);
    cIceberg:    result := AIIceberg.Create(self);
    cMouse:      result := AIMouse.Create(self);
    cTiger:      result := AITiger.Create(self);
    cDuck:       result := AIDuck.Create(self);
    cCommunity:  result := AICommunity.Create(self);
    cDolphin:    result := AIDolphin.Create(self);
    cAquaPlant:  result := AIAquaPlant.Create(self);
    cLadybug:    result := AILadybug.Create(self);
    cAnt:        result := AIAnt.Create(self);
    cEarthquake: result := AIEarthquake.Create(self);
    cEvolvingTree:  result := AIEvolvingTree.Create(self);
    cEvolvingFruit: result := AIEvolvingFruit.Create(self);
    cEvolvingSeed:  result := AIEvolvingSeed.Create(self);
    cFireTree:   result := AIFireTree.Create(self);
    cSpeech:     result := AISpeech.Create(self);
    cMissileDefence: result := AIMissileDefence.Create(self);
    cMissile:       result := AIMissile.Create(self);
  else
    result := nil;
  end;
end;

// ----------------------------------------------------------------------------
function AIThingList.NewApple: AIThing;
var
  myApple: AIFruit;
begin
  myApple := AIFruit.Create(self);
  myApple.Kind := cApple;

  myApple.Position.Height := 40;
  myApple.Position.SetSize(0.3, 0.3, 0.3, true);
  myApple.Position.SetProperties(1, 0.5, 0.2);
  myApple.Health := 2048;

  result := myApple;
end;

// ----------------------------------------------------------------------------
function AIThingList.NewOrange: AIThing;
var
  myOrange: AIFruit;
begin
  myOrange := AIFruit.Create(self);
  myOrange.Kind := cOrange;

  myOrange.Position.Height := 20;
  myOrange.Position.SetSize(0.3, 0.3, 0.3, true);
  myOrange.Position.SetProperties(1, 0.7, 0.75);
  myOrange.Health := 2048;

  result := myOrange;
end;

// ----------------------------------------------------------------------------
function AIThingList.NewAppleTree: AIThing;
var
  myAppleTree: AITree;
begin
  myAppleTree := AITree.Create(self);
  myAppleTree.Kind := cAppleTree;

  myAppleTree.Position.SetPosition(Random(10), Random(10), 15);
  myAppleTree.Position.SetSize(0.5, 0.5, 1, true);
  myAppleTree.Position.SetProperties(4, 0.1, 0);

  result := myAppleTree;
end;

// ----------------------------------------------------------------------------
function AIThingList.NewOrangeTree: AIThing;
var
  myOrangeTree: AITree;
begin
  myOrangeTree := AITree.Create(self);
  myOrangeTree.Kind := cOrangeTree;

  myOrangeTree.Position.SetSize(0.5, 0.5, 1, true);
  myOrangeTree.Position.SetProperties(4, 0.2, 0);

  result := myOrangeTree;
end;

// ----------------------------------------------------------------------------
function AIThingList.NewAppleSeed: AIThing;
var
  myAppleSeed: AISeed;
begin
  myAppleSeed := AISeed.Create(self);
  myAppleSeed.Kind := cAppleSeed;
  myAppleSeed.Health := 512;
  myAppleSeed.Position.SetSize(0.1, 0.1, 1.5, true);
  myAppleSeed.Position.SetProperties(1, 0.1, 0.9);
  result := myAppleSeed;
end;

// ----------------------------------------------------------------------------
function AIThingList.NewOrangeSeed: AIThing;
var
  myOrangeSeed: AISeed;
begin
  myOrangeSeed := AISeed.Create(self);
  myOrangeSeed.Kind := cOrangeSeed;
  myOrangeSeed.Health := 512;
  myOrangeSeed.Position.SetSize(0.1, 0.1, 0.5, true);
  myOrangeSeed.Position.SetProperties(1, 0.2, 0.2);
  result := myOrangeSeed;
end;

// ----------------------------------------------------------------------------
procedure AIThingList.EmptyPurgatory;
var
  i: integer;
  myThing: AIThing;
begin
  for i := 0 to Purgatory.Count - 1 do
  begin
    myThing := AIThing(Purgatory.Items[i]);
    Trash.Add(myThing);
  end;
  Purgatory.Clear;
end;

// ----------------------------------------------------------------------------
procedure AIThingList.EmptyTrash;
var
  i: integer;
  myThing: AIThing;
begin
  for i := 0 to Trash.Count - 1 do
  begin
    myThing := AIThing(Trash.Items[i]);
    Remove(myThing);              // remove thing from reality, forever
  end;
  Trash.Clear;
end;

// ----------------------------------------------------------------------------
procedure AIThingList.EmptyCradle;
begin
  Cradle.Clear;
end;

// ----------------------------------------------------------------------------
procedure AIThing.SaveToFile(var aFile: TextFile);
begin
  inherited SaveToFile(aFile);
  Position.SaveToFile(aFile);
  writeln(aFile, fBirthday);
  writeFileBoolean(aFile, fExists);
end;

// ----------------------------------------------------------------------------
procedure AIThing.LoadFromFile(var aFile: TextFile);
begin
  inherited LoadFromFile(aFile);
  Position.LoadFromFile(aFile);
  readln(aFile, fBirthday);
  fExists := readFileBoolean(aFile);
end;

// ----------------------------------------------------------------------------
procedure AIThingList.SaveToFile(var aFile: TextFile);
var
  i: Integer;
  myThing: AIThing;
begin
  writeFileBoolean(aFile, fCollisions);
  writeFileBoolean(aFile, fAI);

  for i := 0 to 64-1 do
    writeln(aFile, Maximums[i]);

  writeln(aFile, Count);
  for i := 0 to Count - 1 do
  begin
    myThing := AIThing(Items[i]);
    writeln(aFile, myThing.Kind);                     // write kind
    myThing.SaveToFile(aFile);
  end;
end;

// ----------------------------------------------------------------------------
procedure AIThingList.LoadFromFile(var aFile: TextFile);
var
  i: Integer;
  myCount: Integer;
  myThing: AIThing;
  myKind: integer;
begin
  ResetCounters;

  fCollisions := readFileBoolean(aFile);
  fAI := readFileBoolean(aFile);

  for i := 0 to 64-1 do
    readln(aFile, Maximums[i]);

  readln(aFile, myCount);
  for i := 0 to myCount - 1 do
  begin
    readln(aFile, myKind);                // read kind
    myThing := NewThing(myKind);
    myThing.LoadFromFile(aFile);
  end;
end;

// ----------------------------------------------------------------------------
procedure AIThing.Damage(aAmount: integer);
begin
  // do nothing; subclasses responsible for damage assessment
end;

// ----------------------------------------------------------------------------
function AIThingList.Exists(aKind: integer): boolean;
var
  i: integer;
begin
  result := false;
  for i := 0 to Count - 1 do
    if AIThing(Items[i]).Kind = aKind then
      result := true;
end;

// ----------------------------------------------------------------------------
function AIThingList.Connection(aKind: integer): AIThing;
var
  i: integer;
begin
  // this method always returns the last apple in the list
  result := nil;
  for i := 0 to Count - 1 do
    if AIThing(Items[i]).Kind = aKind then
      result := AIThing(Items[i]);
end;

// ----------------------------------------------------------------------------
// If you have seen the movie THE STAND you might remember a big black guy
//  ringing a bell yelling "Bring out your dead!!!"
// This function is named in honor of him.
procedure AIThingList.BringOutYourDead;
var
  i: integer;
  myThing: AIThing;
begin
  for i := 0 to Purgatory.Count - 1 do
  begin
    myThing := AIThing(Purgatory.Items[i]);
    if Existents.IndexOf(myThing) <> -1 then
    begin
      // remove links to this thing
      gEnvironment.Snip(myThing.Handle);
      // remove from existents
      Existents.Remove(myThing);
      // remove from tables
      Tables[myThing.Kind].Remove(myThing);
      // decrement counter
      Counters[myThing.Kind] := Counters[myThing.Kind] - 1;
      // remove from cradle
      if Cradle.IndexOf(myThing) <> -1 then Cradle.Remove(myThing);
      // remove if fruit from fruitlist
      if myThing.IsFruit then Fruits.Remove(myThing);
      // remove if prey from preylist
      if myThing.IsPrey then Prey.Remove(myThing);
      // remove if predator from predatorlist
      if myThing.IsPredator then Predators.Remove(myThing);
      // remove from tangible list
      if myThing.Position.Tangible then Tangibles.Remove(myThing);
      // remove from collision list
      if myThing.Position.Collider then Colliders.Remove(myThing);
    end;
  end;
end;

// ----------------------------------------------------------------------------
procedure AIThing.Noise(aEffectIndex, aTimerDeath: integer);
var
  myVibe: AIVibe;
begin
  if not gThings.CanAdd(cVibe) then exit;

  myVibe := AIVibe(gEnvironment.Things.NewThing(cVibe));
  myVibe.SetVibe(cEffectNoise, aEffectIndex, aTimerDeath);
  myVibe.Position.CopyCoords(Position);
end;

// ----------------------------------------------------------------------------
procedure AIThing.Vibrate(aEffectType, aEffectIndex, aTimerDeath: integer);
var
  myVibe: AIVibe;
begin
  if not gThings.CanAdd(cVibe) then exit;
  myVibe := AIVibe(gEnvironment.Things.NewThing(cVibe));
  myVibe.SetVibe(aEffectType, aEffectIndex, aTimerDeath);
  myVibe.Position.CopyCoords(Position);
end;

// ----------------------------------------------------------------------------
procedure AIThing.Perform(aActivity: integer);
begin
//  Noise(cNoiseKick, 1);
  // nothing
end;

// ----------------------------------------------------------------------------
procedure AIThingList.FuelEverything;
var
  i: integer;
  RigidCount: integer;
  myThing: AIThing;
  myItem: AIThing;
  myCreature: AICreature;
begin

  if fCollisions then
    CheckCollisions;

  // newly created things dont get fueled till next round
  RigidCount := Existents.Count - 1;
  // call all AI code
  if fAI then
    for i := 0 to RigidCount do
    begin
      if not (Existents.Items[i] is AILivingThing) then
        AIThing(Existents.Items[i]).Fuel
      else if AILivingThing(Existents.Items[i]).Alive then
        AIThing(Existents.Items[i]).Fuel
      else
        AILivingThing(Existents.Items[i]).Decompose;
    end;

  // apply all velocities
  for i := 0 to fTangibles.Count-1 do
  begin
    myThing := AIThing(fTangibles.Items[i]);

    if not myThing.Position.Carried then
      myThing.Position.Fuel;

    if myThing is AICreature then
    begin
      myCreature := AICreature(myThing);
      // check to see if it is holding something
      if myCreature.Grabber.Holding then
      begin
        myItem := myCreature.Grabber.Target;

        myItem.Position.CopyCoords(myThing.Position);
        // set the item direction to creature direction
        myItem.Position.DirectionXY := myThing.Position.DirectionXY;
        // set the position of the item to near the front of the creature
        myItem.Position.Height := myItem.Position.Height - myItem.Position.SizeH/2;
        // since the item is rotated 90 degrees, move it out by half the Y side of the bounding box, plus
        //  half the size of the creature
        myItem.Position.MoveBy((myItem.Position.SizeY/2 + myThing.Position.SizeX/2));
        // now rotate it properly by 90 degrees
        myItem.Position.DirectionXY := myThing.Position.DirectionXY + HalfPi;
        // nullify the velocities and accels
        myItem.Position.Velocity.Zero;
        myItem.Position.Acceleration.Zero;
        myItem.Position.Fuel;
        myItem.Position.Velocity.CopyFrom(myThing.Position.Velocity);
      end;
    end;
  end;
end;

// ----------------------------------------------------------------------------
procedure AIThingList.CreateTables;
var
  i: integer;
begin
  // set the array length
  SetLength(fTables, 64);
  // create the tables
  for i := 0 to 64-1 do
    fTables[i] := AIThingReferenceList.Create(self);
end;

// ----------------------------------------------------------------------------
procedure AIThingList.DestroyTables;
var
  i: integer;
begin
  // free tables
  for i := 0 to 64-1 do
    fTables[i].Free;
end;

// ----------------------------------------------------------------------------
procedure AIThingList.ClearTables;
var
  i: integer;
begin
  // free tables
  for i := 0 to 64-1 do
    fTables[i].Clear;
end;

// ----------------------------------------------------------------------------
procedure AIThing.FullDisplay(aList: TStrings);
begin
  aList.Add(Name);
  inherited FullDisplay(aList);
  aList.Add('Kind: ' + IntToStr(fKind));
  aList.Add('Birthday: ' + IntToStr(fBirthday));
  aList.Add('Age: ' + IntToStr(Age));
  aList.Add('Exists: ' + BoolToYesNoStr(fExists));
  aList.Add('HasDNA: ' + BoolToYesNoStr(HasDNA));
  aList.Add('IsFruit: ' + BoolToYesNoStr(IsFruit));
  aList.Add('IsPredator: ' + BoolToYesNoStr(IsPredator));
  aList.Add('IsPrey: ' + BoolToYesNoStr(IsPrey));
  Position.FullDisplay(aList);
end;

// ----------------------------------------------------------------------------
function AIThing.GetAge: integer;
begin
  result := gReality.Time - fBirthday;
end;

// ----------------------------------------------------------------------------
// what happens when something tries to eat this?
function AIThing.Digest(const aAmount: integer): integer;
begin
  result := 0;
end;

// ----------------------------------------------------------------------------
// used after a file is loaded, to rejoin creatures to their communities
procedure AIThingList.JoinAllCommunities;
var
  myThing: AIThing;
  i: integer;
begin
  for i := 0 to Count-1 do
  begin
    myThing := AIThing(Items[i]);
    if myThing is AICommunityCreature then
      AICommunityCreature(myThing).ReaffirmCommunity;
    if myThing is AIBird then
      AIBird(myThing).ReaffirmFlock;
  end;
end;

// ----------------------------------------------------------------------------
// creates an instance of every object
// Plato's Forms: every object has a form from which it acquires its characteristics
procedure AIThingList.GenerateForms;
var
  myDNA: AIDNA;
  i: integer;
begin
  for i := 0 to cLastThing do
  begin
    myDNA := AIDNA.Create;
    Forms.Add(myDNA);
  end;
end;

// ----------------------------------------------------------------------------
// loads DNA ini files
procedure AIThingList.LoadForms;
var
  myDNA: AIDNA;
  i: integer;
  myFileName: string;
begin
  for i := 0 to cLastThing do
  begin
    myDNA := AIDNA(Forms.Items[i]);
    myFileName := 'data\' + ThingName(i) + '.ini';
    if FileExists(myFileName) then
      myDNA.LoadFromINI(myFileName);
  end;
end;

// ----------------------------------------------------------------------------
function AIThingList.CanTreeGrowHere(aPosition: AIPosition): boolean;
begin
  result := (not gThings.Tables[cOrangeTree].HasKindWithinXY(cOrangeTree, aPosition.X, aPosition.Y, 5))
    and (not gThings.Tables[cAppleTree].HasKindWithinXY(cAppleTree, aPosition.X, aPosition.Y, 5))
    and (not gThings.Tables[cEvolvingTree].HasKindWithinXY(cEvolvingTree, aPosition.X, aPosition.Y, 5))
    and (not gThings.Tables[cFireTree].HasKindWithinXY(cFireTree, aPosition.X, aPosition.Y, 5));
end;

// ----------------------------------------------------------------------------
function AIThing.HasDNA: boolean;
begin
  result := false;
end;

// ----------------------------------------------------------------------------
function AIThing.GetDNA: pointer;
begin
  result := nil;
end;

// ----------------------------------------------------------------------------
function AIThing.IsPlant: boolean;
begin
  result := false;
end;

// ----------------------------------------------------------------------------
function AIThing.IsFruit: boolean;
begin
  result := false;
end;

// ----------------------------------------------------------------------------
function AIThing.IsPrey: boolean;
begin
  result := false;
end;

// ----------------------------------------------------------------------------
function AIThing.IsPredator: boolean;
begin
  result := false;
end;

// ----------------------------------------------------------------------------
procedure AIThing.OnCollide(aCollider: AIThing);
begin
  // do nothing
end;

// ----------------------------------------------------------------------------
// this system uses two forces:
//  - repulsion: objects will repulse other objects when they are colliding
//  - kinetic collision: kinetic energy and mass is used to distribute forces 
procedure AIThingList.CheckCollisions;
var
  myPos1, myPos2: AIPosition;
  i, j: integer;
  n1, n2, v1, v2, c1, c2, r1, r2: TAffineVector;
  overlap: single;
begin
  for i := 0 to gThings.Colliders.Count-1 do
  begin
    myPos1 := AIThing(gThings.Colliders.Items[i]).Position;
    for j := i+1 to gThings.Colliders.Count-1 do
    begin
      myPos2 := AIThing(gThings.Colliders.Items[j]).Position;
      if i<>j then
      begin
        // true if collided (sphere vs sphere)
        if VectorDistance2(myPos1.AsAffineVector, myPos2.AsAffineVector)
           <= Sqr(myPos1.SizeY/2 + myPos2.SizeY/2) then
        begin
          // velocities of both objects
          v1 := myPos1.Velocity.AsAffineVector;
          v2 := myPos2.Velocity.AsAffineVector;
          // amount of repulsion overlap
          overlap := (myPos1.SizeY/2+myPos2.SizeY/2) - myPos1.DistancePlusHeightTo(myPos2);
          // calculate the normal directions from each object to the other object
          // first normal
          n1.X:=myPos1.X-myPos2.X;
          n1.Y:=myPos1.Y-myPos2.Y;
          n1.Z:=myPos1.Height-myPos2.Height;
          // second normal
          n2.X:=myPos2.X-myPos1.X;
          n2.Y:=myPos2.Y-myPos1.Y;
          n2.Z:=myPos2.Height-myPos1.Height;
          // check for duplicate positions
          if (n1.X=0) and (n1.Y=0) and (n1.Z=0) then
          begin
            n1.X:=RandomSwing;
            n1.Y:=RandomSwing;
            n1.Z:=RandomSwing;
            n2.X:=-n1.X; n2.Y:=-n1.Y; n2.Z:=-n1.Z;
          end;
          // normalize both normals
          n1 := VectorNormalize(n1);
          n2 := VectorNormalize(n2);
          // basic repulsion force
          r1 := VectorScale(n1, overlap);
          r2 := VectorScale(n2, overlap);
          // calculate the kinetic collision force for Pos1
          c1 := VectorCombine(v2, v1, 2*myPos2.Mass, myPos1.Mass-myPos2.Mass);
          c1 := VectorScale(c1, 1.0/(myPos1.Mass+myPos2.Mass));
          // calculate the kinetic collision force for Pos2
          c2 := VectorCombine(v1, v2, 2*myPos1.Mass, myPos2.Mass-myPos1.Mass);
          c2 := VectorScale(c2, 1.0/(myPos1.Mass+myPos2.Mass));
          // scale the force down
          c1 := VectorScale(c1, 0.1);
          c2 := VectorScale(c2, 0.1);
          // apply the repulsion force
          myPos1.Acceleration.ApplyForce(r1);
          myPos2.Acceleration.ApplyForce(r2);
          // apply the collision force
          myPos1.Acceleration.ApplyForce(c1);
          myPos2.Acceleration.ApplyForce(c2);
          // call smash code
          AIThing(gThings.Colliders.Items[i]).OnCollide(AIThing(gThings.Colliders.Items[j]));
          AIThing(gThings.Colliders.Items[j]).OnCollide(AIThing(gThings.Colliders.Items[i]));
        end;
      end;
    end;
  end;
end;

// ----------------------------------------------------------------------------
function AIThing.Play(aPlaymate: AIThing): integer;
begin
  result := aPlaymate.Tickle;
  if (aPlaymate.Kind = Kind) then result := 5;
  if (aPlaymate = self) then result := 0;
end;

// ----------------------------------------------------------------------------
function AIThing.Tickle: integer;
begin
  result := 1;
end;

// ----------------------------------------------------------------------------
procedure AIThingList.DisplayCounts(aList: TStrings);
var
  i: integer;
begin
  aList.Add('THING COUNTERS');
  aList.Add('------------------');
  for i:=0 to cLastThing do
    aList.Add(ThingNamePlural(i) + ' = ' + IntToStr(Counters[i]));
  aList.Add('------------------');
end;

// ----------------------------------------------------------------------------
procedure AIThing.Talk(aText: string; aRadius: single; aTimerDeath: integer);
var
  mySpeech: AISpeech;
begin
  if gThings.CanAdd(cSpeech) then
  begin
    mySpeech := AISpeech(gThings.NewThing(cSpeech));
    mySpeech.Position.CopyCoords(Position);
    mySpeech.Position.Height := mySpeech.Position.Height + Position.SizeH;
    mySpeech.Text := aText;
    mySpeech.Radius := aRadius;
    mySpeech.TimerDeath := aTimerDeath;
  end;
end;

// ----------------------------------------------------------------------------
procedure AIThing.Report;
begin
  Talk(OneLineDisplay, 10, 32);
end;

end.

