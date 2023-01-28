unit fFuncts;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.UITypes,
  System.Math,
  System.ImageList,
  Vcl.ImgList,
  Vcl.ClipBrd,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.CheckLst,
  Vcl.Buttons,
  Vcl.ComCtrls,
  Vcl.Menus,
  Vcl.ExtCtrls,

  uGlobal,
  uParser;

type
  TFunctionsForm = class(TForm)
    MainMenu: TMainMenu;
    File1: TMenuItem;
    New1: TMenuItem;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    LabelPhi: TLabel;
    Labeldx: TLabel;
    Labelx: TLabel;
    Labely: TLabel;
    LabelRCos: TLabel;
    LabelRSin: TLabel;
    LabelFunc: TLabel;
    EditSegMin: TEdit;
    EditSegMax: TEdit;
    Editdx: TEdit;
    UpDown1: TUpDown;
    EditLocX: TEdit;
    EditLocY: TEdit;
    ShowLabelCheckBox: TCheckBox;
    ContinuousCheckBox: TCheckBox;
    EditPen: TEdit;
    UpDown2: TUpDown;
    EditCoordinate: TEdit;
    UpDown3: TUpDown;
    EditEvaluate: TEdit;
    Editfx: TEdit;
    SwitchButton: TSpeedButton;
    SegmentButton: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    EvaluateButton: TSpeedButton;
    AddButton: TSpeedButton;
    DeleteButton: TSpeedButton;
    UpButton: TSpeedButton;
    DownButton: TSpeedButton;
    CheckListBox: TCheckListBox;
    BitBtn2: TBitBtn;
    ColorDialog: TColorDialog;
    Open1: TMenuItem;
    Save1: TMenuItem;
    Saveas1: TMenuItem;
    Derivatives1: TMenuItem;
    yfx1: TMenuItem;
    yfx2: TMenuItem;
    Integrate1: TMenuItem;
    Integrate2x: TMenuItem;
    Integrate2y: TMenuItem;
    Between1: TMenuItem;
    Volumex1: TMenuItem;
    Volumey1: TMenuItem;
    SaveDialog: TSaveDialog;
    OpenDialog: TOpenDialog;
    ImageList1: TImageList;
    Findx: TMenuItem;
    fxValue: TMenuItem;
    fx1Value: TMenuItem;
    fx2Value: TMenuItem;
    PenPanel: TPanel;
    CoordPanel: TPanel;
    N1: TMenuItem;
    Exit1: TMenuItem;
    CoordPointButton: TSpeedButton;
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ParseKeyPress(Sender: TObject; var Key: Char);
    procedure IntKeyPress(Sender: TObject; var Key: Char);
    procedure fxKeyPress(Sender: TObject; var Key: Char);
    procedure EditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EditSegMinKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditSegMaxKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditdxKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EditdxChange(Sender: TObject);
    procedure EditLocXKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EditLocYKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EditPenKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EditPenChange(Sender: TObject);
    procedure EvaluateKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EditfxKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure NewClick(Sender: TObject);
    procedure OpenClick(Sender: TObject);
    procedure SaveClick(Sender: TObject);
    procedure SaveAsClick(Sender: TObject);
    procedure yfx1Click(Sender: TObject);
    procedure yfx2Click(Sender: TObject);
    procedure Integrate2xClick(Sender: TObject);
    procedure Integrate2yClick(Sender: TObject);
    procedure Between1Click(Sender: TObject);
    procedure Volumex1Click(Sender: TObject);
    procedure Volumey1Click(Sender: TObject);
    procedure fxValueClick(Sender: TObject);
    procedure fx1ValueClick(Sender: TObject);
    procedure fx2ValueClick(Sender: TObject);
    procedure SwitchClick(Sender: TObject);
    procedure SegmentClick(Sender: TObject);
    procedure ShowLabelClick(Sender: TObject);
    procedure ContinuousClick(Sender: TObject);
    procedure ColorClick(Sender: TObject);
    procedure EvaluateClick(Sender: TObject);
    procedure LabelyClick(Sender: TObject);
    procedure LabelRCosClick(Sender: TObject);
    procedure LabelRSinClick(Sender: TObject);
    procedure CheckListBoxClick(Sender: TObject);
    procedure AddButtonClick(Sender: TObject);
    procedure DeleteButtonClick(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure UpButtonClick(Sender: TObject);
    procedure DownButtonClick(Sender: TObject);
    procedure CheckListBoxClickCheck(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Exit1Click(Sender: TObject);
    procedure CoordPointButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    NewFile: Boolean;
    x1, x2: extended;
    function ReadData(const FName: TFileName): Boolean;
    procedure WriteData(const FName: TFileName);
    function DefaultData: TGraphData;
    procedure ShowData(Sender: TObject);
    procedure OpenSelectedFile(Sender: TObject; FName: TFileName);
    procedure ClosefxValueForm;
    procedure Closefx1ValueForm;
    procedure Closefx2ValueForm;
  public
    procedure ShowCartesianEvaluate;
    procedure ShowPolarEvaluate;
    procedure CloseIntegrateXForm;
    procedure CloseIntegrateYForm;
    procedure CloseBetweenForm;
    procedure CloseVolumeXForm;
    procedure CloseVolumeYForm;
  end;

var
  FunctionsForm: TFunctionsForm;

// =====================================================================
implementation
// =====================================================================

uses
  fMain,
  fGridOpts,
  fDerivative,
  fIntegrateX,
  fIntegrateY,
  fBetween,
  fVolumeX,
  fVolumeY,
  fxValue,
  fx1Value,
  fx2Value,
  fTextBlocks,
  fNumeric;

{$R *.dfm}

procedure TFunctionsForm.FormClose(Sender: TObject; var Action: TCloseAction);
var
  i: integer;
begin
    for i := 0 to CheckListBox.Items.Count - 1 do
    CheckListBox.Items.Objects[i].Free;
  CheckListBox.Clear;
end;

procedure TFunctionsForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  MainForm.Close;
end;

procedure TFunctionsForm.FormCreate(Sender: TObject);
begin
  ReportMemoryLeaksOnShutdown := True;
end;

procedure TFunctionsForm.FormDestroy(Sender: TObject);
var
  i: integer;

begin
  with CheckListBox do
    for i := 0 to Count - 1 do
      Items.Objects[i].Free;
end;

procedure TFunctionsForm.FormShow(Sender: TObject);
begin
  if not ReadData(DataPath + GraphFName) then
  begin
    GraphFName := NewFName;
    NewFile := True;
    GraphData := DefaultData;

    with GraphData, CheckListBox do
    begin
      AddItem(PlotData.TextStr, TPlotDataObject.Create(PlotData));
      ItemIndex := Count - 1;
      Checked[ItemIndex] := True; // initially this item is checked
    end;
  end;

  Caption := GraphFName;
  ShowData(Sender);
  if GridOptionsForm.Visible then
    GridOptionsForm.ShowData;
end;

procedure TFunctionsForm.ParseKeyPress(Sender: TObject; var Key: Char);
begin
  with Sender as TEdit do
  begin
    if not CharInSet(UpCase(Key), [' ', '!', '(', ')', '*', '+', '-', '.', ',',
      '/', '0' .. '9', 'A' .. 'C', 'E', 'G' .. 'I', 'L', 'N' .. 'T', 'X', '^',
      '`', #8]) then
    begin
      Key := #0;
      Exit;
    end
    else if Active then
      BitBtn2.Visible := True;
    if Key = '`' then
      Key := '°';
  end;
  Altered := True;
end;

procedure TFunctionsForm.IntKeyPress(Sender: TObject; var Key: Char);
begin
  with Sender as TEdit do
    if not CharInSet(Key, ['0' .. '9', #8]) then
      Key := #0
end;

procedure TFunctionsForm.fxKeyPress(Sender: TObject; var Key: Char);
begin
  with Sender as TEdit do
  begin
    if not CharInSet(UpCase(Key), [' ', '!', '(', ')', '*', '+', '-', '.', ',',
      '/', '0' .. '9', 'A' .. 'C', 'E', 'G' .. 'I', 'L', 'N' .. 'T', 'X', '\',
      '^', '`', #8]) then
    begin
      Key := #0;
      Exit;
    end;

    if not GraphData.PlotData.PlotAsFx and
      ((Key = '\') or (Key = 'x') or (Key = 'X')) then
      Key := 'Ø';
    if Key = '`' then
      Key := '°';
  end;
  Altered := True;
end;

procedure TFunctionsForm.EditKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_DELETE) or (Key = VK_BACK) then
    Altered := True;
end;

procedure TFunctionsForm.EditSegMinKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  s: string;
  e: byte;

begin
  s := ScanText(EditSegMin.Text);
  x1 := ParseAndEvaluate(s, e);
  if isNAN(x1) or isInfinite(x1) or (e > 0) then
    x1 := -Pi;
  if Active then
    BitBtn2.Visible := True;
end;

procedure TFunctionsForm.EditSegMaxKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  s: string;
  e: byte;

begin
  s := ScanText(EditSegMax.Text);
  x2 := ParseAndEvaluate(s, e);
  if isNAN(x2) or isInfinite(x2) or (e > 0) then
    x2 := Pi;
  // if e > 0 then x2 := Pi;
  if Active then
    BitBtn2.Visible := True;
end;

procedure TFunctionsForm.EditdxKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  e: single;

begin
  if Active then
  begin
    with GraphData, PlotData do
    begin
      if PlotAsFx then
      begin
        try
          e := StrToFloat(Editdx.Text);
          if e = 0 then
            e := 1;
          xInc := e;
        except
          xInc := 1;
        end;
        TPlotDataObject(CheckListBox.Items.Objects[CheckListBox.ItemIndex]).Data.xInc := xInc;
      end
      else { plotting r = f(Ø) }
      begin
        try
          e := StrToFloat(Editdx.Text);
          if e = 0 then
            e := 0.2;
          PhiInc := e;
        except
          PhiInc := 0.2;
        end;
        if PhiInc < PhiIncMin then
          PhiInc := PhiIncMin;
        TPlotDataObject(CheckListBox.Items.Objects[CheckListBox.ItemIndex]).Data.PhiInc := PhiInc;
      end;
    end;
    MainForm.GLViewer.Invalidate;
  end;
end;

procedure TFunctionsForm.EditdxChange(Sender: TObject);
var
  k: Word;
begin
  if Active then
  begin
    k := 0;
    EditdxKeyUp(Sender, k, []);
  end;
end;

procedure TFunctionsForm.EditLocXKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  x: extended;
begin
  try
    x := StrToFloat(EditLocX.Text);
    with GraphData do
    begin
      if x > 0.95 * xMax then
        x := 0.95 * xMax;
      if x < xMin then
        x := xMin;
    end;
  except
    x := 0;
  end;
  TPlotDataObject(CheckListBox.Items.Objects[CheckListBox.ItemIndex]).Data.xLabel := x;
  GraphData.PlotData.xLabel := x;
  MainForm.GLViewer.Invalidate;
end;

procedure TFunctionsForm.EditLocYKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  y: extended;
begin
  try
    y := StrToFloat(EditLocY.Text);
    with GraphData do
    begin
      if y > yMax then
        y := yMax;
      if y < 0.95 * yMin then
        y := 0.95 * yMin;
    end;
  except
    y := 0;
  end;
  TPlotDataObject(CheckListBox.Items.Objects[CheckListBox.ItemIndex]).Data.yLabel := y;
  GraphData.PlotData.yLabel := y;
  MainForm.GLViewer.Invalidate;
end;

procedure TFunctionsForm.EditPenKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  w: integer;

begin
  if Active then
    with Sender as TEdit do
    begin
      try
        w := StrToInt(Text);
      except
        w := 1;
      end;
      if w < 1 then
        w := 1;
      with GraphData do
        case Tag of
          0:
            begin // sent from EditPen
              PlotData.PlotWidth := w;
              with CheckListBox do
                TPlotDataObject(Items.Objects[ItemIndex]).Data.PlotWidth := w;
            end;
          1:
            CoordWidth := w; // sent from EditCoordinate
        end;
      Altered := True;
      MainForm.GLViewer.Invalidate;
    end;
end;

procedure TFunctionsForm.EditPenChange(Sender: TObject);
var
  k: Word;

begin
  k := 0;
  EditPenKeyUp(Sender, k, []);
end;

procedure TFunctionsForm.EvaluateKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  s: string;
  e: byte;

begin
  if EditEvaluate.Text <> '' then
  begin
    s := ScanText(EditEvaluate.Text);
    xEvaluate := ParseAndEvaluate(s, e);
    if e = 0 then
      MainForm.GLViewer.Invalidate;
  end;
end;

procedure TFunctionsForm.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TFunctionsForm.EditfxKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  with TPlotDataObject(CheckListBox.Items.Objects[CheckListBox.ItemIndex]).Data do
  begin
    TextStr := Editfx.Text;
    FunctStr := ScanText(TextStr);
    GraphData.PlotData.FunctStr := FunctStr;
    GraphData.PlotData.TextStr := TextStr;
  end;
  CheckListBox.Items[CheckListBox.ItemIndex] := Editfx.Text;
  MainForm.GLViewer.Invalidate;
end;

procedure TFunctionsForm.NewClick(Sender: TObject);
var
  i: integer;

begin
  if Altered then
    case MessageDlg('The current graph data has been altered.' +
      #13#10'Do you wish to save the alterations ?', mtConfirmation,
      [mbYes, mbNo, mbCancel], 0) of
      mrYes:
        SaveClick(Sender);
      mrCancel:
        Exit;
    end;

  for i := 0 to CheckListBox.Items.Count - 1 do
    CheckListBox.Items.Objects[i].Free;
  CheckListBox.Clear;

  GraphFName := NewFName;
  Caption := GraphFName;
  MainForm.Caption := GraphFName;
  GridOptionsForm.Caption := GraphFName;
  NumericForm.Caption := GraphFName;
  NumericForm.ClearCheckListBox;
  NumericForm.DataListBox.Clear;
  NumericForm.ShowData(Sender);
  TextBlocksForm.Caption := GraphFName;

  NewFile := True;
  Altered := True;
  GraphData := DefaultData;

  with GraphData do
    CheckListBox.AddItem(PlotData.TextStr, TPlotDataObject.Create(PlotData));

  CheckListBox.ItemIndex := 0;
  CheckListBox.Checked[CheckListBox.ItemIndex] := True;
  ShowData(Sender);
  GridOptionsForm.ShowData;
  GridOptionsForm.ApplyBitBtn.Visible := false;
  TextBlocksForm.ClearTextBlocks;
  (*
    NewFont needed to initialize GLWinFont.GetCharWidth
    if the font has been altered, which may or may not be the case,
    so do it anyway
  *)
  NewFont := True;
  MainForm.GLViewer.Invalidate;
end;

procedure TFunctionsForm.OpenClick(Sender: TObject);
begin
  if Altered then
    case MessageDlg('The current graph data has been altered.' +
      #13#10'Do you wish to save the alterations ?', mtConfirmation,
      [mbYes, mbNo, mbCancel], 0) of
      mrYes:
        SaveClick(Sender);
      mrCancel:
        Exit;
      mrNo:
        begin
          Altered := false;
          NewFile := false;
        end
    end;

  OpenDialog.InitialDir := DataPath;
  if OpenDialog.Execute then
  begin
    DataPath := ExtractFilePath(OpenDialog.FileName);
    DataPath := IncludeTrailingPathDelimiter(DataPath);
    MainForm.oMousex := -1;
    OpenSelectedFile(Sender, OpenDialog.FileName);
  end;
end;

procedure TFunctionsForm.SaveClick(Sender: TObject);
begin
  if NewFile then
    SaveAsClick(Sender)
  else
    WriteData(DataPath + GraphFName);
end;

procedure TFunctionsForm.SaveAsClick(Sender: TObject);
begin
  SaveDialog.InitialDir := DataPath;
  SaveDialog.FileName := GraphFName;
  if SaveDialog.Execute then
  begin
    GraphFName := ExtractFileName(SaveDialog.FileName);
    DataPath := ExtractFilePath(SaveDialog.FileName);
    DataPath := IncludeTrailingPathDelimiter(DataPath);
    WriteData(DataPath + GraphFName);
  end;
  Caption := GraphFName;
  MainForm.Caption := GraphFName;
  GridOptionsForm.Caption := GraphFName;
  NumericForm.Caption := GraphFName;
  TextBlocksForm.Caption := GraphFName;
end;

procedure TFunctionsForm.yfx1Click(Sender: TObject);
begin
  if yfx1.Checked then
  begin
    DerivativeForm.Show;
    yfx1.ImageIndex := -1;
    CheckListBoxClick(Sender);
  end
  else
  begin
    if yfx2.Checked then
      yfx2.Checked := false;
    yfx1.ImageIndex := 1;
    yfx2.ImageIndex := 2;
    with DerivativeForm do
      if Visible then
        Close;
  end;
  MainForm.GLViewer.Invalidate;
end;

procedure TFunctionsForm.yfx2Click(Sender: TObject);
begin
  if yfx2.Checked then
  begin
    if not yfx1.Checked then
      yfx1.Checked := True;
    with DerivativeForm do
      if not Visible then
        Show;
    yfx1.ImageIndex := -1;
    yfx2.ImageIndex := -1;
    CheckListBoxClick(Sender);
  end
  else
    yfx2.ImageIndex := 2;

  DerivativeForm.ShowData;
  MainForm.GLViewer.Invalidate;
end;

procedure TFunctionsForm.Integrate2xClick(Sender: TObject);
begin
  if Integrate2x.Checked then
  begin
    if Integrate2y.Checked then
      CloseIntegrateYForm;
    if Between1.Checked then
      CloseBetweenForm;
    if Volumex1.Checked then
      CloseVolumeXForm;
    if Volumey1.Checked then
      CloseVolumeYForm;
    CheckListBoxClick(Sender);
    IntegrateXForm.PlotIntegrated := piBoth;
    IntegrateXForm.Show;
    Integrate2x.ImageIndex := -1;
  end
  else
  begin
    Integrate2x.ImageIndex := 4;
    IntegrateXForm.Close;
    IntegrateXForm.PlotIntegrated := piCalc;
    MainForm.GLViewer.Invalidate;
  end;
end;

procedure TFunctionsForm.Integrate2yClick(Sender: TObject);
begin
  if Integrate2y.Checked then
  begin
    if Integrate2x.Checked then
      CloseIntegrateXForm;
    if Between1.Checked then
      CloseBetweenForm;
    if Volumex1.Checked then
      CloseVolumeXForm;
    if Volumey1.Checked then
      CloseVolumeYForm;
    CheckListBoxClick(Sender);
    IntegrateYForm.Show;
    Integrate2y.ImageIndex := -1;
  end
  else
  begin
    Integrate2y.ImageIndex := 4;
    IntegrateYForm.Close;
    MainForm.GLViewer.Invalidate;
  end;
end;

procedure TFunctionsForm.Between1Click(Sender: TObject);
begin
  if CheckListBox.Count < 2 then
    Exit;

  if Between1.Checked then
  begin
    if Integrate2x.Checked then
      CloseIntegrateXForm;
    if Integrate2y.Checked then
      CloseIntegrateYForm;
    if Volumex1.Checked then
      CloseVolumeXForm;
    if Volumey1.Checked then
      CloseVolumeYForm;
    with CheckListBox do
    begin
      ItemIndex := 0;
      Checked[0] := True;
      Checked[1] := True;
    end;
    CheckListBoxClick(Sender);
    BetweenForm.Show;
    Between1.ImageIndex := -1;
  end
  else
  begin
    Between1.ImageIndex := 5;
    BetweenForm.Close;
    MainForm.GLViewer.Invalidate;
  end;
end;

procedure TFunctionsForm.Volumex1Click(Sender: TObject);
begin
  if Volumex1.Checked then
  begin
    if Integrate2x.Checked then
      CloseIntegrateXForm;
    if Integrate2y.Checked then
      CloseIntegrateYForm;
    if Between1.Checked then
      CloseBetweenForm;
    if Volumey1.Checked then
      CloseVolumeYForm;
    CheckListBoxClick(Sender);
    Volumex1.ImageIndex := -1;
    VolumeXForm.Show;
  end
  else
  begin
    VolumeXForm.HideFunctionCheckBox.Checked := false;
    Volumex1.ImageIndex := 6;
    VolumeXForm.Close;
    MainForm.GLViewer.Invalidate;
  end;
end;

procedure TFunctionsForm.Volumey1Click(Sender: TObject);
begin
  if Volumey1.Checked then
  begin
    if Integrate2x.Checked then
      CloseIntegrateXForm;
    if Integrate2y.Checked then
      CloseIntegrateYForm;
    if Between1.Checked then
      CloseBetweenForm;
    if Volumex1.Checked then
      CloseVolumeXForm;
    CheckListBoxClick(Sender);
    Volumey1.ImageIndex := -1;
    VolumeYForm.Show;
  end
  else
  begin
    VolumeYForm.HideFunctionCheckBox.Checked := false;
    Volumey1.ImageIndex := 7;
    VolumeYForm.Close;
    MainForm.GLViewer.Invalidate;
  end;
end;

procedure TFunctionsForm.fxValueClick(Sender: TObject);
begin
  if fxValue.Checked then
  begin
    if fx1Value.Checked then
      Closefx1ValueForm;
    if fx2Value.Checked then
      Closefx2ValueForm;
    CheckListBoxClick(Sender);
    fxValue.ImageIndex := -1;
    fxValueForm.Show;
  end
  else
  begin
    fxValue.ImageIndex := 0;
    fxValueForm.Close;
  end;
end;

procedure TFunctionsForm.fx1ValueClick(Sender: TObject);
begin
  if fx1Value.Checked then
  begin
    if fxValue.Checked then
      ClosefxValueForm;
    if fx2Value.Checked then
      Closefx2ValueForm;
    CheckListBoxClick(Sender);
    fx1Value.ImageIndex := -1;
    fx1ValueForm.Show;
  end
  else
  begin
    fx1ValueForm.Close;
    fx1Value.ImageIndex := 1;
  end;
end;

procedure TFunctionsForm.fx2ValueClick(Sender: TObject);
begin
  if fx2Value.Checked then
  begin
    if fxValue.Checked then
      ClosefxValueForm;
    if fx1Value.Checked then
      Closefx1ValueForm;
    CheckListBoxClick(Sender);
    fx2Value.ImageIndex := -1;
    fx2ValueForm.Show;
  end
  else
  begin
    fx2ValueForm.Close;
    fx2Value.ImageIndex := 2;
  end;
end;

procedure TFunctionsForm.SwitchClick(Sender: TObject);
begin
  with CheckListBox do
    GraphData.PlotData := TPlotDataObject(Items.Objects[ItemIndex]).Data;

  with GraphData, PlotData do
  begin
    with SwitchButton do
    begin
      PlotAsFx := Tag = 1;
      Tag := (Tag + 1) mod 2;
    end;

    if not PlotAsFx and ((SegMax - SegMin) / PhiInc > 1E6) then
    begin
      MessageDlg('The current graph data'#13#10 +
        'can not be plotted as y = f(Ø).'#13#10 + 'The range is too large.',
        mtError, [mbOK], 0);
      SwitchButton.Tag := 0;
      PlotAsFx := True;
      Exit;
    end;

    with CheckListBox do
      TPlotDataObject(Items.Objects[ItemIndex]).Data.PlotAsFx := PlotAsFx;
  end;

  CheckListBoxClick(Sender);
  Altered := True;
end;

procedure TFunctionsForm.SegmentClick(Sender: TObject);
begin
  with GraphData.PlotData do
  begin
    with SegmentButton do
    begin
      IsSegment := Tag = 1;
      Tag := (Tag + 1) mod 2;
    end;
    with CheckListBox do
      TPlotDataObject(Items.Objects[ItemIndex]).Data.IsSegment := IsSegment;
  end;
  CheckListBoxClick(Sender);
end;

procedure TFunctionsForm.ShowLabelClick(Sender: TObject);
begin
  Label7.Visible := ShowLabelCheckBox.Checked;
  EditLocX.Visible := ShowLabelCheckBox.Checked;
  EditLocY.Visible := ShowLabelCheckBox.Checked;
  GraphData.PlotData.ShowLabel := ShowLabelCheckBox.Checked;
  with CheckListBox do
    TPlotDataObject(Items.Objects[ItemIndex]).Data.ShowLabel :=
      GraphData.PlotData.ShowLabel;
  Altered := True;
  MainForm.GLViewer.Invalidate;
end;

procedure TFunctionsForm.ContinuousClick(Sender: TObject);
begin
  GraphData.PlotData.IsContinuous := ContinuousCheckBox.Checked;
  with CheckListBox do
    TPlotDataObject(Items.Objects[ItemIndex]).Data.IsContinuous :=
      GraphData.PlotData.IsContinuous;
  Altered := True;
  MainForm.GLViewer.Invalidate;
end;

procedure TFunctionsForm.CoordPointButtonClick(Sender: TObject);
var
  k: Word;

begin
  if (NumericForm.CheckListBox.Count > 0) and
    (NumericForm.CheckListBox.ItemIndex > -1) and
    (NumericForm.CheckListBox.ItemIndex < NumericForm.CheckListBox.Count) and
    (NumericForm.InputRG.ItemIndex = 0) then
  begin
    if (Labely.Caption = 'y = Infinitely positive') or
      (Labely.Caption = 'y = Undefined') then
    begin
      Beep;
      Exit;
    end;
    k := VK_RETURN;
    if SwitchButton.Tag = 0 then
    begin
      NumericForm.EditXCoord.Text := EditEvaluate.Text;
      NumericForm.EditYCoord.Text :=
        Copy(Labely.Caption, pos('=', Labely.Caption) + 2,
        Length(Labely.Caption));
    end
    else
    begin
      if NumericForm.CoordsRG.ItemIndex = 1 then // .RadialCheckBox.Checked then
      begin
        NumericForm.EditXCoord.Text := EditEvaluate.Text;
        NumericForm.EditYCoord.Text :=
          Copy(Labely.Caption, pos('=', Labely.Caption) + 2,
          Length(Labely.Caption));
      end
      else
      begin
        NumericForm.EditXCoord.Text := Copy(LabelRCos.Caption,
          pos('=', LabelRCos.Caption) + 2, Length(LabelRCos.Caption));
        NumericForm.EditYCoord.Text := Copy(LabelRSin.Caption,
          pos('=', LabelRSin.Caption) + 2, Length(LabelRSin.Caption));
      end;
    end;
    NumericForm.EditXCoord.SetFocus;
    NumericForm.EditXCoordKeyUp(Sender, k, []);
    NumericForm.EditYCoordKeyUp(Sender, k, []);
  end
  else
    MessageDlg('The data for the coordinate can not' +
      #13#10'be entered in the Numeric data form' +
      #13#10'as the settings are not correct.' +
      #13#10'Select ''Adding'' for ''Input Options''.', mtInformation,
      [mbOK], 0);
end;

procedure TFunctionsForm.ColorClick(Sender: TObject);
var
  i: integer;

begin
  with GraphData do
  begin
    if Sender.ClassType = TPanel then
      i := TPanel(Sender).Tag
    else
      i := TSpeedButton(Sender).Tag;

    case i of
      0:
         ColorDialog.Color := TPlotDataObject(CheckListBox.Items.Objects[
           CheckListBox.ItemIndex]).Data.PlotColor;
      1:
        ColorDialog.Color := CoordColor;
    end;
    if ColorDialog.Execute then
    begin
      case TSpeedButton(Sender).Tag of
        0:
          begin
            PlotData.PlotColor := ColorDialog.Color;
            with CheckListBox do
              TPlotDataObject(Items.Objects[ItemIndex]).Data.PlotColor :=
                ColorDialog.Color;
            PenPanel.Color := ColorDialog.Color;
          end;
        1:
          begin
            CoordColor := ColorDialog.Color;
            CoordPanel.Color := ColorDialog.Color;
          end;
      end;
      Altered := True;
      MainForm.GLViewer.Invalidate;
    end;
  end;
end;

procedure TFunctionsForm.EvaluateClick(Sender: TObject);
var
  k: Word;

begin
  with EvaluateButton do
    Tag := (Tag + 1) mod 2;

  CheckListBoxClick(Sender);

  CoordPointButton.Visible := EditEvaluate.Visible and NumericForm.Visible and
    (NumericForm.CheckListBox.Count > 0) and
    (NumericForm.CheckListBox.ItemIndex > -1) and
    (NumericForm.CheckListBox.ItemIndex < NumericForm.CheckListBox.Count) and
    (NumericForm.InputRG.ItemIndex = 0);

  if EditEvaluate.Visible then
  begin
    EditEvaluate.SetFocus;
    if EditEvaluate.Text <> '' then
    begin
      k := 0;
      EditEvaluate.SelStart := Length(EditEvaluate.Text);
      EvaluateKeyUp(Sender, k, []);
    end;
  end
  else
    MainForm.GLViewer.Invalidate;
end;

procedure TFunctionsForm.LabelyClick(Sender: TObject);
begin
  Clipboard.Clear;
  Clipboard.AsText := Copy(Labely.Caption, pos('=', Labely.Caption) + 2,
    Length(Labely.Caption));
end;

procedure TFunctionsForm.LabelRCosClick(Sender: TObject);
begin
  Clipboard.Clear;
  Clipboard.AsText := Copy(LabelRCos.Caption, pos('=', LabelRCos.Caption) + 2,
    Length(LabelRCos.Caption));
end;

procedure TFunctionsForm.LabelRSinClick(Sender: TObject);
begin
  Clipboard.Clear;
  Clipboard.AsText := Copy(LabelRSin.Caption, pos('=', LabelRSin.Caption) + 2,
    Length(LabelRSin.Caption));
end;

procedure TFunctionsForm.CheckListBoxClick(Sender: TObject);
begin
  if BitBtn2.Visible then
    BitBtn2Click(Sender);
  with CheckListBox do
    if Count > 0 then
      with GraphData do
      begin
        PlotData := TPlotDataObject(Items.Objects[ItemIndex]).Data;

        EvaluateButton.Visible := Checked[ItemIndex];
        if (EvaluateButton.Tag = 1) and not Checked[ItemIndex] then
          EvaluateButton.Tag := 0;
        CoordPointButton.Visible := EvaluateButton.Tag = 1;

        if PlotData.PlotAsFx then
        begin
          yfx1.Caption := 'y = f''(x)';
          yfx2.Caption := 'y = f"(x)';
        end
        else
        begin
          yfx1.Caption := 'y = f''(Ø)';
          yfx2.Caption := 'y = f"(Ø)';

          if Integrate2y.Checked then
            CloseIntegrateYForm;
          if Between1.Checked then
            CloseBetweenForm;
          if Volumex1.Checked then
            CloseVolumeXForm;
          if Volumey1.Checked then
            CloseVolumeYForm;
          if fxValue.Checked then
            ClosefxValueForm;
          if fx1Value.Checked then
            Closefx1ValueForm;
          if fx2Value.Checked then
            Closefx2ValueForm;
        end;
      end;

  MainForm.GLViewer.Invalidate;
  ShowData(Sender);
  DerivativeForm.ShowData;
  IntegrateXForm.ShowData;
  IntegrateYForm.ShowData;
  BetweenForm.ShowData;
  VolumeXForm.ShowData;
  VolumeYForm.ShowData;
  with fxValueForm do
    if Visible then
    begin
      ShowData;
      SetFocus;
      RecalcBtnClick(Sender);
    end;
  with fx1ValueForm do
    if Visible then
    begin
      ShowData;
      SetFocus;
      RecalcBtnClick(Sender);
    end;
  with fx2ValueForm do
    if Visible then
    begin
      ShowData;
      SetFocus;
      RecalcBtnClick(Sender);
    end;
end;

procedure TFunctionsForm.CheckListBoxClickCheck(Sender: TObject);
begin
  Altered := True;
end;

procedure TFunctionsForm.BitBtn2Click(Sender: TObject);
var
  k: Word;

  procedure Swap(var N1, n2: extended);
  var
    n: extended;

  begin
    n := N1;
    N1 := n2;
    n2 := n;
  end;

begin
  k := 0;
  EditSegMinKeyUp(Sender, k, []);
  EditSegMaxKeyUp(Sender, k, []);

  if x1 = x2 then
    x2 := 1.1 * x1;
  if x1 > x2 then
    Swap(x1, x2);

  with GraphData.PlotData do
  begin
    SegMin := x1;
    SegMax := x2;
  end;

  with CheckListBox, TPlotDataObject(Items.Objects[ItemIndex]).Data do
  begin
    SegMin := x1;
    SegMax := x2;
  end;
  Altered := True;
  MainForm.GLViewer.Invalidate;
  BitBtn2.Visible := false;
end;

procedure TFunctionsForm.AddButtonClick(Sender: TObject);
begin
  with CheckListBox, GraphData do
  begin
    PlotData := TPlotDataObject(Items.Objects[ItemIndex]).Data;
    AddItem(PlotData.TextStr, TPlotDataObject.Create(PlotData));
    ItemIndex := Count - 1;
    Checked[ItemIndex] := True;
    DeleteButton.Enabled := True;
    UpButton.Enabled := True;
    DownButton.Enabled := True;
  end;
  Altered := True;
  MainForm.GLViewer.Invalidate;
  Editfx.SetFocus;
  Editfx.SelStart := 0;
end;

procedure TFunctionsForm.DeleteButtonClick(Sender: TObject);
var
  i: integer;

begin
  if CheckListBox.Count > 1 then
  begin
    with CheckListBox do
    begin
      i := ItemIndex;
      with Items.Objects[i] as TPlotDataObject do
        Free;
      Items.Delete(i);
      if i > Count - 1 then
        i := Count - 1;
      ItemIndex := i;
      DeleteButton.Enabled := Count > 1;
    end;
    Altered := True;
    MainForm.GLViewer.Invalidate;
  end
end;

procedure TFunctionsForm.BitBtn1Click(Sender: TObject);
begin
  Close;
end;

procedure TFunctionsForm.UpButtonClick(Sender: TObject);
var
  i: integer;

begin
  with CheckListBox do
  begin
    i := ItemIndex;
    if i > 0 then
      Items.Move(i, i - 1);
    if i > 1 then
      ItemIndex := i - 1
    else
      ItemIndex := 0;
  end;
  CheckListBoxClick(Sender);
  Altered := True;
end;

procedure TFunctionsForm.DownButtonClick(Sender: TObject);
var
  i: integer;

begin
  with CheckListBox do
  begin
    i := ItemIndex;
    if i < Count - 1 then
      Items.Move(i, i + 1);
    ItemIndex := i + 1;
  end;
  CheckListBoxClick(Sender);
  Altered := True;
end;

function TFunctionsForm.ReadData(const FName: TFileName): Boolean;
var
  s, t: string;
  f: TextFile;
  i, j, k, l, m, n: integer;
  c: TColor;
  td: TTextData;
  vx, vy: extended;

begin
  Result := false;
  if FileExists(FName) then
  begin
    AssignFile(f, FName);
    try
      Reset(f);
      if FileSize(f) = 0 then
      begin
        CloseFile(f);
        Result := false;
        CheckListBox.ItemIndex := CheckListBox.Count - 1;
        MessageDlg('File Error!'#13#10'The file '#13#10'"' + FName + '"' +
          #13#10'is empty.', mtError, [mbOK], 0);
        Exit;
      end;
      Readln(f, s);
      j := 0;
      i := pos(#9, s);

      while i > 0 do
      begin
        t := Copy(s, 1, i - 1);
        s := Copy(s, i + 1, Length(s));
        i := pos(#9, s);
        Inc(j);

        case j of
          1:
            TryStrToFloat(t, GraphData.xMin);
          2:
            TryStrToFloat(t, GraphData.yMin);
          3:
            TryStrToFloat(t, GraphData.xMax);
          4:
            TryStrToFloat(t, GraphData.yMax);
          5:
            TryStrToFloat(t, GraphData.SavexMin);
          6:
            TryStrToFloat(t, GraphData.SaveyMin);
          7:
            TryStrToFloat(t, GraphData.SavexMax);
          8:
            TryStrToFloat(t, GraphData.SaveyMax);
          9:
            TryStrToFloat(t, GraphData.AreaAlpha);
          10:
            GraphData.FontName := t;
          11:
            begin
              GraphData.FontStyle := [];
              if pos('fsBold', t) > 0 then
                Include(GraphData.FontStyle, fsBold);
              if pos('fsItalic', t) > 0 then
                Include(GraphData.FontStyle, fsItalic);
              if pos('fsUnderline', t) > 0 then
                Include(GraphData.FontStyle, fsUnderline);
              if pos('fsStrikeOut', t) > 0 then
                Include(GraphData.FontStyle, fsStrikeOut);
            end;
          12:
            GraphData.FontSize := StrToInt(t);
          13:
            GraphData.AxisWidth := StrToInt(t);
          14:
            TryStrToInt(t, GraphData.xMinorGrad);
          15:
            TryStrToInt(t, GraphData.yMinorGrad);
          16:
            TryStrToInt(t, GraphData.xMajorGrad);
          17:
            TryStrToInt(t, GraphData.yMajorGrad);
          18:
            TryStrToInt(t, GraphData.MinorWidth);
          19:
            TryStrToInt(t, GraphData.MajorWidth);
          20:
            TryStrToInt(t, GraphData.CoordWidth);
          21:
            TryStrToInt(t, GraphData.dydxWidth);
          22:
            TryStrToInt(t, GraphData.d2ydx2Width);
          23:
            TryStrToInt(t, GraphData.IntegCount);
          24:
            TryStrToInt(t, GraphData.ydxWidth);
          25:
            GraphData.BackColor := StrToInt(t);
          26:
            GraphData.GridColor := StrToInt(t);
          27:
            GraphData.xAxisColor := StrToInt(t);
          28:
            GraphData.yAxisColor := StrToInt(t);
          29:
            GraphData.CoordColor := StrToInt(t);
          30:
            GraphData.dydxColor := StrToInt(t);
          31:
            GraphData.d2ydx2Color := StrToInt(t);
          32:
            GraphData.ydxColor := StrToInt(t);
          33:
            GraphData.PosAreaColor := StrToInt(t);
          34:
            GraphData.NegAreaColor := StrToInt(t);
          35:
            GraphData.Grid.xAxisStyle := TAxisStyle(StrToInt(t));
          36:
            GraphData.Grid.yAxisStyle := TAxisStyle(StrToInt(t));
          37:
            GraphData.Grid.GridStyle := TGridStyle(StrToInt(t));
        end;
      end;
      // with GridOptionsForm
      GridOptionsForm.xTrackBar.Position := GraphData.xMinorGrad;
      GridOptionsForm.yTrackBar.Position := GraphData.yMinorGrad;

      n := StrToInt(s); // number of functions to plot

      for k := 0 to n - 1 do
      begin // read each function's data
        Readln(f, s);
        j := 0;
        i := pos(#9, s);

        while i > 0 do
        begin
          t := Copy(s, 1, i - 1);
          s := Copy(s, i + 1, Length(s));
          i := pos(#9, s);
          Inc(j);
          with GraphData.PlotData do
            case j of
              1:
                FunctStr := t;
              2:
                TextStr := t;
              3:
                TryStrToFloat(t, xInc);
              4:
                PlotWidth := StrToInt(t);
              5:
                PlotColor := StrToInt(t);
              6:
                TryStrToFloat(t, PhiInc);
              7:
                TryStrToFloat(t, SegMin);
              8:
                TryStrToFloat(t, SegMax);
              9:
                TryStrToFloat(t, xLabel);
              10:
                TryStrToFloat(t, yLabel);
              11:
                ShowLabel := StrToBool(t);
              12:
                PlotAsFx := StrToBool(t);
              13:
                IsSegment := StrToBool(t);
              14:
                IsContinuous := StrToBool(t);
            end;
        end;

        CheckListBox.AddItem(GraphData.PlotData.TextStr,
          TPlotDataObject.Create(GraphData.PlotData));
        CheckListBox.Checked[CheckListBox.Count - 1] := StrToBool(s);
      end;

      with NumericForm do
      begin
        ClearCheckListBox;
        Readln(f, s);
        n := StrToInt(s); // number of numeric graphs
        m := 0;
        vx := 0;
        for k := 0 to n - 1 do
        begin
          Readln(f, s);
          j := 0;
          i := pos(#9, s);

          while i > 0 do
          begin
            t := Copy(s, 1, i - 1);
            s := Copy(s, i + 1, Length(s));
            i := pos(#9, s);
            Inc(j);

            case j of
              1:
                NumericData.Name := t;
              2:
                NumericData.NumericStyle := TNumericStyle(StrToInt(t));
              3:
                NumericData.ShowPoints := StrToBool(t);
              4:
                NumericData.PointStyle := TPointStyle(StrToInt(t));
              5:
                NumericData.PointSize := StrToInt(t);
              6:
                NumericData.PointColor := StrToInt(t);
              7:
                NumericData.PlotWidth := StrToInt(t);
              8:
                NumericData.PlotColor := StrToInt(t);
              9:
                NumericData.SortXValue := StrToBool(t);
              10:
                NumericData.Extrapolate := StrToBool(t);
              11:
                TryStrToInt(t, NumericData.CoordsIdx);
              12:
                TryStrToInt(t, NumericData.CurveRate);
              // was k0 = CurveRate/100
              13:
                m := StrToInt(t); // number of plot points
            end;
          end;

          with CheckListBox do
          begin
            AddItem(NumericData.Name, TNumericObject.Create(NumericData));
            Checked[Count - 1] := StrToBool(s); // Checked
          end;

          if m > 0 then
          begin
            Readln(f, s);
            j := 0;
            i := pos(#9, s);

            while i > 0 do
            begin
              t := Copy(s, 1, i - 1);
              s := Copy(s, i + 1, Length(s));
              i := pos(#9, s);
              Inc(j);
              if Odd(j) then
                TryStrToFloat(t, vx)
              else
              begin
                TryStrToFloat(t, vy);
                with TNumericObject(CheckListBox.Items.Objects
                  [CheckListBox.Count - 1]) do
                  ControlPoints.Add(TGraphPointObject.Create(vx, vy));
              end;
            end;
          end;
        end;
        ShowData(Self);
        UpdateDataListBox;
      end;

      TextBlocksForm.ClearTextBlocks;
      Readln(f, s);
      n := StrToInt(s); // number of TextBlocks

      for k := 0 to n - 1 do
      begin // read each TextBlock's data
        Readln(f, s);
        j := 0;
        i := pos(#9, s);

        while i > 0 do
        begin
          t := Copy(s, 1, i - 1);
          s := Copy(s, i + 1, Length(s));
          i := pos(#9, s);
          Inc(j);
          case j of
            1:
              Caption := t;
            2:
              TryStrToFloat(t, td.xLoc);
            3:
              TryStrToFloat(t, td.yLoc);
            4:
              TryStrToInt(t, td.yInc);
            5:
              td.FontName := t;
            6:
              begin
                td.FontStyle := [];
                if pos('fsBold', t) > 0 then
                  Include(td.FontStyle, fsBold);
                if pos('fsItalic', t) > 0 then
                  Include(td.FontStyle, fsItalic);
                if pos('fsUnderline', t) > 0 then
                  Include(td.FontStyle, fsUnderline);
                if pos('fsStrikeOut', t) > 0 then
                  Include(td.FontStyle, fsStrikeOut);
              end;
            7:
              td.FontSize := StrToInt(t);
            8:
              td.FontColor := StrToInt(t);
          end;
        end;

        with TextBlocksForm.BlockListBox do
        begin
          AddItem(td.Caption, TTextDataObject.Create(td));
          ItemIndex := k;
          Checked[k] := StrToBool(s);
        end;

        Readln(f, s);
        m := StrToInt(s); // number of TextLines

        for l := 0 to m - 1 do
        begin // read each line
          Readln(f, s);
          i := pos(#9, s);
          with TTextDataObject(TextBlocksForm.BlockListBox.Items.Objects[k]) do
          begin
            t := Copy(s, 1, i - 1);
            c := StrToInt(Copy(s, i + 1, Length(s)));
            TextLines.Add(TTextLineObject.Create(t, c));
          end;
        end;
      end;

      with TextBlocksForm do
        if Visible then
        begin
          ShowData(Self);
          if BlockListBox.Count > 0 then
            BlockListBoxClick(Self);
        end;

    except
      MessageDlg('File Error! An Error has occurred' +
        #13#10'when attempting to read "' + FName + '".', mtError, [mbOK], 0);
      CloseFile(f);
      Exit;
    end;
    CloseFile(f);
    Result := True;
    MainForm.GLViewer.Buffer.BackgroundColor := GraphData.BackColor;
    CheckListBox.ItemIndex := CheckListBox.Count - 1;
  end;
end;

procedure TFunctionsForm.WriteData(const FName: TFileName);
var
  f: TextFile;
  s: string;
  i, j, TextLineCount: integer;

begin
  try
    AssignFile(f, FName);
    try
      Rewrite(f); { write tab delimited data }
      with GraphData do
      begin
        s := FloatToStr(xMin) + #9 + FloatToStr(yMin) + #9 + FloatToStr(xMax) +
          #9 + FloatToStr(yMax) + #9 + FloatToStr(SavexMin) + #9 +
          FloatToStr(SaveyMin) + #9 + FloatToStr(SavexMax) + #9 +
          FloatToStr(SaveyMax) + #9 + FloatToStr(AreaAlpha) + #9 +
          FontName + #9;
        if fsBold in FontStyle then
          s := s + 'fsBold';
        if fsItalic in FontStyle then
          s := s + 'fsItalic';
        if fsUnderline in FontStyle then
          s := s + 'fsUnderline';
        if fsStrikeOut in FontStyle then
          s := s + 'fsStrikeOut';
        s := s + #9 + IntToStr(FontSize) + #9 + IntToStr(AxisWidth) + #9 +
          IntToStr(xMinorGrad) + #9 + IntToStr(yMinorGrad) + #9 +
          IntToStr(xMajorGrad) + #9 + IntToStr(yMajorGrad) + #9 +
          IntToStr(MinorWidth) + #9 + IntToStr(MajorWidth) + #9 +
          IntToStr(CoordWidth) + #9 + IntToStr(dydxWidth) + #9 +
          IntToStr(d2ydx2Width) + #9 + IntToStr(IntegCount) + #9 +
          IntToStr(ydxWidth) + #9 + IntToStr(BackColor) + #9 +
          IntToStr(GridColor) + #9 + IntToStr(xAxisColor) + #9 +
          IntToStr(yAxisColor) + #9 + IntToStr(CoordColor) + #9 +
          IntToStr(dydxColor) + #9 + IntToStr(d2ydx2Color) + #9 +
          IntToStr(ydxColor) + #9 + IntToStr(PosAreaColor) + #9 +
          IntToStr(NegAreaColor) + #9 + IntToStr(Ord(Grid.xAxisStyle)) + #9 +
          IntToStr(Ord(Grid.yAxisStyle)) + #9 + IntToStr(Ord(Grid.GridStyle)) +
          #9 + IntToStr(CheckListBox.Count); { number of functions }
      end;
      writeln(f, s);

      for i := 0 to CheckListBox.Count - 1 do
      begin { write each function's data }
        with TPlotDataObject(CheckListBox.Items.Objects[i]).Data do
        begin
          FunctStr := Trim(FunctStr);
          TextStr := Trim(TextStr);
          s := FunctStr + #9 + TextStr + #9 + FloatToStr(xInc) + #9 +
            IntToStr(PlotWidth) + #9 + IntToStr(PlotColor) + #9 +
            FloatToStr(PhiInc) + #9 + FloatToStr(SegMin) + #9 +
            FloatToStr(SegMax) + #9 + FloatToStr(xLabel) + #9 +
            FloatToStr(yLabel) + #9 + BoolToStr(ShowLabel) + #9 +
            BoolToStr(PlotAsFx) + #9 + BoolToStr(IsSegment) + #9 +
            BoolToStr(IsContinuous) + #9 + BoolToStr(CheckListBox.Checked[i]);
        end;
        writeln(f, s);
      end;

      with NumericForm do { write each Numeric plot }
      begin
        with CheckListBox do
        begin
          s := IntToStr(Count);
          writeln(f, s); { number of numeric graphs }
          for i := 0 to Count - 1 do
          begin
            with TNumericObject(Items.Objects[i]).Data do
              s := Name + #9 + IntToStr(Ord(NumericStyle)) + #9 +
                BoolToStr(ShowPoints) + #9 + IntToStr(Ord(PointStyle)) + #9 +
                IntToStr(PointSize) + #9 + IntToStr(PointColor) + #9 +
                IntToStr(PlotWidth) + #9 + IntToStr(PlotColor) + #9 +
                BoolToStr(SortXValue) + #9 + BoolToStr(Extrapolate) + #9 +
                IntToStr(CoordsIdx) + #9 + IntToStr(CurveRate) + #9;
            { was k0 factor = CurveRate/100 }
            s := s + IntToStr(TNumericObject(Items.Objects[i])
              .ControlPoints.Count) + #9 + BoolToStr(Checked[i]);
            writeln(f, s);
            s := '';
            with TNumericObject(Items.Objects[i]) do
              for j := 0 to ControlPoints.Count - 1 do
              begin
                with TGraphPointObject(ControlPoints[j]) do
                  s := s + FloatToStr(x_phi) + #9 + FloatToStr(y_r) + #9;
              end;
            writeln(f, s);
          end;
        end;
      end;

      with TextBlocksForm do
      begin
        s := IntToStr(BlockListBox.Count);
        writeln(f, s); { number of TextBlocks }

        for i := 0 to BlockListBox.Count - 1 do
        begin { write each TextBlock's data }
          with TTextDataObject(BlockListBox.Items.Objects[i]).Data do
          begin
            Caption := Trim(Caption);
            s := Caption + #9 + FloatToStr(xLoc) + #9 + FloatToStr(yLoc) + #9 +
              IntToStr(yInc) + #9 + FontName + #9;
            if fsBold in FontStyle then
              s := s + 'fsBold';
            if fsItalic in FontStyle then
              s := s + 'fsItalic';
            if fsUnderline in FontStyle then
              s := s + 'fsUnderline';
            if fsStrikeOut in FontStyle then
              s := s + 'fsStrikeOut';
            s := s + #9 + IntToStr(FontSize) + #9 + IntToStr(FontColor) + #9 +
              BoolToStr(BlockListBox.Checked[i]);
          end;
          writeln(f, s);

          with TTextDataObject(BlockListBox.Items.Objects[i]) do
          begin
            j := TextLines.Count - 1;
            while (j >= 0) and (TTextLineObject(TextLines[j]).Text = '') do
              Dec(j); { remove any traling empty lines }

            TextLineCount := j + 1;
            s := IntToStr(TextLineCount);
            writeln(f, s); { number of TextLines }
            for j := 0 to TextLineCount - 1 do
              with TTextLineObject(TextLines[j]) do
              begin
                s := Text + #9 + IntToStr(Color);
                writeln(f, s);
              end;
          end;
        end;
      end;
    finally
      Flush(f);
      CloseFile(f);
    end;
  except
    MessageDlg('File Error! An Error has occurred' +
      #13#10'when attempting to write to "' + GraphFName + '".', mtError,
      [mbOK], 0);
  end;
  Altered := false;
  NewFile := false;
end;

function TFunctionsForm.DefaultData: TGraphData;
begin
  with Result do
  begin
    xMin := -10.2;
    yMin := -10.2;
    xMax := 10.75;
    yMax := 10.95;

    SavexMin := 0;
    SavexMax := 0;
    SaveyMin := 0;
    SaveyMax := 0;

    AreaAlpha := 0.25; { transparency of integration area }

    FontName := 'Tahoma';
    FontStyle := [];
    FontSize := 9;

    AxisWidth := 2; { axis line width }

    xMinorGrad := 5; { minor X axis graduation lengths }
    yMinorGrad := 5; { minor Y axis graduation lengths }
    xMajorGrad := 50; { major X axis graduation lengths }
    yMajorGrad := 50; { major Y axis graduation lengths }

    MinorWidth := 1; { minor graduation & grid line width }
    MajorWidth := 1; { major graduation & grid line width }
    CoordWidth := 2; { coordinate line width }

    dydxWidth := 1; { derivative line width }
    d2ydx2Width := 1; { 2nd derivative line width }
    IntegCount := 64000; { number of integration intervals }
    ydxWidth := 1; { integral line width }

    BackColor := clCream; { paper or background color }
    GridColor := clSilver; { grid color }
    xAxisColor := clRed; { xAxis color }
    yAxisColor := clGreen; { yAxis color }
    CoordColor := clGray; { coordinate line color }
    dydxColor := clOlive; { derivative line color }
    d2ydx2Color := clOlive; { 2nd derivative line color }
    ydxColor := clTeal; { integral line color }
    PosAreaColor := clSkyBlue; { positive integral area color }
    NegAreaColor := clMaroon; { negative integral area color }

    with Grid do
    begin
      GridStyle := gsCartesian;
      xAxisStyle := asLinear;
      yAxisStyle := asLinear;
    end;

    with PlotData do { each function has these individual values }
    begin
      FunctStr := '';
      TextStr := FunctStr;
      xInc := 1;
      PlotWidth := 1;
      PlotColor := clBlue;
      PhiInc := 0.1;
      SegMin := -Pi;
      SegMax := Pi;
      xLabel := -0.3;
      yLabel := 0.1;
      ShowLabel := True;
      PlotAsFx := True;
      IsSegment := false;
      IsContinuous := false;
    end;
  end;
end;

procedure TFunctionsForm.ShowData(Sender: TObject);
var
  i: integer;
  fs, ts: string;

begin
  with GraphData, PlotData do
  begin
    fs := FunctStr;
    ts := TextStr;

    ShowLabelCheckBox.Checked := ShowLabel;
    SegmentButton.Visible := PlotAsFx;
    ContinuousCheckBox.Checked := IsContinuous;
    UpButton.Enabled := CheckListBox.Count > 1;
    DownButton.Enabled := UpButton.Enabled;
    DeleteButton.Enabled := UpButton.Enabled;

    Labelx.Visible := EvaluateButton.Tag = 1;
    Labely.Visible := Labelx.Visible;
    EditEvaluate.Visible := Labelx.Visible;
    EditCoordinate.Visible := Labelx.Visible;
    UpDown3.Visible := Labelx.Visible;
    SpeedButton4.Visible := Labelx.Visible;
    PenPanel.Color := PlotColor;
    CoordPanel.Color := CoordColor;
    CoordPanel.Visible := Labelx.Visible;

    Label11.Visible := Labelx.Visible;

    SwitchButton.Visible := (Grid.xAxisStyle = asLinear) and
      (Grid.yAxisStyle = asLinear);

    if PlotAsFx then
    begin { plot as y = f(x) }
      for i := 1 to Length(fs) do
        if fs[i] = 'Ø' then
          fs[i] := 'x';
      for i := 1 to Length(ts) do
        if ts[i] = 'Ø' then
          ts[i] := 'x';

      LabelPhi.Caption := 'Plot x :';
      with SwitchButton do
      begin
        Caption := 'Go to f(Ø)';
        Hint := 'Switch to r = f(Ø)';
        if not IsSegment then
        begin
          Label1.Visible := false;
          Label2.Visible := false;
          Label3.Visible := false;
        end;
        Tag := 0;
      end;

      LabelFunc.Caption := 'y = f(x) = ';
      Labelx.Caption := 'x =';
      Labeldx.Caption := 'pixels';

      LabelRCos.Visible := false;
      LabelRSin.Visible := false;

      Editdx.Text := FloatToStrF(xInc, ffGeneral, 7, 4);
      UpDown1.Visible := True;

      yfx1.Caption := 'y = f''(x)';
      yfx2.Caption := 'y = f"(x)';
      Integrate1.Enabled := True;
      Integrate2y.Enabled := True;
      Findx.Enabled := True;
      try
        Between1.Enabled := (CheckListBox.Count > 1) and
          (pos('Ø', CheckListBox.Items[0]) = 0) and
          (pos('Ø', CheckListBox.Items[1]) = 0);
      except
      end;

      Volumex1.Enabled := True;
      Volumey1.Enabled := True;

      with SegmentButton do
      begin
        if IsSegment then
        begin
          Caption := 'Go to Complete';
          Hint := 'Click to plot whole range.';
          Label1.Visible := True;
          Label2.Visible := True;
          Label3.Visible := True;
          LabelPhi.Visible := True;
          EditSegMin.Visible := True;
          EditSegMax.Visible := True;

          EditSegMin.Text := FloatToStrF(SegMin, ffGeneral, 13, 4);
          EditSegMax.Text := FloatToStrF(SegMax, ffGeneral, 13, 4);
          Tag := 0;
        end
        else
        begin
          Caption := 'Go to Segment';
          Hint := 'Click to limit plot range.';
          Label1.Visible := false;
          Label2.Visible := false;
          Label3.Visible := false;
          LabelPhi.Visible := false;
          EditSegMin.Visible := false;
          EditSegMax.Visible := false;
          Tag := 1;
        end;
      end;
    end { plot as y = f(x) }
    else
    begin { plot as r = f(Ø) }
      for i := 1 to Length(fs) do
        if (not CharInSet(fs[i - 1], ['e', 'E'])) and (UpCase(fs[i]) = 'X') then
          fs[i] := 'Ø';

      for i := 1 to Length(ts) do
        if (not CharInSet(ts[i - 1], ['e', 'E'])) and (UpCase(ts[i]) = 'X') then
          ts[i] := 'Ø';

      LabelPhi.Visible := True;
      EditSegMin.Visible := True;
      EditSegMax.Visible := True;

      LabelRCos.Visible := Labely.Visible;
      LabelRSin.Visible := Labely.Visible;

      LabelPhi.Caption := 'Plot Ø :';
      with SwitchButton do
      begin
        Caption := 'Go to f(x)';
        Hint := 'Switch to y = f(x)';
        Label1.Visible := True;
        Label2.Visible := True;
        Label3.Visible := True;
        Tag := 1;
      end;

      LabelFunc.Caption := 'r = f(Ø) = ';
      Labelx.Caption := 'Ø =';
      Labeldx.Caption := 'radians';

      yfx1.Caption := 'y = f''(Ø)';
      yfx2.Caption := 'y = f"(Ø)';

      Integrate2y.Enabled := false;
      Between1.Enabled := false;
      Volumex1.Enabled := false;
      Volumey1.Enabled := false;
      Findx.Enabled := false;

      Editdx.Text := FloatToStrF(PhiInc, ffGeneral, 7, 4);
      UpDown1.Visible := false;

      EditSegMin.Text := FloatToStrF(SegMin, ffGeneral, 13, 4);
      EditSegMax.Text := FloatToStrF(SegMax, ffGeneral, 13, 4);
    end; { plot as r = f(Ø) }

    FunctStr := fs;
    TextStr := ts;
    Editfx.Text := ts;

    EditLocX.Text := FloatToStrF(xLabel, ffGeneral, 4, 3);
    EditLocY.Text := FloatToStrF(yLabel, ffGeneral, 4, 3);

    EditPen.Text := IntToStr(PlotWidth);
    EditCoordinate.Text := IntToStr(CoordWidth);

    if Sender = SwitchButton then
    begin
      with CheckListBox do
      begin
        Items[ItemIndex] := ts;
        with TPlotDataObject(Items.Objects[ItemIndex]).Data do
        begin
          FunctStr := fs;
          TextStr := ts;
        end;
      end;
      BitBtn2.Visible := false;
    end;
  end;
end;

procedure TFunctionsForm.OpenSelectedFile(Sender: TObject; FName: TFileName);
var
  i: integer;

begin
  if FileExists(FName) then
  begin
    Screen.Cursor := crHourglass;
    CheckListBox.Clear;
    GraphFName := ExtractFileName(FName);

    if ReadData(DataPath + GraphFName) then
    begin
      if Integrate2x.Checked then
        CloseIntegrateXForm;
      if Integrate2y.Checked then
        CloseIntegrateYForm;
      if Between1.Checked then
        CloseBetweenForm;
      if Volumex1.Checked then
        CloseVolumeXForm;
      if Volumey1.Checked then
        CloseVolumeYForm;

      Caption := GraphFName;
      MainForm.Caption := GraphFName;
      GridOptionsForm.Caption := GraphFName;
      NumericForm.Caption := GraphFName;
      TextBlocksForm.Caption := GraphFName;

      ShowData(Sender);
      BitBtn2.Visible := false;
      NewFile := false;
      Altered := false;
      (*
        NewFont needed to initialize GLWinFont.GetCharWidth
        if the font has been altered, which may or may not be the case,
        so do it anyway
      *)
      NewFont := True;
      MainForm.GLViewer.Buffer.BackgroundColor := GraphData.BackColor;
      MainForm.GLViewer.Invalidate;
    end;

    GridOptionsForm.ShowData;
    GridOptionsForm.ApplyBitBtn.Visible := false;
    DerivativeForm.ShowData;

    with NumericForm do
      if Visible then
      begin
        SetFocus;
        ShowData(Sender);
        CheckListBox.ItemIndex := CheckListBox.Count - 1;
        if CheckListBox.ItemIndex > -1 then
          CheckListBoxClick(Sender);
      end;

    with TextBlocksForm do
      if BlockListBox.Count > 0 then
        UpdateRichLines;
    Screen.Cursor := crDefault;
  end
  else
  begin
    MessageDlg('The file' + FName + #13#10'Could not be found.', mtError,
      [mbOK], 0);
    Screen.Cursor := crDefault;
  end;
end;

procedure TFunctionsForm.CloseIntegrateXForm;
begin
  Integrate2x.Checked := false;
  Integrate2x.ImageIndex := 3;
  IntegrateXForm.Close;
  IntegrateXForm.PlotIntegrated := piCalc;
end;

procedure TFunctionsForm.CloseIntegrateYForm;
begin
  Integrate2y.Checked := false;
  Integrate2y.ImageIndex := 4;
  IntegrateYForm.Close;
end;

procedure TFunctionsForm.CloseBetweenForm;
begin
  Between1.Checked := false;
  Between1.ImageIndex := 5;
  BetweenForm.Close;
end;

procedure TFunctionsForm.CloseVolumeXForm;
begin
  Volumex1.Checked := false;
  Volumex1.ImageIndex := 6;
  VolumeXForm.HideFunctionCheckBox.Checked := false;
  VolumeXForm.Close;
end;

procedure TFunctionsForm.CloseVolumeYForm;
begin
  Volumey1.Checked := false;
  Volumey1.ImageIndex := 7;
  VolumeYForm.HideFunctionCheckBox.Checked := false;
  VolumeYForm.Close;
end;

procedure TFunctionsForm.ClosefxValueForm;
begin
  fxValue.Checked := false;
  fxValue.ImageIndex := 0;
  fxValueForm.Close;
end;

procedure TFunctionsForm.Closefx1ValueForm;
begin
  fx1Value.Checked := false;
  fx1Value.ImageIndex := 1;
  fx1ValueForm.Close;
end;

procedure TFunctionsForm.Closefx2ValueForm;
begin
  fx2Value.Checked := false;
  fx2Value.ImageIndex := 2;
  fx2ValueForm.Close;
end;

procedure TFunctionsForm.ShowCartesianEvaluate;
var
  s: string;

begin
  if EditEvaluate.Text = '' then
  begin
    Labely.Caption := 'y = Undefined';
    LabelRCos.Caption := '';
    LabelRSin.Caption := '';
  end
  else
  begin
    s := FloatToStr(yEvaluate);
    if s = '-INF' then
      s := 'Infinitely negative';
    if s = 'INF' then
      s := 'Infinitely positive';
    if s = 'NAN' then
      s := 'Undefined';
    Labely.Caption := 'y = ' + s;
    Label12.Caption := '';
  end;
end;

procedure TFunctionsForm.ShowPolarEvaluate;
var
  s: string;

begin
  if EditEvaluate.Text = '' then
  begin
    Labely.Caption := 'r = Undefined';
    LabelRCos.Caption := 'x = Undefined';
    LabelRSin.Caption := 'y = Undefined';
  end
  else
  begin
    s := FloatToStr(yEvaluate);
    if s = '-INF' then
      s := 'Infinitely negative';
    if s = 'INF' then
      s := 'Infinitely positive';
    if s = 'NAN' then
      s := 'Undefined';
    Labely.Caption := 'r = ' + s;
    yCosxEval := yEvaluate * Cos(xEvaluate);
    ySinxEval := yEvaluate * Sin(xEvaluate);
    LabelRCos.Caption := 'x = ' + FloatToStr(yCosxEval);
    LabelRSin.Caption := 'y = ' + FloatToStr(ySinxEval);
    Label12.Caption := 'Radians';
  end;
end;

end.
