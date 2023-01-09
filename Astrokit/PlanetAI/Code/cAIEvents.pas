{
  ai.planet
  http://aiplanet.sourceforge.net
  Created by Dave Kerr (kerrd@hotmail.com)

  One event per thing per round.
    sorry, thats the rule.
    trying to prevent infinite actions by one object.
    If an creature can act infinitely, it never loses.
    Moving is a free action.
}
unit cAIEvents;

interface

uses System.Classes, cAIBaseObject, cAIThings, Geometry;

const
  cEventForce = 0;
  cEventGrab = 1;
  cEventAttack = 2;
  cEventBite = 3;
  cEventUse = 4;
  cEventGive = 5;
  cEventDrop = 6;

type

// ============================================================================
AIEvent = Class(TObject)
private
  fKind: integer;
  fOrigin: AIThing;
  fTarget: AIThing;
  fValue: integer;
  fAmount: single;
  fVector: TAffineVector;
public
  property Kind: integer read fKind write fKind;
  property Origin: AIThing read fOrigin write fOrigin;
  property Target: AIThing read fTarget write fTarget;
  property Value: integer read fValue write fValue;
  property Amount: single read fAmount write fAmount;
  property Vector: TAffineVector read fVector write fVector;
end;

// ============================================================================
AIEventScheduler =  Class(TActiveList)
public
  Constructor Create;
  Destructor Destroy; override;

  procedure Advance;

  // basic event
//  function AddEvent(aKind: integer; aOrigin, aTarget: AIThing; aValue: integer; aAmount: single; aVector: TGLVector): boolean; overload;
  function AddEvent(aKind: integer; aOrigin, aTarget: AIThing): boolean; overload;
  function AddEvent(aKind: integer; aOrigin, aTarget: AIThing; aValue: integer): boolean; overload;
  function AddEvent(aKind: integer; aOrigin, aTarget: AIThing; aAmount: single): boolean; overload;
  function AddEvent(aKind: integer; aOrigin, aTarget: AIThing; aVector: TAffineVector): boolean; overload;
end;

implementation

uses
  cUtilities, System.SysUtils, cGlobals, cAICreature, cAILife, cAIVibes;

// ----------------------------------------------------------------------------
Constructor AIEventScheduler.Create;
begin
  inherited Create(true);

end;

// ----------------------------------------------------------------------------
Destructor AIEventScheduler.Destroy;
begin
  inherited Destroy;
end;

// ----------------------------------------------------------------------------
function AIEventScheduler.AddEvent(
    aKind: integer;
    aOrigin, aTarget: AIThing): boolean;
var
  myEvent: AIEvent;
begin
  result := false;
  // only one Event per Origin
  if aOrigin.Acted then
    exit;

  myEvent := AIEvent.Create;
  myEvent.Kind := aKind;
  myEvent.Origin := aOrigin;
  myEvent.Target := aTarget;

  // assign event to Origin
  aOrigin.Action := myEvent;

  Add(myEvent);
  result := true;
end;

// ----------------------------------------------------------------------------
function AIEventScheduler.AddEvent(
    aKind: integer;
    aOrigin, aTarget: AIThing;
    aValue: integer): boolean;
var
  myEvent: AIEvent;
begin
  result := false;
  // only one Event per Origin
  if aOrigin.Acted then
    exit;

  myEvent := AIEvent.Create;
  myEvent.Kind := aKind;
  myEvent.Origin := aOrigin;
  myEvent.Target := aTarget;
  myEvent.Value := aValue;

  // assign event to Origin
  aOrigin.Action := myEvent;

  Add(myEvent);
  result := true;
end;

// ----------------------------------------------------------------------------
function AIEventScheduler.AddEvent(
    aKind: integer;
    aOrigin, aTarget: AIThing;
    aAmount: single): boolean;
var
  myEvent: AIEvent;
begin
  result := false;
  // only one Event per Origin
  if aOrigin.Acted then
    exit;

  myEvent := AIEvent.Create;
  myEvent.Kind := aKind;
  myEvent.Origin := aOrigin;
  myEvent.Target := aTarget;
  myEvent.Amount := aAmount;

  // assign event to Origin
  aOrigin.Action := myEvent;

  Add(myEvent);
  result := true;
end;

// ----------------------------------------------------------------------------
function AIEventScheduler.AddEvent(
    aKind: integer;
    aOrigin, aTarget: AIThing;
    aVector: TAffineVector): boolean;
var
  myEvent: AIEvent;
begin
  result := false;
  // only one Event per Origin
  if aOrigin.Acted then
    exit;

  myEvent := AIEvent.Create;
  myEvent.Kind := aKind;
  myEvent.Origin := aOrigin;
  myEvent.Target := aTarget;
  myEvent.Vector := aVector;

  // assign event to Origin
  aOrigin.Action := myEvent;

  Add(myEvent);
  result := true;
end;

// ----------------------------------------------------------------------------
// enact all events
// clear all events
procedure AIEventScheduler.Advance;
var
  i: integer;
  myEvent: AIEvent;
begin
  for i := 0 to Count -1 do
  begin
    myEvent := AIEvent(Items[i]);
    myEvent.Origin.Action := nil;
    case myEvent.Kind of
      cEventForce:
        myEvent.Target.Position.Acceleration.ApplyForce(myEvent.Vector);
      cEventGrab:
      begin
        AICreature(myEvent.Origin).Grabber.Attach(myEvent.Target);
        myEvent.Target.Noise(cNoiseGrab, 1);
      end;
      cEventAttack:
        AICreature(myEvent.Target).Health := AICreature(myEvent.Target).Health - myEvent.Value;
      cEventBite:
      begin
        AICreature(myEvent.Origin).Health := AICreature(myEvent.Origin).Health + myEvent.Value;
        AILivingThing(myEvent.Target).Health := AILivingThing(myEvent.Target).Health - myEvent.Value;
      end;
      cEventUse:
        myEvent.Target.Perform(myEvent.Value);

    end;
  end;
  Clear;
end;

end.
