unit FGLSViewer;

interface

uses
  WinApi.Windows,
  WinApi.Messages,
  WinApi.OpenGL,
  System.SysUtils,
  System.Classes,
  System.Actions,
  System.Types,
  System.Win.Registry,
  System.ImageList,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.ExtCtrls,
  Vcl.ExtDlgs,
  Vcl.ImgList,
  Vcl.ActnList,
  Vcl.Menus,
  Vcl.ComCtrls,
  Vcl.ToolWin,

  GLCadencer,
  GLTexture,
  GLScene,
  GLObjects,
  GLVectorTypes,
  GLVectorFileObjects,
  GLWin32Viewer,
  GLState,
  GLVectorGeometry,
  GLContext,
  GLVectorLists,
  GLMaterial,
  GLCoordinates,
  GLCrossPlatform,
  GLBaseClasses;

type
  TGLSViewerFrm = class(TForm)
    MainMenu: TMainMenu;
    ActionList: TActionList;
    ImageList: TImageList;
    ToolBar: TToolBar;
    MIFile: TMenuItem;
    ACOpen: TAction;
    ACExit: TAction;
    Open1: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    ToolButton1: TToolButton;
    StatusBar: TStatusBar;
    GLSceneViewer: TGLSceneViewer;
    GLScene: TGLScene;
    MIOptions: TMenuItem;
    MIAntiAlias: TMenuItem;
    MIAADefault: TMenuItem;
    MIAA2x: TMenuItem;
    MIAA4X: TMenuItem;
    ACSaveAs: TAction;
    ACZoomIn: TAction;
    ACZoomOut: TAction;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    MIView: TMenuItem;
    ZoomIn1: TMenuItem;
    ZoomOut1: TMenuItem;
    FreeForm: TGLFreeForm;
    OpenDialog: TOpenDialog;
    GLLightSource: TGLLightSource;
    GLMaterialLibrary: TGLMaterialLibrary;
    CubeExtents: TGLCube;
    ACResetView: TAction;
    Resetview1: TMenuItem;
    ToolButton5: TToolButton;
    ACShadeSmooth: TAction;
    ACFlatShading: TAction;
    ACWireframe: TAction;
    ACHiddenLines: TAction;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    N2: TMenuItem;
    Smoothshading1: TMenuItem;
    Flatshading1: TMenuItem;
    Hiddenlines1: TMenuItem;
    Wireframe1: TMenuItem;
    ToolButton10: TToolButton;
    ACCullFace: TAction;
    Faceculling1: TMenuItem;
    N3: TMenuItem;
    MIBgColor: TMenuItem;
    ColorDialog: TColorDialog;
    MITexturing: TMenuItem;
    ACTexturing: TAction;
    ToolButton11: TToolButton;
    ToolButton12: TToolButton;
    OpenPictureDialog: TOpenPictureDialog;
    MIPickTexture: TMenuItem;
    DCTarget: TGLDummyCube;
    GLCamera: TGLCamera;
    DCAxis: TGLDummyCube;
    ACFlatLined: TAction;
    ToolButton13: TToolButton;
    FlatShadingwithlines1: TMenuItem;
    ACInvertNormals: TAction;
    MIActions: TMenuItem;
    InvertNormals1: TMenuItem;
    Saveas1: TMenuItem;
    SaveDialog: TSaveDialog;
    ACReverseRenderingOrder: TAction;
    ReverseRenderingOrder1: TMenuItem;
    ACConvertToIndexedTriangles: TAction;
    ConverttoIndexedTriangles1: TMenuItem;
    ACFPS: TAction;
    FramesPerSecond1: TMenuItem;
    GLCadencer: TGLCadencer;
    Timer: TTimer;
    GLLightmapLibrary: TGLMaterialLibrary;
    ACSaveTextures: TAction;
    SDTextures: TSaveDialog;
    Savetextures1: TMenuItem;
    MIOpenTexLib: TMenuItem;
    ODTextures: TOpenDialog;
    Mesh1: TMenuItem;
    Optimize1: TMenuItem;
    N4: TMenuItem;
    N6: TMenuItem;
    AmbientLight1: TMenuItem;
    AxisBounds1: TMenuItem;
    FreeLook1: TMenuItem;
    N7: TMenuItem;
    ScaleObject1: TMenuItem;
    LightMapMaker1: TMenuItem;
    About1: TMenuItem;
    Help1: TMenuItem;
    procedure MIAboutClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ACOpenExecute(Sender: TObject);
    procedure GLSceneViewerMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure GLSceneViewerMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure GLSceneViewerMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ACZoomInExecute(Sender: TObject);
    procedure ACZoomOutExecute(Sender: TObject);
    procedure ACExitExecute(Sender: TObject);
    procedure ACShadeSmoothExecute(Sender: TObject);
    procedure GLSceneViewerBeforeRender(Sender: TObject);
    procedure MIAADefaultClick(Sender: TObject);
    procedure GLSceneViewerAfterRender(Sender: TObject);
    procedure ACResetViewExecute(Sender: TObject);
    procedure ACCullFaceExecute(Sender: TObject);
    procedure MIBgColorClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure GLMaterialLibraryTextureNeeded(Sender: TObject;
      var textureFileName: String);
    procedure ACTexturingExecute(Sender: TObject);
    procedure MIPickTextureClick(Sender: TObject);
    procedure MIFileClick(Sender: TObject);
    procedure ACInvertNormalsExecute(Sender: TObject);
    procedure ACSaveAsExecute(Sender: TObject);
    procedure ACSaveAsUpdate(Sender: TObject);
    procedure ACReverseRenderingOrderExecute(Sender: TObject);
    procedure ACConvertToIndexedTrianglesExecute(Sender: TObject);
    procedure GLCadencerProgress(Sender: TObject;
      const deltaTime, newTime: Double);
    procedure ACFPSExecute(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure ACSaveTexturesExecute(Sender: TObject);
    procedure MIOpenTexLibClick(Sender: TObject);

    procedure AllBtnsUp;
    procedure Smoothshading1Click(Sender: TObject);
    procedure Flatshading1Click(Sender: TObject);

    procedure Hiddenlines1Click(Sender: TObject);
    procedure Wireframe1Click(Sender: TObject);
    procedure FlatShadingwithlines1Click(Sender: TObject);
    procedure LightMapMaker1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure About1Click(Sender: TObject);
  private
     
    procedure DoResetCamera;
    procedure ApplyShadeModeToMaterial(aMaterial: TGLMaterial);
    procedure ApplyShadeMode;
    procedure ApplyFSAA;
    procedure ApplyFaceCull;
    procedure ApplyBgColor;
    procedure ApplyTexturing;
    procedure ApplyFPS;

    procedure DoOpen(const fileName: String);

  public
     
    md, nthShow: Boolean;
    mx, my: Integer;
    hlShader: TGLShader;
    lastFileName: String;
    lastLoadWithTextures: Boolean;
  end;

var
  GLSViewerFrm: TGLSViewerFrm;

implementation

{$R *.dfm}

uses
  GLKeyBoard, {GraphicEx,} GLPersistentClasses, GLMeshUtils,
  GLFileOBJ, GLFileSTL, GLFileLWO, GLFileQ3BSP, GLFileOCT, GLFileMS3D,
  GLFileNMF, GLFileMD3, GLFile3DS, GLFileMD2, GLFileSMD, GLFileTIN,
  GLFilePLY, GLFileGTS, GLMeshOptimizer, GLColor, GLRenderContextInfo,
  uGlobals;

type

  // Hidden line shader (specific implem for the viewer, *not* generic)
  THiddenLineShader = class(TGLShader)
  private
    LinesColor: TColorVector;
    BackgroundColor: TColorVector;
    PassCount: Integer;
  public
    procedure DoApply(var rci: TGLRenderContextInfo; Sender: TObject); override;
    function DoUnApply(var rci: TGLRenderContextInfo): Boolean; override;
  end;

procedure THiddenLineShader.DoApply(var rci: TGLRenderContextInfo;
  Sender: TObject);
begin
  PassCount := 1;
  rci.GLStates.PolygonMode := pmFill; // (GL_FRONT_AND_BACK, GL_FILL);
  glPushAttrib(GL_ENABLE_BIT);
  glPushAttrib(GL_CURRENT_BIT + GL_ENABLE_BIT);
  glColor3fv(@BackgroundColor);
  glDisable(GL_TEXTURE_2D);
  glEnable(GL_POLYGON_OFFSET_FILL);
  glPolygonOffset(1, 2);
end;

function THiddenLineShader.DoUnApply(var rci: TGLRenderContextInfo): Boolean;
begin
  case PassCount of
    1:
      begin
        PassCount := 2;
        rci.GLStates.PolygonMode := pmFill; // (GL_FRONT_AND_BACK, GL_LINE);
        glPopAttrib;
        glColor3fv(@LinesColor);
        glDisable(GL_LIGHTING);
        Result := True;
      end;
    2:
      begin
        glPopAttrib;
        Result := False;
      end;
  else
    // doesn't hurt to be cautious
    Assert(False);
    Result := False;
  end;
end;

procedure TGLSViewerFrm.FormCreate(Sender: TObject);
(* var
  reg : TRegistry;
  shellCmd : String;
  keyOkay : Boolean;
  const
  cKeyName : String = 'Applications\GLSViewer1.exe\shell\open\command';
  cFriendlyKeyName : String = 'Applications\GLSViewer1.exe'; *)
begin
  top := GLSViewerFormY;
  left := GLSViewerFormX;
  // instantiate our specific hidden-lines shader
  hlShader := THiddenLineShader.Create(Self);

  FreeForm.IgnoreMissingTextures := True;
  // register as an application that handles arbitrary file classes
  (* try
    reg:=TRegistry.Create;
    try
    shellCmd:='"'+ParamStr(0)+'" "%1"';
    reg.RootKey:=HKEY_CLASSES_ROOT;
    keyOkay:=False;
    if reg.OpenKeyReadOnly(cKeyName) then
    keyOkay:=(reg.ReadString('')=shellCmd);
    if not keyOkay then begin
    reg.CloseKey;
    if reg.OpenKey(cKeyName, True) then
    reg.WriteString('', shellCmd);
    reg.CloseKey;
    if reg.OpenKey(cFriendlyKeyName, True) then
    reg.WriteString('FriendlyAppName', 'GLSViewer1, OpenGL 3D Files Viewer');
    end;
    finally
    reg.Free;
    end;
    except
    // ignore all registry issues (not critical)
    end; *)
end;

procedure TGLSViewerFrm.ACExitExecute(Sender: TObject);
begin
  Close;
end;

procedure TGLSViewerFrm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ACFPS.Checked := False;
  ApplyFPS;
  GLSViewerFormY := GLSViewerFrm.top;
  GLSViewerFormX := GLSViewerFrm.left;
end;

procedure TGLSViewerFrm.FormShow(Sender: TObject);
var
  i: Integer;
begin
  if not nthShow then
  begin
    OpenDialog.Filter := VectorFileFormatsFilter;
    SaveDialog.Filter := VectorFileFormatsSaveFilter;
    with ActionList do
      for i := 0 to ActionCount - 1 do
        if Actions[i] is TCustomAction then
          with TCustomAction(Actions[i]) do
            Hint := Caption;
    ApplyFSAA;
    ApplyFaceCull;
    ApplyBgColor;

    if ParamCount > 0 then
      DoOpen(ParamStr(1));
    nthShow := True;
  end;
end;

procedure TGLSViewerFrm.GLSceneViewerBeforeRender(Sender: TObject);
begin
  THiddenLineShader(hlShader).LinesColor := VectorMake(107 / 256, 123 / 256,
    173 / 256, 1);
  THiddenLineShader(hlShader).BackgroundColor :=
    ConvertWinColor(GLSceneViewer.Buffer.BackgroundColor);
{
  if not GL_ARB_multisample then
  begin
    MIAADefault.Checked := True;
    MIAA2x.Enabled := False;
    MIAA4X.Enabled := False;
  end;
}
end;

procedure TGLSViewerFrm.GLSceneViewerAfterRender(Sender: TObject);
begin
  ApplyFSAA;
  Screen.Cursor := crDefault;
end;

procedure TGLSViewerFrm.MIAboutClick(Sender: TObject);
begin
  Application.HelpContext(4000);
end;

procedure TGLSViewerFrm.About1Click(Sender: TObject);
begin
  ShowMessage('GLSViewer - Simple OpenGL Mesh Viewer'#13#10 +
    'A freeware Delphi program based on...'#13#10#13#10 +
    'GLScene: 3D view, 3D file formats support'#13#10 +
    'http://glscene.org');
end;

procedure TGLSViewerFrm.DoResetCamera;
var
  objSize: Single;
begin
  DCTarget.Position.AsVector := NullHmgPoint;
  GLCamera.Position.SetPoint(7, 3, 5);
  FreeForm.Position.AsVector := NullHmgPoint;
  FreeForm.Up.Assign(DCAxis.Up);
  FreeForm.Direction.Assign(DCAxis.Direction);

  objSize := FreeForm.BoundingSphereRadius;
  StatusBar.Panels[3].Text := floattostr(objSize);
  if objSize > 0 then
  begin
    if objSize < 1 then
    begin
      GLCamera.SceneScale := 1 / objSize;
      objSize := 1;
    end
    else
      GLCamera.SceneScale := 1;
    GLCamera.AdjustDistanceToTarget(objSize * 0.27);
    GLCamera.DepthOfView := 1.5 * GLCamera.DistanceToTarget + 2 * objSize;
  end;
end;

procedure TGLSViewerFrm.ApplyShadeModeToMaterial(aMaterial: TGLMaterial);
begin
  with aMaterial do
  begin
    if ACShadeSmooth.Checked then
    begin
      GLSceneViewer.Buffer.Lighting := True;
      GLSceneViewer.Buffer.ShadeModel := smSmooth;
      aMaterial.PolygonMode := pmFill;
    end
    else if ACFlatShading.Checked then
    begin
      GLSceneViewer.Buffer.Lighting := True;
      GLSceneViewer.Buffer.ShadeModel := smFlat;
      aMaterial.PolygonMode := pmFill;
    end
    else if ACFlatLined.Checked then
    begin
      GLSceneViewer.Buffer.Lighting := True;
      GLSceneViewer.Buffer.ShadeModel := smFlat;
      aMaterial.PolygonMode := pmLines;
    end
    else if ACHiddenLines.Checked then
    begin
      GLSceneViewer.Buffer.Lighting := False;
      GLSceneViewer.Buffer.ShadeModel := smSmooth;
      aMaterial.PolygonMode := pmLines;
    end
    else if ACWireframe.Checked then
    begin
      GLSceneViewer.Buffer.Lighting := False;
      GLSceneViewer.Buffer.ShadeModel := smSmooth;
      aMaterial.PolygonMode := pmLines;
    end;
  end;
end;

procedure TGLSViewerFrm.ApplyShadeMode;
var
  i: Integer;
begin
  with GLMaterialLibrary.Materials do
    for i := 0 to Count - 1 do
    begin
      ApplyShadeModeToMaterial(Items[i].Material);
      if (Hiddenlines1.Checked) or (FlatShadingwithlines1.Checked) then
        Items[i].Shader := hlShader
      else
        Items[i].Shader := nil;
    end;
  FreeForm.StructureChanged;
end;

procedure TGLSViewerFrm.ApplyFSAA;
begin
  with GLSceneViewer.Buffer do
  begin
    if MIAADefault.Checked then
      AntiAliasing := aaDefault
    else if MIAA2x.Checked then
      AntiAliasing := aa2x
    else if MIAA4X.Checked then
      AntiAliasing := aa4x;
  end;
end;

procedure TGLSViewerFrm.ApplyFaceCull;
begin
  with GLSceneViewer.Buffer do
  begin
    if ACCullFace.Checked then
    begin
      FaceCulling := True;
      ContextOptions := ContextOptions - [roTwoSideLighting];
    end
    else
    begin
      FaceCulling := False;
      ContextOptions := ContextOptions + [roTwoSideLighting];
    end;
  end;
end;

procedure TGLSViewerFrm.ApplyBgColor;
var
  bmp: TBitmap;
  col: TColor;
begin
  bmp := TBitmap.Create;
  try
    bmp.Width := 16;
    bmp.Height := 16;
    col := ColorToRGB(ColorDialog.Color);
    GLSceneViewer.Buffer.BackgroundColor := col;
    with bmp.Canvas do
    begin
      Pen.Color := col xor $FFFFFF;
      Brush.Color := col;
      Rectangle(0, 0, 16, 16);
    end;
    MIBgColor.Bitmap := bmp;
  finally
    bmp.Free;
  end;
end;

procedure TGLSViewerFrm.ApplyTexturing;
var
  i: Integer;
begin
  with GLMaterialLibrary.Materials do
    for i := 0 to Count - 1 do
    begin
      with Items[i].Material.Texture do
      begin
        if Enabled then
          Items[i].Tag := Integer(True);
        Enabled := Boolean(Items[i].Tag) and ACTexturing.Checked;
      end;
    end;
  FreeForm.StructureChanged;
end;

procedure TGLSViewerFrm.ApplyFPS;
begin
  if ACFPS.Checked then
  begin
    Timer.Enabled := True;
    GLCadencer.Enabled := True;
  end
  else
  begin
    Timer.Enabled := False;
    GLCadencer.Enabled := False;
    StatusBar.Panels[1].Text := '--- FPS';
  end;
end;

procedure TGLSViewerFrm.DoOpen(const fileName: String);
var
  i: Integer;
  min, max: TAffineVector;
  libMat: TGLLibMaterial;
begin
  if not FileExists(fileName) then
    Exit;

  Screen.Cursor := crHourGlass;
  Caption := 'GLSViewer1 - ' + ExtractFileName(fileName);

  FreeForm.MeshObjects.Clear;
  GLMaterialLibrary.Materials.Clear;

  FreeForm.LoadFromFile(fileName);
  with GLMaterialLibrary do
  begin
    if Materials.Count = 0 then
    begin
      FreeForm.Material.MaterialLibrary := GLMaterialLibrary;
      libMat := Materials.Add;
      FreeForm.Material.LibMaterialName := libMat.Name;
      libMat.Material.FrontProperties.Diffuse.Red := 0;
    end;
    for i := 0 to Materials.Count - 1 do
      with Materials[i].Material do
        BackProperties.Assign(FrontProperties);
  end;
  ApplyShadeMode;
  ApplyTexturing;
  ApplyFPS;

  StatusBar.Panels[0].Text := IntToStr(FreeForm.MeshObjects.TriangleCount)
    + ' tris';
  StatusBar.Panels[2].Text := fileName;
  ACSaveTextures.Enabled := (GLMaterialLibrary.Materials.Count > 0);
  MIOpenTexLib.Enabled := (GLMaterialLibrary.Materials.Count > 0);
  lastFileName := fileName;
  lastLoadWithTextures := ACTexturing.Enabled;

  FreeForm.GetExtents(min, max);
  with CubeExtents do
  begin
    CubeWidth := max.X - min.X;
    CubeHeight := max.Y - min.Y;
    CubeDepth := max.Z - min.Z;
    Position.AsAffineVector := VectorLerp(min, max, 0.5);
  end;

  DoResetCamera;
end;

procedure TGLSViewerFrm.ACOpenExecute(Sender: TObject);
begin
  OpenDialog.InitialDir := EarthModelPath;
  if OpenDialog.Execute then
    DoOpen(OpenDialog.fileName);
end;

procedure TGLSViewerFrm.GLSceneViewerMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  mx := X;
  my := Y;
  md := True;
end;

procedure TGLSViewerFrm.GLSceneViewerMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  d: Single;
begin
  if md and (Shift <> []) then
  begin
    if ssLeft in Shift then
      if ssShift in Shift then
        GLCamera.MoveAroundTarget((my - Y) * 0.1, (mx - X) * 0.1)
      else
        GLCamera.MoveAroundTarget(my - Y, mx - X)
    else if ssRight in Shift then
    begin
      d := GLCamera.DistanceToTarget * 0.01 * (X - mx + Y - my);
      if IsKeyDown('x') then
        FreeForm.Translate(d, 0, 0)
      else if IsKeyDown('y') then
        FreeForm.Translate(0, d, 0)
      else if IsKeyDown('z') then
        FreeForm.Translate(0, 0, d)
      else
      begin
        if ssShift in Shift then
          GLCamera.RotateObject(FreeForm, (my - Y) * 0.1, (mx - X) * 0.1)
        else
          GLCamera.RotateObject(FreeForm, my - Y, mx - X);
      end;
    end;
    mx := X;
    my := Y;
  end;
end;

procedure TGLSViewerFrm.GLSceneViewerMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  md := False;
end;

procedure TGLSViewerFrm.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  if FreeForm.MeshObjects.Count > 0 then
  begin
    GLCamera.AdjustDistanceToTarget(PowerSingle(1.05, WheelDelta / 120));
    GLCamera.DepthOfView := 2 * GLCamera.DistanceToTarget + 2 *
      FreeForm.BoundingSphereRadius;
  end;
  Handled := True;
end;

procedure TGLSViewerFrm.ACZoomInExecute(Sender: TObject);
var
  h: Boolean;
begin
  FormMouseWheel(Self, [], -120 * 4, Point(0, 0), h);
end;

procedure TGLSViewerFrm.ACZoomOutExecute(Sender: TObject);
var
  h: Boolean;
begin
  FormMouseWheel(Self, [], 120 * 4, Point(0, 0), h);
end;

procedure TGLSViewerFrm.ACShadeSmoothExecute(Sender: TObject);
begin
  ApplyShadeMode;
end;

procedure TGLSViewerFrm.AllBtnsUp;
Begin
  Smoothshading1.Checked := False;
  ToolButton6.Down := False;
  Flatshading1.Checked := False;
  ToolButton7.Down := False;
  Hiddenlines1.Checked := False;
  ToolButton8.Down := False;
  Wireframe1.Checked := False;
  ToolButton9.Down := False;
  FlatShadingwithlines1.Checked := False;
  ToolButton13.Down := False;
End;

procedure TGLSViewerFrm.Smoothshading1Click(Sender: TObject);
begin
  AllBtnsUp;
  Smoothshading1.Checked := True;
  ToolButton6.Down := True;
  ApplyShadeMode;
end;

procedure TGLSViewerFrm.Flatshading1Click(Sender: TObject);
begin
  AllBtnsUp;
  Flatshading1.Checked := True;
  ToolButton7.Down := True;
  ApplyShadeMode;
end;

procedure TGLSViewerFrm.FlatShadingwithlines1Click(Sender: TObject);
begin
  AllBtnsUp;
  FlatShadingwithlines1.Checked := True;
  ToolButton13.Down := True;
  ApplyShadeMode;
end;

procedure TGLSViewerFrm.Hiddenlines1Click(Sender: TObject);
begin
  AllBtnsUp;
  Hiddenlines1.Checked := True;
  ToolButton8.Down := True;
  ApplyShadeMode;
end;

procedure TGLSViewerFrm.Wireframe1Click(Sender: TObject);
begin
  AllBtnsUp;
  Wireframe1.Checked := True;
  ToolButton9.Down := True;
  ApplyShadeMode;
end;

procedure TGLSViewerFrm.MIAADefaultClick(Sender: TObject);
begin
  (Sender as TMenuItem).Checked := True;
  ApplyFSAA;
end;

procedure TGLSViewerFrm.ACResetViewExecute(Sender: TObject);
begin
  DoResetCamera;
end;

procedure TGLSViewerFrm.ACCullFaceExecute(Sender: TObject);
begin
  ACCullFace.Checked := not ACCullFace.Checked;
  ApplyFaceCull;
end;

procedure TGLSViewerFrm.MIBgColorClick(Sender: TObject);
begin
  if ColorDialog.Execute then
    ApplyBgColor;
end;

procedure TGLSViewerFrm.GLMaterialLibraryTextureNeeded(Sender: TObject;
  var textureFileName: String);
begin
  if not ACTexturing.Enabled then
    textureFileName := '';
end;

procedure TGLSViewerFrm.ACTexturingExecute(Sender: TObject);
begin
  ACTexturing.Checked := not ACTexturing.Checked;
  if ACTexturing.Checked then
    if lastLoadWithTextures then
      ApplyTexturing
    else
    begin
      DoOpen(lastFileName);
    end
  else
    ApplyTexturing;
end;

procedure TGLSViewerFrm.MIFileClick(Sender: TObject);
begin
  MIPickTexture.Enabled := (GLMaterialLibrary.Materials.Count > 0);
end;

procedure TGLSViewerFrm.MIPickTextureClick(Sender: TObject);
begin
  OpenPictureDialog.InitialDir := EarthModelPath;
  if OpenPictureDialog.Execute then
  begin
    with GLMaterialLibrary.Materials do
    begin
      with Items[Count - 1] do
      begin
        Tag := 1;
        Material.Texture.Image.LoadFromFile(OpenPictureDialog.fileName);
        Material.Texture.Enabled := True;
      end;
    end;
    ApplyTexturing;
  end;
end;

procedure TGLSViewerFrm.MIOpenTexLibClick(Sender: TObject);
var
  i: Integer;
begin
  ODTextures.InitialDir := EarthModelPath;
  if ODTextures.Execute then
    with GLMaterialLibrary do
    begin
      LoadFromFile(ODTextures.fileName);
      for i := 0 to Materials.Count - 1 do
        with Materials[i].Material do
          BackProperties.Assign(FrontProperties);
      ApplyShadeMode;
      ApplyTexturing;
    end;
end;

procedure TGLSViewerFrm.ACInvertNormalsExecute(Sender: TObject);
var
  i: Integer;
begin
  InvertNormals1.Checked := (not InvertNormals1.Checked);
  with FreeForm.MeshObjects do
    for i := 0 to Count - 1 do
      Items[i].Normals.Scale(-1);
  FreeForm.StructureChanged;
end;

procedure TGLSViewerFrm.ACReverseRenderingOrderExecute(Sender: TObject);
var
  i, j, n: Integer;
  fg: TGLFaceGroup;
begin
  ReverseRenderingOrder1.Checked := (not ReverseRenderingOrder1.Checked);
  with FreeForm.MeshObjects do
  begin
    // invert meshobjects order
    for i := 0 to (Count div 2) do
      Exchange(i, Count - 1 - i);
    // for each mesh object
    for i := 0 to Count - 1 do
      with Items[i] do
      begin
        // invert facegroups order
        n := FaceGroups.Count;
        for j := 0 to (n div 2) do
          Exchange(j, n - 1 - j);
        // for each facegroup
        for j := 0 to n - 1 do
        begin
          fg := FaceGroups[j];
          fg.Reverse;
        end;
      end;
  end;
  FreeForm.StructureChanged;
end;

procedure TGLSViewerFrm.ACSaveAsExecute(Sender: TObject);
var
  ext: String;
begin
  SaveDialog.InitialDir := EarthModelPath;
  if SaveDialog.Execute then
  begin
    ext := ExtractFileExt(SaveDialog.fileName);
    if ext = '' then
      SaveDialog.fileName := ChangeFileExt(SaveDialog.fileName,
        '.' + GetVectorFileFormats.FindExtByIndex(SaveDialog.FilterIndex,
        False, True));
    if GetVectorFileFormats.FindFromFileName(SaveDialog.fileName) = nil then
      ShowMessage('Unsupported or unspecified file extension.')
    else
      FreeForm.SaveToFile(SaveDialog.fileName);
  end;
end;

procedure TGLSViewerFrm.ACSaveAsUpdate(Sender: TObject);
begin
  ACSaveAs.Enabled := (FreeForm.MeshObjects.Count > 0);
end;

procedure TGLSViewerFrm.ACConvertToIndexedTrianglesExecute(Sender: TObject);
var
  v: TAffineVectorList;
  i: TIntegerList;
  m: TMeshObject;
  fg: TFGVertexIndexList;
begin
  ConverttoIndexedTriangles1.Checked :=
    (not ConverttoIndexedTriangles1.Checked);
  v := FreeForm.MeshObjects.ExtractTriangles;
  try
    i := BuildVectorCountOptimizedIndices(v);
    try
      RemapAndCleanupReferences(v, i);
      IncreaseCoherency(i, 8);
      FreeForm.MeshObjects.Clean;
      m := TMeshObject.CreateOwned(FreeForm.MeshObjects);
      m.Vertices := v;
      m.BuildNormals(i, momTriangles);
      m.Mode := momFaceGroups;
      fg := TFGVertexIndexList.CreateOwned(m.FaceGroups);
      fg.VertexIndices := i;
      fg.Mode := fgmmTriangles;
      FreeForm.StructureChanged;
    finally
      i.Free;
    end;
  finally
    v.Free;
  end;
end;

procedure TGLSViewerFrm.GLCadencerProgress(Sender: TObject;
  const deltaTime, newTime: Double);
begin
  GLSceneViewer.Invalidate;
end;

procedure TGLSViewerFrm.ACFPSExecute(Sender: TObject);
begin
  ACFPS.Checked := not ACFPS.Checked;
  ApplyFPS;
end;

procedure TGLSViewerFrm.TimerTimer(Sender: TObject);
begin
  StatusBar.Panels[1].Text := Format('%.1f FPS',
    [GLSceneViewer.FramesPerSecond]);
  GLSceneViewer.ResetPerformanceMonitor;
end;

procedure TGLSViewerFrm.ACSaveTexturesExecute(Sender: TObject);
begin
  SDTextures.InitialDir := EarthModelPath;
  if SDTextures.Execute then
    GLMaterialLibrary.SaveToFile(SDTextures.fileName);
end;

procedure TGLSViewerFrm.LightMapMaker1Click(Sender: TObject);
begin
  { }
end;

end.
