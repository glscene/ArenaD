unit fDerivative;

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
  Vcl.Buttons,
  Vcl.ComCtrls,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,

  uGlobal;

type
  TDerivativeForm = class(TForm)
    Label1: TLabel;
    Edityfx1Pen: TEdit;
    UpDown1: TUpDown;
    SpeedButton1: TSpeedButton;
    Label2: TLabel;
    Edityfx2Pen: TEdit;
    UpDown2: TUpDown;
    SpeedButton2: TSpeedButton;
    BitBtn1: TBitBtn;
    ColorDialog: TColorDialog;
    Panel1: TPanel;
    Panel2: TPanel;
    procedure FormShow(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure IntKeyPress(Sender: TObject; var Key: Char);
    procedure Edityfx1PenKeyUp(Sender: TObject; var Key: Word;
                                Shift: TShiftState);
    procedure Edityfx2PenKeyUp(Sender: TObject; var Key: Word;
                                  Shift: TShiftState);
    procedure Edityfx1PenChange(Sender: TObject);
    procedure Edityfx2PenChange(Sender: TObject);
    procedure ColorClick(Sender: TObject);
  public
    procedure ShowData;
  end;

var
  DerivativeForm: TDerivativeForm;

//====================================================================
implementation
//====================================================================

uses
  fFuncts,
  fMain;

{$R *.dfm}

procedure TDerivativeForm.FormShow(Sender: TObject);
begin
  ShowData;
end;

procedure TDerivativeForm.BitBtn1Click(Sender: TObject);
begin
  Close;
end;

procedure TDerivativeForm.ShowData;
begin
  Label2.Visible := FunctionsForm.yfx2.Checked;
  Edityfx2Pen.Visible := Label2.Visible;
  UpDown2.Visible := Label2.Visible;
  SpeedButton2.Visible := Label2.Visible;
  Panel2.Visible := Label2.Visible;
  with GraphData do
  begin
    if PlotData.TextStr = '' then Caption := ''
    else Caption := 'y = '+PlotData.TextStr;
    Edityfx1Pen.Text := IntToStr(dydxWidth);
    Edityfx2Pen.Text := IntToStr(d2ydx2Width);
    UpDown1.Position := dydxWidth;
    UpDown2.Position := d2ydx2Width;
    Panel1.Color := dydxColor;
    Panel2.Color := d2ydx2Color;
    if PlotData.PlotAsFx then
    begin
      Label1.Caption := 'f ''(x) Pen Width:';
      Label2.Caption := 'f "(x) Pen Width:';
      SpeedButton1.Caption := 'f &''(x) Colour';
      SpeedButton2.Caption := '&f "(x) Colour';
    end
    else
    begin
      Label1.Caption := 'f ''(Ø) Pen Width:';
      Label2.Caption := 'f "(Ø) Pen Width:';
      SpeedButton1.Caption := 'f &''(Ø) Colour';
      SpeedButton2.Caption := '&f "(Ø) Colour';
    end;
  end;
  MainForm.GLViewer.Invalidate;
end;

procedure TDerivativeForm.ColorClick(Sender: TObject);
var
  i: integer;

begin
  with GraphData do
  begin
    if Sender.ClassType = TPanel
    then i := TPanel(Sender).Tag
    else i := TSpeedButton(Sender).Tag;

    case i of
    0:ColorDialog.Color := GraphData.dydxColor;
    1:ColorDialog.Color := GraphData.d2ydx2Color;
    end;
    if ColorDialog.Execute then
    begin
      case i of
      0:begin
          GraphData.dydxColor := ColorDialog.Color;
          Panel1.Color := ColorDialog.Color;
        end;
      1:begin
          GraphData.d2ydx2Color := ColorDialog.Color;
          Panel2.Color := ColorDialog.Color;
        end;
      end;
      Altered := true;
      MainForm.GLViewer.Invalidate;
    end;
  end;
end;

procedure TDerivativeForm.IntKeyPress(Sender: TObject; var Key: Char);
begin
  with Sender as TEdit do if not CharInset(Key, ['0'..'9', #8]) then Key := #0
end;

procedure TDerivativeForm.Edityfx1PenKeyUp(Sender: TObject; var Key: Word;
                                            Shift: TShiftState);
var
  x: integer;

begin
  try
    x := StrToInt(Edityfx1Pen.Text);
  except
    x := 1;
  end;
  if x < 1 then x := 1;
  GraphData.dydxWidth := x;
  Altered := true;
  MainForm.GLViewer.Invalidate;
end;

procedure TDerivativeForm.Edityfx2PenKeyUp(Sender: TObject; var Key: Word;
                                             Shift: TShiftState);
var
  x: integer;

begin
  try
    x := StrToInt(Edityfx2Pen.Text);
  except
    x := 1;
  end;
  if x < 1 then x := 1;
  GraphData.d2ydx2Width := x;
  Altered := true;
  MainForm.GLViewer.Invalidate;
end;

procedure TDerivativeForm.Edityfx1PenChange(Sender: TObject);
var
  k: word;
begin
  if Visible then
  begin
    k := 0;
    Edityfx1PenKeyUp(Sender, k, []);
  end;
end;

procedure TDerivativeForm.Edityfx2PenChange(Sender: TObject);
var
  k: word;

begin
  if Visible then
  begin
    k := 0;
    Edityfx2PenKeyUp(Sender, k, []);
  end;
end;

end.
