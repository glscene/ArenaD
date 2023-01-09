{
  ai.planet
  http://aiplanet.sourceforge.net
  by David Kerr
  A mating creature can be reproduced with another creature of the same kind
  Doesnt have to be in a community
}
unit cAIMatingSingle;

interface

uses
  System.Classes,
  System.Types,
  System.Contnrs,
  cAIBaseObject,
  cAIThings,
  cAIPosition,
  cAILife,
  cAILink,
  cAICreature;

const
  cCreatureBaby = 0;
  cCreatureAdult = 1;
  cCreatureElder = 2;

type

// ============================================================================
AIMatingSingleCreature = Class(AICreature)
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
  cAIReality, System.SysUtils, cGlobals, cAITrees, cAIVibes, cUtilities, cAIFish;

// ----------------------------------------------------------------------------
Constructor AIMatingSingleCreature.Create(aParent: pointer);
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
destructor AIMatingSingleCreature.Destroy;
begin
  gEnvironment.References.Remove(fPartner);

  inherited Destroy;
end;

// ----------------------------------------------------------------------------
procedure AIMatingSingleCreature.Fuel;
begin
  inherited Fuel;

  case fStage of
    cCreatureBaby:  if Age > 1024 then fStage := cCreatureAdult;
    cCreatureAdult: if Age > 9500 then fStage := cCreatureElder;
    cCreatureElder: if Age > 10000 then Die;
  end;
end;

// ----------------------------------------------------------------------------
procedure AIMatingSingleCreature.Die;
begin
  inherited Die;

  fPartner.InvalidateTarget;
end;

// ----------------------------------------------------------------------------
procedure AIMatingSingleCreature.Cease;
begin
  fPartner.InvalidateTarget;

  inherited Cease;
end;

// ----------------------------------------------------------------------------
procedure AIMatingSingleCreature.SaveToFile(var aFile: TextFile);
begin
  inherited SaveToFile(aFile);
  fPartner.SaveToFile(aFile);
  writeFileBoolean(aFile, fFemale);
  writeln(aFile, fStage);
end;

// ----------------------------------------------------------------------------
procedure AIMatingSingleCreature.LoadFromFile(var aFile: TextFile);
begin
  inherited LoadFromFile(aFile);
  fPartner.LoadFromFile(aFile);
  fFemale := readFileBoolean(aFile);
  readln(aFile, fStage);
end;

// ----------------------------------------------------------------------------
procedure AIMatingSingleCreature.FullDisplay(aList: TStrings);
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
function AIMatingSingleCreature.OneLineDisplay: string;
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
procedure AIMatingSingleCreature.MatingBehaviour;
begin
  // look for a partner
  if not Partner.ValidTarget then
    FindMate
  else
    // if female, mate with partner
    if (Health >= 1024) then
      MateWithPartner;
end;

// ----------------------------------------------------------------------------
// find nearest possible mate
procedure AIMatingSingleCreature.FindMate;
var
  i: integer;
  myMate: AIMatingSingleCreature;
  closest: single;
  distance: single;
begin
  // find a mate
  closest := 1000000;
  for i := 0 to gThings.Tables[Kind].Count - 1 do
  begin
    myMate := AIMatingSingleCreature(gThings.Tables[Kind].Items[i]);
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

// ----------------------------------------------------------------------------
// assumes in a community
// assumes has a partner
procedure AIMatingSingleCreature.MateWithPartner;
var
  myMate: AIMatingSingleCreature;
  myBaby: AIMatingSingleCreature;
begin
  if not Partner.ValidTarget then exit;

  myMate := AIMatingSingleCreature(Partner.Target);

  // turn towards mate
  Position.TurnTowardsTarget(myMate.Position, ca30);

  if not myMate.Alive then begin Partner.InvalidateTarget; exit; end;
  if not gThings.CanAdd(Kind) then exit;
  if not Female then exit;
  if not CloseEnoughToGrab(myMate) then exit;
  if gReality.Time < MatingTimer then exit;

  // close to mate, so make a baby
  myBaby := AIMatingSingleCreature(gThings.NewThing(Kind));
  myBaby.Position.FullCopy(Position);
  Health := Health - 512;
  myBaby.Health := 512;
  myBaby.DevelopIntoBaby;
  myBaby.Position.Y := myBaby.Position.Y + Position.SizeY;
  myBaby.Position.X := myBaby.Position.X + Position.SizeX;
//  myBaby.Position.Height := myBaby.Position.Height + Position.SizeH;
  MatingTimer := gReality.Time + 128;
  Partner.InvalidateTarget;
end;

end.

