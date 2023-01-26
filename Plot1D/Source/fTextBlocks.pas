unit fTextBlocks;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.UITypes,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.ComCtrls,
  Vcl.CheckLst,
  Vcl.Buttons,
  Vcl.ExtCtrls,

  uGlobal;

type
  TTextBlocksForm = class(TForm)
    RichEdit: TRichEdit;
    BlockListBox: TCheckListBox;
    ApplyBitBtn: TBitBtn;
    BitBtn1: TBitBtn;
    Label2: TLabel;
    EditLeft: TEdit;
    EditTop: TEdit;
    Label3: TLabel;
    EditLineHeight: TEdit;
    UpDown1: TUpDown;
    ColorButton: TSpeedButton;
    ColorPanel: TPanel;
    FontButton: TSpeedButton;
    Label1: TLabel;
    AddButton: TSpeedButton;
    DeleteButton: TSpeedButton;
    UpButton: TSpeedButton;
    DownButton: TSpeedButton;
    EditCaption: TEdit;
    FontDialog: TFontDialog;
    ColorDialog: TColorDialog;
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FloatKeyPress(Sender: TObject; var Key: Char);
    procedure IntKeyPress(Sender: TObject; var Key: Char);
    procedure EditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EditLeftKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EditTopKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EditCaptionKeyUp(Sender: TObject; var Key: Word;
                                Shift: TShiftState);
    procedure IntKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure LineHeightChange(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure ApplyBitBtnClick(Sender: TObject);
    procedure FontButtonClick(Sender: TObject);
    procedure AddButtonClick(Sender: TObject);
    procedure BlockListBoxClick(Sender: TObject);
    procedure ColorPanelClick(Sender: TObject);
    procedure RichEditChange(Sender: TObject);
    procedure BlockListBoxClickCheck(Sender: TObject);
    procedure DeleteButtonClick(Sender: TObject);
    procedure UpButtonClick(Sender: TObject);
    procedure DownButtonClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
     
    TextData: TTextData;
    function DefaultData: TTextData;
    procedure UpdateTextLines;
  public
     
    procedure ClearTextBlocks;
    procedure UpdateRichLines;
    procedure ShowData(Sender: TObject);
  end;

var
  TextBlocksForm: TTextBlocksForm;

const
  yIncFactor = 1.65;

//=====================================================================
implementation
//=====================================================================

uses
  fMain;

{$R *.dfm}

procedure TTextBlocksForm.FormCloseQuery(Sender: TObject;
                                   var CanClose: Boolean);
begin
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

procedure TTextBlocksForm.FormDestroy(Sender: TObject);
var
  i: integer;

begin
  for i := 0 to BlocklistBox.Count - 1
  do BlockListBox.Items.Objects[i].Free;
  RichEdit.Clear;
end;

procedure TTextBlocksForm.FormShow(Sender: TObject);
begin
  Caption := GraphFName;
  if BlockListBox.Count = 0 then TextData := DefaultData
  else
  begin
    UpdateRichLines;
    ColorPanel.Color := RichEdit.DefAttributes.Color;
    with BlockListBox do
    TextData := TTextDataObject(Items.Objects[ItemIndex]).Data;
    with FontDialog.Font, TextData do
    begin
      Name := FontName;
      Size := FontSize;
      Style := FontStyle;
      Color := ColorPanel.Color;
    end;
  end;
  ShowData(Sender);
end;

procedure TTextBlocksForm.FloatKeyPress(Sender: TObject; var Key: Char);
begin
  with Sender as TEdit do
  if not CharInSet(Key, ['-', '0'..'9', '.', 'e', 'E', #8]) then Key := #0
  else if Active then ApplyBitBtn.Visible := RichEdit.Lines.Count > 0;
end;

procedure TTextBlocksForm.IntKeyPress(Sender: TObject; var Key: Char);
begin
  with Sender as TEdit do
  if not CharInSet(Key, ['0'..'9', #8]) then Key := #0
  else ApplyBitBtn.Visible := RichEdit.Lines.Count > 0;
end;

procedure TTextBlocksForm.EditKeyDown(Sender: TObject; var Key: Word;
                                       Shift: TShiftState);
begin
  if (Key = VK_DELETE) or (Key = VK_BACK)
  then ApplyBitBtn.Visible := RichEdit.Lines.Count > 0;
end;

procedure TTextBlocksForm.EditLeftKeyUp(Sender: TObject; var Key: Word;
                                         Shift: TShiftState);
begin
  with TextData do
  try
    xLoc := StrToFloat(EditLeft.Text);
  except
    if GraphData.Grid.xAxisStyle = asLog then xLoc :=  0.1 else xLoc := -0.1;
  end;
  with BlockListBox do
  TTextDataObject(Items.Objects[ItemIndex]).Data.xLoc := TextData.xLoc;
  ApplyBitBtn.Visible := RichEdit.Lines.Count > 0;
end;

procedure TTextBlocksForm.EditTopKeyUp(Sender: TObject; var Key: Word;
                                        Shift: TShiftState);
begin
  with TextData do
  try
    yLoc := StrToFloat(EditTop.Text);
  except
    if GraphData.Grid.yAxisStyle = asLog then yLoc :=  0.1 else yLoc := -0.1;
  end;
  with BlockListBox do
  TTextDataObject(Items.Objects[ItemIndex]).Data.yLoc := TextData.yLoc;
  ApplyBitBtn.Visible := RichEdit.Lines.Count > 0;
end;

procedure TTextBlocksForm.EditCaptionKeyUp(Sender: TObject; var Key: Word;
                                            Shift: TShiftState);
begin
  with BlockListBox do
  begin
    TTextDataObject(Items.Objects[ItemIndex]).Data.Caption := EditCaption.Text;
    Items[ItemIndex] := EditCaption.Text;
  end;
end;

procedure TTextBlocksForm.RichEditChange(Sender: TObject);
begin
  if Active then
  begin
    ApplyBitBtn.Visible := (BlockListBox.Count > 0) and
   (TTextDataObject(BlockListBox.Items.Objects[BlockListBox.ItemIndex]).
     TextLines.Count > 0) and (RichEdit.Lines.Count > 0);
  end;
end;

procedure TTextBlocksForm.IntKeyUp(Sender: TObject; var Key: Word;
                                    Shift: TShiftState);
begin
  if Active then
  begin
    with Sender as TEdit do
    try
      TextData.yInc := StrToInt(Text);
    except
      TextData.yInc := round(TextData.FontSize*yIncFactor);
    end;
    with BlockListBox do
    TTextDataObject(Items.Objects[ItemIndex]).Data.yInc := TextData.yInc;
    ApplyBitBtn.Visible := RichEdit.Lines.Count > 0;
  end;
end;

procedure TTextBlocksForm.LineHeightChange(Sender: TObject);
var
  k: word;

begin
  if Active then
  begin
    k := 0;
    IntKeyUp(Sender, k, []);
  end;
end;

procedure TTextBlocksForm.BitBtn1Click(Sender: TObject);
begin
  Close;
end;

procedure TTextBlocksForm.ApplyBitBtnClick(Sender: TObject);
begin
  UpdateTextLines;
  Altered := True;
  MainForm.GLViewer.Invalidate;
  ApplyBitBtn.Visible := False;
end;

procedure TTextBlocksForm.FontButtonClick(Sender: TObject);
var
  Cpos: integer;
  i: integer;

begin
  if RichEdit.Lines.Count = 0 then RichEdit.Lines.Add('Sample text.');
  UpdateTextLines;
  Cpos := RichEdit.SelStart;

  if FontDialog.Execute then
  begin
    with TextData, FontDialog.Font do
    begin
      FontName := Name;
      FontStyle := Style;
      FontSize := Size;
      FontColor := Color;
      yInc := round(FontSize*yIncFactor);
      ColorPanel.Color := FontColor;
      UpDown1.Position := yInc;
    end;

    with FontDialog,
    TTextDataObject(BlockListBox.Items.Objects[BlockListBox.ItemIndex]) do
    begin
      with Data do
      begin
        FontName := Font.Name;
        FontStyle := Font.Style;
        FontSize := Font.Size;
        FontColor := Font.Color;
        yInc := round(FontSize*yIncFactor);

        with RichEdit do if Lines.Count > 0 then
        begin
          UpdateTextLines;
          TextLines.Clear;
          for i := 0 to Lines.Count -1
          do TextLines.Add(TTextLineObject.Create(Lines[i], FontColor));
          Lines.Clear;
          with DefAttributes do
          begin
            Name := FontName;
            Style := FontStyle;
            Size := FontSize;
            Color := FontColor;
          end;
          for i := 0 to TextLines.Count -1 do
          with TTextLineObject(TextLines[i]) do Lines.Add(Text);
        end;

      end;
    end;
    RichEdit.SelStart := Cpos;
    ApplyBitBtn.Visible := RichEdit.Lines.Count > 0;
  end;
end;

procedure TTextBlocksForm.AddButtonClick(Sender: TObject);
begin
  with BlockListBox do
  begin
    if Count = 0 then TextData := DefaultData
    else TextData := TTextDataObject(Items.Objects[ItemIndex]).Data;

    with FontDialog.Font, TextData do
    begin
      Name := FontName;
      Size := FontSize;
      Style := FontStyle;
      Color := FontColor;
    end;

    with TextData do Caption := 'Text Block';
    AddItem(TextData.Caption, TTextDataObject.Create(TextData));
    ItemIndex := Count -1;
    Checked[ItemIndex] := True;
    RichEdit.Clear;
  end;
  ShowData(Sender);
  EditCaption.SetFocus;
  FontButtonClick(Sender);
end;

procedure TTextBlocksForm.BlockListBoxClick(Sender: TObject);
begin
  with BlockListBox do
  TextData := TTextDataObject(Items.Objects[ItemIndex]).Data;

  with FontDialog.Font, TextData do
  begin
    Name := FontName;
    Size := FontSize;
    Style := FontStyle;
    Color := FontColor;
    ColorPanel.Color := Color;
  end;

  UpdateRichLines;
  ShowData(Sender);
end;

procedure TTextBlocksForm.BlockListBoxClickCheck(Sender: TObject);
begin
  ApplyBitBtn.Visible := True;
end;

procedure TTextBlocksForm.ColorPanelClick(Sender: TObject);
var
  Cpos: integer;
  idx: cardinal;
  s: string;

begin
  with RichEdit do
  begin
    if Lines.Count = 0 then
    begin
      Lines.Add('Sample text.');
      UpdateTextLines;
      SelStart := 1;
    end;

    Cpos := SelStart;

    if ActiveLineNo >= cardinal(Lines.Count) then SelStart := Length(Text) -1;
  end;
  MainForm.StatusBar.Panels[2].Text := '';

  ColorDialog.Color := ColorPanel.Color;
  if ColorDialog.Execute then
  begin
    ColorPanel.Color := ColorDialog.Color;
    with RichEdit do
    begin
      Idx := ActiveLineNo;
      s := Lines[Idx];
      Lines.Delete(Idx);
      SelAttributes.Color := ColorPanel.Color;
      Lines.Insert(Idx, s);
    end;
  end;

  RichEdit.SelStart := cPos;
  ApplyBitBtn.Visible := RichEdit.Lines.Count > 0;
end;

function TTextBlocksForm.DefaultData: TTextData;
begin
  with Result do
  begin
    Caption := 'Text Block #';
    xLoc := 0.0;
    yLoc := 0.0;
    FontName := 'Tahoma';
    FontStyle := [];
    FontSize := 12;
    FontColor := clBlack;
    yInc := round(FontSize*yIncFactor);
  end;
end;

procedure TTextBlocksForm.DeleteButtonClick(Sender: TObject);
var
  i: integer;

begin
  if BlockListBox.Count > 0 then
  begin
    RichEdit.Clear;
    with BlockListBox do
    begin
      i := ItemIndex;
      with Items.Objects[i] as TTextDataObject do Free;
      Items.Delete(i);
      if i > Count -1 then i := Count -1;
      ItemIndex := i;
      DeleteButton.Enabled := Count > 0;
    end;

    if BlockListBox.Count > 0 then BlockListBoxClick(Sender);
    ApplyBitBtn.Visible := True;
  end;
end;

procedure TTextBlocksForm.DownButtonClick(Sender: TObject);
var
  i: integer;

begin
  with BlockListBox do
  begin
    i := ItemIndex;
    if i < Count -1 then Items.Move(i, i+1);
    ItemIndex := i+1;
  end;
  BlockListBoxClick(Sender);
end;

procedure TTextBlocksForm.ShowData(Sender: TObject);
var
  a: Boolean;

begin
{ if BlockListBox.Count = 0 then disable all except AddButton }
  a := Altered;
  RichEdit.Color := GraphData.BackColor;
  DeleteButton.Enabled := BlockListBox.Count > 0;
  UpButton.Enabled := DeleteButton.Enabled and (BlockListBox.Count > 1);
  DownButton.Enabled := DeleteButton.Enabled and (BlockListBox.Count > 1);
  FontButton.Enabled := DeleteButton.Enabled;
  BlockListBox.Enabled := DeleteButton.Enabled;
  EditCaption.Enabled := DeleteButton.Enabled;
  EditLeft.Enabled := DeleteButton.Enabled;
  EditTop.Enabled := DeleteButton.Enabled;
  EditLineHeight.Enabled := DeleteButton.Enabled;
  upDown1.Enabled := DeleteButton.Enabled;
  ColorButton.Enabled := DeleteButton.Enabled;
  ColorPanel.Enabled := DeleteButton.Enabled;
  RichEdit.Enabled := DeleteButton.Enabled;
  ApplyBitBtn.Visible := Active and (Sender.ClassName <> 'TSpeedButton') and
                                (RichEdit.Lines.Count > 0);

  with BlockListBox do if Count > 0 then
  begin;
    with TTextDataObject(Items.Objects[ItemIndex]).Data do
    begin
      EditCaption.Text := Caption;
      EditLeft.Text := FloatToStrF(xLoc, ffGeneral, 4, 3);
      EditTop.Text := FloatToStrF(yLoc, ffGeneral, 4, 3);
      EditLineHeight.Text := IntToStr(yInc);

      with RichEdit, TTextDataObject(Items.Objects[ItemIndex]) do
      if (Lines.Count > 1) and (ActiveLineNo < cardinal(Lines.Count))
      then ColorDialog.Color := TTextLineObject(TextLines[ActiveLineNo]).Color;
    end;
  end;
  Altered := a;
end;

procedure TTextBlocksForm.UpButtonClick(Sender: TObject);
var
  i: integer;

begin
  with BlockListBox do
  begin
    i := ItemIndex;
    if i > 0 then Items.Move(i, i-1);
    if i > 1 then ItemIndex := i-1 else ItemIndex := 0;
  end;
  BlockListBoxClick(Sender);
end;

procedure TTextBlocksForm.UpdateTextLines;
var
  i: integer;

begin
  with BlockListBox, TTextDataObject(Items.Objects[ItemIndex]) do
  begin
    for i := 0 to TextLines.Count -1 do
    begin
      TTextLineObject(TextLines.Items[i]).Free;
    end;
    TextLines.Clear;
  end;

  RichEdit.SelStart := 0;
  with BlockListBox, TTextDataObject(Items.Objects[ItemIndex]) do
  for i := 0 to RichEdit.Lines.Count -1 do
  begin
    TextLines.Add(TTextLineObject.Create(RichEdit.Lines[i],
                                         RichEdit.SelAttributes.Color));

    RichEdit.SelStart := RichEdit.SelStart + Length(RichEdit.Lines[i]) +1;
  end;
end;

procedure TTextBlocksForm.UpdateRichLines;
var
  i: integer;

begin
  with TTextDataObject(BlockListBox.Items.Objects[BlockListBox.ItemIndex]) do
  begin
    with RichEdit.DefAttributes do
    begin
      Name := Data.FontName;
      Style := Data.FontStyle;
      Size := Data.FontSize;
      Color := Data.FontColor;
    end;

    with RichEdit do
    begin
      Lines.Clear;
      for i := 0 to TextLines.Count -1 do
      with TTextLineObject(TextLines.Items[i]) do
      begin
        SelAttributes.Color := Color;
        Lines.Add(Text);
      end;
    end;
  end;
end;

procedure TTextBlocksForm.ClearTextBlocks;
var
  i: integer;

begin
  with BlockListBox do
  begin
    for i := 0 to Count -1 do Items.Objects[i].Free;
    Clear;
  end;

  RichEdit.Clear;
end;

end.
