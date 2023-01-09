{
  ai.planet
  http://aiplanet.sourceforge.net
  Created by Dave Kerr (kerrd@hotmail.com)

  Base class for creatures
    - parts (grabber, eyes, desire)
    - abilities (grab, drop, kick, use, etc)
    - ai (forage, etc)
}
unit cAICreature;

interface

uses
  System.Classes,
  System.Types,
  System.Contnrs,
  cAIThings,
  cAILife,
  cAILink;

const
  cDesireNone = 0;
  cDesireFood = 1;
  cDesireWander = 2;
  cDesireEat = 3;
  cDesireMate = 4;
  cDesireLand = 5;
  cDesireRetire = 6;  // old age
  cDesirePlay = 7;

type

// ============================================================================
AICreature = Class(AILivingThing)
private
  fGrabber: AIAttachment;   // used to pick things up
  fEyes: AILink;            // used to focus attention
  fNextActivity: integer;
  fDesire: integer;
  fSize: single;
protected
  procedure Grow(aAmount: single); virtual;
public
  Constructor Create(aParent: pointer);
  Destructor Destroy; override;

  property Grabber: AIAttachment read fGrabber;
  property Eyes: AILink read fEyes;
  property Desire: integer read fDesire write fDesire;
  property NextActivity: integer read fNextActivity write fNextActivity;
  property Size: single read fSize write fSize;

  // Actions
  function Eat(const JawSize: integer): boolean; virtual;
  procedure Grab(aTarget: AIThing); overload;
  procedure Grab; overload;
  procedure Drop;
  procedure Bonk(aTarget: AIThing); overload;
  procedure Bonk; overload;
  procedure Use(aSwitch: integer);
  procedure Kick(aTarget: AIThing; aStrength: single); overload;
  procedure Kick(aStrength: single); overload;
  procedure KickReturn;
  procedure KickTowards(aTarget, aDestination: AIThing; aMaxStrength: single);
  procedure Throw;
  procedure Give(aCreature: AICreature); overload;
  procedure Give; overload;
  procedure Attack(aAmount: integer; aTarget: AIThing);
  function CloseEnoughToGrab(aThing: AIThing): boolean;

  // AI Code
  procedure Forage(aSpeed: single); overload;
  procedure Forage(aKind: integer; aSpeed: single); overload;
  procedure ForageFruitAndPrey(aSpeed: single);

  procedure Cease; override;
  procedure Perform(aActivity: integer); override;

  procedure SaveToFile(var aFile: TextFile); override;
  procedure LoadFromFile(var aFile: TextFile); override;
  function OneLineDisplay: string; override;
  procedure FullDisplay(aList: TStrings); override;
end;

implementation

uses cUtilities, cGlobals, cAIVibes, cAIPosition, SysUtils;

// ----------------------------------------------------------------------------
Constructor AICreature.Create(aParent: pointer);
begin
  inherited Create(aParent);

  fGrabber := gEnvironment.Attachments.NewAttachment(self);
  fEyes := gEnvironment.References.NewLink(self);
  fNextActivity := 0;
end;

// ----------------------------------------------------------------------------
Destructor AICreature.Destroy;
begin
  gEnvironment.Attachments.Remove(fGrabber);
  gEnvironment.References.Remove(fEyes);

  inherited Destroy;
end;

// ----------------------------------------------------------------------------
procedure AICreature.Cease;
begin
  if Exists then
  begin
    Drop;
    Eyes.InvalidateTarget;
  end;

  inherited Cease;
end;

// ----------------------------------------------------------------------------
// try to pick up something
procedure AICreature.Grab(aTarget: AIThing);
begin
  // already holding something?
  if Grabber.Holding then exit;
  // grabbing itself?
  if (aTarget = self) then exit;
  // grabbing a tangible?
  if not (aTarget.Position.Tangible) then exit;
  // check to see if the target is grabbing me already (cancel if so);
  if aTarget is AICreature then
    // possible BUG SOURCE
    if AICreature(aTarget).Grabber.Holding and
      (AICreature(aTarget).Grabber.Target = self) then
      exit;
  // is it already carried?
  if aTarget.Position.Carried then exit;
  // is it close enough?
  if not CloseEnoughToGrab(aTarget) then exit;
//  and (Position.DistancePlusHeightTo(aTarget.Position) < 1.5) then
  Grabber.Attach(aTarget);
  Noise(cNoiseGrab, 1);
end;

// ----------------------------------------------------------------------------
// try to pick up something nearby
procedure AICreature.Grab;
var
  myThing: AIThing;
begin
  if Grabber.Holding then
    exit;

  myThing := AIThing(gEnvironment.Things.Existents.NearestThing(self, Position, 2.5));

  if not (myThing = nil) and not (myThing = self) then
    Grab(myThing);
end;

// ----------------------------------------------------------------------------
// drop
procedure AICreature.Drop;
var
  myThing: AIThing;
begin
  if Grabber.Holding then
  begin
    myThing := Grabber.Target;
    myThing.Position.Velocity.CopyFrom(Position.Velocity);
    myThing.Position.Acceleration.ApplyAngularForce(Position.DirectionXY, 0.05);
    Grabber.Detach;
    Noise(cNoiseDrop, 1);
  end;
end;

// ----------------------------------------------------------------------------
// give an item to another creature
procedure AICreature.Give(aCreature: AICreature);
var
  myThing: AIThing;
begin
  if Grabber.Holding then
  begin
    myThing := Grabber.Target;
    Grabber.Detach;
    Noise(cNoiseDrop, 1);

    // possible BUG SOURCE
    if not aCreature.Grabber.Holding then
      aCreature.Grab(myThing);
  end;
end;

// ----------------------------------------------------------------------------
// give an item to nearest creature
procedure AICreature.Give;
var
  myThing: AIThing;
begin
  myThing := gEnvironment.Things.Existents.NearestThing(self, Position, 2.5);
  if not (myThing = nil) then
    if myThing is AICreature then
      Give(AICreature(myThing));
end;

// ----------------------------------------------------------------------------
// hit a target
// if the target is holding something, it drops it
procedure AICreature.Bonk(aTarget: AIThing);
var
  myThing: AIThing;
begin
  Assert(Assigned(aTarget));
  if Position.DistancePlusHeightTo(aTarget.Position) < 1.5 then
  begin
    if aTarget is AICreature then
    // possible BUG SOURCE
      if AICreature(aTarget).Grabber.Holding then
      begin
        myThing := AICreature(aTarget).Grabber.Target;
        AICreature(aTarget).Grabber.Detach;
        myThing.Position.Acceleration.ApplyForce(
          Random*0.2-0.1, Random*0.2-0.1, Random*0.2);
      end;
  end;
end;

// ----------------------------------------------------------------------------
// bonk nearest thing
procedure AICreature.Bonk;
var
  myThing: AIThing;
begin
  myThing := AIThing(gEnvironment.Things.Existents.NearestThing(self, Position, 2.5));
  if not (myThing = nil) then
    Bonk(myThing);
end;

// ----------------------------------------------------------------------------
// try to eat whatever the creature is holding
function AICreature.Eat(const JawSize: integer): boolean;
var
  myThing: AIThing;
begin
  result := false;

  if Grabber.Connected and (AIThing(Grabber.Target) is AILivingThing) then
  begin
    myThing := AIThing(Grabber.Target);
    // absorb health
    Health := Health + myThing.Digest(JawSize);
    // return true if completely eaten
    if not myThing.Exists then result := true;
  end;
end;

// ----------------------------------------------------------------------------
procedure AICreature.Use(aSwitch: integer);
begin
  if Grabber.Connected then
    AIThing(Grabber.Target).Perform(aSwitch);
end;

// ----------------------------------------------------------------------------
procedure AICreature.Kick(aTarget: AIThing; aStrength: single);
begin
  if NextActivity > Age then
    exit;

  aTarget.Position.Acceleration.ApplyAngularForce(
    Position.DirectionXY, 0.5, aStrength);
  aTarget.Noise(cNoiseKick, 1);

  NextActivity := Age + 8;
end;

// ----------------------------------------------------------------------------
procedure AICreature.Kick(aStrength: single);
var
  myThing: AIThing;
begin
  if NextActivity > Age then
    exit;

  // kick what creature is holding
  if Grabber.Holding then
  begin
    myThing := Grabber.Target;
    Drop;
  end
  // if not holding, then kick nearest thing
  else
    myThing := gEnvironment.Things.Existents.NearestThing(self, Position, 2.0);

  // kick em if you got em
  if not (myThing = nil) then
    Kick(myThing, aStrength);
end;

// ----------------------------------------------------------------------------
procedure AICreature.Throw;
var
  myThing: AIThing;
begin
  if Grabber.Holding then
  begin
    myThing := Grabber.Target;
    myThing.Position.Acceleration.ApplyAngularForce(Position.DirectionXY, 0.5, 0.5);
    Drop;
  end;
end;

// ----------------------------------------------------------------------------
procedure AICreature.Perform(aActivity: integer);
begin
  case aActivity of
    0: Grab;
    1: Use(0);
    2: Kick(0.25);
    3: Drop;
    4: Give;
  end;
end;

// ----------------------------------------------------------------------------
// find and grab food
procedure AICreature.Forage(aSpeed: single);
var
  myThing: AIThing;
begin
  if not Grabber.Holding then
  begin
    // check validity of sight
    if Eyes.ValidTarget then
    begin
      myThing := Eyes.Target;

      // see if another creature got the apple
      if myThing.Position.Carried
      // make sure we are looking at an apple
      or not (myThing.IsFruit) then
        Eyes.InvalidateTarget;
    end;

    // an apple is in sight
    if Eyes.ValidTarget then
    begin
      myThing := Eyes.Target;
      // face the apple and move towards it
      Position.TurnTowardsTarget(myThing.Position, ca30);
      if Position.Velocity.XYStrength < aSpeed then
        Position.Acceleration.ApplyAngularForce(Position.DirectionXY, aSpeed);
      // grab the apple
      if CloseEnoughToGrab(myThing) then
        Grab(myThing);
    end
    else // dont see an apple, try to find an apple
      Eyes.AssignTarget(gEnvironment.Things.Fruits.NearestAvailableThing(Position));
  end;
end;

// ----------------------------------------------------------------------------
// find and grab food
procedure AICreature.Forage(aKind: integer; aSpeed: single);
var
  myThing: AIThing;
begin
  if not Grabber.Holding then
  begin
    // check validity of sight
    if Eyes.ValidTarget then
    begin
      myThing := Eyes.Target;

      // see if another creature got the apple
      if myThing.Position.Carried
      // make sure we are looking at an apple
      or not (myThing.Kind = aKind) then
        Eyes.InvalidateTarget;
    end;

    // an apple is in sight
    if Eyes.ValidTarget then
    begin
      myThing := Eyes.Target;
      // grab the apple
      if CloseEnoughToGrab(myThing) then
        Grab(myThing)
      else // go to it
      begin
        Position.TurnTowardsTarget(myThing.Position, ca30);
        if Position.Velocity.XYStrength < aSpeed then
          Position.Acceleration.ApplyAngularForce(Position.DirectionXY, aSpeed);
        if Position.Height > myThing.Position.Height then
          Position.Acceleration.DeltaHeight := Position.Acceleration.DeltaHeight - aSpeed
        else
        if (Position.Height < myThing.Position.Height) and Position.Underwater then
          Position.Acceleration.DeltaHeight := Position.Acceleration.DeltaHeight + aSpeed;
      end;
    end
    else // dont see an apple, try to find an apple
      Eyes.AssignTarget(gEnvironment.Things.Tables[aKind].NearestAvailableOfKind(aKind, Position, 10000));
  end;
end;

// ----------------------------------------------------------------------------
procedure AICreature.KickTowards(aTarget, aDestination: AIThing; aMaxStrength: single);
var
  myStrength: single;
  myDistance: single;
  myStep: single;
begin
  if NextActivity > Age then
    exit;

  aTarget.Position.FaceTarget(aDestination.Position);

  // find distance to target
  myDistance := aTarget.Position.DistanceTo(aDestination.Position);

  // calculate amount of "time" to target
  myStep := 64.0;
  if myDistance < 5 then
    myStep := 16.0;

  // find the velocity
  myStrength := myDistance / myStep;
  // account for wind resistance
  myStrength := myStrength + (myStrength * 0.01) * (myStep * 0.75);
  // limit strength
  if myStrength > aMaxStrength then
    myStrength := aMaxStrength;

  // apply lift force
  aTarget.Position.Velocity.ApplyForce(0, 0, gGravity.DeltaHeight * (myStep / -2.0));
  // apply directional force
  aTarget.Position.Velocity.ApplyAngularForce(
    aTarget.Position.DirectionXY,
    myStrength);

  // noise
  aTarget.Noise(cNoiseKick, 1);

  NextActivity := Age + 8;
end;

// ----------------------------------------------------------------------------
procedure AICreature.KickReturn;
var
  myCreature: AICreature;
  myThing: AIThing;
begin
  if NextActivity > Age then
    exit;

  myCreature := AICreature(gEnvironment.Things.Existents.NearestOfKind(Kind, Position, 200));
  myThing := gEnvironment.Things.Existents.NearestThing(self, Position, 2.0);

  if not (myCreature = nil) and not (myThing = nil) then
  begin
    if Grabber.Holding then
      Drop;
    KickTowards(myThing, myCreature, 0.4);
  end;
end;

// ----------------------------------------------------------------------------
procedure AICreature.SaveToFile(var aFile: TextFile);
begin
  inherited SaveToFile(aFile);
  writeln(aFile, fNextActivity);
  writeln(aFile, fDesire);
  writeln(aFile, fSize);
  fGrabber.SaveToFile(aFile);
  fEyes.SaveToFile(aFile);
end;

// ----------------------------------------------------------------------------
procedure AICreature.LoadFromFile(var aFile: TextFile);
begin
  inherited LoadFromFile(aFile);
  readln(aFile, fNextActivity);
  readln(aFile, fDesire);
  readln(aFile, fSize);
  fGrabber.LoadFromFile(aFile);
  fEyes.LoadFromFile(aFile);
end;

// ----------------------------------------------------------------------------
function AICreature.OneLineDisplay: string;
begin
  result := GetName
    + Format(' %d Health=%d Water=%0.2f Desire=%d-', [Handle, Health, Water, fDesire]);

  case fDesire of
    cDesireNone: result := result + 'None ';
    cDesireFood: result := result + 'Food ';
    cDesireWander: result := result + 'Wander ';
    cDesireMate: result := result + 'Mate ';
    cDesireEat: result := result + 'Eat ';
    cDesireLand: result := result + 'Land ';
    cDesireRetire: result := result + 'Retire ';
    cDesirePlay: result := result + 'Play ';
  end;

  result := result + Position.OneLineDisplay;
end;

// ----------------------------------------------------------------------------
procedure AICreature.FullDisplay(aList: TStrings);
begin
  inherited FullDisplay(aList);

  if fEyes.ValidTarget then
    aList.Add('Eyes: ' + fEyes.Target.OneLineDisplay);
  if fGrabber.Holding then
    aList.Add('Grabber: ' + fGrabber.Target.OneLineDisplay);
  case fDesire of
    cDesireNone: aList.Add('Desire: None');
    cDesireFood: aList.Add('Desire: Food');
    cDesireWander: aList.Add('Desire: Wander');
    cDesireMate: aList.Add('Desire: Mate');
    cDesireEat: aList.Add('Desire: Eat');
    cDesireLand: aList.Add('Desire: Land');
    cDesireRetire: aList.Add('Desire: Retire');
    cDesirePlay: aList.Add('Desire: Play');
  end;
  aList.Add(Format('Size: %0.2f', [fSize]));
end;

// ----------------------------------------------------------------------------
procedure AICreature.Attack(aAmount: integer; aTarget: AIThing);
begin
  if Position.DistancePlusHeightTo(aTarget.Position) < (Position.SizeX + aTarget.Position.SizeX + 1) then
    aTarget.Damage(aAmount);
end;

// ----------------------------------------------------------------------------
// close enough to grab?
function AICreature.CloseEnoughToGrab(aThing: AIThing): boolean;
begin
  result :=
    Position.DistancePlusHeightTo(aThing.Position)
    <= (Position.SizeX/2 + aThing.Position.SizeX/2 + 0.25);
end;

// ----------------------------------------------------------------------------
procedure AICreature.Grow(aAmount: single);
begin
  Size := Size + aAmount;
  Position.SetSize(Size, Size, Size);
end;

// ----------------------------------------------------------------------------
// find and grab food
procedure AICreature.ForageFruitAndPrey(aSpeed: single);
var
  myThing: AIThing;
begin
  if not Grabber.Holding then
  begin
    // check validity of sight
    if Eyes.ValidTarget then
    begin
      myThing := Eyes.Target;

      // see if another creature got the apple
      if myThing.Position.Carried then
        Eyes.InvalidateTarget;
    end;

    // an apple is in sight
    if Eyes.ValidTarget then
    begin
      myThing := Eyes.Target;
      // face it
      Position.TurnTowardsTarget(myThing.Position, ca30);
      // move towards it
      if Position.Velocity.XYStrength < aSpeed then
        Position.Acceleration.ApplyAngularForce(Position.DirectionXY, aSpeed);
      // move up or down
      if Position.Height > myThing.Position.Height then
        Position.Acceleration.DeltaHeight := Position.Acceleration.DeltaHeight - aSpeed
      else
      if (Position.Height < myThing.Position.Height) and Position.Underwater then
        Position.Acceleration.DeltaHeight := Position.Acceleration.DeltaHeight + aSpeed;
      // grab the apple
      if CloseEnoughToGrab(myThing) then
        Grab(myThing);
    end
    else // dont see an apple, try to find an apple
    begin
      if Random(16) <> 0 then
        Eyes.AssignTarget(gEnvironment.Things.Fruits.NearestAvailableThing(Position))
      else
        Eyes.AssignTarget(gEnvironment.Things.Prey.NearestAvailableThing(Position));
    end;
  end;
end;

end.
