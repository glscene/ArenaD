object fmBuildProgress: TfmBuildProgress
  Left = 569
  Top = 180
  BorderIcons = []
  Caption = 'Building Planet...'
  ClientHeight = 25
  ClientWidth = 300
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object pbBuildProgress: TProgressBar
    Left = 10
    Top = 10
    Width = 291
    Height = 21
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    TabOrder = 0
  end
end
