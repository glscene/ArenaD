{
  ai.planet
  http://aiplanet.sourceforge.net
  $Id: cAIMissileDefence.pas,v 1.4 2003/09/25 19:46:18 uid105088 Exp $

  Missile Defense by David Kerr
}
unit cAIMissileDefence;

interface

uses System.Classes, cAIBaseObject, cAISpace, cAIThings, cAIPosition, cAISatellites;

type

// ============================================================================
AIMissileDefence = Class(AIOrbiter)
private
  fDestination: AIPosition;
  fPredictor: AIPosition;
  fPick: AIPosition;
  fInitial: AIPosition;
  fRecharge: integer;
  fPriority: single;
protected
  // returns true if fired a missile
  function Shoot: boolean;
  procedure SetPriority(aValue: single);
public
  Constructor Create(aParent: pointer);
  Destructor Destroy; override;

  property Initial: AIPosition read fInitial;
  property Destination: AIPosition read fDestination;
  property Predictor: AIPosition read fPredictor;
  property Pick: AIPosition read fPick;
  property Recharge: integer read fRecharge write fRecharge;
  property Priority: single read fPriority write SetPriority;

  procedure Damage(aAmount: integer); override;
  procedure OnCollide(aCollider: AIThing); override;
  procedure Explode; override;
  procedure Fuel; override;
  procedure FullDisplay(aList: TStrings); override;
end;

// ============================================================================
AIMissile = Class(AIThing)
private
  fTimer: integer;
  fAim: integer;
protected
  procedure Explode;
public
  Constructor Create(aParent: pointer);
  Destructor Destroy; override;

  property Timer: integer read fTimer write fTimer;
  property Aim: integer read fAim write fAim;

  procedure OnCollide(aCollider: AIThing); override;
  procedure Damage(aAmount: integer); override;

  procedure Fuel; override;
  procedure FullDisplay(aList: TStrings); override;
end;

implementation

uses
  System.SysUtils,
  GLS.VectorGeometry,
  cAIReality, cAIEnvironment, cAIGrid, cGlobals,
  cAIVibes, cUtilities, cAITrees, cAIExplosions;

// ----------------------------------------------------------------------------
Constructor AIMissileDefence.Create(aParent: pointer);
begin
  inherited Create(aParent);

  Kind := cMissileDefence;

  fPredictor := AIPosition.Create(self);
  fPick := AIPosition.Create(self);
  fDestination := AIPosition.Create(self);
  fInitial := AIPosition.Create(self);
  Priority := 0;

  Position.SetSize(1, 1, 1, true);
  Position.Height := 110;
  Position.DirectionH := HalfPi;
  fRecharge := Birthday + 32;
end;

// ----------------------------------------------------------------------------
Destructor AIMissileDefence.Destroy;
begin
  fPredictor.Free;
  fPick.Free;
  fDestination.Free;
  fInitial.Free;

  inherited Destroy;
end;

// ----------------------------------------------------------------------------
procedure AIMissileDefence.Fuel;
begin
  inherited Fuel;

  // fade the priority color
  if Priority <> 0 then
    Priority := Priority - 0.002;

  if gThings.Tables[cAsteroid].Count > 0 then
  begin
    if (Recharge <= gReality.Time) then
      if Shoot then
      begin
        Priority := Priority + 0.05; // make the priority color brighter
        fRecharge := gReality.Time + 2;// + Random(16);
      end;
  end;
end;

// ----------------------------------------------------------------------------
procedure AIMissileDefence.SetPriority(aValue: single);
begin
  fPriority := aValue;
  if fPriority < 0.0 then
    fPriority := 0.0;
  if fPriority > 0.5 then
    fPriority := 0.5;
end;

// ----------------------------------------------------------------------------
procedure AIMissileDefence.FullDisplay(aList: TStrings);
begin
  inherited FullDisplay(aList);

end;

// ----------------------------------------------------------------------------
function AIMissileDefence.Shoot: boolean;
var
  myMissile: AIMissile;
  myAsteroid: AIAsteroid;
  myDistance,myLastDistance: single;
  i, j, aLoopStart, aLoopEnd, Timer: integer;
  mySpeed, myCollide: single;
  myMissilePathMax: integer;
  myDestinationArray: array of TAffineVector;
  FoundIt: boolean;
begin
  result := false;
  if not gThings.CanAdd(cMissile) then exit;

  gThings.Tables[cAsteroid].SetNextOrFirstActive;
  myAsteroid := gThings.Tables[cAsteroid].ActiveItem;

  if myAsteroid.Markers >= 2 then exit;

  if myAsteroid.Age < 16 then
  begin
    gThings.Tables[cAsteroid].SetFirstActive;
    exit;
  end;

  Initial.CopyCoords(Position);
  Initial.SetSize(1, 1, 1, true);
  Initial.Mass := 1;
  Initial.FaceTarget(myAsteroid.Position);
  Initial.DirectionH := HalfPi;
  Initial.MoveFreely(0.1+Initial.SizeX);
  Initial.DirectionH := 0;

  // find the initial variables of the relation of missile to asteroid
  myDistance := Initial.DistancePlusHeightTo(myAsteroid.Position);
  mySpeed := 2.5;
  myMissilePathMax := Round(myDistance/mySpeed/2.0); // longest path to take
  myCollide := (Initial.SizeY + myAsteroid.Position.SizeY)/2;

  // predict the asteroids position,
  // then test a bunch of paths to see if we can hit it.
  Destination.FullCopy(myAsteroid.Position);
  Destination.Tangible := false;
  SetLength(myDestinationArray, myMissilePathMax);
  for i := 0 to myMissilePathMax-1 do
  begin
    myDestinationArray[i] := Destination.AsAffineVector;
    Destination.Fuel;
  end;

  FoundIt := false;

  if Initial.Height < myAsteroid.Position.Height then
  begin
    aLoopStart := 0;
    aLoopEnd := 30;
  end
  else
  begin
    aLoopStart := 30;
    aLoopEnd := 60;
  end;

  Timer := 0;
  // for every angle, try and hit the target
  for i := aLoopStart to aLoopEnd do
  begin
    Initial.DirectionH := i * ca3;
    // initialize the prediction
    Predictor.FullCopy(Initial);
    Predictor.Velocity.ApplyAngularForce(Predictor.DirectionXY, Predictor.DirectionH, mySpeed);
    Pick.FullCopy(Predictor);
    Predictor.Tangible := false;
    myLastDistance := 100000;
    // run the prediction
    for j:=0 to myMissilePathMax-1 do
    begin
      // distance between positions
      myDistance:=Predictor.DistanceToVector(myDestinationArray[j]);
      // if this path has gone past closest point, quit
      if myDistance>myLastDistance then break;
      myLastDistance := myDistance;
      // test the prediction
      if (myDistance <= myCollide) then
      begin
        FoundIt := true;
        Timer := j + 1;
        break;
      end;
      // increase the prediction
      Predictor.Fuel;
    end;
    // if foundit, then exit
    if FoundIt then break;
  end;

  Position.TurnTowardsTarget(myAsteroid.Position, ca15);

  // found the right missile path
  if FoundIt then
  begin
    myMissile := AIMissile(gThings.NewThing(cMissile));
    myMissile.Position.FullCopy(Pick);
    myMissile.Timer := Timer;
    myMissile.Aim := myAsteroid.Handle;
    myAsteroid.Mark;
    Position.FaceTarget(myAsteroid.Position);
  end;

  result := FoundIt;
end;

// ----------------------------------------------------------------------------
procedure AIMissileDefence.Explode;
var
  myExplosion: AIExplosion;
begin
  myExplosion := AIExplosion(gThings.NewThing(cExplosion));
  Noise(cNoiseSmash, 1);
  if Assigned(myExplosion) then
  begin
    myExplosion.Position.CopyCoords(Position);
    myExplosion.Position.Velocity.Zero;
    myExplosion.Position.Acceleration.Zero;
    myExplosion.Effect := cEffectBlast;
    myExplosion.BlastRadius := 5;
    myExplosion.Strength := 0.0100;
    myExplosion.Diminish := 0.0001;
    myExplosion.Position.Fuel;
  end;
end;

// ----------------------------------------------------------------------------
Constructor AIMissile.Create(aParent: pointer);
begin
  inherited Create(aParent);

  Kind := cMissile;
  Aim := 0;

  Position.SetSize(1, 1, 1, true);
  Position.Mass := 1;
end;

// ----------------------------------------------------------------------------
Destructor AIMissile.Destroy;
begin

  inherited Destroy;
end;

// ----------------------------------------------------------------------------
procedure AIMissile.Fuel;
begin
  inherited Fuel;

  if (Age > Timer) then
  begin
    Explode;
    Cease;
  end;

  if (Position.Binding = bindLand) then
  begin
    if not Position.UnderWater then
      Explode;
    Cease;
  end;
end;

// ----------------------------------------------------------------------------
procedure AIMissile.FullDisplay(aList: TStrings);
begin
  inherited FullDisplay(aList);

end;

// ----------------------------------------------------------------------------
procedure AIMissile.OnCollide(aCollider: AIThing);
begin
  aCollider.Cease;
  if Exists then
  begin
    Explode;
    Cease;
  end;
end;

// ----------------------------------------------------------------------------
procedure AIMissile.Damage(aAmount: integer);
begin
  // do nothing
end;

// ----------------------------------------------------------------------------
procedure AIMissile.Explode;
var
  myExplosion: AIExplosion;
  myTarget: AIThing;
begin
  myExplosion := AIExplosion(gThings.NewThing(cExplosion));
  Noise(cNoiseSmash, 1);
  if Assigned(myExplosion) then
  begin
    myExplosion.Position.CopyCoords(Position);
    myExplosion.Position.Velocity.Zero;
    myExplosion.Position.Acceleration.Zero;
    myExplosion.Effect := cEffectBlast;
    myExplosion.BlastRadius := 1;
    myExplosion.Strength := 0.0040;
    myExplosion.Diminish := 0.0001;
    myExplosion.Position.Fuel;
  end;
  myTarget := AIThing(gThings.FindWithHandle(Aim));
  if (myTarget<>nil) and (myTarget.Exists) and (myTarget.Kind = cAsteroid) then
    AIAsteroid(myTarget).UnMark;
end;

// ----------------------------------------------------------------------------
procedure AIMissileDefence.OnCollide(aCollider: AIThing);
begin
  if not (aCollider is AIMissileDefence) or (Position.Velocity.Strength > 1) then
  begin
    Explode;
    Cease;
  end;
end;

// ----------------------------------------------------------------------------
procedure AIMissileDefence.Damage(aAmount: integer);
begin
  Explode;
  Cease;
end;

end.

