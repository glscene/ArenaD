object fmLists: TfmLists
  Left = 103
  Top = 136
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Lists'
  ClientHeight = 796
  ClientWidth = 1314
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
    0000000000000000000000000000000000000000000000000000000000000000
    000B3B3B3B33330000BB3B3000000000B3B3B3B3333333030BB3303300000003
    3330000000000030BB0B3B3330000003333B8B8383333033BBBB333330000000
    3333333333330B3B3BB33B3B3B0000000B3B3B3333330B3B33B3BBB3330000B3
    B3B3B3B333330B3B333BBB333B0003333000000000000B3B33BBBBB3B3000300
    000B3B3B33330B3B333BB0B33B000030B3B3B3B3B3330B3B333BBBB3B3000303
    3333333333330B33333BBB3B3B000003000B888383830BB33333333BB0000000
    33330000000000B33B3333BB300000033000B3B3B3B3B0BB33330BBB00000000
    0B3B3B3B3B3B3B0BB33B3BB00000000033333333333333300B33330000000000
    3000BBB838383830003000000000000003333380000000000000000000000000
    3338000B3B3B3B3B3B000000000000000330B3B3B3B3B3B3B3B3300000000000
    0003333FFFFFF33333333300000000000003088BBBB3B3B3B300030000000000
    000033333BBBBB3B3B33300000000000000333B3B3BBBBB3B3B3330000000000
    0000333B3BBBBBBB333330000000000000000003B3B3BFFFFB00000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    000000000000000000000000000000000000000000000000000000000000FFFF
    FFFFFE003C1FF000000FE0000007C0000003C0000003C0000001C00000018000
    00010000000100000001000000010000000180000003C0000003C0000007E000
    000FE000001FE00000FFE00000FFE000007FF000003FF800001FFC00001FFC00
    001FFC00001FFE00003FFF00007FFFE003FFFFFFFFFFFFFFFFFFFFFFFFFF}
  WindowState = wsMaximized
  OnCloseQuery = FormCloseQuery
  OnShow = FormShow
  PixelsPerInch = 120
  TextHeight = 16
  object Panel15: TPanel
    Left = 0
    Top = 0
    Width = 1314
    Height = 796
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Panel15'
    TabOrder = 0
    object Splitter2: TSplitter
      Left = 939
      Top = 0
      Width = 9
      Height = 744
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alRight
      Beveled = True
    end
    object Panel7: TPanel
      Left = 0
      Top = 0
      Width = 939
      Height = 744
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alClient
      BevelOuter = bvNone
      BorderWidth = 10
      Color = clBtnShadow
      TabOrder = 0
      object panCultureName: TPanel
        Left = 10
        Top = 10
        Width = 919
        Height = 31
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alTop
        BevelOuter = bvNone
        Caption = 'THINGS'
        Color = clBtnShadow
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -14
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsUnderline]
        ParentFont = False
        TabOrder = 0
      end
      object lbThings: TListBox
        Left = 10
        Top = 41
        Width = 919
        Height = 625
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alClient
        Color = clCream
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -16
        Font.Name = 'SimSun'
        Font.Style = []
        Items.Strings = (
          'one'
          'two'
          'three')
        ParentFont = False
        TabOrder = 1
        OnDblClick = lbThingsDblClick
        ExplicitWidth = 930
      end
      object Panel3: TPanel
        Left = 10
        Top = 666
        Width = 919
        Height = 68
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alBottom
        BevelOuter = bvNone
        Color = clBtnShadow
        TabOrder = 2
        object btnDelete: TBitBtn
          Left = 130
          Top = 5
          Width = 94
          Height = 31
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Delete'
          Enabled = False
          TabOrder = 0
          OnClick = btnDeleteClick
        end
        object btnView: TBitBtn
          Left = 233
          Top = 5
          Width = 93
          Height = 31
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'View'
          TabOrder = 1
          OnClick = btnViewClick
        end
        object btnTrack: TBitBtn
          Left = 335
          Top = 5
          Width = 94
          Height = 31
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Track'
          TabOrder = 2
          OnClick = btnTrackClick
        end
        object btnRefreshAll: TBitBtn
          Left = 0
          Top = 5
          Width = 124
          Height = 31
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Refresh'
          TabOrder = 3
          OnClick = btnRefreshAllClick
        end
        object cbAutoRefresh: TCheckBox
          Left = 3
          Top = 45
          Width = 121
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Auto Refresh'
          TabOrder = 4
        end
        object cbPlants: TCheckBox
          Left = 133
          Top = 45
          Width = 81
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Plants'
          TabOrder = 5
        end
        object cbCreatures: TCheckBox
          Left = 203
          Top = 45
          Width = 126
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Creatures'
          Checked = True
          State = cbChecked
          TabOrder = 6
        end
        object cbClouds: TCheckBox
          Left = 293
          Top = 45
          Width = 78
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Clouds'
          TabOrder = 7
        end
      end
    end
    object Panel20: TPanel
      Left = 948
      Top = 0
      Width = 366
      Height = 744
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alRight
      BevelOuter = bvNone
      BorderWidth = 10
      Color = clBtnShadow
      TabOrder = 1
      object ToolBar1: TToolBar
        Left = 10
        Top = 587
        Width = 346
        Height = 147
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alBottom
        ButtonHeight = 24
        ButtonWidth = 81
        Caption = 'ToolBar1'
        ShowCaptions = True
        TabOrder = 0
        object tbReality: TToolButton
          Left = 0
          Top = 0
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Reality'
          ImageIndex = 12
          OnClick = tbRealityClick
        end
        object tbSpace: TToolButton
          Left = 81
          Top = 0
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Space'
          ImageIndex = 10
          OnClick = tbSpaceClick
        end
        object tbEnvironment: TToolButton
          Left = 162
          Top = 0
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Environment'
          ImageIndex = 11
          OnClick = tbEnvironmentClick
        end
        object tbExistents: TToolButton
          Left = 243
          Top = 0
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Existents'
          ImageIndex = 4
          OnClick = tbExistentsClick
        end
        object tbAttachments: TToolButton
          Left = 324
          Top = 0
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Attachments'
          ImageIndex = 1
          Wrap = True
          OnClick = tbAttachmentsClick
        end
        object tbReferences: TToolButton
          Left = 0
          Top = 24
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'References'
          ImageIndex = 0
          OnClick = tbReferencesClick
        end
        object tbGrids: TToolButton
          Left = 81
          Top = 24
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Grids'
          ImageIndex = 3
          OnClick = tbGridsClick
        end
        object tbCradle: TToolButton
          Left = 162
          Top = 24
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Cradle'
          ImageIndex = 5
          OnClick = tbCradleClick
        end
        object tbPurgatory: TToolButton
          Left = 243
          Top = 24
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Purgatory'
          ImageIndex = 6
          OnClick = tbPurgatoryClick
        end
        object tbTrash: TToolButton
          Left = 324
          Top = 24
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Trash'
          ImageIndex = 14
          Wrap = True
          OnClick = tbTrashClick
        end
        object tbEventQueue: TToolButton
          Left = 0
          Top = 48
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'EventQueue'
          ImageIndex = 14
          OnClick = tbEventQueueClick
        end
        object tbEventRound: TToolButton
          Left = 81
          Top = 48
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'EventRound'
          ImageIndex = 13
          OnClick = tbEventRoundClick
        end
        object tbThings: TToolButton
          Left = 162
          Top = 48
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Things'
          ImageIndex = 9
          OnClick = tbThingsClick
        end
        object tbFruits: TToolButton
          Left = 243
          Top = 48
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Fruits'
          ImageIndex = 10
          OnClick = tbFruitsClick
        end
        object tbPrey: TToolButton
          Left = 324
          Top = 48
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Prey'
          ImageIndex = 11
          Wrap = True
          OnClick = tbPreyClick
        end
        object tbPredators: TToolButton
          Left = 0
          Top = 72
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Predators'
          ImageIndex = 12
          OnClick = tbPredatorsClick
        end
        object tbColliders: TToolButton
          Left = 81
          Top = 72
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Colliders'
          ImageIndex = 14
          OnClick = tbCollidersClick
        end
        object tb3DView: TToolButton
          Left = 162
          Top = 72
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = '3DView'
          ImageIndex = 13
          OnClick = tb3DViewClick
        end
      end
      object redView: TRichEdit
        Left = 10
        Top = 10
        Width = 346
        Height = 577
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
        Lines.Strings = (
          'ai.planet data viewer'
          '-------------------------------------------'
          'Click on a data structure below to see its contents.')
        ParentFont = False
        ReadOnly = True
        ScrollBars = ssBoth
        TabOrder = 1
        WordWrap = False
      end
    end
    object Panel1: TPanel
      Left = 0
      Top = 744
      Width = 1314
      Height = 52
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alBottom
      Color = clBtnShadow
      TabOrder = 2
      object Panel2: TPanel
        Left = 1183
        Top = 1
        Width = 130
        Height = 50
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alRight
        BevelOuter = bvNone
        Color = clBtnShadow
        TabOrder = 0
        object btnClose: TBitBtn
          Left = 18
          Top = 10
          Width = 93
          Height = 31
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Close'
          TabOrder = 0
          OnClick = btnCloseClick
        end
      end
    end
  end
end
