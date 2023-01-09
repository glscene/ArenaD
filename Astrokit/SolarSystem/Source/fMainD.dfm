object Form1: TForm1
  Left = 193
  Top = 128
  Caption = 'Solar System D'
  ClientHeight = 605
  ClientWidth = 854
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu
  Position = poScreenCenter
  WindowState = wsMaximized
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  TextHeight = 13
  object SceneViewer: TGLSceneViewer
    Left = 195
    Top = 0
    Width = 475
    Height = 605
    Camera = Camera
    Buffer.FogEnvironment.FogColor.Color = {938C0C3E938C0C3E938E0E3F0000803F}
    Buffer.FogEnvironment.FogStart = 10.000000000000000000
    Buffer.FogEnvironment.FogEnd = 1000.000000000000000000
    Buffer.FogEnvironment.FogDistance = fdEyePlane
    Buffer.BackgroundColor = clBackground
    FieldOfView = 134.332687377929700000
    PenAsTouch = False
    Align = alClient
    OnMouseDown = SceneViewerMouseDown
    TabOrder = 0
  end
  object PanelLeft: TPanel
    Left = 0
    Top = 0
    Width = 195
    Height = 605
    Align = alLeft
    BevelOuter = bvNone
    BorderWidth = 4
    TabOrder = 1
    object TreeView: TTreeView
      Left = 4
      Top = 4
      Width = 187
      Height = 597
      Align = alClient
      BevelKind = bkTile
      BorderStyle = bsNone
      Indent = 19
      TabOrder = 0
      OnChange = TreeViewChange
      OnClick = TreeViewClick
    end
  end
  object PanelRight: TPanel
    Left = 670
    Top = 0
    Width = 184
    Height = 605
    Align = alRight
    TabOrder = 2
    object Splitter1: TSplitter
      Left = 1
      Top = 131
      Width = 182
      Height = 19
      Cursor = crVSplit
      Align = alTop
      AutoSnap = False
      MinSize = 120
      ExplicitTop = 107
      ExplicitWidth = 183
    end
    object stPickObject: TStaticText
      Left = 1
      Top = 1
      Width = 182
      Height = 17
      Align = alTop
      Alignment = taCenter
      Caption = 'stPickObject'
      TabOrder = 0
    end
    inline FrameParams: TFrameParams
      Left = 1
      Top = 18
      Width = 182
      Height = 113
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alTop
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Courier'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      ExplicitLeft = 1
      ExplicitTop = 18
      ExplicitWidth = 182
      ExplicitHeight = 113
    end
    object cbOrbit: TCheckBox
      Left = 29
      Top = 173
      Width = 97
      Height = 17
      Caption = 'Orbit Lines'
      Checked = True
      State = cbChecked
      TabOrder = 2
      OnClick = cbOrbitClick
    end
    object cbHabitableZone: TCheckBox
      Left = 29
      Top = 196
      Width = 97
      Height = 17
      Caption = 'Habitable Zone'
      Checked = True
      State = cbChecked
      TabOrder = 3
      OnClick = cbHabitableZoneClick
    end
    object MemoInfo: TMemo
      Left = 1
      Top = 474
      Width = 182
      Height = 130
      Align = alBottom
      Lines.Strings = (
        'Memo1')
      TabOrder = 4
    end
    object cbRotation: TCheckBox
      Left = 29
      Top = 224
      Width = 97
      Height = 17
      Caption = 'Rotation'
      Checked = True
      State = cbChecked
      TabOrder = 5
      OnClick = cbRotationClick
    end
  end
  object Scene: TGLScene
    Left = 24
    Top = 16
    object SkyDome: TGLSkyDome
      Bands = <
        item
          StartColor.Color = {0000803F0000803F0000803F0000803F}
          StopAngle = 15.000000000000000000
        end
        item
          StartAngle = 15.000000000000000000
          StopAngle = 90.000000000000000000
          StopColor.Color = {938C0C3E938C0C3E938E0E3F0000803F}
          Stacks = 4
        end>
      Stars = <>
    end
    object SolarSystem: TGLDummyCube
      CubeSize = 1.000000000000000000
      object Camera: TGLCamera
        DepthOfView = 10000.000000000000000000
        FocalLength = 100.000000000000000000
        NearPlaneBias = 0.100000001490116100
        TargetObject = SolarSystem
        CameraStyle = csInfinitePerspective
        Position.Coordinates = {0000204100002041000020410000803F}
        object LightSource: TGLLightSource
          ConstAttenuation = 1.000000000000000000
          SpotCutOff = 180.000000000000000000
        end
      end
      object Sun: TGLSphere
        Material.FrontProperties.Emission.Color = {9A99593F9A99593FCDCCCC3D0000803F}
        Material.Texture.Disabled = False
        Radius = 0.699999988079071000
        Slices = 32
        Stacks = 32
        EffectsData = {
          0458434F4C02010201060A54474C424669726546580201020006064669726546
          5802000200060D4669726546584D616E61676572}
      end
      object HabitableZone: TGLDisk
        Material.BackProperties.Diffuse.Color = {CDCC4C3E0000803FCDCC4C3E9A99993E}
        Material.FrontProperties.Diffuse.Color = {CDCC4C3E0000803FCDCC4C3E9A99993E}
        Material.BlendingMode = bmTransparency
        Material.FaceCulling = fcCull
        Direction.Coordinates = {000000000000803F2EBD3BB300000000}
        PitchAngle = 90.000000000000000000
        Up.Coordinates = {000000002EBD3BB3000080BF00000000}
        Visible = False
        Pickable = False
        InnerRadius = 4.800000190734863000
        Loops = 1
        OuterRadius = 9.500000000000000000
        Slices = 64
        SweepAngle = 360.000000000000000000
      end
      object dcMercury: TGLDummyCube
        Tag = 1
        CubeSize = 1.000000000000000000
        object Mercury: TGLSphere
          Tag = 1
          Material.Texture.Disabled = False
          Position.Coordinates = {0000000000000000000000400000803F}
          Radius = 0.319999992847442600
          Slices = 32
          Stacks = 32
        end
        object MercuryOrbit: TGLTorus
          Tag = 1
          Direction.Coordinates = {000000000000803F2EBD3BB300000000}
          PitchAngle = 90.000000000000000000
          Up.Coordinates = {000000002EBD3BB3000080BF00000000}
          Visible = False
          Pickable = False
          MajorRadius = 2.000000000000000000
          MinorRadius = 0.029999999329447750
          Rings = 64
          StopAngle = 360.000000000000000000
          Parts = [toSides, toStartDisk, toStopDisk]
        end
      end
      object dcVenus: TGLDummyCube
        Tag = 1
        CubeSize = 1.000000000000000000
        object Venus: TGLSphere
          Tag = 1
          Material.Texture.Disabled = False
          Position.Coordinates = {0000000000000000000080400000803F}
          Radius = 0.750000000000000000
          Slices = 32
          Stacks = 32
        end
        object VenusOrbit: TGLTorus
          Tag = 2
          Direction.Coordinates = {000000000000803F2EBD3BB300000000}
          PitchAngle = 90.000000000000000000
          Up.Coordinates = {000000002EBD3BB3000080BF00000000}
          Visible = False
          Pickable = False
          MajorRadius = 4.000000000000000000
          MinorRadius = 0.029999999329447750
          Rings = 64
          StopAngle = 360.000000000000000000
          Parts = [toSides, toStartDisk, toStopDisk]
        end
      end
      object dcEarth: TGLDummyCube
        Tag = 3
        CubeSize = 1.000000000000000000
        object Earth: TGLSphere
          Tag = 3
          Material.Texture.Disabled = False
          Position.Coordinates = {00000000000000000000E0400000803F}
          Radius = 0.800000011920929000
          Slices = 32
          Stacks = 32
          object dcMoon: TGLDummyCube
            Tag = 3
            TagFloat = 1.000000000000000000
            CubeSize = 1.000000000000000000
            object Moon: TGLSphere
              Tag = 3
              TagFloat = 1.000000000000000000
              Material.Texture.Disabled = False
              Position.Coordinates = {00000000000000000000C03F0000803F}
              Radius = 0.200000002980232200
              Slices = 32
              Stacks = 32
            end
          end
        end
        object EarthOrbit: TGLTorus
          Tag = 3
          Direction.Coordinates = {000000000000803F2EBD3BB300000000}
          PitchAngle = 90.000000000000000000
          Up.Coordinates = {000000002EBD3BB3000080BF00000000}
          Visible = False
          Pickable = False
          MajorRadius = 7.000000000000000000
          MinorRadius = 0.029999999329447750
          Rings = 64
          StopAngle = 360.000000000000000000
          Parts = [toSides, toStartDisk, toStopDisk]
        end
      end
      object dcMars: TGLDummyCube
        Tag = 4
        CubeSize = 1.000000000000000000
        object Mars: TGLSphere
          Tag = 4
          Material.Texture.Disabled = False
          Position.Coordinates = {0000000000000000000020C10000803F}
          Radius = 0.400000005960464500
          Slices = 32
          Stacks = 32
          object dcPhobos: TGLDummyCube
            Tag = 4
            TagFloat = 1.000000000000000000
            CubeSize = 1.000000000000000000
            object Phobos: TGLFreeForm
              Material.Texture.Disabled = False
              Position.Coordinates = {0000000000000000333333BF0000803F}
            end
          end
          object dcDeimos: TGLDummyCube
            Tag = 4
            TagFloat = 2.000000000000000000
            CubeSize = 1.000000000000000000
            object Deimos: TGLFreeForm
              Material.Texture.Disabled = False
              Position.Coordinates = {00000000000000006666663F0000803F}
            end
          end
        end
        object MarsOrbit: TGLTorus
          Tag = 4
          Direction.Coordinates = {000000000000803F2EBD3BB300000000}
          PitchAngle = 90.000000000000000000
          Up.Coordinates = {000000002EBD3BB3000080BF00000000}
          Visible = False
          Pickable = False
          MajorRadius = 10.000000000000000000
          MinorRadius = 0.029999999329447750
          Rings = 64
          Sides = 32
          StopAngle = 360.000000000000000000
          Parts = [toSides, toStartDisk, toStopDisk]
        end
      end
      object dcJupiter: TGLDummyCube
        Tag = 5
        CubeSize = 1.000000000000000000
        object Jupiter: TGLSphere
          Tag = 5
          Material.Texture.Disabled = False
          Position.Coordinates = {00000000000000000000B0C10000803F}
          Radius = 3.400000095367432000
          Slices = 32
          Stacks = 32
          object dcIo: TGLDummyCube
            Tag = 5
            TagFloat = 1.000000000000000000
            CubeSize = 1.000000000000000000
            object Io: TGLSphere
              Tag = 5
              TagFloat = 1.000000000000000000
              Material.Texture.Disabled = False
              Position.Coordinates = {0000000000000000000080C00000803F}
              Radius = 0.239999994635582000
              Slices = 32
              Stacks = 32
            end
          end
          object dcEuropa: TGLDummyCube
            Tag = 5
            TagFloat = 2.000000000000000000
            CubeSize = 1.000000000000000000
            object Europa: TGLSphere
              Tag = 5
              TagFloat = 2.000000000000000000
              Material.Texture.Disabled = False
              Position.Coordinates = {00000000000000000000A0400000803F}
              Radius = 0.239999994635582000
              Slices = 32
              Stacks = 32
            end
          end
          object dcGanymede: TGLDummyCube
            Tag = 5
            TagFloat = 3.000000000000000000
            CubeSize = 1.000000000000000000
            object Ganymede: TGLSphere
              Tag = 5
              TagFloat = 3.000000000000000000
              Material.Texture.Disabled = False
              Position.Coordinates = {00000000000000000000C0C00000803F}
              Radius = 0.379999995231628400
              Slices = 32
              Stacks = 32
            end
          end
          object dcCallisto: TGLDummyCube
            Tag = 5
            TagFloat = 4.000000000000000000
            CubeSize = 1.000000000000000000
            object Callisto: TGLSphere
              Tag = 5
              TagFloat = 4.000000000000000000
              Material.Texture.Disabled = False
              Position.Coordinates = {00000000000000000000E0400000803F}
              Radius = 0.259999990463256800
              Slices = 32
              Stacks = 32
            end
          end
        end
        object JupiterOrbit: TGLTorus
          Tag = 5
          Direction.Coordinates = {000000000000803F2EBD3BB300000000}
          PitchAngle = 90.000000000000000000
          Up.Coordinates = {000000002EBD3BB3000080BF00000000}
          Visible = False
          Pickable = False
          MajorRadius = 22.000000000000000000
          MinorRadius = 0.029999999329447750
          Rings = 64
          StopAngle = 360.000000000000000000
          Parts = [toSides, toStartDisk, toStopDisk]
        end
      end
      object dcSaturn: TGLDummyCube
        Tag = 6
        CubeSize = 1.000000000000000000
        object Saturn: TGLSphere
          Tag = 6
          Material.Texture.Disabled = False
          Position.Coordinates = {0000000000000000000020420000803F}
          Radius = 3.000000000000000000
          Slices = 32
          Stacks = 32
          object SaturnRing: TGLDisk
            Material.BackProperties.Ambient.Color = {0000803FF8FEFE3E000000000000803F}
            Material.BackProperties.Diffuse.Color = {0000803F0000803F0000803F0000803F}
            Material.BackProperties.Emission.Color = {0000803F0000803F0000803F0000803F}
            Material.BackProperties.Specular.Color = {0000803F0000803F0000803F0000803F}
            Material.FrontProperties.Ambient.Color = {0000803F0000803F0000803F0000803F}
            Material.FrontProperties.Diffuse.Color = {0000803F0000803F0000803F0000803F}
            Material.FrontProperties.Specular.Color = {0000803F0000803F0000803F0000803F}
            Material.Texture.Disabled = False
            Material.FaceCulling = fcNoCull
            ObjectsSorting = osRenderNearestFirst
            Direction.Coordinates = {000000000000803F2EBD3BB300000000}
            PitchAngle = 90.000000000000000000
            Up.Coordinates = {000000002EBD3BB3000080BF00000000}
            InnerRadius = 3.200000047683716000
            OuterRadius = 6.000000000000000000
            Slices = 32
            SweepAngle = 360.000000000000000000
          end
          object dcEnceladus: TGLDummyCube
            Tag = 6
            TagFloat = 1.000000000000000000
            CubeSize = 1.000000000000000000
            object Enceladus: TGLSphere
              Tag = 6
              TagFloat = 1.000000000000000000
              Material.Texture.Disabled = False
              Position.Coordinates = {0000000000000000000000410000803F}
              Radius = 0.100000001490116100
              Slices = 32
              Stacks = 32
            end
          end
          object dcTitan: TGLDummyCube
            Tag = 6
            TagFloat = 2.000000000000000000
            CubeSize = 1.000000000000000000
            object Titan: TGLSphere
              Tag = 6
              TagFloat = 2.000000000000000000
              Material.Texture.Disabled = False
              Position.Coordinates = {0000000000000000000020410000803F}
              Radius = 0.500000000000000000
              Slices = 32
              Stacks = 32
            end
          end
        end
        object SaturnOrbit: TGLTorus
          Tag = 6
          Direction.Coordinates = {000000000000803F2EBD3BB300000000}
          PitchAngle = 90.000000000000000000
          Up.Coordinates = {000000002EBD3BB3000080BF00000000}
          Visible = False
          Pickable = False
          MajorRadius = 40.000000000000000000
          MinorRadius = 0.029999999329447750
          Rings = 64
          StopAngle = 360.000000000000000000
          Parts = [toSides, toStartDisk, toStopDisk]
        end
      end
      object dcUranus: TGLDummyCube
        Tag = 7
        CubeSize = 1.000000000000000000
        object Uranus: TGLSphere
          Tag = 7
          Material.Texture.Disabled = False
          Position.Coordinates = {0000000000000000000070420000803F}
          RollAngle = 45.000000000000000000
          Up.Coordinates = {F30435BFF304353F0000000000000000}
          Radius = 2.200000047683716000
          Slices = 32
          Stacks = 32
          object UranusRing: TGLDisk
            Material.BackProperties.Ambient.Color = {0000803FF8FEFE3E000000000000803F}
            Material.BackProperties.Diffuse.Color = {0000803F0000803F0000803F0000803F}
            Material.BackProperties.Emission.Color = {0000803F0000803F0000803F0000803F}
            Material.BackProperties.Specular.Color = {0000803F0000803F0000803F0000803F}
            Material.FrontProperties.Ambient.Color = {0000003F0000003F0000003F0000803F}
            Material.FrontProperties.Diffuse.Color = {0000003F0000003F0000003F0000803F}
            Material.FrontProperties.Emission.Color = {0000003F0000003F0000003F0000803F}
            Material.FrontProperties.Specular.Color = {0000003F0000003F0000003F0000803F}
            Material.FaceCulling = fcNoCull
            ObjectsSorting = osRenderNearestFirst
            Direction.Coordinates = {000000000000803F2EBD3BB300000000}
            PitchAngle = 90.000000000000000000
            Up.Coordinates = {000000002EBD3BB3000080BF00000000}
            InnerRadius = 2.799999952316284000
            OuterRadius = 3.200000047683716000
            Slices = 32
            SweepAngle = 360.000000000000000000
          end
          object dcTitania: TGLDummyCube
            Tag = 7
            TagFloat = 1.000000000000000000
            CubeSize = 1.000000000000000000
            object Titania: TGLSphere
              Tag = 7
              TagFloat = 1.000000000000000000
              Material.Texture.Disabled = False
              Position.Coordinates = {0000000000000000000080400000803F}
              Radius = 0.250000000000000000
            end
          end
          object dcMiranda: TGLDummyCube
            Tag = 7
            TagFloat = 2.000000000000000000
            CubeSize = 1.000000000000000000
            object Miranda: TGLSphere
              Tag = 7
              TagFloat = 2.000000000000000000
              Material.Texture.Disabled = False
              Position.Coordinates = {0000000000000000000040C00000803F}
              Radius = 0.200000002980232200
            end
          end
        end
        object UranusOrbit: TGLTorus
          Tag = 7
          Direction.Coordinates = {000000000000803F2EBD3BB300000000}
          PitchAngle = 90.000000000000000000
          Up.Coordinates = {000000002EBD3BB3000080BF00000000}
          Visible = False
          Pickable = False
          MajorRadius = 60.000000000000000000
          MinorRadius = 0.029999999329447750
          Rings = 64
          StopAngle = 360.000000000000000000
          Parts = [toSides, toStartDisk, toStopDisk]
        end
      end
      object dcNeptune: TGLDummyCube
        Tag = 8
        CubeSize = 1.000000000000000000
        object Neptune: TGLSphere
          Tag = 8
          Material.Texture.Disabled = False
          Position.Coordinates = {00000000000000000000A0420000803F}
          Radius = 2.099999904632568000
          Slices = 32
          Stacks = 32
          object NeptuneRing: TGLDisk
            Material.BackProperties.Ambient.Color = {0000803FF8FEFE3E000000000000803F}
            Material.BackProperties.Diffuse.Color = {0000803F0000803F0000803F0000803F}
            Material.BackProperties.Emission.Color = {0000803F0000803F0000803F0000803F}
            Material.BackProperties.Specular.Color = {0000803F0000803F0000803F0000803F}
            Material.FrontProperties.Ambient.Color = {0000803F0000803F0000803F0000803F}
            Material.FrontProperties.Diffuse.Color = {0000803F0000803F0000803F0000803F}
            Material.FrontProperties.Specular.Color = {0000803F0000803F0000803F0000803F}
            Material.Texture.Disabled = False
            Material.FaceCulling = fcNoCull
            ObjectsSorting = osRenderNearestFirst
            Direction.Coordinates = {000000000000803F2EBD3BB300000000}
            PitchAngle = 90.000000000000000000
            Up.Coordinates = {000000002EBD3BB3000080BF00000000}
            InnerRadius = 4.000000000000000000
            OuterRadius = 4.199999809265137000
            Slices = 32
            SweepAngle = 360.000000000000000000
          end
          object dcTriton: TGLDummyCube
            Tag = 8
            TagFloat = 1.000000000000000000
            CubeSize = 1.000000000000000000
            object Triton: TGLSphere
              Tag = 8
              TagFloat = 1.000000000000000000
              Material.Texture.Disabled = False
              Position.Coordinates = {00000000000000000000A0400000803F}
              Radius = 0.180000007152557400
            end
          end
        end
        object NeptuneOrbit: TGLTorus
          Tag = 8
          Direction.Coordinates = {000000000000803F2EBD3BB300000000}
          PitchAngle = 90.000000000000000000
          Up.Coordinates = {000000002EBD3BB3000080BF00000000}
          Visible = False
          Pickable = False
          MajorRadius = 80.000000000000000000
          MinorRadius = 0.029999999329447750
          Rings = 64
          StopAngle = 360.000000000000000000
          Parts = [toSides, toStartDisk, toStopDisk]
        end
      end
      object dcPluto: TGLDummyCube
        Tag = 9
        CubeSize = 1.000000000000000000
        object Pluto: TGLSphere
          Tag = 9
          Material.Texture.Disabled = False
          Position.Coordinates = {00000000000000000000C8420000803F}
          Radius = 0.300000011920929000
          Slices = 32
          Stacks = 32
          object dcCharon: TGLDummyCube
            Tag = 9
            TagFloat = 1.000000000000000000
            CubeSize = 1.000000000000000000
            object Charon: TGLSphere
              Tag = 9
              TagFloat = 1.000000000000000000
              Material.Texture.Disabled = False
              Position.Coordinates = {0000000000000000000080BF0000803F}
              Radius = 0.100000001490116100
              Slices = 32
              Stacks = 32
            end
          end
        end
        object PlutoOrbit: TGLTorus
          Tag = 9
          Direction.Coordinates = {000000000000803F2EBD3BB300000000}
          PitchAngle = 90.000000000000000000
          Up.Coordinates = {000000002EBD3BB3000080BF00000000}
          Visible = False
          Pickable = False
          MajorRadius = 100.000000000000000000
          MinorRadius = 0.029999999329447750
          Rings = 64
          StopAngle = 360.000000000000000000
          Parts = [toSides, toStartDisk, toStopDisk]
        end
      end
    end
    object sys_dogl: TGLDirectOpenGL
      Visible = False
      UseBuildList = False
      OnRender = sys_doglRender
      Blend = False
      object axis_lines: TGLLines
        LineWidth = 2.000000000000000000
        Nodes = <
          item
            Color.Color = {0000000039B4483F000000000000803F}
          end
          item
            X = 0.500000000000000000
            Color.Color = {0000000039B4483F000000000000803F}
          end
          item
            Color.Color = {39B4483F00000000000000000000803F}
          end
          item
            Y = 0.500000000000000000
            Color.Color = {39B4483F00000000000000000000803F}
          end
          item
            Color.Color = {000000000000000039B4483F0000803F}
          end
          item
            Z = 0.500000000000000000
            Color.Color = {000000000000000039B4483F0000803F}
          end>
        NodesAspect = lnaInvisible
        SplineMode = lsmSegments
        Options = [loUseNodeColorForLines]
      end
      object bb_lines: TGLLines
        Nodes = <>
        NodesAspect = lnaInvisible
        SplineMode = lsmSegments
        Options = []
      end
    end
  end
  object Cadencer: TGLCadencer
    Scene = Scene
    Mode = cmApplicationIdle
    SleepLength = 1
    OnProgress = CadencerProgress
    Left = 24
    Top = 72
  end
  object AsyncTimer: TGLAsyncTimer
    Enabled = True
    Interval = 800
    OnTimer = AsyncTimerTimer
    Left = 88
    Top = 16
  end
  object SimpleNavigation: TGLSimpleNavigation
    Form = Owner
    GLSceneViewer = SceneViewer
    FormCaption = 'Solar System'
    Options = [snoMouseWheelHandled]
    KeyCombinations = <
      item
        ShiftState = [ssLeft, ssRight]
        Action = snaZoom
      end
      item
        ShiftState = [ssLeft]
        Action = snaMoveAroundTarget
      end
      item
        ShiftState = [ssRight]
        Action = snaMoveAroundTarget
      end>
    Left = 140
    Top = 96
  end
  object MatLib: TGLMaterialLibrary
    Left = 40
    Top = 200
  end
  object FireFXManager: TGLFireFXManager
    FireDir.Coordinates = {00000000000000000000000000000000}
    InitialDir.Coordinates = {00000000000000000000000000000000}
    Cadencer = Cadencer
    MaxParticles = 128
    FireDensity = 0.100000001490116100
    FireEvaporation = 0.500000000000000000
    ParticleLife = 1
    FireRadius = 0.500000000000000000
    Disabled = False
    Paused = False
    ParticleInterval = 0.500000000000000000
    UseInterval = False
    Reference = Sun
    Left = 152
    Top = 256
  end
  object MainMenu: TMainMenu
    Left = 358
    Top = 32
    object File1: TMenuItem
      Caption = '&File'
      object New1: TMenuItem
        Caption = '&New'
      end
      object Open1: TMenuItem
        Caption = '&Open...'
        OnClick = Open1Click
      end
      object Save1: TMenuItem
        Caption = '&Save'
      end
      object SaveAs1: TMenuItem
        Caption = 'Save &As...'
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object Exit1: TMenuItem
        Caption = 'E&xit'
        OnClick = Exit1Click
      end
    end
    object Edit1: TMenuItem
      Caption = '&Edit'
      object Undo1: TMenuItem
        Caption = '&Undo'
        ShortCut = 16474
      end
      object Repeat1: TMenuItem
        Caption = '&Repeat <command>'
      end
      object N6: TMenuItem
        Caption = '-'
      end
      object Cut1: TMenuItem
        Caption = 'Cu&t'
        ShortCut = 16472
      end
      object Copy1: TMenuItem
        Caption = '&Copy'
        ShortCut = 16451
      end
      object Paste1: TMenuItem
        Caption = '&Paste'
        ShortCut = 16470
      end
      object PasteSpecial1: TMenuItem
        Caption = 'Paste &Special...'
      end
      object N5: TMenuItem
        Caption = '-'
      end
      object Find1: TMenuItem
        Caption = '&Find...'
      end
      object Replace1: TMenuItem
        Caption = 'R&eplace...'
      end
      object GoTo1: TMenuItem
        Caption = '&Go To...'
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object Links1: TMenuItem
        Caption = 'Lin&ks...'
      end
      object Object1: TMenuItem
        Caption = '&Object'
      end
    end
    object Window1: TMenuItem
      Caption = '&View'
      object miInnerCore: TMenuItem
        Caption = '&Inner Core'
        OnClick = miInnerCoreClick
      end
      object miOrbitLines: TMenuItem
        Caption = '&Orbit Lines'
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object miHidePanels: TMenuItem
        Caption = '&Hide Panels'
        Checked = True
        OnClick = miHidePanelsClick
      end
    end
    object Help1: TMenuItem
      Caption = '&Help'
      object Contents1: TMenuItem
        Caption = '&Contents'
      end
      object N7: TMenuItem
        Caption = '-'
      end
      object About1: TMenuItem
        Caption = '&About...'
        OnClick = About1Click
      end
    end
  end
  object OpenDialog: TOpenDialog
    Left = 590
    Top = 38
  end
end
