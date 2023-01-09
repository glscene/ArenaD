object fmKeyboard: TfmKeyboard
  Left = 435
  Top = 67
  Caption = 'Controls'
  ClientHeight = 571
  ClientWidth = 524
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  PixelsPerInch = 120
  TextHeight = 16
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 524
    Height = 51
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alTop
    Caption = 'Keyboard and Mouse'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -20
    Font.Name = 'Lucida Sans'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
  end
  object Panel3: TPanel
    Left = 0
    Top = 520
    Width = 524
    Height = 51
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alBottom
    TabOrder = 1
    object Panel4: TPanel
      Left = 387
      Top = 1
      Width = 136
      Height = 49
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      object btnRun: TBitBtn
        Left = 23
        Top = 8
        Width = 93
        Height = 31
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Kind = bkOK
        NumGlyphs = 2
        TabOrder = 0
      end
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 51
    Width = 524
    Height = 469
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alClient
    BorderWidth = 10
    TabOrder = 2
    object redIntro: TRichEdit
      Left = 11
      Top = 11
      Width = 502
      Height = 447
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alClient
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      Lines.Strings = (
        'HOW TO USE THE MOUSE INTERFACE'
        ''
        'Planet Mode'
        '--------------------'
        'Use the left mouse button by itself to use a tool.'
        'Use the right mouse button to move the view.'
        'Use the mouse wheel to zoom in and out of the planet.'
        ''
        'Avatar Mode (First Person)'
        '---------------------'
        'From the planet camera, you can use the mouse wheel'
        'to zoom in very close.  This will take you to first person mode.'
        'Use the mouse wheel to jump back off the planet.'
        ''
        'Use the left mouse button by itself to use a tool.'
        'Use the right mouse button to look around.'
        'Hold down both mouse buttons to move forwards.'
        'Hold down the middle button to move backwards.'
        ''
        ''
        'KEYBOARD'
        '-------------------------------'
        'Up - Move Forward'
        'Down - Move Backward'
        'Left - Turn Left'
        'Right - Turn Right'
        'Shift - Run'
        ''
        'W - Move Forward'
        'S - Move Backward'
        'A - Move Left'
        'D - Move Right'
        ''
        ''
        'CAMERA'
        '------------'
        'P - Planet'
        '\ - Follow Target'
        '[ - Previous Target'
        '] - Next Target'
        'TAB - First person'
        ''
        'Home - Look Up'
        'End - Look Down'
        'R - Raise Camera Height'
        'F - Lower Camera Height'
        ''
        'ESC - Leave Fullscreen Mode'
        ''
        'Targetting'
        '----------------'
        '1 - Sun'
        '2 - Moon'
        '3 - Bird'
        '4 - Fish'
        '5 - Apple Tree'
        '6 - Orange Tree'
        '7 - Cloud'
        '8 - Asteroid'
        '0 - Bot')
      ParentFont = False
      ReadOnly = True
      ScrollBars = ssBoth
      TabOrder = 0
    end
  end
end
