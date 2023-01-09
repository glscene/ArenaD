object fmPhotograph: TfmPhotograph
  Left = 266
  Top = 190
  Width = 474
  Height = 318
  Caption = 'Photograph'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 466
    Height = 240
    Align = alBottom
    TabOrder = 0
    object Label1: TLabel
      Left = 40
      Top = 64
      Width = 58
      Height = 13
      Caption = 'Photograph:'
    end
    object Label2: TLabel
      Left = 48
      Top = 168
      Width = 52
      Height = 13
      Caption = 'Thumbnail:'
    end
    object Label3: TLabel
      Left = 64
      Top = 96
      Width = 34
      Height = 13
      Caption = 'Height:'
    end
    object Label4: TLabel
      Left = 224
      Top = 96
      Width = 31
      Height = 13
      Caption = 'Width:'
    end
    object Label5: TLabel
      Left = 64
      Top = 200
      Width = 34
      Height = 13
      Caption = 'Height:'
    end
    object Label6: TLabel
      Left = 224
      Top = 200
      Width = 31
      Height = 13
      Caption = 'Width:'
    end
    object Label7: TLabel
      Left = 64
      Top = 16
      Width = 31
      Height = 13
      Caption = 'Name:'
    end
    object edPhotograph: TEdit
      Left = 112
      Top = 64
      Width = 225
      Height = 21
      TabOrder = 1
      Text = 'snapshot1.bmp'
    end
    object edThumbnail: TEdit
      Left = 112
      Top = 168
      Width = 225
      Height = 21
      TabOrder = 6
      Text = 'snapshot1-thumb.bmp'
    end
    object cbCreateThumbnail: TCheckBox
      Left = 112
      Top = 144
      Width = 137
      Height = 17
      Caption = 'Create Thumbnail?'
      Checked = True
      State = cbChecked
      TabOrder = 5
    end
    object edPhotoHeight: TEdit
      Left = 112
      Top = 96
      Width = 73
      Height = 21
      TabOrder = 3
      Text = '320'
    end
    object edPhotoWidth: TEdit
      Left = 264
      Top = 96
      Width = 73
      Height = 21
      TabOrder = 4
      Text = '640'
    end
    object edThumbHeight: TEdit
      Left = 112
      Top = 200
      Width = 73
      Height = 21
      TabOrder = 8
      Text = '320'
    end
    object edThumbWidth: TEdit
      Left = 264
      Top = 200
      Width = 73
      Height = 21
      TabOrder = 9
      Text = '640'
    end
    object btnPhotograph: TBitBtn
      Left = 344
      Top = 64
      Width = 25
      Height = 25
      TabOrder = 2
      OnClick = btnPhotographClick
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000130B0000130B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333330070
        7700333333337777777733333333008088003333333377F73377333333330088
        88003333333377FFFF7733333333000000003FFFFFFF77777777000000000000
        000077777777777777770FFFFFFF0FFFFFF07F3333337F3333370FFFFFFF0FFF
        FFF07F3FF3FF7FFFFFF70F00F0080CCC9CC07F773773777777770FFFFFFFF039
        99337F3FFFF3F7F777F30F0000F0F09999937F7777373777777F0FFFFFFFF999
        99997F3FF3FFF77777770F00F000003999337F773777773777F30FFFF0FF0339
        99337F3FF7F3733777F30F08F0F0337999337F7737F73F7777330FFFF0039999
        93337FFFF7737777733300000033333333337777773333333333}
      NumGlyphs = 2
    end
    object btnThumbnail: TBitBtn
      Left = 344
      Top = 168
      Width = 25
      Height = 25
      TabOrder = 7
      OnClick = btnThumbnailClick
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000130B0000130B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333330070
        7700333333337777777733333333008088003333333377F73377333333330088
        88003333333377FFFF7733333333000000003FFFFFFF77777777000000000000
        000077777777777777770FFFFFFF0FFFFFF07F3333337F3333370FFFFFFF0FFF
        FFF07F3FF3FF7FFFFFF70F00F0080CCC9CC07F773773777777770FFFFFFFF039
        99337F3FFFF3F7F777F30F0000F0F09999937F7777373777777F0FFFFFFFF999
        99997F3FF3FFF77777770F00F000003999337F773777773777F30FFFF0FF0339
        99337F3FF7F3733777F30F08F0F0337999337F7737F73F7777330FFFF0039999
        93337FFFF7737777733300000033333333337777773333333333}
      NumGlyphs = 2
    end
    object edName: TEdit
      Left = 112
      Top = 16
      Width = 225
      Height = 21
      TabOrder = 0
      Text = 'snapshot1'
      OnChange = edNameChange
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 240
    Width = 466
    Height = 44
    Align = alBottom
    TabOrder = 1
    object Panel4: TPanel
      Left = 288
      Top = 1
      Width = 177
      Height = 42
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      object BitBtn1: TBitBtn
        Left = 86
        Top = 8
        Width = 75
        Height = 25
        TabOrder = 0
        Kind = bkOK
      end
      object BitBtn2: TBitBtn
        Left = 6
        Top = 8
        Width = 75
        Height = 25
        TabOrder = 1
        Kind = bkCancel
      end
    end
  end
  object SaveDialog: TSaveDialog
    Left = 6
    Top = 2
  end
end
