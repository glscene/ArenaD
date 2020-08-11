object DemoFrm: TDemoFrm
  Left = 195
  Top = 114
  Caption = 'Reflection Demo'
  ClientHeight = 383
  ClientWidth = 540
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnMouseWheel = FormMouseWheel
  PixelsPerInch = 96
  TextHeight = 13
  object Display: TGLSceneViewer
    Left = 0
    Top = 0
    Width = 540
    Height = 383
    Camera = Camera
    Buffer.ShadeModel = smSmooth
    FieldOfView = 150.733886718750000000
    PenAsTouch = False
    Align = alClient
    OnMouseMove = DisplayMouseMove
    TabOrder = 0
  end
  object DemoScene: TGLScene
    Left = 32
    Top = 8
    object SkyBox: TGLSkyBox
      Direction.Coordinates = {00000000000080BF0000000000000000}
      Up.Coordinates = {00000000000000000000803F00000000}
      CloudsPlaneOffset = 0.200000002980232200
      CloudsPlaneSize = 32.000000000000000000
    end
    object plane: TGLPlane
      Material.FrontProperties.Diffuse.Color = {0000803F0000803F0000803F0000803F}
      Position.Coordinates = {00000000000000000AD7A3BE0000803F}
      Height = 10.000000000000000000
      Width = 10.000000000000000000
    end
    object Camera: TGLCamera
      DepthOfView = 100.000000000000000000
      FocalLength = 50.000000000000000000
      Position.Coordinates = {0000C03F0000C03F0000003F0000803F}
      Direction.Coordinates = {000000000000803F0000008000000000}
      Up.Coordinates = {00000000000000000000803F00000000}
      object LightSource: TGLLightSource
        ConstAttenuation = 1.000000000000000000
        SpotCutOff = 180.000000000000000000
      end
    end
  end
  object MatLib: TGLMaterialLibrary
    Left = 96
    Top = 8
  end
  object CelShader: TGLCelShader
    CelShaderOptions = [csoOutlines, csoTextured]
    OutlineWidth = 1.000000000000000000
    Left = 248
    Top = 8
  end
  object PhongShader: TGLPhongShader
    Left = 168
    Top = 8
  end
  object Timer: TGLAsyncTimer
    Interval = 500
    OnTimer = TimerTimer
    ThreadPriority = tpNormal
    Left = 184
    Top = 80
  end
  object Cadencer: TGLCadencer
    Scene = DemoScene
    Enabled = False
    OnProgress = CadencerProgress
    Left = 32
    Top = 56
  end
  object MainMenu1: TMainMenu
    Left = 312
    Top = 48
    object miFPS: TMenuItem
      Caption = 'FPS'
    end
  end
end
