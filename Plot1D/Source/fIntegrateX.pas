unit fIntegrateX;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.Math,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.Buttons,
  Vcl.ComCtrls,
  Vcl.Menus,
  Vcl.ExtCtrls;

type
  TIntegrateXForm = class(TForm)
    Label3: TLabel;
    Label1: TLabel;
    Label4: TLabel;
    MinIntegXLabel: TLabel;
    Label6: TLabel;
    ColorButton: TSpeedButton;
    Label5: TLabel;
    AreaLabel: TLabel;
    Label7: TLabel;
    PositiveButton: TSpeedButton;
    NegativeButton: TSpeedButton;
    MaxIntegXLabel: TLabel;
    NegAreaLabel: TLabel;
    PosAreaLabel: TLabel;
    MinIntegYLabel: TLabel;
    MaxIntegYLabel: TLabel;
    TotalAreaLabel: TLabel;
    CentreButton: TSpeedButton;
    EditIntegMin: TEdit;
    EditIntegMax: TEdit;
    EditCount: TEdit;
    UpDown1: TUpDown;
    RecalcBtn: TBitBtn;
    CloseBtn: TBitBtn;
    EditPenWidth: TEdit;
    UpDown2: TUpDown;
    EditConst: TEdit;
    IntegCheckBox: TCheckBox;
    ShadeCheckBox: TCheckBox;
    EditOpacity: TEdit;
    UpDown3: TUpDown;
    ColorDialog: TColorDialog;
    Label2: TLabel;
    KeepRangeCheckBox: TCheckBox;
    ColorPanel: TPanel;
    NegativePanel: TPanel;
    PositivePanel: TPanel;
    SumAreaLabel: TLabel;
    procedure FormShow(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormDeactivate(Sender: TObject);

    procedure ParseKeyPress(Sender: TObject; var Key: Char);
    procedure IntKeyPress(Sender: TObject; var Key: Char);
    procedure EditIntegMinKeyUp(Sender: TObject; var Key: Word;
                                 Shift: TShiftState);
    procedure EditIntegMaxKeyUp(Sender: TObject; var Key: Word;
                                 Shift: TShiftState);
    procedure EditCountKeyUp(Sender: TObject; var Key: Word;
                              Shift: TShiftState);
    procedure EditConstKeyUp(Sender: TObject; var Key: Word;
                              Shift: TShiftState);
    procedure EditPenWidthKeyUp(Sender: TObject; var Key: Word;
                                 Shift: TShiftState);
    procedure EditOpacityKeyUp(Sender: TObject; var Key: Word;
                                Shift: TShiftState);
    procedure EditCountExit(Sender: TObject);

    procedure UpDown1Click(Sender: TObject; Button: TUDBtnType);
    procedure UpDown2Click(Sender: TObject; Button: TUDBtnType);
    procedure UpDown3Click(Sender: TObject; Button: TUDBtnType);
    procedure UpDown1MouseUp(Sender: TObject; Button: TMouseButton;
                              Shift: TShiftState; X, Y: Integer);

    procedure CheckBoxClick(Sender: TObject);
    procedure CentreButtonClick(Sender: TObject);
    procedure ColorButtonClick(Sender: TObject);
    procedure PositiveButtonClick(Sender: TObject);
    procedure NegativeButtonClick(Sender: TObject);
    procedure RecalcBtnClick(Sender: TObject);
    procedure CloseBtnClick(Sender: TObject);
    procedure IntegLabelClick(Sender: TObject);
    procedure KeepRangeCheckBoxClick(Sender: TObject);
  private
     
    procedure UpdateRangeData;
  public
     
    PlotIntegrated: byte; { piCalc = 0; piShow = 1; piArea = 2; piBoth = 3 }
    procedure ShowData;
  end;

var
  IntegrateXForm: TIntegrateXForm;

//======================================================================
implementation
//======================================================================

uses
  uParser,
  uGlobal,
  fFuncts,
  fMain,
  Clipbrd;

{$R *.dfm}

procedure TIntegrateXForm.FormShow(Sender: TObject);
begin
  KeepRangeCheckBox.Checked := KeepRange;
  ShowData;
end;

procedure TIntegrateXForm.FormActivate(Sender: TObject);
begin
  EditIntegMin.SetFocus;
  EditIntegMin.SelText;
end;

procedure TIntegrateXForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  case Key of
#13:begin
      RecalcBtnClick(Sender);
      Key := #0;
    end;
#27:begin
      Key := #0;
      Close;
    end;
  end;
end;

procedure TIntegrateXForm.FormDeactivate(Sender: TObject);
begin
  if KeepRange then UpdateRangeData;
end;

procedure TIntegrateXForm.ParseKeyPress(Sender: TObject; var Key: Char);
begin
  with Sender as TEdit do
  begin
    if not CharInSet(UpCase(Key),
   [' ', '!', '(', ')', '*', '+', '-', '.', ',', '/', '0'..'9',
    'A'..'C', 'E', 'G'..'I', 'L', 'N'..'T', 'X', '^', '`', #8]) then
    begin
      Key := #0;
      Exit;
    end;
    if Key = '`' then Key := '°';
  end;
end;

procedure TIntegrateXForm.IntKeyPress(Sender: TObject; var Key: Char);
begin
  with Sender as TEdit do
  if not CharInSet(Key, ['0'..'9', #8]) then Key := #0
end;

procedure TIntegrateXForm.EditIntegMinKeyUp(Sender: TObject; var Key: Word;
                                             Shift: TShiftState);
var
  s: string;
  e: byte;

begin
  s := ScanText(EditIntegMin.Text);
  IntegMin := ParseAndEvaluate(s, e);
//if isNAN(IntegMin) then IntegMin := 0;
//if e > 0 then IntegMin := 0;
  if isNAN(IntegMin) or isInfinite(IntegMin) or (e > 0) then IntegMin := 0;
end;

procedure TIntegrateXForm.EditIntegMaxKeyUp(Sender: TObject; var Key: Word;
                                             Shift: TShiftState);
var
  s: string;
  e: byte;

begin
  s := ScanText(EditIntegMax.Text);
  IntegMax := ParseAndEvaluate(s, e);
//  if isNAN(IntegMax) then IntegMax := 0;
//  if e > 0 then IntegMax := 0;
  if isNAN(IntegMax) or isInfinite(IntegMax) or (e > 0) then IntegMax := 0;
end;

procedure TIntegrateXForm.EditCountKeyUp(Sender: TObject; var Key: Word;
                                          Shift: TShiftState);
begin
  with GraphData do
  begin
    try
      IntegCount := StrToInt(EditCount.Text);
      if IntegCount = 0 then IntegCount := IntegCountPos;
    except
      IntegCount := IntegCountPos;
    end;
    if IntegCount > IntegCountMax then IntegCount := IntegCountMax;
  end;
  Altered := true;
end;

procedure TIntegrateXForm.EditConstKeyUp(Sender: TObject; var Key: Word;
                                          Shift: TShiftState);
begin
  try
    IntegConst := StrToFloat(EditConst.Text);
  except
    IntegConst := 0;
  end;
end;

procedure TIntegrateXForm.EditPenWidthKeyUp(Sender: TObject; var Key: Word;
                                             Shift: TShiftState);
begin
  try
    GraphData.ydxWidth := StrToInt(EditPenWidth.Text);
    if Graphdata.ydxWidth = 0 then GraphData.ydxWidth := 1;
  except
    GraphData.ydxWidth := 1;
  end;
  Altered := true;
  MainForm.GLViewer.Invalidate;
end;

procedure TIntegrateXForm.EditOpacityKeyUp(Sender: TObject; var Key: Word;
                                            Shift: TShiftState);
var
  n: integer;

begin
  try
    n := StrToInt(EditOpacity.Text);
  except
    n := 1;
  end;
  GraphData.AreaAlpha := n/100;
  Altered := true;
  MainForm.GLViewer.Invalidate;
end;

procedure TIntegrateXForm.EditCountExit(Sender: TObject);
begin
  EditCount.Text := IntToStr(GraphData.IntegCount);
end;

procedure TIntegrateXForm.UpDown1Click(Sender: TObject; Button: TUDBtnType);
var
  k: word;

begin
  k := 0;
  EditCountKeyUp(Sender, k, []);
end;

procedure TIntegrateXForm.UpDown2Click(Sender: TObject; Button: TUDBtnType);
var
  k: word;

begin
  k := 0;
  EditPenWidthKeyUp(Sender, k, []);
end;

procedure TIntegrateXForm.UpDown3Click(Sender: TObject; Button: TUDBtnType);
var
  k: word;

begin
  k := 0;
  EditOpacityKeyUp(Sender, k, []);
end;

procedure TIntegrateXForm.UpDown1MouseUp(Sender: TObject; Button: TMouseButton;
                                          Shift: TShiftState; X, Y: Integer);
begin
  RecalcBtnClick(Sender);
end;

procedure TIntegrateXForm.CheckBoxClick(Sender: TObject);
begin
  with Sender as TCheckBox do
  if Checked then
  begin  { tag = piShow for IntegCheckBox; piArea for ShadeCheckBox }
    if not Ord(PlotIntegrated) and Tag = Tag
    then Inc(PlotIntegrated, Tag);  { now selected }
  end
  else
  if Ord(PlotIntegrated) and Tag = Tag
  then Dec(PlotIntegrated, Tag);  { now de-selected }
  RecalcBtnClick(Sender);
end;

procedure TIntegrateXForm.CentreButtonClick(Sender: TObject);
var
  y1, y2: extended;

begin
  y1 := StrToFloat(Copy(MinIntegYLabel.Caption,
                   pos('=', MinIntegYLabel.Caption)+2,
                     Length(MinIntegYLabel.Caption)));
  y2 := StrToFloat(Copy(MaxIntegYLabel.Caption,
                   pos('=', MaxIntegYLabel.Caption)+2,
                     Length(MaxIntegYLabel.Caption)));
  IntegConst := IntegConst-(y1 + y2)/2;
  EditConst.Text := FloatToStr(IntegConst);
  RecalcBtnclick(Sender);
end;

procedure TIntegrateXForm.ColorButtonClick(Sender: TObject);
begin
  ColorDialog.Color := GraphData.ydxColor;
  if ColorDialog.Execute then
  begin
    GraphData.ydxColor := ColorDialog.Color;
    ColorPanel.Color := GraphData.ydxColor;
    MainForm.GLViewer.Invalidate;
    Altered := TRUE
  end;
end;

procedure TIntegrateXForm.PositiveButtonClick(Sender: TObject);
begin
  ColorDialog.Color := GraphData.PosAreaColor;
  if ColorDialog.Execute then
  begin
    GraphData.PosAreaColor := ColorDialog.Color;
    PositivePanel.Color := GraphData.PosAreaColor;
    MainForm.GLViewer.Invalidate;
    Altered := TRUE
  end;
end;

procedure TIntegrateXForm.NegativeButtonClick(Sender: TObject);
begin
  ColorDialog.Color := GraphData.NegAreaColor;
  if ColorDialog.Execute then
  begin
    GraphData.NegAreaColor := ColorDialog.Color;
    NegativePanel.Color := GraphData.NegAreaColor;
    MainForm.GLViewer.Invalidate;
    Altered := TRUE
  end;
end;

procedure TIntegrateXForm.RecalcBtnClick(Sender: TObject);
begin
  MainForm.GLViewer.Invalidate;
end;

procedure TIntegrateXForm.IntegLabelClick(Sender: TObject);
begin
  Clipboard.Clear;
  with Sender as TLabel do
  Clipboard.AsText := Copy(Caption,  pos('=', Caption)+2, Length(Caption));
end;

procedure TIntegrateXForm.KeepRangeCheckBoxClick(Sender: TObject);
begin
  KeepRange := KeepRangeCheckBox.Checked;
end;

procedure TIntegrateXForm.CloseBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TIntegrateXForm.UpdateRangeData;
begin
  KeptMin := IntegMin;
  KeptMax := IntegMax;
end;

procedure TIntegrateXForm.ShowData;
begin
  with GraphData, PlotData do
  begin
    EditCount.Text := IntToStr(IntegCount);
    UpDown2.Position := ydxWidth;
    UpDown3.Position := round(AreaAlpha*100);
    KeepRangeCheckBox.Checked := KeepRange;
    ColorPanel.Color := ydxColor;
    PositivePanel.Color := PosAreaColor;
    NegativePanel.Color := NegAreaColor;

    if PlotAsFx then
    begin
      if TextStr = '' then Caption := '' else Caption := 'y = '+TextStr;
      if IsSegment then
      begin
        if KeepRange then
        begin
          IntegMin := KeptMin;
          IntegMax := KeptMax;
        end
        else
        begin
          IntegMin := SegMin;
          IntegMax := SegMax;
        end;
      end
      else
      begin
        if KeepRange then
        begin
          IntegMin := KeptMin;
          IntegMax := KeptMax;
        end
        else
        begin
          IntegMin := xMin;
          IntegMax := xMax;
        end;
      end;

      Label1.Caption := 'where  a = x1';
      Label2.Caption := 'and  b = x2';
      Label5.Caption := 'Integral y at a = x1:';
      CentreButton.Caption := 'Centre to x a&xis';
    end
    else
    begin
      Caption := 'r = '+TextStr;
      if KeepRange then
      begin
        IntegMin := KeptMin;
        IntegMax := KeptMax;
      end
      else
      begin
        IntegMin := SegMin;
        IntegMax := SegMax;
      end;
      Label1.Caption := 'For a = Ø1';
      Label2.Caption := 'b = Ø2  (radians)';
      Label5.Caption := 'Integral r at (a = Ø1):';
      CentreButton.Caption := 'Centre to x a&xis';
    end;
  end;
  EditIntegMin.Text := FloatToStrF(IntegMin, ffGeneral, 13, 4);
  EditIntegMax.Text := FloatToStrF(IntegMax, ffGeneral, 13, 4);
  EditConst.Text := FloatToStrF(IntegConst, ffGeneral, 13, 4);
end;

end.
