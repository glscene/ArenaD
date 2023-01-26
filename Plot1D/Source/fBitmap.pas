unit fBitmap;

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
  Vcl.ExtDlgs,
  Vcl.Imaging.Jpeg,

  uGlobal;

type
  TBitmapForm = class(TForm)
    Label1: TLabel;
    EditScale: TEdit;
    UnitRG: TRadioGroup;
    Label2: TLabel;
    EditWidth: TEdit;
    Label3: TLabel;
    EditHeight: TEdit;
    OKBitBtn: TBitBtn;
    SavePictureDialog: TSavePictureDialog;
    WidthLabel: TLabel;
    HeightLabel: TLabel;
    ColorDialog: TColorDialog;
    Label6: TLabel;
    EditBorder: TEdit;
    ColorButton: TSpeedButton;
    CloseBitBtn: TBitBtn;
    Label4: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FloatKeyPress(Sender: TObject; var Key: Char);
    procedure ScaleKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure numKeyPress(Sender: TObject; var Key: Char);
    procedure WidthKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure HeightKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure UnitRGClick(Sender: TObject);
    procedure EditBorderKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure ColorButtonClick(Sender: TObject);
    procedure EditBorderKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure CloseBitBtnClick(Sender: TObject);
  private
    bmpScale: double;
    bmpWidth: integer;   { as pixels }
    bmpHeight: integer;  { as pixels }
    BorderWidth: integer;
    BorderColor: TColor;
    procedure ShowData(Sender: TObject);
    function PixelTomm(v: integer): double;
    function PixelTocm(v: integer): double;
    function PixelToInch(v: integer): double;
    function mmToPixel(v: double): integer;
    function cmToPixel(v: double): integer;
    function InchToPixel(v: double): integer;
  end;

var
  BitmapForm: TBitmapForm;

//=====================================================================
implementation
//=====================================================================

uses
  fMain;

{$R *.dfm}

procedure TBitmapForm.FormCreate(Sender: TObject);
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
      BorderWidth := 5;
    end
    else
    begin
      Left := BitmapLeft;
      Top := BitmapTop;
      UnitRG.ItemIndex := BitmapUnit;
      bmpScale := BitmapScale;
      BorderColor := BitmapBorderColor;
      BorderWidth := BitmapBorderWidth;
    end;
  end;
  bmpWidth := round(bmpScale*MainForm.GLViewer.Width);
  bmpHeight := round(bmpScale*MainForm.GLViewer.Height);

  ShowData(Sender);
end;

procedure TBitmapForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  BorderRect: TRect;
  GraphRect: TRect;
  bmp: TBitmap;
  jpg: TJPEGImage;
  filebmp: TBitmap;
  fName: TFileName;
  isJpeg: Boolean;

  function ScanText(const s: string): string;
  var
    i: integer;

  begin
    Result := s;
    for i := 1 to Length(s) do
    if CharInSet(Result[i], ['/', '\', ':', '*', '?', '<', '>', '|'])
    then Result[i] := ' ';
  end;

begin
  if ModalResult = mrOK then
  begin
    isJpeg := pos('.jpg', Caption) > 0;

    BorderRect := Rect(BorderWidth div 2, BorderWidth div 2,
                       bmpWidth - BorderWidth div 2 + 1,
                       bmpHeight - BorderWidth div 2 + 1);
    GraphRect := Rect(0, 0, bmpWidth - 2*BorderWidth,
                            bmpHeight - 2*BorderWidth);

    with SavePictureDialog do
    begin
      FName := ScanText(GraphData.PlotData.TextStr);

      if isJpeg then
      begin
        Filter := 'Jpeg (*.jpg)|*.jpg';
        Title := 'Save Graph as ''.jpg'' File';
        FileName := FName+'.jpg';
      end
      else
      begin
        Filter := 'Bitmaps (*.bmp)|*.bmp';
        Title := 'Save Graph as ''.bmp'' File';
        FileName := FName+'.bmp';
      end;

      InitialDir := ImagePath;
      if Execute then
      begin
        jpg := nil;
        if isJpeg then
        begin
          jpg := TJPEGImage.Create;
          jpg.CompressionQuality := 100;
        { default is 90; range 1..100; 100 best quality }
        end;
        bmp := TBitmap.Create;

        filebmp := TBitmap.Create;
        try
          bmp.PixelFormat := pf32bit;
        { bmp is a device-independent true-color 32 bits per pixel bitmap. }
          with GraphRect do
          begin
            bmp.Width := Right - Left;
            bmp.Height := Bottom - Top;
          end;

          filebmp.PixelFormat := pf32bit;
          with BorderRect do
          begin
            filebmp.Width := Right - Left + BorderWidth -1;
            filebmp.Height := Bottom - Top + BorderWidth -1;
          end;

          MainForm.GLViewer.Invalidate;;

          with MainForm.GLMemoryViewer do
          begin
            Width := bmp.Width;
            Height := bmp.Height;
            Buffer.BackgroundColor := GraphData.BackColor;
            Render;
            bmp := Buffer.CreateSnapShotBitmap;
          end;

          filebmp.Canvas.Pen.Color := BorderColor;
          filebmp.Canvas.Pen.Width := BorderWidth;
          filebmp.Canvas.Rectangle(BorderRect);
          filebmp.Canvas.Draw(BorderWidth, BorderWidth, bmp);
          if isJpeg then
          begin
            jpg.Assign(filebmp);
            jpg.SaveToFile(FileName);
          end
          else filebmp.SaveToFile(FileName);
        finally
          bmp.Free;
          filebmp.Free;
          if isJpeg then jpg.Free;
        end;
        ImagePath := ExtractFilePath(FileName);
        ImagePath := IncludeTrailingPathDelimiter(ImagePath);
      end;
    end;
  end;
  with Layout do
  begin
    BitmapLeft := Left;
    BitmapTop := Top;
    BitmapUnit := UnitRG.ItemIndex;
    BitmapScale := bmpScale;
    BitmapBorderColor := BorderColor;
    BitmapBorderWidth := BorderWidth;
  end;
end;

procedure TBitmapForm.FormShow(Sender: TObject);
begin
  UnitRG.SetFocus;
  UnitRG.ItemIndex := 0;
  UnitRGClick(Sender);
  EditScale.SetFocus;
end;

procedure TBitmapForm.ColorButtonClick(Sender: TObject);
begin
  ColorDialog.Color := BorderColor;
  if ColorDialog.Execute then BorderColor := ColorDialog.Color;
end;

procedure TBitmapForm.EditBorderKeyPress(Sender: TObject; var Key: Char);
begin
  if not CharInSet(Key, ['0'..'9', #8]) then Key := #0
end;

procedure TBitmapForm.EditBorderKeyUp(Sender: TObject; var Key: Word;
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

procedure TBitmapForm.FloatKeyPress(Sender: TObject; var Key: Char);
begin
  with Sender as TEdit do
  if not CharInSet(Key, ['0'..'9', '.', #8]) then Key := #0
end;

procedure TBitmapForm.ScaleKeyUp(Sender: TObject; var Key: Word;
                                 Shift: TShiftState);
begin
  try
    bmpScale := StrToFloat(EditScale.Text);
  except
    bmpScale := 1.0;
  end;
  bmpWidth := round(bmpScale*MainForm.GLViewer.Width);
  bmpHeight := round(bmpScale*MainForm.GLViewer.Height);
  ShowData(Sender);
end;

procedure TBitmapForm.numKeyPress(Sender: TObject; var Key: Char);
begin
  with Sender as TEdit do
  begin
    if UnitRG.ItemIndex = 0 then
    begin
      if not CharInSet(Key,['0'..'9', #8]) then Key := #0
    end
    else if not CharInSet(Key, ['0'..'9', '.', #8]) then Key := #0
  end;
end;

procedure TBitmapForm.WidthKeyUp(Sender: TObject; var Key: Word;
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
  1:bmpWidth := mmToPixel(v);
  2:bmpWidth := cmToPixel(v);
  3:bmpWidth := InchToPixel(v);
  end;
  bmpScale := bmpWidth/MainForm.GLViewer.Width;
  bmpHeight := round(bmpScale*MainForm.GLViewer.Height);
  ShowData(Sender);
end;

procedure TBitmapForm.HeightKeyUp(Sender: TObject; var Key: Word;
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
  1:bmpHeight := mmToPixel(v);
  2:bmpHeight := cmToPixel(v);
  3:bmpHeight := InchToPixel(v);
  end;
  bmpScale := bmpHeight/MainForm.GLViewer.Height;
  bmpWidth := round(bmpScale*MainForm.GLViewer.Width);
  ShowData(Sender);
end;

procedure TBitmapForm.UnitRGClick(Sender: TObject);
begin
  ShowData(Sender);
end;

procedure TBitmapForm.ShowData(Sender: TObject);
  procedure TagIsZero;
{ not a change in the edit fields: Scale Width or Height }
  begin   { TagIsZero }
    EditScale.Text := FloatToStrF(bmpScale, ffFixed, 8, 2);
    case UnitRg.ItemIndex of
    0:begin  { Pixels }
        EditWidth.Text := IntToStr(bmpWidth);
        EditHeight.Text := IntToStr(bmpHeight);
        WidthLabel.Caption := 'Pixels';
        HeightLabel.Caption := 'Pixels';
      end;
    1:begin  { mm }
        EditWidth.Text :=
            FloatToStrF(PixelTomm(bmpWidth), ffFixed, 8, 2);
        EditHeight.Text :=
            FloatToStrF(PixelTomm(bmpHeight), ffFixed, 8, 2);
        WidthLabel.Caption := 'mm';
        HeightLabel.Caption := 'mm';
      end;
    2:begin  { cm }
        EditWidth.Text :=
            FloatToStrF(PixelTocm(bmpWidth), ffFixed, 8, 2);
        EditHeight.Text :=
            FloatToStrF(PixelTocm(bmpHeight), ffFixed, 8, 2);
        WidthLabel.Caption := 'cm';
        HeightLabel.Caption := 'cm';
      end;
    3:begin  { inch }
        EditWidth.Text :=
            FloatToStrF(PixelToInch(bmpWidth), ffFixed, 8, 2);
        EditHeight.Text :=
            FloatToStrF(PixelToInch(bmpHeight), ffFixed, 8, 2);
        WidthLabel.Caption := 'inches';
        HeightLabel.Caption := 'inches';
      end;
    end;
  end;

begin
  if Sender is TEdit then
  begin
    with Sender as TEdit do
    case Tag of
    0:TagIsZero; { Factor }
    1:begin  { Scale }
        case UnitRg.ItemIndex of
        0:begin
            EditWidth.Text := IntToStr(bmpWidth);
            EditHeight.Text := IntToStr(bmpHeight);
          end;
        1:begin
            EditWidth.Text :=
                FloatToStrF(PixelTomm(bmpWidth), ffFixed, 8, 2);
            EditHeight.Text :=
                FloatToStrF(PixelTomm(bmpHeight), ffFixed, 8, 2);
          end;
        2:begin
            EditWidth.Text :=
                FloatToStrF(PixelTocm(bmpWidth), ffFixed, 8, 2);
            EditHeight.Text :=
                FloatToStrF(PixelTocm(bmpHeight), ffFixed, 8, 2);
          end;
        3:begin
            EditWidth.Text :=
                FloatToStrF(PixelToInch(bmpWidth), ffFixed, 8, 2);
            EditHeight.Text :=
                FloatToStrF(PixelToInch(bmpHeight), ffFixed, 8, 2);
          end;
        end;
      end;
    2:begin  { Width }
        EditScale.Text := FloatToStrF(bmpScale, ffFixed, 8, 2);
        case UnitRg.ItemIndex of
        0:EditHeight.Text := IntToStr(bmpHeight);
        1:EditHeight.Text :=
              FloatToStrF(PixelTomm(bmpHeight), ffFixed, 8, 2);
        2:EditHeight.Text :=
              FloatToStrF(PixelTocm(bmpHeight), ffFixed, 8, 2);
        3:EditHeight.Text :=
              FloatToStrF(PixelToInch(bmpHeight), ffFixed, 8, 2);
        end;
      end;
    3:begin  { Height }
        EditScale.Text := FloatToStrF(bmpScale, ffFixed, 8, 2);
        case UnitRg.ItemIndex of
        0:EditWidth.Text := IntToStr(bmpWidth);
        1:EditWidth.Text :=
              FloatToStrF(PixelTomm(bmpWidth), ffFixed, 8, 2);
        2:EditWidth.Text :=
              FloatToStrF(PixelTocm(bmpWidth), ffFixed, 8, 2);
        3:EditWidth.Text :=
              FloatToStrF(PixelToInch(bmpWidth), ffFixed, 8, 2);
        end;
      end;
    end;
  end
  else TagIsZero;  { UnitRG }
  EditBorder.Text := IntToStr(BorderWidth);
end;

function TBitmapForm.PixelTomm(v: integer): double;
begin
  Result := 25.4*v/Screen.PixelsPerInch;
end;



function TBitmapForm.PixelTocm(v: integer): double;
begin
  Result := 2.54*v/Screen.PixelsPerInch;
end;

function TBitmapForm.PixelToInch(v: integer): double;
begin
  Result := v/Screen.PixelsPerInch;
end;

function TBitmapForm.mmToPixel(v: double): integer;
begin
  Result := round(Screen.PixelsPerInch*v/25.4);
end;

procedure TBitmapForm.CloseBitBtnClick(Sender: TObject);
begin
  Close;
end;

function TBitmapForm.cmToPixel(v: double): integer;
begin
  Result := round(Screen.PixelsPerInch*v/2.54);
end;

function TBitmapForm.InchToPixel(v: double): integer;
begin
  Result := round(Screen.PixelsPerInch*v);
end;

end.
