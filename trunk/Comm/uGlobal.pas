unit uGlobal;

interface

uses
  Windows, Messages, System.SysUtils, Generics.Collections, System.Classes,
  uJsonClass, QLog
  ;

const
  RetOK = 1;
  RetErr = 0;

const
  //����̨
  WM_ADD_LOG              = WM_USER + 1001;
  //--ע��:
  WM_HOOK_ON              = WM_USER + 1006;

  WM_ADD_SEND_MACHINE     = WM_USER + 2001;
  WM_DEL_SEND_MACHINE     = WM_USER + 2003;
  WM_ADD_ORDER            = WM_USER + 2006;
  WM_DEL_ORDER            = WM_USER + 2007;
  //--------------------------------------------
  WM_UPDATE_CONN_UI       = WM_USER + 2011;
  WM_UPDATE_TASK_UI       = WM_USER + 2012;
  //--------------------------------------------
  WM_DIS_CONN             = WM_USER + 2021;   //--�������Ͽ�����

type
  //״̬ ��0��ʼ����,1���,2���ڷ���,3,��ͣ��,4ʧ��,5��������
  TTaskState = (tsNormal = 100, tsStart = 0, tsSuccess = 1, tsDoing = 2, tsSuspend = 3, tsTargetFail = 4, tsFail = 5, tsKillTask = 6);
  //TTaskState = (tsNormal = 100, tsUnTreated = 10, tsPickUp = 15, tsDoing = 20, tsTargetFail = 50, tsSelfFail = 55, tsKillTas, tsSuccess = 0);
  TTaskType = (ttNormal = 100, tt���� = 0, tt�ֲ� = 1, tt��� = 2, tt�ʼ� = 3);

  //--������״̬
  TSendMachineState = (sms����, sms��æ, sms�쳣);

  //--��ǰ��ɫִ�е���һ����
  TRoleStep = (
  /// <remarks>
  /// ��ʼ״̬
  /// </remarks>
  rsNormal = 0,
  /// <remarks>
  /// �ӺŰ�̯��ɣ����ſ��Կ�ʼ��ħ
  /// </remarks>
  rs׼������=1,
  /// <remarks>
  /// ���Ÿ�ħ���
  /// </remarks>
  rs���Ÿ�ħ���=2,
  /// <remarks>
  /// �Ӻ��յ�Ǯ��
  /// </remarks>
  rs�Ӻ��յ����=3,
  /// <remarks>
  /// �Ӻ�δ�յ����
  /// </remarks>
  rs�Ӻ�δ�յ����=4,
  /// <remarks>
  /// �Է�����
  /// </remarks>
  rs�Է�����ʧ��=5,
  /// <remarks>
  /// �����ɺ�ִ���������
  /// </remarks>
  rsFinished=6
  );

  //--�ͻ��ˡ����á�ҳ
  TClientSet = record
    GroupName         : string;
    TheHost           : string;
    GamePath          : string;
    Capture           : string;

    ConsoleHost       : string;
    ConsolePort       : Word;

    CodingMachineHost : string;
    CodingMachinePort : Word;

    UseDama2          : Boolean;
    Dama2User         : string;
    Dama2Pwd          : string;

    UseVpn            : Boolean;
    VpnServerName     : string;
    VpnUserName       : string;
    VpnPassword       : string;

    TokenHost         : string;
    TokenPort         : Word;

    AutoConn          : Boolean;    //�Զ�����
    MutiRoleFenYe     : Boolean;    //���ɫ��ҳ
    AutoRun           : Boolean;    //�����Զ�����
    Less10FFenPi      : Boolean;    //С��10����ҳ

    //-------------------------------------
    UrlЯ����         : string;
    Url�ϴ�ͼƬ       : string;
  end;

  TSharedInfo = record
    OrderItem     : TOrderItem;
    RoleIndex     : Integer;      //--���ڴ���ڼ�����ɫ,Ĭ����0
    RoleStep      : TRoleStep;    //--��ɫִ�е���һ����
    RecvRoleName  : string;       //--���ŵĽ��ս�ɫ
    TaskIndex     : Integer;      //--̎���ڼ���������
    ClientSet     : TClientSet;   //--�ͻ�������
    //TaskParam     : TTaskParam;
    //BagMoney      : Integer;
    GameWindow    : HWND;          //--��Ϸ���ھ��
    MainFormHandle: HWND;          //--�����������ھ��
    bWork         : Boolean;       //--�������Ƿ����ڹ���
    bReStart      : Boolean;       //--�Ƿ�����������з���
    bSuspendTask  : Boolean;       //--��ͣ����
    bStopTask     : Boolean;       //--�رյ�ǰ����
    bCmdOk        : Boolean;       //--������������������ �������ʾ���ж϶Է��Ƿ��Ѿ�����������
    bConnOK       : Boolean;       //--�ж��ǲ������ӳɹ���
    LocalIP       : string;        //--����IP
    AppPath       : string;        //--������·����Ŀ¼
    TaskStatus    : TTaskState;
    TaskType      : TTaskType;     //--��ǰ��������
    procedure Init();
  end;

const   //������
  CON_REAPT_TIMES = 3;

var
  GSharedInfo: TSharedInfo;
  GConsoleSet: TConsoleSet;
  GAppQuit: Boolean = False;

  CS_OP_Task: TRTLCriticalSection;
  CS_LOG: TRTLCriticalSection;
  CS_ThreadIds: TRTLCriticalSection;

  //--------------------------------------
  GKeyMapLst    : TStringList;
  GKeyMapLstCode: TStringList;

var
  CON_SYS_DICT: string = 'Config\ϵͳ�ֿ�.txt';
  CON_DNF_DICT: string = 'Config\DNFDict.txt';
  CON_BMP_PATH: string = 'Bmp\';
  PATH_IMAGE  : string = '%sBmp\%s.jpg';


function InitAppPath(): Boolean;
function LoadCfg: Boolean;
function SaveCfg: Boolean;

function InitKeyMap: Boolean;
function InitKeyMapCode: Boolean;



procedure PostLogFile(AFormat: string; const Args: array of const);
procedure AddLogMsg(AFormat: string; const Args: array of const; AOnlyDebugShow: Boolean = False);
//procedure DebugInfo(AFormat: string; const Args: array of const; AOnlyDebugShow: Boolean = False);

function GetStateNum(ATaskState: TTaskState): Integer;
implementation

uses
  Vcl.Forms
  , System.IniFiles
  , System.Win.Registry
  , ManSoy.Encode
  , ManSoy.Global
  ;

{ TSharedInfo }

function InitAppPath(): Boolean;
var
  szFilePath: array[0..259] of WideChar;
begin
  GetModuleFileName(HInstance, @szFilePath, 260);
  GSharedInfo.AppPath  := ExtractFilePath(string(PWideChar(@szFilePath)));
  QLog.SetDefaultLogFile(Format('%s\Log\Logs_%s.log', [GSharedInfo.AppPath, FormatDateTime('yyyyMMdd', Now)]), 1024 * 1024 * 10, False, True);
end;

function LoadCfg: Boolean;
var
  iniLocalFile, iniSysFile: TIniFile;
  sDama2: string;
  iDupPos: Integer;
begin
  Debuginf('MS - ��ʼ��������', []);
  //DebugInf('MS - ģ��·�� %s', [string(PWideChar(@szFilePath))]);
  //iniLocalFile := TIniFile.Create(Format('%sConfig\LocalCfg.ini', [GSharedInfo.AppPath]));
  iniLocalFile := TIniFile.Create(Format('%sConfig\LocalCfg.ini', [GSharedInfo.AppPath]));
  iniSysFile := TIniFile.Create(Format('%sConfig\SysCfg.ini', [GSharedInfo.AppPath]));
  try
    GSharedInfo.ClientSet.GroupName         := iniLocalFile.ReadString('����', '�����ʶ��', '');
    //------------------------------------------------------------------------
    GSharedInfo.ClientSet.ConsoleHost       := iniLocalFile.ReadString('����', '����̨IP', '');
    GSharedInfo.ClientSet.ConsolePort       := iniLocalFile.ReadInteger('����', '����̨�˿�', 0);
    //------------------------------------------------------------------------
    GSharedInfo.ClientSet.CodingMachineHost := iniLocalFile.ReadString('����', '�����IP', '');
    GSharedInfo.ClientSet.CodingMachinePort := iniLocalFile.ReadInteger('����', '������˿�', 0);
    GSharedInfo.ClientSet.UseDama2          := iniLocalFile.ReadBool('����', 'ʹ�ô�����', False);
    sDama2 := iniLocalFile.ReadString('����', '������', '');
    sDama2 := Trim(sDama2);
    if ( sDama2 <> '') then
    begin
      iDupPos := Pos('|', sDama2);
      if iDupPos > 0 then
      begin
        GSharedInfo.ClientSet.Dama2User := string(ManSoy.Encode.Base64ToStr(AnsiString(Copy(sDama2, 1, iDupPos - 1))));
        GSharedInfo.ClientSet.Dama2Pwd  := string(ManSoy.Encode.Base64ToStr(AnsiString(Copy(sDama2, iDupPos + 1, Length(sDama2)))));
      end;
    end;
    //------------------------------------------------------------------------
    GSharedInfo.ClientSet.UseVpn        := iniLocalFile.ReadBool('VPN', 'ʹ��VPN', False);
    GSharedInfo.ClientSet.VpnServerName := iniLocalFile.ReadString('VPN', '������', '');
    GSharedInfo.ClientSet.VpnUserName   := iniLocalFile.ReadString('VPN', '�˺�', '');
    GSharedInfo.ClientSet.VpnPassword   := ManSoy.Encode.Base64ToStr(iniLocalFile.ReadString('VPN', '����', ''));
    //------------------------------------------------------------------------
    GSharedInfo.ClientSet.TokenHost         := iniLocalFile.ReadString('����', '���ƻ�IP', '');
    GSharedInfo.ClientSet.TokenPort         := iniLocalFile.ReadInteger('����', '���ƻ��˿�', 0);
    //------------------------------------------------------------------------
    GSharedInfo.ClientSet.TheHost           := iniLocalFile.ReadString('����', '��������', 'C:\Program Files (x86)\Tencent\QQMusic\QQMusic1213.17.49.21\QQMusic.exe');
    GSharedInfo.ClientSet.GamePath          := iniLocalFile.ReadString('����', '��Ϸ·��', '');
    GSharedInfo.ClientSet.Capture           := iniLocalFile.ReadString('����', '��ͼ���Ŀ¼', '');
    //------------------------------------------------------------------------
    GSharedInfo.ClientSet.AutoConn          := iniLocalFile.ReadBool('����', '�Զ�����', False);
    GSharedInfo.ClientSet.MutiRoleFenYe     := iniLocalFile.ReadBool('����', '���ɫ��ҳ', False);
    GSharedInfo.ClientSet.AutoRun           := iniLocalFile.ReadBool('����', '�����Զ�����', False);
    GSharedInfo.ClientSet.Less10FFenPi      := iniLocalFile.ReadBool('����', '10�����·���', False);
    //------------------------------------------------------------------------
    GSharedInfo.ClientSet.UrlЯ����     := iniSysFile.ReadString('����', 'Я����', '');
    GSharedInfo.ClientSet.Url�ϴ�ͼƬ   := iniSysFile.ReadString('����', '�ϴ�ͼƬ', '');
  finally
    FreeAndNil(iniSysFile);
    FreeAndNil(iniLocalFile);
  end;
  //}
  Debuginf('MS - ���ü�����ɣ�AppPath[%s]', [GSharedInfo.AppPath]);
  Result := True;
end;

function SaveCfg: Boolean;
  function SetAutoRunValue(AKeyName: string; APath: string; AFlag: Boolean): Boolean;
  var
    vReg: TRegistry;
  begin
    Result := False;
    vReg := TRegistry.Create;
    try
      vReg.RootKey := HKEY_LOCAL_MACHINE;
      vReg.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\Run', True);
      if AFlag then
        vReg.WriteString(AKeyName, APath)
      else
        vReg.DeleteValue(AKeyName)
    finally
      vReg.CloseKey;
      FreeAndNil(vReg);
    end;
  end;

var
  iniLocalFile, iniSysFile: TIniFile;
  sTmp: string;
begin
  iniLocalFile := TIniFile.Create(Format('%sConfig\LocalCfg.ini', [GSharedInfo.AppPath]));
  iniSysFile := TIniFile.Create(Format('%sConfig\SysCfg.ini', [GSharedInfo.AppPath]));
  try
    iniLocalFile.WriteString('����', '�����ʶ��', GSharedInfo.ClientSet.GroupName);
    //------------------------------------------------------------------------
    iniLocalFile.WriteString('����', '����̨IP', GSharedInfo.ClientSet.ConsoleHost);
    iniLocalFile.WriteInteger('����', '����̨�˿�', GSharedInfo.ClientSet.ConsolePort);
    //------------------------------------------------------------------------
    //iniLocalFile.WriteString('����', '�����IP', GSharedInfo.ClientSet.CodingMachineHost);
    //iniLocalFile.WriteInteger('����', '������˿�', GSharedInfo.ClientSet.CodingMachinePort);
    //------------------------------------------------------------------------
    iniLocalFile.WriteBool('����', 'ʹ�ô�����', GSharedInfo.ClientSet.UseDama2);
    sTmp := ManSoy.Encode.StrToBase64(GSharedInfo.ClientSet.Dama2User);
    sTmp := sTmp + '|' + ManSoy.Encode.StrToBase64(GSharedInfo.ClientSet.Dama2Pwd);
    iniLocalFile.WriteString('����', '������', sTmp);
    //------------------------------------------------------------------------
    iniLocalFile.WriteBool('VPN', 'ʹ��VPN', GSharedInfo.ClientSet.UseVpn);
    iniLocalFile.WriteString('VPN', '������', GSharedInfo.ClientSet.VpnServerName);
    iniLocalFile.WriteString('VPN', '�˺�', GSharedInfo.ClientSet.VpnUserName);
    iniLocalFile.WriteString('VPN', '����', ManSoy.Encode.StrToBase64(GSharedInfo.ClientSet.VpnPassword));


    //------------------------------------------------------------------------
    //iniLocalFile.WriteString('����', '���ƻ�IP', GSharedInfo.ClientSet.TokenHost);
    //iniLocalFile.WriteInteger('����', '���ƻ��˿�', GSharedInfo.ClientSet.TokenPort);
    //------------------------------------------------------------------------
    iniLocalFile.WriteString('����', '��Ϸ·��', GSharedInfo.ClientSet.GamePath);
    iniLocalFile.WriteString('����', '��������', GSharedInfo.ClientSet.TheHost);
    iniLocalFile.WriteString('����', '��ͼ���Ŀ¼', GSharedInfo.ClientSet.Capture);
    iniLocalFile.WriteBool('����', '�Զ�����', GSharedInfo.ClientSet.AutoConn);
    iniLocalFile.WriteBool('����', '���ɫ��ҳ', GSharedInfo.ClientSet.MutiRoleFenYe);
    iniLocalFile.WriteBool('����', '�����Զ�����', GSharedInfo.ClientSet.AutoRun);
    //iniLocalFile.WriteBool('����', '10�����·���', GSharedInfo.ClientSet.Less10FFenPi);
    SetAutoRunValue('������3.0', GSharedInfo.AppPath + 'AutoUpdate.exe', GSharedInfo.ClientSet.AutoRun);
  finally
    FreeAndNil(iniSysFile);
    FreeAndNil(iniLocalFile);
  end;
  Result := True;
end;

function InitKeyMap: Boolean;
begin
  GKeyMapLst.Clear;
  GKeyMapLst.Values['~'] := '`';
  GKeyMapLst.Values['!'] := '1';
  GKeyMapLst.Values['@'] := '2';
  GKeyMapLst.Values['#'] := '3';
  GKeyMapLst.Values['$'] := '4';
  GKeyMapLst.Values['%'] := '5';
  GKeyMapLst.Values['^'] := '6';
  GKeyMapLst.Values['&'] := '7';
  GKeyMapLst.Values['*'] := '8';
  GKeyMapLst.Values['('] := '9';
  GKeyMapLst.Values[')'] := '0';
  GKeyMapLst.Values['_'] := '-';
  GKeyMapLst.Values['+'] := '=';
  GKeyMapLst.Values['{'] := '[';
  GKeyMapLst.Values['}'] := ']';
  GKeyMapLst.Values['|'] := '\';
  GKeyMapLst.Values[':'] := ';';
  GKeyMapLst.Values['"'] := '''';
  GKeyMapLst.Values['<'] := ',';
  GKeyMapLst.Values['>'] := '.';
  GKeyMapLst.Values['?'] := '/';
end;

function InitKeyMapCode: Boolean;
begin
  GKeyMapLstCode.Values['~'] := '192';
  GKeyMapLstCode.Values['_'] := '189';
  GKeyMapLstCode.Values['+'] := '187';
  GKeyMapLstCode.Values['{'] := '219';
  GKeyMapLstCode.Values['}'] := '221';
  GKeyMapLstCode.Values['|'] := '220';
  GKeyMapLstCode.Values[':'] := '186';
  GKeyMapLstCode.Values['"'] := '222';
  GKeyMapLstCode.Values['<'] := '188';
  GKeyMapLstCode.Values['>'] := '190';
  GKeyMapLstCode.Values['?'] := '191';

  GKeyMapLstCode.Values['`'] := '192';
  GKeyMapLstCode.Values['-'] := '189';
  GKeyMapLstCode.Values['='] := '187';
  GKeyMapLstCode.Values['['] := '219';
  GKeyMapLstCode.Values[']'] := '221';
  GKeyMapLstCode.Values['\'] := '220';
  GKeyMapLstCode.Values[';'] := '186';
  GKeyMapLstCode.Values['''']:= '222';;
  GKeyMapLstCode.Values[','] := '188';
  GKeyMapLstCode.Values['.'] := '190';
  GKeyMapLstCode.Values['/'] := '191';

  GKeyMapLstCode.Values['a'] := '65';
  GKeyMapLstCode.Values['b'] := '66';
  GKeyMapLstCode.Values['c'] := '67';
  GKeyMapLstCode.Values['d'] := '68';
  GKeyMapLstCode.Values['e'] := '69';
  GKeyMapLstCode.Values['f'] := '70';
  GKeyMapLstCode.Values['g'] := '71';
  GKeyMapLstCode.Values['h'] := '72';
  GKeyMapLstCode.Values['i'] := '73';
  GKeyMapLstCode.Values['j'] := '74';
  GKeyMapLstCode.Values['k'] := '75';
  GKeyMapLstCode.Values['l'] := '76';
  GKeyMapLstCode.Values['m'] := '77';
  GKeyMapLstCode.Values['n'] := '78';
  GKeyMapLstCode.Values['o'] := '79';
  GKeyMapLstCode.Values['p'] := '80';
  GKeyMapLstCode.Values['q'] := '81';
  GKeyMapLstCode.Values['r'] := '82';
  GKeyMapLstCode.Values['s'] := '83';
  GKeyMapLstCode.Values['t'] := '84';
  GKeyMapLstCode.Values['u'] := '85';
  GKeyMapLstCode.Values['v'] := '86';
  GKeyMapLstCode.Values['w'] := '87';
  GKeyMapLstCode.Values['x'] := '88';
  GKeyMapLstCode.Values['y'] := '89';
  GKeyMapLstCode.Values['z'] := '90';
end;

procedure PostLogFile(AFormat: string; const Args: array of const);
begin
  QLog.PostLog(TQLogLevel.llMessage, PWideChar(AFormat), Args);
end;

procedure AddLogMsg(AFormat: string; const Args: array of const; AOnlyDebugShow: Boolean = False);
var
  sMsg: string;
begin
  if AOnlyDebugShow then
  begin
    {$IFNDEF _MS_DEBUG}
      Exit;
    {$ENDIF}
  end;
  PostLogFile(AFormat, Args);
  if not IsWindow(GSharedInfo.MainFormHandle) then Exit;
  sMsg := System.SysUtils.Format(AFormat, Args, FormatSettings);
  if sMsg = '' then Exit;
  sMsg := Format('[%s]%s', [FormatDateTime('yyyy-MM-dd hh:nn:ss', Now), sMsg]);
  SendMessage(GSharedInfo.MainFormHandle, WM_ADD_LOG, 0, LPARAM(sMsg));
  Application.ProcessMessages;
end;

//procedure DebugInfo(AFormat: string; const Args: array of const; AOnlyDebugShow: Boolean = False);
//var
//  sMsg: string;
//begin
//  if AOnlyDebugShow then
//  begin
//    {$IFNDEF _MS_DEBUG}
//      Exit;
//    {$ENDIF}
//  end;
//  sMsg := System.SysUtils.Format(AFormat, Args, FormatSettings);
//  if sMsg = '' then Exit;
//  OutputDebugString(PWideChar(sMsg));
//  Application.ProcessMessages;
//end;

procedure AddLogFile(AFileNam: string; AFormat: string; const Args: array of const);
var
  sMsg: string;
  vFile: Text;
begin
  sMsg := System.SysUtils.Format(AFormat, Args, FormatSettings);
  if sMsg = '' then Exit;
  sMsg := Format('[%s]%s', [FormatDateTime('yyyy-MM-dd hh:nn:ss', Now), sMsg]);
  EnterCriticalSection(CS_LOG);
  try
    try
      AssignFile(vFile, AFileNam);
      if FileExists(AFileNam) then
        Append(vFile)
      else
        Rewrite(vFile);
      if Trim(sMsg) <> '' then
      begin
        Writeln(vFile, sMsg);
      end;
    except

    end;
  finally
    CloseFile(vFile);
    LeaveCriticalSection(CS_LOG);
  end;
end;

function GetStateNum(ATaskState: TTaskState): Integer;
begin
  Result := 15;
  case ATaskState of
    tsNormal: Result := 100;
    tsStart: Result := 15;
    tsSuccess: Result := 0;
    tsDoing: Result := 20;
    tsSuspend: Result := 20;
    tsTargetFail: Result := 55;
    tsFail: Result := 50;
    { TODO : �����Ҫ����ʧ�����Ļ����������޸� }
    tsKillTask: Result := 55;
  end;
end;

procedure TSharedInfo.Init;
begin
  bReStart      := True;
  bWork         := False;
  bSuspendTask  := False;
  bStopTask     := False;
  bCmdOk        := True;
  bConnOK       := False;
  TaskStatus    := tsNormal;
  TaskType      := ttNormal;
end;

initialization
  InitAppPath;
  LoadCfg;
 // if TOSVersion.Major = 6 then
  begin
    CON_SYS_DICT := 'Config\ϵͳ�ֿ�(W7).txt';
    CON_DNF_DICT := 'Config\DNFDict(W7).txt';
    CON_BMP_PATH := 'Bmp(W7)\';
    PATH_IMAGE   := '%sBmp(W7)\%s.jpg';
  end;

  InitializeCriticalSection(CS_OP_Task);
  InitializeCriticalSection(CS_LOG);
  InitializeCriticalSection(CS_ThreadIds);
  GKeyMapLst := TStringList.Create;
  InitKeyMap;
  GKeyMapLstCode := TStringList.Create;
  InitKeyMapCode;
  GSharedInfo.Init;
finalization
  DeleteCriticalSection(CS_OP_Task);
  DeleteCriticalSection(CS_LOG);
  DeleteCriticalSection(CS_ThreadIds);
  GKeyMapLst.Free;
  GKeyMapLst := nil;

end.
