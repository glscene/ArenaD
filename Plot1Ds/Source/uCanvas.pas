unit uCanvas;

interface

uses
  Winapi.OpenGL,
  System.Types,
  System.Classes,
  System.SysUtils,
  System.Math,
  Vcl.Dialogs,
  Vcl.Graphics,

  GLS.OpenGLTokens,
  GLS.Context,
  GLS.VectorTypes,
  GLS.Canvas,
  GLS.VectorGeometry,
  GLS.Color,
  
  GLS.State,
  GLS.RenderContextInfo,
  GLS.WindowsFont,

  uGlobal,
  uParser,
  fPrint,
  fFuncts;

type
  TTextLocObject = class(TObject)
    constructor Create(x, y: integer; c: TColor; T: string);
    destructor Destroy; override;
  private
  public
    TextString: string;
    TextColor: integer;
    xLoc: integer;
    yLoc: integer;
  end;

  TfxCanvas = class(TGLCanvas)
  private
     
    CharW, CharH: integer;  { GLWinBitFont width and height  }
    dxGrad, dyGrad: extended;
    dx10Grad, dy10Grad: extended;
    IntegXMax, IntegXMin: extended;
    IntegYMax, IntegYMin: extended;
    xDigits, yDigits: integer;
    PlotList: TList;        { used to hold function TGraphPointObjects }
    yfx1List: TList;        { used to hold y = f'(x) TGraphPointObjects }
    yfx2List: TList;        { used to hold y = f"(x) TGraphPointObjects }
    IntegList: TList;       { used to hold Integral TGraphPointObjects }
    SectorList: TList;      { used to hold polar Integral sectors }
    FxParser: TFxParser;
    function FormatValue(const n: integer; const v, dv: extended): string;
    function CoordX(x: extended): integer;
    function CoordY(y: extended): integer;
    function CoordLogX(x: extended): integer;
    function CoordLogY(y: extended): integer;
    function EvaluateFunction(const x: extended): extended;
    function ValueX(const x: integer): extended;
    function ValueLogX(const x: integer): extended;
    procedure AddXAxisText(x: extended;
              xCoord, yCoord, halfWd: integer; atTop: Boolean);
    procedure AddYAxisText(y: extended;
              xCoord, yCoord, halfWd: integer; atRight: Boolean);
    procedure DrawXGridLinear;
    procedure DrawYGridLinear;
    procedure DrawXGridLog;
    procedure DrawYGridLog;
    procedure DrawPolarGrid;
    procedure DrawXAxisLinear;
    procedure DrawYAxisLinear;
    procedure DrawXAxisLog;
    procedure DrawYAxisLog;
    procedure PlotFunction(Selected: Boolean);
    procedure PlotAsCartesian(Selected: Boolean);
    procedure PlotAsPolar(Selected: Boolean);
    procedure PopulateCartesian(var L: TList);
    procedure PopulateCartesianLogX(var L: TList);
    procedure PopulateCartesianLogY(var L: TList);
    procedure PopulateCartesianLogXY(var L: TList);
    procedure PopulatePolar(var L: TList);
    procedure PopulateDerivCartesian(var Ls, L: TList);
    procedure PopulateDerivPolar(var Ls, L: TList);
    procedure NoNumberCartesian(var L: Tlist; const P, C: TGraphPoint; const i: integer);
    procedure NoNumberDerivCartesian(var L: Tlist; const P, C: TGraphPoint; const i: integer);
    procedure NoNumberPolar(var L: Tlist; var P, C: TGraphPoint; const i: integer);
    procedure InfinityCartesian(var L: Tlist; var P, C: TGraphPoint; const i: integer);
    procedure InfinityPolar(var L: Tlist; var P, C: TGraphPoint; const i: integer);
    function LineIsValid(var P, C: TGraphPoint): Boolean;
    procedure AnalyseCartesian(var L: TList);
    procedure AnalyseDerivCartesian(var L: TList);
    procedure AnalysePolar(var L: TList);
    procedure DrawCartesian(var L: TList);
    procedure DrawPolar(var L: TList);
    procedure Draw_yfx1(var L: Tlist);
    procedure Draw_yfx2(Var L: TList);
    procedure IntegrateCartesian;
    procedure IntegratePolar;
    procedure IntegrateYCartesian;
    procedure IntegrateBetweenFunctions;
    procedure IntegrateVolumeX;
    procedure IntegrateVolumeY;
    procedure FindfxValues(const y: extended);
    procedure DrawfxPoints;
    procedure Findfx1Values(const dy: extended);
    procedure Drawfx1Points;
    procedure Findfx2Values(const d2y: extended);
    procedure Drawfx2Points;
    procedure DrawCartesianCoordinates;
    procedure DrawPolarCoordinates;
    procedure ClearTextList;
    procedure ClearPointList(var L: TList);
    function SumSegments(var aNeg, aPos: extended): extended;
    function SumYSegments(var aNeg, aPos: extended): extended;
  protected
    procedure QuadVertices(x, y, xRadius, yRadius: Single;
                           q1, q2, q3, q4: Boolean);
  public
    TextList: TList;
    constructor Create(bufferSizeX, bufferSizeY: Integer); overload;
    destructor Destroy; override;
  { Draws a filled ellipse with (x1,y1)-(x2, y2) bounding rectangle }
    procedure FillEllipseBB(const x1, y1, x2, y2: Integer); overload;
    procedure FillEllipseBB(const x1, y1, x2, y2: Single); overload;
    procedure FillQuadrants(const x, y: Integer;
                            const xRadius, yRadius: Single;
                                  q1, q2, q3, q4: Boolean);
    procedure FillQuadrantsBB(const x1, y1, x2, y2: Integer;
                                    q1, q2, q3, q4: Boolean);
    procedure StartRadialFill(const x, y: Integer);
    procedure FillSector(x, y: Integer);
    procedure StopRadialFill;
    procedure SetupFont(var rci: TGLRenderContextInfo;
                        var wbf: TGLWindowsBitmapFont);
    procedure SetGLWinBitFont(var rci: TGLRenderContextInfo;
                              var wbf: TGLWindowsBitmapFont;
                  Nm: string; Sz: integer; St: TFontStyles);
    procedure AddFunctionLabelsText;
    procedure xAxisGradsCalc(var wbf: TGLWindowsBitmapFont);
    procedure yAxisGradsCalc(var wbf: TGLWindowsBitmapFont);
    procedure DrawAxes;
    procedure DrawTextList(var rci: TGLRenderContextInfo; L: TList;
                           var wbf: TGLWindowsBitmapFont);
    procedure DrawFunctions;
    procedure DrawNumericData;
    procedure DrawTextBlocks(var rci: TGLRenderContextInfo;
                             var wbf: TGLWindowsBitmapFont);
  end;

//======================================================================
implementation
//======================================================================

uses
  fMain,
  fNumeric,
  fTextBlocks,
  fIntegrateX,
  fIntegrateY,
  fBetween,
  fVolumeX,
  fVolumeY,
  fBitmap,
  fxValue,
  fx1Value,
  fx2Value;

constructor TTextLocObject.Create(x, y: integer; c: TColor; T: string);
begin
  inherited Create;
  xLoc := x;
  yLoc := y;
  TextColor := c;
  TextString := T;
end;

destructor TTextLocObject.Destroy;
begin
  inherited Destroy;
end;

constructor TfxCanvas.Create(bufferSizeX, bufferSizeY: Integer);
begin                                        inherited;
  TextList := TList.Create;
  PlotList := TList.Create;
  FxParser := TFxParser.Create(0);
end;

destructor TfxCanvas.Destroy;
begin
  ClearTextList;
  ClearPointList(Plotlist);

  with FxParser do
  begin
    Calculus.Free;
    Calculus := nil;
    Free;
  end;
  inherited;
end;

function TfxCanvas.FormatValue(const n: integer; const v, dv: Extended): string;
var
  s: string;
  d: integer;

begin
  d := 1;
  if n > 3 then  { decide which format to use }
  begin
    Result := FloatToStrF(v, ffExponent, d, 1);
    s := FloatToStrF(v + dv, ffExponent, d, 1);

    while Result = s do
    begin
      Inc(d);
      Result := FloatToStrF(v, ffExponent, d, 1);
      s := FloatToStrF(v + dv, ffExponent, d, 1);
    end;
    Dec(d);

    Result := FloatToStrF(v, ffExponent, d, 1);
  end
  else Result := FloatToStrF(v, ffGeneral, 6, n);
end;

{ linear X coordinate }
function TfxCanvas.CoordX(x: extended): integer;
begin
  with GraphData do
  Result := round(CanvasSizeX*(x - xMin)/(xMax - xMin));
end;

{ linear Y coordinate }
function TfxCanvas.CoordY(y: extended): integer;
begin
  with GraphData do
  Result := CanvasSizeY - round(CanvasSizeY*(y - yMin)/(yMax - yMin));
end;

{ log X coordinate }
function TfxCanvas.CoordLogX(x: Extended): integer;
begin
  with GraphData do
  Result := round(CanvasSizeX*(Log10(x)-Log10(xMin))/(Log10(xMax)-Log10(xMin)));
end;

{ log Y coordinate }
function TfxCanvas.CoordLogY(y: Extended): integer;
begin
  with GraphData do
  Result := CanvasSizeY -
            round(CanvasSizeY*(Log10(y)-Log10(yMin))/(Log10(yMax)-Log10(yMin)));
end;

function TfxCanvas.EvaluateFunction(const x: extended): extended;
begin
  with FxParser do
  if Assigned(Calculus) then
  try
    VarX.Value := x;
    Result := Calculus.Eval;
  except
    Result := NaN;
  end
  else Result := 0;
end;

function TfxCanvas.ValueX(const x: integer): extended;
begin
  with GraphData do Result := xMin + x*(xMax - xMin)/CanvasSizeX;
end;

function TfxCanvas.ValueLogX(const x: integer): extended;
var
  LogMin, a: extended;

begin
  with GraphData do
  begin
    LogMin := Log10(xMin);
    a := LogMin + x*(Log10(xMax) - LogMin)/CanvasSizeX;
  end;
  Result := Power(10, a);
end;

procedure TfxCanvas.AddXAxisText(x: extended;
                     xCoord, yCoord, halfWd: integer; atTop: Boolean);
var
  s: string;

begin
  s := FormatValue(xDigits, x, dxGrad );

  with GraphData do
  begin
    if Grid.GridStyle = gsCartesian then  { Cartesian grid drawn }
    begin
      if atTop
      then TextList.Add(TTextLocObject.Create(
                        xCoord + 2*CharW div 3 + halfWd,
                        8 + AxisWidth, xAxisColor, s))
      else TextList.Add(TTextLocObject.Create(
                        xCoord + 2*CharW div 3 + halfWd,
                        yCoord - 8 - CharH - AxisWidth ,xAxisColor, s));
    end
    else
    begin
      if atTop
      then TextList.Add(TTextLocObject.Create(
                        xCoord - CharW div 3,
                        15 + halfWd, xAxisColor, s))
      else TextList.Add(TTextLocObject.Create(
                        xCoord - CharW div 3,
                        yCoord - 15 - CharH - halfWd, xAxisColor, s));
    end;
  end;
end;

procedure TfxCanvas.AddYAxisText(y: extended;
                   xCoord, yCoord, halfWd: integer; atRight: Boolean);
var
  s: string;


begin
  s := FormatValue(yDigits, y, dyGrad);

  with GraphData do
  begin
    if Grid.GridStyle = gsCartesian then  { Cartesian grid drawn }
    begin
      if atRight
      then TextList.Add(TTextLocObject.Create(
           CanvasSizeX - Length(s)*CharW - AxisWidth - 5,
           yCoord - 3*CharH div 2 - halfWd, yAxisColor, s)) { at right }
      else TextList.Add(TTextLocObject.Create(xCoord + 2*CharW + halfWd,
           yCoord - 3*CharH div 2 - halfWd, yAxisColor, s));
    end
    else
    begin
      if atRight
      then TextList.Add(TTextLocObject.Create(
           CanvasSizeX - Length(s)*CharW - AxisWidth - 15,
           yCoord - 7*CharH div 8, yAxisColor, s))           { at right }
      else TextList.Add(TTextLocObject.Create(xCoord + halfWd + 25,
           yCoord - 7*CharH div 8, yAxisColor, s));
    end;
  end;
end;

procedure TfxCanvas.AddFunctionLabelsText;
var
  i: integer;
  x, y: integer;
  LabelStr: string;

begin
  with FunctionsForm.CheckListBox do
  begin
    for i := 0 to Items.Count -1 do if Checked[i] then
    begin
      with GraphData do
      begin
        PlotData := TPlotDataObject(Items.Objects[i]).Data;
        if Plotdata.ShowLabel and
          (PlotData.xLabel > xMin) and (PlotData.xLabel < xMax) and
          (PlotData.yLabel > yMin) and (PlotData.yLabel < yMax) then
        begin
          if PlotData.TextStr = '' then LabelStr := ''
          else if PlotData.PlotAsFx
          then LabelStr := 'y = '+PlotData.TextStr
          else LabelStr := 'r = '+PlotData.TextStr;

          if Grid.xAxisStyle = asLog
          then x := CoordLogX(PlotData.xLabel)
          else x := CoordX(PlotData.xLabel);

          if Grid.yAxisStyle = asLog
          then y := CoordLogY(PlotData.yLabel)
          else y := CoordY(PlotData.yLabel);

          TextList.Add(TTextLocObject.Create(x, y,
                       PlotData.PlotColor, LabelStr));
        end;
      end;
    end;
    GraphData.PlotData := TPlotDataObject(Items.Objects[ItemIndex]).Data;
  end;
end;

procedure TfxCanvas.DrawXGridLinear;
var
  xO, xCoord, c: integer;
  atRight: Boolean;
  x: extended;
  yMinCoord, yMaxCoord: integer;

begin
  with GraphData do
  begin
    yMinCoord := CoordY(yMin);
    yMaxCoord := CoordY(yMax);

    xO := CoordX(0);                       { x origin, i.e. y axis }
    atRight := (xO >= CanvasSizeX - 6*CharW - AxisWidth div 2);

    x := trunc(xMin/dx10Grad)*dx10Grad;
    c := round((xMin - x)/dxGrad);
    x := x + c*dxGrad;

    if c < 0 then Inc(c, 10);

    while x < xMax do
    begin
      if c mod 10 = 0 then
      begin
        PenColor := xAxisColor;
        PenWidth := MajorWidth;
      end
      else
      begin
        PenColor := GridColor;
        PenWidth := MinorWidth;
      end;

      xCoord := CoordX(x);

      if (abs(xCoord - xO) > 2) or atRight then
      begin
        MoveTo(xCoord, yMinCoord);
        LineTo(xCoord, yMaxCoord);
      end;

      x := x + dxGrad;
      Inc(c);
    end;
  end;
end;

procedure TfxCanvas.DrawYGridLinear;
var
  yO, yCoord, c: integer;
  atTop: Boolean;
  y: extended;
  xMinCoord, xMaxCoord: integer;

begin
  with GraphData do
  begin
    xMinCoord := CoordX(xMin);
    xMaxCoord := CoordX(xMax);

    yO := CoordY(0);                       { y origin, i.e. x axis }
    atTop := (yO <= 2*CharH + AxisWidth);

    y := trunc(yMin/dy10Grad)*dy10Grad;
    c := round((yMin - y)/dyGrad);
    y := y + c*dyGrad;

    if c < 0 then Inc(c, 10);

    while y < yMax do
    begin
      if c mod 10 = 0 then
      begin
        PenColor := yAxisColor;
        PenWidth := MajorWidth;
      end
      else
      begin
        PenColor := GridColor;
        PenWidth := MinorWidth;
      end;

      yCoord := CoordY(y);

      if (abs(yCoord - yO) > 2) or atTop then
      begin
        MoveTo(xMinCoord, yCoord);
        LineTo(xMaxCoord, yCoord);
      end;

      y := y + dyGrad;
      Inc(c);
    end;
  end;
end;

procedure TfxCanvas.DrawXGridLog;
var
  xCoord, ixCoord, yMinCoord, yMaxCoord, i: integer;
  x, dx: extended;

begin
  with GraphData do
  begin
    yMinCoord := CoordY(yMin);
    yMaxCoord := CoordY(yMax);
    dx := 10*dx10Grad;
    xCoord := CoordLogX(dx);
    while xCoord > 0 do
    begin
      PenColor := xAxisColor;
      PenWidth := MajorWidth;
      MoveTo(xCoord, yMinCoord);
      LineTo(xCoord, yMaxCoord);
      x := dx;
      PenColor := GridColor;
      PenWidth := MinorWidth;
      for i := 2 to 9 do
      begin
        x := x + dx;
        if x < xMax then
        begin
          ixCoord := CoordLogX(x);
          MoveTo(ixCoord, yMinCoord);
          LineTo(ixCoord, yMaxCoord);
        end;
      end;
      dx := dx/10;
      xCoord := CoordLogX(dx);
    end;
    x := dx;
    for i := 2 to 9 do
    begin
      x := x + dx;
      if x > xMin then
      begin
        ixCoord := CoordLogX(x);
        MoveTo(ixCoord, yMinCoord);
        LineTo(ixCoord, yMaxCoord);
      end;
    end;
  end;
end;

procedure TfxCanvas.DrawYGridLog;
var
  yCoord, iyCoord, xMinCoord, xMaxCoord, i: integer;
  y, dy: extended;

begin
  with GraphData do
  begin
    xMinCoord := CoordX(xMin);
    xMaxCoord := CoordX(xMax);
    dy := 10*dy10Grad;
    yCoord := CoordLogY(dy);
    while yCoord < CanvasSizeY do
    begin
      PenColor := yAxisColor;
      PenWidth := MajorWidth;
      MoveTo(xMinCoord, yCoord);
      LineTo(xMaxCoord, yCoord);
      y := dy;
      PenColor := GridColor;
      PenWidth := MinorWidth;
      for i := 2 to 9 do
      begin
        y := y + dy;
        if y < yMax then
        begin
          iyCoord := CoordLogy(y);
          MoveTo(xMinCoord, iyCoord);
          LineTo(xMaxCoord, iyCoord);
        end;
      end;
      dy := dy/10;
      yCoord := CoordLogY(dy);
    end;
    y := dy;
    for i := 2 to 9 do
    begin
      y := y + dy;
      if y > yMin then
      begin
        iyCoord := CoordLogy(y);
        MoveTo(xMinCoord, iyCoord);
        LineTo(xMaxCoord, iyCoord);
      end;
    end;
  end;
end;

procedure TfxCanvas.DrawPolarGrid;
var
  rMax, r, dr: extended;
  dx, dy: extended;

const
  MaxR = $2000;
  dMax = $700;

begin
  with GraphData do
  begin
    PenColor := GridColor;
    PenWidth := MinorWidth;
    rMax := 0;
    dx := xMax - xMin;
    dy := yMax - yMin;

    r := Hypot(xMin, yMin);
    if r > rMax then rMax := r;

    r := Hypot(xMin, yMax);
    if r > rMax then rMax := r;

    r := Hypot(xMax, yMax);
    if r > rMax then rMax := r;

    r := Hypot(xMax, yMin);
    if r > rMax then rMax := r;
  end;

  r := trunc(rMax/dx10Grad)*dx10Grad;
  dr := dxGrad;

                { major X axis graduation lengths }
  while rMax/dr > GraphData.xMajorGrad do dr := dr*10;

  if (CoordX(abs(r)) < MaxR) and     { r & canvas width/height ratio }
     (CoordY(abs(r)) < MaxR) and     { are not too big }
     (dx/dy < dMax) and (dy/dx < dMax) then
  begin
    while r < rMax - 2*dr  do r := r + dr;
    while r > 0 do
    begin
      EllipseBB(CoordX(-r),CoordY(-r),
                CoordX(r)+1,CoordY(r)-1);
      r := r - dr;
    end;
  end
end;

procedure TfxCanvas.DrawXAxisLinear;
var
  halfWd: integer;
  xCoord, yCoord: integer;               { holds screen coordinate location }
  xO: integer;
  x: extended;
  c: integer;                                        { for graduation marks }
  dCoord: integer;
  atTop: Boolean;

begin
  with GraphData do
  begin
    halfWd := AxisWidth div 2;
    yCoord := CoordY(0);                   { coordinate for x axis }
    xO := CoordX(0);                       { x origin, i.e. y axis }
  { if GridStyle = gsPolar the xAxis may be off canvas
    otherwise it will be displayed at the top or bottom of canvas }
    if (Grid.GridStyle in [gsAxes, gsCartesian]) or
      ((yCoord > 0) and (yCoord < CanvasSizeY + halfWd)) then
    begin                             { xAxis is within canvas height range }
      PenColor := xAxisColor;
      PenWidth := AxisWidth;
      atTop := yCoord < 2*CharH + AxisWidth;

      if atTop then yCoord := halfWd                        { top of canvas }
      else if yCoord > CanvasSizeY                       { bottom of canvas }
      then yCoord := CanvasSizeY - halfWd;

      MoveTo(0, yCoord);
      LineTo(CanvasSizeX, yCoord);

      PenWidth := halfWd;

      x := trunc(xMin/dx10Grad)*dx10Grad;          { graduations for x axis }
      c := round((xMin - x)/dxGrad);
      x := x + c*dxGrad;

      if c < 0 then Inc(c, 10);
      dCoord := CoordX(x + dxGrad) - CoordX(x);

      while x < xMax do
      begin                      { calculate coordinate for each graduation }
        xCoord := CoordX(x);

        if atTop then MoveTo(xCoord, AxisWidth) else MoveTo(xCoord, yCoord);

        if c mod 5 = 0 then                { larger mark for 5th graduation }
        begin
          if abs(xCoord - xO) > 2 then     { is not y axis }
          begin
            if c mod 10 = 0 then
            begin
              if atTop then LineTo(xCoord, 16 + halfWd)
              else LineTo(xCoord, yCoord - 16 - halfWd);
              AddXAxisText(x, xCoord, yCoord, halfWd, atTop);
            end
            else
            begin
              if atTop then LineTo(xCoord, 11 + halfWd)
              else LineTo(xCoord, yCoord - 11 - halfWd);
              if (trunc(x) = x) and (dCoord >= 5*xMinorGrad)
              then AddXAxisText(x, xCoord, yCoord, halfWd, atTop);
           end;
          end;                                              { is not y axis }
        end
        else
        begin
          if atTop then LineTo(xCoord, 7 + AxisWidth)
          else LineTo(xCoord, yCoord - 6 - halfWd);
        { small graduation mark }
          if (trunc(x) = x) and (dCoord >= xMajorGrad)
          then AddXAxisText(x, xCoord, yCoord, halfWd, atTop);
        end;
        x := x + dxGrad;
        Inc(c);
      end;  { while x < xMax do... }
    end
  end;
end;

procedure TfxCanvas.DrawYAxisLinear;
var
  halfWd: integer;
  xCoord, yCoord: integer;               { holds screen coordinate location }
  yO: integer;
  y: extended;
  c: integer;                                        { for graduation marks }
  dCoord: integer;
  atRight: Boolean;

begin
  with GraphData do
  begin
    halfWd := AxisWidth div 2;
    xCoord := CoordX(0);                   { coordinate for y axis }
    yO := CoordY(0);                       { y origin, i.e. x axis }
  { if GridStyle = gsPolar the yAxis may be off canvas
    otherwise it will be displayed at the left or right of canvas }
    if (Grid.GridStyle in [gsAxes, gsCartesian]) or
      ((xCoord > 0) and (xCoord < CanvasSizeX + halfWd)) then
    begin                              { yAxis is within canvas width range }
      PenColor := yAxisColor;
      PenWidth := AxisWidth;
      atRight := xCoord > CanvasSizeX - 6*CharW - halfWd;

      if atRight then xCoord := CanvasSizeX - halfWd         { canvas right }
                 else if xCoord < 0 then xCoord := halfWd;    { canvas left }

      MoveTo(xCoord, 0);
      LineTo(xCoord, CanvasSizeY);

      PenWidth := halfWd;

      y := trunc(yMin/dy10Grad)*dy10Grad;          { graduations for y axis }
      c := round((yMin - y)/dyGrad);
      y := y + c*dyGrad;

      if c < 0 then Inc(c, 10);
      dCoord := CoordY(y) - CoordY(y + dyGrad);

      while y < yMax do
      begin                      { calculate coordinate for each graduation }
        yCoord := CoordY(y);

        if atRight then MoveTo(CanvasSizeX - AxisWidth, yCoord)
                   else MoveTo(xCoord, yCoord);

        if c mod 5 = 0 then                { larger mark for 5th graduation }
        begin
          if abs(yCoord - yO) > 2 then     { is not x axis }
          begin
            if c mod 10 = 0 then
            begin
              if atRight
              then LineTo(CanvasSizeX - 15 - halfWd, yCoord)
              else LineTo(xCoord + 15 + halfWd, yCoord);
              AddYAxisText(y, xCoord, yCoord, halfWd, atRight);
            end
            else
            begin
              if atRight
              then LineTo(CanvasSizeX - 10 - halfWd, yCoord)
              else LineTo(xCoord + 10 + halfWd, yCoord);
              if (trunc(y) = y) and (dCoord > 5*yMinorGrad)
              then AddYAxisText(y, xCoord, yCoord, halfWd, atRight);
            end;
          end;                                              { is not x axis }
        end
        else
        begin
          if atRight
          then LineTo(CanvasSizeX - 7 - AxisWidth, yCoord)
          else LineTo(xCoord + 5 + halfWd, yCoord);
        { small graduation mark }
          if (trunc(y) = y) and (dCoord >= yMajorGrad)
          then AddYAxisText(y, xCoord, yCoord, halfWd, atRight);
        end;
        y := y + dyGrad;
        Inc(c);
      end;  { while y < yMax do... }
    end;
  end;
end;

procedure TfxCanvas.DrawXAxisLog;
var
  xCoord, ixCoord, yCoord, halfWd, i: integer;
  x, dx: extended;
  s: string;
  atTop: Boolean;

begin
  with GraphData do
  begin
    halfWd := AxisWidth div 2;

    if Grid.yAxisStyle = asLog then yCoord := CanvasSizeY
    else yCoord := CoordY(0);  { coordinate for x axis if y axis not Log }

  { if GridStyle = gsPolar and yAxis is not Log the xAxis may be off canvas
    otherwise it will be displayed at the top or bottom of the canvas }
    if (Grid.GridStyle in [gsAxes, gsCartesian]) or
      ((yCoord > 0) and (yCoord < CanvasSizeY + halfWd)) then
    begin                             { xAxis is within canvas height range }
      PenColor := xAxisColor;
      PenWidth := AxisWidth;
      atTop := yCoord < 2*CharH + AxisWidth;

      if atTop then yCoord := halfWd                        { top of canvas }
      else if yCoord > CanvasSizeY                       { bottom of canvas }
      then yCoord := CanvasSizeY - halfWd;

      MoveTo(0, yCoord);
      LineTo(CanvasSizeX, yCoord);

      PenWidth := halfWd;
      dx := 10*dx10Grad;

      xCoord := CoordLogX(dx);
      while xCoord > 0 do
      begin
        MoveTo(xCoord, yCoord);
        if atTop then LineTo(xCoord, 15 + halfWd)
        else LineTo(xCoord, yCoord - 15 -HalfWd);
        x := dx;
        s := FormatValue(xDigits, x, dxGrad);
        if CoordLogX(x + 10*dx)-xCoord > Length(' '+s)*CharW then
        AddXAxisText(x, xCoord - CharW div 2, yCoord, halfWd, atTop);
        for i := 2 to 9 do
        begin
          x := x + dx;
          if x < xMax then
          begin
            ixCoord := CoordLogX(x);
            MoveTo(ixCoord, yCoord);
            if i = 5 then
            begin
              if atTop then LineTo(ixCoord, 11 + halfWd)
              else LineTo(ixCoord, yCoord - 11 -HalfWd);
            end
            else
            begin
              if atTop then LineTo(ixCoord, 7 + HalfWd)
              else LineTo(ixCoord, yCoord - 6 -HalfWd); { small graduation mark }
            end;
            s := FormatValue(xDigits, x, dxGrad);
            if CoordLogX(x + dx)-ixCoord > Length(' '+s)*CharW then
            AddXAxisText(x, ixCoord - CharW div 2, yCoord, halfWd, atTop);
          end;
        end;
        dx := dx/10;
        xCoord := CoordLogX(dx);
      end;

      x := dx;
      for i := 2 to 9 do
      begin
        x := x + dx;
        if x > xMin then
        begin
          ixCoord := CoordLogX(x);
          MoveTo(ixCoord, yCoord);
          if i = 5 then
          begin
            if atTop then LineTo(ixCoord, 11 + halfWd)
            else LineTo(ixCoord, yCoord - 11 -HalfWd);
          end
          else
          begin
            if atTop then LineTo(ixCoord, 7 + HalfWd)
            else LineTo(ixCoord, yCoord - 6 -HalfWd); { small graduation mark }
          end;
          s := FormatValue(xDigits, x, dxGrad);
          if CoordLogX(x + dx)-ixCoord > Length(' '+s)*CharW then
          AddXAxisText(x, ixCoord - CharW div 2, yCoord, halfWd, atTop);
        end;
      end;
    end;
  end;
end;

procedure TfxCanvas.DrawYAxisLog;
var
  xCoord, yCoord, iyCoord, halfWd, i: integer;
  y, dy: extended;
  atRight: Boolean;

begin
  with GraphData do
  begin
    halfWd := AxisWidth div 2;

    if Grid.xAxisStyle = asLog then xCoord := 0
    else xCoord := CoordX(0);              { coordinate for y axis }

  { if GridStyle = gsPolar and xAxis is not Log the yAxis may be off canvas
    otherwise it will be displayed at the left or right of the canvas }
    if (Grid.GridStyle in [gsAxes, gsCartesian]) or
      ((xCoord > 0) and (xCoord < CanvasSizeX + halfWd)) then
    begin                              { yAxis is within canvas width range }
      PenColor := yAxisColor;
      PenWidth := AxisWidth;
      atRight := xCoord > CanvasSizeX - 6*CharW - halfWd;

      if atRight then xCoord := CanvasSizeX - halfWd         { canvas right }
      else if xCoord < 0 then xCoord := halfWd;              { canvas left }

      MoveTo(xCoord, 0);
      LineTo(xCoord, CanvasSizeY);

      PenWidth := halfWd;
      dy := 10*dy10Grad;
      yCoord := CoordLogY(dy);

      while yCoord < CanvasSizeY do
      begin
        MoveTo(xCoord, yCoord);
        if atRight then LineTo(CanvasSizeX - 15 - halfWd, yCoord)
        else LineTo(xCoord + 15 + halfWd, yCoord);
        y := dy;
        if 3*CharH div 2 < yCoord - CoordLogY(y + 10*dy) then
        AddYAxisText(y, xCoord - CharW div 2,
                        yCoord + CharH div 3, halfWd, atRight);

        for i := 2 to 9 do
        begin
          y := y + dy;
          if y < yMax then
          begin
            iyCoord := CoordLogY(y);
            MoveTo(xCoord, iyCoord);
            if i = 5 then
            begin
              if atRight then LineTo(CanvasSizeX - 11 - halfWd, iyCoord)
              else LineTo(xCoord + 11 + halfWd, iyCoord);
            end
            else
            begin
              if atRight then LineTo(CanvasSizeX - 7 - halfWd, iyCoord)
              else LineTo(xCoord + 6 + halfWd, iyCoord); { small graduation mark }
            end;
            if 3*CharH div 2 < iyCoord - CoordLogY(y + dy) then
            AddYAxisText(y, xCoord - CharW div 2,
                           iyCoord + CharH div 3, halfWd, atRight);
          end;
        end;

        dy := dy/10;
        yCoord := CoordLogY(dy);
      end;

      y := dy;
      for i := 2 to 9 do
      begin
        y := y + dy;
        if y > yMin then
        begin
          iyCoord := CoordLogY(y);
          MoveTo(xCoord, iyCoord);
          if i = 5 then
          begin
            if atRight then LineTo(CanvasSizeX - 11 - halfWd, iyCoord)
            else LineTo(xCoord + 11 + halfWd, iyCoord);
          end
          else
          begin
            if atRight then LineTo(CanvasSizeX - 7 - halfWd, iyCoord)
            else LineTo(xCoord + 6 + halfWd, iyCoord); { small graduation mark }
          end;
          if 3*CharH div 2 < iyCoord - CoordLogY(y + dy) then
          AddYAxisText(y, xCoord - CharW div 2,
                         iyCoord + CharH div 3, halfWd, atRight);
        end;
      end;
    end;
  end;
end;

procedure TfxCanvas.PlotFunction(Selected: Boolean);
var
  LabelStr: string;

    function GetStringWidth(const s: string): integer;
    var
      i : integer;

    begin  { GetStringWidth }
      Result := 0;
      for i := 1 to Length(s)
      do Result := Result + MainForm.GLWinBitFont.GetCharWidth(Char(s[i])) +1;
    end;   { GetStringWidth }

begin
  with GraphData, PlotData, FxParser do
  begin
    if PlotAsFx then LabelStr := 'y = ' + TextStr
                else LabelStr := 'r = ' + TextStr;

    PenColor := PlotColor;
    if ShowLabel and (ErrorByte = 0) and
      (PlotData.xLabel > xMin) and (PlotData.xLabel < xMax) and
      (PlotData.yLabel > yMin) and (PlotData.yLabel < yMax) then
    begin  { display the label rectangle }
      if Selected and (BitmapForm = nil) and (PrintForm = nil) then
      begin  { display a rectangle around the label }
        PenWidth := 1;

        with LabelRect do
        begin
          Right := GetStringWidth(LabelStr+'   ');
          Bottom := round(4*MainForm.GLWinBitFont.CharHeight/3);

          if Grid.xAxisStyle = asLog
          then Left := CoordLogX(xLabel) -
                       2*MainForm.GLWinBitFont.GetCharWidth(' ')
          else Left := CoordX(xLabel) -
                       2*MainForm.GLWinBitFont.GetCharWidth(' ');

          if Grid.yAxisStyle = asLog
          then Top := CoordLogY(yLabel) -
                      round(MainForm.GLWinBitFont.CharHeight/8)
          else Top := CoordY(yLabel) -
                      round(MainForm.GLWinBitFont.CharHeight/8);

          Right := Left + Right;
          Bottom := Top + Bottom;
          RoundRect(Left, Top, Right, Bottom, 9, 9);
        end;
      end;  { if Selected... then... }
    end;  { if ShowLabel then... }

    PenWidth := PlotWidth;

    if (ErrorByte = 0) and Assigned(Calculus) then
    begin
      if PlotAsFx
      then PlotAsCartesian(Selected)
      else PlotAsPolar(Selected);
    end;
  end;
end;

procedure TfxCanvas.PlotAsCartesian(Selected: Boolean);
begin
{ evaluate y for each x & calculate plot point }
  if GraphData.Grid.xAxisStyle = asLog then
  begin
    if GraphData.Grid.yAxisStyle = asLog
    then PopulateCartesianLogXY(PlotList)
    else PopulateCartesianLogX(PlotList);
  end
  else
  if GraphData.Grid.yAxisStyle = asLog
  then PopulateCartesianLogY(PlotList)
  else PopulateCartesian(PlotList);

  AnalyseCartesian(PlotList);  { determine which lines are to be drawn }

  if Selected then with FunctionsForm do
  begin
    if Integrate2x.Checked then IntegrateCartesian else
    if Integrate2y.Checked then IntegrateYCartesian else
    if Between1.Checked then IntegrateBetweenFunctions else
    if VolumeX1.Checked then IntegrateVolumeX;
    if VolumeY1.Checked then IntegrateVolumeY;
    if fxValueForm.Visible and fxValueForm.DisplayOK
    then FindfxValues(fxValueForm.fxValueToFind);
    if fx1ValueForm.Visible and fx1ValueForm.DisplayOK
    then Findfx1Values(fx1ValueForm.fx1ValueToFind);
    if fx2ValueForm.Visible and fx2ValueForm.DisplayOK
    then Findfx2Values(fx2ValueForm.fx2ValueToFind);
  end;
{ next line hides the function used for the integrate volume }
  if not (Selected and
         (VolumeXForm.HideFunctionCheckBox.Checked or
          VolumeYForm.HideFunctionCheckBox.Checked)) then
  DrawCartesian(PlotList);     { draw the graph }

  if Selected then with FunctionsForm do
  begin
    if yfx1.Checked then  { dy/dx }
    begin
      yfx1List := TList.Create;
      try
        PopulateDerivCartesian(PlotList, yfx1List);
        AnalyseDerivCartesian(yfx1List);
        Draw_yfx1(yfx1List);
        if yfx2.Checked then  {d2y/dx2 }
        begin
          yfx2List := TList.Create;
          try
            PopulateDerivCartesian(yfx1List, yfx2List);
            AnalyseDerivCartesian(yfx2List);
            Draw_yfx2(yfx2List);
          finally
            ClearPointList(yfx2List);
          end;
        end;
      finally
        ClearPointList(yfx1List);
      end;
    end;

    if EvaluateButton.Tag = 1 then
    begin
      yEvaluate := EvaluateFunction(xEvaluate);
      ShowCartesianEvaluate;
      DrawCartesianCoordinates;
    end;
  end;
  if FunctionsForm.fxValue.Checked then DrawfxPoints;
  if FunctionsForm.fx1Value.Checked then Drawfx1Points;
  if FunctionsForm.fx2Value.Checked then Drawfx2Points;
end;

procedure TfxCanvas.PlotAsPolar(Selected: Boolean);
begin
  PopulatePolar(PlotList); { evaluate r for each phi & calculate plot point }
  AnalysePolar(PlotList);  { determine which lines are to be drawn }

  if FunctionsForm.Integrate2x.Checked and Selected then IntegratePolar;

  DrawPolar(PlotList);     { draw the graph }

  if Selected then with FunctionsForm do
  begin
    if yfx1.Checked then
    begin
      yfx1List := TList.Create;
      try
        PopulateDerivPolar(PlotList, yfx1List);
        AnalysePolar(yfx1List);
        Draw_yfx1(yfx1List);
        if yfx2.Checked then
        begin
          yfx2List := TList.Create;
          try
            PopulateDerivPolar(yfx1List, yfx2List);
            AnalysePolar(yfx2List);
            Draw_yfx2(yfx2List);
          finally
            ClearPointList(yfx2List);
          end;
        end;
      finally
        ClearPointList(yfx1List);
      end;
    end;

    if EvaluateButton.Tag = 1 then
    begin
      yEvaluate := EvaluateFunction(xEvaluate);
      ShowPolarEvaluate;
      DrawPolarCoordinates;
    end;
  end;
end;

procedure TfxCanvas.PopulateCartesian(var L: TList);
var
  i, n: integer;
  vx, vy: extended;

begin
  n := round(GraphData.PlotData.xInc);  { xInc may have decimals }
  if n < 1 then n := 1;                 { each pixel }

  i := 0;

  while i <= CanvasSizeX do
  begin
    vx := ValueX(i);
    try
      vy := EvaluateFunction(vx);
    except
      vy := NaN;
    end;

    L.Add(TGraphPointObject.Create(vx, vy));
    with TGraphPointObject(L[L.Count -1]) do
    begin
      PlotPoint.X := CoordX(vx);
      PlotPoint.Y := CoordY(vy);
      DrawLine := false;  { set all false initially }
    end;
    Inc(i, n);
  end;  { while i <= CanvasSizeX do... }
end;

procedure TfxCanvas.PopulateCartesianLogX(var L: TList);
var
  i, n: integer;
  vx, vy: extended;

begin
  i := 0;
  n := round(GraphData.PlotData.xInc);
  if n < 1 then n := 1;  { plot all points for each pixel }

  while i <= CanvasSizeX + n do
  begin
    vx := ValueLogX(i);
    try
      vy := EvaluateFunction(vx);
    except
      vy := NaN;
    end;

    L.Add(TGraphPointObject.Create(vx, vy));

    with TGraphPointObject(L[L.Count -1]) do
    begin
      PlotPoint.X := CoordLogX(vx);
      PlotPoint.Y := CoordY(vy);
      DrawLine := false;  { set all false initially }
    end;
    Inc(i, n);
  end;
end;

procedure TfxCanvas.PopulateCartesianLogY(var L: TList);
var
  i, n: integer;
  vx, vy: extended;

begin
  i := 0;
  n := round(GraphData.PlotData.xInc);
  if n < 1 then n := 1;  { plot all points for each pixel }

  while i <= CanvasSizeX + n do
  begin
    vx := ValueX(i);
    try
      vy := EvaluateFunction(vx);
    except
      vy := NaN;
    end;

    L.Add(TGraphPointObject.Create(vx, vy));

    with TGraphPointObject(L[L.Count -1]) do
    begin
      PlotPoint.X := CoordX(vx);
      with GraphData do
      begin
        if vy < yMin then PlotPoint.Y := CoordLogY(yMin) + 2 else
        if vy > yMax then PlotPoint.Y := CoordLogY(yMax) - 2
        else PlotPoint.Y := CoordLogY(vy);
      end;
      DrawLine := false;  { set all false initially }
    end;
    Inc(i, n);
  end;
end;

procedure TfxCanvas.PopulateCartesianLogXY(var L: TList);
var
  i, n: integer;
  vx, vy: extended;

begin
  i := 0;
  n := round(GraphData.PlotData.xInc);
  if n < 1 then n := 1;  { plot all points for each pixel }

  while i <= CanvasSizeX + n do
  begin
    vx := ValueLogX(i);
    try
      vy := EvaluateFunction(vx);
    except
      vy := NaN;
    end;

    L.Add(TGraphPointObject.Create(vx, vy));

    with TGraphPointObject(L[L.Count -1]) do
    begin
      PlotPoint.X := CoordLogX(vx);
      with GraphData do
      begin
        if vy < yMin then PlotPoint.Y := CoordLogY(yMin) + 2 else
        if vy > yMax then PlotPoint.Y := CoordLogY(yMax) - 2
        else PlotPoint.Y := CoordLogY(vy);
      end;
      DrawLine := false;  { set all false initially }
    end;
    Inc(i, n);
  end;
end;

procedure TfxCanvas.PopulatePolar(var L: TList);
var
  vPhi, vr: extended;

begin
  with GraphData, PlotData do
  begin
    vPhi := SegMin;

    while vPhi <= SegMax + PhiInc do
    begin
      try
        vr := EvaluateFunction(vPhi);
      except
        vr := NaN;
      end;

      L.Add(TGraphPointObject.Create(vPhi, vr));

      with TGraphPointObject(L[L.Count -1]) do
      begin
        PlotPoint.X := CoordX(vr*Cos(vPhi));
        PlotPoint.Y := CoordY(vr*Sin(vPhi));
        DrawLine := false;  { set all false initially }
      end;
      vPhi := vPhi + PhiInc;  { next step }
    end;
  end;
end;

procedure TfxCanvas.PopulateDerivCartesian(var Ls: TList; var L: TList);
var
  i: integer;
  p1, p2, p: TGraphPoint;
  m: extended;

begin
  for i := 1 to Ls.Count -2 do
  begin
    with TGraphPointObject(Ls[i -1]) do
    begin
      p1.x := x_phi;
      p1.y := y_r;
    end;

    with TGraphPointObject(Ls[i]) do
    begin
      p.x := x_phi;
      p.y := y_r;
    end;

    with TGraphPointObject(Ls[i +1]) do
    begin
      p2.x := x_phi;
      p2.y := y_r;
    end;

    m := (p2.y - p1.y)/(p2.x - p1.x);
    L.Add(TGraphPointObject.Create(p.x, m));

    with TGraphPointObject(L[L.Count -1]) do
    begin
      with GraphData, Grid do
      begin
        if xAxisStyle = asLog
        then PlotPoint.X := CoordLogX(x_phi)
        else PlotPoint.X := CoordX(x_phi);

        if yAxisStyle = asLog then
        begin
          if y_r < yMin then PlotPoint.Y := CoordLogY(yMin) + 2 else
          if y_r > yMax then PlotPoint.Y := CoordLogY(yMax) - 2
          else PlotPoint.Y := CoordLogY(y_r);
        end
        else PlotPoint.Y := CoordY(y_r);
      end;
      DrawLine := false;
    end;
  end;
end;

procedure TfxCanvas.PopulateDerivPolar(var Ls: TList; var L: TList);
var
  i: integer;
  p1, p2, p: TGraphPoint;
  m: extended;

begin
  for i := 1 to Ls.Count -2 do
  begin
    with TGraphPointObject(Ls[i -1]) do
    begin
      p1.x := x_phi;
      p1.y := y_r;
    end;

    with TGraphPointObject(Ls[i]) do
    begin
      p.x := x_phi;
      p.y := y_r;
    end;

    with TGraphPointObject(Ls[i +1]) do
    begin
      p2.x := x_phi;
      p2.y := y_r;
    end;

    m := (p2.y - p1.y)/(p2.x - p1.x);
    L.Add(TGraphPointObject.Create(p.x, m));

    with TGraphPointObject(L[L.Count -1]) do
    begin
      PlotPoint.X := CoordX(y_r*Cos(x_phi));
      PlotPoint.Y := CoordY(y_r*Sin(x_phi));
      DrawLine := false;
    end;
  end;
end;

procedure TfxCanvas.NoNumberCartesian(var L: TList; const P, C: TGraphPoint;
                                    const i: integer);
{ ChecknoNumber checks prior and current graph values for validity.
  If not valid then prior point is adjusted to a more accurate X, Y values }
const
  dpMin = 1e-9;

  function StartPoint(const n: integer): extended;
  var
    vx, vy, dx, dp: extended;

  begin
    Result := NaN;
    with TGraphPointObject(L[n]) do
    begin
      if GraphData.Grid.xAxisStyle = asLog
      then vx := ValueLogX(PlotPoint.X -1)
      else vx := ValueX(PlotPoint.X -1);
      dx := (vx - x_phi);
      dp := 1;     { one pixel }
      while dp > dpMin do
      begin
        vy := EvaluateFunction(vx);
        if isNaN(vy) then vx := vx - dx
        else
        begin
          Result := vx;
          vx := vx + dx;
        end;
        dx := dx/2;
        dp := dp/2;
      end;
    end;
  end;

  function StopPoint(const n: integer): extended;
  var
    vx, vy, dx, dp: extended;

  begin
    Result := NaN;
    with TGraphPointObject(L[n]) do
    begin
      if GraphData.Grid.xAxisStyle = asLog
      then vx := ValueLogX(PlotPoint.X -1)
      else vx := ValueX(PlotPoint.X -1);
      dx := (x_phi - vx);
      dp := 1;     { one pixel }
      while dp > dpMin do
      begin
        vy := EvaluateFunction(vx);
        if isNaN(vy) then vx := vx - dx
        else
        begin
          Result := vx;
          vx := vx + dx;
        end;
        dx := dx/2;
        dp := dp/2;
      end;
    end;
  end;

var
  sy: extended;
  b: Boolean;

begin
  if isNaN(P.y) and not isNaN(C.y) then
  begin
    sy := EvaluateFunction(StartPoint(i));
    with TGraphPointObject(L[i - 1]) do PlotPoint.Y := CoordY(sy);
    Exit;
  end;
{ in some cases this is needed to trigger the next option }
  b := (i + 2 < L.Count) and isNaN(TGraphPointObject(L[i + 2]).y_r);
  if not isNaN(P.y) and isNaN(C.y) and b then
  begin
    sy := EvaluateFunction(StopPoint(i + 1));
    with TGraphPointObject(L[i + 1]).PlotPoint do Y := CoordY(sy);
  end;
end;

procedure TfxCanvas.NoNumberDerivCartesian(var L: TList; const P, C: TGraphPoint;
                                         const i: integer);
{ ChecknoNumber checks prior and current graph values for validity.
  If not valid then prior point is adjusted to a more accurate X, Y values }
var
  delta: integer;

begin
  try
    if isNaN(P.y) and not isNaN(C.y) then
    begin
      with TGraphPointObject(L[i +1])
      do delta := C.PlotPoint.Y - PlotPoint.Y;
      with TGraphPointObject(L[i -1]).PlotPoint do
      begin
        X := C.PlotPoint.X;
        Y := C.PlotPoint.Y + delta;
      end;
      Exit;
    end;

    if not isNaN(P.y) and isNaN(C.y) then
    begin
      with TGraphPointObject(L[i -2])
      do delta := P.PlotPoint.Y - PlotPoint.Y;
      with TGraphPointObject(L[i -1]).PlotPoint do
      begin
        X := C.PlotPoint.X;
        Y := P.PlotPoint.Y + delta;
      end;
    end;
  except
  end;
end;

procedure TfxCanvas.NoNumberPolar(var L: TList; var P, C: TGraphPoint;
                                const i: Integer);
begin
  if isNaN(P.y) and not isNaN(C.y) then
  begin
    with TGraphPointObject(L[i - 1]).PlotPoint do
    begin
      X := C.PlotPoint.X;
      Y := C.PlotPoint.Y;
    end;
  end;
  if not isNaN(P.y) and isNaN(C.y) then
  begin
    with TGraphPointObject(L[i]).PlotPoint do
    begin
      X := P.PlotPoint.X;
      Y := P.PlotPoint.Y;
    end;
  end;
end;

procedure TfxCanvas.InfinityCartesian(var L: Tlist; var P, C: TGraphPoint;
                                    const i: integer);
{ CheckInfinity checks prior and current graph values for infinity.
  If one is and the other is not then the y value of the prior plot point
  needs to be adjusted either to the top or bottom of the viewer. }
begin
  if isInfinite(P.y) and not isInfinite(C.y)
  then with TGraphPointObject(L[i -1]).PlotPoint do
  begin
    case Sign(P.y) of
   -1:Y := CanvasSizeY;      { -INF: bottom }
    0:Y := C.PlotPoint.Y;    { may never happen }
    1:Y := 0;                { +INF: top }
    end;
  end;

  if not isInfinite(P.y) and isInfinite(C.y)
  then with TGraphPointObject(L[i -1]).PlotPoint do
  begin
    case Sign(C.y) of
   -1:Y := CanvasSizeY;      { -INF: bottom }
    0:Y := C.PlotPoint.Y;    { may never happen }
    1:Y := 0;                { +INF: top }
    end;
  end;
end;

procedure  TfxCanvas.InfinityPolar(var L: Tlist; var P, C: TGraphPoint;
                                 const i: integer);
begin
{ CheckInfinity checks prior and current graph values for infinity.
  If one is and the other is not then the y value of the prior
  plot point needs to be adjusted. }
  if isInfinite(P.y) and not isInfinite(C.y) then
  begin
    with TGraphPointObject(L[i -1]).PlotPoint do
    begin
      X := C.PlotPoint.X;
      Y := C.PlotPoint.Y;
    end;
  end;

  if not isInfinite(P.y) and isInfinite(C.y) then
  begin
    with TGraphPointObject(L[i]).PlotPoint do
    begin
      X := P.PlotPoint.X;
      Y := P.PlotPoint.Y;
    end;
  end;
end;

function TfxCanvas.LineIsValid(var P, C: TGraphPoint): Boolean;
begin
{ if the line is not valid it will not be drawn }
  if not GraphData.PlotData.IsContinuous then
  begin
    if isNaN(C.y) or IsInfinite(C.y) then
    begin
      Result := false;
      Exit;
    end;

    if (C.PlotPoint.Y <= 0) and (P.PlotPoint.Y >= CanvasSizeY) or
       (P.PlotPoint.Y <= 0) and (C.PlotPoint.Y >= CanvasSizeY) then
    begin
      Result := false;
      Exit;
    end;
  end;
  Result := true;
end;

procedure TfxCanvas.AnalyseCartesian(var L: TList);
var
  i: integer;
  Prior, Current: TGraphPoint;

begin
  i := 0;

  with TGraphPointObject(L[i]) do
  begin
    Prior.PlotPoint := PlotPoint;
    Prior.x := x_phi;
    Prior.y := y_r;
  end;

  Inc(i);  { start from L[1]; first point is a MoveTo not a LineTo
               i.e. DrawLine is false }
  while i < L.Count do
  begin    { integer plot points; down is greater }
    with TGraphPointObject(L[i]) do
    begin
      Current.PlotPoint := PlotPoint;
      Current.x := x_phi;
      Current.y := y_r;

      if GraphData.PlotData.IsSegment then
      begin  { plot only segment }
        with GraphData.PlotData do
        if (x_phi >= SegMin) and (x_phi <= SegMax) then
        begin
          NoNumberCartesian(L, Prior, Current, i);
          InfinityCartesian(L, Prior, Current, i);
          DrawLine := LineIsValid(Prior, Current);
        end;
      end
      else
      begin  { complete plot }
        NoNumberCartesian(L, Prior, Current, i);
        InfinityCartesian(L, Prior, Current, i);
        DrawLine := LineIsValid(Prior, Current);
      end;
    end;  { with TGraphPointObject(L[i]) do... }

    Prior := Current;  { update Prior }
    Inc(i);  { next step }
  end;  { while i < L.Count do... }
end;

procedure TfxCanvas.AnalyseDerivCartesian(var L: TList);
var
  i: integer;
  Prior, Current: TGraphPoint;

begin
  i := 0;

  with TGraphPointObject(L[i]) do
  begin
    Prior.PlotPoint := PlotPoint;
    Prior.x := x_phi;
    Prior.y := y_r;
  end;

  Inc(i);  { start from L[1]; first point is a MoveTo not a LineTo
               i.e. DrawLine is false }
  while i < L.Count do
  begin    { integer plot points; down is greater }
    with TGraphPointObject(L[i]) do
    begin
      Current.PlotPoint := PlotPoint;
      Current.x := x_phi;
      Current.y := y_r;
      if GraphData.PlotData.IsSegment then
      begin  { plot only segment }
        with GraphData.PlotData do
        if (x_phi >= SegMin) and (x_phi <= SegMax) then
        begin
          NoNumberDerivCartesian(L, Prior, Current, i);
          InfinityCartesian(L, Prior, Current, i);
          DrawLine := LineIsValid(Prior, Current);
        end;
      end
      else
      begin  { complete plot }
        NoNumberDerivCartesian(L, Prior, Current, i);
        InfinityCartesian(L, Prior, Current, i);
        DrawLine := LineIsValid(Prior, Current);
      end;
    end;  { with TGraphPointObject(L[i]) do... }

    Prior := Current;  { update Prior }
    Inc(i);  { next step }
  end;  { while i < L.Count do... }
end;

procedure TfxCanvas.AnalysePolar(var L: TList);
var
  idx: integer;
  Prior, Current: TGraphPoint;

begin
  idx := 0;

  with TGraphPointObject(L[idx]) do
  begin
    Prior.PlotPoint := PlotPoint;
    Prior.x := x_phi;
    Prior.y := y_r;
  end;

  Inc(idx);

  while idx < L.Count do
  begin
    with TGraphPointObject(L[idx]) do
    begin
      Current.PlotPoint := PlotPoint;
      Current.x := x_phi;
      Current.y := y_r;

      NoNumberPolar(L, Prior, Current, idx);
      InfinityPolar(L, Prior, Current, idx);
      DrawLine := LineIsValid(Prior, Current);
    end;
    Prior := Current;  { update Prior }
    Inc(idx);  { next step }
  end;  { while i < L.Count do... }
end;

procedure TfxCanvas.DrawCartesian(var L: TList);
var
  i: integer;
  x0: integer;

begin
  with GraphData, PlotData do
  begin
    PenWidth := PlotWidth;
    PenColor := PlotColor;
    x0 := MaxInt;
  end;

  for i := 0 to L.Count -1 do
  with TGraphPointObject(L[i]) do
  begin
    if x0 <> PlotPoint.X then
    if DrawLine then LineTo(PlotPoint.X, PlotPoint.Y)
                else MoveTo(PlotPoint.X, PlotPoint.Y);
    x0 := PlotPoint.X;
  end;
end;

procedure TfxCanvas.DrawPolar(var L: TList);
var
  i: integer;

begin
  with GraphData, PlotData do
  begin
    PenWidth := PlotWidth;
    PenColor := PlotColor;
  end;

  for i := 0 to L.Count -1 do
  with TGraphPointObject(L[i]) do
  if DrawLine then LineTo(PlotPoint.X, PlotPoint.Y)
              else MoveTo(PlotPoint.X, PlotPoint.Y);
end;

procedure TfxCanvas.Draw_yfx1(var L: TList);
var
  i: integer;
  x0: integer;

begin
  PenWidth := GraphData.dydxWidth;
  PenColor := GraphData.dydxColor;
  x0 := MaxInt;

  for i := 0 to L.Count -1 do
  with TGraphPointObject(L[i]) do
  begin
    if x0 <> PlotPoint.X then
    if DrawLine then LineTo(PlotPoint.X, PlotPoint.Y)
                else MoveTo(PlotPoint.X, PlotPoint.Y);
    x0 := PlotPoint.X;
  end;
end;

procedure TfxCanvas.Draw_yfx2(var L: TList);
var
  i: integer;
  x0: integer;

begin
  PenWidth := GraphData.d2ydx2Width;
  PenColor := GraphData.d2ydx2Color;
  x0 := MaxInt;

  for i := 0 to L.Count -1 do
  with TGraphPointObject(L[i]) do
  begin
    if x0 <> PlotPoint.X then
    if DrawLine then LineTo(PlotPoint.X, PlotPoint.Y)
                else MoveTo(PlotPoint.X, PlotPoint.Y);
    x0 := PlotPoint.X;
  end;
end;

procedure TfxCanvas.IntegrateCartesian;

  procedure SetupIntegral;
  var
    i: integer;

  begin   { SetupIntegral }
    if Assigned(IntegList) then
    for i := 0 to IntegList.Count -1 do
    with TGraphPointObject(IntegList[i]) do
    begin
      PlotPoint.X := CoordX(x_phi);
      PlotPoint.Y := CoordY(y_r);
      if i = 0 then DrawLine := false;
    end;
  end;    { SetupIntegral }

    procedure ShadeArea;
    var
      i: integer;
      yCoord: integer;

      procedure DrawShading;
      var
        yValue: extended;
        x, y: integer;

      begin
        with TGraphPointObject(IntegList[i]) do
        begin
          x := PlotPoint.X;
          yValue := EvaluateFunction(x_phi);

          PenWidth := 1;
          PenAlpha := GraphData.AreaAlpha;
          y := CoordY(yValue);

          if yValue < 0
          then PenColor := GraphData.NegAreaColor
          else PenColor := GraphData.PosAreaColor;

          Line(x, yCoord, x, y);
          PenAlpha := 1;
        end;
      end;

    begin   { ShadeArea }
      yCoord := CoordY(0);
      for i := 0 to IntegList.Count -1 do
      with TGraphPointObject(IntegList[i]) do
      if DrawLine then DrawShading;
    end;    { ShadeArea }

    procedure DrawIntegral;
    var
      i: integer;

    begin   { DrawIntegral }
      PenColor := GraphData.ydxColor;
      PenWidth := GraphData.ydxWidth;
      for i := 0 to IntegList.Count -1 do
      with TGraphPointObject(IntegList[i]) do
      if DrawLine
      then LineTo(PlotPoint.X, PlotPoint.Y)
      else MoveTo(PlotPoint.X, PlotPoint.Y);
    end;    { DrawIntegral }

        { TfxCanvas.IntegrateCartesian }
var
  SumSegs: extended;
  NegSegs: extended;
  PosSegs: extended;

begin
  IntegList := TList.Create;
  try
    NegSegs := 0;
    PosSegs := 0;
    SumSegs := SumSegments(NegSegs, PosSegs);  { Cartesian }

    with IntegrateXForm do
    begin
      if IntegCheckBox.Checked then { Plot Integral selected }
      begin
        MinIntegXLabel.Caption := 'Minimum: x = '+
        FloatToStrF(IntegXMin, ffGeneral, 12, 8);
        MinIntegYLabel.Caption := 'Minimum: y = '+
        FloatToStrF(IntegYMin, ffGeneral, 12, 8);

        MaxIntegXLabel.Caption := 'Maximum: x = '+
        FloatToStrF(IntegXMax, ffGeneral, 12, 8);
        MaxIntegYLabel.Caption := 'Maximum: y = '+
        FloatToStrF(IntegYMax, ffGeneral, 12, 8);
      end;
      AreaLabel.Caption := 'Integral P[a, b] = '+
      FloatToStrF(SumSegs, ffGeneral, 12, 8);

      NegAreaLabel.Caption := '"Negative" Area = '+
      FloatToStrF(-NegSegs, ffGeneral, 12, 8);

      PosAreaLabel.Caption := '"Positive" Area = '+
      FloatToStrF(PosSegs, ffGeneral, 12, 8);

      TotalAreaLabel.Caption := 'Total Area = '+
      FloatToStrF(PosSegs - NegSegs, ffGeneral, 12, 8);

      SumAreaLabel.Caption := 'Sum Area = '+
      FloatToStrF(SumSegs, ffGeneral, 12, 8);
    end;

    if IntegList.Count > 0 then
    begin
      SetupIntegral;
      if IntegrateXForm.PlotIntegrated and piArea = piArea then ShadeArea;
      if IntegrateXForm.PlotIntegrated and piShow = piShow then DrawIntegral;
    end;
  finally
    ClearPointList(IntegList);
    IntegList := nil;
  end;
end;    { TfxCanvas.IntegrateCartesian }

procedure TfxCanvas.IntegratePolar;
  function SumSectors(var aNeg, aPos: extended): extended;
  var
    a: extended;      { area }
    h: extended;      { step }
    phi, phi1, phi2: extended;
    i: integer;
    r, r1, r2: extended;
    m: extended;
    xCoord: integer;
    yCoord: integer;
    LastXCoord: integer;
    LastYCoord: integer;

  begin  { SumSectors }
    if KeepRange then
    begin
      IntegMin := KeptMin;
      IntegMax := KeptMax;
    end
    else with GraphData, PlotData do
    begin
      if IsSegment then
      begin
        IntegMin := SegMin;
        IntegMax := SegMax;
      end
      else if PlotAsFx then
      begin
        IntegMin := xMin;
        IntegMax := xMax;
      end;
    end;

    if IntegMax = IntegMin then
    begin
      Result := 0;
      Exit;
    end;

    if IntegMax < IntegMin then
    begin
      a := IntegMax;
      IntegMax := IntegMin;
      IntegMin := a;
      with IntegrateXForm do
      begin
        EditIntegMin.Text := FloatToStrF(IntegMin, ffGeneral, 13, 4);
        EditIntegMax.Text := FloatToStrF(IntegMax, ffGeneral, 13, 4);
      end;
    end;
    LastXCoord := MaxInt;
    LastYCoord := MaxInt;

    h := (IntegMax - IntegMin)/GraphData.IntegCount;  { calculate step }
    a := 0;  { initial area = 0 }

  { calculate numerical value to be used to display area }
    phi1 := IntegMin;
    phi2 := phi1 + h;  { h = dØ }

    for i := 1 to GraphData.IntegCount do
    begin  { calculate area using a = 0.5*r(mean)^2*dØ }
      phi := (phi1 + phi2)/2;                { mean phi }

      r1 := EvaluateFunction(phi1); { r1 = f(Ø1) }
      r2 := EvaluateFunction(phi2); { r2 = f(Ø2) }
      r := (r1 + r2)/2;             { mean r }

      if not isNaN(r) then
      begin
        m := h*sqr(r)/2;                       { area of sector }
        a := a + m;                            { add to total area }

        xCoord := CoordX(r*Cos(Phi));
        yCoord := CoordY(r*Sin(phi));

        if (LastXCoord <> xCoord) or (LastYCoord <> yCoord)
        then SectorList.Add(TGraphPointObject.Create(phi, r));

        LastXCoord := xCoord;
        LastYCoord := yCoord;

        if r < 0 then aNeg := aNeg + m else aPos := aPos + m;
      end;

      phi1 := phi2;                   { step }
      phi2 := phi2 + h;
    end;
    Result := aPos - aNeg;
  end;   { SumSectors }

  procedure SetupIntegral;
  var
    i: integer;

  begin   { SetupIntegral }
    if Assigned(IntegList) then
    for i := 0 to IntegList.Count -1 do
    with TGraphPointObject(IntegList[i]) do
    begin
      PlotPoint.X := CoordX(y_r*Cos(x_phi));
      PlotPoint.Y := CoordY(y_r*Sin(x_phi));
      if i = 0 then DrawLine := false;
    end;
  end;    { SetupIntegral }

  procedure ShadeArea;
  var
    i: integer;
    p1, p2: TPoint;
    yCoord: integer;
    xCoord: integer;
    r: extended;

    procedure DrawShading;
    begin
      with TGraphPointObject(SectorList[i]) do
      begin
        p1.x := xCoord;
        r := EvaluateFunction(x_phi);
        p2.x := CoordX(r*Cos(x_phi));

        p1.y := yCoord;
        p2.y := CoordY(r*Sin(x_Phi));
        if y_r < 0
        then PenColor := GraphData.NegAreaColor
        else PenColor := GraphData.PosAreaColor;
        FillSector(p2.x, p2.Y);
      end;
    end;    { DrawShading }

  begin   { ShadeArea }
    yCoord := CoordY(0);     { coordinate for x axis }
    xCoord := CoordX(0);     { coordinate for y axis }

    PenWidth := 1;
    PenAlpha := GraphData.AreaAlpha;
    StartRadialFill(xCoord, yCoord);

    for i := 0 to Sectorlist.Count -1 do
    with TGraphPointObject(SectorList[i]) do DrawShading;
    PenAlpha := 1;
    PenWidth := GraphData.PlotData.PlotWidth;
    StopRadialFill;
  end;    { ShadeArea }

  procedure DrawIntegral;
  var
    i: integer;

  begin   { DrawIntegral }
    if Assigned(IntegList) then
    PenColor := GraphData.ydxColor;
    PenWidth := GraphData.ydxWidth;
    for i := 0 to IntegList.Count -1 do
    with TGraphPointObject(IntegList[i]) do
    if DrawLine
    then LineTo(PlotPoint.X, PlotPoint.Y)
    else MoveTo(PlotPoint.X, PlotPoint.Y);
  end;    { DrawIntegral }

        { TfxCanvas.IntegratePolar }
var
  SumSect: extended;   { calculate sector area using a = 0.5*r(mean)^2*dØ  }
  NegSect: extended;
  PosSect: extended;

  NegSegs: extended;
  PosSegs: extended;

begin
  SectorList := TList.Create;
  NegSect := 0;
  PosSect := 0;
  SumSect := SumSectors(NegSect, PosSect);  { polar sectors }

  if IntegrateXForm.PlotIntegrated and piShow = piShow then
  begin
    IntegList := TList.Create;
    NegSegs := 0;
    PosSegs := 0;
    SumSegments(NegSegs, PosSegs);  { integral values }
  end;

  try
    with IntegrateXForm do
    begin
      if IntegCheckBox.Checked then { Plot Integral selected }
      begin
        MinIntegXLabel.Caption := 'Minimum: Ø = '+
        FloatToStrF(IntegXMin, ffGeneral, 12, 8);
        MinIntegYLabel.Caption := 'Minimum: r = '+
        FloatToStrF(IntegYMin, ffGeneral, 12, 8);

        MaxIntegXLabel.Caption := 'Maximum: Ø = '+
        FloatToStrF(IntegXMax, ffGeneral, 12, 8);
        MaxIntegYLabel.Caption := 'Maximum: r = '+
        FloatToStrF(IntegYMax, ffGeneral, 12, 8);
      end;

      AreaLabel.Caption := 'Integral P[a, b] = '+
      FloatToStrF(SumSect, ffGeneral, 12, 8);

      NegAreaLabel.Caption := '"Negative" Area = '+
      FloatToStrF(NegSect, ffGeneral, 12, 8);

      PosAreaLabel.Caption := '"Positive" Area = '+
      FloatToStrF(PosSect, ffGeneral, 12, 8);

      TotalAreaLabel.Caption := 'Total Area = '+
      FloatToStrF(PosSect + NegSect, ffGeneral, 12, 8);

      SumAreaLabel.Caption := 'Sum Area = '+
      FloatToStrF(SumSect, ffGeneral, 12, 8);
    end;

    if SectorList.Count > 0 then
    begin
      SetupIntegral;
      if IntegrateXForm.PlotIntegrated and piArea = piArea then ShadeArea;
      if IntegrateXForm.PlotIntegrated and piShow = piShow then DrawIntegral;
    end;

  finally
    ClearPointList(SectorList);
    SectorList := nil;

    ClearPointList(IntegList);
    IntegList := nil;
  end;
end;    { TfxCanvas.IntegratePolar }

procedure TfxCanvas.IntegrateYCartesian;

  procedure SetupIntegral;
  var
    i: integer;

  begin   { SetupIntegral }
    if Assigned(IntegList) then
    for i := 0 to IntegList.Count -1 do
    with TGraphPointObject(IntegList[i]) do
    begin
      PlotPoint.X := CoordX(x_phi);
      PlotPoint.Y := CoordY(y_r);
      if i = 0 then DrawLine := false;
    end;
  end;    { SetupIntegral }

  procedure ShadeArea;
  var
    i: integer;
    xCoord: integer;

    procedure DrawShading;
    var
      yValue: extended;
      x, y: integer;

    begin
      with TGraphPointObject(IntegList[i]) do
      begin
        x := PlotPoint.X;
        yValue := EvaluateFunction(x_phi);

        PenWidth := 1;
        PenAlpha := GraphData.AreaAlpha;
        y := CoordY(yValue);

        if x_Phi < 0
        then PenColor := GraphData.NegAreaColor
        else PenColor := GraphData.PosAreaColor;

        Line(x, y, xCoord, y);
        PenAlpha := 1;
      end;
    end;

  begin   { ShadeArea }
    xCoord := CoordX(0);
    for i := 0 to IntegList.Count -1 do
    with TGraphPointObject(IntegList[i]) do
    if DrawLine then DrawShading;
  end;    { ShadeArea }

        { TfxCanvas.IntegrateYCartesian }
var
  SumSegs: extended;
  NegSegs: extended;
  PosSegs: extended;
  py1, py2: extended;

begin
  IntegList := TList.Create;
  try
    NegSegs := 0;
    PosSegs := 0;
    SumSegs := SumYSegments(NegSegs, PosSegs);  { Cartesian }

    with IntegrateYForm do
    begin
      py1 := EvaluateFunction(IntegMin);
      py2 := EvaluateFunction(IntegMax);
      Label5.Caption := FloatToStrF(py1, ffFixed, 13, 4);
      Label6.Caption := FloatToStrF(py2, ffFixed, 13, 4);

      NegAreaLabel.Caption := '"Negative" Area = '+
      FloatToStrF(Abs(NegSegs), ffGeneral, 12, 8);

      PosAreaLabel.Caption := '"Positive" Area = '+
      FloatToStrF(PosSegs, ffGeneral, 12, 8);

      TotalAreaLabel.Caption := 'Total Area = '+
      FloatToStrF(PosSegs - NegSegs, ffGeneral, 12, 8);

      SumAreaLabel.Caption := 'Sum Area = '+
      FloatToStrF(SumSegs, ffGeneral, 12, 8);
    end;

    if IntegList.Count > 0 then
    begin
      SetupIntegral;
      ShadeArea;
    end;
  finally
    ClearPointList(IntegList);
    IntegList := nil;
  end;
end;

procedure TfxCanvas.IntegrateBetweenFunctions;
  procedure PopulateList;
  var
    i: integer;
    h, x, y: extended;
    p1X, p1Y: integer;

  begin
    h := (IntegMax - IntegMin)/GraphData.IntegCount;  { calculate step }
    x := IntegMin;
    for i := 0 to GraphData.IntegCount do
    begin
      y := EvaluateFunction(x);
      p1X := CoordX(x);
      p1Y := CoordY(y);

      IntegList.Add(TGraphLineObject.Create(x, y));
      TGraphLineObject(IntegList[i]).GraphLine.P1 := point(p1X, p1Y);

      x := x + h;    { next step }
    end;
  end;

  procedure AddDataToList;
  var
    i: integer;
    p1X, p2Y: integer;

  begin
    for i := 0 to IntegList.Count -1 do
    with TGraphLineObject(IntegList[i]).GraphLine do
    begin
      y2 := EvaluateFunction(x);
      p1X := P1.X;
      p2Y := CoordY(y2);
      P2 := point(p1X, p2Y);
    end;
  end;

  function SumBetweenSegs(var aNeg, aPos: extended): extended;
  var
    i: integer;
    a, dx, dy1, dy2: extended;
    gl1, gl2: TGraphLine;

  begin
    if IntegMax = IntegMin then
    begin
      Result := 0;
      Exit;
    end;

    if IntegMax < IntegMin then
    begin
      a := IntegMax;
      IntegMax := IntegMin;
      IntegMin := a;
      with IntegrateXForm do
      begin
        EditIntegMin.Text := FloatToStrF(IntegMin, ffGeneral, 13, 4);
        EditIntegMax.Text := FloatToStrF(IntegMax, ffGeneral, 13, 4);
      end;
    end;

    gl1 := TGraphLineObject(IntegList[0]).GraphLine;
    gl2 := TGraphLineObject(IntegList[1]).GraphLine;
    dx := gl2.x - gl1.x;

    for i := 1 to IntegList.Count -1 do
    begin
      gl1 := TGraphLineObject(IntegList[i -1]).GraphLine;
      gl2 := TGraphLineObject(IntegList[i]).GraphLine;

      with gl1 do dy1 := y1 - y2;
      with gl2 do dy2 := y1 - y2;

      a := dx*(dy1 + dy2)/2;
      if a > 0 then aPos := aPos + a else aNeg := aNeg - a;
    end;
    Result := aPos - aNeg;
  end;

  procedure ShadeBetweenArea;
  var
    i: integer;
    px: integer;
    gl: TGraphLine;

  begin
    px := CoordX(IntegMax);
    for i := 0 to Integlist.Count -1 do
    begin
      gl := TGraphLineObject(Integlist[i]).GraphLine;
      if gl.P1.X <> px then
      begin
        PenWidth := 1;
        PenAlpha := GraphData.AreaAlpha;

        if  gl.y1 < gl.y2
        then PenColor := GraphData.NegAreaColor
        else PenColor := GraphData.PosAreaColor;

        Line(gl.P1.X, gl.P1.Y, gl.P2.X, gl.P2.Y);
        PenAlpha := 1;
      end;

      px := gl.P1.X;
    end;
  end;

  procedure ClearAndFreeList;
  var
    i: integer;

  begin
    for i := 0 to IntegList.Count -1
    do TGraphLineObject(IntegList[i]).Free;
    IntegList.Free;
    Integlist:= nil;
  end;


var
  SumSegs: extended;
  NegSegs: extended;
  PosSegs: extended;
  py1, py2: extended;

begin
  with FunctionsForm.CheckListBox do
  if (Count < 2) or (ItemIndex > 0) then exit;
  IntegList := TList.Create;
  try
    with BetweenForm do
    begin
      py1 := EvaluateFunction(IntegMin);
      py2 := EvaluateFunction(IntegMax);
      Label5.Caption := FloatToStrF(py1, ffFixed, 13, 4);
      Label6.Caption := FloatToStrF(py2, ffFixed, 13, 4);
    end;

    PopulateList;       { setup the data of first function }

    with FunctionsForm.CheckListBox
    do GraphData.PlotData := TPlotDataObject(Items.Objects[1]).Data;
    with FxParser do
    begin
      Calculus.Free;
      with GraphData.PlotData do
      Calculus := Compile(AnsiLowerCase(FunctStr), ErrorByte);
    end;

    AddDataToList;      { add the second function's data }

    NegSegs := 0;
    PosSegs := 0;
    SumSegs := SumBetweenSegs(NegSegs, PosSegs);

    ShadeBetweenArea;
    with FunctionsForm.CheckListBox
    do GraphData.PlotData := TPlotDataObject(Items.Objects[0]).Data;

    with BetweenForm do
    begin
      NegAreaLabel.Caption := '"Negative" Area = '+
      FloatToStrF(NegSegs, ffGeneral, 12, 8);

      PosAreaLabel.Caption := '"Positive" Area = '+
      FloatToStrF(PosSegs, ffGeneral, 12, 8);

      TotalAreaLabel.Caption := 'Total Area = '+
      FloatToStrF(PosSegs + NegSegs, ffGeneral, 12, 8);

      SumAreaLabel.Caption := 'Sum Area = '+
      FloatToStrF(SumSegs, ffGeneral, 12, 8);
    end;

  finally
    ClearAndFreeList;
  end;
end;    { TfxCanvas.IntegrateBetweenFunctions }

procedure TfxCanvas.IntegrateVolumeX;

  function SumVolumeXSegments(var aVol, aSur: extended): Boolean;
  var
    h: extended;      { step }
    x: extended;
    y, y1, y2: extended;
    i, j: integer;

  begin
    Result := false;
    if IntegMax = IntegMin then Exit;

    if IntegMax < IntegMin then
    begin
      x := IntegMax;
      IntegMax := IntegMin;
      IntegMin := x;
      with VolumeXForm do
      begin
        EditIntegMin.Text := FloatToStrF(IntegMin, ffGeneral, 13, 4);
        EditIntegMax.Text := FloatToStrF(IntegMax, ffGeneral, 13, 4);
      end;
    end;

    h := (IntegMax - IntegMin)/GraphData.IntegCount;  { calculate step }

  { calculate numerical value to be used to display volume X }
    x := IntegMin;
    y1 := EvaluateFunction(x);
    x := x + h;
    j := 0;
    for i := 1 to GraphData.IntegCount do
 { calculate volume X using V = piR^2*h }
    begin
      y2 := EvaluateFunction(x);
      if not (isNaN(y1) or isNaN(y2) or isInfinite(y1) or isInfinite(y2)) then
      begin
        y := (y1 + y2)/2;
        aVol := aVol + pi*sqr(y)*h;  { volume is always positive }
        aSur := aSur + 2*pi*abs(y)*h;
      end
      else Inc(j);   { count NaN's }
      y1 := y2;      { update y1 }
      x := x + h;    { next step }
    end;  { for i := 0 to IntegCount do... }
  { if all y values are NaN then Result is false }
    Result := j < GraphData.IntegCount;
  end;   { SumVolumeXSegments }

  procedure DrawVolumeX;
  var
    yCoord: integer;
    i: integer;
    StartIndex: integer;    { StartIndex = PlotList index for plot start }
    FinishIndex: integer;   { FinishIndex = PlotList index for plot finish }
    LastXCoord: integer;
    dx: integer;
    R1, R2: TRect;

  const
    dxDiv: integer = 65;

  begin
    yCoord := 2*CoordY(0);

  { find start }
    i := 0;
    StartIndex := -1;
    LastXCoord := MaxInt;
    while (i < PlotList.Count) and (StartIndex < 0) do
    begin
      with TGraphPointObject(PlotList[i]) do
      begin
        if (x_phi >= IntegMin) and (x_phi <= IntegMax) and
            DrawLine and not(isNaN(y_r) or isInfinite(y_r)) and
           (LastXCoord <> PlotPoint.X) then
        begin
          StartIndex := i;
          dx := abs(2*PlotPoint.Y - yCoord) div dxDiv;
          R1 := Rect(PlotPoint.X - dx +1, PlotPoint.Y,
                     PlotPoint.X + dx +1, yCoord - PlotPoint.Y);
        end;
        LastXCoord := PlotPoint.X;
      end;  { with TGraphPointObject(PlotList[i]) do... }
      Inc(i);
    end;  { (i < PlotList.Count) and (StartIndex < 0)... }

  { find finish }
    i := PlotList.Count -1;
    FinishIndex := -1;
    LastXCoord := MaxInt;
    while (i > 0) and (FinishIndex < 0) do
    begin
      with TGraphPointObject(PlotList[i]) do
      begin
        if (x_phi >= IntegMin) and (x_phi <= IntegMax) and
            DrawLine and not(isNaN(y_r) or isInfinite(y_r)) and
           (LastXCoord <> PlotPoint.X) then
        begin
          FinishIndex := i;
          dx := abs(2*PlotPoint.Y - yCoord) div dxDiv;
          R2 := Rect(PlotPoint.X - dx, PlotPoint.Y,
                     PlotPoint.X + dx, yCoord - PlotPoint.Y);
        end;
        LastXCoord := PlotPoint.X;
      end;  { with TGraphPointObject(PlotList[i]) do... }
      Dec(i);
    end;  { while (i > 0) and (FinishIndex < 0)... }

  { use shade positive pen }
    PenAlpha := GraphData.AreaAlpha;
    PenWidth := 1;
    PenColor := GraphData.PosAreaColor;

    with R1 do if (Left > 0) and (Right < CanvasSizeX) then
    begin
      FillEllipseBB(Left, Top, right, Bottom);
      FillQuadrantsBB(Left, Top, Right, Bottom, false, true, true, false);
    end;

    LastXCoord := MaxInt;
  { shade the solid volume X }
    for i := StartIndex to FinishIndex do
    with TGraphPointObject(PlotList[i]) do if DrawLine then
    begin
      if LastXCoord <> PlotPoint.X then
      Line(PlotPoint.X, PlotPoint.Y, PlotPoint.X, yCoord - PlotPoint.Y);
      LastXCoord := PlotPoint.X;
    end;  { for i := StartIndex to FinishIndex do... }

    with R2 do FillQuadrantsBB(Left, Top, Right, Bottom,
                               true, false, false, true);

  { outline solid }
    PenAlpha := 1;

    with R1 do if (Left > 0) and (Right < CanvasSizeX)
    then Arc(Left, Top, Right, Bottom, 3*pion2, pion2);

  { plot the positive section of function of f(x)}
    LastXCoord := MaxInt;
    for i := StartIndex to FinishIndex do
    with TGraphPointObject(PlotList[i]) do
    begin
      if LastXCoord <> PlotPoint.X then
      begin
        if i = StartIndex
        then MoveTo(PlotPoint.X, PlotPoint.Y)
        else LineTo(PlotPoint.X, PlotPoint.Y);
      end;
      LastXCoord := PlotPoint.X;
    end;  { for i := StartIndex to FinishIndex do... }

  { plot the negative function of f(x)}
    LastXCoord := MaxInt;
    for i := StartIndex to FinishIndex do
    with TGraphPointObject(PlotList[i]) do
    begin
      if LastXCoord <> PlotPoint.X then
      begin
        if i = StartIndex
        then MoveTo(PlotPoint.X, yCoord - PlotPoint.Y)
        else LineTo(PlotPoint.X, yCoord - PlotPoint.Y);
      end;
      LastXCoord := PlotPoint.X;
    end;  { for i := StartIndex to FinishIndex do... }

    PenAlpha := GraphData.AreaAlpha;
  { use shade negative pen; shade solid's end }
    PenColor := GraphData.NegAreaColor;

    with R2 do if (Left > 0) and (Right < CanvasSizeX)
    then FillEllipseBB(Left, Top, Right, Bottom);

    PenAlpha := 1;

    with R2 do if (Left > 0) and (Right < CanvasSizeX)
    then EllipseBB(Left, Top, Right, Bottom);

  { restore plot pen width }
    PenWidth := GraphData.PlotData.PlotWidth;
    PenColor := GraphData.PlotData.PlotColor;
  end;


var
  VolSegs: extended;
  SurSegs: extended;
  py1, py2: extended;

begin
  with VolumeXForm do
  begin
    py1 := EvaluateFunction(IntegMin);
    py2 := EvaluateFunction(IntegMax);
    Label5.Caption := FloatToStrF(py1, ffFixed, 13, 4);
    Label6.Caption := FloatToStrF(py2, ffFixed, 13, 4);
  end;
  try
    VolSegs := 0;  { Cartesian }
    SurSegs := 0;
    if not SumVolumeXSegments(VolSegs, SurSegs)
    then Exit;  { SumVolumeXSegments is false there are no values to plot }

    DrawVolumeX;

    with VolumeXForm do
    begin
      TotalVolumeLabel.Caption :=
     'Total Volume = '+FloatToStrF(VolSegs, ffGeneral, 12, 8);
      SurfaceAreaLabel.Caption :=
     'Surface Area = '+FloatToStrF(SurSegs, ffGeneral, 12, 8);
    end
  except
  end;
end;

procedure TfxCanvas.IntegrateVolumeY;

  function SumVolumeYSegments(var aVol, aSur: extended): Boolean;
  var
    h: extended;      { step }
    x, x1, x2: extended;
    y1, y2: extended;
    i, j: integer;

  begin
    Result := false;
    if IntegMax = IntegMin then Exit;

    if IntegMax < IntegMin then
    begin
      x1 := IntegMax;
      IntegMax := IntegMin;
      IntegMin := x1;
      with VolumeYForm do
      begin
        EditIntegMin.Text := FloatToStrF(IntegMin, ffGeneral, 13, 4);
        EditIntegMax.Text := FloatToStrF(IntegMax, ffGeneral, 13, 4);
      end;
    end;

    h := (IntegMax - IntegMin)/GraphData.IntegCount;  { calculate step }

  { calculate numerical value to be used to display volume Y }
    x1 := IntegMin;
    y1 := EvaluateFunction(x1);
    x2 := x1 + h;
    j := 0;
    for i := 1 to GraphData.IntegCount do
 { calculate volume Y using V = piR^2*h }
    begin
      y2 := EvaluateFunction(x2);
      if not (isNaN(y1) or isNaN(y2) or isInfinite(y1) or IsInfinite(y2)) then
      begin
        x := (x1 + x2)/2;
        aVol := aVol + pi*sqr(x)*abs(y2 - y1); { volume is always positive }
        aSur := aSur + 2*pi*abs(x)*abs(y2 - y1);
      end
      else Inc(j);
      y1 := y2;        { update y1 }
      x1 := x2;
      x2 := x2 + h;    { next step }
    end;  { for i := 0 to IntegCount do... }
    Result := j < GraphData.IntegCount;
  end;   { SumVolumeYSegments }

  procedure DrawVolumeY;
  var
    xCoord: integer;
    i: integer;
    j: integer;
    StartIndex: integer;    { StartIndex = PlotList index for plot start }
    FinishIndex: integer;   { FinishIndex = PlotList index for plot finish }
    LastXCoord: integer;
    LastYCoord: integer;
    dy: integer;
    R1, R2: TRect;

  const
    dyDiv: integer = 65;

  begin
    xCoord := 2*CoordX(0);
  { find start }
    i := 0;
    StartIndex := -1;
    LastXCoord := MaxInt;
    while (i < PlotList.Count) and (StartIndex < 0) do
    begin
      with TGraphPointObject(PlotList[i]) do
      begin
        if (x_phi >= IntegMin) and (x_phi <= IntegMax) and
            DrawLine and not(isNaN(y_r) or isInfinite(y_r)) and
           (LastXCoord <> PlotPoint.X) then
        begin
          StartIndex := i - 1;
          with TGraphPointObject(PlotList[StartIndex]) do
          begin
            dy := abs(2*PlotPoint.X - xCoord) div dyDiv;
            R1 := Rect(PlotPoint.X, PlotPoint.Y - dy,
                       xCoord - PlotPoint.X, PlotPoint.Y + dy);
          end;
        end;
        LastXCoord := PlotPoint.X;
      end;  { with TGraphPointObject(PlotList[i]) do... }
      Inc(i);
    end;  { (i < PlotList.Count) and (StartIndex < 0)... }

  { find finish }
    i := PlotList.Count -2;
    FinishIndex := -1;
    LastXCoord := MaxInt;
    while (i > 0) and (FinishIndex < 0) do
    begin
      with TGraphPointObject(PlotList[i]) do
      begin
        if (x_phi >= IntegMin) and (x_phi <= IntegMax) and
            DrawLine and not(isNaN(y_r) or isInfinite(y_r)) and
           (LastXCoord <> PlotPoint.X) then
        begin
          FinishIndex := i + 1;
          with TGraphPointObject(PlotList[FinishIndex]) do
          begin
            dy := abs(2*PlotPoint.X - xCoord) div dyDiv;
            R2 := Rect(PlotPoint.X, PlotPoint.Y - dy,
                       xCoord - PlotPoint.X, PlotPoint.Y + dy);
          end;
        end;
        LastXCoord := PlotPoint.X;
      end;  { with TGraphPointObject(PlotList[i]) do... }
      Dec(i);
    end;  { while (i > 0) and (FinishIndex < 0)... }

    if StartIndex = FinishIndex then Exit;

    if TGraphPointObject(PlotList[StartIndex]).PlotPoint.Y >
       TGraphPointObject(PlotList[FinishIndex]).PlotPoint.Y then
    begin
    { use shade positive pen }
      PenAlpha := GraphData.AreaAlpha;
      PenWidth := 1;
      PenColor := GraphData.PosAreaColor;

      with R1 do
      begin
        FillEllipseBB(Left, Top, right, Bottom);
        FillQuadrantsBB(Left, Top, Right, Bottom, false, false, true, true);
      end;

      LastXCoord := MaxInt;
      LastYCoord := TGraphPointObject(PlotList[StartIndex]).PlotPoint.Y;

    { shade the solid volume Y }
      for i := StartIndex to FinishIndex do
      with TGraphPointObject(PlotList[i]) do
      begin
        if (LastXCoord <> PlotPoint.X) and (LastYCoord <> PlotPoint.Y) then
        Line(PlotPoint.X, PlotPoint.Y, xCoord - PlotPoint.X, PlotPoint.Y);
        if DrawLine then
        begin
          dy := PlotPoint.Y - LastYCoord;
          for j := 1 to abs(dy) - 1 do
          Line(PlotPoint.X + trunc(j/dy), PlotPoint.Y + j,
               xCoord - PlotPoint.X - trunc(j/dy), PlotPoint.Y + j);
        end;
        LastYCoord := PlotPoint.Y;
        LastXCoord := PlotPoint.X;
      end;  { for i := StartIndex to FinishIndex do... }

      with R2 do FillQuadrantsBB(Left, Top, Right, Bottom,
                                 true, true, false, false);
    { outline solid }
      PenAlpha := 1;

      with R1 do Arc(Left, Top, Right, Bottom, pi, 0);
      { plot the positive section of function of f(x)}
      LastXCoord := MaxInt;
      for i := StartIndex to FinishIndex do
      with TGraphPointObject(PlotList[i]) do
      begin
        if LastXCoord <> PlotPoint.X then
        begin
          if i = StartIndex
          then MoveTo(PlotPoint.X, PlotPoint.Y)
          else LineTo(PlotPoint.X, PlotPoint.Y);
        end;
        LastXCoord := PlotPoint.X;
      end;  { for i := StartIndex to FinishIndex do... }

    { plot the negative function of f(x)}
      LastXCoord := MaxInt;
      for i := StartIndex to FinishIndex do
      with TGraphPointObject(PlotList[i]) do
      begin
        if LastXCoord <> PlotPoint.X then
        begin
          if i = StartIndex
          then MoveTo(xCoord - PlotPoint.X, PlotPoint.Y)
          else LineTo(xCoord - PlotPoint.X, PlotPoint.Y);
        end;
        LastXCoord := PlotPoint.X;
      end;  { for i := StartIndex to FinishIndex do... }

      PenAlpha := GraphData.AreaAlpha;
    { use shade negative pen; shade solid's end }
      PenColor := GraphData.NegAreaColor;
      with R2 do if Right < CanvasSizeX
                 then FillEllipseBB(Left, Top, Right, Bottom);

      PenAlpha := 1;
      with R2 do EllipseBB(Left, Top, Right, Bottom);

    { restore plot pen width }
      PenWidth := GraphData.PlotData.PlotWidth;
      PenColor := GraphData.PlotData.PlotColor;
    end
    else { TGraphPointObject(PlotList[StartIndex]).PlotPoint.Y <=
           TGraphPointObject(PlotList[FinishIndex]).PlotPoint.Y  }
    begin
    { use shade positive pen }
      PenAlpha := GraphData.AreaAlpha;
      PenWidth := 1;
      PenColor := GraphData.PosAreaColor;

      with R1 do
      begin
        FillEllipseBB(Left, Top, right, Bottom);
        FillQuadrantsBB(Left, Top, Right, Bottom, true, true, false, false);
      end;

      LastXCoord := MaxInt;
      LastYCoord := TGraphPointObject(PlotList[StartIndex]).PlotPoint.Y;

    { shade the solid volume Y }
      for i := FinishIndex downto StartIndex  do
      with TGraphPointObject(PlotList[i]) do
      begin
        if (LastXCoord <> PlotPoint.X) and (LastYCoord <> PlotPoint.Y) then
        Line(PlotPoint.X, PlotPoint.Y, xCoord - PlotPoint.X, PlotPoint.Y);

        if (i < FinishIndex) and DrawLine then
        begin
          dy := PlotPoint.Y - LastYCoord;
          for j := 1 to abs(dy) -1 do
          Line(PlotPoint.X - round(j/dy), PlotPoint.Y + j,
               xCoord - PlotPoint.X + round(j/dy), PlotPoint.Y + j);
        end;
        LastYCoord := PlotPoint.Y;
        LastXCoord := PlotPoint.X;
      end;  { for i := FinishIndex downto StartIndex do... }

      with R2 do FillQuadrantsBB(Left, Top, Right, Bottom,
                                 false, false, true, true);
    { outline solid }
      PenAlpha := 1;

      with R1 do Arc(Left, Top, Right, Bottom, 0, pi);
    { plot the positive section of function of f(x)}
      LastXCoord := MaxInt;
      for i := StartIndex to FinishIndex do
      with TGraphPointObject(PlotList[i]) do
      begin
        if LastXCoord <> PlotPoint.X then
        begin
          if i = StartIndex
          then MoveTo(PlotPoint.X, PlotPoint.Y)
          else LineTo(PlotPoint.X, PlotPoint.Y);
        end;
        LastXCoord := PlotPoint.X;
      end;  { for i := StartIndex to FinishIndex do... }

    { plot the negative function of f(x)}
      LastXCoord := MaxInt;
      for i := StartIndex to FinishIndex do
      with TGraphPointObject(PlotList[i]) do
      begin
        if LastXCoord <> PlotPoint.X then
        begin
          if i = StartIndex
          then MoveTo(xCoord - PlotPoint.X, PlotPoint.Y)
          else LineTo(xCoord - PlotPoint.X, PlotPoint.Y);
        end;
        LastXCoord := PlotPoint.X;
      end;  { for i := StartIndex to FinishIndex do... }

      PenAlpha := GraphData.AreaAlpha;
    { use shade negative pen; shade solid's end }
      PenColor := GraphData.NegAreaColor;
      with R2 do if Right < CanvasSizeX
                 then FillEllipseBB(Left, Top, Right, Bottom);

      PenAlpha := 1;
      with R2 do EllipseBB(Left, Top, Right, Bottom);

    { restore plot pen width }
      PenWidth := GraphData.PlotData.PlotWidth;
      PenColor := GraphData.PlotData.PlotColor;
    end;
  end;


var
  VolSegs: extended;
  SurSegs: extended;
  py1, py2: extended;

begin
  with VolumeYForm do
  begin
    py1 := EvaluateFunction(IntegMin);
    py2 := EvaluateFunction(IntegMax);
    Label5.Caption := FloatToStrF(py1, ffFixed, 13, 4);
    Label6.Caption := FloatToStrF(py2, ffFixed, 13, 4);
  end;

  try
    VolSegs := 0;  { Cartesian }
    SurSegs := 0;
    if not SumVolumeYSegments(VolSegs, SurSegs)
    then exit;

    DrawVolumeY;

    with VolumeYForm do
    begin
      TotalVolumeLabel.Caption :=
     'Total Volume = '+FloatToStrF(VolSegs, ffGeneral, 12, 8);
      SurfaceAreaLabel.Caption :=
     'Surface Area = '+FloatToStrF(SurSegs, ffGeneral, 12, 8);
    end;
  except
  end;
end;

procedure TfxCanvas.FindfxValues(const y: extended);

  procedure Interpolate(x1, x2, y1, y2: extended);

    procedure Display;
    var
      sx, sy: string;

    begin
      x1 := (x1 + x2)/2;
      y1 := EvaluateFunction(x1);

      if x1 < 0
      then sx := ' '+Format('%g',[x1])
      else sx := '  '+Format('%g',[x1]);
      while Length(sx) < 24 do sx := sx + ' ';

      if y1 < 0
      then sy := ' '+Format('%g',[y1])
      else sy := '  '+Format('%g',[y1]);
      while Length(sy) < 24 do sy := sy + ' ';

      fxValueForm.ListBox1.AddItem(sx + '|' + sy,
      TFoundPointObject.Create(x1, 0, y1, GraphData.PlotData.PlotColor, 0));
    end;

          { Interpolate f(x) }
  const
    dpMin = 1e-30;

  var
    vx, vy: extended;
    dx, dp: extended;

  begin
    dx := (x2 - x1)/2;
    dp := 1;
    if y1 < y2 then
    begin
      while dp > dpMin do
      begin
        vx := x1 + dx;
        vy := EvaluateFunction(vx);
        if vy < y then x1 := vx
        else
        if vy > y then x2 := vx;
        dx := dx/2;
        dp := dp/2;
      end;
    end
    else
    begin
      while dp > dpMin do
      begin
        vx := x1 + dx;
        vy := EvaluateFunction(vx);
        if vy < y then x2 := vx
        else
        if vy > y then x1 := vx;
        dx := dx/2;
        dp := dp/2;
      end;
    end;
    Display;
  end;


var
  i: integer;
  y_rPrior: extended;
  cy, dy: extended;

begin
  i := 0;
  y_rPrior := TGraphPointObject(PlotList[i]).y_r;
  dy := abs(y - y_rPrior);  { difference y to find and current y }
  cy := (GraphData.yMax - GraphData.yMin)/(CanvasSizeY*1000);
  Inc(i);

  while i < PlotList.Count do
  begin
    with TGraphPointObject(PlotList[i]) do
    begin
      if not isNaN(y_r) then
      begin
        if (((y_rPrior <= y) and (y_r >= y)) or
            ((y_rPrior >= y) and (y_r <= y)) or (dy < cy))
        and not isNaN(TGraphPointObject(PlotList[i -1]).y_r)
        then Interpolate(TGraphPointObject(PlotList[i -1]).x_phi, x_phi,
                         TGraphPointObject(PlotList[i -1]).y_r, y_r);
        y_rPrior := y_r;
        dy := abs(y - y_rPrior);
      end;
      Inc(i);
    end;
  end;
end;

procedure TfxCanvas.DrawfxPoints;
var
  i: integer;
  p0, p1, p2: TPoint;

begin
  with fxValueForm.ListBox1 do for i := 0 to Count -1 do
  with TFoundPointObject(Items.Objects[i]) do
  begin
    with GraphData.Grid do
    begin
      if xAxisStyle = asLog
      then p0.X := CoordLogX(xValue)
      else p0.X := CoordX(xValue);

      if yAxisStyle = asLog
      then p0.Y := CoordLogY(yValue)
      else p0.Y := CoordY(yValue);
    end;
    p1.X := p0.X - 8;
    p1.Y := p0.Y - 7;
    p2.X := p0.X + 7;
    p2.Y := p0.Y + 8;

    PenWidth := 2;
    PenColor := Color;
    MoveTo(p1.X, p0.Y);
    LineTo(p2.X, p0.Y);
    MoveTo(p0.X, p1.Y);
    LineTo(p0.X, p2.Y);
    Ellipse(p0.X, p0.Y, 8, 8);
  end;
end;

procedure TfxCanvas.Findfx1Values(const dy: extended);
var
  px: array[1..3] of extended;       { 3 points to consider }
  py: array[1..3] of extended;       { 3 points to consider }
  dybydx: array[1..2] of extended;   { 2 intervals to consider }
  Mean: extended;

  procedure Interpolate;
    procedure Display;
    var
      sx, sy: string;

    begin
      if isNaN(px[2]) or isInfinite(px[2]) or
         isNaN(Mean) or isInfinite(Mean) then Exit;

      if px[2] < 0
      then sx := ' '+Format('%g',[px[2]])
      else sx := '  '+Format('%g',[px[2]]);
      while Length(sx) < 24 do sx := sx + ' ';

      if Mean < 0
      then sy := ' '+Format('%g',[Mean])
      else sy := '  '+Format('%g',[Mean]);
      while Length(sy) < 24 do sy := sy + ' ';

      fx1ValueForm.ListBox1.AddItem(sx + '|' + sy,
      TFoundPointObject.Create(px[2], Mean, py[2],
       GraphData.PlotData.PlotColor, GraphData.dydxColor));
    end;    { Display }

  var
    dx: extended;

    procedure MoveLeft;
    var
      j: integer;

    begin
      for j := 1 to 3 do px[j] := px[j] - dx;
    end;

    procedure MoveRight;
    var
      j: integer;

    begin
      for j := 1 to 3 do px[j] := px[j] + dx;
    end;

 { Interpolate f'(x) }

  const
    xDeltaMin = 7.88860905221012E-31;  { 1/2^100 }

  var
    xDelta: extended;
    j: integer;

  begin
    xDelta := 1/8;
    Mean := (dybydx[1] + dybydx[2])/2;
    dx := (px[2] - px[1])*xDelta;

    while xDelta > xDeltaMin do
    begin
      if Mean > dy then
      begin
        if dybydx[2] > dybydx[1] then MoveLeft else MoveRight;
      end
      else  { Mean <= dy }
      begin
        if dybydx[2] > dybydx[1] then MoveRight else MoveLeft;
      end;

      for j := 1 to 3 do py[j] := EvaluateFunction(px[j]);

      for j := 1 to 2 do dybydx[j] := (py[j +1] - py[j])/(px[j +1] - px[j]);

      Mean := (dybydx[1] + dybydx[2])/2;
      xDelta := xDelta/2;
      dx := dx/2;
    end;

    Display;
  end;


var
  i: integer;
  j: integer;

begin
  i := 1;
  while i < PlotList.Count -1 do
  begin
    for j := 1 to 3 do
    with TGraphPointObject(PlotList[i + j - 2]) do
    begin
      px[j] := x_phi;
      py[j] := y_r;
    end;

    if not(isNaN(py[1]) or isNaN(py[2]) or isNaN(py[3])) then
    begin
    { calculate dy/dx (f'x) for the 2 intervals }
      for j := 1 to 2 do dybydx[j] := (py[j +1] - py[j])/(px[j +1] - px[j]);

      if (((dybydx[1] <= dy) and (dybydx[2] >= dy)) or
          ((dybydx[1] >= dy) and (dybydx[2] <= dy)))
      then Interpolate;
    end;
    Inc(i);
  end;
end;

procedure TfxCanvas.Drawfx1Points;
var
  i: integer;
  p0, p1, p2: TPoint;

begin
  with fx1ValueForm.ListBox1 do for i := 0 to Count -1 do
  with TFoundPointObject(Items.Objects[i]) do
  begin
    with GraphData.Grid do
    begin
      if xAxisStyle = asLog
      then p0.X := CoordLogX(xValue)
      else p0.X := CoordX(xValue);

      if yAxisStyle = asLog
      then p0.Y := CoordLogY(yValue)
      else p0.Y := CoordY(yValue);
    end;
    p1.X := p0.X - 8;
    p1.Y := p0.Y - 7;
    p2.X := p0.X + 7;
    p2.Y := p0.Y + 8;

    PenWidth := 2;
    PenColor := Color;
    MoveTo(p1.X, p0.Y);
    LineTo(p2.X, p0.Y);
    MoveTo(p0.X, p1.Y);
    LineTo(p0.X, p2.Y);
    Ellipse(p0.X, p0.Y, 8, 8);

    if FunctionsForm.yfx1.Checked then
    begin
      if GraphData.Grid.yAxisStyle = asLog
      then p0.Y := CoordLogY(mValue)
      else p0.Y := CoordY(mValue);

      p1.Y := p0.Y - 7;
      p2.Y := p0.Y + 8;
      PenColor := mColor;

      MoveTo(p1.X, p0.Y);
      LineTo(p2.X, p0.Y);
      MoveTo(p0.X, p1.Y);
      LineTo(p0.X, p2.Y);
      Ellipse(p0.X, p0.Y, 8, 8);
    end;
  end;
end;

procedure TfxCanvas.Findfx2Values(const d2y: Extended);
var
  px: array[1..5] of extended;       { 5 points to consider }
  py: array[1..5] of extended;       { 5 points to consider }
  dybydx: array[1..4] of extended;   { 4 intervals to consider }
  d2ybydx2: array[1..2] of extended; { 2 intervals to consider }
  Mean: extended;

  procedure Interpolate;
  const
    xDeltaMin = 7.88860905221012E-31;  { 1/2^100 }
  var
    dx: extended;
    xDelta: extended;
    j: integer;

    procedure Display;
    var
      sx, sy: string;
    begin
      if isNaN(px[3]) or isInfinite(px[3]) or
         isNaN(Mean) or isInfinite(Mean) then Exit;
      if px[3] < 0
      then sx := ' '+Format('%g',[px[3]])
      else sx := '  '+Format('%g',[px[3]]);
      while Length(sx) < 24 do sx := sx + ' ';

      if Mean < 0
      then sy := ' '+Format('%g',[Mean])
      else sy := '  '+Format('%g',[Mean]);
      while Length(sy) < 24 do sy := sy + ' ';
      fx2ValueForm.ListBox1.AddItem(sx + '|' + sy,
      TFoundPointObject.Create(px[3], Mean, py[3],
       GraphData.PlotData.PlotColor, GraphData.d2ydx2Color));
    end;


    procedure MoveLeft;
    var
      j: integer;

    begin
      for j := 1 to 5 do px[j] := px[j] - dx;
    end;

    procedure MoveRight;
    var
      j: integer;

    begin
      for j := 1 to 5 do px[j] := px[j] + dx;
    end;


  begin
    xDelta := 1/8;
    Mean := (d2ybydx2[1] + d2ybydx2[2])/2;
    dx := (px[2] - px[1])*xDelta;

    while xDelta > xDeltaMin do
    begin
      if Mean > d2y then
      begin
        if d2ybydx2[2] > d2ybydx2[1] then MoveLeft else MoveRight;
      end
      else  { Mean <= d2y }
      begin
        if d2ybydx2[2] > d2ybydx2[1] then MoveRight else MoveLeft;
      end;

      for j := 1 to 5 do py[j] := EvaluateFunction(px[j]);

    { calculate dy/dx (f'x) for the four intervals }
      for j := 1 to 4 do
      dybydx[j] := (py[j +1] - py[j])/(px[j +1] - px[j]);
    { calculate d2y/dx² (f"x) for the two intervals  }
      for j := 1 to 2 do
      d2ybydx2[j] := (dybydx[j +1] - dybydx[j])/(px[j +1] - px[j]);

      Mean := (d2ybydx2[1] + d2ybydx2[2])/2;
      xDelta := xDelta/2;
      dx := dx/2;
    end;

    Display;
  end;

var
  i: integer;
  j: integer;

begin
  i := 2;
  while i < PlotList.Count -2 do
  begin
    for j := 1 to 5 do
    with TGraphPointObject(PlotList[i + j - 3]) do
    begin
      px[j] := x_phi;
      py[j] := y_r;
    end;

    if not(isNaN(py[1]) or isNaN(py[2]) or isNaN(py[3]) or
           isNaN(py[4]) or isNaN(py[5])) then
    begin
    { calculate dy/dx (f'x) for the four intervals }
      for j := 1 to 4 do
      dybydx[j] := (py[j +1] - py[j])/(px[j +1] - px[j]);
    { calculate d2y/dx² (f"x) for the two intervals  }
      for j := 1 to 2 do
      d2ybydx2[j] := (dybydx[j +1] - dybydx[j])/(px[j +1] - px[j]);

    { (f"x1 <= d2y and f"x2 >= d2y) or (f"x2 <= d2y and f"x1 >= d2y) }
      if (((d2ybydx2[1] <= d2y) and (d2ybydx2[2] >= d2y)) or
          ((d2ybydx2[1] >= d2y) and (d2ybydx2[2] <= d2y)))
      then Interpolate;
    end;

    Inc(i);
  end;
end;

procedure TfxCanvas.Drawfx2Points;
var
  i: integer;
  p0, p1, p2: TPoint;

begin
  with fx2ValueForm.ListBox1 do for i := 0 to Count -1 do
  with TFoundPointObject(Items.Objects[i]) do
  begin
    with GraphData.Grid do
    begin
      if xAxisStyle = asLog
      then p0.X := CoordLogX(xValue)
      else p0.X := CoordX(xValue);

      if yAxisStyle = asLog
      then p0.Y := CoordLogY(yValue)
      else p0.Y := CoordY(yValue);
    end;
    p1.X := p0.X - 8;
    p1.Y := p0.Y - 7;
    p2.X := p0.X + 7;
    p2.Y := p0.Y + 8;

    PenWidth := 2;
    PenColor := Color;
    MoveTo(p1.X, p0.Y);
    LineTo(p2.X, p0.Y);
    MoveTo(p0.X, p1.Y);
    LineTo(p0.X, p2.Y);
    Ellipse(p0.X, p0.Y, 8, 8);

    if FunctionsForm.yfx2.Checked then
    begin
      if GraphData.Grid.yAxisStyle = asLog
      then p0.Y := CoordLogY(mValue)
      else p0.Y := CoordY(mValue);
      p1.Y := p0.Y - 7;
      p2.Y := p0.Y + 8;
      PenColor := mColor;

      MoveTo(p1.X, p0.Y);
      LineTo(p2.X, p0.Y);
      MoveTo(p0.X, p1.Y);
      LineTo(p0.X, p2.Y);
      Ellipse(p0.X, p0.Y, 8, 8);
    end;
  end;
end;

procedure TfxCanvas.DrawCartesianCoordinates;
var
  x, y: integer;

begin
  PenWidth := GraphData.CoordWidth;
  PenColor := GraphData.CoordColor;

  with GraphData.Grid do
  begin
    if xAxisStyle = asLog
    then x := CoordLogX(xEvaluate)
    else x := CoordX(xEvaluate);

    if yAxisStyle = asLog
    then y := CoordLogY(yEvaluate)
    else y := CoordY(yEvaluate);
  end;

  MoveTo(x, 0);
  LineTo(x, CanvasSizeY);
  MoveTo(0, y);
  LineTo(CanvasSizeX, y);
end;

procedure TfxCanvas.DrawPolarCoordinates;
var
  x, y: integer;

begin
  PenWidth := GraphData.CoordWidth;
  PenColor := GraphData.CoordColor;

  x := CoordX(yCosxEval);
  y := CoordY(ySinxEval);
  MoveTo(CoordX(0), CoordY(0));
  LineTo(x, y);
  MoveTo(x, 0);
  LineTo(x, CanvasSizeY);
  MoveTo(0, y);
  LineTo(CanvasSizeX, y);
end;

procedure TfxCanvas.DrawNumericData;
{ Hermite }
const
  StepPts = 500;

var
  ePoints: TList;               { list of TGraphPoint }
{ Hermite }

  function sk(x: extended; n: word): extended;  {resolution factor }
  var
    nt: integer;

  begin
    Result := 1;
    for nt := 1 to n do Result := Result*x;
  end;

  function xp(k, j, i: integer): extended;
  var
    n: extended;

  begin
    n := (j +1)/StepPts;
    with NumericForm.CheckListBox do
    with TNumericObject(Items.Objects[i]) do
    Result := ((2*sk(n, 3) -
                3*sk(n, 2) +1)*TGraphPointObject(ControlPoints[k]).x_phi -
               (2*sk(n, 3) -
                3*sk(n, 2))*TGraphPointObject(ControlPoints[k +1]).x_phi +
               (sk(n, 3) -
                2*sk(n, 2) + n)*TGraphPointObject(ePoints[k]).x_phi +
               (sk(n, 3) -
                sk(n, 2))*TGraphPointObject(ePoints[k +1]).x_phi);
  end;

  function yp(k, j, i: integer): extended;
  var
    n: extended;

  begin
    n := (j +1)/StepPts;
    with NumericForm.CheckListBox do
    with TNumericObject(Items.Objects[i]) do
    Result := ((2*sk(n, 3) -
                3*sk(n, 2) +1)*TGraphPointObject(ControlPoints[k]).y_r -
               (2*sk(n, 3) -
                3*sk(n, 2))*TGraphPointObject(ControlPoints[k +1]).y_r +
               (sk(n, 3) -
                2*sk(n, 2) + n)*TGraphPointObject(ePoints[k]).y_r +
               (sk(n, 3) -
                sk(n, 2))*TGraphPointObject(ePoints[k +1]).y_r);

  end;

  procedure DrawTarget(const x, y: extended; const c: TColor);
  var
    i: integer;
    p0, p1, p2: TPoint;

  begin
    with GraphData.Grid do
    begin
      if xAxisStyle = asLog
      then p0.X := CoordLogX(x)
      else p0.X := CoordX(x);

      if yAxisStyle = asLog
      then p0.Y := CoordLogY(y)
      else p0.Y := CoordY(y);
    end;
    p1.X := p0.X - 8;
    p1.Y := p0.Y - 7;
    p2.X := p0.X + 7;
    p2.Y := p0.Y + 8;
    PenWidth := 2;
    PenColor := c;
    MoveTo(p1.X, p0.Y);
    LineTo(p2.X, p0.Y);
    MoveTo(p0.X, p1.Y);
    LineTo(p0.X, p2.Y);
    Ellipse(p0.X, p0.Y, 8, 8);
  end;

var
  FirstPoint, LastPoint: integer;
  Start, Stop, Step, vx, vy: extended;
  p, a, d: extended;
  i, j, k, w: integer;
  Ordered: Boolean;
  x_phiWas: extended;
  c: TColor;

{ Hermite }
  k0: extended;   { see CurveRate }
  ePoint: TGraphPoint;
{ Hermite }

begin   { TfxCanvas.DrawNumericData }
  with NumericForm.CheckListBox do if Count > 0 then
  begin
    for i := 0 to Count -1 do
    with TNumericObject(Items.Objects[i]) do if Checked[i] then
    begin
      if ControlPoints.Count > 0 then
      begin
        FirstPoint := 0;  { first control point index }
      { ignore negative values if Log x axis }
        if GraphData.Grid.xAxisStyle = asLog then
        while (FirstPoint < ControlPoints.Count) and
              (TGraphPointObject(ControlPoints[FirstPoint]).x_phi <= 0)
          do Inc(FirstPoint);

      { ignore negative values if Log y axis }
        if GraphData.Grid.yAxisStyle = asLog then
        while (FirstPoint < ControlPoints.Count) and
              (TGraphPointObject(ControlPoints[FirstPoint]).y_r <= 0)
        do Inc(FirstPoint);

        if FirstPoint = ControlPoints.Count then Exit;

        w := 2*Data.PointSize;
        PenColor := Data.PointColor;
        if Data.PointSize < 3 then PenWidth := 2
        else PenWidth := 2*Data.PointSize div 3 ;

        x_phiWas := -1e200;

        LastPoint := ControlPoints.Count -1;

      { points must be ordered and not repeat; Loops if first = last }
        Ordered := TGraphPointObject(ControlPoints[FirstPoint]).x_phi <>
                   TGraphPointObject(ControlPoints[LastPoint]).x_phi;
        if Data.ShowPoints then
        begin
          for j := FirstPoint to LastPoint do
          with TGraphPointObject(ControlPoints[j]) do
          begin
            if GraphData.Grid.xAxisStyle = asLog
            then PlotPoint.X := CoordLogX(x_phi)
            else
            begin
              if Data.CoordsIdx = 1
              then PlotPoint.X := CoordX(y_r*Cos(x_phi))
              else PlotPoint.X := CoordX(x_phi);
            end;

            if x_phi < x_phiWas then Ordered := False;
            x_phiWas := x_phi;

            if GraphData.Grid.yAxisStyle = asLog
            then PlotPoint.Y := CoordLogY(y_r)
            else
            begin
              if Data.CoordsIdx = 1
              then PlotPoint.Y := CoordY(y_r*Sin(x_phi))
              else PlotPoint.Y := CoordY(y_r);
            end;

            case Data.PointStyle of
            psSquare:
            begin
              MoveTo(PlotPoint.X - w, PlotPoint.Y - w);
              LineTo(PlotPoint.X + w, PlotPoint.Y - w);
              LineTo(PlotPoint.X + w, PlotPoint.Y + w);
              LineTo(PlotPoint.X - w, PlotPoint.Y + w);
              LineTo(PlotPoint.X - w, PlotPoint.Y - w);
            end;
            psPlus:
              begin
                MoveTo(PlotPoint.X, PlotPoint.Y - w);
                LineTo(PlotPoint.X, PlotPoint.Y + w +1);
                MoveTo(PlotPoint.X - w, PlotPoint.Y);
                LineTo(PlotPoint.X + w, PlotPoint.Y);
              end;
            psCross:
              begin
                MoveTo(PlotPoint.X + w, PlotPoint.Y - w);
                LineTo(PlotPoint.X - w, PlotPoint.Y + w +1);
                MoveTo(PlotPoint.X - w, PlotPoint.Y - w);
                LineTo(PlotPoint.X + w, PlotPoint.Y + w +1);
              end;
            psCircle:
                Ellipse(PlotPoint.X, PlotPoint.Y, w, w);
            end;
          end;  { with TPointObject(Points[j]) do... }

        end;

        PenColor := Data.PlotColor;
        PenWidth := Data.PlotWidth;

        ClearPointList(Plotlist);   { clear & free }
        PlotList := TList.Create;

        case Data.NumericStyle of
        nsLinear:
          begin
            with TGraphPointObject(ControlPoints[FirstPoint]) do
            begin
              if GraphData.Grid.xAxisStyle = asLog
              then PlotPoint.X := CoordLogX(x_phi)
              else
              begin
                if Data.CoordsIdx = 1
                then PlotPoint.X := CoordX(y_r*Cos(x_phi))
                else PlotPoint.X := CoordX(x_phi);
              end;

              if GraphData.Grid.yAxisStyle = asLog
              then PlotPoint.Y := CoordLogY(y_r)
              else
              begin
                if Data.CoordsIdx = 1
                then PlotPoint.Y := CoordY(y_r*Sin(x_phi))
                else PlotPoint.Y := CoordY(y_r);
              end;

              MoveTo(PlotPoint.X, PlotPoint.Y);
            end;

            for j := FirstPoint +1 to LastPoint do
            with TGraphPointObject(ControlPoints[j]) do
            begin
              if GraphData.Grid.xAxisStyle = asLog
              then PlotPoint.X := CoordLogX(x_phi)
              else
              begin
                if Data.CoordsIdx = 1
                then PlotPoint.X := CoordX(y_r*Cos(x_phi))
                else PlotPoint.X := CoordX(x_phi);
              end;

              if GraphData.Grid.yAxisStyle = asLog
              then PlotPoint.Y := CoordLogY(y_r)
              else
              begin
                if Data.CoordsIdx = 1
                then PlotPoint.Y := CoordY(y_r*Sin(x_phi))
                else PlotPoint.Y := CoordY(y_r);
              end;

              LineTo(PlotPoint.X, PlotPoint.Y);
            end
          end;  { nsLinear }

        nsLagrange: if Ordered and (Data.CoordsIdx <> 1) then
          begin
            if Data.Extrapolate then
            begin
              Start := GraphData.xMin;
              Stop := GraphData.xMax;
            end
            else
            begin
              Start := TGraphPointObject(ControlPoints[FirstPoint]).x_phi;
              Stop :=  TGraphPointObject(ControlPoints[LastPoint]).x_phi;
            end;
            j := TGraphPointObject(ControlPoints[FirstPoint]).PlotPoint.X;
            k := TGraphPointObject(ControlPoints[LastPoint]).PlotPoint.X;
            Step := (Stop - Start)/(k - j);
            vx := Start;
            while vx <= Stop + Step do
            begin
              vy := 0;
              for j := FirstPoint to LastPoint do
              begin
                p := 1;
                for k := FirstPoint to LastPoint do
                if j <> k then  { if xj = xk then xj - xk = 0 i.e. d = 0 }
                begin
                  d := TGraphPointObject(ControlPoints[j]).x_phi -
                       TGraphPointObject(ControlPoints[k]).x_phi;
                  a := (vx - TGraphPointObject(ControlPoints[k]).x_phi)/d;
                  p := p*a;
                end;
                vy := vy + p*TGraphPointObject(ControlPoints[j]).y_r;
              end;
              with PlotList do
              begin
                Add(TGraphPointObject.Create(vx, vy));
                with TGraphPointObject(Items[Count -1]) do
                begin
                  if GraphData.Grid.xAxisStyle = asLog
                  then PlotPoint.X := CoordLogX(x_phi)
                  else PlotPoint.X := CoordX(x_phi);

                  if GraphData.Grid.yAxisStyle = asLog
                  then PlotPoint.Y := CoordLogY(y_r)
                  else PlotPoint.Y := CoordY(y_r);

                  DrawLine := Count > 1;
                end;
              end;
              vx := vx + Step;
            end;

            with GraphData.PlotData do
            begin
              PlotWidth := PenWidth;
              PlotColor := PenColor;
            end;
            DrawCartesian(PlotList);     { draw the graph }
          end;

        nsHermite:

          begin
            if ((GraphData.Grid.xAxisStyle = asLog) or
               (GraphData.Grid.yAxisStyle = asLog)) and
               (FirstPoint > 0) then Exit;

            k0 := Data.CurveRate/100;
            ePoints := TList.Create;
            if ControlPoints.Count > 1 then
            begin
            { set ePoints; first two ControlPoints k - j = 1 }
              j := FirstPoint;
              k := FirstPoint +1;
              ePoint.x := (TGraphPointObject(ControlPoints[k]).x_phi -
                           TGraphPointObject(ControlPoints[j]).x_phi)*k0;
              ePoint.y := (TGraphPointObject(ControlPoints[k]).y_r -
                           TGraphPointObject(ControlPoints[j]).y_r)*k0;
              ePoints.Add(TGraphPointObject.Create(ePoint.x, ePoint.y));
            { set ePoints; mid ControlPoints j + 1 - (j - 1) = 2 }
              for j := FirstPoint +1 to LastPoint -1 do
              begin
                ePoint.x := (TGraphPointObject(ControlPoints[j +1]).x_phi -
                             TGraphPointObject(ControlPoints[j -1]).x_phi)*k0;
                ePoint.y := (TGraphPointObject(ControlPoints[j +1]).y_r -
                             TGraphPointObject(ControlPoints[j -1]).y_r)*k0;
                ePoints.Add(TGraphPointObject.Create(ePoint.x, ePoint.y));
              end;
            { set ePoints; last two ControlPoints k - j = 1 }
              j := LastPoint -1;
              k := LastPoint;
              ePoint.x := (TGraphPointObject(ControlPoints[k]).x_phi -
                           TGraphPointObject(ControlPoints[j]).x_phi)*k0;
              ePoint.y := (TGraphPointObject(ControlPoints[k]).y_r -
                           TGraphPointObject(ControlPoints[j]).y_r)*k0;
              ePoints.Add(TGraphPointObject.Create(ePoint.x, ePoint.y));
            end;

            with PlotList do  { start PlotList at first control point }
            begin
              with TGraphPointObject(ControlPoints[0]) do
              Add(TGraphPointObject.Create(x_phi, y_r));
              with TGraphPointObject(Items[Count -1]) do
              begin
                if GraphData.Grid.xAxisStyle = asLog
                then PlotPoint.X := CoordLogX(x_phi)
                else
                begin
                  if Data.CoordsIdx = 1
                  then PlotPoint.X := CoordX(y_r*Cos(x_phi))
                  else PlotPoint.X := CoordX(x_phi);
                end;

                if GraphData.Grid.yAxisStyle = asLog
                then PlotPoint.Y := CoordLogY(y_r)
                else
                begin
                  if Data.CoordsIdx = 1
                  then PlotPoint.Y := CoordY(y_r*Sin(x_phi))
                  else PlotPoint.Y := CoordY(y_r);
                end;
                DrawLine := Count > 1;
              end;

              for k := FirstPoint to ControlPoints.Count do
              if k < ControlPoints.Count -1 then
              for j := 0 to StepPts -1 do
              begin
                with TGraphPointObject(ControlPoints[FirstPoint]) do
                Add(TGraphPointObject.Create(xp(k, j, i), yp(k, j, i)));
                with TGraphPointObject(Items[Count -1]) do
                begin
                  if GraphData.Grid.xAxisStyle = asLog
                  then PlotPoint.X := CoordLogX(x_phi)
                  else
                  begin
                    if Data.CoordsIdx = 1
                    then PlotPoint.X := CoordX(y_r*Cos(x_phi))
                    else PlotPoint.X := CoordX(x_phi);
                  end;

                  if GraphData.Grid.yAxisStyle = asLog
                  then PlotPoint.Y := CoordLogY(y_r)
                  else
                  begin
                    if Data.CoordsIdx = 1
                    then PlotPoint.Y := CoordY(y_r*Sin(x_phi))
                    else PlotPoint.Y := CoordY(y_r);
                  end;
                  DrawLine := Count > 1;
                end;
              end;
            end;

            with GraphData.PlotData do
            begin
              PlotWidth := PenWidth;
              PlotColor := PenColor;
            end;

            DrawCartesian(PlotList);     { draw the graph }
            ClearPointList(ePoints);
          end;
        end;  { case Data.NumericStyle of }

        with NumericForm do
        begin
          if Visible and (InputRG.ItemIndex > 0) and
                    (CheckListBox.ItemIndex = i) then
          begin
            j := CheckListBox.ItemIndex;
            k := DataListBox.ItemIndex;
            with TNumericObject(Items.Objects[j]) do
            begin
              c := Data.PlotColor;
              with TGraphPointObject(ControlPoints[k]) do
              begin
                vx := x_phi;
                vy := y_r;
              end;
            end;

            case CoordsRG.ItemIndex of
            0:DrawTarget(vx, vy, c);  { Cartesian }
            1:begin                   { Polar }
                with TGraphPointObject(ControlPoints[k]) do
                begin
                  vx := y_r*Cos(x_phi);
                  vy := y_r*Sin(x_phi);
                  DrawTarget(vx, vy, c);
                  Line(CoordX(0), CoordY(0), CoordX(vx), CoordY(vy));
                end;
              end;
            2:begin                   { As Vector }
                DrawTarget(vx, vy, c);
                if k > 0 then
                with TGraphPointObject(ControlPoints[k -1]) do
                begin
                  vx := x_phi;
                  vy := y_r;
                  DrawTarget(vx, vy, c);
                end;
              end;
            end;
          end;
        end;
      end;  { if Points.Count > 0 then... }
    end;  { with TNumericObject(Items.Objects[i]) do if Checked[i] then... }
  end;  { with NumericForm.CheckListBox do if Count > 0 then... }
end;  { TfxCanvas.DrawNumericData }


procedure TfxCanvas.DrawTextBlocks(var rci: TGLRenderContextInfo;
                                   var wbf: TGLWindowsBitmapFont);
var
  i, j, k, x, y: integer;

begin
  with TextBlocksForm.BlockListBox do if Count > 0 then
  begin
    StopPrimitive;
    for i := 0 to Count -1 do
    with TTextDataObject(Items.Objects[i]) do if Checked[i] then
    begin
      SetGLWinBitFont(rci, wbf, Data.FontName, Data.FontSize, Data.FontStyle);
      for j := 0 to Items.Count -1 do if Checked[j] then
      begin
        if GraphData.Grid.xAxisStyle = asLog
        then x := CoordLogX(Data.xLoc)
        else x := CoordX(Data.xLoc);

        if GraphData.Grid.yAxisStyle = asLog
        then y := CoordLogY(Data.yLoc)
        else y := CoordY(Data.yLoc);

        for k := 0 to TextLines.Count -1 do
        with TTextLineObject(TextLines[k])do
        wbf.TextOut(rci, x, y + k*Data.yInc, Text, Color);
      end;
    end;
  end;
  with GraphData do SetGLWinBitFont(rci, wbf, FontName, FontSize, FontStyle);
  SetupFont(rci, wbf);
end;

procedure TfxCanvas.ClearTextList;
var
  i: integer;

begin
  for i := 0 to TextList.Count -1 do TTextLocObject(TextList[i]).Free;
  TextList.Free;
end;

procedure TfxCanvas.ClearPointList(var L: TList);
var
  i: integer;

begin
  if Assigned(L) then
  begin
    for i := 0 to L.Count -1 do TGraphPointObject(L[i]).Free;
    L.Free;
    L := nil;
  end;
end;

function TfxCanvas.SumSegments(var aNeg, aPos: extended): extended;
var
  a: extended;      { integral area }
  h: extended;      { step }
  isOK: Boolean;    { OK to draw line }
  x, x1, x2: extended;
  y, y1, y2: extended;
  my: extended;
  i: integer;
  m: integer;
  LastXCoord: integer;

begin  { SumSegments }
  if IntegMax = IntegMin then
  begin
    Result := 0;
    Exit;
  end;

  if IntegMax < IntegMin then
  begin
    a := IntegMax;
    IntegMax := IntegMin;
    IntegMin := a;
    with IntegrateXForm do
    begin
      EditIntegMin.Text := FloatToStrF(IntegMin, ffGeneral, 13, 4);
      EditIntegMax.Text := FloatToStrF(IntegMax, ffGeneral, 13, 4);
    end;
  end;

  h := (IntegMax - IntegMin)/GraphData.IntegCount;  { calculate step }
  a := 0;  { initial area = 0 }

{ calculate numerical value to be used to display area }
  x := IntegMin;
  for i := 0 to GraphData.IntegCount do
  begin  { calculate area using Simpson's rule }
  { h/3(y0 + 4y1 + 2y2 + 4y3 +...+ 2y(i-2) + 4y(i-1) + y(i)) }
    y := EvaluateFunction(x);
    if not isNaN(y) then
    begin
      if odd(i) then m := 4 else
      if (i > 0) and (i < GraphData.IntegCount) then m := 2 else m := 1;
    { sum = (y0 + 4y1 + 2y2 + 4y3 +...+ 2y(i-2) + 4y(i-1) + y(i)) }
    { m   =  1    4     2     4         2         4         1    }

      my := m*y;     { m*f(x(i)) for i = 0 to Count }
      a := a + my;   { add to sum }
      if y < 0 then aNeg := aNeg + my else aPos := aPos + my;
    end;

    x := x + h;    { next step }
  end;  { for i := 0 to IntegCount do... }

  aNeg := aNeg*h/3;
  aPos := aPos*h/3;
  Result := aPos + aNeg;
{-------------------------------------------------------------}
  a := 0;  { initial area = 0 }
  LastXCoord := MaxInt;

{ calculate value for each segment to be used to plot integral }
  IntegYMin := 1.1e308;
  IntegYMax := -IntegYMin;

  x := IntegMin;  { start }
  x1 := x + h;    { one step }
  x2 := x1 + h;   { two steps }

  for i := 0 to GraphData.IntegCount div 2 do
  begin
    isOK := true;
    y := EvaluateFunction(x);

    if isNaN(y) then
    begin
      isOK := false;
      y := 0;
    end;

    y1 := EvaluateFunction(x1);
    if isNaN(y1) then
    begin
      isOK := false;
      y1 := 0;
    end;

    y2 := EvaluateFunction(x2);
    if isNaN(y2) then
    begin
      isOK := false;
      y2 := 0;
    end;

    a := a + h*(y + 4*y1 + y2)/3;
  { Simpson's rule h/3(y + 4y1 + y2) }
    y := a + IntegConst;

    if x1 <= IntegMax then
    begin
      if y < IntegYMin then IntegYMin := y;
      if y > IntegYMax then IntegYMax := y;
    { only add a GraphPoint for each pixel horizontally }
      if LastXCoord <> CoordX(x1) then
      begin
        IntegList.Add(TGraphPointObject.Create(x1, y));
        TGraphPointObject(
        IntegList[IntegList.Count -1]).DrawLine := isOK;
      end;
      LastXCoord := CoordX(x1)
    end;
    x := x2;        { increase two steps }
    x1 := x + h;    { increase one step }
    x2 := x1 + h;   { increase one step }
  end;

  i := 0;                    { get IntegXMin }
  with TGraphPointObject(IntegList[i]) do
  begin
    isOK := DrawLine;
    IntegXMin := x_phi;
  end;

  while not isOK and (i < IntegList.Count) do
  begin
    with TGraphPointObject(IntegList[i]) do isOK := DrawLine;
    Inc(i);
  end;
  if i > 0 then Dec(i);
  with TGraphPointObject(IntegList[i]) do IntegXMin := x_phi;


  i := IntegList.Count -1;   { get IntegXMax }
  with TGraphPointObject(IntegList[i]) do
  begin
    isOK := DrawLine;
    IntegXMax := x_phi;
  end;

  while not isOK and (i > 0) do
  begin
    with TGraphPointObject(IntegList[i]) do isOK := DrawLine;
    Dec(i);
  end;
  if i < IntegList.Count -1 then Inc(i);
  with TGraphPointObject(IntegList[i]) do IntegXMax := x_phi;
end;

function TfxCanvas.SumYSegments(var aNeg, aPos: Extended): extended;
var
  a: extended;   { integral area }
  h: extended;   { step }
  x1, x2, y1, y2: extended;
  i: integer;
  LastYCoord: integer;

begin  { SumYSegments }
  if IntegMax = IntegMin then
  begin
    Result := 0;
    Exit;
  end;

  if IntegMax < IntegMin then
  begin
    a := IntegMax;
    IntegMax := IntegMin;
    IntegMin := a;
    with IntegrateYForm do
    begin
      EditIntegMin.Text := FloatToStrF(IntegMin, ffGeneral, 13, 4);
      EditIntegMax.Text := FloatToStrF(IntegMax, ffGeneral, 13, 4);
    end;
  end;

  h := (IntegMax - IntegMin)/GraphData.IntegCount;  { calculate step }
  a := 0;  { initial area = 0 }

  LastYCoord := MaxInt;
  aNeg := a;
  aPos := a;

  x1 := IntegMin;
  x2 := x1 + h;
  y1 := EvaluateFunction(x1);
  y2 := EvaluateFunction(x2);

  for i := 0 to GraphData.IntegCount do
  begin
    if not(isNAN(y1) or isNAN(y2)) then
    begin
      a := abs(y2 - y1)*(x1 + x2)/2;
      if (x1 < 0) and (x2 <= 0) then aNeg := aNeg + a else aPos := aPos + a;
    { only add a GraphPoint for each pixel vertically }
      if LastYCoord <> CoordY(y1) then
      IntegList.Add(TGraphPointObject.Create(x1, y1));
      TGraphPointObject(IntegList[IntegList.Count -1]).DrawLine := True;
    end
    else
    begin
    { only add a GraphPoint for each pixel vertically }
      if LastYCoord <> CoordY(y1) then
      IntegList.Add(TGraphPointObject.Create(x1, y1));
      TGraphPointObject(IntegList[IntegList.Count -1]).DrawLine := False;
    end;
    LastYCoord := CoordY(y1);

    x1 := x2;
    x2 := x2 + h;
    y1 := y2;
    y2 := EvaluateFunction(x2);
  end;
  Result := aPos + aNeg;
end;   { SumYSegments }

procedure TfxCanvas.QuadVertices(x, y, xRadius, yRadius: Single;
                                 q1, q2, q3, q4: Boolean);
var
  i, n: Integer;
  s, c: TSingleArray;

begin
  n := Round(MaxFloat(xRadius, yRadius) * 0.1) + 5;
  SetLength(s, n);
  SetLength(c, n);
  Dec(n);
  PrepareSinCosCache(s, c, 0, 90);
  ScaleFloatArray(s, yRadius);
  ScaleFloatArray(c, xRadius);
{ first quadrant; top right }
  if q1 then for i := 0 to n do glVertex2f(x + c[i], y - s[i]);

{ second quadrant; top left }
  if q2 then for i := n - 1 downto 0 do glVertex2f(x - c[i], y - s[i]);

{ third quadrant; bottom left }
  if q3 then for i := 1 to n do glVertex2f(x - c[i], y + s[i]);

{ fourth quadrant; bottom right }
  if q4 then for i := n - 1 downto 0 do glVertex2f(x + c[i], y + s[i]);
end;

procedure TfxCanvas.FillEllipseBB(const x1, y1, x2, y2: Integer);
begin
  FillEllipse((x1 + x2)*0.5, (y1 + y2)*0.5, Abs(x2 - x1)*0.5, Abs(y2 - y1)*0.5);
end;

procedure TfxCanvas.FillEllipseBB(const x1, y1, x2, y2: Single);
begin
  FillEllipse((x1 + x2)*0.5, (y1 + y2)*0.5, Abs(x2 - x1)*0.5, Abs(y2 - y1)*0.5);
end;

procedure TfxCanvas.FillQuadrants(const x, y: Integer;
                                  const xRadius, yRadius: Single;
                                        q1, q2, q3, q4: Boolean);
begin
  StartPrimitive(GL_TRIANGLE_FAN);
  glVertex2f(x, y); { not really necessary, but may help with memory stride }
  QuadVertices(x, y, xRadius, yRadius, q1, q2, q3, q4);
  StopPrimitive;
end;

procedure TfxCanvas.FillQuadrantsBB(const x1, y1, x2, y2: Integer;
                                q1, q2, q3, q4: Boolean);
begin
  FillQuadrants((x1 + x2) div 2, (y1 + y2) div 2,
             Abs(x1 - x2) div 2, Abs(y1 - y2) div 2, q1, q2, q3, q4);
end;

procedure TfxCanvas.StartRadialFill(const x, y: integer);
begin
  StartPrimitive(GL_TRIANGLE_FAN);
  glVertex2f(x, y);
end;

procedure TfxCanvas.FillSector(x, y: Integer);
begin
  glVertex2f(x, y);
end;

procedure TfxCanvas.StopRadialFill;
begin
  StopPrimitive;
end;

procedure TfxCanvas.SetupFont(var rci: TGLRenderContextInfo;
                              var wbf: TGLWindowsBitmapFont);
begin
  wbf.TextOut(rci, -10, -30, 'y = f(x)', clRed);
  CharW := wbf.GetCharWidth('M');
  CharH := wbf.CharHeight;
end;

procedure TfxCanvas.SetGLWinBitFont(var rci: TGLRenderContextInfo;
                                    var wbf: TGLWindowsBitmapFont;
                        Nm: string; Sz: Integer; St: TFontStyles);
begin
  with wbf.Font do
  begin
    Name := Nm;
    Size := Sz;
    Style := St;
  end;
end;

procedure TfxCanvas.xAxisGradsCalc(var wbf: TGLWindowsBitmapFont);
var
  xCoord: integer;

begin
  CharW := wbf.GetCharWidth('M');
  CharH := wbf.CharHeight;

  dxGrad := 0.1;
  dx10Grad := 1;

  with GraphData do
  begin
    xCoord := CoordX(xMin + dxGrad);

                  { major X axis graduation lengths }
    while (xCoord > xMajorGrad) or (xCoord < 0) do
    begin
      dxGrad := dxGrad/10;
      xCoord := CoordX(xMin + dxGrad);
    end;
                 { minor X axis graduation lengths }
    while xCoord < xMinorGrad do
    begin
      dxGrad := dxGrad*10;
      xCoord := CoordX(xMin + dxGrad);
    end;
  end;

  dx10Grad := 10*dxGrad;  { major x graduation space }
  if dxGrad < 1           { calculate number of digits }
  then xDigits := round(-log10(dxGrad)) -1
  else xDigits := round(log10(dxGrad)) +1;
end;

procedure TfxCanvas.yAxisGradsCalc(var wbf: TGLWindowsBitmapFont);
var
  yCoord: integer;

begin
  CharW := wbf.GetCharWidth('M');
  CharH := wbf.CharHeight;

  dyGrad := 0.1;
  dy10Grad := 1;

  with GraphData do
  begin
    yCoord := CoordY(yMin) - CoordY(yMin + dyGrad);
                  { major Y axis graduation lengths }
    while (yCoord > yMajorGrad) or (yCoord < 0) do
    begin
      dyGrad := dyGrad/10;
      yCoord := CoordY(yMin) - CoordY(yMin + dyGrad);
    end;
                  { minor Y axis graduation lengths }
    while yCoord < yMinorGrad do
    begin
      dyGrad := dyGrad*10;
      yCoord := CoordY(yMin) - CoordY(yMin + dyGrad);
    end;
  end;

  dy10Grad := 10*dyGrad;  { major y graduation space }
  if dyGrad < 1           { calculate number of digits }
  then yDigits := round(-log10(dyGrad)) -1
  else yDigits := round(log10(dyGrad)) +1;
end;

procedure TfxCanvas.DrawTextList(var rci: TGLRenderContextInfo; L: TList;
                                 var wbf: TGLWindowsBitmapFont);
var
  i: integer;
  t: TTextLocObject;

begin
  StopPrimitive;
  for i := 0 to L.Count -1 do
  begin
    t := TTextLocObject(L.Items[i]);
    wbf.TextOut(rci, t.xLoc, t.yLoc, t.TextString, t.TextColor);
  end;
end;

procedure TfxCanvas.DrawAxes;
begin
  with GraphData.Grid do
  begin
    case GridStyle of
    gsCartesian:
    begin
      if xAxisStyle = asLog then DrawXGridLog else DrawXGridLinear;
      if yAxisStyle = asLog then DrawYGridLog else DrawYGridLinear;
    end;
    gsPolar:
      DrawPolarGrid;
    end;
    if xAxisStyle = asLog then DrawXAxisLog else DrawXAxisLinear;
    if yAxisStyle = asLog then DrawYAxisLog else DrawYAxisLinear;
  end;
end;

procedure TfxCanvas.DrawFunctions;
var
  i: integer;

begin
  with FunctionsForm.CheckListBox do
  begin
    for i := 0 to Items.Count -1 do if Checked[i] then
    begin
      GraphData.PlotData := TPlotDataObject(Items.Objects[i]).Data;
      ClearPointList(PlotList);
      PlotList := TList.Create;

      with FxParser do
      begin
        if i > 0 then Calculus.Free;

        ErrorByte := 0;
        MainForm.StatusBar.Panels[2].Text := '';
        with GraphData.PlotData do
        Calculus := Compile(AnsiLowerCase(FunctStr), ErrorByte);

        if ErrorByte > 0 then
        begin
          with MainForm.StatusBar.Panels[2] do
          case ErrorByte of
            1:Text := 'Check Brackets for "'+
                       GraphData.PlotData.FunctStr+'"';
            2:Text := 'Unable to Parse "'+
                       GraphData.PlotData.FunctStr+'"';
          end;
        end;
      end;
      PlotFunction(i = ItemIndex);  { Selected := i = ItemIndex }
    end;
  end;
end;

end.
