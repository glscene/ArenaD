unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ExtDlgs, shellapi;

type
  TForm1 = class(TForm)
    image_anaglyphe: TImage;
    Panel1: TPanel;
    i1: TImage;
    i2: TImage;
    Button1: TButton;
    Label1: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    OpenPictureDialog1: TOpenPictureDialog;
    SavePictureDialog1: TSavePictureDialog;
    procedure Button1Click(Sender: TObject);
    procedure i1Click(Sender: TObject);
    procedure i2Click(Sender: TObject);
    procedure image_anaglypheClick(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure Label2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TRGBArray = array [0 .. 0] of TRGBTriple;
  pRGBArray = ^TRGBArray;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.i2Click(Sender: TObject);
begin
  if OpenPictureDialog1.Execute then
  begin
    i2.Picture.LoadFromFile(OpenPictureDialog1.FileName);
  end;
end;

procedure TForm1.image_anaglypheClick(Sender: TObject);
begin
  if SavePictureDialog1.Execute then
  begin
    image_anaglyphe.Picture.SaveToFile(SavePictureDialog1.FileName);
  end;
end;

procedure TForm1.Label1Click(Sender: TObject);
begin
  If (Sender is TLabel) then
    with (Sender as TLabel) do
      ShellExecute(Application.Handle, PChar('open'), PChar(Hint), PChar(0),
        nil, SW_NORMAL);
end;

procedure TForm1.Label2Click(Sender: TObject);
begin
  If (Sender is TLabel) then
    with (Sender as TLabel) do
      ShellExecute(Application.Handle, PChar('open'), PChar(Hint), PChar(0),
        nil, SW_NORMAL);
end;

procedure TForm1.i1Click(Sender: TObject);
begin
  if OpenPictureDialog1.Execute then
  begin
    i1.Picture.LoadFromFile(OpenPictureDialog1.FileName);
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  a1, ai: pRGBArray;
  R, G, B: integer;
  y, x: integer;
  h, w: integer;
  Anaglyphe: tbitmap;
begin
  try
    w := i2.Picture.Bitmap.Width;
    h := i2.Picture.Bitmap.Height;
    Anaglyphe := tbitmap.create;
    Anaglyphe.assign(i2.Picture.Bitmap);
    Anaglyphe.Width := w;
    Anaglyphe.Height := h;
    for y := 0 to h - 1 do
    begin
      a1 := Anaglyphe.scanline[y];
      ai := i1.Picture.Bitmap.scanline[y];

      for x := 0 to w - 1 do
      begin

        R := ai[x].RGBtRed;
        G := ai[x].RGBtGreen;
        B := ai[x].RGBtBlue;

        if R > 255 then
          R := 255
        else if R < 0 then
          R := 0;
        if G > 255 then
          G := 255
        else if G < 0 then
          G := 0;
        if B > 255 then
          B := 255
        else if B < 0 then
          B := 0;

        a1[x].RGBtRed := R;
      end;
    end;

    image_anaglyphe.Picture.Bitmap.assign(Anaglyphe);

  finally
    Anaglyphe.Free;
  end;

end;

end.
