object Form3: TForm3
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'Form3'
  ClientHeight = 418
  ClientWidth = 628
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  TextHeight = 13
  object GLSceneViewer1: TGLSceneViewer
    Left = 0
    Top = 0
    Width = 628
    Height = 418
    Camera = GLCamera1
    FieldOfView = 153.091491699218800000
    PenAsTouch = False
    Align = alClient
    PopupMenu = PopupMenu1
    TabOrder = 0
  end
  object GLScene1: TGLScene
    Left = 128
    Top = 72
    object GLDummyCube1: TGLDummyCube
      CubeSize = 1.000000000000000000
      object GLPlane1: TGLPlane
        Material.MaterialLibrary = GLMaterialLibrary1
        Material.LibMaterialName = 'caixa'
        Height = 1.000000000000000000
        Width = 1.000000000000000000
      end
      object GLPlane2: TGLPlane
        Material.MaterialLibrary = GLMaterialLibrary1
        Material.LibMaterialName = 'ponteiro'
        Direction.Coordinates = {0000000000000000FFFF7F3F00000000}
        Position.Coordinates = {00000000000000006F12833A0000803F}
        RollAngle = 90.000000000000000000
        Scale.Coordinates = {CDCCCC3ECDCC4C3FCDCCCC3E00000000}
        Up.Coordinates = {000080BF2EBD3BB30000000000000000}
        Height = 1.000000000000000000
        Width = 1.000000000000000000
      end
      object GLPlane3: TGLPlane
        Material.MaterialLibrary = GLMaterialLibrary1
        Material.LibMaterialName = 'ponteiro'
        Direction.Coordinates = {0000000000000000FFFF7F3F00000000}
        Position.Coordinates = {00000000000000006F12033B0000803F}
        RollAngle = 90.000000000000000000
        Scale.Coordinates = {CDCCCC3E9A99193FCDCCCC3E00000000}
        Up.Coordinates = {000080BF2EBD3BB30000000000000000}
        Height = 1.000000000000000000
        Width = 1.000000000000000000
      end
      object GLPlane4: TGLPlane
        Material.MaterialLibrary = GLMaterialLibrary1
        Material.LibMaterialName = 'ponteirofino'
        Direction.Coordinates = {0000000000000000FFFF7F3F00000000}
        Position.Coordinates = {0000000000000000A69B443B0000803F}
        RollAngle = 90.000000000000000000
        Scale.Coordinates = {CDCCCC3ECDCC4C3FCDCCCC3E00000000}
        Up.Coordinates = {000080BF2EBD3BB30000000000000000}
        Height = 1.000000000000000000
        Width = 1.000000000000000000
      end
    end
    object GLLightSource1: TGLLightSource
      ConstAttenuation = 1.000000000000000000
      SpotCutOff = 180.000000000000000000
    end
    object GLCamera1: TGLCamera
      DepthOfView = 100.000000000000000000
      FocalLength = 50.000000000000000000
      TargetObject = GLDummyCube1
      Position.Coordinates = {0000000000000000000000400000803F}
    end
  end
  object GLMaterialLibrary1: TGLMaterialLibrary
    Materials = <
      item
        Name = 'caixa'
        Tag = 0
        Material.BlendingMode = bmTransparency
        Material.MaterialOptions = [moNoLighting]
        Material.Texture.Disabled = False
      end
      item
        Name = 'ponteiro'
        Tag = 0
        Material.BlendingMode = bmTransparency
        Material.Texture.TextureMode = tmModulate
        Material.Texture.Disabled = False
      end
      item
        Name = 'ponteirofino'
        Tag = 0
        Material.BlendingMode = bmTransparency
        Material.MaterialOptions = [moNoLighting]
        Material.Texture.TextureMode = tmModulate
        Material.Texture.Disabled = False
      end>
    Left = 128
    Top = 32
  end
  object Timer1: TTimer
    Interval = 500
    Left = 40
    Top = 32
  end
  object PopupMenu1: TPopupMenu
    Left = 40
    Top = 80
    object Close1: TMenuItem
      Caption = 'Close'
    end
  end
end
