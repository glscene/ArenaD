object AaStereoForm: TAaStereoForm
  Left = 219
  Top = 12
  Caption = 'GLS Stereo'
  ClientHeight = 507
  ClientWidth = 504
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010001002020100000000000E80200001600000028000000200000004000
    0000010004000000000080020000000000000000000000000000000000000000
    000000008000008000000080800080000000800080008080000080808000C0C0
    C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    00000000CCCCCCCC0000000000000000000000CC99999999CC00000000000000
    0000CC999C99CC9999CC000000000000000C99C9C99999CCCC99C00000000000
    00C9CC9999CC9C9999CC9C00000000000C99C99CC9CC9CCCC999C9C000000000
    C9CCC9CCC9CC9CCCCC9C999C0000000C9CCC9CCC9CCCC9CCCC9CCCC9C000000C
    9CCC9C99999999999CC9CCC9C00000C9CC9999CC9CCCC9CCC9999CCC9C0000C9
    99C9CCCC9CCCCC9CCCCC999C9C000CC9CCC9CCC9CCCCCC9CCCCC9CC99C000C9C
    CC9CCCC9CCCCCC9CCCCC9CCC99C00C9CCC9CC9999999999999CC9CCCC9C00C9C
    CC999CC9CCCCCC9CCC9999CCC9C00C9C999CCCC9CCCCCC9CCCCC9C99C9C00C99
    CC9CCCC9CCCCCC9CCCCC9CCC99C00C9CCC9CCCC9CCCCCC9CCCCC9CCCC9C00C9C
    CC9CCC99999999999CCC9CCCC9C00C9CCC9999C9CCCCCC9CC9999CCCC9C000C9
    C999CCC9CCCCCC9CCCC999CC9C0000C99CC9CCCC9CCCC9CCCCC9CC9C9C0000C9
    CCC9CCCC9CCCC9CCCCC9CCC99C00000C9CCC9CC99999999CCC9CCCC9C000000C
    9CCC999C99CC9CC9999CCCC9C0000000C9C9C9CCC9CC9CCCC999CC9C00000000
    0C99CC9CC9CC9CCC9CCC99C00000000000C9CC9CC9CC9CCC9CCC9C0000000000
    000C99C9CC99CCC9CC99C000000000000000CC999C99CC9C99CC000000000000
    000000CC99999999CC000000000000000000000CCCCCCCCC000000000000FFF0
    0FFFFFC003FFFF0000FFFE00007FFC00003FF800001FF000000FE0000007E000
    0007C0000003C000000380000003800000018000000180000001800000018000
    0001800000018000000180000001C0000003C0000003C0000003E0000007E000
    0007F000000FF800001FFC00003FFE00007FFF0000FFFFC003FFFFE00FFF}
  OldCreateOrder = False
  Position = poScreenCenter
  OnCanResize = FormCanResize
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  OnMouseWheel = FormMouseWheel
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object GLSceneViewer1: TGLSceneViewer
    Left = 0
    Top = 0
    Width = 504
    Height = 507
    Camera = GLCamera1
    BeforeRender = GLSceneViewer1BeforeRender
    Buffer.BackgroundColor = clBlack
    FieldOfView = 157.555084228515600000
    Align = alClient
    PopupMenu = PopupMenu1
    OnDblClick = GLSceneViewer1DblClick
    OnMouseDown = GLSceneViewer1MouseDown
    OnMouseMove = GLSceneViewer1MouseMove
    TabOrder = 0
  end
  object GLScene1: TGLScene
    ObjectsSorting = osNone
    Left = 8
    Top = 8
    object CameraTarget: TGLDummyCube
      CubeSize = 1.000000000000000000
    end
    object StereoScene: TGLDummyCube
      CubeSize = 1.000000000000000000
      object Setup: TGLDirectOpenGL
        UseBuildList = False
        OnRender = SetupRender
        Blend = False
      end
      object GLTeapot1: TGLTeapot
        Scale.Coordinates = {00002040000020400000204000000000}
        object GLSphere1: TGLSphere
          Position.Coordinates = {E926113F1D5AA43E000000000000803F}
          Radius = 0.123000003397464800
        end
      end
      object Cleanup: TGLDirectOpenGL
        UseBuildList = False
        OnRender = CleanupRender
        Blend = False
      end
    end
    object GLHUDSprite1: TGLHUDSprite
      Material.MaterialLibrary = GLMaterialLibrary1
      Material.LibMaterialName = 'Blending'
      Position.Coordinates = {0000004300000043000000000000803F}
      Visible = False
      Width = 256.000000000000000000
      Height = 256.000000000000000000
      Rotation = 0.000000000000000000
    end
    object GLCamera1: TGLCamera
      DepthOfView = 100.000000000000000000
      FocalLength = 50.000000000000000000
      TargetObject = CameraTarget
      Position.Coordinates = {000000000000803F0000A0400000803F}
      object LeftCamera: TGLCamera
        DepthOfView = 100.000000000000000000
        FocalLength = 50.000000000000000000
        TargetObject = CameraTarget
        Position.Coordinates = {000080BE00000000000000000000803F}
      end
      object RightCamera: TGLCamera
        DepthOfView = 100.000000000000000000
        FocalLength = 50.000000000000000000
        TargetObject = CameraTarget
        Position.Coordinates = {0000803E00000000000000000000803F}
      end
      object GLLightSource1: TGLLightSource
        ConstAttenuation = 1.000000000000000000
        SpotCutOff = 180.000000000000000000
      end
    end
  end
  object GLMemoryViewer1: TGLMemoryViewer
    Camera = GLCamera1
    Buffer.BackgroundColor = clBlack
    Left = 40
    Top = 8
  end
  object GLCadencer1: TGLCadencer
    Scene = GLScene1
    OnProgress = GLCadencer1Progress
    Left = 8
    Top = 40
  end
  object GLMaterialLibrary1: TGLMaterialLibrary
    Materials = <
      item
        Name = 'Left'
        Tag = 0
        Material.Texture.ImageClassName = 'TGLBlankImage'
        Material.Texture.Image.ColorFormat = 6408
        Material.Texture.MinFilter = miLinear
        Material.Texture.TextureWrap = twNone
        Material.Texture.Disabled = False
      end
      item
        Name = 'Right'
        Tag = 0
        Material.BlendingMode = bmAdditive
        Material.Texture.ImageClassName = 'TGLBlankImage'
        Material.Texture.Image.ColorFormat = 6408
        Material.Texture.MinFilter = miLinear
        Material.Texture.TextureWrap = twNone
        Material.Texture.Disabled = False
      end
      item
        Name = 'Blending'
        Tag = 0
        Shader = GLUserShader1
      end>
    Left = 40
    Top = 40
  end
  object GLUserShader1: TGLUserShader
    OnDoApply = GLUserShader1DoApply
    OnDoUnApply = GLUserShader1DoUnApply
    ShaderStyle = ssReplace
    Left = 168
    Top = 8
  end
  object AsyncTimer1: TGLAsyncTimer
    Enabled = True
    OnTimer = AsyncTimer1Timer
    ThreadPriority = tpNormal
    Left = 72
    Top = 40
  end
  object PopupMenu1: TPopupMenu
    Left = 296
    Top = 8
    object Rotate1: TMenuItem
      Caption = 'Rotate'
      Checked = True
      OnClick = Rotate1Click
    end
    object VSync1: TMenuItem
      Caption = 'V Sync'
      OnClick = VSync1Click
    end
    object Colors1: TMenuItem
      Caption = 'Colors'
      object RedBlueColor: TMenuItem
        Tag = 11
        Caption = 'Red/Blue'
        Checked = True
        GroupIndex = 1
        RadioItem = True
        OnClick = RedBlueColorClick
      end
      object BLueRed1: TMenuItem
        Tag = 12
        Caption = 'BLue/Red'
        GroupIndex = 1
        RadioItem = True
        OnClick = RedBlueColorClick
      end
      object GreenBlue1: TMenuItem
        Tag = 13
        Caption = 'Green/Blue'
        GroupIndex = 1
        RadioItem = True
        OnClick = RedBlueColorClick
      end
      object BlueGreen1: TMenuItem
        Tag = 14
        Caption = 'Blue/Green'
        GroupIndex = 1
        RadioItem = True
        OnClick = RedBlueColorClick
      end
    end
    object StereoView1: TMenuItem
      Caption = 'Stereo View'
      object NotStereo1: TMenuItem
        Caption = 'Not Stereo'
        GroupIndex = 2
        RadioItem = True
        OnClick = NotStereo1Click
      end
      object Blurred1: TMenuItem
        Tag = 1
        Caption = 'Blurred'
        GroupIndex = 2
        RadioItem = True
        OnClick = NotStereo1Click
      end
      object GlyphMenu: TMenuItem
        Tag = 2
        Caption = 'Glyph'
        Checked = True
        GroupIndex = 2
        RadioItem = True
        OnClick = NotStereo1Click
      end
      object Pinout1: TMenuItem
        Tag = 3
        Caption = 'Pin-out'
        GroupIndex = 2
        RadioItem = True
        OnClick = NotStereo1Click
      end
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object About1: TMenuItem
      Caption = 'About...'
      OnClick = About1Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Exit1: TMenuItem
      Caption = 'Exit'
      OnClick = Exit1Click
    end
  end
end
