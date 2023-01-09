{
  ai.planet
  http://aiplanet.sourceforge.net
  Created by Dave Kerr and Aaron Hochwimmer
  $Id: fPopulations.pas,v 1.26 2003/09/25 19:46:46 uid105088 Exp $
}
unit fPopulations;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls,Forms,
  Dialogs, Vcl.StdCtrls,Vcl.Buttons, Vcl.ExtCtrls,VCLTee.TeEngine, VCLTee.TeeProcs,
  VCLTee.Chart, Data.DB, VCLTee.TeeData, VCLTee.Series, VclTee.TeeGDIPlus{, TeeProcs, TeEngine, Chart, Series};
 //JvEdit, JvTypedEdit

type
  TfmPopulations = class(TForm)
    PopGraph: TChart;
    Panel3: TPanel;
    Panel4: TPanel;
    btnRun: TBitBtn;
    cb3DGraph: TCheckBox;
    cbCrop: TCheckBox;
    cbHiddenRefresh: TCheckBox;
    Label1: TLabel;
    Label2: TLabel;
    Series1: TLineSeries;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnRunClick(Sender: TObject);
    procedure cb3DGraphClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edRateChange(Sender: TObject);
    procedure edCropChange(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
     
    Initialized: boolean;
    procedure InitializeGraph;
  public
     
    procedure Advance;
    procedure Clean;
  end;

var
  fmPopulations: TfmPopulations;

implementation

uses fFirstForm, cAIThings, cGlobals, GLS.Texture, GLS.Color;

{$R *.dfm}

procedure TfmPopulations.Advance;
var
  mySeries: TLineSeries;
  i: integer;
begin
  if not Visible and not cbHiddenRefresh.Checked then
    exit;

///  if not (gReality.Time mod edRate.Value = 0) then  exit;

  // TChart refresh
  for i := 0 to cLastThing do
  if (i <> cVibe) then
  begin
    mySeries := TLineSeries(PopGraph.SeriesList.Items[i]);
    mySeries.Title := ThingNamePlural(i) + ' (' + IntToStr(gThings.Counters[i]) + ')';

    if (mySeries.YValues.Count = 0) then
      mySeries.AddXY(gReality.Time-1, 0);
    if (mySeries.YValues.Count = 1) then
      mySeries.AddXY(gReality.Time, 0);

    // check for change
    if gThings.Counters[i] <> mySeries.YValue[mySeries.YValues.Count-1] then
    begin
///      mySeries.XValue[mySeries.XValues.Count-1] := gReality.Time-edRate.Value;
      // add extra point to extend
      mySeries.AddXY(gReality.Time, gThings.Counters[i]);
      mySeries.Active := true;
    end
    else
    begin
      // extend the line if no change
      if mySeries.YValue[mySeries.YValues.Count-1] <> 0 then
        mySeries.XValue[mySeries.XValues.Count-1] := gReality.Time;
    end;
  end;

  if cbCrop.Checked then
    Clean;
end;

procedure TfmPopulations.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := false;
  fmFirstForm.RealityForm.ManagerForm.DropPopulations;
end;

procedure TfmPopulations.btnRunClick(Sender: TObject);
begin
  Close;
end;

procedure TfmPopulations.InitializeGraph;
var
  mySeries: TLineSeries;
  i: integer;
  myColor: TGLColor;
begin
  if Initialized then exit;

  myColor := TGLColor.Create(nil);

  // add all Kinds of things to the graph, and hide them
  // each line becomes active when things appear
  for i := 0 to cLastThing do
  begin
    mySeries := TLineSeries.Create(self);
    mySeries.ParentChart := PopGraph;
    mySeries.Title := ThingNamePlural(i) + ' (' + IntToStr(gThings.Counters[i]) + ')';
    mySeries.Active := false;
    mySeries.Stairs := false;
    myColor.RandomColor;
    mySeries.SeriesColor := myColor.AsWinColor;
    // start
    mySeries.AddXY(gReality.Time-1, gThings.Counters[i]);
    mySeries.AddXY(gReality.Time, gThings.Counters[i]);
    if (i <> cVibe) and (gThings.Counters[i] <> 0) then
      mySeries.Active := true;
    mySeries.HorizAxis := aBothHorizAxis;
    mySeries.VertAxis := aBothVertAxis;
  end;
  Initialized := true;
  myColor.Free;
end;

procedure TfmPopulations.Clean;
var
  mySeries: TLineSeries;
  i, crop, remove: integer;
begin
///  crop := gReality.Time - edCrop.Value; // XValue crop line

  // delete all entries older than the crop value
  for i := 0 to cLastThing do
  if (i <> cVibe) then
  begin
    mySeries := TLineSeries(PopGraph.SeriesList.Items[i]);

    // if two points behind the crop line, then delete the first one
    if mySeries.XValues.Count > 1 then
    begin
      remove := 0;
      // find the amount of items behind crop line
      while (remove<mySeries.XValues.Count) and (mySeries.XValue[remove]<crop) do
        inc(remove);
      // delete all but one of those items
      while remove > 1 do
      begin
        mySeries.Delete(0);
        dec(remove);
      end;
      // position the last item onto the crop line
      if remove = 1 then
      begin
        mySeries.XValue[0] := crop;
        if mySeries.YValues.Count > 1 then
          mySeries.YValue[0] := mySeries.YValue[1];
      end;
    end;
    // if this graph is dead, hide it
    if (mySeries.XValues.Count = 1) and (mySeries.XValue[0] <= crop) then
      mySeries.Active := false;
  end;
end;

procedure TfmPopulations.cb3DGraphClick(Sender: TObject);
begin
  PopGraph.View3D := cb3DGraph.Checked;
end;

procedure TfmPopulations.FormShow(Sender: TObject);
begin
  InitializeGraph;
end;

procedure TfmPopulations.FormCreate(Sender: TObject);
begin
  Initialized := false;
end;

procedure TfmPopulations.edRateChange(Sender: TObject);
begin
///  if edRate.Value < 1 then edRate.Value := 1;
end;

procedure TfmPopulations.edCropChange(Sender: TObject);
begin
///  if edCrop.Value < 1 then edCrop.Value := 1;
end;

procedure TfmPopulations.Button1Click(Sender: TObject);
var
  myFile: TextFile;
  i: integer;
begin
  AssignFile(myFile, 'data\pops.csv');
  Rewrite(myFile);

  for i := 0 to cLastThing do
  if i <> cVibe then
  begin
    writeln(myFile, ThingNamePlural(i) + ',0,0,0');
  end;

  CloseFile(myFile);
end;

end.
