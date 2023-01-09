{
  ai.planet
  http://aiplanet.sourceforge.net
  Created by Dave Kerr (kerrd@hotmail.com)
}
unit cAIEnvironment;
{
  Node AIEnvironment

  Patterns:
    Things
    Causes
    Events
    Map
}
interface

// need function to store list of changes at each round
// this can be used for all sorts of things
//   ex graphics updates

uses
  System.Classes,
  System.Contnrs,
  System.SysUtils,
  cAIThings,
  cAIBaseObject,
  cAIEnvironmentStructures,
  cAISpace,
  cAIGrid,
  cAILink,
  cAIPosition,
  cAIForce,
  cAICreature;

type

// ============================================================================
AIEnvironment = Class(AIBaseObject)
private
  fName: string;
  fThings: AIThingList;
  fSpace: AISpace;
  fReferences: AILinkContainer;
  fAttachments: AIAttachmentContainer;
  fShadows: boolean;
protected
  function GetGravity: AIForce;
  function GetAirFriction: AIForce;
  function GetLandFriction: AIForce;
  function GetWaterFriction: AIForce;
public
  Constructor Create(aReality: pointer);
  Destructor Destroy; override;

  property Name: string read fName write fName;
  property Things: AIThingList read fThings;
  property Space: AISpace read fSpace;
  property References: AILinkContainer read fReferences;
  property Attachments: AIAttachmentContainer read fAttachments;
  property Gravity: AIForce read GetGravity;
  property AirFriction: AIForce read GetAirFriction;
  property LandFriction: AIForce read GetLandFriction;
  property WaterFriction: AIForce read GetWaterFriction;
  property Shadows: boolean read fShadows write fShadows;
  procedure Fuel;
  function RoundStatistics: string;
  procedure EnactGrab(aOriginCreature: AICreature; aTarget: AIThing);
  procedure EnactBonk(aOriginCreature: AICreature; aTarget: AIThing);
  procedure Clean;
  procedure Build(aWidth: integer; aHeight: integer);
  procedure SaveToFile(var aFile: TextFile); override;
  procedure LoadFromFile(var aFile: TextFile); override;
  procedure Snip(aHandle: integer); overload;
  procedure Snip(aThing: AIThing); overload;
  procedure FullDisplay(aList: TStrings); override;
  function FindWithHandle(aHandle: integer): AIBaseObject;
end;

implementation

uses
  cAIReality,
  cGlobals,
  cUtilities,
  cAIVibes;

// ----------------------------------------------------------------------------
Constructor AIEnvironment.Create(aReality: pointer);
begin
  inherited Create(aReality);

  gEnvironment := self;

  fSpace := AISpace.Create(self, 20, 11);
  // create an empty list of things
  fThings := AIThingList.Create(self);
  // create an empty list of links (thing <-> thing)
  fReferences := AILinkContainer.Create(self);
  fAttachments := AIAttachmentContainer.Create(self);
  fShadows := false;

  fName := 'New Planet';
  gGravity := AIForce.Create;
  gGravity.SetForce(0.0, 0.0, -0.0098*1.5);
  gAirFriction := AIForce.Create;
  gAirFriction.SetForce(0.0005, 0.0005, 0.0005);
  gLandFriction := AIForce.Create;
  gLandFriction.SetForce(0.05, 0.05, 0.05);
  gWaterFriction := AIForce.Create;
  gWaterFriction.SetForce(0.25, 0.25, 0.25);
end;

// ----------------------------------------------------------------------------
Destructor AIEnvironment.Destroy;
begin
  fThings.Free;
  fSpace.Free;
  fReferences.Free;
  fAttachments.Free;

  gGravity.Free;
  gAirFriction.Free;
  gLandFriction.Free;
  gWaterFriction.Free;

  inherited Destroy;
end;

// ----------------------------------------------------------------------------
procedure AIEnvironment.Clean;
begin
  Things.Clean;
  Space.Clean;
  References.Clear;
  Attachments.Clear;
end;

// ----------------------------------------------------------------------------
procedure AIEnvironment.Build(aWidth: integer; aHeight: integer);
begin
  gEnvironment := self;
  Space.Build(aWidth, aHeight);
end;

// ----------------------------------------------------------------------------
procedure AIEnvironment.Fuel;
begin
  // delete trash
  Things.EmptyTrash;
  // prune dead things
  Things.BringOutYourDead;
  // clean out purgatory
  Things.EmptyPurgatory;
  // fuel space with time
  Space.Fuel;
  // fuel all things
  Things.FuelEverything;
end;

// ----------------------------------------------------------------------------
procedure AIEnvironment.SaveToFile(var aFile: TextFile);
begin
  inherited SaveToFile(aFile);
  writeln(aFile, fName);
  writeFileBoolean(aFile, fShadows);
  fSpace.SaveToFile(aFile);
  fThings.SaveToFile(aFile);
  fReferences.SaveToFile(aFile);
  fAttachments.SaveToFile(aFile);
end;

// ----------------------------------------------------------------------------
procedure AIEnvironment.LoadFromFile(var aFile: TextFile);
begin
  inherited LoadFromFile(aFile);
  readln(aFile, fName);
  fShadows := readFileBoolean(aFile);
  fSpace.LoadFromFile(aFile);
  fThings.LoadFromFile(aFile);
  fReferences.LoadFromFile(aFile);
  fAttachments.LoadFromFile(aFile);

  fReferences.SetObjectPointers(fThings);
  fAttachments.SetObjectPointers(fThings);
  fThings.JoinAllCommunities;
end;

// ----------------------------------------------------------------------------
function AIEnvironment.RoundStatistics: string;
var
  i: integer;
begin
  result := '';

  if Things.Cradle.Count > 0 then
    for i := 0 to Things.Cradle.Count - 1 do
      result := result + #13#10 + 'Born: ' + AIBaseObject(Things.Cradle.Items[i]).OneLineDisplay;

  if Things.Purgatory.Count > 0 then
    for i := 0 to Things.Purgatory.Count - 1 do
      result := result + #13#10 + 'Died: ' + AIBaseObject(Things.Purgatory.Items[i]).OneLineDisplay;
end;

// ----------------------------------------------------------------------------
function AIEnvironment.GetGravity: AIForce;
begin
  result := gGravity;
end;

// ----------------------------------------------------------------------------
function AIEnvironment.GetAirFriction: AIForce;
begin
  result := gAirFriction;
end;

// ----------------------------------------------------------------------------
function AIEnvironment.GetLandFriction: AIForce;
begin
  result := gLandFriction;
end;

// ----------------------------------------------------------------------------
function AIEnvironment.GetWaterFriction: AIForce;
begin
  result := gWaterFriction;
end;

// ----------------------------------------------------------------------------
// cleans all references to this thing
procedure AIEnvironment.Snip(aThing: AIThing);
begin
  Snip(aThing.Handle);
end;

// ----------------------------------------------------------------------------
// cleans all references to this thing
procedure AIEnvironment.Snip(aHandle: integer);
begin
  fReferences.NeutralizeAllLinksWithRightHandle(aHandle);
  fAttachments.DetachAllWithHandle(aHandle);
end;

// ----------------------------------------------------------------------------
function AIEnvironment.FindWithHandle(aHandle: integer): AIBaseObject;
begin
  result := gThings.FindWithHandle(aHandle);
  if not Assigned(result) then
    result := gSpace.FindWithHandle(aHandle);
end;

// ----------------------------------------------------------------------------
procedure AIEnvironment.FullDisplay(aList: TStrings);
begin
  {
  aList.Add('='+IntToStr());
  aList.Add('='+PtrToStr());
  aList.Add('='+Format('%0.2f', []));
  }
  aList.Add('ENVIRONMENT');
  aList.Add('-------------');
  inherited FullDisplay(aList);
  aList.Add(Name);
  aList.Add('Things='+PtrToStr(fThings));
  aList.Add('Space='+PtrToStr(fSpace));
  aList.Add('References='+PtrToStr(fReferences));
  aList.Add('Attachments='+PtrToStr(fAttachments));
  aList.Add('Gravity: ' + GetGravity.OneLineDisplay);
  aList.Add('AirFriction: ' + GetAirFriction.OneLineDisplay);
  aList.Add('LandFriction: ' + GetLandFriction.OneLineDisplay);
  aList.Add('WaterFriction: ' + GetWaterFriction.OneLineDisplay);
end;

// ----------------------------------------------------------------------------
procedure AIEnvironment.EnactGrab(aOriginCreature: AICreature; aTarget: AIThing);
begin
  // already holding something?
  if aOriginCreature.Grabber.Holding then exit;
  // grabbing itself?
  if (aTarget = aOriginCreature) then exit;
  // grabbing a sound?
  if (aTarget.Kind = cVibe) then exit;
  // check to see if the target is grabbing me already (cancel if so);
  if aTarget is AICreature then
    if AICreature(aTarget).Grabber.Holding and
      (AICreature(aTarget).Grabber.Target = aOriginCreature) then
        exit;
  // is it already carried?
  if aTarget.Position.Carried then exit;
  // is it close enough?
  if not aOriginCreature.CloseEnoughToGrab(aTarget) then exit;
  if not aTarget.Position.Carried then
  begin
    aOriginCreature.Grabber.Attach(aTarget);
    aTarget.Noise(cNoiseGrab, 1);
  end;
end;

// ----------------------------------------------------------------------------
procedure AIEnvironment.EnactBonk(aOriginCreature: AICreature; aTarget: AIThing);
var
  myTargetCreature: AICreature;
  myThing: AIThing;
begin
  if aOriginCreature.CloseEnoughToGrab(aTarget) then
  begin
    if aTarget is AICreature then
    begin
      myTargetCreature := AICreature(aTarget);
      if myTargetCreature.Grabber.Holding then
      begin
        myThing := myTargetCreature.Grabber.Target;
        myTargetCreature.Grabber.Detach;
        myThing.Position.Acceleration.ApplyForce(Random*0.2-0.1, Random*0.2-0.1, Random*0.2);
      end;
    end;
  end;
end;

end.
