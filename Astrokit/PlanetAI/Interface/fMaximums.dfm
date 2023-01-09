object fmMaximums: TfmMaximums
  Left = 311
  Top = 150
  Caption = 'Maximums'
  ClientHeight = 633
  ClientWidth = 553
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Position = poOwnerFormCenter
  OnShow = FormShow
  PixelsPerInch = 120
  TextHeight = 16
  object BackPanel: TPanel
    Left = 0
    Top = 0
    Width = 553
    Height = 543
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alClient
    BorderWidth = 2
    TabOrder = 0
    object ListBox: TListBox
      Left = 3
      Top = 3
      Width = 547
      Height = 537
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alClient
      TabOrder = 0
      OnClick = ListBoxClick
    end
    object EditMax: TEdit
      Left = 100
      Top = 180
      Width = 151
      Height = 24
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      TabOrder = 1
      Text = 'EditMax'
    end
  end
  object panButtonBar: TPanel
    Left = 0
    Top = 581
    Width = 553
    Height = 52
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alBottom
    BevelOuter = bvLowered
    TabOrder = 1
    object panOKButton: TPanel
      Left = 422
      Top = 1
      Width = 130
      Height = 50
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      object btnOK: TBitBtn
        Left = 13
        Top = 8
        Width = 93
        Height = 31
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Kind = bkOK
        NumGlyphs = 2
        TabOrder = 0
      end
    end
    object btnEdit: TBitBtn
      Left = 293
      Top = 10
      Width = 93
      Height = 31
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = '&Commit'
      Kind = bkHelp
      NumGlyphs = 2
      TabOrder = 1
      OnClick = btnEditClick
    end
    object btnDefaults: TBitBtn
      Left = 20
      Top = 10
      Width = 94
      Height = 31
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Defaults'
      TabOrder = 2
      OnClick = btnDefaultsClick
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 543
    Width = 553
    Height = 38
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alBottom
    Caption = 
      'Click on a Thing, enter a new value in the box below, then press' +
      ' the Commit button.'
    TabOrder = 2
  end
end
