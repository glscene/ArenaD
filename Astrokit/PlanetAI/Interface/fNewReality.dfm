object fmNewReality: TfmNewReality
  Left = 330
  Top = 148
  Width = 439
  Height = 488
  Caption = 'New Planet'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010001002020100000000000E80200001600000028000000200000004000
    0000010004000000000080020000000000000000000000000000000000000000
    000000008000008000000080800080000000800080008080000080808000C0C0
    C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000330000000000000000000000033303303303300000000000000
    0003303330333003003300000000000000033003330330002333000000000000
    0030000033003033333000000000000033333330000003330003330000000803
    33333333333333300233330000000F033333333333333302333BB03000004F83
    33333333333333333BB003BB00004FF3333333333333B33BB0033BBB00004FF3
    33333333B3BB3BB0033BBBB000004FF83B333B3B3B3BBBB03BBBBB0300F04FFF
    33B3B3B3BBBBBBBBBBBB00330FF04FFF8B3B3333BBBBBBBBBB0033330FF044FF
    F8BBB03033BBBBB330333330FFF444FFF8BB0BB3003B330003333330FF44444F
    F88B3BBB300000033333B33FFF44444FFF3BB0BBB3000333B33BB38FF4444444
    FF003B0BB333333BBBBBB3FFF44444444FF00030BBBBBBBBBBBBBBFF44444444
    0000000303BBB3300000BFF444444400000000000000000000000FF444440000
    0000000000000000000000444444000000000000000000000000000044440000
    0000000000000000000000000444000000000000000000000000000000040000
    000000000000000000000000000000000000000000000000000000000000FFFF
    FFFFFFFFFFFFFFFF1FFFFF8003FFFC0000FFF800007FF800007FE000003F0000
    001F0000001F0000000F00000007000000070000000000000000000000000000
    00000000000000000000000000000000000000000000000000000000000000C0
    00000FE01F003FFFFF80FFFFFFC0FFFFFFF0FFFFFFF8FFFFFFFEFFFFFFFF}
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 29
    Width = 431
    Height = 29
    Align = alTop
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 1
    object Panel2: TPanel
      Left = 0
      Top = 0
      Width = 100
      Height = 29
      Align = alLeft
      Alignment = taRightJustify
      BevelOuter = bvNone
      BorderWidth = 5
      Caption = 'User Name:'
      ParentColor = True
      TabOrder = 0
    end
    object edCreator: TEdit
      Left = 102
      Top = 4
      Width = 189
      Height = 21
      TabOrder = 1
      Text = 'User'
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 58
    Width = 431
    Height = 29
    Align = alTop
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 2
    object Panel4: TPanel
      Left = 0
      Top = 0
      Width = 100
      Height = 29
      Align = alLeft
      Alignment = taRightJustify
      BevelOuter = bvNone
      BorderWidth = 5
      Caption = 'Map Width:'
      ParentColor = True
      TabOrder = 0
    end
    object edWidth: TEdit
      Left = 102
      Top = 4
      Width = 51
      Height = 21
      ReadOnly = True
      TabOrder = 1
      Text = '20'
    end
    object UpDownWidth: TUpDown
      Left = 152
      Top = 0
      Width = 17
      Height = 25
      Min = 2
      Max = 80
      Increment = 2
      Position = 20
      TabOrder = 2
      OnClick = UpDownWidthClick
    end
  end
  object Panel5: TPanel
    Left = 0
    Top = 0
    Width = 431
    Height = 29
    Align = alTop
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 0
    object Panel6: TPanel
      Left = 0
      Top = 0
      Width = 100
      Height = 29
      Align = alLeft
      Alignment = taRightJustify
      BevelOuter = bvNone
      BorderWidth = 5
      Caption = 'Planet Name:'
      ParentColor = True
      TabOrder = 0
    end
    object edEnvironment: TEdit
      Left = 102
      Top = 4
      Width = 189
      Height = 21
      TabOrder = 1
      Text = 'myPlanet'
    end
  end
  object Panel7: TPanel
    Left = 0
    Top = 87
    Width = 431
    Height = 29
    Align = alTop
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 3
    object Panel8: TPanel
      Left = 0
      Top = 0
      Width = 100
      Height = 29
      Align = alLeft
      Alignment = taRightJustify
      BevelOuter = bvNone
      BorderWidth = 5
      Caption = 'Map Height:'
      ParentColor = True
      TabOrder = 0
    end
    object edHeight: TEdit
      Left = 102
      Top = 4
      Width = 51
      Height = 21
      ReadOnly = True
      TabOrder = 1
      Text = '11'
    end
    object UpDownHeight: TUpDown
      Left = 152
      Top = 0
      Width = 17
      Height = 25
      Min = 2
      Max = 40
      Position = 11
      TabOrder = 2
      OnClick = UpDownHeightClick
    end
  end
  object Panel11: TPanel
    Left = 0
    Top = 145
    Width = 431
    Height = 29
    Align = alTop
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 4
    Visible = False
    object Panel12: TPanel
      Left = 0
      Top = 0
      Width = 129
      Height = 29
      Align = alLeft
      Alignment = taRightJustify
      BevelOuter = bvNone
      BorderWidth = 5
      Caption = 'Water Surface Tension:'
      ParentColor = True
      TabOrder = 0
    end
    object edTension: TEdit
      Left = 142
      Top = 4
      Width = 51
      Height = 21
      ReadOnly = True
      TabOrder = 1
      Text = '2'
    end
    object UpDownTension: TUpDown
      Left = 192
      Top = 0
      Width = 17
      Height = 25
      Max = 20
      Position = 2
      TabOrder = 2
      OnClick = UpDownTensionClick
    end
  end
  object Panel19: TPanel
    Left = 0
    Top = 174
    Width = 431
    Height = 41
    Align = alTop
    TabOrder = 5
    object btnBarren: TBitBtn
      Left = 40
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Barren'
      TabOrder = 0
      OnClick = btnBarrenClick
    end
    object btnDirty: TBitBtn
      Left = 120
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Dirty'
      TabOrder = 1
      OnClick = btnDirtyClick
    end
    object btnGrass: TBitBtn
      Left = 200
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Grasslands'
      TabOrder = 2
      OnClick = btnGrassClick
    end
    object btnWatery: TBitBtn
      Left = 280
      Top = 8
      Width = 85
      Height = 25
      Caption = 'Underwater'
      TabOrder = 3
      OnClick = btnWateryClick
    end
  end
  object Panel20: TPanel
    Left = 0
    Top = 410
    Width = 431
    Height = 44
    Align = alBottom
    TabOrder = 7
    object Panel22: TPanel
      Left = 253
      Top = 1
      Width = 177
      Height = 42
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      object BitBtn1: TBitBtn
        Left = 86
        Top = 8
        Width = 75
        Height = 25
        TabOrder = 0
        Kind = bkOK
      end
      object BitBtn2: TBitBtn
        Left = 6
        Top = 8
        Width = 75
        Height = 25
        TabOrder = 1
        Kind = bkCancel
      end
    end
  end
  object Panel23: TPanel
    Left = 0
    Top = 215
    Width = 431
    Height = 195
    Align = alClient
    TabOrder = 6
    object Panel21: TPanel
      Left = 1
      Top = 1
      Width = 240
      Height = 193
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      object Panel13: TPanel
        Left = 0
        Top = 33
        Width = 240
        Height = 29
        Align = alTop
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 0
        object Panel14: TPanel
          Left = 0
          Top = 0
          Width = 129
          Height = 29
          Align = alLeft
          Alignment = taRightJustify
          BevelOuter = bvNone
          BorderWidth = 5
          Caption = 'Water:'
          ParentColor = True
          TabOrder = 0
        end
        object edWater: TEdit
          Left = 142
          Top = 4
          Width = 51
          Height = 21
          ReadOnly = True
          TabOrder = 1
          Text = '20'
        end
        object UpDownWater: TUpDown
          Left = 192
          Top = 0
          Width = 17
          Height = 25
          Max = 50
          Position = 20
          TabOrder = 2
          OnClick = UpDownWaterClick
        end
      end
      object Panel9: TPanel
        Left = 0
        Top = 62
        Width = 240
        Height = 29
        Align = alTop
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 1
        object Panel10: TPanel
          Left = 0
          Top = 0
          Width = 129
          Height = 29
          Align = alLeft
          Alignment = taRightJustify
          BevelOuter = bvNone
          BorderWidth = 5
          Caption = 'Height:'
          ParentColor = True
          TabOrder = 0
        end
        object edLandHeight: TEdit
          Left = 142
          Top = 4
          Width = 51
          Height = 21
          ReadOnly = True
          TabOrder = 1
          Text = '10'
        end
        object UpDownLandHeight: TUpDown
          Left = 192
          Top = 0
          Width = 17
          Height = 25
          Max = 25
          Position = 10
          TabOrder = 2
          OnClick = UpDownLandHeightClick
        end
      end
      object Panel17: TPanel
        Left = 0
        Top = 91
        Width = 240
        Height = 29
        Align = alTop
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 2
        object Panel18: TPanel
          Left = 0
          Top = 0
          Width = 129
          Height = 29
          Align = alLeft
          Alignment = taRightJustify
          BevelOuter = bvNone
          BorderWidth = 5
          Caption = 'Humidity:'
          ParentColor = True
          TabOrder = 0
        end
        object edHumidity: TEdit
          Left = 142
          Top = 4
          Width = 51
          Height = 21
          ReadOnly = True
          TabOrder = 1
          Text = '0'
        end
        object UpDownHumidity: TUpDown
          Left = 192
          Top = 0
          Width = 17
          Height = 25
          Max = 10
          TabOrder = 2
          OnClick = UpDownHumidityClick
        end
      end
      object Panel15: TPanel
        Left = 0
        Top = 120
        Width = 240
        Height = 29
        Align = alTop
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 3
        object Panel16: TPanel
          Left = 0
          Top = 0
          Width = 129
          Height = 29
          Align = alLeft
          Alignment = taRightJustify
          BevelOuter = bvNone
          BorderWidth = 5
          Caption = 'Temperature:'
          ParentColor = True
          TabOrder = 0
        end
        object edTemp: TEdit
          Left = 142
          Top = 4
          Width = 51
          Height = 21
          ReadOnly = True
          TabOrder = 1
          Text = '2'
        end
        object UpDownTemp: TUpDown
          Left = 192
          Top = 0
          Width = 17
          Height = 25
          Max = 10
          Position = 2
          TabOrder = 2
          OnClick = UpDownTempClick
        end
      end
      object Panel25: TPanel
        Left = 0
        Top = 0
        Width = 240
        Height = 33
        Align = alTop
        Alignment = taLeftJustify
        BevelOuter = bvNone
        TabOrder = 4
        object Label2: TLabel
          Left = 14
          Top = 10
          Width = 64
          Height = 13
          Caption = 'Grid Defaults:'
        end
      end
    end
    object Panel24: TPanel
      Left = 241
      Top = 1
      Width = 189
      Height = 193
      Align = alClient
      TabOrder = 1
      object Label1: TLabel
        Left = 14
        Top = 8
        Width = 91
        Height = 13
        Caption = 'Terrain Generation:'
      end
      object cbContinents: TCheckBox
        Left = 32
        Top = 36
        Width = 97
        Height = 17
        Caption = 'Continents'
        ParentShowHint = False
        ShowHint = False
        TabOrder = 0
      end
      object cbIslands: TCheckBox
        Left = 32
        Top = 62
        Width = 97
        Height = 17
        Caption = 'Islands'
        TabOrder = 3
      end
      object cbHalo: TCheckBox
        Left = 32
        Top = 86
        Width = 97
        Height = 17
        Hint = 'Generates a ring of raised land about the equator.'
        Caption = 'Halo'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 6
      end
      object cbSun: TCheckBox
        Left = 32
        Top = 112
        Width = 97
        Height = 17
        Hint = 'Automatically create a sun.'
        Caption = 'Sun'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 7
      end
      object edContinents: TEdit
        Left = 110
        Top = 34
        Width = 43
        Height = 21
        ReadOnly = True
        TabOrder = 1
        Text = '7'
      end
      object edIslands: TEdit
        Left = 110
        Top = 60
        Width = 43
        Height = 21
        ReadOnly = True
        TabOrder = 4
        Text = '4'
      end
      object cbFrozenPoles: TCheckBox
        Left = 32
        Top = 136
        Width = 97
        Height = 17
        Hint = 'Lower the temperature of the poles to frozen.'
        Caption = 'Frozen Poles'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 8
      end
      object cbFuzzy: TCheckBox
        Left = 32
        Top = 160
        Width = 97
        Height = 17
        Hint = 'Randomly raise/lower grid heights by small amounts.'
        Caption = 'Fuzzy Land'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 9
      end
      object UpDownContinents: TUpDown
        Left = 152
        Top = 32
        Width = 17
        Height = 25
        Max = 16
        Position = 7
        TabOrder = 2
        OnClick = UpDownContinentsClick
      end
      object UpDownIslands: TUpDown
        Left = 152
        Top = 60
        Width = 17
        Height = 25
        Max = 50
        Position = 4
        TabOrder = 5
        OnClick = UpDownIslandsClick
      end
    end
  end
  object Panel26: TPanel
    Left = 0
    Top = 116
    Width = 431
    Height = 29
    Align = alTop
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 8
    object Panel27: TPanel
      Left = 0
      Top = 0
      Width = 100
      Height = 29
      Align = alLeft
      Alignment = taRightJustify
      BevelOuter = bvNone
      BorderWidth = 5
      Caption = 'Planet Radius'
      ParentColor = True
      TabOrder = 0
    end
    object edPlanetRadius: TEdit
      Left = 102
      Top = 4
      Width = 51
      Height = 21
      ReadOnly = True
      TabOrder = 1
      Text = '10'
    end
    object UpDownRadius: TUpDown
      Left = 152
      Top = 0
      Width = 17
      Height = 25
      Min = 4
      Max = 64
      Position = 10
      TabOrder = 2
      OnClick = UpDownRadiusClick
    end
  end
end
