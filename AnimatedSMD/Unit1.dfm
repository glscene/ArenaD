object Form1: TForm1
  Left = 204
  Top = 206
  Caption = 'GLFileSMD with right weight bones'
  ClientHeight = 366
  ClientWidth = 637
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object GLSceneViewer1: TGLSceneViewer
    Left = 0
    Top = 0
    Width = 637
    Height = 366
    Camera = GLCamera1
    Buffer.BackgroundColor = clMedGray
    FieldOfView = 149.436782836914100000
    PenAsTouch = False
    Align = alClient
    OnMouseDown = GLSceneViewer1MouseDown
    OnMouseMove = GLSceneViewer1MouseMove
    TabOrder = 0
  end
  object GLScene1: TGLScene
    Left = 91
    Top = 34
    object GLActor1: TGLActor
      Direction.Coordinates = {000000000000803F2EBD3BB300000000}
      PitchAngle = 90.000000000000000000
      Scale.Coordinates = {0000003F0000003F0000003F00000000}
      Up.Coordinates = {000000002EBD3BB3000080BF00000000}
      AnimationMode = aamLoop
      Interval = 100
      MaterialLibrary = GLMaterialLibrary1
    end
    object GLCamera1: TGLCamera
      DepthOfView = 100.000000000000000000
      FocalLength = 50.000000000000000000
      TargetObject = GLActor1
      CameraStyle = csInfinitePerspective
      Position.Coordinates = {0000C8420000C8420000C8420000803F}
      object GLLightSource1: TGLLightSource
        ConstAttenuation = 1.000000000000000000
        SpotCutOff = 180.000000000000000000
      end
    end
  end
  object GLMaterialLibrary1: TGLMaterialLibrary
    Left = 91
    Top = 66
  end
  object GLCadencer1: TGLCadencer
    Scene = GLScene1
    MaxDeltaTime = 0.020000000000000000
    Left = 124
    Top = 35
  end
end
