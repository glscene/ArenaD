object Form1: TForm1
  Left = 126
  Top = 93
  Align = alClient
  BorderStyle = bsNone
  Caption = 'Form1'
  ClientHeight = 400
  ClientWidth = 603
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object GLSceneViewer1: TGLSceneViewer
    Left = 0
    Top = 0
    Width = 603
    Height = 400
    Camera = GLCamera1
    Buffer.FogEnvironment.FogColor.Color = {0000803F0000803F0000803F0000803F}
    Buffer.FogEnvironment.FogStart = 200.000000000000000000
    Buffer.FogEnvironment.FogEnd = 650.000000000000000000
    Buffer.FogEnvironment.FogDistance = fdEyeRadial
    Buffer.BackgroundColor = clDefault
    Buffer.FogEnable = True
    Buffer.Lighting = False
    Buffer.AntiAliasing = aa2x
    PenAsTouch = False
    Align = alClient
    OnMouseDown = GLSceneViewer1MouseDown
    OnMouseMove = GLSceneViewer1MouseMove
    TabOrder = 0
  end
  object GLBitmapHDS1: TGLBitmapHDS
    MaxPoolSize = 0
    Left = 264
    Top = 88
  end
  object GLScene1: TGLScene
    ObjectsSorting = osNone
    Left = 56
    Top = 32
    object GLSkyDome1: TGLSkyDome
      Direction.Coordinates = {000000000000803F2EBD3BB300000000}
      Up.Coordinates = {000000002EBD3BB3000080BF00000000}
      Bands = <
        item
          StartAngle = -5.00000000000000000
          StartColor.Color = {0000803F0000803F0000803F0000803F}
          StopAngle = 25.00000000000000000
          Slices = 9
        end
        item
          StartAngle = 25.00000000000000000
          StopAngle = 90.00000000000000000
          StopColor.Color = {938C0C3E938C0C3E938E0E3F0000803F}
          Slices = 9
          Stacks = 4
        end>
      Stars = <>
      Options = [sdoTwinkle]
    end
    object GLTerrainRenderer1: TGLTerrainRenderer
      Direction.Coordinates = {000000000000803F0000000000000000}
      Scale.Coordinates = {00008040000080400000803E00000000}
      Up.Coordinates = {00000000000000000000803F00000000}
      Material.MaterialLibrary = GLMaterialLibrary1
      Material.LibMaterialName = 'ground'
      HeightDataSource = GLBitmapHDS1
      TileSize = 32
      TilesPerTexture = 1.00000000000000000
      QualityDistance = 150.00000000000000000
      CLODPrecision = 150
    end
    object GLDummyCube1: TGLDummyCube
      Position.Coordinates = {0000000000000041000000000000803F}
      CubeSize = 1.00000000000000000
      object GLCamera1: TGLCamera
        DepthOfView = 800.00000000000000000
        FocalLength = 50.00000000000000000
        TargetObject = FreeForm1
        Position.Coordinates = {00000000000020410000C8410000803F}
        Left = 264
        Top = 160
      end
      object GLFreeForm1: TGLFreeForm
        Scale.Coordinates = {9A99993ECDCC4C3E9A99993E00000000}
        Material.Texture.Disabled = False
        MaterialLibrary = GLMaterialLibrary1
        object GLDummyCube2: TGLDummyCube
          Position.Coordinates = {0000000000000000000004420000803F}
          CubeSize = 1.00000000000000000
          EffectsData = {
            0201060A54474C4246697265465802000610474C4669726546584D616E616765
            7231}
        end
      end
    end
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 56
    Top = 96
  end
  object GLCadencer1: TGLCadencer
    Scene = GLScene1
    OnProgress = GLCadencer1Progress
    Left = 144
    Top = 32
  end
  object GLMaterialLibrary1: TGLMaterialLibrary
    Materials = <
      item
        Name = 'ground'
        Tag = 0
        Material.FrontProperties.Ambient.Color = {0000000000000000000000000000803F}
        Material.FrontProperties.Diffuse.Color = {0000000000000000000000000000803F}
        Material.FrontProperties.Emission.Color = {9A99993E9A99993E9A99993E0000803F}
        Material.Texture.TextureMode = tmReplace
        Material.Texture.Compression = tcStandard
        Material.Texture.MappingTCoordinates.Coordinates = {000000000000803F0000000000000000}
        Material.Texture.Disabled = False
        Texture2Name = 'details'
      end
      item
        Name = 'details'
        Tag = 0
        Material.Texture.TextureMode = tmModulate
        Material.Texture.TextureFormat = tfLuminance
        Material.Texture.Compression = tcStandard
        Material.Texture.MappingTCoordinates.Coordinates = {000000000000803F0000000000000000}
        Material.Texture.Disabled = False
        TextureScale.Coordinates = {00000043000000430000004300000000}
      end>
    Left = 144
    Top = 96
  end
  object GLFireFXManager1: TGLFireFXManager
    FireDir.Coordinates = {00000000000000000000803F00000000}
    InitialDir.Coordinates = {00000000000000000000803F00000000}
    Cadencer = GLCadencer1
    InnerColor.Color = {0000803F0000003F000000000000803F}
    OuterColor.Color = {0000803F0000803E000000000000803F}
    FireDensity = 1.000000000000000000
    FireEvaporation = 0.860000014305114700
    ParticleLife = 1
    FireBurst = 4.000000000000000000
    FireRadius = 0.500000000000000000
    Disabled = False
    Paused = False
    ParticleInterval = 0.000099999997473788
    UseInterval = False
    Left = 264
    Top = 32
  end
end
