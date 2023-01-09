object Form1: TForm1
  Left = 226
  Top = 44
  Caption = 'Liquid Flow'
  ClientHeight = 538
  ClientWidth = 570
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  WindowState = wsMaximized
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object PaintBox1: TPaintBox
    Left = 240
    Top = 240
    Width = 105
    Height = 105
  end
  object GLSceneViewer1: TGLSceneViewer
    Left = 0
    Top = 0
    Width = 570
    Height = 538
    Camera = GLCamera1
    Buffer.BackgroundColor = 14342874
    FieldOfView = 169.380737304687500000
    PenAsTouch = False
    Align = alClient
    OnMouseDown = GLSceneViewer1MouseDown
    OnMouseMove = GLSceneViewer1MouseMove
    TabOrder = 0
  end
  object GLScene1: TGLScene
    Left = 8
    Top = 8
    object camera_cube: TGLDummyCube
      Position.Coordinates = {0000A0400000A041000020C10000803F}
      CubeSize = 1.000000000000000000
      object GLCamera1: TGLCamera
        DepthOfView = 500.000000000000000000
        FocalLength = 25.000000000000000000
        SceneScale = 2.000000000000000000
        TargetObject = camera_cube
        Position.Coordinates = {000048420000A0410000A0C10000803F}
        Direction.Coordinates = {00000000000000000000803F00000000}
        Left = 224
        Top = 160
      end
    end
    object GLLightSource1: TGLLightSource
      ConstAttenuation = 1.000000000000000000
      Position.Coordinates = {00000000000048420000A0410000803F}
      LightStyle = lsOmni
      SpotCutOff = 180.000000000000000000
    end
    object GLCube1: TGLCube
      Direction.Coordinates = {000000000000803F0000000000000000}
      Up.Coordinates = {00000000000000800000803F00000000}
      CubeSize = {0000A042000070420000803F}
    end
    object GLCube2: TGLCube
      Position.Coordinates = {0000000000002041000070C10000803F}
      Visible = False
      CubeSize = {000070410000A04000007041}
    end
    object block: TGLCube
      Position.Coordinates = {000000000000A041000000000000803F}
      CubeSize = {0000F041000080400000A041}
    end
    object GLCylinder1: TGLCylinder
      Direction.Coordinates = {000000000000803F0000000000000000}
      Position.Coordinates = {00000000000048420000F0C10000803F}
      Up.Coordinates = {00000000000000000000803F00000000}
      BottomRadius = 6.000000000000000000
      Height = 20.000000000000000000
      TopRadius = 6.000000000000000000
    end
  end
  object GLCadencer1: TGLCadencer
    Scene = GLScene1
    OnProgress = GLCadencer1Progress
    Left = 48
    Top = 8
  end
  object GLMaterialLibrary1: TGLMaterialLibrary
    Left = 88
    Top = 8
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 128
    Top = 8
  end
end
