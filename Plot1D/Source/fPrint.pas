unit fPrint;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.Buttons,
  Vcl.ExtCtrls,
  Vcl.Printers,

  uGlobal;

type
  TPrintForm = class(TForm)
    Panel: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    EditScale: TEdit;
    EditLeft: TEdit;
    EditTop: TEdit;
    EditWidth: TEdit;
    EditHeight: TEdit;
    UnitRG: TRadioGroup;
    CloseBitBtn: TBitBtn;
    OKBitBtn: TBitBtn;
    Image: TImage;
    FitToPageButton: TSpeedButton;
    PageCentreButton: TSpeedButton;
    ColorDialog: TColorDialog;
    ColorButton: TSpeedButton;
    Label6: TLabel;
    EditBorder: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FloatKeyPress(Sender: TObject; var Key: Char);
    procedure ScaleKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure numKeyPress(Sender: TObject; var Key: Char);
    procedure LeftKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure TopKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure WidthKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure HeightKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure UnitRGClick(Sender: TObject);
    procedure FitToPageButtonClick(Sender: TObject);
    procedure PageCentreButtonClick(Sender: TObject);
    procedure ColorButtonClick(Sender: TObject);
    procedure CloseBitBtnClick(Sender: TObject);
    procedure EditBorderKeyPress(Sender: TObject; var Key: Char);
    procedure EditBorderKeyUp(Sender: TObject; var Key: Word;
                              Shift: TShiftState);
  private
    bmpScale: double;
    bmpLeft: integer;    { as pixels }
    bmpTop: integer;     { as pixels }
    bmpWidth: integer;   { as pixels }
    bmpHeight: integer;  { as pixels }
    BorderWidth: integer;
    BorderColor: TColor;
    vubmp: TBitMap;
    procedure PaintImage;
    procedure ShowData(Sender: TObject);
    function PixelTomm(const v, t: integer): double;
    function PixelTocm(const v, t: integer): double;
    function PixelToInch(const v, t: integer): double;
    function mmToPixel(const v: double; const t: integer): integer;
    function cmToPixel(const v: double; const t: integer): integer;
    function InchToPixel(const v: double; const t: integer): integer;
  end;

var
  PrintForm: TPrintForm;

//========================================================================
implementation
//========================================================================

uses
  fMain;

{$R *.dfm}

procedure TPrintForm.FormCreate(Sender: TObject);
begin
  with Layout do
  begin
    if bmpScale = 0 then
    begin
      Left := (Screen.Width - Width) div 2;
      Top := (Screen.Height - Height) div 2;
      UnitRG.ItemIndex := 0;
      bmpScale := 1;
      BorderColor := ClRed;
      BorderWidth := 10;
    end
    else
    begin
      Left := PrintLeft;
      Top := PrintTop;
      UnitRG.ItemIndex := PrintUnit;
      bmpScale := PrintScale;
      BorderColor := PrintBorderColor;
      BorderWidth := PrintBorderWidth;
    end;
  end;

  bmpWidth := round(bmpScale*MainForm.GLViewer.Width);
  bmpHeight := round(bmpScale*MainForm.GLViewer.Height);

  ShowData(Sender);
  vubmp := TBitMap.Create;
  vubmp.Width := Image.Width;
  vubmp.Height := Image.Height;
end;

procedure TPrintForm.FormShow(Sender: TObject);
begin
  with MainForm.GLMemoryViewer do
  begin
    Width := vubmp.Width;
    Height := vubmp.Height;
    Buffer.BackgroundColor := GraphData.BackColor;
    Render;
    vubmp := Buffer.CreateSnapShotBitmap;
  end;
  UnitRG.SetFocus;
  UnitRG.ItemIndex := 0;
  UnitRGClick(Sender);
  EditScale.SetFocus;
end;

procedure TPrintForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  BorderRect: TRect;
  GraphRect: TRect;
  bmp: TBitmap;

begin
  if ModalResult = mrOK then
  begin
    BorderRect := Rect(bmpLeft + BorderWidth div 2, bmpTop + BorderWidth div 2,
                       bmpLeft + bmpWidth - BorderWidth div 2 + 1,
                       bmpTop + bmpHeight - BorderWidth div 2 + 1);
    GraphRect := Rect(0, 0, bmpWidth - 2*BorderWidth,
                            bmpHeight - 2*BorderWidth);

    Printer.Title := MainForm.Caption;
    Printer.BeginDoc;
    bmp := TBitmap.Create;
    try
      bmp.PixelFormat := pf32bit;
    { bmp is a device-independent true-color 32 bits per pixel bitmap. }
      with GraphRect do
      begin
        bmp.Width := Right - Left;
        bmp.Height := Bottom - Top;
      end;

      with MainForm.GLMemoryViewer do
      begin
        Width := bmp.Width;
        Height := bmp.Height;
        Buffer.BackgroundColor := GraphData.BackColor;
        Render;
        bmp := Buffer.CreateSnapShotBitmap;
      end;

      Printer.Canvas.Pen.Color := BorderColor;
      Printer.Canvas.Pen.Width := BorderWidth;
      Printer.Canvas.Rectangle(BorderRect);
      Printer.Canvas.Draw(bmpLeft + BorderWidth, bmpTop + BorderWidth, bmp);
    finally
      Printer.EndDoc;
      bmp.Free;
    end;
  end;
  vubmp.Free;
  with Layout do
  begin
    PrintLeft := Left;
    PrintTop := Top;
    PrintUnit := UnitRG.ItemIndex;
    PrintScale := bmpScale;
    PrintBorderColor := BorderColor;
    PrintBorderWidth := BorderWidth;
  end;
end;

procedure TPrintForm.FloatKeyPress(Sender: TObject; var Key: Char);
begin
  with Sender as TEdit do
  if not CharInSet(Key, ['0'..'9', '.', #8]) then Key := #0
end;

procedure TPrintForm.ScaleKeyUp(Sender: TObject; var Key: Word;
                                Shift: TShiftState);
begin
  try
    bmpScale := StrToFloat(EditScale.Text);
  except
    bmpScale := 1.0;
  end;

  bmpWidth := round(bmpScale*MainForm.GLViewer.Width);
  if bmpWidth > PrinterInfo.xRes then
  begin
    bmpWidth := PrinterInfo.xRes;
    bmpScale := bmpWidth/MainForm.GLViewer.Width;
    bmpHeight := round(bmpScale*MainForm.GLViewer.Height);
    ShowData(Sender);
    Exit;
  end;

  bmpHeight := round(bmpScale*MainForm.GLViewer.Height);
  if bmpHeight > PrinterInfo.yRes then
  begin
    bmpHeight := PrinterInfo.yRes;
    bmpScale := bmpHeight/MainForm.GLViewer.Height;
    bmpWidth := round(bmpScale*MainForm.GLViewer.Width);
    ShowData(Sender);
    Exit;
  end;
  ShowData(Sender);
end;

procedure TPrintForm.numKeyPress(Sender: TObject; var Key: Char);
begin
  with Sender as TEdit do
  begin
    if UnitRG.ItemIndex = 0 then
    begin
      if not CharInSet(Key, ['0'..'9', #8]) then Key := #0
    end
    else if not CharInSet(Key, ['0'..'9', '.', #8]) then Key := #0
  end;
end;

procedure TPrintForm.LeftKeyUp(Sender: TObject; var Key: Word;
                               Shift: TShiftState);
var
  v: double;

begin
  try
    v := StrToFloat(EditLeft.Text);
  except
    v := 10;
  end;
  case UnitRG.ItemIndex of
  0:bmpLeft := round(v);
  1:bmpLeft := mmToPixel(v, 0);
  2:bmpLeft := cmToPixel(v, 0);
  3:bmpLeft := InchToPixel(v, 0);
  end;
  ShowData(Sender);
end;

procedure TPrintForm.TopKeyUp(Sender: TObject; var Key: Word;
                              Shift: TShiftState);
var
  v: double;

begin
  try
    v := StrToFloat(EditTop.Text);
  except
    v := 10;
  end;
  case UnitRG.ItemIndex of
  0:bmpTop := round(v);
  1:bmpTop := mmToPixel(v, 0);
  2:bmpTop := cmToPixel(v, 0);
  3:bmpTop := InchToPixel(v, 0);
  end;
  ShowData(Sender);
end;

procedure TPrintForm.WidthKeyUp(Sender: TObject; var Key: Word;
                                Shift: TShiftState);
var
  v: double;

begin
  try
    v := StrToFloat(EditWidth.Text);
  except
    v := bmpScale*MainForm.GLViewer.Width;
  end;
  case UnitRG.ItemIndex of
  0:bmpWidth := round(v);
  1:bmpWidth := mmToPixel(v, 0);
  2:bmpWidth := cmToPixel(v, 0);
  3:bmpWidth := InchToPixel(v, 0);
  end;
  if bmpWidth > PrinterInfo.xRes then
  begin
    bmpWidth := PrinterInfo.xRes;
  end;
  bmpScale := bmpWidth/MainForm.GLViewer.Width;
  bmpHeight := round(bmpScale*MainForm.GLViewer.Height);
  ShowData(Sender);
end;    { TPrintForm.WidthKeyUp }

procedure TPrintForm.HeightKeyUp(Sender: TObject; var Key: Word;
                                 Shift: TShiftState);
var
  v: double;

begin
  try
    v := StrToFloat(EditHeight.Text);
  except
    v := bmpScale*MainForm.GLViewer.Height;
  end;
  case UnitRG.ItemIndex of
  0:bmpHeight := round(v);
  1:bmpHeight := mmToPixel(v, 0);
  2:bmpHeight := cmToPixel(v, 0);
  3:bmpHeight := InchToPixel(v, 0);
  end;
  if bmpHeight > PrinterInfo.yRes then
  begin
    bmpHeight := PrinterInfo.yRes;
  end;
  bmpScale := bmpHeight/MainForm.GLViewer.Height;
  bmpWidth := round(bmpScale*MainForm.GLViewer.Width);
  ShowData(Sender);
end;

procedure TPrintForm.UnitRGClick(Sender: TObject);
begin
  ShowData(Sender);
end;

procedure TPrintForm.FitToPageButtonClick(Sender: TObject);
var
  i: integer;

begin
  UnitRG.SetFocus;
  i := UnitRG.ItemIndex;
  UnitRG.ItemIndex := 0;

  bmpScale := 1;
  bmpLeft := 0;
  bmpTop := 0;
  bmpHeight := MainForm.GLViewer.Height;
  bmpWidth := MainForm.GLViewer.Width;

  bmpWidth := Printer.PageWidth - 2*bmpLeft;
  bmpScale := bmpWidth/MainForm.GLViewer.Width;
  bmpHeight := round(bmpScale*MainForm.GLViewer.Height);

  if bmpHeight > Printer.PageHeight - 2*bmpTop then
  begin
    bmpHeight := Printer.PageHeight - 2*bmpTop;
    bmpScale := bmpHeight/MainForm.GLViewer.Height;
    bmpWidth := round(bmpScale*MainForm.GLViewer.Width);
  end;

  ShowData(Sender);
  UnitRG.SetFocus;
  UnitRG.ItemIndex := i
end;

procedure TPrintForm.PageCentreButtonClick(Sender: TObject);
var
  i: integer;

begin
  UnitRG.SetFocus;
  i := UnitRG.ItemIndex;
  UnitRG.ItemIndex := 0;
  if bmpLeft + bmpWidth > Printer.PageWidth then bmpLeft := 0;
  if bmpTop + bmpHeight > Printer.PageHeight then bmpTop := 0;
  if bmpWidth > Printer.PageWidth then
  begin
    bmpWidth := Printer.PageWidth;
    bmpScale := bmpWidth/MainForm.GLViewer.Width;
    bmpHeight := round(bmpScale*MainForm.GLViewer.Height);
  end;
  if bmpHeight > Printer.PageHeight then
  begin
    bmpHeight := Printer.PageHeight;
    bmpScale := bmpHeight/MainForm.GLViewer.Height;
    bmpWidth := round(bmpScale*MainForm.GLViewer.Width);
  end;
  bmpLeft := (Printer.PageWidth - bmpWidth) div 2;
  bmpTop := (Printer.PageHeight - bmpHeight) div 2;
  ShowData(Sender);
  UnitRG.SetFocus;
  UnitRG.ItemIndex := i
end;

procedure TPrintForm.ColorButtonClick(Sender: TObject);
begin
  ColorDialog.Color := BorderColor;
  if ColorDialog.Execute then
  begin
    BorderColor := ColorDialog.Color;
    PaintImage;
  end;
end;

procedure TPrintForm.EditBorderKeyPress(Sender: TObject; var Key: Char);
begin
  if not CharInSet(Key, ['0'..'9', #8]) then Key := #0
end;

procedure TPrintForm.EditBorderKeyUp(Sender: TObject; var Key: Word;
                                     Shift: TShiftState);
var
  v: integer;
begin
  try
    v := StrToInt(EditBorder.Text);
  except
    v := 10;
  end;
  BorderWidth := v;
  ShowData(Sender);
end;

procedure TPrintForm.PaintImage;
var
  PaperWidthPix: integer;
  PaperHeightPix: integer;
  PrintAreaWidthPix: integer;
  PrintAreaHeightPix: integer;
  dx, dy: integer;
  Scale: double;
  Shade: TRect;
  Paper: TRect;
  PrintArea: TRect;
  Graph: TRect;

begin
{ calculations }
  PaperWidthPix := PrinterInfo.xRes+2*PrinterInfo.xOffset;
  PaperHeightPix := PrinterInfo.yRes+2*PrinterInfo.yOffset;

  if PaperWidthPix > PaperHeightPix
  then Scale := 0.95*Image.Width/PaperWidthPix
  else Scale := 0.95*Image.Height/PaperHeightPix;

  PaperHeightPix := round(Scale*PaperHeightPix);
  PaperWidthPix := round(Scale*PaperWidthPix);

  PrintAreaWidthPix := round(Scale*PrinterInfo.xRes);
  PrintAreaHeightPix := round(Scale*PrinterInfo.yRes);

  Paper.Top := (Image.Height - PaperHeightPix) div 2 - 3;
  Paper.Left := (Image.Width - PaperWidthPix) div 2 - 3;
  Paper.Bottom := Paper.Top + PaperHeightPix;
  Paper.Right := Paper.Left + PaperWidthPix;

  dx := round(Scale*PrinterInfo.xOffset);
  dy := round(Scale*PrinterInfo.yOffset);

  PrintArea.Top := Paper.Top + dy;
  PrintArea.Left := Paper.Left + dx;
  PrintArea.Bottom := PrintArea.Top + PrintAreaHeightPix;
  PrintArea.Right := PrintArea.Left + PrintAreaWidthPix;

  Shade := Paper;
  Inc(Shade.Top, 6);
  Inc(Shade.Left, 6);
  Inc(Shade.Bottom, 6);
  Inc(Shade.Right, 6);

  if bmpWidth < 100 then bmpWidth := 100;
  if bmpHeight < 100 then bmpHeight := 100;

  Graph.Left := PrintArea.Left + round(Scale*bmpLeft);
  Graph.Top := PrintArea.Top + round(Scale*bmpTop);
  Graph.Right := Graph.Left + round(Scale*bmpWidth);
  Graph.Bottom := Graph.Top + round(Scale*bmpHeight);

  with Image.Canvas do
  begin
    with Brush do
    begin
      Style := bsSolid;
      Color := clCream;
    end;
    FillRect(Rect(0, 0, Image.Width, Image.Height));

    Brush.Color := clSilver;
    Pen.Color := clBlack;
    FillRect(Shade);

    Brush.Color := clWhite;
    FillRect(Paper);
    Rectangle(Paper);

    Pen.Color := clBlue;
    Rectangle(PrintArea);

    StretchDraw(Graph, vubmp);
    if BorderWidth > 0 then
    begin
      Brush.Color := BorderColor;
      FrameRect(Graph);
    end;
  end;
end;

procedure TPrintForm.ShowData(Sender: TObject);
  procedure TagIsZero;
  begin
    EditScale.Text := FloatToStrF(bmpScale, ffFixed, 6, 3);
    case UnitRg.ItemIndex of
    0:begin  { pixels }
        EditLeft.Text := IntToStr(bmpLeft);
        EditTop.Text := IntToStr(bmpTop);
        EditWidth.Text := IntToStr(bmpWidth);
        EditHeight.Text := IntToStr(bmpHeight);
      end;
    1:begin  { mm }
        EditLeft.Text :=
         FloatToStrF(PixelTomm(bmpLeft, 0), ffFixed, 6, 3);
        EditTop.Text :=
         FloatToStrF(PixelTomm(bmpTop, 0), ffFixed, 6, 3);
        EditWidth.Text :=
         FloatToStrF(PixelTomm(bmpWidth, 0), ffFixed, 6, 3);
        EditHeight.Text :=
         FloatToStrF(PixelTomm(bmpHeight, 0), ffFixed, 6, 3);
      end;
    2:begin  { cm }
        EditLeft.Text :=
         FloatToStrF(PixelTocm(bmpLeft, 0), ffFixed, 6, 3);
        EditTop.Text :=
         FloatToStrF(PixelTocm(bmpTop, 0), ffFixed, 6, 3);
        EditWidth.Text :=
         FloatToStrF(PixelTocm(bmpWidth, 0), ffFixed, 6, 3);
        EditHeight.Text :=
         FloatToStrF(PixelTocm(bmpHeight, 0), ffFixed, 6, 3);
      end;
    3:begin  { inch }
        EditLeft.Text :=
         FloatToStrF(PixelToInch(bmpLeft, 0), ffFixed, 6, 3);
        EditTop.Text :=
         FloatToStrF(PixelToInch(bmpTop, 0), ffFixed, 6, 3);
        EditWidth.Text :=
         FloatToStrF(PixelToInch(bmpWidth, 0), ffFixed, 6, 3);
        EditHeight.Text :=
         FloatToStrF(PixelToInch(bmpHeight, 0), ffFixed, 6, 3);
      end;
    end;
  end;    { TagIsZero }

begin
  if Sender is TEdit then
  begin
    with Sender as TEdit do
    case Tag of
    0:TagIsZero; { Factor etc. }
    1:begin  { Scale }
        case UnitRg.ItemIndex of
        0:begin  { pixels }
            EditLeft.Text := IntToStr(bmpLeft);
            EditTop.Text := IntToStr(bmpTop);
            EditWidth.Text := IntToStr(bmpWidth);
            EditHeight.Text := IntToStr(bmpHeight);
          end;
        1:begin  { mm }
            EditLeft.Text :=
             FloatToStrF(PixelTomm(bmpLeft, Tag), ffFixed, 6, 3);
            EditTop.Text :=
             FloatToStrF(PixelTomm(bmpTop, Tag), ffFixed, 6, 3);
            EditWidth.Text :=
             FloatToStrF(PixelTomm(bmpWidth, Tag), ffFixed, 6, 3);
            EditHeight.Text :=
             FloatToStrF(PixelTomm(bmpHeight, Tag), ffFixed, 6, 3);
          end;
        2:begin  { cm }
            EditLeft.Text :=
             FloatToStrF(PixelTocm(bmpLeft, Tag), ffFixed, 6, 3);
            EditTop.Text :=
             FloatToStrF(PixelTocm(bmpTop, Tag), ffFixed, 6, 3);
            EditWidth.Text :=
             FloatToStrF(PixelTocm(bmpWidth, Tag), ffFixed, 6, 3);
            EditHeight.Text :=
             FloatToStrF(PixelTocm(bmpHeight, Tag), ffFixed, 6, 3);
          end;
        3:begin  { inch }
            EditLeft.Text :=
             FloatToStrF(PixelToInch(bmpLeft, Tag), ffFixed, 6, 3);
            EditTop.Text :=
             FloatToStrF(PixelToInch(bmpTop, Tag), ffFixed, 6, 3);
            EditWidth.Text :=
             FloatToStrF(PixelToInch(bmpWidth, Tag), ffFixed, 6, 3);
            EditHeight.Text :=
             FloatToStrF(PixelToInch(bmpHeight, Tag), ffFixed, 6, 3);
          end;
        end;
      end;
    4:begin  { Width }
        EditScale.Text := FloatToStrF(bmpScale, ffFixed, 6, 3);
        case UnitRg.ItemIndex of
        0:EditHeight.Text := IntToStr(bmpHeight);
        1:begin  { mm }
            EditLeft.Text :=
             FloatToStrF(PixelTomm(bmpLeft, Tag), ffFixed, 6, 3);
            EditTop.Text :=
             FloatToStrF(PixelTomm(bmpTop, Tag), ffFixed, 6, 3);
            EditHeight.Text :=
             FloatToStrF(PixelTomm(bmpHeight, Tag), ffFixed, 6, 3);
          end;
        2:begin  { cm }
            EditLeft.Text :=
             FloatToStrF(PixelTocm(bmpLeft, Tag), ffFixed, 6, 3);
            EditTop.Text :=
             FloatToStrF(PixelTocm(bmpTop, Tag), ffFixed, 6, 3);
            EditHeight.Text :=
             FloatToStrF(PixelTocm(bmpHeight, Tag), ffFixed, 6, 3);
          end;
        3:begin  { inch }
            EditLeft.Text :=
             FloatToStrF(PixelToInch(bmpLeft, Tag), ffFixed, 6, 3);
            EditTop.Text :=
             FloatToStrF(PixelToInch(bmpTop, Tag), ffFixed, 6, 3);
            EditHeight.Text :=
             FloatToStrF(PixelToInch(bmpHeight, Tag), ffFixed, 6, 3);
          end;
        end;
      end;
    5:begin  { Height }
        EditScale.Text := FloatToStrF(bmpScale, ffFixed, 6, 3);
        case UnitRg.ItemIndex of
        0:EditWidth.Text := IntToStr(bmpWidth);
        1:begin  { mm }
            EditLeft.Text :=
             FloatToStrF(PixelTomm(bmpLeft, Tag), ffFixed, 6, 3);
            EditTop.Text :=
             FloatToStrF(PixelTomm(bmpTop, Tag), ffFixed, 6, 3);
            EditWidth.Text :=
             FloatToStrF(PixelTomm(bmpWidth, Tag), ffFixed, 6, 3);
          end;
        2:begin  { cm }
            EditLeft.Text :=
             FloatToStrF(PixelTocm(bmpLeft, Tag), ffFixed, 6, 3);
            EditTop.Text :=
             FloatToStrF(PixelTocm(bmpTop, Tag), ffFixed, 6, 3);
            EditWidth.Text :=
             FloatToStrF(PixelTocm(bmpWidth, Tag), ffFixed, 6, 3);
          end;
        3:begin  { inch }
            EditLeft.Text :=
             FloatToStrF(PixelToInch(bmpLeft, Tag), ffFixed, 6, 3);
            EditTop.Text :=
             FloatToStrF(PixelToInch(bmpTop, Tag), ffFixed, 6, 3);
            EditWidth.Text :=
             FloatToStrF(PixelToInch(bmpWidth, Tag), ffFixed, 6, 3);
          end;
        end;
      end;
    end;
  end
  else TagIsZero;  { UnitRG }
  EditBorder.Text := IntToStr(BorderWidth);
  PaintImage;
end;

function TPrintForm.PixelTomm(const v, t: integer): double;
begin
  if odd(t)
  then Result := 25.4*v/PrinterInfo.yPixPerInch
  else Result := 25.4*v/PrinterInfo.xPixPerInch;
end;

function TPrintForm.PixelTocm(const v, t: integer): double;
begin
  if odd(t)
  then Result := 2.54*v/PrinterInfo.yPixPerInch
  else Result := 2.54*v/PrinterInfo.xPixPerInch;
end;

function TPrintForm.PixelToInch(const v, t: integer): double;
begin
  if odd(t)
  then Result := v/PrinterInfo.yPixPerInch
  else Result := v/PrinterInfo.xPixPerInch;
end;

function TPrintForm.mmToPixel(const v: double; const t: integer): integer;
begin
  if odd(t)
  then Result := round(PrinterInfo.yPixPerInch*v/25.4)
  else Result := round(PrinterInfo.xPixPerInch*v/25.4);
end;

function TPrintForm.cmToPixel(const v: double; const t: integer): integer;
begin
  if odd(t)
  then Result := round(PrinterInfo.yPixPerInch*v/2.54)
  else Result := round(PrinterInfo.xPixPerInch*v/2.54);
end;

function TPrintForm.InchToPixel(const v: double; const t: integer): integer;
begin
  if odd(t)
  then Result := round(PrinterInfo.yPixPerInch*v)
  else Result := round(PrinterInfo.xPixPerInch*v);
end;

procedure TPrintForm.CloseBitBtnClick(Sender: TObject);
begin
  Close;
end;

end.
