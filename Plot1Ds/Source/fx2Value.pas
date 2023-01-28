unit fx2Value;

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

  uGlobal,
  fFuncts;

type
  Tfx2ValueForm = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Editfx2: TEdit;
    ListBox1: TListBox;
    RecalcBtn: TBitBtn;
    CloseBtn: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure Editfx2KeyPress(Sender: TObject; var Key: Char);
    procedure Editfx2KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure RecalcBtnClick(Sender: TObject);
    procedure CloseBtnClick(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
  public
    DisplayOK: Boolean;
    fx2ValueToFind: extended;
    procedure ShowData;
  end;

var
  fx2ValueForm: Tfx2ValueForm;

//========================================================================
implementation
//========================================================================

uses
  fMain;

{$R *.dfm}

procedure Tfx2ValueForm.FormShow(Sender: TObject);
begin
  ShowData;
end;

procedure Tfx2ValueForm.FormActivate(Sender: TObject);
begin
  DisplayOK := true;
end;

procedure Tfx2ValueForm.FormDeactivate(Sender: TObject);
begin
  DisplayOK := false;
end;

procedure Tfx2ValueForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  with FunctionsForm.fx2Value do
  begin
    Checked := false;
    ImageIndex := 2;
  end;
end;

procedure Tfx2ValueForm.FormDestroy(Sender: TObject);
var
  i: integer;

begin
  with ListBox1 do
  begin
    for i := 0 to Count -1 do Items.Objects[i].Free;
    Clear;
  end;
end;

procedure Tfx2ValueForm.Editfx2KeyPress(Sender: TObject; var Key: Char);
begin
  with Sender as TEdit do
  if not CharInSet(Key, ['-', '0'..'9', '.', 'e', 'E', #8]) then Key := #0
end;

procedure Tfx2ValueForm.Editfx2KeyUp(Sender: TObject; var Key: Word;
                                       Shift: TShiftState);
begin
  try
    fx2ValueToFind := StrToFloat(Editfx2.Text);
  except
    fx2ValueToFind := 0;
  end;
end;

procedure Tfx2ValueForm.RecalcBtnClick(Sender: TObject);
var
  i: integer;

begin
  with ListBox1 do
  begin
    for i := 0 to Count -1 do Items.Objects[i].Free;
    Clear;
  end;
  MainForm.GLViewer.Invalidate;
end;

procedure Tfx2ValueForm.CloseBtnClick(Sender: TObject);
begin
  Close;
end;

procedure Tfx2ValueForm.ListBox1Click(Sender: TObject);
var
  w: word;
  i: integer;

begin
  with ListBox1 do if Count > 0 then
  begin
    if FunctionsForm.EditEvaluate.Visible then
    begin
      FunctionsForm.EditEvaluate.Text := Trim(Copy(Items[ItemIndex], 1, 24));
      for i := 0 to Count -1 do Items.Objects[i].Free;
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

procedure Tfx2ValueForm.ShowData;
var
  i: integer;

begin
  if GraphData.PlotData.TextStr = '' then Caption := ''
  else Caption := 'y = '+GraphData.PlotData.TextStr;
  Editfx2.Text := FloatToStr(fx2ValueToFind);
  with ListBox1 do
  begin
    for i := 0 to Count -1 do Items.Objects[i].Free;
    Clear;
  end;
  MainForm.GLViewer.Invalidate;
end;

end.
