object Main: TMain
  Left = 168
  Top = 111
  Margins.Left = 5
  Margins.Top = 5
  Margins.Right = 5
  Margins.Bottom = 5
  Caption = 'AirBlast'
  ClientHeight = 691
  ClientWidth = 1050
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -19
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnMouseWheel = FormMouseWheel
  OnPaint = FormPaint
  OnShow = FormShow
  PixelsPerInch = 168
  TextHeight = 24
  object IMLogo: TImage
    Left = 224
    Top = 280
    Width = 184
    Height = 184
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    AutoSize = True
  end
  object SceneViewer: TGLSceneViewer
    Left = 0
    Top = 0
    Width = 1050
    Height = 691
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Buffer.FogEnvironment.FogColor.Color = {AAF1523F91ED5C3F79E9663F0000803F}
    Buffer.FogEnvironment.FogStart = 65000.000000000000000000
    Buffer.FogEnvironment.FogEnd = 80000.000000000000000000
    Buffer.BackgroundColor = 15129810
    Buffer.FogEnable = True
    Buffer.DepthPrecision = dp24bits
    PenAsTouch = False
    Align = alClient
    Visible = False
    TabOrder = 0
  end
  object GLScene: TGLScene
    Left = 40
    Top = 16
    object SkyBox: TGLSkyBox
      Direction.Coordinates = {2CBD3BB3000080BF0000000000000000}
      TurnAngle = -90.000000000000000000
      Up.Coordinates = {0000000000000000FFFF7F3F00000000}
      MaterialLibrary = MLSkyBox
      MatNameTop = 'top'
      MatNameLeft = 'west'
      MatNameRight = 'east'
      MatNameFront = 'north'
      MatNameBack = 'south'
      CloudsPlaneOffset = 0.200000002980232200
      CloudsPlaneSize = 32.000000000000000000
      Style = sbsTopHalfClamped
    end
    object LSSun: TGLLightSource
      Ambient.Color = {3333B33E3333B33E3333B33E0000803F}
      ConstAttenuation = 1.000000000000000000
      Position.Coordinates = {00401CC60050C3450000AF450000803F}
      LightStyle = lsParallel
      Specular.Color = {0000803E0000803E0000803E0000803F}
      SpotCutOff = 180.000000000000000000
      SpotDirection.Coordinates = {000020C10000C8403333B34000000000}
    end
    object TerrainRenderer: TGLTerrainRenderer
      Material.MaterialLibrary = MaterialLibrary
      Material.LibMaterialName = 'Terrain'
      Position.Coordinates = {000048C7000048C7000000000000803F}
      Scale.Coordinates = {0000C8420000C8420000484200000000}
      HeightDataSource = HTF
      TileSize = 64
      TilesPerTexture = 16.000000000000000000
      QualityDistance = 5000.000000000000000000
      QualityStyle = hrsTesselated
      MaxCLODTriangles = 199999
      CLODPrecision = 5
      ContourWidth = 0
    end
    object DCRoot: TGLDummyCube
      CubeSize = 1.000000000000000000
    end
    object DCSortedRoot: TGLDummyCube
      ObjectsSorting = osRenderFarthestFirst
      CubeSize = 1.000000000000000000
    end
    object ParticleFXRenderer: TGLParticleFXRenderer
      BlendingMode = bmTransparency
    end
    object DCProxies: TGLDummyCube
      Visible = False
      CubeSize = 1.000000000000000000
    end
    object DCMenu: TGLDummyCube
      Visible = False
      CubeSize = 1.000000000000000000
      object GameMenu: TGLGameMenu
        Position.Coordinates = {00002F440000C043000000000000803F}
        MaterialLibrary = MaterialLibrary
        MenuScale = gms1024x768
        MarginHorz = 32
        MarginVert = 32
        Spacing = 20
        Font = WBFMenu
        TitleMaterialName = 'Title'
        TitleWidth = 512
        TitleHeight = 128
        BackColor.Color = {0000000000000000000000000000003F}
        OnSelectedChanged = GameMenuSelectedChanged
      end
      object GameOverMenu: TGLGameMenu
        Position.Coordinates = {000000440000C043000000000000803F}
        Visible = False
        MaterialLibrary = MaterialLibrary
        MenuScale = gms1024x768
        MarginHorz = 32
        MarginVert = 32
        Spacing = 4
        Font = WBFMenu
        TitleWidth = 600
        TitleHeight = 128
        BackColor.Color = {0000000000000000000000000000003F}
        DisabledColor.Color = {0000803F0000803FCDCCCC3D0000803F}
      end
      object AbortGameMenu: TGLGameMenu
        Position.Coordinates = {000000440000C043000000000000803F}
        Visible = False
        MaterialLibrary = MaterialLibrary
        MenuScale = gms1024x768
        MarginHorz = 32
        MarginVert = 32
        Spacing = 4
        Font = WBFMenu
        TitleMaterialName = 'Title'
        TitleWidth = 600
        TitleHeight = 128
        BackColor.Color = {0000000000000000000000000000003F}
        DisabledColor.Color = {0000803F0000803FCDCCCC3D0000803F}
        Items.Strings = (
          'Abort?'
          ''
          'Yes'
          'No')
      end
    end
    object HSCover: TGLHUDSprite
      Material.FrontProperties.Diffuse.Color = {0000803F0000803F0000803F0000803F}
      Material.BlendingMode = bmTransparency
      Material.MaterialOptions = [moNoLighting]
      Material.Texture.ImageClassName = 'TGLPicFileImage'
      Material.Texture.Image.PictureFileName = 'GLScene.bmp'
      Material.Texture.MinFilter = miLinear
      Material.Texture.TextureMode = tmModulate
      Material.Texture.TextureWrap = twNone
      Material.Texture.TextureFormat = tfRGB
      Material.Texture.MappingMode = tmmObjectLinear
      Material.Texture.MappingSCoordinates.Coordinates = {0AD7233C000000000000000000000000}
      Material.Texture.MappingTCoordinates.Coordinates = {000000000AD7233C0000000000000000}
      Material.Texture.Disabled = False
      Position.Coordinates = {0000964300001643000000000000803F}
      Width = 512.000000000000000000
      Height = 128.000000000000000000
      Rotation = 0.000000000000000000
    end
  end
  object MaterialLibrary: TGLMaterialLibrary
    Materials = <
      item
        Name = 'Terrain'
        Tag = 0
        Material.Texture.ImageClassName = 'TGLPicFileImage'
        Material.Texture.MinFilter = miLinearMipmapNearest
        Material.Texture.TextureFormat = tfRGB
        Material.Texture.FilteringQuality = tfAnisotropic
        Material.Texture.Disabled = False
        Texture2Name = 'Detail'
        Shader = GLTexCombineShader
      end
      item
        Name = 'Detail'
        Tag = 0
        Material.Texture.ImageClassName = 'TGLPicFileImage'
        Material.Texture.MinFilter = miLinearMipmapNearest
        Material.Texture.TextureMode = tmModulate
        Material.Texture.TextureFormat = tfLuminance
        Material.Texture.Compression = tcStandard
        Material.Texture.FilteringQuality = tfAnisotropic
        Material.Texture.Disabled = False
        TextureScale.Coordinates = {00002442000024420000803F00000000}
      end
      item
        Name = 'Detail2'
        Tag = 0
        Material.Texture.ImageClassName = 'TGLPicFileImage'
        Material.Texture.MinFilter = miLinearMipmapNearest
        Material.Texture.TextureMode = tmModulate
        Material.Texture.TextureFormat = tfLuminance
        Material.Texture.Compression = tcStandard
        Material.Texture.FilteringQuality = tfAnisotropic
        Material.Texture.MappingMode = tmmObjectLinear
        Material.Texture.MappingSCoordinates.Coordinates = {0000003F000000000000000000000000}
        Material.Texture.MappingTCoordinates.Coordinates = {000000000000003F0000000000000000}
        Material.Texture.Disabled = False
      end
      item
        Name = 'Title'
        Tag = 0
        Material.BlendingMode = bmAdditive
        Material.Texture.ImageAlpha = tiaAlphaFromIntensity
        Material.Texture.MinFilter = miLinear
        Material.Texture.TextureMode = tmReplace
        Material.Texture.TextureWrap = twNone
        Material.Texture.Disabled = False
      end
      item
        Name = 'Victory'
        Tag = 0
        Material.BlendingMode = bmAdditive
        Material.Texture.ImageAlpha = tiaAlphaFromIntensity
        Material.Texture.MinFilter = miLinear
        Material.Texture.TextureMode = tmReplace
        Material.Texture.TextureWrap = twNone
        Material.Texture.Disabled = False
      end
      item
        Name = 'Defeat'
        Tag = 0
        Material.BlendingMode = bmAdditive
        Material.Texture.ImageAlpha = tiaAlphaFromIntensity
        Material.Texture.MinFilter = miLinear
        Material.Texture.TextureMode = tmReplace
        Material.Texture.TextureWrap = twNone
        Material.Texture.Disabled = False
      end>
    Left = 200
    Top = 128
  end
  object GLCadencer: TGLCadencer
    Scene = GLScene
    MaxDeltaTime = 0.500000000000000000
    OnProgress = GLCadencerProgress
    Left = 112
    Top = 16
  end
  object HTF: TGLHeightTileFileHDS
    MaxPoolSize = 0
    Left = 40
    Top = 72
  end
  object MLSkyBox: TGLMaterialLibrary
    Materials = <
      item
        Name = 'north'
        Tag = 0
        Material.FrontProperties.Diffuse.Color = {0000803F0000803F0000803F0000803F}
        Material.MaterialOptions = [moNoLighting]
        Material.Texture.ImageClassName = 'TGLPicFileImage'
        Material.Texture.MinFilter = miLinearMipmapNearest
        Material.Texture.TextureMode = tmReplace
        Material.Texture.TextureWrap = twNone
        Material.Texture.TextureFormat = tfRGB
        Material.Texture.Compression = tcNone
        Material.Texture.Disabled = False
      end
      item
        Name = 'east'
        Tag = 0
        Material.FrontProperties.Diffuse.Color = {0000803F0000803F0000803F0000803F}
        Material.MaterialOptions = [moNoLighting]
        Material.Texture.ImageClassName = 'TGLPicFileImage'
        Material.Texture.MinFilter = miLinearMipmapNearest
        Material.Texture.TextureMode = tmReplace
        Material.Texture.TextureWrap = twNone
        Material.Texture.TextureFormat = tfRGB
        Material.Texture.Compression = tcNone
        Material.Texture.Disabled = False
      end
      item
        Name = 'south'
        Tag = 0
        Material.FrontProperties.Diffuse.Color = {0000803F0000803F0000803F0000803F}
        Material.MaterialOptions = [moNoLighting]
        Material.Texture.ImageClassName = 'TGLPicFileImage'
        Material.Texture.MinFilter = miLinearMipmapNearest
        Material.Texture.TextureMode = tmReplace
        Material.Texture.TextureWrap = twNone
        Material.Texture.TextureFormat = tfRGB
        Material.Texture.Compression = tcNone
        Material.Texture.Disabled = False
      end
      item
        Name = 'west'
        Tag = 0
        Material.FrontProperties.Diffuse.Color = {0000803F0000803F0000803F0000803F}
        Material.MaterialOptions = [moNoLighting]
        Material.Texture.ImageClassName = 'TGLPicFileImage'
        Material.Texture.MinFilter = miLinearMipmapNearest
        Material.Texture.TextureMode = tmReplace
        Material.Texture.TextureWrap = twNone
        Material.Texture.TextureFormat = tfRGB
        Material.Texture.Compression = tcNone
        Material.Texture.Disabled = False
      end
      item
        Name = 'top'
        Tag = 0
        Material.FrontProperties.Diffuse.Color = {0000803F0000803F0000803F0000803F}
        Material.MaterialOptions = [moNoLighting]
        Material.Texture.ImageClassName = 'TGLPicFileImage'
        Material.Texture.MinFilter = miLinearMipmapNearest
        Material.Texture.TextureMode = tmReplace
        Material.Texture.TextureWrap = twNone
        Material.Texture.TextureFormat = tfRGB
        Material.Texture.Compression = tcNone
        Material.Texture.Disabled = False
      end>
    Left = 112
    Top = 72
  end
  object GLTexCombineShader: TGLTexCombineShader
    Combiners.Strings = (
      'Tex0:=Tex0'
      'Tex1:=Tex1*Tex0'
      'Tex2:=Tex1*Tex2')
    DesignTimeEnabled = False
    MaterialLibrary = MaterialLibrary
    LibMaterial3Name = 'Detail2'
    Left = 120
    Top = 256
  end
  object PFXSmoke: TGLPerlinPFXManager
    Cadencer = GLCadencer
    Renderer = ParticleFXRenderer
    Friction = 1.000000000000000000
    BlendingMode = bmTransparency
    Smoothness = 1.000000000000000000
    Brightness = 1.000000000000000000
    Gamma = 1.200000047683716000
    ParticleSize = 5.000000000000000000
    ColorInner.Color = {00000000000000000000000000000000}
    LifeColors = <
      item
        ColorInner.Color = {9A99993E9A99993E9A99993E0AD7233C}
        LifeTime = 0.300000011920929000
        SizeScale = 1.000000000000000000
      end
      item
        ColorInner.Color = {9A99993E9A99993E9A99993E0000003F}
        LifeTime = 1.399999976158142000
        SizeScale = 5.000000000000000000
      end
      item
        ColorInner.Color = {9A99993E9A99993E9A99993E00000000}
        LifeTime = 5.000000000000000000
        SizeScale = 16.000000000000000000
      end>
    Left = 40
    Top = 192
  end
  object PFXFire: TGLPerlinPFXManager
    Cadencer = GLCadencer
    Renderer = ParticleFXRenderer
    Friction = 1.000000000000000000
    ShareSprites = PFXSmoke
    Smoothness = 1.000000000000000000
    Brightness = 1.000000000000000000
    Gamma = 1.000000000000000000
    ParticleSize = 2.000000000000000000
    ColorInner.Color = {0000803F0000803F0000403F0000803F}
    LifeColors = <
      item
        ColorInner.Color = {0000803F0000803F000000000000803F}
        LifeTime = 0.250000000000000000
        SizeScale = 2.000000000000000000
      end
      item
        ColorInner.Color = {0000803F000000000000000000000000}
        LifeTime = 0.500000000000000000
        SizeScale = 5.000000000000000000
      end>
    Left = 200
    Top = 192
  end
  object GLSMFMOD: TGLSMFMOD
    MasterVolume = 1.000000000000000000
    Sources = <>
    Cadencer = GLCadencer
    RollOffFactor = 0.009999999776482582
    Left = 40
    Top = 128
    Doppler = 0.100000001490116100
  end
  object GLSoundLibrary: TGLSoundLibrary
    Samples = <>
    Left = 112
    Top = 128
  end
  object PFXDust: TGLCustomSpritePFXManager
    Cadencer = GLCadencer
    Renderer = ParticleFXRenderer
    Friction = 1.000000000000000000
    BlendingMode = bmTransparency
    ShareSprites = PFXSmoke
    SpritesPerTexture = sptFour
    ParticleSize = 10.000000000000000000
    ColorInner.Color = {9A99193F0000003FCDCCCC3E00000000}
    LifeColors = <
      item
        ColorInner.Color = {9A99193F0000003FCDCCCC3E0000803F}
        LifeTime = 0.500000000000000000
        SizeScale = 1.000000000000000000
      end
      item
        ColorInner.Color = {9A99193F0000003FCDCCCC3ECDCCCC3D}
        LifeTime = 4.000000000000000000
        SizeScale = 5.000000000000000000
      end>
    Left = 120
    Top = 192
  end
  object Timer: TTimer
    OnTimer = TimerTimer
    Left = 400
    Top = 16
  end
  object WBFMenu: TGLWindowsBitmapFont
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = 30
    Font.Name = 'Courier New'
    Font.Style = [fsBold]
    Left = 200
    Top = 72
  end
  object TIMenuVoiceDelay: TTimer
    Enabled = False
    Interval = 350
    OnTimer = TIMenuVoiceDelayTimer
    Left = 464
    Top = 16
  end
  object TISplash: TTimer
    Enabled = False
    Interval = 100
    OnTimer = TISplashTimer
    Left = 544
    Top = 16
  end
  object ApplicationFileIO: TGLApplicationFileIO
    Left = 238
    Top = 21
  end
end
