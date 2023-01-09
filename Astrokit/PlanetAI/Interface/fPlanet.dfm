object fmPlanet: TfmPlanet
  Left = 337
  Top = 313
  Caption = 'Build Planet'
  ClientHeight = 298
  ClientWidth = 395
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010001002020100000000000E80200001600000028000000200000004000
    0000010004000000000080020000000000000000000000000000000000000000
    000000008000008000000080800080000000800080008080000080808000C0C0
    C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF009999
    99999999999999999999999999999FFFFFFFFFFFFF88888888888FFFFFF997FF
    FFFFFFFF888888888888888FFFF9977FFFFFFFF8444C444888888888FFF99777
    FFFFFF4444444444488888888FF997777FFF44444C4C4C4C4C48888888F99777
    77F44444443444444444888888F99777774C444C433C4C4C4C4C488888899777
    74444444C334C444C444C48888899777744C4C4C433C4C4C4C4C4C8888899777
    444444C43334CCC4C4C4C44888899777444C4C43333C4C4C4C4C4C3888899774
    4444C4433333CCCCC4CCC433888997744C4C4C4333333C4C4C4C4C3388899774
    4444C43333333CCCCCCCC43388899774444C4C333333CC4CCC4C4C3388899774
    4444C433333CCCCCCCC33333888997744C4C4C334C4C4CCCCCC3333388899774
    44444433CCCC3CCCCCC3333388F99777444C4C433C433C4CCC4C333888F99777
    4444343333333CCCCCCCC4C88FF99777744C333333333C4C4C433C88FFF99777
    7444333333333CCCCCC3348FFFF99777774C333333333C4C3C433FFFFFF99777
    7774333333C333CC3433FFFFFFF9977777774333334C333C4C377FFFFFF99777
    77777744433444C4477777FFFFF99777777777774C4C4C477777777FFFF99777
    777777777777777777777777FFF997777777777777777777777777777FF99777
    77777777777777777777777777F9999999999999999999999999999999990000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    000000000000000000000000000000000000000000000000000000000000}
  PixelsPerInch = 120
  TextHeight = 16
  object Label1: TLabel
    Left = 30
    Top = 20
    Width = 29
    Height = 16
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Core'
  end
  object Label2: TLabel
    Left = 60
    Top = 50
    Width = 8
    Height = 16
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'X'
  end
  object Label3: TLabel
    Left = 160
    Top = 50
    Width = 9
    Height = 16
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Y'
  end
  object Label4: TLabel
    Left = 270
    Top = 50
    Width = 8
    Height = 16
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Z'
  end
  object Label5: TLabel
    Left = 20
    Top = 100
    Width = 43
    Height = 16
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Radius'
  end
  object Label6: TLabel
    Left = 30
    Top = 150
    Width = 39
    Height = 16
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Height'
  end
  object Label7: TLabel
    Left = 30
    Top = 190
    Width = 34
    Height = 16
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Width'
  end
  object edX: TEdit
    Left = 80
    Top = 40
    Width = 71
    Height = 24
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    TabOrder = 0
    Text = '0'
  end
  object edY: TEdit
    Left = 180
    Top = 40
    Width = 71
    Height = 24
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    TabOrder = 1
    Text = '0'
  end
  object edZ: TEdit
    Left = 290
    Top = 40
    Width = 71
    Height = 24
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    TabOrder = 2
    Text = '0'
  end
  object edRadius: TEdit
    Left = 80
    Top = 90
    Width = 71
    Height = 24
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    TabOrder = 3
    Text = '7'
  end
  object edHeight: TEdit
    Left = 80
    Top = 140
    Width = 71
    Height = 24
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    TabOrder = 4
    Text = '15'
  end
  object edWidth: TEdit
    Left = 80
    Top = 180
    Width = 71
    Height = 24
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    TabOrder = 5
    Text = '30'
  end
  object cbShowBuild: TCheckBox
    Left = 265
    Top = 142
    Width = 121
    Height = 21
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Show Build'
    TabOrder = 6
  end
  object btnOK: TBitBtn
    Left = 290
    Top = 260
    Width = 94
    Height = 31
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Kind = bkOK
    NumGlyphs = 2
    TabOrder = 7
  end
  object btnCancel: TBitBtn
    Left = 180
    Top = 260
    Width = 94
    Height = 31
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Kind = bkCancel
    NumGlyphs = 2
    TabOrder = 8
  end
end
