object FormLunation: TFormLunation
  Left = 193
  Top = 221
  Caption = 'SkyDome'
  ClientHeight = 449
  ClientWidth = 871
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poScreenCenter
  WindowState = wsMaximized
  OnCreate = FormCreate
  OnResize = FormResize
  TextHeight = 13
  object GLSceneViewer1: TGLSceneViewer
    Left = 0
    Top = 0
    Width = 871
    Height = 449
    Camera = GLCamera1
    Buffer.BackgroundColor = 3487029
    FieldOfView = 154.888351440429700000
    PenAsTouch = False
    Align = alClient
    TabOrder = 0
  end
  object GLScene1: TGLScene
    Left = 50
    Top = 10
    object GLSkyDome1: TGLSkyDome
      ObjectsSorting = osRenderBlendedLast
      Direction.Coordinates = {000000000000803F0000000000000000}
      Up.Coordinates = {0000000000000000000080BF00000000}
      Bands = <
        item
          StartColor.Color = {FBFAFA3E9796163FDEDD5D3F0000803F}
          StopAngle = 8.000000000000000000
          StopColor.Color = {4E62903EF4FDD43E17D94E3F0000803F}
          Slices = 32
          Stacks = 3
        end
        item
          StartAngle = 8.000000000000000000
          StartColor.Color = {9190903ED5D4D43ECFCE4E3F0000803F}
          StopAngle = 15.000000000000000000
          StopColor.Color = {39B4483EB072A83EBE9F3A3F0000803F}
          Slices = 32
          Stacks = 3
        end
        item
          StartAngle = 15.000000000000000000
          StartColor.Color = {C9C8483EA9A8A83EBBBA3A3F0000803F}
          StopAngle = 90.000000000000000000
          StopColor.Color = {D9D8D83DB9B8383ECBCACA3E0000803F}
          Slices = 32
        end>
      Stars = <>
    end
    object GLPlane1: TGLPlane
      Material.BlendingMode = bmTransparency
      Material.Texture.TextureMode = tmAdd
      Direction.Coordinates = {3ACD133F3ACD13BF3ACD133F00000000}
      Position.Coordinates = {00800EC400800E4400800EC40000803F}
      Up.Coordinates = {EC05D13EEC05513FEC05D13E00000000}
      Height = 200.000000000000000000
      Width = 200.000000000000000000
    end
    object dc_cam: TGLDummyCube
      Position.Coordinates = {000000000000803F000000000000803F}
      Visible = False
      CubeSize = 1.000000000000000000
      VisibleAtRunTime = True
      object GLCamera1: TGLCamera
        DepthOfView = 1000.000000000000000000
        FocalLength = 50.000000000000000000
        TargetObject = dc_cam
        Position.Coordinates = {00000000000000C00000A0400000803F}
      end
    end
  end
end
