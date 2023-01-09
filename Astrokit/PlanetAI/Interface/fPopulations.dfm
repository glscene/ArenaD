object fmPopulations: TfmPopulations
  Left = 338
  Top = 179
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Populations'
  ClientHeight = 416
  ClientWidth = 551
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 120
  TextHeight = 16
  object PopGraph: TChart
    Left = 0
    Top = 0
    Width = 551
    Height = 341
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    BackWall.Brush.Style = bsClear
    LeftWall.Color = clWhite
    Legend.LegendStyle = lsSeries
    Title.Text.Strings = (
      'Populations')
    Title.Visible = False
    Chart3DPercent = 10
    View3DOptions.Perspective = 0
    Align = alClient
    TabOrder = 0
    DefaultCanvas = 'TGDIPlusCanvas'
    PrintMargins = (
      15
      19
      15
      19)
    ColorPaletteIndex = 13
    object Series1: TLineSeries
      HoverElement = [heCurrent]
      Brush.BackColor = clDefault
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 341
    Width = 551
    Height = 75
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alBottom
    TabOrder = 1
    object Label1: TLabel
      Left = 20
      Top = 45
      Width = 64
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Crop Rate:'
    end
    object Label2: TLabel
      Left = 188
      Top = 45
      Width = 82
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Refresh Rate:'
    end
    object Panel4: TPanel
      Left = 414
      Top = 1
      Width = 136
      Height = 73
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      object btnRun: TBitBtn
        Left = 30
        Top = 30
        Width = 94
        Height = 31
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Close'
        Kind = bkOK
        NumGlyphs = 2
        TabOrder = 0
        OnClick = btnRunClick
      end
    end
    object cb3DGraph: TCheckBox
      Left = 88
      Top = 10
      Width = 96
      Height = 21
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = '3-D Graph'
      Checked = True
      State = cbChecked
      TabOrder = 1
      OnClick = cb3DGraphClick
    end
    object cbCrop: TCheckBox
      Left = 18
      Top = 10
      Width = 63
      Height = 21
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Crop'
      Checked = True
      State = cbChecked
      TabOrder = 2
    end
    object cbHiddenRefresh: TCheckBox
      Left = 190
      Top = 10
      Width = 169
      Height = 21
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Refresh When Hidden'
      Checked = True
      State = cbChecked
      TabOrder = 3
    end
  end
end
