object fmError: TfmError
  Left = 322
  Top = 166
  Caption = 'AI Planet Error!'
  ClientHeight = 419
  ClientWidth = 605
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Position = poOwnerFormCenter
  OnShow = FormShow
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 605
    Height = 41
    Align = alTop
    Alignment = taLeftJustify
    BorderWidth = 10
    Caption = 
      'AI Planet has crashed.  Sorry for the inconvenience. Please foll' +
      'ow the steps below to report the error.'
    TabOrder = 0
  end
  object Panel2: TPanel
    Left = 0
    Top = 257
    Width = 605
    Height = 121
    Align = alBottom
    TabOrder = 1
    object Label1: TLabel
      Left = 12
      Top = 78
      Width = 390
      Height = 13
      Caption = 
        'STEP THREE: Optional, visit the bug tracking homepage to view mo' +
        're information:'
    end
    object Label2: TLabel
      Left = 38
      Top = 93
      Width = 351
      Height = 13
      Cursor = crHandPoint
      Caption = 
        'http://sourceforge.net/tracker/?atid=521003&group_id=68377&func=' +
        'browse'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsUnderline]
      ParentColor = False
      ParentFont = False
      OnClick = Label2Click
    end
    object Label3: TLabel
      Left = 12
      Top = 44
      Width = 537
      Height = 13
      Caption = 
        'STEP TWO: Send an e-mail by clicking the link below, and paste t' +
        'he information into the e-mail by pressing Ctrl+V.'
    end
    object Label4: TLabel
      Left = 38
      Top = 60
      Width = 168
      Height = 13
      Cursor = crHandPoint
      Caption = 'aiplanet-bugs@lists.sourceforge.net'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsUnderline]
      ParentFont = False
      OnClick = Label4Click
    end
    object Label5: TLabel
      Left = 12
      Top = 24
      Width = 294
      Height = 13
      Caption = 'STEP ONE: Copy the text in the above box by pressing Ctrl+C.'
    end
    object Label6: TLabel
      Left = 10
      Top = 6
      Width = 136
      Height = 13
      Caption = 'Error Reporting Process'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 41
    Width = 605
    Height = 216
    Align = alClient
    BorderWidth = 5
    TabOrder = 2
    ExplicitTop = 29
    ExplicitHeight = 228
    object memReport: TMemo
      Left = 6
      Top = 6
      Width = 593
      Height = 204
      Align = alClient
      Color = clBlack
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      Lines.Strings = (
        '')
      ParentFont = False
      ReadOnly = True
      ScrollBars = ssBoth
      TabOrder = 0
      WordWrap = False
      ExplicitHeight = 216
    end
  end
  object Panel4: TPanel
    Left = 0
    Top = 378
    Width = 605
    Height = 41
    Align = alBottom
    TabOrder = 3
    object Button4: TButton
      Left = 494
      Top = 8
      Width = 99
      Height = 25
      Caption = 'Close'
      TabOrder = 0
      OnClick = Button4Click
    end
    object btnSaveWorld: TBitBtn
      Left = 10
      Top = 8
      Width = 99
      Height = 25
      Caption = 'Save World'
      TabOrder = 1
      OnClick = btnSaveWorldClick
    end
  end
end
