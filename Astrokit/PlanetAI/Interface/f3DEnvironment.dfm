object fm3DEnvironment: Tfm3DEnvironment
  Left = 4
  Top = 83
  Align = alClient
  BorderIcons = [biSystemMenu]
  Caption = 'Planet'
  ClientHeight = 676
  ClientWidth = 1008
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  WindowState = wsMaximized
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnMouseWheel = FormMouseWheel
  OnResize = FormResize
  OnShow = FormShow
  TextHeight = 13
  object Splitter3D: TSplitter
    Left = 0
    Top = 553
    Width = 1008
    Height = 2
    Cursor = crVSplit
    Align = alTop
    Beveled = True
  end
  object panMenus: TPanel
    Left = 0
    Top = 0
    Width = 1008
    Height = 553
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object panTools: TPanel
      Left = 0
      Top = 231
      Width = 1008
      Height = 322
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      object tbWater: TToolBar
        Left = 0
        Top = 56
        Width = 1008
        Height = 29
        ButtonWidth = 64
        EdgeBorders = [ebLeft, ebRight, ebBottom]
        Images = fmImages.imgIcons
        List = True
        ShowCaptions = True
        TabOrder = 0
        Visible = False
        object Label9: TLabel
          Left = 0
          Top = 0
          Width = 73
          Height = 22
          AutoSize = False
          Caption = 'Water: '
          Color = clInactiveBorder
          ParentColor = False
        end
        object tbWateringCan: TToolButton
          Left = 73
          Top = 0
          Hint = 'Watering Can (Adds Water)'
          Caption = 'Water'
          Down = True
          Grouped = True
          ImageIndex = 51
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbWateringCanClick
        end
        object tbSponge: TToolButton
          Left = 137
          Top = 0
          Hint = 'Sponge (Removes Water)'
          Caption = 'Sponge'
          Grouped = True
          ImageIndex = 52
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbSpongeClick
        end
        object tbSplash: TToolButton
          Left = 201
          Top = 0
          Hint = 'Splash'
          Caption = 'Splash'
          Grouped = True
          ImageIndex = 91
          Style = tbsCheck
          OnClick = tbSplashClick
        end
        object tbIceberg: TToolButton
          Left = 265
          Top = 0
          Caption = 'Iceberg'
          Grouped = True
          ImageIndex = 74
          Style = tbsCheck
          OnClick = tbIcebergClick
        end
        object ToolButton2: TToolButton
          Left = 329
          Top = 0
          Width = 8
          Caption = 'ToolButton2'
          ImageIndex = 9
          Style = tbsSeparator
        end
        object Panel4: TPanel
          Left = 337
          Top = 0
          Width = 97
          Height = 22
          BevelOuter = bvNone
          Caption = 'Pour Rate:'
          Color = clActiveBorder
          TabOrder = 2
        end
        object edWater: TEdit
          Left = 434
          Top = 0
          Width = 38
          Height = 22
          Hint = 'Amount of water that the watering can pours when you use it.'
          Enabled = False
          ParentShowHint = False
          ReadOnly = True
          ShowHint = True
          TabOrder = 0
          Text = '1'
        end
        object WaterUpDown: TUpDown
          Left = 472
          Top = 0
          Width = 17
          Height = 22
          Min = 1
          Position = 5
          TabOrder = 1
          OnClick = WaterUpDownClick
        end
        object WaterFastUpDown: TUpDown
          Left = 489
          Top = 0
          Width = 17
          Height = 22
          Min = 1
          Increment = 10
          Position = 5
          TabOrder = 3
          OnClick = WaterFastUpDownClick
        end
        object ToolButton3: TToolButton
          Left = 506
          Top = 0
          Width = 8
          Caption = 'ToolButton3'
          ImageIndex = 10
          Style = tbsSeparator
        end
      end
      object tbAtmosphere: TToolBar
        Left = 0
        Top = 85
        Width = 1008
        Height = 29
        ButtonWidth = 85
        Caption = 'tbAtmosphere'
        EdgeBorders = [ebLeft, ebRight, ebBottom]
        Images = fmImages.imgIcons
        List = True
        ShowCaptions = True
        TabOrder = 1
        Visible = False
        object Label4: TLabel
          Left = 0
          Top = 0
          Width = 73
          Height = 22
          AutoSize = False
          Caption = 'Atmosphere:'
          Color = clInactiveBorder
          ParentColor = False
        end
        object tbHeat: TToolButton
          Left = 73
          Top = 0
          Hint = 'Heat'
          Caption = 'Heat'
          Down = True
          Grouped = True
          ImageIndex = 77
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbHeatClick
        end
        object tbCold: TToolButton
          Left = 158
          Top = 0
          Hint = 'Cool'
          Caption = 'Cool'
          Grouped = True
          ImageIndex = 73
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbColdClick
        end
        object tbHumidifier: TToolButton
          Left = 243
          Top = 0
          Hint = 'Humidify'
          Caption = 'Humidify'
          Grouped = True
          ImageIndex = 83
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbHumidifierClick
        end
        object tbDehumidifier: TToolButton
          Left = 328
          Top = 0
          Hint = 'Dehumidify'
          Caption = 'Dehumidify  '
          Grouped = True
          ImageIndex = 82
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbDehumidifierClick
        end
        object tbCloud: TToolButton
          Left = 413
          Top = 0
          Hint = 'Cloud'
          Caption = 'Clouds'
          Grouped = True
          ImageIndex = 57
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbCloudClick
        end
        object tbRainCloud: TToolButton
          Left = 498
          Top = 0
          Hint = 'Cloud that is raining.'
          Caption = 'Rain Cloud'
          Grouped = True
          ImageIndex = 57
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbRainCloudClick
        end
        object tbStormCloud: TToolButton
          Left = 583
          Top = 0
          Hint = 'Cloud that shoots lightning.'
          Caption = 'Storm Cloud'
          Grouped = True
          ImageIndex = 153
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbStormCloudClick
        end
      end
      object tbGalaxy: TToolBar
        Left = 0
        Top = 27
        Width = 1008
        Height = 29
        ButtonWidth = 81
        Caption = 'tbGalaxy'
        EdgeBorders = [ebLeft, ebRight, ebBottom]
        Images = fmImages.imgIcons
        List = True
        ParentShowHint = False
        ShowCaptions = True
        ShowHint = False
        TabOrder = 2
        Visible = False
        object Label12: TLabel
          Left = 0
          Top = 0
          Width = 73
          Height = 22
          AutoSize = False
          Caption = 'Satellites: '
          Color = clInactiveBorder
          ParentColor = False
        end
        object tbBuildSun: TToolButton
          Left = 73
          Top = 0
          Hint = 'Sun'
          Caption = 'Sun'
          Grouped = True
          ImageIndex = 61
          ParentShowHint = False
          ShowHint = True
          OnClick = tbBuildSunClick
        end
        object tbBuildMoon: TToolButton
          Left = 154
          Top = 0
          Hint = 'Moon'
          Caption = 'Moon'
          ImageIndex = 62
          ParentShowHint = False
          ShowHint = True
          OnClick = tbBuildMoonClick
        end
        object ToolButton11: TToolButton
          Left = 235
          Top = 0
          Width = 8
          Caption = 'ToolButton11'
          ImageIndex = 60
          Style = tbsSeparator
        end
        object tbFakeSun: TToolButton
          Left = 243
          Top = 0
          Hint = 'Create a sun with only light, no heat.'
          Caption = 'Frozen Sun'
          ImageIndex = 58
          ParentShowHint = False
          ShowHint = True
          OnClick = tbFakeSunClick
        end
        object ToolButton10: TToolButton
          Left = 324
          Top = 0
          Width = 8
          Caption = 'ToolButton10'
          ImageIndex = 61
          Style = tbsSeparator
        end
        object tbAsteroid: TToolButton
          Left = 332
          Top = 0
          Hint = 'Asteroid'
          Caption = 'Asteroids'
          Grouped = True
          ImageIndex = 93
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbAsteroidClick
        end
        object tbMissileDefence: TToolButton
          Left = 413
          Top = 0
          Hint = 'Add a missile defence satellite.'
          Caption = 'Defence'
          Grouped = True
          ImageIndex = 150
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbMissileDefenceClick
        end
        object ToolButton4: TToolButton
          Left = 494
          Top = 0
          Width = 8
          Caption = 'ToolButton4'
          ImageIndex = 60
          Style = tbsSeparator
        end
      end
      object tbSettings: TToolBar
        Left = 0
        Top = 188
        Width = 1008
        Height = 25
        ButtonWidth = 78
        Caption = 'tbSettings'
        EdgeBorders = [ebLeft, ebRight, ebBottom]
        Images = fmImages.imgIcons
        List = True
        ShowCaptions = True
        TabOrder = 3
        Visible = False
        object Label18: TLabel
          Left = 0
          Top = 0
          Width = 73
          Height = 22
          AutoSize = False
          Caption = 'Utilities: '
          Color = clInactiveBorder
          ParentColor = False
        end
        object tbCameraLight: TToolButton
          Left = 73
          Top = 0
          Hint = 'Shine a Light From the Camera'
          Caption = 'Cam Light'
          Down = True
          ImageIndex = 39
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbCameraLightClick
        end
        object tbShowCursor: TToolButton
          Left = 151
          Top = 0
          Hint = 'Shows a cursor on the planet when you move the mouse.'
          Caption = 'Cursor   '
          Down = True
          ImageIndex = 74
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbShowCursorClick
        end
        object tbFlashlight: TToolButton
          Left = 229
          Top = 0
          Hint = 'Shines a light on the planet that you are looking at.'
          Caption = 'Flash Light'
          ImageIndex = 88
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbFlashlightClick
        end
        object tbStickyFit: TToolButton
          Left = 307
          Top = 0
          Hint = 
            'Sticky fit causes the Space window to stick in its designated de' +
            'sktop position.'
          Caption = 'Sticky Fit'
          Down = True
          ImageIndex = 90
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbStickyFitClick
        end
        object tbFullscreen: TToolButton
          Left = 385
          Top = 0
          Hint = 'Press ESC to exit fullscreen mode.'
          Caption = 'Fullscreen'
          ImageIndex = 89
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbFullscreenClick
        end
        object ToolButton6: TToolButton
          Left = 463
          Top = 0
          Width = 8
          Caption = 'ToolButton6'
          ImageIndex = 91
          Style = tbsSeparator
        end
        object tbSnapshot: TToolButton
          Left = 471
          Top = 0
          Hint = 'Take a photograph of your world.'
          Caption = 'Snapshot'
          ImageIndex = 5
          ParentShowHint = False
          ShowHint = True
          OnClick = tbSnapshotClick
        end
        object cbAutoSnap: TCheckBox
          Left = 549
          Top = 0
          Width = 70
          Height = 22
          Caption = 'AutoSnap'
          TabOrder = 0
          OnClick = cbAutoSnapClick
        end
        object ToolButton9: TToolButton
          Left = 619
          Top = 0
          Width = 8
          Caption = 'ToolButton9'
          ImageIndex = 6
          Style = tbsSeparator
        end
        object tbAVIMovie: TToolButton
          Left = 627
          Top = 0
          Hint = 
            'Start recording an AVI movie. When you close AIPlanet, the movie' +
            ' stops recording.'
          Caption = 'AVI Start'
          ImageIndex = 39
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbAVIMovieClick
        end
        object tbAVIDirect: TToolButton
          Left = 705
          Top = 0
          Hint = 'While this button is down, capture a frame.'
          Caption = 'AVI Direct'
          ImageIndex = 39
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          Visible = False
        end
        object tbAVIFrame: TToolButton
          Left = 783
          Top = 0
          Hint = 'Capture an extra AVI frame (for when time is stopped).'
          Caption = 'AVI Frame'
          ImageIndex = 34
          ParentShowHint = False
          ShowHint = True
          Visible = False
          OnClick = tbAVIFrameClick
        end
      end
      object tbTools: TToolBar
        Left = 0
        Top = 213
        Width = 1008
        Height = 28
        ButtonWidth = 81
        Caption = 'tbTools'
        EdgeBorders = [ebLeft, ebRight, ebBottom]
        Images = fmImages.imgIcons
        List = True
        ShowCaptions = True
        TabOrder = 4
        Visible = False
        object Label8: TLabel
          Left = 0
          Top = 0
          Width = 73
          Height = 22
          AutoSize = False
          Caption = 'Tools:'
          Color = clInactiveBorder
          ParentColor = False
        end
        object tbBall: TToolButton
          Left = 73
          Top = 0
          Caption = 'Ball'
          Down = True
          Grouped = True
          ImageIndex = 95
          Style = tbsCheck
          OnClick = tbBallClick
        end
        object tbBeaconBubble: TToolButton
          Left = 154
          Top = 0
          Hint = 'Bubble Beacon'
          Caption = 'Bubble'
          Grouped = True
          ImageIndex = 24
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbBeaconBubbleClick
        end
        object tbBeaconDrain: TToolButton
          Left = 235
          Top = 0
          Hint = 'Drain Beacon'
          Caption = 'Drain'
          Grouped = True
          ImageIndex = 23
          Style = tbsCheck
          OnClick = tbBeaconDrainClick
        end
        object tbBeaconApple: TToolButton
          Left = 316
          Top = 0
          Hint = 'Apple Beacon'
          Caption = 'ApplePop'
          Grouped = True
          ImageIndex = 9
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbBeaconAppleClick
        end
        object tbBeaconOrange: TToolButton
          Left = 397
          Top = 0
          Hint = 'Pop oranges'
          Caption = 'OrangePop'
          Grouped = True
          ImageIndex = 11
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbBeaconOrangeClick
        end
        object tbPopBeacon: TToolButton
          Left = 478
          Top = 0
          Hint = 'Pop any thing (use edit boxes for kind and rate)'
          Caption = 'AnyPop'
          Grouped = True
          ImageIndex = 147
          Style = tbsCheck
          OnClick = tbPopBeaconClick
        end
        object Label31: TLabel
          Left = 559
          Top = 0
          Width = 27
          Height = 22
          Caption = 'Kind='
        end
        object cboxThings: TComboBox
          Left = 586
          Top = 0
          Width = 121
          Height = 21
          Style = csDropDownList
          TabOrder = 0
          OnChange = cboxThingsChange
        end
        object Label33: TLabel
          Left = 707
          Top = 0
          Width = 29
          Height = 22
          Caption = 'Rate='
        end
        object imgDefaultTexture: TImage
          Left = 736
          Top = 0
          Width = 24
          Height = 22
          Picture.Data = {
            07544269746D617036050000424D360500000000000036040000280000001000
            0000100000000100080000000000000100000000000000000000000100000000
            000000000000000080000080000000808000800000008000800080800000C0C0
            C00099A8AC00D8E9EC000020400000206000002080000020A0000020C0000020
            E00000400000004020000040400000406000004080000040A0000040C0000040
            E00000600000006020000060400000606000006080000060A0000060C0000060
            E00000800000008020000080400000806000008080000080A0000080C0000080
            E00000A0000000A0200000A0400000A0600000A0800000A0A00000A0C00000A0
            E00000C0000000C0200000C0400000C0600000C0800000C0A00000C0C00000C0
            E00000E0000000E0200000E0400000E0600000E0800000E0A00000E0C00000E0
            E00040000000400020004000400040006000400080004000A0004000C0004000
            E00040200000402020004020400040206000402080004020A0004020C0004020
            E00040400000404020004040400040406000404080004040A0004040C0004040
            E00040600000406020004060400040606000406080004060A0004060C0004060
            E00040800000408020004080400040806000408080004080A0004080C0004080
            E00040A0000040A0200040A0400040A0600040A0800040A0A00040A0C00040A0
            E00040C0000040C0200040C0400040C0600040C0800040C0A00040C0C00040C0
            E00040E0000040E0200040E0400040E0600040E0800040E0A00040E0C00040E0
            E00080000000800020008000400080006000800080008000A0008000C0008000
            E00080200000802020008020400080206000802080008020A0008020C0008020
            E00080400000804020008040400080406000804080008040A0008040C0008040
            E00080600000806020008060400080606000806080008060A0008060C0008060
            E00080800000808020008080400080806000808080008080A0008080C0008080
            E00080A0000080A0200080A0400080A0600080A0800080A0A00080A0C00080A0
            E00080C0000080C0200080C0400080C0600080C0800080C0A00080C0C00080C0
            E00080E0000080E0200080E0400080E0600080E0800080E0A00080E0C00080E0
            E000C0000000C0002000C0004000C0006000C0008000C000A000C000C000C000
            E000C0200000C0202000C0204000C0206000C0208000C020A000C020C000C020
            E000C0400000C0402000C0404000C0406000C0408000C040A000C040C000C040
            E000C0600000C0602000C0604000C0606000C0608000C060A000C060C000C060
            E000C0800000C0802000C0804000C0806000C0808000C080A000C080C000C080
            E000C0A00000C0A02000C0A04000C0A06000C0A08000C0A0A000C0A0C000C0A0
            E000C0C00000C0C02000C0C04000C0C06000C0C08000C0C0A000F0FBFF00984E
            0000808080000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
            FF00E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1
            E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1D8D8D8D8D8D8E1E1D8D8D8E1E1
            E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1
            E1E1E1E1E1D8D8D8E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1
            E1E1E1E1E1E1E1E1E1E1E1E1D8D8D8E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1
            E1E1E1E1E1E1E1E1D8D8E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1D8D8D8E1E1E1E1
            E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1D8D8D8D8E1E1E1E1E1E1D8D8D8
            D8E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1
            E1E1}
          Visible = False
        end
      end
      object tbVisuals: TToolBar
        Left = 0
        Top = 141
        Width = 1008
        Height = 47
        ButtonWidth = 93
        Caption = 'tbSettings'
        EdgeBorders = [ebLeft, ebRight, ebBottom]
        Images = fmImages.imgIcons
        List = True
        ShowCaptions = True
        TabOrder = 5
        Visible = False
        object Label17: TLabel
          Left = 0
          Top = 0
          Width = 73
          Height = 22
          AutoSize = False
          Caption = 'Visuals: '
          Color = clInactiveBorder
          ParentColor = False
        end
        object tbShowSatellites: TToolButton
          Left = 73
          Top = 0
          Hint = 'Show Suns, Moons, and Asteroids'
          Caption = 'Satellites        '
          Down = True
          ImageIndex = 76
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbShowSatellitesClick
        end
        object tbShowClouds: TToolButton
          Left = 166
          Top = 0
          Hint = 'Shows clouds in the atmosphere.'
          Caption = 'Clouds'
          Down = True
          ImageIndex = 72
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbShowCloudsClick
        end
        object tbShowWater: TToolButton
          Left = 259
          Top = 0
          Hint = 'Show lakes, seas, and oceans.'
          Caption = 'Water'
          Down = True
          ImageIndex = 84
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbShowWaterClick
        end
        object tbShowStars: TToolButton
          Left = 352
          Top = 0
          Hint = 'Shows the starfield in the background.'
          Caption = 'Stars'
          Down = True
          ImageIndex = 91
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbShowStarsClick
        end
        object tbShowAtmosphere: TToolButton
          Left = 445
          Top = 0
          Hint = 'Show the atmosphere around your planet.'
          Caption = 'Atmosphere'
          Down = True
          ImageIndex = 85
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbShowAtmosphereClick
        end
        object tbHighDetail: TToolButton
          Left = 538
          Top = 0
          Hint = 'Use high detail models if available.'
          Caption = 'High Detail'
          ImageIndex = 91
          ParentShowHint = False
          Wrap = True
          ShowHint = True
          Style = tbsCheck
          OnClick = tbHighDetailClick
        end
        object Label25: TLabel
          Left = 0
          Top = 22
          Width = 72
          Height = 22
          AutoSize = False
          Caption = 'Graphics:'
          Color = clInactiveBorder
          ParentColor = False
        end
        object tbShadows: TToolButton
          Left = 72
          Top = 22
          Hint = 'Turn shadows on or off.'
          Caption = 'Shadows'
          ImageIndex = 97
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbShadowsClick
        end
        object tbComplexify: TToolButton
          Left = 165
          Top = 22
          Hint = 'Object shadows cast onto other objects.'
          Caption = 'Multicast'
          ImageIndex = 154
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbComplexifyClick
        end
        object tbVolumes: TToolButton
          Left = 258
          Top = 22
          Hint = 'Shows shadow volumes.'
          Caption = 'Volumes'
          ImageIndex = 88
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbVolumesClick
        end
        object tbSpeeches: TToolButton
          Left = 351
          Top = 22
          Hint = 'Show text speeches.'
          Caption = 'Speeches'
          Down = True
          ImageIndex = 56
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbSpeechesClick
        end
        object tbShowFire: TToolButton
          Left = 444
          Top = 22
          Hint = 
            'Prevents fire effects from being created by sun and explosions (' +
            'not undoable).'
          Caption = 'Fire Effects'
          Down = True
          ImageIndex = 7
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbShowFireClick
        end
        object tbSpherical: TToolButton
          Left = 537
          Top = 22
          Hint = 'Shape Land as Flat or Spherical'
          Caption = 'Spherical'
          Down = True
          ImageIndex = 86
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          Visible = False
          OnClick = tbSphericalClick
        end
      end
      object tbSpirits: TToolBar
        Left = 0
        Top = 241
        Width = 1008
        Height = 48
        ButtonWidth = 66
        Caption = 'tbFauna'
        EdgeBorders = [ebLeft, ebRight, ebBottom]
        Images = fmImages.imgIcons
        List = True
        ShowCaptions = True
        TabOrder = 6
        Visible = False
        object Label15: TLabel
          Left = 0
          Top = 0
          Width = 73
          Height = 22
          AutoSize = False
          Caption = 'New Bot: '
          Color = clInactiveBorder
          ParentColor = False
        end
        object tbSpiritGuy: TToolButton
          Left = 73
          Top = 0
          Hint = 'Bot'
          Caption = 'Bot'
          Down = True
          Grouped = True
          ImageIndex = 45
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbSpiritGuyClick
        end
        object tbBotSelect: TToolButton
          Left = 139
          Top = 0
          Caption = 'Select'
          Grouped = True
          ImageIndex = 122
          Style = tbsCheck
          OnClick = tbBotSelectClick
        end
        object Label5: TLabel
          Left = 205
          Top = 0
          Width = 36
          Height = 22
          Caption = 'Control:'
          Color = clInactiveBorder
          ParentColor = False
        end
        object tbControlBot: TToolButton
          Left = 241
          Top = 0
          Hint = 'Control Bot'
          Caption = 'Control'
          ImageIndex = 5
          ParentShowHint = False
          ShowHint = True
          OnClick = tbControlBotClick
        end
        object Label2: TLabel
          Left = 307
          Top = 0
          Width = 38
          Height = 22
          Caption = 'Actions:'
          Color = clInactiveBorder
          ParentColor = False
        end
        object tbGrab: TToolButton
          Left = 345
          Top = 0
          Caption = 'Grab'
          ImageIndex = 12
          OnClick = tbGrabClick
        end
        object tbDrop: TToolButton
          Left = 411
          Top = 0
          Caption = 'Drop'
          ImageIndex = 13
          OnClick = tbDropClick
        end
        object tbKick: TToolButton
          Left = 477
          Top = 0
          Caption = 'Kick'
          ImageIndex = 11
          OnClick = tbKickClick
        end
        object tbEat: TToolButton
          Left = 543
          Top = 0
          Caption = 'Eat'
          ImageIndex = 15
          Wrap = True
          OnClick = tbEatClick
        end
        object Label6: TLabel
          Left = 0
          Top = 22
          Width = 73
          Height = 22
          AutoSize = False
          Caption = 'Actions:'
          Color = clInactiveBorder
          ParentColor = False
        end
        object tbBonk: TToolButton
          Left = 73
          Top = 22
          Caption = 'Bonk'
          ImageIndex = 16
          OnClick = tbBonkClick
        end
        object tbGive: TToolButton
          Left = 139
          Top = 22
          Caption = 'Give'
          ImageIndex = 17
          OnClick = tbGiveClick
        end
        object tbThrow: TToolButton
          Left = 205
          Top = 22
          Caption = 'Throw'
          ImageIndex = 14
          OnClick = tbThrowClick
        end
        object Label3: TLabel
          Left = 271
          Top = 22
          Width = 22
          Height = 22
          Caption = 'Use:'
          Color = clInactiveBorder
          ParentColor = False
        end
        object tbUse1: TToolButton
          Left = 293
          Top = 22
          Caption = 'Use1 (/)'
          ImageIndex = 127
          OnClick = tbUse1Click
        end
        object tbUse2: TToolButton
          Left = 359
          Top = 22
          Caption = 'Use2'
          ImageIndex = 128
          OnClick = tbUse2Click
        end
        object tbUse3: TToolButton
          Left = 425
          Top = 22
          Caption = 'Use3'
          ImageIndex = 129
          OnClick = tbUse3Click
        end
        object tbUse4: TToolButton
          Left = 491
          Top = 22
          Caption = 'Use4'
          ImageIndex = 130
          OnClick = tbUse4Click
        end
        object tbUse5: TToolButton
          Left = 557
          Top = 22
          Caption = 'Use5'
          ImageIndex = 131
          OnClick = tbUse5Click
        end
      end
      object tbCameras: TToolBar
        Left = 0
        Top = 0
        Width = 1008
        Height = 27
        ButtonHeight = 7510
        ButtonWidth = 7794
        Caption = 'tbFauna'
        EdgeBorders = [ebLeft, ebRight, ebBottom]
        TabOrder = 7
        Visible = False
        object Label1: TLabel
          Left = 0
          Top = 0
          Width = 73
          Height = 7510
          AutoSize = False
          Caption = 'Find: '
          Color = clInactiveBorder
          ParentColor = False
        end
        object ToolButton14: TToolButton
          Left = 73
          Top = 0
          Hint = 'Planet (P)'
          Caption = 'ToolButton14'
          ImageIndex = 63
          ParentShowHint = False
          Wrap = True
          ShowHint = True
          OnClick = tbCameraPlanetClick
        end
        object tbTrackSpirit: TToolButton
          Left = 0
          Top = 7510
          Hint = 'Spirit (0)'
          Caption = 'tbTrackSpirit'
          ImageIndex = 45
          ParentShowHint = False
          Wrap = True
          ShowHint = True
          OnClick = tbTrackSpiritClick
        end
        object tbTrackBird: TToolButton
          Left = 0
          Top = 15020
          Hint = 'Bird (3)'
          Caption = 'tbBird'
          ImageIndex = 53
          ParentShowHint = False
          Wrap = True
          ShowHint = True
          OnClick = tbTrackBirdClick
        end
        object tbTrackFish: TToolButton
          Left = 0
          Top = 22530
          Hint = 'Fish (4)'
          Caption = 'tbTrackFish'
          ImageIndex = 94
          ParentShowHint = False
          Wrap = True
          ShowHint = True
          OnClick = tbTrackFishClick
        end
        object tbTrackDuck: TToolButton
          Left = 0
          Top = 30040
          Caption = 'tbTrackDuck'
          ImageIndex = 116
          Wrap = True
          OnClick = tbTrackDuckClick
        end
        object tbTrackTurtle: TToolButton
          Left = 0
          Top = 37550
          Hint = 'Turtle'
          Caption = 'tbTrackTurtle'
          Grouped = True
          ImageIndex = 108
          ParentShowHint = False
          Wrap = True
          ShowHint = True
          OnClick = tbTrackTurtleClick
        end
        object tbTrackLadybug: TToolButton
          Left = 0
          Top = 45060
          Hint = 'Ladybug'
          Caption = 'tbTrackLadybug'
          ImageIndex = 136
          ParentShowHint = False
          Wrap = True
          ShowHint = True
          OnClick = tbTrackLadybugClick
        end
        object tbTrackShark: TToolButton
          Left = 0
          Top = 52570
          Hint = 'Shark'
          Caption = 'tbTrackShark'
          ImageIndex = 107
          ParentShowHint = False
          Wrap = True
          ShowHint = True
          OnClick = tbTrackSharkClick
        end
        object tbTrackDolphin: TToolButton
          Left = 0
          Top = 60080
          Caption = 'tbTrackDolphin'
          ImageIndex = 119
          Wrap = True
          OnClick = tbTrackDolphinClick
        end
        object tbTrackHawk: TToolButton
          Left = 0
          Top = 67590
          Caption = 'tbTrackHawk'
          ImageIndex = 98
          Wrap = True
          OnClick = tbTrackHawkClick
        end
        object tbTrackCrab: TToolButton
          Left = 0
          Top = 75100
          Caption = 'tbTrackCrab'
          ImageIndex = 96
          Wrap = True
          OnClick = tbTrackCrabClick
        end
        object tbTrackAnt: TToolButton
          Left = 0
          Top = 82610
          Hint = 'Ant'
          Caption = 'tbTrackAnt'
          ImageIndex = 137
          ParentShowHint = False
          Wrap = True
          ShowHint = True
          OnClick = tbTrackAntClick
        end
        object tbTrackBall: TToolButton
          Left = 0
          Top = 90120
          Caption = 'tbTrackBall'
          ImageIndex = 95
          Wrap = True
          OnClick = tbTrackBallClick
        end
        object tbTrackSun: TToolButton
          Left = 0
          Top = 97630
          Hint = 'Sun (1)'
          Caption = 'tbAppleTree'
          ImageIndex = 58
          ParentShowHint = False
          Wrap = True
          ShowHint = True
          OnClick = tbTrackSunClick
        end
        object tbTrackMoon: TToolButton
          Left = 0
          Top = 105140
          Hint = 'Moon (2)'
          Caption = 'tbCrawlie'
          ImageIndex = 59
          ParentShowHint = False
          Wrap = True
          ShowHint = True
          OnClick = tbTrackMoonClick
        end
        object tbTrackApple: TToolButton
          Left = 0
          Top = 112650
          Hint = 'Apple Tree (5)'
          Caption = 'tbTrackApple'
          ImageIndex = 47
          ParentShowHint = False
          Wrap = True
          ShowHint = True
          OnClick = tbTrackAppleClick
        end
        object tbTrackOrange: TToolButton
          Left = 0
          Top = 120160
          Hint = 'Orange Tree (6)'
          Caption = 'tbTrackOrange'
          ImageIndex = 49
          ParentShowHint = False
          Wrap = True
          ShowHint = True
          OnClick = tbTrackOrangeClick
        end
        object tbTrackAsteroid: TToolButton
          Left = 0
          Top = 127670
          Hint = 'Asteroid (8)'
          Caption = 'tbTrackAsteroid'
          ImageIndex = 93
          ParentShowHint = False
          Wrap = True
          ShowHint = True
          OnClick = tbTrackAsteroidClick
        end
        object tbTrackCloud: TToolButton
          Left = 0
          Top = 135180
          Hint = 'Cloud (7)'
          Caption = 'tbTrackCloud'
          ImageIndex = 57
          ParentShowHint = False
          Wrap = True
          ShowHint = True
          OnClick = tbTrackCloudClick
        end
        object tbTrackRabbit: TToolButton
          Left = 0
          Top = 142690
          Hint = 'Rabbit'
          Caption = 'tbTrackRabbit'
          ImageIndex = 111
          ParentShowHint = False
          Wrap = True
          ShowHint = True
          OnClick = tbTrackRabbitClick
        end
        object tbTrackTrex: TToolButton
          Left = 0
          Top = 150200
          Caption = 'tbTrackTrex'
          ImageIndex = 100
          Wrap = True
          OnClick = tbTrackTrexClick
        end
        object tbTrackGrazer: TToolButton
          Left = 0
          Top = 157710
          Caption = 'tbTrackGrazer'
          ImageIndex = 101
          Wrap = True
          OnClick = tbTrackGrazerClick
        end
        object tbTrackTiger: TToolButton
          Left = 0
          Top = 165220
          Caption = 'tbTrackTiger'
          ImageIndex = 115
          Wrap = True
          OnClick = tbTrackTigerClick
        end
        object tbTrackTerrier: TToolButton
          Left = 0
          Top = 172730
          Hint = 'Terrier'
          Caption = 'tbTrackTerrier'
          ImageIndex = 110
          ParentShowHint = False
          Wrap = True
          ShowHint = True
          OnClick = tbTrackTerrierClick
        end
        object tbTrackFox: TToolButton
          Left = 0
          Top = 180240
          Hint = 'Fox'
          Caption = 'tbTrackFox'
          ImageIndex = 113
          ParentShowHint = False
          ShowHint = True
          OnClick = tbTrackFoxClick
        end
      end
      object tbAudio: TToolBar
        Left = 0
        Top = 114
        Width = 1008
        Height = 27
        ButtonWidth = 97
        Caption = 'tbSettings'
        EdgeBorders = [ebLeft, ebRight, ebBottom]
        Images = fmImages.imgIcons
        List = True
        ShowCaptions = True
        TabOrder = 8
        Visible = False
        object Label32: TLabel
          Left = 0
          Top = 0
          Width = 73
          Height = 22
          AutoSize = False
          Caption = 'Volume: '
          Color = clInactiveBorder
          ParentColor = False
        end
        object tbVolume: TTrackBar
          Left = 73
          Top = 0
          Width = 100
          Height = 22
          Position = 10
          TabOrder = 1
          OnChange = tbVolumeChange
        end
        object Label26: TLabel
          Left = 173
          Top = 0
          Width = 28
          Height = 22
          Caption = 'Trails:'
          Color = clInactiveBorder
          ParentColor = False
        end
        object tbTrackLines: TToolButton
          Left = 201
          Top = 0
          Caption = 'Tracking Trail'
          ImageIndex = 8
          Style = tbsCheck
          OnClick = tbTrackLinesClick
        end
        object tbPredictions: TToolButton
          Left = 298
          Top = 0
          Caption = 'Prediction Trail'
          ImageIndex = 27
          Style = tbsCheck
          OnClick = tbPredictionsClick
        end
        object cbTrackNewThings: TCheckBox
          Left = 395
          Top = 0
          Width = 112
          Height = 22
          Caption = 'Track New Things'
          TabOrder = 0
          OnClick = cbTrackNewThingsClick
        end
        object tbRestoreParent: TToolButton
          Left = 507
          Top = 0
          Hint = 'Restore the Time and Manager windows.'
          Caption = 'Restore'
          ImageIndex = 90
          ParentShowHint = False
          ShowHint = True
          OnClick = tbRestoreParentClick
        end
      end
      object tbDisasters: TToolBar
        Left = 0
        Top = 289
        Width = 1008
        Height = 29
        ButtonWidth = 97
        Caption = 'tbDisasters'
        EdgeBorders = [ebLeft, ebTop, ebRight, ebBottom]
        Images = fmImages.imgIcons
        List = True
        ShowCaptions = True
        TabOrder = 9
        Visible = False
        object Label34: TLabel
          Left = 0
          Top = 0
          Width = 73
          Height = 22
          AutoSize = False
          Caption = 'Disasters:'
          Color = clInactiveBorder
          ParentColor = False
        end
        object tbEarthquake: TToolButton
          Left = 73
          Top = 0
          Hint = 'Earthquake'
          Caption = 'Earthquake'
          ImageIndex = 2
          ParentShowHint = False
          ShowHint = True
          OnClick = tbEarthquakeClick
        end
        object ToolButton5: TToolButton
          Left = 170
          Top = 0
          Width = 8
          Caption = 'ToolButton5'
          ImageIndex = 42
          Style = tbsSeparator
        end
        object tbLightning: TToolButton
          Left = 178
          Top = 0
          Caption = 'Lightning'
          Grouped = True
          ImageIndex = 155
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbLightningClick
        end
        object tbPlantRemover: TToolButton
          Left = 275
          Top = 0
          Caption = 'Plant Remover'
          Grouped = True
          ImageIndex = 48
          Style = tbsCheck
          OnClick = tbPlantRemoverClick
        end
        object tbLifeKiller: TToolButton
          Left = 372
          Top = 0
          Caption = 'Life Killer'
          Grouped = True
          ImageIndex = 16
          Style = tbsCheck
          OnClick = tbLifeKillerClick
        end
        object tbThingCeaser: TToolButton
          Left = 469
          Top = 0
          Hint = 'Remove Things from Land'
          Caption = 'Trash'
          Grouped = True
          ImageIndex = 41
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbThingCeaserClick
        end
      end
    end
    object panMainMenu: TPanel
      Left = 0
      Top = 0
      Width = 1008
      Height = 39
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 1
      object tbPlanet: TToolBar
        Left = 0
        Top = 0
        Width = 1008
        Height = 39
        Align = alClient
        ButtonHeight = 36
        ButtonWidth = 52
        Color = clActiveBorder
        EdgeBorders = [ebLeft, ebTop, ebRight, ebBottom]
        Images = fmImages.imgIcons
        ParentColor = False
        ShowCaptions = True
        TabOrder = 0
        object tbObjectMenu: TToolButton
          Left = 0
          Top = 0
          Hint = 'Object Menu'
          Caption = 'Select'
          Grouped = True
          ImageIndex = 138
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbObjectMenuClick
        end
        object tbGalaxyMenu: TToolButton
          Left = 52
          Top = 0
          Hint = 'Satellites'
          Caption = 'Space'
          Grouped = True
          ImageIndex = 76
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbGalaxyMenuClick
        end
        object tbWaterMenu: TToolButton
          Left = 104
          Top = 0
          Hint = 'Water'
          Caption = 'Water'
          Grouped = True
          ImageIndex = 84
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbWaterMenuClick
        end
        object tbLandMenu: TToolButton
          Left = 156
          Top = 0
          Hint = 'Land'
          Caption = 'Land'
          Grouped = True
          ImageIndex = 78
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbLandMenuClick
        end
        object tbAtmosphereMenu: TToolButton
          Left = 208
          Top = 0
          Hint = 'Atmosphere'
          Caption = 'Air'
          Grouped = True
          ImageIndex = 85
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbAtmosphereMenuClick
        end
        object tbFaunaMenu: TToolButton
          Left = 260
          Top = 0
          Hint = 'Fauna'
          Caption = 'Plants'
          Grouped = True
          ImageIndex = 75
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbFaunaMenuClick
        end
        object tbCreaturesMenu: TToolButton
          Left = 312
          Top = 0
          Hint = 'Creatures'
          Caption = 'Creatures'
          Grouped = True
          ImageIndex = 109
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbCreaturesMenuClick
        end
        object tbSpiritsMenu: TToolButton
          Left = 364
          Top = 0
          Hint = 'Spirits'
          Caption = 'Bots'
          Grouped = True
          ImageIndex = 45
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbSpiritsMenuClick
        end
        object tbToolsMenu: TToolButton
          Left = 416
          Top = 0
          Hint = 'Tools'
          Caption = 'Tools'
          Grouped = True
          ImageIndex = 40
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbToolsMenuClick
        end
        object tbDisastersMenu: TToolButton
          Left = 468
          Top = 0
          Hint = 'Disasters'
          Caption = 'Disasters'
          Grouped = True
          ImageIndex = 153
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbDisastersMenuClick
        end
        object tbCameraMenu: TToolButton
          Left = 520
          Top = 0
          Hint = 'Find'
          Caption = 'Find'
          Grouped = True
          ImageIndex = 140
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbCameraMenuClick
        end
        object tbVisualsMenu: TToolButton
          Left = 572
          Top = 0
          Hint = 'Visuals'
          Caption = 'Visuals'
          Grouped = True
          ImageIndex = 20
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbVisualsMenuClick
        end
        object tbAudioMenu: TToolButton
          Left = 624
          Top = 0
          Hint = 'Audio and Details'
          Caption = 'Audio'
          Grouped = True
          ImageIndex = 43
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbAudioMenuClick
        end
        object tbSettingsMenu: TToolButton
          Left = 676
          Top = 0
          Hint = 'Settings'
          Caption = 'Settings'
          Grouped = True
          ImageIndex = 31
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbSettingsMenuClick
        end
        object ToolButton7: TToolButton
          Left = 728
          Top = 0
          Width = 8
          Caption = 'ToolButton7'
          ImageIndex = 40
          Style = tbsSeparator
        end
        object tbRepeat: TToolButton
          Left = 736
          Top = 0
          Hint = 'Tool Repeat'
          Caption = 'Repeat'
          Down = True
          ImageIndex = 142
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
        end
      end
    end
    object panSelect: TPanel
      Left = 0
      Top = 39
      Width = 1008
      Height = 48
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 2
      Visible = False
      object tbObjects: TToolBar
        Left = 176
        Top = 0
        Width = 832
        Height = 48
        Align = alClient
        ButtonWidth = 73
        EdgeBorders = [ebTop, ebRight, ebBottom]
        Images = fmImages.imgIcons
        List = True
        ShowCaptions = True
        TabOrder = 0
        object Label22: TLabel
          Left = 0
          Top = 0
          Width = 48
          Height = 22
          AutoSize = False
          Caption = 'View:'
          Color = clActiveBorder
          ParentColor = False
        end
        object tbMouseView: TToolButton
          Left = 48
          Top = 0
          Hint = 'Mouse View (Info appears under cursor)'
          Caption = 'Info'
          ImageIndex = 125
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbMouseViewClick
        end
        object tbTrackWindow: TToolButton
          Left = 121
          Top = 0
          Hint = 'View Selected Object (Double Click)'
          Caption = 'Details'
          ImageIndex = 123
          ParentShowHint = False
          ShowHint = True
          OnClick = tbTrackWindowClick
        end
        object Label23: TLabel
          Left = 194
          Top = 0
          Width = 50
          Height = 22
          AutoSize = False
          Caption = 'Change:'
          Color = clInactiveBorder
          ParentColor = False
        end
        object tbHeal: TToolButton
          Left = 244
          Top = 0
          Hint = 'Heal this object (256).'
          Caption = 'Heal'
          ImageIndex = 24
          ParentShowHint = False
          ShowHint = True
          OnClick = tbHealClick
        end
        object tbHarm: TToolButton
          Left = 317
          Top = 0
          Hint = 'Harm this object (-256).'
          Caption = 'Harm'
          ImageIndex = 23
          ParentShowHint = False
          ShowHint = True
          OnClick = tbHarmClick
        end
        object tbDie: TToolButton
          Left = 390
          Top = 0
          Hint = 'Kill this object, if it is living.'
          Caption = 'Die'
          ImageIndex = 41
          ParentShowHint = False
          ShowHint = True
          OnClick = tbDieClick
        end
        object tbCease: TToolButton
          Left = 463
          Top = 0
          Hint = 'Cease this objects existence.'
          Caption = 'Cease'
          ImageIndex = 16
          ParentShowHint = False
          ShowHint = True
          OnClick = tbCeaseClick
        end
        object tbExtinction: TToolButton
          Left = 536
          Top = 0
          Hint = 'Kill every kind of this object.'
          Caption = 'Extinction'
          ImageIndex = 42
          ParentShowHint = False
          ShowHint = True
          OnClick = tbExtinctionClick
        end
        object tbJump: TToolButton
          Left = 609
          Top = 0
          Caption = 'Jump'
          ImageIndex = 152
          Wrap = True
          OnClick = tbJumpClick
        end
        object Label30: TLabel
          Left = 0
          Top = 22
          Width = 48
          Height = 22
          AutoSize = False
          Caption = 'Report:'
          Color = clActiveBorder
          ParentColor = False
        end
        object tbReport: TToolButton
          Left = 48
          Top = 22
          Hint = 'Ask for report from current object.'
          Caption = 'Report'
          ImageIndex = 117
          ParentShowHint = False
          ShowHint = True
          OnClick = tbReportClick
        end
        object tbReportAll: TToolButton
          Left = 121
          Top = 22
          Hint = 'Ask for reports from all creatures.'
          Caption = 'Report All'
          ImageIndex = 118
          ParentShowHint = False
          ShowHint = True
          OnClick = tbReportAllClick
        end
        object Label20: TLabel
          Left = 194
          Top = 22
          Width = 50
          Height = 22
          AutoSize = False
          Caption = 'Actions:'
          Color = clInactiveBorder
          ParentColor = False
        end
        object tbPerform0: TToolButton
          Left = 244
          Top = 22
          Caption = 'Perform'
          ImageIndex = 126
          OnClick = tbPerform0Click
        end
        object tbPerform1: TToolButton
          Left = 317
          Top = 22
          Caption = 'Perform'
          ImageIndex = 127
          OnClick = tbPerform1Click
        end
        object tbPerform2: TToolButton
          Left = 390
          Top = 22
          Caption = 'Perform'
          ImageIndex = 128
          OnClick = tbPerform2Click
        end
        object tbPerform3: TToolButton
          Left = 463
          Top = 22
          Caption = 'Perform'
          ImageIndex = 129
          OnClick = tbPerform3Click
        end
        object tbPerform4: TToolButton
          Left = 536
          Top = 22
          Caption = 'Perform'
          ImageIndex = 130
          OnClick = tbPerform4Click
        end
        object tbPerform5: TToolButton
          Left = 609
          Top = 22
          Caption = 'Perform'
          ImageIndex = 131
          OnClick = tbPerform5Click
        end
      end
      object ToolBar1: TToolBar
        Left = 58
        Top = 0
        Width = 118
        Height = 48
        Align = alLeft
        ButtonHeight = 21
        ButtonWidth = 55
        Caption = 'ToolBar1'
        EdgeBorders = [ebLeft, ebTop, ebBottom]
        ShowCaptions = True
        TabOrder = 1
        Wrapable = False
        object tbSelect: TToolButton
          Left = 0
          Top = 0
          Hint = 'Use the mouse button to target an object.'
          Caption = '   Select   '
          Down = True
          Grouped = True
          ImageIndex = 122
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbSelectClick
        end
        object tbMove: TToolButton
          Left = 55
          Top = 0
          Hint = 'Use the mouse but to drag objects around.'
          Caption = 'Move'
          Grouped = True
          ImageIndex = 150
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbMoveClick
        end
      end
      object Panel5: TPanel
        Left = 0
        Top = 0
        Width = 58
        Height = 48
        Align = alLeft
        BevelOuter = bvNone
        Color = clInactiveBorder
        TabOrder = 2
        object Panel8: TPanel
          Left = 0
          Top = 0
          Width = 58
          Height = 21
          Align = alTop
          BevelOuter = bvNone
          Caption = 'Cursor:'
          Color = clInactiveBorder
          TabOrder = 0
        end
      end
    end
    object panCreatures: TPanel
      Left = 0
      Top = 183
      Width = 1008
      Height = 48
      Align = alTop
      TabOrder = 3
      Visible = False
      object Panel1: TPanel
        Left = 1
        Top = 1
        Width = 58
        Height = 46
        Align = alLeft
        BevelOuter = bvNone
        Color = clInactiveBorder
        TabOrder = 0
        object Panel3: TPanel
          Left = 0
          Top = 0
          Width = 58
          Height = 21
          Align = alTop
          BevelOuter = bvNone
          Caption = 'Creatures:'
          Color = clInactiveBorder
          TabOrder = 0
        end
      end
      object tbCreatures: TToolBar
        Left = 59
        Top = 1
        Width = 948
        Height = 46
        Align = alClient
        ButtonWidth = 68
        Caption = 'tbFauna'
        EdgeBorders = [ebRight, ebBottom]
        Images = fmImages.imgIcons
        List = True
        ShowCaptions = True
        TabOrder = 1
        object tbBird: TToolButton
          Left = 0
          Top = 0
          Hint = 'Bird'
          Caption = 'Bird'
          Down = True
          Grouped = True
          ImageIndex = 53
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbBirdClick
        end
        object tbFish: TToolButton
          Left = 68
          Top = 0
          Hint = 'Fish'
          Caption = 'Fish'
          Grouped = True
          ImageIndex = 94
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbFishClick
        end
        object tbDuck: TToolButton
          Left = 136
          Top = 0
          Hint = 'Duck'
          Caption = 'Duck'
          Grouped = True
          ImageIndex = 116
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbDuckClick
        end
        object tbLadybug: TToolButton
          Left = 204
          Top = 0
          Hint = 'Ladybug'
          Caption = 'Ladybug'
          Grouped = True
          ImageIndex = 136
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbLadybugClick
        end
        object tbHawk: TToolButton
          Left = 272
          Top = 0
          Hint = 'Hawk'
          Caption = 'Hawk'
          Grouped = True
          ImageIndex = 98
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbHawkClick
        end
        object tbTurtle: TToolButton
          Left = 340
          Top = 0
          Hint = 'Turtle'
          Caption = 'Turtle'
          Grouped = True
          ImageIndex = 108
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbTurtleClick
        end
        object tbCrab: TToolButton
          Left = 408
          Top = 0
          Hint = 'Crab'
          Caption = 'Crab'
          Grouped = True
          ImageIndex = 96
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbCrabClick
        end
        object tbShark: TToolButton
          Left = 476
          Top = 0
          Hint = 'Shark'
          Caption = 'Shark'
          Grouped = True
          ImageIndex = 107
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbSharkClick
        end
        object tbAnt: TToolButton
          Left = 544
          Top = 0
          Hint = 'Ant'
          Caption = 'Ant'
          Grouped = True
          ImageIndex = 137
          ParentShowHint = False
          Wrap = True
          ShowHint = True
          Style = tbsCheck
          OnClick = tbAntClick
        end
        object tbGrazer: TToolButton
          Left = 0
          Top = 22
          Hint = 'Grazer'
          Caption = 'Grazer'
          Grouped = True
          ImageIndex = 101
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbGrazerClick
        end
        object tbTrex: TToolButton
          Left = 68
          Top = 22
          Hint = 'Trex'
          Caption = 'Trex'
          Grouped = True
          ImageIndex = 100
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbTrexClick
        end
        object tbRabbit: TToolButton
          Left = 136
          Top = 22
          Hint = 'Rabbit'
          Caption = 'Rabbit'
          Grouped = True
          ImageIndex = 111
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbRabbitClick
        end
        object tbTiger: TToolButton
          Left = 204
          Top = 22
          Hint = 'Tiger'
          Caption = 'Tiger'
          Grouped = True
          ImageIndex = 115
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbTigerClick
        end
        object tbMouse: TToolButton
          Left = 272
          Top = 22
          Hint = 'Mouse'
          Caption = 'Mouse'
          Grouped = True
          ImageIndex = 114
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbMouseClick
        end
        object tbTerrier: TToolButton
          Left = 340
          Top = 22
          Hint = 'Terrier'
          Caption = 'Terrier'
          Grouped = True
          ImageIndex = 110
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          Visible = False
          OnClick = tbTerrierClick
        end
        object tbDolphin: TToolButton
          Left = 408
          Top = 22
          Hint = 'Dolphin'
          Caption = 'Dolphin'
          Grouped = True
          ImageIndex = 119
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbDolphinClick
        end
        object tbFox: TToolButton
          Left = 476
          Top = 22
          Hint = 'Fox'
          Caption = 'Fox'
          Grouped = True
          ImageIndex = 113
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbFoxClick
        end
        object tbCreatureDeath: TToolButton
          Left = 544
          Top = 22
          Hint = 'Creature Killer'
          Caption = 'Death'
          Grouped = True
          ImageIndex = 41
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbCreatureDeathClick
        end
      end
    end
    object panLand: TPanel
      Left = 0
      Top = 135
      Width = 1008
      Height = 48
      Align = alTop
      TabOrder = 4
      Visible = False
      object Panel6: TPanel
        Left = 1
        Top = 1
        Width = 58
        Height = 46
        Align = alLeft
        BevelOuter = bvNone
        Color = clInactiveBorder
        TabOrder = 0
        object Panel7: TPanel
          Left = 0
          Top = 0
          Width = 58
          Height = 21
          Align = alTop
          BevelOuter = bvNone
          Caption = 'Land:'
          Color = clInactiveBorder
          TabOrder = 0
        end
      end
      object tbLand: TToolBar
        Left = 59
        Top = 1
        Width = 436
        Height = 46
        Align = alLeft
        ButtonWidth = 86
        Caption = 'tbLand'
        EdgeBorders = [ebLeft, ebBottom]
        Images = fmImages.imgIcons
        List = True
        ShowCaptions = True
        TabOrder = 1
        Transparent = False
        object tbRaiseLand: TToolButton
          Left = 0
          Top = 0
          Hint = 'Raise Land'
          Caption = 'Raise Land'
          Grouped = True
          ImageIndex = 65
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbRaiseLandClick
        end
        object tbLowerLand: TToolButton
          Left = 86
          Top = 0
          Hint = 'Lower Land'
          Caption = 'Lower Land'
          Grouped = True
          ImageIndex = 64
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbLowerLandClick
        end
        object tbMountain: TToolButton
          Left = 172
          Top = 0
          Hint = 'Mountain'
          Caption = 'Mountain'
          Grouped = True
          ImageIndex = 86
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbMountainClick
        end
        object tbValley: TToolButton
          Left = 258
          Top = 0
          Hint = 'Valley'
          Caption = 'Valley'
          Grouped = True
          ImageIndex = 81
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbValleyClick
        end
        object tbFlattenLand: TToolButton
          Left = 344
          Top = 0
          Hint = 'Flatten'
          Caption = 'Flatten Land'
          Grouped = True
          ImageIndex = 70
          ParentShowHint = False
          Wrap = True
          ShowHint = True
          Style = tbsCheck
          OnClick = tbFlattenLandClick
        end
        object tbLandDesert: TToolButton
          Left = 0
          Top = 22
          Hint = 'Land (1.0)'
          Caption = 'Desert'
          Grouped = True
          ImageIndex = 102
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbLandDesertClick
        end
        object tbLandDirt: TToolButton
          Left = 86
          Top = 22
          Hint = 'Land (2.5)'
          Caption = 'Dirt'
          Grouped = True
          ImageIndex = 103
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbLandDirtClick
        end
        object tbLandField: TToolButton
          Left = 172
          Top = 22
          Hint = 'Land (5.0)'
          Caption = 'Field'
          Down = True
          Grouped = True
          ImageIndex = 104
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbLandFieldClick
        end
        object tbLandGrass: TToolButton
          Left = 258
          Top = 22
          Hint = 'Land (7.5)'
          Caption = 'Grass'
          Grouped = True
          ImageIndex = 105
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbLandGrassClick
        end
        object tbWaterSea: TToolButton
          Left = 344
          Top = 22
          Hint = 'Land (15.0)'
          Caption = 'Highland'
          Grouped = True
          ImageIndex = 106
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbWaterSeaClick
        end
      end
    end
    object panFauna: TPanel
      Left = 0
      Top = 87
      Width = 1008
      Height = 48
      Align = alTop
      TabOrder = 5
      Visible = False
      object Panel9: TPanel
        Left = 1
        Top = 1
        Width = 58
        Height = 46
        Align = alLeft
        BevelOuter = bvNone
        Color = clInactiveBorder
        TabOrder = 0
        object Panel10: TPanel
          Left = 0
          Top = 0
          Width = 58
          Height = 21
          Align = alTop
          BevelOuter = bvNone
          Caption = 'Plants:'
          Color = clInactiveBorder
          TabOrder = 0
        end
      end
      object tbFauna: TToolBar
        Left = 59
        Top = 1
        Width = 948
        Height = 46
        Align = alClient
        ButtonWidth = 96
        Caption = 'tbFauna'
        EdgeBorders = [ebLeft, ebRight, ebBottom]
        Images = fmImages.imgIcons
        List = True
        ShowCaptions = True
        TabOrder = 1
        object tbPlantForest: TToolButton
          Left = 0
          Top = 0
          Hint = 'Plant Forest'
          Caption = 'Plant Forest'
          Down = True
          Grouped = True
          ImageIndex = 75
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbPlantForestClick
        end
        object tbEvolvingTree: TToolButton
          Left = 96
          Top = 0
          Hint = 'Evolving Tree'
          Caption = 'Evolving Tree'
          Grouped = True
          ImageIndex = 148
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbEvolvingTreeClick
        end
        object tbAppleTree: TToolButton
          Left = 192
          Top = 0
          Hint = 'Apple Tree'
          Caption = 'Apple Tree'
          Grouped = True
          ImageIndex = 47
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbAppleTreeClick
        end
        object tbOrangeTree: TToolButton
          Left = 288
          Top = 0
          Hint = 'Orange Tree'
          Caption = 'Orange Tree'
          Grouped = True
          ImageIndex = 49
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbOrangeTreeClick
        end
        object tbAquaPlant: TToolButton
          Left = 384
          Top = 0
          Hint = 'Aquatic Plant'
          Caption = 'Aqua Plant'
          Grouped = True
          ImageIndex = 120
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbAquaPlantClick
        end
        object tbGrass: TToolButton
          Left = 480
          Top = 0
          Hint = 'Grass'
          Caption = 'Grass'
          Grouped = True
          ImageIndex = 112
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbGrassClick
        end
        object tbFireTree: TToolButton
          Left = 576
          Top = 0
          Hint = 'Fire Tree'
          Caption = 'Fire Tree'
          Grouped = True
          ImageIndex = 48
          ParentShowHint = False
          Wrap = True
          ShowHint = True
          Style = tbsCheck
          OnClick = tbFireTreeClick
        end
        object tbApple: TToolButton
          Left = 0
          Top = 22
          Hint = 'Apple'
          Caption = 'Apple'
          Grouped = True
          ImageIndex = 9
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbAppleClick
        end
        object tbEvolvingFruit: TToolButton
          Left = 96
          Top = 22
          Hint = 'Evolving Fruit'
          Caption = 'Evolving Fruit'
          Grouped = True
          ImageIndex = 149
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbEvolvingFruitClick
        end
        object tbOrange: TToolButton
          Left = 192
          Top = 22
          Hint = 'Orange'
          Caption = 'Orange'
          Grouped = True
          ImageIndex = 11
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbOrangeClick
        end
        object tbAppleSeed: TToolButton
          Left = 288
          Top = 22
          Hint = 'Apple Seed'
          Caption = 'Apple Seed'
          Grouped = True
          ImageIndex = 54
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbAppleSeedClick
        end
        object tbOrangeSeed: TToolButton
          Left = 384
          Top = 22
          Hint = 'Orange Seed'
          Caption = 'Orange Seed'
          Grouped = True
          ImageIndex = 54
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbOrangeSeedClick
        end
        object tbEvolvingSeed: TToolButton
          Left = 480
          Top = 22
          Hint = 'Evolving Seed'
          Caption = 'Evolving Seed'
          Grouped = True
          ImageIndex = 54
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbEvolvingSeedClick
        end
        object tbPlantClearer: TToolButton
          Left = 576
          Top = 22
          Hint = 'Plant Clearer'
          Caption = 'Plant Clearer'
          Grouped = True
          ImageIndex = 42
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbPlantClearerClick
        end
      end
    end
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 657
    Width = 1008
    Height = 19
    Panels = <
      item
        Width = 75
      end
      item
        Width = 300
      end
      item
        Width = 350
      end>
    OnClick = StatusBarClick
  end
  object Panel2: TPanel
    Left = 0
    Top = 555
    Width = 1008
    Height = 102
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    object Image1: TImage
      Left = 144
      Top = 32
      Width = 105
      Height = 105
    end
    object GLSceneViewer: TGLSceneViewer
      Left = 0
      Top = 0
      Width = 1008
      Height = 71
      Camera = GLCamera
      Buffer.FogEnvironment.FogColor.Color = {00000000F8FEFE3E0000803F0000803F}
      Buffer.FogEnvironment.FogStart = 1.000000000000000000
      Buffer.FogEnvironment.FogEnd = 100.000000000000000000
      Buffer.FogEnvironment.FogMode = fmExp
      Buffer.FogEnvironment.FogDistance = fdEyePlane
      Buffer.BackgroundColor = clBlack
      Buffer.ContextOptions = [roDoubleBuffer, roStencilBuffer, roRenderToWindow]
      FieldOfView = 39.089725494384770000
      PenAsTouch = False
      OnMouseLeave = GLSceneViewerMouseLeave
      OnMouseEnter = GLSceneViewerMouseEnter
      Align = alClient
      OnDblClick = GLSceneViewerDblClick
      OnMouseDown = GLSceneViewerMouseDown
      OnMouseMove = GLSceneViewerMouseMove
      OnMouseUp = GLSceneViewerMouseUp
      TabOrder = 0
    end
    object panCamera: TPanel
      Left = 0
      Top = 71
      Width = 1008
      Height = 31
      Align = alBottom
      TabOrder = 1
      object tbViews: TToolBar
        Left = 1
        Top = 1
        Width = 1006
        Height = 29
        Align = alClient
        ButtonWidth = 64
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        Images = fmImages.imgIcons
        List = True
        ParentFont = False
        ShowCaptions = True
        TabOrder = 0
        object Label19: TLabel
          Left = 0
          Top = 0
          Width = 39
          Height = 22
          Caption = 'Camera:'
        end
        object tbCameraPlanet: TToolButton
          Left = 39
          Top = 0
          Hint = 'Focus on your planet (P).'
          Caption = 'Planet'
          Grouped = True
          ImageIndex = 63
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbCameraPlanetClick
        end
        object tbFloatCamera: TToolButton
          Left = 103
          Top = 0
          Hint = 'Free floating camera.'
          Caption = 'Free'
          Grouped = True
          ImageIndex = 39
          Style = tbsCheck
          OnClick = tbFloatCameraClick
        end
        object tbCameraTarget: TToolButton
          Left = 167
          Top = 0
          Hint = 'The camera follows a target (\).'
          Caption = 'Target'
          Grouped = True
          ImageIndex = 35
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbCameraTargetClick
        end
        object tbCameraEyes: TToolButton
          Left = 231
          Top = 0
          Hint = 'Eyes view.'
          Caption = 'Eyes'
          Grouped = True
          ImageIndex = 151
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbCameraEyesClick
        end
        object tbCameraGalaxy: TToolButton
          Left = 295
          Top = 0
          Hint = 'View the planet from afar.'
          Caption = 'Space'
          Grouped = True
          ImageIndex = 76
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbCameraGalaxyClick
        end
        object tbCameraSatellite: TToolButton
          Left = 359
          Top = 0
          Hint = 'Rotate around the planet from space.'
          Caption = 'Satellite'
          Grouped = True
          ImageIndex = 80
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbCameraSatelliteClick
        end
        object tbCameraAvatar: TToolButton
          Left = 423
          Top = 0
          Hint = 'Walk around on your planet in first person mode (Tab).'
          Caption = 'Walk'
          Grouped = True
          ImageIndex = 34
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = tbCameraAvatarClick
        end
        object tbZoomIn: TToolButton
          Left = 487
          Top = 0
          Hint = 'Zoom In (+ key or mouse wheel)'
          Caption = 'In'
          ImageIndex = 37
          ParentShowHint = False
          ShowHint = True
          OnClick = tbZoomInClick
        end
        object tbZoomOut: TToolButton
          Left = 551
          Top = 0
          Hint = 'Zoom Out (- key or mouse wheel)'
          Caption = 'Out'
          ImageIndex = 139
          ParentShowHint = False
          ShowHint = True
          OnClick = tbZoomOutClick
        end
        object tbPriorTarget: TToolButton
          Left = 615
          Top = 0
          Hint = 'Target the previous target to view ([).'
          Caption = 'Prev'
          ImageIndex = 68
          ParentShowHint = False
          ShowHint = True
          OnClick = tbPriorTargetClick
        end
        object tbNextTarget: TToolButton
          Left = 679
          Top = 0
          Hint = 'Find the next target to view (]).'
          Caption = 'Next'
          ImageIndex = 69
          ParentShowHint = False
          ShowHint = True
          OnClick = tbNextTargetClick
        end
        object tbNextKind: TToolButton
          Left = 743
          Top = 0
          Caption = 'Kind'
          ImageIndex = 157
          OnClick = tbNextKindClick
        end
      end
    end
  end
  object GLScene: TGLScene
    Left = 22
    Top = 552
    object GalaxyCube: TGLDummyCube
      CubeSize = 1.000000000000000000
      object SkyDome: TGLSkyDome
        Bands = <
          item
            StartColor.Color = {0000000000000000000000000000803F}
            StopAngle = 90.000000000000000000
            StopColor.Color = {0000000000000000000000000000803F}
            Slices = 3
          end>
        Stars = <>
      end
      object GLShadowVolume: TGLShadowVolume
        Lights = <>
        Occluders = <>
        Mode = svmOff
        object PlanetModel: TGLFreeForm
          Material.BackProperties.Ambient.Color = {0000000000000000000000000000803F}
          Material.BackProperties.Diffuse.Color = {0000000000000000000000000000803F}
          Material.FrontProperties.Ambient.Color = {0000000000000000000000000000803F}
          Material.FrontProperties.Diffuse.Color = {0000000000000000000000000000803F}
          Material.Texture.MinFilter = miLinear
          Material.Texture.Disabled = False
          Up.Coordinates = {00000000000080BF0000000000000000}
          AutoCentering = [macCenterX, macCenterY, macCenterZ]
          MaterialLibrary = GLMaterialLibrary
        end
      end
      object SeedCube: TGLDummyCube
        CubeSize = 1.000000000000000000
      end
      object FruitCube: TGLDummyCube
        CubeSize = 1.000000000000000000
      end
      object ForestCube: TGLDummyCube
        CubeSize = 1.000000000000000000
      end
      object SpiritCube: TGLDummyCube
        CubeSize = 1.000000000000000000
      end
      object CloudCube: TGLDummyCube
        CubeSize = 1.000000000000000000
      end
      object ProxyCube: TGLDummyCube
        CubeSize = 1.000000000000000000
      end
      object WaterBubble: TGLActor
        Material.FrontProperties.Ambient.Color = {00000000F8FEFE3E0000803F0000803F}
        Material.FrontProperties.Diffuse.Color = {000000000000003F0000803F0000003F}
        Material.FrontProperties.Emission.Color = {00000000F8FEFE3E0000803F0000803F}
        Material.BlendingMode = bmTransparency
        Material.MaterialOptions = [moNoLighting]
        Up.Coordinates = {00000000000080BF0000000000000000}
        Interval = 100
        UseMeshMaterials = False
      end
      object Atmosphere: TGLFreeForm
        Material.FrontProperties.Ambient.Color = {C6BF3F3FDCD8583FDCD8583F0000803F}
        Material.FrontProperties.Diffuse.Color = {0000803F0000803F0000803F0000803E}
        Material.FrontProperties.Emission.Color = {C6BF3F3FDCD8583FDCD8583F0000803F}
        Material.BlendingMode = bmTransparency
        Material.MaterialOptions = [moNoLighting]
        Up.Coordinates = {00000000000080BF0000000000000000}
        AutoCentering = [macCenterX, macCenterY, macCenterZ]
        UseMeshMaterials = False
      end
      object SatellitesCube: TGLDummyCube
        CubeSize = 1.000000000000000000
      end
      object EffectsCube: TGLDummyCube
        CubeSize = 1.000000000000000000
        object PlanetCursor: TGLSphere
          Material.FrontProperties.Ambient.Color = {3333733F3333733F3333733F0000803F}
          Material.FrontProperties.Diffuse.Color = {0000803F0000803F0000803F0000003F}
          Material.FrontProperties.Emission.Color = {0000803E0000803E0000803E0000803F}
          Material.BlendingMode = bmTransparency
          Visible = False
          Radius = 1.000000000000000000
        end
        object FlashLight: TGLLightSource
          ConstAttenuation = 1.000000000000000000
          Diffuse.Color = {EBE0E03E9A93133FE4DB5B3F0000803F}
          SpotCutOff = 15.000000000000000000
          SpotExponent = 2.000000000000000000
        end
        object CameraLight: TGLLightSource
          ConstAttenuation = 1.000000000000000000
          Diffuse.Color = {EAEA6A3FEAEA6A3FA7AD2D3F0000803F}
          SpotCutOff = 180.000000000000000000
        end
        object PredictLines: TGLLines
          Visible = False
          LineColor.Color = {9A99993E9A99993E0000803F0000803F}
          Nodes = <>
          NodesAspect = lnaCube
          NodeSize = 0.019999999552965160
          SplineMode = lsmCubicSpline
          Options = [loUseNodeColorForLines]
        end
        object TrackLines: TGLLines
          Visible = False
          LineColor.Color = {0000803F0000803F0000803F3333733F}
          NodeColor.Color = {0000803F0000803F0000803F0000803F}
          Nodes = <>
          NodesAspect = lnaCube
          NodeSize = 0.019999999552965160
          SplineMode = lsmCubicSpline
          Options = [loUseNodeColorForLines]
        end
      end
    end
    object ModelCube: TGLDummyCube
      Visible = False
      CubeSize = 1.000000000000000000
      object Animals: TGLDummyCube
        CubeSize = 1.000000000000000000
        object DuckModel: TGLFreeForm
          Material.BackProperties.Ambient.Color = {0000803F0000803F0000803F0000803F}
          Material.BackProperties.Diffuse.Color = {0000803F0000803F0000803F0000803F}
          Material.BackProperties.Emission.Color = {0000803F0000803F0000803F0000803F}
          Material.BackProperties.Specular.Color = {0000803F0000803F0000803F0000803F}
          Material.FrontProperties.Ambient.Color = {0000803F0000803F0000803F0000803F}
          Material.FrontProperties.Diffuse.Color = {0000803F0000803F0000803F0000803F}
          Material.FrontProperties.Emission.Color = {0000803F0000803F0000803F0000803F}
          Material.FrontProperties.Shininess = 1
          Material.FrontProperties.Specular.Color = {0000803F0000803F0000803F0000803F}
          Material.Texture.ImageAlpha = tiaAlphaFromIntensity
          Material.Texture.TextureWrap = twNone
          Material.Texture.TextureFormat = tfLuminanceAlpha
          Material.Texture.Compression = tcHighQuality
          Material.Texture.FilteringQuality = tfAnisotropic
          AutoCentering = [macCenterX, macCenterY]
          MaterialLibrary = GLMaterialLibrary
        end
        object SharkModel: TGLFreeForm
          Material.FrontProperties.Ambient.Color = {C6BF3F3FDCD8583FDCD8583F0000803F}
          Material.FrontProperties.Diffuse.Color = {BEBEBE3E999F1F3F999F1F3F0000803F}
          Material.FrontProperties.Emission.Color = {0000803E0000803E0000803E0000803F}
          Material.FaceCulling = fcNoCull
        end
        object HawkModel: TGLFreeForm
          Material.FrontProperties.Diffuse.Color = {EC51B83ECDCC4C3EEC51B83D0000803F}
          Material.FrontProperties.Emission.Color = {A19E9E3ECFBC3C3ECFBC3C3E0000803F}
          Material.FaceCulling = fcNoCull
          NormalsOrientation = mnoInvert
        end
        object TerrierModel: TGLFreeForm
          Material.FrontProperties.Ambient.Color = {9A99193F9A99193F9A99193F0000803F}
          Material.FrontProperties.Diffuse.Color = {6666663F6666663F6666663F0000803F}
          Material.FrontProperties.Emission.Color = {CDCCCC3ECDCCCC3ECDCCCC3E0000803F}
          Material.FaceCulling = fcNoCull
          AutoCentering = [macCenterX, macCenterY, macCenterZ]
        end
        object CrabModel: TGLFreeForm
          Material.FrontProperties.Diffuse.Color = {EC51383F6666E63ECDCC4C3E0000803F}
          Material.FrontProperties.Emission.Color = {938E0E3F938C0C3E938C0C3E0000803F}
          Material.FaceCulling = fcNoCull
        end
        object TurtleModel: TGLFreeForm
          Material.FrontProperties.Ambient.Color = {938C0C3E938E0E3FDCD6D63E0000803F}
          Material.FrontProperties.Diffuse.Color = {9484843EDBDEDE3E9484843E0000803F}
          Material.FrontProperties.Emission.Color = {CDCC4C3ECDCC4C3ECDCC4C3E0000803F}
          Material.FaceCulling = fcCull
        end
        object TrexModel: TGLFreeForm
          Material.FrontProperties.Diffuse.Color = {0000000000000000F6281C3F0000803F}
          Material.FrontProperties.Emission.Color = {9484843E9484843EDBDEDE3E0000803F}
          Material.FaceCulling = fcNoCull
        end
        object GrazerModel: TGLFreeForm
          Material.FrontProperties.Diffuse.Color = {9484843EDBDEDE3E9484843E0000803F}
          Material.FrontProperties.Emission.Color = {DCD6D63E938E0E3F938C0C3E0000803F}
          Material.FaceCulling = fcNoCull
        end
        object MouseModel: TGLFreeForm
          Material.FaceCulling = fcNoCull
        end
        object TigerModel: TGLFreeForm
          Material.FrontProperties.Emission.Color = {9392123FF3F2F23E000000000000803F}
          Material.FrontProperties.Specular.Color = {9F9E1E3FFBFAFA3E000000000000803F}
          Material.FaceCulling = fcNoCull
        end
        object RabbitModel: TGLFreeForm
          Material.FrontProperties.Emission.Color = {3333333F3333333F3333333F0000803F}
          Material.FaceCulling = fcNoCull
        end
        object FoxModel: TGLFreeForm
          Material.FrontProperties.Diffuse.Color = {EC51B83ECDCC4C3EEC51B83D0000803F}
          Material.FrontProperties.Emission.Color = {A9A5253FB1A8283EB1A8283E0000803F}
          Material.FaceCulling = fcNoCull
          AutoCentering = [macCenterX, macCenterY, macCenterZ]
        end
        object LadyBugModel: TGLFreeForm
          Material.Texture.Disabled = False
          Scale.Coordinates = {CDCCCC3DCDCCCC3DCDCCCC3D00000000}
          AutoCentering = [macUseBarycenter]
          MaterialLibrary = GLMaterialLibrary
        end
      end
      object Plants: TGLDummyCube
        CubeSize = 1.000000000000000000
        object OrangeTreeModel: TGLFreeForm
          Material.FrontProperties.Ambient.Color = {938C0C3E938E0E3F938C0C3E0000803F}
          Material.FrontProperties.Diffuse.Color = {91ED7C3EA69BC43EC520303D0000803F}
          Material.FrontProperties.Emission.Color = {2B87963E52B8DE3E6F12033C0000803F}
          Material.FaceCulling = fcNoCull
          AutoCentering = [macUseBarycenter]
          NormalsOrientation = mnoInvert
        end
        object GrassModel: TGLFreeForm
          Material.FrontProperties.Diffuse.Color = {ACC8483ECDCC4C3FACC8483E0000803F}
          Material.FrontProperties.Emission.Color = {938C0C3E938E0E3F938C0C3E0000803F}
          Material.FaceCulling = fcNoCull
        end
        object SeedModel: TGLFreeForm
          Material.FrontProperties.Ambient.Color = {B81E053FA470BD3EB81E853E0000803F}
          Material.FrontProperties.Diffuse.Color = {A19E9E3ECFBC3C3ECFBC3C3E0000803F}
          Material.FrontProperties.Emission.Color = {3D0AD73EB81E853E9A99193E0000803F}
          Visible = False
          AutoCentering = [macUseBarycenter]
          UseMeshMaterials = False
        end
        object OrangeModel: TGLFreeForm
          Material.FrontProperties.Ambient.Color = {0000803FF8FEFE3E000000000000803F}
          Material.FrontProperties.Diffuse.Color = {0000803F0000003F000000000000803F}
          Material.FrontProperties.Emission.Color = {0AD7633FD7A3F03ECDCC4C3E0000803F}
          Visible = False
          AutoCentering = [macCenterX, macCenterY, macCenterZ]
          UseMeshMaterials = False
        end
        object AppleModel: TGLFreeForm
          Material.FrontProperties.Ambient.Color = {0000803F00000000000000000000803F}
          Material.FrontProperties.Diffuse.Color = {0000803F0000803E000000000000803F}
          Material.FrontProperties.Emission.Color = {938E0E3F938C0C3E938C0C3E0000803F}
          Visible = False
          AutoCentering = [macCenterX, macCenterY, macCenterZ]
          UseMeshMaterials = False
        end
        object AppleTreeModel: TGLFreeForm
          Material.FrontProperties.Ambient.Color = {938E0E3F938C0C3E938C0C3E0000803F}
          Material.FrontProperties.Diffuse.Color = {CFBC3C3EA19E9E3ECFBC3C3E0000803F}
          Material.FrontProperties.Emission.Color = {938C0C3E938E0E3F938C0C3E0000803F}
          Material.FaceCulling = fcNoCull
          Visible = False
          AutoCentering = [macUseBarycenter]
          UseMeshMaterials = False
          NormalsOrientation = mnoInvert
        end
        object AquaPlant: TGLFreeForm
          Material.FrontProperties.Ambient.Color = {CFBC3C3EA19E9E3ECFBC3C3E0000803F}
          Material.FrontProperties.Diffuse.Color = {938C0C3E938E0E3F938C0C3E0000803F}
          Material.FrontProperties.Emission.Color = {ACC8483ECDCC4C3FACC8483E0000803F}
          Material.FaceCulling = fcNoCull
          Scale.Coordinates = {CDCCCC3DCDCCCC3DCDCCCC3D00000000}
          AutoCentering = [macCenterX, macCenterY, macCenterZ]
        end
        object EvolvingTree: TGLFreeForm
          Material.FrontProperties.Emission.Color = {CDCCCC3ECDCCCC3ECDCCCC3E0000803F}
          Material.FaceCulling = fcNoCull
          AutoCentering = [macUseBarycenter]
          NormalsOrientation = mnoInvert
        end
        object EvolvingFruit: TGLFreeForm
          Material.FrontProperties.Emission.Color = {CDCC4C3ECDCC4C3ECDCC4C3E0000803F}
          AutoCentering = [macCenterX, macCenterY, macCenterZ]
        end
        object EvolvingSeed: TGLFreeForm
          Material.FrontProperties.Emission.Color = {CDCC4C3ECDCC4C3ECDCC4C3E0000803F}
          AutoCentering = [macUseBarycenter]
        end
        object FireTree: TGLFreeForm
          Material.FrontProperties.Ambient.Color = {938E0E3F938C0C3E938C0C3E0000803F}
          Material.FrontProperties.Diffuse.Color = {CFBC3C3EA19E9E3ECFBC3C3E0000803F}
          Material.FrontProperties.Emission.Color = {938C0C3E938E0E3F938C0C3E0000803F}
          NormalsOrientation = mnoInvert
        end
      end
      object FishModels: TGLDummyCube
        CubeSize = 1.000000000000000000
        object FishModel: TGLFreeForm
          Material.FrontProperties.Ambient.Color = {CDCC0C3FD7A3F03E295C0F3E0000803F}
          Material.FrontProperties.Diffuse.Color = {2DB23D3F986E923E5839343E0000803F}
          Material.FrontProperties.Emission.Color = {6ABC343F9CC4E03EE926313E0000803F}
        end
        object FishGirlModel: TGLFreeForm
          Material.FrontProperties.Ambient.Color = {A8C62B3F21B0123FE926313E0000803F}
          Material.FrontProperties.Diffuse.Color = {D9CE573F39B4C83EFED4783E0000803F}
          Material.FrontProperties.Emission.Color = {60E5503F3D0AD73E7F6A3C3E0000803F}
        end
      end
      object BirdModels: TGLDummyCube
        CubeSize = 1.000000000000000000
        object BirdFlap1: TGLFreeForm
          Material.FrontProperties.Diffuse.Color = {AE47613ED7A3303F52B85E3F0000803F}
          Material.FrontProperties.Emission.Color = {CDCC4C3FCDCC4C3FCDCC4C3F0000803F}
          Material.FaceCulling = fcNoCull
        end
        object BirdFlap2: TGLFreeForm
          Material.FrontProperties.Diffuse.Color = {AE47613ED7A3303F52B85E3F0000803F}
          Material.FrontProperties.Emission.Color = {CDCC4C3FCDCC4C3FCDCC4C3F0000803F}
          Material.FaceCulling = fcNoCull
        end
        object BirdFlap3: TGLFreeForm
          Material.FrontProperties.Diffuse.Color = {AE47613ED7A3303F52B85E3F0000803F}
          Material.FrontProperties.Emission.Color = {CDCC4C3FCDCC4C3FCDCC4C3F0000803F}
          Material.FaceCulling = fcNoCull
        end
        object BirdFlap4: TGLFreeForm
          Material.FrontProperties.Diffuse.Color = {AE47613ED7A3303F52B85E3F0000803F}
          Material.FrontProperties.Emission.Color = {CDCC4C3FCDCC4C3FCDCC4C3F0000803F}
          Material.FaceCulling = fcNoCull
        end
        object BirdSit: TGLFreeForm
          Material.FrontProperties.Diffuse.Color = {AE47613ED7A3303F52B85E3F0000803F}
          Material.FrontProperties.Emission.Color = {CDCC4C3FCDCC4C3FCDCC4C3F0000803F}
          Material.FaceCulling = fcNoCull
        end
        object BirdDead: TGLFreeForm
          Material.FrontProperties.Diffuse.Color = {AE47613ED7A3303F52B85E3F0000803F}
          Material.FrontProperties.Emission.Color = {3333333F3333333F3333333F0000803F}
          Material.FaceCulling = fcNoCull
        end
      end
      object Tools: TGLDummyCube
        CubeSize = 1.000000000000000000
        object SpiritModel: TGLFreeForm
          Material.FrontProperties.Ambient.Color = {ACC8483EACC8483ECDCC4C3F0000803F}
          Material.FrontProperties.Diffuse.Color = {8A8F0F3F8A8F0F3FBEBC3C3F0000803F}
          Material.FrontProperties.Emission.Color = {9484843E9484843EDBDEDE3E0000803F}
          AutoCentering = [macCenterX, macCenterY, macCenterZ]
        end
        object BeaconModel: TGLFreeForm
          Material.FrontProperties.Ambient.Color = {6666663FC3F5683F48E17A3F0000803F}
          Material.FrontProperties.Emission.Color = {999F1F3F999F1F3FBEBEBE3E0000803F}
        end
        object BombModel: TGLFreeForm
          Material.FrontProperties.Diffuse.Color = {EC51B83E0000803ECDCC4C3E0000803F}
          Material.FrontProperties.Emission.Color = {A19E9E3ECFBC3C3ECFBC3C3E0000803F}
        end
        object ExplosionModel: TGLFreeForm
        end
        object ShellModel: TGLFreeForm
        end
        object WeaponModel: TGLFreeForm
          Material.FrontProperties.Diffuse.Color = {A19E9E3ECFBC3C3ECFBC3C3E0000803F}
          Material.FrontProperties.Emission.Color = {B1A8A83EB1A8A83EB1A8A83E0000803F}
        end
        object MissileDefence: TGLFreeForm
          Material.FrontProperties.Ambient.Color = {9A99993E9A99993E9A99993E0000803F}
          Material.FrontProperties.Diffuse.Color = {B1A8A83EB1A8A83EB1A8A83E0000803F}
          Material.FrontProperties.Emission.Color = {9A99193E9A99193E9A99193E0000803F}
          AutoCentering = [macCenterX, macCenterY, macCenterZ]
          UseMeshMaterials = False
        end
        object Missile: TGLFreeForm
        end
      end
      object WeatherCube: TGLDummyCube
        CubeSize = 1.000000000000000000
        object CloudModel: TGLFreeForm
          Material.FrontProperties.Ambient.Color = {B1A8283FB1A8283FB1A8283F0000803F}
          Material.FrontProperties.Diffuse.Color = {D9D8583FE5E4643FF9F8783F0000803F}
          Material.FrontProperties.Emission.Color = {BEBEBE3E999F1F3F999F1F3F0000803F}
          Material.Texture.ImageAlpha = tiaTopLeftPointColorTransparent
          ObjectsSorting = osRenderFarthestFirst
          Visible = False
          AutoCentering = [macUseBarycenter]
          UseMeshMaterials = False
        end
        object SnowModel: TGLFreeForm
          Material.FrontProperties.Diffuse.Color = {0000803F0000803F0000803F0000803F}
          Material.FrontProperties.Emission.Color = {6666663F6666663F6666663F0000803F}
        end
        object IcebergModel: TGLFreeForm
          Material.FrontProperties.Ambient.Color = {9A99993E9A99993E0000803F0000403F}
          Material.FrontProperties.Diffuse.Color = {BEBEBE3E999F1F3F999F1F3F0000403F}
          Material.FrontProperties.Emission.Color = {CDCC4C3ECDCC4C3ECDCC4C3E0000403F}
          Material.BlendingMode = bmAdditive
        end
        object MoonModel: TGLFreeForm
          Material.FrontProperties.Ambient.Color = {ACC8483EACC8483ECDCC4C3F0000803F}
          Material.FrontProperties.Diffuse.Color = {9A99993E9A99993E0000803F0000803F}
          Material.FrontProperties.Emission.Color = {938C0C3EDCD6D63E938E0E3F0000803F}
          Visible = False
        end
        object SunModel: TGLFreeForm
          Material.FrontProperties.Ambient.Color = {0000803F00000000000000000000803F}
          Material.FrontProperties.Diffuse.Color = {0000803F00000000000000000000803F}
          Material.FrontProperties.Emission.Color = {0000803F0000803F000000000000803F}
          Visible = False
        end
        object MoonAsteroidModel: TGLFreeForm
          Material.FrontProperties.Ambient.Color = {EBE0E03E9A93133FE4DB5B3F0000803F}
          Material.FrontProperties.Diffuse.Color = {C6BF3F3FDCD8583FDCD8583F0000803F}
          Material.FrontProperties.Emission.Color = {ACC8483EACC8483ECDCC4C3F0000803F}
        end
        object AsteroidModel: TGLFreeForm
          Material.FrontProperties.Ambient.Color = {0000000000000000000000000000803F}
          Material.FrontProperties.Diffuse.Color = {CDCC4C3ECDCC4C3ECDCC4C3E0000803F}
          Material.FrontProperties.Emission.Color = {9A99193E9A99193E9A99193E0000803F}
          AutoCentering = [macCenterX, macCenterY, macCenterZ]
        end
        object SunAsteroidModel: TGLFreeForm
          Material.FrontProperties.Ambient.Color = {0000803F0000003F000000000000803F}
          Material.FrontProperties.Diffuse.Color = {0000803F0000803F000000000000803F}
          Material.FrontProperties.Emission.Color = {0000803F00000000000000000000803F}
        end
        object RainModel: TGLFreeForm
          Material.FrontProperties.Ambient.Color = {BEBEBE3E999F1F3F999F1F3F0000803F}
          Material.FrontProperties.Diffuse.Color = {00000000000000000000803F0000803F}
          Material.FrontProperties.Emission.Color = {00000000F8FEFE3E0000803F0000803F}
          Scale.Coordinates = {00004040000040400000404000000000}
        end
        object CloudModelOld: TGLFreeForm
          Material.FrontProperties.Ambient.Color = {39B4283F39B4283F39B4283F0000803F}
          Material.FrontProperties.Diffuse.Color = {FED4583F2FDD643F8716793F0000803F}
          Material.FrontProperties.Emission.Color = {BEBEBE3E999F1F3F999F1F3F0000803F}
          UseMeshMaterials = False
        end
      end
      object Dolphins: TGLDummyCube
        CubeSize = 1.000000000000000000
        object Dolphin1: TGLFreeForm
          Material.FrontProperties.Diffuse.Color = {BEBEBE3E999F1F3F999F1F3F0000803F}
          Material.FrontProperties.Emission.Color = {E17A943E1F85EB3EF628DC3E0000803F}
          AutoCentering = [macUseBarycenter]
        end
        object Dolphin2: TGLFreeForm
          Material.FrontProperties.Diffuse.Color = {BEBEBE3E999F1F3F999F1F3F0000803F}
          Material.FrontProperties.Emission.Color = {E17A943E1F85EB3EF628DC3E0000803F}
          AutoCentering = [macUseBarycenter]
        end
        object Dolphin3: TGLFreeForm
          Material.FrontProperties.Diffuse.Color = {BEBEBE3E999F1F3F999F1F3F0000803F}
          Material.FrontProperties.Emission.Color = {E17A943E1F85EB3EF628DC3E0000803F}
          AutoCentering = [macUseBarycenter]
        end
        object Dolphin4: TGLFreeForm
          Material.FrontProperties.Diffuse.Color = {BEBEBE3E999F1F3F999F1F3F0000803F}
          Material.FrontProperties.Emission.Color = {E17A943E1F85EB3EF628DC3E0000803F}
          AutoCentering = [macUseBarycenter]
        end
      end
      object Ants: TGLDummyCube
        CubeSize = 1.000000000000000000
        object AntModel1: TGLFreeForm
          MaterialLibrary = GLMaterialLibrary
        end
        object AntModel2: TGLFreeForm
          MaterialLibrary = GLMaterialLibrary
        end
        object AntModel3: TGLFreeForm
          MaterialLibrary = GLMaterialLibrary
        end
      end
    end
    object FloatCube: TGLDummyCube
      Visible = False
      CubeSize = 1.000000000000000000
    end
    object LightsCube: TGLDummyCube
      CubeSize = 1.000000000000000000
    end
    object SoundSystem: TGLDummyCube
      Visible = False
      CubeSize = 1.000000000000000000
    end
    object HUDCube: TGLDummyCube
      CubeSize = 1.000000000000000000
      object GLObjectText: TGLHUDText
        Visible = False
        BitmapFont = GLWindowsBitmapFont1
        Rotation = 0.000000000000000000
      end
    end
    object GLCamera: TGLCamera
      DepthOfView = 500.000000000000000000
      FocalLength = 100.000000000000000000
      Position.Coordinates = {000048420000803F0000A0C10000803F}
      Direction.Coordinates = {00000000000000000000803F00000000}
    end
  end
  object GLCadencer: TGLCadencer
    Scene = GLScene
    Enabled = False
    MaxDeltaTime = 1.000000000000000000
    SleepLength = 5
    OnProgress = GLCadencerProgress
    Left = 84
    Top = 552
  end
  object GLMaterialLibrary: TGLMaterialLibrary
    Left = 258
    Top = 552
  end
  object FPSTimer: TTimer
    Interval = 1024
    OnTimer = FPSTimerTimer
    Left = 718
    Top = 552
  end
  object GLSoundLibrary: TGLSoundLibrary
    Samples = <>
    Left = 164
    Top = 552
  end
  object GLPolygonPFXManager1: TGLPolygonPFXManager
    Cadencer = GLCadencer
    Friction = 1.000000000000000000
    ParticleSize = 1.000000000000000000
    LifeColors = <
      item
        LifeTime = 3.000000000000000000
        SizeScale = 1.000000000000000000
      end>
    Left = 362
    Top = 552
  end
  object GLWindowsBitmapFont1: TGLWindowsBitmapFont
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Left = 482
    Top = 553
  end
  object AVIRecorder: TGLAVIRecorder
    FPS = 24
    GLSceneViewer = GLSceneViewer
    Width = 320
    Height = 200
    Filename = 'photos\aimovie.avi'
    Left = 634
    Top = 553
  end
  object GLBass: TGLSMBASS
    MaxChannels = 32
    MasterVolume = 1.000000000000000000
    Sources = <>
    Left = 560
    Top = 555
  end
end
