unit cAIThingReferenceList;

interface

uses
  System.Classes,
  System.Contnrs,

  cAIBaseObject,
  cAICoordinates,
  cAIPosition,

  GLS.VectorTypes,
  GLS.VectorGeometry;

type

// ----------------------------------------------------------------------------
AIThingReferenceList = Class(AIReferenceList)
public
  procedure FullDisplay(aList: TStrings); override;

  // basic operations
  function RandomThing: pointer;
  function NearestThing(aPosition: AIPosition): pointer; overload;
  function NearestThing(aPosition: AIPosition; aRange: single): pointer; overload;
  function SimpleNearestThing(aPosition: AIPosition): pointer;
  function NearestAvailableThing(aPosition: AIPosition): pointer;

  function HasKind(aKind: integer): boolean;
  function HasKindAtLocation(aLocation: pointer; aKind: integer): boolean;
  function HasKindWithinDistance(aKind: integer; aPosition: AIPosition; aDistance: single): boolean;
  function HasKindWithinXY(aKind: integer; aX: single; aY: single; aDistance: single): boolean;
  function AmountOfKind(aKind: integer): integer;
  function FirstOfKind(aKind: integer): pointer;
  function RandomOfKind(aKind: integer): pointer;
  function FarthestOfKind(aPosition: AIPosition; aKind: integer): pointer;
  function LastOfKind(aKind: integer): pointer;
  function NearestThing(aGrabber: pointer; aPosition: AIPosition; aRange: single): pointer; overload;
  function NearestOfKind(aKind: integer; aPosition: AIPosition; aRange: single): pointer; overload;
  function NearestOfKind(aKind: integer; aPosition: AIPosition): pointer; overload;
  function NearestOfClass(aClass: AIBaseClass; aPosition: AIPosition; aRange: single): pointer;
  function NearestAvailableOfKind(aKind: integer; aPosition: AIPosition; aRange: single): pointer;
  function NearestAvailableUnderwaterThing(aPosition: AIPosition; aNotKind: integer): pointer;
  function NearestAvailableNotUnderwaterThing(aPosition: AIPosition): pointer;
  function SimpleNearestAvailableOfKind(aKind: integer; aPosition: AIPosition; aRange: single): pointer;
  procedure ApplyOriginatingForceToAll(aOrigin: AIPosition; aStrength: single; aRadius: single);
  procedure ApplyDamage(aOrigin: AIPosition; aDamage: integer; aRadius: single);
  procedure KillEverything;
  procedure KillEveryKind(aKind: integer);
  function AreAllAtLocation(aLocation: pointer): boolean;
  procedure ShakeLand(aStrength: single);

  procedure KillAllPlantsAtLocation(aLocation: pointer);
  procedure KillAllLifeAtLocation(aLocation: pointer);
  procedure CeaseEverythingLocation(aLocation: pointer);
  function DistanceToNearest(aPosition: AIPosition): single;

  // community
  function CommunityWithRoom(aKind: integer): pointer;
  procedure NotifyAllCommunitiesOfDeath(aThing: pointer);

  procedure NearestNeighbours(aPosition: AIPosition; aRange: single; aList: AIThingReferenceList);

  procedure ReportAll;
  procedure ReportAllCreatures;
end;

AIThingTables = array of AIThingReferenceList;
AILocationTables = array of array of AIThingReferenceList;

implementation

uses
  System.SysUtils, cAIThings, cAISatellites, cGlobals, cAICommunity, cUtilities,
  cAILife, cAICreature;

// ----------------------------------------------------------------------------
function AIThingReferenceList.AreAllAtLocation(aLocation: pointer): boolean;
var
  i: integer;
begin
  result := true;

  for i := 0 to Count - 1 do
    if not (AIThing(Items[i]).Position.Location = aLocation) then
      result := false
end;

// ----------------------------------------------------------------------------
function AIThingReferenceList.HasKind(aKind: integer): boolean;
var
  i: integer;
  myThing: AIThing;
begin
  result := false;

  for i := 0 to Count - 1 do
  begin
    myThing := AIThing(Items[i]);

    if (myThing.Kind = aKind) then
      result := true;
  end;
end;

// ----------------------------------------------------------------------------
function AIThingReferenceList.HasKindWithinDistance(
  aKind: integer;
  aPosition: AIPosition;
  aDistance: single): boolean;
var
  i: integer;
  myThing: AIThing;
begin
  result := false;

  for i := 0 to Count - 1 do
  begin
    myThing := AIThing(Items[i]);

    if (myThing.Kind = aKind) and (aPosition.DistancePlusHeightTo(myThing.Position) <= aDistance) then
      result := true;
  end;
end;

// ----------------------------------------------------------------------------
function AIThingReferenceList.AmountOfKind(aKind: integer): integer;
var
  i: integer;
begin
  result := 0;

  for i := 0 to Count - 1 do
    if (AIThing(Items[i]).Kind = aKind) then
      result := result + 1;
end;

// ----------------------------------------------------------------------------
function AIThingReferenceList.FirstOfKind(aKind: integer): pointer;
var
  i: integer;
begin
  result := nil;

  for i := 0 to Count - 1 do
    if (AIThing(Items[i]).Kind = aKind) then
    begin
      result := Items[i];
      exit;
    end;
end;

// ----------------------------------------------------------------------------
function AIThingReferenceList.RandomOfKind(aKind: integer): pointer;
var
  i: integer;
  want: integer;
  pos: integer;
begin
  result := nil;

  pos := 0;
  want := Random(gThings.Counters[aKind]);
//  want := Random(AmountOfKind(aKind));

  for i := 0 to Count - 1 do
    if (AIThing(Items[i]).Kind = aKind) then
    begin
      if pos = want then
        result := Items[i];
      pos := pos + 1;
    end;
end;

// ----------------------------------------------------------------------------
function AIThingReferenceList.LastOfKind(aKind: integer): pointer;
var
  i: integer;
begin
  result := nil;

  for i := Count -1 downto 0 do
    if (AIThing(Items[i]).Kind = aKind) then
    begin
      result := Items[i];
      exit;
    end;
end;

// ----------------------------------------------------------------------------
function AIThingReferenceList.NearestThing(aGrabber: pointer; aPosition: AIPosition; aRange: single): pointer;
var
  myThing: AIThing;
  closest: single;
  distance: single;
  i: integer;
begin
  result := nil;  // closest thing
  closest := aRange + 1;

  for i := 0 to Count - 1 do
  begin
    myThing := AIThing(Items[i]);

    if not (myThing = aGrabber) then
    begin
      distance := aPosition.DistancePlusHeightTo(myThing.Position);
      if (distance <= aRange) and (distance < closest) and not (myThing.Kind = cVibe) then
      begin
        closest := distance;
        result := myThing;
      end;
    end;
  end;
end;

// ----------------------------------------------------------------------------
function AIThingReferenceList.NearestOfKind(aKind: integer; aPosition: AIPosition; aRange: single): pointer;
var
  myThing: AIThing;
  closest: single;
  distance: single;
  i: integer;
begin
  result := nil;  // closest thing
  closest := aRange + 1;

  for i := 0 to Count - 1 do
  begin
    myThing := AIThing(Items[i]);

    if (myThing.Kind = aKind) and not (myThing.Position = aPosition) then
    begin
      distance := aPosition.DistancePlusHeightTo(myThing.Position);
      if (distance <= aRange) and (distance < closest) then
      begin
        closest := distance;
        result := myThing;
      end;
    end;
  end;
end;

// ----------------------------------------------------------------------------
function AIThingReferenceList.NearestOfKind(aKind: integer; aPosition: AIPosition): pointer;
var
  myThing: AIThing;
  closest: single;
  distance: single;
  i: integer;
begin
  result := nil;  // closest thing
  closest := 100000;

  for i := 0 to Count - 1 do
  begin
    myThing := AIThing(Items[i]);

    if (myThing.Kind = aKind) and not (myThing.Position = aPosition) then
    begin
      distance := aPosition.DistancePlusHeightTo(myThing.Position);
      if (distance < closest) then
      begin
        closest := distance;
        result := myThing;
      end;
    end;
  end;
end;

// ----------------------------------------------------------------------------
function AIThingReferenceList.NearestAvailableOfKind(aKind: integer; aPosition: AIPosition; aRange: single): pointer;
var
  myThing: AIThing;
  closest: single;
  distance: single;
  i: integer;
begin
  result := nil;  // closest thing
  closest := aRange + 1;

  for i := 0 to Count - 1 do
  begin
    myThing := AIThing(Items[i]);

    if (myThing.Kind = aKind) and not (myThing.Position = aPosition) and not (myThing.Position.Carried) then
    begin
      distance := aPosition.DistancePlusHeightTo(myThing.Position);
      if (distance <= aRange) and (distance < closest) then
      begin
        closest := distance;
        result := myThing;
      end;
    end;
  end;
end;

// ----------------------------------------------------------------------------
function AIThingReferenceList.FarthestOfKind(aPosition: AIPosition; aKind: integer): pointer;
var
  myThing: AIThing;
  farthest: single;
  distance: single;
  i: integer;
begin
  result := nil;  // closest thing
  farthest := 0;

  for i := 0 to Count - 1 do
  begin
    myThing := AIThing(Items[i]);

    if myThing.Kind = aKind then
    begin
      distance := aPosition.DistancePlusHeightTo(myThing.Position);
      if (distance > farthest) then
      begin
        farthest := distance;
        result := myThing;
      end;
    end;
  end;
end;

// ----------------------------------------------------------------------------
procedure AIThingReferenceList.ApplyOriginatingForceToAll(
  aOrigin: AIPosition;
  aStrength: single;
  aRadius: single);
var
  i: integer;
  distance: single;
  myThing: AIThing;
  myVect: TGLVector;
begin
  for i := 0 to Count - 1 do
  begin
    myThing := AIThing(Items[i]);

    if not (myThing.Position = aOrigin) and not (myThing.Kind = cExplosion) then
      begin
      distance := aOrigin.DistancePlusHeightTo(myThing.Position);

      if distance < aRadius then
      begin
        if distance < 1 then distance := 1;
        myVect.X := aStrength * (myThing.Position.X - aOrigin.X) / (distance);
        myVect.Y := aStrength * (myThing.Position.Y - aOrigin.Y) / (distance);
        myVect.Z := aStrength * (myThing.Position.Height - (aOrigin.Height-1)) / (distance);

        myThing.Position.Acceleration.ApplyForce(myVect.X, myVect.Y, myVect.Z);
      end;
    end;
  end;
end;

// ----------------------------------------------------------------------------
procedure AIThingReferenceList.ApplyDamage(aOrigin: AIPosition; aDamage: integer; aRadius: single);
var
  i: integer;
  distance: single;
  myThing: AIThing;
begin
  for i := 0 to Count - 1 do
  begin
    myThing := AIThing(Items[i]);

    if not (myThing.Position = aOrigin) and not (myThing.Kind = cExplosion) then
      begin
      distance := aOrigin.DistancePlusHeightTo(myThing.Position);

      if distance < aRadius then
        myThing.Damage(aDamage);
    end;
  end;
end;

// ----------------------------------------------------------------------------
procedure AIThingReferenceList.KillEverything;
var
  i: integer;
begin
  for i := 0 to Count - 1 do
    AIThing(Items[i]).Cease;
end;

// ----------------------------------------------------------------------------
procedure AIThingReferenceList.KillEveryKind(aKind: integer);
var
  i: integer;
begin
  for i := 0 to Count - 1 do
    if AIThing(Items[i]).Kind = aKind then
      AIThing(Items[i]).Cease;
end;

// ----------------------------------------------------------------------------
function AIThingReferenceList.HasKindWithinXY(
  aKind: integer;
  aX: single; aY: single;
  aDistance: single): boolean;
var
  i: integer;
  myThing: AIThing;
  dX, dY: single;
begin
  result := false;

  for i := 0 to Count - 1 do
  begin
    myThing := AIThing(Items[i]);

    if (myThing.Kind = aKind) then
    begin
      dx := (aX - myThing.Position.X);
      dy := (aY - myThing.Position.Y);
      if (Sqrt(dx*dx + dy*dy) <= aDistance) then
        result := true;
    end;
  end;
end;

// ----------------------------------------------------------------------------
function AIThingReferenceList.NearestOfClass(aClass: AIBaseClass; aPosition: AIPosition; aRange: single): pointer;
var
  myThing: AIThing;
  closest: single;
  distance: single;
  i: integer;
begin
  result := nil;  // closest thing
  closest := aRange + 1;

  for i := 0 to Count - 1 do
  begin
    myThing := AIThing(Items[i]);

    if (myThing is aClass) and not (myThing.Position = aPosition) then
    begin
      distance := aPosition.DistancePlusHeightTo(myThing.Position);
      if (distance <= aRange) and (distance < closest) then
      begin
        closest := distance;
        result := myThing;
      end;
    end;
  end;
end;

// ----------------------------------------------------------------------------
function AIThingReferenceList.RandomThing: pointer;
var
  want: integer;
begin
  result := nil;
  if Count > 0 then
  begin
    want := Random(Count);
    result := Items[want];
  end;
end;

// ----------------------------------------------------------------------------
function AIThingReferenceList.NearestThing(aPosition: AIPosition): pointer;
var
  myThing: AIThing;
  closest: single;
  distance: single;
  i: integer;
begin
  result := nil;  // closest thing
  closest := 100000;

  for i := 0 to Count - 1 do
  begin
    myThing := AIThing(Items[i]);

    distance := aPosition.DistancePlusHeightTo(myThing.Position);
    if (myThing.Position <> aPosition) and (distance < closest) then
    begin
      closest := distance;
      result := myThing;
    end;
  end;
end;

// ----------------------------------------------------------------------------
function AIThingReferenceList.NearestThing(aPosition: AIPosition; aRange: single): pointer;
var
  myThing: AIThing;
  closest: single;
  distance: single;
  i: integer;
begin
  result := nil;  // closest thing
  closest := aRange + 1;

  for i := 0 to Count - 1 do
  begin
    myThing := AIThing(Items[i]);

    distance := aPosition.DistancePlusHeightTo(myThing.Position);
    if (distance <= aRange) and (distance < closest) and not (myThing.Kind = cVibe) then
    begin
      closest := distance;
      result := myThing;
    end;
  end;
end;

// ----------------------------------------------------------------------------
function AIThingReferenceList.HasKindAtLocation(aLocation: pointer; aKind: integer): boolean;
var
  i: integer;
  myThing: AIThing;
begin
  result := false;

  for i := 0 to Count - 1 do
  begin
    myThing := AIThing(Items[i]);

    if (myThing.Kind = aKind) and (myThing.Position = aLocation) then
      result := true;
  end;
end;

// ----------------------------------------------------------------------------
function AIThingReferenceList.CommunityWithRoom(aKind: integer): pointer;
var
  i: integer;
  myCommunity: AICommunity;
begin
  result := nil;

  for i := 0 to Count - 1 do
  begin
    myCommunity := AICommunity(Items[i]);

    if (myCommunity.Admit = aKind) and (myCommunity.Vacancy) then
      result := myCommunity;
  end;
end;

// ----------------------------------------------------------------------------
function AIThingReferenceList.SimpleNearestThing(aPosition: AIPosition): pointer;
var
  myThing: AIThing;
  closest: single;
  distance: single;
  i: integer;
begin
  result := nil;  // closest thing
  closest := 100000;

  for i := 0 to Count - 1 do
  begin
    myThing := AIThing(Items[i]);

    if aPosition <> myThing.Position then
    begin
      distance := aPosition.SimpleDistanceTo(myThing.Position);
      if (distance < closest) then
      begin
        closest := distance;
        result := myThing;
      end;
    end;
  end;
end;

// ----------------------------------------------------------------------------
procedure AIThingReferenceList.NotifyAllCommunitiesOfDeath(aThing: pointer);
var
  i: integer;
  myCommunity: AICommunity;
begin
  for i := 0 to Count - 1 do
  begin
    myCommunity := AICommunity(Items[i]);

    if (myCommunity.Admit = AIThing(aThing).Kind) then
      myCommunity.NotifyOfDeath(aThing);
  end;
end;

// ----------------------------------------------------------------------------
function AIThingReferenceList.SimpleNearestAvailableOfKind(aKind: integer; aPosition: AIPosition; aRange: single): pointer;
var
  myThing: AIThing;
  closest: single;
  distance: single;
  i: integer;
begin
  result := nil;  // closest thing
  closest := aRange + 1;

  for i := 0 to Count - 1 do
  begin
    myThing := AIThing(Items[i]);

    if (myThing.Kind = aKind) and not (myThing.Position = aPosition) and not (myThing.Position.Carried) then
    begin
      distance := aPosition.SimpleDistanceTo(myThing.Position);
      if (distance <= aRange) and (distance < closest) then
      begin
        closest := distance;
        result := myThing;
      end;
    end;
  end;
end;

// ----------------------------------------------------------------------------
// find the n nearest neighbours to aPosition
procedure AIThingReferenceList.NearestNeighbours(
  aPosition: AIPosition;
  aRange: single;
  aList: AIThingReferenceList);
var
  myThing: AIThing;
  distance: single;
  i: integer;
begin
  for i := 0 to Count - 1 do
  begin
    myThing := AIThing(Items[i]);

    distance := aPosition.DistancePlusHeightTo(myThing.Position);
    if (myThing.Position <> aPosition) and (distance < aRange) then
      aList.Add(myThing);
  end;
end;

// ----------------------------------------------------------------------------
procedure AIThingReferenceList.FullDisplay(aList: TStrings);
var
  myThing: AIThing;
  i: integer;
begin
  for i := 0 to Count - 1 do
  begin
    myThing := AIThing(Items[i]);
    aList.Add(myThing.OneLineDisplay);
  end;
end;

// ----------------------------------------------------------------------------
procedure AIThingReferenceList.ShakeLand(aStrength: single);
var
  i: integer;
  myThing: AIThing;
begin
  for i := 0 to Count - 1 do
  begin
    myThing := AIThing(Items[i]);

    if myThing.Position.Binding = bindLand then
    begin
      myThing.Position.Velocity.ApplyForce(
        RandomSwing*aStrength/2,
        RandomSwing*aStrength/2,
        aStrength);
    end;

  end;
end;

// ----------------------------------------------------------------------------
function AIThingReferenceList.NearestAvailableThing(aPosition: AIPosition): pointer;
var
  myThing: AIThing;
  closest: single;
  distance: single;
  i: integer;
begin
  result := nil;  // closest thing
  closest := 100000;

  for i := 0 to Count - 1 do
  begin
    myThing := AIThing(Items[i]);

    distance := aPosition.DistancePlusHeightTo(myThing.Position);
    if (distance < closest) and (myThing.Position <> aPosition) and (not myThing.Position.Carried) then
    begin
      closest := distance;
      result := myThing;
    end;
  end;
end;

// ----------------------------------------------------------------------------
function AIThingReferenceList.NearestAvailableUnderwaterThing(aPosition: AIPosition; aNotKind: integer): pointer;
var
  myThing: AIThing;
  closest: single;
  distance: single;
  i: integer;
begin
  result := nil;  // closest thing
  closest := 100000;

  for i := 0 to Count - 1 do
  begin
    myThing := AIThing(Items[i]);

    distance := aPosition.DistancePlusHeightTo(myThing.Position);
    if (distance < closest) and (myThing.Position.UnderWater) and (myThing.Kind <> aNotKind)
      and (myThing.Position <> aPosition) and (not myThing.Position.Carried) then
    begin
      closest := distance;
      result := myThing;
    end;
  end;
end;

// ----------------------------------------------------------------------------
function AIThingReferenceList.NearestAvailableNotUnderwaterThing(aPosition: AIPosition): pointer;
var
  myThing: AIThing;
  closest: single;
  distance: single;
  i: integer;
begin
  result := nil;  // closest thing
  closest := 100000;

  for i := 0 to Count - 1 do
  begin
    myThing := AIThing(Items[i]);

    distance := aPosition.DistancePlusHeightTo(myThing.Position);
    if (distance < closest) and (not myThing.Position.UnderWater)
      and (not myThing.Position.Carried) then
    begin
      closest := distance;
      result := myThing;
    end;
  end;
end;

// ----------------------------------------------------------------------------
procedure AIThingReferenceList.KillAllPlantsAtLocation(aLocation: pointer);
var
  i: integer;
  myThing: AIThing;
begin
  for i := 0 to Count - 1 do
  begin
    myThing := AIThing(Items[i]);
    if (myThing.Position.Location = aLocation) and (myThing.IsPlant) then
      myThing.Cease;
  end;
end;

// ----------------------------------------------------------------------------
procedure AIThingReferenceList.KillAllLifeAtLocation(aLocation: pointer);
var
  i: integer;
  myThing: AIThing;
begin
  for i := 0 to Count - 1 do
  begin
    myThing := AIThing(Items[i]);
    if (myThing.Position.Location = aLocation) and (myThing is AILivingThing)
    and (AILivingThing(myThing).Alive) then
      AILivingThing(myThing).Die;
  end;
end;

// ----------------------------------------------------------------------------
procedure AIThingReferenceList.CeaseEverythingLocation(aLocation: pointer);
var
  i: integer;
  myThing: AIThing;
begin
  for i := 0 to Count - 1 do
  begin
    myThing := AIThing(Items[i]);
    if (myThing.Position.Location = aLocation)then
      myThing.Cease;
  end;
end;

// ----------------------------------------------------------------------------
procedure AIThingReferenceList.ReportAll;
var
  i: integer;
  myThing: AIThing;
begin
  for i := 0 to Count - 1 do
  begin
    myThing := AIThing(Items[i]);
    myThing.Report;
  end;
end;

// ----------------------------------------------------------------------------
procedure AIThingReferenceList.ReportAllCreatures;
var
  i: integer;
  myThing: AIThing;
begin
  for i := 0 to Count - 1 do
  begin
    myThing := AIThing(Items[i]);
    if myThing is AICreature then
      myThing.Report;
  end;
end;

// ----------------------------------------------------------------------------
function AIThingReferenceList.DistanceToNearest(aPosition: AIPosition): single;
var
  i: integer;
  dist: single;
  myThing: AIThing;
begin
  result := 100;
  for i := 0 to Count - 1 do
  begin
    myThing := AIThing(Items[i]);
    dist := aPosition.DistanceToXPlusY(myThing.Position);
    if result > dist then
      result := dist;
  end;
end;

end.
