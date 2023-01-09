unit fHeightField;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.Math,
  Vcl.ComCtrls,
  Vcl.Menus,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.Buttons,
  Vcl.ExtCtrls,

  GLS.Scene,
  GLS.VectorTypes,
  GLS.Graph,
  GLS.SceneViewer,
  GLS.Objects,
  GLS.Texture,
  GLS.VectorGeometry,
  GLS.GeomObjects,
  GLS.Coordinates,
  
  GLS.BaseClasses,
  GLS.Color;

type
  TfmHeightField = class(TForm)
    GLScene: TGLScene;
    GLSceneViewer: TGLSceneViewer;
    Panel3: TPanel;
    Panel4: TPanel;
    btnRun: TBitBtn;
    Light: TGLLightSource;
    Camera: TGLCamera;
    HeatField: TGLHeightField;
    FocusCube: TGLDummyCube;
    Grid: TGLXYZGrid;
    cbGrid: TCheckBox;
    XAxis: TGLArrowLine;
    YAxis: TGLArrowLine;
    cbAxis: TCheckBox;
    LabelOpacity: TLabel;
    tbAlpha: TTrackBar;
    cbColorMode: TComboBox;
    LightCube: TGLDummyCube;
    cbLighting: TCheckBox;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnRunClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure GLSceneViewerMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure GLSceneViewerMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure cbGridClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cbAxisClick(Sender: TObject);
    procedure cbColorModeChange(Sender: TObject);
    procedure cbLightingClick(Sender: TObject);
    procedure tbAlphaChange(Sender: TObject);
  private
    mx, my : Integer;
  protected
    procedure HeatFormula(const x, y: Single; var z: Single;
      var color: TGLColorVector; var texPoint: TTexPoint);
    procedure HumidityFormula(const x, y: Single; var z: Single;
      var color: TGLColorVector; var texPoint: TTexPoint);
  public
    procedure Advance;
  end;

var
  fmHeightField: TfmHeightField;

//===================================================
implementation

uses
  fFirstForm,
  cGlobals,
  cAIGrid;

{$R *.dfm}

procedure TfmHeightField.Advance;
begin
  HeatField.StructureChanged;
end;

procedure TfmHeightField.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := false;
  fmFirstForm.RealityForm.ManagerForm.DropHeightField;
end;

procedure TfmHeightField.btnRunClick(Sender: TObject);
begin
  Close;
end;

procedure TfmHeightField.FormCreate(Sender: TObject);
begin
  HeatField.OnGetHeight := HeatFormula;
  HeatField.XSamplingScale.Min := 0;
  HeatField.XSamplingScale.Max := gSpace.WidthLoop+1;
  HeatField.XSamplingScale.Step := 1;
  HeatField.YSamplingScale.Min := 0;
  HeatField.YSamplingScale.Max := gSpace.HeightLoop;
  HeatField.YSamplingScale.Step := 1;
  FocusCube.Position.X := HeatField.XSamplingScale.Max / 2;
  FocusCube.Position.Y := HeatField.YSamplingScale.Max / 2;
  Grid.XSamplingScale.Min := 0;
  Grid.XSamplingScale.Max := gSpace.WidthLoop;
  Grid.XSamplingScale.Step := 1;
  Grid.YSamplingScale.Min := 0;
  Grid.YSamplingScale.Max := gSpace.HeightLoop;
  Grid.YSamplingScale.Step := 1;
  XAxis.Height := gSpace.WidthSingle-1;
  XAxis.Position.X := (gSpace.WidthSingle-1)/2;
  YAxis.Height := gSpace.HeightSingle-1;
  YAxis.Position.Y := (gSpace.HeightSingle-1)/2;
end;

procedure TfmHeightField.HeatFormula(const x, y: Single; var z: Single;
  var color: TGLColorVector; var texPoint: TTexPoint);
var
  gridx, gridy: integer;
  myLocation: AIGrid;
begin
  gridx := Round(x);
  gridy := Round(y);
  myLocation := gSpace.Map[gridx][gridy];
  z := myLocation.Temperature/10;
  VectorLerp(clrBlue, clrRed, (z-0.5)*10, color);
  color.W := 0.01*tbAlpha.Position;
end;

procedure TfmHeightField.HumidityFormula(const x, y: Single; var z: Single;
  var color: TGLColorVector; var texPoint: TTexPoint);
var
  gridx, gridy: integer;
  myLocation: AIGrid;
begin
  gridx := Round(x);
  gridy := Round(y);
  myLocation := gSpace.Map[gridx][gridy];
  z := myLocation.Humidity/10;
  VectorLerp(clrGray, clrWhite, (z-0.5)*10, color);
  color.W := 0.01*tbAlpha.Position;
end;

procedure TfmHeightField.GLSceneViewerMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
   if Shift<>[] then begin
      Camera.MoveAroundTarget(my-y, mx-x);
      mx:=x; my:=y;
   end;
end;

procedure TfmHeightField.GLSceneViewerMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   mx:=x; my:=y;
end;

procedure TfmHeightField.FormMouseWheel(Sender: TObject;
  Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint;
  var Handled: Boolean);
begin
	Camera.AdjustDistanceToTarget(Power(1.1, WheelDelta/-256));
end;

procedure TfmHeightField.cbGridClick(Sender: TObject);
begin
  Grid.Visible := cbGrid.Checked;
  GLSceneViewer.SetFocus;
end;

procedure TfmHeightField.FormShow(Sender: TObject);
begin
  GLSceneViewer.Invalidate;
  GLSceneViewer.SetFocus;
  Camera.MoveAroundTarget(0,0); // makes the viewer update on show (?)
  GLSceneViewer.Buffer.Render;
end;

procedure TfmHeightField.cbAxisClick(Sender: TObject);
begin
  XAxis.Visible := cbAxis.Checked;
  YAxis.Visible := cbAxis.Checked;
  GLSceneViewer.SetFocus;
end;

procedure TfmHeightField.cbColorModeChange(Sender: TObject);
begin
  tbAlpha.Enabled := true;
  case cbColorMode.ItemIndex of
    0: begin
      HeatField.ColorMode := hfcmAmbient;
      tbAlpha.Enabled := false;
      tbAlpha.Position := 100;
    end;
    1: HeatField.ColorMode := hfcmAmbientAndDiffuse;
    2: HeatField.ColorMode := hfcmDiffuse;
    3: begin
      HeatField.ColorMode := hfcmEmission;
      tbAlpha.Enabled := false;
      tbAlpha.Position := 100;
    end;
    4: begin
      HeatField.ColorMode := hfcmNone;
      tbAlpha.Enabled := false;
      tbAlpha.Position := 100;
    end;
  end;
  LabelOpacity.Enabled := tbAlpha.Enabled;
  HeatField.StructureChanged;
  GLSceneViewer.SetFocus;
end;

procedure TfmHeightField.cbLightingClick(Sender: TObject);
begin
  Light.Shining := cbLighting.Checked;
  GLSceneViewer.SetFocus;
end;

procedure TfmHeightField.tbAlphaChange(Sender: TObject);
begin
  GLSceneViewer.SetFocus;
end;

end.
