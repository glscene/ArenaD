object AboutForm: TAboutForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'About'
  ClientHeight = 267
  ClientWidth = 420
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poScreenCenter
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 420
    Height = 74
    Align = alTop
    Caption = 'Plot1Ds v.3'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
  end
  object Panel2: TPanel
    Left = 0
    Top = 224
    Width = 420
    Height = 43
    Align = alBottom
    Caption = 'Copyright '#169' GLS Team'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
  end
  object PanelCentre: TPanel
    Left = 0
    Top = 74
    Width = 420
    Height = 150
    Align = alClient
    Caption = ' '
    TabOrder = 2
    object MemoContributors: TMemo
      Left = 72
      Top = 63
      Width = 265
      Height = 58
      Alignment = taCenter
      Lines.Strings = (
        'Eric Hardinger'
        'Eric Grange'
        'Pavel Vassiliev')
      TabOrder = 0
      Visible = False
    end
    object Button1: TButton
      Left = 104
      Top = 23
      Width = 201
      Height = 25
      Caption = 'Developers and Contributors'
      TabOrder = 1
      OnClick = Button1Click
    end
  end
end
