unit fEnvironment;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Controls,Forms, Dialogs,
  ComCtrls, ToolWin, Vcl.ExtCtrls,cAIEnvironment, cAIEnvironmentStructures,
  cAISpace, Vcl.StdCtrls,cAIThings, vInterfaceClasses;

type
  TfmEnvironment = class(TForm)
    Panel3: TPanel;
    panelMap: TPanel;
    imageMap: TImage;
    ToolBarSpace: TToolBar;
    tbWateringCan: TToolButton;
    tbSpiritGuy: TToolButton;
    tbSpiritGirl: TToolButton;
    tbAppleTree: TToolButton;
    tbOrangeTree: TToolButton;
    tbSlime: TToolButton;
    tbBrick: TToolButton;
    tbCrawly: TToolButton;
    StatusBar: TStatusBar;
    ToolButton1: TToolButton;
    tbRefresh: TToolButton;
    ToolTimer: TTimer;
    Panel4: TPanel;
    tbWater: TToolBar;
    tbAddRemoveWater: TToolButton;
    tbLandDesert: TToolButton;
    tbLandDirt: TToolButton;
    tbLandField: TToolButton;
    tbLandGrass: TToolButton;
    tbWaterPuddle: TToolButton;
    tbWaterPuddle2: TToolButton;
    tbWaterLake: TToolButton;
    tbWaterSea: TToolButton;
    ToolButton2: TToolButton;
    Panel1: TPanel;
    edWater: TEdit;
    WaterUpDown: TUpDown;
    ToolButton3: TToolButton;
    tbFauna: TToolBar;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    tbBoringTree: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    ToolButton12: TToolButton;
    ToolButton13: TToolButton;
    ToolButton14: TToolButton;
    tbTemperature: TToolButton;
    tbSun: TToolButton;
    tbMoon: TToolButton;
    procedure tbWateringCanClick(Sender: TObject);
    procedure tbSpiritGuyClick(Sender: TObject);
    procedure tbSpiritGirlClick(Sender: TObject);
    procedure tbAppleTreeClick(Sender: TObject);
    procedure tbOrangeTreeClick(Sender: TObject);
    procedure tbAppleClick(Sender: TObject);
    procedure tbOrangeClick(Sender: TObject);
    procedure tbSlimeClick(Sender: TObject);
    procedure tbBrickClick(Sender: TObject);
    procedure tbBirdClick(Sender: TObject);
    procedure tbCrawlyClick(Sender: TObject);
    procedure imageMapMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure imageMapMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure tbRefreshClick(Sender: TObject);
    procedure imageMapMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ToolTimerTimer(Sender: TObject);
    procedure tbLandDesertClick(Sender: TObject);
    procedure tbAddRemoveWaterClick(Sender: TObject);
    procedure tbLandDirtClick(Sender: TObject);
    procedure tbLandFieldClick(Sender: TObject);
    procedure tbLandGrassClick(Sender: TObject);
    procedure tbWaterPuddleClick(Sender: TObject);
    procedure tbWaterPuddle2Click(Sender: TObject);
    procedure tbWaterLakeClick(Sender: TObject);
    procedure tbWaterSeaClick(Sender: TObject);
    procedure WaterUpDownClick(Sender: TObject; Button: TUDBtnType);
    procedure tbHumidityClick(Sender: TObject);
    procedure tbCloudClick(Sender: TObject);
    procedure tbTemperatureClick(Sender: TObject);
    procedure tbSunClick(Sender: TObject);
    procedure tbMoonClick(Sender: TObject);
  private
     
    fEnvironment: AIEnvironment;

    fMouseGridX: integer;
    fMouseGridY: integer;
    fTool: eTool;
    fToolIsActive: boolean;
    fOppositeTool: boolean;
    fWaterLevel: integer;

    procedure SetMouseGridX(X: integer);
    procedure SetMouseGridY(Y: integer);

    procedure SetTool(aTool: eTool);
  public
     
    property Environment: AIEnvironment read fEnvironment write fEnvironment;
    property MouseGridX: integer read fMouseGridX write SetMouseGridX;
    property MouseGridY: integer read fMouseGridY write SetMouseGridY;
    property Tool: eTool read fTool write SetTool;
    property ToolIsActive: boolean read fToolIsActive write fToolIsActive;
    property OppositeTool: boolean read fOppositeTool write fOppositeTool;
    property WaterLevel: integer read fWaterLevel write fWaterLevel;

    procedure ClearMap;
    procedure RefreshMap;
    procedure RefreshMouseGrid(aColor: TColor);
    procedure RefreshSquare(X: integer; Y: integer);
    procedure RefreshThings;
    procedure RefreshGridInfo;
    procedure StartUsingTool;
    procedure StopUsingTool;
    procedure DrawThing(aThing: AIThing);
    procedure ApplyTool(aTool: eTool; X: integer; Y: integer);
    procedure AddSpirit(aGender: integer);
    procedure ReportUserEvent(aEvent: string);
  end;

var
  fmEnvironment: TfmEnvironment;

implementation

{$R *.DFM}

uses
  fImages, cAISpirit, fFirstForm, fReality, cAITrees, cAISatellites, cAIGrid;


procedure TfmEnvironment.FormCreate(Sender: TObject);
begin
  Tool := tWateringCan;
  tbWateringCan.Down := true;
  fToolIsActive := false;
  fOppositeTool := false;
  fWaterLevel := wlOverflow;

  ImageMap.Cursor := crNone;
end;

procedure TfmEnvironment.ReportUserEvent(aEvent: string);
begin
  fmFirstForm.RealityForm.ManagerForm.EventsForm.AddEvent(
    fmFirstForm.RealityForm.Reality.Creator + ' -> ' + aEvent);
end;

procedure TfmEnvironment.ClearMap;
var
  myRect: TRect;
begin
  // clear the map
  imageMap.Canvas.Brush.Color := panelMap.Color;
  myRect.Left := 0;
  myRect.Right := 600;
  myRect.Top := 0;
  myRect.Bottom := 600;
  imageMap.Canvas.FillRect(myRect);
end;

procedure TfmEnvironment.RefreshMap;
var
  myWidth: integer;
  myHeight: integer;
begin
  ClearMap;

  // draw land
  for myWidth := 0 to Environment.Space.Width - 1 do
    for myHeight := 0 to Environment.Space.Height - 1 do
      RefreshSquare(myWidth, myHeight);

  RefreshThings;

  RefreshMouseGrid(clBlack);
  RefreshGridInfo;
end;

procedure TfmEnvironment.RefreshThings;
var
  i: integer;
begin
  for i := Environment.Things.Existents.Count - 1 downto 0 do
    DrawThing(AIThing(Environment.Things.Existents.Items[i]));
  for i := Environment.Culture.Count - 1 downto 0 do
    DrawThing(AIThing(Environment.Culture.Items[i]));
end;

procedure TfmEnvironment.DrawThing(aThing: AIThing);
var
  myGraphic: TGraphic;
  mySpirit: AISpirit;
begin
  case aThing.Kind of
    cApple:       myGraphic := fmImages.imgApple.Picture.Graphic;
    cOrange:      myGraphic := fmImages.imgOrange.Picture.Graphic;
    cAppleSeed:   myGraphic := fmImages.imgSeed.Picture.Graphic;
    cOrangeSeed:  myGraphic := fmImages.imgSeed.Picture.Graphic;
    cSun:         myGraphic := fmImages.imgSun.Picture.Graphic;
    cMoon:        myGraphic := fmImages.imgMoon.Picture.Graphic;
    cBrick:       myGraphic := fmImages.imgBrick.Picture.Graphic;
    cSlime:       myGraphic := fmImages.imgSlime.Picture.Graphic;
    cCloud:
      begin
        if not (aThing.Location.Temperature = 0) then
        case ((AICloud(aThing).Water) mod 5) of
          0: myGraphic := fmImages.imgCloudRain5.Picture.Graphic;
          1: myGraphic := fmImages.imgCloudRain4.Picture.Graphic;
          2: myGraphic := fmImages.imgCloudRain3.Picture.Graphic;
          3: myGraphic := fmImages.imgCloudRain2.Picture.Graphic;
          4: myGraphic := fmImages.imgCloudRain1.Picture.Graphic;
        end
        else
        case ((AICloud(aThing).Water) mod 5) of
          0: myGraphic := fmImages.imgCloudSnow5.Picture.Graphic;
          1: myGraphic := fmImages.imgCloudSnow4.Picture.Graphic;
          2: myGraphic := fmImages.imgCloudSnow3.Picture.Graphic;
          3: myGraphic := fmImages.imgCloudSnow2.Picture.Graphic;
          4: myGraphic := fmImages.imgCloudSnow1.Picture.Graphic;
        end;
      end;
    cAppleTree:
      begin
        case AITree(aThing).Age of
          cTreeSapling..cTreeFlowering - 1:
            myGraphic := fmImages.imgTreeSapling.Picture.Graphic;
          cTreeFlowering..cTreeTeenager - 1:
            myGraphic := fmImages.imgTreeFlowering.Picture.Graphic;
          cTreeTeenager..cTreeAdult - 1:
            myGraphic := fmImages.imgTreeTeenager.Picture.Graphic;
        else
          myGraphic := fmImages.imgAppleTree.Picture.Graphic;
        end;
      end;
    cOrangeTree:
      begin
        case AITree(aThing).Age of
          cTreeSapling..cTreeFlowering - 1:
            myGraphic := fmImages.imgTreeSapling.Picture.Graphic;
          cTreeFlowering..cTreeTeenager - 1:
            myGraphic := fmImages.imgTreeFlowering.Picture.Graphic;
          cTreeTeenager..cTreeAdult - 1:
            myGraphic := fmImages.imgTreeTeenager.Picture.Graphic;
        else
          myGraphic := fmImages.imgOrangeTree.Picture.Graphic;
        end;
      end;
    cSpirit:
      begin
        mySpirit := AISpirit(aThing);
        if mySpirit.IsAlive then
        begin
          if mySpirit.IsMale then
            myGraphic := fmImages.imgGuy.Picture.Graphic
          else
            myGraphic := fmImages.imgGirl.Picture.Graphic;
        end
        else
            myGraphic := fmImages.imgDeadGuy.Picture.Graphic;
      end;
  end;

  imageMap.Canvas.CopyMode := cmSrcAnd; // blend
  imageMap.Canvas.Draw(
    1 + 16 * aThing.Location.Coordinates.X + aThing.Offset.X,
    1 + 16 * aThing.Location.Coordinates.Y + aThing.Offset.Y,
    myGraphic);
end;

procedure TfmEnvironment.RefreshSquare(X: integer; Y: integer);
var
  myGrid: AIGrid;
  myGraphic: TGraphic;
begin
  myGrid := Environment.Space.Map[X][Y];

  case myGrid.Water of
    wlDesert..wlDirt - 1:
      myGraphic := fmImages.imgLandDesert.Picture.Graphic;
    wlDirt..wlField - 1:
      myGraphic := fmImages.imgLandDirt.Picture.Graphic;
    wlField..wlGrass - 1:
      myGraphic := fmImages.imgLandField.Picture.Graphic;
    wlGrass..wlPuddle - 1:
      myGraphic := fmImages.imgLandGrass.Picture.Graphic;
    wlPuddle..wlPuddle2 - 1:
      myGraphic := fmImages.imgWaterPuddle.Picture.Graphic;
    wlPuddle2..wlLake - 1:
      myGraphic := fmImages.imgWaterPuddle2.Picture.Graphic;
    wlLake..wlSea - 1:
      myGraphic := fmImages.imgWaterLake.Picture.Graphic;
    wlSea..wlOverFlow:
      myGraphic := fmImages.imgWaterSea.Picture.Graphic;
    wlOverFlow + 1..10000:
    begin
      case Random(3) of
        0: myGraphic := fmImages.imgWaterWave1.Picture.Graphic;
        1: myGraphic := fmImages.imgWaterWave2.Picture.Graphic;
        2: myGraphic := fmImages.imgWaterWave3.Picture.Graphic;
      end;
    end;
  else
    myGraphic := fmImages.imgHuh.Picture.Graphic;
  end;

  if myGrid.IsGlacier then
    myGraphic := fmImages.imgGlacier.Picture.Graphic;

  imageMap.Canvas.CopyMode := cmSrcCopy;
  imageMap.Canvas.Draw(
    16 * X + 1,
    16 * Y + 1,
    myGraphic);

  if (myGrid.Temperature = 0) and (myGrid.Humidity > 90) then
  begin
    myGraphic := fmImages.imgRainbow.Picture.Graphic;
    imageMap.Canvas.Draw(
      16 * X + 1,
      16 * Y + 1,
      myGraphic);
  end;
end;

procedure TfmEnvironment.RefreshMouseGrid(aColor: TColor);
var
  myRect: TRect;
  myXPos: integer;
  myYPos: integer;
begin
  myXPos := MouseGridX * 16 + 1;
  myYPos := MouseGridY * 16 + 1;

  imageMap.Canvas.Brush.Color := aColor;
  myRect.Left := myXPos - 1;
  myRect.Right := myXPos + 16;
  myRect.Top := myYPos - 1;
  myRect.Bottom := myYPos + 16;
  imageMap.Canvas.FrameRect(myRect);
end;

procedure TfmEnvironment.tbWateringCanClick(Sender: TObject);
begin
  Tool := tWateringCan;
end;

procedure TfmEnvironment.tbSpiritGuyClick(Sender: TObject);
begin
  Tool := tSpiritGuy;
end;

procedure TfmEnvironment.tbSpiritGirlClick(Sender: TObject);
begin
  Tool := tSpiritGirl;
end;

procedure TfmEnvironment.tbAppleTreeClick(Sender: TObject);
begin
  Tool := tAppleTree;
end;

procedure TfmEnvironment.tbOrangeTreeClick(Sender: TObject);
begin
  Tool := tOrangeTree;
end;

procedure TfmEnvironment.tbAppleClick(Sender: TObject);
begin
  Tool := tApple;
end;

procedure TfmEnvironment.tbOrangeClick(Sender: TObject);
begin
  Tool := tOrange;
end;

procedure TfmEnvironment.tbSlimeClick(Sender: TObject);
begin
  Tool := tSlime;
end;

procedure TfmEnvironment.tbBrickClick(Sender: TObject);
begin
  Tool := tBrick;
end;

procedure TfmEnvironment.tbBirdClick(Sender: TObject);
begin
  Tool := tBird;
end;

procedure TfmEnvironment.tbCrawlyClick(Sender: TObject);
begin
  Tool := tCrawly;
end;

procedure TfmEnvironment.SetMouseGridX(X: integer);
begin
  fMouseGridX := X;

  if fMouseGridX > Environment.Space.Width - 1 then
    fMouseGridX := Environment.Space.Width - 1;
  if fMouseGridX < 0 then
    fMouseGridX := 0;
end;

procedure TfmEnvironment.SetMouseGridY(Y: integer);
begin
  fMouseGridY := Y;

  if fMouseGridY > Environment.Space.Height - 1 then
    fMouseGridY := Environment.Space.Height - 1;
  if fMouseGridY < 0 then
    fMouseGridY := 0;
end;

// refresh the statusbar with info on the grid the mouse is pointing at
procedure TfmEnvironment.RefreshGridInfo;
var
  myGrid: AIGrid;
begin
  StatusBar.Panels[0].Text :=
    'X: ' + IntToStr(MouseGridX) + ', ' +
    'Y: ' + IntToStr(MouseGridY);

  myGrid := Environment.Space.Map[MouseGridX][MouseGridY];

  StatusBar.Panels[1].Text := myGrid.OneLineDisplay;
end;

// apply aTool at location X,Y on the map
procedure TfmEnvironment.ApplyTool(aTool: eTool; X: integer; Y: integer);
var
  myThing: AIThing;
  myLocation: AIGrid;
begin
  myLocation := Environment.Space.Map[X][Y];

  if aTool = tWateringCan then
  begin
    if not OppositeTool then
    begin
      if WaterLevel = wlOverFlow then
        Environment.Space.QueueChange(nil, cEventAddWater, StrToInt(edWater.Text), myLocation)
      else
        myLocation.Water := WaterLevel;

      if myLocation.FullOfWater then
        RefreshMap;
    end
    else
      Environment.Space.QueueChange(nil, cEventAddWater, StrToInt(edWater.Text) * -1, myLocation);
  end;

  if aTool = tHumidifier then
  begin
    if not OppositeTool then
      Environment.Space.QueueChange(nil, cEventAddHumidity, 10, myLocation)
    else
      Environment.Space.QueueChange(nil, cEventAddHumidity, -10, myLocation);

    RefreshMap;
  end;

  if aTool = tHeater then
  begin
    if not OppositeTool then
      Environment.Space.QueueChange(nil, cEventAddTemperature, 10, myLocation)
    else
      Environment.Space.QueueChange(nil, cEventAddTemperature, -10, myLocation);

    RefreshMap;
  end;

  if aTool = tApple then
  begin
    myThing := Environment.Things.NewThing(myLocation, cApple);
    RefreshMap;
    ReportUserEvent('Added apple: ' + myThing.OneLineDisplay);
  end;

  if aTool = tAppleTree then
  begin
    myThing := Environment.Things.NewThing(myLocation, cAppleSeed);
    RefreshMap;
    fmFirstForm.RealityForm.ManagerForm.ListsForm.RefreshThings;
    ReportUserEvent('Added apple seed: ' + myThing.OneLineDisplay);
  end;

  if aTool = tOrange then
  begin
    myThing := Environment.Things.NewThing(myLocation, cOrange);
    RefreshMap;
    ReportUserEvent('Added orange: ' + myThing.OneLineDisplay);
  end;

  if aTool = tOrangeTree then
  begin
    myThing := Environment.Things.NewThing(myLocation, cOrangeSeed);
    RefreshMap;
    ReportUserEvent('Added orange seed: ' + myThing.OneLineDisplay);
  end;

  if aTool = tSlime then
  begin
    myThing := Environment.Things.NewThing(myLocation, cSlime);
    RefreshMap;
    ReportUserEvent('Added slime: ' + myThing.OneLineDisplay);
  end;

  if aTool = tBrick then
  begin
    myThing := Environment.Things.NewThing(myLocation, cBrick);
    RefreshMap;
    ReportUserEvent('Added brick: ' + myThing.OneLineDisplay);
  end;

  if aTool = tSpiritGuy then
  begin
    AddSpirit(cGenderMale);
    ReportUserEvent('Added male spirit.');
  end;

  if aTool = tSpiritGirl then
  begin
    AddSpirit(cGenderFemale);
    ReportUserEvent('Added girl spirit.');
  end;

  if aTool = tSun then
  begin
    myThing := Environment.Things.NewThing(myLocation, cSun);
    ReportUserEvent('Added sun: ' + myThing.OneLineDisplay);
    fmFirstForm.RealityForm.ManagerForm.ListsForm.EditSatellite(AISatellite(myThing));
  end;

  if aTool = tMoon then
  begin
    myThing := Environment.Things.NewThing(myLocation, cMoon);
    ReportUserEvent('Added moon: ' + myThing.OneLineDisplay);
    fmFirstForm.RealityForm.ManagerForm.ListsForm.EditSatellite(AISatellite(myThing));
  end;
end;

procedure TfmEnvironment.imageMapMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  newX: integer; // latest position of mouse x
  newY: integer; // latest position of mouse y
begin
  newX := (1 + X - X mod 16) div 16;
  newY := (1 + Y - Y mod 16) div 16;

  // check to see if new position is different from old position
  // if not, then we dont need to do anything
  if not (newX = MouseGridX) or not (newY = MouseGridY) then
  begin
    RefreshMouseGrid(clGray);

    MouseGridX := newX;
    MouseGridY := newY;

    if ToolIsActive then
    begin
      ApplyTool(Tool, MouseGridX, MouseGridY);
      RefreshSquare(MouseGridX, MouseGridY);
      RefreshGridInfo;
    end;

    if not fmFirstForm.RealityForm.Reality.IsRunning then
      RefreshMap
    else
      RefreshMouseGrid(clBlack);
  end;

  RefreshGridInfo;
end;

procedure TfmEnvironment.imageMapMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if ssLeft in Shift then
    OppositeTool := false
  else
  if ssRight in Shift then
    OppositeTool := true;
  StartUsingTool;
end;

procedure TfmEnvironment.AddSpirit(aGender: integer);
var
  mySpirit: AISpirit;
begin
  mySpirit := Environment.Culture.NewSpirit(Environment.Space.Map[MouseGridX][MouseGridY], aGender);
  fmFirstForm.RealityForm.ManagerForm.SpiritWindows.AddSpirit(
    mySpirit,
    fmFirstForm.RealityForm.ManagerForm.AutoPop);
  RefreshMap;
  ReportUserEvent('Added spirit ' + mySpirit.Name + '.');
end;

procedure TfmEnvironment.FormShow(Sender: TObject);
begin
  ClearMap;
  RefreshMap;
  ToolTimer.Interval := fmFirstForm.RealityForm.trackSpeed.Position;
end;

procedure TfmEnvironment.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := false;
  fmFirstForm.RealityForm.ManagerForm.DropEnvironment;
end;

procedure TfmEnvironment.tbRefreshClick(Sender: TObject);
begin
  RefreshMap;
end;

procedure TfmEnvironment.imageMapMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  StopUsingTool;
end;

procedure TfmEnvironment.StartUsingTool;
begin
  ToolIsActive := true;

  ApplyTool(Tool, MouseGridX, MouseGridY);
  RefreshSquare(MouseGridX, MouseGridY);
  RefreshGridInfo;
end;

procedure TfmEnvironment.StopUsingTool;
begin
  ToolIsActive := false;
end;

procedure TfmEnvironment.ToolTimerTimer(Sender: TObject);
begin
  if ToolIsActive then
  begin
    ApplyTool(Tool, MouseGridX, MouseGridY);
    RefreshSquare(MouseGridX, MouseGridY);
    RefreshGridInfo;
  end;
end;

procedure TfmEnvironment.tbAddRemoveWaterClick(Sender: TObject);
begin
  WaterLevel := wlOverFlow;
end;

procedure TfmEnvironment.tbLandDesertClick(Sender: TObject);
begin
  WaterLevel := wlDesert;
end;

procedure TfmEnvironment.tbLandDirtClick(Sender: TObject);
begin
  WaterLevel := wlDirt;
end;

procedure TfmEnvironment.tbLandFieldClick(Sender: TObject);
begin
  WaterLevel := wlField;
end;

procedure TfmEnvironment.tbLandGrassClick(Sender: TObject);
begin
  WaterLevel := wlGrass;
end;

procedure TfmEnvironment.tbWaterPuddleClick(Sender: TObject);
begin
  WaterLevel := wlPuddle;
end;

procedure TfmEnvironment.tbWaterPuddle2Click(Sender: TObject);
begin
  WaterLevel := wlPuddle2;
end;

procedure TfmEnvironment.tbWaterLakeClick(Sender: TObject);
begin
  WaterLevel := wlLake;
end;

procedure TfmEnvironment.tbWaterSeaClick(Sender: TObject);
begin
  WaterLevel := wlSea;
end;

procedure TfmEnvironment.WaterUpDownClick(Sender: TObject;
  Button: TUDBtnType);
begin
  edWater.Text := IntToStr(WaterUpDown.Position);
end;

procedure TfmEnvironment.SetTool(aTool: eTool);
begin
  fTool := aTool;

  tbWater.Visible := (Tool = tWateringCan);
  ToolTimer.Enabled := tbWater.Visible;
end;

procedure TfmEnvironment.tbHumidityClick(Sender: TObject);
begin
  Tool := tHumidifier;
end;

procedure TfmEnvironment.tbCloudClick(Sender: TObject);
begin
  Tool := tCloud;
end;

procedure TfmEnvironment.tbTemperatureClick(Sender: TObject);
begin
  Tool := tHeater;
end;

procedure TfmEnvironment.tbSunClick(Sender: TObject);
begin
  Tool := tSun;
end;

procedure TfmEnvironment.tbMoonClick(Sender: TObject);
begin
  Tool := tMoon;
end;

end.
