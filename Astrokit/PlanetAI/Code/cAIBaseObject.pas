{
  The unit of ai.planet project http://aiplanet.sourceforge.net
  Created by Dave Kerr
}
unit cAIBaseObject;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Contnrs;

type

AIBaseObject = class;
AIBaseClass = class of AIBaseObject;

// ============================================================================
TActiveList = Class(TObjectList)
private
  fActiveItem: Pointer;
public
  constructor Create(aValue: boolean);
  destructor Destroy; override;
  property ActiveItem: Pointer read fActiveItem write fActiveItem;
  function  Next: boolean;
  function  First: boolean;
  function  SetNextActive: boolean;
  function  SetFirstActive: boolean;
  function  SetPriorActive: boolean;
  function  SetLastActive: boolean;
  function  SetNextOrFirstActive: boolean;
  function  SetPriorOrLastActive: boolean;
  function OneLineDisplay: string; virtual;
  function  PositionAtIndex(anIndex: LongInt): boolean;
  function  ActiveItemIndex: LongInt;
  function  IndexOfActiveItem: LongInt;
end;

// ============================================================================
AIBaseObject = Class(TObject)
private
  fHandle: integer;
  fParentHandle: integer;
  fParentPointer: Pointer;
  fCrossover: pointer;        // assigned at runtime, for visual links
public
  Constructor Create(aParent: pointer);
  Destructor Destroy; override;
  property Handle: integer read fHandle write fHandle;
  property ParentHandle: integer read fParentHandle write fParentHandle;
  property ParentPointer: Pointer read fParentPointer write fParentPointer;
  property Crossover: Pointer read fCrossover write fCrossover;
  function OneLineDisplay: string; virtual;
  procedure FullDisplay(aList: TStrings); virtual;
  procedure SaveToFile(var aFile: TextFile); virtual;
  procedure LoadFromFile(var aFile: TextFile); virtual;
end;

// ============================================================================
AIBaseContainer = Class(TActiveList)
private
  fParentHandle: integer;
  fParentPointer: Pointer;
public
  Constructor Create(aParent: pointer);
  Destructor Destroy; override;
  property ParentHandle: integer read fParentHandle;
  property ParentPointer: Pointer read fParentPointer write fParentPointer;
  function FindWithHandle(aHandle: integer): AIBaseObject;
  procedure FullDisplay(aStrings: TStrings); virtual;
end;

// ============================================================================
AIReferenceList = Class(TActiveList)
private
  fParentPointer: Pointer;
public
  Constructor Create(aParent: pointer);
  Destructor Destroy; override;
  property ParentPointer: Pointer read fParentPointer write fParentPointer;
  procedure FullDisplay(aStrings: TStrings); virtual;
end;

AIKind = Class of AIBaseObject;

//=====================================
implementation
//=====================================

uses
  cUtilities;

//-----------------------------------------------------------------------------
constructor TActiveList.Create(aValue: boolean);
begin
  inherited Create(aValue);
end;

// ----------------------------------------------------------------------------
destructor TActiveList.Destroy;
begin
  inherited Destroy;
end;

// ----------------------------------------------------------------------------
function TActiveList.Next: boolean;
var
  myIndex: integer;
begin
  result := False;
  myIndex := IndexOf(fActiveItem);
  if (myIndex > -2) and (myIndex < (Count - 1)) then
  begin
    fActiveItem := Items[myIndex + 1];
    result := True;
  end;
end;

// ----------------------------------------------------------------------------
function TActiveList.First: boolean;
begin
  if Count > 0 then
  begin
    fActiveItem := Items[0];
    result := True;
  end
  else
  begin
    fActiveItem := nil;
    result := False;
  end;
end;

// ----------------------------------------------------------------------------
function TActiveList.SetFirstActive: boolean;
begin
  if Count > 0 then
  begin
    fActiveItem := Items[0];
    result := True;
  end
  else
  begin
    fActiveItem := nil;
    result := False;
  end;
end;

// ----------------------------------------------------------------------------
function TActiveList.SetNextActive: boolean;
var
  myIndex: integer;
begin
  result := False;
  myIndex := IndexOf(fActiveItem);
  if (myIndex > -2) and (myIndex < (Count - 1)) then
  begin
    fActiveItem := Items[myIndex + 1];
    result := True;
  end;
end;

// ----------------------------------------------------------------------------
function TActiveList.SetLastActive: boolean;
begin
  if Count > 0 then
  begin
    fActiveItem := Items[Count - 1];
    result := True;
  end
  else
  begin
    fActiveItem := nil;
    result := False;
  end;
end;

// ----------------------------------------------------------------------------
function TActiveList.SetPriorActive: boolean;
var
  myIndex: longint;
begin
  result := False;
  myIndex := IndexOf(fActiveItem);
  if (myIndex > 0) and (myIndex < Count) then
  begin
    fActiveItem := Items[myIndex - 1];
    result := True;
  end;
end;

// ----------------------------------------------------------------------------
function TActiveList.SetNextOrFirstActive: boolean;
begin
  result := SetNextActive;

  if not result then
    result := SetFirstActive;
end;

// ----------------------------------------------------------------------------
function TActiveList.SetPriorOrLastActive: boolean;
begin
  result := SetPriorActive;

  if not result then
    result := SetLastActive;
end;

// ----------------------------------------------------------------------------
function TActiveList.PositionAtIndex(anIndex: LongInt): boolean;
begin
  result := False;
  if ((anIndex > -1) and (anIndex < Count)) then
  begin
    fActiveItem := Items[anIndex];
    result := True;
  end;
end;

// ----------------------------------------------------------------------------
function  TActiveList.IndexOfActiveItem: LongInt;
begin
  result := IndexOf(fActiveItem);
end;

// ----------------------------------------------------------------------------
function TActiveList.ActiveItemIndex: LongInt;
begin
  result := IndexOf(ActiveItem);
end;

// ----------------------------------------------------------------------------
Constructor AIBaseObject.Create(aParent: pointer);
begin
  inherited Create;

  fParentPointer := aParent;
  fHandle := 0;
  fParentHandle := 0;
end;

// ----------------------------------------------------------------------------
Destructor AIBaseObject.Destroy;
begin

  inherited Destroy;
end;

// ----------------------------------------------------------------------------
function AIBaseObject.OneLineDisplay: string;
begin
  result := 'UNDEFINED';
end;

// ----------------------------------------------------------------------------
procedure AIBaseObject.SaveToFile(var aFile: TextFile);
begin
  writeln(aFile, fHandle);
  writeln(aFile, fParentHandle);
end;

// ----------------------------------------------------------------------------
procedure AIBaseObject.LoadFromFile(var aFile: TextFile);
begin
  readln(aFile, fHandle);
  readln(aFile, fParentHandle);
end;

// ----------------------------------------------------------------------------
Constructor AIBaseContainer.Create(aParent: pointer);
begin
  inherited Create(true); // does own objects

  ParentPointer := aParent;
end;

// ----------------------------------------------------------------------------
Destructor AIBaseContainer.Destroy;
begin

  inherited Destroy;
end;

// ----------------------------------------------------------------------------
procedure AIBaseContainer.FullDisplay(aStrings: TStrings);
var
  i: integer;
begin
  for i := 0 to Count - 1 do
    aStrings.AddObject(AIBaseObject(Items[i]).OneLineDisplay, Items[i]);
end;

// ----------------------------------------------------------------------------
Constructor AIReferenceList.Create(aParent: pointer);
begin
  inherited Create(false); // doesnt own objects

  ParentPointer := aParent;
end;

// ----------------------------------------------------------------------------
Destructor AIReferenceList.Destroy;
begin

  inherited Destroy;
end;

// ----------------------------------------------------------------------------
procedure AIReferenceList.FullDisplay(aStrings: TStrings);
var
  i: integer;
begin
  for i := 0 to Count - 1 do
    aStrings.AddObject(AIBaseObject(Items[i]).OneLineDisplay, Items[i]);
end;

// ----------------------------------------------------------------------------
function TActiveList.OneLineDisplay: string;
var
  i: integer;
begin
  result := '';
  for i := 0 to Count - 1 do
  begin
    result := result + AIBaseObject(Items[i]).OneLineDisplay + #13#10;
  end;
end;

// ----------------------------------------------------------------------------
function AIBaseContainer.FindWithHandle(aHandle: integer): AIBaseObject;
var
  i: integer;
begin
  result := nil;
  for i := 0 to Count - 1 do
  begin
    if AIBaseObject(Items[i]).Handle = aHandle then
    begin
      result := AIBaseObject(Items[i]);
      break;
    end;
  end;
end;

// ----------------------------------------------------------------------------
procedure AIBaseObject.FullDisplay(aList: TStrings);
begin
  aList.Add('Handle: ' + IntToStr(Handle));
  aList.Add('Pointer: ' + PtrToStr(self));
  aList.Add('ParentHandle: ' + IntToStr(fParentHandle));
  aList.Add('Crossover: ' + PtrToStr(fCrossover));
end;

end.




