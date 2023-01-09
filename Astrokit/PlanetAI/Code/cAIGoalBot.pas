{
  ai.planet
  http://aiplanet.sourceforge.net
  Created by Dave Kerr (kerrd@hotmail.com)
}
unit cAIGoalBot;
{
  Node AIGoalBot

  AIGoalBot is a AI-controlled entity living on ai.planet.
}
interface

uses System.Classes, cAIBot, cAIBaseObject, cAIThings, cAIPosition, cAILink, cAILife,
  cAIGoals, cAICube;

const
  //defaults
  cGoalNone = 0;
  cGoalFetch = 1;
  cGoalKick = 2;

  cPlanFinished = 0;
  cPlanNone = 1;
  cPlanMove = 2;
  cPlanKick = 3;

  cAssignDefense = 0; // defend the net
  cAssignOffense = 1; // chase the ball
  cAssignWander = 2;  // wander around, if ball comes within range, kick it

type

// ============================================================================
// a group of bots
AIGlobalBot = Class(AILivingGroup)
private
  fSoccerMode: boolean;
  fNet: AINet;
  fEnemyNet: AINet;
  fTeam: integer;
public
  Constructor Create(aParent: pointer);
  Destructor Destroy; override;

  property SoccerMode: boolean read fSoccerMode write fSoccerMode;
  property Net: AINet read fNet write fNet;
  property EnemyNet: AINet read fEnemyNet write fEnemyNet;
  property Team: integer read fTeam write fTeam;

  procedure Fetch(aMaster: AIThing; aObject: AIThing);
  procedure KickReturn(aMaster: AIThing; aObject: AIThing);

  procedure ResetTeam;

  procedure Fuel; override;
end;

// ============================================================================
AIGoalBot = Class(AIBot)
private
  fGlobalBot: AIGlobalBot;
  fGoalList: AIGoalList;

  fOccupied: boolean;
  fGoal: integer;
  fPlan: integer;

  fAssignment: integer;

  procedure SetGoal(aGoal: integer);
public
  Constructor Create(
    aParent: pointer);
  Destructor Destroy; override;

  property GlobalBot: AIGlobalBot read fGlobalBot write fGlobalBot;
  property Occupied: boolean read fOccupied write fOccupied;
  property Goal: integer read fGoal write SetGoal;
  property Plan: integer read fPlan write fPlan;
  property GoalList: AIGoalList read fGoalList;
  property Assignment: integer read fAssignment write fAssignment;

  procedure Fuel; override; // add time
end;

// ----------------------------------------------------------------------------

implementation

uses System.SysUtils, cGlobals, cAICreature;

// ----------------------------------------------------------------------------
Constructor AIGoalBot.Create(
    aParent: pointer);
begin
  inherited Create(aParent);

  fGoalList := AIGoalList.Create(self);

  fOccupied := false;

  // find a team or start a new team
  if gEnvironment.Things.Counters[cGlobalBot] >= 2 then
  begin
    if AIGlobalBot(gEnvironment.Things.Existents.FirstOfKind(cGlobalBot)).Members.Count >
       AIGlobalBot(gEnvironment.Things.Existents.LastOfKind(cGlobalBot)).Members.Count then
      fGlobalBot := gEnvironment.Things.Existents.LastOfKind(cGlobalBot)
    else
      fGlobalBot := gEnvironment.Things.Existents.FirstOfKind(cGlobalBot);
  end
  else
    fGlobalBot := AIGlobalBot(gEnvironment.Things.NewThing(cGlobalBot));

  // assign position
  if fGlobalBot.Members.Count = 0 then
    fAssignment := cAssignOffense
  else if fGlobalBot.Members.Count = 1 then
    fAssignment := cAssignDefense
  else
    fAssignment := cAssignWander;
//    fAssignment := cAssignOffense;

  // join the team
  GlobalBot.Members.Add(self);
end;

// ----------------------------------------------------------------------------
Destructor AIGoalBot.Destroy;
begin
  GlobalBot.Members.Remove(self);

  fGoalList.Free;

  inherited Destroy;
end;

// ----------------------------------------------------------------------------
procedure AIGoalBot.Fuel;
var
  myGoal: AIGoal;
  myNet: AINet;
begin
  inherited Fuel;

  if Occupied or Dead then exit;

  if GoalList.Incomplete then
  begin
    myGoal := GoalList.FinalGoal;
    if myGoal.Target.Target is AICreature then
    if AICreature(myGoal.Target.Target).Grabber.TargetKind = cBall then
    begin
      GoalList.Completed;
      exit;
    end;

    myGoal := GoalList.CurrentGoal;

    case myGoal.Instruction of
      cInstructionMove:
      begin
        if myGoal.Target.ValidRight then
        begin
          if Grabber.Holding then
          begin
            if Grabber.Target = myGoal.Target.Target then
              GoalList.CurrentGoalComplete;
          end;

          myGoal.SetDestinationToTarget;
          Position.FaceTarget(myGoal.Destination);
          Command := 'MOVE';
          if Position.DistanceTo(myGoal.Destination) < myGoal.Modifier then
          begin
            if myGoal.Target.Target.Position.Carried then
            begin
              Bonk;
              exit;
            end;

            if Position.DistanceToHeight(myGoal.Destination.Height) < 0.5 then
              GoalList.CurrentGoalComplete
            else
              if Position.Binding = bindLand then
                Position.Acceleration.ApplyForce(0, 0, 0.175);
          end;
        end;
      end;

      cInstructionKick:
      begin
        Command := 'KICK';
        GoalList.CurrentGoalComplete;
      end;

      cInstructionKickReturn:
      begin
        if myGoal.Target.ValidRight then
        begin
          Position.FaceTarget(AIThing(myGoal.Source.RightObjectPointer).Position);
          KickTowards(AIThing(myGoal.Target.RightObjectPointer), AIThing(myGoal.Source.RightObjectPointer), 0.5);
        end;
        GoalList.CurrentGoalComplete;
      end;

      cInstructionGrab:
      begin
        if Grabber.Holding then
        begin
          if Grabber.Target = myGoal.Target.Target then
            GoalList.CurrentGoalComplete
          else
            Drop;
          exit;
        end;

        if myGoal.Target.ValidRight then
        begin
          Grab(AIThing(myGoal.Target.RightObjectPointer));
          GoalList.CurrentGoalComplete;
        end;
      end;

      cInstructionDrop:
      begin
        Drop;
        GoalList.CurrentGoalComplete;
      end;

      cInstructionGive:
      begin
        if myGoal.Target.ValidRight then
          Position.FaceTarget(AIThing(myGoal.Target.RightObjectPointer).Position);
        Position.Velocity.Zero;
        Give;
        GoalList.CurrentGoalComplete;
      end;

      cInstructionMoveAway:
      begin
        if myGoal.Target.ValidRight then
        begin
          myGoal.SetDestinationToTarget;
          Position.FaceTarget(myGoal.Destination);
          myGoal.Destination.MoveBy(myGoal.Modifier);
          Position.MoveTowards(myGoal.Destination, 0.2);
          if Position.DistanceTo(myGoal.Destination) < 0.3 then
            GoalList.CurrentGoalComplete;
        end;
      end;

    end;
  end
  // no goal, play position
  else
  begin
    if not GlobalBot.SoccerMode then exit;

    myNet := GlobalBot.Net;

    case Assignment of
      cAssignOffense:
      begin
        GoalList.KickStrategy(cGoalFetch, gEnvironment.Things.Existents.NearestOfKind(cBall, Position, 100), GlobalBot.EnemyNet);
        exit;
      end;
      cAssignDefense:
      begin
        if gEnvironment.Things.Existents.HasKindWithinDistance(cBall, myNet.Position, 15) then
        begin
          GoalList.KickStrategy(cGoalFetch, gEnvironment.Things.Existents.NearestOfKind(cBall, myNet.Position, 15), GlobalBot.EnemyNet);
          exit;
        end;
        if Position.DistanceTo(myNet.Position) > 15 then
        begin
          GoalList.Gaurd(myNet, 12);
          exit;
        end;
        if Position.DistanceTo(myNet.Position) < myNet.NetSize then
        begin
          GoalList.Leave(myNet, myNet.NetSize + 1);
          exit;
        end;
      end;
      cAssignWander:
      begin
        if gEnvironment.Things.Existents.HasKindWithinDistance(cBall, Position, 5) then
        begin
          GoalList.KickStrategy(cGoalFetch, gEnvironment.Things.Existents.NearestOfKind(cBall, Position, 5), GlobalBot.EnemyNet);
          exit;
        end;
      end;
   end;
  end;

end;

// ----------------------------------------------------------------------------
procedure AIGoalBot.SetGoal(aGoal: integer);
begin
  fGoal := aGoal;

//  GoalList.FetchStrategy(cGoalFetch);
end;


// ----------------------------------------------------------------------------
Constructor AIGlobalBot.Create(aParent: pointer);
begin
  inherited Create(aParent);

  fSoccerMode := false;

  if fSoccerMode then
    if (gEnvironment.Things.Counters[cNet] = 0) then
    begin
      fNet := AINet(gEnvironment.Things.NewThing(cNet));
      fNet.TeamOwner := self;
      fEnemyNet := AINet(gEnvironment.Things.NewThing(cNet));
      fTeam := 0;
    end
    else
    begin
      fNet := gEnvironment.Things.Existents.LastOfKind(cNet);
      fNet.TeamOwner := self;
      fEnemyNet := gEnvironment.Things.Existents.FirstOfKind(cNet);
      fTeam := 1;
    end;
end;

// ----------------------------------------------------------------------------
destructor AIGlobalBot.Destroy;
begin

  inherited Destroy;
end;

// ----------------------------------------------------------------------------
procedure AIGlobalBot.Fuel;
begin
  inherited Fuel;

end;

// ----------------------------------------------------------------------------
procedure AIGlobalBot.Fetch(aMaster: AIThing; aObject: AIThing);
var
  i: integer;
  myBot: AIGoalBot;
  nearestDistance: single;
  distance: single;
  closestBot: AIGoalBot;
begin
  nearestDistance := 1000000;
  closestBot := nil;
  for i := 0 to Members.Count - 1 do
  begin
    myBot := AIGoalBot(Members.Items[i]);
    distance := aObject.Position.DistanceTo(myBot.Position);
    if (distance < nearestDistance) and not myBot.Occupied and not (myBot.GoalList.Incomplete) then
    begin
      nearestDistance := distance;
      closestBot := myBot;
    end;
  end;

  if Assigned(closestBot) then
  begin
    closestBot.GoalList.FetchStrategy(cGoalFetch, aObject, aMaster);
  end;
end;

// ----------------------------------------------------------------------------
procedure AIGlobalBot.KickReturn(aMaster: AIThing; aObject: AIThing);
var
  i: integer;
  myBot: AIGoalBot;
  nearestDistance: single;
  distance: single;
  closestBot: AIGoalBot;
begin
  nearestDistance := 1000000;
  closestBot := nil;
  for i := 0 to Members.Count - 1 do
  begin
    myBot := AIGoalBot(Members.Items[i]);
    distance := aObject.Position.DistanceTo(myBot.Position);
    if (distance < nearestDistance) and not myBot.Occupied and not (myBot.GoalList.Incomplete) then
    begin
      nearestDistance := distance;
      closestBot := myBot;
    end;
  end;

  if Assigned(closestBot) then
  begin
    closestBot.GoalList.KickStrategy(cGoalFetch, aObject, aMaster);
  end;
end;

// ----------------------------------------------------------------------------
procedure AIGlobalBot.ResetTeam;
var
  i: integer;
  myBot: AIGoalBot;
begin
  for i := 0 to Members.Count - 1 do
  begin
    myBot := AIGoalBot(Members.Items[i]);
    myBot.GoalList.Completed;
  end;
end;

end.

