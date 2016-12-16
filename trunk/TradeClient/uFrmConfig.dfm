object FrmConfig: TFrmConfig
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #37197#32622
  ClientHeight = 330
  ClientWidth = 461
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  DesignSize = (
    461
    330)
  PixelsPerInch = 96
  TextHeight = 13
  object Label8: TLabel
    Left = 32
    Top = 183
    Width = 48
    Height = 13
    Caption = #28216#25103#30446#24405
  end
  object Label10: TLabel
    Left = 8
    Top = 205
    Width = 72
    Height = 13
    Caption = #25130#22270#23384#25918#30446#24405
  end
  object Label30: TLabel
    Left = 8
    Top = 31
    Width = 60
    Height = 13
    Caption = #21457#36135#26426#26631#35782
  end
  object Bevel2: TBevel
    Left = 42
    Top = 15
    Width = 414
    Height = 2
    Anchors = [akLeft, akTop, akRight]
  end
  object Label31: TLabel
    Left = 6
    Top = 7
    Width = 36
    Height = 13
    Caption = #21457#36135#26426
  end
  object Bevel3: TBevel
    Left = 6
    Top = 143
    Width = 450
    Height = 2
    Anchors = [akLeft, akTop, akRight]
  end
  object Bevel5: TBevel
    Left = 6
    Top = 234
    Width = 450
    Height = 2
    Anchors = [akLeft, akTop, akRight]
  end
  object Label2: TLabel
    Left = 113
    Top = 116
    Width = 48
    Height = 13
    Caption = #29992#25143#21517#65306
  end
  object Label3: TLabel
    Left = 298
    Top = 116
    Width = 36
    Height = 13
    Caption = #23494#30721#65306
  end
  object Label5: TLabel
    Left = 41
    Top = 73
    Width = 46
    Height = 13
    Caption = 'IP'#22320#22336#65306
  end
  object Label6: TLabel
    Left = 298
    Top = 73
    Width = 36
    Height = 13
    Caption = #31471#21475#65306
  end
  object Label7: TLabel
    Left = 6
    Top = 52
    Width = 36
    Height = 13
    Caption = #25511#21046#21488
  end
  object Bevel8: TBevel
    Left = 42
    Top = 59
    Width = 414
    Height = 2
    Anchors = [akLeft, akTop, akRight]
  end
  object Label1: TLabel
    Left = 6
    Top = 93
    Width = 36
    Height = 13
    Caption = #25511#21046#21488
  end
  object Bevel1: TBevel
    Left = 42
    Top = 100
    Width = 414
    Height = 2
    Anchors = [akLeft, akTop, akRight]
  end
  object Bevel4: TBevel
    Left = 6
    Top = 280
    Width = 450
    Height = 2
    Anchors = [akLeft, akTop, akRight]
  end
  object Label4: TLabel
    Left = 32
    Top = 160
    Width = 48
    Height = 13
    Caption = #23487#20027#31243#24207
  end
  object edtGameDir: TEdit
    Left = 82
    Top = 179
    Width = 327
    Height = 21
    TabOrder = 0
  end
  object btnSelGameDir: TButton
    Left = 415
    Top = 180
    Width = 26
    Height = 21
    Caption = '...'
    TabOrder = 1
    OnClick = btnSelGameDirClick
  end
  object edtCapture: TEdit
    Left = 82
    Top = 201
    Width = 327
    Height = 21
    TabOrder = 2
  end
  object btnSelCaptureDir: TButton
    Tag = 1
    Left = 415
    Top = 202
    Width = 26
    Height = 21
    Caption = '...'
    TabOrder = 3
    OnClick = btnSelGameDirClick
  end
  object edtGroupName: TEdit
    Left = 70
    Top = 28
    Width = 371
    Height = 21
    TabOrder = 4
  end
  object chkAutoReConn: TCheckBox
    Left = 37
    Top = 249
    Width = 97
    Height = 17
    Caption = #33258#21160#37325#36830
    TabOrder = 5
  end
  object chkMultiRoleFlip: TCheckBox
    Left = 155
    Top = 249
    Width = 97
    Height = 17
    Caption = #22810#35282#33394#32763#39029
    TabOrder = 6
  end
  object chkAutoRun: TCheckBox
    Left = 298
    Top = 249
    Width = 97
    Height = 17
    Caption = #24320#26426#33258#21160#21551#21160
    TabOrder = 7
  end
  object edtDama2User: TEdit
    Left = 155
    Top = 112
    Width = 137
    Height = 21
    TabOrder = 8
  end
  object edtDama2Pwd: TEdit
    Left = 332
    Top = 112
    Width = 109
    Height = 21
    PasswordChar = '*'
    TabOrder = 9
  end
  object chkUseDama2: TCheckBox
    Left = 26
    Top = 114
    Width = 84
    Height = 17
    Caption = #25171#30721#20820#31572#39064
    TabOrder = 10
  end
  object edtConsoleHost: TEdit
    Left = 83
    Top = 69
    Width = 208
    Height = 21
    TabOrder = 11
  end
  object edtConsolePort: TSpinEdit
    Left = 332
    Top = 68
    Width = 109
    Height = 22
    MaxValue = 65535
    MinValue = 0
    TabOrder = 12
    Value = 0
  end
  object btnSave: TButton
    Left = 287
    Top = 294
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = #20445#23384
    TabOrder = 13
    OnClick = btnSaveClick
  end
  object btnCancel: TButton
    Left = 368
    Top = 294
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = #21462#28040
    ModalResult = 2
    TabOrder = 14
  end
  object edtTheHost: TEdit
    Left = 82
    Top = 156
    Width = 327
    Height = 21
    TabOrder = 15
  end
  object btnSelTheHost: TButton
    Left = 415
    Top = 157
    Width = 26
    Height = 21
    Caption = '...'
    TabOrder = 16
    OnClick = btnSelTheHostClick
  end
end
