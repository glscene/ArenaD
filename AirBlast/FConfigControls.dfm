object ConfigControls: TConfigControls
  Left = 144
  Top = 101
  BorderStyle = bsNone
  Caption = 'ConfigControls'
  ClientHeight = 509
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clBtnText
  Font.Height = -16
  Font.Name = 'Arial'
  Font.Style = [fsBold]
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  PixelsPerInch = 120
  TextHeight = 19
  object Shape1: TShape
    Left = 0
    Top = 0
    Width = 635
    Height = 509
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alClient
    Brush.Style = bsClear
  end
  object LATitle: TLabel
    Left = 10
    Top = 10
    Width = 175
    Height = 19
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Controls Configuration'
  end
  object Label2: TLabel
    Left = 10
    Top = 50
    Width = 55
    Height = 16
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Function'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBtnText
    Font.Height = -14
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label3: TLabel
    Left = 240
    Top = 50
    Width = 98
    Height = 16
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Alignment = taCenter
    Caption = 'Primary Control'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBtnText
    Font.Height = -14
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label4: TLabel
    Left = 380
    Top = 50
    Width = 118
    Height = 16
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Secondary Control'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBtnText
    Font.Height = -14
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object ToolBar1: TToolBar
    Left = 530
    Top = 80
    Width = 101
    Height = 221
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alNone
    ButtonHeight = 27
    ButtonWidth = 82
    Caption = 'ToolBar1'
    Color = clBtnFace
    Font.Charset = ANSI_CHARSET
    Font.Color = clBtnText
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    ShowCaptions = True
    TabOrder = 0
    object TBApply: TToolButton
      Left = 0
      Top = 0
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = '    Apply    '
      ImageIndex = 0
      Wrap = True
      OnClick = TBApplyClick
    end
    object TToolButton
      Left = 0
      Top = 27
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Enabled = False
      ImageIndex = 1
      Wrap = True
    end
    object TBCancel: TToolButton
      Left = 0
      Top = 54
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Cancel'
      ImageIndex = 2
      Wrap = True
      OnClick = TBCancelClick
    end
    object TToolButton
      Left = 0
      Top = 81
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      ImageIndex = 3
      Wrap = True
    end
    object TToolButton
      Left = 0
      Top = 108
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      ImageIndex = 4
      Wrap = True
    end
    object TBLoad: TToolButton
      Left = 0
      Top = 135
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Load'
      ImageIndex = 5
      Wrap = True
      OnClick = TBLoadClick
    end
    object TBSave: TToolButton
      Left = 0
      Top = 162
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Save'
      ImageIndex = 6
      OnClick = TBSaveClick
    end
  end
  object ListBox: TListBox
    Left = 10
    Top = 70
    Width = 511
    Height = 425
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Style = lbOwnerDrawFixed
    BorderStyle = bsNone
    Color = clBtnHighlight
    Font.Charset = ANSI_CHARSET
    Font.Color = clBtnText
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 25
    ParentFont = False
    TabOrder = 1
    OnDblClick = ListBoxDblClick
    OnDrawItem = ListBoxDrawItem
    OnMouseDown = ListBoxMouseDown
  end
  object OpenDialog: TOpenDialog
    Filter = 'Controls Configuration (*.keys)|*.keys'
    Options = [ofHideReadOnly, ofFileMustExist, ofEnableSizing]
    Left = 192
    Top = 8
  end
  object SaveDialog: TSaveDialog
    Filter = 'Controls Configuration (*.keys)|*.keys'
    Options = [ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Left = 232
    Top = 8
  end
end
