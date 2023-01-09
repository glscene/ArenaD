{
  ai.planet
  http://aiplanet.sourceforge.net
  Created by Dave Kerr (kerrd@hotmail.com)
}
unit cAIEvolvingTrees;

interface

uses
  System.Classes,
  System.SysUtils,
  System.Contnrs,
  cAIBaseObject,
  cAISpace,
  cAIThings,
  cAILife,
  cAIDNA,
  cAITrees;

type

// ============================================================================
AIEvolvingPlant = Class(AIPlant)
private
  fDNA: AIDNA;
public
  // create and delete
  Constructor Create(aParent: pointer);
  Destructor Destroy; override;

  property DNA: AIDNA read fDNA;

  // DNA access     
  function HasDNA: boolean; override;
  function GetDNA: pointer; override;
  // file load/save routines
  procedure SaveToFile(var aFile: TextFile); override;
  procedure LoadFromFile(var aFile: TextFile); override;
  // display routines
  function OneLineDisplay: string; override;
  procedure FullDisplay(aList: TStrings); override;
end;

// ============================================================================
AIEvolvingTree = Class(AIEvolvingPlant)
private
  fFruitTimer: integer;
  procedure BearFruit;
public
  Constructor Create(aParent: pointer);

  procedure Fuel; override;
  procedure Cease; override;
  procedure Perform(aActivity: integer); override;
  function Digest(const aAmount: integer): integer; override;

  procedure FullDisplay(aList: TStrings); override;
  procedure SaveToFile(var aFile: TextFile); override;
  procedure LoadFromFile(var aFile: TextFile); override;
end;

// ============================================================================
AIEvolvingFruit = Class(AIEvolvingPlant)
private
  fCarryingSeed: boolean;
  procedure DropSeed;
public
  Constructor Create(aParent: pointer);
  property CarryingSeed: boolean read fCarryingSeed write fCarryingSeed;
  procedure Fuel; override;
  procedure Cease; override;
  function IsFruit: boolean; override;
  procedure FullDisplay(aList: TStrings); override;
  procedure SaveToFile(var aFile: TextFile); override;
  procedure LoadFromFile(var aFile: TextFile); override;
end;

// ============================================================================
AIEvolvingSeed = Class(AIEvolvingPlant)
private
  procedure Sprout;
public
  Constructor Create(aParent: pointer);
  function Digest(const aAmount: integer): integer; override;
  procedure Fuel; override;
  procedure Cease; override;
end;

implementation

uses
  cAIReality,
  cAIEnvironment,
  cAIGrid,
  cUtilities,
  cAIVibes,
  cGlobals,
  cAIPosition;

// ----------------------------------------------------------------------------
Constructor AIEvolvingPlant.Create(aParent: pointer);
begin
  inherited Create(aParent);

  fDNA := AIDNA.Create;
  fDNA.CopyFrom(AIDNA(gThings.Forms.Items[Kind]));
end;

// ----------------------------------------------------------------------------
Destructor AIEvolvingPlant.Destroy;
begin
  fDNA.Free;

  inherited Destroy;
end;

// ----------------------------------------------------------------------------
procedure AIEvolvingPlant.SaveToFile(var aFile: TextFile);
begin
  inherited SaveToFile(aFile);

  DNA.SaveToFile(aFile);
end;

// ----------------------------------------------------------------------------
procedure AIEvolvingPlant.LoadFromFile(var aFile: TextFile);
begin
  inherited LoadFromFile(aFile);

  DNA.LoadFromFile(aFile);
end;

// ----------------------------------------------------------------------------
function AIEvolvingPlant.OneLineDisplay: string;
begin
  result := inherited OneLineDisplay;
end;

// ----------------------------------------------------------------------------
procedure AIEvolvingPlant.FullDisplay(aList: TStrings);
begin
  inherited FullDisplay(aList);

  DNA.FullDisplay(aList);
end;

// ----------------------------------------------------------------------------
function AIEvolvingPlant.HasDNA: boolean;
begin
  result := true;
end;

// ----------------------------------------------------------------------------
function AIEvolvingPlant.GetDNA: pointer;
begin
  result := fDNA;
end;

// ----------------------------------------------------------------------------
Constructor AIEvolvingTree.Create(aParent: pointer);
begin
  Kind := cEvolvingTree;

  inherited Create(aParent);

  fFruitTimer := 256;
  Water := Random*1;
  Health := 64;
  Position.DirectionXY := Random*TwoPi;
  Position.SetPosition(Random(10), Random(10), 15);
  Position.SetSize(0.5, 0.5, 1, true);
  Position.SetProperties(4, 0.1, 0);
  Position.Collider := false;
end;

// ----------------------------------------------------------------------------
procedure AIEvolvingTree.Fuel;
begin
  inherited Fuel;

  // face wind direction
//  if AIGrid(Position.Location).Windy then Position.TurnTowardsVector(AIGrid(Position.Location).Wind, ca1);

  // suck water from land
  if (Water < 1.5) and (AIGrid(Position.Location).Water > 0.005)
      and not (Position.Underwater) and (Position.Binding = bindLand) then
  begin
    gSpace.QueueChange(Position.Location, cEventAddWater, -0.005);
    Water := Water + 0.005; // modify to be put into an event!!!
  end;

  // bear fruit
  if (Age > fFruitTimer) then//and (AIGrid(Position.Location).Temperature > 5) then
  begin
    if (Water > 0.25) then
      BearFruit;
    fFruitTimer := Age + (Random(128)+64);
    gSpace.QueueChange(Position.Location, cEventAddHumidity, 0.2);
    Water := Water - 0.2;
  end;

  // die
  if (Age > 3000) or (Water <= 0) then
    Die;

  // increase health if all is good
  if (Position.Binding = bindLand) and not (Position.UnderWater) then
    Health := Health + 1;
end;

// ----------------------------------------------------------------------------
procedure AIEvolvingTree.BearFruit;
var
  myFruit: AIEvolvingFruit;
begin
  myFruit := AIEvolvingFruit(gThings.NewThing(cEvolvingFruit));

  if Assigned(myFruit) then
  begin
    Noise(cNoisePop, 1);
    myFruit.DNA.CopyFrom(DNA);
    myFruit.DNA.Red := myFruit.DNA.Red + RandomPolarity * myFruit.DNA.Mutation;
    myFruit.DNA.Blue := myFruit.DNA.Blue + RandomPolarity * myFruit.DNA.Mutation;
    myFruit.DNA.Green := myFruit.DNA.Green + RandomPolarity * myFruit.DNA.Mutation;
    myFruit.DNA.Buoyancy := myFruit.DNA.Buoyancy + RandomPolarity * myFruit.DNA.Mutation;
    myFruit.DNA.Bounce := myFruit.DNA.Bounce + RandomPolarity * myFruit.DNA.Mutation;
    // set colors to match values
//    myFruit.DNA.Blue := myFruit.DNA.Buoyancy;
//    myFruit.DNA.Green := myFruit.DNA.Bounce;
    myFruit.Position.Buoyancy := myFruit.DNA.Buoyancy;
    myFruit.Position.Bounce := myFruit.DNA.Bounce;
    myFruit.CarryingSeed := true;
    myFruit.Position.CopyCoords(Position);
    myFruit.Position.Height := Position.Height + (7.5/2 * Water);
    myFruit.Position.Acceleration.SetAngularForce(Random * TwoPi, Random * HalfPi, 0.01 + Random * 0.25);
    myFruit.Health := Random(Age) + 256;
  end;
end;

// ----------------------------------------------------------------------------
procedure AIEvolvingTree.Perform(aActivity: integer);
begin
  BearFruit;
end;

// ----------------------------------------------------------------------------
procedure AIEvolvingTree.Cease;
begin
  if Exists then
  begin
    if Water > 0 then
      gSpace.QueueChange(Position.Location, cEventAddWater, Water);
    Noise(cNoiseForest, 1);
  end;

  inherited Cease;
end;

// ----------------------------------------------------------------------------
Constructor AIEvolvingFruit.Create(aParent: pointer);
begin
  Kind := cEvolvingFruit;

  inherited Create(aParent);

  Health := 1024;
  CarryingSeed := false;
  Position.DirectionXY := Random*TwoPi;
  Position.SetSize(0.3, 0.3, 0.3, true);
  Position.SetProperties(1, DNA.Bounce, DNA.Buoyancy);

  DNA.Red := Random+0.2;
  DNA.Green := Random+0.2;
  DNA.Blue := Random+0.2;
end;

// ----------------------------------------------------------------------------
procedure AIEvolvingFruit.Fuel;
begin
  inherited Fuel;

//  if Health < 1024 then Health := 1024; // this makes the fruit invincible

  if Health <= 0 then
    Cease;
end;

// ----------------------------------------------------------------------------
procedure AIEvolvingFruit.Cease;
begin
  if Exists and CarryingSeed then
    DropSeed;

  inherited Cease;
end;

// ----------------------------------------------------------------------------
procedure AIEvolvingFruit.DropSeed;
var
  mySeed: AIEvolvingSeed;
begin
  mySeed := AIEvolvingSeed(gThings.NewThing(cEvolvingSeed));

  if Assigned(mySeed) then
  begin
    mySeed.DNA.CopyFrom(DNA);
    mySeed.Position.Buoyancy := mySeed.DNA.Buoyancy;
    mySeed.Position.Bounce := mySeed.DNA.Bounce;
    mySeed.Position.CopyCoords(Position);
    mySeed.Position.Velocity.CopyFrom(Position.Velocity);
    mySeed.Position.Acceleration.CopyFrom(Position.Acceleration);
  end;

  fCarryingSeed := false;
end;

// ----------------------------------------------------------------------------
Constructor AIEvolvingSeed.Create(aParent: pointer);
begin
  Kind := cEvolvingSeed;

  inherited Create(aParent);

  Health := 512;
  Position.DirectionXY := Random*TwoPi;
  Position.SetSize(0.1, 0.1, 0.1, true);
  Position.SetProperties(1, DNA.Bounce, DNA.Buoyancy);

  DNA.Red := Random;
  DNA.Green := Random;
  DNA.Blue := Random;
end;

// ----------------------------------------------------------------------------
procedure AIEvolvingSeed.Fuel;
begin
  inherited Fuel;

  if Age > 512 then
    Cease;
end;

// ----------------------------------------------------------------------------
procedure AIEvolvingSeed.Cease;
begin
  if Exists then
  begin
    if (Position.Binding = bindLand) and not (Position.UnderWater) and (AIGrid(Position.Location).Water >= 0.5) then
      Sprout;
  end;
  
  inherited Cease;
end;

// ----------------------------------------------------------------------------
procedure AIEvolvingSeed.Sprout;
var
  myTree: AIEvolvingTree;
//  myLocation: AIGrid;
begin
  myTree := nil;

  Noise(cNoiseCricket, 1);

//  myLocation := Position.Location;
  // must be warm
//  if myLocation.Temperature < 2 then
//    exit;
  // must be on land
  if Position.Binding <> bindLand then
    exit;

  if gThings.CanTreeGrowHere(Position) then
    myTree := AIEvolvingTree(gThings.NewThing(cEvolvingTree));

  if Assigned(myTree) then
  begin
    myTree.DNA.CopyFrom(DNA);
    myTree.Position.CopyCoords(Position);
    myTree.Water := 0.01;
  end;
end;

// ----------------------------------------------------------------------------
procedure AIEvolvingFruit.SaveToFile(var aFile: TextFile);
begin
  inherited SaveToFile(aFile);
  writeFileBoolean(aFile, fCarryingSeed);
end;

// ----------------------------------------------------------------------------
procedure AIEvolvingFruit.LoadFromFile(var aFile: TextFile);
begin
  inherited LoadFromFile(aFile);
  fCarryingSeed := readFileBoolean(aFile);
end;

// ----------------------------------------------------------------------------
procedure AIEvolvingTree.SaveToFile(var aFile: TextFile);
begin
  inherited SaveToFile(aFile);
  writeln(aFile, fFruitTimer);
end;

// ----------------------------------------------------------------------------
procedure AIEvolvingTree.LoadFromFile(var aFile: TextFile);
begin
  inherited LoadFromFile(aFile);
  readln(aFile, fFruitTimer);
end;

// ----------------------------------------------------------------------------
procedure AIEvolvingTree.FullDisplay(aList: TStrings);
begin
  inherited FullDisplay(aList);

  aList.Add('FruitTimer: ' + IntToStr(fFruitTimer));
end;

// ----------------------------------------------------------------------------
procedure AIEvolvingFruit.FullDisplay(aList: TStrings);
begin
  inherited FullDisplay(aList);

  aList.Add('CarryingSeed: ' + BoolToYesNoStr(fCarryingSeed));
end;

// ----------------------------------------------------------------------------
function AIEvolvingTree.Digest(const aAmount: integer): integer;
begin
  result := -1 * inherited Digest(aAmount);
end;

// ----------------------------------------------------------------------------
function AIEvolvingSeed.Digest(const aAmount: integer): integer;
begin
  inherited Digest(aAmount);
  result := 0;
end;

// ----------------------------------------------------------------------------
function AIEvolvingFruit.IsFruit: boolean;
begin
  result := true;
end;

end.

