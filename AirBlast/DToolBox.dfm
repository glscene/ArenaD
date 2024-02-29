object DMToolBox: TDMToolBox
  Height = 188
  Width = 269
  PixelsPerInch = 120
  object GLScene: TGLScene
    Left = 30
    Top = 20
    object FreeForm: TGLFreeForm
      Material.FrontProperties.Diffuse.Color = {0000803F0000803F0000803F0000803F}
      Direction.Coordinates = {000000000000803F0000000000000000}
      Up.Coordinates = {0000000000000000000080BF00000000}
      UseMeshMaterials = False
    end
    object GLCamera: TGLCamera
      DepthOfView = 100.000000000000000000
      FocalLength = 50.000000000000000000
      CameraStyle = csOrthogonal
    end
  end
  object MemoryViewer: TGLMemoryViewer
    Camera = GLCamera
    Buffer.BackgroundColor = clWhite
    Buffer.ContextOptions = [roDestinationAlpha]
    Buffer.Lighting = False
    Buffer.AntiAliasing = aa4x
    Buffer.ColorDepth = cd24bits
    Left = 140
    Top = 20
  end
end
