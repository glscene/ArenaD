object Form2: TForm2
  Left = 226
  Top = 176
  Width = 350
  Height = 260
  Caption = 'Best Scores of Simon 3D'
  Color = clBtnFace
  Constraints.MaxHeight = 265
  Constraints.MaxWidth = 355
  Constraints.MinHeight = 260
  Constraints.MinWidth = 350
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 24
    Width = 33
    Height = 13
    Caption = 'Place'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 112
    Top = 24
    Width = 33
    Height = 13
    Caption = 'Name'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 264
    Top = 24
    Width = 34
    Height = 13
    Caption = 'Score'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
  end
  object cls1: TLabel
    Left = 40
    Top = 64
    Width = 6
    Height = 13
    Caption = '1'
  end
  object cls2: TLabel
    Left = 40
    Top = 88
    Width = 6
    Height = 13
    Caption = '2'
  end
  object cls3: TLabel
    Left = 40
    Top = 112
    Width = 6
    Height = 13
    Caption = '3'
  end
  object cls4: TLabel
    Left = 40
    Top = 136
    Width = 6
    Height = 13
    Caption = '4'
  end
  object cls5: TLabel
    Left = 40
    Top = 160
    Width = 6
    Height = 13
    Caption = '5'
  end
  object nm1: TLabel
    Left = 112
    Top = 64
    Width = 29
    Height = 13
    Caption = 'Empty'
  end
  object nm2: TLabel
    Left = 112
    Top = 88
    Width = 29
    Height = 13
    Caption = 'Empty'
  end
  object nm3: TLabel
    Left = 112
    Top = 112
    Width = 29
    Height = 13
    Caption = 'Empty'
  end
  object nm4: TLabel
    Left = 112
    Top = 136
    Width = 29
    Height = 13
    Caption = 'Empty'
  end
  object nm5: TLabel
    Left = 112
    Top = 160
    Width = 29
    Height = 13
    Caption = 'Empty'
  end
  object pt1: TLabel
    Left = 280
    Top = 64
    Width = 6
    Height = 13
    Caption = '0'
  end
  object pt2: TLabel
    Left = 280
    Top = 88
    Width = 6
    Height = 13
    Caption = '0'
  end
  object pt3: TLabel
    Left = 280
    Top = 112
    Width = 6
    Height = 13
    Caption = '0'
  end
  object pt4: TLabel
    Left = 280
    Top = 136
    Width = 6
    Height = 13
    Caption = '0'
  end
  object pt5: TLabel
    Left = 280
    Top = 160
    Width = 6
    Height = 13
    Caption = '0'
  end
  object Button1: TButton
    Left = 48
    Top = 192
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 192
    Top = 192
    Width = 75
    Height = 25
    Caption = 'C&lear results'
    TabOrder = 1
    OnClick = Button2Click
  end
end
