{
  ai.planet
  http://aiplanet.sourceforge.net
  Created by Dave Kerr (kerrd@hotmail.com)
}
unit cAIBot;
{
  Node AIBot

  AIBot is a remote-controlled entity living on ai.planet.
  A client controls the bot by sending it commands.
  The body of the bot tries to act out that command in the world.
  The body of the bot gives the client sensual information about the environment.
  The client may be a human user, controlling the bot with keys and mouse.
  The client may be an artificial intelligence.  This would send commands by
    an internet protocol such as SOAP.
  Both human and ai are restricted by the same set of world rules.

  Dave:
  After showing alot of people this project, the funniest reaction were from
  two women who threw their hands up to her heads and screamed
  "Wow!!  I feel like I've just been shown a new dimension of knowledge!"

  danch (developers add next comment here).
}
interface

uses
  System.Classes,
  System.Contnrs,
  System.Types,
  cAIBaseObject,
  cAIThings,
  cAILink,
  cAICreature;

const
  //defaults
  cBotHealthBegin = 1000;
  cBotHealthDeath = 0;
  cBotHealthDrain = 1;


type

// ============================================================================
AIBot = Class(AICreature)
private
  fPassword: string;    // password that allows bot to be controlled

  fTargetLink: AILink;

  fLastJump: integer;
  fLastBomb: integer;

  fCommand: string;
  fEmotion: string;
  fJetpack: string;
  fActivity: string;

  KickStrength: single;

  procedure SetCommand(aCommand: string);
protected
  procedure Bomb;

  procedure InterpretCommand;
  procedure InterpretActivity;
  procedure InterpretJetpack;
  procedure InterpretEmotion;

public
  Constructor Create(
    aParent: pointer);
  Destructor Destroy; override;

  // info
  property Command: string read fCommand write SetCommand;
  property Emotion: string read fEmotion write fEmotion;
  property Jetpack: string read fJetpack write fJetpack;
  property Activity: string read fActivity write fActivity;
  property TargetLink: AILink read fTargetLink;
  property LastJump: integer read fLastJump write fLastJump;
  property LastBomb: integer read fLastBomb write fLastBomb;

  function OneLineDisplay: string; override;
  procedure Fuel; override; // add time
end;

// ----------------------------------------------------------------------------

implementation

uses System.SysUtils, cAIPosition, cGlobals, cAIExplosions, cAIVibes;

// ----------------------------------------------------------------------------
Constructor AIBot.Create(
    aParent: pointer);
begin
  inherited Create(aParent);

  Kind := cBot;

  Position.SetPosition(Random(5), Random(5), 0);
  Position.SetSize(0.4, 0.4, 1, true);

  Health := cBotHealthBegin;
  fPassword := 'freebot';
  fTargetLink := gEnvironment.References.NewLink(self);

  Position.SetDirection(Pi/2, HalfPi);
end;

// ----------------------------------------------------------------------------
Destructor AIBot.Destroy;
begin
  gEnvironment.References.Remove(fTargetLink);

  inherited Destroy;
end;

// ----------------------------------------------------------------------------
function AIBot.OneLineDisplay: string;
begin
  result := 'bot + Health: ' + IntToStr(Health) + ' ' + Position.OneLineDisplay;
end;

// ----------------------------------------------------------------------------
procedure AIBot.Fuel;
begin
  inherited Fuel;

  Health := Health + 1;

  if not (KickStrength = 0) and not (Activity = 'KICK') then
  begin
    Kick(KickStrength + 0.15);
    KickStrength := 0;
  end;

  // inact a command
  if not (Command = '') then
    InterpretCommand;
  if not (Activity = '') then
    InterpretActivity;
  if not (Jetpack = '') then
    InterpretJetpack;
  if not (Emotion = '') then
    InterpretEmotion;
end;

// ----------------------------------------------------------------------------
procedure AIBot.SetCommand(aCommand: string);
begin
  fCommand := aCommand;
end;

// ----------------------------------------------------------------------------
procedure AIBot.Bomb;
var
  myBomb: AIBomb;
begin
  if (gReality.Time - LastBomb < 8) then
    exit;

  LastBomb := gReality.Time;

  myBomb := AIBomb(gEnvironment.Things.NewThing(cBomb));
  if not (myBomb = nil) then
  begin
    myBomb.Position.CopyCoords(Position);
    myBomb.Position.Velocity.CopyFrom(Position.Velocity);
//    myBomb.Position.Acceleration.SetAngularForce(Position.Direction + Random * 0.25 - 0.125, 0.3, 0.6);
    myBomb.Timer := 160;
    myBomb.Strength := 0.15;
    myBomb.Effect := cEffectFire;
    myBomb.Diminish := 0.025;
    myBomb.BlastRadius := 25;
  end;
end;

// ----------------------------------------------------------------------------
procedure AIBot.InterpretCommand;
begin
  if (Command = 'MOVE') then
    if (Position.Binding = bindLand) and (Jetpack = '') then
    begin
      if Position.Velocity.XYStrength < 0.5 then
        Position.Acceleration.ApplyAngularForce(Position.DirectionXY, 0.175);
    end
    else if Position.Velocity.XYStrength < 0.5 then
        Position.Acceleration.ApplyAngularForce(Position.DirectionXY, 0.04);

  if (Command = 'RUN') then
    if Position.Velocity.XYStrength < 1.0 then
    Position.Acceleration.ApplyAngularForce(Position.DirectionXY, 0.5);

  if (Command = 'MOVEBACK') then
    if (Position.Binding = bindLand) and (Jetpack = '') then
    begin
      if Position.Velocity.XYStrength < 0.5 then
        Position.Acceleration.ApplyAngularForce(Position.DirectionXY + Pi, 0.1);
    end
    else if Position.Velocity.XYStrength < 0.5 then
        Position.Acceleration.ApplyAngularForce(Position.DirectionXY + Pi, 0.05);

  fCommand := '';
end;

// ----------------------------------------------------------------------------
procedure AIBot.InterpretActivity;
begin
  if Activity = 'KICK' then
  begin
    KickStrength := KickStrength + 0.01;
    if KickStrength > 0.5 then KickStrength := 0.5;
  end;

  if Activity = 'KICKRETURN' then
    KickReturn;

  if Activity = 'GRAB' then
    Grab;

  if Activity = 'DROP' then
    Drop;

  if Activity = 'THROW' then
    Throw;

  if Activity = 'BONK' then
    Bonk;

  if Activity = 'GIVE' then
    Give;

  if Activity = 'USE' then
    Use(0);
  if Activity = 'USE1' then
    Use(0);
  if Activity = 'USE2' then
    Use(1);
  if Activity = 'USE3' then
    Use(2);
  if Activity = 'USE4' then
    Use(3);
  if Activity = 'USE5' then
    Use(4);

  if Activity = 'EAT' then
    if Eat(128) then Noise(cNoiseEat, 1);
  if Activity = 'BOMB' then
    Bomb;

  fActivity := '';
end;

// ----------------------------------------------------------------------------
procedure AIBot.InterpretJetpack;
begin
  if (Jetpack = 'JETPACK') then
    Position.Acceleration.ApplyForce(0, 0, 0.04);

  if (Jetpack = 'JUMP') and (gReality.Time - LastJump >= 16) and (Position.Binding = bindLand) then
  begin
    Position.Acceleration.ApplyForce(0, 0, 0.2);
    LastJump := gReality.Time;
  end;

  fJetpack := '';
end;

// ----------------------------------------------------------------------------
procedure AIBot.InterpretEmotion;
begin
  if Emotion = 'TURNLEFT' then
    Position.TurnLeft(ca5);
  if Emotion = 'TURNRIGHT' then
    Position.TurnRight(ca5);
  if Emotion = 'SHIFTLEFT' then
    if Position.Velocity.XYStrength < 0.5 then
      Position.Acceleration.ApplyAngularForce(Position.DirectionXY - HalfPi, 0.1);
  if Emotion = 'SHIFTRIGHT' then
    if Position.Velocity.XYStrength < 0.5 then
      Position.Acceleration.ApplyAngularForce(Position.DirectionXY + HalfPi, 0.1);
  fEmotion := '';
end;

end.

