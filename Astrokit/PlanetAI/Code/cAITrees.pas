{
  ai.planet
  http://aiplanet.sourceforge.net
  Created by Dave Kerr (kerrd@hotmail.com)
  $Id: cAITrees.pas,v 1.39 2003/09/25 19:46:18 uid105088 Exp $
}
unit cAITrees;

interface

uses System.Classes, cAIBaseObject, cAISpace, cAIThings, cAILife;

const
  cTreeSapling = 0;
  cTreeFlowering = 64;
  cTreeTeenager = 128;
  cTreeAdult = 256;
  cTreeDeath = 2560;

  cFruitDeath = 256;
  cSeedSprout = 256+128;

type

// ============================================================================
AIPlant = Class(AILivingThing)
public
  function IsPlant: boolean; override;
end;

// ============================================================================
AITree = Class(AIPlant)
private
  fFruitTimer: integer;

  procedure BearFruit;
public
  Constructor Create(aParent: pointer);

  property FruitTimer: integer read fFruitTimer write fFruitTimer;

  procedure Fuel; override;
  procedure Cease; override;
  procedure Perform(aActivity: integer); override;
  function Digest(const aAmount: integer): integer; override;

  procedure FullDisplay(aList: TStrings); override;
  procedure SaveToFile(var aFile: TextFile); override;
  procedure LoadFromFile(var aFile: TextFile); override;
end;

// ============================================================================
AIFruit = Class(AIPlant)
private
  fCarryingSeed: boolean;

  procedure DropSeed;
public
  property CarryingSeed: boolean read fCarryingSeed write fCarryingSeed;

  procedure Fuel; override;
  procedure Cease; override;
  function IsFruit: boolean; override;

  procedure FullDisplay(aList: TStrings); override;
  procedure SaveToFile(var aFile: TextFile); override;
  procedure LoadFromFile(var aFile: TextFile); override;
end;

// ============================================================================
AISeed = Class(AIPlant)
private
  procedure Sprout;
public
  function Digest(const aAmount: integer): integer; override;
  procedure Fuel; override;
  procedure Cease; override;
end;

// ============================================================================
AIAquaPlant = Class(AIPlant)
private
  fFruitTimer: integer;
  procedure BearFruit;
public
  Constructor Create(aParent: pointer);

  property FruitTimer: integer read fFruitTimer write fFruitTimer;

  function Digest(const aAmount: integer): integer; override;
  procedure Fuel; override;
  procedure Perform(aActivity: integer); override;

  procedure FullDisplay(aList: TStrings); override;
  procedure SaveToFile(var aFile: TextFile); override;
  procedure LoadFromFile(var aFile: TextFile); override;
end;

implementation

uses
  cAIReality, cAIEnvironment, System.SysUtils, cAIGrid, cUtilities, cAIVibes, cGlobals,
  cAIPosition;

// ----------------------------------------------------------------------------
Constructor AITree.Create(aParent: pointer);
begin
  inherited Create(aParent);

  fFruitTimer := cTreeAdult;
  Water := Random*1;
  Health := 64;
  Position.DirectionXY := Random*TwoPi;
  Position.Collider := false;
end;

// ----------------------------------------------------------------------------
procedure AITree.Fuel;
begin
  inherited Fuel;

  // turn towards wind
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
  if (Age > cTreeDeath) or (Water <= 0) then
    Die;

  // increase health if all is good
  if (Position.Binding = bindLand) and not (Position.UnderWater) then
    Health := Health + 1;
end;

// ----------------------------------------------------------------------------
procedure AITree.BearFruit;
var
  myFruit: AIFruit;
begin
  if Kind = cAppleTree then
    myFruit := AIFruit(gThings.NewThing(cApple))
  else
    myFruit := AIFruit(gThings.NewThing(cOrange));

  if Assigned(myFruit) then
  begin
    Noise(cNoisePop, 1);
    myFruit.CarryingSeed := true;
    myFruit.Position.CopyCoords(Position);
    myFruit.Position.Height := Position.Height + (7.5/2 * Water);
    myFruit.Position.Acceleration.SetAngularForce(Random * TwoPi, Random * HalfPi, 0.01 + Random * 0.25);
    myFruit.Health := Random(Age) + 256;
  end;
end;

// ----------------------------------------------------------------------------
procedure AITree.Perform(aActivity: integer);
begin
  BearFruit;
end;

// ----------------------------------------------------------------------------
procedure AITree.Cease;
begin
  if Exists then
  begin
    if (Water > 0) then
      gSpace.QueueChange(Position.Location, cEventAddWater, Water);
    Noise(cNoiseForest, 1);
  end;

  inherited Cease;
end;

// ----------------------------------------------------------------------------
procedure AIFruit.Fuel;
begin
  inherited Fuel;

//  if Health < 1024 then Health := 1024; // this makes the fruit invincible

  if Health <= 0 then
    Cease;
end;

// ----------------------------------------------------------------------------
procedure AIFruit.Cease;
begin
  if CarryingSeed then
    DropSeed;

  inherited Cease;
end;

// ----------------------------------------------------------------------------
procedure AIFruit.DropSeed;
var
  mySeed: AISeed;
begin
  if Kind = cApple then
    mySeed := AISeed(gThings.NewThing(cAppleSeed))
  else //orange
    mySeed := AISeed(gThings.NewThing(cOrangeSeed));

  if Assigned(mySeed) then
  begin
    mySeed.Position.CopyCoords(Position);
    mySeed.Position.Velocity.CopyFrom(Position.Velocity);
    mySeed.Position.Acceleration.CopyFrom(Position.Acceleration);
  end;

  fCarryingSeed := false;
end;

// ----------------------------------------------------------------------------
procedure AISeed.Fuel;
begin
  inherited Fuel;

  if Age > cSeedSprout then
    Cease;
end;

// ----------------------------------------------------------------------------
procedure AISeed.Cease;
begin
  if Exists then
  begin
    if (Position.Binding = bindLand) and not (Position.UnderWater) and (AIGrid(Position.Location).Water >= 0.5) then
      Sprout;
  end;

  inherited Cease;
end;

// ----------------------------------------------------------------------------
procedure AISeed.Sprout;
var
  myTree: AITree;
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

    if Kind = cAppleSeed then
    begin
      if gThings.CanTreeGrowHere(Position) then
        myTree := AIGrid(Position.Location).NewThing(cAppleTree);
    end;

    if Kind = cOrangeSeed then
    begin
      if gThings.CanTreeGrowHere(Position) then
        myTree := AIGrid(Position.Location).NewThing(cOrangeTree);
    end;

    if Assigned(myTree) then
    begin
      myTree.Position.CopyCoords(Position);
      myTree.Water := 0.01;
    end;
end;

// ----------------------------------------------------------------------------
procedure AIFruit.SaveToFile(var aFile: TextFile);
begin
  inherited SaveToFile(aFile);
  writeFileBoolean(aFile, fCarryingSeed);
end;

// ----------------------------------------------------------------------------
procedure AIFruit.LoadFromFile(var aFile: TextFile);
begin
  inherited LoadFromFile(aFile);
  fCarryingSeed := readFileBoolean(aFile);
end;

// ----------------------------------------------------------------------------
function AIFruit.IsFruit: boolean;
begin
  result := true;
end;

// ----------------------------------------------------------------------------
procedure AITree.SaveToFile(var aFile: TextFile);
begin
  inherited SaveToFile(aFile);
  writeln(aFile, fFruitTimer);
end;

// ----------------------------------------------------------------------------
procedure AITree.LoadFromFile(var aFile: TextFile);
begin
  inherited LoadFromFile(aFile);
  readln(aFile, fFruitTimer);
end;

// ----------------------------------------------------------------------------
procedure AITree.FullDisplay(aList: TStrings);
begin
  inherited FullDisplay(aList);
  aList.Add('FruitTimer: ' + IntToStr(fFruitTimer));
end;

// ----------------------------------------------------------------------------
procedure AIFruit.FullDisplay(aList: TStrings);
begin
  inherited FullDisplay(aList);

  aList.Add('CarryingSeed: ' + BoolToYesNoStr(fCarryingSeed));
end;

// ----------------------------------------------------------------------------
Constructor AIAquaPlant.Create(aParent: pointer);
begin
  inherited Create(aParent);

  Kind := cAquaPlant;
  Health := 32;
  Position.Mass := 100;
  Position.DirectionXY := Random*TwoPi;
  fFruitTimer := gReality.Time + Random(256);
  Position.Collider := false;
  Position.DirectionH := 0;
end;

// ----------------------------------------------------------------------------
procedure AIAquaPlant.Fuel;
begin
  inherited Fuel;

  // face water direction
//  if AIGrid(Position.Location).Wavy then Position.TurnTowardsVector(AIGrid(Position.Location).Wave, ca1);

  if gReality.Time > fFruitTimer then
  begin
    BearFruit;
    fFruitTimer := gReality.Time + 256;
  end;

  // increase health if all is good
  if (Position.UnderWater) then
    Health := Health + 1;
end;

// ----------------------------------------------------------------------------
procedure AIAquaPlant.BearFruit;
var
  myFruit: AIFruit;
begin
  if Random(3) = 0 then
    myFruit := AIFruit(gThings.NewThing(cApple))
  else
    myFruit := AIFruit(gThings.NewThing(cOrange));

  if Assigned(myFruit) then
  begin
    Noise(cNoisePop, 1);
    myFruit.CarryingSeed := false;
    myFruit.Position.CopyCoords(Position);
    myFruit.Position.Height := Position.Height;
    myFruit.Position.Acceleration.SetAngularForce(Random * TwoPi, Random * HalfPi, 0.05 + Random * 0.25);
    myFruit.Health := 1024 + Random(1024);
  end;
end;

// ----------------------------------------------------------------------------
procedure AIAquaPlant.Perform(aActivity: integer);
begin
  BearFruit;
end;

// ----------------------------------------------------------------------------
function AITree.Digest(const aAmount: integer): integer;
begin
  result := -1 * inherited Digest(aAmount);
end;

// ----------------------------------------------------------------------------
function AISeed.Digest(const aAmount: integer): integer;
begin
  inherited Digest(aAmount);
  result := 0;
end;

// ----------------------------------------------------------------------------
function AIAquaPlant.Digest(const aAmount: integer): integer;
begin
  inherited Digest(aAmount);
  result := 0;
end;

// ----------------------------------------------------------------------------
procedure AIAquaPlant.SaveToFile(var aFile: TextFile);
begin
  inherited SaveToFile(aFile);
  writeln(aFile, fFruitTimer);
end;

// ----------------------------------------------------------------------------
procedure AIAquaPlant.LoadFromFile(var aFile: TextFile);
begin
  inherited LoadFromFile(aFile);
  readln(aFile, fFruitTimer);
end;

// ----------------------------------------------------------------------------
procedure AIAquaPlant.FullDisplay(aList: TStrings);
begin
  inherited FullDisplay(aList);
  aList.Add('FruitTimer: ' + IntToStr(fFruitTimer));
end;

// ----------------------------------------------------------------------------
function AIPlant.IsPlant: boolean;
begin
  result := true;
end;

end.

