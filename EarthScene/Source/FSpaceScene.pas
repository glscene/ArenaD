unit FSpaceScene;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  Winapi.OpenGL,
  Winapi.ShellAPI,
  System.SysUtils,
  System.Classes,
  System.Math,
  Vcl.FileCtrl,
  Vcl.Imaging.Jpeg,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Vcl.ComCtrls,
  Vcl.Dialogs,
  Vcl.Menus,

  GLS.Scene,
  GLS.Objects,
  GLS.VectorLists,
  GLS.SceneViewer,
  GLS.Utils,
  GLS.SkyDome,
  GLS.Texture,
  GLS.VectorFileObjects,
  GLS.Mesh,
  GLS.RenderContextInfo,
  GLS.Color,
  GLS.VectorTypes,
  GLS.Cadencer,
  GLS.LensFlare,
  GLSL.TextureShaders,
  GLS.VectorGeometry,
  GLSL.MultiMaterialShader,
  GLS.Material,
  GLS.Coordinates,
  
  GLS.BaseClasses,
  GLS.TextureFormat,
  GLS.Context;

type
  TMarkerPosition = class(TObject)
  private
    fLatitude: single;
    fLongitude: single;
    fmembertype, fGlow: byte; // 0..255
    fTypeName, fName, fNickName, fCity, fState, fCountry: String;
    fDateAdded, fDateDOB: TDate;
    fPhoto, fEMail, fUrl, fDemoName, fDescription: String;
  public
    function GetCartesian(dRadius: single): TVector;
    property Name: String read fName write fName;
    property NickName: String read fNickName write fNickName;
    property TypeName: String read fTypeName write fTypeName;
    property City: String read fCity write fCity;
    property State: String read fState write fState;
    property Country: String read fCountry write fCountry;
    property Photo: String read fPhoto write fPhoto;
    property EMail: String read fEMail write fEMail;
    property Url: String read fUrl write fUrl;
    property DemoName: String read fDemoName write fDemoName;
    property Description: String read fDescription write fDescription;
    property DateDOB: TDate read fDateDOB write fDateDOB;
    property DateAdded: TDate read fDateAdded write fDateAdded;
    property Glow: byte read fGlow write fGlow;
    property membertype: byte read fmembertype write fmembertype;
    property Latitude: single read fLatitude write fLatitude;
    property Longitude: single read fLongitude write fLongitude;
  end;

type
  TSpaceSceneFrm = class(TForm)
    GLScene: TGLScene;
    GLSceneViewer: TGLSceneViewer;
    GLCamera: TGLCamera;
    SPEarth: TGLSphere;
    LSSun: TGLLightSource;
    GLDirectOpenGL1: TGLDirectOpenGL;
    GLCadencer: TGLCadencer;
    Timer: TTimer;
    SPMoon: TGLSphere;
    DCEarthSystem: TGLDummyCube;
    DCMoon: TGLDummyCube;
    GLLensFlare1: TGLLensFlare;
    GLMaterialLibrary: TGLMaterialLibrary;
    EarthCombiner: TGLTexCombineShader;
    GLCameraControler: TGLCamera;
    GLSkydome: TGLSkyDome;
    ConstellationLines: TGLLines;
    MainMenu: TMainMenu;
    miFile: TMenuItem;
    miSpinThePlanet: TMenuItem;
    miCountries: TMenuItem;
    miFlipFlopLand: TMenuItem;
    miN1: TMenuItem;
    miExit: TMenuItem;
    miMarkers: TMenuItem;
    miRound: TMenuItem;
    miSmooth: TMenuItem;
    miSmoothAdditive: TMenuItem;
    miSquare: TMenuItem;
    miN2: TMenuItem;
    miAddaPeople: TMenuItem;
    miTools: TMenuItem;
    miViewer: TMenuItem;
    miMetadata: TMenuItem;
    miHelp: TMenuItem;
    miAbout: TMenuItem;
    MemberGB: TGroupBox;
    Label2: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    lblNickname: TLabel;
    LblCountry: TLabel;
    LblCity: TLabel;
    Memo1: TMemo;
    ChoiceRG: TRadioGroup;
    DateTimePicker1: TDateTimePicker;
    NameCB: TComboBox;
    cbTypes: TComboBox;
    LblWebUrl: TLabel;
    lblEMail: TLabel;
    Label1: TLabel;
    Label3: TLabel;
    lblType: TLabel;
    Label10: TLabel;
    lblDobDate: TLabel;
    Label12: TLabel;
    lblGLSDate: TLabel;
    miDisplayToolBar: TMenuItem;
    miN3: TMenuItem;
    ptsLocations: TGLPoints;
    Label11: TLabel;
    lblState: TLabel;
    Label13: TLabel;
    lblDemoName: TLabel;
    Label14: TLabel;
    lblTypeName: TLabel;
    lblGLSGlow: TLabel;
    Label16: TLabel;
    miGLSTemporalFlow: TMenuItem;
    FlowTimer: TTimer;
    PeopleColorPanel: TPanel;
    ColorDialog: TColorDialog;
    miColorAlltheSame: TMenuItem;
    Splitter1: TSplitter;
    ptsFlashLocations: TGLPoints;
    ShpLines: TGLLines;
    CountryColorPanel: TPanel;
    GlsGlowLF: TGLLensFlare;
    miSatelliteLight: TMenuItem;
    miABCreator: TMenuItem;
    miSmdQc: TMenuItem;
    miMdlQc: TMenuItem;
    miConstellationLines: TMenuItem;
    miStars: TMenuItem;
    miSunFlare: TMenuItem;
    miHighResolution: TMenuItem;
    miClouds: TMenuItem;
    miAtmosphere: TMenuItem;
    miAsteroidField: TMenuItem;
    N3: TMenuItem;
    miShowCities: TMenuItem;
    miSpinSolarSystem: TMenuItem;
    ShpPoints: TGLPoints;
    CityPanel: TPanel;
    CapitolPanel: TPanel;
    miShowCapitals: TMenuItem;
    N5: TMenuItem;
    ShpCapPoints: TGLPoints;
    miSelectedSatellite: TMenuItem;
    GlowUpDown: TUpDown;
    GlowEdit: TEdit;
    lblPhotoName: TLabel;
    Label17: TLabel;
    N1: TMenuItem;
    DateForwardCB: TCheckBox;
    PhotoImage: TImage;
    PhotoCB: TCheckBox;
    DCEarthClouds: TGLDummyCube;
    SPEarthClouds: TGLSphere;
    NightSkyorBumpyLand1: TMenuItem;
    GLMultiMaterialShader: TGLMultiMaterialShader;
    MMShaderMatLibrary: TGLMaterialLibrary;
    DCAsteroids: TGLDummyCube;
    ptsSizeUpDown: TUpDown;
    ptsSizeEdit: TEdit;
    N2: TMenuItem;
    miFPS: TMenuItem;
    miDisplay: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure GLDirectOpenGL1Render(Sender: TObject;
      var rci: TGLRenderContextInfo);
    procedure TimerTimer(Sender: TObject);
    procedure GLCadencerProgress(Sender: TObject;
      const deltaTime, newTime: Double);
    procedure GLSceneViewerMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure GLSceneViewerMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure GLSceneViewerDblClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure GLSceneViewerBeforeRender(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure miAboutClick(Sender: TObject);
    procedure GLSceneViewerMouseEnter(Sender: TObject);
    procedure miRoundClick(Sender: TObject);
    procedure miSmoothClick(Sender: TObject);
    procedure miSmoothAdditiveClick(Sender: TObject);
    procedure miSquareClick(Sender: TObject);
    procedure miAddaPeopleClick(Sender: TObject);
    procedure ChoiceRGClick(Sender: TObject);
    procedure cbTypesChange(Sender: TObject);
    procedure DateTimePicker1Change(Sender: TObject);
    procedure NameCBChange(Sender: TObject);
    procedure miContentsClick(Sender: TObject);
    procedure miOnHelpClick(Sender: TObject);
    procedure miExitClick(Sender: TObject);
    procedure miSpinThePlanetClick(Sender: TObject);
    procedure miCountriesClick(Sender: TObject);
    procedure DisplayCountries(Show: Boolean);
    Function LoadCountryShapes: Boolean;
    { Function LoadShapes:Boolean;
      Function NewLayer:Boolean;
      procedure DVDORedraw; }

    procedure miShowCapitalsClick(Sender: TObject);
    procedure DisplayCapitals(Show: Boolean);
    Function LoadCapitalShapes: Boolean;
    procedure miShowCitiesClick(Sender: TObject);
    procedure DisplayCities(Show: Boolean);
    Function LoadCityShapes: Boolean;

    procedure miFlipFlopLandClick(Sender: TObject);
    procedure miDisplayToolBarClick(Sender: TObject);
    procedure miGLSTemporalFlowClick(Sender: TObject);
    procedure FlowTimerTimer(Sender: TObject);
    procedure lblEMailClick(Sender: TObject);
    procedure LblWebUrlClick(Sender: TObject);
    procedure lblDemoNameClick(Sender: TObject);
    procedure PeopleColorPanelClick(Sender: TObject);
    procedure miColorAlltheSameClick(Sender: TObject);
    procedure GLSceneViewerMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure CountryColorPanelClick(Sender: TObject);
    procedure miSatelliteLightClick(Sender: TObject);
    procedure miViewerClick(Sender: TObject);
    procedure miMetadataClick(Sender: TObject);
    procedure miABCreatorClick(Sender: TObject);
    procedure miSmdQcClick(Sender: TObject);
    procedure miMdlQcClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure miSpinSolarSystemClick(Sender: TObject);
    procedure miStarsClick(Sender: TObject);
    procedure miSunFlareClick(Sender: TObject);
    procedure miAsteroidFieldClick(Sender: TObject);
    procedure miConstellationLinesClick(Sender: TObject);
    procedure miAtmosphereClick(Sender: TObject);
    procedure miCloudsClick(Sender: TObject);
    procedure miHighResolutionClick(Sender: TObject);

    procedure CityPanelClick(Sender: TObject);
    procedure CapitolPanelClick(Sender: TObject);

    procedure miSelectedSatelliteClick(Sender: TObject);
    procedure GlowUpDownClick(Sender: TObject; Button: TUDBtnType);
    procedure lblPhotoNameClick(Sender: TObject);
    procedure NightSkyorBumpyLand1Click(Sender: TObject);
    procedure ptsSizeUpDownClick(Sender: TObject; Button: TUDBtnType);

  private
     
    MenuVisible, ColorAlltheSame, CapitalsLoaded, EarthLoaded, CitiesLoaded,
      CountriesLoaded: Boolean;
    markersCounted, MarkersDisplaySelection: Integer;
    TemporalFlowDateTime: TDateTime;
    procedure LoadConstellationLines;
    procedure ClearLocations;
    procedure DrawPoints;
  public
     
    constellationsAlpha: single;
    timeMultiplier: single;
    mx, my, dmx, dmy: Integer;
    highResResourcesLoaded: Boolean;
    cameraTimeSteps: single;
    MasterAsteroidF: TGLFreeForm;
  end;

var
  SpaceSceneFrm: TSpaceSceneFrm;
  DotColorArray: array of TColorVector;
  markers: TStringList; { from Private }
  markerIndex, ColorIndex: Integer;

//----------------------------------------------------------------------
//
implementation
//
//----------------------------------------------------------------------


{$R *.dfm}

uses
  // accurate movements left for later... or the astute reader
  uSolarSystem, {1000}
  uGlobals,
  FABCreator, {2000 Asteroid.. Galaxy System Creator}
  // AllShapeLoaderFrm,  {Earth Cities, Countries}
  EarthAboutFrm,
  {Gizmo in 'Gizmo.pas'..not yet}
  FEarthLocations, {1300 Data input for Earth}
  FMeshShow, {3000}
  FGLSViewer, {4000 GLS Viewer demo}
  FSkyPilot,  {5000}
  FGlsSmdQc, {8000 Marcus...}
  FGlsLoadSmdMdl, {8500}
  uSahObjects {Asteroid};

// ----- TMarkerPosition.GetCartesian ------------------------------------------
{ Convert from Longitude-Latitude system to cartesian coordinates.
  Correct for offset.
  Longitude are positive eastward and latitude northward }

function TMarkerPosition.GetCartesian(dRadius: single): TVector;
var
  ca, sa, co, so: single;
begin
  SinCosine(DegToRadian(-Longitude - 90), so, co); // 90° offset
  SinCosine(DegToRadian(Latitude), sa, ca);

  Result.X := dRadius * co * ca;
  Result.Y := dRadius * sa;
  Result.Z := dRadius * so * ca;
end;

procedure TSpaceSceneFrm.FormCreate(Sender: TObject);
var
  Temp: TMeshObject;
  { Seed	:integer; }
  Lat, Lon: single;
  F: TextFile;
  mp: TMarkerPosition;
  { iIndex : integer; }    { made global }
  mType, gType: byte;
  sDate, sDateSmuoosh, sDateFormat, sWhoWhereFormat: String;

begin
  AppPath := ExtractFilePath(ParamStr(0));
  {
  if FileExists(ExtractFilePath(ParamStr(0)) + 'EarthGLS.pof') then
  begin
    DoLoader;
  end
  else
  begin
  }
    EarthFormX := 0;
    EarthFormY := 0;
    GlsSmdQcFormX := 123;
    GlsSmdQcFormY := 123;
    GlsSmdLoadMdlFormX := 123;
    GlsSmdLoadMdlFormY := 123;
    GLSViewerFormX := 123;
    GLSViewerFormY := 123;
    HoloFormY := 123;
    HoloFormX := 123;
    AboutFormX := 123;
    AboutFormY := 123;
    AboutHolographicsX := 123;
    AboutHolographicsY := 123;
    MessageX := 123;
    MessageY := 123;
    ABCreatorFormX := 123;
    ABCreatorFormY := 123;
    Colorreg := 123;
    GlowUpDowni := 20;
    ShpPath := ExtractFilePath(ParamStr(0)) + 'EarthShp\';
    EarthDataPath := ExtractFilePath(ParamStr(0)) + 'EarthData\';
    EarthModelPath := ExtractFilePath(ParamStr(0)) + 'EarthModel\';
    EarthPhotoPath := ExtractFilePath(ParamStr(0)) + 'EarthPhoto\';
    EarthHRPath := ExtractFilePath(ParamStr(0)) + 'EarthHR\';
    /// StartedNameNumber:='Alle Alle in Free';
    DoSaver;
  //end;
  top := EarthFormY;
  left := EarthFormX;
  If FileExists(ExtractFilePath(ParamStr(0)) + 'EarthGLS.chm') then
    Application.HelpFile := ExtractFilePath(ParamStr(0)) + 'EarthGLS.hlp';

  MenuVisible := True;
   GLSkydome.Bands.Clear;
  if FileExists(EarthDataPath + 'Yale_BSC.stars') then
    GLSkydome.Stars.LoadStarsFile(EarthDataPath + 'Yale_BSC.stars');
  if FileExists(EarthDataPath + 'Constellations.dat') then
    LoadConstellationLines;
  timeMultiplier := 1;
  { V5 additions }
  if FileExists(EarthModelPath + 'earth_cloud_360.jpg') then
  begin
    GLMaterialLibrary.Materials[3].Material.Texture.Compression := tcStandard;
    GLMaterialLibrary.Materials[3].Material.Texture.Image.LoadFromFile
      (EarthModelPath + 'earth_cloud_360.jpg');
  end
  else
  begin
    miClouds.Enabled := False;
    SPEarthClouds.Visible := False;
  end;

  If FileExists(EarthModelPath + 'earth_bump.bmp') then
    GLMaterialLibrary.Materials[4].Material.Texture.Image.LoadFromFile
      (EarthModelPath + 'earth_bump.bmp')
    { GLMaterialLibrary.AddTextureMaterial('EarthBump',EarthProjectPath+'earth_bump.bmp') }
  else
    NightSkyorBumpyLand1.Enabled := False;
  GlsGlowLF.Visible := False;
  Randomize;
  { Seed:=RandSeed; }
  MasterAsteroidF := TGLFreeForm(DCAsteroids.AddNewChild(TGLFreeForm));
  Temp := TMeshObject.CreateOwned(MasterAsteroidF.MeshObjects);
  BuildPotatoid(Temp, 0.7, 3, 2);
  MasterAsteroidF.Scale.X := 0.2;
  MasterAsteroidF.Scale.Y := 0.2;
  MasterAsteroidF.Scale.Z := 0.2;
  MasterAsteroidF.Position.X := 2.5;
  // LayersLoaded:=0;
  EarthLoaded := False;
  ColorAlltheSame := False;
  MarkersDisplaySelection := 0;
  TemporalFlowDateTime := Now;
  CountriesLoaded := False;
  CapitalsLoaded := False;
  CitiesLoaded := False;
  markers := TStringList.CReate;
  NameCB.Clear;
  // Load coordinate list
  sDateFormat := System.SysUtils.FormatSettings.ShortDateFormat; // save it
  System.SysUtils.FormatSettings.ShortDateFormat := 'dd/mm/yyyy';
  System.SysUtils.FormatSettings.DateSeparator := '/';
  AssignFile(F, EarthDataPath + 'EarthLoco.txt');
  Reset(F);
  try
    ClearLocations;
    markerIndex := 0;
    while not eof(F) do
    begin
      Readln(F, Lon, Lat, mType, gType, sDateSmuoosh);
      // Showmessage(sDateSmuoosh);
      mp := TMarkerPosition.CReate;
      markers.AddObject(IntToStr(markerIndex), mp);
      with TMarkerPosition(markers.Objects[markerIndex]) do
      begin
        Longitude := Lon;
        Latitude := Lat;
        membertype := mType;
        Glow := gType;
        // Showmessage(sDateSmuoosh);
        TypeName := Copy(sDateSmuoosh, 0 { pos(' ',sDateSmuoosh)+1 } ,
          pos(',', sDateSmuoosh) - 1);
        sWhoWhereFormat := Copy(sDateSmuoosh, pos(',', sDateSmuoosh) + 1,
          Length(sDateSmuoosh));
        sDateSmuoosh := sWhoWhereFormat;
        Name := Copy(sDateSmuoosh, 0, pos(',', sDateSmuoosh) - 1);
        NameCB.Items.Add(Name);
        sWhoWhereFormat := Copy(sDateSmuoosh, pos(',', sDateSmuoosh) + 1,
          Length(sDateSmuoosh));
        sDateSmuoosh := sWhoWhereFormat;
        NickName := Copy(sDateSmuoosh, 0, pos(',', sDateSmuoosh) - 1);
        sWhoWhereFormat := Copy(sDateSmuoosh, pos(',', sDateSmuoosh) + 1,
          Length(sDateSmuoosh));
        sDateSmuoosh := sWhoWhereFormat;
        sWhoWhereFormat := Copy(sDateSmuoosh, 0, pos(',', sDateSmuoosh) - 1);
        City := sWhoWhereFormat;
        sWhoWhereFormat := Copy(sDateSmuoosh, pos(',', sDateSmuoosh) + 1,
          Length(sDateSmuoosh));
        sDateSmuoosh := sWhoWhereFormat;
        sWhoWhereFormat := Copy(sDateSmuoosh, 0, pos(',', sDateSmuoosh) - 1);
        State := sWhoWhereFormat;
        sWhoWhereFormat := Copy(sDateSmuoosh, pos(',', sDateSmuoosh) + 1,
          Length(sDateSmuoosh));
        sDateSmuoosh := sWhoWhereFormat;
        Country := Copy(sDateSmuoosh, 0, pos(',', sDateSmuoosh) - 1);
        sWhoWhereFormat := Copy(sDateSmuoosh, pos(',', sDateSmuoosh) + 1,
          Length(sDateSmuoosh));
        sDateSmuoosh := sWhoWhereFormat;
        sDate := Copy(sDateSmuoosh, 0, pos(',', sDateSmuoosh) - 1);
        // sDate := Trim(sDate);

        GetDateFormatA(LOCALE_SYSTEM_DEFAULT, DATE_SHORTDATE, NIL, NIL, NIL, 0);

        DateAdded := StrToDate(sDate);
        sWhoWhereFormat := Copy(sDateSmuoosh, pos(',', sDateSmuoosh) + 1,
          Length(sDateSmuoosh));
        sDateSmuoosh := sWhoWhereFormat;
        sDate := Copy(sDateSmuoosh, 0, pos(',', sDateSmuoosh) - 1);
        DateDOB := StrToDate(Trim(sDate));
        sWhoWhereFormat := Copy(sDateSmuoosh, pos(',', sDateSmuoosh) + 1,
          Length(sDateSmuoosh));
        sDateSmuoosh := sWhoWhereFormat;
        sWhoWhereFormat := Copy(sDateSmuoosh, 0, pos(',', sDateSmuoosh) - 1);
        Photo := sWhoWhereFormat;
        sWhoWhereFormat := Copy(sDateSmuoosh, pos(',', sDateSmuoosh) + 1,
          Length(sDateSmuoosh));
        sDateSmuoosh := sWhoWhereFormat;
        sWhoWhereFormat := Copy(sDateSmuoosh, 0, pos(',', sDateSmuoosh) - 1);
        EMail := sWhoWhereFormat;
        sWhoWhereFormat := Copy(sDateSmuoosh, pos(',', sDateSmuoosh) + 1,
          Length(sDateSmuoosh));
        sDateSmuoosh := sWhoWhereFormat;
        sWhoWhereFormat := Copy(sDateSmuoosh, 0, pos(',', sDateSmuoosh) - 1);
        Url := sWhoWhereFormat;
        sWhoWhereFormat := Copy(sDateSmuoosh, pos(',', sDateSmuoosh) + 1,
          Length(sDateSmuoosh));
        sDateSmuoosh := sWhoWhereFormat;
        sWhoWhereFormat := Copy(sDateSmuoosh, 0, pos(',', sDateSmuoosh) - 1);
        DemoName := sWhoWhereFormat;
        sWhoWhereFormat := Copy(sDateSmuoosh, pos(',', sDateSmuoosh) + 1,
          Length(sDateSmuoosh));
        Description := sWhoWhereFormat;
        { fLatitude : single;
          fLongitude : single;
          fmembertype, fGlow  : byte; // 0..255
          fTypeName, fName, fNickName, fCity, fState, fCountry: String;
          fDateAdded, fDateDOB: TDate;
          fEMail, fUrl, fDemoName,  fDescription: String; }
      end;
      Inc(markerIndex);
    end; // while
  finally
    CloseFile(F);
  end; // finally
  NameCB.ItemIndex := 0;
  AssignFile(F, EarthDataPath + 'EarthLocoColors.txt');
  Reset(F);
  try
    ColorIndex := 0;
    while not eof(F) do
    begin
      Readln(F, sDateSmuoosh);
      SetLength(DotColorArray, ColorIndex + 1);
      DotColorArray[ColorIndex] := ConvertWinColor(strtoint(sDateSmuoosh));
      Inc(ColorIndex);
    end; // while
  finally
    CloseFile(F);
  end; // finally

  System.SysUtils.FormatSettings.ShortDateFormat := sDateFormat;
  DrawPoints;
  DateTimePicker1.DateTime := Now; { calls DrawPoints; ? }
end;

procedure TSpaceSceneFrm.FormShow(Sender: TObject);
begin
  GlowUpDown.Position := GlowUpDowni;
  NameCBChange(Sender);
end;

procedure TSpaceSceneFrm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  EarthFormY := SpaceSceneFrm.top;
  EarthFormX := SpaceSceneFrm.left;
  GlowUpDowni := GlowUpDown.Position;
  DoSaver;
end;

procedure TSpaceSceneFrm.miExitClick(Sender: TObject);
begin
  Close;
end;

procedure TSpaceSceneFrm.FormDestroy(Sender: TObject);
begin
  SetLength(DotColorArray, 0);
  ClearLocations;
  markers.Free;
end;

// ----- Tform1.ClearLocations -------------------------------------------------
procedure TSpaceSceneFrm.ClearLocations;
begin
  while markers.Count > 0 do
  begin
    TMarkerPosition(markers.Objects[0]).Free;
    markers.Delete(0);
  end;
  markers.Clear;
end;

// ----- Tform1.DrawPoints -----------------------------------------------------
procedure TSpaceSceneFrm.DrawPoints;
var
  i: Integer;
  PlanetLocation: single;

begin
  if miClouds.Checked then
    PlanetLocation := SPEarthClouds.Radius
  else
    PlanetLocation := SPEarth.Radius;
  ptsLocations.Positions.Clear;
  ptsLocations.Colors.Clear;
  markersCounted := 0;
  for i := 0 to markers.Count - 1 do
  begin
    case MarkersDisplaySelection of
      0: { Display ALL }
        begin
          If ColorAlltheSame then
            ptsLocations.Colors.Add(ConvertWinColor(PeopleColorPanel.Color))
          else If (TMarkerPosition(markers.Objects[i]).membertype > ColorIndex)
          then
            ptsLocations.Colors.Add(DotColorArray[3])
          else
            ptsLocations.Colors.Add
              (DotColorArray[TMarkerPosition(markers.Objects[i]).membertype]);
          ptsLocations.Positions.Add(TMarkerPosition(markers.Objects[i])
            .GetCartesian(PlanetLocation));
        end;
      1: { Display by Type } { cbTypes }
        Begin
          if (TMarkerPosition(markers.Objects[i]).membertype = cbTypes.ItemIndex)
          then
          begin
            If ColorAlltheSame then
              ptsLocations.Colors.Add(ConvertWinColor(PeopleColorPanel.Color))
            else
              { Cant Load more Colors Yet... ! }
              If (TMarkerPosition(markers.Objects[i]).membertype > ColorIndex)
              then
                ptsLocations.Colors.Add(DotColorArray[3])
              else
                ptsLocations.Colors.Add
                  (DotColorArray[TMarkerPosition(markers.Objects[i])
                  .membertype]);

            ptsLocations.Positions.Add(TMarkerPosition(markers.Objects[i])
              .GetCartesian(PlanetLocation));
          end;
        end;
      2: { Display by Date }
        begin // only add dates prior to display date
          If ((DateForwardCB.Checked and (TMarkerPosition(markers.Objects[i])
            .DateAdded < DateTimePicker1.DateTime)) or
            ((not DateForwardCB.Checked) and (TMarkerPosition(markers.Objects[i]
            ).DateAdded > DateTimePicker1.DateTime))) then
          begin
            If ColorAlltheSame then
              ptsLocations.Colors.Add(ConvertWinColor(PeopleColorPanel.Color))
            else If (TMarkerPosition(markers.Objects[i]).membertype > ColorIndex)
            then
              ptsLocations.Colors.Add(DotColorArray[3])
            else
              ptsLocations.Colors.Add
                (DotColorArray[TMarkerPosition(markers.Objects[i]).membertype]);

            ptsLocations.Positions.Add(TMarkerPosition(markers.Objects[i])
              .GetCartesian(PlanetLocation));
          end;
        end;
      3: { Display by Name }{ NameCB }
        begin { fmembertype  fName }
          if (TMarkerPosition(markers.Objects[i]).Name = NameCB.Items
            [NameCB.ItemIndex]) then
          begin
            If ColorAlltheSame then
              ptsLocations.Colors.Add(ConvertWinColor(PeopleColorPanel.Color))
            else If (TMarkerPosition(markers.Objects[i]).membertype > ColorIndex)
            then
              ptsLocations.Colors.Add(DotColorArray[3])
            else
              ptsLocations.Colors.Add
                (DotColorArray[TMarkerPosition(markers.Objects[i]).membertype]);

            ptsLocations.Positions.Add(TMarkerPosition(markers.Objects[i])
              .GetCartesian(PlanetLocation));
          end;
        End;
      { ChoiceRG.Itemindex  MarkersDisplaySelection
        TemporalFlowDateTime }
      4: { Temporal Display by Date }
        begin // only add dates prior to display date
          if (TMarkerPosition(markers.Objects[i]).DateAdded <
            TemporalFlowDateTime) then
          begin
            If ColorAlltheSame then
              ptsLocations.Colors.Add(ConvertWinColor(PeopleColorPanel.Color))
            else If (TMarkerPosition(markers.Objects[i]).membertype > ColorIndex)
            then
              ptsLocations.Colors.Add(DotColorArray[3])
            else
              ptsLocations.Colors.Add
                (DotColorArray[TMarkerPosition(markers.Objects[i]).membertype]);
            Inc(markersCounted);
            ptsLocations.Positions.Add(TMarkerPosition(markers.Objects[i])
              .GetCartesian(PlanetLocation));
          end;
        end;
    end; { Case }
  end;
  ptsLocations.StructureChanged;
end;

procedure TSpaceSceneFrm.GLSceneViewerBeforeRender(Sender: TObject);
begin
  If miSunFlare.Checked then
    GLLensFlare1.PreRender(Sender as TGLSceneBuffer);
  If miSatelliteLight.Checked then
    If ptsFlashLocations.Visible then
      GlsGlowLF.PreRender(Sender as TGLSceneBuffer);

    GLMaterialLibrary.Materials[0].Shader := EarthCombiner;
    If NightSkyorBumpyLand1.Checked then
      GLMaterialLibrary.Materials[0].Texture2Name := 'earthNight'
    else
      GLMaterialLibrary.Materials[0].Texture2Name := 'earthBump'
(*
  // if no multitexturing or no combiner support, turn off city lights
    if GL_ARB_multitexture and GL_ARB_texture_env_combine then
  begin
    GLMaterialLibrary.Materials[0].Shader := EarthCombiner;
    If NightSkyorBumpyLand1.Checked then
      GLMaterialLibrary.Materials[0].Texture2Name := 'earthNight'
    else
      GLMaterialLibrary.Materials[0].Texture2Name := 'earthBump'
  end
  else
  begin
    GLMaterialLibrary.Materials[0].Shader := nil;
    GLMaterialLibrary.Materials[0].Texture2Name := '';
    NightSkyorBumpyLand1.Enabled := False;
  end;
  *)
end;

{ Tex0:=Tex0;
  Tex1:=InterPolate(Tex0, Tex1, PrimaryColor); }
{ Tex0:=Tex0;
  Tex1:=InterPolate(Tex0, Tex1, PrimaryColor);

  Syntax Examples:

  Tex1:=Tex0;   // replace texture 1 with texture 0
  Tex1:=Tex0+Tex1; // additive blending between textures 0 and 1
  Tex1:=Tex0-Tex1; // subtractive blending between textures 0 and 1
  Tex1:=Tex0*Tex1; // modulation between textures 0 and 1
  Tex1:=Tex0+Tex1-0.5; // signed additive blending between textures 0 and 1
  Tex1:=Interpolate(Tex0, Tex1, PrimaryColor); // interpolation between textures 0 and 1 using primary color as factor
  Tex1:=Dot3(Tex0, Tex1); // dot3 product between textures 0 and 1
}
procedure TSpaceSceneFrm.GLDirectOpenGL1Render(Sender: TObject;
  var rci: TGLRenderContextInfo);
const
  // unrealisticly thick atmospheres look better :)
  cAtmosphereRadius: single = 0.55;
  // use value slightly lower than actual radius, for antialiasing effect
  cPlanetRadius: single = 0.495;
  cLowAtmColor: TColorVector = (X:1; Y:1; Z:1; W:1);
  cHighAtmColor: TColorVector = (X:0; Y:0; Z:1; W:1);
  cOpacity: single = 5;
  cIntDivTable: array [2 .. 20] of single = (1 / 2, 1 / 3, 1 / 4, 1 / 5, 1 / 6,
    1 / 7, 1 / 8, 1 / 9, 1 / 10, 1 / 11, 1 / 12, 1 / 13, 1 / 14, 1 / 15, 1 / 16,
    1 / 17, 1 / 18, 1 / 19, 1 / 20);
var
  Radius, invAtmosphereHeight: single;
  sunPos, eyePos, lightingVector: TVector;
  diskNormal, diskRight, diskUp: TVector;

  function AtmosphereColor(const rayStart, rayEnd: TVector): TColorVector;
  var
    i, n: Integer;
    atmPoint, normal: TVector;
    altColor: TColorVector;
    alt, rayLength, contrib, decay, intensity, invN: single;
  begin
    Result := clrTransparent;
    rayLength := VectorDistance(rayStart, rayEnd);
    n := Round(3 * rayLength * invAtmosphereHeight) + 2;
    if n > 10 then
      n := 10;
    invN := cIntDivTable[n]; // 1/n;
    contrib := rayLength * invN * cOpacity;
    decay := 1 - contrib * 0.5;
    contrib := contrib * (1 / 1.1);
    for i := n - 1 downto 0 do
    begin
      VectorLerp(rayStart, rayEnd, i * invN, atmPoint);
      // diffuse lighting normal
      normal := VectorNormalize(atmPoint);
      // diffuse lighting intensity
      intensity := VectorDotProduct(normal, lightingVector) + 0.1;
      if PInteger(@intensity)^ > 0 then
      begin
        // sample on the lit side
        intensity := intensity * contrib;
        alt := (VectorLength(atmPoint) - cPlanetRadius) * invAtmosphereHeight;
        VectorLerp(cLowAtmColor, cHighAtmColor, alt, altColor);
        Result.X := Result.X * decay + altColor.X * intensity;
        Result.Y := Result.Y * decay + altColor.Y * intensity;
        Result.Z := Result.Z * decay + altColor.Z * intensity;
      end
      else
      begin
        // sample on the dark side
        Result.X := Result.X * decay;
        Result.Y := Result.Y * decay;
        Result.Z := Result.Z * decay;
      end;
    end;
    Result.W := n * contrib * cOpacity * 0.1;
  end;

  function ComputeColor(var rayDest: TVector; mayHitGround: Boolean)
    : TColorVector;
  var
    ai1, ai2, pi1, pi2: TVector;
    rayVector: TVector;
  begin
    rayVector := VectorNormalize(VectorSubtract(rayDest, eyePos));
    if RayCastSphereIntersect(eyePos, rayVector, NullHmgPoint,
      cAtmosphereRadius, ai1, ai2) > 1 then
    begin
      // atmosphere hit
      if mayHitGround and (RayCastSphereIntersect(eyePos, rayVector,
        NullHmgPoint, cPlanetRadius, pi1, pi2) > 0) then
      begin
        // hit ground
        Result := AtmosphereColor(ai1, pi1);
      end
      else
      begin
        // through atmosphere only
        Result := AtmosphereColor(ai1, ai2);
      end;
      rayDest := ai1;
    end
    else
      Result := clrTransparent;
  end;

const
  cSlices = 60;
var
  i, j, k0, k1: Integer;
  cosCache, sinCache: array [0 .. cSlices] of single;
  pVertex, pColor: PVectorArray;
begin
  If miAtmosphere.Checked then
  begin
    sunPos := LSSun.AbsolutePosition;
    eyePos := GLCamera.AbsolutePosition;

    diskNormal := VectorNegate(eyePos);
    NormalizeVector(diskNormal);
    diskRight := VectorCrossProduct(GLCamera.AbsoluteUp, diskNormal);
    NormalizeVector(diskRight);
    diskUp := VectorCrossProduct(diskNormal, diskRight);
    NormalizeVector(diskUp);

    invAtmosphereHeight := 1 / (cAtmosphereRadius - cPlanetRadius);
    lightingVector := VectorNormalize(sunPos); // sun at infinity
    PrepareSinCosCache(sinCache, cosCache, 0, 360);

    GetMem(pVertex, 2 * (cSlices + 1) * SizeOf(TVector));
    GetMem(pColor, 2 * (cSlices + 1) * SizeOf(TVector));

    glPushAttrib(GL_ENABLE_BIT);
    glDepthMask(0);
    glDisable(GL_LIGHTING);
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    for i := 0 to 13 do
    begin
      if i < 5 then
        Radius := cPlanetRadius * Sqrt(i * (1 / 5))
      else
        Radius := cPlanetRadius + (i - 5.1) *
          (cAtmosphereRadius - cPlanetRadius) * (1 / 6.9);
      Radius := SphereVisibleRadius(VectorLength(eyePos), Radius);
      k0 := (i and 1) * (cSlices + 1);
      k1 := (cSlices + 1) - k0;
      for j := 0 to cSlices do
      begin
        VectorCombine(diskRight, diskUp, cosCache[j] * Radius,
          sinCache[j] * Radius, pVertex[k0 + j]);
        if i < 13 then
          pColor[k0 + j] := ComputeColor(pVertex[k0 + j], i <= 7);
        if i = 0 then
          Break;
      end;

      if i > 1 then
      begin
        if i = 13 then
        begin
          glBegin(GL_QUAD_STRIP);
          for j := cSlices downto 0 do
          begin
            glColor4fv(@pColor[k1 + j]);
            glVertex3fv(@pVertex[k1 + j]);
            glColor4fv(@clrTransparent);
            glVertex3fv(@pVertex[k0 + j]);
          end;
          glEnd;
        end
        else
        begin
          glBegin(GL_QUAD_STRIP);
          for j := cSlices downto 0 do
          begin
            glColor4fv(@pColor[k1 + j]);
            glVertex3fv(@pVertex[k1 + j]);
            glColor4fv(@pColor[k0 + j]);
            glVertex3fv(@pVertex[k0 + j]);
          end;
          glEnd;
        end;
      end
      else if i = 1 then
      begin
        glBegin(GL_TRIANGLE_FAN);
        glColor4fv(@pColor[k1]);
        glVertex3fv(@pVertex[k1]);
        for j := k0 + cSlices downto k0 do
        begin
          glColor4fv(@pColor[j]);
          glVertex3fv(@pVertex[j]);
        end;
        glEnd;
      end;
    end;
    glDepthMask(1);
    glPopAttrib;

    FreeMem(pVertex);
    FreeMem(pColor);
  end;
end;

procedure TSpaceSceneFrm.LoadConstellationLines;
var
  sl, line: TStrings;
  pos1, pos2: TAffineVector;
  function LonLatToPos(Lon, Lat: single): TAffineVector;
  var
    F: single;
  begin
    SinCosine(Lat * (PI / 180), Result.Y, F);
    SinCosine(Lon * (360 / 24 * PI / 180), F, Result.X, Result.Z);
  end;

var
  i: Integer;
begin
  sl := TStringList.CReate;
  line := TStringList.CReate;
  sl.LoadFromFile(EarthDataPath + 'Constellations.dat');
  for i := 0 to sl.Count - 1 do
  begin
    line.CommaText := sl[i];
    pos1 := LonLatToPos(StrToFloatDef(line[0]), StrToFloatDef(line[1]));
    ConstellationLines.AddNode(pos1);
    pos2 := LonLatToPos(StrToFloatDef(line[2]), StrToFloatDef(line[3]));
    ConstellationLines.AddNode(pos2);
  end;
  sl.Free;
  line.Free;
end;

procedure TSpaceSceneFrm.TimerTimer(Sender: TObject);
begin
  If MarkersDisplaySelection < 4 then
    miFPS.Caption := Format('%.1f FPS', [GLSceneViewer.FramesPerSecond])
  else
    miFPS.Caption := IntToStr(markersCounted) + ' of ' + IntToStr(markers.Count) +
      ' : ' + DateToStr(TemporalFlowDateTime);
  GLSceneViewer.ResetPerformanceMonitor;
end;

procedure TSpaceSceneFrm.GLCadencerProgress(Sender: TObject;
  const deltaTime, newTime: Double);
var
  d: Double;
  p: TAffineVector;
begin
  { sun Position X8500 Y8500 Z0 }
  { Sun: 9880  6375  0 }
  { Moon cube Up X-3.719719E-9 Y1Z0
    Moon Position X-29.6 Y0Z0
    Scale XYZ 0.27 Radius 0.5 Earth Radius 0.5
    Moon: 277604 687816 29574    Scale Moon/Earth radii = 3475/12756
    Mercury -3715  -3693  39     Scale XYZ 0.382  Position X -39
    Venus -8392  -451  478       Scale XYZ 0.949  Position X -478
    Mars -5882  17881  518       Scale XYZ 0.533  Position X 518
    Jupiter -61941  13502  1329  Scale XYZ 11.209  Position X 1329
    Saturn -25401  102463  -779  Scale XYZ 9.45  Position X -779
    Uranus 209552 -104695 -3108  Scale XYZ 4.007  Position X -3108
    Neptune 241251  -255428 -291 Scale XYZ 3.883  Position X -291 }
  { Pluto... }
  // d:=GMTDateTimeToJulianDay(Now-2+newTime*timeMultiplier);
  // make earth rotate
  SPEarth.TurnAngle := SPEarth.TurnAngle + deltaTime * timeMultiplier;
  SPEarthClouds.TurnAngle := SPEarthClouds.TurnAngle + deltaTime *
    timeMultiplier { +timeMultiplier };
  If miSpinSolarSystem.Checked then
  begin
    d := GMTDateTimeToJulianDay(Now - 2 + newTime * timeMultiplier);
    p := ComputePlanetPosition(cSunOrbitalElements, d);
    ScaleVector(p, 0.5 * cAUToKilometers * (1 / cEarthRadius));
    LSSun.Position.AsAffineVector := p;
    { showmessage('Sun: '+Floattostr(LSSun.Position.x)  +' , '+Floattostr(LSSun.Position.y)  +' , '+Floattostr(LSSun.Position.z)); }
  end;
  If miAsteroidField.Checked then
  begin
    MasterAsteroidF.RollAngle := MasterAsteroidF.RollAngle + 1 +
      (Random * deltaTime);
    MasterAsteroidF.TurnAngle := MasterAsteroidF.TurnAngle + 1 + deltaTime *
      timeMultiplier;
    MasterAsteroidF.Position.X := MasterAsteroidF.Position.X - deltaTime;
    If MasterAsteroidF.Position.X < (0) then
      MasterAsteroidF.Position.X := 2;
    If ((MasterAsteroidF.Position.X < 0.7) and
      (MasterAsteroidF.Position.X > (0.5))) then
    begin
      GlsGlowLF.Size := 1000 -
        Round((SPEarth.Position.X - MasterAsteroidF.Position.X) * 1000);
      GlsGlowLF.Position.X := { SPEarth.Position.X } -MasterAsteroidF.
        Position.X;
      GlsGlowLF.Position.Y := SPEarth.Position.Y - MasterAsteroidF.Position.Y;
      GlsGlowLF.Position.Z := SPEarth.Position.Z - MasterAsteroidF.Position.Z;
      GlsGlowLF.Visible := True;
    end
    else
      GlsGlowLF.Visible := False;
    // SPEarth.Position.X - 1;//(SPMoon.Position.X/deltaTime  );
    MasterAsteroidF.Position.Y := SPEarth.Position.Y;
  end;

  // moon rotates on itself and around earth (not sure about the rotation direction!)
  { p:=ComputePlanetPosition(cMoonOrbitalElements, d);
    ScaleVector(p, 0.5*cAUToKilometers*(1/cEarthRadius));
    SPMoon.Position.AsAffineVector:=p; }
  { showmessage('Moon: '+Floattostr(p[0])  +' , '+Floattostr(p[1])  +' , '+Floattostr(p[2])); }
  DCMoon.TurnAngle := DCMoon.TurnAngle + deltaTime * timeMultiplier / 29.5;
  SPMoon.TurnAngle := 180 - DCMoon.TurnAngle;

  { p:=ComputePlanetPosition(cMercuryOrbitalElements, d);
    //ScaleVector(p, 0.5*cAUToKilometers*(1/cEarthRadius));
    showmessage('Mercury: '+Floattostr(p[0])  +' , '+Floattostr(p[1])  +' , '+Floattostr(p[2]));
    p:=ComputePlanetPosition(cVenusOrbitalElements, d);
    //ScaleVector(p, 0.5*cAUToKilometers*(1/cEarthRadius));
    showmessage('Venus: '+Floattostr(p[0])  +' , '+Floattostr(p[1])  +' , '+Floattostr(p[2]));
    p:=ComputePlanetPosition(cMarsOrbitalElements, d);
    //ScaleVector(p, 0.5*cAUToKilometers*(1/cEarthRadius));
    showmessage('Mars: '+Floattostr(p[0])  +' , '+Floattostr(p[1])  +' , '+Floattostr(p[2]));
    p:=ComputePlanetPosition(cJupiterOrbitalElements, d);
    //ScaleVector(p, 0.5*cAUToKilometers*(1/cEarthRadius));
    showmessage('Jupiter: '+Floattostr(p[0])  +' , '+Floattostr(p[1])  +' , '+Floattostr(p[2]));
    p:=ComputePlanetPosition(cSaturnOrbitalElements, d);
    //ScaleVector(p, 0.5*cAUToKilometers*(1/cEarthRadius));
    showmessage('Saturn: '+Floattostr(p[0])  +' , '+Floattostr(p[1])  +' , '+Floattostr(p[2]));
    p:=ComputePlanetPosition(cUranusOrbitalElements, d);
    //ScaleVector(p, 0.5*cAUToKilometers*(1/cEarthRadius));
    showmessage('Uranus: '+Floattostr(p[0])  +' , '+Floattostr(p[1])  +' , '+Floattostr(p[2]));
    p:=ComputePlanetPosition(cNeptuneOrbitalElements, d);
    //ScaleVector(p, 0.5*cAUToKilometers*(1/cEarthRadius));
    showmessage('Neptune: '+Floattostr(p[0])  +' , '+Floattostr(p[1])  +' , '+Floattostr(p[2])); }
  { Pluto... }
  // honour camera movements
  if (dmy <> 0) or (dmx <> 0) then
  begin
    GLCameraControler.MoveAroundTarget(ClampValue(dmy * 0.3, -5, 5),
      ClampValue(dmx * 0.3, -5, 5));
    dmx := 0;
    dmy := 0;
  end;
  // this gives us smoother camera movements
  cameraTimeSteps := cameraTimeSteps + deltaTime;
  while cameraTimeSteps > 0.005 do
  begin
    GLCamera.Position.AsVector := VectorLerp(GLCamera.Position.AsVector,
      GLCameraControler.Position.AsVector, 0.05);
    cameraTimeSteps := cameraTimeSteps - 0.005;
  end;
  // smooth constellation appearance/disappearance
  with ConstellationLines.LineColor do
    if Alpha <> constellationsAlpha then
    begin
      Alpha := ClampValue(Alpha + SignStrict(constellationsAlpha - Alpha) *
        deltaTime, 0, 0.5);
      ConstellationLines.Visible := (Alpha > 0);
    end;
end;

procedure TSpaceSceneFrm.GLSceneViewerMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  mx := X;
  my := Y;
end;

procedure TSpaceSceneFrm.GLSceneViewerMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if Shift = [ssLeft] then
  begin
    dmx := dmx + (mx - X);
    dmy := dmy + (my - Y);
  end
  else if Shift = [ssRight] then
    GLCamera.FocalLength := GLCamera.FocalLength * PowerSingle(1.05, (my - Y) * 0.1);
  mx := X;
  my := Y;
end;

procedure TSpaceSceneFrm.GLSceneViewerMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Shift = [ssCtrl] then
  begin
    { Perform Selection of Marker.. then
      Select the NameCB.ItemIndex := 0;
      to display the Selected Persons Data }

  end;
end;

procedure TSpaceSceneFrm.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
var
  F: single;
begin
  if (WheelDelta > 0) or (GLCameraControler.Position.VectorLength > 0.90) then
  begin
    F := PowerSingle(1.05, WheelDelta * (1 / 120));
    GLCameraControler.AdjustDistanceToTarget(F);
  end;
  Handled := True;
end;

procedure TSpaceSceneFrm.GLSceneViewerDblClick(Sender: TObject);
begin { fig FullScreen ? }
  GLSceneViewer.OnMouseMove := nil;
  if WindowState = wsMaximized then
  begin
    WindowState := wsNormal;
    BorderStyle := bsSizeable; // bsSizeToolWin;
  end
  else
  begin
    BorderStyle := bsNone;
    WindowState := wsMaximized;
  end;
  GLSceneViewer.OnMouseMove := GLSceneViewerMouseMove;
end;

procedure TSpaceSceneFrm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  case Key of
    #27:
      Close;
    'z', 'Z':
      begin
        { the z gets into the memo too.. a bug.. dunno what to 'Focus' }
        MenuVisible := (not MenuVisible);
        If (MenuVisible) then
          SpaceSceneFrm.Menu := MainMenu
        else
          SpaceSceneFrm.Menu := nil;
      end;
    'e', 'E':
      begin
        GLCamera.MoveTo(DCEarthSystem);
        GLCameraControler.MoveTo(DCEarthSystem);
        GLCamera.TargetObject := DCEarthSystem;
        GLCameraControler.TargetObject := DCEarthSystem;
      end;
    'm', 'M':
      begin
        ptsFlashLocations.Visible := False;
        GLCamera.MoveTo(SPMoon);
        GLCameraControler.MoveTo(SPMoon);
        GLCamera.TargetObject := SPMoon;
        GLCameraControler.TargetObject := SPMoon;
      end;
    '0' .. '9':
      timeMultiplier := PowerInteger(Integer(Key) - Integer('0'), 3);
  end;
end;

procedure TSpaceSceneFrm.GLSceneViewerMouseEnter(Sender: TObject);
begin
  GLSceneViewer.SetFocus;  GLSceneViewer.Focused;
end;

{ ============================================================== }

procedure TSpaceSceneFrm.miRoundClick(Sender: TObject);
begin
  miRound.Checked := True;
  miSmooth.Checked := not miRound.Checked;
  miSmoothAdditive.Checked := not miRound.Checked;
  miSquare.Checked := not miRound.Checked;
  ptsLocations.Style := psRound;
end;

procedure TSpaceSceneFrm.miSmoothClick(Sender: TObject);
begin
  miSmooth.Checked := True;
  miRound.Checked := not miSmooth.Checked;
  miSmoothAdditive.Checked := not miSmooth.Checked;
  miSquare.Checked := not miSmooth.Checked;
  ptsLocations.Style := psSmooth;
end;

procedure TSpaceSceneFrm.miSmoothAdditiveClick(Sender: TObject);
begin
  miSmoothAdditive.Checked := True;
  miRound.Checked := not miSmoothAdditive.Checked;
  miSmooth.Checked := not miSmoothAdditive.Checked;
  miSquare.Checked := not miSmoothAdditive.Checked;
  ptsLocations.Style := psSmoothAdditive;
end;

procedure TSpaceSceneFrm.miSquareClick(Sender: TObject);
begin
  miSquare.Checked := True;
  miRound.Checked := not miSquare.Checked;
  miSmoothAdditive.Checked := not miSquare.Checked;
  miSmooth.Checked := not miSquare.Checked;
  ptsLocations.Style := psSquare;
end;

{ ============================================================== }

procedure TSpaceSceneFrm.miSelectedSatelliteClick(Sender: TObject);
begin
  miSelectedSatellite.Checked := not miSelectedSatellite.Checked;
  ptsFlashLocations.Visible := miSelectedSatellite.Checked;
end;

procedure TSpaceSceneFrm.miSatelliteLightClick(Sender: TObject);
begin
  miSatelliteLight.Checked := not miSatelliteLight.Checked;
  If miSatelliteLight.Checked then
  begin
    If ptsFlashLocations.Visible then
      GlsGlowLF.Visible := True
    else
      GlsGlowLF.Visible := False;
  end
  else
    GlsGlowLF.Visible := False;
end;

{ ============================================================== }
procedure TSpaceSceneFrm.miAddaPeopleClick(Sender: TObject);
begin
  EarthLocationsFrm.Show;
end;

{ ============================================================== }
procedure TSpaceSceneFrm.miSpinThePlanetClick(Sender: TObject);
begin
  miSpinThePlanet.Checked := (not miSpinThePlanet.Checked);
  GLCadencer.Enabled := miSpinThePlanet.Checked; // on autocheck
end;

procedure TSpaceSceneFrm.miSpinSolarSystemClick(Sender: TObject);
begin
  miSpinSolarSystem.Checked := (not miSpinSolarSystem.Checked);
end;

{ ============================================================== }
procedure TSpaceSceneFrm.miStarsClick(Sender: TObject);
begin
  miStars.Checked := (not miStars.Checked);
  GLSkydome.Visible := miStars.Checked;
end;

procedure TSpaceSceneFrm.miSunFlareClick(Sender: TObject);
begin
  miSunFlare.Checked := (not miSunFlare.Checked);
  GLLensFlare1.Visible := miSunFlare.Checked;
end;

procedure TSpaceSceneFrm.miAsteroidFieldClick(Sender: TObject);
begin
  miAsteroidField.Checked := (not miAsteroidField.Checked);
  MasterAsteroidF.Position.X := 3;
  GlsGlowLF.Visible := False;
end;

procedure TSpaceSceneFrm.miConstellationLinesClick(Sender: TObject);
begin
  miConstellationLines.Checked := (not miConstellationLines.Checked);
  constellationsAlpha := 0.5 - constellationsAlpha;
end;

procedure TSpaceSceneFrm.miCloudsClick(Sender: TObject);
begin
  miClouds.Checked := (not miClouds.Checked);
  SPEarthClouds.Visible := miClouds.Checked;
  ptsLocations.StructureChanged;
  DrawPoints;
  GLSceneViewer.Invalidate;
end;

procedure TSpaceSceneFrm.miAtmosphereClick(Sender: TObject);
begin { GLDirectOpenGL1 }
  miAtmosphere.Checked := (not miAtmosphere.Checked);
end;

procedure TSpaceSceneFrm.NightSkyorBumpyLand1Click(Sender: TObject);
begin
  NightSkyorBumpyLand1.Checked := (not NightSkyorBumpyLand1.Checked);
  ptsLocations.StructureChanged;
  GLSceneViewer.Invalidate;
end;

procedure TSpaceSceneFrm.miFlipFlopLandClick(Sender: TObject);
  procedure LoadHighResTexture(libMat: TGLLibMaterial; const fileName: String);
  begin
    if FileExists(fileName) then
    begin
      libMat.Material.Texture.Compression := tcStandard;
      libMat.Material.Texture.Image.LoadFromFile(fileName);
    end;
  end;

begin
  if (not highResResourcesLoaded) then
  begin
    miFlipFlopLand.Checked := (not miFlipFlopLand.Checked);
    If miFlipFlopLand.Checked then
    begin
      If (FileExists(EarthModelPath + 'earth_tint.jpg')) then
      begin
        with GLMaterialLibrary do
          LoadHighResTexture(Materials[0], EarthModelPath + 'earth_tint.jpg');
      end;
    end
    else
    begin { land_ocean_ice_2048.jpg }
      If (FileExists(EarthModelPath + 'earth_ocean_ice_2048.jpg')) then
      begin
        with GLMaterialLibrary do
          LoadHighResTexture(Materials[0],
            EarthModelPath + 'earth_ocean_ice_2048.jpg');
      end;
    end;
    ptsLocations.StructureChanged;
    GLSceneViewer.Invalidate;
  end;
end;

procedure TSpaceSceneFrm.miHighResolutionClick(Sender: TObject);
  procedure LoadHighResTexture(libMat: TGLLibMaterial; const fileName: String);
  begin
    if FileExists(fileName) then
    begin
      libMat.Material.Texture.Compression := tcStandard;
      libMat.Material.Texture.Image.LoadFromFile(fileName);
    end;
  end;

begin
  if not highResResourcesLoaded then
  begin
    GLSceneViewer.Cursor := crHourGlass;
    miFlipFlopLand.Checked := False; { just in case }
    try
      { if DirectoryExists(ExtractFilePath(ParamStr(0))+'HighResPack') then
        ChDir('HighResPack'); }
      If (FileExists(EarthHRPath + 'land_ocean_ice_4096.jpg')) then
      begin
      end
      else
        showmessage(EarthHRPath + 'land_ocean_ice_4096.jpg' + ' lost HighRes');
      with GLMaterialLibrary do
      begin
        LoadHighResTexture(Materials[0],
          EarthHRPath + 'land_ocean_ice_4096.jpg');
        LoadHighResTexture(Materials[1],
          EarthHRPath + 'land_ocean_ice_lights_4096.jpg');
        LoadHighResTexture(Materials[2], EarthHRPath + 'moon_2048.jpg');
      end;
      if FileExists(EarthHRPath + 'Hipparcos_9.0.stars') then
      begin
        GLSkydome.Stars.Clear;
        GLSkydome.Stars.LoadStarsFile(EarthHRPath + 'Hipparcos_9.0.stars');
        GLSkydome.StructureChanged;
      end;
      GLSceneViewer.Buffer.AntiAliasing := aa2x;
    finally
      GLSceneViewer.Cursor := crDefault;
    end;
    highResResourcesLoaded := True;
  end;
  miHighResolution.Checked := highResResourcesLoaded;
end;

procedure TSpaceSceneFrm.miCountriesClick(Sender: TObject);
begin
  If FileExists(ShpPath + 'Country.dat') then
  begin
    miCountries.Checked := (not miCountries.Checked);
    DisplayCountries(miCountries.Checked)
  end
  else
    showmessage(ShpPath + 'Country.dat missing');
end;

{ ============================================================== }
procedure TSpaceSceneFrm.DisplayCountries(Show: Boolean);
Begin
  If (not Show) then
  begin { off }
    ShpLines.Visible := False;
  end;
  If (Show and CountriesLoaded) then
  begin { on }
    ShpLines.Visible := True;
  end;
  If (Show and (not CountriesLoaded)) then
  begin
    { ShapePath := ExtractFilePath(ParamStr(0)); }
    { ShpFileName := ShpPath+'Country.shp'; }
    ShpLines.Visible := True;
    If LoadCountryShapes then
    begin { on }

    end
    else
      ShpLines.Visible := False;
  end;
end;

function TSpaceSceneFrm.LoadCountryShapes: Boolean;
var
  INumparts, INumPoints, NumParts, NumPoints: Integer;
  winColor, i, Count: Integer;
  dXTemp, dYTemp: Double;
  pos2: TVector; // TAffineVector;
  ShapeFileOut: file of Double;
  ShapetypeD: Double;
  function GetCartesian(Longitude, Latitude, dRadius: single): TVector;
  // TAffineVector;//TVector;
  var
    ca, sa, co, so: single;
  begin
    SinCosine(DegToRadian(-Longitude - 90), so, co); // 90° offset
    SinCosine(DegToRadian(Latitude), sa, ca);
    Result.X := dRadius * co * ca;
    Result.Y := dRadius * sa;
    Result.Z := dRadius * so * ca;
  end;

begin
  GLSceneViewer.Cursor := crHourGlass;
  ShpLines.Nodes.Clear;
  winColor := CountryColorPanel.Color;
  /// ShpLines.LineColor:= ConvertWinColor(CountryColorPanel.Color);
  ShpLines.LineColor.Red := (winColor and $FF) * (1 / 255);
  ShpLines.LineColor.Green := ((winColor shr 8) and $FF) * (1 / 255);
  ShpLines.LineColor.Blue := ((winColor shr 16) and $FF) * (1 / 255);
  ShpLines.LineColor.Alpha := 1; // alpha;

  AssignFile(ShapeFileOut, ShpPath + 'Country.dat');
  Reset(ShapeFileOut);
  For i := 1 to 9 do
    Read(ShapeFileOut, ShapetypeD);

  Read(ShapeFileOut, ShapetypeD);
  Count := Trunc(ShapetypeD);

  For i := 1 to Count do
  begin
    Application.ProcessMessages;
    Read(ShapeFileOut, ShapetypeD);
    NumParts := Trunc(ShapetypeD);
    for INumparts := 1 to NumParts do
    begin { Always at least 1 0... }
      { Polygon.NewLine; }
      Read(ShapeFileOut, ShapetypeD);
      NumPoints := Trunc(ShapetypeD);
      for INumPoints := 1 to NumPoints do
      begin { 2 points internally }
        Read(ShapeFileOut, dXTemp);
        Read(ShapeFileOut, dYTemp);
        pos2 := GetCartesian(dXTemp { Longitude } , dYTemp { Latitude } ,
          SPEarth.Radius);
        ShpLines.AddNode(pos2);
      end; { INumPoints }
      ShpLines.Nodes.Last.AsVector := pos2;
    end; { INumparts }
    ShpLines.Nodes.Last.AsVector := pos2;
  end; { For ShapeToDo }
  CountriesLoaded := True;
  Result := True;
  GLSceneViewer.Cursor := crDefault;
  ShpPoints.StructureChanged;
end;

{ Load the Shape File ... then Process ALL the points of the Lines }
{ Function TEarthForm.LoadShapes:Boolean;
  begin
  GLSceneViewer.Cursor:=crHourGlass;
  If NewLayer then
  begin
  DVDORedraw;
  If (lowercase(ShpFileName) = lowercase(ShpPath+'Country.shp'))
  then CountriesLoaded:=True;
  If (lowercase(ShpFileName) = lowercase(ShpPath+'Cities.shp'))
  then CitiesLoaded:=True;
  If (lowercase(ShpFileName) = lowercase(ShpPath+'CAPITALS.SHP'))
  then CapitalsLoaded:=True;
  Result:=True;
  end else Result:=False;
  GLSceneViewer.Cursor:=crDefault;
  end; }

(*
  Function TEarthForm.NewLayer:Boolean;
  var gotloaded:Boolean;
  begin
  gotloaded:=False;
  Inc(LayersLoaded);
  CurrentLayer:=LayersLoaded;
  SetLength(LayA,LayersLoaded+1);{Trash the Zero layer in array}
  SetLength(LayersControlArray,LayersLoaded);
  LayersControlArray[(LayersLoaded-1)]:= LayersLoaded;
  If ShapeLoaderForm.LoadLayer then gotloaded:=True;
  If gotloaded then result:=gotloaded else
  begin
  {do something cause it failed loading}
  dec(LayersLoaded);
  CurrentLayer:=LayersLoaded;
  SetLength(LayA,LayersLoaded+1);
  SetLength(LayersControlArray,LayersLoaded);
  result:=gotloaded;
  ShowMessage('Error loading Shape (*.shp) file');
  end;
  end; *)
{ ============================================================== }
{ Text X,Y =recompute; if 'set' rescale then recompute }
(*
  procedure TEarthForm.DVDORedraw;
  var
  PointType,winColor,winPointColor : Integer;
  LayerDo, Startat,
  INumparts,  INumPoints,
  ShapeType, ShapeToDo,
  NumShape, NumParts, NumPoints : integer;
  dXTemp,dYTemp:Double;
  pos2 :TVector;// TAffineVector;
  function GetCartesian(Longitude,Latitude,dRadius:single):TVector;//TAffineVector;//TVector;
  var
  ca,sa,co,so	:single;
  begin
  SinCos(DegToRad(-Longitude-90),so,co); // 90° offset
  SinCos(DegToRad(Latitude),sa,ca);
  Result[0]:=dRadius*co*ca;
  Result[1]:=dRadius*sa;
  Result[2]:=dRadius*so*ca;
  end;
  begin
  If LayersLoaded>0 then
  Begin
  ShpLines.Nodes.Clear;
  ShpPoints.Positions.Clear;
  ShpPoints.Colors.Clear;
  ShpCapPoints.Positions.Clear;
  ShpCapPoints.Colors.Clear;

  winColor:=CountryColorPanel.Color;
  {ShpLines.LineColor:= ConvertWinColor(CountryColorPanel.Color);}
  ShpLines.LineColor.Red:=(winColor and $FF)*(1/255);
  ShpLines.LineColor.Green:=((winColor shr 8) and $FF)*(1/255);
  ShpLines.LineColor.Blue:=((winColor shr 16) and $FF)*(1/255);
  ShpLines.LineColor.Alpha:=1;//alpha;

  { Bitwise line pattern.   
  For instance $FFFF (65535) is a white line (stipple disabled),
  $0000 is a black line,
  $CCCC is the stipple used in axes and dummycube, etc. }
  {property LinePattern: TGLushort read FLinePattern write SetLinePattern default $FFFF;}

  For Startat:=0 to LayersLoaded-1 do
  Begin
  LayerDo:=LayersControlArray[Startat];
  ShapeType:= LayA[LayerDo].ShpType;
  NumShape:= LayA[LayerDo].ShapeN;
  If lowercase(LayA[Startat+1].Filename) =lowercase('CAPITALS.SHP') then
  begin
  PointType:=0;
  winPointColor:=CapitolPanel.Color;
  end else
  begin
  PointType:=1;
  winPointColor:=CityPanel.Color;
  end;
  If ((ShapeType=1) or(ShapeType=11) or(ShapeType=21)) then
  begin
  {CurrentPointType:=LayA[LayerDo].CurrentPointType;
  PointSize:=LayA[LayerDo].PointSize;}
  For ShapeToDo:=1 to NumShape do
  Begin
  dXTemp:=LayA[LayerDo].LyrShp[ShapeToDo].XMax;
  dYTemp:=LayA[LayerDo].LyrShp[ShapeToDo].YMax;
  pos2:=GetCartesian(dXTemp{Longitude},dYTemp{Latitude},spEarth.Radius);
  If PointType=0 then
  begin
  ShpCapPoints.Positions.Add(pos2);
  ShpCapPoints.Colors.Add(ConvertWinColor(winPointColor));
  end else
  begin
  ShpPoints.Positions.Add(pos2);
  ShpPoints.Colors.Add(ConvertWinColor(winPointColor));
  end;
  end;
  end else
  If ((ShapeType=5) or (ShapeType=15) or (ShapeType=25) )then
  begin
  {New Polygon ..Line change Color}
  For ShapeToDo:=1 to NumShape do
  Begin
  Application.ProcessMessages;
  Numparts:=LayA[LayerDo].LyrShp[ShapeToDo].PartsN;{Numparts}
  for INumparts := 1 to Numparts do
  begin {Always at least 1 0...}
  {Polygon.NewLine; }
  NumPoints:=LayA[LayerDo].LyrShp[ShapeToDo].PPA[INumparts];
  for INumPoints := 1 to NumPoints do
  begin {2 points internally}
  dXTemp:=LayA[LayerDo].LyrShp[ShapeToDo].PARA[INumparts].PA[INumPoints].Xd;
  dYTemp:=LayA[LayerDo].LyrShp[ShapeToDo].PARA[INumparts].PA[INumPoints].Yd;
  pos2:=GetCartesian(dXTemp{Longitude},dYTemp{Latitude},spEarth.Radius);
  ShpLines.AddNode(pos2);
  end;{INumPoints}
  ShpLines.Nodes.Last.AsVector:=pos2;
  end;{INumparts}
  ShpLines.Nodes.Last.AsVector:=pos2;
  end; {For ShapeToDo}
  ShpLines.Nodes.Last.AsVector:=pos2;
  end;{LayerDo ShapeType}
  end;{CurrentLayer for each layer}
  ShpLines.StructureChanged;
  ShpPoints.StructureChanged;
  ShpCapPoints.StructureChanged;
  end;{Any Layers ?}
  End; *)
{ ============================================================== }
{ CAPITALS.SHP }
{ ============================================================== }
procedure TSpaceSceneFrm.miShowCapitalsClick(Sender: TObject);
begin
  If FileExists(ShpPath + 'CAPITALS.dat') then
  begin
    miShowCapitals.Checked := (not miShowCapitals.Checked);
    DisplayCapitals(miShowCapitals.Checked)
  end
  else
    showmessage(ShpPath + 'CAPITALS.dat missing');
end;

procedure TSpaceSceneFrm.DisplayCapitals(Show: Boolean);
Begin
  If (not Show) then
  begin { off }
    ShpCapPoints.Visible := False;
  end;
  If (Show and CapitalsLoaded) then
  begin { on }
    ShpCapPoints.Visible := True;
  end;
  If (Show and (not CapitalsLoaded)) then
  begin
    { ShapePath := ExtractFilePath(ParamStr(0)); }
    { ShpFileName := ShpPath+'CAPITALS.dat'; }
    ShpCapPoints.Visible := True;
    If LoadCapitalShapes then
    begin { on }

    end
    else
      ShpCapPoints.Visible := False;
  end;
end;

Function TSpaceSceneFrm.LoadCapitalShapes: Boolean;
var
  i, Count, winPointColor: Integer;
  dXTemp, dYTemp: Double;
  pos2: TVector; // TAffineVector;
  ShapeFileOut: file of Double;
  ShapetypeD: Double;
  function GetCartesian(Longitude, Latitude, dRadius: single): TVector;
  // TAffineVector;//TVector;
  var
    ca, sa, co, so: single;
  begin
    SinCosine(DegToRadian(-Longitude - 90), so, co); // 90° offset
    SinCosine(DegToRadian(Latitude), sa, ca);
    Result.X := dRadius * co * ca;
    Result.Y := dRadius * sa;
    Result.Z := dRadius * so * ca;
  end;

Begin
  GLSceneViewer.Cursor := crHourGlass;
  { Result:=False; }
  ShpCapPoints.Positions.Clear;
  ShpCapPoints.Colors.Clear;
  winPointColor := CapitolPanel.Color;
  AssignFile(ShapeFileOut, ShpPath + 'CAPITALS.dat');
  Reset(ShapeFileOut);
  For i := 1 to 9 do
    Read(ShapeFileOut, ShapetypeD);
  Read(ShapeFileOut, ShapetypeD);
  Count := Trunc(ShapetypeD);

  For i := 1 to Count do
  Begin
    Read(ShapeFileOut, dXTemp);
    Read(ShapeFileOut, dYTemp);
    { dXTemp:=LayA[LayerDo].LyrShp[ShapeToDo].XMax;
      dYTemp:=LayA[LayerDo].LyrShp[ShapeToDo].YMax; }
    pos2 := GetCartesian(dXTemp { Longitude } , dYTemp { Latitude } ,
      SPEarth.Radius);
    ShpCapPoints.Positions.Add(pos2);
    ShpCapPoints.Colors.Add(ConvertWinColor(winPointColor));
  end;

  CapitalsLoaded := True;
  Result := True;
  GLSceneViewer.Cursor := crDefault;
  ShpCapPoints.StructureChanged;
end;

procedure TSpaceSceneFrm.miShowCitiesClick(Sender: TObject);
begin
  If FileExists(ShpPath + 'Cities.dat') then
  begin
    miShowCities.Checked := (not miShowCities.Checked);
    DisplayCities(miShowCities.Checked)
  end
  else
    showmessage(ShpPath + 'Cities.dat missing');
end;

procedure TSpaceSceneFrm.DisplayCities(Show: Boolean);
Begin
  If (not Show) then
  begin { off }
    ShpPoints.Visible := False;
  end;
  If (Show and CitiesLoaded) then
  begin { on }
    ShpPoints.Visible := True;
  end;
  If (Show and (not CitiesLoaded)) then
  begin
    { ShapePath := ExtractFilePath(ParamStr(0)); }
    { ShpFileName := ShpPath+'Cities.shp'; }
    ShpPoints.Visible := True;
    If LoadCityShapes then
    begin { on }

    end
    else
      ShpPoints.Visible := False;
  end;
end;

function TSpaceSceneFrm.LoadCityShapes: Boolean;
var
  i, Count, winPointColor: Integer;
  dXTemp, dYTemp: Double;
  pos2: TVector; // TAffineVector;
  ShapeFileOut: file of Double;
  ShapetypeD: Double;
  function GetCartesian(Longitude, Latitude, dRadius: single): TVector;
  // TAffineVector;//TVector;
  var
    ca, sa, co, so: single;
  begin
    SinCosine(DegToRadian(-Longitude - 90), so, co); // 90° offset
    SinCosine(DegToRadian(Latitude), sa, ca);
    Result.X := dRadius * co * ca;
    Result.Y := dRadius * sa;
    Result.Z := dRadius * so * ca;
  end;

Begin
  GLSceneViewer.Cursor := crHourGlass;
  ShpPoints.Positions.Clear;
  ShpPoints.Colors.Clear;
  winPointColor := CityPanel.Color;
  AssignFile(ShapeFileOut, ShpPath + 'Cities.dat');
  Reset(ShapeFileOut);
  For i := 1 to 9 do
    Read(ShapeFileOut, ShapetypeD);
  Read(ShapeFileOut, ShapetypeD);
  Count := Trunc(ShapetypeD);

  For i := 1 to Count do
  Begin
    Read(ShapeFileOut, dXTemp);
    Read(ShapeFileOut, dYTemp);
    { dXTemp:=LayA[LayerDo].LyrShp[ShapeToDo].XMax;
      dYTemp:=LayA[LayerDo].LyrShp[ShapeToDo].YMax; }
    pos2 := GetCartesian(dXTemp { Longitude } , dYTemp { Latitude } ,
      SPEarth.Radius);
    ShpPoints.Positions.Add(pos2);
    ShpPoints.Colors.Add(ConvertWinColor(winPointColor));
  end;
  CitiesLoaded := True;
  Result := True;
  GLSceneViewer.Cursor := crDefault;
  ShpPoints.StructureChanged;
end;

{ ============================================================== }
procedure TSpaceSceneFrm.miGLSTemporalFlowClick(Sender: TObject);
begin
  miGLSTemporalFlow.Checked := (not miGLSTemporalFlow.Checked);
  FlowTimer.Enabled := miGLSTemporalFlow.Checked;
  If miGLSTemporalFlow.Checked then
  begin
    markersCounted := 0;
    MarkersDisplaySelection := 4; // 35065	1/1/1996 12:00 am
    TemporalFlowDateTime := 35430; { Date Mike Liscke started GLS ? }
    DrawPoints;
  end
  else
  begin
    MarkersDisplaySelection := ChoiceRG.ItemIndex;
  end;
end;

procedure TSpaceSceneFrm.FlowTimerTimer(Sender: TObject);
begin
  { Every 'Unit' of time Cycle the display according to GLS Start Date
    All Off .. Mike Liscke.. Roger Cao ..turn On according to Date }
  { Every 5 seconds...TDateTime number of days }
  TemporalFlowDateTime := TemporalFlowDateTime + 123;
  DrawPoints;
  If TemporalFlowDateTime > Now then
  begin
    ChoiceRG.ItemIndex := 0;
    miGLSTemporalFlow.Checked := False;
    FlowTimer.Enabled := miGLSTemporalFlow.Checked;
    MarkersDisplaySelection := 0;
  end;
end;

procedure TSpaceSceneFrm.miColorAlltheSameClick(Sender: TObject);
begin
  miColorAlltheSame.Checked := (not miColorAlltheSame.Checked);
  ColorAlltheSame := miColorAlltheSame.Checked;
  DrawPoints;
end;

{ ============================================================== }
// Tools
{ ============================================================== }
procedure TSpaceSceneFrm.miDisplayToolBarClick(Sender: TObject);
begin
  miDisplayToolBar.Checked := (not miDisplayToolBar.Checked);
  If miDisplayToolBar.Checked then
  begin
    GLSceneViewer.Align := alNone;
    Splitter1.Visible := True;
    MemberGB.Visible := True;
    MemberGB.Align := alLeft;
    GLSceneViewer.Align := alClient;
  end
  else
  begin
    GLSceneViewer.Align := alNone;
    MemberGB.Align := alNone;
    Splitter1.Visible := False;
    MemberGB.Visible := False;
    GLSceneViewer.Align := alClient;
  end;
end;

procedure TSpaceSceneFrm.miABCreatorClick(Sender: TObject);
begin
   Timer.Enabled:=False;
    GLCadencer.Enabled:=False;
    ABCreatorFrm.ShowModal;
    Timer.Enabled:=True;
    GLCadencer.Enabled:=True;
  If FileExists(AppPath + 'EarthAbcde.exe') then
    ShellExecute(0, 'open', PChar(AppPath + 'EarthAbcde.exe'), '', '', SW_SHOW);
end;

procedure TSpaceSceneFrm.miViewerClick(Sender: TObject);
begin
  Timer.Enabled := False;
  GLCadencer.Enabled := False;
  GLSViewerFrm.ShowModal;
  Timer.Enabled := True;
  GLCadencer.Enabled := True;
  (* GLSViewerFrm in 'GLSViewerFrm.pas' {GLSViewerForm},
    GLFileSTL in 'GLFileSTL.pas',
    GlsSmdQcFrm in 'GlsSmdQcFrm.pas' {GlsSmdQcForm},
    GlsSmdLoadMdlFrm in 'GlsSmdLoadMdlFrm.pas' {GlsSmdLoadMdlForm},
    USMDStuff in 'USMDStuff.pas'; *)
end;

procedure TSpaceSceneFrm.miSmdQcClick(Sender: TObject);
begin
  Timer.Enabled := False;
  GLCadencer.Enabled := False;
  GlsSmdQcFrm.ShowModal;
  Timer.Enabled := True;
  GLCadencer.Enabled := True;
end;

procedure TSpaceSceneFrm.miMdlQcClick(Sender: TObject);
begin
  Timer.Enabled := False;
  GLCadencer.Enabled := False;
  GlsLoadSmdMdlFrm.ShowModal;
  Timer.Enabled := True;
  GLCadencer.Enabled := True;
end;

procedure TSpaceSceneFrm.miMetadataClick(Sender: TObject);
begin
  Timer.Enabled := False;
  GLCadencer.Enabled := False;
  MeshShowFrm.ShowModal;
  Timer.Enabled := True;
  GLCadencer.Enabled := True;
end;

{ ============================================================== }
procedure TSpaceSceneFrm.miContentsClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTENTS, 0);
end;

procedure TSpaceSceneFrm.miOnHelpClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_HELPONHELP, 0);
end;

procedure TSpaceSceneFrm.miAboutClick(Sender: TObject);
begin
  ShowMessage('A freeware program based on Earth Advdemo...'#13#10#13#10 +
              'to shows GLScene users and developers around the world!');
end;

{ ============================================================== }
procedure TSpaceSceneFrm.ChoiceRGClick(Sender: TObject);
begin
  MarkersDisplaySelection := ChoiceRG.ItemIndex;
  { Allows turning it Off ,,
    changing the Person will Display it
    NO MATTER WHAT the Display Selection }
  { If (MarkersDisplaySelection=3) then
    ptsFlashLocations.Visible:=True else }
  ptsFlashLocations.Visible := False;
  GlsGlowLF.Visible := False;
  DrawPoints;
  { ChoiceRG.Itemindex  MarkersDisplaySelection
    TemporalFlowDateTime }
end;

procedure TSpaceSceneFrm.cbTypesChange(Sender: TObject);
begin
  DrawPoints; // cbTypes
end;

procedure TSpaceSceneFrm.DateTimePicker1Change(Sender: TObject);
begin
  DrawPoints; // redraw points based on new date constraint
end;

procedure TSpaceSceneFrm.NameCBChange(Sender: TObject);
var
  i: Integer;
begin
  ptsFlashLocations.Visible := miSelectedSatellite.Checked;
  { ptsFlashLocations.Visible:= miSatelliteLight.Checked; }
  { ptsFlashLocations.Visible:=True; }
  { Load all the data into labels }
  for i := 0 to markers.Count - 1 do
  begin
    if (TMarkerPosition(markers.Objects[i]).Name = NameCB.Items
      [NameCB.ItemIndex]) then
    begin
      cbTypes.ItemIndex := TMarkerPosition(markers.Objects[i]).membertype;
      lblNickname.Caption := TMarkerPosition(markers.Objects[i]).NickName;
      LblCountry.Caption := TMarkerPosition(markers.Objects[i]).Country;
      lblState.Caption := TMarkerPosition(markers.Objects[i]).State;
      LblCity.Caption := TMarkerPosition(markers.Objects[i]).City;
      lblPhotoName.Caption := TMarkerPosition(markers.Objects[i]).Photo;
      If PhotoCB.Checked and FileExists(EarthPhotoPath + lblPhotoName.Caption)
      then
      begin
        PhotoImage.Visible := True;
        PhotoImage.Picture.LoadFromFile(EarthPhotoPath + lblPhotoName.Caption);
        Memo1.Align := alNone;
        Memo1.Visible := False;
      end
      else
      begin
        PhotoImage.Visible := False;
        Memo1.Visible := True;
        Memo1.Align := alBottom;
      end;
      LblWebUrl.Caption := TMarkerPosition(markers.Objects[i]).Url;
      lblEMail.Caption := TMarkerPosition(markers.Objects[i]).EMail;
      Case TMarkerPosition(markers.Objects[i]).membertype of
        1: lblType.Caption := 'GLS Developer';
        2: lblType.Caption := 'Content Creator';
        3: lblType.Caption := 'Game Developer: FPS';
        4: lblType.Caption := 'Game Developer: RTS Sim';
        5: lblType.Caption := 'VR Simulation';
        6: lblType.Caption := 'Scientific Visualization';
        7: lblType.Caption := 'Others';
      else
        lblType.Caption := 'Undecided Dabbler';
      end; { Case }
      lblTypeName.Caption := TMarkerPosition(markers.Objects[i]).TypeName;
      GlowUpDown.Position := TMarkerPosition(markers.Objects[i]).Glow;
      { ptsSizeUpDown.Position:=TMarkerPosition(markers.Objects[i]).Glow; }
      ptsFlashLocations.Size := ptsSizeUpDown.Position;
      GlsGlowLF.Size := GlowUpDown.Position;
      lblGLSGlow.Caption := IntToStr(TMarkerPosition(markers.Objects[i]).Glow);
      lblDobDate.Caption := DateToStr(TMarkerPosition(markers.Objects[i]
        ).DateDOB);
      lblGLSDate.Caption := DateToStr(TMarkerPosition(markers.Objects[i])
        .DateAdded);
      lblDemoName.Caption := TMarkerPosition(markers.Objects[i]).DemoName;
      Memo1.Clear;
      Memo1.Text := TMarkerPosition(markers.Objects[i]).Description;
      // Display the 'Majic Marker' for the selected person
      { Latitude := Lat;     Longitude := Lon; }
      ptsFlashLocations.Positions.Clear;
      ptsFlashLocations.Colors.Clear;
      If ColorAlltheSame then
        ptsFlashLocations.Colors.Add(ConvertWinColor(PeopleColorPanel.Color))
      else If (TMarkerPosition(markers.Objects[i]).membertype > ColorIndex) then
        ptsFlashLocations.Colors.Add(DotColorArray[3])
      else
        ptsFlashLocations.Colors.Add
          (DotColorArray[TMarkerPosition(markers.Objects[i]).membertype]);

      ptsFlashLocations.Positions.Add(TMarkerPosition(markers.Objects[i])
        .GetCartesian(SPEarth.Radius));
      { Lensflare Z test OFF }
      { +(ptsFlashLocations.Size/1000) }
      GlsGlowLF.Position.X := TMarkerPosition(markers.Objects[i])
        .GetCartesian(SPEarth.Radius { +0.1 } ).X;
      GlsGlowLF.Position.Y := TMarkerPosition(markers.Objects[i])
        .GetCartesian(SPEarth.Radius { +0.1 } ).Y;
      GlsGlowLF.Position.Z := TMarkerPosition(markers.Objects[i])
        .GetCartesian(SPEarth.Radius { +0.1 } ).Z;
      If (miSelectedSatellite.Checked and miSatelliteLight.Checked) then
        GlsGlowLF.Visible := True
      else
        GlsGlowLF.Visible := False;
    end;
  end;
  DrawPoints; { NameCB }
end;

{ ============================================================== }
procedure TSpaceSceneFrm.CountryColorPanelClick(Sender: TObject);
begin
  ColorDialog.Color := CountryColorPanel.Color;
  if ColorDialog.Execute then
    CountryColorPanel.Color := ColorDialog.Color;
  Application.ProcessMessages; // hide the dialog
  If CountriesLoaded then
    LoadCountryShapes; // DVDORedraw;
end;

procedure TSpaceSceneFrm.CapitolPanelClick(Sender: TObject);
begin
  ColorDialog.Color := CapitolPanel.Color;
  if ColorDialog.Execute then
    CapitolPanel.Color := ColorDialog.Color;
  Application.ProcessMessages; { hide the dialog }
  If CapitalsLoaded then
    LoadCapitalShapes; // DVDORedraw;
end;

procedure TSpaceSceneFrm.CityPanelClick(Sender: TObject);
begin
  ColorDialog.Color := CityPanel.Color;
  if ColorDialog.Execute then
    CityPanel.Color := ColorDialog.Color;
  Application.ProcessMessages; { hide the dialog }
  If CitiesLoaded then
    LoadCityShapes; // DVDORedraw;
end;

procedure TSpaceSceneFrm.PeopleColorPanelClick(Sender: TObject);
begin
  ColorDialog.Color := PeopleColorPanel.Color;
  if ColorDialog.Execute then
  begin
    PeopleColorPanel.Color := ColorDialog.Color;
    DrawPoints;
  end;
end;

procedure TSpaceSceneFrm.lblEMailClick(Sender: TObject);
begin
  ShellExecute(0, 'open', PChar('mailto:' + lblEMail.Caption), '', '', SW_SHOW);
end;

procedure TSpaceSceneFrm.LblWebUrlClick(Sender: TObject);
begin
  ShellExecute(0, 'open', PChar(LblWebUrl.Caption), '', '', SW_SHOW);
end;

procedure TSpaceSceneFrm.lblPhotoNameClick(Sender: TObject);
begin
  ShellExecute(0, 'open', PChar(lblPhotoName.Caption), '', '', SW_SHOW);
end;

procedure TSpaceSceneFrm.lblDemoNameClick(Sender: TObject);
begin
  ShellExecute(0, 'open', PChar(lblDemoName.Caption), '', '', SW_SHOW);
end;

procedure TSpaceSceneFrm.GlowUpDownClick(Sender: TObject; Button: TUDBtnType);
begin
  { If (Button = btNext) then
    (ptsFlashLocations.Size:=ptsFlashLocations.Size+1 ) else
    (ptsFlashLocations.Size:=ptsFlashLocations.Size-1 );
    If ptsFlashLocations.Size < 10 then
    ptsFlashLocations.Size:=10; }
  GlsGlowLF.Size := GlowUpDown.Position;
end;

{ ============================================================== }
procedure TSpaceSceneFrm.ptsSizeUpDownClick(Sender: TObject; Button: TUDBtnType);
begin
  ptsFlashLocations.Size := ptsSizeUpDown.Position;
end;


end.
