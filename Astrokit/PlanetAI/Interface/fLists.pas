{
  The unit of ai.planet project http://aiplanet.sourceforge.net
  Created by Dave Kerr (kerrd@hotmail.com)
}

unit fLists;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Classes,
  System.Contnrs,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Vcl.ComCtrls,
  Vcl.Buttons,
  Vcl.ToolWin,
  cAIReality,
  cAISatellites;

type
  TfmLists = class(TForm)
    Panel15: TPanel;
    Panel7: TPanel;
    panCultureName: TPanel;
    lbThings: TListBox;
    Panel3: TPanel;
    btnDelete: TBitBtn;
    Panel20: TPanel;
    Panel1: TPanel;
    btnView: TBitBtn;
    Splitter2: TSplitter;
    btnTrack: TBitBtn;
    ToolBar1: TToolBar;
    tbExistents: TToolButton;
    tbAttachments: TToolButton;
    tbReferences: TToolButton;
    tbGrids: TToolButton;
    tbCradle: TToolButton;
    tbPurgatory: TToolButton;
    tbThings: TToolButton;
    tbSpace: TToolButton;
    tbEnvironment: TToolButton;
    tbReality: TToolButton;
    redView: TRichEdit;
    Panel2: TPanel;
    btnClose: TBitBtn;
    tbEventRound: TToolButton;
    tbEventQueue: TToolButton;
    btnRefreshAll: TBitBtn;
    cbAutoRefresh: TCheckBox;
    cbPlants: TCheckBox;
    cbCreatures: TCheckBox;
    cbClouds: TCheckBox;
    tbFruits: TToolButton;
    tbPrey: TToolButton;
    tbPredators: TToolButton;
    tb3DView: TToolButton;
    tbColliders: TToolButton;
    tbTrash: TToolButton;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormShow(Sender: TObject);
    procedure btnRefreshAllClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnViewClick(Sender: TObject);
    procedure lbThingsDblClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnTrackClick(Sender: TObject);
    procedure tbExistentsClick(Sender: TObject);
    procedure tbGridsClick(Sender: TObject);
    procedure tbAttachmentsClick(Sender: TObject);
    procedure tbReferencesClick(Sender: TObject);
    procedure tbCradleClick(Sender: TObject);
    procedure tbPurgatoryClick(Sender: TObject);
    procedure tbFormsClick(Sender: TObject);
    procedure tbThingsClick(Sender: TObject);
    procedure tbSpaceClick(Sender: TObject);
    procedure tbEnvironmentClick(Sender: TObject);
    procedure tbEventRoundClick(Sender: TObject);
    procedure tbEventQueueClick(Sender: TObject);
    procedure tbRealityClick(Sender: TObject);
    procedure tbFruitsClick(Sender: TObject);
    procedure tbPreyClick(Sender: TObject);
    procedure tbPredatorsClick(Sender: TObject);
    procedure tb3DViewClick(Sender: TObject);
    procedure tbCollidersClick(Sender: TObject);
    procedure tbTrashClick(Sender: TObject);
  private
     
    fReality: AIReality;
  public
     
    property Reality: AIReality read fReality write fReality;

    procedure RefreshAll;
    procedure RefreshThings;
    procedure RefreshGrids;

    procedure Advance;

    procedure EditSatellite(aSatellite: AISatellite);
  end;

var
  fmLists: TfmLists;

implementation

{$R *.DFM}

uses
  fImages, cAIThings, fFirstForm, fSatellite, cAITrees, cAISpace,
  cAIGrid, cAICreature, cAIWeather, cAIEvolvingTrees;

procedure TfmLists.Advance;
begin
  if cbAutoRefresh.Checked then
    RefreshAll;
end;

procedure TfmLists.RefreshAll;
begin
  RefreshThings;
end;

procedure TfmLists.RefreshThings;
var
  myIndex: integer;
  myThing: AIThing;
  myLastPos: integer;
begin
  myLastPos := lbThings.ItemIndex;

  LockWindowUpdate(lbThings.Handle);

  lbThings.Clear;
  lbThings.Sorted := false;

  for myIndex := 0 to Reality.Environment.Things.Existents.Count -1 do
  begin
    myThing := AIThing(Reality.Environment.Things.Existents[myIndex]);

    if not ((myThing is AIPlant) or (myThing is AIEvolvingPlant)) or cbPlants.Checked then
    if not (myThing is AICreature) or cbCreatures.Checked then
    if not (myThing is AICloud) or cbClouds.Checked then
    lbThings.Items.AddObject(
      myThing.OneLineDisplay,
      myThing);
  end;

  lbThings.ItemIndex := lbThings.Items.Count - 1;

  lbThings.ItemIndex := myLastPos;

  LockWindowUpdate(0);
end;

procedure TfmLists.RefreshGrids;
var
  X: integer;
  Y: integer;
  myGrid: AIGrid;
begin
  redView.Clear;
  for X := 0 to Reality.Environment.Space.WidthLoop do
    for Y := 0 to Reality.Environment.Space.HeightLoop do
  begin
    myGrid := AIGrid(Reality.Environment.Space.Map[X][Y]);
    redView.Lines.Add(myGrid.OneLineDisplay);
  end;
end;

procedure TfmLists.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := false;
  fmFirstForm.RealityForm.ManagerForm.DropLists;
end;

procedure TfmLists.FormShow(Sender: TObject);
begin
  RefreshThings;
end;

procedure TfmLists.btnRefreshAllClick(Sender: TObject);
begin
  RefreshThings;
end;

procedure TfmLists.EditSatellite(aSatellite: AISatellite);
var
  myfmSatellite: TfmSatellite;
begin
  myfmSatellite := TfmSatellite.Create(self);

  myfmSatellite.Satellite := aSatellite;

  myfmSatellite.Show;
end;

procedure TfmLists.btnDeleteClick(Sender: TObject);
var
  myThing: AIThing;
begin
  if not (lbThings.ItemIndex = -1) then
  begin
    myThing := AIThing(lbThings.Items.Objects[lbThings.ItemIndex]);
    myThing.Cease;
  end;
end;

procedure TfmLists.btnViewClick(Sender: TObject);
var
  myThing: AIThing;
begin
  if not (lbThings.ItemIndex = -1) then
  begin
    myThing := AIThing(lbThings.Items.Objects[lbThings.ItemIndex]);
    fmFirstForm.RealityForm.ManagerForm.SpiritWindows.AddSpirit(myThing, true);
  end;
end;

procedure TfmLists.lbThingsDblClick(Sender: TObject);
var
  myThing: AIThing;
begin
  if not (lbThings.ItemIndex = -1) then
  begin
    myThing := AIThing(lbThings.Items.Objects[lbThings.ItemIndex]);
    fmFirstForm.RealityForm.ManagerForm.SpiritWindows.AddSpirit(myThing, true);
  end;
end;

procedure TfmLists.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfmLists.btnTrackClick(Sender: TObject);
var
  myThing: AIThing;
begin
  if not (lbThings.ItemIndex = -1) then
  begin
    myThing := AIThing(lbThings.Items.Objects[lbThings.ItemIndex]);
    fmFirstForm.RealityForm.ManagerForm.SpaceForm.FindTarget(myThing);
  end;
end;

procedure TfmLists.tbExistentsClick(Sender: TObject);
begin
  redView.Clear;
  Reality.Environment.Things.Existents.FullDisplay(redView.Lines);
end;

procedure TfmLists.tbGridsClick(Sender: TObject);
begin
  RefreshGrids;
end;

procedure TfmLists.tbAttachmentsClick(Sender: TObject);
begin
  redView.Clear;
  Reality.Environment.Attachments.FullDisplay(redView.Lines);
end;

procedure TfmLists.tbReferencesClick(Sender: TObject);
begin
  redView.Clear;
  Reality.Environment.References.FullDisplay(redView.Lines);
end;

procedure TfmLists.tbCradleClick(Sender: TObject);
begin
  redView.Clear;
  Reality.Environment.Things.Cradle.FullDisplay(redView.Lines);
end;

procedure TfmLists.tbPurgatoryClick(Sender: TObject);
begin
  redView.Clear;
  Reality.Environment.Things.Purgatory.FullDisplay(redView.Lines);
end;

procedure TfmLists.tbFormsClick(Sender: TObject);
begin
  redView.Clear;
  Reality.Environment.Things.Forms.FullDisplay(redView.Lines);
end;

procedure TfmLists.tbThingsClick(Sender: TObject);
begin
  redView.Clear;
  Reality.Environment.Things.FullDisplay(redView.Lines);
end;

procedure TfmLists.tbSpaceClick(Sender: TObject);
begin
  redView.Clear;
  Reality.Environment.Space.FullDisplay(redView.Lines);
end;

procedure TfmLists.tbEnvironmentClick(Sender: TObject);
begin
  redView.Clear;
  Reality.Environment.FullDisplay(redView.Lines);
end;

procedure TfmLists.tbEventRoundClick(Sender: TObject);
begin
  redView.Clear;
  Reality.Environment.Space.EventRound.FullDisplay(redView.Lines);
end;

procedure TfmLists.tbEventQueueClick(Sender: TObject);
begin
  redView.Clear;
  Reality.Environment.Space.EventQueue.FullDisplay(redView.Lines);
end;

procedure TfmLists.tbRealityClick(Sender: TObject);
begin
  redView.Clear;
  Reality.FullDisplay(redView.Lines);
end;

procedure TfmLists.tbFruitsClick(Sender: TObject);
begin
  redView.Clear;
  Reality.Environment.Things.Fruits.FullDisplay(redView.Lines);
end;

procedure TfmLists.tbPreyClick(Sender: TObject);
begin
  redView.Clear;
  Reality.Environment.Things.Prey.FullDisplay(redView.Lines);
end;

procedure TfmLists.tbPredatorsClick(Sender: TObject);
begin
  redView.Clear;
  Reality.Environment.Things.Predators.FullDisplay(redView.Lines);
end;

procedure TfmLists.tb3DViewClick(Sender: TObject);
begin
  redView.Clear;
  fmFirstForm.RealityForm.ManagerForm.SpaceForm.FullDisplay(redView.Lines);
end;

procedure TfmLists.tbCollidersClick(Sender: TObject);
begin
  redView.Clear;
  Reality.Environment.Things.Colliders.FullDisplay(redView.Lines);
end;

procedure TfmLists.tbTrashClick(Sender: TObject);
begin
  redView.Clear;
  Reality.Environment.Things.Trash.FullDisplay(redView.Lines);
end;

end.
