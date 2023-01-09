object fmWorld: TfmWorld
  Left = 192
  Top = 200
  Width = 559
  Height = 364
  Caption = 'World'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 56
    Top = 138
    Width = 53
    Height = 13
    Caption = 'Frequency:'
  end
  object Label2: TLabel
    Left = 56
    Top = 160
    Width = 42
    Height = 13
    Caption = 'Quantity:'
  end
  object Label4: TLabel
    Left = 12
    Top = 22
    Width = 71
    Height = 13
    Caption = 'Planet Settings'
  end
  object Label5: TLabel
    Left = 314
    Top = 48
    Width = 33
    Height = 13
    Caption = 'Radius'
  end
  object Label6: TLabel
    Left = 316
    Top = 72
    Width = 31
    Height = 13
    Caption = 'Height'
  end
  object Label7: TLabel
    Left = 320
    Top = 98
    Width = 28
    Height = 13
    Caption = 'Width'
  end
  object Label3: TLabel
    Left = 294
    Top = 22
    Width = 42
    Height = 13
    Caption = 'Statistics'
  end
  object Label8: TLabel
    Left = 50
    Top = 46
    Width = 31
    Height = 13
    Caption = 'Name:'
  end
  object Label9: TLabel
    Left = 44
    Top = 70
    Width = 37
    Height = 13
    Caption = 'Creator:'
  end
  object CheckBox1: TCheckBox
    Left = 38
    Top = 112
    Width = 157
    Height = 17
    Caption = 'Asteroid Showers'
    Checked = True
    State = cbChecked
    TabOrder = 0
  end
  object Edit1: TEdit
    Left = 112
    Top = 134
    Width = 45
    Height = 21
    TabOrder = 1
    Text = '128'
  end
  object Edit2: TEdit
    Left = 112
    Top = 158
    Width = 45
    Height = 21
    TabOrder = 2
    Text = '5'
  end
  object edRadius: TEdit
    Left = 356
    Top = 42
    Width = 43
    Height = 21
    ReadOnly = True
    TabOrder = 3
    Text = '7'
  end
  object edHeight: TEdit
    Left = 356
    Top = 68
    Width = 45
    Height = 21
    ReadOnly = True
    TabOrder = 4
    Text = '15'
  end
  object edWidth: TEdit
    Left = 356
    Top = 94
    Width = 45
    Height = 21
    ReadOnly = True
    TabOrder = 5
    Text = '30'
  end
  object panButtonBar: TPanel
    Left = 0
    Top = 289
    Width = 551
    Height = 41
    Align = alBottom
    BevelOuter = bvLowered
    TabOrder = 6
    object panOKButton: TPanel
      Left = 446
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
  object BitBtn1: TBitBtn
    Left = 26
    Top = 218
    Width = 165
    Height = 25
    Caption = 'Maximums'
    TabOrder = 7
  end
  object RichEdit1: TRichEdit
    Left = 294
    Top = 128
    Width = 235
    Height = 141
    Lines.Strings = (
      'StatusReport')
    TabOrder = 8
  end
  object Edit3: TEdit
    Left = 86
    Top = 42
    Width = 121
    Height = 21
    TabOrder = 9
    Text = 'aiplanet'
  end
  object Edit4: TEdit
    Left = 86
    Top = 68
    Width = 121
    Height = 21
    TabOrder = 10
    Text = 'user'
  end
end
