{
  ai.planet
  http://aiplanet.sourceforge.net
  Created by Dave Kerr (kerrd@hotmail.com)
}
unit cAIReportCard;

interface

uses
  System.Classes,
  System.Contnrs,
  cAIBaseObject,
  cAIThings,
  cAIPosition,
  cAILink,
  cAILife;

type

// *****************************************************************************
AIReportCard = class(TObject)
private
  fKind: integer;     // kind of object eaten
  fSuccess: integer;  // times succesful (health+)
  fTotal: integer;    // total times tried
  fWeight: single;    // =Success/Total, how "important" this is
  fValue: integer;   // average Value of health gained (*(total-1)/total)
  fEffort: integer;   // average amount of time taken to catch
public
  property Kind: integer read fKind write fKind;
  property Success: integer read fSuccess write fSuccess;
  property Total: integer read fTotal write fTotal;
  property Weight: single read fWeight;
  property Value: integer read fValue write fValue;
  property Effort: integer read fEffort;

  procedure UpdateReport(aResult: boolean; aValue: integer; aEffort: integer);

  function Failed: integer;   //=Total-Success, how many times failed
  function OneLineDisplay: string;

  procedure SaveToFile(var aFile: TextFile);
  procedure LoadFromFile(var aFile: TextFile);
end;

// *****************************************************************************
AIReportList = class(TActiveList)
public
  procedure AddReport(aKind: integer; aSuccess: boolean; aValue: integer; aEffort: integer);
  procedure FullDisplay(aList: TStrings);
  function ReportWeight(aKind: integer): single; overload;
  function ReportWeight(aLivingThing: AILivingThing): single; overload;

  function HighestWeight: integer;
  function LowestWeight: integer;

  procedure SaveToFile(var aFile: TextFile);
  procedure LoadFromFile(var aFile: TextFile);
end;

implementation

uses SysUtils;

// ----------------------------------------------------------------------------
procedure AIReportList.AddReport(aKind: integer; aSuccess: boolean; aValue: integer; aEffort: integer);
var
  myReport: AIReportCard;
  i: integer;
begin
  myReport := nil;
  // find it
  for i := 0 to Count - 1 do
    if AIReportCard(Items[i]).Kind = aKind then
      myReport := AIReportCard(Items[i]);
  // found it
  if myReport <> nil then
    myReport.UpdateReport(aSuccess, aValue, aEffort)
  else
  begin
    myReport := AIReportCard.Create;
    myReport.Kind := aKind;
    myReport.UpdateReport(aSuccess, aValue, aEffort);
    Add(myReport);
  end;
end;

// ----------------------------------------------------------------------------
procedure AIReportList.FullDisplay(aList: TStrings);
var
  i: integer;
  myReport: AIReportCard;
begin
  aList.Add('Reports: ' + IntToStr(Count));
  for i := 0 to Count - 1 do
  begin
    myReport := AIReportCard(Items[i]);
    aList.AddObject(IntToStr(i+1) + ': '
      + myReport.OneLineDisplay, myReport);
  end;
end;

// ----------------------------------------------------------------------------
procedure AIReportCard.UpdateReport(aResult: boolean; aValue: integer; aEffort: integer);
begin
  // add to average Value
  fValue := (fValue * fTotal + aValue) div (fTotal + 1);
  // add to average effort
  fEffort := (fEffort * fTotal + aEffort) div (fTotal + 1);
  // add to total
  fTotal := fTotal + 1;
  // add to success?
  if aResult then fSuccess := fSuccess + 1;
  // calculate weight
  fWeight := (fSuccess/fTotal) * (fValue/fEffort);
end;

// ----------------------------------------------------------------------------
function AIReportCard.Failed: integer;   //=Total-Success, how many times failed
begin
  result := fTotal - fSuccess;
end;

// ----------------------------------------------------------------------------
function AIReportCard.OneLineDisplay: string;
begin
  result := ThingName(fKind) + Format('->Weight=%0.2f, Kind=%d, Success=%d, Failed=%d, Total=%d, Value=%d, Effort=%d',
    [fWeight, fKind, fSuccess, Failed, fTotal, fValue, fEffort]);
end;

// ----------------------------------------------------------------------------
function AIReportList.ReportWeight(aKind: integer): single;
var
  i: integer;
  myReport: AIReportCard;
begin
  result := 100; // returns 50 if unknown thing
  for i := 0 to Count - 1 do
  begin
    myReport := AIReportCard(Items[i]);
    if myReport.Kind = aKind then
      result := myReport.Weight;
  end;
end;

// ----------------------------------------------------------------------------
function AIReportList.ReportWeight(aLivingThing: AILivingThing): single;
var
  i: integer;
  myReport: AIReportCard;
begin
  result := aLivingThing.Health;
  for i := 0 to Count - 1 do
  begin
    myReport := AIReportCard(Items[i]);
    if myReport.Kind = aLivingThing.Kind then
      result := myReport.Weight;
  end;
end;

// ----------------------------------------------------------------------------
procedure AIReportCard.LoadFromFile(var aFile: TextFile);
begin
  readln(aFile, fKind);
  readln(aFile, fSuccess);
  readln(aFile, fTotal);
  readln(aFile, fWeight);
  readln(aFile, fValue);
  readln(aFile, fEffort);
end;

// ----------------------------------------------------------------------------
procedure AIReportCard.SaveToFile(var aFile: TextFile);
begin
  writeln(aFile, fKind);
  writeln(aFile, fSuccess);
  writeln(aFile, fTotal);
  writeln(aFile, fWeight);
  writeln(aFile, fValue);
  writeln(aFile, fEffort);
end;

// ----------------------------------------------------------------------------
procedure AIReportList.SaveToFile(var aFile: TextFile);
var
  i: Integer;
  myReport: AIReportCard;
begin
  writeln(aFile, Count);
  for i := 0 to Count - 1 do
  begin
    myReport := AIReportCard(Items[i]);
    myReport.SaveToFile(aFile);
  end;
end;

// ----------------------------------------------------------------------------
procedure AIReportList.LoadFromFile(var aFile: TextFile);
var
  i: Integer;
  myCount: Integer;
  myReport: AIReportCard;
begin
  readln(aFile, myCount);
  for i := 0 to myCount - 1 do
  begin
    myReport := AIReportCard.Create;
    myReport.LoadFromFile(aFile);
    Add(myReport);
  end;
end;

// ----------------------------------------------------------------------------
function AIReportList.HighestWeight: integer;
var
  i: integer;
  myReport: AIReportCard;
  best: single;
begin
  result := cNoThing;
  best := -1;
  for i := 0 to Count - 1 do
  begin
    myReport := AIReportCard(Items[i]);
    if myReport.Weight > best then
    begin
      best := myReport.Weight;
      result := myReport.Kind;
    end;
  end;
end;

// ----------------------------------------------------------------------------
function AIReportList.LowestWeight: integer;
var
  i: integer;
  myReport: AIReportCard;
  worst: single;
begin
  result := cNoThing;
  worst := 100000;
  for i := 0 to Count - 1 do
  begin
    myReport := AIReportCard(Items[i]);
    if myReport.Weight < worst then
    begin
      worst := myReport.Weight;
      result := myReport.Kind;
    end;
  end;
end;

end.
