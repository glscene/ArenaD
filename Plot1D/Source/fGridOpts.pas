unit fGridOpts;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.UITypes,
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.Math,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Vcl.Buttons,
  Vcl.ComCtrls,
  Vcl.Menus,

  uParser,
  uGlobal;

type
  TGridOptionsForm = class(TForm)
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

    EditMinY: TEdit;
    EditMinX: TEdit;
    EditMaxX: TEdit;
    EditMaxY: TEdit;

    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    SpeedButton7: TSpeedButton;
    SpeedButton8: TSpeedButton;

    EditAxesPen: TEdit;
    UpDown1: TUpDown;
    EditMajorGrid: TEdit;
    UpDown2: TUpDown;
    EditMinorGrid: TEdit;
    UpDown3: TUpDown;

    GridStyles: TRadioGroup;
    xTrackBar: TTrackBar;
    yTrackBar: TTrackBar;

    BitBtn1: TBitBtn;
    ApplyBitBtn: TBitBtn;
    ColorDialog: TColorDialog;
    FontDialog: TFontDialog;
    LogXCheck: TCheckBox;
    LogYCheck: TCheckBox;
    SaveSpeedButton: TSpeedButton;
    RestoreSpeedButton: TSpeedButton;
    procedure FormShow(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure ApplyBitBtnClick(Sender: TObject);

    procedure EditMinXKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EditMaxXKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EditMinYKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EditMaxYKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EditPenKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EditPenChange(Sender: TObject);

    procedure EditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);

    procedure ParseKeyPress(Sender: TObject; var Key: Char);
    procedure IntKeyPress(Sender: TObject; var Key: Char);

    procedure GridStylesClick(Sender: TObject);
    procedure ColorClick(Sender: TObject);
    procedure FontClick(Sender: TObject);
    procedure LogXCheckClick(Sender: TObject);
    procedure LogYCheckClick(Sender: TObject);

    procedure Centre(Sender: TObject);
    procedure EqualGrad(Sender: TObject);
    procedure EqualRange(Sender: TObject);
    procedure xTrackBarChange(Sender: TObject);
    procedure yTrackBarChange(Sender: TObject);
    procedure SaveSpeedButtonClick(Sender: TObject);
    procedure RestoreSpeedButtonClick(Sender: TObject);
  private
     
    function AnyPolar: Boolean;
  public
     
    procedure ShowData;
  end;

var
  GridOptionsForm: TGridOptionsForm;

//========================================================================
implementation
//========================================================================

uses
  fMain,
  fTextBlocks,
  fFuncts;

{$R *.dfm}

procedure TGridOptionsForm.FormShow(Sender: TObject);
begin
  Caption := GraphFName;
  ShowData;
end;

procedure TGridOptionsForm.BitBtn1Click(Sender: TObject);
begin
  Close;
end;

procedure TGridOptionsForm.ApplyBitBtnClick(Sender: TObject);
  procedure Swap(var n1, n2: extended);
  var
    n: extended;

  begin
    n := n1;
    n1 := n2;
    n2 := n;
  end;

begin
  with GraphData do
  begin
    if xMin = xMax then xMax := 1.1*xMin;
    if yMin = yMax then yMax := 1.1*yMin;
    if xMin > xMax then Swap(xMin, xMax);
    if yMin > yMax then Swap(yMin, yMax);
  end;

  Altered := True;
  MainForm.GLViewer.Invalidate;
  ApplyBitBtn.Visible := False;
end;

procedure TGridOptionsForm.EditMinXKeyUp(Sender: TObject; var Key: Word;
                                          Shift: TShiftState);
var
  x: extended;
  s: string;
  e: byte;

begin
  with GraphData do
  begin
    s := ScanText(EditMinX.Text);
    x := ParseAndEvaluate(s, e);
    if isNAN(x) or isInfinite(x) then x := 0;
    if (e = 0) and((Grid.xAxisStyle <> asLog) or (x > 0)) then xMin := x
    else if Grid.xAxisStyle = asLog then xMin :=  0.1 else xMin := -0.1;
  end;
end;

procedure TGridOptionsForm.EditMinYKeyUp(Sender: TObject; var Key: Word;
                                          Shift: TShiftState);
var
  y: extended;
  s: string;
  e: byte;

begin
  with GraphData do
  begin
    s := ScanText(EditMinY.Text);
    y := ParseAndEvaluate(s, e);
    if isNAN(y) or isInfinite(y) then y := 0;
    if (e = 0) and((Grid.yAxisStyle <> asLog) or (y > 0)) then yMin := y
    else if Grid.yAxisStyle = asLog then yMin :=  0.1 else yMin := -0.1;
  end;
end;

procedure TGridOptionsForm.EditMaxXKeyUp(Sender: TObject; var Key: Word;
                                          Shift: TShiftState);
var
  x: extended;
  s: string;
  e: byte;

begin
  with GraphData do
  begin
    s := ScanText(EditMaxX.Text);
    x := ParseAndEvaluate(s, e);
    if isNAN(x) or isInfinite(x) then x := 0;
    if (e = 0) and((Grid.xAxisStyle <> asLog) or (x > 0)) then xMax := x
    else xMax := 0.1;
  end;
end;

procedure TGridOptionsForm.EditMaxYKeyUp(Sender: TObject; var Key: Word;
                                          Shift: TShiftState);
var
  y: extended;
  s: string;
  e: byte;

begin
  with GraphData do
  begin
    s := ScanText(EditMaxY.Text);
    y := ParseAndEvaluate(s, e);
    if isNAN(y) or isInfinite(y) then y := 0;
    if (e = 0) and((Grid.yAxisStyle <> asLog) or (y > 0)) then yMax := y
    else yMax := 0.1;
  end;
end;

procedure TGridOptionsForm.EditPenKeyUp(Sender: TObject; var Key: Word;
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
    if w < 1 then w := 1;

    with GraphData do
    case Tag of
    0:AxisWidth := w;
    1:MajorWidth := w;
    2:MinorWidth := w;
    end;
    Altered := True;
    MainForm.GLViewer.Invalidate;
  end;
end;

procedure TGridOptionsForm.EditPenChange(Sender: TObject);
var
  k: word;

begin
  k := 0;
  EditPenKeyUp(Sender, k, []);
end;

procedure TGridOptionsForm.EditKeyDown(Sender: TObject; var Key: Word;
                                       Shift: TShiftState);
begin
  if Active and ((Key = VK_DELETE) or (Key = VK_BACK))
  then ApplyBitBtn.Visible := True;
end;

procedure TGridOptionsForm.ParseKeyPress(Sender: TObject; var Key: Char);
begin
  with Sender as TEdit do
  begin
    if not CharInSet(UpCase(Key),
   [' ', '!', '(', ')', '*', '+', '-', '.', ',', '/', '0'..'9',
    'A'..'C', 'E', 'G'..'I', 'L', 'N'..'T', 'X', '^', '`', #8]) then
    begin
      Key := #0;
      Exit;
    end
    else if Active then ApplyBitBtn.Visible := True;
    if Key = '`' then Key := '°';
  end;
end;

procedure TGridOptionsForm.IntKeyPress(Sender: TObject; var Key: Char);
begin
  with Sender as TEdit do
  if not CharInSet(Key, ['0'..'9', #8]) then Key := #0
end;

procedure TGridOptionsForm.xTrackBarChange(Sender: TObject);
begin
  if Active then with GraphData do
  begin
    if xTrackBar.Position > 10
    then xMinorGrad := 10*(xTrackBar.Position - 10)
    else xMinorGrad := xTrackBar.Position;
    xMajorGrad := 10*xMinorGrad;
    Altered := True;
    MainForm.GLViewer.Invalidate;
  end;
end;

procedure TGridOptionsForm.yTrackBarChange(Sender: TObject);
begin
  if Active then with GraphData do
  begin
    if yTrackBar.Position > 10
    then yMinorGrad := 10*(yTrackBar.Position - 10)
    else yMinorGrad := yTrackBar.Position;
    yMajorGrad := 10*yMinorGrad;
    Altered := True;
    MainForm.GLViewer.Invalidate;
  end;
end;

procedure TGridOptionsForm.GridStylesClick(Sender: TObject);
begin
  if Active then
  begin
    with GridStyles, GraphData do Grid.GridStyle := TGridStyle(ItemIndex);
    Altered := True;
    MainForm.GLViewer.Invalidate;
  end;
end;

procedure TGridOptionsForm.ColorClick(Sender: TObject);
begin
  with GraphData do
  begin
    case TSpeedButton(Sender).Tag of
    0:ColorDialog.Color := BackColor;
    1:ColorDialog.Color := GridColor;
    2:ColorDialog.Color := xAxisColor;
    3:ColorDialog.Color := yAxisColor;
    end;
    if ColorDialog.Execute then
    begin
      case TSpeedButton(Sender).Tag of
      0:begin
          BackColor := ColorDialog.Color;
          MainForm.GLViewer.Buffer.BackgroundColor := BackColor;
          with TextBlocksForm
          do if BlockListBox.Count > 0 then RichEdit.Color := BackColor;
        end;
      1:GridColor := ColorDialog.Color;
      2:xAxisColor := ColorDialog.Color;
      3:yAxisColor := ColorDialog.Color;
      end;
      Altered := True;
      MainForm.GLViewer.Invalidate;
    end;
  end;
end;

procedure TGridOptionsForm.FontClick(Sender: TObject);
begin
  with FontDialog, GraphData do
  begin
    case TSpeedButton(Sender).Tag of
    0:begin
        Font.Name := FontName;
        Font.Style := FontStyle;
        Font.Size := FontSize;
      end;
    end;
    if Execute then
    begin
      case TSpeedButton(Sender).Tag of
      0:begin
          FontName := Font.Name;
          FontStyle := Font.Style;
          FontSize := Font.Size;
        end;
      end;
      Altered := True;
      NewFont := True;
      MainForm.GLViewer.Invalidate;
    end;
  end;
end;

procedure TGridOptionsForm.LogXCheckClick(Sender: TObject);
var
  d: extended;

begin
  if AnyPolar then  { can not use log axes }
  begin
    LogXCheck.Checked := False;
    MainForm.StatusBar.Panels[2].Text := 'One or more Functions are Polar';
  end
  else
  begin
    with GraphData do
    begin
      if LogXCheck.Checked then
      begin
        with FunctionsForm do
        begin
          if Integrate2x.Checked then CloseIntegrateXForm;
          if Integrate2y.Checked then CloseIntegrateYForm;
          if Between1.Checked then CloseBetweenForm;
          if Volumex1.Checked then CloseVolumeXForm;
          if Volumey1.Checked then CloseVolumeYForm;
        end;

        Grid.xAxisStyle := asLog;
        if xMin <= 0 then  { xMin must be +ve }
        begin
          d := xMax - xMin;
          xMin := (xMax - xMin)/MainForm.GLViewer.Width;
          xMax := xMin + d;
          EditMinX.Text := FloatToStr(xMin);
          EditMaxX.Text := FloatToStr(xMax);
        end;
      end
      else Grid.xAxisStyle := asLinear;

      SpeedButton6.Enabled := (Grid.xAxisStyle = asLinear) and
                              (Grid.yAxisStyle = asLinear);
      SpeedButton7.Enabled := SpeedButton6.Enabled or
                             ((Grid.xAxisStyle = asLog) and
                              (Grid.yAxisStyle = asLog));
      SpeedButton8.Enabled := SpeedButton6.Enabled or
                             ((Grid.xAxisStyle = asLog) and
                              (Grid.yAxisStyle = asLog));

      with FunctionsForm do
      begin
        SwitchButton.Visible := SpeedButton6.Enabled;
        Integrate1.Enabled := SpeedButton6.Enabled;
      end;
    end;
    Altered := True;
    MainForm.GLViewer.Invalidate;
  end;
end;

procedure TGridOptionsForm.LogYCheckClick(Sender: TObject);
var
  d: extended;

begin
  if AnyPolar then  { can not use log axes }
  begin
    LogYCheck.Checked := False;
    MainForm.StatusBar.Panels[2].Text := 'One or more Functions are Polar';
  end
  else
  begin
    with GraphData do
    begin
      if LogYCheck.Checked then
      begin
        with FunctionsForm do
        begin
          if Integrate2x.Checked then CloseIntegrateXForm;
          if Integrate2y.Checked then CloseIntegrateYForm;
          if Between1.Checked then CloseBetweenForm;
          if Volumex1.Checked then CloseVolumeXForm;
          if Volumey1.Checked then CloseVolumeYForm;
        end;

        Grid.yAxisStyle := asLog;
        if yMin <= 0 then  { yMin must be +ve }
        begin
          d := yMax - yMin;
          yMin := (yMax - yMin)/MainForm.GLViewer.Height;
          yMax := yMin + d;
          EditMinY.Text := FloatToStr(yMin);
          EditMaxY.Text := FloatToStr(yMax);
        end;
      end
      else Grid.yAxisStyle := asLinear;

      SpeedButton6.Enabled := (Grid.xAxisStyle = asLinear) and
                              (Grid.yAxisStyle = asLinear);
      SpeedButton7.Enabled := SpeedButton6.Enabled or
                             ((Grid.xAxisStyle = asLog) and
                              (Grid.yAxisStyle = asLog));
      SpeedButton8.Enabled := SpeedButton6.Enabled or
                             ((Grid.xAxisStyle = asLog) and
                              (Grid.yAxisStyle = asLog));

      with FunctionsForm do
      begin
        SwitchButton.Visible := SpeedButton6.Enabled;
        Integrate1.Enabled := SpeedButton6.Enabled;
      end;
    end;
    Altered := True;
    MainForm.GLViewer.Invalidate;
  end;
end;

procedure TGridOptionsForm.RestoreSpeedButtonClick(Sender: TObject);
begin
  with GraphData do
  begin
    if (SavexMin > 0) or (Grid.xAxisStyle = asLinear)
    then xMin := SavexMin;
    xMax := SavexMax;
    if (SaveyMin > 0) or (Grid.yAxisStyle = asLinear)
    then yMin := SaveyMin;
    yMax := SaveyMax;

    EditMinX.Text := FloatToStrF(xMin, ffGeneral, 13, 4);
    EditMaxX.Text := FloatToStrF(xMax, ffGeneral, 13, 4);
    EditMinY.Text := FloatToStrF(yMin, ffGeneral, 13, 4);
    EditMaxY.Text := FloatToStrF(yMax, ffGeneral, 13, 4);
  end;
  Altered := True;
  MainForm.GLViewer.Invalidate;
end;

procedure TGridOptionsForm.Centre(Sender: TObject);
var
  x, y: extended;

begin
  with GraphData do
  begin
    x := (xMax - xMin)/2;
    xMin := -x;
    xMax :=  x;

    y := (yMax - yMin)/2;
    yMin := -y;
    yMax :=  y;

    EditMinX.Text := FloatToStrF(xMin, ffGeneral, 13, 4);
    EditMaxX.Text := FloatToStrF(xMax, ffGeneral, 13, 4);
  end;

  Altered := True;
  MainForm.GLViewer.Invalidate;
end;

procedure TGridOptionsForm.EqualGrad(Sender: TObject);
var
  x, y, r: extended;

begin
  with GraphData do
  begin
    x := xMax - xMin;
    y := yMax - yMin;
    r := (x*MainForm.GLViewer.Height)/(y*Mainform.GLViewer.Width);

    if x > y then
    begin
      yMax := yMax*r;
      yMin := yMin*r;
    end
    else
    begin
      xMax := xMax/r;
      xMin := xMin/r;
    end;
    EditMinX.Text := FloatToStrF(xMin, ffGeneral, 13, 4);
    EditMaxX.Text := FloatToStrF(xMax, ffGeneral, 13, 4);
  end;
  Altered := True;
  MainForm.GLViewer.Invalidate;
end;

procedure TGridOptionsForm.EqualRange(Sender: TObject);
var
  x, y: extended;

begin
  with GraphData do
  begin
    x := xMax - xMin;
    y := yMax - yMin;

    if x > y then
    begin
      xMax := yMax;
      xMin := yMin;
    end
    else
    begin
      yMax := xMax;
      yMin := xMin;
    end;
    EditMinX.Text := FloatToStrF(xMin, ffGeneral, 13, 4);
    EditMaxX.Text := FloatToStrF(xMax, ffGeneral, 13, 4);
    EditMinY.Text := FloatToStrF(yMin, ffGeneral, 13, 4);
    EditMaxY.Text := FloatToStrF(yMax, ffGeneral, 13, 4);
  end;
  Altered := True;
  MainForm.GLViewer.Invalidate;
end;

function TGridOptionsForm.AnyPolar: Boolean;
var
  i: integer;
  Found: Boolean;

begin
  with FunctionsForm.CheckListBox do
  begin
    i := 0;
    Found := False;
    while not Found and (i < Count) do
    begin
      Found := not TPlotDataObject(Items.Objects[i]).Data.PlotAsFx
               and Checked[i];
      Inc(i);
    end;
    Result := Found;
  end;
end;

procedure TGridOptionsForm.SaveSpeedButtonClick(Sender: TObject);
begin
  with GraphData do
  begin
    SavexMin := xMin;
    SavexMax := xMax;
    SaveyMin := yMin;
    SaveyMax := yMax;
    RestoreSpeedButton.Visible := (SavexMin <> SavexMax) and
                                  (SaveyMin <> SaveyMax);
  end;
end;

procedure TGridOptionsForm.ShowData;
var
  b: boolean;

begin
  b := Altered;

  with GraphData do
  begin
    RestoreSpeedButton.Visible := (SavexMin <> SavexMax) and
                                  (SaveyMin <> SaveyMax);
    EditMinX.Text := FloatToStrF(xMin, ffGeneral, 13, 4);
    EditMaxX.Text := FloatToStrF(xMax, ffGeneral, 13, 4);
    EditMinY.Text := FloatToStrF(yMin, ffGeneral, 13, 4);
    EditMaxY.Text := FloatToStrF(yMax, ffGeneral, 13, 4);
    if Active then
    ApplyBitBtn.Visible := False;

    UpDown1.Position := AxisWidth;
    UpDown2.Position := MajorWidth;
    UpDown3.Position := MinorWidth;
    GridStyles.ItemIndex := Ord(Grid.GridStyle);

    LogXCheck.Checked := Grid.xAxisStyle = asLog;
    LogYCheck.Checked := Grid.yAxisStyle = asLog;

    SpeedButton6.Enabled := not(LogXCheck.Checked or LogYCheck.Checked);
    SpeedButton7.Enabled := SpeedButton6.Enabled or
                          ((Grid.xAxisStyle = asLog) and
                           (Grid.yAxisStyle = asLog));
    SpeedButton8.Enabled := SpeedButton6.Enabled or
                          ((Grid.xAxisStyle = asLog) and
                           (Grid.yAxisStyle = asLog));

    Label9.Font.Color := xAxisColor;
    Label10.Font.Color := yAxisColor;
    xTrackBar.Position := xMinorGrad;
    yTrackBar.Position := yMinorGrad;
  end;
  Altered := b;
end;

end.
