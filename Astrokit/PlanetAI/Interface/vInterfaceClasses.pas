unit vInterfaceClasses;

interface

uses
  System.Classes,
  System.Contnrs,
  Vcl.Forms,
  Vcl.ComCtrls,
  cAIBaseObject,
  GLS.VectorGeometry;

const
  cStateChangeTime = 32;

type

  eTool = (tSelect, tWateringCan, tSponge, tWaterLeveller, tSplash, tSpiritGuy, tSpiritGirl,
    tAppleTree, tOrangeTree, tApple, tOrange, tAppleSeed, tOrangeSeed, tForest, tAquaPlant, tBird,
    tFish, tTrex, tGrazer, tCrab, tHawk, tShark, tTurtle, tTerrier, tTiger, tCloud, tHeater,
    tCooler, tStormCloud, tRainCloud, tLightning, tRaiseLand, tLowerLand, tFlattenLand, tMountain,
    tValley, tHumidifier, tDehumidifier, tSun, tMoon, tAsteroid, tMissileDefence, tRabbit, tGrass,
    tFox, tMouse, tDuck, tDolphin, tBeaconBubble, tBeaconDrain, tBeaconOrange, tBeaconApple,
    tIceBerg, tMove, tFireTree, tPlantClearer, tLifeKiller, tThingCeaser, tLadybug, tAnt,
    tBeaconAny, tEvolvingTree, tEvolvingFruit, tEvolvingSeed, tBall, tCube, tWeapon);

  eCamera = (camPlanet, camAvatar, camSatellite, camTarget, camFree, camEyes);

  // *****************************************************************************
  TDynamicToolButton = Class(TToolButton)
  public
    procedure SetLinkToolBar(AToolBar: TToolBar);
  end;

  // [face][vertex-index]
  TVertexIndexList = array of array of integer;
  TGLVectorList = array of TAffineVector;

  // *****************************************************************************
  // stores links between data objects and interface objects
  TCrossover = Class(TObject)
  private
    fVisuals: TObjectList; // list of interface components (links)
    fSubVisuals: TObjectList; // list of interface components (owned)
    fData: pointer; // data component
    fHeight: integer;
  public
    Constructor Create;
    Destructor Destroy; override;

    property Visuals: TObjectList read fVisuals;
    property SubVisuals: TObjectList read fSubVisuals;
    property Data: pointer read fData write fData;
    property Height: integer read fHeight write fHeight;
  end;

  // *****************************************************************************
  // stores links between grid objects and 3d visual maps
  TGridCrossover = Class(TCrossover)
  private
    fNormals: TGLVectorList; // list of normals (owned)
    fLastState: integer; // last state of data
    fLastValue: single;
    fVertices: TVertexIndexList;
    fChangeTime: integer; // time of last change
  public
    constructor Create(aNormals: integer);
    destructor Destroy; override;

    property Normals: TGLVectorList read fNormals;
    property LastState: integer read fLastState write fLastState;
    property LastValue: single read fLastValue write fLastValue;
    property Vertices: TVertexIndexList read fVertices;
    property ChangeTime: integer read fChangeTime write fChangeTime;
  end;

  // *****************************************************************************
  TCrossoverList = Class(TActiveList)
  public
    constructor Create;

    function NewCrossover: TCrossover;
    function FindCrossoverByVisual(aVisual: pointer): TCrossover;
    function FindCrossoverByData(aData: pointer): TCrossover;
    function AmountOfData(aClass: TClass): integer;
    function FindCrossoverByVisualOrSubVisual(aVisual: pointer): TCrossover;

    function SetCrossoverByKind(aKind: integer): boolean;
    function SetCrossoverByData(aData: pointer): boolean;
    function SetReverseCrossoverByKind(aKind: integer): boolean;
  end;

  // *****************************************************************************
  TGridCrossoverList = Class(TCrossoverList)
  public
    function NewGridCrossover(aNormals: integer): TGridCrossover;
    function FindCrossoverByVertexIndex(aIndex: integer): TGridCrossover;
  end;

function OppositeTool(aTool: eTool): eTool;
function ThingImageIndex(aKind: integer): integer;
function CameraModeString(const aMode: eCamera): string;

// ------------------------------------------------
implementation
// ------------------------------------------------

uses
  cAIThings;

// =============================================================================
// TDynamicToolButton
// ----------------------------------------------------------------------------
procedure TDynamicToolButton.SetLinkToolBar(AToolBar: TToolBar);
begin
  SetToolBar(AToolBar);
  ValidateContainer(AToolBar);
end;

// ----------------------------------------------------------------------------
Constructor TCrossover.Create;
begin
  inherited Create;

  fVisuals := TObjectList.Create(false);
  fSubVisuals := TObjectList.Create(true);
  fHeight := 0;
end;

// ----------------------------------------------------------------------------
Destructor TCrossover.Destroy;
begin
  fVisuals.Free;
  fSubVisuals.Free;

  inherited Destroy;
end;

// ----------------------------------------------------------------------------
Constructor TGridCrossover.Create(aNormals: integer);
begin
  inherited Create;

  SetLength(fNormals, aNormals);
  SetLength(fVertices, aNormals, 3);
  fChangeTime := cStateChangeTime - 1;
end;

// ----------------------------------------------------------------------------
Destructor TGridCrossover.Destroy;
begin

  inherited Destroy;
end;

// ----------------------------------------------------------------------------
Constructor TCrossoverList.Create;
begin
  inherited Create(true);
end;

// ----------------------------------------------------------------------------
function TCrossoverList.NewCrossover: TCrossover;
begin
  result := TCrossover.Create;
  Add(result);
end;

// ----------------------------------------------------------------------------
function TGridCrossoverList.NewGridCrossover(aNormals: integer): TGridCrossover;
begin
  result := TGridCrossover.Create(aNormals);
  Add(result);
end;

// ----------------------------------------------------------------------------
function TCrossoverList.FindCrossoverByVisual(aVisual: pointer): TCrossover;
var
  myCrossover: TCrossover;
  i: integer;
begin
  result := nil;

  for i := 0 to Count - 1 do
  begin
    myCrossover := TCrossover(Items[i]);
    if myCrossover.Visuals.IndexOf(aVisual) > -1 then
      result := myCrossover;
  end;
end;

// ----------------------------------------------------------------------------
function TCrossoverList.FindCrossoverByVisualOrSubVisual(aVisual: pointer): TCrossover;
var
  myCrossover: TCrossover;
  i: integer;
begin
  result := nil;

  for i := 0 to Count - 1 do
  begin
    myCrossover := TCrossover(Items[i]);
    if myCrossover.Visuals.IndexOf(aVisual) > -1 then
      result := myCrossover;
    if myCrossover.SubVisuals.IndexOf(aVisual) > -1 then
      result := myCrossover;
  end;
end;

// ----------------------------------------------------------------------------
function TCrossoverList.FindCrossoverByData(aData: pointer): TCrossover;
var
  myCrossover: TCrossover;
  i: integer;
begin
  result := nil;

  for i := 0 to Count - 1 do
  begin
    myCrossover := TCrossover(Items[i]);
    if myCrossover.Data = aData then
      result := myCrossover;
  end;
end;

// ----------------------------------------------------------------------------
function TGridCrossoverList.FindCrossoverByVertexIndex(aIndex: integer): TGridCrossover;
var
  myGridCrossover: TGridCrossover;
  i, j, k: integer;
begin
  result := nil;

  for i := 0 to Count - 1 do
  begin
    myGridCrossover := TGridCrossover(Items[i]);

    for j := 0 to 8 do
      for k := 0 to 2 do
        if myGridCrossover.Vertices[j][k] = aIndex then
          result := myGridCrossover;
  end;
end;

// ----------------------------------------------------------------------------
function TCrossoverList.AmountOfData(aClass: TClass): integer;
var
  myCrossover: TCrossover;
  i: integer;
begin
  result := 0;

  for i := 0 to Count - 1 do
  begin
    myCrossover := TCrossover(Items[i]);
    if TObject(myCrossover.Data) is aClass then
      result := result + 1;
  end;
end;

// ----------------------------------------------------------------------------
function TCrossoverList.SetCrossoverByKind(aKind: integer): boolean;
var
  myCrossover: TCrossover;
begin
  result := false;

  if not SetNextOrFirstActive then
    exit;

  myCrossover := TCrossover(ActiveItem);
  repeat
  begin
    if AIThing(TCrossover(ActiveItem).Data).Kind = aKind then
      result := true
    else
      SetNextOrFirstActive;
  end
  until result or (myCrossover = ActiveItem);
end;

// ----------------------------------------------------------------------------
function TCrossoverList.SetReverseCrossoverByKind(aKind: integer): boolean;
var
  myCrossover: TCrossover;
begin
  result := false;

  if not SetPriorOrLastActive then
    exit;

  myCrossover := TCrossover(ActiveItem);
  repeat
  begin
    if AIThing(TCrossover(ActiveItem).Data).Kind = aKind then
      result := true
    else
      SetPriorOrLastActive;
  end
  until result or (myCrossover = ActiveItem);
end;

// ----------------------------------------------------------------------------
function TCrossoverList.SetCrossoverByData(aData: pointer): boolean;
var
  myCrossover: TCrossover;
  i: integer;
begin
  result := false;

  for i := 0 to Count - 1 do
  begin
    myCrossover := TCrossover(Items[i]);
    if myCrossover.Data = aData then
    begin
      result := true;
      ActiveItem := myCrossover;
    end;
  end;
end;

function OppositeTool(aTool: eTool): eTool;
begin
  case aTool of
    tWateringCan:
      result := tSponge;
    tSponge:
      result := tWateringCan;
    tHeater:
      result := tCooler;
    tCooler:
      result := tHeater;
    tHumidifier:
      result := tDehumidifier;
    tDehumidifier:
      result := tHumidifier;
    tRaiseLand:
      result := tLowerLand;
    tLowerLand:
      result := tRaiseLand;
    tFlattenLand:
      result := tFlattenLand;
    tMountain:
      result := tValley;
    tValley:
      result := tMountain;
  else
    result := aTool;
  end;
end;

// returns the image index of a kind for imgIcons
function ThingImageIndex(aKind: integer): integer;
begin
  result := 0;
  case aKind of
    cApple:
      result := 9;
    cOrange:
      result := 11;
    cAppleTree:
      result := 47;
    cOrangeTree:
      result := 49;
    cAppleSeed:
      result := 54;
    cOrangeSeed:
      result := 54;
    cSun:
      result := 61;
    cMoon:
      result := 62;
    cCloud:
      result := 57;
    cFish:
      result := 94;
    cBird:
      result := 53;
    cBot:
      result := 45;
    cBall:
      result := 95;
    cCrab:
      result := 96;
    cHawk:
      result := 98;
    cTrex:
      result := 100;
    cGrazer:
      result := 101;
    cAsteroid:
      result := 93;
    cExplosion:
      result := 57;
    cFlock:
      result := 53;
    cLightning:
      result := 57;
    cShark:
      result := 107;
    cTurtle:
      result := 108;
    cBeacon:
      result := 24;
    cTerrier:
      result := 110;
    cVibe:
      result := 77;
    cBomb:
      result := 99;
    cWeapon:
      result := 99;
    cFox:
      result := 113;
    cRabbit:
      result := 111;
    cGrass:
      result := 112;
    cIceberg:
      result := 74;
    cMouse:
      result := 114;
    cTiger:
      result := 115;
    cDuck:
      result := 116;
    cCommunity:
      result := 109;
    cDolphin:
      result := 119;
    cAquaPlant:
      result := 120;
    cLadybug:
      result := 136;
    cAnt:
      result := 137;
    cFireTree:
      result := 48;
    cSpeech:
      result := 56;
    cEvolvingTree:
      result := 148;
    cEvolvingFruit:
      result := 149;
    cEvolvingSeed:
      result := 54;
    cMissileDefence:
      result := 80;
    cMissile:
      result := 10;
  end;
end;

function CameraModeString(const aMode: eCamera): string;
begin
  case aMode of
    camPlanet:
      result := 'camPlanet';
    camTarget:
      result := 'camTarget';
    camFree:
      result := 'camFree';
    camAvatar:
      result := 'camAvatar';
    camSatellite:
      result := 'camSatellite';
    camEyes:
      result := 'camEyes';
  end;
end;

end.
