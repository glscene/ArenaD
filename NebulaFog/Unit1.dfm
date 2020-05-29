object Form1: TForm1
  Left = 201
  Top = 106
  Caption = 'Volumetric fog/nebula test'
  ClientHeight = 501
  ClientWidth = 767
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
  object GLSceneViewer: TGLSceneViewer
    Left = 0
    Top = 0
    Width = 767
    Height = 501
    Camera = gloCamera
    VSync = vsmSync
    Buffer.BackgroundColor = clBlack
    Buffer.FaceCulling = False
    FieldOfView = 128.807250976562500000
    Align = alClient
    TabOrder = 0
  end
  object GLScene: TGLScene
    VisibilityCulling = vcHierarchical
    Left = 8
    Top = 8
    object gloTeapot: TGLTeapot
      Material.FrontProperties.Diffuse.Color = {CDCC4C3FF8FEFE3EACC8483E0000803F}
      Scale.Coordinates = {00000041000000410000004100000000}
    end
    object gloLight: TGLLightSource
      ConstAttenuation = 1.000000000000000000
      Position.Coordinates = {000048420000F041000040410000803F}
      SpotCutOff = 180.000000000000000000
    end
    object gloFog: TGLDummyCube
      CubeSize = 1.000000000000000000
      object gloFogX1: TGLPlane
        Direction.Coordinates = {0000803F000000000000000000000000}
        Position.Coordinates = {0000A0C000000000000000000000803F}
        Up.Coordinates = {0000000000000000000080BF00000000}
        Height = 15.000000000000000000
        Width = 15.000000000000000000
      end
      object gloFogX2: TGLPlane
        Direction.Coordinates = {0000803F000000000000000000000000}
        Height = 15.000000000000000000
        Width = 15.000000000000000000
      end
      object gloFogX3: TGLPlane
        Direction.Coordinates = {0000803F000000000000000000000000}
        Position.Coordinates = {0000A04000000000000000000000803F}
        Height = 15.000000000000000000
        Width = 15.000000000000000000
      end
      object gloFogY1: TGLPlane
        Direction.Coordinates = {000000000000803F0000000000000000}
        Position.Coordinates = {000000000000A0C0000000000000803F}
        Up.Coordinates = {0000000000000000000080BF00000000}
        Height = 15.000000000000000000
        Width = 15.000000000000000000
      end
      object gloFogY2: TGLPlane
        Direction.Coordinates = {000000000000803F0000000000000000}
        Up.Coordinates = {0000000000000000000080BF00000000}
        Height = 15.000000000000000000
        Width = 15.000000000000000000
      end
      object gloFogY3: TGLPlane
        Direction.Coordinates = {000000000000803F0000000000000000}
        Position.Coordinates = {000000000000A040000000000000803F}
        Up.Coordinates = {0000000000000000000080BF00000000}
        Height = 15.000000000000000000
        Width = 15.000000000000000000
      end
      object gloFogZ1: TGLPlane
        Position.Coordinates = {00000000000000000000A0C00000803F}
        Height = 15.000000000000000000
        Width = 15.000000000000000000
      end
      object gloFogZ2: TGLPlane
        Height = 15.000000000000000000
        Width = 15.000000000000000000
      end
      object gloFogZ3: TGLPlane
        Position.Coordinates = {00000000000000000000A0400000803F}
        Height = 15.000000000000000000
        Width = 15.000000000000000000
      end
    end
    object gloCamera: TGLCamera
      DepthOfView = 100.000000000000000000
      FocalLength = 120.000000000000000000
      TargetObject = gloFog
      Position.Coordinates = {0000A0410000A041000048420000803F}
    end
  end
  object GLMaterialLibrary: TGLMaterialLibrary
    Left = 40
    Top = 8
  end
  object GLCadencer: TGLCadencer
    Scene = GLScene
    SleepLength = 1
    OnProgress = GLCadencerProgress
    Left = 8
    Top = 40
  end
end
