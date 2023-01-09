{
  ai.planet
  http://aiplanet.sourceforge.net
  A community: Community, herd, school, etc
}
unit cAICommunity;

interface

uses
  System.Classes,
  System.Contnrs,
  System.Types,
  cAIBaseObject,
  cAIThings,
  cAIPosition,
  cAILife,
  cAILink,
  cAICreature,

  GLS.VectorTypes,
  GLS.VectorGeometry;

const
  cPatternNone = 0;        // fly normally
  cPatternEclipse = 1;          // fly in a horizontal eclipse
  cPatternEclipseReverse = 2;   // fly other way eclipse
  cPatternRight = 3;
  cPatternLeft = 4;

type

// ============================================================================
AICommunity = Class(AILivingGroup)
private
  fPattern: integer;        // movement of the group
  fCenter: TAffineVector;   // center coordinate of the group
  fVelocity: TAffineVector; // average velocity of the group
  fAngle: single;           // direction Community is flying
  fAdmit: integer;          // Kind of members
protected
  procedure CalculateCenters;
public
  Constructor Create(aParent: pointer);
  Destructor Destroy; override;

  property Pattern: integer read fPattern write fPattern;
  property Center: TAffineVector read fCenter;
  property Velocity: TAffineVector read fVelocity;
  property Angle: single read fAngle write fAngle;
  property Admit: integer read fAdmit write fAdmit;

  function AddMember(aMember: AIThing): boolean; override;
  procedure NotifyOfDeath(aThing: AIThing);

  procedure Fuel; override;
  function OneLineDisplay: string; override;

  procedure FullDisplay(aList: TStrings); override;
  procedure SaveToFile(var aFile: TextFile); override;
  procedure LoadFromFile(var aFile: TextFile); override;
end;

// ============================================================================
AICommunityCreature = Class(AICreature)
private
  fCommunity: AILink;   // community this creature belongs to
  fAvoidance: TAffineVector;
  fBump: boolean;
protected
  function CommunityAvoidance(aBubble: single): TAffineVector;
  function CommunityAvoidanceXY(aBubble: single): TAffineVector;
  procedure JoinCommunity;
  procedure LeaveCommunity;

//  procedure FlyWithCommunity;
//  procedure TravelWithCommunity;
  procedure SwimWithCommunity;
public
  Constructor Create(aParent: pointer);
  Destructor Destroy; override;

  property Community: AILink read fCommunity;
  property Avoidance: TAffineVector read fAvoidance write fAvoidance;
  property Bump: boolean read fBump write fBump;

  procedure AvoidNeighbour;

  procedure Fuel; override;
  procedure Die; override;
  procedure Cease; override;

  procedure ReaffirmCommunity; // for loading
  procedure FullDisplay(aList: TStrings); override;
  procedure SaveToFile(var aFile: TextFile); override;
  procedure LoadFromFile(var aFile: TextFile); override;
end;

implementation

uses
  cAIReality, System.SysUtils, cGlobals, cAITrees, cAIVibes, cUtilities, cAIFish;

// ----------------------------------------------------------------------------
Constructor AICommunity.Create(aParent: pointer);
begin
  inherited Create(aParent);

  Kind := cCommunity;
  fPattern := cPatternEclipse;
  Maximum := Random(32) + 8;
  Position.Tangible := false;
  Position.Collider := false;
end;

// ----------------------------------------------------------------------------
destructor AICommunity.Destroy;
begin

  inherited Destroy;
end;

// ----------------------------------------------------------------------------
procedure AICommunity.Fuel;
begin
  inherited Fuel;

  fAngle := fAngle + ca2;
  if fAngle >= TwoPi then
  begin
    fAngle := 0;
    fPattern := Random(5);
  end;

  //if Age mod 4 = 0 then
    CalculateCenters;
  Position.SetPosition(Center.X, Center.Y, Center.Z);
//  CalculateAvoidances;
end;

// ----------------------------------------------------------------------------
// finds center of Community (avg of all members)
// and finds velocity of Community (avg of all members)
procedure AICommunity.CalculateCenters;
var
  myCreature, myNeighbour: AICommunityCreature;
  i, j, RigidCount: integer;
  Participation: integer;
  myDistance: single;
  myAvoidance: TAffineVector;
begin
  Participation := 0;
  RigidCount := Members.Count - 1;

  // reset to 0
  fCenter.X := 0;
  fCenter.Y := 0;
  fCenter.Z := 0;
  fVelocity.X := 0;
  fVelocity.Y := 0;
  fVelocity.Z := 0;

  // for all birds
  for i := 0 to Members.Count - 1 do
  begin
    myCreature := AICommunityCreature(Members.Items[i]);
    // add to center
    fCenter.X := fCenter.X + myCreature.Position.X;
    fCenter.Y := fCenter.Y + myCreature.Position.Y;
    fCenter.Z := fCenter.Z + myCreature.Position.Height;
    // if bird is Communitying then add it to Community count
    if not (myCreature.Desire = cDesireFood) then
    begin
      // add to velocity, if the bird is Communitying
      fVelocity.X := fVelocity.X + myCreature.Position.Velocity.DeltaX;        // crashed here once
      fVelocity.Y := fVelocity.Y + myCreature.Position.Velocity.DeltaY;
      fVelocity.Z := fVelocity.Z + myCreature.Position.Velocity.DeltaHeight;
      Participation := Participation + 1;
    end;

    myCreature.Bump := false;
    myAvoidance.X := 0;
    myAvoidance.Y := 0;
    myAvoidance.Z := 0;
    for j := 0 to Members.Count - 1 do
      if i <> j then
        begin
          myNeighbour := AICommunityCreature(Members.Items[j]);
          myDistance := myCreature.Position.SimpleDistanceTo(myNeighbour.Position);
          if myDistance < (0.2 + myCreature.Size + myNeighbour.Size)/2 then
          begin
            myAvoidance.X := myAvoidance.X + (myCreature.Position.X - myNeighbour.Position.X) * 0.05;
            myAvoidance.Y := myAvoidance.Y + (myCreature.Position.Y - myNeighbour.Position.Y) * 0.05;
            myAvoidance.Z := myAvoidance.Z + (myCreature.Position.Height - myNeighbour.Position.Height) * 0.05;
            myCreature.Bump := true;
          end;
        end;
    myCreature.Avoidance := myAvoidance;
  end;

  // calculate the average center position
  RigidCount := RigidCount + 1;
  fCenter.X := fCenter.X / (RigidCount);
  fCenter.Y := fCenter.Y / (RigidCount);
  fCenter.Z := fCenter.Z / (RigidCount);

  case fPattern of
    cPatternEclipse:
    begin
      fCenter.X := fCenter.X + 25*sin(fAngle) + 2.5;
      fCenter.Y := fCenter.Y - 5*cos(fAngle);
      fCenter.Z := fCenter.Z;
    end;
    cPatternEclipseReverse:
    begin
      fCenter.X := fCenter.X + 25*cos(fAngle) - 2.5;
      fCenter.Y := fCenter.Y - 5*sin(fAngle);
      fCenter.Z := fCenter.Z;
    end;
    cPatternRight:
      fCenter.X := fCenter.X + 2.5;
    cPatternLeft:
      fCenter.X := fCenter.X - 2.5;
  end;

  // calculate the average velocity
  if Participation <> 0 then
  begin
    fVelocity.X := fVelocity.X / (Participation*80);
    fVelocity.Y := fVelocity.Y / (Participation*80);
    fVelocity.Z := fVelocity.Z / (Participation*80);
  end;
end;

// ----------------------------------------------------------------------------
Constructor AICommunityCreature.Create(aParent: pointer);
begin
  inherited Create(aParent);

  fCommunity := gEnvironment.References.NewLink(self);
end;

// ----------------------------------------------------------------------------
destructor AICommunityCreature.Destroy;
begin
  LeaveCommunity;
  gEnvironment.References.Remove(fCommunity);

  inherited Destroy;
end;

// ----------------------------------------------------------------------------
// assumes in a flock
// avoid any nearby birds
function AICommunityCreature.CommunityAvoidance(aBubble: single): TAffineVector;
var
  myFriend: AICommunityCreature;
  i, RigidCount: integer;
  myCommunity: AICommunity;
begin
  myCommunity := AICommunity(Community.Target);
  RigidCount := myCommunity.Members.Count - 1;

  // find the first creature that is nearby and return avoidance vector
  for i := 0 to RigidCount do
  begin
    myFriend := AICommunityCreature(myCommunity.Members.Items[i]);
    if (myFriend <> self) then
    begin
      if Position.SimpleDistanceTo(myFriend.Position)/2 < aBubble then
      begin
        result.X := result.X + (Position.X - myFriend.Position.X) * 0.025;
        result.Y := result.Y + (Position.Y - myFriend.Position.Y) * 0.025;
        result.Z := result.Z + (Position.Height - myFriend.Position.Height) * 0.025;
        break;
      end;
    end;
  end;
end;

// ----------------------------------------------------------------------------
// assumes in a flock
// avoid any nearby birds
function AICommunityCreature.CommunityAvoidanceXY(aBubble: single): TAffineVector;
var
  myFriend: AICommunityCreature;
  i, RigidCount: integer;
  myCommunity: AICommunity;
begin
  myCommunity := AICommunity(Community.Target);
  RigidCount := myCommunity.Members.Count;

  for i := 0 to RigidCount - 1 do
  begin
    myFriend := AICommunityCreature(myCommunity.Members.Items[i]);
    if (myFriend <> self) then
    begin
      if Position.SimpleDistanceToXY(myFriend.Position) < aBubble then
      begin
        result.X := result.X + (Position.X - myFriend.Position.X) * 0.05;
        result.Y := result.Y + (Position.Y - myFriend.Position.Y) * 0.05;
        break;
      end;
    end;
  end;
end;

// ----------------------------------------------------------------------------
procedure AICommunityCreature.JoinCommunity;
var
  myCommunity: AICommunity;
begin
  // already in a community?
  if Community.ValidTarget then
    exit;

  // find an existing community with vacancy
  myCommunity := gThings.Tables[cCommunity].CommunityWithRoom(Kind);

  // if there are no Communitys, create one
  if (myCommunity = nil) and (gThings.CanAdd(cCommunity)) then
  begin
    myCommunity := AICommunity(gThings.NewThing(cCommunity));
    myCommunity.Admit := Kind; // set this community to allow only my kind
  end;

  // if valid community, then join it
  if (myCommunity <> nil) then
  begin
    // add self to Community member list
    if myCommunity.AddMember(self) then
      Community.AssignTarget(myCommunity);
  end;
end;

// ----------------------------------------------------------------------------
procedure AICommunityCreature.LeaveCommunity;
begin
  if Community.ValidTarget then
  begin
    AICommunity(Community.Target).RemoveMember(self);
    Community.InvalidateTarget;
  end;
end;

// ----------------------------------------------------------------------------
procedure AICommunityCreature.Fuel;
begin
  inherited Fuel;

  if (Age mod 64 = 0) then
    if not Community.ValidTarget then
      JoinCommunity;
end;

// ----------------------------------------------------------------------------
procedure AICommunityCreature.Die;
begin
  inherited Die;

  LeaveCommunity;
end;

// ----------------------------------------------------------------------------
procedure AICommunityCreature.Cease;
begin
  LeaveCommunity;
  gThings.Tables[cCommunity].NotifyAllCommunitiesOfDeath(self);

  inherited Cease;
end;

// ----------------------------------------------------------------------------
procedure AICommunityCreature.SaveToFile(var aFile: TextFile);
begin
  inherited SaveToFile(aFile);
  fCommunity.SaveToFile(aFile);
  writeVector(aFile, fAvoidance);
  writeFileBoolean(aFile, fBump);
end;

// ----------------------------------------------------------------------------
procedure AICommunityCreature.LoadFromFile(var aFile: TextFile);
begin
  inherited LoadFromFile(aFile);
  fCommunity.LoadFromFile(aFile);
  readVector(aFile, fAvoidance);
  fBump := readFileBoolean(aFile);
end;

// ----------------------------------------------------------------------------
// returns true if the member was added,
// returns false if group is full
function AICommunity.AddMember(aMember: AIThing): boolean;
begin
  result := false;

  // valid member?
  if aMember.Kind <> fAdmit then
    exit;

  // already in a community?
  if AICommunityCreature(aMember).Community.ValidTarget then
    exit;

  // add member
  result := inherited AddMember(aMember);

  // assign the community to the new member
  if result then
    AICommunityCreature(aMember).Community.AssignTarget(self);
end;

// ----------------------------------------------------------------------------
function AICommunity.OneLineDisplay: string;
begin
  result := GetName
    + Format(' %d %s=%d/%d Admit=%d Pattern=%d Angle=%0.2f ',
        [Handle, ThingNamePlural(Admit), Members.Count, Maximum, Admit, Pattern, Angle])
    + 'Center=' + VectorToString(fCenter)
    + ' Vel=' + VectorToString(fVelocity);
end;

// ----------------------------------------------------------------------------
procedure AICommunityCreature.SwimWithCommunity;
var
  myCommunity: AICommunity;
  myForce: TAffineVector;
begin
  if not Position.UnderWater then exit;

  // in a Community?
  if Community.ValidTarget then
  begin
    myCommunity := AICommunity(Community.Target);
    // Boids
    // http://www.vergenet.net/~conrad/boids/pseudocode.html
    // Rule 1: Boids try to fly towards the centre of mass of neighbouring boids.
    myForce.X := (myCommunity.Center.X - Position.X) / 100;
    myForce.Y := (myCommunity.Center.Y - Position.Y) / 100;
    myForce.Z := (myCommunity.Center.Z - Position.Height) / 100;
    // Rule 2: Boids try to keep a small distance away from other objects (including other boids).
    if Bump then
    begin
        myForce.X := myForce.X + fAvoidance.X/10;
        myForce.Y := myForce.Y + fAvoidance.Y/10;
        myForce.Z := myForce.Z + fAvoidance.Z/10;
    end;
    // Rule 3: Boids try to match velocity with near boids.
    AddVector(myForce, myCommunity.Velocity);
    Position.Velocity.ApplyForce(myForce);
    // Limiting the speed
    Position.Velocity.LimitSpeed(0.1);
    // Face direction of velocity
    Position.TurnTowardsVelocity(ca30);
    // make sure its underwater
    if Position.Height > (Position.Water-2) then
      Position.Velocity.DeltaHeight := -0.1;
  end
  else // not in a Community
    JoinCommunity;
end;

// ----------------------------------------------------------------------------
procedure AICommunity.SaveToFile(var aFile: TextFile);
begin
  inherited SaveToFile(aFile);
  writeln(aFile, fPattern);
  writeln(aFile, fAngle);
  writeln(aFile, fAdmit);
  writeVector(aFile, fCenter);
  writeVector(aFile, fVelocity);
end;

// ----------------------------------------------------------------------------
procedure AICommunity.LoadFromFile(var aFile: TextFile);
begin
  inherited LoadFromFile(aFile);
  readln(aFile, fPattern);
  readln(aFile, fAngle);
  readln(aFile, fAdmit);
  readVector(aFile, fCenter);
  readVector(aFile, fVelocity);
end;

// ----------------------------------------------------------------------------
procedure AICommunityCreature.AvoidNeighbour;
begin
//  Position.Velocity.ApplyForce(fAvoidance);
  Position.Velocity.ApplyForce(fAvoidance.X/10, fAvoidance.Y/10, fAvoidance.Z/10);
end;

// ----------------------------------------------------------------------------
procedure AICommunity.FullDisplay(aList: TStrings);
begin
  inherited FullDisplay(aList);

  aList.Add('Pattern: ' + IntToStr(fPattern));
  aList.Add('Admit: ' + IntToStr(fAdmit));
  aList.Add('Center: ' + VectorToString(fCenter));
  aList.Add('CVelocity: ' + VectorToString(fVelocity));
  aList.Add(Format('Angle: %0.2f', [fAngle]));
end;

// ----------------------------------------------------------------------------
procedure AICommunityCreature.FullDisplay(aList: TStrings);
begin
  inherited FullDisplay(aList);

  aList.Add('Community: ' + Community.OneLineDisplayRight);
end;

// ----------------------------------------------------------------------------
procedure AICommunity.NotifyOfDeath(aThing: AIThing);
begin
  RemoveMember(aThing);
end;

// ----------------------------------------------------------------------------
procedure AICommunityCreature.ReaffirmCommunity;
var
  myCommunity: AICommunity;
begin
  if Community.ValidTarget then
  begin
    myCommunity := AICommunity(Community.Target);
    Community.InvalidateTarget;
    myCommunity.AddMember(self);
  end;
end;

end.

