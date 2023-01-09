{
  ai.planet
  http://aiplanet.sourceforge.net
  Created by Dave Kerr (kerrd@hotmail.com)
}
unit cAIPosition;
{
  Node
       AIPosition       - coordinate object for things
       AIForce          - position modifier

}
interface

uses
  System.Classes,

  GLS.VectorGeometry,
  GLS.VectorTypes,

  cAIBaseObject,
  cAICoordinates,
  cAIForce;

const
  ca360 = Pi/180;
  ca180 = Pi/360;
  TwoPi = Pi*2;
  HalfPi = Pi/2;
  QuarterPi = Pi/4;
  EighthPi = Pi/8;
  SixteenthPi = Pi/16;
  PiAndHalf = Pi + HalfPi;

  ca1 = Pi/360;
  ca2 = ca1 * 2;
  ca3 = ca1 * 3;
  ca5 = ca1 * 5;
  ca15 = ca1 * 15;
  ca30 = ca1 * 30;
  ca45 = ca1 * 45;
  ca60 = ca1 * 60;
  ca75 = ca1 * 75;
  ca90 = ca1 * 90;
  PiLess1 = Pi - ca1;

  bindLand = 0;
  bindWater = 1;
  bindAtmosphere = 2;
  bindSpace = 3;

type

// ----------------------------------------------------------------------------
AIPosition = Class(TObject)
private
  // velocity
  fVelocity: AIForce;
  // acceleration
  fAcceleration: AIForce;
  // pointer to carrier
  fCarrier: pointer;
  fLocation: pointer;

  // coordinates
  fX: single;
  fY: single;
  fHeight: single;

  // direction
  fDirectionXY: single;
  fDirectionH: single;

  // mass
  fMass: single;        // "weight"
  fBounce: single;      // land bounce
  fBuoyancy: single;    // water floating

  // bounding box
  fSizeX: single;
  fSizeY: single;
  fSizeH: single;

  // height of land/water
  fLand: single;
  fWater: single;

  // world binding
  fBinding: integer;
  // can be grabbed?
  fTangible: boolean;
  // being carried?
  fCarried: boolean;
  // is it underwater?
  fUnderWater: boolean;
  // collides?
  fCollider: boolean;

  procedure SetX(aX: single);
  procedure SetY(aY: single);

  function ApplyY(aY: single): boolean;

  procedure SetDirectionXY(aDirectionXY: single);
  procedure SetDirectionH(aDirectionH: single);
  procedure SetMass(aMass: single);

  procedure TerrainCollide(aLocation: pointer);
public
  Constructor Create(aParent: pointer);
  Destructor Destroy; override;
  procedure CopyCoords(aPosition: AIPosition);
  procedure FullCopy(aPosition: AIPosition);

  property X: single read fX write SetX;
  property Y: single read fY write SetY;
  property Height: single read fHeight write fHeight;

  property DirectionXY: single read fDirectionXY write SetDirectionXY;
  property DirectionH: single read fDirectionH write SetDirectionH;

  property Binding: integer read fBinding write fBinding;

  property Mass: single read fMass write SetMass;
  property Buoyancy: single read fBuoyancy write fBuoyancy;
  property Bounce: single read fBounce write fBounce;
  property SizeX: single read fSizeX write fSizeX;
  property SizeY: single read fSizeY write fSizeY;
  property SizeH: single read fSizeH write fSizeH;
  property Tangible: boolean read fTangible write fTangible;
  property Collider: boolean read fCollider write fCollider;

  property Carried: boolean read fCarried write fCarried;
  property Carrier: pointer read fCarrier write fCarrier;

  property Velocity: AIForce read fVelocity;
  property Acceleration: AIForce read fAcceleration;

  property UnderWater: boolean read fUnderWater;
  property Land: single read fLand;
  property Water: single read fWater;
  property Location: pointer read fLocation;

  procedure SetPosition(aX: single; aY: single; aHeight: single);
  procedure SetSize(aSizeX: single; aSizeY: single; aSizeH: single; aTangible: boolean); overload;
  procedure SetSize(aSizeX: single; aSizeY: single; aSizeH: single); overload;
  procedure SetProperties(aMass: single; aBounce: single; aBuoyancy: single);
  procedure SetDirection(aXYAngle: single; aHeightAngle: single);

  function Volume: single;

  function DistanceToX(aDestX: single): single;
  function DistanceToY(aDestY: single): single;
  procedure TurnTowards(const aTarget, aAmount: single);

  procedure MoveFreely(aAmount: single);
  procedure MoveFreely5(aAmount: single);
  procedure Move(dX: single; dY: single);
  procedure MoveX(dX: single);
  procedure MoveY(dY: single);
  procedure MoveYNoPoles(dY: single);
  procedure MoveHeight(dHeight: single);
  procedure TurnLeft; overload;
  procedure TurnRight; overload;
  procedure TurnLeft(aAmount: single); overload;
  procedure TurnRight(aAmount: single); overload;
  procedure Reverse;

  procedure MoveBy(aAmount: single);

  procedure FaceTarget(aPosition: AIPosition); overload;
  procedure FaceTarget(aPosition: TAffineVector); overload;
  procedure TurnTowardsVelocity(const aAmount: single);
  procedure TurnTowardsTarget(const aPosition: AIPosition); overload;
  procedure TurnTowardsTarget(const aPosition: AIPosition; const aAmount: single); overload;
  procedure TurnTowardsVector(const aVector: TAffineVector; const aAmount: single);
  procedure FaceVelocity;
  function TurnTowardsAndIsFacingTarget(const aPosition: AIPosition; const aAmount: single): boolean;

  procedure MoveTowards(aPosition: AIPosition; aAmount: single); overload;
  procedure MoveTowardsHeight(aHeight: single; aAmount: single);

  procedure ApplyForce(aForce: AIForce); overload;
  procedure ApplyForce(dX: single; dY: single; dH: single); overload;
  procedure ApplyForce(aOrigin: AIPosition; aStrength: single); overload;
  procedure ApplyForce(aAngle: single; aStrength: single); overload;

  procedure Center;               // centers at x.5, y.5
  procedure RandomizeOffset;      // randomizes the fraction of the position (1.0)
  procedure RandomizeHalfOffset;  // randomizes the fraction of the position (0.5)

  // grow/shrink
  procedure Inflate(aAmount: single);
  procedure Deflate(aAmount: single);

  function DistanceTo(aDestination: AIPosition): single;
  function DistancePlusHeightTo(aDestination: AIPosition): single;
  function DistanceToHeight(aHeight: single): single;
  function DistanceToXPlusY(aDestination: AIPosition): single;
  function SimpleDistanceTo(aDestination: AIPosition): single;
  function SimpleDistanceToXY(aDestination: AIPosition): single;
  function DistanceToVector(aVector: TAffineVector): single;
  function DirectionTo(aPosition: AIPosition): single;

  function HeightAbove: single;
  function HighestHeight: single;
  function AsAffineVector: TAffineVector;

  procedure VelocityStrafeLeft(aAmount: single);
  procedure VelocityStrafeRight(aAmount: single);
  procedure AccelerationStrafeLeft(aAmount: single);
  procedure AccelerationStrafeRight(aAmount: single);

  // emit noises etc
  procedure Vibrate(aEffectType, aEffectIndex, aTimerDeath: integer);

  // location interface
  procedure ApplyOrbitingForce(aForce: AIForce);  // reverses y at poles
  procedure SetToCoordinates(aCoordinates: AICoordinates);
  function GridX: integer;
  function GridY: integer;

  procedure Fuel;

  function OneLineDisplay: string;
  procedure FullDisplay(aList: TStrings);
  procedure SaveToFile(var aFile: TextFile);
  procedure LoadFromFile(var aFile: TextFile);
end;

implementation

uses
  System.SysUtils, cGlobals, cUtilities, cAIThings, cAIGrid, cAIVibes, Math;

// ----------------------------------------------------------------------------
Constructor AIPosition.Create(aParent: pointer);
begin
  inherited Create;

  fVelocity := AIForce.Create;
  fAcceleration := AIForce.Create;

  fBinding := bindLand;
  fMass := 1.0;
  fBounce := 0.1;
  fSizeX := 3;
  fSizeY := 3;
  fSizeH := 3;
  fTangible := true;
  fCollider := true;
  fCarried := false;
  fCarrier := nil;
  fBuoyancy := 0;
  fBounce := 0.25;
  fDirectionXY := 0;
  fDirectionH := HalfPi;

  fLocation := gSpace.Map[0][0];

  Fuel;
end;

// ----------------------------------------------------------------------------
Destructor AIPosition.Destroy;
begin
  fVelocity.Free;
  fAcceleration.Free;

  inherited Destroy;
end;

// ----------------------------------------------------------------------------
procedure AIPosition.Fuel;
var
  gridx, gridy: integer;
  myLocation: AIGrid;
begin
  // apply acceleration
  if not (fAcceleration.Stale) then
  begin
    fVelocity.ApplyMassiveForce(fAcceleration, fMass);
    fAcceleration.Zero;
  end;
  // limit velocity
  if fVelocity.Strength > 5 then
    fVelocity.LimitForce;
  // apply velocity
  ApplyForce(fVelocity);

  // determine terrain info
  gridx := Round(fX/10-0.5);
  gridy := Round(fY/10-0.5);
  myLocation := gSpace.Map[gridx][gridy];
  fLocation := myLocation;
  fLand := myLocation.LandMax;
  if (fHeight <= fLand) then
    fLand := myLocation.DetermineLandHeight(fX, fY);
  fWater := myLocation.WaterMax;
  if (fHeight <= fWater) then
    fWater := myLocation.DetermineWaterHeight(fX, fY);

  // determine binding
  if (fHeight <= fLand) then
    fBinding := bindLand
  else
  if (fHeight <= fWater) then
    fBinding := bindWater
  else
  begin
    if fHeight < 100 then
      fBinding := bindAtmosphere
    else
      fBinding := bindSpace;
  end;

  // check to see if underwater
  if not fUnderWater then
  begin
    fUnderWater := (fHeight <= fWater);
    // just fell into the water, make a splash sound
    if fUnderWater and (Velocity.DeltaHeight < -0.1) and (Tangible) then
      Vibrate(cEffectNoise, cNoiseSploosh, 1);
  end
  else
    fUnderWater := (fHeight <= fWater);

  // calculate effects of binding
  case Binding of
    bindLand:
    begin
      // land friction
      if (fHeight < fLand) then
      begin
        TerrainCollide(location);
        // dampen tiny bumps
        if Velocity.DeltaHeight <= 0.02 then begin Velocity.DeltaHeight := 0; fHeight := fLand; end;
      end;

      //fAcceleration.ApplyForce(AIGrid(fLocation).Wind);

      if not fVelocity.Stale then
        fVelocity.Shrink(fMass * 0.010);

      fHeight := fLand;

      if fUnderWater then
      begin
        // gravity
        fVelocity.DeltaHeight := fVelocity.DeltaHeight - 0.020;

        fAcceleration.ApplyForce(myLocation.Wave);
        if (fBuoyancy <> 0) then
          fAcceleration.DeltaHeight := fAcceleration.DeltaHeight + 0.03 * fBuoyancy;
        fVelocity.Scale(0.8);
      end;
    end;

    bindWater:
    begin
      // gravity
      fVelocity.DeltaHeight := fVelocity.DeltaHeight - 0.020;
      // float
      if (fBuoyancy <> 0) then
      begin
        if ((fHeight + fSizeH/2) < fWater) then
          fAcceleration.DeltaHeight := fAcceleration.DeltaHeight + 0.03 * fBuoyancy
        else if (fBuoyancy>0.5) then
          fVelocity.DeltaHeight := fVelocity.DeltaHeight + 0.020;
      end;
      fVelocity.ApplyForce(myLocation.Wave);
      // water friction
      fVelocity.Scale(0.8);
    end;

    bindAtmosphere:
    begin
      // gravity
      fVelocity.DeltaHeight := fVelocity.DeltaHeight - 0.020;
      fAcceleration.ApplyForce(myLocation.Wind);
      // air friction
      fVelocity.Scale(0.99);
    end;

    bindSpace:
    begin
      // gravity
      fVelocity.DeltaHeight := fVelocity.DeltaHeight - 0.020;
      // no friction
    end;
  end;
end;

// ----------------------------------------------------------------------------
procedure AIPosition.TerrainCollide(aLocation: pointer);
var
  v, n, r: TAffineVector;
begin
  n := AIGrid(aLocation).Normal;
  v := fVelocity.AsAffineVector;
  r := VectorCombine(v, n, 1, -2*VectorDotProduct(v, n));
  r := VectorScale(r, fBounce);
  fVelocity.SetForce(r.X/1.5, r.Y/1.5, r.Z);
end;

// ----------------------------------------------------------------------------
function AIPosition.OneLineDisplay: string;
begin
  case fBinding of
    bindLand: result := 'b-Land';
    bindWater: result := 'b-Water';
    bindAtmosphere: result := 'b-Air';
    bindSpace: result := 'b-Space';
  end;

  result := result +
    Format(' X=%0.2f,Y=%0.2f,H=%0.2f,Dxy=%0.2f,V=%0.2f',
    [fX, fY, fHeight, fDirectionXY, fVelocity.Length]);
//  result := result + ',v=' + fVelocity.OneLineDisplay + ',a=' + fAcceleration.OneLineDisplay;
end;

// ----------------------------------------------------------------------------
procedure AIPosition.SaveToFile(var aFile: TextFile);
begin
  writeln(aFile, fDirectionXY);
  writeln(aFile, fX);
  writeln(aFile, fY);
  writeln(aFile, fHeight);
  writeln(aFile, fDirectionXY);
  writeln(aFile, fDirectionH);
  writeln(aFile, fMass);
  writeln(aFile, fBounce);
  writeln(aFile, fBuoyancy);
  writeln(aFile, fSizeX);
  writeln(aFile, fSizeY);
  writeln(aFile, fSizeH);
  writeln(aFile, fLand);
  writeln(aFile, fWater);
  writeln(aFile, fBinding);
  writeFileBoolean(aFile, fTangible);
  writeFileBoolean(aFile, fUnderwater);
  writeFileBoolean(aFile, fCarried);
  writeFileBoolean(aFile, fCollider);
  fVelocity.SaveToFile(aFile);
  fAcceleration.SaveToFile(aFile);
end;

// ----------------------------------------------------------------------------
procedure AIPosition.LoadFromFile(var aFile: TextFile);
begin
  readln(aFile, fDirectionXY);
  readln(aFile, fX);
  readln(aFile, fY);
  readln(aFile, fHeight);
  readln(aFile, fDirectionXY);
  readln(aFile, fDirectionH);
  readln(aFile, fMass);
  readln(aFile, fBounce);
  readln(aFile, fBuoyancy);
  readln(aFile, fSizeX);
  readln(aFile, fSizeY);
  readln(aFile, fSizeH);
  readln(aFile, fLand);
  readln(aFile, fWater);
  readln(aFile, fBinding);
  fTangible := readFileBoolean(aFile);
  fUnderwater := readFileBoolean(aFile);
  fCarried := readFileBoolean(aFile);
  fCollider := readFileBoolean(aFile);
  fVelocity.LoadFromFile(aFile);
  fAcceleration.LoadFromFile(aFile);
end;

// ----------------------------------------------------------------------------
procedure AIPosition.CopyCoords(aPosition: AIPosition);
begin
  fX := aPosition.X;
  fY := aPosition.Y;
  fHeight := aPosition.Height;
  fBinding := aPosition.Binding;
  fLand := aPosition.Land;
  fWater := aPosition.Water;
end;

// ----------------------------------------------------------------------------
procedure AIPosition.FullCopy(aPosition: AIPosition);
begin
  fX := aPosition.X;
  fY := aPosition.Y;
  fHeight := aPosition.Height;
  fDirectionXY := aPosition.DirectionXY;
  fDirectionH := aPosition.DirectionH;
  fBinding := aPosition.Binding;
  fLand := aPosition.Land;
  fWater := aPosition.Water;
  fBuoyancy := aPosition.Buoyancy;
  fBounce := aPosition.Bounce;
  fMass := aPosition.Mass;
  fSizeX := aPosition.SizeX;
  fSizeY := aPosition.SizeY;
  fSizeH := aPosition.SizeH;
  fVelocity.CopyFrom(aPosition.Velocity);
  fAcceleration.CopyFrom(aPosition.Acceleration);
end;

// ----------------------------------------------------------------------------
procedure AIPosition.SetPosition(aX: single; aY: single; aHeight: single);
begin
  SetX(aX);
  SetY(aY);
  fHeight := aHeight;
end;

// ----------------------------------------------------------------------------
procedure AIPosition.SetX(aX: single);
begin
  fX := aX;

  if fX < 0 then               // under bounds check
  begin
    fX := (gWorldWidth + fX);  // since fX is negative, just add it to Width
  end;

  if fX >= (gWorldWidth) then // over bounds check
  begin
    fX := fX - (gWorldWidth);  // since fX is greater than width, subtract width from fX
  end;
end;

// ----------------------------------------------------------------------------
procedure AIPosition.SetY(aY: single);
begin
  fY := aY;

  // north pole
  if fY < 0 then
  begin
    fY := -1 * fY; // y is negative, so keep the same y by making it positive
    Reverse;
    X := fX - gHalfWorldWidth;
  end;

  // south pole
  if fY >= (gWorldHeight) then
  begin
    fY := gWorldHeight - (fY - gWorldHeight);
    if fY >= gWorldHeight then
      fY := gWorldHeight - 0.01;
    Reverse;
    X := fX - gHalfWorldWidth;
  end;
end;

// ----------------------------------------------------------------------------
// from 0 to 2pi
// wraps around
procedure AIPosition.SetDirectionXY(aDirectionXY: single);
begin
  fDirectionXY := aDirectionXY;

  if fDirectionXY < 0 then
    fDirectionXY := TwoPi + fDirectionXY;
  if fDirectionXY >= TwoPi then
    fDirectionXY := fDirectionXY - TwoPi;
end;

// ----------------------------------------------------------------------------
// from 0 to pi
// doesnt wrap around
procedure AIPosition.SetDirectionH(aDirectionH: single);
begin
  fDirectionH := aDirectionH;

  if fDirectionH < ca1 then
    fDirectionH := ca1;
  if fDirectionH > (PiLess1) then
    fDirectionH := PiLess1;
end;

// ----------------------------------------------------------------------------
// aXY = 0..2pi
// aH = 0..pi
procedure AIPosition.SetDirection(aXYAngle: single; aHeightAngle: single);
begin
  DirectionXY := aXYAngle;
  DirectionH := aHeightAngle;
end;

// ----------------------------------------------------------------------------
// moves by the total direction vector, including height
procedure AIPosition.MoveFreely(aAmount: single);
var
  mySinH: single;
begin
  mySinH := sin(fDirectionH);
  X := fX + cos(fDirectionXY) * mySinH * aAmount;
  Y := fY + sin(fDirectionXY) * mySinH * aAmount;
  Height := fHeight + cos(fDirectionH) * aAmount;
end;

// ----------------------------------------------------------------------------
// moves by the total direction vector, including height
procedure AIPosition.MoveFreely5(aAmount: single);
var
  mySinH: single;
begin
  mySinH := sin(fDirectionH);
  X := fX + cos(fDirectionXY) * mySinH * aAmount/15;
  MoveYNoPoles(sin(fDirectionXY) * mySinH * aAmount/15);
  Height := fHeight + cos(fDirectionH) * aAmount/5;
end;

// ----------------------------------------------------------------------------
procedure AIPosition.MoveBy(aAmount: single);
begin
  X := fX + cos(fDirectionXY) * aAmount;
  Y := fY + sin(fDirectionXY) * aAmount;
end;

// ----------------------------------------------------------------------------
// sets direction to face a target position
procedure AIPosition.FaceTarget(aPosition: AIPosition);
begin
  DirectionXY := Math.arctan2(aPosition.Y - Y, aPosition.X - X);
end;

// ----------------------------------------------------------------------------
// sets direction to face a target position
procedure AIPosition.FaceTarget(aPosition: TAffineVector);
begin
  DirectionXY := Math.arctan2(aPosition.Y - Y, aPosition.X - X);
end;

// ----------------------------------------------------------------------------
// sets direction to face target velocity
procedure AIPosition.FaceVelocity;
begin
  Assert(not IsNan(fVelocity.DeltaX));
  Assert(not IsNan(fVelocity.DeltaY));
  DirectionXY := Math.arctan2(fVelocity.DeltaY, fVelocity.DeltaX);
end;

// ----------------------------------------------------------------------------
// sets direction to incrementally face target velocity
procedure AIPosition.TurnTowardsVelocity(const aAmount: single);
begin
  TurnTowards(Math.arctan2(fVelocity.DeltaY, fVelocity.DeltaX), aAmount);
end;

// ----------------------------------------------------------------------------
// sets direction to incrementally face target vector
procedure AIPosition.TurnTowardsVector(const aVector: TAffineVector; const aAmount: single);
begin
  TurnTowards(Math.arctan2(aVector.Y, aVector.X), aAmount);
end;

// ----------------------------------------------------------------------------
// turn towards a target position
procedure AIPosition.TurnTowardsTarget(const aPosition: AIPosition);
begin
  TurnTowards(Math.arctan2(aPosition.Y - Y, aPosition.X - X), ca5);
end;

// ----------------------------------------------------------------------------
// turn towards a target position
procedure AIPosition.TurnTowardsTarget(const aPosition: AIPosition; const aAmount: single);
begin
  TurnTowards(Math.arctan2(aPosition.Y - Y, aPosition.X - X), aAmount);
end;

// ----------------------------------------------------------------------------
// turn towards a target position
function AIPosition.TurnTowardsAndIsFacingTarget(const aPosition: AIPosition; const aAmount: single): boolean;
var
  myTarget: single;
begin
  myTarget := Math.arctan2(aPosition.Y - Y, aPosition.X - X);
  TurnTowards(myTarget, aAmount);
  result := (fDirectionXY = myTarget);
end;

// ----------------------------------------------------------------------------
procedure AIPosition.TurnTowards(const aTarget, aAmount: single);
var
  myDiff: single;
begin
  myDiff := abs(aTarget - fDirectionXY);

  if myDiff < aAmount then
  begin
    fDirectionXY := aTarget;
    exit;
  end;

  if (TwoPi - myDiff) < aAmount then
  begin
    fDirectionXY := aTarget;
    exit;
  end;

  if fDirectionXY > aTarget then
  begin
    if myDiff < Pi then
      fDirectionXY := fDirectionXY - aAmount
    else
      fDirectionXY := fDirectionXY + aAmount;
    exit;
  end;

  if myDiff < Pi then
    fDirectionXY := fDirectionXY + aAmount
  else
    fDirectionXY := fDirectionXY - aAmount;
end;

// ----------------------------------------------------------------------------
// shortest distance between two x coordinates
// accounts for edge of spherical map
// TODO: account for poles
function AIPosition.DistanceToX(aDestX: single): single;
begin
  result := Abs(X - aDestX);

  if X > aDestX then
  begin
    if ((gWorldWidth - X) + aDestX) < result then
      result := ((gWorldWidth - X) + aDestX);
  end
  else
    if ((gWorldWidth - aDestX) + X) < result then
      result := ((gWorldWidth - aDestX) + X);
end;

// ----------------------------------------------------------------------------
// shortest distance between two Y coordinates
// TODO: account for poles
function AIPosition.DistanceToY(aDestY: single): single;
begin
  result := Abs(Y - aDestY);
end;

// ----------------------------------------------------------------------------
function AIPosition.DistanceToHeight(aHeight: single): single;
begin
  result := abs(Height - aHeight);
end;

// ----------------------------------------------------------------------------
procedure AIPosition.Move(dX: single; dY: single);
begin
  X := fX + dX;
  Y := fY + dY;
end;

// ----------------------------------------------------------------------------
procedure AIPosition.MoveX(dX: single);
begin
  X := fX + dX;
end;

// ----------------------------------------------------------------------------
procedure AIPosition.MoveY(dY: single);
begin
  Y := fY + dY;
end;

// ----------------------------------------------------------------------------
procedure AIPosition.MoveHeight(dHeight: single);
begin
  Height := fHeight + dHeight;
end;

// ----------------------------------------------------------------------------
procedure AIPosition.TurnLeft;
begin
  DirectionXY := fDirectionXY - ca360;
end;

// ----------------------------------------------------------------------------
procedure AIPosition.TurnRight;
begin
  DirectionXY := fDirectionXY + ca360;
end;

// ----------------------------------------------------------------------------
procedure AIPosition.TurnLeft(aAmount: single);
begin
  DirectionXY := fDirectionXY - aAmount;
end;

// ----------------------------------------------------------------------------
procedure AIPosition.TurnRight(aAmount: single);
begin
  DirectionXY := fDirectionXY + aAmount;
end;

// ----------------------------------------------------------------------------
procedure AIPosition.Reverse;
begin
  DirectionXY := fDirectionXY + Pi;
  Velocity.InvertXY;
end;

// ----------------------------------------------------------------------------
procedure AIPosition.Center;
begin
  fX := Round(fX/10-0.5)*10 + 5.0;
  fY := Round(fY/10-0.5)*10 + 5.0;
end;

// ----------------------------------------------------------------------------
procedure AIPosition.RandomizeOffset;
begin
  fX := fX + Random*10.0;
  fY := fY + Random*10.0;
end;

// ----------------------------------------------------------------------------
procedure AIPosition.RandomizeHalfOffset;
begin
  fX := fX + 2.5 + Random*5.0;
  fY := fY + 2.5 + Random*5.0;
end;

// ----------------------------------------------------------------------------
procedure AIPosition.ApplyForce(aForce: AIForce);
begin
  if not (aForce.DeltaX = 0) then
    X := X + aForce.DeltaX;

  if not (aForce.DeltaY = 0) then
    Y := Y + aForce.DeltaY;

  if not (aForce.DeltaHeight = 0) then
    Height := Height + aForce.DeltaHeight;
end;

// ----------------------------------------------------------------------------
procedure AIPosition.ApplyForce(dX: single; dY: single; dH: single);
begin
  if not (dX = 0) then
    X := X + dX;
  if not (dY = 0) then
    Y := Y + dY;
  if not (dH = 0) then
    Height := Height + dH;
end;

// ----------------------------------------------------------------------------
// applies a force from an origin, decreasing strength over distance
procedure AIPosition.ApplyForce(aOrigin: AIPosition; aStrength: single);
var
  dX: single;
  dY: single;
  L: single;
begin
  dx := (X - aOrigin.X);
  dy := (Y - aOrigin.Y);
  L := Sqrt(dx*dx + dy*dy);
  X := X + dx * aStrength / L;
  Y := Y + dy * aStrength / L;
end;

// ----------------------------------------------------------------------------
procedure AIPosition.ApplyForce(aAngle: single; aStrength: single);
begin
  X := X + aStrength * cos(aAngle);
  Y := Y + aStrength * sin(aAngle);
end;

// ----------------------------------------------------------------------------
function AIPosition.DistanceTo(aDestination: AIPosition): single;
var
  dX, dY: single;
begin
  dx := (X - aDestination.X);
  dy := (Y - aDestination.Y);
  result := Sqrt(dx*dx + dy*dy);
end;

// ----------------------------------------------------------------------------
function AIPosition.DistancePlusHeightTo(aDestination: AIPosition): single;
var
  dX, dY, dH: single;
begin
  dx := (fX - aDestination.X);
  dy := (fY - aDestination.Y);
  dH := (fHeight - aDestination.Height);
  result := Sqrt(dx*dx + dy*dy + dH*dH);
end;

// ----------------------------------------------------------------------------
function AIPosition.DistanceToVector(aVector: TAffineVector): single;
var
  dX, dY, dH: single;
begin
  dx := (fX - aVector.X);
  dy := (fY - aVector.Y);
  dH := (fHeight - aVector.Z);
  result := Sqrt(dx*dx + dy*dy + dH*dH);
end;

// ----------------------------------------------------------------------------
function AIPosition.DistanceToXPlusY(aDestination: AIPosition): single;
var
  dX, dY: single;
begin
  dx := DistanceToX(aDestination.X);
  dy := (Y - aDestination.Y);
  result := Sqrt(dx*dx + dy*dy);
end;

// ----------------------------------------------------------------------------
procedure AIPosition.MoveTowards(aPosition: AIPosition; aAmount: single);
begin
  if DistanceToX(aPosition.X) < aAmount then
    X := aPosition.X
  else
  if aPosition.DistanceToX(X + aAmount) < aPosition.DistanceToX(X - aAmount) then
    X := X + aAmount
  else
    X := X - aAmount;

  if Y > aPosition.Y then
  begin
    Y := Y - aAmount;
    if Y < aPosition.Y then
      Y := aPosition.Y;
  end;

  if Y < aPosition.Y then
  begin
    Y := Y + aAmount;
    if Y > aPosition.Y then
      Y := aPosition.Y;
  end;
end;

// ----------------------------------------------------------------------------
procedure AIPosition.MoveTowardsHeight(aHeight: single; aAmount: single);
begin
  if Height < aHeight then
  begin
    Height := Height + aAmount;
    if Height > aHeight then
      Height := aHeight;
  end;

  if Height > aHeight then
  begin
    Height := Height - aAmount;
    if Height < aHeight then
      Height := aHeight;
  end;
end;

// ----------------------------------------------------------------------------
procedure AIPosition.SetSize(aSizeX: single; aSizeY: single; aSizeH: single; aTangible: boolean);
begin
  fSizeX := aSizeX;
  fSizeY := aSizeY;
  fSizeH := aSizeH;
  fTangible := aTangible;
end;

// ----------------------------------------------------------------------------
procedure AIPosition.SetSize(aSizeX: single; aSizeY: single; aSizeH: single);
begin
  fSizeX := aSizeX;
  fSizeY := aSizeY;
  fSizeH := aSizeH;
end;

// ----------------------------------------------------------------------------
procedure AIPosition.SetProperties(aMass: single; aBounce: single; aBuoyancy: single);
begin
  Mass := aMass;
  Bounce := aBounce;
  Buoyancy := aBuoyancy;
end;

// ----------------------------------------------------------------------------
function AIPosition.DirectionTo(aPosition: AIPosition): single;
begin
  result := Math.arctan2(aPosition.Y - Y, aPosition.X - X);
end;

// ----------------------------------------------------------------------------
function AIPosition.Volume: single;
begin
  result := fSizeX * fSizeY * fSizeH;
end;

// ----------------------------------------------------------------------------
procedure AIPosition.Inflate(aAmount: single);
begin
  fSizeX := fSizeX + aAmount;
  fSizeY := fSizeY + aAmount;
  fSizeH := fSizeH + aAmount;
end;

// ----------------------------------------------------------------------------
procedure AIPosition.Deflate(aAmount: single);
begin
  fSizeX := fSizeX - aAmount;
  fSizeY := fSizeY - aAmount;
  fSizeH := fSizeH - aAmount;
end;

// ----------------------------------------------------------------------------
procedure AIPosition.ApplyOrbitingForce(aForce: AIForce);
begin
  if not (aForce.DeltaX = 0) then
    X := X + aForce.DeltaX;

  if not (aForce.DeltaY = 0) then
    if ApplyY(Y + aForce.DeltaY) then
      aForce.ReverseY;

  if not (aForce.DeltaHeight = 0) then
    Height := Height + aForce.DeltaHeight;
end;

// ----------------------------------------------------------------------------
procedure AIPosition.SetToCoordinates(aCoordinates: AICoordinates);
begin
  X := aCoordinates.X*10;
  Y := aCoordinates.Y*10;
end;

// ----------------------------------------------------------------------------
function AIPosition.GridX: integer;
begin
  result := Round(fX/10-0.5);
end;

// ----------------------------------------------------------------------------
function AIPosition.GridY: integer;
begin
  result := Round(fY/10-0.5);
end;

// ----------------------------------------------------------------------------
// same as setY
// returns true if position changed across a pole
function AIPosition.ApplyY(aY: single): boolean;
begin
  fY := aY;
  result := false;

  // north pole
  if fY < 0 then
  begin
    Y := -1 * fY; // y is negative, so keep the same y by making it positive
    Reverse;
    X := fX - gHalfWorldWidth;
    result := true;
  end;

  // south pole
  if fY >= (gWorldHeight) then
  begin
    Y := gWorldHeight - (fY - gWorldHeight);
    Reverse;
    X := fX - gHalfWorldWidth;
    result := true;
  end;
end;

// ----------------------------------------------------------------------------
procedure AIPosition.MoveYNoPoles(dY: single);
begin
  if (fY + dY > 0) and (fY + dY < gWorldHeight) then
    Y := fY + dY;
end;

// ----------------------------------------------------------------------------
function AIPosition.HeightAbove: single;
begin
  if fLand > fWater then
    result := fHeight - fLand
  else
    result := fHeight - fWater;
end;

// ----------------------------------------------------------------------------
function AIPosition.HighestHeight: single;
begin
  if fLand > fWater then
    result := fLand
  else
    result := fWater;
end;

// ----------------------------------------------------------------------------
function AIPosition.AsAffineVector: TAffineVector;
begin
  result.X := fX;
  result.Y := fY;
  result.Z := fHeight;
end;

// ----------------------------------------------------------------------------
procedure AIPosition.Vibrate(aEffectType, aEffectIndex, aTimerDeath: integer);
var
  myVibe: AIVibe;
begin
  if not gThings.CanAdd(cVibe) then exit;

  myVibe := AIVibe(gEnvironment.Things.NewThing(cVibe));
  myVibe.SetVibe(aEffectType, aEffectIndex, aTimerDeath);
  myVibe.Position.CopyCoords(self);
end;

// ----------------------------------------------------------------------------
function AIPosition.SimpleDistanceTo(aDestination: AIPosition): single;
begin
  // crashed here
  result := abs(X - aDestination.X) + abs(Y - aDestination.Y) + abs(Height - aDestination.Height);
end;

// ----------------------------------------------------------------------------
function AIPosition.SimpleDistanceToXY(aDestination: AIPosition): single;
begin
  result := abs(X - aDestination.X) + abs(Y - aDestination.Y);
end;

// ----------------------------------------------------------------------------
procedure AIPosition.FullDisplay(aList: TStrings);
begin
  case fBinding of
    bindLand: aList.Add('Binding: Land');
    bindWater: aList.Add('Binding: Water');
    bindAtmosphere: aList.Add('Binding: Air');
    bindSpace: aList.Add('Binding: Space');
  end;

  aList.Add(Format('X=%0.2f, Y=%0.2f, H=%0.2f', [fX, fY, fHeight]));
  aList.Add('Velocity: ' + Velocity.OneLineDisplay);
  aList.Add('Accel: ' + Acceleration.OneLineDisplay);
  aList.Add(Format('DirXY:%0.2f, DirH:%0.2f', [fDirectionXY, fDirectionH]));
  aList.Add(Format('Mass:%0.2f, Buoyancy:%0.2f, Bounce:%0.2f,', [fMass, fBuoyancy, fBounce]));
  aList.Add(Format('SizeX:%0.2f, SizeY:%0.2f, SizeH:%0.2f, Volume:%0.2f', [fSizeX, fSizeY, fSizeH, Volume]));
  aList.Add(Format('Land:%0.2f, Water:%0.2f, HeightAbove:%0.2f, HighestHeight:%0.2f', [fLand, fWater, HeightAbove, HighestHeight]));
  aList.Add('Underwater: ' + BoolToYesNoStr(fUnderwater));
  aList.Add('Tangible: ' + BoolToYesNoStr(fTangible));
  aList.Add('Collider: ' + BoolToYesNoStr(fCollider));
  aList.Add('Carried: ' + BoolToYesNoStr(fCarried));
  if fCarried then
    aList.Add('Carrier: ' + AIThing(fCarrier).OneLineDisplay);
//  aList.Add('Location: ' + AIGrid(fLocation).OneLineDisplay);
end;

// ----------------------------------------------------------------------------
procedure AIPosition.VelocityStrafeLeft(aAmount: single);
begin
  Velocity.ApplyAngularForce(DirectionXY - HalfPi, aAmount);
end;

// ----------------------------------------------------------------------------
procedure AIPosition.VelocityStrafeRight(aAmount: single);
begin
  Velocity.ApplyAngularForce(DirectionXY + HalfPi, aAmount);
end;

// ----------------------------------------------------------------------------
procedure AIPosition.AccelerationStrafeLeft(aAmount: single);
begin
  Acceleration.ApplyAngularForce(DirectionXY - HalfPi, aAmount);
end;

// ----------------------------------------------------------------------------
procedure AIPosition.AccelerationStrafeRight(aAmount: single);
begin
  Acceleration.ApplyAngularForce(DirectionXY + HalfPi, aAmount);
end;

// ----------------------------------------------------------------------------
procedure AIPosition.SetMass(aMass: single);
begin
  fMass := aMass;
  if fMass < 1.0 then fMass := 1.0;
end;

end.
