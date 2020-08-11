object Form1: TForm1
  Left = 227
  Top = 185
  BorderWidth = 3
  Caption = 'Fire Demo'
  ClientHeight = 423
  ClientWidth = 613
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  WindowState = wsMaximized
  OnMouseWheel = FormMouseWheel
  PixelsPerInch = 96
  TextHeight = 13
  object GLSceneViewer1: TGLSceneViewer
    Left = 0
    Top = 0
    Width = 439
    Height = 423
    Camera = GLCamera1
    Buffer.BackgroundColor = clBlack
    FieldOfView = 153.398193359375000000
    PenAsTouch = False
    Align = alClient
    OnMouseDown = GLSceneViewer1MouseDown
    OnMouseMove = GLSceneViewer1MouseMove
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 439
    Top = 0
    Width = 174
    Height = 423
    Align = alRight
    Alignment = taRightJustify
    TabOrder = 1
    object Label1: TLabel
      Left = 11
      Top = 16
      Width = 52
      Height = 13
      Caption = 'FireDensity'
    end
    object Label2: TLabel
      Left = 11
      Top = 48
      Width = 41
      Height = 13
      Caption = 'FireBurst'
    end
    object Label3: TLabel
      Left = 11
      Top = 96
      Width = 47
      Height = 13
      Caption = 'FireCrown'
    end
    object Label4: TLabel
      Left = 11
      Top = 128
      Width = 74
      Height = 13
      Caption = 'FireEvaporation'
    end
    object Label6: TLabel
      Left = 11
      Top = 176
      Width = 72
      Height = 13
      Caption = 'Particule Count'
    end
    object Label7: TLabel
      Left = 11
      Top = 224
      Width = 61
      Height = 13
      Caption = 'Particule Life'
    end
    object Label5: TLabel
      Left = 11
      Top = 304
      Width = 85
      Height = 13
      Caption = 'Particule Intervale'
    end
    object Label8: TLabel
      Left = 11
      Top = 264
      Width = 46
      Height = 13
      Caption = 'Fire rayon'
    end
    object TrackBar1: TTrackBar
      Left = 96
      Top = 8
      Width = 73
      Height = 25
      TabOrder = 0
      OnChange = TrackBar1Change
    end
    object TrackBar2: TTrackBar
      Left = 96
      Top = 47
      Width = 73
      Height = 28
      TabOrder = 1
      OnChange = TrackBar2Change
    end
    object TrackBar3: TTrackBar
      Left = 96
      Top = 87
      Width = 73
      Height = 28
      TabOrder = 2
      OnChange = TrackBar3Change
    end
    object TrackBar4: TTrackBar
      Left = 96
      Top = 127
      Width = 74
      Height = 28
      TabOrder = 3
      OnChange = TrackBar4Change
    end
    object TrackBar6: TTrackBar
      Left = 96
      Top = 167
      Width = 73
      Height = 28
      TabOrder = 4
      OnChange = TrackBar6Change
    end
    object TrackBar7: TTrackBar
      Left = 96
      Top = 215
      Width = 73
      Height = 28
      TabOrder = 5
      OnChange = TrackBar7Change
    end
    object TrackBar8: TTrackBar
      Left = 96
      Top = 310
      Width = 73
      Height = 28
      Min = 1
      Position = 1
      TabOrder = 6
      OnChange = TrackBar8Change
    end
    object TrackBar5: TTrackBar
      Left = 96
      Top = 261
      Width = 73
      Height = 28
      Min = 1
      Position = 1
      TabOrder = 7
      OnChange = TrackBar5Change
    end
    object TrackBar9: TTrackBar
      Left = 48
      Top = 353
      Width = 88
      Height = 28
      Max = 20
      Min = -20
      TabOrder = 8
      OnChange = TrackBar9Change
    end
    object Button1: TButton
      Left = 104
      Top = 392
      Width = 67
      Height = 27
      Caption = 'Explosion II'
      TabOrder = 9
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 24
      Top = 391
      Width = 56
      Height = 27
      Caption = 'Explosion I '
      TabOrder = 10
      OnClick = Button2Click
    end
  end
  object GLScene1: TGLScene
    ObjectsSorting = osNone
    Left = 8
    Top = 8
    object Sphere1: TGLSphere
      Radius = 0.300000011920929000
      Slices = 6
      Stacks = 6
      EffectsData = {
        0458434F4C02010201060A54474C424669726546580201020012000000000200
        02000610474C4669726546584D616E6167657231}
      object GLLightSource2: TGLLightSource
        Ambient.Color = {0000803F0000803F0000803F0000803F}
        ConstAttenuation = 1.000000000000000000
        Diffuse.Color = {0000803F8180003F000000000000803F}
        Position.Coordinates = {000000000000003F000000000000803F}
        SpotCutOff = 180.000000000000000000
      end
    end
    object GLCamera1: TGLCamera
      DepthOfView = 100.000000000000000000
      FocalLength = 50.000000000000000000
      TargetObject = Sphere1
      Position.Coordinates = {00000041000000400000A0400000803F}
      Left = 152
      Top = 104
    end
  end
  object GLCadencer1: TGLCadencer
    Scene = GLScene1
    Left = 40
    Top = 8
  end
  object GLFireFXManager1: TGLFireFXManager
    FireDir.Coordinates = {000000000000803F0000000000000000}
    InitialDir.Coordinates = {00000000000000000000000000000000}
    Cadencer = GLCadencer1
    MaxParticles = 124
    ParticleSize = 0.699999988079071000
    FireDensity = 0.500000000000000000
    FireEvaporation = 0.860000014305114700
    FireBurst = 1.000000000000000000
    FireRadius = 0.500000000000000000
    Disabled = False
    Paused = False
    ParticleInterval = 0.009999999776482582
    UseInterval = True
    Left = 72
    Top = 8
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 8
    Top = 40
  end
  object Timer2: TTimer
    Interval = 100
    OnTimer = Timer1Timer
    Left = 8
    Top = 40
  end
end
