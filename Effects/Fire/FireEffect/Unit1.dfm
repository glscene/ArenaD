object Form1: TForm1
  Left = 31
  Top = 86
  Caption = 'Fire Effect'
  ClientHeight = 441
  ClientWidth = 709
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  WindowState = wsMaximized
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object GLSceneViewer1: TGLSceneViewer
    Left = 0
    Top = 0
    Width = 709
    Height = 441
    Camera = GLCamera1
    Buffer.BackgroundColor = clBlack
    FieldOfView = 154.447631835937500000
    Align = alClient
    TabOrder = 0
  end
  object Button1: TButton
    Left = 8
    Top = 8
    Width = 85
    Height = 25
    Caption = 'On/Off'
    TabOrder = 1
    OnClick = Button1Click
  end
  object GLScene1: TGLScene
    Left = 32
    Top = 48
    object GLDummyCube1: TGLDummyCube
      CubeSize = 1.000000000000000000
      object GLSphere1: TGLSphere
        Material.FrontProperties.Ambient.Color = {0000803F0000803F0000803F0000803F}
        Material.FrontProperties.Diffuse.Color = {0000803F0000803F0000803F0000803F}
        Material.FrontProperties.Emission.Color = {0000803F0000803F000000000000803F}
        Position.Coordinates = {00000000000000000000C03F0000803F}
        Up.Coordinates = {000000000000803F0000008000000000}
        Radius = 0.100000001490116100
        Slices = 5
        Stacks = 5
        EffectsData = {
          0458434F4C02010201060A54474C424669726546580201020012000000000200
          02001200000000}
        object GLLightSource1: TGLLightSource
          Ambient.Color = {A69B043F00000000000000000000803F}
          ConstAttenuation = 1.000000000000000000
          Diffuse.Color = {0000803F0000803F1283003F0000803F}
          Shining = False
          SpotCutOff = 180.000000000000000000
          OnProgress = GLCadencer1Progress
        end
      end
    end
    object GLCylinder1: TGLCylinder
      BottomRadius = 0.500000000000000000
      Height = 1.000000000000000000
      TopRadius = 0.500000000000000000
    end
    object Sprites: TGLDummyCube
      CubeSize = 1.000000000000000000
      EffectsData = {
        0458434F4C02010201060A54474C424669726546580201020012000000000200
        02000610474C4669726546584D616E6167657231}
    end
    object GLCamera1: TGLCamera
      DepthOfView = 100.000000000000000000
      FocalLength = 50.000000000000000000
      Position.Coordinates = {8A89CF3F4E26763F2BD6D43F0000803F}
      Direction.Coordinates = {236422BF8A89FBBE66CC18BF00000000}
      Up.Coordinates = {0181B6BEB8F95E3FF119ADBE00000000}
    end
  end
  object GLMatLibrary: TGLMaterialLibrary
    Left = 32
    Top = 104
  end
  object GLCadencer1: TGLCadencer
    Scene = GLScene1
    Enabled = False
    OnProgress = GLCadencer1Progress
    Left = 32
    Top = 164
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 28
    Top = 220
  end
  object GLFireFXManager1: TGLFireFXManager
    Cadencer = GLCadencer1
    FireDensity = 1.000000000000000000
    FireEvaporation = 0.860000014305114800
    FireRadius = 1.000000000000000000
    Disabled = False
    Paused = False
    ParticleInterval = 0.100000001490116100
    UseInterval = True
    Left = 160
    Top = 48
  end
end
