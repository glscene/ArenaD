unit cAICoordinates;
{
  Node AICoordinates    - coordinate object for grid
  $Id: cAICoordinates.pas,v 1.9 2003/09/25 19:46:18 uid105088 Exp $

}
interface

uses
  cAIBaseObject;

const
  // directions
  cDirectionUp = 0;
  cDirectionDown = 1;
  cDirectionLeft = 2;
  cDirectionRight = 3;
  cDirectionNone = 4;

  cDirectionNE = 5;
  cDirectionSE = 6;
  cDirectionSW = 7;
  cDirectionNW = 8;

  // angular directions
  caDirectionE = 0;
  caDirectionN = 90;
  caDirectionW = 180;
  caDirectionS = 270;
  caDirectionNE = 45;
  caDirectionNW = 135;
  caDirectionSW = 225;
  caDirectionSE = 315;

  ca360 = Pi/180;
  ca180 = Pi/360; 

  cGridDivision = 16;

  function ReverseDirection(aDirection: integer): integer;

type

// ----------------------------------------------------------------------------
AICoordinates = Class(TObject)
private
  fX: integer;
  fY: integer;
  fXS: single;
  fYS: single;
  procedure SetX(aX: integer);
  procedure SetY(aY: integer);
public
  Constructor Create(
    aParent: pointer;
    aX: integer;
    aY: integer);

  property X: integer read fX write SetX;
  property Y: integer read fY write SetY;
  // XS = X *10.0
  property XS: single read fXS;
  // YS = Y *10.0
  property YS: single read fYS;

  function OneLineDisplay: string;
  function DistanceTo(aDestination: AICoordinates): integer;

  procedure SaveToFile(var aFile: TextFile);
  procedure LoadFromFile(var aFile: TextFile);
end;

implementation

uses
  System.SysUtils,
  GLS.VectorGeometry,
  cAISpace, cAIGrid, cGlobals;

// ----------------------------------------------------------------------------
Constructor AICoordinates.Create(
    aParent: pointer;
    aX: integer;
    aY: integer);
begin
  inherited Create;

  X := aX;
  Y := aY;
end;

// ----------------------------------------------------------------------------
function AICoordinates.OneLineDisplay: string;
begin
  result :=
    'X: ' + IntToStr(X) +
    ', Y: ' + IntToStr(Y);
end;

// ----------------------------------------------------------------------------
procedure AICoordinates.SetX(aX: integer);
begin
  fX := aX;
  fXS := fX * 10.0;
end;

// ----------------------------------------------------------------------------
procedure AICoordinates.SetY(aY: integer);
begin
  fY := aY;
  fYS := fY * 10.0;
end;

// ----------------------------------------------------------------------------
function AICoordinates.DistanceTo(aDestination: AICoordinates): integer;
var
  lX, lY: integer;
begin
  lX := Abs(X - aDestination.X);
{  if (X - aDestination.X + 30) < lX then
    lX := (X - aDestination.X + 30);
  if (aDestination.X - X + 30) < lX then
    lX := (aDestination.X - X + 30);}

  lY := Abs(Y - aDestination.Y);

  result := lX + lY;
end;

// ----------------------------------------------------------------------------
procedure AICoordinates.SaveToFile(var aFile: TextFile);
begin
  writeln(aFile, fX);
  writeln(aFile, fY);
end;

// ----------------------------------------------------------------------------
procedure AICoordinates.LoadFromFile(var aFile: TextFile);
begin
  readln(aFile, fX);
  readln(aFile, fY);
end;

// ----------------------------------------------------------------------------
function ReverseDirection(aDirection: integer): integer;
begin
  case aDirection
  of
    cDirectionUp: result := cDirectionDown;
    cDirectionDown: result := cDirectionUp;
    cDirectionLeft: result := cDirectionRight;
    cDirectionRight: result := cDirectionLeft;
    else result := cDirectionNone;
  end;
end;

end.
