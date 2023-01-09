object fmSettings: TfmSettings
  Left = 324
  Top = 109
  Width = 257
  Height = 417
  Caption = 'Settings'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label3: TLabel
    Left = 12
    Top = 12
    Width = 97
    Height = 13
    Caption = 'Program Settings'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label1: TLabel
    Left = 12
    Top = 79
    Width = 89
    Height = 13
    Caption = 'Splash Screens'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 12
    Top = 172
    Width = 52
    Height = 13
    Caption = 'Interface'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object cbLoadOnStartup: TCheckBox
    Left = 46
    Top = 32
    Width = 151
    Height = 17
    Caption = 'Load Planet on Startup'
    TabOrder = 0
    OnClick = cbLoadOnStartupClick
  end
  object cbAutosave: TCheckBox
    Left = 46
    Top = 52
    Width = 151
    Height = 17
    Caption = 'Autosave on Exit'
    Enabled = False
    TabOrder = 1
    OnClick = cbAutosaveClick
  end
  object panButtonBar: TPanel
    Left = 0
    Top = 342
    Width = 249
    Height = 41
    Align = alBottom
    BevelOuter = bvLowered
    TabOrder = 2
    object panOKButton: TPanel
      Left = 144
      Top = 1
      Width = 104
      Height = 39
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      object btnOK: TBitBtn
        Left = 10
        Top = 8
        Width = 75
        Height = 25
        TabOrder = 0
        Kind = bkOK
      end
    end
  end
  object cbSplashStart: TCheckBox
    Left = 46
    Top = 103
    Width = 185
    Height = 18
    Caption = 'Show Splash Screen on Startup'
    TabOrder = 3
    OnClick = cbSplashStartClick
  end
  object cbSplashExit: TCheckBox
    Left = 46
    Top = 123
    Width = 185
    Height = 18
    Caption = 'Show Splash Screen on Exit'
    TabOrder = 4
    OnClick = cbSplashExitClick
  end
  object cbInvertMouse: TCheckBox
    Left = 46
    Top = 192
    Width = 185
    Height = 18
    Caption = 'Invert First Person Mouse'
    TabOrder = 5
    OnClick = cbInvertMouseClick
  end
  object cbInvertPlanet: TCheckBox
    Left = 46
    Top = 211
    Width = 185
    Height = 18
    Caption = 'Invert Planet Mouse'
    TabOrder = 6
    OnClick = cbInvertPlanetClick
  end
  object cbAuto3DView: TCheckBox
    Left = 46
    Top = 231
    Width = 187
    Height = 18
    Caption = 'Auto 3D View In Object Windows'
    TabOrder = 7
    OnClick = cbAuto3DViewClick
  end
  object cbInvertMouseWheel: TCheckBox
    Left = 46
    Top = 251
    Width = 189
    Height = 18
    Caption = 'Invert Mousewheel Zoom'
    TabOrder = 8
    OnClick = cbInvertMouseWheelClick
  end
  object cbTipOfTheDay: TCheckBox
    Left = 46
    Top = 144
    Width = 185
    Height = 18
    Caption = 'Show Tip of the Day on Startup'
    TabOrder = 9
    OnClick = cbTipOfTheDayClick
  end
  object cbRememberView: TCheckBox
    Left = 46
    Top = 272
    Width = 191
    Height = 17
    Caption = 'Remember 3D View Size'
    TabOrder = 10
    OnClick = cbRememberViewClick
  end
  object cbAdvancedMode: TCheckBox
    Left = 46
    Top = 292
    Width = 191
    Height = 17
    Hint = 'Show advanced controls in the menus.'
    Caption = 'Advanced Mode'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 11
    OnClick = cbAdvancedModeClick
  end
end
