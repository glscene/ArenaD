object fmDNA: TfmDNA
  Left = 531
  Top = 210
  Caption = 'DNA'
  ClientHeight = 460
  ClientWidth = 479
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  Position = poOwnerFormCenter
  OnShow = FormShow
  PixelsPerInch = 120
  TextHeight = 16
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 479
    Height = 46
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alTop
    TabOrder = 0
    object Panel1: TPanel
      Left = 1
      Top = 1
      Width = 85
      Height = 44
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alLeft
      BevelOuter = bvNone
      Caption = 'Creature:'
      TabOrder = 0
    end
    object panID: TPanel
      Left = 86
      Top = 1
      Width = 392
      Height = 44
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alClient
      Alignment = taLeftJustify
      BevelOuter = bvNone
      Caption = 'ID'
      TabOrder = 1
    end
  end
  object Panel4: TPanel
    Left = 0
    Top = 46
    Width = 479
    Height = 47
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object Panel5: TPanel
      Left = 0
      Top = 0
      Width = 116
      Height = 47
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alLeft
      BevelOuter = bvNone
      Caption = 'Mutation:'
      TabOrder = 0
    end
  end
  object Panel6: TPanel
    Left = 0
    Top = 93
    Width = 479
    Height = 46
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    object Panel7: TPanel
      Left = 0
      Top = 0
      Width = 116
      Height = 46
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alLeft
      BevelOuter = bvNone
      Caption = 'Buoyancy:'
      TabOrder = 0
    end
  end
  object Panel12: TPanel
    Left = 0
    Top = 185
    Width = 479
    Height = 46
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 3
    object Panel13: TPanel
      Left = 0
      Top = 0
      Width = 116
      Height = 46
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alLeft
      BevelOuter = bvNone
      Caption = 'Preferred Food:'
      TabOrder = 0
    end
  end
  object panButtonBar: TPanel
    Left = 0
    Top = 409
    Width = 479
    Height = 51
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alBottom
    BevelOuter = bvLowered
    TabOrder = 4
    object panOKButton: TPanel
      Left = 348
      Top = 1
      Width = 130
      Height = 49
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      object btnOK: TBitBtn
        Left = 23
        Top = 10
        Width = 93
        Height = 31
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Kind = bkOK
        NumGlyphs = 2
        TabOrder = 0
        OnClick = btnOKClick
      end
    end
    object btnCancel: TBitBtn
      Left = 10
      Top = 10
      Width = 94
      Height = 31
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 1
      OnClick = btnCancelClick
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 139
    Width = 479
    Height = 46
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 5
    object Panel8: TPanel
      Left = 0
      Top = 0
      Width = 116
      Height = 46
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alLeft
      BevelOuter = bvNone
      Caption = 'Bounce:'
      TabOrder = 0
    end
  end
  object Panel9: TPanel
    Left = 0
    Top = 324
    Width = 479
    Height = 46
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 6
    object Panel10: TPanel
      Left = 0
      Top = 0
      Width = 116
      Height = 46
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alLeft
      BevelOuter = bvNone
      Caption = 'Green:'
      TabOrder = 0
    end
  end
  object Panel11: TPanel
    Left = 0
    Top = 278
    Width = 479
    Height = 46
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 7
    object Panel14: TPanel
      Left = 0
      Top = 0
      Width = 116
      Height = 46
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alLeft
      BevelOuter = bvNone
      Caption = 'Blue:'
      TabOrder = 0
    end
  end
  object Panel15: TPanel
    Left = 0
    Top = 231
    Width = 479
    Height = 47
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 8
    object Panel16: TPanel
      Left = 0
      Top = 0
      Width = 116
      Height = 47
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alLeft
      BevelOuter = bvNone
      Caption = 'Red:'
      TabOrder = 0
    end
  end
  object Panel17: TPanel
    Left = 0
    Top = 358
    Width = 479
    Height = 51
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alBottom
    BevelOuter = bvLowered
    TabOrder = 9
    object btnLoadDNA: TBitBtn
      Left = 13
      Top = 8
      Width = 136
      Height = 31
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Load DNA File'
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000130B0000130B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0033333333B333
        333B33FF33337F3333F73BB3777BB7777BB3377FFFF77FFFF77333B000000000
        0B3333777777777777333330FFFFFFFF07333337F33333337F333330FFFFFFFF
        07333337F3FF3FFF7F333330F00F000F07333337F77377737F333330FFFFFFFF
        07333FF7F3FFFF3F7FFFBBB0F0000F0F0BB37777F7777373777F3BB0FFFFFFFF
        0BBB3777F3FF3FFF77773330F00F000003333337F773777773333330FFFF0FF0
        33333337F3FF7F37F3333330F08F0F0B33333337F7737F77FF333330FFFF003B
        B3333337FFFF77377FF333B000000333BB33337777777F3377FF3BB3333BB333
        3BB33773333773333773B333333B3333333B7333333733333337}
      NumGlyphs = 2
      TabOrder = 0
      OnClick = LoadDNA1Click
    end
    object btnSaveDNA: TBitBtn
      Left = 160
      Top = 8
      Width = 139
      Height = 31
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Save DNA File'
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000130B0000130B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333330070
        7700333333337777777733333333008088003333333377F73377333333330088
        88003333333377FFFF7733333333000000003FFFFFFF77777777000000000000
        000077777777777777770FFFFFFF0FFFFFF07F3333337F3333370FFFFFFF0FFF
        FFF07F3FF3FF7FFFFFF70F00F0080CCC9CC07F773773777777770FFFFFFFF039
        99337F3FFFF3F7F777F30F0000F0F09999937F7777373777777F0FFFFFFFF999
        99997F3FF3FFF77777770F00F000003999337F773777773777F30FFFF0FF0339
        99337F3FF7F3733777F30F08F0F0337999337F7737F73F7777330FFFF0039999
        93337FFFF7737777733300000033333333337777773333333333}
      NumGlyphs = 2
      TabOrder = 1
      OnClick = SaveDNA1Click
    end
  end
  object OpenDNADialog: TOpenDialog
    Left = 120
    Top = 5
  end
  object SaveDNADialog: TSaveDialog
    Left = 88
    Top = 5
  end
  object MainMenu1: TMainMenu
    Left = 152
    Top = 6
    object File1: TMenuItem
      Caption = '&File'
      object LoadDNA1: TMenuItem
        Caption = '&Load DNA'
        OnClick = LoadDNA1Click
      end
      object SaveDNA1: TMenuItem
        Caption = '&Save DNA'
        OnClick = SaveDNA1Click
      end
    end
  end
end
