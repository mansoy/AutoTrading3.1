object FrmMain: TFrmMain
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'QQ'#35299#23433#20840
  ClientHeight = 183
  ClientWidth = 351
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 26
    Top = 32
    Width = 24
    Height = 13
    Caption = #36134#21495
  end
  object Label2: TLabel
    Left = 16
    Top = 8
    Width = 35
    Height = 13
    Caption = #28216#25103'ID'
  end
  object Label3: TLabel
    Left = 183
    Top = 35
    Width = 24
    Height = 13
    Caption = #23494#30721
  end
  object Label4: TLabel
    Left = 38
    Top = 64
    Width = 12
    Height = 13
    Caption = #21306
  end
  object Label5: TLabel
    Left = 195
    Top = 61
    Width = 12
    Height = 13
    Caption = #26381
  end
  object Label6: TLabel
    Left = 183
    Top = 8
    Width = 48
    Height = 13
    Caption = #20196#29260#31867#22411
  end
  object btnOn: TButton
    Left = 236
    Top = 134
    Width = 107
    Height = 41
    Caption = #35299#23433#20840
    TabOrder = 0
    OnClick = btnOnClick
  end
  object edtGameId: TEdit
    Left = 56
    Top = 5
    Width = 121
    Height = 21
    ImeName = #20013#25991'('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    TabOrder = 1
    Text = '0'
  end
  object edtAccount: TEdit
    Left = 56
    Top = 32
    Width = 121
    Height = 21
    ImeName = #20013#25991'('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    TabOrder = 2
    Text = '1767460005'
  end
  object edtPwd: TEdit
    Left = 213
    Top = 35
    Width = 121
    Height = 21
    ImeName = #20013#25991'('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    TabOrder = 3
    Text = '123456a'
  end
  object edtArea: TEdit
    Left = 56
    Top = 59
    Width = 121
    Height = 21
    ImeName = #20013#25991'('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    TabOrder = 4
    Text = #30005#20449
  end
  object edtServer: TEdit
    Left = 213
    Top = 61
    Width = 121
    Height = 21
    ImeName = #20013#25991'('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    TabOrder = 5
    Text = #38485#35199'1'#21306
  end
  object cbbMBType: TComboBox
    Left = 237
    Top = 8
    Width = 102
    Height = 21
    ImeName = #20013#25991'('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    TabOrder = 6
    Text = '50'
    Items.Strings = (
      '10'
      '20'
      '30'
      '40'
      '50')
  end
  object edtIType: TEdit
    Left = 56
    Top = 96
    Width = 121
    Height = 21
    TabOrder = 7
    Text = '1'
  end
  object edtKey: TEdit
    Left = 216
    Top = 96
    Width = 121
    Height = 21
    TabOrder = 8
  end
end
