{
  ai.planet
  http://aiplanet.sourceforge.net
  Created by Dave Kerr (kerrd@hotmail.com)
  $Id: cAIForce.pas,v 1.16 2003/08/06 07:05:21 aidave Exp $
}
unit cAIForce;
{
  Node
       AIForce          - position modifier

}
interface

uses
  cAIBaseObject,

  GLS.VectorTypes,
  GLS.VectorGeometry,
  cAICoordinates;

type

// ----------------------------------------------------------------------------
AIForce = Class(TObject)
private
  fDeltaX: single;
  fDeltaY: single;
  fDeltaHeight: single;
public
  property DeltaX: single read fDeltaX write fDeltaX;
  property DeltaY: single read fDeltaY write fDeltaY;
  property DeltaHeight: single read fDeltaHeight write fDeltaHeight;

  // set the force (=)
  procedure SetForce(aDeltaX: single; aDeltaY: single; aDeltaHeight: single); overload;
  procedure SetAngularForce(aXYAngle: single; aHeightAngle: single; aStrength: single);
  procedure SetForce(aVector: TAffineVector); overload;

  // modify the components
  procedure AlterDeltaX(aAmount: single);
  procedure AlterDeltaY(aAmount: single);
  procedure AlterDeltaHeight(aAmount: single);

  // add a force (+)
  procedure ApplyForce(aForce: AIForce); overload;
  procedure ApplyForce(aDeltaX: single; aDeltaY: single; aDeltaHeight: single); overload;
  procedure ApplyForce(aForce: TAffineVector); overload;
  procedure ApplyAngularForce(aXYAngle: single; aHeightAngle: single; aStrength: single); overload;
  procedure ApplyAngularForce(aXYAngle: single; aStrength: single); overload;
  procedure ApplyOppositeForce(aForce: AIForce);

  // apply a force, accounting for mass
  procedure ApplyMassiveForce(aForce: AIForce; aMass: single);

  // weakens the force towards 0
  procedure ApplyNeutralizingAngularForce(aXYAngle: single; aHeightAngle: single; aStrength: single);
  procedure ApplyNeutralizingForce(aForce: AIForce);

  procedure Zero; // sets force to 0
  procedure Zero2; // sets force to 0
  function Stale: boolean;  // true if strenght = 0

  procedure Shrink(aAmount: single);

  procedure Scale(aFactor: single);
  procedure XYScale(aFactor: single);
  procedure LimitForce;
  procedure LimitSpeed(aMax: single);
  function Length: single;

  procedure Invert;
  procedure InvertXY;
  procedure InvertY;
  procedure InvertX;
  procedure InvertHeight;

  function Strength: single;
  function XYStrength: single;

  function Valid: boolean;

  procedure ReverseY;
  function AsAffineVector: TAffineVector;

  procedure CopyFrom(aForce: AIForce);

  function OneLineDisplay: string;
  procedure SaveToFile(var aFile: TextFile);
  procedure LoadFromFile(var aFile: TextFile);
end;

implementation

uses
  System.SysUtils, cGlobals, cUtilities, cAIThings, cAIGrid, Math;

// ----------------------------------------------------------------------------
procedure AIForce.CopyFrom(aForce: AIForce);
begin
  fDeltaX := aForce.DeltaX;
  fDeltaY := aForce.DeltaY;
  fDeltaHeight := aForce.DeltaHeight;
end;

// ----------------------------------------------------------------------------
procedure AIForce.SetForce(aDeltaX: single; aDeltaY: single; aDeltaHeight: single);
begin
  fDeltaX := aDeltaX;
  fDeltaY := aDeltaY;
  fDeltaHeight := aDeltaHeight;
end;

// ----------------------------------------------------------------------------
procedure AIForce.SetForce(aVector: TAffineVector);
begin
  fDeltaX := aVector.X;
  fDeltaY := aVector.Y;
  fDeltaHeight := aVector.Z;
end;

// ----------------------------------------------------------------------------
procedure AIForce.SetAngularForce(aXYAngle: single; aHeightAngle: single; aStrength: single);
begin
  fDeltaX := cos(aXYAngle) * sin(aHeightAngle) * aStrength;
  fDeltaY := sin(aXYAngle) * sin(aHeightAngle) * aStrength;
  fDeltaHeight := cos(aHeightAngle) * aStrength;
{  fDeltaX := cos(aXYAngle) * aStrength;
  fDeltaY := sin(aXYAngle) * aStrength;
  fDeltaHeight := cos(aHeightAngle) * sin(aHeightAngle) * aStrength;}
end;

// ----------------------------------------------------------------------------
procedure AIForce.ApplyAngularForce(aXYAngle: single; aHeightAngle: single; aStrength: single);
begin
  fDeltaX := fDeltaX + cos(aXYAngle) * sin(aHeightAngle) * aStrength;
  fDeltaY := fDeltaY + sin(aXYAngle) * sin(aHeightAngle) * aStrength;
  fDeltaHeight := fDeltaHeight + cos(aHeightAngle) * aStrength;

{  fDeltaX := fDeltaX + cos(aXYAngle) * aStrength;
  fDeltaY := fDeltaY + sin(aXYAngle) * aStrength;
  fDeltaHeight := fDeltaHeight + cos(aHeightAngle) * sin(aHeightAngle) * aStrength;
  }
end;

// ----------------------------------------------------------------------------
procedure AIForce.ApplyAngularForce(aXYAngle: single; aStrength: single);
begin
  fDeltaX := fDeltaX + cos(aXYAngle) * aStrength;
  fDeltaY := fDeltaY + sin(aXYAngle) * aStrength;
end;

// ----------------------------------------------------------------------------
procedure AIForce.ApplyForce(aForce: AIForce);
begin
  fDeltaX := fDeltaX + aForce.DeltaX;
  fDeltaY := fDeltaY + aForce.DeltaY;
  fDeltaHeight := fDeltaHeight + aForce.DeltaHeight;
end;

// ----------------------------------------------------------------------------
procedure AIForce.ApplyOppositeForce(aForce: AIForce);
begin
  fDeltaX := fDeltaX - aForce.DeltaX;
  fDeltaY := fDeltaY - aForce.DeltaY;
  fDeltaHeight := fDeltaHeight - aForce.DeltaHeight;
end;

// ----------------------------------------------------------------------------
procedure AIForce.ApplyForce(aDeltaX: single; aDeltaY: single; aDeltaHeight: single);
begin
  fDeltaX := fDeltaX + aDeltaX;
  fDeltaY := fDeltaY + aDeltaY;
  fDeltaHeight := fDeltaHeight + aDeltaHeight;
end;

// ----------------------------------------------------------------------------
procedure AIForce.ApplyForce(aForce: TAffineVector);
begin
  fDeltaX := fDeltaX + aForce.X;
  fDeltaY := fDeltaY + aForce.Y;
  fDeltaHeight := fDeltaHeight + aForce.Z;
end;

// ----------------------------------------------------------------------------
procedure AIForce.Zero;
begin
  fDeltaX := 0.0;          // crashed here once twice
  fDeltaY := 0.0;
  fDeltaHeight := 0.0;
end;

// ----------------------------------------------------------------------------
procedure AIForce.Zero2;
begin
  fDeltaX := 0.0;          // crashed here once twice
  fDeltaY := 0.0;
  fDeltaHeight := 0.0;
end;

// ----------------------------------------------------------------------------
procedure AIForce.ApplyNeutralizingForce(aForce: AIForce);
begin
  fDeltaX := AdjustValue(fDeltaX, 0.0, aForce.DeltaX);
  fDeltaY := AdjustValue(fDeltaY, 0.0, aForce.DeltaY);
  fDeltaHeight := AdjustValue(fDeltaHeight, 0.0, aForce.DeltaHeight);
end;

// ----------------------------------------------------------------------------
procedure AIForce.Scale(aFactor: single);
begin
  fDeltaX := fDeltaX * aFactor;
  fDeltaY := fDeltaY * aFactor;
  fDeltaHeight := fDeltaHeight * aFactor;
end;

// ----------------------------------------------------------------------------
procedure AIForce.XYScale(aFactor: single);
begin
  fDeltaX := fDeltaX * aFactor;
  fDeltaY := fDeltaY * aFactor;
end;

// ----------------------------------------------------------------------------
procedure AIForce.ApplyNeutralizingAngularForce(aXYAngle: single; aHeightAngle: single; aStrength: single);
var
  dX, dY, dH: single;
begin
  dX := cos(aXYAngle) * aStrength;
  dY := sin(aXYAngle) * aStrength;
  dH := cos(aHeightAngle) * sin(aHeightAngle) * aStrength;

  fDeltaX := AdjustValue(fDeltaX, 0.0, dX);
  fDeltaY := AdjustValue(fDeltaY, 0.0, dY);
  fDeltaHeight := AdjustValue(fDeltaHeight, 0.0, dH);
end;

// ----------------------------------------------------------------------------
procedure AIForce.ReverseY;
begin
  fDeltaY := fDeltaY * -1.0;
end;

// ----------------------------------------------------------------------------
function AIForce.Strength: single;
begin
  result := abs(fDeltaX) + abs(fDeltaY) + abs(fDeltaHeight);
end;

// ----------------------------------------------------------------------------
function AIForce.XYStrength: single;
begin
  result := abs(fDeltaX) + abs(fDeltaY);
end;

// ----------------------------------------------------------------------------
procedure AIForce.Invert;
begin
  fDeltaX := fDeltaX * -1.0;
  fDeltaY := fDeltaY * -1.0;
  fDeltaHeight := fDeltaHeight * -1.0;
end;

// ----------------------------------------------------------------------------
procedure AIForce.InvertXY;
begin
  fDeltaX := fDeltaX * -1.0;
  fDeltaY := fDeltaY * -1.0;
end;

// ----------------------------------------------------------------------------
procedure AIForce.InvertY;
begin
  fDeltaY := fDeltaY * -1.0;
end;

// ----------------------------------------------------------------------------
procedure AIForce.InvertX;
begin
  fDeltaX := fDeltaX * -1.0;
end;

// ----------------------------------------------------------------------------
procedure AIForce.InvertHeight;
begin
  fDeltaHeight := fDeltaHeight * -1.0;
end;


// ----------------------------------------------------------------------------
function AIForce.OneLineDisplay: string;
begin
  result :=
    Format('dX=%0.2f, dY=%0.2f, dH=%0.2f', [fDeltaX, fDeltaY, fDeltaHeight]);
end;

// ----------------------------------------------------------------------------
procedure AIForce.SaveToFile(var aFile: TextFile);
begin
  writeln(aFile, fDeltaX);
  writeln(aFile, fDeltaY);
  writeln(aFile, fDeltaHeight);
end;

// ----------------------------------------------------------------------------
procedure AIForce.LoadFromFile(var aFile: TextFile);
begin
  readln(aFile, fDeltaX);
  readln(aFile, fDeltaY);
  readln(aFile, fDeltaHeight);
end;

// ----------------------------------------------------------------------------
procedure AIForce.ApplyMassiveForce(aForce: AIForce; aMass: single);
begin
  if not (aForce.DeltaX = 0.0) then
    fDeltaX := fDeltaX + aForce.DeltaX / aMass;

  if not (aForce.DeltaY = 0.0) then
    fDeltaY := fDeltaY + aForce.DeltaY / aMass;

  if not (aForce.DeltaHeight = 0.0) then
    fDeltaHeight := fDeltaHeight + aForce.DeltaHeight / aMass;
end;

// ----------------------------------------------------------------------------
function AIForce.Stale: boolean;
begin
  result := ((fDeltaX = 0.0) and (fDeltaY = 0.0) and (fDeltaHeight = 0.0));
end;

// ----------------------------------------------------------------------------
procedure AIForce.LimitForce;
begin
  if (fDeltaX > 5.0) then fDeltaX := 5.0;
  if (fDeltaX < -5.0) then fDeltaX := -5.0;

  if (fDeltaY > 5.0) then fDeltaY := 5.0;
  if (fDeltaY < -5.0) then fDeltaY := -5.0;

  if (fDeltaHeight > 5.0) then fDeltaHeight := 5.0;
  if (fDeltaHeight < -5.0) then fDeltaHeight := -5.0;
end;

// ----------------------------------------------------------------------------
procedure AIForce.Shrink(aAmount: single);
var
  n: TAffineVector;
begin
  n.X := fDeltaX;
  n.Y := fDeltaY;
  n.Z := fDeltaHeight;
  NormalizeVector(n);
  ScaleVector(n, aAmount);

  if abs(n.X) < abs(fDeltaX) then
  begin
    fDeltaX := fDeltaX - n.X;
    fDeltaY := fDeltaY - n.Y;
    fDeltaHeight := fDeltaHeight - n.Z;
  end
  else
  begin
    fDeltaX := 0.0;
    fDeltaY := 0.0;
    fDeltaHeight := 0.0;
  end;
end;

// ----------------------------------------------------------------------------
function AIForce.Length: single;
begin
  result := sqrt(fDeltaX*fDeltaX + fDeltaY*fDeltaY + fDeltaHeight*fDeltaHeight);
end;

// ----------------------------------------------------------------------------
function AIForce.AsAffineVector: TAffineVector;
begin
  result.X := fDeltaX;
  result.Y := fDeltaY;
  result.Z := fDeltaHeight;
end;

// ----------------------------------------------------------------------------
procedure AIForce.LimitSpeed(aMax: single);
var
  mySpeed: single;
begin
  mySpeed := Length;

  if mySpeed > aMax then
  begin
    fDeltaX := (fDeltaX / mySpeed) * aMax;
    fDeltaY := (fDeltaY / mySpeed) * aMax;
    fDeltaHeight := (fDeltaHeight / mySpeed) * aMax;
  end;
end;

// ----------------------------------------------------------------------------
function AIForce.Valid: boolean;
begin
  result := not (IsNan(fDeltaX) or IsNan(fDeltaY) or IsNan(fDeltaHeight));
end;

// ----------------------------------------------------------------------------
procedure AIForce.AlterDeltaX(aAmount: single);
begin
  DeltaX := DeltaX + aAmount;
end;

// ----------------------------------------------------------------------------
procedure AIForce.AlterDeltaY(aAmount: single);
begin
  DeltaY := DeltaY + aAmount;
end;

// ----------------------------------------------------------------------------
procedure AIForce.AlterDeltaHeight(aAmount: single);
begin
  DeltaHeight := DeltaHeight + aAmount;
end;

end.
