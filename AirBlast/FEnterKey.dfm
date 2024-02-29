object EnterKey: TEnterKey
  Left = 222
  Top = 150
  BorderStyle = bsNone
  Caption = 'EnterKey'
  ClientHeight = 90
  ClientWidth = 249
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Arial'
  Font.Style = [fsBold]
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  OnMouseWheel = FormMouseWheel
  PixelsPerInch = 96
  TextHeight = 19
  object Shape1: TShape
    Left = 0
    Top = 0
    Width = 249
    Height = 90
    Align = alClient
    Brush.Style = bsClear
  end
  object Label1: TLabel
    Left = 8
    Top = 16
    Width = 233
    Height = 19
    Alignment = taCenter
    AutoSize = False
    Caption = 'Type key to use for'
  end
  object LAFunction: TLabel
    Left = 8
    Top = 56
    Width = 233
    Height = 19
    Alignment = taCenter
    AutoSize = False
    Caption = '-'
  end
  object Timer: TTimer
    Enabled = False
    Interval = 10
    OnTimer = TimerTimer
    Left = 24
    Top = 32
  end
end
