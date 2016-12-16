unit uFrmConfig;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Samples.Spin, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TFrmConfig = class(TForm)
    Label8: TLabel;
    Label10: TLabel;
    Label30: TLabel;
    Bevel2: TBevel;
    Label31: TLabel;
    Bevel3: TBevel;
    Bevel5: TBevel;
    Label2: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Bevel8: TBevel;
    edtGameDir: TEdit;
    btnSelGameDir: TButton;
    edtCapture: TEdit;
    btnSelCaptureDir: TButton;
    edtGroupName: TEdit;
    chkAutoReConn: TCheckBox;
    chkMultiRoleFlip: TCheckBox;
    chkAutoRun: TCheckBox;
    edtDama2User: TEdit;
    edtDama2Pwd: TEdit;
    chkUseDama2: TCheckBox;
    edtConsoleHost: TEdit;
    edtConsolePort: TSpinEdit;
    Label1: TLabel;
    Bevel1: TBevel;
    Bevel4: TBevel;
    btnSave: TButton;
    btnCancel: TButton;
    Label4: TLabel;
    edtTheHost: TEdit;
    btnSelTheHost: TButton;
    procedure btnSaveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnSelTheHostClick(Sender: TObject);
    procedure btnSelGameDirClick(Sender: TObject);
  private
    { Private declarations }
    {$REGION '配置'}
    function Data2UI: Boolean;
    function UI2Data: Boolean;
    {$ENDREGION}
  public
    { Public declarations }
  end;

var
  FrmConfig: TFrmConfig;

implementation

uses
  System.Win.Registry
  , System.IniFiles
  , Vcl.FileCtrl
  , uGlobal
  , ManSoy.MsgBox
  , ManSoy.Global
  , ManSoy.Encode
  ;

{$R *.dfm}

procedure TFrmConfig.btnSaveClick(Sender: TObject);
begin
  try
    if (Trim(edtGroupName.Text) = '') then
    begin
      ManSoy.MsgBox.WarnMsg(Self.Handle, '请填写发货机编号!', []);
      Exit;
    end;

    if (Trim(edtConsoleHost.Text) = '') or (edtConsolePort.Value = 0) then
    begin
      ManSoy.MsgBox.WarnMsg(Self.Handle, '请填写控制台信息!', []);
      Exit;
    end;

    if (Trim(edtDama2User.Text) = '') or (Trim(edtDama2Pwd.Text) = '') then
    begin
      ManSoy.MsgBox.WarnMsg(Self.Handle, '请填写打码兔账号和密码!', []);
      Exit;
    end;

    if Trim(edtGameDir.Text) = '' then
    begin
      ManSoy.MsgBox.WarnMsg(Self.Handle, '游戏目录不能为空!', []);
      Exit;
    end;

    if Trim(edtTheHost.Text) = '' then
    begin
      ManSoy.MsgBox.WarnMsg(Self.Handle, '必须选择宿主程序不能为空!', []);
      Exit;
    end;

    if Trim(edtCapture.Text) = '' then
    begin
      ManSoy.MsgBox.WarnMsg(Self.Handle, '截图存放目录不能为空!', []);
      Exit;
    end;
    UI2Data;
    SaveCfg;
    Self.ModalResult := mrOk;
  except

  end;
end;

procedure TFrmConfig.btnSelGameDirClick(Sender: TObject);
var
  sDir, sTitle: string;
begin
  if TButton(Sender).Tag = 0 then
    sTitle := '请选择DNF游戏目录'
  else
    sTitle := '请选择截图存放目录';

  if Vcl.FileCtrl.SelectDirectory(sTitle, '', sDir) then
  begin
    if TButton(Sender).Tag = 0 then
      edtGameDir.Text := Trim(sDir)
    else
      edtCapture.Text := Trim(sDir);
  end;
end;

procedure TFrmConfig.btnSelTheHostClick(Sender: TObject);
begin
  With TOpenDialog.Create(nil) do
  try
    Filter := '可执行文件|*.exe';
    if Execute then
    begin
      edtTheHost.Text := FileName;
    end;
  finally
    Free;
  end;
end;

function TFrmConfig.Data2UI: Boolean;
begin
  Result := False;
  try
    edtGroupName.Text           := GSharedInfo.ClientSet.GroupName;
    edtTheHost.Text             := GSharedInfo.ClientSet.TheHost;
    edtGameDir.Text             := GSharedInfo.ClientSet.GamePath;
    edtCapture.Text             := GSharedInfo.ClientSet.Capture;
    //-------------------------------------------------------------------------
    edtConsoleHost.Text         := GSharedInfo.ClientSet.ConsoleHost;
    edtConsolePort.Value        := GSharedInfo.ClientSet.ConsolePort;
    //-------------------------------------------------------------------------
    chkUseDama2.Checked         := GSharedInfo.ClientSet.UseDama2;
    edtDama2User.Text           := GSharedInfo.ClientSet.Dama2User;
    edtDama2Pwd.Text            := GSharedInfo.ClientSet.Dama2Pwd;
    //-------------------------------------------------------------------------
    chkAutoReConn.Checked       := GSharedInfo.ClientSet.AutoConn;
    chkMultiRoleFlip.Checked    := GSharedInfo.ClientSet.MutiRoleFenYe;
    chkAutoRun.Checked          := GSharedInfo.ClientSet.AutoRun;
    if Trim(edtCapture.Text) = '' then edtCapture.Text := Format('%s\Capture',[ExtractFileDir(ParamStr(0))]);
    Result := True;
  except

  end;
end;

procedure TFrmConfig.FormCreate(Sender: TObject);
begin
  //LoadCfg;
  Data2UI;
end;

function TFrmConfig.UI2Data: Boolean;
begin
  Result := False;
  try
    GSharedInfo.ClientSet.GroupName         := Trim(edtGroupName.Text);
    GSharedInfo.ClientSet.TheHost           := Trim(edtTheHost.Text);
    GSharedInfo.ClientSet.GamePath          := Trim(edtGameDir.Text);
    GSharedInfo.ClientSet.Capture           := Trim(edtCapture.Text);
    //----------------------------------
    GSharedInfo.ClientSet.ConsoleHost       := Trim(edtConsoleHost.Text);
    GSharedInfo.ClientSet.ConsolePort       := edtConsolePort.Value;
    //----------------------------------
    GSharedInfo.ClientSet.UseDama2          := chkUseDama2.Checked;
    GSharedInfo.ClientSet.Dama2User         := Trim(edtDama2User.Text);
    GSharedInfo.ClientSet.Dama2Pwd          := Trim(edtDama2Pwd.Text);
    //----------------------------------
    GSharedInfo.ClientSet.AutoConn          := chkAutoReConn.Checked;
    GSharedInfo.ClientSet.MutiRoleFenYe     := chkMultiRoleFlip.Checked;
    GSharedInfo.ClientSet.AutoRun           := chkAutoRun.Checked;
    Result := True;
  except

  end;
end;

end.
