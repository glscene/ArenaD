{
  ai.planet
  http://aiplanet.sourceforge.net
  Created by Dave Kerr (kerrd@hotmail.com)
  $Id: cAIGoals.pas,v 1.3 2003/06/28 21:45:56 aidave Exp $
}
unit cAIGoals;
{
  Node AIGoalBot

  AIGoalBot is a AI-controlled entity living on ai.planet.

  danch (developers add next comment here).
}
interface

uses System.Classes, cAIBaseObject, cAIPosition, cAIThings, cAILink;

const
  //defaults
  cInstructionNone = 0;
  cInstructionFetch = 1;
  cInstructionMove = 2;
  cInstructionKick = 3;
  cInstructionGrab = 4;
  cInstructionJump = 5;
  cInstructionDrop = 6;
  cInstructionTurnLeft = 7;
  cInstructionTurnRight = 8;
  cInstructionMoveAway = 9;
  cInstructionGive = 10;
  cInstructionBonk = 11;
  cInstructionKickReturn = 12;

  cGoalNone = 0;
  cGoalFetch = 1;

  cPlanFinished = 0;
  cPlanNone = 1;
  cPlanMove = 2;
  cPlanKick = 3;



type

AIGoalList = Class;

// ============================================================================
AIGoal = Class(AIBaseObject)
private
  fTarget: AILink;
  fSource: AILink;
  fInstruction: integer;
  fAccomplished: boolean;
  fModifier: single;

  fDestination: AIPosition;

  fPlans: AIGoalList;
public
  Constructor Create(aParent: pointer);
  Destructor Destroy; override;

  property Target: AILink read fTarget;
  property Source: AILink read fSource;
  property Instruction: integer read fInstruction write fInstruction;
  property Accomplished: boolean read fAccomplished write fAccomplished;
  property Destination: AIPosition read fDestination;
  property Plans: AIGoalList read fPlans;
  property Modifier: single read fModifier write fModifier;

  function OneLineDisplay: string; override;
  procedure SetDestinationToTarget;
end;

// ============================================================================
AIGoalList = Class(TActiveList)
private
  fCurrentGoal: integer;
  fCompleted: boolean;
public
  Constructor Create(aParent: pointer);
  Destructor Destroy; override;

  function Incomplete: boolean;
  function CurrentGoal: AIGoal;
  function FinalGoal: AIGoal;

  function NewGoal: AIGoal;
  procedure FetchStrategy(aGoal: integer; aObject: AIThing; aMaster: AIThing);
  procedure KickStrategy(aGoal: integer; aObject: AIThing; aMaster: AIThing);
  procedure Gaurd(aObject: AIThing; aDistance: single);
  procedure Leave(aObject: AIThing; aDistance: single);

  procedure CurrentGoalComplete;
  procedure Completed;
end;

// ----------------------------------------------------------------------------

implementation

uses System.SysUtils, cGlobals;

// ----------------------------------------------------------------------------
Constructor AIGoal.Create(
    aParent: pointer);
begin
  inherited Create(aParent);

  fTarget := gEnvironment.References.NewLink(self);
  fSource := gEnvironment.References.NewLink(self);
  fDestination := AIPosition.Create(self);
  fAccomplished := false;
  fInstruction := cInstructionNone;
end;

// ----------------------------------------------------------------------------
Destructor AIGoal.Destroy;
begin
//  fPlans.Free;
  fDestination.Free;
  gEnvironment.References.Remove(fTarget);
  gEnvironment.References.Remove(fSource);

  inherited Destroy;
end;

// ----------------------------------------------------------------------------
function AIGoal.OneLineDisplay: string;
begin
  result := 'goal';
end;

// ----------------------------------------------------------------------------
procedure AIGoal.SetDestinationToTarget;
begin
  Destination.CopyCoords(AIThing(Target.RightObjectPointer).Position);
end;

// ----------------------------------------------------------------------------
Constructor AIGoalList.Create(aParent: pointer);
begin
  inherited Create(true);

  fCompleted := true;
end;

// ----------------------------------------------------------------------------
destructor AIGoalList.Destroy;
begin

  inherited Destroy;
end;

// ----------------------------------------------------------------------------
function AIGoalList.NewGoal: AIGoal;
begin
  result := AIGoal.Create(self);
  Add(result);
end;

// ----------------------------------------------------------------------------
function AIGoalList.Incomplete: boolean;
begin
  result := not (fCompleted);
end;

// ----------------------------------------------------------------------------
function AIGoalList.CurrentGoal: AIGoal;
begin
  result := AIGoal(Items[fCurrentGoal]);
end;

// ----------------------------------------------------------------------------
function AIGoalList.FinalGoal: AIGoal;
begin
  result := AIGoal(Items[Count-1]);
end;

// ----------------------------------------------------------------------------
procedure AIGoalList.CurrentGoalComplete;
begin
  fCurrentGoal := fCurrentGoal + 1;
  if fCurrentGoal >= Count then
    fCompleted := true;
end;

// ----------------------------------------------------------------------------
procedure AIGoalList.Completed;
begin
  while Incomplete do CurrentGoalComplete;
end;

// ----------------------------------------------------------------------------
procedure AIGoalList.FetchStrategy(aGoal: integer; aObject: AIThing; aMaster: AIThing);
var
  myGoal: AIGoal;
begin
  fCompleted := false;
  Clear;

  if (aObject = nil) or (aMaster = nil) then
    exit;
    
  // make a plan
  if aGoal = cGoalFetch then
  begin
    // move to object
    myGoal := NewGoal;
    myGoal.Instruction := cInstructionMove;
    myGoal.Target.AssignRightObject(aObject);
    myGoal.Modifier := 0.5;
    fCurrentGoal := 0;
    // grab object
    myGoal := NewGoal;
    myGoal.Instruction := cInstructionGrab;
    myGoal.Target.AssignRightObject(aObject);
    // return object to master
    myGoal := NewGoal;
    myGoal.Instruction := cInstructionMove;
    myGoal.Target.AssignRightObject(aMaster);
    // give object
    myGoal := NewGoal;
    myGoal.Instruction := cInstructionGive;
    myGoal.Target.AssignRightObject(aMaster);
    // move away
    myGoal := NewGoal;
    myGoal.Instruction := cInstructionMoveAway;
    myGoal.Target.AssignRightObject(aMaster);
    myGoal.Modifier := 5;
  end;
end;

// ----------------------------------------------------------------------------
procedure AIGoalList.KickStrategy(aGoal: integer; aObject: AIThing; aMaster: AIThing);
var
  myGoal: AIGoal;
begin
  fCompleted := false;
  Clear;

  if (aObject = nil) or (aMaster = nil) then
    exit;

  // make a plan
  if aGoal = cGoalFetch then
  begin
    // move to object
    myGoal := NewGoal;
    myGoal.Instruction := cInstructionMove;
    myGoal.Target.AssignRightObject(aObject);
    myGoal.Modifier := 0.5;
    fCurrentGoal := 0;
    // kick object to master
    myGoal := NewGoal;
    myGoal.Instruction := cInstructionKickReturn;
    myGoal.Source.AssignRightObject(aMaster);
    myGoal.Target.AssignRightObject(aObject);
  end;
end;

// ----------------------------------------------------------------------------
procedure AIGoalList.Gaurd(aObject: AIThing; aDistance: single);
var
  myGoal: AIGoal;
begin
  fCompleted := false;
  Clear;

  if aObject = nil then
    exit;

  // make a plan
  // move to object
    myGoal := NewGoal;
    myGoal.Instruction := cInstructionMove;
    myGoal.Target.AssignRightObject(aObject);
    myGoal.Modifier := aDistance;
    fCurrentGoal := 0;
end;

// ----------------------------------------------------------------------------
procedure AIGoalList.Leave(aObject: AIThing; aDistance: single);
var
  myGoal: AIGoal;
begin
  fCompleted := false;
  Clear;

  if aObject = nil then
    exit;

  // make a plan
  // move to object
    myGoal := NewGoal;
    myGoal.Instruction := cInstructionMoveAway;
    myGoal.Target.AssignRightObject(aObject);
    myGoal.Modifier := aDistance;
    fCurrentGoal := 0;
end;

end.

