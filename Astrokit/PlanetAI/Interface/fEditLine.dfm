object fmEditLine: TfmEditLine
  Left = 241
  Top = 234
  Caption = 'Edit'
  ClientHeight = 101
  ClientWidth = 439
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Position = poOwnerFormCenter
  PixelsPerInch = 120
  TextHeight = 16
  object labName: TLabel
    Left = 23
    Top = 15
    Width = 40
    Height = 16
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Name:'
  end
  object edLine: TEdit
    Left = 23
    Top = 39
    Width = 313
    Height = 24
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    TabOrder = 0
  end
  object BitBtn1: TBitBtn
    Left = 348
    Top = 38
    Width = 93
    Height = 31
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Kind = bkOK
    NumGlyphs = 2
    TabOrder = 1
  end
  object BitBtn2: TBitBtn
    Left = 348
    Top = 75
    Width = 93
    Height = 31
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Kind = bkCancel
    NumGlyphs = 2
    TabOrder = 2
  end
end
