object Form1: TForm1
  Left = 192
  Top = 124
  Caption = 'Form1'
  ClientHeight = 379
  ClientWidth = 630
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
    Width = 630
    Height = 379
    Camera = cam
    Buffer.BackgroundColor = 3487029
    Buffer.AmbientColor.Color = {0000003F0000003F0000003F0000803F}
    Buffer.ContextOptions = [roDoubleBuffer, roRenderToWindow, roNoColorBufferClear]
    FieldOfView = 129.190734863281300000
    PenAsTouch = False
    Align = alClient
    OnMouseDown = vpMouseDown
    TabOrder = 0
  end
  object GLScene1: TGLScene
    Left = 8
    Top = 8
    object back: TGLHUDSprite
      Material.Texture.Image.Picture.Data = {
        07544269746D6170B6010000424DB60100000000000036000000280000000400
        000020000000010018000000000080010000415C0000415C0000000000000000
        0000666666666666666666666666656565656565656565656565646464646464
        6464646464646363636363636363636363636262626262626262626262626060
        606060606060606060605F5F5F5F5F5F5F5F5F5F5F5F5E5E5E5E5E5E5E5E5E5E
        5E5E5C5C5C5C5C5C5C5C5C5C5C5C5B5B5B5B5B5B5B5B5B5B5B5B5A5A5A5A5A5A
        5A5A5A5A5A5A5858585858585858585858585757575757575757575757575555
        5555555555555555555554545454545454545454545452525252525252525252
        52525151515151515151515151515050505050505050505050504E4E4E4E4E4E
        4E4E4E4E4E4E4D4D4D4D4D4D4D4D4D4D4D4D4B4B4B4B4B4B4B4B4B4B4B4B4A4A
        4A4A4A4A4A4A4A4A4A4A49494949494949494949494947474747474747474747
        4747464646464646464646464646454545454545454545454545434343434343
        4343434343434242424242424242424242424141414141414141414141414040
        404040404040404040403F3F3F3F3F3F3F3F3F3F3F3F3E3E3E3E3E3E3E3E3E3E
        3E3E}
      Material.Texture.TextureWrap = twNone
      Material.Texture.Disabled = False
      Rotation = 0.000000000000000000
    end
    object dc_cam: TGLDummyCube
      CubeSize = 1.000000000000000000
      BehavioursData = {
        0458434F4C02010201060F54474C424650534D6F76656D656E74020012000000
        000200020002000F0000204108080615474C4650534D6F76656D656E744D616E
        6167657231}
      object cam: TGLCamera
        DepthOfView = 5000.000000000000000000
        FocalLength = 90.000000000000000000
        Position.Coordinates = {000000000000A041000000000000803F}
      end
    end
    object dc_world: TGLDummyCube
      Direction.Coordinates = {000080BF00000000E2CD0C3400000000}
      TurnAngle = -90.000000000000000000
      CubeSize = 1.000000000000000000
      object ff_scn: TGLFreeForm
        Direction.Coordinates = {000000000000803F0000000000000000}
        Up.Coordinates = {0000000000000000000080BF00000000}
        MaterialLibrary = MatLib
      end
      object ff_mask: TGLFreeForm
        Direction.Coordinates = {000000000000803F0000000000000000}
        Up.Coordinates = {0000000000000000000080BF00000000}
        Visible = False
      end
      object ff_ani: TGLActor
        Direction.Coordinates = {000000000000803F0000000000000000}
        Up.Coordinates = {0000000000000000000080BF00000000}
        AnimationMode = aamLoop
        Interval = 40
        MaterialLibrary = MatLib
      end
      object light: TGLLightSource
        ConstAttenuation = 1.000000000000000000
        Diffuse.Color = {0000803F8FC2353FE3A51B3F0000803F}
        LinearAttenuation = 0.004000000189989805
        Position.Coordinates = {000000000080BB44000000000000803F}
        LightStyle = lsOmni
        SpotCutOff = 180.000000000000000000
      end
      object GLShadowPlane1: TGLShadowPlane
        Direction.Coordinates = {000000000000803F0000000000000000}
        Position.Coordinates = {0000FAC30000803F000000000000803F}
        Up.Coordinates = {0000000000000000000080BF00000000}
        Height = 2000.000000000000000000
        Width = 2000.000000000000000000
        ShadowingObject = ff_ani
        ShadowedLight = light
        ShadowColor.Color = {000000000000000000000000CDCCCC3E}
        ShadowOptions = [spoUseStencil, spoScissor, spoTransparent]
      end
      object dc_light: TGLDummyCube
        CubeSize = 1.000000000000000000
        object light01: TGLLightSource
          ConstAttenuation = 1.000000000000000000
          Diffuse.Color = {0000803F0000803E000000000000803F}
          LinearAttenuation = 0.003000000026077032
          SpotCutOff = 180.000000000000000000
        end
        object light02: TGLLightSource
          ConstAttenuation = 1.000000000000000000
          Diffuse.Color = {0000803F0000803E000000000000803F}
          LinearAttenuation = 0.003000000026077032
          SpotCutOff = 180.000000000000000000
        end
      end
    end
  end
  object MatLib: TGLMaterialLibrary
    Left = 80
    Top = 8
  end
  object Cadencer: TGLCadencer
    Scene = GLScene1
    Enabled = False
    OnProgress = CadencerProgress
    Left = 8
    Top = 72
  end
  object AsyncTimer1: TGLAsyncTimer
    Enabled = True
    Interval = 800
    OnTimer = AsyncTimer1Timer
    ThreadPriority = tpIdle
    Left = 256
    Top = 8
  end
  object GLFPSMovementManager1: TGLFPSMovementManager
    Navigator = GLNavigator1
    Scene = GLScene1
    DisplayTime = 2000
    MovementScale = 4.000000000000000000
    Left = 160
    Top = 64
    MapsData = {
      0458434F4C02010201061454474C4D6170436F6C6C656374696F6E4974656D02
      00120000000002000200060766665F6D61736B}
  end
  object GLNavigator1: TGLNavigator
    Left = 160
    Top = 8
  end
end
