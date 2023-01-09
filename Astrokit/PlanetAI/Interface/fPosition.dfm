object fmPosition: TfmPosition
  Left = 335
  Top = 113
  Caption = 'Position'
  ClientHeight = 516
  ClientWidth = 313
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
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 313
    Height = 37
    Align = alTop
    TabOrder = 9
    object Panel1: TPanel
      Left = 1
      Top = 1
      Width = 68
      Height = 35
      Align = alLeft
      BevelOuter = bvNone
      Caption = 'Creature:'
      TabOrder = 0
    end
    object panID: TPanel
      Left = 69
      Top = 1
      Width = 243
      Height = 35
      Align = alClient
      Alignment = taLeftJustify
      BevelOuter = bvNone
      Caption = 'ID'
      TabOrder = 1
    end
  end
  object panButtonBar: TPanel
    Left = 0
    Top = 442
    Width = 313
    Height = 74
    Align = alBottom
    BevelOuter = bvLowered
    TabOrder = 17
    ExplicitTop = 452
    object panOKButton: TPanel
      Left = 208
      Top = 1
      Width = 104
      Height = 72
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      object btnOK: TBitBtn
        Left = 20
        Top = 42
        Width = 75
        Height = 25
        DoubleBuffered = True
        Kind = bkOK
        ParentDoubleBuffered = False
        TabOrder = 0
        OnClick = btnOKClick
      end
    end
    object btnCancel: TBitBtn
      Left = 10
      Top = 42
      Width = 75
      Height = 25
      DoubleBuffered = True
      Kind = bkCancel
      ParentDoubleBuffered = False
      TabOrder = 1
      OnClick = btnCancelClick
    end
    object btnApply: TBitBtn
      Left = 228
      Top = 10
      Width = 75
      Height = 25
      Caption = 'Apply'
      DoubleBuffered = True
      ParentDoubleBuffered = False
      TabOrder = 2
      OnClick = btnApplyClick
    end
    object btnCopy: TBitBtn
      Left = 10
      Top = 10
      Width = 75
      Height = 25
      Hint = 'Copy from another object'#39's position (enter handle).'
      Caption = 'Copy'
      DoubleBuffered = True
      ParentDoubleBuffered = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      OnClick = btnCopyClick
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 37
    Width = 313
    Height = 23
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object Panel4: TPanel
      Left = 0
      Top = 0
      Width = 93
      Height = 23
      Align = alLeft
      Alignment = taRightJustify
      BevelOuter = bvNone
      Caption = 'X:'
      TabOrder = 0
    end
  end
  object Panel5: TPanel
    Left = 0
    Top = 359
    Width = 313
    Height = 23
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 14
    object Panel8: TPanel
      Left = 0
      Top = 0
      Width = 93
      Height = 23
      Align = alLeft
      Alignment = taRightJustify
      BevelOuter = bvNone
      Caption = 'SizeX:'
      TabOrder = 0
    end
  end
  object Panel9: TPanel
    Left = 0
    Top = 336
    Width = 313
    Height = 23
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 13
    object Panel10: TPanel
      Left = 0
      Top = 0
      Width = 93
      Height = 23
      Align = alLeft
      Alignment = taRightJustify
      BevelOuter = bvNone
      Caption = 'Buoyancy:'
      TabOrder = 0
    end
  end
  object Panel11: TPanel
    Left = 0
    Top = 313
    Width = 313
    Height = 23
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 12
    object Panel14: TPanel
      Left = 0
      Top = 0
      Width = 93
      Height = 23
      Align = alLeft
      Alignment = taRightJustify
      BevelOuter = bvNone
      Caption = 'Bounce:'
      TabOrder = 0
    end
  end
  object Panel15: TPanel
    Left = 0
    Top = 290
    Width = 313
    Height = 23
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 11
    object Panel16: TPanel
      Left = 0
      Top = 0
      Width = 93
      Height = 23
      Align = alLeft
      Alignment = taRightJustify
      BevelOuter = bvNone
      Caption = 'Mass:'
      TabOrder = 0
    end
  end
  object Panel17: TPanel
    Left = 0
    Top = 267
    Width = 313
    Height = 23
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 10
    object Panel18: TPanel
      Left = 0
      Top = 0
      Width = 93
      Height = 23
      Align = alLeft
      Alignment = taRightJustify
      BevelOuter = bvNone
      Caption = 'DirectionH:'
      TabOrder = 0
    end
  end
  object Panel19: TPanel
    Left = 0
    Top = 244
    Width = 313
    Height = 23
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 18
    object Panel20: TPanel
      Left = 0
      Top = 0
      Width = 93
      Height = 23
      Align = alLeft
      Alignment = taRightJustify
      BevelOuter = bvNone
      Caption = 'DirectionXY:'
      TabOrder = 0
    end
  end
  object Panel21: TPanel
    Left = 0
    Top = 221
    Width = 313
    Height = 23
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 8
    object Panel22: TPanel
      Left = 0
      Top = 0
      Width = 93
      Height = 23
      Align = alLeft
      Alignment = taRightJustify
      BevelOuter = bvNone
      Caption = 'Acceleration.H:'
      TabOrder = 0
    end
  end
  object Panel23: TPanel
    Left = 0
    Top = 198
    Width = 313
    Height = 23
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 7
    object Panel24: TPanel
      Left = 0
      Top = 0
      Width = 93
      Height = 23
      Align = alLeft
      Alignment = taRightJustify
      BevelOuter = bvNone
      Caption = 'Acceleration.Y:'
      TabOrder = 0
    end
  end
  object Panel25: TPanel
    Left = 0
    Top = 175
    Width = 313
    Height = 23
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 6
    object Panel26: TPanel
      Left = 0
      Top = 0
      Width = 93
      Height = 23
      Align = alLeft
      Alignment = taRightJustify
      BevelOuter = bvNone
      Caption = 'Acceleration.X:'
      TabOrder = 0
    end
  end
  object Panel27: TPanel
    Left = 0
    Top = 152
    Width = 313
    Height = 23
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 5
    object Panel28: TPanel
      Left = 0
      Top = 0
      Width = 93
      Height = 23
      Align = alLeft
      Alignment = taRightJustify
      BevelOuter = bvNone
      Caption = 'Velocity.H:'
      TabOrder = 0
    end
  end
  object Panel29: TPanel
    Left = 0
    Top = 129
    Width = 313
    Height = 23
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 4
    object Panel30: TPanel
      Left = 0
      Top = 0
      Width = 93
      Height = 23
      Align = alLeft
      Alignment = taRightJustify
      BevelOuter = bvNone
      Caption = 'Velocity.Y:'
      TabOrder = 0
    end
  end
  object Panel31: TPanel
    Left = 0
    Top = 106
    Width = 313
    Height = 23
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 3
    object Panel32: TPanel
      Left = 0
      Top = 0
      Width = 93
      Height = 23
      Align = alLeft
      Alignment = taRightJustify
      BevelOuter = bvNone
      Caption = 'Velocity.X:'
      TabOrder = 0
    end
  end
  object Panel33: TPanel
    Left = 0
    Top = 83
    Width = 313
    Height = 23
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    object Panel34: TPanel
      Left = 0
      Top = 0
      Width = 93
      Height = 23
      Align = alLeft
      Alignment = taRightJustify
      BevelOuter = bvNone
      Caption = 'Height:'
      TabOrder = 0
    end
  end
  object Panel35: TPanel
    Left = 0
    Top = 60
    Width = 313
    Height = 23
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object Panel36: TPanel
      Left = 0
      Top = 0
      Width = 93
      Height = 23
      Align = alLeft
      Alignment = taRightJustify
      BevelOuter = bvNone
      Caption = 'Y:'
      TabOrder = 0
    end
  end
  object Panel41: TPanel
    Left = 0
    Top = 428
    Width = 313
    Height = 23
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 19
    object Panel42: TPanel
      Left = 0
      Top = 0
      Width = 93
      Height = 23
      Align = alLeft
      Alignment = taRightJustify
      BevelOuter = bvNone
      Caption = 'Tangible:'
      TabOrder = 0
    end
    object cbTangible: TCheckBox
      Left = 100
      Top = 4
      Width = 39
      Height = 17
      Enabled = False
      TabOrder = 2
    end
    object cbCollider: TCheckBox
      Left = 132
      Top = 4
      Width = 57
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Collider:'
      Enabled = False
      TabOrder = 1
    end
  end
  object Panel43: TPanel
    Left = 0
    Top = 405
    Width = 313
    Height = 23
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 16
    object Panel44: TPanel
      Left = 0
      Top = 0
      Width = 93
      Height = 23
      Align = alLeft
      Alignment = taRightJustify
      BevelOuter = bvNone
      Caption = 'SizeH:'
      TabOrder = 0
    end
  end
  object Panel45: TPanel
    Left = 0
    Top = 382
    Width = 313
    Height = 23
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 15
    object Panel46: TPanel
      Left = 0
      Top = 0
      Width = 93
      Height = 23
      Align = alLeft
      Alignment = taRightJustify
      BevelOuter = bvNone
      Caption = 'SizeY:'
      TabOrder = 0
    end
  end
end
