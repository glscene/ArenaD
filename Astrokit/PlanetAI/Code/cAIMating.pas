{
  ai.planet
  http://aiplanet.sourceforge.net
  by David Kerr
  A mating creature can be reproduced with another creature of the same kind
  Must be in a community
}
unit cAIMating;

interface

uses
  System.Classes,
  System.Contnrs,
  System.SysUtils,
  System.Types,
  cAIBaseObject,
  cAIThings,
  cAIPosition,
  cAILife,
  cAILink,
  cAICreature,
  cAICommunity;

const
  cCreatureBaby = 0;
  cCreatureAdult = 1;
  cCreatureElder = 2;

type

// ============================================================================
AIMatingCreature = Class(AICommunityCreature)
private
  fPartner: AILink; // potential partner to reproduce with
  fFemale: boolean; // true if girl, false if guy
  fStage: integer;  // stage of sexual reproduction
  fMatingTimer: integer; // timer to delay mating
protected
  procedure MatingBehaviour;
  procedure FindMate;
  procedure MateWithPartner; virtual;
  procedure DevelopIntoBaby; virtual; abstract;
  procedure FindMateNoRestraints;
  procedure MatingBehaviourNoRestraints;
  procedure MateWithPartnerNoRestraints; virtual; abstract;
public
  Constructor Create(aParent: pointer);
  Destructor Destroy; override;
  procedure Fuel; override;
  procedure Die; override;
  procedure Cease; override;
  property Partner: AILink read fPartner;
  property Female: boolean read fFemale write fFemale;
  property Stage: integer read fStage write fStage;
  property MatingTimer: integer read fMatingTimer write fMatingTimer;
  function OneLineDisplay: string; override;
  procedure FullDisplay(aList: TStrings); override;
  procedure SaveToFile(var aFile: TextFile); override;
  procedure LoadFromFile(var aFile: TextFile); override;
end;

implementation

uses
  cAIReality,
  cGlobals,
  cAITrees,
  cAIVibes,
  cUtilities,
  cAIFish;

// ----------------------------------------------------------------------------
Constructor AIMatingCreature.Create(aParent: pointer);
begin
  inherited Create(aParent);

  fPartner := gEnvironment.References.NewLink(self);
  // random gender
  if Random(2) = 0 then
    fFemale := false
  else
    fFemale := true;
  fStage := cCreatureBaby;
  fMatingTimer := 0;
end;

// ----------------------------------------------------------------------------
destructor AIMatingCreature.Destroy;
begin
  gEnvironment.References.Remove(fPartner);

  inherited Destroy;
end;

// ----------------------------------------------------------------------------
procedure AIMatingCreature.Fuel;
begin
  inherited Fuel;

  case fStage of
    cCreatureBaby:  if Age > 1024 then fStage := cCreatureAdult;
    cCreatureAdult: if Age > 9500 then fStage := cCreatureElder;
    cCreatureElder: if Age > 10000 then Die;
  end;
end;

// ----------------------------------------------------------------------------
procedure AIMatingCreature.Die;
begin
  inherited Die;

  fPartner.InvalidateTarget;
end;

// ----------------------------------------------------------------------------
procedure AIMatingCreature.Cease;
begin
  fPartner.InvalidateTarget;

  inherited Cease;
end;

// ----------------------------------------------------------------------------
procedure AIMatingCreature.SaveToFile(var aFile: TextFile);
begin
  inherited SaveToFile(aFile);
  fPartner.SaveToFile(aFile);
  writeFileBoolean(aFile, fFemale);
  writeln(aFile, fStage);
end;

// ----------------------------------------------------------------------------
procedure AIMatingCreature.LoadFromFile(var aFile: TextFile);
begin
  inherited LoadFromFile(aFile);
  fPartner.LoadFromFile(aFile);
  fFemale := readFileBoolean(aFile);
  readln(aFile, fStage);
end;

// ----------------------------------------------------------------------------
procedure AIMatingCreature.MatingBehaviour;
begin
  // must be in a community
  if not Community.ValidTarget then
    exit;
  // must be room in the community for a baby
  if AICommunity(Community.Target).Full then
  begin
    Partner.InvalidateTarget;
    exit;
  end;

  // look for a partner
  if not Partner.ValidTarget then
    FindMate
  else
    // if female, mate with partner
    if (Health >= 1024) then
      MateWithPartner;
end;

// ----------------------------------------------------------------------------
// assumes in a community
procedure AIMatingCreature.FindMate;
var
  myCommunity: AICommunity;
  i: integer;
  myMate: AIMatingCreature;
begin
  myCommunity := AICommunity(Community.Target);
  // if too many in this community, dont breed
  if myCommunity.Full then exit;
  // find a mate
  for i := 0 to myCommunity.Members.Count - 1 do
  begin
    myMate := AIMatingCreature(myCommunity.Members[i]);
    if (Female <> myMate.Female)
    and (myMate.Stage = cCreatureAdult)
    and ((myMate.Partner.Target = nil) or (myMate.Partner.Target = self)) 
    then
      Partner.AssignTarget(myMate);
  end;
end;

// ----------------------------------------------------------------------------
// assumes in a community
// assumes has a partner
procedure AIMatingCreature.MateWithPartner;
var
  myMate: AIMatingCreature;
  myBaby: AIMatingCreature;
  myCommunity: AICommunity;
begin
  if not Partner.ValidTarget then exit;
  if not Community.ValidTarget then exit;

  myMate := AIMatingCreature(Partner.Target);

  // turn towards mate
  Position.TurnTowardsTarget(myMate.Position, ca30);

  myCommunity := AICommunity(Community.Target);
  if myCommunity.Full then exit;

  if not myMate.Alive then begin Partner.InvalidateTarget; exit; end;
  if not gThings.CanAdd(Kind) then exit;
  if not Female then exit;
  if not CloseEnoughToGrab(myMate) then exit;
  if gReality.Time < MatingTimer then exit;

  // close to mate, so make a baby
  myBaby := AIMatingCreature(gThings.NewThing(Kind));
  myBaby.Position.FullCopy(Position);
  myBaby.Position.Y := myBaby.Position.Y + Position.SizeY;
  Health := Health - 512;
  myBaby.Health := 512;
  myBaby.DevelopIntoBaby;
  MatingTimer := gReality.Time + 128;
  AICommunity(Community.Target).AddMember(myBaby);
  Partner.InvalidateTarget;
end;

// ----------------------------------------------------------------------------
procedure AIMatingCreature.FullDisplay(aList: TStrings);
begin
  inherited FullDisplay(aList);

  aList.Add('Partner: ' + Partner.OneLineDisplayRight);
  aList.Add('Female/Male: ' + BoolToGender(fFemale));
  case fStage of
    cCreatureBaby:  aList.Add('Stage: Baby');
    cCreatureAdult: aList.Add('Stage: Adult');
    cCreatureElder: aList.Add('Stage: Elder');
  end;

end;

// ----------------------------------------------------------------------------
function AIMatingCreature.OneLineDisplay: string;
begin
  result := GetName + ' ' + IntToStr(Handle) + ' ';

  if Female then
    result := result + 'Female'
  else
    result := result + 'Male';

  case fStage of
    cCreatureBaby: result := result + ' Baby';
    cCreatureAdult: result := result + ' Adult';
    cCreatureElder: result := result + ' Elder';
  end;

  if Dead then
    result := result + ' Dead Rot=' + IntToStr(Rot);

  result := result
    + Format(' Health=%d Age=%0d Desire=%d-', [Health, Age, Desire]);

  case Desire of
    cDesireNone: result := result + 'None ';
    cDesireFood: result := result + 'Food ';
    cDesireWander: result := result + 'Wander ';
    cDesireMate: result := result + 'Mate ';
    cDesireEat: result := result + 'Eat ';
    cDesireLand: result := result + 'Land ';
    cDesireRetire: result := result + 'Retire ';
  end;

  result := result + Position.OneLineDisplay;
end;

// ----------------------------------------------------------------------------
procedure AIMatingCreature.MatingBehaviourNoRestraints;
begin
  // look for a partner
  if not Partner.ValidTarget then
    FindMateNoRestraints
  else
    // if female, mate with partner
    if (Health >= 1024) then
      MateWithPartnerNoRestraints;
end;

// ----------------------------------------------------------------------------
// find nearest possible mate
procedure AIMatingCreature.FindMateNoRestraints;
var
  i: integer;
  myMate: AIMatingCreature;
  closest: single;
  distance: single;
begin
  // find a mate
  closest := 1000000;
  for i := 0 to gThings.Tables[Kind].Count - 1 do
  begin
    myMate := AIMatingCreature(gThings.Tables[Kind].Items[i]);
    distance := Position.DistancePlusHeightTo(myMate.Position);
    if (distance < closest) and (Female <> myMate.Female) and myMate.Alive then
    begin
//    and ((myMate.Partner.Target = nil) or (myMate.Partner.Target = self))
//    then
      closest := distance;
      Partner.AssignTarget(myMate);
    end;
  end;
end;

end.

