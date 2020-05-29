object Form1: TForm1
  Left = 198
  Top = 153
  Caption = 'Smarties'
  ClientHeight = 533
  ClientWidth = 697
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  WindowState = wsMaximized
  PixelsPerInch = 96
  TextHeight = 13
  object GLSceneViewer1: TGLSceneViewer
    Left = 0
    Top = 0
    Width = 584
    Height = 533
    Camera = GLCamera1
    FieldOfView = 158.747711181640600000
    Align = alClient
    OnMouseDown = GLSceneViewer1MouseDown
    OnMouseMove = GLSceneViewer1MouseMove
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 584
    Top = 0
    Width = 113
    Height = 533
    Align = alRight
    TabOrder = 1
    object rgRotationAngle: TRadioGroup
      Left = 16
      Top = 16
      Width = 89
      Height = 105
      Caption = 'Rotation'
      ItemIndex = 0
      Items.Strings = (
        'None'
        'Turn'
        'Pitch'
        'Roll')
      TabOrder = 0
      OnClick = rgRotationAngleClick
    end
  end
  object GLScene1: TGLScene
    Left = 16
    Top = 8
    object GLLightSource1: TGLLightSource
      Ambient.Color = {77BE1F3F39B4283F1283003F0000803F}
      ConstAttenuation = 1.000000000000000000
      Position.Coordinates = {0000803F0000C040000000000000803F}
      SpotCutOff = 180.000000000000000000
    end
    object DummyCube1: TGLDummyCube
      ShowAxes = True
      CubeSize = 1.000000000000000000
      object Cyl: TGLCylinder
        Direction.Coordinates = {000000000000803F2EBD3BB300000000}
        Position.Coordinates = {0AD7233ECDCC4CBF000000000000803F}
        Up.Coordinates = {000080BF2EBD3B272EBD3B3300000000}
        BottomRadius = 0.500000000000000000
        Height = 0.500000000000000000
        Slices = 64
        TopRadius = 0.500000000000000000
        object levres: TGLTorus
          Material.FrontProperties.Emission.Color = {0000803F00000000000000000000803F}
          Direction.Coordinates = {2EBD3BB30000803F2EBD3B2700000000}
          Position.Coordinates = {00000000CDCC4CBE000000000000803F}
          Up.Coordinates = {000080BF2EBD3BB32EBD3B3300000000}
          MajorRadius = 0.550000011920929000
          MinorRadius = 0.119999997317791000
          Sides = 64
          StopAngle = 360.000000000000000000
          Parts = [toSides, toStartDisk, toStopDisk]
        end
      end
      object oeil1: TGLSphere
        Material.FrontProperties.Emission.Color = {A5A4243F00000000000000000000803F}
        Position.Coordinates = {CDCC4C3E0000803FCDCC4C3F0000803F}
        Radius = 0.400000005960464500
        Slices = 64
        Stacks = 64
      end
      object oeil2: TGLSphere
        Material.FrontProperties.Emission.Color = {A5A4243F00000000000000000000803F}
        Position.Coordinates = {CDCC4C3E0000803FCDCC4CBF0000803F}
        Radius = 0.400000005960464500
        Slices = 64
        Stacks = 64
      end
      object Tete: TGLSphere
        Material.FrontProperties.Emission.Color = {9897173FEFEEEE3E000000000000803F}
        Scale.Coordinates = {CDCC4C3E0000803F0000803F00000000}
        Radius = 2.000000000000000000
        Slices = 64
        Stacks = 64
        object Cone1: TGLCone
          Material.FrontProperties.Emission.Color = {AFAE2E3FEFEEEE3E000000000000803F}
          Position.Coordinates = {CDCCCC3F0000003F000000000000803F}
          Scale.Coordinates = {000080400000803F0000803F00000000}
          Up.Coordinates = {CFE654BEE1677A3F0000000000000000}
          BottomRadius = 0.500000000000000000
          Height = 1.000000000000000000
          Slices = 64
        end
        object cheveu1: TGLCylinder
          Direction.Coordinates = {00000000010000BFD7B35D3F00000000}
          Position.Coordinates = {0000003F000000400000003F0000803F}
          Scale.Coordinates = {0000A0400000803F0000803F00000000}
          Up.Coordinates = {00000000D7B35D3F0100003F00000000}
          BottomRadius = 0.019999999552965160
          Height = 2.000000000000000000
          TopRadius = 0.019999999552965160
        end
        object cheveu2: TGLCylinder
          Direction.Coordinates = {00000000FFFFFF3ED7B35D3F00000000}
          Position.Coordinates = {0000003F00000040000000BF0000803F}
          Scale.Coordinates = {0000A0400000803F0000803F00000000}
          Up.Coordinates = {00000000D7B35D3FFFFFFFBE00000000}
          BottomRadius = 0.019999999552965160
          Height = 2.000000000000000000
          TopRadius = 0.019999999552965160
        end
        object Sourcil1: TGLTorus
          Direction.Coordinates = {D8B35D3FC2976433FFFFFF3E00000000}
          Position.Coordinates = {CDCC4C3F6666A63FCDCC4C3F0000803F}
          Up.Coordinates = {5C1CFCB20000803FEBD96EB300000000}
          MajorRadius = 0.400000005960464500
          MinorRadius = 0.100000001490116100
          Rings = 32
          Sides = 64
          StopAngle = 360.000000000000000000
          Parts = [toSides, toStartDisk, toStopDisk]
        end
        object Sourcil2: TGLTorus
          Direction.Coordinates = {D7B35D3FA32224B1000000BF00000000}
          Position.Coordinates = {CDCC4C3F6666A63FCDCC4CBF0000803F}
          Up.Coordinates = {5C1CFCB20000803FEBD96EB300000000}
          MajorRadius = 0.400000005960464500
          MinorRadius = 0.100000001490116100
          Rings = 32
          Sides = 64
          StopAngle = 360.000000000000000000
          Parts = [toSides, toStartDisk, toStopDisk]
        end
      end
      object Pupil1: TGLSphere
        Position.Coordinates = {0000003F0000803FCDCC4C3F0000803F}
        Radius = 0.200000002980232200
      end
      object Pupil2: TGLSphere
        Position.Coordinates = {0000003F0000803FCDCC4CBF0000803F}
        Radius = 0.200000002980232200
      end
    end
    object GLCamera1: TGLCamera
      DepthOfView = 100.000000000000000000
      FocalLength = 50.000000000000000000
      TargetObject = DummyCube1
      Position.Coordinates = {000080400000803F000000000000803F}
    end
  end
  object Timer1: TTimer
    Interval = 25
    OnTimer = Timer1Timer
    Left = 96
    Top = 16
  end
  object GLCadencer1: TGLCadencer
    OnProgress = GLCadencer1Progress
    Left = 24
    Top = 80
  end
end
