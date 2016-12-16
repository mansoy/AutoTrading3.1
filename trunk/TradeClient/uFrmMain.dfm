object FrmMain: TFrmMain
  Left = 0
  Top = 0
  ActiveControl = btnStart
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'DToolClient'
  ClientHeight = 97
  ClientWidth = 224
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object btnStart: TButton
    Left = 32
    Top = 32
    Width = 75
    Height = 25
    Caption = 'Start'
    TabOrder = 0
    OnClick = btnStartClick
  end
  object btnConfig: TButton
    Left = 113
    Top = 32
    Width = 75
    Height = 25
    Caption = 'Config'
    TabOrder = 1
    OnClick = btnConfigClick
  end
  object Timer1: TTimer
    Interval = 5000
    OnTimer = Timer1Timer
    Left = 152
    Top = 56
  end
end
