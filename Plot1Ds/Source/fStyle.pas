unit fStyle;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.UITypes,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.Buttons,

  uGlobal;

type
  TStyleNameForm = class(TForm)
    BitBtn1: TBitBtn;
    StyleListBox: TListBox;
    EditName: TEdit;
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure EditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EditKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure StyleListBoxDblClick(Sender: TObject);
  private
    StyleAltered: Boolean;
    procedure SaveToFile;
  public
    Selecting: Boolean;
     
  end;

var
  StyleNameForm: TStyleNameForm;

//====================================================================
implementation
//====================================================================

uses
  fMain,
  fFuncts,
  fNumeric;

{$R *.dfm}

procedure TStyleNameForm.FormShow(Sender: TObject);
  procedure ReadStyles;
  var
    F: File of TPlotStyle;
    s: TPlotStyle;
    so: TPlotStyleObject;

  begin
    AssignFile(F, StyleFName);
    Reset(F);
    while not Eof(F) do
    begin
      Read(F, s);
      so := TPlotStyleObject.Create(s);
      StyleListBox.Items.AddObject(String(s.StyleName), so);
    end;
    CloseFile(F);
  end;

begin
  if Selecting then
  begin
    StyleListBox.Enabled := true;
    StyleListBox.ItemIndex := -1;
    EditName.Visible := false;
    Caption := '   Select a style';
    BitBtn1.Hint := 'OK to apply selected style.';
    StyleListBox.Hint := 'Press Del to delete an item.';
    Hint := 'Press escape to deselect style.'
  end
  else
  begin
    StyleListBox.Enabled := false;
    EditName.Visible := true;
    Caption := '   Save a style as...';
    BitBtn1.Hint := 'OK to add the current graph style.';
    StyleListBox.Hint := '';
    Hint := '';
  end;
  StyleAltered := false;

  if FileExists(StyleFName) then ReadStyles;
  StyleListBox.ItemIndex := -1;

  with Layout do
  begin
    if Left = 0 then
    begin
      Left := (Screen.Width - Width) div 2;
      Top := (Screen.Height - Height) div 2;
    end
    else
    begin
      Left := StyleLeft;
      Top := StyleTop;
    end;
  end;
end;

procedure TStyleNameForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  procedure ApplyStyle;
  var
    s: TPlotStyle;
    so: TPlotStyleObject;
    i: integer;

  begin
    if StyleListbox.ItemIndex = -1 then exit;
    so := TPlotStyleObject(StyleListBox.Items.Objects[StyleListBox.ItemIndex]);
    s := so.Style;
    with GraphData do
    begin
      AreaAlpha := s.AreaAlpha;
      FontName := String(s.FontName);
      FontStyle := s.FontStyle;
      FontSize := s.FontSize;
      AxisWidth := s.AxisWidth;
      xMinorGrad := s.xMinorGrad;
      yMinorGrad := s.yMinorGrad;
      xMajorGrad := s.xMajorGrad;
      yMajorGrad := s.yMajorGrad;
      MinorWidth := s.MinorWidth;
      MajorWidth := s.MajorWidth;
      CoordWidth := s.CoordWidth;
      dydxWidth := s.dydxWidth;
      d2ydx2Width := s.d2ydx2Width;
      IntegCount := s.IntegCount;
      ydxWidth := s.ydxWidth;

      BackColor := s.BackColor;
      GridColor := s.GridColor;
      xAxisColor := s.xAxisColor;
      yAxisColor := s.yAxisColor;
      CoordColor := s.CoordColor;
      dydxColor := s.dydxColor;
      d2ydx2Color := s.d2ydx2Color;
      ydxColor := s.ydxColor;
      PosAreaColor := s.PosAreaColor;
      NegAreaColor := s.NegAreaColor;
      Grid := s.Grid;
      with FunctionsForm.CheckListBox do
      begin
        for i := 0 to Count -1 do
        with TPlotDataObject(Items.Objects[i]).Data do
        begin
          PlotWidth := s.Pens[i mod 12].PenWidth;
          PlotColor := s.Pens[i mod 12].PenColor;
        end;
      end;

      with NumericForm.CheckListBox do
      begin
        for i := 0 to Count -1 do
        with TNumericObject(Items.Objects[i]).Data do
        begin
          PlotWidth := s.NumLines[i mod 12].PenWidth;
          PlotColor := s.NumLines[i mod 12].PenColor;
          PointSize := s.NumPoints[i mod 12].PenWidth;
          PointColor := s.NumPoints[i mod 12].PenColor;
        end;
      end;
    end;
    MainForm.GLViewer.Buffer.BackgroundColor := GraphData.BackColor;
  end;    { ApplyStyle }

  function UniqueName(s: string): Boolean;
  var
    i: integer;
    Found: Boolean;

  begin
    i := 0;
    Found := false;
    while not Found and (i < StyleListBox.Items.Count) do
    begin
      Found := LowerCase(s) = LowerCase(StyleListBox.Items[i]);
      Inc(i);
    end;
    Result := not Found;
  end;   { UniqueName }

  procedure AddToList;
  var
    s: TPlotStyle;
    so: TPlotStyleObject;
    i: integer;

  begin
    with GraphData do
    begin
      s.AreaAlpha := AreaAlpha;
      s.FontName := ShortString(FontName);
      s.StyleName := ShortString(EditName.Text);
      s.FontStyle := FontStyle;
      s.FontSize := FontSize;
      s.AxisWidth := AxisWidth;
      s.xMinorGrad := xMinorGrad;
      s.yMinorGrad := yMinorGrad;
      s.xMajorGrad := xMajorGrad;
      s.yMajorGrad := yMajorGrad;
      s.MinorWidth := MinorWidth;
      s.MajorWidth := MajorWidth;
      s.CoordWidth := CoordWidth;
      s.dydxWidth := dydxWidth;
      s.d2ydx2Width := d2ydx2Width;
      s.IntegCount := IntegCount;
      s.ydxWidth := ydxWidth;

      s.BackColor := BackColor;
      s.GridColor := GridColor;
      s.xAxisColor := xAxisColor;
      s.yAxisColor := yAxisColor;
      s.CoordColor := CoordColor;
      s.dydxColor := dydxColor;
      s.d2ydx2Color := d2ydx2Color;
      s.ydxColor := ydxColor;
      s.PosAreaColor := PosAreaColor;
      s.NegAreaColor := NegAreaColor;

      s.Grid := Grid;

      for i := 0 to 11 do
      begin
        s.Pens[i].PenWidth := 1;
        s.Pens[i].PenColor := clBlack;
      end;

      with FunctionsForm.CheckListBox do
      begin
        for i := 0 to Count -1 do
        with TPlotDataObject(Items.Objects[i]).Data do
        begin
          s.Pens[i mod 12].PenWidth := PlotWidth;
          s.Pens[i mod 12].PenColor := PlotColor;
        end;
      end;

      with NumericForm.CheckListBox do
      begin
        for i := 0 to Count -1 do
        with TNumericObject(Items.Objects[i]).Data do
        begin
          s.NumLines[i mod 12].PenWidth := PlotWidth;
          s.NumLines[i mod 12].PenColor := PlotColor;
          s.NumPoints[i mod 12].PenWidth := PointSize;
          s.NumPoints[i mod 12].PenColor := PointColor;
        end;
      end;
    end;
    so := TPlotStyleObject.Create(s);
    StyleListBox.Items.AddObject(EditName.Text, so);
    SaveToFile;
  end;    { AddToList }

var
  i: integer;

begin
  if Selecting then ApplyStyle
  else if StyleAltered then
  begin
    EditName.Text := Trim(EditName.Text);
    if EditName.Text <> '' then
    begin
      if UniqueName(EditName.Text) then AddToList
      else
      begin
        MessageDlg('The Style Name entered is not unique.', mtError, [mbOK], 0);
        CanClose := false;
      end;
    end;
  end;
  if CanClose then
  begin
    for i := 0 to StyleListBox.Items.Count -1
     do StyleListBox.Items.Objects[i].Free;
    StyleListBox.Clear;
  end;
  with Layout do
  begin
    StyleLeft := Left;
    StyleTop := Top;
  end;
end;

procedure TStyleNameForm.EditKeyDown(Sender: TObject; var Key: Word;
                                     Shift: TShiftState);
begin
  if Key = VK_DELETE then StyleAltered := true;
end;

procedure TStyleNameForm.EditKeyPress(Sender: TObject; var Key: Char);
begin
  StyleAltered := true;
end;

procedure TStyleNameForm.FormKeyDown(Sender: TObject; var Key: Word;
                                     Shift: TShiftState);
begin
  if Key = VK_ESCAPE then StyleListBox.ItemIndex := -1;
  if (Key = VK_DELETE) and (StyleListBox.Items.Count > 0) then
  begin
    StyleListBox.DeleteSelected;
    SaveToFile;
  end;
end;

procedure TStyleNameForm.SaveToFile;

var
  F: File of TPlotStyle;
  s: TPlotStyle;
  so: TPlotStyleObject;
  i: integer;

begin
  AssignFile(F, StyleFName);
  Rewrite(F);
  for i := 0 to StyleListBox.Count -1 do
  begin
    so := TPlotStyleObject(StyleListBox.Items.Objects[i]);
    s := so.Style;
    write(F, s);
  end;
  CloseFile(F);
end;

procedure TStyleNameForm.StyleListBoxDblClick(Sender: TObject);
begin
  Close;
end;

end.
