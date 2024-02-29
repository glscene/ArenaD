object OptionsDlg: TOptionsDlg
  Left = 227
  Top = 132
  BorderStyle = bsNone
  Caption = 'OptionsDlg'
  ClientHeight = 263
  ClientWidth = 568
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Arial'
  Font.Style = [fsBold]
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 120
  TextHeight = 19
  object Shape1: TShape
    Left = 0
    Top = 0
    Width = 568
    Height = 263
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alClient
    Brush.Style = bsClear
  end
  object ToolBar1: TToolBar
    Left = 460
    Top = 40
    Width = 101
    Height = 101
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alNone
    ButtonHeight = 27
    ButtonWidth = 82
    Caption = 'ToolBar1'
    Color = clBtnFace
    ParentColor = False
    ShowCaptions = True
    TabOrder = 0
    object TBApply: TToolButton
      Left = 0
      Top = 0
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = '    Apply    '
      ImageIndex = 0
      Wrap = True
      OnClick = TBApplyClick
    end
    object TBSpacer: TToolButton
      Left = 0
      Top = 27
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Enabled = False
      ImageIndex = 1
      Wrap = True
    end
    object TBCancel: TToolButton
      Left = 0
      Top = 54
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Cancel'
      ImageIndex = 2
      OnClick = TBCancelClick
    end
  end
  object Panel1: TPanel
    Left = 10
    Top = 10
    Width = 441
    Height = 241
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    BevelOuter = bvNone
    Caption = 'Panel1'
    Color = clBtnHighlight
    TabOrder = 1
    object PageControl: TPageControl
      Left = 0
      Top = 0
      Width = 441
      Height = 241
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      ActivePage = TSGameplay
      Align = alClient
      Style = tsFlatButtons
      TabOrder = 0
      object TSGameplay: TTabSheet
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Gameplay'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = []
        ImageIndex = 3
        ParentFont = False
        object Label11: TLabel
          Left = 10
          Top = 24
          Width = 58
          Height = 18
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Difficulty'
        end
        object Label12: TLabel
          Left = 10
          Top = 64
          Width = 47
          Height = 18
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Speed'
        end
        object CBDifficulty: TComboBox
          Left = 90
          Top = 20
          Width = 131
          Height = 26
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          TabOrder = 0
          Text = 'Normal'
          OnChange = CBDifficultyChange
          Items.Strings = (
            'Please don'#39't hurt me!'
            'Beginner'
            'Normal'
            'Advanced'
            'Ace of Aces')
        end
        object CBSpeed: TComboBox
          Left = 90
          Top = 60
          Width = 131
          Height = 26
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          ItemIndex = 2
          TabOrder = 1
          Text = 'Normal'
          OnChange = CBDifficultyChange
          Items.Strings = (
            'Sleepy'
            'Slow'
            'Normal'
            'Fast'
            'Frantic'
            '')
        end
      end
      object TSVideo: TTabSheet
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Video'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        object Label1: TLabel
          Left = 10
          Top = 24
          Width = 40
          Height = 18
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Mode'
        end
        object Label2: TLabel
          Left = 10
          Top = 64
          Width = 83
          Height = 18
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'AntiAliasing'
        end
        object Label3: TLabel
          Left = 10
          Top = 120
          Width = 47
          Height = 18
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Quality'
        end
        object Label4: TLabel
          Left = 90
          Top = 120
          Width = 47
          Height = 18
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Terrain'
        end
        object Label5: TLabel
          Left = 90
          Top = 160
          Width = 61
          Height = 18
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Particles'
        end
        object CBVideoMode: TComboBox
          Left = 70
          Top = 20
          Width = 191
          Height = 26
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          TabOrder = 0
          Text = '800x600 32bit'
          OnChange = CBVideoModeChange
          Items.Strings = (
            '640x480 32bit'
            '800x600 32bit'
            '1024x768 32bit'
            '1280x960 32bit'
            '1600x1200 32bit')
        end
        object CBFSAA: TComboBox
          Left = 130
          Top = 60
          Width = 131
          Height = 26
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          ItemIndex = 0
          TabOrder = 1
          Text = 'Default'
          OnChange = CBDifficultyChange
          Items.Strings = (
            'Default'
            'FSAA 2x'
            'FSAA 4x')
        end
        object CBTerrain: TComboBox
          Left = 170
          Top = 116
          Width = 91
          Height = 26
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          TabOrder = 2
          Text = 'Normal'
          OnChange = CBDifficultyChange
          Items.Strings = (
            'Low'
            'Normal'
            'High')
        end
        object CBParticles: TComboBox
          Left = 170
          Top = 156
          Width = 91
          Height = 26
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          ItemIndex = 1
          TabOrder = 3
          Text = 'Normal'
          OnChange = CBDifficultyChange
          Items.Strings = (
            'Low'
            'Normal'
            'High')
        end
        object CBVSync: TCheckBox
          Left = 280
          Top = 24
          Width = 91
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'VSync'
          TabOrder = 4
          OnClick = CBVideoModeChange
        end
      end
      object TSAudio: TTabSheet
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Audio'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = []
        ImageIndex = 2
        ParentFont = False
        object Label6: TLabel
          Left = 10
          Top = 20
          Width = 104
          Height = 18
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Master Volume'
        end
        object Label9: TLabel
          Left = 10
          Top = 70
          Width = 57
          Height = 18
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Engines'
        end
        object Label7: TLabel
          Left = 10
          Top = 120
          Width = 41
          Height = 18
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Music'
        end
        object Label13: TLabel
          Left = 10
          Top = 170
          Width = 40
          Height = 18
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Voice'
        end
        object TBMasterVolume: TTrackBar
          Left = 140
          Top = 10
          Width = 281
          Height = 41
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Max = 100
          Frequency = 10
          Position = 80
          TabOrder = 0
          ThumbLength = 19
          TickMarks = tmBoth
          OnChange = CBDifficultyChange
        end
        object TBEngineVolume: TTrackBar
          Left = 140
          Top = 60
          Width = 281
          Height = 41
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Max = 100
          Frequency = 10
          Position = 80
          TabOrder = 1
          ThumbLength = 19
          TickMarks = tmBoth
          OnChange = CBDifficultyChange
        end
        object TBVoiceVolume: TTrackBar
          Left = 140
          Top = 160
          Width = 281
          Height = 41
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Max = 100
          Frequency = 10
          Position = 80
          TabOrder = 2
          ThumbLength = 19
          TickMarks = tmBoth
          OnChange = CBDifficultyChange
        end
        object TBMusicVolume: TTrackBar
          Left = 140
          Top = 110
          Width = 281
          Height = 41
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Max = 100
          Frequency = 10
          Position = 80
          TabOrder = 3
          ThumbLength = 19
          TickMarks = tmBoth
          OnChange = CBDifficultyChange
        end
      end
      object TSControls: TTabSheet
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Controls'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = []
        ImageIndex = 1
        ParentFont = False
        object Label8: TLabel
          Left = 130
          Top = 80
          Width = 78
          Height = 18
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Dead Zone'
        end
        object Label10: TLabel
          Left = 10
          Top = 20
          Width = 68
          Height = 18
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Keyboard'
        end
        object CBJoystick: TCheckBox
          Left = 10
          Top = 80
          Width = 101
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Joystick'
          TabOrder = 0
          OnClick = CBDifficultyChange
        end
        object TBJoystickDeadzone: TTrackBar
          Left = 210
          Top = 70
          Width = 211
          Height = 41
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Max = 100
          Frequency = 10
          TabOrder = 1
          ThumbLength = 19
          TickMarks = tmBoth
          OnChange = CBDifficultyChange
        end
        object BUConfigureKeyboard: TButton
          Left = 320
          Top = 15
          Width = 94
          Height = 31
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Customize'
          TabOrder = 2
          OnClick = BUConfigureKeyboardClick
        end
        object CBKeyboardLayout: TComboBox
          Left = 130
          Top = 16
          Width = 181
          Height = 26
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          TabOrder = 3
          Text = 'CBKeyboardLayout'
          OnChange = CBDifficultyChange
        end
      end
    end
  end
end
