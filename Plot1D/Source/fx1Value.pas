unit fx1Value;

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
  Vcl.Clipbrd,

  uGlobal;

type
  Tfx1ValueForm = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Editfx1: TEdit;
    ListBox1: TListBox;
    RecalcBtn: TBitBtn;
    CloseBtn: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure Editfx1KeyPress(Sender: TObject; var Key: Char);
    procedure Editfx1KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure RecalcBtnClick(Sender: TObject);
    procedure CloseBtnClick(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
  public
    DisplayOK: Boolean;
    fx1ValueToFind: extended;
    procedure ShowData;
  end;

var
  fx1ValueForm: Tfx1ValueForm;

//======================================================================
implementation
//======================================================================

uses
  fMain,
  fFuncts;

{$R *.dfm}

procedure Tfx1ValueForm.FormShow(Sender: TObject);
begin
  ShowData;
end;

procedure Tfx1ValueForm.FormActivate(Sender: TObject);
begin
  DisplayOK := true;
end;

procedure Tfx1ValueForm.FormDeactivate(Sender: TObject);
begin
  DisplayOK := false;
end;

procedure Tfx1ValueForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  with FunctionsForm.fx1Value do
  begin
    Checked := false;
    ImageIndex := 1;
  end;
end;

procedure Tfx1ValueForm.FormDestroy(Sender: TObject);
var
  i: integer;

begin
  with ListBox1 do
  begin
    for i := 0 to Count -1 do Items.Objects[i].Free;
    Clear;
  end;
end;

procedure Tfx1ValueForm.Editfx1KeyPress(Sender: TObject; var Key: Char);
begin
  with Sender as TEdit do
  if not CharInSet(Key, ['-', '0'..'9', '.', 'e', 'E', #8]) then Key := #0
end;

procedure Tfx1ValueForm.Editfx1KeyUp(Sender: TObject; var Key: Word;
                                       Shift: TShiftState);
begin
  try
    fx1ValueToFind := StrToFloat(Editfx1.Text);
  except
    fx1ValueToFind := 0;
  end;
end;

procedure Tfx1ValueForm.RecalcBtnClick(Sender: TObject);
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

procedure Tfx1ValueForm.CloseBtnClick(Sender: TObject);
begin
  Close;
end;

procedure Tfx1ValueForm.ListBox1Click(Sender: TObject);
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

procedure Tfx1Valueform.ShowData;
var
  i: integer;

begin
  if GraphData.PlotData.TextStr = '' then Caption := ''
  else Caption := 'y = '+GraphData.PlotData.TextStr;
  Editfx1.Text := FloatToStr(fx1ValueToFind);
  with ListBox1 do
  begin
    for i := 0 to Count -1 do Items.Objects[i].Free;
    Clear;
  end;
  MainForm.GLViewer.Invalidate;
end;

end.
