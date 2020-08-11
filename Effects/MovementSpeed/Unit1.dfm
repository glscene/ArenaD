object Form1: TForm1
  Left = 201
  Top = 106
  Caption = 'Vectorial flight model'
  ClientHeight = 543
  ClientWidth = 834
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object GLSceneViewer1: TGLSceneViewer
    Left = 0
    Top = 0
    Width = 834
    Height = 543
    Camera = GLCamera1
    Buffer.BackgroundColor = clBlack
    FieldOfView = 143.320144653320300000
    Align = alClient
    TabOrder = 0
  end
  object GLScene1: TGLScene
    Left = 8
    Top = 80
    object gloPlayer: TGLDummyCube
      CubeSize = 1.000000000000000000
      object GLCamera4: TGLCamera
        DepthOfView = 2000.000000000000000000
        FocalLength = 5.000000000000000000
        TargetObject = gloShip
        CameraStyle = csOrthogonal
        Position.Coordinates = {0000000000004041000000000000803F}
        Direction.Coordinates = {00000000000080BF0000000000000000}
        Up.Coordinates = {0000000000000000000080BF00000000}
      end
      object gloPlayerShip: TGLDummyCube
        CubeSize = 1.000000000000000000
        object GLCamera2: TGLCamera
          DepthOfView = 2000.000000000000000000
          FocalLength = 80.000000000000000000
          TargetObject = gloShip
          Position.Coordinates = {00000000000000400000A0C00000803F}
        end
        object gloShip: TGLTeapot
          Direction.Coordinates = {000080BF000000000000000000000000}
          Scale.Coordinates = {00000040000000400000004000000000}
          object GLCamera3: TGLCamera
            DepthOfView = 2000.000000000000000000
            FocalLength = 50.000000000000000000
            Direction.Coordinates = {0000803F000000000000000000000000}
          end
        end
      end
    end
    object GLSphere1: TGLSphere
      Position.Coordinates = {0000404100000000000000000000803F}
      Radius = 0.500000000000000000
    end
    object GLCube1: TGLCube
      Position.Coordinates = {000080C0000000000000A0400000803F}
      CubeSize = {0000803F0000803F00004040}
    end
    object GLLightSource1: TGLLightSource
      ConstAttenuation = 1.000000000000000000
      Position.Coordinates = {0000404000000000000000000000803F}
      SpotCutOff = 180.000000000000000000
    end
    object GLSphere2: TGLSphere
      Material.FrontProperties.Diffuse.Color = {0000803F0000803F0000803F0000803F}
      Material.Texture.TextureMode = tmModulate
      Material.Texture.TextureWrap = twNone
      Material.Texture.Disabled = False
      Position.Coordinates = {000020C1000000000000C0C00000803F}
      Radius = 3.000000000000000000
      EffectsData = {
        0458434F4C02010201060A54474C424669726546580201020012000000000200
        02000610474C4669726546584D616E6167657231}
      object GLSprite1: TGLSprite
        Material.FrontProperties.Ambient.Color = {0000803FF8FEFE3E000000000000803F}
        Material.FrontProperties.Diffuse.Color = {0000803FF8FEFE3E000000000000803F}
        Material.FrontProperties.Emission.Color = {9A99593F14AE073FCDCCCC3D0000803F}
        Material.FrontProperties.Shininess = 2
        Material.BlendingMode = bmTransparency
        Material.Texture.ImageAlpha = tiaAlphaFromIntensity
        Material.Texture.TextureMode = tmModulate
        Material.Texture.Disabled = False
        Width = 13.000000000000000000
        Height = 13.000000000000000000
        Rotation = 0.000000000000000000
      end
    end
    object gloHUDCube: TGLDummyCube
      CubeSize = 1.000000000000000000
      object gloTXTSpeed: TGLHUDText
        Position.Coordinates = {0000204100002041000000000000803F}
        BitmapFont = GLWindowsBitmapFont1
        Text = 'Current Speed : 0'
        Rotation = 0.000000000000000000
        ModulateColor.Color = {CDCC4C3FF8FEFE3EACC8483E0000803F}
      end
      object gloTXTfps: TGLHUDText
        Position.Coordinates = {000020410000C841000000000000803F}
        BitmapFont = GLWindowsBitmapFont1
        Text = 'FPS : ???'
        Rotation = 0.000000000000000000
        ModulateColor.Color = {14AE073F8FC2F53DD7A3F03E0000803F}
      end
      object gloTXTInstructions: TGLHUDText
        Position.Coordinates = {0000204100002042000000000000803F}
        BitmapFont = GLWindowsBitmapFont1
        Text = 
          'Use the arrows to turn and thrust the teapot; use F1, F2, F3, F4' +
          ' to change the view'
        Rotation = 0.000000000000000000
      end
    end
    object GLCamera1: TGLCamera
      DepthOfView = 3000.000000000000000000
      FocalLength = 90.000000000000000000
      TargetObject = gloPlayer
      Position.Coordinates = {0000404100004040000040410000803F}
    end
  end
  object GLCadencer1: TGLCadencer
    Scene = GLScene1
    OnProgress = GLCadencer1Progress
    Left = 8
    Top = 48
  end
  object GLWindowsBitmapFont1: TGLWindowsBitmapFont
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    Left = 40
    Top = 48
  end
  object GLFireFXManager1: TGLFireFXManager
    FireDir.Coordinates = {00000000000000000000000000000000}
    InitialDir.Coordinates = {00000000000000000000000000000000}
    Cadencer = GLCadencer1
    MaxParticles = 500
    FireDensity = 1.000000000000000000
    FireEvaporation = 0.860000014305114800
    FireCrown = 0.500000000000000000
    ParticleLife = 1
    FireBurst = 0.200000002980232200
    FireRadius = 2.299999952316284000
    Disabled = False
    Paused = False
    ParticleInterval = 0.000099999997473788
    UseInterval = False
    Left = 40
    Top = 80
  end
end
