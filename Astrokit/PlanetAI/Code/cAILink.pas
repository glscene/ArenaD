{
  ai.planet
  http://aiplanet.sourceforge.net
  Created by Dave Kerr (kerrd@hotmail.com)
  $Id: cAILink.pas,v 1.18 2003/08/28 22:59:55 aidave Exp $
}
unit cAILink;

interface

uses
  System.Types,
  System.Classes,
  System.Contnrs,
  cAIBaseObject,
  cAIThings;

type

// ============================================================================
TLinkObject = class(TObject)
private
  fLeftHandle: Int64;
  fRightHandle: Int64;

  fLeftObjectPointer: Pointer;
  fRightObjectPointer: Pointer;

  procedure SetLeftHandle(aValue: Int64);
  procedure SetRightHandle(aValue: Int64);
public
  constructor Create;
  property LeftHandle: Int64 read fLeftHandle write SetLeftHandle;
  property RightHandle: Int64 read fRightHandle write SetRightHandle;
  property LeftObjectPointer: Pointer read fLeftObjectPointer write fLeftObjectPointer;
  property RightObjectPointer: Pointer read fRightObjectPointer write fRightObjectPointer;

  function Valid: boolean;
  function ValidLeft: boolean;

  procedure AssignLeftObject(aObject: AIBaseObject);
  procedure AssignRightObject(aObject: AIBaseObject);

  function ValidRight: boolean;

  procedure InvalidateRight;
  procedure InvalidateLeft;

  procedure SaveToFile(var aFile: TextFile);
  procedure LoadFromFile(var aFile: TextFile);

  procedure CopyFrom(aLinkObject: TLinkObject); virtual;
end;

// ============================================================================
AILink = class(TLinkObject)
private
  function GetOrigin: AIThing;
  function GetTarget: AIThing;
  procedure SetOrigin(aThing: AIThing);
  procedure SetTarget(aThing: AIThing);
public
  property Origin: AIThing read GetOrigin write SetOrigin;
  property Target: AIThing read GetTarget write SetTarget;

  function OriginKind: integer;
  function TargetKind: integer;

  function Connected: boolean;
  function Disconnected: boolean;

  function ValidTarget: boolean;
  function ValidOrigin: boolean;

  procedure InvalidateOrigin;
  procedure InvalidateTarget;

  procedure Disconnect;

  procedure AssignOrigin(aObject: AIBaseObject);
  procedure AssignTarget(aObject: AIBaseObject); virtual;
  function OneLineDisplayRight: string;
  function OneLineDisplayBoth: string;
end;

// ============================================================================
AIAttachment = class(AILink)
public
  procedure Attach(aThing: AIThing);
  procedure Detach;

  function Holding: boolean;
  function Empty: boolean;
end;

// ============================================================================
TLinkContainer = class(AIBaseContainer)
protected
  procedure RemoveAllLinksWithRightHandle(aHandle: int64);
  procedure RemoveAllLinksWithLeftHandle(aHandle: int64);
public
  function FirstWithRightHandle(aHandle: int64): boolean;
  function FirstWithLeftHandle(aHandle: int64): boolean;

  function NextWithRightHandle(aHandle: int64): boolean;
  function NextWithLeftHandle(aHandle: int64): boolean;

  procedure SetObjectPointers(aContainer: AIBaseContainer); virtual;
  procedure SetLeftObjectPointers(aContainer: AIBaseContainer);
  procedure SetRightObjectPointers(aContainer: AIBaseContainer);

  procedure NeutralizeAllLinksWithRightHandle(aHandle: int64);
  procedure NeutralizeAllLinksWithLeftHandle(aHandle: int64);
  procedure NeutralizeAllLinksWithHandle(aHandle: int64);

  function NewLink: AILink; overload;

  procedure SaveToFile(var aFile: TextFile);
  procedure LoadFromFile(var aFile: TextFile);
end;

// ============================================================================
AILinkContainer = class(TLinkContainer)
public
  function NewLink(aLeftObject: AIBaseObject): AILink; overload;
  function NewLink(aLeftObject: AIBaseObject; aRightObject: AIBaseObject): AILink; overload;
  procedure FullDisplay(aList: TStrings); override;
end;

// ============================================================================
AIAttachmentContainer = class(AILinkContainer)
public
  function NewAttachment(aLeftObject: AIThing): AIAttachment;
  procedure DetachAllWithHandle(aHandle: int64);
  procedure SetObjectPointers(aContainer: AIBaseContainer); override;
end;

implementation

uses SysUtils;

// ----------------------------------------------------------------------------
constructor TLinkObject.Create;
begin
  inherited Create;
  fLeftHandle := 0;
  fRightHandle := 0;
  fLeftObjectPointer := nil;
  fRightObjectPointer := nil;
end;

// ----------------------------------------------------------------------------
function TLinkObject.Valid: boolean;
begin
  result := ValidLeft and ValidRight;
end;

// ----------------------------------------------------------------------------
function TLinkObject.ValidLeft: boolean;
begin
  result := (fLeftHandle <> 0);
end;

// ----------------------------------------------------------------------------
function TLinkObject.ValidRight: boolean;
begin
  result := (fRightHandle <> 0);
end;

// ----------------------------------------------------------------------------
procedure TLinkObject.SetLeftHandle(aValue: Int64);
begin
  if fLeftHandle <> aValue then
    fLeftHandle := aValue;
end;

// ----------------------------------------------------------------------------
procedure TLinkObject.SetRightHandle(aValue: Int64);
begin
  if fRightHandle <> aValue then
    fRightHandle := aValue;
end;

// ----------------------------------------------------------------------------
procedure TLinkObject.AssignLeftObject(aObject: AIBaseObject);
begin
  fLeftObjectPointer := aObject;
  fLeftHandle := aObject.Handle;
end;

// ----------------------------------------------------------------------------
procedure TLinkObject.AssignRightObject(aObject: AIBaseObject);
begin
  fRightObjectPointer := aObject;
  fRightHandle := aObject.Handle;
end;

// ----------------------------------------------------------------------------
procedure TLinkObject.InvalidateRight;
begin
  fRightObjectPointer := nil;
  fRightHandle := 0;
end;

// ----------------------------------------------------------------------------
procedure TLinkObject.InvalidateLeft;
begin
  fLeftObjectPointer := nil;
  fLeftHandle := 0;
end;

// ----------------------------------------------------------------------------
procedure TLinkObject.CopyFrom(aLinkObject: TLinkObject);
begin
  fLeftHandle := aLinkObject.fLeftHandle;
  fRightHandle := aLinkObject.fRightHandle;
  fLeftObjectPointer := aLinkObject.fLeftObjectPointer;
  fRightObjectPointer := aLinkObject.fRightObjectPointer;
end;

// ----------------------------------------------------------------------------
procedure TLinkObject.SaveToFile(var aFile: TextFile);
begin
  writeln(aFile, fRightHandle);
  writeln(aFile, fLeftHandle);
end;

// ----------------------------------------------------------------------------
procedure TLinkObject.LoadFromFile(var aFile: TextFile);
begin
  readln(aFile, fRightHandle);
  readln(aFile, fLeftHandle);
end;

// ----------------------------------------------------------------------------
function TLinkContainer.NextWithRightHandle(aHandle: int64): boolean;
var mySearch: TLinkObject;
begin
  result := false;
  if Next then
  repeat
    mySearch := ActiveItem;
    if mySearch.RightHandle = aHandle then
      result := true;
  until (result = true) or (not Next);
end;

// ----------------------------------------------------------------------------
function TLinkContainer.NextWithLeftHandle(aHandle: int64): boolean;
var mySearch: TLinkObject;
begin
  result := false;
  if Next then
  repeat
    mySearch := ActiveItem;
    if mySearch.LeftHandle = aHandle then
      result := true;
  until (result = true) or (not Next);
end;

// ----------------------------------------------------------------------------
procedure TLinkContainer.RemoveAllLinksWithRightHandle(aHandle: int64);
var mySearch: TLinkObject;
begin
  while FirstWithRightHandle(aHandle) do
  begin
    mySearch := ActiveItem;
    Remove(mySearch);
  end;
end;

// ----------------------------------------------------------------------------
procedure TLinkContainer.RemoveAllLinksWithLeftHandle(aHandle: int64);
var mySearch: TLinkObject;
begin
  while FirstWithLeftHandle(aHandle) do
  begin
    mySearch := ActiveItem;
    Remove(mySearch);
  end;
end;

// ----------------------------------------------------------------------------
procedure TLinkContainer.NeutralizeAllLinksWithRightHandle(aHandle: int64);
var mySearch: TLinkObject;
begin
  if First then
  repeat
    mySearch := ActiveItem;
    if mySearch.RightHandle = aHandle then
      mySearch.InvalidateRight;
  until (not Next);
end;

// ----------------------------------------------------------------------------
procedure TLinkContainer.NeutralizeAllLinksWithLeftHandle(aHandle: int64);
var mySearch: TLinkObject;
begin
  if First then
  repeat
    mySearch := ActiveItem;
    if mySearch.LeftHandle = aHandle then
      mySearch.InvalidateLeft;
  until (not Next);
end;

// ----------------------------------------------------------------------------
procedure TLinkContainer.NeutralizeAllLinksWithHandle(aHandle: int64);
var mySearch: TLinkObject;
begin
  if First then
  repeat
    mySearch := ActiveItem;
    if mySearch.RightHandle = aHandle then
      mySearch.InvalidateRight;
    if mySearch.LeftHandle = aHandle then
      mySearch.InvalidateLeft;
  until (not Next);
end;

// ----------------------------------------------------------------------------
function TLinkContainer.FirstWithRightHandle(aHandle: int64): boolean;
var mySearch: TLinkObject;
begin
  result := false;
  if First then
  repeat
    mySearch := ActiveItem;
    if mySearch.RightHandle = aHandle then
      result := true;
  until (result = true) or (not Next);
end;

// ----------------------------------------------------------------------------
function TLinkContainer.FirstWithLeftHandle(aHandle: int64): boolean;
var mySearch: TLinkObject;
begin
  result := false;
  if First then
  repeat
    mySearch := ActiveItem;
    if mySearch.LeftHandle = aHandle then
      result := true;
  until (result = true) or (not Next);
end;

// ----------------------------------------------------------------------------
function TLinkContainer.NewLink: AILink;
begin
  result := AILink.Create;
  Add(result);
end;

// ----------------------------------------------------------------------------
function AILinkContainer.NewLink(aLeftObject: AIBaseObject; aRightObject: AIBaseObject): AILink;
begin
  result := AILink.Create;
  result.LeftObjectPointer := aLeftObject;
  result.RightObjectPointer := aRightObject;
  result.LeftHandle := aLeftObject.Handle;
  result.RightHandle := aRightObject.Handle;
  Add(result);
end;

// ----------------------------------------------------------------------------
function AILinkContainer.NewLink(aLeftObject: AIBaseObject): AILink;
begin
  result := AILink.Create;
  result.LeftObjectPointer := aLeftObject;
  result.LeftHandle := aLeftObject.Handle;
  Add(result);
end;

// ----------------------------------------------------------------------------
function AILink.Connected: boolean;
begin
  result := (fRightHandle <> 0);
end;

// ----------------------------------------------------------------------------
function AILink.Disconnected: boolean;
begin
  result := not ValidRight;
end;

// ----------------------------------------------------------------------------
procedure AILink.Disconnect;
begin
  InvalidateRight;
end;

// ----------------------------------------------------------------------------
function AILink.GetOrigin: AIThing;
begin
  result := fLeftObjectPointer;
end;

// ----------------------------------------------------------------------------
function AILink.GetTarget: AIThing;
begin
  result := fRightObjectPointer;
end;

// ----------------------------------------------------------------------------
procedure AILink.SetOrigin(aThing: AIThing);
begin
  AssignLeftObject(aThing);
end;

// ----------------------------------------------------------------------------
procedure AILink.SetTarget(aThing: AIThing);
begin
  AssignRightObject(aThing);
end;

// ----------------------------------------------------------------------------
procedure AILink.AssignOrigin(aObject: AIBaseObject);
begin
  if not (aObject = nil) then
    AssignLeftObject(aObject);
end;

// ----------------------------------------------------------------------------
procedure AILink.AssignTarget(aObject: AIBaseObject);
begin
  if not (aObject = nil) then
    AssignRightObject(aObject);
end;

// ----------------------------------------------------------------------------
function AILink.OriginKind: integer;
begin
  result := cNothing;
  if ValidLeft then
    result := AIThing(LeftObjectPointer).Kind;
end;

// ----------------------------------------------------------------------------
function AILink.TargetKind: integer;
begin
  result := cNothing;
  if ValidRight then
    result := AIThing(RightObjectPointer).Kind;
end;

// ----------------------------------------------------------------------------
procedure AIAttachment.Attach(aThing: AIThing);
begin
  if aThing.Position.Carried then
    exit;

  AssignTarget(aThing);

  if ValidRight then
  begin
    aThing.Position.Carried := true;
    aThing.Position.Carrier := Origin;
  end;
end;

// ----------------------------------------------------------------------------
procedure AIAttachment.Detach;
begin
  if ValidTarget then
  begin
    Target.Position.Carried := false;
    Target.Position.Carrier := nil;
    InvalidateTarget;
  end;
end;

// ----------------------------------------------------------------------------
function AIAttachment.Holding: boolean;
begin
  // CRASHED
  result := (fRightHandle <> 0);
end;

// ----------------------------------------------------------------------------
function AIAttachment.Empty: boolean;
begin
  result := not ValidRight;
end;

// ----------------------------------------------------------------------------
function AIAttachmentContainer.NewAttachment(aLeftObject: AIThing): AIAttachment;
begin
  result := AIAttachment.Create;
  result.LeftObjectPointer := aLeftObject;
  result.LeftHandle := aLeftObject.Handle;
  Add(result);
end;

// ----------------------------------------------------------------------------
procedure AIAttachmentContainer.DetachAllWithHandle(aHandle: int64);
var mySearch: AIAttachment;
begin
  if First then
  repeat
    mySearch := ActiveItem;
    if mySearch.RightHandle = aHandle then
    begin
      mySearch.Detach;
{      AIThing(mySearch.RightObjectPointer).Position.Carried := false;
      AIThing(mySearch.RightObjectPointer).Position.Carrier := nil;
      mySearch.InvalidateRight;}
    end;
  until (not Next);
end;

// ----------------------------------------------------------------------------
procedure TLinkContainer.SetLeftObjectPointers(aContainer: AIBaseContainer);
var mySearch: TLinkObject;
    myPointer: pointer;
begin
  if First then
  repeat
    mySearch := ActiveItem;
    myPointer := aContainer.FindWithHandle(mySearch.LeftHandle);
    if myPointer <> nil then
      mySearch.LeftObjectPointer := myPointer;
    ActiveItem := mySearch;
  until not Next;
end;

// ----------------------------------------------------------------------------
procedure TLinkContainer.SetRightObjectPointers(aContainer: AIBaseContainer);
var mySearch: TLinkObject;
    myPointer: pointer;
begin
  if First then
  repeat
    mySearch := ActiveItem;
    myPointer := aContainer.FindWithHandle(mySearch.RightHandle);
    if myPointer <> nil then
      mySearch.RightObjectPointer := myPointer;
    ActiveItem := mySearch;
  until not Next;
end;

// ----------------------------------------------------------------------------
procedure TLinkContainer.SetObjectPointers(aContainer: AIBaseContainer);
var
  mySearch: TLinkObject;
  myPointer: pointer;
begin
  if First then
  repeat
    mySearch := ActiveItem;
    // find left
    myPointer := aContainer.FindWithHandle(mySearch.LeftHandle);
    if myPointer <> nil then
      mySearch.LeftObjectPointer := myPointer;
    // find right
    myPointer := aContainer.FindWithHandle(mySearch.RightHandle);
    if myPointer <> nil then
      mySearch.RightObjectPointer := myPointer;
    ActiveItem := mySearch;
  until not Next;
end;

// ----------------------------------------------------------------------------
procedure TLinkContainer.SaveToFile(var aFile: TextFile);
var
  i: integer;
  myLink: TLinkObject;
begin
  writeln(aFile, Count);
  for i := 0 to Count - 1 do
  begin
    myLink := TLinkObject(Items[i]);
    myLink.SaveToFile(aFile);
  end;
end;

// ----------------------------------------------------------------------------
procedure TLinkContainer.LoadFromFile(var aFile: TextFile);
var
  i, aCount: integer;
  myLink: TLinkObject;
begin
  readln(aFile, aCount);
  for i := 0 to aCount - 1 do
  begin
    myLink := AILink.Create;
    myLink.LoadFromFile(aFile);
    // do not load dead links
    if myLink.LeftHandle <> 0 then
      Add(myLink)
    else
      myLink.Free;
  end;
end;

// ----------------------------------------------------------------------------
procedure AILink.InvalidateTarget;
begin
  fRightObjectPointer := nil;
  fRightHandle := 0;
end;

// ----------------------------------------------------------------------------
procedure AILink.InvalidateOrigin;
begin
  fLeftObjectPointer := nil;
  fLeftHandle := 0;
end;

// ----------------------------------------------------------------------------
function AILink.ValidTarget: boolean;
begin
  result := (fRightHandle <> 0);
end;

// ----------------------------------------------------------------------------
function AILink.ValidOrigin: boolean;
begin
  result := ValidLeft;
end;

// ----------------------------------------------------------------------------
function AILink.OneLineDisplayRight: string;
begin
  if ValidRight then
    result := AIBaseObject(RightObjectPointer).OneLineDisplay
  else
    result := 'Empty';
end;

// ----------------------------------------------------------------------------
function AILink.OneLineDisplayBoth: string;
begin
  result := IntToStr(LeftHandle) + '<->' + IntToStr(RightHandle);
end;

// ----------------------------------------------------------------------------
procedure AILinkContainer.FullDisplay(aList: TStrings);
var
  i: integer;
  myLink: AILink;
begin
  aList.Add('LINK CONTAINER');
  aList.Add('----------------------');
  for i := 0 to Count - 1 do
  begin
    myLink := AILink(Items[i]);
    aList.Add(myLink.OneLineDisplayBoth + ' ' + myLink.OneLineDisplayRight);
  end;
end;

// ----------------------------------------------------------------------------
procedure AIAttachmentContainer.SetObjectPointers(aContainer: AIBaseContainer);
var
  mySearch: AIAttachment;
  myPointer: pointer;
begin
  if First then
  repeat
    mySearch := ActiveItem;
    // find left
    myPointer := aContainer.FindWithHandle(mySearch.LeftHandle);
    if myPointer <> nil then
      mySearch.LeftObjectPointer := myPointer;
    // find right
    myPointer := aContainer.FindWithHandle(mySearch.RightHandle);
    if myPointer <> nil then
    begin
      // have to set this to false, because .Attach exits if true
      AIThing(myPointer).Position.Carried := false;
      // now attach
      mySearch.Attach(myPointer);
    end;
    ActiveItem := mySearch;
  until not Next;
end;

end.
