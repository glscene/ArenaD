unit uDados;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.Math,
  System.IniFiles,
  Vcl.ExtCtrls,
  Vcl.Menus,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  GLTexture,
  GLScene,
  GLObjects,
  GLWin32Viewer,
  GLFileTGA,
  GLCadencer,
  GLMaterial,
  GLCoordinates,
  GLCrossPlatform,
  GLBaseClasses;

type
  TRGBArray = array [0 .. 32767] of TRGBTriple;
  PRGBArray = ^TRGBArray;

  TForm1 = class(TForm)
    GLScene1: TGLScene;
    GLSceneViewer1: TGLSceneViewer;
    GLCamera1: TGLCamera;
    GLDummyCube1: TGLDummyCube;
    GLPlane1: TGLPlane;
    GLMaterialLibrary1: TGLMaterialLibrary;
    GLLightSource1: TGLLightSource;
    GLPlane2: TGLPlane;
    GLPlane3: TGLPlane;
    GLPlane4: TGLPlane;
    Timer1: TTimer;
    PopupMenu1: TPopupMenu;
    Close1: TMenuItem;
    procedure GLSceneViewer1MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure Timer1Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure GLSceneViewer1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SalvarConfig;
    procedure CarregarConfig;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Close1Click(Sender: TObject);
  private
    FRegion: THandle;
    function CreateRegion(Bmp: TBitmap): THandle;
  public
  end;

var
  Form1: TForm1;
  mdx, mdy: Integer;
  Ponto: TPoint;
  DifX, DifY: Integer;

implementation

{$R *.dfm}

procedure TForm1.CarregarConfig;
var
  IniFile: TIniFile;
begin
  IniFile := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'Configs.ini');
  // Upload Content
  Form1.Top := Strtoint(IniFile.ReadString('CONFIG', 'Top', ''));
  Form1.Left := Strtoint(IniFile.ReadString('CONFIG', 'Left', ''));
end;

procedure TForm1.SalvarConfig;
var
  IniFile: TIniFile;
begin
  IniFile := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'Configs.ini');
  // Save Content
  IniFile.WriteString('CONFIG', 'Top', inttostr(Form1.Top));
  IniFile.WriteString('CONFIG', 'Left', inttostr(Form1.Left));
end;

procedure TForm1.GLSceneViewer1MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  { if Shift<>[] then
    GLCamera1.MoveAroundTarget(mdy-y, mdx-x);
    mdx:=x; mdy:=y; }

  if GetAsyncKeyState(VK_LBUTTON) < 0 then
  begin
    Screen.Cursor := crHandPoint;
    GetCursorPos(Ponto);
    Form1.Top := Ponto.Y - DifY;
    Form1.Left := Ponto.X - DifX;
  end
  else
    Screen.Cursor := crDefault;
end;

function TForm1.CreateRegion(Bmp: TBitmap): THandle;
var
  X, Y, StartX: Integer;
  Cool: TPoint;
  Excl: THandle;
  Row: PRGBArray;
  TransparentColor: TRGBTriple;
begin
  Bmp.PixelFormat := pf24Bit;
  GetCursorPos(Cool);
  Cool.X := Bmp.Height;
  Cool.Y := Bmp.Width;
  Result := CreateRectRGN(0, 0, Bmp.Width, Bmp.Height);

  for Y := 0 to Bmp.Height - 1 do
  begin
    Row := Bmp.Scanline[Y];
    StartX := -1;
    if Y = 0 then
    begin
      TransparentColor := Row[0];
    end;

    for X := 0 to Bmp.Width - 1 do
    begin
      if (Row[X].rgbtRed = TransparentColor.rgbtRed) and
        (Row[X].rgbtGreen = TransparentColor.rgbtGreen) and
        (Row[X].rgbtBlue = TransparentColor.rgbtBlue) then
      begin
        if StartX = -1 then
          StartX := X;
      end
      else
      begin
        if StartX > -1 then
        begin
          Excl := CreateRectRGN(StartX, Y, X, Y + 1);
          try
            CombineRGN(Result, Result, Excl, RGN_DIFF);
            StartX := -1;
          finally
            DeleteObject(Excl);
          end;
        end;
      end;
    end;

    if StartX > -1 then
    begin
      Excl := CreateRectRGN(StartX, Y, Bmp.Width, Y + 1);
      try
        CombineRGN(Result, Result, Excl, RGN_DIFF);
      finally
        DeleteObject(Excl);
      end;
    end;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  Bmp: TBitmap;
begin
  CarregarConfig;
  Timer1Timer(self);
  Bmp := TBitmap.Create;
  try
    Bmp.LoadFromFile('RelogioMask.bmp');
    FRegion := CreateRegion(Bmp);
    SetWindowRGN(Handle, FRegion, True);
    Application.ProcessMessages;
  finally
    Bmp.Free;
  end;

  GLMaterialLibrary1.Materials[0].Material.Texture.Image.LoadFromFile
    ('relogio.tga');
  GLMaterialLibrary1.Materials[1].Material.Texture.Image.LoadFromFile
    ('ponteiro.tga');
  GLMaterialLibrary1.Materials[2].Material.Texture.Image.LoadFromFile
    ('ponteirofino.tga');
end;

procedure TForm1.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
var
  f: Single;
begin
  if (WheelDelta > 0) or (GLCamera1.Position.VectorLength > 0.90) then
  begin
    f := Power(1.05, WheelDelta * (1 / 120));
    GLCamera1.AdjustDistanceToTarget(f);
  end;
  Handled := True;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  Present: TDateTime;
  Hour, Min, Sec, MSec: Word;
begin
  Present := Now;
  DecodeTime(Present, Hour, Min, Sec, MSec);
  GLPlane4.RollAngle := -6 * Sec;
  GLPlane2.RollAngle := -(6 * Min) - (Sec / 20);
  GLPlane3.RollAngle := -(30 * (Hour mod 12)) - (Min / 2);
end;

procedure TForm1.FormShow(Sender: TObject);
var
  H: HWnd;
begin
  H := FindWindow(Nil, 'Relogio3D');
  { torque project1 by the name of your project }
  if H <> 0 then
    ShowWindow(H, SW_HIDE);
end;

procedure TForm1.GLSceneViewer1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Screen.Cursor := crHandPoint;
  GetCursorPos(Ponto);
  DifY := Ponto.Y - Form1.Top;
  DifX := Ponto.X - Form1.Left;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SalvarConfig;
end;

procedure TForm1.Close1Click(Sender: TObject);
begin
  Close;
end;

end.
