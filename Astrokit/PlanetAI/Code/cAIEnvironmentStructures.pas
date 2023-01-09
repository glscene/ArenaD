{
  ai.planet
  http://aiplanet.sourceforge.net
  Created by Dave Kerr (kerrd@hotmail.com)
  $Id: cAIEnvironmentStructures.pas,v 1.9 2003/07/16 10:33:28 aidave Exp $
}
unit cAIEnvironmentStructures;

interface

uses System.Classes, cAIBaseObject;

const
  cCauseEat = 0;

type

// ----------------------------------------------------------------------------
AISpatialEvent = record
  Kind: integer;
  Target: pointer;
  Modifier: single;
end;

AISpatialArray = array of AISpatialEvent;

// ----------------------------------------------------------------------------
AIEventList = Class(AIBaseObject)
private
  fFull: boolean;
  fActiveIndex: integer;
  fSize: integer;
  fEvents: AISpatialArray;
protected
  procedure IncreaseArraySize(aAmount: integer);
public
  Constructor Create(aParent: pointer; aSize: integer);

  property Full: boolean read fFull;
  property Size: integer read fSize;
  property ActiveIndex: integer read fActiveIndex write fActiveIndex;
  property Events: AISpatialArray read fEvents;

  procedure AddEvent(aKind: integer; aTarget: pointer; aModifier: single);
  procedure Clear;
  function Empty: boolean;
  function Count: integer;

  procedure SaveToFile(var aFile: TextFile); override;
  procedure LoadFromFile(var aFile: TextFile); override;
  procedure FullDisplay(aLines: TStrings); override;
end;

// ----------------------------------------------------------------------------

implementation

uses System.SysUtils, cUtilities, cGlobals;

// ----------------------------------------------------------------------------
Constructor AIEventList.Create(aParent: pointer; aSize: integer);
begin
  inherited Create(aParent);

  fSize := aSize;
  fActiveIndex := 0;
  SetLength(fEvents, fSize);
end;

// ----------------------------------------------------------------------------
procedure AIEventList.AddEvent(aKind: integer; aTarget: pointer; aModifier: single);
begin
  // if too many events, then increase the event size list
  if fActiveIndex >= fSize then
    IncreaseArraySize(16);

  fEvents[fActiveIndex].Kind := aKind;
  fEvents[fActiveIndex].Target := aTarget;
  fEvents[fActiveIndex].Modifier := aModifier;

  fActiveIndex := fActiveIndex + 1;
  fFull := true;
end;

// ----------------------------------------------------------------------------
procedure AIEventList.Clear;
begin
  fActiveIndex := 0;
  fFull := false;
end;

// ----------------------------------------------------------------------------
function AIEventList.Empty: boolean;
begin
  result := not (fFull);
end;

// ----------------------------------------------------------------------------
function AIEventList.Count: integer;
begin
  result := fActiveIndex;
end;

// ----------------------------------------------------------------------------
procedure AIEventList.LoadFromFile(var aFile: TextFile);
var
  i: integer;
  handle: integer;
begin
  inherited LoadFromFile(aFile);

  readln(aFile, fActiveIndex);
  readln(aFile, fSize);
  fFull := readFileBoolean(aFile);
  // recalculate size to make it smaller memory
  fSize := fActiveIndex + 16;
  SetLength(fEvents, fSize);

  for i := 0 to fActiveIndex - 1 do
  begin
    readln(aFile, fEvents[i].Kind);
    readln(aFile, fEvents[i].Modifier);
    readln(aFile, Handle);
    fEvents[i].Target := gSpace.FindWithHandle(Handle);
  end;
end;

// ----------------------------------------------------------------------------
procedure AIEventList.SaveToFile(var aFile: TextFile);
var
  i: integer;
begin
  inherited SaveToFile(aFile);

  writeln(aFile, fActiveIndex);
  writeln(aFile, fSize);
  writeFileBoolean(aFile, fFull);

  for i := 0 to fActiveIndex - 1 do
  begin
    writeln(aFile, fEvents[i].Kind);
    writeln(aFile, fEvents[i].Modifier);
    writeln(aFile, AIBaseObject(fEvents[i].Target).Handle);
  end;
end;

// ----------------------------------------------------------------------------
procedure AIEventList.FullDisplay(aLines: TStrings);
var
  i: integer;
  RigidCount: integer;
  myEvent: AISpatialEvent;
begin
  aLines.Add('EventList');
  aLines.Add('--------------');
  inherited FullDisplay(aLines);
  aLines.Add('Full: ' + BoolToYesNoStr(fFull));
  aLines.Add('Size: ' + IntToStr(fSize));
  aLines.Add('ActiveIndex: ' + IntToStr(fActiveIndex));
  aLines.Add('--------------');
  RigidCount := ActiveIndex - 1;
  for i := 0 to RigidCount do
  begin
    myEvent := fEvents[i];
    aLines.Add(Format('%d Kind=%d, Target=%s, Modifier=%0.2f',
      [i, myEvent.Kind, PtrToStr(myEvent.Target), myEvent.Modifier]));
  end;
end;

// ----------------------------------------------------------------------------
procedure AIEventList.IncreaseArraySize(aAmount: integer);
begin
  fSize := Count + aAmount;
  SetLength(fEvents, Size);
end;

end.

