object fmReality: TfmReality
  Left = 18
  Top = 158
  BorderIcons = [biSystemMenu, biMinimize, biHelp]
  BorderStyle = bsSingle
  Caption = 'ai.planet'
  ClientHeight = 51
  ClientWidth = 1345
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
    0000000000000000000000000000000000000000000000080000000000000000
    00F000000000000F800000000000000008800000444C40000000000000000000
    080000444444444400000F0000000000000044444C4C4C4C4C40008000000000
    00044444442444444444000000000000004C444C422C4C4C4C4C400000000800
    04444444C224C444C444C4000000F800044C4C4C422C4C4C4C4C4C0000008800
    444444C42224CCC4C4C4C44000000000444C4C42A22C4C4C4C4C4C200F000004
    4444C4422222CCCCC4CCC422080000044C4C4C4222A22C4C4C4C4C2208000004
    4444C4222A222CCCCCCCC42200000004444C4C222222CC4CCC4C4C2200000004
    4444C422222CCCCCCCC22222000000044C4C4C224C4C4CCCCCC2222200000004
    44444422CCCC2CCCECC22AA200000000444C4C422C422C6CCC6C222000000000
    4444242222222CCCCECCC6C000000000044C22222A222C6ECC622C0000000080
    044422A2222A2CCCCCC2260000000088004C222222222C6C2C6620000000000F
    800422A222C222CC262200000000000088004222224C222C6C20009900000000
    00000044422444C66000091190000000008F00004C4C4C60000091BB19000000
    0008800000000000000091BB1900000000000000088800000000091190000000
    000000000088000000000099000000000000000000000000000000000000FFFF
    FFFFFFFFEFFFFDFFE7FFF9F07FFFFBC00FBFFF0001DFFE0000FFFC00007FB800
    003F3800003F3000001FF000001BE000000BE000000BE000000FE000000FE000
    000FE000000FE000000FF000001FF000001FF800003FD800003FCC00007FE600
    00FFF30001CFFFC00787FCF01F03FE7FFF03FFF8FF87FFFCFFCFFFFFFFFF}
  Menu = MainMenu1
  OnActivate = FormActivate
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 120
  TextHeight = 16
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 1345
    Height = 51
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alTop
    BevelOuter = bvLowered
    BorderWidth = 2
    TabOrder = 0
    object Panel4: TPanel
      Left = 3
      Top = 3
      Width = 190
      Height = 45
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      object btnGo: TBitBtn
        Left = 3
        Top = 3
        Width = 88
        Height = 38
        Hint = 'Start time.'
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = '&GO'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -14
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        Glyph.Data = {
          76010000424D7601000000000000760000002800000020000000100000000100
          04000000000000010000120B0000120B00001000000000000000000000000000
          800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
          3333333333FFFFF3333333333700000733333333F777773FF3333333007F0F70
          0333333773373377FF3333300FFF7FFF003333773F3333377FF33300F0FFFFF0
          F00337737333F37377F33707FFFF0FFFF70737F33337F33337FF300FFFFF0FFF
          FF00773F3337F333377F30707FFF0FFF70707F733337F333737F300FFFF09FFF
          FF0077F33377F33337733707FF0F9FFFF70737FF3737F33F37F33300F0FF9FF0
          F003377F7337F373773333300FFF9FFF00333377FF37F3377FF33300007F9F70
          000337777FF7FF77773333703070007030733373777777737333333333330333
          333333333337FF33333333333330003333333333337773333333}
        NumGlyphs = 2
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnClick = btnGoClick
      end
      object btnStop: TBitBtn
        Left = 100
        Top = 3
        Width = 86
        Height = 38
        Hint = 'Stop time.'
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = '&STOP'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -14
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        Glyph.Data = {
          76010000424D7601000000000000760000002800000020000000100000000100
          04000000000000010000130B0000130B00001000000000000000000000000000
          800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
          3333333333FFFFF3333333333999993333333333F77777FFF333333999999999
          33333337777FF377FF3333993370739993333377FF373F377FF3399993000339
          993337777F777F3377F3393999707333993337F77737333337FF993399933333
          399377F3777FF333377F993339903333399377F33737FF33377F993333707333
          399377F333377FF3377F993333101933399377F333777FFF377F993333000993
          399377FF3377737FF7733993330009993933373FF3777377F7F3399933000399
          99333773FF777F777733339993707339933333773FF7FFF77333333999999999
          3333333777333777333333333999993333333333377777333333}
        NumGlyphs = 2
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        OnClick = btnStopClick
      end
    end
    object Panel16: TPanel
      Left = 600
      Top = 3
      Width = 87
      Height = 45
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 1
      object radTicking: TRadioButton
        Left = 5
        Top = 3
        Width = 141
        Height = 21
        Hint = 
          'Set time to ticking mode if you want to pause between each round' +
          '.'
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Ticking'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clInactiveCaption
        Font.Height = -14
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnClick = radTickingClick
      end
      object radFlowing: TRadioButton
        Left = 5
        Top = 23
        Width = 141
        Height = 21
        Hint = 'Flowing time mode sets the planet running until you press stop.'
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Flowing'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clInactiveCaption
        Font.Height = -14
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        OnClick = radFlowingClick
      end
    end
    object Panel1: TPanel
      Left = 193
      Top = 3
      Width = 407
      Height = 45
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 2
      object Panel17: TPanel
        Left = 0
        Top = 0
        Width = 407
        Height = 59
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object laBspeed: TLabel
          Left = 18
          Top = 5
          Width = 17
          Height = 13
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'fast'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label1: TLabel
          Left = 316
          Top = 5
          Width = 21
          Height = 13
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'slow'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object labRoundTime: TLabel
          Left = 153
          Top = 24
          Width = 39
          Height = 16
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = '100ms'
        end
        object trackSpeed: TTrackBar
          Left = 44
          Top = 0
          Width = 272
          Height = 26
          Hint = 'Speed between each clock tick.'
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          LineSize = 2
          Max = 200
          Min = 1
          ParentShowHint = False
          Frequency = 50
          Position = 50
          ShowHint = True
          TabOrder = 0
          ThumbLength = 19
          TickMarks = tmTopLeft
          TickStyle = tsNone
          OnChange = trackSpeedChange
        end
        object btn20: TBitBtn
          Left = 360
          Top = 8
          Width = 34
          Height = 28
          Hint = 'Set to default round time of 20ms.'
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = '40'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          OnClick = btn20Click
        end
      end
    end
    object Panel3: TPanel
      Left = 687
      Top = 3
      Width = 492
      Height = 45
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 3
      object panRealityT: TPanel
        Left = 0
        Top = 0
        Width = 375
        Height = 45
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alLeft
        BevelOuter = bvNone
        TabOrder = 0
        object panRealityTime: TPanel
          Left = 0
          Top = 0
          Width = 89
          Height = 45
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Align = alLeft
          BevelOuter = bvNone
          Caption = 'Time:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clTeal
          Font.Height = -16
          Font.Name = 'Verdana'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
        object panRealityTime1: TPanel
          Left = 89
          Top = 0
          Width = 125
          Height = 45
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Align = alLeft
          Alignment = taLeftJustify
          BevelOuter = bvNone
          Caption = 'panRealityTime1'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clTeal
          Font.Height = -14
          Font.Name = 'Times New Roman'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
        end
        object cbCollisions: TCheckBox
          Left = 195
          Top = 21
          Width = 146
          Height = 22
          Hint = 'Turn the collision system on or off.'
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Collision Detection'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 2
          OnClick = cbCollisionsClick
        end
        object cbAI: TCheckBox
          Left = 195
          Top = 0
          Width = 156
          Height = 21
          Hint = 'Run ai code for objects.'
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Artificial Intelligence'
          ParentShowHint = False
          ShowHint = False
          TabOrder = 3
          OnClick = cbAIClick
        end
      end
    end
    object Panel5: TPanel
      Left = 1244
      Top = 3
      Width = 98
      Height = 45
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 4
      object btnExit: TBitBtn
        Left = 5
        Top = 3
        Width = 86
        Height = 38
        Hint = 'Stop time.'
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'E&XIT'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -14
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        Glyph.Data = {
          76010000424D7601000000000000760000002800000020000000100000000100
          04000000000000010000120B0000120B00001000000000000000000000000000
          800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
          333333333333333333333333333333333333333FFFFFFFFFFF33330000000000
          03333377777777777F33333003333330033333377FF333377F33333300333333
          0333333377FF33337F3333333003333303333333377FF3337333333333003333
          333333333377FF3333333333333003333333333333377FF33333333333330033
          3333333333337733333333333330033333333333333773333333333333003333
          33333333337733333F3333333003333303333333377333337F33333300333333
          03333333773333337F33333003333330033333377FFFFFF77F33330000000000
          0333337777777777733333333333333333333333333333333333}
        NumGlyphs = 2
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnClick = btnExitClick
      end
    end
  end
  object MainMenu1: TMainMenu
    Left = 664
    Top = 8
    object File1: TMenuItem
      Caption = '&File'
      object menuNewReality: TMenuItem
        Caption = '&New World'
        OnClick = menuNewRealityClick
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object Load1: TMenuItem
        Caption = '&Load World...'
        OnClick = Load1Click
      end
      object menuSave: TMenuItem
        Caption = '&Save World'
        OnClick = menuSaveClick
      end
      object SaveAs1: TMenuItem
        Caption = 'Save World &As...'
        OnClick = SaveAs1Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Quit1: TMenuItem
        Caption = '&Quit'
        OnClick = Quit1Click
      end
    end
    object Set1: TMenuItem
      Caption = '&Set'
      object TimeMode1: TMenuItem
        Caption = '&Time Mode'
        object menuSetTimeTicking: TMenuItem
          Caption = '&Ticking'
          RadioItem = True
          OnClick = menuSetTimeTickingClick
        end
        object menuSetTimeFlowing: TMenuItem
          Caption = '&Flowing'
          RadioItem = True
          OnClick = menuSetTimeFlowingClick
        end
      end
      object Names1: TMenuItem
        Caption = '&Names'
        object menuEnvironmentName: TMenuItem
          Caption = 'Planet Name'
          OnClick = menuEnvironmentNameClick
        end
        object menuCreatorName: TMenuItem
          Caption = 'User Name'
          OnClick = menuCreatorNameClick
        end
      end
      object ReloadDNA1: TMenuItem
        Caption = '&Reload DNAs'
        OnClick = ReloadDNA1Click
      end
      object menuMax: TMenuItem
        Caption = '&Maximums'
        OnClick = menuMaxClick
      end
      object menuSettings: TMenuItem
        Caption = '&Program Settings'
        OnClick = menuSettingsClick
      end
      object AAsteroids1: TMenuItem
        Caption = '&Asteroids'
        OnClick = AAsteroids1Click
      end
    end
    object Add1: TMenuItem
      Caption = '&Add'
      object Object1: TMenuItem
        Caption = 'Object'
        Enabled = False
        object Apple1: TMenuItem
          Caption = 'Apple'
          Enabled = False
        end
        object Orange1: TMenuItem
          Caption = 'Orange'
          Enabled = False
        end
      end
      object AI1: TMenuItem
        Caption = 'AI'
        Enabled = False
      end
    end
    object View1: TMenuItem
      Caption = '&View'
      object menuMonitor: TMenuItem
        Caption = '&Desktop'
        Visible = False
        object menuMonitorSingle: TMenuItem
          Caption = 'Single Monitor'
          RadioItem = True
          OnClick = menuMonitorSingleClick
        end
        object menuMonitorDouble: TMenuItem
          Caption = 'Multiple Monitors'
          RadioItem = True
          OnClick = menuMonitorDoubleClick
        end
      end
      object menuViewManager: TMenuItem
        Caption = '&Manager'
        OnClick = menuViewManagerClick
      end
      object menuViewSpace: TMenuItem
        Caption = '&Space'
        OnClick = menuViewSpaceClick
      end
      object menuViewEvents: TMenuItem
        Caption = '&Events'
        OnClick = menuViewEventsClick
      end
      object menuViewLists: TMenuItem
        Caption = '&Lists'
        OnClick = menuViewListsClick
      end
      object ime1: TMenuItem
        Caption = 'Time'
      end
      object Construction1: TMenuItem
        Caption = 'Construction'
      end
    end
    object Run1: TMenuItem
      Caption = '&Run'
      object menuGo: TMenuItem
        Caption = '&Go!'
        OnClick = menuGoClick
      end
      object menuStop: TMenuItem
        Caption = '&Stop!'
        OnClick = menuStopClick
      end
    end
    object Net1: TMenuItem
      Caption = '&Net'
      object AllowCommunication1: TMenuItem
        Caption = 'Allow Communication'
        Enabled = False
      end
      object AllowInterNetTravel1: TMenuItem
        Caption = 'Allow Travel'
        Enabled = False
      end
    end
    object About1: TMenuItem
      Caption = '&Help'
      object menuReadme: TMenuItem
        Caption = '&Readme'
        OnClick = menuReadmeClick
      end
      object menuTutorial: TMenuItem
        Caption = '&Tutorial'
        OnClick = menuTutorialClick
      end
      object ipoftheDay1: TMenuItem
        Caption = 'Tip of the &Day'
        OnClick = ipoftheDay1Click
      end
      object menuKeyboard: TMenuItem
        Caption = '&Controls'
        OnClick = menuKeyboardClick
      end
      object Restore1: TMenuItem
        Caption = 'Restore Black Scene'
        Visible = False
        OnClick = Restore1Click
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object About2: TMenuItem
        Caption = '&About...'
        OnClick = About2Click
      end
    end
  end
  object RealityClock: TTimer
    Interval = 100
    OnTimer = RealityClockTimer
    Left = 634
    Top = 8
  end
  object odLoadReality: TOpenDialog
    DefaultExt = 'air'
    FileName = '*.air'
    Filter = '*.air'
    Left = 604
    Top = 8
  end
  object sdSaveReality: TSaveDialog
    FileName = '*.air'
    Filter = '*.air'
    Left = 574
    Top = 8
  end
end
