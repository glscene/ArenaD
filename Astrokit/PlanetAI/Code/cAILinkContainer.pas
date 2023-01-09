unit cAILinkContainer;

interface

uses System.SysUtils, cAIBaseObject, cAILink,
     System.Classes, Vcl.Forms,Dialogs;

type
// ----------------------------------------------------------------------------
TLinkContainer = Class(TActiveList)
private

public
  procedure SetLeftObjectPointers(aContainerList: TActiveList);
  procedure SetRightObjectPointers(aContainerList: TActiveList);
  procedure SaveToFile(var aFile: TextFile);
  procedure LoadFromFile(var aFile: TextFile);

  function FindWithHandle(aHandle: int64): boolean;
  function FindWithLeftRightHandle(aLeftHandle: int64; aRightHandle: int64): boolean;
  function IsDuplicateObject(aLinkObject: TLinkObject): boolean;

  function FirstWithRightHandle(aHandle: int64): boolean;
  function FirstWithLeftHandle(aHandle: int64): boolean;

  function NextWithRightHandle(aHandle: int64): boolean;
  function NextWithLeftHandle(aHandle: int64): boolean;

  function NextOrCurrentWithRightHandle(aHandle: int64): boolean;
  function NextOrCurrentWithLeftHandle(aHandle: int64): boolean;

  procedure SortOnLeftHandle;
  procedure SortOnRightHandle;

  procedure RemoveAllLinksWithRightHandle(aHandle: int64);
  procedure RemoveAllLinksWithLeftHandle(aHandle: int64);

  function AddLadLadLink(aLeftLadObject: pointer; aRightLadObject: pointer): boolean;
  function FindLadLadLink(aLeftLadObject: pointer; aRightLadObject: pointer): boolean;
  function RemoveLadLadLink(aLeftLadObject: pointer; aRightLadObject: pointer): boolean;

  function ActiveLink: TLinkObject;

  procedure SystemDisplayList(myList: TStrings; myObjects: TStrings);
end;

implementation

// ----------------------------------------------------------------------------
procedure TLinkContainer.SaveToFile(var aFile: TextFile);
var mySearch: TLinkObject;
begin
  writeln(aFile, Count);
  if First = true then
  repeat
    mySearch := ActiveItem;
    mySearch.SaveToFile(aFile);
  until Next = false;
end;

procedure TLinkContainer.LoadFromFile(var aFile: TextFile);
var myCount: Integer;
    myLink: TLinkObject;
    i: Integer;
begin
  readln(aFile, myCount);
  for i := 0 to myCount - 1 do
  begin
    myLink := TLinkObject.Create;
    myLink.LoadFromFile(aFile);
    AddObject(myLink);
  end;
end;

procedure TLinkContainer.SetLeftObjectPointers(aContainerList: TActiveList);
var mySearch: TLinkObject;
    myPointer: pointer;
begin
  if First then
  repeat
    mySearch := ActiveItem;
    myPointer := aContainerList.FindWithHandle(mySearch.LeftHandle);
    if myPointer <> nil then
      mySearch.LeftObjectPointer := myPointer;
    ActiveItem := mySearch;
  until not Next;
end;

procedure TLinkContainer.SetRightObjectPointers(aContainerList: TActiveList);
var mySearch: TLinkObject;
    myPointer: pointer;
begin
  if First then
  repeat
    mySearch := ActiveItem;
    myPointer := aContainerList.FindWithHandle(mySearch.RightHandle);
    if myPointer <> nil then
      mySearch.RightObjectPointer := myPointer;
    ActiveItem := mySearch;
  until not Next;
end;

function TLinkContainerSortOnRightHandle(Item1, Item2: Pointer): integer;
begin
  if TLinkObject(Item1).RightHandle < TLinkObject(Item2).RightHandle then
    result := -1
  else if TLinkObject(Item1).RightHandle = TLinkObject(Item2).RightHandle then
    result := 0
  else
    result := 1;
end;

function TLinkContainerSortOnLeftHandle(Item1, Item2: Pointer): integer;
begin
  if TLinkObject(Item1).LeftHandle < TLinkObject(Item2).LeftHandle then
    result := -1
  else if TLinkObject(Item1).LeftHandle = TLinkObject(Item2).LeftHandle then
    result := 0
  else
    result := 1;
end;

procedure TLinkContainer.SortOnRightHandle;
begin
  Sort(TLinkContainerSortOnRightHandle);
end;

procedure TLinkContainer.SortOnLeftHandle;
begin
  Sort(TLinkContainerSortOnLeftHandle);
end;

function TLinkContainer.FindWithLeftRightHandle(aLeftHandle: int64; aRightHandle: int64): boolean;
var mySearch: TLinkObject;
begin
  result := false;
  if First then
  repeat
    mySearch := ActiveItem;
    if (mySearch.LeftHandle  = aLeftHandle)  and
       (mySearch.RightHandle = aRightHandle) then
    result := true;
  until (result = true) or (Next = false);
end;

function TLinkContainer.FindWithHandle(aHandle: int64): boolean;
var mySearch: TLinkObject;
begin
  result := false;
  if First then
  repeat
    mySearch := ActiveItem;
    if mySearch.Handle = aHandle then
      result := true;
  until (result = true) or (not Next);
end;

function TLinkContainer.IsDuplicateObject(aLinkObject: TLinkObject): boolean;
begin
  result := FindWithLeftRightHandle(aLinkObject.LeftHandle, aLinkObject.RightHandle);
end;

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

function TLinkContainer.NextOrCurrentWithRightHandle(aHandle: int64): boolean;
var mySearch: TLinkObject;
begin
  result := false;

  if Count = 0 then
    exit;

  mySearch := ActiveItem;
  if mySearch.RightHandle = aHandle then
  begin
    result := true;
    exit;
  end;

  if Next then
  repeat
    mySearch := ActiveItem;
    if mySearch.RightHandle = aHandle then
      result := true;
  until (result = true) or (not Next);
end;

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

function TLinkContainer.NextOrCurrentWithLeftHandle(aHandle: int64): boolean;
var mySearch: TLinkObject;
begin
  result := false;

  if Count = 0 then
    exit;

  mySearch := ActiveItem;
  if mySearch.LeftHandle = aHandle then
  begin
    result := true;
    exit;
  end;

  if Next then
  repeat
    mySearch := ActiveItem;
    if mySearch.LeftHandle = aHandle then
      result := true;
  until (result = true) or (not Next);
end;

procedure TLinkContainer.RemoveAllLinksWithRightHandle(aHandle: int64);
var mySearch: TLinkObject;
begin
  while FirstWithRightHandle(aHandle) do
  begin
    mySearch := ActiveItem;
    DestroyObject(mySearch);
  end;
end;

procedure TLinkContainer.RemoveAllLinksWithLeftHandle(aHandle: int64);
var mySearch: TLinkObject;
begin
  while FirstWithLeftHandle(aHandle) do
  begin
    mySearch := ActiveItem;
    DestroyObject(mySearch);
  end;
end;

function TLinkContainer.AddLadLadLink(aLeftLadObject: pointer; aRightLadObject: pointer): boolean;
begin
  ShowMessage('TLinkContainer.AddLadLadLink is no longer available.');
  result := false;
end;

function TLinkContainer.FindLadLadLink(aLeftLadObject: pointer; aRightLadObject: pointer): boolean;
begin
  ShowMessage('TLinkContainer.FindLadLadLink is no longer available.');
  result := false;
end;

function TLinkContainer.RemoveLadLadLink(aLeftLadObject: pointer; aRightLadObject: pointer): boolean;
begin
  ShowMessage('TLinkContainer.RemoveLadLadLink is no longer available.');
  result := false;
end;

function TLinkContainer.ActiveLink: TLinkObject;
begin
  result := ActiveItem;
end;

procedure TLinkContainer.SystemDisplayList(myList: TStrings; myObjects: TStrings);
var myLO: TLinkObject;
begin
  if First then
  repeat
    myLO := ActiveItem;
    myList.Add(myLO.SystemDisplay);
    myObjects.AddObject(IntToStr(myLO.Handle), myLO);
    if myObjects.IndexOfObject(myLO.RightObjectPointer) = -1 then
      myObjects.AddObject(IntToStr(myLO.RightHandle), myLO.RightObjectPointer);
    if myObjects.IndexOfObject(myLO.LeftObjectPointer) = -1 then
      myObjects.AddObject(IntToStr(myLO.LeftHandle), myLO.LeftObjectPointer);
  until not Next;
end;

end.
