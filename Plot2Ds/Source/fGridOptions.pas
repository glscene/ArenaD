unit fGridOptions;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.Math,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.Buttons,

  GLS.OpenGLTokens,
  GLS.VectorTypes,
  GLS.Coordinates,
  GLS.VectorGeometry,

  uGlobal,
  uParser,
  fGridColors;

type
  TGridOptionsForm = class(TForm)
    GroupBoxXY: TGroupBox;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label10: TLabel;
    EditxyGridMinx: TEdit;
    EditxyGridMaxx: TEdit;
    EditxyGridStpx: TEdit;
    EditxyGridMiny: TEdit;
    EditxyGridMaxy: TEdit;
    EditxyGridStpy: TEdit;
    EditxyGridPosz: TEdit;
    xyLock: TCheckBox;
    GroupBoxXZ: TGroupBox;
    Label13: TLabel;
    Label18: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    EditxzGridMinx: TEdit;
    EditxzGridMaxx: TEdit;
    EditxzGridStpx: TEdit;
    EditxzGridMinz: TEdit;
    EditxzGridMaxz: TEdit;
    EditxzGridStpz: TEdit;
    EditxzGridPosy: TEdit;
    zLock: TCheckBox;
    GroupBoxYZ: TGroupBox;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    EdityzGridMiny: TEdit;
    EdityzGridMaxy: TEdit;
    EdityzGridStpy: TEdit;
    EdityzGridMinz: TEdit;
    EdityzGridMaxz: TEdit;
    EdityzGridStpz: TEdit;
    EdityzGridPosx: TEdit;
    GroupBoxOp: TGroupBox;
    Label14: TLabel;
    Label19: TLabel;
    Colors: TSpeedButton;
    xyGridCB: TCheckBox;
    xzGridCB: TCheckBox;
    yzGridCB: TCheckBox;
    EditViewDepth: TEdit;
    MinLock: TCheckBox;
    Label1: TLabel;
    EditzScale: TEdit;
    Centre: TSpeedButton;
    BoxOutlineCB: TCheckBox;
    Label4: TLabel;
    EditBoxLnWidth: TEdit;
    BitBtn1: TBitBtn;
    PlotValues: TSpeedButton;
    procedure ColorsClick(Sender: TObject);
    procedure FloatKeyPress(Sender: TObject; var Key: Char);
    procedure PositiveKeyPress(Sender: TObject; var Key: Char);
    procedure EditxyGridMinxChange(Sender: TObject);
    procedure EditxyGridMaxxChange(Sender: TObject);
    procedure EditxyGridStpxChange(Sender: TObject);
    procedure EditxyGridPoszChange(Sender: TObject);
    procedure EditxyGridMinyChange(Sender: TObject);
    procedure EditxyGridMaxyChange(Sender: TObject);
    procedure EditxyGridStpyChange(Sender: TObject);
    procedure EditxzGridMinxChange(Sender: TObject);
    procedure EditxzGridMaxxChange(Sender: TObject);
    procedure EditxzGridStpxChange(Sender: TObject);
    procedure EditxzGridPosyChange(Sender: TObject);
    procedure EditxzGridMinzChange(Sender: TObject);
    procedure EditxzGridMaxzChange(Sender: TObject);
    procedure EditxzGridStpzChange(Sender: TObject);
    procedure EdityzGridMinyChange(Sender: TObject);
    procedure EdityzGridMaxyChange(Sender: TObject);
    procedure EdityzGridStpyChange(Sender: TObject);
    procedure EdityzGridPosxChange(Sender: TObject);
    procedure EdityzGridMinzChange(Sender: TObject);
    procedure EdityzGridMaxzChange(Sender: TObject);
    procedure EdityzGridStpzChange(Sender: TObject);
    procedure xyGridCBClick(Sender: TObject);
    procedure xzGridCBClick(Sender: TObject);
    procedure yzGridCBClick(Sender: TObject);
    procedure xyLockClick(Sender: TObject);
    procedure zLockClick(Sender: TObject);
    procedure MinLockClick(Sender: TObject);
    procedure ComboBoxMouseEnter(Sender: TObject);
    procedure EditViewDepthChange(Sender: TObject);
    procedure CentreClick(Sender: TObject);
    procedure EditzScaleKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BoxOutlineCBClick(Sender: TObject);
    procedure IntKeyPress(Sender: TObject; var Key: Char);
    procedure EditBoxLnWidthKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BitBtn1Click(Sender: TObject);
    procedure EditxzGridStpxExit(Sender: TObject);
    procedure EdityzGridStpyExit(Sender: TObject);
    procedure EdityzGridStpzExit(Sender: TObject);
    procedure PlotValuesClick(Sender: TObject);
  private
  public
    procedure DrawOutline(const Show: Boolean);
  end;

var
  GridOptionsForm: TGridOptionsForm;

// =====================================================================
implementation
// =====================================================================

uses
  fMain,
  fEvaluate,
  fCoordOptions,
  fFunctions;

{$R *.dfm}

procedure TGridOptionsForm.CentreClick(Sender: TObject);
var
  x, y, z: TGLFloat;

begin
  with ViewForm do
  begin
    MousePoint.x := Maxint;
    if GLxyGrid.XSamplingScale.Max - GLxyGrid.XSamplingScale.Min >
      GLxzGrid.XSamplingScale.Max - GLxzGrid.XSamplingScale.Min then
      x := GLxyGrid.XSamplingScale.Max + GLxyGrid.XSamplingScale.Min
    else
      x := GLxzGrid.XSamplingScale.Max + GLxzGrid.XSamplingScale.Min;

    if GLxyGrid.YSamplingScale.Max - GLxyGrid.YSamplingScale.Min >
      GLyzGrid.YSamplingScale.Max - GLxzGrid.YSamplingScale.Min then
      y := GLxyGrid.YSamplingScale.Max + GLxyGrid.YSamplingScale.Min
    else
      y := GLyzGrid.YSamplingScale.Max + GLyzGrid.YSamplingScale.Min;

    if GLxzGrid.ZSamplingScale.Max - GLxzGrid.ZSamplingScale.Min >
      GLyzGrid.ZSamplingScale.Max - GLyzGrid.ZSamplingScale.Min then
      z := GLxzGrid.ZSamplingScale.Max + GLxzGrid.ZSamplingScale.Min
    else
      z := GLyzGrid.ZSamplingScale.Max + GLyzGrid.ZSamplingScale.Min;

    TargetCube.Position.SetPoint(x / 2, y / 2,
      (ViewData.xyGrid.zScale * z) / 2);
  end;
  Altered := True;
  ViewForm.ShowDisplacement;
end;

procedure TGridOptionsForm.BitBtn1Click(Sender: TObject);
begin
  Close;
end;

procedure TGridOptionsForm.BoxOutlineCBClick(Sender: TObject);
begin
  ViewData.BoxChecked := BoxOutlineCB.Checked;
  DrawOutline(ViewData.BoxChecked);
  Altered := True;
end;

procedure TGridOptionsForm.ColorsClick(Sender: TObject);
begin
  GridColorsForm.Show;
end;

procedure TGridOptionsForm.IntKeyPress(Sender: TObject; var Key: Char);
begin
  with Sender as TEdit do
    if not CharInSet(Key, ['0' .. '9', #8]) then
      Key := #0
end;

procedure TGridOptionsForm.EditBoxLnWidthKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  w: integer;

begin
  try
    w := StrToInt(EditBoxLnWidth.Text);
  except
    w := 3;
  end;
  ViewData.BoxLnWidth := w;
  ViewForm.BoxLine1.LineWidth := w;
  ViewForm.BoxLine2.LineWidth := w;
  ViewForm.BoxLine3.LineWidth := w;
  ViewForm.BoxLine4.LineWidth := w;
  Altered := True;
end;

procedure TGridOptionsForm.EditViewDepthChange(Sender: TObject);
var
  v: TGLFloat;

begin
  if Active then
  begin
    try
      v := StrToFloat(EditViewDepth.Text);
    except
      v := 1000;
    end;
    if v = 0 then
      Exit;
    ViewData.ViewDepth := v;
    ViewForm.GLSViewer.Camera.DepthOfView := v;
  end;
end;

procedure TGridOptionsForm.PlotValuesClick(Sender: TObject);
begin
  if xyLock.Checked and zLock.Checked and MinLock.Checked then
  begin
    EditxyGridMinx.Text := FloatToStrF(PlotData.xMin, ffGeneral, 7, 4);
    EditxyGridMaxx.Text := FloatToStrF(PlotData.xMax, ffGeneral, 7, 4);
    EditxyGridMiny.Text := FloatToStrF(PlotData.yMin, ffGeneral, 7, 4);
    EditxyGridMaxy.Text := FloatToStrF(PlotData.yMax, ffGeneral, 7, 4);
    EditxzGridMinz.Text := FloatToStrF(PlotData.zMin, ffGeneral, 7, 4);
    EditxzGridMaxz.Text := FloatToStrF(PlotData.zMax, ffGeneral, 7, 4);
  end;
end;

procedure TGridOptionsForm.PositiveKeyPress(Sender: TObject; var Key: Char);
begin
  with Sender as TEdit do
    if not CharInSet(Key, ['+', '0' .. '9', '.', #8]) then
      Key := #0;
end;

procedure TGridOptionsForm.EditxyGridMaxxChange(Sender: TObject);
var
  x: TGLFloat;

begin { 2 }
  if Active then
  begin
    try
      x := StrToFloat(EditxyGridMaxx.Text);
    except
      x := 1.0;
    end;
    ViewData.xyGrid.xRange.Maximum := x;
    ViewForm.GLxyGrid.XSamplingScale.Max := x;
    if xyLock.Checked then
    begin
      ViewData.xzGrid.xRange.Maximum := x;
      ViewForm.GLxzGrid.XSamplingScale.Max := x;
      EditxzGridMaxx.Text := EditxyGridMaxx.Text;
    end;
    DrawOutline(ViewData.BoxChecked);
    CoordsForm.UpdateCoordText;
  end;
end;

procedure TGridOptionsForm.EditxyGridMaxyChange(Sender: TObject);
var
  y: TGLFloat;

begin { 5 }
  if Active then
  begin
    try
      y := StrToFloat(EditxyGridMaxy.Text);
    except
      y := 1.0;
    end;
    ViewData.xyGrid.yRange.Maximum := y;
    ViewForm.GLxyGrid.YSamplingScale.Max := y;
    if xyLock.Checked then
    begin
      ViewData.yzGrid.yRange.Maximum := y;
      ViewForm.GLyzGrid.YSamplingScale.Max := y;
      EdityzGridMaxy.Text := EditxyGridMaxy.Text;
    end;
    DrawOutline(ViewData.BoxChecked);
    CoordsForm.UpdateCoordText;
  end;
end;

procedure TGridOptionsForm.EditxyGridMinxChange(Sender: TObject);
var
  x: TGLFloat;

begin { 1 }
  if Active then
  begin
    try
      x := StrToFloat(EditxyGridMinx.Text);
    except
      x := -1.0;
    end;
    ViewData.xyGrid.xRange.Minimum := x;
    ViewForm.GLxyGrid.XSamplingScale.Min := x;
    if xyLock.Checked then
    begin
      ViewData.xzGrid.xRange.Minimum := x;
      ViewForm.GLxzGrid.XSamplingScale.Min := x;
      EditxzGridMinx.Text := EditxyGridMinx.Text;
    end;
    if MinLock.Checked then
    begin
      ViewData.yzGrid.xPosition := x;
      ViewForm.GLyzGrid.Position.x := x;
      EdityzGridPosx.Text := EditxyGridMinx.Text;
    end;
    DrawOutline(ViewData.BoxChecked);
    CoordsForm.UpdateCoordText;
  end;
end;

procedure TGridOptionsForm.EditxyGridMinyChange(Sender: TObject);
var
  y: TGLFloat;

begin { 4 }
  if Active then
  begin { 1 }
    try
      y := StrToFloat(EditxyGridMiny.Text);
    except
      y := -1.0;
    end;
    if xyLock.Checked then
      ViewData.xyGrid.yRange.Minimum := y;
    ViewForm.GLxyGrid.YSamplingScale.Min := y;
    if xyLock.Checked then
    begin
      ViewData.yzGrid.yRange.Minimum := y;
      ViewForm.GLyzGrid.YSamplingScale.Min := y;
      EdityzGridMiny.Text := EditxyGridMiny.Text;
    end;
    if MinLock.Checked then
    begin
      ViewData.xzGrid.yPosition := y;
      ViewForm.GLxzGrid.Position.y := y;
      EditxzGridPosy.Text := EditxyGridMiny.Text;
    end;
    DrawOutline(ViewData.BoxChecked);
    CoordsForm.UpdateCoordText;
  end;
end;

procedure TGridOptionsForm.EditxyGridPoszChange(Sender: TObject);
var
  z: TGLFloat;

begin { - }
  if Active then
  begin
    try
      z := StrToFloat(EditxyGridPosz.Text);
    except
      z := 0.0;
    end;
    ViewData.xyGrid.zPosition := z;
    ViewForm.GLxyGrid.Position.z := z * ViewData.xyGrid.zScale;
    EvaluateForm.UpdateEvaluate;
    DrawOutline(ViewData.BoxChecked);
  end;
end;

procedure TGridOptionsForm.EditxyGridStpxChange(Sender: TObject);
var
  x: TGLFloat;

begin { 3 }
  if Active then
  begin
    try
      x := StrToFloat(EditxyGridStpx.Text);
    except
      x := 1.0;
    end;
    if x = 0 then
      x := 1;
    ViewData.xyGrid.xRange.Step := x;
    ViewForm.GLxyGrid.XSamplingScale.Step := x;
    if xyLock.Checked then
    begin
      ViewData.xzGrid.xRange.Step := x;
      ViewForm.GLxzGrid.XSamplingScale.Step := x;
      EditxzGridStpx.Text := EditxyGridStpx.Text;
    end;
    CoordsForm.UpdateCoordText;
    EvaluateForm.DoEvaluate;
  end;
end;

procedure TGridOptionsForm.EditxyGridStpyChange(Sender: TObject);
var
  y: TGLFloat;

begin { 6 }
  if Active then
  begin
    try
      y := StrToFloat(EditxyGridStpy.Text);
    except
      y := 1.0;
    end;
    if y = 0 then
      y := 1;
    ViewData.xyGrid.yRange.Step := y;
    ViewForm.GLxyGrid.YSamplingScale.Step := y;
    if xyLock.Checked then
    begin
      ViewData.yzGrid.yRange.Step := y;
      ViewForm.GLyzGrid.YSamplingScale.Step := y;
      EdityzGridStpy.Text := EditxyGridStpy.Text;
    end;
    CoordsForm.UpdateCoordText;
    EvaluateForm.DoEvaluate;
  end;
end;

procedure TGridOptionsForm.EditxzGridMaxxChange(Sender: TObject);
var
  x: TGLFloat;

begin { 2 }
  if Active then
  begin
    try
      x := StrToFloat(EditxzGridMaxx.Text);
    except
      x := 1.0;
    end;
    ViewData.xzGrid.xRange.Maximum := x;
    ViewForm.GLxzGrid.XSamplingScale.Max := x;
    if xyLock.Checked then
    begin
      ViewData.xyGrid.xRange.Maximum := x;
      ViewForm.GLxyGrid.XSamplingScale.Max := x;
      EditxyGridMaxx.Text := EditxzGridMaxx.Text;
    end;
    DrawOutline(ViewData.BoxChecked);
    CoordsForm.UpdateCoordText;
  end;
end;

procedure TGridOptionsForm.EditxzGridMaxzChange(Sender: TObject);
var
  z: TGLFloat;

begin { 8 }
  if Active then
  begin
    try
      z := StrToFloat(EditxzGridMaxz.Text);
    except
      z := 1.0;
    end;
    ViewData.xzGrid.zRange.Maximum := z;
    ViewForm.GLxzGrid.ZSamplingScale.Max := z;
    if zLock.Checked then
    begin
      ViewData.yzGrid.zRange.Maximum := z;
      ViewForm.GLyzGrid.ZSamplingScale.Max := z;
      EdityzGridMaxz.Text := EditxzGridMaxz.Text;
    end;
    DrawOutline(ViewData.BoxChecked);
    CoordsForm.UpdateCoordText;
  end;
end;

procedure TGridOptionsForm.EditxzGridMinxChange(Sender: TObject);
var
  x: TGLFloat;

begin { 1 }
  if Active then
  begin
    try
      x := StrToFloat(EditxzGridMinx.Text);
    except
      x := -1.0;
    end;
    ViewData.xzGrid.xRange.Minimum := x;
    ViewForm.GLxzGrid.XSamplingScale.Min := x;
    if xyLock.Checked then
    begin
      ViewData.xyGrid.xRange.Minimum := x;
      ViewForm.GLxyGrid.XSamplingScale.Min := x;
      EditxyGridMinx.Text := EditxzGridMinx.Text;
    end;
    if MinLock.Checked then
    begin
      ViewData.yzGrid.xPosition := x;
      ViewForm.GLyzGrid.Position.x := x;
      EdityzGridPosx.Text := EditxzGridMinx.Text;
    end;
    DrawOutline(ViewData.BoxChecked);
    CoordsForm.UpdateCoordText;
  end;
end;

procedure TGridOptionsForm.EditxzGridMinzChange(Sender: TObject);
var
  z: TGLFloat;

begin { 7 }
  if Active then
  begin
    try
      z := StrToFloat(EditxzGridMinz.Text);
    except
      z := -1.0;
    end;
    ViewData.xzGrid.zRange.Minimum := z;
    ViewForm.GLxzGrid.ZSamplingScale.Min := z;
    if zLock.Checked then
    begin
      ViewData.yzGrid.zRange.Minimum := z;
      ViewForm.GLyzGrid.ZSamplingScale.Min := z;
      EdityzGridMinz.Text := EditxzGridMinz.Text;
    end;
    if MinLock.Checked then
    begin
      ViewData.xyGrid.zPosition := z;
      ViewForm.GLxyGrid.Position.z := z * ViewData.xyGrid.zScale;
      EditxyGridPosz.Text := EditxzGridMinz.Text;
    end;
    DrawOutline(ViewData.BoxChecked);
    CoordsForm.UpdateCoordText;
  end;
end;

procedure TGridOptionsForm.EditxzGridPosyChange(Sender: TObject);
var
  y: TGLFloat;

begin { - }
  if Active then
  begin
    try
      y := StrToFloat(EditxzGridPosy.Text);
    except
      y := 1.0;
    end;
    ViewData.xzGrid.yPosition := y;
    ViewForm.GLxzGrid.Position.y := y;
    EvaluateForm.UpdateEvaluate;
    DrawOutline(ViewData.BoxChecked);
  end;
end;

procedure TGridOptionsForm.EditxzGridStpxChange(Sender: TObject);
var
  x: TGLFloat;

begin { 3 }
  if Active then
  begin
    try
      x := StrToFloat(EditxzGridStpx.Text);
    except
      x := 1.0;
    end;
    if x = 0 then
      x := 1;
    ViewData.xzGrid.xRange.Step := x;
    ViewForm.GLxzGrid.XSamplingScale.Step := x;
    if xyLock.Checked then
    begin
      ViewData.xyGrid.xRange.Step := x;
      ViewForm.GLxyGrid.XSamplingScale.Step := x;
    end;
    CoordsForm.UpdateCoordText;
  end;
end;

procedure TGridOptionsForm.EditxzGridStpxExit(Sender: TObject);
begin
  if xyLock.Checked then
    EditxyGridStpx.Text := EditxzGridStpx.Text;
end;

procedure TGridOptionsForm.EditxzGridStpzChange(Sender: TObject);
var
  z: TGLFloat;

begin { 9 }
  if Active then
  begin
    try
      z := StrToFloat(EditxzGridStpz.Text);
    except
      z := 1.0;
    end;
    if z = 0 then
      z := 1;
    ViewData.xzGrid.zRange.Step := z;
    ViewForm.GLxzGrid.ZSamplingScale.Step := z;
    if zLock.Checked then
    begin
      ViewData.yzGrid.zRange.Step := z;
      ViewForm.GLyzGrid.ZSamplingScale.Step := z;
      EdityzGridStpz.Text := EditxzGridStpz.Text;
    end;
    CoordsForm.UpdateCoordText;
  end;
end;

procedure TGridOptionsForm.EdityzGridMaxyChange(Sender: TObject);
var
  y: TGLFloat;

begin { 5 }
  if Active then
  begin
    try
      y := StrToFloat(EdityzGridMaxy.Text);
    except
      y := 1.0;
    end;
    ViewData.yzGrid.yRange.Maximum := y;
    ViewForm.GLyzGrid.YSamplingScale.Max := y;
    if xyLock.Checked then
    begin
      ViewData.xyGrid.yRange.Maximum := y;
      ViewForm.GLxyGrid.YSamplingScale.Max := y;
      EditxyGridMaxy.Text := EdityzGridMaxy.Text;
    end;
    DrawOutline(ViewData.BoxChecked);
    CoordsForm.UpdateCoordText;
  end;
end;

procedure TGridOptionsForm.EdityzGridMaxzChange(Sender: TObject);
var
  z: TGLFloat;

begin { 8 }
  if Active then
  begin
    try
      z := StrToFloat(EdityzGridMaxz.Text);
    except
      z := 1.0;
    end;
    ViewData.yzGrid.zRange.Maximum := z;
    ViewForm.GLyzGrid.ZSamplingScale.Max := z;
    if zLock.Checked then
    begin
      ViewData.xzGrid.zRange.Maximum := z;
      ViewForm.GLxzGrid.ZSamplingScale.Max := z;
      EditxzGridMaxz.Text := EdityzGridMaxz.Text;
    end;
    DrawOutline(ViewData.BoxChecked);
    CoordsForm.UpdateCoordText;
  end;
end;

procedure TGridOptionsForm.EdityzGridMinyChange(Sender: TObject);
var
  y: TGLFloat;

begin { 4 }
  if Active then
  begin
    try
      y := StrToFloat(EdityzGridMiny.Text);
    except
      y := -1.0;
    end;
    ViewData.yzGrid.yRange.Minimum := y;
    ViewForm.GLyzGrid.YSamplingScale.Min := y;
    if xyLock.Checked then
    begin
      ViewData.xyGrid.yRange.Minimum := y;
      ViewForm.GLxyGrid.YSamplingScale.Min := y;
      EditxyGridMiny.Text := EdityzGridMiny.Text;
    end;
    if MinLock.Checked then
    begin
      ViewData.xzGrid.yPosition := y;
      ViewForm.GLxzGrid.Position.y := y;
      EditxzGridPosy.Text := EdityzGridMiny.Text;
    end;
    DrawOutline(ViewData.BoxChecked);
    CoordsForm.UpdateCoordText;
  end;
end;

procedure TGridOptionsForm.EdityzGridMinzChange(Sender: TObject);
var
  z: TGLFloat;

begin { 7 }
  if Active then
  begin
    try
      z := StrToFloat(EdityzGridMinz.Text);
    except
      z := -1.0;
    end;
    ViewData.yzGrid.zRange.Minimum := z;
    ViewForm.GLyzGrid.ZSamplingScale.Min := z;
    if zLock.Checked then
    begin
      ViewData.xyGrid.zPosition := z;
      ViewForm.GLxzGrid.ZSamplingScale.Min := z;
      EditxzGridMinz.Text := EdityzGridMinz.Text;
    end;
    if MinLock.Checked then
    begin
      ViewData.xyGrid.zPosition := z;
      ViewForm.GLxyGrid.Position.z := z * ViewData.xyGrid.zScale;
      EditxyGridPosz.Text := EdityzGridMinz.Text;
    end;
    DrawOutline(ViewData.BoxChecked);
    CoordsForm.UpdateCoordText;
  end;
end;

procedure TGridOptionsForm.EdityzGridPosxChange(Sender: TObject);
var
  x: TGLFloat;

begin { - }
  if Active then
  begin
    try
      x := StrToFloat(EdityzGridPosx.Text);
    except
      x := 1.0;
    end;
    ViewData.yzGrid.xPosition := x;
    ViewForm.GLyzGrid.Position.x := x;
    EvaluateForm.UpdateEvaluate;
    DrawOutline(ViewData.BoxChecked);
  end;
end;

procedure TGridOptionsForm.EdityzGridStpyChange(Sender: TObject);
var
  y: TGLFloat;

begin { 6 }
  if Active then
  begin
    try
      y := StrToFloat(EdityzGridStpy.Text);
    except
      y := 1.0;
    end;
    if y = 0 then
      y := 1;
    ViewData.yzGrid.yRange.Step := y;
    ViewForm.GLyzGrid.YSamplingScale.Step := y;
    if xyLock.Checked then
    begin
      ViewData.xyGrid.yRange.Step := y;
      ViewForm.GLxyGrid.YSamplingScale.Step := y;
    end;
    CoordsForm.UpdateCoordText;
  end;
end;

procedure TGridOptionsForm.EdityzGridStpyExit(Sender: TObject);
begin
  if xyLock.Checked then
    EditxyGridStpy.Text := EdityzGridStpy.Text;
end;

procedure TGridOptionsForm.EdityzGridStpzChange(Sender: TObject);
var
  z: TGLFloat;

begin { 9 }
  if Active then
  begin
    try
      z := StrToFloat(EdityzGridStpz.Text);
    except
      z := 1.0;
    end;
    if z = 0 then
      z := 1;
    ViewData.yzGrid.zRange.Step := z;
    ViewForm.GLyzGrid.ZSamplingScale.Step := z;
    if zLock.Checked then
    begin
      ViewData.xzGrid.zRange.Step := z;
      ViewForm.GLxzGrid.ZSamplingScale.Step := z;
    end;
    CoordsForm.UpdateCoordText;
  end;
end;

procedure TGridOptionsForm.EdityzGridStpzExit(Sender: TObject);
begin
  if zLock.Checked then
    EditxzGridStpz.Text := EdityzGridStpz.Text;
end;

procedure TGridOptionsForm.EditzScaleKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  z: TGLFloat;

begin
  if Key <> 9 then
  begin
    try
      z := StrToFloat(EditzScale.Text);
    except
      z := 1.0;
    end;
    if z = 0 then
      Exit;
    ViewData.xyGrid.zScale := z;
    ViewForm.GLxzGrid.Scale.z := z;
    ViewForm.GLyzGrid.Scale.z := z;
    ViewForm.GLxyGrid.Position.z := ViewData.xyGrid.zPosition *
      ViewData.xyGrid.zScale;
    DrawOutline(ViewData.BoxChecked);
    CoordsForm.UpdateCoordText;
    EvaluateForm.UpdateEvaluate;
    FunctionsForm.ApplyBtnClick(Sender);
  end;
end;

procedure TGridOptionsForm.FloatKeyPress(Sender: TObject; var Key: Char);
begin
  with Sender as TEdit do
    if not CharInSet(Key, AnyFloat) then
      Key := #0;
end;

procedure TGridOptionsForm.MinLockClick(Sender: TObject);
var
  x, y, z: TGLFloat;

begin
  if MinLock.Checked then
  begin
    if ViewData.xyGrid.xRange.Minimum < ViewData.xzGrid.xRange.Minimum then
      x := ViewData.xyGrid.xRange.Minimum
    else
      x := ViewData.xzGrid.xRange.Minimum;
    ViewForm.GLyzGrid.Position.x := x;
    EdityzGridPosx.Text := FloatToStrF(x, ffGeneral, 7, 4);

    if ViewData.xyGrid.yRange.Minimum < ViewData.yzGrid.yRange.Minimum then
      y := ViewData.xyGrid.yRange.Minimum
    else
      y := ViewData.yzGrid.yRange.Minimum;
    ViewForm.GLxzGrid.Position.y := y;
    EditxzGridPosy.Text := FloatToStrF(y, ffGeneral, 7, 4);

    if ViewData.xzGrid.zRange.Minimum < ViewData.yzGrid.zRange.Minimum then
      z := ViewData.xzGrid.zRange.Minimum
    else
      z := ViewData.yzGrid.zRange.Minimum;
    ViewForm.GLxyGrid.Position.z := z * ViewData.xyGrid.zScale;
    EditxyGridPosz.Text := FloatToStrF(z, ffGeneral, 7, 4);
  end;

  ViewData.yzGrid.IsChecked := MinLock.Checked;
  Altered := True;
end;

procedure TGridOptionsForm.ComboBoxMouseEnter(Sender: TObject);
begin
  ViewForm.MousePoint.x := Maxint;
end;

procedure TGridOptionsForm.xyGridCBClick(Sender: TObject);
begin
  ViewForm.GLxyGrid.Visible := xyGridCB.Checked;
  ViewData.xyGrid.IsVisible := xyGridCB.Checked;
  Altered := True;
end;

procedure TGridOptionsForm.xyLockClick(Sender: TObject);
begin
  if xyLock.Checked then
  begin
    if ViewData.xyGrid.xRange.Minimum < ViewData.xzGrid.xRange.Minimum then
      EditxzGridMinx.Text := FloatToStrF(ViewData.xyGrid.xRange.Minimum,
        ffGeneral, 7, 4)
    else
      EditxyGridMinx.Text := FloatToStrF(ViewData.xzGrid.xRange.Minimum,
        ffGeneral, 7, 4);

    if ViewData.xyGrid.yRange.Minimum < ViewData.yzGrid.yRange.Minimum then
      EdityzGridMiny.Text := FloatToStrF(ViewData.xyGrid.yRange.Minimum,
        ffGeneral, 7, 4)
    else
      EditxyGridMiny.Text := FloatToStrF(ViewData.yzGrid.yRange.Minimum,
        ffGeneral, 7, 4);
  end;

  ViewData.xyGrid.IsChecked := xyLock.Checked;
  Altered := True;
end;

procedure TGridOptionsForm.xzGridCBClick(Sender: TObject);
begin
  ViewForm.GLxzGrid.Visible := xzGridCB.Checked;
  ViewData.xzGrid.IsVisible := xzGridCB.Checked;
  Altered := True;
end;

procedure TGridOptionsForm.yzGridCBClick(Sender: TObject);
begin
  ViewForm.GLyzGrid.Visible := yzGridCB.Checked;
  ViewData.yzGrid.IsVisible := yzGridCB.Checked;
  Altered := True;
end;

procedure TGridOptionsForm.zLockClick(Sender: TObject);
begin
  if zLock.Checked then
  begin
    if ViewData.xzGrid.zRange.Minimum < ViewData.yzGrid.zRange.Minimum then
      EdityzGridMinz.Text := FloatToStrF(ViewData.xzGrid.zRange.Minimum,
        ffGeneral, 7, 4)
    else
      EditxzGridMinz.Text := FloatToStrF(ViewData.yzGrid.zRange.Minimum,
        ffGeneral, 7, 4);
  end;

  ViewData.xzGrid.IsChecked := zLock.Checked;
  Altered := True;
end;

procedure TGridOptionsForm.DrawOutline(const Show: Boolean);
var
  Vectors: array [0 .. 7] of TGLVector;

begin
  ViewForm.BoxLine1.Visible := Show;
  ViewForm.BoxLine1.LineWidth := ViewData.BoxLnWidth;

  ViewForm.BoxLine2.Visible := Show;
  ViewForm.BoxLine2.LineWidth := ViewData.BoxLnWidth;

  ViewForm.BoxLine3.Visible := Show;
  ViewForm.BoxLine3.LineWidth := ViewData.BoxLnWidth;

  ViewForm.BoxLine4.Visible := Show;
  ViewForm.BoxLine4.LineWidth := ViewData.BoxLnWidth;

  if Show then
  begin
    if ViewData.xyGrid.xRange.Minimum < ViewData.xzGrid.xRange.Minimum then
      Vectors[0].x := ViewData.xyGrid.xRange.Minimum
    else
      Vectors[0].x := ViewData.xzGrid.xRange.Minimum;

    if ViewData.xyGrid.xRange.Maximum > ViewData.xzGrid.xRange.Maximum then
      Vectors[1].x := ViewData.xyGrid.xRange.Maximum
    else
      Vectors[1].x := ViewData.xzGrid.xRange.Maximum;

    if ViewData.xyGrid.yRange.Minimum < ViewData.yzGrid.yRange.Minimum then
      Vectors[0].y := ViewData.xyGrid.yRange.Minimum
    else
      Vectors[0].y := ViewData.yzGrid.yRange.Minimum;

    if ViewData.xyGrid.yRange.Maximum > ViewData.yzGrid.yRange.Maximum then
      Vectors[2].y := ViewData.xyGrid.yRange.Maximum
    else
      Vectors[2].y := ViewData.yzGrid.yRange.Maximum;

    if ViewData.xzGrid.zRange.Minimum < ViewData.yzGrid.zRange.Minimum then
      Vectors[0].z := ViewData.xzGrid.zRange.Minimum * ViewData.xyGrid.zScale
    else
      Vectors[0].z := ViewData.yzGrid.zRange.Minimum * ViewData.xyGrid.zScale;

    if ViewData.xzGrid.zRange.Maximum > ViewData.yzGrid.zRange.Maximum then
      Vectors[4].z := ViewData.xzGrid.zRange.Maximum * ViewData.xyGrid.zScale
    else
      Vectors[4].z := ViewData.yzGrid.zRange.Maximum * ViewData.xyGrid.zScale;

    Vectors[1].y := Vectors[0].y;
    Vectors[1].z := Vectors[0].z;

    Vectors[2].x := Vectors[1].x;
    Vectors[2].z := Vectors[0].z;

    Vectors[3].x := Vectors[0].x;
    Vectors[3].y := Vectors[2].y;
    Vectors[3].z := Vectors[0].z;

    Vectors[4].x := Vectors[0].x;
    Vectors[4].y := Vectors[0].y;

    Vectors[5].x := Vectors[1].x;
    Vectors[5].y := Vectors[1].y;
    Vectors[5].z := Vectors[4].z;

    Vectors[6].x := Vectors[2].x;
    Vectors[6].y := Vectors[2].y;
    Vectors[6].z := Vectors[4].z;

    Vectors[7].x := Vectors[3].x;
    Vectors[7].y := Vectors[3].y;
    Vectors[7].z := Vectors[4].z;

    with ViewForm.BoxLine1 do
    begin
      Nodes[0].AsVector := Vectors[0];
      Nodes[1].AsVector := Vectors[1];
      Nodes[2].AsVector := Vectors[2];
      Nodes[3].AsVector := Vectors[3];
      Nodes[4].AsVector := Vectors[0];
      Nodes[5].AsVector := Vectors[4];
      Nodes[6].AsVector := Vectors[5];
      Nodes[7].AsVector := Vectors[6];
      Nodes[8].AsVector := Vectors[7];
      Nodes[9].AsVector := Vectors[4];
    end;
    with ViewForm.BoxLine2 do
    begin
      Nodes[0].AsVector := Vectors[1];
      Nodes[1].AsVector := Vectors[5];
    end;
    with ViewForm.BoxLine3 do
    begin
      Nodes[0].AsVector := Vectors[2];
      Nodes[1].AsVector := Vectors[6];
    end;
    with ViewForm.BoxLine4 do
    begin
      Nodes[0].AsVector := Vectors[3];
      Nodes[1].AsVector := Vectors[7];
    end;
  end;
end;

end.
