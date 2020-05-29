object MeshShowFrm: TMeshShowFrm
  Left = 122
  Top = 59
  Caption = 'Mesh Show'
  ClientHeight = 398
  ClientWidth = 668
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010001002020100000000000E80200001600000028000000200000004000
    0000010004000000000080020000000000000000000000000000000000000000
    0000000080000080000000808000800000008000800080800000C0C0C0008080
    80000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    0009999999999999999999999999000000999999999999999999999999990000
    0991111111111111111111111111000099111111111111111111111111110009
    9111111111111111111111111111999911111111111111111111111111119991
    1111111111111111111111111111991EE11EE11EEE11EEEEE11EEE111111991E
    E11EE1EEEEE1EEEEE1EEEEE11111991EE11EE1EE1EE1EE1111EE1EE11111991E
    E11EE1EE1EE1EE1111EE1EE11111991EEEEEE1EE1EE1EE1111EE1EE11111991E
    EEEEE1EE1EE1EE1111EE1EE11111991EE11EE1EE1EE1EE1111EE1EE11111991E
    E11EE1EEEEE1EE1111EEEEE11111991EE11EE11EEE11EE11111EEE1111119911
    1111111111111111111111111111991EEEE1111111111111111EEE1E1111991E
    EEE111EE111111EE1E1E1E1E11EE991EE1EEE1E11E1E11EEEE1E1E1E11E1991E
    E1E1E1E11E1E11EE1E1EEE1E11EE991EE1E1E1EE1EEE11E1E11E111E11E1991E
    E1EEE1111E1E11E1111E111E11EE991EE111111111E11EEE111E111E11119911
    1111111111111111111111111111991EE1E111E1E11E11EEE11EEEE11111991E
    E1E111E1E11E1E11E11E11111111991EE1E111E1E11E1E11E11E11111111991E
    E1E111E1E11E1E11111EEE111111991EE1E1E1E11EE11E11111E11111111991E
    E1EEEEE11EE11E11E11E11111111991EE1EE1EE11EE11EEE111EEEE11111FE00
    0000FC000000F8000000F0000000E00000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    000000000000000000000000000000000000000000000000000000000000}
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  ShowHint = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnMouseWheel = FormMouseWheel
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 209
    Top = 0
    Height = 379
    ExplicitHeight = 369
  end
  object Scn: TGLSceneViewer
    Left = 212
    Top = 0
    Width = 456
    Height = 379
    Camera = GLCamera1
    BeforeRender = ScnBeforeRender
    FieldOfView = 150.438476562500000000
    PenAsTouch = False
    Align = alClient
    OnMouseDown = ScnMouseDown
    OnMouseMove = ScnMouseMove
    OnMouseUp = ScnMouseUp
    TabOrder = 0
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 379
    Width = 668
    Height = 19
    Panels = <
      item
        Width = 200
      end
      item
        Width = 100
      end
      item
        Width = 100
      end
      item
        Width = 100
      end
      item
        Width = 50
      end>
  end
  object ControlPanel: TPanel
    Left = 0
    Top = 0
    Width = 209
    Height = 379
    Align = alLeft
    BevelInner = bvLowered
    TabOrder = 2
    object PageControl1: TPageControl
      Left = 2
      Top = 2
      Width = 205
      Height = 375
      ActivePage = TabSheet1
      Align = alClient
      TabOrder = 0
      object TabSheet1: TTabSheet
        Caption = 'Control'
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object Label6: TLabel
          Left = 8
          Top = 192
          Width = 86
          Height = 13
          Caption = 'Camera X Position'
        end
        object Label2: TLabel
          Left = 8
          Top = 8
          Width = 68
          Height = 13
          Caption = 'Polygon Mode'
        end
        object GroupBox2: TGroupBox
          Left = 8
          Top = 248
          Width = 169
          Height = 65
          Caption = 'Movement Direction'
          TabOrder = 0
          object rbXY: TRadioButton
            Left = 8
            Top = 24
            Width = 113
            Height = 17
            Caption = 'Move on X, Y axis'
            Checked = True
            TabOrder = 0
            TabStop = True
          end
          object rbZY: TRadioButton
            Left = 8
            Top = 40
            Width = 113
            Height = 17
            Caption = 'Move on Z, Y axis'
            TabOrder = 1
          end
        end
        object tbPos: TTrackBar
          Left = 8
          Top = 208
          Width = 169
          Height = 33
          Max = 20
          Position = 5
          TabOrder = 1
          OnChange = tbPosChange
        end
        object GroupBox1: TGroupBox
          Left = 8
          Top = 80
          Width = 169
          Height = 105
          Caption = 'Axis'
          TabOrder = 2
          object Bevel1: TBevel
            Left = 8
            Top = 40
            Width = 153
            Height = 2
            Shape = bsBottomLine
          end
          object Label3: TLabel
            Left = 8
            Top = 48
            Width = 58
            Height = 13
            Caption = 'Axis Legend'
          end
          object Label4: TLabel
            Left = 8
            Top = 72
            Width = 29
            Height = 13
            Caption = 'X Axis'
            Color = clBtnFace
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clRed
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentColor = False
            ParentFont = False
          end
          object Label5: TLabel
            Left = 48
            Top = 72
            Width = 29
            Height = 13
            Caption = 'Y Axis'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clGreen
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object Label7: TLabel
            Left = 88
            Top = 72
            Width = 29
            Height = 13
            Caption = 'Z Axis'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object chbShowAxis: TCheckBox
            Left = 8
            Top = 16
            Width = 153
            Height = 17
            Caption = 'Show central axis'
            Checked = True
            State = cbChecked
            TabOrder = 0
            OnClick = chbShowAxisClick
          end
        end
        object chbViewPoints: TCheckBox
          Left = 8
          Top = 56
          Width = 121
          Height = 17
          Caption = 'View vertex points'
          Checked = True
          State = cbChecked
          TabOrder = 3
          OnClick = chbViewPointsClick
        end
        object cbPolygonMode: TComboBox
          Left = 8
          Top = 24
          Width = 145
          Height = 21
          Style = csDropDownList
          TabOrder = 4
          OnChange = cbPolygonModeChange
          Items.Strings = (
            'Fill'
            'Lines / mesh'
            'Points')
        end
      end
      object TabSheet2: TTabSheet
        Caption = 'Attributes'
        ImageIndex = 1
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
      end
      object TabSheet3: TTabSheet
        Caption = 'Data'
        ImageIndex = 2
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object Label1: TLabel
          Left = 16
          Top = 90
          Width = 100
          Height = 13
          Caption = 'Subdivision Iterations'
        end
        object TrackBar1: TTrackBar
          Left = 16
          Top = 104
          Width = 113
          Height = 22
          Max = 5
          Position = 3
          TabOrder = 0
          ThumbLength = 10
          OnChange = TrackBar1Change
        end
        object GroupBox3: TGroupBox
          Left = 0
          Top = 8
          Width = 169
          Height = 81
          Caption = 'Mesh Data'
          TabOrder = 1
          object btnVertex: TBitBtn
            Left = 4
            Top = 16
            Width = 75
            Height = 25
            Caption = 'Vertex'
            TabOrder = 0
            OnClick = btnVertexClick
          end
          object btnNormals: TBitBtn
            Left = 4
            Top = 48
            Width = 75
            Height = 25
            Caption = 'Normals'
            TabOrder = 1
            OnClick = btnNormalsClick
          end
          object btnTextcoords: TBitBtn
            Left = 79
            Top = 16
            Width = 86
            Height = 25
            Caption = 'Tex-Coords'
            TabOrder = 2
            OnClick = btnTextcoordsClick
          end
          object btnGroups: TBitBtn
            Left = 79
            Top = 48
            Width = 86
            Height = 25
            Caption = 'Triangle Count'
            TabOrder = 3
            OnClick = btnGroupsClick
          end
        end
      end
    end
  end
  object GLScene1: TGLScene
    Left = 264
    Top = 16
    object GLFreeForm1: TGLFreeForm
      object GLCamera1: TGLCamera
        DepthOfView = 100.000000000000000000
        FocalLength = 50.000000000000000000
        TargetObject = GLFreeForm1
        Position.Coordinates = {0000803F00000040000040400000803F}
        object GLLightSource1: TGLLightSource
          ConstAttenuation = 1.000000000000000000
          SpotCutOff = 180.000000000000000000
        end
      end
    end
    object GLDummyCube1: TGLDummyCube
      CubeSize = 1.000000000000000000
    end
    object dcModifiers: TGLDummyCube
      CubeSize = 1.000000000000000000
    end
  end
  object MainMenu1: TMainMenu
    Left = 360
    Top = 16
    object File1: TMenuItem
      Caption = 'File'
      object Open1: TMenuItem
        Caption = 'Open...'
        OnClick = Open1Click
      end
      object Save1: TMenuItem
        Caption = 'Save...'
        OnClick = Save1Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Exit1: TMenuItem
        Caption = 'Exit'
        OnClick = Exit1Click
      end
    end
    object Edit1: TMenuItem
      Caption = 'Edit'
      object ViewControlPanel: TMenuItem
        Caption = 'View Control Panel'
        Checked = True
        OnClick = ViewControlPanelClick
      end
    end
  end
  object OpenDialog1: TOpenDialog
    Filter = 'Holographics|*.hgx'
    Left = 264
    Top = 80
  end
  object SaveDialog1: TSaveDialog
    Filter = 'Holographics|*.hgx'
    Left = 360
    Top = 80
  end
end
