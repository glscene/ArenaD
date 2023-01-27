unit fMain;
(* App crashes; stops responding; when vertical volume intergration calculated
  for x/arccsc(ln(x^4)); xonarccsc(ln(x_4)).yfx file
  also for large movements when logx and logy axes in use *)

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.UITypes,
  System.Math,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.ComCtrls,
  Vcl.Menus,
  Vcl.ExtDlgs,
  Vcl.Printers,

  GLS.Scene,
  GLS.Coordinates,

  GLS.BaseClasses,
  GLS.SceneViewer,
  GLS.BitmapFont,
  GLS.WindowsFont,
  GLS.RenderContextInfo,

  uCanvas,
  uGlobal,
  fAbout,
  fFuncts;

type
  TMainForm = class(TForm)
    MainMenu: TMainMenu;
    File1: TMenuItem;
    New: TMenuItem;
    Open: TMenuItem;
    Save: TMenuItem;
    SaveAs: TMenuItem;
    SaveBMPfile1: TMenuItem;
    SaveJPGfile1: TMenuItem;
    N2: TMenuItem;
    Print1: TMenuItem;
    SetupPrinter1: TMenuItem;
    N1: TMenuItem;
    ExitApp: TMenuItem;
    View1: TMenuItem;
    GridOptions1: TMenuItem;
    NumGraphs: TMenuItem;
    Texts1: TMenuItem;
    Style1: TMenuItem;
    SelectStyle1: TMenuItem;
    SaveStyle1: TMenuItem;
    StatusBar: TStatusBar;
    GLViewer: TGLSceneViewer;
    GLScene: TGLScene;
    GLCamera: TGLCamera;
    GLDirectOpenGL: TGLDirectOpenGL;
    GLWinBitFont: TGLWindowsBitmapFont;
    GLMemoryViewer: TGLMemoryViewer;
    PrinterSetupDialog: TPrinterSetupDialog;
    DefaultLayout1: TMenuItem;
    Help1: TMenuItem;
    About1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
              WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure GLViewerDragOver(Sender, Source: TObject; X, Y: Integer;
                               State: TDragState; var Accept: Boolean);
    procedure GLViewerEndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure GLViewerMouseDown(Sender: TObject; Button: TMouseButton;
                                 Shift: TShiftState; X, Y: Integer);
    procedure GLViewerMouseMove(Sender: TObject; Shift: TShiftState;
                                  X, Y: Integer);
    procedure GLViewerMouseUp(Sender: TObject; Button: TMouseButton;
                               Shift: TShiftState; X, Y: Integer);
    procedure GLDirectOpenGLRender(Sender: TObject;
                                  var rci: TGLRenderContextInfo);
    procedure NewClick(Sender: TObject);
    procedure OpenClick(Sender: TObject);
    procedure SaveClick(Sender: TObject);
    procedure SaveAsClick(Sender: TObject);
    procedure ExitAppClick(Sender: TObject);
    procedure GridOptions1Click(Sender: TObject);
    procedure Texts1Click(Sender: TObject);
    procedure SaveBMPfile1Click(Sender: TObject);
    procedure SaveJPGfile1Click(Sender: TObject);
    procedure Print1Click(Sender: TObject);
    procedure SetupPrinter1Click(Sender: TObject);
    procedure SelectStyle1Click(Sender: TObject);
    procedure SaveStyle1Click(Sender: TObject);
    procedure GLViewerMouseLeave(Sender: TObject);
    procedure NumGraphsClick(Sender: TObject);
    procedure DefaultLayout1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
  private
    dMove: integer;
    procedure ShowXYvalues(const x, y: extended);
    procedure UpdateGridXRange;
    procedure UpdateGridYRange;
    procedure DefaultLayout;
    function ValueX(const x: integer): extended;
    function ValueY(const y: integer): extended;
    function ValueLogX(const x: integer): extended;
    function ValueLogY(const y: integer): extended;
  public
    oMousex, oMousey: integer;
  end;

const
  crHandMove = 1;
  crMoveRight = 2;
  crMoveLeft = 3;
  crMoveUp = 4;
  crMoveDown = 5;
  crZoom = 6;

var
  MainForm: TMainForm;
  NewFont: Boolean = True;
  PrinterExists: Boolean;

//=====================================================================
implementation
//=====================================================================

{$R *.dfm}
{$R CURSORS.RES}

uses
  fGridOpts,
  fIntegrateX,
  fIntegrateY,
  fBitmap,
  fStyle,
  fTextBlocks,
  fDerivative,
  fBetween,
  fVolumeX,
  fVolumeY,
  fxValue,
  fx1Value,
  fx2Value,
  fNumeric,
  fPrint;

procedure TMainForm.FormCreate(Sender: TObject);

begin
  BinPath :=  ExtractFilePath(ParamStr(0));
  BinPath := IncludeTrailingPathDelimiter(BinPath);
  DataPath := BinPath + 'Examples\';

  PrinterExists := Printer.Printers.Count > 0;
  StyleFName := BinPath + 'Styles.sty';
  LayoutFName := BinPath + 'Layout.lay';

  Screen.Cursors[crHandMove] := LoadCursor(HInstance, 'HANDMOVE');
  Screen.Cursors[crMoveRight] := LoadCursor(HInstance, 'MOVERIGHT');
  Screen.Cursors[crMoveLeft] := LoadCursor(HInstance, 'MOVELEFT');
  Screen.Cursors[crMoveUp] := LoadCursor(HInstance, 'MOVEUP');
  Screen.Cursors[crMoveDown] := LoadCursor(HInstance, 'MOVEDOWN');
  Screen.Cursors[crZoom] := LoadCursor(HInstance, 'ZOOM');
  dMove := $200;
end;

procedure TMainForm.FormShow(Sender: TObject);
var
  f: File of TLayout;

begin
  if FileExists(LayoutFName) then
  begin
    try
      AssignFile(f, LayoutFName);
      try
        Reset(f);
        Read(f, Layout);
      finally
        CloseFile(f);
      end;

      if Layout.IsMaximize then WindowState := wsMaximized
      else
      begin
        with Layout do
        begin
          Left := MainLeft;
          Top := MainTop;
          Width := MainWidth;
          Height := MainHeight;
          GraphFName := CurrentGraphFName;
          DataPath := CurrentDataPath;
          ImagePath := CurrentImagePath;
          PrinterInfo := CurrentPrinterInfo;

          if GridsVisible then GridOptionsForm.Show;
          with GridOptionsForm do
          begin
            MainForm.Left := GridsLeft;
            MainForm.Top := GridsTop;
          end;

          if NumericVisible then NumericForm.Show;
          with NumericForm do
          begin
            MainForm.Left := NumericLeft;
            MainForm.Top := NumericTop;
          end;

          if TextVisible then TextBlocksForm.Show;
          with TextBlocksForm do
          begin
            MainForm.Left := TextLeft;
            MainForm.Top := TextTop;
            MainForm.Width := TextWidth;
            MainForm.Height := TextHeight;
          end;
          with FunctionsForm do
          begin
            MainForm.Left := FuncLeft;
            MainForm.Top := FuncTop;
          end;
          with DerivativeForm do
          begin
            MainForm.Left := DerivLeft;
            MainForm.Top := DerivTop;
          end;
          with IntegrateXForm do
          begin
            MainForm.Left := IntegXLeft;
            MainForm.Top := IntegXTop;
          end;
          with IntegrateYForm do
          begin
            MainForm.Left := IntegYLeft;
            MainForm.Top := IntegYTop;
          end;
          with BetweenForm do
          begin
            MainForm.Left := BetweenLeft;
            MainForm.Top := BetweenTop;
          end;
          with VolumeXForm do
          begin
            MainForm.Left := VolumeXLeft;
            MainForm.Top := VolumeXTop;
          end;
          with VolumeYForm do
          begin
            MainForm.Left := VolumeYLeft;
            MainForm.Top := VolumeYTop;
          end;
          with fxValueForm do
          begin
            MainForm.Left := fxLeft;
            MainForm.Top := fxTop;
          end;
          with fx1ValueForm do
          begin
            MainForm.Left := fx1Left;
            MainForm.Top := fx1Top;
          end;
          with fx2ValueForm do
          begin
            MainForm.Left := fx2Left;
            MainForm.Top := fx2Top;
          end;
        end;
      end;
    except
      MessageDlg('File Error! An Error has occurred when attempting to read'+
           #13#10'"'+LayoutFName+'".'+
           #13#10'The default layout will be used.',
           mtError, [mbOK], 0);
      DefaultLayout;
    end;
  end
  else DefaultLayout;
  if DataPath = '' then DataPath := BinPath + 'Examples\';
  if ImagePath = '' then ImagePath := BinPath + 'Images\';
  if not DirectoryExists(DataPath) then ForceDirectories(DataPath);
  if not DirectoryExists(ImagePath) then ForceDirectories(ImagePath);

  if PrinterExists then
  begin
    SetPrinterInfo(PrinterInfo);
    GetPrinterInfo(PrinterInfo);
    if PrinterInfo.Orientation = poPortrait
    then StatusBar.Panels[1].Text :=
         '  '+Printer.Printers[PrinterInfo.Index]+'  '+GetPaperType +
         ', Portrait.'
    else StatusBar.Panels[1].Text :=
         '  '+Printer.Printers[PrinterInfo.Index]+'  '+GetPaperType +
         ', Landscape.';
  end
  else
  begin
    Print1.Enabled := false;   // disabled if no printer
    SetupPrinter1.Enabled := false;
    StatusBar.Panels[1].Text := 'No printer was found.';
  end;

  Caption := GraphFName;
  KeepRange := false;
  FunctionsForm.Show;
  Altered := false;
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  f: File of TLayout;

begin
  with Layout do
  begin
    IsMaximize := WindowState = wsMaximized;
    MainLeft := Left;
    MainTop := Top;
    MainWidth := Width;
    MainHeight := Height;
    CurrentGraphFName := GraphFName;
    CurrentDataPath := DataPath;
    CurrentImagePath := ImagePath;
    CurrentPrinterInfo := PrinterInfo;
    GridsVisible := GridOptionsForm.Visible;
    with GridOptionsForm do
    begin
      GridsLeft := Left;
      GridsTop := Top;
    end;

    NumericVisible := NumericForm.Visible;
    with NumericForm do
    begin
      NumericLeft := Left;
      NumericTop := Top;
    end;

    with NumericForm do if Visible then
    begin
      if (DataListBox.Count = 0) and (CheckListBox.Count > 0)
      then DeleteButtonClick(Sender);
      FunctionsForm.CoordPointButton.Visible := False;
    end;

    TextVisible := TextBlocksForm.Visible;
    with TextBlocksForm do
    begin
      TextLeft := Left;
      TextTop := Top;
      TextWidth := Width;
      TextHeight := Height;
    end;
    with FunctionsForm do
    begin
      FuncLeft := Left;
      FuncTop := Top;
    end;
    with DerivativeForm do
    begin
      DerivLeft := Left;
      DerivTop := Top;
    end;
    with IntegrateXForm do
    begin
      IntegXLeft := Left;
      IntegXTop := Top;
    end;
    with IntegrateYForm do
    begin
      IntegYLeft := Left;
      IntegYTop := Top;
    end;
    with BetweenForm do
    begin
      BetweenLeft := Left;
      BetweenTop := Top;
    end;
    with VolumeXForm do
    begin
      VolumeXLeft := Left;
      VolumeXTop := Top;
    end;
    with VolumeYForm do
    begin
      VolumeYLeft := Left;
      VolumeYTop := Top;
    end;
    with fxValueForm do
    begin
      fxLeft := Left;
      fxTop := Top;
    end;
    with fx1ValueForm do
    begin
      fx1Left := Left;
      fx1Top := Top;
    end;
    with fx2ValueForm do
    begin
      fx2Left := Left;
      fx2Top := Top;
    end;
  end;

  try
    AssignFile(f, LayoutFName);
    try
      Rewrite(f);
      write(f, Layout);
    finally
      CloseFile(f);
    end;
  except
    MessageDlg('File Error! An Error has occurred'+
         #13#10'when attempting to write to "'+LayoutFName+'".',
    mtError, [mbOK], 0);
  end;

  if Altered then
  begin
    case MessageDlg('The current graph data has been altered.'+
              #13#10'Do you wish to save the alterations ?', mtConfirmation,
                    [mbYes, mbNo, mbCancel], 0) of
    mrYes: FunctionsForm.SaveClick(Sender);
 mrCancel: begin
             CanClose := false;
             Exit;
           end;
    end;
  end;
end;

procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word;
                                 Shift: TShiftState);
var
  x, y, r: extended;

begin
  with GraphData.Grid do
  if (xAxisStyle = asLog) or (yAxisStyle = asLog) then exit;
  case Key of
//VK_F2:ShowAbout;
  VK_ESCAPE:
    if (MessageDlg('Do you wish to close the applicsation?',
                    mtConfirmation, [mbYes, mbNo], 0) = mrYes)
    then ExitAppClick(Sender);
  VK_LEFT, VK_NUMPAD4:
    begin
      Screen.Cursor := crMoveLeft;
      with GraphData do
      begin
        x := (xMax - xMin)/dMove;
        xMin := xMin + x;
        xMax := xMax + x;
      end;
      UpdateGridXRange;
      Altered := true;
      if dMove > 1 then dec(dMove, dMove div 16);
      GLViewer.Invalidate;
      Key := 0;
    end;
  VK_RIGHT, VK_NUMPAD6:
    begin
      Screen.Cursor := crMoveRight;
      with GraphData do
      begin
        x := (xMax - xMin)/dMove;
        xMin := xMin - x;
        xMax := xMax - x;
      end;
      UpdateGridXRange;
      Altered := true;
      if dMove > 1 then dec(dMove, dMove div 16);
      GLViewer.Invalidate;
      Key := 0;
    end;
  VK_UP, VK_NUMPAD8:
    begin
      Screen.Cursor := crMoveUp;
      with GraphData do
      begin
        y := (yMax - yMin)/dMove;
        yMin := yMin - y;
        yMax := yMax - y;
      end;
      UpdateGridYRange;
      Altered := true;
      if dMove > 1 then dec(dMove, dMove div 16);
      GLViewer.Invalidate;
      Key := 0;
    end;
  VK_DOWN, VK_NUMPAD2:
    begin
      Screen.Cursor := crMoveDown;
      with GraphData do
      begin
        y := (yMax - yMin)/dMove;
        yMin := yMin + y;
        yMax := yMax + y;
      end;
      UpdateGridYRange;
      Altered := true;
      if dMove > 1 then dec(dMove, dMove div 16);
      GLViewer.Invalidate;
      Key := 0;
    end;
  VK_ADD:  // zoom in
    begin
      Screen.Cursor := crZoom;
      with GraphData do
      begin
        x := (xMax - xMin)/dMove;
        xMin := xMin + x;
        xMax := xMax - x;

        y := (yMax - yMin)/dMove;
        yMin := yMin + y;
        yMax := yMax - y;
      end;
      UpdateGridXRange;
      UpdateGridYRange;
      Altered := true;
      if dMove > 1 then dec(dMove, dMove div 16);
      GLViewer.Invalidate;
      Key := 0;
    end;
  VK_SUBTRACT:  // zoom out
    begin
      Screen.Cursor := crZoom;
      x := (GraphData.xMax - GraphData.xMin)/dMove;
      GraphData.xMin := GraphData.xMin - x;
      GraphData.xMax := GraphData.xMax + x;

      y := (GraphData.yMax - GraphData.yMin)/dMove;
      GraphData.yMin := GraphData.yMin - y;
      GraphData.yMax := GraphData.yMax + y;
      UpdateGridXRange;
      UpdateGridYRange;
      Altered := true;
      if dMove > 1 then dec(dMove, dMove div 16);
      GLViewer.Invalidate;
      Key := 0;
    end;
  VK_HOME, VK_NUMPAD7:
    begin
      x := (GraphData.xMax - GraphData.xMin)/2;
      GraphData.xMin := -x;
      GraphData.xMax :=  x;
      y := (GraphData.yMax - GraphData.yMin)/2;
      GraphData.yMin := -y;
      GraphData.yMax :=  y;
      UpdateGridXRange;
      UpdateGridYRange;
      Altered := true;
      GLViewer.Invalidate;
      Key := 0;
    end;
  12, VK_NUMPAD5:  // eual grid
    begin
      with GraphData do
      begin
        x := xMax - xMin;
        y := yMax - yMin;
        r := (x*MainForm.GLViewer.Height)/(y*Mainform.GLViewer.Width);

        if x > y then
        begin
          if Shift = [ssCtrl] then
          begin
            xMax := yMax;
            xMin := yMin;
          end
          else
          begin
            yMax := yMax*r;
            yMin := yMin*r;
          end;
        end
        else
        begin
          if Shift = [ssCtrl] then
          begin
            yMax := xMax;
            yMin := xMin;
          end
          else
          begin
            xMax := xMax/r;
            xMin := xMin/r;
          end;
        end;
      end;
      UpdateGridXRange;
      UpdateGridYRange;
      Altered := true;
      GLViewer.Invalidate;
      Key := 0;
    end;
  end;
end;

procedure TMainForm.FormKeyUp(Sender: TObject; var Key: Word;
                              Shift: TShiftState);
begin
  Screen.Cursor := crDefault;
  dMove := $200;
end;

procedure TMainForm.FormMouseWheel(Sender: TObject; Shift: TShiftState;
          WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
var
  d: integer;
  x, y: extended;

begin
  with GraphData.Grid do
  if (xAxisStyle = asLog) or (yAxisStyle = asLog) then exit;
// WheelDelta is negative when wheel is rotated toward user, i.e. Zoom in.
  d := -WheelDelta div 2;
  if Shift = [ssShift] then d := d div 4
  else if Shift = [ssCtrl] then d := d div 2;

  with GraphData do
  begin
    x := (xMax - xMin)/d;
    xMin := xMin + x;
    xMax := xMax - x;

    y := (yMax - yMin)/d;
    yMin := yMin + y;
    yMax := yMax - y;
  end;
  UpdateGridXRange;
  UpdateGridYRange;
  Altered := true;
  GLViewer.Invalidate;
end;

procedure TMainForm.GLViewerDragOver(Sender, Source: TObject; X, Y: Integer;
                                     State: TDragState; var Accept: Boolean);
begin
  Accept := Source = Sender;
  if Accept then with GraphData, PlotData do
  begin
    with Grid do
    begin
      if xAxisStyle = asLog
      then xLabel := ValueLogX(X)
      else xLabel := ValueX(X);

      if yAxisStyle = asLog
      then yLabel := ValueLogY(Y)
      else yLabel := ValueY(Y);
    end;

    FunctionsForm.EditLocX.Text := FloatToStrF(xLabel, ffNumber, 4, 3);
    FunctionsForm.EditLocY.Text := FloatToStrF(yLabel, ffNumber, 4, 3);
    ShowXYvalues(xLabel, yLabel);
  end;
end;

procedure TMainForm.GLViewerEndDrag(Sender, Target: TObject; X, Y: Integer);
begin
  if Target = Sender then  // end of drag
  with FunctionsForm.CheckListBox,
       TPlotDataObject(Items.Objects[ItemIndex]).Data do
  begin
    with GraphData.Grid do
    begin
      if xAxisStyle = asLog
      then xLabel := ValueLogX(X)
      else xLabel := ValueX(X);

      if yAxisStyle = asLog
      then yLabel := ValueLogY(Y)
      else yLabel := ValueY(Y);
    end;

    Altered := true;
    GLViewer.Invalidate;
  end;
end;

procedure TMainForm.GLViewerMouseDown(Sender: TObject; Button: TMouseButton;
                                       Shift: TShiftState; X, Y: Integer);
var
  dx, dy: extended;

begin
  if Shift = [ssLeft] then          // drag only if left button pressed
  with Sender as TGLSceneViewer do  // treat Sender as TGLSceneViewer
  begin
    if (X >= LabelRect.Left ) and (X <= LabelRect.Right) and
       (Y >= LabelRect.Top) and (Y <= LabelRect.Bottom)
    then BeginDrag(false) else Screen.Cursor := crHandMove;
  end
  else if (GraphData.Grid.xAxisStyle <> asLog) and
          (GraphData.Grid.yAxisStyle <> asLog) and
          (Shift = [ssLeft, ssAlt]) then
  begin         // reposition graph; set mouse location as graph center
    with GraphData do
    begin
      dx := (xMin + xMax)/2 - ValueX(X);
      dy := (yMin + yMax)/2 - ValueY(Y);
      xMin := xMin - dx;
      xMax := xMax - dx;
      yMin := yMin - dy;
      yMax := yMax - dy;
    end;
    UpdateGridXRange;
    UpdateGridYRange;
    Altered := true;
    GLViewer.Invalidate;
  end;
end;

procedure TMainForm.GLViewerMouseLeave(Sender: TObject);
begin
  oMousex := -1;
end;

procedure TMainForm.GLViewerMouseMove(Sender: TObject; Shift: TShiftState;
                                        X, Y: Integer);

  procedure IsAltered;
  begin
    UpdateGridXRange;
    UpdateGridYRange;
    Altered := true;
    GLViewer.Invalidate;
  end;

var
  xValue, yValue: extended;

begin
  xValue := 0;
  yValue := 0;

  if Active and (oMousex > -1) then
  begin
    if Shift = [ssLeft] then
    begin
      with GraphData do
      begin
        if Grid.xAxisStyle = asLog then
        begin // ratio of change to current value of x
          xValue := (ValueLogX(X) - ValueLogX(oMousex))/ValueLogX(X);
          xMin := xMin - xMin*xValue;
          xMax := xMax - xMax*xValue;
        end
        else
        begin
          xValue := ValueX(X) - ValueX(oMousex);
          xMax := xMax - xValue;
          xMin := xMin - xValue;
        end;

        if Grid.yAxisStyle = asLog then
        begin // ratio of change to current value of y
          yValue := (ValueLogY(Y) - ValueLogY(oMousey))/ValueLogY(Y);
          yMin := yMin - yMin*yValue;
          yMax := yMax - yMax*yValue;
        end
        else
        begin
          yValue := ValueY(Y) - ValueY(oMousey);
          yMax := yMax - yValue;
          yMin := yMin - yValue;
        end;
      end;
      IsAltered;
    end
    else
    if Shift = [ssLeft, ssCtrl] then
    begin
      Screen.Cursor := crSizeAll;

      if GraphData.Grid.xAxisStyle = asLog then
      begin
        xValue := (ValueLogX(X) - ValueLogX(oMousex))/ValueLogX(X);
        GraphData.xMin := GraphData.xMin + GraphData.xMin*xValue;
        GraphData.xMax := GraphData.xMax - GraphData.xMax*xValue;
      end
      else
      begin
        xValue := ValueX(X) - ValueX(oMousex);
        GraphData.xMin := GraphData.xMin + xValue;
        GraphData.xMax := GraphData.xMax - xValue;
      end;

      if GraphData.Grid.yAxisStyle = asLog then
      begin
        yValue := (ValueLogY(Y) - ValueLogY(oMousey))/ValueLogY(Y);
        GraphData.yMin := GraphData.yMin + GraphData.yMin*yValue;
        GraphData.yMax := GraphData.yMax - GraphData.yMax*yValue;
      end
      else
      begin
        yValue := ValueY(Y) - ValueY(oMousey);
        GraphData.yMin := GraphData.yMin + yValue;
        GraphData.yMax := GraphData.yMax - yValue;
      end;

      IsAltered;
    end;

    if GraphData.Grid.xAxisStyle = asLog then
      xValue := ValueLogX(X)
    else
      xValue := ValueX(X);

    if GraphData.Grid.yAxisStyle = asLog then
      yValue := ValueLogY(Y)
    else
      yValue := ValueY(Y);
  end;

  oMousex := X;
  oMousey := Y;

  ShowXYvalues(xValue, yValue);
end;

procedure TMainForm.GLViewerMouseUp(Sender: TObject; Button: TMouseButton;
                                     Shift: TShiftState; X, Y: Integer);
begin
  Screen.Cursor := crDefault;
end;

procedure TMainForm.NewClick(Sender: TObject);
begin
  FunctionsForm.NewClick(Sender);
end;

procedure TMainForm.OpenClick(Sender: TObject);
begin
  FunctionsForm.OpenClick(Sender);
end;

procedure TMainForm.SaveClick(Sender: TObject);
begin
  FunctionsForm.SaveClick(Sender);
end;

procedure TMainForm.SaveAsClick(Sender: TObject);
begin
  FunctionsForm.SaveAsClick(Sender);
end;

procedure TMainForm.SaveBMPfile1Click(Sender: TObject);
begin
  BitmapForm := TBitmapForm.Create(Application);
  if FunctionsForm.CheckListBox.Count > 1 then
    BitmapForm.Caption := '   Save graphs as ''' +
      ChangeFileExt(GraphFName, '.bmp''')
  else
    BitmapForm.Caption := '   Save graph as ''' +
      ChangeFileExt(GraphFName, '.bmp''');
  BitmapForm.ShowModal;
  BitmapForm.Free;
  BitmapForm := nil;
end;

procedure TMainForm.SaveJPGfile1Click(Sender: TObject);
begin
  BitmapForm := TBitmapForm.Create(Application);
  if FunctionsForm.CheckListBox.Count > 1 then
    BitmapForm.Caption := '   Save graphs as ''' +
      ChangeFileExt(GraphFName, '.jpg''')
  else
    BitmapForm.Caption := '   Save graph as ''' +
      ChangeFileExt(GraphFName, '.jpg''');
  BitmapForm.ShowModal;
  BitmapForm.Free;
  BitmapForm := nil;
end;

procedure TMainForm.Print1Click(Sender: TObject);
begin
  PrintForm := TPrintForm.Create(Application);
  PrintForm.Caption := '   Print '''+ GraphFName+'''.';
  PrintForm.ShowModal;
  PrintForm.Free;
  PrintForm := nil;
end;

procedure TMainForm.SetupPrinter1Click(Sender: TObject);
begin
  if PrinterSetupDialog.Execute then
  begin
    GetPrinterInfo(PrinterInfo);
    if PrinterInfo.Orientation = poPortrait
    then StatusBar.Panels[1].Text :=
         '  '+Printer.Printers[PrinterInfo.Index]+'  '+GetPaperType +
         ', Portrait.'
    else StatusBar.Panels[1].Text :=
         '  '+Printer.Printers[PrinterInfo.Index]+'  '+GetPaperType +
         ', Landscape.';
  end;
end;

procedure TMainForm.DefaultLayout1Click(Sender: TObject);
begin
  DefaultLayout;
end;

procedure TMainForm.ExitAppClick(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.GridOptions1Click(Sender: TObject);
begin
  if not GridOptionsForm.Visible then
    GridOptionsForm.Show;
end;

procedure TMainForm.NumGraphsClick(Sender: TObject);
begin
  if not NumericForm.Visible then
  begin
    NumericForm.Show;
    NumericForm.CheckListBoxClick(Sender); // updates NumericForm.DataListBox
  end;
end;

procedure TMainForm.Texts1Click(Sender: TObject);
begin
  if not TextBlocksForm.Visible then
    TextBlocksForm.Show;
end;

procedure TMainForm.SelectStyle1Click(Sender: TObject);
begin
  StyleNameForm := TStyleNameForm.Create(Application);
  StyleNameForm.Selecting := true;
  StyleNameForm.ShowModal;
  StyleNameForm.Free;
  StyleNameForm := nil;
  Altered := true;
(*
NewFont needed to initialize GLWinFont.GetCharWidth
  if the font has been altered, which may or may not be the case,
  so do it anyway
*)
  NewFont := true;
  GLViewer.Invalidate;
end;

procedure TMainForm.SaveStyle1Click(Sender: TObject);
begin
  StyleNameForm := TStyleNameForm.Create(Application);
  StyleNameForm.Selecting := false;
  StyleNameForm.ShowModal;
  StyleNameForm.Free;
  StyleNameForm := nil;
end;

procedure TMainForm.GLDirectOpenGLRender(Sender: TObject;
                                        var rci: TGLRenderContextInfo);
var
  fxCanvas: TfxCanvas;

begin
  fxCanvas := TfxCanvas.Create(GLViewer.Width, GLViewer.Height);
  try
    if NewFont then
    begin
      fxCanvas.SetGLWinBitFont(rci, GLWinBitFont, GraphData.FontName,
        GraphData.FontSize, GraphData.FontStyle);
      fxCanvas.SetupFont(rci, GLWinBitFont);
      NewFont := false;
    end;

    with fxCanvas do
    begin
      xAxisGradsCalc(GLWinBitFont);            // calculates graduations
      yAxisGradsCalc(GLWinBitFont);

      if GraphData.Grid.GridStyle > gsNone
      then DrawAxes;

      AddFunctionLabelsText;               // add the labels to text list
      DrawTextList(rci, TextList, GLWinBitFont);  // axes and labels text
      DrawFunctions;
      DrawNumericData;
      DrawTextBlocks(rci, GLWinBitFont);
    end;
  finally
    fxCanvas.Free;
  end;
end;

procedure TMainForm.ShowXYvalues(const x, y: extended);
var
  sx, sy: string;

begin
  sx := FloatToStrF(x, ffnumber, 16, 8);
  sy := FloatToStrF(y, ffnumber, 16, 8);
  StatusBar.Panels[0].Text := ' x : '+sx+', y : '+sy;
end;

procedure TMainForm.UpdateGridXRange;
begin
  with GridOptionsForm do
    if Visible then
      begin
        EditMinX.Text := FloatToStrF(GraphData.xMin, ffGeneral, 13, 4);
        EditMaxX.Text := FloatToStrF(GraphData.xMax, ffGeneral, 13, 4);
      end;
end;

procedure TMainForm.About1Click(Sender: TObject);
begin
  AboutForm.Show
(*
  with TAboutForm.Create();
  try
    ShowModal;
  finally
    Free;
  end;
*)
end;

procedure TMainForm.DefaultLayout;
begin
  MainForm.Left := 1;
  MainForm.Top := 1;
  MainForm.Width := Screen.Width - GridOptionsForm.Width - 10;
  MainForm.Height := Screen.Height - 30;
  FunctionsForm.Left := MainForm.Left + MainForm.Width + 5;
  FunctionsForm.Top := MainForm.Top + 5;
  GridOptionsForm.Left := FunctionsForm.Left;
  GridOptionsForm.Top := FunctionsForm.Top + FunctionsForm.Height + 10;
  GridOptionsForm.Show;
  NumericForm.Top := 25;
  NumericForm.Left := 25;
  TextBlocksForm.Top := 75;
  TextBlocksForm.Left := 75;
end;

procedure TMainForm.UpdateGridYRange;
begin
  with GridOptionsForm do
    if Visible then
    begin
      EditMinY.Text := FloatToStrF(GraphData.yMin, ffGeneral, 13, 4);
      EditMaxY.Text := FloatToStrF(GraphData.yMax, ffGeneral, 13, 4);
    end;
end;

function TMainForm.ValueX(const x: integer): extended;
begin
  Result := GraphData.xMin + X * (GraphData.xMax - GraphData.xMin) / GLViewer.Width;
end;

function TMainForm.ValueY(const y: integer): extended;
begin
  Result := GraphData.yMax + Y * (GraphData.yMin - GraphData.yMax) / GLViewer.Height;
end;

function TMainForm.ValueLogX(const x: integer): extended;
var
  LogMin, a: extended;

begin
  LogMin := Log10(GraphData.xMin);
  a := LogMin + x*(Log10(GraphData.xMax) - LogMin)/GLViewer.Width;
  Result := Power(10, a);
end;

function TMainForm.ValueLogY(const y: integer): extended;
var
  LogMax, a: extended;

begin
  LogMax := Log10(GraphData.yMax);
  a := LogMax + y*(Log10(GraphData.yMin) - LogMax)/GLViewer.Height;
  Result := Power(10, a);
end;



end.
