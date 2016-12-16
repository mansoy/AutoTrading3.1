program DToolClient;

uses
  EMemLeaks,
  EResLeaks,
  EDialogWinAPIMSClassic,
  EDialogWinAPIEurekaLogDetailed,
  EDialogWinAPIStepsToReproduce,
  EDebugExports,
  EFixSafeCallException,
  EMapWin32,
  EAppVCL,
  ExceptionLog7,
  Vcl.Forms,
  System.IniFiles,
  System.SysUtils,
  uFrmMain in 'uFrmMain.pas' {FrmMain},
  uFrmConfig in 'uFrmConfig.pas' {FrmConfig},
  uGlobal in '..\Comm\uGlobal.pas',
  uJsonClass in '..\Comm\uJsonClass.pas',
  SuperObject in '..\Comm\SuperObject.pas',
  ManSoy.Encode in '..\Global\ManSoy.Encode.pas',
  ManSoy.Global in '..\Global\ManSoy.Global.pas',
  ManSoy.MsgBox in '..\Global\ManSoy.MsgBox.pas';

{$R *.res}

//function SetAppPath: Boolean;
//var
//  iniFile: TIniFile;
//  CfgPath: string;
//begin
//  CfgPath := GetAppdataPath;
//  CfgPath := CfgPath + 'TradeClient\';
//  if not DirectoryExists(CfgPath) then
//    ForceDirectories(CfgPath);
//
//  iniFile := TIniFile.Create(CfgPath + 'LocalCfg.ini');
//  try
//    iniFile.WriteString('设置', '发货机路径', ExtractFilePath(ParamStr(0)));
//  finally
//    FreeAndNil(iniFile);
//  end;
//end;

begin
  //SetAppPath();
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmMain, FrmMain);
  Application.Run;
end.
