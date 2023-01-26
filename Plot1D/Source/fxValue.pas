unit fxValue;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Clipbrd,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.Buttons,

  uGlobal;

type
  TfxValueForm = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Editfx: TEdit;
    ListBox1: TListBox;
    RecalcBtn: TBitBtn;
    CloseBtn: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure EditfxKeyPress(Sender: TObject; var Key: Char);
    procedure EditfxKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure RecalcBtnClick(Sender: TObject);
    procedure CloseBtnClick(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
  public
    DisplayOK: Boolean;
    fxValueToFind: extended;
    procedure ShowData;
  end;

var
  fxValueForm: TfxValueForm;

// ==================================================================
implementation
// ==================================================================

uses
  fMain,
  fFuncts;

{$R *.dfm}

procedure TfxValueForm.FormShow(Sender: TObject);
begin
  ShowData;
end;

procedure TfxValueForm.FormActivate(Sender: TObject);
begin
  DisplayOK := true;
end;

procedure TfxValueForm.FormDeactivate(Sender: TObject);
begin
  DisplayOK := false;
end;

procedure TfxValueForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  with FunctionsForm.fxValue do
  begin
    Checked := false;
    ImageIndex := 0;
  end;
end;

procedure TfxValueForm.FormDestroy(Sender: TObject);
var
  i: integer;

begin
  with ListBox1 do
  begin
    for i := 0 to Count - 1 do
      Items.Objects[i].Free;
    Clear;
  end;
end;

procedure TfxValueForm.EditfxKeyPress(Sender: TObject; var Key: Char);
begin
  with Sender as TEdit do
    if not CharInSet(Key, ['-', '0' .. '9', '.', 'e', 'E', #8]) then
      Key := #0
end;

procedure TfxValueForm.EditfxKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  try
    fxValueToFind := StrToFloat(Editfx.Text);
  except
    fxValueToFind := 0;
  end;
end;

procedure TfxValueForm.RecalcBtnClick(Sender: TObject);
var
  i: integer;

begin
  with ListBox1 do
  begin
    for i := 0 to Count - 1 do
      Items.Objects[i].Free;
    Clear;
  end;
  MainForm.GLViewer.Invalidate;
end;

procedure TfxValueForm.CloseBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TfxValueForm.ListBox1Click(Sender: TObject);
var
  w: Word;
  i: integer;

begin
  with ListBox1 do
    if Count > 0 then
    begin
      if FunctionsForm.EditEvaluate.Visible then
      begin
        FunctionsForm.EditEvaluate.Text := Trim(Copy(Items[ItemIndex], 1, 24));
        for i := 0 to Count - 1 do
          Items.Objects[i].Free;
        Clear;
        FunctionsForm.EvaluateKeyUp(Sender, w, []);
      end
      else
      begin
        Clipboard.Clear;
        Clipboard.AsText := Trim(Copy(Items[ItemIndex], 1, 24));
      end;
    end;
end;

procedure TfxValueForm.ShowData;
var
  i: integer;

begin
  if GraphData.PlotData.TextStr = '' then
    Caption := ''
  else
    Caption := 'y = ' + GraphData.PlotData.TextStr;
  Editfx.Text := FloatToStr(fxValueToFind);
  for i := 0 to ListBox1.Count - 1 do
    ListBox1.Items.Objects[i].Free;
  ListBox1.Clear;
  MainForm.GLViewer.Invalidate;
end;

end.
