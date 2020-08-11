object Form1: TForm1
  Left = 192
  Top = 124
  Caption = 'Bubbles'
  ClientHeight = 595
  ClientWidth = 992
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
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object vp: TGLSceneViewer
    Left = 0
    Top = 0
    Width = 992
    Height = 595
    Camera = cam
    Buffer.BackgroundColor = 8541952
    Buffer.ContextOptions = [roDoubleBuffer, roRenderToWindow]
    Buffer.DepthTest = False
    FieldOfView = 151.701049804687500000
    Align = alClient
    TabOrder = 0
  end
  object GLScene1: TGLScene
    Left = 16
    Top = 8
    object dc_cam: TGLDummyCube
      CubeSize = 1.000000000000000000
      object cam: TGLCamera
        DepthOfView = 100.000000000000000000
        FocalLength = 75.000000000000000000
        TargetObject = dc_cam
        Position.Coordinates = {0000000000000000000020410000803F}
      end
    end
    object dc_world: TGLDummyCube
      CubeSize = 1.000000000000000000
    end
  end
  object cad: TGLCadencer
    Scene = GLScene1
    Enabled = False
    Mode = cmApplicationIdle
    OnProgress = cadProgress
    Left = 72
    Top = 8
  end
  object AsyncTimer1: TGLAsyncTimer
    Enabled = True
    Interval = 800
    OnTimer = AsyncTimer1Timer
    Left = 48
    Top = 64
  end
end
