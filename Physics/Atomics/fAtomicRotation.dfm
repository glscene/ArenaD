object AtomicRotationForm: TAtomicRotationForm
  Left = 228
  Top = 120
  Caption = 'Atomic Rotation'
  ClientHeight = 102
  ClientWidth = 386
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
    C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF006666
    6666666666666666666666666666666666666666666666666666666666666666
    66F666666666F6666666666666666666666F6666FF6F6666F6FFF66666666666
    6F666F6666F6F6F6666F6F666666666666F6FF66F6FF6FF6F6FFFFFF66666666
    6FF6F6666F666666FF6F6FF6F666666666F6F666FF66666FFFF6FF6666666666
    FFF66666F6FFF6FF66666F6F6F66666666FF666FFFFFFFF6FFF6666666666666
    F6F66666F66FFFFFFFF6F6666F66F6666FFF66F6F6FFFFFF66FFFF6F66666666
    66FF6FFF6FFFFFFFF66FFF666666FF66FFFFFFFFFF6666FFFF6FFFF6FF666F66
    66FFFF6FFF66666FF6FF6FFF6F66FF6666FFF6FFF666666FFF66666FF6666FF6
    666FF66FF666666FFF66F666FF666F6666FF666FF666666FF6FFF6666F666FFF
    66F6FFFFFF6666FFFF6FFFF66FF6666F6F6F6F66FFFFFFFF6F6F6F66F6F6666F
    F66FFFF66FFFFFFFF6FFFFF6F6666666FFF6FFFFF6FFFF6FFFFFFFF6F6666666
    6FFFFF6F6FF666FFFFF6FF666666666666FFF6FFFFFFF6FFFF6FFFF666666666
    666F6F6F6FF6FFFFF6F6F6F6666666666666FFF6666FF6F6FF66FFF666666666
    666666FF6FFFFF6FF666FF6666666666F66FF666FFF6F66F6666F6F666666F6F
    FFF6FFFFFFFF666F66FFFFF66666666FF6FF6FFFF66666666FFF666666666666
    6666666666666666F6F666666666666666666666666666666666666666660000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    000000000000000000000000000000000000000000000000000000000000}
  Position = poScreenCenter
  ShowHint = True
  OnCreate = FormCreate
  TextHeight = 13
  object SpeedButton1: TSpeedButton
    Left = 8
    Top = 9
    Width = 25
    Height = 27
    Hint = 'Set Level Color'
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000120B0000120B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00559999999995
      5555557777777775F5555559999999505555555777777757FFF5555555555550
      0955555555555FF7775F55555555995501955555555577557F75555555555555
      01995555555555557F5755555555555501905555555555557F57555555555555
      0F905555555555557FF75555555555500005555555555557777555555555550F
      F05555555555557F57F5555555555008F05555555555F775F755555555570000
      05555555555775577555555555700007555555555F755F775555555570000755
      55555555775F77555555555700075555555555F75F7755555555570007555555
      5555577F77555555555500075555555555557777555555555555}
    NumGlyphs = 2
    OnClick = SpeedButton1Click
  end
  object AtomicLevelsRg: TRadioGroup
    Left = 32
    Top = 8
    Width = 345
    Height = 49
    Caption = 'Atomic Levels'
    Columns = 8
    ItemIndex = 0
    Items.Strings = (
      '1'
      '2'
      '3'
      '4'
      '5'
      '6'
      '7'
      'Light')
    TabOrder = 0
    OnClick = AtomicLevelsRgClick
  end
  object TrackBarX: TTrackBar
    Left = 0
    Top = 64
    Width = 120
    Height = 33
    Hint = 'X (front to back) Rotation'
    Max = 100
    Min = -100
    Frequency = 10
    TabOrder = 1
    OnChange = TrackBarXChange
  end
  object TrackBarY: TTrackBar
    Left = 128
    Top = 64
    Width = 120
    Height = 33
    Hint = 'Y (Clockwise) Rotation'
    Max = 100
    Min = -100
    Frequency = 10
    TabOrder = 2
    OnChange = TrackBarXChange
  end
  object TrackBarZ: TTrackBar
    Left = 264
    Top = 64
    Width = 120
    Height = 33
    Hint = 'Z (on itself) Rotation'
    Max = 100
    Min = -100
    Frequency = 10
    TabOrder = 3
    OnChange = TrackBarXChange
  end
  object LevelLineCB: TCheckBox
    Left = 144
    Top = 7
    Width = 170
    Height = 17
    Hint = 'Line Indicator for selected level'
    Caption = 'Line Indicator for selected level'
    TabOrder = 4
    OnClick = LevelLineCBClick
  end
  object ColorDialog1: TColorDialog
    Color = clRed
    Options = [cdFullOpen, cdAnyColor]
    Left = 306
    Top = 62
  end
end
