unit fNumeric;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.UITypes,
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.Math,
  Vcl.Dialogs,
  Vcl.ComCtrls,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Vcl.Controls,
  Vcl.Buttons,
  Vcl.CheckLst,

  Vcl.Graphics,
  Forms,
  uGlobal,
  fFuncts;

type
  TNumericForm = class(TForm)
    AddButton: TSpeedButton;
    DeleteButton: TSpeedButton;
    UpButton: TSpeedButton;
    DownButton: TSpeedButton;
    CheckListBox: TCheckListBox;
    ApplyBitBtn: TBitBtn;
    Label4: TLabel;
    EditName: TEdit;
    Label2: TLabel;
    EditXCoord: TEdit;
    EditYCoord: TEdit;
    Label1: TLabel;
    CloseBitBtn: TBitBtn;
    Label3: TLabel;
    EditPen: TEdit;
    PenUpDown: TUpDown;
    PenSpeedButton: TSpeedButton;
    PenPanel: TPanel;
    DataListBox: TListBox;
    InputRG: TRadioGroup;
    PointsCheckBox: TCheckBox;
    SortCheckBox: TCheckBox;
    ColorDialog: TColorDialog;
    CoordsRG: TRadioGroup;
    PointsRG: TRadioGroup;
    PointSpeedButton: TSpeedButton;
    PointPanel: TPanel;
    GraphRG: TRadioGroup;
    Label5: TLabel;
    PointSizeTB: TTrackBar;
    ExtrapolateCB: TCheckBox;
    Label6: TLabel;
    CurveTB: TTrackBar;
    PointUpBtn: TSpeedButton;
    PointDownBtn: TSpeedButton;
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure EditNameKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ParseKeyPress(Sender: TObject; var Key: Char);
    procedure EditNameKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure AddButtonClick(Sender: TObject);
    procedure IntKeyPress(Sender: TObject; var Key: Char);
    procedure EditPenKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EditPenChange(Sender: TObject);
    procedure DeleteButtonClick(Sender: TObject);
    procedure EditXCoordKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EditYCoordKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DataListBoxClick(Sender: TObject);
    procedure InputRGClick(Sender: TObject);
    procedure DataListBoxKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure CloseBitBtnClick(Sender: TObject);
    procedure CheckListBoxClick(Sender: TObject);
    procedure SortCheckBoxClick(Sender: TObject);
    procedure PointsCheckBoxClick(Sender: TObject);
    procedure ColorClick(Sender: TObject);
    procedure ApplyBitBtnClick(Sender: TObject);
    procedure UpButtonClick(Sender: TObject);
    procedure DownButtonClick(Sender: TObject);
    procedure CheckListBoxClickCheck(Sender: TObject);
    procedure CoordsRGClick(Sender: TObject);
    procedure PointColorClick(Sender: TObject);
    procedure ExtrapolateCBClick(Sender: TObject);
    procedure PointSizeTBChange(Sender: TObject);
    procedure PointsRGClick(Sender: TObject);
    procedure GraphRGClick(Sender: TObject);
    procedure CurveTBChange(Sender: TObject);
    procedure EditXCoordEnter(Sender: TObject);
    procedure EditCoordExit(Sender: TObject);
    procedure EditYCoordEnter(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure PointUpBtnClick(Sender: TObject);
    procedure PointDownBtnClick(Sender: TObject);
  private
    xValue, yValue: extended;
    CurrentIndex: integer;
    function DefaultData: TNumericData;
    procedure UpdateNumericDataLists;
    procedure ConfirmDataOrder;
  public
    NumericData: TNumericData;
    procedure ShowData(Sender: TObject);
    procedure ClearCheckListBox;
    procedure UpdateDataListBox;
  end;

var
  NumericForm: TNumericForm;

//=====================================================================
implementation
//=====================================================================

uses
  uParser,
  fMain;

{$R *.dfm}

procedure TNumericForm.FormShow(Sender: TObject);
begin
  Caption := GraphFName;
  if CheckListBox.Count = 0 then NumericData := DefaultData;
  ShowData(Sender);
end;

procedure TNumericForm.GraphRGClick(Sender: TObject);
begin
  if Active then
  begin
    case GraphRG.ItemIndex of
    0:GraphRG.Hint := 'Only coordinate points are displayed.';
    1:GraphRG.Hint := 'Lines point to point are displayed.';
    2:GraphRG.Hint := 'Function plotted using the Lagrange interpolation.';
    3:GraphRG.Hint := 'Function plotted using the Hermite interpolation.';
    end;
    with NumericData do
    begin
      NumericStyle := TNumericStyle(GraphRG.ItemIndex);
      with CheckListBox do
      TNumericObject(Items.Objects[ItemIndex]).Data.NumericStyle := NumericStyle;
    end;
    CurveTB.Enabled := GraphRG.ItemIndex = 3;
    Label6.Enabled := CurveTB.Enabled;
    ExtrapolateCB.Enabled := GraphRG.ItemIndex = 2;
    MainForm.GLViewer.Invalidate;
    Altered := True;
    ApplyBitBtn.Visible := False;
  end;
end;

procedure TNumericForm.ParseKeyPress(Sender: TObject; var Key: Char);
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

procedure TNumericForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if (DataListBox.Count = 0) and (CheckListBox.Count > 0)
  then DeleteButtonClick(Sender);
  FunctionsForm.CoordPointButton.Visible := False;

  if ApplyBitBtn.Visible then
  begin
    case MessageDlg('The current data has been altered.'+
              #13#10'To save the change press the Apply Change Button.'+
              #13#10'Do you wish to save the alterations ?', mtConfirmation,
                    [mbYes, mbNo], 0) of
      mrYes: CanClose := False;
    end;
  end;
end;

procedure TNumericForm.FormDestroy(Sender: TObject);
begin
  ClearCheckListBox;
end;

procedure TNumericForm.FormKeyDown(Sender: TObject; var Key: Word;
                                    Shift: TShiftState);
begin
  if not(EditXCoord.Focused or EditYCoord.Focused) then
  case Key of
    VK_ADD: AddButtonClick(Sender);
    VK_SUBTRACT: DeleteButtonclick(Sender);
  end;
end;

procedure TNumericForm.EditNameKeyUp(Sender: TObject; var Key: Word;
                                      Shift: TShiftState);
begin
  with CheckListBox do if Count > 0 then
  begin
    if ItemIndex < 0 then ItemIndex := 0;
    TNumericObject(Items.Objects[ItemIndex]).Data.Name := EditName.Text;
    Items[ItemIndex] := EditName.Text;
    ApplyBitBtn.Visible := True;
  end;
end;

procedure TNumericForm.EditNameKeyDown(Sender: TObject; var Key: Word;
                                    Shift: TShiftState);
begin
  if (Key = VK_DELETE) or (Key = VK_BACK)
  then ApplyBitBtn.Visible := True;
end;

procedure TNumericForm.EditPenChange(Sender: TObject);
var
  k: word;

begin
  if Active then
  begin
    k := 0;
    EditPenKeyUp(Sender, k, []);
  end;
end;

procedure TNumericForm.EditPenKeyUp(Sender: TObject; var Key: Word;
                                     Shift: TShiftState);
var
  w: integer;

begin
  if Active then with Sender as TEdit do
  begin
    try
      w := StrToInt(Text);
    except
      w := 1;
    end;
    if w < 1 then w := 1;

    NumericData.PlotWidth := w;
    with CheckListBox do if Count > 0 then
    begin
      TNumericObject(Items.Objects[ItemIndex]).Data.PlotWidth := w;
      MainForm.GLViewer.Invalidate;
      Altered := True;
      ApplyBitBtn.Visible := False;
    end;
  end;
end;

procedure TNumericForm.EditXCoordEnter(Sender: TObject);
begin
  with MainForm.StatusBar.Panels[2] do
  case CoordsRG.ItemIndex of
  0:case InputRG.ItemIndex of
    0:Text := 'Enter an x Coordinate value then press Enter key.';
    1:Text := 'Enter a value then press Enter key to alter x Coordinate.';
    2:Text := 'Select an item from the coordinates list and press Delete Key.';
    end;
  1:case InputRG.ItemIndex of
    0:Text := 'Enter a value for polar angle ''Ø'' then press Enter key.';
    1:Text := 'Enter a value then press Enter key to alter ''Ø''.';
    2:Text := 'Select an item from the coordinates list and press Delete Key.';
    end;
  2:case InputRG.ItemIndex of
    0:Text := 'Enter a length for the vector then press Enter key.';
    1:Text := 'Enter a value then press Enter key to alter the vector length.';
    2:Text := 'Select an item from the coordinates list and press Delete Key.';
    end;
  end;
end;

procedure TNumericForm.EditCoordExit(Sender: TObject);
begin
  MainForm.StatusBar.Panels[2].Text := '';
end;

procedure TNumericForm.EditXCoordKeyUp(Sender: TObject; var Key: Word;
                                        Shift: TShiftState);
var
  s: string;
  e: byte;

begin
  if Active and (Key <> 9) then
  begin
    s := ScanText(EditXCoord.Text);
    xValue := ParseAndEvaluate(s, e);
    if isNAN(xValue) or isInfinite(xValue) or (e > 0) then xValue := 0;
    if Key = VK_RETURN then
    case InputRG.ItemIndex of
    0:begin      { Adding }
        EditYCoord.SetFocus;
      end;
    1:if DataListBox.Count > 0 then
      begin      { Editing }
        UpdateNumericDataLists;
        EditYCoord.SetFocus;
      end;
    end;
  end;
end;

procedure TNumericForm.EditYCoordEnter(Sender: TObject);
begin
  with MainForm.StatusBar.Panels[2] do
  case CoordsRG.ItemIndex of
  0:case InputRG.ItemIndex of
    0:Text := 'Enter a y Coordinate value then press Enter key.';
    1:Text := 'Enter a value then press Enter key to alter y Coordinate.';
    2:Text := 'Select an item from the coordinates list and press Delete Key.';
    end;
  1:case InputRG.ItemIndex of
    0:Text := 'Enter a value for the polar radial ''r'' then press Enter key.';
    1:Text := 'Enter a value then press Enter key to alter ''r''.';
    2:Text := 'Select an item from the coordinates list and press Delete Key.';
    end;
  2:case InputRG.ItemIndex of
    0:Text := 'Enter an angle for the vector then press Enter key.';
    1:Text := 'Enter a value then press Enter key to alter the vector angle.';
    2:Text := 'Select an item from the coordinates list and press Delete Key.';
    end;
  end;
end;

procedure TNumericForm.EditYCoordKeyUp(Sender: TObject; var Key: Word;
                                        Shift: TShiftState);
var
  j: integer;
  s: string;
  e: byte;

begin
  if Active and (Key <> 9) then
  begin
    s := ScanText(EditYCoord.Text);
    yValue := ParseAndEvaluate(s, e);
    if isNAN(yValue) or isInfinite(yValue) or (e > 0) then yValue := 0;
    if Key = VK_RETURN then
    begin
      case InputRG.ItemIndex of
      0:begin    { Adding }
          UpdateNumericDataLists;
          EditXCoord.SetFocus;
        end;
      1:if DataListBox.Count > 0 then
        begin    { Editing }
          j := DataListBox.ItemIndex;
          UpdateNumericDataLists;
          if j < DataListBox.Count -1 then
          begin
            DataListBox.ItemIndex := j +1;
            DataListBox.Selected[DataListbox.ItemIndex] := True;
            DataListBoxClick(Sender);
          end;
          EditXCoord.SetFocus;
        end;
      end;
    end;
    if DataListBox.Count > 0 then
    begin
      MainForm.GLViewer.Invalidate;
      Altered := True;
      ApplyBitBtn.Visible := False;
    end;
  end;
end;

procedure TNumericForm.ExtrapolateCBClick(Sender: TObject);
begin
  with NumericData do
  begin
    Extrapolate := ExtrapolateCB.Checked;
    with CheckListBox do
    TNumericObject(Items.Objects[ItemIndex]).Data.Extrapolate := Extrapolate;
  end;
  MainForm.GLViewer.Invalidate;
  Altered := True;
  ApplyBitBtn.Visible := False;
end;

procedure TNumericForm.InputRGClick(Sender: TObject);
begin
  if DataListBox.Count > 0 then
  case InputRG.ItemIndex of
  0:begin
      InputRG.Hint := 'Adding: Enter coordinates & press enter.';
      DataListBox.Hint := 'Adding data.';
      DataListBox.MultiSelect := False;
      EditXCoord.Text := '';
      EditYCoord.Text := '';
      SortCheckBox.Enabled := True;
      ConfirmDataOrder;
    end;
  1:begin
      InputRG.Hint := 'Select the item to edit then enter coordinates & press enter.';
      DataListBox.Hint := 'Editing data.';
      DataListBox.MultiSelect := False;
      SortCheckBox.Enabled := False;
      DataListBox.SetFocus;
      DataListBoxClick(Sender);
      MainForm.GLViewer.Invalidate;
    end;
  2:begin
      InputRG.Hint := 'Select the items to delete. Multiple items can be selected.';
      DataListBox.Hint := 'Deleting data: Press ''Del'' to delete. Two items must remain.';
      DataListBox.MultiSelect := True;
      SortCheckBox.Enabled := False;
      DataListBox.SetFocus;
      DataListBoxClick(Sender);
      MainForm.GLViewer.Invalidate;
    end;
  end;
end;

procedure TNumericForm.IntKeyPress(Sender: TObject; var Key: Char);
begin
  with Sender as TEdit do
  if not CharInSet(Key, ['0'..'9', #8]) then Key := #0;
end;

procedure TNumericForm.PointColorClick(Sender: TObject);
begin
  with NumericData do
  begin
    with CheckListBox do ColorDialog.Color :=
    TNumericObject(Items.Objects[ItemIndex]).Data.PointColor;
    if ColorDialog.Execute then
    begin
      NumericData.PointColor := ColorDialog.Color;
      with CheckListBox do
      TNumericObject(Items.Objects[ItemIndex]).Data.PointColor :=
      ColorDialog.Color;
      PointPanel.Color := ColorDialog.Color;
      MainForm.GLViewer.Invalidate;
      Altered := True;
      ApplyBitBtn.Visible := False;
    end;
  end;
end;

procedure TNumericForm.PointDownBtnClick(Sender: TObject);
var
  i: integer;

begin
  with DataListBox do
  begin
    i := ItemIndex;
    if i < Count -1 then Items.Move(i, i+1);
    ItemIndex := i+1;
  end;
  with CheckListBox do if i < DataListBox.Count -1
  then TNumericObject(Items.Objects[ItemIndex]).ControlPoints.Move(i, i+1);

  MainForm.GLViewer.Invalidate;
  Altered := True;
end;

procedure TNumericForm.PointsCheckBoxClick(Sender: TObject);
begin
  if Active and (CheckListBox.Count > 0) then
  begin
    NumericData.ShowPoints := PointsCheckBox.Checked;
    with CheckListBox do
    TNumericObject(Items.Objects[ItemIndex]).Data.ShowPoints :=
                                             PointsCheckBox.Checked;
    MainForm.GLViewer.Invalidate;
    Altered := True;
    ApplyBitBtn.Visible := False;
  end;
end;

procedure TNumericForm.PointSizeTBChange(Sender: TObject);
begin
  if Active then with NumericData do
  begin
    PointSize := PointSizeTB.Position;
    with CheckListBox do
    TNumericObject(Items.Objects[ItemIndex]).Data.PointSize := PointSize;
  end;
  MainForm.GLViewer.Invalidate;
  Altered := True;
  ApplyBitBtn.Visible := False;
end;

procedure TNumericForm.PointsRGClick(Sender: TObject);
begin
  with NumericData do
  begin
    PointStyle := TPointStyle(PointsRG.ItemIndex);
    with CheckListBox do
    TNumericObject(Items.Objects[ItemIndex]).Data.PointStyle := PointStyle;
  end;
  MainForm.GLViewer.Invalidate;
  Altered := True;
  ApplyBitBtn.Visible := False;
end;

procedure TNumericForm.PointUpBtnClick(Sender: TObject);
var
  i: integer;

begin
  with DataListBox do
  begin
    i := ItemIndex;
    if i > 0 then Items.Move(i, i-1);
    if i > 1 then ItemIndex := i-1 else ItemIndex := 0;
  end;
  with CheckListBox do if i > 0
  then TNumericObject(Items.Objects[ItemIndex]).ControlPoints.Move(i, i-1);

  MainForm.GLViewer.Invalidate;
  Altered := True;
end;

procedure TNumericForm.CoordsRGClick(Sender: TObject);
begin
  if Active and (CheckListBox.Count > 0) then
  begin
    case CoordsRG.ItemIndex of
    0:begin
        Label2.Caption := 'Plot Cartesian Coordinates {x, y}';
      end;
    1:begin
        Label2.Caption := 'Plot Polar Coordinates {Ø, r}';
      end;
    2:begin
        Label2.Caption := 'Enter a vector {length, angle}';
      end;
    end;
    DataListBoxClick(Sender);
    NumericData.CoordsIdx := CoordsRG.ItemIndex;
    with CheckListBox do
    TNumericObject(Items.Objects[ItemIndex]).Data.CoordsIdx :=
                                      NumericData.CoordsIdx;
    MainForm.GLViewer.Invalidate;
    Altered := True;
    ApplyBitBtn.Visible := False;
  end;
end;

procedure TNumericForm.ShowData(Sender: TObject);
var
  a, b: Boolean;

begin
  a := Altered;
  with CheckListBox do
  begin
    b := Count > 0;
    if b and (ItemIndex < 0) then ItemIndex := Count -1;
  end;
  DeleteButton.Enabled := b;
  UpButton.Enabled := b and (CheckListBox.Count > 1);
  DownButton.Enabled := b and (CheckListBox.Count > 1);
  DataListBox.Enabled := b;
  Label1.Enabled := b;
  Label4.Enabled := b;
  EditName.Enabled := b;
  Label3.Enabled := b;
  PointSpeedButton.Enabled := b;
  EditPen.Enabled := b;
  PenUpDown.Enabled := b;
  PenSpeedButton.Enabled := b;
  PointPanel.Enabled := b;
  PenPanel.Enabled := b;
  PointsCheckBox.Enabled := b;
  Label2.Enabled := b;
  EditXCoord.Enabled := b;
  EditYCoord.Enabled := b;
  SortCheckBox.Enabled := b;
  PointUpBtn.Enabled := not SortCheckBox.Checked;
  PointDownBtn.Enabled := not SortCheckBox.Checked;
  InputRG.Enabled := b;
  PointsRG.Enabled := b;
  GraphRG.Enabled := b;
  CoordsRG.Enabled := b;
  Label5.Enabled := b;
  PointSizeTB.Enabled := b;
  Label6.Enabled := b and (GraphRG.ItemIndex = 3);
  CurveTB.Enabled := b and (GraphRG.ItemIndex = 3);
  ExtrapolateCB.Enabled := b and (GraphRG.ItemIndex = 2);
  if b then
  begin
//  ConfirmDataOrder;??????
    SortCheckBox.Checked := NumericData.SortXValue;
    PointsCheckBox.Checked := NumericData.ShowPoints;
    EditPen.Text := IntToStr(NumericData.PlotWidth);
    PenPanel.Color := NumericData.PlotColor;
    EditName.Text := NumericData.Name;
    CoordsRG.ItemIndex := NumericData.CoordsIdx;
    PointsRG.ItemIndex := Ord(NumericData.PointStyle);
    PointSizeTB.Position := NumericData.PointSize;
    PointPanel.Color := NumericData.PointColor;
    GraphRG.ItemIndex := Ord(NumericData.NumericStyle);
    CurveTB.Position := NumericData.CurveRate;
    Label6.Caption := 'Curve Rate '+IntToStr(CurveTB.Position);
    ExtrapolateCB.Checked := NumericData.Extrapolate;
  end
  else DataListBox.Clear;
  Altered := a;
end;

procedure TNumericForm.SortCheckBoxClick(Sender: TObject);
begin
  PointUpBtn.Enabled := not SortCheckBox.Checked;
  PointDownBtn.Enabled := not SortCheckBox.Checked;
  if Active then with CheckListBox do if Count > 0 then
  begin
    TNumericObject(Items.Objects[ItemIndex]).Data.SortXValue := SortCheckBox.Checked;
    NumericData.SortXValue := SortCheckBox.Checked;
    ApplyBitBtn.Visible := DataListBox.Count > 0;
    if SortCheckBox.Checked then ConfirmDataOrder;
  end;
end;

procedure TNumericForm.AddButtonClick(Sender: TObject);
begin
  with CheckListBox do
  begin
    if Count = 0 then NumericData := DefaultData
    else NumericData := TNumericObject(Items.Objects[ItemIndex]).Data;
    AddItem(NumericData.Name, TNumericObject.Create(NumericData));
    ItemIndex := Count -1;
    Checked[ItemIndex] := True;
    DataListBox.Clear;
    CurrentIndex := ItemIndex;
  end;
  Altered := True;
  ShowData(Sender);
  InputRG.ItemIndex := 0;
  EditXCoord.SetFocus;
  ApplyBitBtn.Visible := True;
end;

procedure TNumericForm.DataListBoxClick(Sender: TObject);
  procedure PointToVector(x1, y1, x2, y2: extended; var l, a: extended);
  var
    dx, dy: extended;

  begin
    dx := x2 - x1;
    dy := y2 - y1;
    l := Sqrt(dx*dx + dy*dy);
    a := ArcTan(dy/dx);
  end;

var
  j: integer;
  l, a: extended;
  x, y: extended;

begin
  if InputRG.ItemIndex > 0 then
  begin        { Editing or Deleting }
    j := DataListBox.ItemIndex;
    with CheckListBox, TGraphPointObject(
         TNumericObject(Items.Objects[ItemIndex]).ControlPoints[j]) do
    begin
      xValue := x_phi;
      yValue := y_r;

      case CoordsRG.ItemIndex of
      0:begin    { Cartesian option }
          EditXCoord.Text := FloatToStr(xValue);
          EditYCoord.Text := FloatToStr(yValue);
        end;
      1:begin    { Polar option }
          EditXCoord.Text := FloatToStrF(RadToDeg(xValue), ffNumber, 7, 5)+'°';
          EditYCoord.Text := FloatToStr(yValue);
        end;
      2:begin    { As a Vector option }
          l := 0;
          a := 0;
          if j > 0 then //PointToVector(0, 0, xValue, yValue, l, a)
          begin
            with CheckListBox, TGraphPointObject(
            TNumericObject(Items.Objects[ItemIndex]).ControlPoints[j -1]) do
            begin
              x := x_phi;
              y := y_r;
            end;
            PointToVector(x, y, xValue, yValue, l, a);
          end;
          EditXCoord.Text := FloatToStr(l);
          EditYCoord.Text := FloatToStrF(RadToDeg(a), ffNumber, 7, 5)+'°';
        end;
      end;
    end;
    MainForm.GLViewer.Invalidate;
  end;
end;

procedure TNumericForm.DataListBoxKeyDown(Sender: TObject; var Key: Word;
                                          Shift: TShiftState);
var
  j, k: integer;

begin
  if (DataListBox.Count > 2) and (Key = VK_DELETE) then
  begin
    j := DataListBox.ItemIndex;        { free ControlPoint[j] }
    k := CheckListBox.ItemIndex;
    with CheckListBox, TGraphPointObject(
         TNumericObject(Items.Objects[k]).ControlPoints[j]) do Free;
    UpdateNumericDataLists;
    DataListBox.Selected[DataListBox.ItemIndex] := True;
    ApplyBitBtn.Visible := DataListBox.Count > 0;
  end;
end;

function TNumericForm.DefaultData: TNumericData;
begin
  with Result do
  begin
    Name := 'Numeric Plot';
    NumericStyle := nsLinear;
    ShowPoints := True;
    PointStyle := psSquare;
    PointSize := 1;         {  }
    PointColor := ClBlack;  {  }
    PlotWidth := 1;         { pen width for plot }
    PlotColor := ClBlack;   { pen color for plot }
    SortXValue := True;     { x values sorted if true }
    Extrapolate := False;   { extrapolate graph if true }
    CoordsIdx := 0;         { enter coords as x, y or phi, r or vector }
    CurveRate := 5;         { was k0 = 0.5; CurveRate/100 }
  end;
end;

procedure TNumericForm.ApplyBitBtnClick(Sender: TObject);
begin
  if EditXCoord.Focused or EditYCoord.Focused then Exit;

  if (DataListBox.Count = 0) and (CheckListBox.Count > 0)
  then DeleteButtonClick(Sender);

  MainForm.GLViewer.Invalidate;
  Altered := True;
  ApplyBitBtn.Visible := False;
end;

procedure TNumericForm.CheckListBoxClick(Sender: TObject);
begin
  if Active then
  begin
    UpdateDataListBox;
    ShowData(Sender);
  end;
end;

procedure TNumericForm.CheckListBoxClickCheck(Sender: TObject);
begin
  MainForm.GLViewer.Invalidate;
  Altered := True;
  ApplyBitBtn.Visible := False;
end;

procedure TNumericForm.ClearCheckListBox;
var
  i: integer;

begin
  with CheckListBox do
  begin
    for i := 0 to Count -1 do Items.Objects[i].Free;
    Clear;
  end;
end;

procedure TNumericForm.CloseBitBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TNumericForm.ColorClick(Sender: TObject);
begin
  with NumericData do
  begin
    with CheckListBox do ColorDialog.Color :=
    TNumericObject(Items.Objects[ItemIndex]).Data.PlotColor;
    if ColorDialog.Execute then
    begin
      NumericData.PlotColor := ColorDialog.Color;
      with CheckListBox do
      TNumericObject(Items.Objects[ItemIndex]).Data.PlotColor :=
      ColorDialog.Color;
      PenPanel.Color := ColorDialog.Color;
      MainForm.GLViewer.Invalidate;
      Altered := True;
      ApplyBitBtn.Visible := False;
    end;
  end;
end;

procedure TNumericForm.CurveTBChange(Sender: TObject);
begin
  if Active then
  begin
    with NumericData do
    begin
      CurveRate := CurveTB.Position;
      Label6.Caption := 'Curve Rate '+IntToStr(CurveTB.Position);
      with CheckListBox do
      TNumericObject(Items.Objects[ItemIndex]).Data.CurveRate := CurveRate;
    end;
    MainForm.GLViewer.Invalidate;
    Altered := True;
    ApplyBitBtn.Visible := False;
  end;
end;

procedure TNumericForm.UpdateNumericDataLists;
  function InsertValuesAt: integer;
  var
    i: integer;

  begin
    Result := -1;
    with CheckListBox do
    if TNumericObject(Items.Objects[ItemIndex]).ControlPoints.Count > 0 then
    begin
      if xValue < TGraphPointObject(
         TNumericObject(Items.Objects[ItemIndex]).ControlPoints[0]).x_phi
      then Result := 0
      else
      begin
        i := TNumericObject(Items.Objects[ItemIndex]).ControlPoints.Count -1;
        if xValue < TGraphPointObject(
        TNumericObject(Items.Objects[ItemIndex]).ControlPoints[i]).x_phi then
        begin
          while (i > 0) and (xValue < TgraphPointObject(
          TNumericObject(Items.Objects[ItemIndex]).ControlPoints[i]).x_phi)
          do Dec(i);
          Result := i +1;
        end;
      end;
    end;
  end;

var
  s: string;
  j: integer;
  e: byte;
  x: extended;
  y: extended;

begin
  if CoordsRG.ItemIndex = 2 then   { As a Vector option }
  begin
    s := ScanText(EditXCoord.Text);
    xValue := ParseAndEvaluate(s, e);
//  if isNAN(xValue) then xValue := 0;
//  if e > 0 then xValue := 0;
    if isNAN(xValue) or isInfinite(xValue) or (e > 0) then xValue := 0;
    x := xValue*Cos(yValue);
    y := xValue*Sin(yValue);
    j := DataListBox.Count;

    if j > 0 then with CheckListBox, TGraphPointObject(
       TNumericObject(Items.Objects[ItemIndex]).ControlPoints[j -1]) do
    begin
      x := x + x_phi;
      y := y + y_r;
    end;
    xValue := x;
    yValue := y;
  end;

  case InputRG.ItemIndex of
  0:begin       { Adding }
      if SortCheckBox.Checked then j := InsertValuesAt else j := -1;
      if j > -1 then
      begin    { insert added data }
        DataListBox.Items.Insert(j, Format('%18s,%18s', [FloatToStr(xValue),
                                                         FloatToStr(yValue)]));
        with CheckListBox do
        TNumericObject(Items.Objects[ItemIndex]).ControlPoints.Insert(j,
                       TgraphPointObject.Create(xValue, yValue));
      end
      else
      begin    { append added data}
        DataListBox.Items.Add(Format('%18s,%18s', [FloatToStr(xValue),
                                                   FloatToStr(yValue)]));
        with CheckListBox do
        TNumericObject(Items.Objects[ItemIndex]).ControlPoints.Add(
                       TGraphPointObject.Create(xValue, yValue));
        j := DataListBox.Count -1;
      end;
      DataListBox.ItemIndex := j;
      DataListBox.Selected[j] := True;
    end;
  1:begin       { Editing }
      j := DataListBox.ItemIndex;
      if CoordsRG.ItemIndex = 2 then
      begin
      end
      else DataListBox.Items[j] := Format('%18s,%18s', [FloatToStr(xValue),
                                                        FloatToStr(yValue)]);
      with CheckListBox, TGraphPointObject(
      TNumericObject(Items.Objects[ItemIndex]).ControlPoints[j]) do
      begin
        x_phi := xValue;
        y_r := yValue;
      end;
    end;
  2:with DataListBox do if SelCount > 0 then
    begin       { Deleting }
      j := 0;
      while (j < Count) and (Count > 2) do
      begin
        if Selected[j] then
        begin
          with CheckListBox do
          TNumericObject(Items.Objects[ItemIndex]).ControlPoints.Delete(j);
          Items.Delete(j);
        end
        else Inc(j);
      end;
      MainForm.GLViewer.Invalidate;
      Altered := True;
      ApplyBitBtn.Visible := False;
    end;
  end;
end;

procedure TNumericForm.UpButtonClick(Sender: TObject);
var
  i: integer;

begin
  with CheckListBox do
  begin
    i := ItemIndex;
    if i > 0 then Items.Move(i, i-1);
    if i > 1 then ItemIndex := i-1 else ItemIndex := 0;
  end;
  CheckListBoxClick(Sender);
end;

procedure TNumericForm.UpdateDataListBox;
var
  j: integer;
  p: TGraphPointObject;

begin
  if Active then
  begin
    if CheckListBox.Count > 0 then
    begin
      DataListBox.Clear;
      with CheckListBox do
      begin
        NumericData := TNumericObject(Items.Objects[ItemIndex]).Data;
        CurrentIndex := ItemIndex;
        for j := 0 to TNumericObject(
            Items.Objects[ItemIndex]).ControlPoints.Count -1 do
        begin
          p := TNumericObject(Items.Objects[ItemIndex]).ControlPoints[j];
          DataListBox.Items.Add(Format('%18s,%18s', [FloatToStr(p.x_phi),
                                                     FloatToStr(p.y_r)]));
        end;
      end;
      with DataListBox do if Count > 0 then
      begin
        ItemIndex := Count -1;
        Selected[ItemIndex] := True;
      end;

      if InputRG.ItemIndex = 0 then
      begin
        EditXCoord.Text := '';
        EditYCoord.Text := '';
      end
      else DataListBoxClick(Self);
      ShowData(Self);
    end;
  end;
end;

procedure TNumericForm.DeleteButtonClick(Sender: TObject);
var
  i: integer;

begin
  if CheckListBox.Count > 0 then
  begin
    with CheckListBox do
    begin
      i := ItemIndex;
      with Items.Objects[i] as TNumericObject do Free;
      Items.Delete(i);
      if i > Count -1 then i := Count -1;
      ItemIndex := i;
      DeleteButton.Enabled := Count > 0;
    end;
  end;
  Altered := True;
  ApplyBitBtn.Visible := True;
  if CheckListBox.Count > 0 then CheckListBoxClick(Sender);
  if CheckListBox.Count < 2  then ShowData(Sender);
end;

procedure TNumericForm.DownButtonClick(Sender: TObject);
var
  i: integer;

begin
  with CheckListBox do
  begin
    i := ItemIndex;
    if i < Count -1 then Items.Move(i, i+1);
    ItemIndex := i+1;
  end;
  CheckListBoxClick(Sender);
end;

procedure TNumericForm.ConfirmDataOrder;
var
  x, y: extended;

  function InsertValuesAt: integer;
  var
    i: integer;

  begin
    Result := -1;
    with CheckListBox do
    if TNumericObject(Items.Objects[ItemIndex]).ControlPoints.Count > 0 then
    begin
      if x < TGraphPointObject(
         TNumericObject(Items.Objects[ItemIndex]).ControlPoints[0]).x_phi
      then Result := 0
      else
      begin
        i := TNumericObject(Items.Objects[ItemIndex]).ControlPoints.Count -1;
        if x < TGraphPointObject(
        TNumericObject(Items.Objects[ItemIndex]).ControlPoints[i]).x_phi then
        begin
          while (i > 0) and (x < TgraphPointObject(
          TNumericObject(Items.Objects[ItemIndex]).ControlPoints[i]).x_phi)
          do Dec(i);
          Result := i +1;
        end;
      end;
    end;
  end;

var
  i, j: integer;
  IsOrdered: Boolean;
  Temp: TList;         { list of TGraphPointObject }

begin
  if SortCheckBox.Checked and (DataListBox.Count > 1) then
  with CheckListBox do if Count > 0 then
  with TNumericObject(Items.Objects[ItemIndex]) do
  begin
    IsOrdered := ControlPoints.Count > 1;
    i := 1;
    while IsOrdered and (i < ControlPoints.Count) do
    begin
      IsOrdered := (TGraphPointObject(ControlPoints[i]).x_phi >
                    TGraphPointObject(ControlPoints[i -1]).x_phi);
      Inc(i);
    end;
    if not IsOrdered and (MessageDlg('The current data is not sorted!'+
                               #13#10'Should the data be sorted?',
           mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
    begin
      Temp := TList.Create;
      try
        Temp.Assign(ControlPoints);
        ControlPoints.Clear;
        DataListBox.Clear;
        x := TGraphPointObject(Temp[0]).x_phi;
        y := TGraphPointObject(Temp[0]).y_r;
        DataListBox.Items.Add(Format('%18s,%18s', [FloatToStr(x), FloatToStr(y)]));
        ControlPoints.Add(TGraphPointObject.Create(x, y));
        j := InsertValuesAt;
        for i := 1 to Temp.Count -1 do
        begin
          x := TGraphPointObject(Temp[i]).x_phi;
          y := TGraphPointObject(Temp[i]).y_r;
          j := InsertValuesAt;
          if j > -1 then
          begin    { insert added data }
            DataListBox.Items.Insert(j, Format('%18s,%18s', [FloatToStr(x),
                                                             FloatToStr(y)]));
            with CheckListBox do
            TNumericObject(Items.Objects[ItemIndex]).ControlPoints.Insert(j,
                           TGraphPointObject.Create(x, y));
          end
          else
          begin    { append added data}
            DataListBox.Items.Add(Format('%18s,%18s', [FloatToStr(x),
                                                       FloatToStr(y)]));
            with CheckListBox do
            TNumericObject(Items.Objects[ItemIndex]).ControlPoints.Add(
                           TGraphPointObject.Create(x, y));
            j := DataListBox.Count -1;
          end;
        end;
        DataListBox.ItemIndex := j;
        DataListBox.Selected[j] := True;
      finally
        for i := 0 to Temp.Count -1 do TObject(Temp.Items[i]).Free;
        Temp.Free;
        MainForm.GLViewer.Invalidate;
        Altered := True;
        ApplyBitBtn.Visible := False;
      end;
    end;
  end;
end;

end.
