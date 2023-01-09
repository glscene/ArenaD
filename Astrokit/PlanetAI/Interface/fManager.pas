{
  ai.planet
  http://aiplanet.sourceforge.net
  Created by Dave Kerr (kerrd@hotmail.com)
  $Id: fManager.pas,v 1.27 2003/08/12 23:28:36 aidave Exp $
}
unit fManager;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.ComCtrls,
  ToolWin,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  System.Contnrs,
  fImages,
  fEvents,
  fLists,
  fSpirit,
  vInterfaceClasses,
  f3DEnvironment,
  vSpiritManager,
  fPopulations,
  fHeightField,
  fHumidityMap,
  Vcl.Buttons,
  Vcl.Menus;

type

  TfmManager = class(TForm)
    Panel3: TPanel;
    Panel2: TPanel;
    panSpirits: TPanel;
    Panel1: TPanel;
    tbSpirits: TToolBar;
    ToolBar1: TToolBar;
    tbEvents: TToolButton;
    tbLists: TToolButton;
    tbSpace: TToolButton;
    tbTime: TToolButton;
    tbConstruction: TToolButton;
    tbPopulations: TToolButton;
    tbHeightField: TToolButton;
    tbHumidityMap: TToolButton;
    Panel4: TPanel;
    btnAddThing: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure tbEventsClick(Sender: TObject);
    procedure tbListsClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormShow(Sender: TObject);
    procedure tbSpaceClick(Sender: TObject);
    procedure tbTimeClick(Sender: TObject);
    procedure tbConstructionClick(Sender: TObject);
    procedure tbPopulationsClick(Sender: TObject);
    procedure tbHeightFieldClick(Sender: TObject);
    procedure tbHumidityMapClick(Sender: TObject);
    procedure btnAddThingClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
     
    fSpiritWindows: TSpiritList;
    fSpaceForm: Tfm3DEnvironment;
    fEventsForm: TfmEvents;
    fListsForm: TfmLists;
    fPopulations: TfmPopulations;
    fHeightField: TfmHeightField;
    fHumidityMap: TfmHumidityMap;
    fStarted: boolean;
  public
     
    property SpaceForm: Tfm3DEnvironment read fSpaceForm;
    property EventsForm: TfmEvents read fEventsForm;
    property ListsForm: TfmLists read fListsForm;
    property SpiritWindows: TSpiritList read fSpiritWindows;
    property Populations: TfmPopulations read fPopulations;
    property HeightField: TfmHeightField read fHeightField;
    property HumidityMap: TfmHumidityMap read fHumidityMap;

    procedure Advance;

    procedure RefreshSpirits;
    procedure PopSpace;
    procedure DropSpace;
    procedure PopLists;
    procedure DropLists;
    procedure PopEvents;
    procedure DropEvents;
    procedure PopConstruction;
    procedure DropConstruction;
    procedure PopPopulations;
    procedure DropPopulations;
    procedure PopHeightField;
    procedure DropHeightField;
    procedure PopHumidityMap;
    procedure DropHumidityMap;
    procedure BigHide;
    procedure BigRestore;

    procedure DropAll;
    procedure Reset;
    procedure Verify;

    function FocusForm: TForm;
  end;

var
  fmManager: TfmManager;

implementation

uses
  fReality, fFirstForm, fConstruction, cGlobals, Math;

{$R *.DFM}

procedure TfmManager.FormCreate(Sender: TObject);
begin
  fStarted := false;

  fmFirstForm.Construction.AddEvent('Creating fEventsForm...');
  fEventsForm := TfmEvents.Create(self);

  fmFirstForm.Construction.AddEvent('Creating SpiritList...');
  fSpiritWindows := TSpiritList.Create(self, tbSpirits);

  fmFirstForm.Construction.AddEvent('Creating f3DEnvironment...');
  fSpaceForm := Tfm3DEnvironment.Create(self);

end;

procedure TfmManager.FormDestroy(Sender: TObject);
begin
  DropAll;

  fEventsForm.Free;
  fSpiritWindows.Free;
  if Assigned(fListsForm) then
    fListsForm.Free;
  // free populations graph
  if Assigned(fPopulations) then
    fPopulations.Free;
  // free heat map
  if Assigned(fHeightField) then
  begin
    fHeightField.GLSceneViewer.Camera := nil;
    fHeightField.GLScene.CurrentGLCamera.DeleteChildren;
    fHeightField.Free;
  end;
  // free humidity map
  if Assigned(fHumidityMap) then
  begin
    fHumidityMap.GLSceneViewer.Camera := nil;
    fHumidityMap.GLScene.CurrentGLCamera.DeleteChildren;
    fHumidityMap.Free;
  end;
  fSpaceForm.Free;
end;

procedure TfmManager.Advance;
begin
  if SpiritWindows.Count <> 0 then
    SpiritWindows.AdvanceAll;

  if tbLists.Down then
    ListsForm.Advance;

  if tbSpace.Down then
    SpaceForm.Advance
  else
    SpaceForm.AdvanceHidden;

  if Assigned(Populations) then
    Populations.Advance;

  if tbHeightField.Down then
    HeightField.Advance;

  if tbHumidityMap.Down then
    HumidityMap.Advance;
end;

procedure TfmManager.DropAll;
begin
  DropSpace;
  DropEvents;
  DropLists;
  DropPopulations;
  DropHeightField;
  DropHumidityMap;
end;

procedure TfmManager.BigHide;
begin
  SpaceForm.Hide;
  EventsForm.Hide;
  fmImages.Hide;
  SpiritWindows.HideAll;
  if Assigned(fListsForm) then
    ListsForm.Hide;
  if Assigned(fPopulations) then
    Populations.Hide;
  if Assigned(fHeightField) then
    HeightField.Hide;
  if Assigned(fHumidityMap) then
    HumidityMap.Hide;
end;

procedure TfmManager.BigRestore;
begin
  Show;

  if tbSpace.Down then
    PopSpace;
  if tbEvents.Down then
    PopEvents;
  if tbLists.Down then
    PopLists;
  if tbPopulations.Down then
    PopPopulations;
  if tbHeightField.Down then
    PopHeightField;
  if tbHumidityMap.Down then
    PopHumidityMap;
end;

procedure TfmManager.RefreshSpirits;
var
  i: integer;
begin
  for i := 0 to SpiritWindows.Count - 1 do
    TSpiritHolder(SpiritWindows.Items[i]).SpiritForm.RefreshAll;
end;

procedure TfmManager.PopSpace;
begin
  if not SpaceForm.Visible then
    SpaceForm.RefreshPlanetFull;
    
  tbSpace.Down := true;
  SpaceForm.Show;
  SpaceForm.GLCadencer.Enabled := true;
end;

procedure TfmManager.DropSpace;
begin
  tbSpace.Down := false;
  SpaceForm.Visible := false;
  SpaceForm.EmptyAllSounds;
  SpaceForm.GLCadencer.Enabled := false;
end;

procedure TfmManager.PopEvents;
begin
  tbEvents.Down := true;
  EventsForm.Show;
end;

procedure TfmManager.DropEvents;
begin
  tbEvents.Down := false;
  EventsForm.Visible := false;
end;

procedure TfmManager.PopLists;
var
  myMonitor: integer;
begin
  if not Assigned(fListsForm) then
  begin
    fmFirstForm.Construction.AddEvent('Creating fListForm...');
    fListsForm := TfmLists.Create(self);
    fListsForm.Reality := gReality;
  end;

  tbLists.Down := true;
  ListsForm.Show;

  myMonitor := fmFirstForm.Monitors - 1;  // last monitor

  ListsForm.Left := fmFirstForm.Screen.Monitors[myMonitor].Left;
  ListsForm.Top := fmFirstForm.Screen.Monitors[myMonitor].Top;
end;

procedure TfmManager.DropLists;
begin
  tbLists.Down := false;
  if Assigned(fListsForm) then
    ListsForm.Visible := false;
end;

procedure TfmManager.PopConstruction;
begin
  tbConstruction.Down := true;
  fmFirstForm.Construction.Show;
end;

procedure TfmManager.DropConstruction;
begin
  tbConstruction.Down := false;
  fmFirstForm.Construction.Visible := false;
end;

procedure TfmManager.tbEventsClick(Sender: TObject);
begin
  if tbEvents.Down then
    PopEvents
  else
    DropEvents;
end;

procedure TfmManager.tbListsClick(Sender: TObject);
begin
  if tbLists.Down then
    PopLists
  else
    DropLists;
end;

procedure TfmManager.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := false;
end;

procedure TfmManager.FormShow(Sender: TObject);
begin
  panSpirits.Left := panSpirits.Left + 1;

  if fmFirstForm.UserSettings.RememberView then
  begin
    if fmFirstForm.UserSettings.ViewAligned then
    begin
      SpaceForm.Align := alClient;
      SpaceForm.tbStickyFit.Down := true;
    end
    else
    begin
      SpaceForm.Align := alNone;
      SpaceForm.tbStickyFit.Down := false;
      SpaceForm.Width := fmFirstForm.UserSettings.ViewSizeX;
      SpaceForm.Height := fmFirstForm.UserSettings.ViewSizeY;
    end;
  end;

  SpaceForm.Top := Top;
  SpaceForm.Left := Left + Width;
  SpaceForm.Left := SpaceForm.Left + 1;
  SpaceForm.Left := SpaceForm.Left - 1;
  SpaceForm.Height := SpaceForm.Height + 1;
  SpaceForm.Height := SpaceForm.Height - 1;

  if not fStarted and fmFirstForm.UserSettings.TipOfTheDay then
    fmFirstForm.RealityForm.ShowTipOfTheDay;
  fStarted := true;
end;

procedure TfmManager.tbSpaceClick(Sender: TObject);
begin
  if tbSpace.Down then
    PopSpace
  else
    DropSpace;
end;

procedure TfmManager.tbTimeClick(Sender: TObject);
begin
  tbTime.Down := true;
  fmFirstForm.RealityForm.Show;
end;

procedure TfmManager.tbConstructionClick(Sender: TObject);
begin
  if tbConstruction.Down then
    PopConstruction
  else
    DropConstruction;
end;

procedure TfmManager.PopPopulations;
begin
  if not Assigned(fPopulations) then
  begin
    fmFirstForm.Construction.AddEvent('Creating Populations...');
    fPopulations := TfmPopulations.Create(self);
  end;

  tbPopulations.Down := true;
  Populations.Show;
end;

procedure TfmManager.DropPopulations;
begin
  if Assigned(fPopulations) then
    Populations.Hide;
  tbPopulations.Down := false;
end;

procedure TfmManager.tbPopulationsClick(Sender: TObject);
begin
  if tbPopulations.Down then
    PopPopulations
  else
    DropPopulations;
end;

procedure TfmManager.PopHeightField;
begin
  if not Assigned(fHeightField) then
  begin
    fmFirstForm.Construction.AddEvent('Creating Height Field...');
    fHeightField := TfmHeightField.Create(self);
  end;

  tbHeightField.Down := true;
  HeightField.Show;
end;

procedure TfmManager.DropHeightField;
begin
  tbHeightField.Down := false;
  if Assigned(fHeightField) then
  begin
    HeightField.Visible := false;
//    fHeightField.Free;
//    fHeightField := nil;
  end;
end;

procedure TfmManager.tbHeightFieldClick(Sender: TObject);
begin
  if tbHeightField.Down then
    PopHeightField
  else
    DropHeightField;
end;

procedure TfmManager.PopHumidityMap;
begin
  if not Assigned(fHumidityMap) then
  begin
    fmFirstForm.Construction.AddEvent('Creating Humidity Map...');
    fHumidityMap := TfmHumidityMap.Create(self);
  end;

  tbHumidityMap.Down := true;
  HumidityMap.Show;
end;

procedure TfmManager.DropHumidityMap;
begin
  tbHumidityMap.Down := false;
  if Assigned(fHumidityMap) then
  begin
    HumidityMap.Visible := false;
//    fHumidityMap.Free;
//    fHumidityMap := nil;
  end;
end;

procedure TfmManager.tbHumidityMapClick(Sender: TObject);
begin
  if tbHumidityMap.Down then
    PopHumidityMap
  else
    DropHumidityMap;
end;

procedure TfmManager.Reset;
begin
  DropAll;
  if Assigned(fPopulations) then
  begin
    fPopulations.Free;
    fPopulations := nil;
  end;
end;

procedure TfmManager.btnAddThingClick(Sender: TObject);
begin
  fSpaceForm.PopUpTargetWindow;
end;

procedure TfmManager.FormActivate(Sender: TObject);
begin
//  Verify;
//  Show;
//  SetFocus;
end;

procedure TfmManager.Verify;
begin
  fmFirstForm.RealityForm.Show;
  BigRestore;
end;

function TfmManager.FocusForm: TForm;
begin
  result := self;
  if SpaceForm.Focused then
    result := SpaceForm;
  if EventsForm.Focused then
    result := EventsForm;
  if Assigned(ListsForm) and ListsForm.Focused then
    result := ListsForm;
  if Assigned(Populations) and Populations.Focused then
    result := Populations;
  if Assigned(HeightField) and HeightField.Focused then
    result := HeightField;
  if Assigned(HumidityMap) and HumidityMap.Focused then
    result := HumidityMap;
end;

end.
