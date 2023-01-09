object fmTutorial: TfmTutorial
  Left = 325
  Top = 87
  Caption = 'Tutorial'
  ClientHeight = 680
  ClientWidth = 530
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
    Width = 530
    Height = 51
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alTop
    Caption = 'Tutorial'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -20
    Font.Name = 'Lucida Sans'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
  end
  object Panel2: TPanel
    Left = 0
    Top = 51
    Width = 530
    Height = 578
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alClient
    BorderWidth = 10
    TabOrder = 1
    object redIntro: TRichEdit
      Left = 11
      Top = 11
      Width = 508
      Height = 556
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
        
          'Your planet is a habitat for artificial intelligence to live on.' +
          '  '
        
          'To create a planet, you will need water, land, a sun, and food. ' +
          ' When you start'
        
          'a new reality, your planet is covered in water.  You will have t' +
          'o clear some'
        
          'water away, to make land.   After this is done, you should add s' +
          'ome trees.'
        ''
        ''
        'First Steps:'
        '---------------------------'
        ''
        '1) Click on the Galaxy Menu'
        '- add a Sun'
        '- add a moon'
        ''
        '2) Click on the Land Menu'
        '- add some Dirt squares'
        '- add some Field/Grass/etc squares'
        ''
        '3) Click on the Fauna Menu'
        '- add some Apple seeds'
        '- add some Orange seeds'
        ''
        '4) Click on the Creatures Menu'
        '- add some Birds'
        '- add some Fish'
        ''
        '5) Experiment'
        '- add other Creatures'
        '- add Beacons to make rivers'
        '- Load other worlds'
        '- Save your world'
        ''
        
          'Now that you have a basic galaxy made, you can let it run and wa' +
          'tch it grow.'
        '')
      ParentFont = False
      ReadOnly = True
      ScrollBars = ssBoth
      TabOrder = 0
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 629
    Width = 530
    Height = 51
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alBottom
    TabOrder = 2
    object Panel4: TPanel
      Left = 393
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
end
