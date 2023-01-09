{
  ai.planet
  http://aiplanet.sourceforge.net

  AIGeneticCreature
}
unit cAIGeneticCreature;

interface

uses
  System.Classes,
  System.Contnrs,

  cAICreature,
  cAIThings,
  cAILife,
  cAILink,
  cAIDNA,
  cAIMatingSingle;

const
  cDNA = 0;

type

// ============================================================================
AIGeneticCreature = Class(AIMatingSingleCreature)
private
  fDNA: AIDNA;
protected
  procedure MateWithPartner; override;
public
  // create and delete
  Constructor Create(aParent: pointer);
  Destructor Destroy; override;

  property DNA: AIDNA read fDNA;

  // user-interface and bot-interface
  procedure Perform(aActivity: integer); override;
  // DNA access     
  function HasDNA: boolean; override;
  function GetDNA: pointer; override;

  // file load/save routines
  procedure SaveToFile(var aFile: TextFile); override;
  procedure LoadFromFile(var aFile: TextFile); override;
  // display routines
  function OneLineDisplay: string; override;
  procedure FullDisplay(aList: TStrings); override;
end;

implementation

uses cUtilities, cGlobals, cAIVibes, cAIPosition, System.SysUtils, cAICommunity;

// ----------------------------------------------------------------------------
Constructor AIGeneticCreature.Create(aParent: pointer);
begin
  inherited Create(aParent);

  fDNA := AIDNA.Create;
  fDNA.CopyFrom(AIDNA(gThings.Forms.Items[Kind]));
end;

// ----------------------------------------------------------------------------
Destructor AIGeneticCreature.Destroy;
begin
  fDNA.Free;

  inherited Destroy;
end;

// ----------------------------------------------------------------------------
procedure AIGeneticCreature.Perform(aActivity: integer);
begin
  inherited Perform(aActivity);

  case aActivity of
    10: ; //Evolve;
  end;
end;

// ----------------------------------------------------------------------------
procedure AIGeneticCreature.SaveToFile(var aFile: TextFile);
begin
  inherited SaveToFile(aFile);

  DNA.SaveToFile(aFile);
end;

// ----------------------------------------------------------------------------
procedure AIGeneticCreature.LoadFromFile(var aFile: TextFile);
begin
  inherited LoadFromFile(aFile);

  DNA.LoadFromFile(aFile);
end;

// ----------------------------------------------------------------------------
function AIGeneticCreature.OneLineDisplay: string;
begin
  result := inherited OneLineDisplay;
end;

// ----------------------------------------------------------------------------
procedure AIGeneticCreature.FullDisplay(aList: TStrings);
begin
  inherited FullDisplay(aList);

  DNA.FullDisplay(aList);
end;

// ----------------------------------------------------------------------------
// assumes in a community
// assumes has a partner
procedure AIGeneticCreature.MateWithPartner;
var
  myMate: AIGeneticCreature;
  myBaby: AIGeneticCreature;
begin
  if not Partner.ValidTarget then exit;

  myMate := AIGeneticCreature(Partner.Target);

  // move towards mate
  Position.TurnTowardsTarget(myMate.Position, ca30);

  if not myMate.Alive then begin Partner.InvalidateTarget; exit; end;
  if not Female then exit;
  if not gThings.CanAdd(Kind) then exit;
  if not CloseEnoughToGrab(myMate) then exit;
  if gReality.Time < MatingTimer then exit;

  // close to mate, so make a baby
  myBaby := AIGeneticCreature(gThings.NewThing(Kind));
  myBaby.Position.FullCopy(Position);
  Health := Health - 512;
  myBaby.Health := 512;
  // inhereit DNA from mother and father
  myBaby.DNA.Combine(myMate.DNA, DNA);
  myBaby.DevelopIntoBaby;
  MatingTimer := gReality.Time + 128;

  Partner.InvalidateTarget;
end;

// ----------------------------------------------------------------------------
function AIGeneticCreature.HasDNA: boolean;
begin
  result := true;
end;

// ----------------------------------------------------------------------------
function AIGeneticCreature.GetDNA: pointer;
begin
  result := fDNA;
end;

end.
