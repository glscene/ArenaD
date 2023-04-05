unit fFunctions;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.ImageList,
  System.UITypes,
  System.Math,
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
  Vcl.ImgList,
  Vcl.ExtCtrls,

  GLS.OpenGLTokens,
  GLS.VectorGeometry,
  GLS.Coordinates,
  GLS.Color,
  GLS.VectorTypes,

  uGlobal,
  uParser;

type
  TFunctionsForm = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    EditMinX: TEdit;
    EditMaxX: TEdit;
    EditdX: TEdit;
    EditMinY: TEdit;
    EditMaxY: TEdit;
    EditdY: TEdit;
    EditMinZ: TEdit;
    EditMaxZ: TEdit;
    cbZLimit: TCheckBox;
    LabelFunc: TLabel;
    Editfxy: TEdit;
    Label9: TLabel;
    AddButton: TSpeedButton;
    DeleteButton: TSpeedButton;
    CheckListBox: TCheckListBox;
    MainMenu: TMainMenu;
    File1: TMenuItem;
    New1: TMenuItem;
    OpenFile: TMenuItem;
    Save: TMenuItem;
    SaveAs: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    SaveDialog: TSaveDialog;
    OpenDialog: TOpenDialog;
    Label17: TLabel;
    ModeComboBox: TComboBox;
    StyleComboBox: TComboBox;
    ApplyBtn: TBitBtn;
    zCountLabel: TLabel;
    Centre: TSpeedButton;
    UpButton: TSpeedButton;
    DownButton: TSpeedButton;
    cbZCap: TCheckBox;
    GridValues: TSpeedButton;
    Label7: TLabel;
    EditNote: TEdit;
    procedure FormDestroy(Sender: TObject);
    procedure FloatKeyPress(Sender: TObject; var Key: Char);
    procedure fxyKeyPress(Sender: TObject; var Key: Char);
    procedure EditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);

    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure AddButtonClick(Sender: TObject);
    procedure SaveClick(Sender: TObject);
    procedure SaveAsClick(Sender: TObject);
    procedure CheckListBoxClick(Sender: TObject);
    procedure DeleteButtonClick(Sender: TObject);
    procedure OpenFileClick(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure New1Click(Sender: TObject);
    procedure cbZLimitClick(Sender: TObject);
    procedure ModeComboBoxChange(Sender: TObject);
    procedure StyleComboBoxChange(Sender: TObject);
    procedure ApplyBtnClick(Sender: TObject);
    procedure EditfxyClick(Sender: TObject);
    procedure CheckListBoxClickCheck(Sender: TObject);
    procedure EditdXKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EditdYKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EditMinXKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EditMaxXKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EditMinYKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EditMaxYKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EditMinZKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EditMaxZKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EditfxyKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure CentreClick(Sender: TObject);
    procedure UpButtonClick(Sender: TObject);
    procedure DownButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbZCapClick(Sender: TObject);
    procedure GridValuesClick(Sender: TObject);
    procedure PositiveKeyPress(Sender: TObject; var Key: Char);
    procedure EditNoteClick(Sender: TObject);
    procedure EditNoteKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    NewFile: Boolean;
    TooManyPoints: integer;
    function ReadData(const FName: TFileName): Boolean;
    procedure OpenSelectedFile(Sender: TObject; FName: TFileName);
    procedure WriteData(const FName: TFileName);
    function DefaultPlotData: TPlotData;
    function DefaultViewData: TViewData;
    function DefaultAddedData: TAddedData;
    procedure ShowData(Sender: TObject);
    procedure AddNewPlot;
    procedure CountzPoints;
    procedure UpdateTPlotDataObject;
    procedure AddRecent(const f: TFileName);
  public
    procedure ReadAndShowInitialData;
    procedure OpenRecentFile(FName: TFileName);
  end;

var
  FunctionsForm: TFunctionsForm;

// ========================================================================
implementation
// ========================================================================

uses
  fMain,
  fPlotColors,
  fEvaluate,
  fCoordOptions,
  fGridColors,
  fGridOptions,
  fDerivativeOptions;

{$R *.dfm}

procedure TFunctionsForm.AddButtonClick(Sender: TObject);
begin
  AddNewPlot;
end;

procedure TFunctionsForm.EditdXKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  x: TGLFloat;

begin
  try
    x := StrToFloat(EditdX.Text);
  except
    x := 1.0;
  end;
  PlotData.xInc := x;
  ApplyBtn.Visible := True;
  UpdateTPlotDataObject;
  CountzPoints;
end;

procedure TFunctionsForm.PositiveKeyPress(Sender: TObject; var Key: Char);
begin
  with Sender as TEdit do
    if not CharInSet(Key, ['+', '0' .. '9', '.', #8]) then
      Key := #0;
end;

procedure TFunctionsForm.EditdYKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  y: TGlFloat;

begin
  try
    y := StrToFloat(EditdY.Text);
  except
    y := 1.0;
  end;
  PlotData.yInc := y;
  ApplyBtn.Visible := True;
  UpdateTPlotDataObject;
  CountzPoints;
end;

procedure TFunctionsForm.EditfxyClick(Sender: TObject);
begin
  ViewForm.MousePoint.x := Maxint;
end;

procedure TFunctionsForm.EditfxyKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  e: byte;

begin
  if Key <> 13 then
  begin
    PlotData.txtStr := Editfxy.Text;
    PlotData.fxyStr := ScanText(Editfxy.Text);
    ParseAndEvaluate(PlotData.fxyStr, e);

    with CheckListBox do
      if (Count > 0) and (ItemIndex > -1) then
        Items[ItemIndex] := PlotData.txtStr;
    ApplyBtn.Visible := e = 0;
    UpdateTPlotDataObject;
  end;
end;

procedure TFunctionsForm.EditKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_DELETE) or (Key = VK_BACK) then
    ApplyBtn.Visible := True;
end;

procedure TFunctionsForm.fxyKeyPress(Sender: TObject; var Key: Char);
begin
  with (Sender as TEdit) do
  begin
    if not CharInSet(UpCase(Key), ParseSet) then
    begin
      Key := #0;
      Exit;
    end;
    if Key = '`' then
      Key := '°';
  end;
end;

procedure TFunctionsForm.GridValuesClick(Sender: TObject);
var
  DoApply: Boolean;

begin
  with GridOptionsForm do
    DoApply := xyLock.Checked and zLock.Checked and MinLock.Checked;

  if DoApply then
  begin
    with ViewData.xyGrid.xRange do
    begin
      EditMinX.Text := FloatToStrF(Minimum, ffGeneral, 7, 4);
      PlotData.xMin := Minimum;
      EditMaxX.Text := FloatToStrF(Maximum, ffGeneral, 7, 4);
      PlotData.xMax := Maximum;
    end;

    with ViewData.xyGrid.yRange do
    begin
      EditMinY.Text := FloatToStrF(Minimum, ffGeneral, 7, 4);
      PlotData.yMin := Minimum;
      EditMaxY.Text := FloatToStrF(Maximum, ffGeneral, 7, 4);
      PlotData.yMax := Maximum;
    end;

    with ViewData.xzGrid.zRange do
    begin
      EditMinZ.Text := FloatToStrF(Minimum, ffGeneral, 7, 4);
      PlotData.zMin := Minimum;
      EditMaxZ.Text := FloatToStrF(Maximum, ffGeneral, 7, 4);
      PlotData.zMax := Maximum;
    end;
    ApplyBtnClick(Sender);
  end;
end;

procedure TFunctionsForm.ModeComboBoxChange(Sender: TObject);
begin
  PlotData.ViewMode := TViewMode(ModeComboBox.ItemIndex);
  UpdateTPlotDataObject;
  ApplyBtnClick(Sender);
end;

procedure TFunctionsForm.New1Click(Sender: TObject);
var
  i: integer;
  s: string;

begin
  if Altered or GridColorsAltered or DerivativeAltered then
    case MessageDlg('The current graph''s data has been altered.' +
      #13#10'Do you wish to save the alterations ?', mtConfirmation,
      [mbYes, mbNo, mbCancel], 0) of
      mrYes:
        SaveClick(Sender);
      mrCancel:
        Exit;
    end;
  s := DataPath + GraphFName; // save original FName
  if s <> GraphFName then
    AddRecent(s);
  with CheckListBox do
  begin
    for i := 0 to Items.Count - 1 do
      Items.Objects[i].Free;
    Clear;
  end;

  GraphFName := NewFName;
  Caption := GraphFName;
  ViewForm.Caption := GraphFName;
  GridOptionsForm.Caption := GraphFName;
  EvaluateForm.Caption := GraphFName;
  CoordsForm.Caption := GraphFName;

  NewFile := True;
  Altered := False;
  ViewData := DefaultViewData;
  PlotData := DefaultPlotData;
  AddedData := DefaultAddedData;

  if GridColorsForm.Visible then
    GridColorsForm.Close;
  if PlotColorsForm.Visible then
    PlotColorsForm.Close;
  if DerivativesForm.Visible then
    DerivativesForm.Close;
  ApplyBtnClick(Sender);

  CheckListBox.AddItem(PlotData.txtStr, TPlotDataObject.Create(PlotData));
  CheckListBox.ItemIndex := CheckListBox.Count - 1;
  CheckListBox.Checked[CheckListBox.ItemIndex] := True;

  ViewForm.TargetCube.Position.SetPoint(0, 0, 0);
  ShowData(Sender);
end;

procedure TFunctionsForm.OpenFileClick(Sender: TObject);
var
  i: integer;
  s: string;

begin
  if DerivativesForm.Visible then
    DerivativesForm.Close;
  if GridColorsForm.Visible then
    GridColorsForm.ShowGridColorData;
  if PlotColorsForm.Visible then
    PlotColorsForm.ShowPlotColorData;
  if Altered or GridColorsAltered or DerivativeAltered then
    case MessageDlg('The current graph''s data has been altered.' +
      #13#10'Do you wish to save the alterations ?', mtConfirmation,
      [mbYes, mbNo, mbCancel], 0) of
      mrYes:
        SaveClick(Sender);
      mrCancel:
        Exit;
      mrNo:
        begin
          Altered := False;
          GridColorsAltered := False;
          DerivativeAltered := False;
          NewFile := False;
        end
    end;

  OpenDialog.InitialDir := DataPath;
  if OpenDialog.Execute then
  begin
    s := DataPath + GraphFName; // save original FName
    DataPath := ExtractFilePath(OpenDialog.FileName);
    DataPath := IncludeTrailingPathDelimiter(DataPath);
    ViewForm.MousePoint.x := Maxint;
    GraphFName := ExtractFileName(OpenDialog.FileName);
    if s <> GraphFName then
      AddRecent(s);

    for i := 0 to CheckListBox.Items.Count - 1 do
      CheckListBox.Items.Objects[i].Free;
    CheckListBox.Clear;

    if ReadData(DataPath + GraphFName) then
      ShowData(Sender);
    ApplyBtnClick(Sender);
    Altered := False;
    GridColorsAltered := False;
    DerivativeAltered := False;
    if GridColorsForm.Visible then
      GridColorsForm.ShowGridColorData;
    if PlotColorsForm.Visible then
      PlotColorsForm.ShowPlotColorData;
  end;
end;

procedure TFunctionsForm.EditMaxXKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  x: TGlFloat;

begin
  try
    x := StrToFloat(EditMaxX.Text);
  except
    x := 1.0;
  end;
  PlotData.xMax := x;
  ApplyBtn.Visible := True;
  UpdateTPlotDataObject;
  CountzPoints;
end;

procedure TFunctionsForm.EditMaxYKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  y: TGlFloat;

begin
  try
    y := StrToFloat(EditMaxY.Text);
  except
    y := 1.0;
  end;
  PlotData.yMax := y;
  ApplyBtn.Visible := True;
  UpdateTPlotDataObject;
  CountzPoints;
end;

procedure TFunctionsForm.EditMaxZKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  z: TGLFloat;

begin
  try
    z := StrToFloat(EditMaxZ.Text);
  except
    z := 1.0;
  end;
  PlotData.zMax := z;
  ApplyBtn.Visible := True;
  UpdateTPlotDataObject;
  CountzPoints;
end;

procedure TFunctionsForm.EditMinXKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  x: TGlFloat;

begin
  try
    x := StrToFloat(EditMinX.Text);
  except
    x := -1.0;
  end;
  PlotData.xMin := x;
  ApplyBtn.Visible := True;
  UpdateTPlotDataObject;
  CountzPoints;
end;

procedure TFunctionsForm.EditMinYKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  y: TGlFloat;

begin
  try
    y := StrToFloat(EditMinY.Text);
  except
    y := -1.0;
  end;
  PlotData.yMin := y;
  ApplyBtn.Visible := True;
  UpdateTPlotDataObject;
  CountzPoints;
end;

procedure TFunctionsForm.EditMinZKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  z: TGlFloat;

begin
  try
    z := StrToFloat(EditMinZ.Text);
  except
    z := -1.0;
  end;
  PlotData.zMin := z;
  ApplyBtn.Visible := True;
  UpdateTPlotDataObject;
  CountzPoints;
end;

procedure TFunctionsForm.EditNoteClick(Sender: TObject);
begin
  ViewForm.MousePoint.x := Maxint;
end;

procedure TFunctionsForm.EditNoteKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key <> 13 then
  begin
    PlotData.NoteStr := EditNote.Text;
    with CheckListBox do
      if (Count > 0) and (ItemIndex > -1) then
        TPlotDataObject(Items.Objects[ItemIndex]).Data := PlotData;
    Altered := True;
  end;
end;

procedure TFunctionsForm.Exit1Click(Sender: TObject);
begin
  ViewForm.Exit1Click(Sender);
end;

procedure TFunctionsForm.FloatKeyPress(Sender: TObject; var Key: Char);
begin
  with Sender as TEdit do
    if not CharInSet(Key, AnyFloat) then
      Key := #0;
end;

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
  ViewForm.Close;
  CanClose := not ViewForm.Visible;
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

function TFunctionsForm.DefaultPlotData: TPlotData;
begin
  with Result do
  begin
    fxyStr := ''; // function string
    txtStr := ''; // txt -> fxy when scanned
    NoteStr := ''; // describe function
    xMin := -10.0; // x limits and increment
    xMax := 10.0;
    xInc := 1.0;
    yMin := -10.0; // y limits and increment
    yMax := 10.0;
    yInc := 1.0;
    zMin := -10.0; // z limits
    zMax := 10.0;
    zLim := False; // false = z limits do not apply
    zCap := False; // above zLim values := NAN

    UpperColor := VectorMake(255, 0, 0, 1000);
    LowerColor := VectorMake(0, 0, 255, 1000);

    ColorBlend := 0.5;
    ColorMove := 0.0;
    ViewMode := vmAmbient;
    fxyMode := fxyFill;
  end;
end;

function TFunctionsForm.DefaultViewData: TViewData;
begin
  Result.CameraCubeAt := VectorMake(0, 0, 0);
  Result.CameraAt := VectorMake(50, 50, 30);
  Result.fLength := 200;
  Result.LightAt := VectorMake(50, 50, 50);
  Result.ViewDepth := 1000;
  Result.BackColor := clActiveCaption;
  with Result.xyGrid do
  begin
    Color := clrBlue;
    xRange.Maximum := 10;
    xRange.Minimum := -10;
    xRange.Step := 1;
    yRange.Maximum := 10;
    yRange.Minimum := -10;
    yRange.Step := 1;
    zPosition := -10;
    zScale := 1;
    IsVisible := True;
    IsChecked := True;
  end;

  with Result.xzGrid do
  begin
    Color := clrGreen;
    xRange.Maximum := 10;
    xRange.Minimum := -10;
    xRange.Step := 1;
    zRange.Maximum := 10;
    zRange.Minimum := -10;
    zRange.Step := 1;
    yPosition := -10;
    IsVisible := True;
    IsChecked := True;
  end;

  with Result.yzGrid do
  begin
    Color := clrRed;
    yRange.Maximum := 10;
    yRange.Minimum := -10;
    yRange.Step := 1;
    zRange.Maximum := 10;
    zRange.Minimum := -10;
    zRange.Step := 1;
    xPosition := -10;
    IsVisible := True;
    IsChecked := True;
  end;

  Result.xEvaluate := 0.0;
  Result.yEvaluate := 0.0;
  Result.CoordChecked := False;
  Result.ToGridsChecked := False;
  Result.dzdx_dyChecked := False;
  Result.BoxChecked := False;
  Result.CoordWidth := 1;
  Result.CoordColor := clBlack;
  Result.BoxLnWidth := 1;
  Result.BoxLnColor := clrBlack;

  Result.TextVisible := False;
  Result.TextFontN := 'Tahoma';
  Result.TextFontSz := 10;
  Result.xPosYMax := False;
  Result.xPosZMax := False;
  Result.xTextColor := clBlack;

  Result.yPosXMax := False;
  Result.yPosZMax := False;
  Result.yTextColor := clBlack;

  Result.TextVisible := True;
  Result.TextFontN := 'Tahoma'; // ViewForm.GLWinBitmapFont
  Result.TextFontSz := 20;

  Result.xPosYMax := False;
  Result.xPosZMax := False;
  Result.xTextColor := clRed;

  Result.yPosXMax := False;
  Result.yPosZMax := False;
  Result.yTextColor := clGreen;

  Result.zPosXMax := False;
  Result.zPosYMax := False;
  Result.zTextColor := clBlue;
  Result.ArrowSize := 1.0;
end;

function TFunctionsForm.DefaultAddedData: TAddedData;
begin
  Result.xMin := -10.0; // x limits and increment
  Result.xMax := 10.0;
  Result.xInc := 1.0;
  Result.yMin := -10.0; // y limits and increment
  Result.yMax := 10.0;
  Result.yInc := 1.0;
  Result.zMin := -10.0; // z limits
  Result.zMax := 10.0;
  Result.zLim := False; // false = z limits do not apply
  Result.zCap := False; // above zLim values := NAN

  Result.UpperColor := VectorMake(255, 0, 0, 1000);
  Result.LowerColor := VectorMake(0, 0, 255, 1000);

  Result.ColorBlend := 0.5;
  Result.ColorMove := 0.0;
  Result.ViewMode := vmAmbient;
  Result.fxyMode := fxyFill;

  Result.AddLineWidth := 1;
  Result.AddLineColor := clBlack;
  Result.AddedAs := AddNone;
end;

procedure TFunctionsForm.CountzPoints;
var
  n: integer;

begin
  n := round((PlotData.xMax - PlotData.xMin + PlotData.xInc) / PlotData.xInc) *
    round((PlotData.yMax - PlotData.yMin + PlotData.yInc) / PlotData.yInc);
  TooManyPoints := round(Log10(n));
  case TooManyPoints of
    0 .. 2:
      zCountLabel.Font.Color := clLime;
    3:
      zCountLabel.Font.Color := clTeal;
    4:
      zCountLabel.Font.Color := clGreen;
    5:
      zCountLabel.Font.Color := clBlue;
  else
    zCountLabel.Font.Color := clRed;
  end;
  if TooManyPoints > 6 then
    zCountLabel.Caption := 'Too many Points: ' + FloatToStrF(n, ffnumber,
      8, 0) + ' !'
  else
    zCountLabel.Caption := 'N° Points = ' + FloatToStrF(n, ffnumber, 8, 0);
end;

procedure TFunctionsForm.UpdateTPlotDataObject;
begin
  TPlotDataObject(CheckListBox.Items.Objects[CheckListBox.ItemIndex]).Data := PlotData;
end;

procedure TFunctionsForm.DeleteButtonClick(Sender: TObject);
var
  i: integer;

begin
  if CheckListBox.Count > 1 then
  begin
    i := CheckListBox.ItemIndex;
    with CheckListBox.Items.Objects[i] as TPlotDataObject do
      Free;
    CheckListBox.Items.Delete(i);
    if i > CheckListBox.Count - 1 then
      i := CheckListBox.Count - 1;
    CheckListBox.ItemIndex := i;
    PlotData := TPlotDataObject(CheckListBox.Items.Objects[CheckListBox.ItemIndex]).Data;
    DeleteButton.Enabled := CheckListBox.Count > 1;
    ApplyBtnClick(Sender);
  end
end;

procedure TFunctionsForm.DownButtonClick(Sender: TObject);
var
  i: integer;

begin
  i := CheckListBox.ItemIndex;
  if i < CheckListBox.Count - 1 then
    CheckListBox.Items.Move(i, i + 1);
  CheckListBox.ItemIndex := i + 1;
  CheckListBoxClick(Sender);
  Altered := True;
end;

function TFunctionsForm.ReadData(const FName: TFileName): Boolean;

  function StrToVector(s: string): TGLVector;
  var
    t: string;
    i: integer;

  begin
    i := Pos(',', s);
    t := Copy(s, 1, i - 1);
    TryStrToFloat(t, Result.x);

    s := Copy(s, i + 1, Length(s));
    i := Pos(',', s);
    t := Copy(s, 1, i - 1);
    TryStrToFloat(t, Result.y);

    s := Copy(s, i + 1, Length(s));
    TryStrToFloat(t, Result.z);
  end;

  function StrToColor(s: string): TGLColorVector;
  var
    t: string;
    i: integer;

  begin
    i := Pos(',', s);
    t := Copy(s, 1, i - 1);
    TryStrToFloat(t, Result.x);

    s := Copy(s, i + 1, Length(s));
    i := Pos(',', s);
    t := Copy(s, 1, i - 1);
    TryStrToFloat(t, Result.y);

    s := Copy(s, i + 1, Length(s));
    i := Pos(',', s);
    t := Copy(s, 1, i - 1);
    TryStrToFloat(t, Result.z);

    s := Copy(s, i + 1, Length(s));
    TryStrToFloat(t, Result.W);
  end;

  function StrToRange(s: string): TRange;
  var
    t: string;
    i: integer;

  begin
    i := Pos(',', s);
    t := Copy(s, 1, i - 1);
    TryStrToFloat(t, Result.Maximum);

    s := Copy(s, i + 1, Length(s));
    i := Pos(',', s);
    t := Copy(s, 1, i - 1);
    TryStrToFloat(t, Result.Minimum);

    s := Copy(s, i + 1, Length(s));
    TryStrToFloat(t, Result.Step);
  end;

var
  s, t: string;
  f: TextFile;
  i, j, k, n: integer;

begin
  Result := False;
  if FileExists(FName) then
  begin
    AssignFile(f, FName);
    try
      Reset(f);
      Readln(f, s);
      j := 0;
      i := Pos(#9, s);

      while i > 0 do
      begin
        t := Copy(s, 1, i - 1);
        s := Copy(s, i + 1, Length(s));
        i := Pos(#9, s);
        Inc(j);

          case j of
            1:
              ViewData.CameraCubeAt := StrToVector(t);
            2:
              ViewData.CameraAt := StrToVector(t);
            3:
              TryStrToFloat(t, ViewData.fLength);
            4:
              ViewData.LightAt := StrToVector(t);
            5:
              TryStrToFloat(t, ViewData.ViewDepth);
            6:
              ViewData.BackColor := StrToInt(t);
            7:
              ViewData.xyGrid.Color := StrToColor(t);
            8:
              ViewData.xyGrid.xRange := StrToRange(t);
            9:
              ViewData.xyGrid.yRange := StrToRange(t);
            10:
              TryStrToFloat(t, ViewData.xyGrid.zPosition);
            11:
              TryStrToFloat(t, ViewData.xyGrid.zScale);
            12:
              ViewData.xyGrid.IsVisible := StrToBool(t);
            13:
              ViewData.xyGrid.IsChecked := StrToBool(t);
            14:
              ViewData.xzGrid.Color := StrToColor(t);
            15:
              ViewData.xzGrid.xRange := StrToRange(t);
            16:
              ViewData.xzGrid.zRange := StrToRange(t);
            17:
              TryStrToFloat(t, ViewData.xzGrid.yPosition);
            18:
              ViewData.xzGrid.IsVisible := StrToBool(t);
            19:
              ViewData.xzGrid.IsChecked := StrToBool(t);
            20:
              ViewData.yzGrid.Color := StrToColor(t);
            21:
              ViewData.yzGrid.yRange := StrToRange(t);
            22:
              ViewData.yzGrid.zRange := StrToRange(t);
            23:
              TryStrToFloat(t, ViewData.yzGrid.xPosition);
            24:
              ViewData.yzGrid.IsVisible := StrToBool(t);
            25:
              ViewData.yzGrid.IsChecked := StrToBool(t);
            26:
              ViewForm.TargetCube.Position.AsVector := StrToVector(t);
            27:
              TryStrToFloat(t, ViewData.xEvaluate);
            28:
              TryStrToFloat(t, ViewData.yEvaluate);
            29:
              ViewData.CoordChecked := StrToBool(t);
            30:
              ViewData.ToGridsChecked := StrToBool(t);
            31:
              ViewData.dzdx_dyChecked := StrToBool(t);
            32:
              ViewData.BoxChecked := StrToBool(t);
            33:
              ViewData.CoordWidth := StrToInt(t);
            34:
              ViewData.CoordColor := StrToInt(t);
            35:
              ViewData.BoxLnWidth := StrToInt(t);
            36:
              ViewData.BoxLnColor := StrToColor(t);
            37:
              ViewData.TextVisible := StrToBool(t);
            38:
              ViewData.TextFontN := t;
            39:
              ViewData.TextFontSz := StrToInt(t);
            40:
              ViewData.xPosYMax := StrToBool(t);
            41:
              ViewData.xPosZMax := StrToBool(t);
            42:
              ViewData.xTextColor := StrToInt(t);
            43:
              ViewData.yPosXMax := StrToBool(t);
            44:
              ViewData.yPosZMax := StrToBool(t);
            45:
              ViewData.yTextColor := StrToInt(t);
            46:
              ViewData.zPosXMax := StrToBool(t);
            47:
              ViewData.zPosYMax := StrToBool(t);
            48:
              ViewData.zTextColor := StrToInt(t);
            49:
              TryStrToFloat(t, ViewData.ArrowSize);
          end;
      end;
      n := StrToInt(s); // number of functions
      for k := 0 to n - 1 do
      begin // read each function's data
        Readln(f, s);
        j := 0;
        i := Pos(#9, s);
        while i > 0 do
        begin
          t := Copy(s, 1, i - 1);
          s := Copy(s, i + 1, Length(s));
          i := Pos(#9, s);
          Inc(j);
          with PlotData do
            case j of
              1:
                fxyStr := t;
              2:
                txtStr := t;
              3:
                NoteStr := t;
              4:
                TryStrToFloat(t, xMin);
              5:
                TryStrToFloat(t, xMax);
              6:
                TryStrToFloat(t, xInc);
              7:
                TryStrToFloat(t, yMin);
              8:
                TryStrToFloat(t, yMax);
              9:
                TryStrToFloat(t, yInc);
              10:
                TryStrToFloat(t, zMin);
              11:
                TryStrToFloat(t, zMax);
              12:
                zLim := StrToBool(t);
              13:
                zCap := StrToBool(t);
              14:
                UpperColor := StrToColor(t);
              15:
                LowerColor := StrToColor(t);
              16:
                ColorBlend := StrToFloat(t); // TryStrToFloat(t, ColorBlend);
              17:
                ColorMove := StrToFloat(t); // TryStrToFloat(t, ColorMove);
              18:
                ViewMode := TViewMode(StrToInt(t));
              19:
                fxyMode := TfxyMode(StrToInt(t));
            end;
        end;
        CheckListBox.AddItem(PlotData.txtStr, TPlotDataObject.Create(PlotData));
        CheckListBox.Checked[CheckListBox.Count - 1] := StrToBool(s);
      end;
      Readln(f, s);
      j := 0;
      i := Pos(#9, s);
      while i > 0 do
      begin
        t := Copy(s, 1, i - 1);
        s := Copy(s, i + 1, Length(s));
        i := Pos(#9, s);
        Inc(j);
        with AddedData do
          case j of
            1:
              TryStrToFloat(t, xMin);
            2:
              TryStrToFloat(t, xMax);
            3:
              TryStrToFloat(t, xInc);
            4:
              TryStrToFloat(t, yMin);
            5:
              TryStrToFloat(t, yMax);
            6:
              TryStrToFloat(t, yInc);
            7:
              TryStrToFloat(t, zMin);
            8:
              TryStrToFloat(t, zMax);
            9:
              zLim := StrToBool(t);
            10:
              zCap := StrToBool(t);
            11:
              UpperColor := StrToColor(t);
            12:
              LowerColor := StrToColor(t);
            13:
              TryStrToFloat(t, ColorBlend);
            14:
              TryStrToFloat(t, ColorMove);
            15:
              ViewMode := TViewMode(StrToInt(t));
            16:
              fxyMode := TfxyMode(StrToInt(t));
            17:
              TryStrToInt(t, AddLineWidth);
            18:
              TryStrToInt(t, AddLineColor);
            19:
              AddedAs := TAddedType(StrToInt(t));
          end;
      end;

    except
      MessageDlg('File Error! An Error has occurred' +
        #13#10'when attempting to read "' + FName + '".', mtError, [mbOK], 0);
      CloseFile(f);
      Exit;
    end;
    CloseFile(f);
    Result := True;
    CheckListBox.ItemIndex := CheckListBox.Count - 1;
    NewFile := not Result;
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
  ViewForm.Caption := GraphFName;
  GridOptionsForm.Caption := GraphFName;
  EvaluateForm.Caption := GraphFName;
  CoordsForm.Caption := GraphFName;
end;

procedure TFunctionsForm.WriteData(const FName: TFileName);
  function VectorToStr(v: TGLVector): string;
  begin
    Result := FloatToStr(v.x) + ',' + FloatToStr(v.y) + ',' + FloatToStr(v.z);
  end;

  function ColorToStr(c: TGLColorVector): string;
  begin
    Result := FloatToStr(c.x) + ',' + FloatToStr(c.y) + ',' + FloatToStr(c.z) +
      ',' + FloatToStr(c.W);
  end;

  function RangetoStr(r: TRange): string;
  begin
    Result := FloatToStr(r.Maximum) + ',' + FloatToStr(r.Minimum) + ',' +
      FloatToStr(r.Step);
  end;

var
  f: TextFile;
  s: string;
  i: integer;

begin
  try
    AssignFile(f, FName);
    try
      Rewrite(f); { write tab delimited data }
      with ViewData do
      begin
        CameraCubeAt := ViewForm.CameraCube.Position.AsVector;
        CameraAt := ViewForm.Camera.Position.AsVector;
        fLength := ViewForm.Camera.FocalLength;
        LightAt := ViewForm.GLLight.Position.AsVector;
        ViewDepth := ViewForm.Camera.DepthOfView;
        BackColor := ViewForm.GLSViewer.Buffer.BackgroundColor;

        s := VectorToStr(CameraCubeAt) + #9 + VectorToStr(CameraAt) + #9 +
          FloatToStr(fLength) + #9 + VectorToStr(LightAt) + #9 +
          FloatToStr(ViewDepth) + #9 + IntToStr(BackColor) + #9 +
        { xy }
          ColorToStr(xyGrid.Color) + #9 + RangetoStr(xyGrid.xRange) + #9 +
          RangetoStr(xyGrid.yRange) + #9 + FloatToStr(xyGrid.zPosition) + #9 +
          FloatToStr(xyGrid.zScale) + #9 + BoolToStr(xyGrid.IsVisible) + #9 +
          BoolToStr(xyGrid.IsChecked) + #9 +
        { xz }
          ColorToStr(xzGrid.Color) + #9 + RangetoStr(xzGrid.xRange) + #9 +
          RangetoStr(xzGrid.zRange) + #9 + FloatToStr(xzGrid.yPosition) + #9 +
          BoolToStr(xzGrid.IsVisible) + #9 + BoolToStr(xzGrid.IsChecked) + #9 +
        { yz }
          ColorToStr(yzGrid.Color) + #9 + RangetoStr(yzGrid.yRange) + #9 +
          RangetoStr(yzGrid.zRange) + #9 + FloatToStr(yzGrid.xPosition) + #9 +
          BoolToStr(yzGrid.IsVisible) + #9 + BoolToStr(yzGrid.IsChecked) + #9 +
        { Target }
          VectorToStr(ViewForm.TargetCube.Position.AsVector) + #9 +

          FloatToStr(xEvaluate) + #9 + FloatToStr(yEvaluate) + #9 +
          BoolToStr(CoordChecked) + #9 + BoolToStr(ToGridsChecked) + #9 +
          BoolToStr(dzdx_dyChecked) + #9 + BoolToStr(BoxChecked) + #9 +
          IntToStr(CoordWidth) + #9 + IntToStr(CoordColor) + #9 +
          IntToStr(BoxLnWidth) + #9 + ColorToStr(BoxLnColor) + #9 +
          BoolToStr(TextVisible) + #9 + TextFontN + #9 + IntToStr(TextFontSz) +
          #9 + BoolToStr(xPosYMax) + #9 + BoolToStr(xPosZMax) + #9 +
          IntToStr(xTextColor) + #9 + BoolToStr(yPosXMax) + #9 +
          BoolToStr(yPosZMax) + #9 + IntToStr(yTextColor) + #9 +
          BoolToStr(zPosXMax) + #9 + BoolToStr(zPosYMax) + #9 +
          IntToStr(zTextColor) + #9 + FloatToStr(ArrowSize) + #9 +
          IntToStr(CheckListBox.Count); { number of functions }
      end;
      writeln(f, s);

      for i := 0 to CheckListBox.Count - 1 do { each function }
      begin
        PlotData := TPlotDataObject(CheckListBox.Items.Objects[i]).Data;
        with PlotData do
        begin
          s := fxyStr + #9 + txtStr + #9 + NoteStr + #9 + FloatToStr(xMin) + #9
            + FloatToStr(xMax) + #9 + FloatToStr(xInc) + #9 + FloatToStr(yMin) +
            #9 + FloatToStr(yMax) + #9 + FloatToStr(yInc) + #9 +
            FloatToStr(zMin) + #9 + FloatToStr(zMax) + #9 + BoolToStr(zLim) + #9
            + BoolToStr(zCap) + #9 + ColorToStr(UpperColor) + #9 +
            ColorToStr(LowerColor) + #9 + FloatToStr(ColorBlend) + #9 +
            FloatToStr(ColorMove) + #9 + IntToStr(Ord(ViewMode)) + #9 +
            IntToStr(Ord(fxyMode)) + #9 + BoolToStr(CheckListBox.Checked[i]);
        end;
        writeln(f, s);
      end;

      with AddedData do
      begin
        s := FloatToStr(xMin) + #9 + FloatToStr(xMax) + #9 + FloatToStr(xInc) +
          #9 + FloatToStr(yMin) + #9 + FloatToStr(yMax) + #9 + FloatToStr(yInc)
          + #9 + FloatToStr(zMin) + #9 + FloatToStr(zMax) + #9 + BoolToStr(zLim)
          + #9 + BoolToStr(zCap) + #9 + ColorToStr(UpperColor) + #9 +
          ColorToStr(LowerColor) + #9 + FloatToStr(ColorBlend) + #9 +
          FloatToStr(ColorMove) + #9 + IntToStr(Ord(ViewMode)) + #9 +
          IntToStr(Ord(fxyMode)) + #9 + IntToStr(AddLineWidth) + #9 +
          IntToStr(AddLineColor) + #9 + IntToStr(Ord(AddedAs));
      end;
      writeln(f, s);
    finally
      Flush(f);
      CloseFile(f);
    end;
  except
    MessageDlg('File Error! An Error has occurred' +
      #13#10'when attempting to write to "' + GraphFName + '".', mtError,
      [mbOK], 0);
  end;
  NewFile := False;
  Altered := False;
  Layout.CurrentGraphFName := GraphFName;
end;

procedure TFunctionsForm.cbZCapClick(Sender: TObject);
begin
  PlotData.zCap := cbZCap.Checked;
  UpdateTPlotDataObject;
  ApplyBtn.Visible := True;
end;

procedure TFunctionsForm.cbZLimitClick(Sender: TObject);
begin
  PlotData.zLim := cbZLimit.Checked;
  UpdateTPlotDataObject;
  ApplyBtn.Visible := True;
end;

procedure TFunctionsForm.ShowData(Sender: TObject);
begin
  if not(Sender is TCheckListBox) then
  begin
    ViewForm.CameraCube.Position.AsVector := ViewData.CameraCubeAt;
    ViewForm.Camera.Position.AsVector := ViewData.CameraAt;
    ViewForm.Camera.FocalLength := ViewData.fLength;
    ViewForm.GLLight.Position.AsVector := ViewData.LightAt;
    ViewForm.Camera.DepthOfView := ViewData.ViewDepth;
    ViewForm.GLSViewer.Buffer.BackgroundColor := ViewData.BackColor;
  end;

  GridOptionsForm.EditViewDepth.Text :=
    FloatToStrF(ViewData.ViewDepth, ffGeneral, 7, 4);

  // xy
  GridOptionsForm.EditxyGridMinx.Text := FloatToStrF(ViewData.xyGrid.xRange.Minimum,
    ffGeneral, 7, 4);
  ViewForm.GLxyGrid.XSamplingScale.Min := ViewData.xyGrid.xRange.Minimum;
  GridOptionsForm.EditxyGridMiny.Text := FloatToStrF(ViewData.xyGrid.yRange.Minimum,
    ffGeneral, 7, 4);
  ViewForm.GLxyGrid.YSamplingScale.Min := ViewData.xyGrid.yRange.Minimum;

  GridOptionsForm.EditxyGridMaxx.Text := FloatToStrF(ViewData.xyGrid.xRange.Maximum,
    ffGeneral, 7, 4);
  ViewForm.GLxyGrid.XSamplingScale.Max := ViewData.xyGrid.xRange.Maximum;
  GridOptionsForm.EditxyGridMaxy.Text := FloatToStrF(ViewData.xyGrid.yRange.Maximum,
    ffGeneral, 7, 4);
  ViewForm.GLxyGrid.YSamplingScale.Max := ViewData.xyGrid.yRange.Maximum;

  GridOptionsForm.EditxyGridStpx.Text := FloatToStrF(ViewData.xyGrid.xRange.Step,
    ffGeneral, 7, 4);
  ViewForm.GLxyGrid.XSamplingScale.Step := ViewData.xyGrid.xRange.Step;
  GridOptionsForm.EditxyGridStpy.Text := FloatToStrF(ViewData.xyGrid.yRange.Step,
    ffGeneral, 7, 4);
  ViewForm.GLxyGrid.YSamplingScale.Step := ViewData.xyGrid.yRange.Step;

  GridOptionsForm.EditxyGridPosz.Text := FloatToStrF(ViewData.xyGrid.zPosition,
    ffGeneral, 7, 4);
  ViewForm.GLxyGrid.Position.z := ViewData.xyGrid.zPosition * ViewData.xyGrid.zScale;

  GridOptionsForm.EditzScale.Text := FloatToStrF(ViewData.xyGrid.zScale,
    ffGeneral, 7, 4);
  ViewForm.GLxzGrid.Scale.z := ViewData.xyGrid.zScale;
  ViewForm.GLyzGrid.Scale.z := ViewData.xyGrid.zScale;

  ViewForm.GLxyGrid.LineColor.SetColor(ViewData.xyGrid.Color.x, ViewData.xyGrid.Color.y,
    ViewData.xyGrid.Color.z, ViewData.xyGrid.Color.W);

  // xz
  GridOptionsForm.EditxzGridMinx.Text := FloatToStrF(ViewData.xzGrid.xRange.Minimum,
    ffGeneral, 7, 4);
  ViewForm.GLxzGrid.XSamplingScale.Min := ViewData.xzGrid.xRange.Minimum;
  GridOptionsForm.EditxzGridMinz.Text := FloatToStrF(ViewData.xzGrid.zRange.Minimum,
    ffGeneral, 7, 4);
  ViewForm.GLxzGrid.ZSamplingScale.Min := ViewData.xzGrid.zRange.Minimum;

  GridOptionsForm.EditxzGridMaxx.Text := FloatToStrF(ViewData.xzGrid.xRange.Maximum,
    ffGeneral, 7, 4);
  ViewForm.GLxzGrid.XSamplingScale.Max := ViewData.xzGrid.xRange.Maximum;
  GridOptionsForm.EditxzGridMaxz.Text := FloatToStrF(ViewData.xzGrid.zRange.Maximum,
    ffGeneral, 7, 4);
  ViewForm.GLxzGrid.ZSamplingScale.Max := ViewData.xzGrid.zRange.Maximum;

  GridOptionsForm.EditxzGridStpx.Text := FloatToStrF(ViewData.xzGrid.xRange.Step,
    ffGeneral, 7, 4);
  ViewForm.GLxzGrid.XSamplingScale.Step := ViewData.xzGrid.xRange.Step;
  GridOptionsForm.EditxzGridStpz.Text := FloatToStrF(ViewData.xzGrid.zRange.Step,
    ffGeneral, 7, 4);
  ViewForm.GLxzGrid.ZSamplingScale.Step := ViewData.xzGrid.zRange.Step;

  GridOptionsForm.EditxzGridPosy.Text := FloatToStrF(ViewData.xzGrid.yPosition,
    ffGeneral, 7, 4);
  ViewForm.GLxzGrid.Position.y := ViewData.xzGrid.yPosition;

  ViewForm.GLxzGrid.LineColor.SetColor(ViewData.xzGrid.Color.x, ViewData.xzGrid.Color.y,
    ViewData.xzGrid.Color.z, ViewData.xzGrid.Color.W);

  // yz
  GridOptionsForm.EdityzGridMiny.Text := FloatToStrF(ViewData.yzGrid.yRange.Minimum,
    ffGeneral, 7, 4);
  ViewForm.GLyzGrid.YSamplingScale.Min := ViewData.yzGrid.yRange.Minimum;
  GridOptionsForm.EdityzGridMinz.Text := FloatToStrF(ViewData.yzGrid.zRange.Minimum,
    ffGeneral, 7, 4);
  ViewForm.GLyzGrid.ZSamplingScale.Min := ViewData.yzGrid.zRange.Minimum;

  GridOptionsForm.EdityzGridMaxy.Text := FloatToStrF(ViewData.yzGrid.yRange.Maximum,
    ffGeneral, 7, 4);
  ViewForm.GLyzGrid.YSamplingScale.Max := ViewData.yzGrid.yRange.Maximum;
  GridOptionsForm.EdityzGridMaxz.Text := FloatToStrF(ViewData.yzGrid.zRange.Maximum,
    ffGeneral, 7, 4);
  ViewForm.GLyzGrid.ZSamplingScale.Max := ViewData.yzGrid.zRange.Maximum;

  GridOptionsForm.EdityzGridStpy.Text := FloatToStrF(ViewData.yzGrid.yRange.Step,
    ffGeneral, 7, 4);
  ViewForm.GLyzGrid.YSamplingScale.Step := ViewData.yzGrid.yRange.Step;
  GridOptionsForm.EdityzGridStpz.Text := FloatToStrF(ViewData.yzGrid.zRange.Step,
    ffGeneral, 7, 4);
  ViewForm.GLyzGrid.ZSamplingScale.Step := ViewData.yzGrid.zRange.Step;
  GridOptionsForm.EdityzGridPosx.Text := FloatToStrF(ViewData.yzGrid.xPosition,
    ffGeneral, 7, 4);
  ViewForm.GLyzGrid.Position.x := ViewData.yzGrid.xPosition;
  ViewForm.GLyzGrid.LineColor.SetColor(ViewData.yzGrid.Color.x, ViewData.yzGrid.Color.y,
    ViewData.yzGrid.Color.z, ViewData.yzGrid.Color.W);
  ViewForm.BoxLine1.LineColor.SetColor(ViewData.BoxLnColor.x, ViewData.BoxLnColor.y,
    ViewData.BoxLnColor.z, ViewData.BoxLnColor.W);

  ViewForm.BoxLine2.LineColor := ViewForm.BoxLine1.LineColor;
  ViewForm.BoxLine3.LineColor := ViewForm.BoxLine1.LineColor;
  ViewForm.BoxLine4.LineColor := ViewForm.BoxLine1.LineColor;

  GridOptionsForm.xyGridCB.Checked := ViewData.xyGrid.IsVisible;
  GridOptionsForm.xyLock.Checked := ViewData.xyGrid.IsChecked;
  ViewForm.GLxyGrid.Visible := ViewData.xyGrid.IsVisible;

  GridOptionsForm.xzGridCB.Checked := ViewData.xzGrid.IsVisible;
  GridOptionsForm.zLock.Checked := ViewData.xzGrid.IsChecked;
  ViewForm.GLxzGrid.Visible := ViewData.xzGrid.IsVisible;

  GridOptionsForm.yzGridCB.Checked := ViewData.yzGrid.IsVisible;
  GridOptionsForm.MinLock.Checked := ViewData.yzGrid.IsChecked;
  ViewForm.GLyzGrid.Visible := ViewData.yzGrid.IsVisible;

  GridOptionsForm.EditzScale.Text := FloatToStrF(ViewData.xyGrid.zScale,
    ffGeneral, 7, 4);
  ViewForm.GLxzGrid.Scale.z := ViewData.xyGrid.zScale;
  ViewForm.GLyzGrid.Scale.z := ViewData.xyGrid.zScale;

  GridOptionsForm.BoxOutlineCB.Checked := ViewData.BoxChecked;
  GridOptionsForm.EditBoxLnWidth.Text := IntToStr(ViewData.BoxLnWidth);
  GridOptionsForm.DrawOutline(ViewData.BoxChecked);

  EvaluateForm.EditX.Text := FloatToStrF(ViewData.xEvaluate, ffGeneral, 7, 4);
  EvaluateForm.EditY.Text := FloatToStrF(ViewData.yEvaluate, ffGeneral, 7, 4);
  EvaluateForm.EditZ.Text := '';
  EvaluateForm.EditCoordWidth.Text := IntToStr(ViewData.CoordWidth);
  EvaluateForm.Coordinates.Checked := ViewData.CoordChecked;
  EvaluateForm.ToGrids.Checked := ViewData.ToGridsChecked;
  EvaluateForm.dzdx_dzdy.Checked := ViewData.dzdx_dyChecked;
  EvaluateForm.ColorDialog.Color := ViewData.CoordColor;
  EvaluateForm.UpdateCoords;
  EvaluateForm.UpdateEvaluate;

  CoordsForm.cbShowCoords.Checked := ViewData.TextVisible;
  CoordsForm.FontButton.Caption := 'Font:' + ' ' + ViewData.TextFontN + ' ' +
    IntToStr(ViewData.TextFontSz);
  ViewForm.GLWinBmpFont.Font.Name := ViewData.TextFontN;
  ViewForm.GLWinBmpFont.Font.Size := ViewData.TextFontSz;
  CoordsForm.cbXmaxY.Checked := ViewData.xPosYMax;
  CoordsForm.cbXmaxZ.Checked := ViewData.xPosZMax;

  CoordsForm.cbYmaxX.Checked := ViewData.yPosXMax;
  CoordsForm.cbYmaxZ.Checked := ViewData.yPosZMax;

  CoordsForm.cbZmaxY.Checked := ViewData.zPosYMax;
  CoordsForm.cbZmaxX.Checked := ViewData.zPosXMax;

  CoordsForm.UpdateCoordText;

  Editfxy.Text := PlotData.txtStr;
  EditNote.Text := PlotData.NoteStr;

  EditMinX.Text := FloatToStrF(PlotData.xMin, ffGeneral, 7, 4);
  EditMaxX.Text := FloatToStrF(PlotData.xMax, ffGeneral, 7, 4);
  EditdX.Text := FloatToStrF(PlotData.xInc, ffGeneral, 7, 4);

  EditMinY.Text := FloatToStrF(PlotData.yMin, ffGeneral, 7, 4);
  EditMaxY.Text := FloatToStrF(PlotData.yMax, ffGeneral, 7, 4);
  EditdY.Text := FloatToStrF(PlotData.yInc, ffGeneral, 7, 4);

  EditMinZ.Text := FloatToStrF(PlotData.zMin, ffGeneral, 7, 4);
  EditMaxZ.Text := FloatToStrF(PlotData.zMax, ffGeneral, 7, 4);
  cbZLimit.Checked := PlotData.zLim;
  cbZCap.Checked := PlotData.zCap;

  ModeComboBox.ItemIndex := Ord(PlotData.ViewMode);
  StyleComboBox.ItemIndex := Ord(PlotData.fxyMode);

  Caption := GraphFName;
  ViewForm.Caption := GraphFName;
  GridOptionsForm.Caption := GraphFName;
  EvaluateForm.Caption := GraphFName;
  CoordsForm.Caption := GraphFName;
  CountzPoints;
end;

procedure TFunctionsForm.StyleComboBoxChange(Sender: TObject);
begin
  PlotData.fxyMode := TfxyMode(StyleComboBox.ItemIndex);
  UpdateTPlotDataObject;
  ApplyBtnClick(Sender);
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

procedure TFunctionsForm.AddNewPlot;
begin
  with CheckListBox do
  begin
    AddItem(PlotData.txtStr, TPlotDataObject.Create(PlotData));
    ItemIndex := Count - 1;
    Checked[ItemIndex] := True; { initially this item is checked }
  end;
  Editfxy.SetFocus;
  Editfxy.SelLength := 0;
end;

procedure TFunctionsForm.ApplyBtnClick(Sender: TObject);
var
  v: TGlFloat;
  s: string;

begin
  if TooManyPoints > 6 then
    Exit;

  with PlotData do
  begin
    if xMin > xMax then { swap }
    begin
      v := xMin;
      xMin := xMax;
      xMax := v;
      s := EditMinX.Text;
      EditMinX.Text := EditMaxX.Text;
      EditMaxX.Text := s;
      UpdateTPlotDataObject;
    end;
    if yMin > yMax then { swap }
    begin
      v := yMin;
      yMin := yMax;
      yMax := v;
      s := EditMinY.Text;
      EditMinY.Text := EditMaxY.Text;
      EditMaxY.Text := s;
      UpdateTPlotDataObject;
    end;
  end;

  AddedData.AddedAs := AddNone;

  ViewForm.UpdatePlot;
  EvaluateForm.UpdateEvaluate;
  ApplyBtn.Visible := False;
  Altered := True;
end;

procedure TFunctionsForm.CentreClick(Sender: TObject);
var
  x, y, z: TGlFloat;

begin
  with ViewForm do
  begin
    MousePoint.x := Maxint;
    x := PlotData.xMax + PlotData.xMin;
    y := PlotData.yMax + PlotData.yMin;
    z := PlotData.zMax + PlotData.zMin;
    TargetCube.Position.SetPoint(x / 2, y / 2, z / 2);
  end;
  Altered := True;
  ViewForm.ShowDisplacement;
end;

procedure TFunctionsForm.CheckListBoxClick(Sender: TObject);
begin
  PlotData := TPlotDataObject(CheckListBox.Items.Objects[CheckListBox.ItemIndex]).Data;
  if CheckListBox.Checked[CheckListBox.ItemIndex] then
    EvaluateForm.UpdateEvaluate;

  ShowData(Sender);
  if PlotColorsForm.Visible then
    PlotColorsForm.ShowPlotColorData;
  if DerivativesForm.Visible then
    DerivativesForm.ApplyBtn.Visible := True;
end;

procedure TFunctionsForm.CheckListBoxClickCheck(Sender: TObject);
begin
  ApplyBtn.Visible := True;
end;

procedure TFunctionsForm.ReadAndShowInitialData;
begin
  if not ReadData(DataPath + GraphFName) then
  begin
    GraphFName := NewFName;
    NewFile := True;
    ViewData := DefaultViewData;
    PlotData := DefaultPlotData;
    AddedData := DefaultAddedData;
    with CheckListBox do
    begin
      AddItem(PlotData.txtStr, TPlotDataObject.Create(PlotData));
      ItemIndex := Count - 1;
      Checked[ItemIndex] := True; // initially this item is checked
    end;
    ViewForm.TargetCube.Position.SetPoint(0, 0, 0);
  end;

  Caption := GraphFName;
  ShowData(Self);
end;

procedure TFunctionsForm.OpenRecentFile(FName: TFileName);
var
  i: integer;

begin
  if DerivativesForm.Visible then
    DerivativesForm.Close;
  if FileExists(FName) then
  begin
    if Altered or GridColorsAltered then
      case MessageDlg('The current graph''s data has been altered.' +
        #13#10'Do you wish to save the alterations ?', mtConfirmation,
        [mbYes, mbNo, mbCancel], 0) of
        mrYes:
          SaveClick(Self);
        mrCancel:
          Exit;
        mrNo:
          begin
            Altered := False;
            GridColorsAltered := False;
            DerivativeAltered := False;
            NewFile := False;
          end;
      end;
    AddRecent(FName);
    DataPath := ExtractFilePath(FName);
    DataPath := IncludeTrailingPathDelimiter(DataPath);
    ViewForm.MousePoint.x := Maxint;
    GraphFName := ExtractFileName(FName);

    with CheckListBox do
    begin
      for i := 0 to Items.Count - 1 do
        Items.Objects[i].Free;
      Clear;
    end;

    if ReadData(FName) then
      ShowData(Self);
    if GridColorsForm.Visible then
      GridColorsForm.ShowGridColorData;
    if PlotColorsForm.Visible then
      PlotColorsForm.ShowPlotColorData;

    ApplyBtnClick(Self);
    Altered := False;
    GridColorsAltered := False;
    DerivativeAltered := False;
  end
  else
    MessageDlg('The file ' + FName + ' does not exist!', mtError, [mbOK], 0);
end;

procedure TFunctionsForm.AddRecent(const f: TFileName);
var
  i: integer;
  Found: Boolean;

begin
  with ViewForm.Recent1 do
  begin
    Found := False;
    i := 0;
    while (i < Count) and not Found do
    begin
      Found := Items[i].Caption = DataPath + GraphFName;
      Inc(i);
    end;
    if Found then
      Delete(i - 1);
    Insert(0, TMenuItem.Create(Self));
    Items[0].Caption := DataPath + GraphFName;
    Items[0].OnClick := ViewForm.RecentFilesClick;
    if Count > 16 then
      Delete(Count - 1);
  end;
end;

procedure TFunctionsForm.OpenSelectedFile(Sender: TObject; FName: TFileName);
var
  i: integer;

begin
  if FileExists(FName) then
  begin
    Screen.Cursor := crHourglass;
    with CheckListBox do
    begin
      for i := 0 to Items.Count - 1 do
        Items.Objects[i].Free;
      Clear;
    end;
    GraphFName := ExtractFileName(FName);
    if ReadData(DataPath + GraphFName) then
    begin
      Caption := GraphFName;
      ViewForm.Caption := GraphFName;
      GridOptionsForm.Caption := GraphFName;
      ShowData(Sender);
      NewFile := False;
      Altered := False;
      (* NewFont needed to initialize GLWinFont.GetCharWidth
        if the font has been altered, which may or may not be the case,
        so do it anyway *)
      ViewForm.GLSViewer.Buffer.BackgroundColor := ViewData.BackColor;
      ViewForm.GLSViewer.Invalidate;
    end;
    Screen.Cursor := crDefault;
  end
  else
  begin
    MessageDlg('The file' + FName + #13#10'Could not be found.', mtError,
      [mbOK], 0);
    Screen.Cursor := crDefault;
  end;
end;

end.
