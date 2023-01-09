object fmCreatingGalaxy: TfmCreatingGalaxy
  Left = 369
  Top = 158
  Caption = 'Creating Galaxy'
  ClientHeight = 368
  ClientWidth = 500
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010001002020100000000000E80200001600000028000000200000004000
    0000010004000000000080020000000000000000000000000000000000000000
    000000008000008000000080800080000000800080008080000080808000C0C0
    C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    00000000000000000000000000000008FFF00000000000000000000000000088
    7777000000000000000000000000008800770F00000000000000000000000880
    88F70FFF0000000000000000000008808880FFFFF00000000000000000000888
    000FFF8FFFF0000000000000000007888800F8088FFF00000000000000000078
    888800F0088F8800000000000000000077700FFFF00888880000000000000000
    000FFFFFFFF088800000000000000000000000FFF8880008BBBBBB8800000000
    000000000800BBBBBBBBBBBBB80000000000000000BBBBBBBBBBBBBBBBB00000
    00000000BBBBBBBBB0000BBBBBB00000000000BB87000000000BB0BBBB800000
    000000008B8BBBBBBBBBB00BB80000000000BBBBBBBBBBBBBBBBBBB000000000
    00BBBBBB0000000000BBB0BB0F000000BBBBB0008888888870BB0B0B0FF0000B
    BBB00888BBBBBBB070BB0BB00FF0000BB0088BBBBBBBBBB070BB0B700000000B
    088BBBBBBBBBBB070BB0BB00000000008BBBBBBBBBBBBB070BB0BB0000000000
    0BBBBBBBBBBBB070BB0BB7000000000008BBBBBBBBBBB070BB0BB00000000000
    008BBBBBBBBB070BB0BB0000000000000000BBBBBBB070BB0BB0000000000000
    0000088888070BB0B0000000000000000000000000BBBB000000000000000000
    00000000BBBB000000000000000000000000000000000000000000000000E07F
    FFFFC01FFFFF8007FFFF8003FFFF0000FFFF00007FFF00001FFF000007FF8000
    03FFC0000007F0000001FC000000FFC00000FFE00000FFC00000FF800000FE00
    0001F8000000F0000000E0000000C0000000C0000009C000000FC000000FF000
    001FF000003FF800007FFC0000FFFF0001FFFF8007FFFFC03FFFFFF0FFFF}
  PixelsPerInch = 120
  TextHeight = 16
  object Panel1: TPanel
    Left = 0
    Top = 51
    Width = 500
    Height = 317
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 10
    TabOrder = 0
    object redStatus: TRichEdit
      Left = 10
      Top = 10
      Width = 480
      Height = 246
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alClient
      Color = clBlack
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clSilver
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 0
    end
    object Panel3: TPanel
      Left = 10
      Top = 256
      Width = 480
      Height = 51
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alBottom
      TabOrder = 1
      object BitBtn1: TBitBtn
        Left = 383
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
      end
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 500
    Height = 51
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alTop
    BevelOuter = bvNone
    BorderWidth = 10
    TabOrder = 1
    object pbTextures: TProgressBar
      Left = 10
      Top = 10
      Width = 480
      Height = 31
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alClient
      TabOrder = 0
    end
  end
end
