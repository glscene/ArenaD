object GlsSmdQcFrm: TGlsSmdQcFrm
  Left = 126
  Top = 77
  HelpContext = 8000
  Caption = 'Rag Doll'
  ClientHeight = 521
  ClientWidth = 883
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
    C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000990
    0000000009990000000999999000099900000100099900000009990000000999
    1000999009990000000990009990009999999990099900000009999999900000
    9999997009990000000099999000000000000000000000000000000000000000
    0000000000000000000000000000000099999100099999999000999991000099
    9999999009999999900999999990099990000990099900000099900009900999
    0000099009990000009990000990099000999990099900000000000099900990
    0099990009990000000009999990099000000000099900000009999990000999
    0000010009990000000999000000009910009990099900000009900099900099
    9999999009990000000999999990000999999970099900000000999999000000
    0000000000000000000000000000000000000000000000000000000000000000
    9999910009999999900099999100000999009990099999999009999099900999
    9000099009990000009990000990099900000990099900000099900009900990
    0099999009990000000000079990099000999990099900000000099999000990
    0000000009990000000999990000099900000100099900000009990000000999
    1000999009990000000990009990079999999990099900000009999999900009
    9999990009990000000099999000000000000000000000000000000000009FF8
    FE078FB8FE3F8718FE71C018FE01F018FF07FFFFFFFFFFFFFFFFF0380703C018
    06018798FC798F98FC799C18FFF19C38FF819FF8FE078FB8FE3FC718FE71C018
    FE01E018FF03FFFFFFFFFFFFFFFFF0380703E31806118798FC798F98FC799C18
    FFE19C18FF839FF8FE0F8FB8FE3F8718FE718018FE01E038FF07FFFFFFFF}
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnHide = FormHide
  OnShow = FormShow
  PixelsPerInch = 120
  TextHeight = 16
  object GLSceneViewer1: TGLSceneViewer
    Left = 0
    Top = 0
    Width = 573
    Height = 521
    HelpContext = 8000
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Camera = GLCamera1
    Buffer.BackgroundColor = clGray
    FieldOfView = 158.269744873046900000
    PenAsTouch = False
    Align = alClient
    OnMouseDown = GLSceneViewer1MouseDown
    OnMouseMove = GLSceneViewer1MouseMove
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 573
    Top = 0
    Width = 310
    Height = 521
    HelpContext = 8000
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alRight
    TabOrder = 1
    object Bevel2: TBevel
      Left = 10
      Top = 250
      Width = 291
      Height = 111
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
    end
    object Bevel1: TBevel
      Left = 10
      Top = 120
      Width = 291
      Height = 121
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
    end
    object Label4: TLabel
      Left = 20
      Top = 130
      Width = 89
      Height = 32
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = '(Tracked by Spine)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -14
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      WordWrap = True
    end
    object Label5: TLabel
      Left = 160
      Top = 140
      Width = 8
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'X'
    end
    object Label6: TLabel
      Left = 160
      Top = 170
      Width = 9
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Y'
    end
    object Label7: TLabel
      Left = 160
      Top = 200
      Width = 8
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Z'
    end
    object Label8: TLabel
      Left = 20
      Top = 260
      Width = 89
      Height = 32
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = '(Tracked by Head)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -14
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      WordWrap = True
    end
    object Label9: TLabel
      Left = 160
      Top = 260
      Width = 8
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'X'
    end
    object Label10: TLabel
      Left = 160
      Top = 290
      Width = 9
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Y'
    end
    object Label11: TLabel
      Left = 160
      Top = 320
      Width = 8
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Z'
    end
    object Label14: TLabel
      Left = 10
      Top = 370
      Width = 126
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Spine Time Reaction'
    end
    object Label1: TLabel
      Left = 10
      Top = 400
      Width = 125
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Head Time Reaction'
    end
    object Label15: TLabel
      Left = 1
      Top = 488
      Width = 290
      Height = 32
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alBottom
      Alignment = taCenter
      Caption = 
        '(Note that best results are when Cube 1 && Cube 2 are in about t' +
        'he same direction)'
      Color = clGray
      ParentColor = False
      WordWrap = True
    end
    object HelpBtn: TSpeedButton
      Left = 230
      Top = 370
      Width = 29
      Height = 28
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333333FFFFF3333333333F797F3333333333F737373FF333333BFB999BFB
        33333337737773773F3333BFBF797FBFB33333733337333373F33BFBFBFBFBFB
        FB3337F33333F33337F33FBFBFB9BFBFBF3337333337F333373FFBFBFBF97BFB
        FBF37F333337FF33337FBFBFBFB99FBFBFB37F3333377FF3337FFBFBFBFB99FB
        FBF37F33333377FF337FBFBF77BF799FBFB37F333FF3377F337FFBFB99FB799B
        FBF373F377F3377F33733FBF997F799FBF3337F377FFF77337F33BFBF99999FB
        FB33373F37777733373333BFBF999FBFB3333373FF77733F7333333BFBFBFBFB
        3333333773FFFF77333333333FBFBF3333333333377777333333}
      NumGlyphs = 2
      OnClick = HelpBtnClick
    end
    object ExitBtn: TSpeedButton
      Left = 270
      Top = 370
      Width = 29
      Height = 28
      Hint = 'Close Form'
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Glyph.Data = {
        DE010000424DDE01000000000000760000002800000024000000120000000100
        0400000000006801000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00388888888877
        F7F787F8888888888333333F00004444400888FFF444448888888888F333FF8F
        000033334D5007FFF4333388888888883338888F0000333345D50FFFF4333333
        338F888F3338F33F000033334D5D0FFFF43333333388788F3338F33F00003333
        45D50FEFE4333333338F878F3338F33F000033334D5D0FFFF43333333388788F
        3338F33F0000333345D50FEFE4333333338F878F3338F33F000033334D5D0FFF
        F43333333388788F3338F33F0000333345D50FEFE4333333338F878F3338F33F
        000033334D5D0EFEF43333333388788F3338F33F0000333345D50FEFE4333333
        338F878F3338F33F000033334D5D0EFEF43333333388788F3338F33F00003333
        4444444444333333338F8F8FFFF8F33F00003333333333333333333333888888
        8888333F00003333330000003333333333333FFFFFF3333F00003333330AAAA0
        333333333333888888F3333F00003333330000003333333333338FFFF8F3333F
        0000}
      NumGlyphs = 2
      OnClick = ExitBtnClick
    end
    object CheckBox1: TCheckBox
      Left = 10
      Top = 50
      Width = 91
      Height = 21
      HelpContext = 8000
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Skeleton'
      TabOrder = 1
      OnClick = CheckBox1Click
    end
    object Button1: TButton
      Left = 10
      Top = 10
      Width = 281
      Height = 31
      Hint = 'open me'
      HelpContext = 8000
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Load Actor+Animations from a .QC File'
      TabOrder = 0
      OnClick = Button1Click
    end
    object cboAnimations: TComboBox
      Left = 9
      Top = 81
      Width = 282
      Height = 21
      HelpContext = 8000
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      TabOrder = 2
      Text = 'cboAnimations'
      OnChange = cboAnimationsChange
    end
    object TrackBar1: TTrackBar
      Left = 170
      Top = 140
      Width = 121
      Height = 21
      HelpContext = 8000
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Max = 20
      Min = -20
      Position = 10
      TabOrder = 3
      ThumbLength = 15
      OnChange = TrackBar1Change
    end
    object TrackBar2: TTrackBar
      Left = 170
      Top = 170
      Width = 121
      Height = 21
      HelpContext = 8000
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Max = 20
      Min = -20
      Position = 10
      TabOrder = 4
      ThumbLength = 15
      OnChange = TrackBar1Change
    end
    object TrackBar3: TTrackBar
      Left = 170
      Top = 200
      Width = 121
      Height = 21
      HelpContext = 8000
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Max = 20
      Min = -20
      Position = 10
      TabOrder = 5
      ThumbLength = 15
      OnChange = TrackBar1Change
    end
    object TrackBar4: TTrackBar
      Left = 170
      Top = 260
      Width = 121
      Height = 21
      HelpContext = 8000
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Max = 20
      Min = -20
      Position = 10
      TabOrder = 6
      ThumbLength = 15
      OnChange = TrackBar4Change
    end
    object TrackBar5: TTrackBar
      Left = 170
      Top = 290
      Width = 121
      Height = 21
      HelpContext = 8000
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Max = 20
      Min = -20
      Position = 10
      TabOrder = 7
      ThumbLength = 15
      OnChange = TrackBar4Change
    end
    object TrackBar6: TTrackBar
      Left = 170
      Top = 320
      Width = 121
      Height = 21
      HelpContext = 8000
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Max = 20
      Min = -20
      Position = 10
      TabOrder = 8
      ThumbLength = 15
      OnChange = TrackBar4Change
    end
    object Panel2: TPanel
      Left = 20
      Top = 170
      Width = 50
      Height = 50
      Hint = '(Also Try Pressing && moving mouse on panels)'
      HelpContext = 8000
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Color = 12615680
      TabOrder = 9
      OnMouseMove = Panel2MouseMove
    end
    object Panel3: TPanel
      Left = 80
      Top = 170
      Width = 50
      Height = 50
      HelpContext = 8000
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Color = 12615680
      TabOrder = 10
      OnMouseMove = Panel2MouseMove
    end
    object Panel4: TPanel
      Left = 20
      Top = 300
      Width = 50
      Height = 50
      HelpContext = 8000
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Color = 7039951
      TabOrder = 11
      OnMouseMove = Panel2MouseMove
    end
    object Panel5: TPanel
      Left = 80
      Top = 300
      Width = 50
      Height = 50
      HelpContext = 8000
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Color = 7039951
      TabOrder = 12
      OnMouseMove = Panel2MouseMove
    end
    object TrackBar7: TTrackBar
      Left = 140
      Top = 370
      Width = 71
      Height = 21
      HelpContext = 8000
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Max = 100
      Min = 1
      Position = 1
      TabOrder = 13
      ThumbLength = 15
    end
    object TrackBar8: TTrackBar
      Left = 140
      Top = 400
      Width = 71
      Height = 21
      HelpContext = 8000
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Max = 100
      Min = 1
      Position = 1
      TabOrder = 14
      ThumbLength = 15
    end
  end
  object GLScene1: TGLScene
    Left = 16
    Top = 8
    object GLLightSource1: TGLLightSource
      Ambient.Color = {0000803F0000803F0000803F0000803F}
      ConstAttenuation = 1.000000000000000000
      Position.Coordinates = {0000C8420000C8420000C8420000803F}
      LightStyle = lsOmni
      SpotCutOff = 180.000000000000000000
    end
    object Actor1: TGLActor
      Direction.Coordinates = {000000000000803F0000000000000000}
      Scale.Coordinates = {0000003F0000003F0000003F00000000}
      Up.Coordinates = {0000000000000080000080BF00000000}
      AnimationMode = aamLoop
      Interval = 100
      MaterialLibrary = GLMaterialLibrary1
    end
    object DummyCube1: TGLDummyCube
      CubeSize = 1.000000000000000000
    end
    object XYZGrid1: TGLXYZGrid
      Position.Coordinates = {00000000000090C1000000000000803F}
      LineColor.Color = {1283803E1283003F1283003F0000803F}
      XSamplingScale.Min = -12.000000000000000000
      XSamplingScale.Max = 12.000000000000000000
      XSamplingScale.Step = 4.000000000000000000
      YSamplingScale.Step = 1.000000000000000000
      ZSamplingScale.Min = -20.000000000000000000
      ZSamplingScale.Max = 20.000000000000000000
      ZSamplingScale.Step = 4.000000000000000000
      Parts = [gpX, gpZ]
    end
    object Cube1: TGLCube
      Material.FrontProperties.Ambient.Color = {00000000000000000000803F0000803F}
      Position.Coordinates = {0000F04100000000000000000000803F}
    end
    object Cube2: TGLCube
      Material.FrontProperties.Ambient.Color = {1283003F00000000000000000000803F}
      Position.Coordinates = {0000F04100002041000000000000803F}
    end
    object GLCamera1: TGLCamera
      DepthOfView = 500.000000000000000000
      FocalLength = 50.000000000000000000
      TargetObject = DummyCube1
      Position.Coordinates = {000048420000A0410000A0400000803F}
      Direction.Coordinates = {00000000000000000000803F00000000}
      Left = 224
      Top = 160
    end
  end
  object GLMaterialLibrary1: TGLMaterialLibrary
    Left = 16
    Top = 40
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 56
    Top = 8
  end
  object GLCadencer1: TGLCadencer
    Scene = GLScene1
    OnProgress = GLCadencer1Progress
    Left = 56
    Top = 40
  end
  object OpenDialog1: TOpenDialog
    Filter = 'Decompiled MDL *.QC file|*.QC'
    Left = 96
    Top = 8
  end
end
