unit uGlobal;

interface

uses
  Winapi.Windows,
  System.Classes,
  System.Types,
  System.SysUtils,
  Vcl.Graphics,
  Vcl.Printers;

const
  piCalc = 0;  // just calculate the integral area
  piShow = 1;  // calculate area & plot the integral
  piArea = 2;  // calculate & shade area
  piBoth = 3;  // calculate area, plot the integral & shade area

  Pi: extended = 3.1415926535897932385;
  PiOn2: extended = 1.5707963267948966192;
  twoPi: extended = 6.2831853071795864769;

  NewFName: TFileName = 'New Graph';

type
  TAxisStyle = (asLinear, asLog);
  TGridStyle = (gsNone, gsAxes, gsCartesian, gsPolar);

  TPrinterInfo = record
    Index: integer;          // Printer.PrinterIndex
    PaperID: SmallInt;       // default = DMPAPER_A4
    Orientation: TPrinterOrientation;
    xOffset: integer;        // paper print area horizontal offset pixels
    yOffset: integer;        // paper print area vertical offset pixels
    xRes: integer;           // paper print area horizontal pixels
    yRes: integer;           // paper print area vertical pixels
    xPixPerInch: integer;    // these are equal
    yPixPerInch: integer;
  end;

  TPlotData = record
    FunctStr: string;      // same font as grid except color = PlotColor
    TextStr: string;       // edit field text
    xInc: single;          // cartesian plot increment
    PlotWidth: integer;    // pen width for function plot
    PlotColor: TColor;     // pen color for function plot
    PhiInc: single;        // polar plot increment
    SegMin: extended;      // max and min for segment plot
    SegMax: extended;
    xLabel: extended;      // plot label location
    yLabel: extended;
    ShowLabel: Boolean;
    PlotAsFx: Boolean;     // true if cartesian plot
    IsSegment: Boolean;    // true for segment plot
    IsContinuous: Boolean; // when false app looks for discontinuities
  end;

  TGrid = record
    xAxisStyle: TAxisStyle;
    yAxisStyle: TAxisStyle;
    GridStyle: TGridStyle;
  end;

  TGraphData = record
    xMin: extended;        // plot area view
    yMin: extended;
    xMax: extended;
    yMax: extended;

    SavexMin: extended;    // saved plot area view
    SaveyMin: extended;
    SavexMax: extended;
    SaveyMax: extended;

    AreaAlpha: single;     // transparency of integration area

    FontName: string;
    FontStyle: TFontStyles;
    FontSize: integer;
    AxisWidth: integer;    { axes line pen width }
    xMinorGrad: integer;   { minor X axis graduation lengths }
    yMinorGrad: integer;   { minor Y axis graduation lengths }
    xMajorGrad: integer;   { major X axis graduation lengths }
    yMajorGrad: integer;   { major Y axis graduation lengths }
    MinorWidth: integer;   { minor graduation & grid line width }
    MajorWidth: integer;   { major graduation & grid line width }
    CoordWidth: integer;   { coordinate line width }
    dydxWidth: integer;    { derivative line width }
    d2ydx2Width: integer;  { 2ndderivative line width }
    IntegCount: integer;   { number of integration intervals }
    ydxWidth: integer;     { integral line width }

    BackColor: TColor;     { paper or background color }
    GridColor: TColor;     { grid color }
    xAxisColor: TColor;    { xAxis color }
    yAxisColor: TColor;    { yAxis color}
    CoordColor: TColor;    { coordinate line color }
    dydxColor: TColor;     { derivative line color }
    d2ydx2Color: TColor;   { 2ndderivative line color }
    ydxColor: TColor;      { integral line color }
    PosAreaColor: TColor;  { positive integral area color }
    NegAreaColor: TColor;  { negative integral area color }

    Grid: TGrid;
    PlotData: TPlotData;
  end;

  TPlotDataObject = class(TObject)
    constructor Create(D: TPlotData);
    destructor Destroy; override;
  private
  public
    Data: TPlotData;
  end;

  TGraphPoint = record
    PlotPoint: TPoint;
    x, y: extended;
  end;

  TGraphPointObject = class(TObject) { in uCanvas; drawing differenttial etc. }
    constructor Create(vx_phi, vy_r: extended);
    destructor Destroy; override;
  private
  public
    PlotPoint: TPoint;
    x_phi: extended;
    y_r: extended;
    DrawLine: Boolean;
  end;

  TGraphLine = record    { in uCanvas; drawing integral etc. }
    P1, P2: TPoint;
    x, y1, y2: extended;
  end;

  TGraphLineObject = class(TObject)
    constructor Create(vx, vy: extended);
    destructor Destroy; override;
  private
  public
    GraphLine: TGraphLine;
  end;

  TPenStyle = record
    PenWidth: integer;    { pen width for function plot }
    PenColor: TColor;     { pen color for function plot }
  end;

  TPlotStyle = record
    AreaAlpha: single;     { transparency of integration area }

    StyleName: string[30];
    FontName: string[100];
    FontStyle: TFontStyles;
    FontSize: integer;
    AxisWidth: integer;    { axes line pen width }
    xMinorGrad: integer;   { minor X axis graduation lengths }
    yMinorGrad: integer;   { minor Y axis graduation lengths }
    xMajorGrad: integer;   { major X axis graduation lengths }
    yMajorGrad: integer;   { major Y axis graduation lengths }
    MinorWidth: integer;   { minor graduation & grid line width }
    MajorWidth: integer;   { major graduation & grid line width }
    CoordWidth: integer;   { coordinate line width }
    dydxWidth: integer;    { derivative line width }
    d2ydx2Width: integer;  { 2ndderivative line width }
    IntegCount: integer;   { number of integration intervals }
    ydxWidth: integer;     { integral line width }

    BackColor: TColor;     { paper or background color }
    GridColor: TColor;     { grid color }
    xAxisColor: TColor;    { xAxis color }
    yAxisColor: TColor;    { yAxis color}
    CoordColor: TColor;    { coordinate line color }
    dydxColor: TColor;     { derivative line color }
    d2ydx2Color: TColor;   { 2ndderivative line color }
    ydxColor: TColor;      { integral line color }
    PosAreaColor: TColor;  { positive integral area color }
    NegAreaColor: TColor;  { negative integral area color }

    Grid: TGrid;
    Pens: Array[0..11] of TPenStyle;

    NumLines: Array[0..11] of TPenStyle;  { PlotWidth,  PlotColor }
    NumPoints: Array[0..11] of TPenStyle; { PointSize,  PointColor }
  end;

  TPlotStyleObject = class(TObject)
    constructor Create(S: TPlotStyle);
    destructor Destroy; override;
  private
  public
    Style: TPlotStyle;
  end;

  TFoundPointObject = class(TObject)   { used by Interpolate procedure }
    constructor Create(x, m, y: extended; c, mc: TColor);
    destructor Destroy; override;
  private
  public
    xValue, mValue, yValue: extended;
    Color, mColor: TColor;
  end;

  TTextData = record
    Caption: string;        { in CheckListBox }
    xLoc, yLoc: extended;   { text block left, top }
    yInc: integer;          { default, wbf.CharHeight }
    FontName: string;       { wbf font }
    FontStyle: TFontStyles; { style }
    FontSize: integer;      { size }
    FontColor: TColor;      { color }
  end;

  TTextLineObject = class(TObject)
    constructor Create(T: string; C: TColor);
    destructor Destroy; override;
  private
  public
    Text: string;
    Color: TColor;
  end;

  TTextDataObject = class(TObject)
    constructor Create(D: TTextData);
    destructor Destroy; override;
  private
  public
    Data: TTextData;
    TextLines: TList;       // TTextLineObject list
  end;

  TNumericStyle = (nsNone, nsLinear, nsLagrange, nsHermite);
  TPointStyle = (psSquare, psPlus, psCross, psCircle);

  TNumericData = record
    Name: string;                  { descriptive name }
    NumericStyle: TNumericStyle;   { nsNone, nsLinear, nsLagrange, nsHermite }
    ShowPoints: Boolean;           { points visible if true }
    PointStyle: TPointStyle;       { psSquare, psPlus, psCross, psCircle }
    PointSize: integer;            {  }
    PointColor: TColor;            {  }
    PlotWidth: integer;            { pen width for plot }
    PlotColor: TColor;             { pen color for plot }
    SortXValue: Boolean;           { x values sorted if true }
    Extrapolate: Boolean;          { extrapolate graph if true }
    CoordsIdx: integer;            { enter coords as x, y or phi, r or vector }
    CurveRate: integer;            { was k0 factor k0 = CurveRate/100 }
  end;

  TNumericObject = class(TObject)
    constructor Create(D: TNumericData);
    destructor Destroy; override;
  private
  public
    Data: TNumericData;
    ControlPoints: TList;         // list of TGraphPointObject
  end;

  TLayout = record
    IsMaximize: Boolean;  // is true if MainForm.WindowState = wsMaximized
    MainLeft: integer;
    MainTop: integer;
    MainWidth: integer;
    MainHeight: integer;
    CurrentGraphFName: ShortString;
    CurrentDataPath: ShortString;
    CurrentImagePath: ShortString;
    CurrentPrinterInfo: TPrinterInfo;
    GridsVisible: Boolean;
    GridsLeft: integer;
    GridsTop: integer;
    NumericVisible: Boolean;
    NumericLeft: integer;
    NumericTop: integer;
    TextVisible: Boolean;
    TextLeft: integer;
    TextTop: integer;
    TextWidth: integer;
    TextHeight: integer;
    FuncLeft: integer;
    FuncTop: integer;
    DerivLeft: integer;
    DerivTop: integer;
    IntegXLeft: integer;
    IntegXTop: integer;
    IntegYLeft: integer;
    IntegYTop: integer;
    BetweenLeft: integer;
    BetweenTop: integer;
    VolumeXLeft: integer;
    VolumeXTop: integer;
    VolumeYLeft: integer;
    VolumeYTop: integer;
    fxLeft: integer;
    fxTop: integer;
    fx1Left: integer;
    fx1Top: integer;
    fx2Left: integer;
    fX2Top: integer;
    PrintLeft: integer;
    PrintTop: integer;
    PrintScale: double;
    PrintBorderColor: integer;
    PrintBorderWidth: integer;
    PrintUnit: integer;
    BitmapLeft: integer;
    BitmapTop: integer;
    BitmapScale: double;
    BitmapBorderColor: integer;
    BitmapBorderWidth: integer;
    BitmapUnit: integer;
    StyleLeft: integer;
    StyleTop: integer;
  end;

var
  GraphData: TGraphData;
  Altered: Boolean;   // any alteration to the plot
  LabelRect: TRect;
  BinPath: TFileName;
///  PlotPath: TFileName;  // now the same as for Plot1d.dproj
  DataPath: TFileName;
  ImagePath: TFileName;
  GraphFName: TFileName;
  StyleFName: TFileName;
  LayoutFName: TFileName;

// Miscellaneous Parameters
  PhiIncMin: single = 0.00001;
  xEvaluate: extended = 0;
  yEvaluate: extended = 0;
  yCosxEval: extended = 0;
  ySinxEval: extended = 0;

  IntegCountMax: integer = 256000;
  IntegMin: extended;
  IntegMax: extended;
  KeptMin: extended;
  KeptMax: extended;
  KeepRange: Boolean;
  IntegConst: extended;
  IntegCountPos: integer;

  PrinterInfo: TPrinterInfo;
  Layout: TLayout;

  procedure GetPrinterInfo(var Info: TPrinterInfo);
  procedure SetPrinterInfo(const Info: TPrinterInfo);
  function GetPaperType: string;

//========================================================================
implementation
//========================================================================

constructor TPlotDataObject.Create(D: TPlotData);
begin
  inherited Create;
  Data := D;
end;

destructor TPlotDataObject.Destroy;
begin
  inherited Destroy;
end;

constructor TGraphPointObject.Create(vx_phi, vy_r: extended);
begin
  inherited Create;
  x_phi := vx_phi;
  y_r := vy_r;
end;

destructor TGraphPointObject.Destroy;
begin
  inherited Destroy;
end;

constructor TGraphLineObject.Create(vx, vy: extended);
begin
  inherited Create;
  with GraphLine do
  begin
    x := vx;
    y1 := vy;
  end;
end;

destructor TGraphLineObject.Destroy;
begin
  inherited Destroy;
end;

constructor TPlotStyleObject.Create(S: TPlotStyle);
begin
  inherited Create;
  Style := S;
end;

destructor TPlotStyleObject.Destroy;
begin
  inherited Destroy;
end;

constructor TFoundPointObject.Create(x, m, y: extended; c, mc: TColor);
begin
  inherited Create;
  xValue := x;
  mValue := m;
  yValue := y;
  Color := c;
  mColor := mc;
end;

destructor TFoundPointObject.Destroy;
begin
  inherited Destroy;
end;

constructor TTextLineObject.Create(T: string; C: TColor);
begin
  inherited Create;
  Text := T;
  Color := C;
end;

destructor TTextLineObject.Destroy;
begin
  inherited Destroy;
end;

constructor TTextDataObject.Create(D: TTextData);
begin
  inherited Create;
  Data := D;
  TextLines := TList.Create;
end;

destructor TTextDataObject.Destroy;
  var
    i: integer;

begin
  for i := 0 to TextLines.Count -1 do TTextLineObject(TextLines.Items[i]).Free;
  TextLines.Free;
  inherited Destroy;
end;

constructor TNumericObject.Create(D: TNumericData);
begin
  inherited Create;
  Data := D;
  ControlPoints := TList.Create;
end;

destructor TNumericObject.Destroy;
  var
    i: integer;

begin
  for i := 0 to ControlPoints.Count -1 do TObject(ControlPoints.Items[i]).Free;
  ControlPoints.Free;
  inherited Destroy;
end;

procedure GetPrinterInfo(var Info: TPrinterInfo);
var
  Device: array [0..255] of char;
  Driver: array [0..255] of char;
  Port: array [0..255] of char;
  hDMode: THandle;
  pDMode: PDevMode;

begin
  Printer.GetPrinter(Device, Driver, Port, hDMode);
  if hDMode <> 0 then
  begin
    pDMode := GlobalLock(hDMode);
    if pDMode <> nil then
    begin
      with Info do PaperID := pDMode.dmPaperSize;  // default = DMPAPER_A4
      GlobalUnlock(hDMode);
      with Info do
      begin
        Index := Printer.PrinterIndex;
        xPixPerInch := GetDeviceCaps(Printer.Handle, LOGPIXELSX);
        yPixPerInch := GetDeviceCaps(Printer.Handle, LOGPIXELSY);
        xOffset := GetDeviceCaps(Printer.Handle, PHYSICALOFFSETX);
        yOffset := GetDeviceCaps(Printer.Handle, PHYSICALOFFSETY);
        xRes := GetDeviceCaps(Printer.Handle, HORZRES);
        yRes := GetDeviceCaps(Printer.Handle, VERTRES);
        Orientation := Printer.Orientation;
      end;
    end;
  end;
end;

procedure SetPrinterInfo(const Info: TPrinterInfo);
var
  Device: array [0..255] of char;
  Driver: array [0..255] of char;
  Port: array [0..255] of char;
  hDMode: THandle;
  pDMode: PDevMode;

begin
  Printer.GetPrinter(Device, Driver, Port, hDMode);
  if (PrinterInfo.Index < -1) or
     (PrinterInfo.Index > Printer.Printers.Count -1)
  then PrinterInfo.Index := -1;

  Printer.PrinterIndex := PrinterInfo.Index;
  Printer.Orientation := PrinterInfo.Orientation;
  if hDMode <> 0 then
  begin
    pDMode := GlobalLock(hDMode);
    if pDMode <> nil then
    begin
      pDMode.dmPaperSize := PrinterInfo.PaperID;    { default = DMPAPER_A4 }
      pDMode^.dmFields := pDMode^.dmFields or DM_PAPERSIZE;
      pDMode^.dmFields := pDMode^.dmFields or DM_ORIENTATION;
      pDMode^.dmFields := pDMode^.dmFields or DM_DEFAULTSOURCE;
      GlobalUnlock(hDMode);
    end;
  end;
end;

function GetPaperType: string;
var
  s: string;
begin
  case PrinterInfo.PaperID of
DMPAPER_LETTER:      s := 'Letter, 8½" x 11"';
DMPAPER_LEGAL:       s := 'Legal, 8½" x 14"';
DMPAPER_A4:          s := 'A4, 210mm x 297mm';
DMPAPER_CSHEET:      s := 'C, 17" x 22"';
DMPAPER_DSHEET:      s := 'D, 22" x 34"';
DMPAPER_ESHEET:      s := 'E, 34" x 44"';
DMPAPER_LETTERSMALL: s := 'Letter, 8½" x 11"';
DMPAPER_TABLOID:     s := 'Tabloid, 11" x 17"';
DMPAPER_LEDGER:      s := 'Ledger, 17" x 11"';
DMPAPER_STATEMENT:   s := 'Statement, 5½" x 8½"';
DMPAPER_EXECUTIVE:   s := 'Executive, 7¼" x 10½"';
DMPAPER_A3:          s := 'A3, 297mm x 420mm';
DMPAPER_A4SMALL:     s := 'A4, 210mm x 297mm';
DMPAPER_A5:          s := 'A5, 148mm x 210mm';
DMPAPER_B4:          s := 'B4, 250mm x 354mm';
DMPAPER_B5:          s := 'B5, 182mm x 257mm';
DMPAPER_FOLIO:       s := 'Folio, 8½" x 13"';
DMPAPER_QUARTO:      s := 'Quarto, 215mm x 275mm';
DMPAPER_10X14:       s := 'Sheet, 10" x 14"';
DMPAPER_11X17:       s := 'Sheet, 11" x 17"';
DMPAPER_NOTE:        s := 'Note, 8½" x 11"';
DMPAPER_ENV_9:       s := 'Envelope 3 7/8" x 8 7/8"';
DMPAPER_ENV_10:      s := 'Envelope 4 1/8" x 9½"';
DMPAPER_ENV_11:      s := 'Envelope 4½" x 10 3/8"';
DMPAPER_ENV_12:      s := 'Envelope 4¾" x 11"';
DMPAPER_ENV_14:      s := 'Envelope 5" x 11½"';
DMPAPER_ENV_DL:      s := 'Envelope 110mm x 220mm';
DMPAPER_ENV_C5:      s := 'Envelope 162mm x 229mm';
DMPAPER_ENV_C3:      s := 'Envelope 324mm x 458mm';
DMPAPER_ENV_C4:      s := 'Envelope 229mm x 324mm';
DMPAPER_ENV_C6:      s := 'Envelope 114mm x 162mm';
DMPAPER_ENV_C65:     s := 'Envelope 114mm x 229mm';
DMPAPER_ENV_B4:      s := 'Envelope 250mm x 353mm';
DMPAPER_ENV_B5:      s := 'Envelope 176mm x 250mm';
DMPAPER_ENV_B6:      s := 'Envelope 176mm x 125mm';
DMPAPER_ENV_ITALY:   s := 'Envelope 110mm x 230mm';
DMPAPER_ENV_MONARCH: s := 'Envelope 3 7/8" x 7½"';
DMPAPER_ENV_PERSONAL:s := 'Envelope 3 5/8" x 6½"';
DMPAPER_FANFOLD_US:  s := 'Fanfold, 14 7/8" x 11"';
DMPAPER_FANFOLD_STD_GERMAN:s := 'Fanfold, 8½" x 12"';
DMPAPER_FANFOLD_LGL_GERMAN:s := 'Fanfold, 8½" x 13"';
260: s := '8" x 6"';
262: s := 'Fanfold, 210mm x 12"';
else s := 'Custom ';
  end;
  Result := s;
end;

end.
