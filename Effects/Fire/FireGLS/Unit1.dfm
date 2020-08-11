object Form1: TForm1
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Fire Flows'
  ClientHeight = 525
  ClientWidth = 489
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object GLSceneViewer1: TGLSceneViewer
    Left = 0
    Top = 0
    Width = 489
    Height = 525
    Camera = GLCamera1
    Buffer.BackgroundColor = 4194304
    FieldOfView = 156.884857177734400000
    Align = alClient
    OnMouseDown = GLSceneViewer1MouseDown
    OnMouseMove = GLSceneViewer1MouseMove
    OnMouseUp = GLSceneViewer1MouseUp
    TabOrder = 0
  end
  object GLScene1: TGLScene
    Left = 192
    Top = 144
    object Lights: TGLDummyCube
      CubeSize = 1.000000000000000000
      object GLLightSource1: TGLLightSource
        ConstAttenuation = 0.009999999776482582
        Position.Coordinates = {00000000000000000000C8C20000803F}
        LightStyle = lsOmni
        SpotCutOff = 180.000000000000000000
      end
    end
    object GLDummyCube1: TGLDummyCube
      CubeSize = 1.000000000000000000
      object GLActor1: TGLActor
        Material.MaterialLibrary = GLMaterialLibrary1
        Material.LibMaterialName = 'LibMaterial'
        Direction.Coordinates = {0000000000000000000080BF00000000}
        Scale.Coordinates = {00002041000020410000204100000000}
        Hint = 'Plane.3DS'
        Interval = 100
      end
    end
    object GLCamera1: TGLCamera
      DepthOfView = 100.000000000000000000
      FocalLength = 50.000000000000000000
      TargetObject = GLDummyCube1
      Position.Coordinates = {00000000000000000000A0C00000803F}
    end
  end
  object GLCadencer1: TGLCadencer
    Scene = GLScene1
    OnProgress = GLCadencer1Progress
    Left = 192
    Top = 184
  end
  object AsyncTimer1: TGLAsyncTimer
    Enabled = True
    OnTimer = AsyncTimer1Timer
    ThreadPriority = tpNormal
    Left = 192
    Top = 224
  end
  object GLMaterialLibrary1: TGLMaterialLibrary
    Materials = <
      item
        Name = 'LibMaterial'
        Tag = 0
        Material.Texture.TextureMode = tmModulate
        Material.Texture.Compression = tcNone
        Material.Texture.Disabled = False
      end>
    Left = 192
    Top = 264
  end
end
