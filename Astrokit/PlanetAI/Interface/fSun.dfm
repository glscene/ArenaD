object fmSatellite: TfmSatellite
  Left = 367
  Top = 215
  Width = 345
  Height = 244
  Caption = 'Satellite'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object panDescription: TPanel
    Left = 0
    Top = 0
    Width = 337
    Height = 29
    Align = alTop
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 0
    object Label1: TLabel
      Left = 150
      Top = 8
      Width = 154
      Height = 13
      Caption = 'Temperature increase per round.'
    end
    object Panel21: TPanel
      Left = 0
      Top = 0
      Width = 100
      Height = 29
      Align = alLeft
      Alignment = taRightJustify
      BevelOuter = bvNone
      BorderWidth = 5
      Caption = 'Heat:'
      ParentColor = True
      TabOrder = 0
    end
    object edHeat: TEdit
      Left = 102
      Top = 4
      Width = 39
      Height = 21
      TabOrder = 1
      Text = '1'
      OnChange = edHeatChange
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 58
    Width = 337
    Height = 29
    Align = alTop
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 1
    object Label3: TLabel
      Left = 150
      Top = 8
      Width = 155
      Height = 13
      Caption = 'Rate of movement in clock ticks.'
    end
    object Panel2: TPanel
      Left = 0
      Top = 0
      Width = 100
      Height = 29
      Align = alLeft
      Alignment = taRightJustify
      BevelOuter = bvNone
      BorderWidth = 5
      Caption = 'Movement:'
      ParentColor = True
      TabOrder = 0
    end
    object edRate: TEdit
      Left = 102
      Top = 4
      Width = 39
      Height = 21
      TabOrder = 1
      Text = '25'
      OnChange = edRateChange
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 29
    Width = 337
    Height = 29
    Align = alTop
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 2
    object Label2: TLabel
      Left = 150
      Top = 8
      Width = 87
      Height = 13
      Caption = 'Distance of effect.'
    end
    object Panel4: TPanel
      Left = 0
      Top = 0
      Width = 100
      Height = 29
      Align = alLeft
      Alignment = taRightJustify
      BevelOuter = bvNone
      BorderWidth = 5
      Caption = 'Radius:'
      ParentColor = True
      TabOrder = 0
    end
    object edRadius: TEdit
      Left = 102
      Top = 4
      Width = 39
      Height = 21
      TabOrder = 1
      Text = '5'
      OnChange = edRadiusChange
    end
  end
  object Panel5: TPanel
    Left = 0
    Top = 87
    Width = 337
    Height = 82
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 5
    TabOrder = 3
    object rgDirection: TRadioGroup
      Left = 46
      Top = 5
      Width = 202
      Height = 72
      Align = alClient
      Caption = 'Direction:'
      Columns = 2
      ItemIndex = 2
      Items.Strings = (
        'Up'
        'Down'
        'Left'
        'Right')
      TabOrder = 0
      OnClick = rgDirectionClick
    end
    object Panel6: TPanel
      Left = 5
      Top = 5
      Width = 41
      Height = 72
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 1
    end
    object Panel7: TPanel
      Left = 248
      Top = 5
      Width = 84
      Height = 72
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 2
    end
  end
  object panButtonBar: TPanel
    Left = 0
    Top = 169
    Width = 337
    Height = 41
    Align = alBottom
    BevelOuter = bvLowered
    TabOrder = 4
    object panOKButton: TPanel
      Left = 232
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
        OnClick = btnOKClick
        Kind = bkOK
      end
    end
  end
end
