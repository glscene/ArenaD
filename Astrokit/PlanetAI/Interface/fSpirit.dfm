object fmSpirit: TfmSpirit
  Left = 709
  Top = 182
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Creature Viewer'
  ClientHeight = 581
  ClientWidth = 896
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
    000000000000330077000000000000000000000000003B077070000000000000
    000000000000BB807007000000000000000000000300B0007000700000000000
    00000000330070070700070000000000000000003B0700700070007000000000
    00000000BB800700000700070000000000000300B00070000000700070000000
    0000330070070000000007000700000000003B07007000000000007007000000
    0000BB800700000000000007070000000300B000700000000070000077000000
    330070070000000007000000803300003B070070000000000000000800330000
    BB8007000000000000000080BBBB0300B000700000000070000008000BB03300
    70070000000707000000803300003B070070000000707000000800330000BB80
    07000000070700000080BBBB0000B000700000000070000008000BB000007007
    0000000007000000803300000000707000007770000000080033000000008700
    0007070700000080BBBB00000000080000077777000008000BB0000000000080
    0007070700008033000000000000000800007770000800330000000000000000
    800000000080BBBB00000000000000000800000008000BB00000000000000000
    0080000080330000000000000000000000080008003300000000000000000000
    00008080BBBB00000000000000000000000008000BB00000000000000000FFFF
    33FFFFFF21FFFFFF00FFFFFB007FFFF3003FFFF2001FFFF0000FFFB00007FF30
    0003FF200003FF000003FB000003F3000000F2000000F0000010B00000393000
    000F2000000F0000010F0000039F000000FF000000FF000010FF800039FFC000
    0FFFE0000FFFF0010FFFF8039FFFFC00FFFFFE00FFFFFF10FFFFFFB9FFFF}
  Position = poOwnerFormCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnMouseWheel = FormMouseWheel
  OnShow = FormShow
  PixelsPerInch = 120
  TextHeight = 16
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 896
    Height = 581
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object Panel4: TPanel
      Left = 0
      Top = 0
      Width = 896
      Height = 581
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      object ViewSplitter: TSplitter
        Left = 0
        Top = 218
        Width = 896
        Height = 2
        Cursor = crVSplit
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alTop
        Visible = False
      end
      object tbTools: TToolBar
        Left = 0
        Top = 0
        Width = 896
        Height = 29
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        ButtonHeight = 30
        ButtonWidth = 81
        Caption = 'tbTools'
        Images = fmImages.imgIcons
        List = True
        ShowCaptions = True
        TabOrder = 0
        object tbTrack: TToolButton
          Left = 0
          Top = 0
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Track'
          ImageIndex = 37
          OnClick = tbTrackClick
        end
        object tbModify: TToolButton
          Left = 81
          Top = 0
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Modify'
          DropdownMenu = ModifyMenu
          ImageIndex = 35
          Style = tbsDropDown
        end
        object tbWindow: TToolButton
          Left = 181
          Top = 0
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Window'
          DropdownMenu = WindowMenu
          ImageIndex = 31
          Style = tbsDropDown
        end
        object cbView: TCheckBox
          Left = 281
          Top = 0
          Width = 59
          Height = 30
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'View'
          TabOrder = 0
          OnClick = cbViewClick
        end
      end
      object FullDisplay: TMemo
        Left = 0
        Top = 220
        Width = 896
        Height = 361
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alClient
        Color = clWhite
        ParentShowHint = False
        ReadOnly = True
        ScrollBars = ssBoth
        ShowHint = False
        TabOrder = 1
        WordWrap = False
      end
      object GLSceneTracker: TGLSceneViewer
        Left = 0
        Top = 29
        Width = 896
        Height = 189
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Buffer.BackgroundColor = clBlack
        PenAsTouch = False
        OnMouseEnter = GLSceneTrackerMouseEnter
        Align = alTop
        Visible = False
        OnMouseDown = GLSceneTrackerMouseDown
        OnMouseMove = GLSceneTrackerMouseMove
        TabOrder = 2
      end
    end
  end
  object ModifyMenu: TPopupMenu
    Left = 82
    Top = 26
    object Heal1: TMenuItem
      Caption = '&Heal'
      OnClick = Heal1Click
    end
    object Stop1: TMenuItem
      Caption = '&Stop'
      OnClick = Stop1Click
    end
    object Kill1: TMenuItem
      Caption = '&Cease'
      OnClick = Kill1Click
    end
    object Die1: TMenuItem
      Caption = '&Die'
      OnClick = Die1Click
    end
    object Reposition1: TMenuItem
      Caption = '&Position (Edit)'
      OnClick = Reposition1Click
    end
    object menuDNA: TMenuItem
      Caption = 'D&NA (Edit)'
      OnClick = menuDNAClick
    end
  end
  object WindowMenu: TPopupMenu
    Left = 180
    Top = 26
    object Refresh1: TMenuItem
      Caption = '&Refresh'
      OnClick = Refresh1Click
    end
    object Scrollbars1: TMenuItem
      Caption = '&Scrollbars'
      Checked = True
      OnClick = Scrollbars1Click
    end
    object OnTop1: TMenuItem
      Caption = '&On Top'
      OnClick = OnTop1Click
    end
    object Close1: TMenuItem
      Caption = '&Remove'
      OnClick = Close1Click
    end
    object LockCamera1: TMenuItem
      Caption = '&Lock Camera'
      OnClick = LockCamera1Click
    end
    object Wordwrap1: TMenuItem
      Caption = '&Wordwrap'
      OnClick = Wordwrap1Click
    end
  end
end
