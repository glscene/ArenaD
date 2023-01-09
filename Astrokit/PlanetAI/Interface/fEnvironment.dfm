object fmEnvironment: TfmEnvironment
  Left = 314
  Top = 174
  Width = 634
  Height = 457
  BorderIcons = [biSystemMenu]
  Caption = 'Environment'
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
    C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF009999
    99999999999999999999999999999FFFFFFFFFFFFF88888888888FFFFFF997FF
    FFFFFFFF888888888888888FFFF9977FFFFFFFF8444C444888888888FFF99777
    FFFFFF4444444444488888888FF997777FFF44444C4C4C4C4C48888888F99777
    77F44444443444444444888888F99777774C444C433C4C4C4C4C488888899777
    74444444C334C444C444C48888899777744C4C4C433C4C4C4C4C4C8888899777
    444444C43334CCC4C4C4C44888899777444C4C43333C4C4C4C4C4C3888899774
    4444C4433333CCCCC4CCC433888997744C4C4C4333333C4C4C4C4C3388899774
    4444C43333333CCCCCCCC43388899774444C4C333333CC4CCC4C4C3388899774
    4444C433333CCCCCCCC33333888997744C4C4C334C4C4CCCCCC3333388899774
    44444433CCCC3CCCCCC3333388F99777444C4C433C433C4CCC4C333888F99777
    4444343333333CCCCCCCC4C88FF99777744C333333333C4C4C433C88FFF99777
    7444333333333CCCCCC3348FFFF99777774C333333333C4C3C433FFFFFF99777
    7774333333C333CC3433FFFFFFF9977777774333334C333C4C377FFFFFF99777
    77777744433444C4477777FFFFF99777777777774C4C4C477777777FFFF99777
    777777777777777777777777FFF997777777777777777777777777777FF99777
    77777777777777777777777777F9999999999999999999999999999999990000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    000000000000000000000000000000000000000000000000000000000000}
  OldCreateOrder = False
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel3: TPanel
    Left = 0
    Top = 0
    Width = 626
    Height = 404
    Align = alClient
    BorderWidth = 5
    Color = clInactiveBorder
    DockSite = True
    DragKind = dkDock
    TabOrder = 0
    object panelMap: TPanel
      Left = 6
      Top = 35
      Width = 614
      Height = 307
      Align = alClient
      BevelInner = bvLowered
      BevelOuter = bvLowered
      BorderWidth = 5
      Color = clOlive
      TabOrder = 0
      object imageMap: TImage
        Left = 7
        Top = 7
        Width = 600
        Height = 293
        Cursor = crCross
        Align = alClient
        Stretch = True
        OnMouseDown = imageMapMouseDown
        OnMouseMove = imageMapMouseMove
        OnMouseUp = imageMapMouseUp
      end
    end
    object ToolBarSpace: TToolBar
      Left = 6
      Top = 6
      Width = 614
      Height = 29
      ButtonWidth = 28
      Caption = 'toolbarEnvironment'
      EdgeBorders = [ebLeft, ebTop, ebRight, ebBottom]
      Images = fmImages.imgIcons
      TabOrder = 1
      object tbWateringCan: TToolButton
        Left = 0
        Top = 2
        Hint = 'Watering Can'
        Caption = 'Watering Can'
        Grouped = True
        ImageIndex = 51
        ParentShowHint = False
        ShowHint = True
        Style = tbsCheck
        OnClick = tbWateringCanClick
      end
      object tbAppleTree: TToolButton
        Left = 28
        Top = 2
        Hint = 'Apple Tree'
        Caption = 'apple tree'
        Grouped = True
        ImageIndex = 47
        ParentShowHint = False
        ShowHint = True
        Style = tbsCheck
        OnClick = tbAppleTreeClick
      end
      object tbOrangeTree: TToolButton
        Left = 56
        Top = 2
        Hint = 'Orange Tree'
        Caption = 'orange tree'
        Grouped = True
        ImageIndex = 49
        ParentShowHint = False
        ShowHint = True
        Style = tbsCheck
        OnClick = tbOrangeTreeClick
      end
      object tbSun: TToolButton
        Left = 84
        Top = 2
        Hint = 'Sun'
        Caption = 'Sun'
        Grouped = True
        ImageIndex = 58
        ParentShowHint = False
        ShowHint = True
        Style = tbsCheck
        OnClick = tbSunClick
      end
      object tbMoon: TToolButton
        Left = 112
        Top = 2
        Hint = 'Moon'
        Caption = 'Moon'
        Grouped = True
        ImageIndex = 59
        ParentShowHint = False
        ShowHint = True
        Style = tbsCheck
        OnClick = tbMoonClick
      end
      object tbSpiritGuy: TToolButton
        Left = 140
        Top = 2
        Hint = 'Guy Spirit'
        Caption = 'spirit (guy)                  '
        Grouped = True
        ImageIndex = 45
        ParentShowHint = False
        ShowHint = True
        Style = tbsCheck
        OnClick = tbSpiritGuyClick
      end
      object tbSpiritGirl: TToolButton
        Left = 168
        Top = 2
        Hint = 'Girl Spirit'
        Caption = 'spirit (girl)'
        Grouped = True
        ImageIndex = 46
        ParentShowHint = False
        ShowHint = True
        Style = tbsCheck
        OnClick = tbSpiritGirlClick
      end
      object tbTemperature: TToolButton
        Left = 196
        Top = 2
        Hint = 'Temperature'
        Caption = 'Temperature'
        Grouped = True
        ImageIndex = 14
        ParentShowHint = False
        ShowHint = True
        Style = tbsCheck
        OnClick = tbTemperatureClick
      end
      object tbSlime: TToolButton
        Left = 224
        Top = 2
        Hint = 'Slime'
        Caption = 'slime'
        Grouped = True
        ImageIndex = 50
        ParentShowHint = False
        ShowHint = True
        Style = tbsCheck
        OnClick = tbSlimeClick
      end
      object tbBrick: TToolButton
        Left = 252
        Top = 2
        Hint = 'Brick'
        Caption = 'brick'
        Grouped = True
        ImageIndex = 10
        ParentShowHint = False
        ShowHint = True
        Style = tbsCheck
        OnClick = tbBrickClick
      end
      object tbCrawly: TToolButton
        Left = 280
        Top = 2
        Hint = 'Crawly'
        Caption = 'crawly'
        Grouped = True
        ImageIndex = 44
        ParentShowHint = False
        ShowHint = True
        Style = tbsCheck
        OnClick = tbCrawlyClick
      end
      object ToolButton1: TToolButton
        Left = 308
        Top = 2
        Width = 8
        Caption = 'ToolButton1'
        ImageIndex = 45
        Style = tbsSeparator
      end
      object tbRefresh: TToolButton
        Left = 316
        Top = 2
        Hint = 'Refresh'
        Caption = 'Refresh'
        ImageIndex = 13
        ParentShowHint = False
        ShowHint = True
        OnClick = tbRefreshClick
      end
    end
    object Panel4: TPanel
      Left = 6
      Top = 342
      Width = 614
      Height = 56
      Align = alBottom
      BevelOuter = bvNone
      Color = clInactiveBorder
      TabOrder = 2
      object tbWater: TToolBar
        Left = 0
        Top = 0
        Width = 614
        Height = 29
        Images = fmImages.imgLand
        TabOrder = 0
        object tbAddRemoveWater: TToolButton
          Left = 0
          Top = 2
          Hint = 'Add / Remove Water'
          Caption = 'tbAddRemoveWater'
          Down = True
          Grouped = True
          ImageIndex = 0
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbAddRemoveWaterClick
        end
        object tbLandDesert: TToolButton
          Left = 23
          Top = 2
          Hint = 'Desert'
          Caption = 'tbLandDesert'
          Grouped = True
          ImageIndex = 1
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbLandDesertClick
        end
        object tbLandDirt: TToolButton
          Left = 46
          Top = 2
          Hint = 'Dirt'
          Caption = 'tbLandDirt'
          Grouped = True
          ImageIndex = 2
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbLandDirtClick
        end
        object tbLandField: TToolButton
          Left = 69
          Top = 2
          Hint = 'Field'
          Caption = 'tbLandField'
          Grouped = True
          ImageIndex = 3
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbLandFieldClick
        end
        object tbLandGrass: TToolButton
          Left = 92
          Top = 2
          Hint = 'Grass'
          Caption = 'tbLandGrass'
          Grouped = True
          ImageIndex = 4
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbLandGrassClick
        end
        object tbWaterPuddle: TToolButton
          Left = 115
          Top = 2
          Hint = 'Puddle'
          Caption = 'tbWaterPuddle'
          Grouped = True
          ImageIndex = 5
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbWaterPuddleClick
        end
        object tbWaterPuddle2: TToolButton
          Left = 138
          Top = 2
          Hint = 'Puddles'
          Caption = 'Swamp'
          Grouped = True
          ImageIndex = 6
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbWaterPuddle2Click
        end
        object tbWaterLake: TToolButton
          Left = 161
          Top = 2
          Hint = 'Lake'
          Caption = 'tbWaterLake'
          Grouped = True
          ImageIndex = 7
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbWaterLakeClick
        end
        object tbWaterSea: TToolButton
          Left = 184
          Top = 2
          Hint = 'Sea'
          Caption = 'tbWaterSea'
          Grouped = True
          ImageIndex = 8
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbWaterSeaClick
        end
        object ToolButton2: TToolButton
          Left = 207
          Top = 2
          Width = 8
          Caption = 'ToolButton2'
          ImageIndex = 9
          Style = tbsSeparator
        end
        object Panel1: TPanel
          Left = 215
          Top = 2
          Width = 50
          Height = 22
          BevelOuter = bvNone
          Caption = 'Water'
          Color = clActiveBorder
          TabOrder = 2
        end
        object edWater: TEdit
          Left = 265
          Top = 2
          Width = 38
          Height = 22
          Hint = 'Water Addition Modifier'
          Enabled = False
          ParentShowHint = False
          ReadOnly = True
          ShowHint = True
          TabOrder = 0
          Text = '1000'
        end
        object WaterUpDown: TUpDown
          Left = 303
          Top = 2
          Width = 17
          Height = 22
          Min = 1
          Position = 20
          TabOrder = 1
          Wrap = False
          OnClick = WaterUpDownClick
        end
        object ToolButton3: TToolButton
          Left = 320
          Top = 2
          Width = 8
          Caption = 'ToolButton3'
          ImageIndex = 10
          Style = tbsSeparator
        end
      end
      object tbFauna: TToolBar
        Left = 0
        Top = 29
        Width = 614
        Height = 29
        Caption = 'tbFauna'
        Images = fmImages.imgFauna
        TabOrder = 1
        Visible = False
        object ToolButton4: TToolButton
          Left = 0
          Top = 2
          Caption = 'ToolButton4'
          ImageIndex = 0
        end
        object ToolButton5: TToolButton
          Left = 23
          Top = 2
          Caption = 'ToolButton5'
          ImageIndex = 1
        end
        object ToolButton8: TToolButton
          Left = 46
          Top = 2
          Caption = 'ToolButton8'
          ImageIndex = 4
        end
        object ToolButton9: TToolButton
          Left = 69
          Top = 2
          Caption = 'ToolButton9'
          ImageIndex = 5
        end
        object ToolButton11: TToolButton
          Left = 92
          Top = 2
          Caption = 'ToolButton11'
          ImageIndex = 7
        end
        object ToolButton13: TToolButton
          Left = 115
          Top = 2
          Caption = 'ToolButton13'
          ImageIndex = 9
        end
        object ToolButton12: TToolButton
          Left = 138
          Top = 2
          Caption = 'ToolButton12'
          ImageIndex = 8
        end
        object ToolButton14: TToolButton
          Left = 161
          Top = 2
          Caption = 'ToolButton14'
          ImageIndex = 10
        end
        object ToolButton10: TToolButton
          Left = 184
          Top = 2
          Caption = 'ToolButton10'
          ImageIndex = 6
        end
        object ToolButton6: TToolButton
          Left = 207
          Top = 2
          Caption = 'ToolButton6'
          ImageIndex = 2
        end
        object tbBoringTree: TToolButton
          Left = 230
          Top = 2
          Caption = 'tbBoringTree'
          ImageIndex = 3
        end
      end
    end
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 404
    Width = 626
    Height = 19
    Panels = <
      item
        Width = 100
      end
      item
        Width = 50
      end>
    SimplePanel = False
  end
  object ToolTimer: TTimer
    Enabled = False
    Interval = 200
    OnTimer = ToolTimerTimer
    Left = 16
    Top = 45
  end
end
