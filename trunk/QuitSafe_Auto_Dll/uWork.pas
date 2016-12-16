unit uWork;

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes, Winapi.ActiveX,
  IdHTTP, IdSSLOpenSSL, Winapi.WinInet, Winapi.ShellAPI,
  Winapi.Messages,
  IdGlobal,
  IdTCPClient,
  ManSoy.Encode,
  Vcl.Controls,
  uQQLogin,
  vcl.forms,
  uData,
  uFrmCaptcha,
  uPublic,
  HPSocketSDKUnit;

const
  DIGIT_DICT = 'QuitSafeConfig\DigitDict.txt';
  SYS_DICT = 'QuitSafeConfig\SysDict.txt';
  SAFE_CODE = 'sTnItrFttpcWUASfy0x1Vy94obcrWqJe';

  KEMULATOR_DIR_OLD = '%s\�ֻ�ģ����';
  KEMULATOR_CFG_OLD = '%s\�ֻ�ģ����\property.txt';
  TOKEN_DIR_OLD     = '%s\�ֻ�ģ����\rms\SonyEricssonK800_240x320\.token_config';

  KEMULATOR_DIR_NEW = '%s\�ֻ�ģ����-New';
  KEMULATOR_CFG_NEW = '%s\�ֻ�ģ����-New\property.txt';
  TOKEN_DIR_NEW     = '%s\�ֻ�ģ����-New\rms\SonyEricssonK800_240x320\.token_config';

  TOKEN_SRC_ZIP_FILE  = '%s\�����ļ�\%s.zip';
  TOKEN_SRC_DIR       = '%s\�����ļ�\%s';
  KEMULATOR_BAT = 'KEmulator.bat';
type
  TDama2Ret = record
    text: string;
    code: Integer;
  end;

  PTCheckUinType = ^TCheckUinType;
  TCheckUinType = record
    IsNeedCheckCode : Boolean;
    szVerifyCode : string;
    szUinCode : string;
    szSession: string;
  end;

  PQQTokensData = ^TQQTokensData;
  TQQTokensData = packed record
      szEvent:string[50];
      szQQUin:string[50];
      szInitCode:string[100];
      szOriginalSn:string[50];
      szSerialNumber:string[200];
      szDnyPsw:string[50];
      szDnyPswTime:string[100];
  end;

  TWorkThread = class
  private
    FUniMess          : TCheckUinType;
    FRedirectPath     : string;
    FQuitSafePageUrl  : string;
    FGameID           : Integer;
    FAppID            : string;
    FDispatchHttp     : TIdHTTP;
    FidSSL            : TIdSSLIOHandlerSocketOpenSSL;
    FDynPwd_Page      : string;
    FAccount          : string;
    FPassWord         : string;
    FGameArea         : string;
    FGameServer       : string;
    FMBType           : Integer;
    FIType            : string;
    FKey              : string;
    FSmsServerIp      : string;
    FSmsServerPort    : WORD;
    FLoginSig         : string;
    FCapSig           : string;
    FCheckImgName     : string;
    FTokenServerIp    : string;
    FTokenServerPort  : WORD;

    function GetCookies(AHttp: TIdHTTP): string;
    function GetLoginSig(AHttp: TIdHTTP): string;
    function ValidateVC(ACheckCode: string): Boolean;
    function RefreshCheckCode: Boolean;
    function SaveCheckCodeImg: Boolean;
    function RunJavaScript(const JsCode, JsVar: string):string;
    function EncodePassword(): string;
    function GetMBPageUrl(AGameServer: string): string;
    function GetJLServerID(AGameServer: string): string;
    function GetMBType(AGameServer: string): Integer;
    function DownloadKMFiles(AFileName: string): Boolean;
    function InitTokenFiles: boolean;
    //
    function ConnectServer(AIP: string; APort: Integer): Boolean;
    function DisconnectServer(): Boolean;
    function SendUnsafe(): Boolean;
    function SendData(pData: Pointer; ALen: Integer): Boolean;
    //
    function GetCodeByDama2(ATimes: Integer = 3): string;
    procedure OnRedirect(Sender: TObject; var dest: string; var NumRedirect: Integer; var Handled: Boolean; var VMethod: string);

  protected
  //
  public
    FCookie           : string;
    constructor Create(AGameID: Integer; AAccount: string; APassWord: string; AArea: string; AServer: string; AMBType: Integer; AKey: string);
    destructor Destroy; override;
    function InitWebAddress: Integer;
    function OpenLoginPage(): Boolean;
    function CheckVC(): Boolean;
    function GetCheckCode(): Boolean;
    function LoginQQ(): Boolean;
    function GetBindType(): Integer;
    function GetToken(AMBType: Integer): string;
    function QuitSafeByToken(ATokenCode: string): string;
    function QuitSafeBySms(): Boolean;

    property DynPwd_Page: string  read FDynPwd_Page write FDynPwd_Page;
    property GameID     : Integer read FGameID      write FGameID         default -1;
    property Account    : string  read FAccount     write FAccount;
    property PassWord   : string  read FPassWord    write FPassWord;
    property GameArea   : string  read FGameArea    write FGameArea;
    property GameServer : string  read FGameServer  write FGameServer;
    property MBType     : Integer read FMBType      write FMBType;
    property IType      : string  read FIType       write FIType;
    property Key        : string  read FKey         write FKey;
    property MserverIp  : string  read FTokenServerIp   write FTokenServerIp;
    property MserverPort: WORD    read FTokenServerPort write FTokenServerPort;
	  property LoginSig   : string  read FLoginSig    write FLoginSig;
  end;

  TDoClientRec = class(TThread)
      pClient: Pointer;
      pData  : Pointer;
      Len: Integer;
      ResultInfo: TResultInfo;
    private
      procedure DealResultMsg();
    protected
      procedure Execute;override;
    public
      constructor Create(AClient, AData: Pointer; ALen: Integer);
      destructor Destroy;override;
  end;

function ResponseDama2(AUserName: string; APassWord: string; ADama2Id: Integer; AResult: Integer): Integer; stdcall; external 'ManSoy.Global.dll' name 'ResponseDama2';
function DamaForDnfAutoTrade(AUserName: string; APassWord: string; AFileName: string; ADelay: Integer; AType: Integer; var ARetCheckCode: string): Integer; stdcall; external 'ManSoy.Global.dll' name 'DamaForDnfAutoTrade';


var
  URL_CheckUina      : string = 'http://check.ptlogin2.qq.com/check?uin=%s&appid=%s&r=0.7375094648898837';
  URL_CheckVC        : string  = 'http://check.ptlogin2.qq.com/check?regmaster=&pt_tea=1&pt_vcode=1&'+
                                 'uin=%s&appid=%s&login_sig=%s&js_ver=10127&js_type=1&'+
                                 'u1=http://gamesafe.qq.com/safe_mode_remove.shtml?game_id=5&'+
                                 'r=0.7789299980983408';
  url_cap_sig        : string = 'http://captcha.qq.com/cap_union_show?clientype=2&uin=%s&aid=%s&cap_cd=%s&0.888272288996901';
  url_get_img        : string = 'http://captcha.qq.com/getimgbysig?aid=%s&uin=%s&sig=%s';
  url_refresh_img    : string = 'http://captcha.qq.com/getQueSig?aid=%s&uin=%s&captype=2&sig=%s&0.7054448733328836';
  url_cap_verify     : string = 'http://captcha.qq.com/cap_union_verify?aid=%s&uin=%s&captype=8&ans=%s&sig=%s&0.2466733300957089';
  URL_QuitSafe       : string = //'http://aq.qq.com/cn2/unionverify/pc/pc_uv_verify';
                                'http://aq.qq.com/cn2/unionverify/pc/pc_uv_sms_query';
  URL_QuitSafe1      : string = 'http://aq.qq.com/cn2/unionverify/pc/pc_uv_verify';

  URL_Safe_Main_Page : string ='';
  URL_Login_Submit   : string = '';
  URL_Login_Page     : string = '';

  URL_Get_DynPwd_Page  : string = '';
  URL_Download_KM_File : string = '';
  URL_REF: string = '';

  TokenPackData : TQQTokensData;
  IdTCPClient: TIdTcpClient;

  SafeData: TSafeData;
  ResultInfo: TResultInfo;
  pClient: Pointer;
  pListener: Pointer;

  GSmsEvent: THANDLE;

implementation

{$R qqlogin.RES}

uses System.IniFiles, System.StrUtils, Vcl.Imaging.GIFImg, Vcl.Imaging.JPEG,
     System.Variants, System.Win.ComObj, ManSoy.MsgBox, ManSoy.StrSub,ManSoy.Global,
     uFun, uCommFuns;

{ TWorkThread }

function TWorkThread.InitWebAddress: Integer;
begin
  Result := -1;
  case FGameID of
    //--���³�����ʿ
    0: begin
      FAppID                := '21000127';
      URL_Safe_Main_Page    := 'http://gamesafe.qq.com/safe_mode_remove.shtml?game_id=5';//2014-10-23 'http://dnf.qq.com/bht/';
	    URL_Login_Page        := 'http://xui.ptlogin2.qq.com/cgi-bin/xlogin?proxy_url=http://game.qq.com/comm-htdocs/milo/proxy.html&'+
                               'appid=21000127&f_url=loginerroralert&'+
                               's_url=http%3A//gamesafe.qq.com/safe_mode_remove.shtml%3Fgame_id%3D5&no_verifyimg=1&'+
                               'qlogin_jumpname=jump&daid=8&'+
                               'qlogin_param=u1%3Dhttp%3A//gamesafe.qq.com/safe_mode_remove.shtml%3Fgame_id%3D5';
      URL_Login_Submit      := 'http://ptlogin2.qq.com/login?u=%s&p=%s&verifycode=%s&login_sig=%s&pt_verifysession_v1=%s&aid=21000127&'+
                               'pt_vcode_v1=0&pt_randsalt=0&ptredirect=1&u1=http%3A%2F%2Fgamesafe.qq.com%2Fsafe_mode_remove.shtml%3Fgame_id%3D5&'+
                               'h=1&t=1&g=1&from_ui=1&ptlang=2052&action=1-6-1430968421728&js_ver=10127&js_type=1&pt_uistyle=20&daid=8';
      URL_Get_DynPwd_Page   := 'http://gamesafe.qq.com/json.php?mod=SafeMode&act=removeSafeMode&callback=safeModeRemove.removeSafeModeCallback&_=1390445747989';
      Result                := FGameID;
    end;
    //--��������
    1: begin
      FAppID                := '21000118';
      URL_Safe_Main_Page    := 'http://yl.qq.com/act/a20121015safe/index.htm';
      URL_Login_Page        := 'http://xui.ptlogin2.qq.com/cgi-bin/xlogin?'+
                               'proxy_url=http://game.qq.com/comm-htdocs/milo/proxy.html&'+
                               'appid=21000118&f_url=loginerroralert&'+
                               's_url=http%3A//yl.qq.com/act/a20121015safe/index.htm&no_verifyimg=1&'+
                               'qlogin_jumpname=jump&daid=8&qlogin_param=u1%3Dhttp%3A//yl.qq.com/act/a20121015safe/index.htm';
      URL_Login_Submit      := 'http://ptlogin2.qq.com/login?u=%s&p=%s&verifycode=%s&login_sig=%s&pt_verifysession_v1=%s&aid=21000118&'+
                               'pt_vcode_v1=0&pt_randsalt=0&ptredirect=1&u1=http%3A%2F%2Fyl.qq.com%2Fact%2Fa20121015safe%2Findex.htm&'+
                               'h=1&t=1&g=1&from_ui=1&ptlang=2052&action=1-6-1430968421728&js_ver=10122&js_type=1&pt_uistyle=20&daid=8';
      URL_Get_DynPwd_Page   := 'http://apps.game.qq.com/cgi-bin/yl/a20121015safe/CheckSafeStatus.cgi';
      Result                := FGameID;
    end;
    //--����
    2: begin
      FAppID                := '21000501';
      URL_Safe_Main_Page    := 'http://gamesafe.qq.com/safe_mode_remove.shtml?game_id=29';//'http://bns.qq.com/cp/a20130320mibao/';
      URL_Login_Page        := 'http://xui.ptlogin2.qq.com/cgi-bin/xlogin?proxy_url='+
                               'http://game.qq.com/comm-htdocs/milo/proxy.html&appid=21000501&f_url=loginerroralert&'+
                               's_url=http%3A//gamesafe.qq.com/safe_mode_remove.shtml%3Fgame_id%3D29&no_verifyimg=1&'+
                               'qlogin_jumpname=jump&daid=8&'+
                               'qlogin_param=u1%3Dhttp%3A//gamesafe.qq.com/safe_mode_remove.shtml%3Fgame_id%3D29';
      URL_Login_Submit      := 'http://ptlogin2.qq.com/login?u=%s&p=%s&verifycode=%s&login_sig=%s&pt_verifysession_v1=%s&aid=21000501&'+
                               'pt_vcode_v1=0&pt_randsalt=0&ptredirect=1&u1=http%3A%2F%2Fgamesafe.qq.com%2Fsafe_mode_remove.shtml%3Fgame_id%3D29&'+
                               'h=1&t=1&g=1&from_ui=1&ptlang=2052&action=1-6-1430968421728&js_ver=10122&js_type=1&pt_uistyle=20&daid=8';
      URL_Get_DynPwd_Page   := //'http://apps.game.qq.com/cgi-bin/bns/a20130426mibao/BnsMibaoFrontApp.cgi?type=3&area=%s&_=1390211703374';
                               'http://gamesafe.qq.com/json.php?mod=SafeMode&act=removeSafeMode&callback=safeModeRemove.removeSafeModeCallback&_=1415003293690';
      Result                := FGameID;
    end;
    //--��ս��
    3: begin
      FAppID                := '21000109';
      URL_Safe_Main_Page    := 'http://gamesafe.qq.com/safe_mode_remove.shtml?game_id=29';
      URL_Login_Page        := 'http://xui.ptlogin2.qq.com/cgi-bin/xlogin?proxy_url=http://game.qq.com/comm-htdocs/milo/proxy.html'+
                               '&appid=21000109&f_url=loginerroralert&'+
                               's_url=http%3A//gamesafe.qq.com/safe_mode_remove.shtml%3Fgame_id%3D29&'+
                               'no_verifyimg=1&qlogin_jumpname=jump&daid=8&qlogin_param=u1%3Dhttp%3A//gamesafe.qq.com/safe_mode_remove.shtml%3Fgame_id%3D29';
      URL_Login_Submit      := 'http://ptlogin2.qq.com/login?u=%s&p=%s&verifycode=%s&login_sig=%s&pt_verifysession_v1=%s&aid=21000501&'+
                               'pt_vcode_v1=0&pt_randsalt=0&ptredirect=1&u1=http%3A%2F%2Fgamesafe.qq.com%2Fsafe_mode_remove.shtml%3Fgame_id%3D29&'+
                               'h=1&t=1&g=1&from_ui=1&ptlang=2052&action=1-6-1430968421728&js_ver=10122&js_type=1&pt_uistyle=20&daid=8';
      URL_Get_DynPwd_Page   := 'http://apps.game.qq.com/cgi-bin/bns/a20130426mibao/BnsMibaoFrontApp.cgi?type=3&area=%s&_=1389668130924';
      Result                := FGameID;
    end;
  end;
end;

constructor TWorkThread.Create(AGameID: Integer; AAccount, APassWord, AArea,
  AServer: string; AMBType: Integer; AKey: string);
var
  dm2User: string;
  iDupPos: Integer;
begin
  FCookie                       := '';
  FRedirectPath                 := '';
  FQuitSafePageUrl              := '';
  FDispatchHttp                 := TIdHTTP.Create(nil);
  FidSSL                        := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  FDispatchHttp.IOHandler       := FidSSL;
  FDispatchHttp.HTTPOptions     := FDispatchHttp.HTTPOptions + [hoKeepOrigProtocol];
  FDispatchHttp.ProtocolVersion := pv1_1;
  FDispatchHttp.HandleRedirects := True;
  FDispatchHttp.OnRedirect      := OnRedirect;
  FDispatchHttp.ReadTimeout     := 30 * 1000;
  FDispatchHttp.Request.CustomHeaders.Clear;
  FDispatchHttp.Request.Clear;

  FGameID     := AGameID;
  FAccount    := AAccount;
  FPassWord   := APassWord;
  FGameArea   := AArea;
  FGameServer := AServer;
  FMBType     := AMBType;
  FKey        := AKey;

  FCheckImgName := ExtractFilePath(ParamStr(0))+'CheckCode.jpg';

  with TIniFile.Create(ExtractFilePath(ParamStr(0))+'QuitSafeConfig\Cfg.ini') do
  try
    FTokenServerIp   := ReadString( 'TokenSvr', 'Host', '113.140.89.109');
    FTokenServerPort := ReadInteger('TokenSvr', 'Port', 8899);

    FSmsServerIp   := ReadString( 'SmsServer', 'ip', '192.168.192.200');
    FSmsServerPort := ReadInteger('SmsServer', 'port', 5173);

    dm2User := ReadString('Dm2', 'user', '');
    dm2User := Trim(dm2User);
    if (dm2User <> '') then begin
      iDupPos := Pos('|', dm2User);
      if iDupPos > 0 then begin
        dm2.account  := string(ManSoy.EnCode.Base64ToStr(AnsiString(Copy(dm2User, 1, iDupPos - 1))));
        dm2.password := string(ManSoy.EnCode.Base64ToStr(AnsiString(Copy(dm2User, iDupPos + 1, Length(dm2User)))));
      end;
    end;
    dm2.use := ReadBool('Dm2','use', False);

    URL_Download_KM_File := ReadString('KEmulator', 'url', '');
  finally
    Free;
  end;

  InitTokenFiles;
  InitWebAddress;
end;

destructor TWorkThread.Destroy;
begin
  FDispatchHttp.Disconnect;
  FreeAndNil(FidSSL);
  FreeAndNil(FDispatchHttp);
  inherited;
end;

function TWorkThread.GetBindType(): Integer;
var
  sGamaServer: string;
  GameServerLst: TStringList;
  i,j: Integer;
begin
  try
    try
      if FGameServer = '' then
      begin
        sGamaServer := 'aaa';
        j := 0;
        for J := 0 to 2 do begin
          Result := GetMBType(sGamaServer); //��ȡ����ֻ�����ҳ��
          if Result = 0 then Continue;
          if Result = 20000 then Break;
          if Result = 10000 then Break;
        end;
      end else
      begin
        //���������n����(S1/S2/.../Sn)�����ˣ���Ҫ���Խⰲȫn��
        GameServerLst := TStringList.Create;
        sGamaServer := '';
        i := 0;
        j := 0;
        GameServerLst.Delimiter := '/';
        GameServerLst.DelimitedText := FGameServer;
        ManSoy.Global.DebugInf('MS - GetBindType-start', []);
        for I := 0 to GameServerLst.Count - 1 do begin
          sGamaServer := GameServerLst.Strings[i];
          for J := 0 to 2 do begin
            Result := GetMBType(sGamaServer); //��ȡ����ֻ�����ҳ��
            if Result = 0 then Continue;
            if Result = 20000 then Break;
            if Result = 10000 then Break;
          end;
          if Result = 0 then Continue;
          if Result = 20000 then Break;
          if Result = 10000 then Break;
        end;
      end;
      ManSoy.Global.DebugInf('MS - [GetBindType] %d', [Result]);
    except on e:Exception do
      ManSoy.Global.DebugInf('[MS - GetBindType] %s', [e.Message]);
    end;
  finally
    FreeAndNil(GameServerLst);
  end;
end;

function TWorkThread.InitTokenFiles: boolean;
var
  tokenSrc_dir,tokenSrcZip_file,
  tokenDir_old,kemulatorDir_old,kemulatorCfg_old,
  tokenDir_new,kemulatorDir_new,kemulatorCfg_new: string;
begin
  result := false;
  tokenSrc_dir     := Format(TOKEN_SRC_DIR,  [ExtractFileDir(ParamStr(0)), FAccount]);
  tokenSrcZip_file := Format(TOKEN_SRC_ZIP_FILE,  [ExtractFileDir(ParamStr(0)), FAccount]);

  tokenDir_old     := Format(TOKEN_DIR_OLD,     [ExtractFileDir(ParamStr(0))]);
  kemulatorDir_old := Format(KEMULATOR_DIR_OLD, [ExtractFileDir(ParamStr(0))]);

  tokenDir_new     := Format(TOKEN_DIR_NEW,     [ExtractFileDir(ParamStr(0))]);
  kemulatorDir_new := Format(KEMULATOR_DIR_NEW, [ExtractFileDir(ParamStr(0))]);
  case FMBType of
    40: //KM(new)
    begin
      DeleteFile(tokenSrcZip_file); //ɾ������ѹ���ļ�
      DelDir(tokenSrc_dir);         //ɾ�����ƽ�ѹ����ļ���

      LogOut('���������ļ�(new)...', []);
      if not DownloadKMFiles(tokenSrcZip_file) then Exit; //���������ļ�
      ManSoy.Global.DebugInf('��ѹ�����ļ�...', []);
      Unzip(tokenSrcZip_file, tokenSrc_dir); //��ѹ�����ļ�
      ManSoy.Global.DebugInf('����.token_configĿ¼...', []);
      ClearDir(tokenDir_new);
      ManSoy.Global.DebugInf('���������ļ���.token_configĿ¼...', []);
      CopyDir(tokenSrc_dir, tokenDir_new, false);
    end;
    50: //KM(old)
    begin
      DeleteFile(tokenSrcZip_file); //ɾ������ѹ���ļ�
      DelDir(tokenSrc_dir);         //ɾ�����ƽ�ѹ����ļ���

      ManSoy.Global.DebugInf('���������ļ�(old)...', []);
      if not DownloadKMFiles(tokenSrcZip_file) then Exit; //���������ļ�
      ManSoy.Global.DebugInf('��ѹ�����ļ�...', []);
      Unzip(tokenSrcZip_file, tokenSrc_dir); //��ѹ�����ļ�
      ManSoy.Global.DebugInf('����.token_configĿ¼...', []);
      ClearDir(tokenDir_new);
      ManSoy.Global.DebugInf('���������ļ���.token_configĿ¼...', []);
      CopyDir(tokenSrc_dir, tokenDir_old, false);
    end;
  end;
  result:= true;
end;

function TWorkThread.DownloadKMFiles(AFileName: string): Boolean;
var
  vResponseContent: TMemoryStream;
  vParam: TStrings;
  hFile: HWND;
  http: TIdHTTP;
  dir: string;
begin
  Result := False;
  DeleteFile(AFileName);
  vResponseContent := TMemoryStream.Create;
  vParam := TStringList.Create;
  try
    vParam.Add('GAME_ACCOUNT_NAME='+FAccount);
    vParam.Add('SAFE_CODE='+SAFE_CODE);

    http := TIdHTTP.Create(nil);
    http.Post(URL_Download_KM_File, vParam, vResponseContent);

    dir := ExtractFileDir(AFileName);
    if not DirectoryExists(dir) then
      ForceDirectories(dir);

    vResponseContent.SaveToFile(AFileName);
    hFile := FileOpen(AFileName, 0);
    Result := GetFileSize(hFile, nil) > 0;
    FileClose(hFile);
  finally
    vResponseContent.Free;
    vParam.Free;

    http.Disconnect;
    //FreeAndNil(FidSSL);
    FreeAndNil(http);
  end;
end;

function TWorkThread.GetCookies(AHttp: TIdHTTP): string;
var
  I: Integer;
begin
  Result := '';
  if AHttp = nil then Exit;
  for I := 0 to AHttp.Response.RawHeaders.Count - 1 do
  begin
    if Pos('Set-Cookie: ',AHttp.Response.RawHeaders[I]) > 0 then
    begin
      Result := Result + GetLeftStr(';',GetRightStr('Set-Cookie: ',AHttp.Response.RawHeaders[I])) + '; ';
    end;
  end;
end;

function TWorkThread.GetLoginSig(AHttp: TIdHTTP): string;
var
  I: Integer;
  s: string;
begin
  Result := '';
  if AHttp = nil then Exit;
  for I := 0 to AHttp.Response.RawHeaders.Count - 1 do
  begin
    s := AHttp.Response.RawHeaders[I];
    if Pos('pt_login_sig', s) > 0 then
    begin
      Result := GetLeftStr(';', GetRightStr('pt_login_sig=', s));
      FLoginSig := Result;
      Break;
    end;
  end;
end;

function TWorkThread.EncodePassword: string;
var
  MyList:TStringList;
  Res:TResourceStream;
  szTemp:string;
begin
  Result :='';
  try
     MyList:=TStringList.Create;
     MyList.Clear;
     Res:=TResourceStream.Create(HInstance,'QQLOGIN','TEXT');
     MyList.LoadFromStream(Res);
     szTemp := Format('szResult = myEncrypt("%s","%s","%s", false);',[FPassWord, FUniMess.szUinCode, FUniMess.szVerifyCode]);
     MyList.Add(szTemp);
     Result := RunJavaScript(MyList.Text,'szResult');
  finally
     MyList.Free;
     Res.Free;
  end;
end;

function TWorkThread.OpenLoginPage: Boolean;
var
  AResponseContent: TStringStream;
  szHtml: string;
begin
  Result := False;
  FDispatchHttp.Request.Clear;
  FDispatchHttp.Request.CustomHeaders.Clear;
  AResponseContent := TStringStream.Create();
  try
    try
      FDispatchHttp.Get(URL_Login_Page, AResponseContent);
      szHtml := AResponseContent.DataString;
      {$IFDEF DEBUG}
      AResponseContent.SaveToFile('1.html');
      FDispatchHttp.Response.RawHeaders.SaveToFile('1.txt');
      {$ENDIF}
      GetLoginSig(FDispatchHttp);
      if FLoginSig = '' then Exit;
      FCookie := FCookie + GetCookies(FDispatchHttp);
      Result := True;
    except
    end;
  finally
    AResponseContent.Free;
    FDispatchHttp.Disconnect;
  end;
end;

function TWorkThread.CheckVC: Boolean;
var
  szHttp,szTemp,sCookies:string;
  AResponseContent:TStringStream;
begin
  Result := True;
  try
    FDispatchHttp.Request.Clear;
    FDispatchHttp.Request.CustomHeaders.Clear;
    FDispatchHttp.Request.AcceptLanguage := 'zh-cn,zh;q=0.8,en-us;q=0.5,en;q=0.3';
    FDispatchHttp.Request.UserAgent :='Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20100101 Firefox/15.0.1';
    FDispatchHttp.Request.Accept := '*/*';
    FDispatchHttp.Request.Connection :='keep-alive';
    FDispatchHttp.Request.CustomHeaders.Text := 'Cookie: ' + FCookie;
    AResponseContent := TStringStream.Create('',TEncoding.utf8);
    try
      AResponseContent.Clear;
      AResponseContent.Seek(0, soBeginning);
      szHttp := Format(URL_CheckVC,[FAccount, FAppID, FLoginSig]);
      FDispatchHttp.Get(szHttp,AResponseContent);
      {$IFDEF DEBUG}
      AResponseContent.SaveToFile('1.html');
      FDispatchHttp.Response.RawHeaders.SaveToFile('1.txt');
      {$ENDIF}
      FCookie := FCookie + GetCookies(FDispatchHttp);
      szHttp := AResponseContent.DataString;
      ManSoy.Global.DebugInf('MS - [CheckVC] %s', [szHttp]);
      szHttp := GetRightStr('ptui_checkVC(''',szHttp);
      szTemp := GetLeftStr('''',szHttp);
      if szTemp = '0' then   //������֤��
      begin
        //ptui_checkVC('0','!QIC','\x00\x00\x00\x00\x0f\x01\xe5\xe5','zJrf0PUwWu-tL7gTcV9NrMmrZPCbmfBbt72zzah3aGHwf1_MmUiroA**','0');
        FUniMess.IsNeedCheckCode := False;
        szHttp := GetRightStr(''',''',szHttp);
        FUniMess.szVerifyCode := GetLeftStr('''',szHttp); //���Ĭ�ϵ���֤��
        szHttp := GetRightStr(''',''',szHttp);
        FUniMess.szUinCode := GetLeftStr('''',szHttp);    //16�����˺�
        szHttp := GetRightStr(''',''',szHttp);
        FUniMess.szSession := GetLeftStr('''',szHttp);    //��֤��session
      end else
      begin    //szTemp = 1 ��Ҫ��֤��
        //ptui_checkVC('1','zJrf0PUwWu-tL7gTcV9NrMmrZPCbmfBbt72zzah3aGHwf1_MmUiroA**','\x00\x00\x00\x00\x0f\x01\xe5\xe5','','0');
        FUniMess.IsNeedCheckCode := True;
        szHttp := GetRightStr(''',''',szHttp);
        FUniMess.szSession := GetLeftStr('''',szHttp);   //��֤��session
        szHttp := GetRightStr(''',''',szHttp);
        FUniMess.szUinCode := GetLeftStr('''',szHttp);   //16�����˺�
        FUniMess.szVerifyCode := ''; //������ҳ���ȡ��֤��
      end;
    except
      Result := False;
    end;
  finally
    AResponseContent.Free;
    FDispatchHttp.Disconnect;
  end
end;

function TWorkThread.GetCheckCode: Boolean;
var
  sRet, sCode, url: string;
  AResponseContent: TStringStream;
  i: Integer;
  b: Boolean;
begin
  Result := False;
  if not FUniMess.IsNeedCheckCode then
  begin
    Result := True;
    Exit;
  end;
  FDispatchHttp.Request.Clear;
  FDispatchHttp.Request.CustomHeaders.Clear;
  FDispatchHttp.Request.Accept := '*/*';
  FDispatchHttp.Request.AcceptLanguage := 'zh-cn,zh;q=0.8,en-us;q=0.5,en;q=0.3';
  FDispatchHttp.Request.UserAgent :='Mozilla/5.0 (Windows NT 6.1; WOW64; rv:35.0) Gecko/20100101 Firefox/35.0';
  FDispatchHttp.Request.Connection :='keep-alive';
  FDispatchHttp.Request.ContentType := 'application/x-www-form-urlencoded';
  FDispatchHttp.Request.CustomHeaders.Text := 'Cookie: ' + FCookie;
  AResponseContent := TStringStream.Create('' ,TEncoding.UTF8);
  try
    try
      //��ȡcap_sig
      url := Format(url_cap_sig, [FAccount, FAppId, FUniMess.szSession]);
      FDispatchHttp.Get(url, AResponseContent);
      sRet := AResponseContent.DataString;
      FCapSig := '';
      FCapSig := GetRightStr('g_click_cap_sig="', sRet);
      FCapSig := GetLeftStr('"', FCapSig);
      ManSoy.Global.DebugInf('MS - [GetCheckCode-FCapSig] %s', [FCapSig]);
      if FCapSig = '' then Exit;

      //��ȡ��֤��ͼƬ
      if not SaveCheckCodeImg then Exit;

      for i := 0 to 5 do
      begin
        if dm2.use then
          sRet := GetCodeByDama2
        else
          sRet := uFrmCaptcha.GetCaptcha(nil);

//        //У����֤��  ����ȷ��ˢ����֤��
        b := ValidateVC(sRet);
        if not b then
        begin
          if RefreshCheckCode then
          begin
            SaveCheckCodeImg;
            Continue;
          end;
        end;

        if b then Break;
      end;
      if not b then Exit;

      Result := True;
    except on e: Exception do
      ManSoy.Global.DebugInf('MS - [GetCheckCode] %s', [e.Message]);
    end;
  finally
    AResponseContent.Free;
    FDispatchHttp.Disconnect;
  end;
end;

function TWorkThread.GetCodeByDama2(ATimes: Integer): string;
var
  i: Integer;
  procedure GetCode(var ADm2Ret: TDama2Ret);
  begin
    ADm2Ret.text := '';
    ADm2Ret.code := -1;
    ADm2Ret.code := DamaForDnfAutoTrade(
      dm2.account, //�û���
      dm2.password,  //����
      FCheckImgName,   //FilePath
      120,  //timeout, ��
      101,  //type id      //4λӢ����ĸ
      ADm2Ret.text
    );
  end;
var
  dm2Ret: TDama2Ret;
begin
  result := '';
  for I := 0 to ATimes - 1 do
  begin
    if i > 0 then   //����룬��Ҫ�۳�����
      ResponseDama2(dm2.account, dm2.password, dm2Ret.code, 0);

    //����
    GetCode(dm2Ret);
    if dm2Ret.text = '' then
    begin
      sleep((i+1)*1000);
      continue;
    end else
    begin
      Result := dm2Ret.text;
      break;
    end;
  end;
end;

function TWorkThread.SaveCheckCodeImg: Boolean;
var
  sRet, url: string;
  AResponseContent: TStringStream;
  ms: TMemoryStream;
begin
  Result := False;
  if FCapSig = '' then Exit;

  FDispatchHttp.Request.Clear;
  FDispatchHttp.Request.CustomHeaders.Clear;
  FDispatchHttp.Request.Accept := '*/*';
  FDispatchHttp.Request.AcceptLanguage := 'zh-cn,zh;q=0.8,en-us;q=0.5,en;q=0.3';
  FDispatchHttp.Request.UserAgent :='Mozilla/5.0 (Windows NT 6.1; WOW64; rv:35.0) Gecko/20100101 Firefox/35.0';
  FDispatchHttp.Request.Connection :='keep-alive';
  FDispatchHttp.Request.ContentType := 'application/x-www-form-urlencoded';
  FDispatchHttp.Request.CustomHeaders.Text := 'Cookie: ' + FCookie;
  AResponseContent := TStringStream.Create('' ,TEncoding.UTF8);
  ms := TMemoryStream.Create;
  try
    try
      //��ȡ��֤��ͼƬ
      url := Format(url_get_img, [FAppId, FAccount, FCapSig]);
      FDispatchHttp.Get(url, ms);
      if ms.Size = 0 then Exit;
      ms.Position := 0;
      ms.SaveToFile(FCheckImgName);
      Result := True;
      ManSoy.Global.DebugInf('MS - [SaveCheckCodeImg] success', []);
    except on e: Exception do
      ManSoy.Global.DebugInf('MS - [SaveCheckCodeImg] %s', [e.Message]);
    end;
  finally
    AResponseContent.Free;
    ms.Free;
    FDispatchHttp.Disconnect;
  end;
end;

function TWorkThread.ValidateVC(ACheckCode: string): Boolean;
var
  sRet, sTmp, url: string;
  AResponseContent: TStringStream;
begin
  Result := False;
  FDispatchHttp.Request.Clear;
  FDispatchHttp.Request.CustomHeaders.Clear;
  FDispatchHttp.Request.Accept := '*/*';
  FDispatchHttp.Request.AcceptLanguage := 'zh-cn,zh;q=0.8,en-us;q=0.5,en;q=0.3';
  FDispatchHttp.Request.UserAgent :='Mozilla/5.0 (Windows NT 6.1; WOW64; rv:35.0) Gecko/20100101 Firefox/35.0';
  FDispatchHttp.Request.Connection :='keep-alive';
  FDispatchHttp.Request.ContentType := 'application/x-www-form-urlencoded';
  FDispatchHttp.Request.CustomHeaders.Text := 'Cookie: ' + FCookie;
  AResponseContent := TStringStream.Create('' ,TEncoding.UTF8);
  try
    try
      url := Format(url_cap_verify, [FAppId, FAccount, ACheckCode, FCapSig]);
      FDispatchHttp.Get(url, AResponseContent);
      sRet := AResponseContent.DataString;
      ManSoy.Global.DebugInf('MS - [ValidateVC] %s', [sRet]);
      sTmp := GetRightStr('rcode:', sRet);
      sTmp := GetLeftStr(',', sTmp);
      if sTmp <> '0' then Exit;

      sTmp := GetRightStr('randstr:"', sRet);
      sTmp := GetLeftStr('"', sTmp);
      FUniMess.szVerifyCode := sTmp;
      sTmp := GetRightStr('sig:"', sRet);
      sTmp := GetLeftStr('"', sTmp);
      FUniMess.szSession := sTmp;
      Result := True;
    except on e: Exception do
      ManSoy.Global.DebugInf('MS - [ValidateVC] %s', [e.Message]);
    end;
  finally
    AResponseContent.Free;
    FDispatchHttp.Disconnect;
  end;
end;

function TWorkThread.RefreshCheckCode: Boolean;
var
  sRet, url: string;
  AResponseContent: TStringStream;
begin
  Result := False;

  FDispatchHttp.Request.Clear;
  FDispatchHttp.Request.CustomHeaders.Clear;
  FDispatchHttp.Request.Accept := '*/*';
  FDispatchHttp.Request.AcceptLanguage := 'zh-cn,zh;q=0.8,en-us;q=0.5,en;q=0.3';
  FDispatchHttp.Request.UserAgent :='Mozilla/5.0 (Windows NT 6.1; WOW64; rv:35.0) Gecko/20100101 Firefox/35.0';
  FDispatchHttp.Request.Connection :='keep-alive';
  FDispatchHttp.Request.ContentType := 'application/x-www-form-urlencoded';
  FDispatchHttp.Request.CustomHeaders.Text := 'Cookie: ' + FCookie;
  AResponseContent := TStringStream.Create('' ,TEncoding.UTF8);
  try
    try
      //ˢ����֤��
      AResponseContent.Clear;
      AResponseContent.Seek(0, soBeginning);
      url := Format(url_refresh_img, [FAppId, FAccount, FCapSig]);
      FDispatchHttp.Get(url, AResponseContent);
      sRet := AResponseContent.DataString;
      ManSoy.Global.DebugInf('MS - [RefreshCheckCode] %s', [sRet]);
      //cap_setQue("",0);cap_showOption(""); cap_getCapBySig("gPe-yksFzKS4OyKqPc75qrFiXQ3sokKzLBYw_Y-Hz14pH1aA-8zIy9NSwHq0z_5cOuNIL3eKA5G_i6r40OnhSFQLleuwJuQj20qVM-DXiVG0*");
      FCapSig := '';
      FCapSig := ManSoy.StrSub.GetRightStr('cap_getCapBySig("', sRet);
      FCapSig := ManSoy.StrSub.GetLeftStr('"', FCapSig);
      if FCapSig = '' then Exit;

      Result := True;
    except on e: Exception do
      ManSoy.Global.DebugInf('MS - [RefreshCheckCode] %s', [e.Message]);
    end;
  finally
    AResponseContent.Free;
    FDispatchHttp.Disconnect;
  end;
end;

function TWorkThread.LoginQQ: Boolean;
var
  szTemp,szHttp,szEncodePwd: string;
  AResponseContent: TStringStream;
  OldRedirectMaximum: Integer;
begin
  Result := False;
  FDispatchHttp.Request.Clear;
  FDispatchHttp.Request.CustomHeaders.Clear;
  FDispatchHttp.Request.Accept := '*/*';
  FDispatchHttp.Request.AcceptLanguage := 'zh-cn,zh;q=0.8,en-us;q=0.5,en;q=0.3';
  FDispatchHttp.Request.UserAgent :='Mozilla/5.0 (Windows NT 6.1; WOW64; rv:35.0) Gecko/20100101 Firefox/35.0';
  FDispatchHttp.Request.Connection :='keep-alive';
  FDispatchHttp.Request.ContentType := 'application/x-www-form-urlencoded';
  FDispatchHttp.Request.CustomHeaders.Text := 'Cookie: ' + FCookie;
  AResponseContent := TStringStream.Create('' ,TEncoding.UTF8);
  try
    try
      szEncodePwd := EncodePassword;
      szHttp := URL_Login_Submit;
      szHttp := ReplaceStr('u=','&','u='+FAccount+'&', szHttp);
      szHttp := ReplaceStr('p=','&','p='+szEncodePwd+'&', szHttp);
      szHttp := ReplaceStr('verifycode=','&','verifycode='+FUniMess.szVerifyCode+'&', szHttp);
      szHttp := ReplaceStr('login_sig=','&','login_sig='+FLoginSig+'&', szHttp);
      szHttp := ReplaceStr('pt_verifysession_v1=','&','pt_verifysession_v1='+FUniMess.szSession+'&', szHttp);

      if FUniMess.IsNeedCheckCode then
        szHttp := ReplaceStr('pt_vcode_v1=','&','pt_vcode_v1=1'+'&', szHttp);

      FDispatchHttp.Get(szHttp, AResponseContent);
      szTemp := AResponseContent.DataString;
      ManSoy.Global.DebugInf('MS - [LoginQQ] %s', [szTemp]);
      {$IFDEF DEBUG}
      AResponseContent.SaveToFile('1.html');
      FDispatchHttp.Response.RawHeaders.SaveToFile('1.txt');
      {$ENDIF}
      if Pos('��¼�ɹ�',szTemp) <= 0 then Exit;
      FCookie := FCookie + GetCookies(FDispatchHttp);
      szHttp := GetRightStr('ptuiCB(''0'',''0'',''', szTemp);
      szHttp := GetLeftStr(''',''',  szHttp);
      OldRedirectMaximum := FDispatchHttp.RedirectMaximum;
      FDispatchHttp.RedirectMaximum := 0;
      FDispatchHttp.Request.CustomHeaders.Text := 'Cookie: ' + FCookie;
      AResponseContent.Clear;
      AResponseContent.Seek(0, soBeginning);
      FDispatchHttp.Get(szHttp, AResponseContent);
      szTemp := AResponseContent.DataString;
      {$IFDEF DEBUG}
      AResponseContent.SaveToFile('1.html');
      FDispatchHttp.Response.RawHeaders.SaveToFile('1.txt');
      {$ENDIF}
      FCookie := FCookie + GetCookies(FDispatchHttp);
      FCookie := StringReplace(FCookie, ' uin=;',       '', [rfReplaceAll]);
      FCookie := StringReplace(FCookie, ' p_uin=;',     '', [rfReplaceAll]);
      FCookie := StringReplace(FCookie, ' p_skey=;',    '', [rfReplaceAll]);
      FCookie := StringReplace(FCookie, ' pt4_token=;', '', [rfReplaceAll]);
      FCookie := StringReplace(FCookie, ' ptcz=;',      '', [rfReplaceAll]);
      //FCookie := ReplaceStr('confirmuin=',';','confirmuin='+FAccount+';', FCookie);
      Result := True;
    except on e:Exception do
      ManSoy.Global.DebugInf('MS - [LoginQQ] %s', [e.Message]);
    end;
  finally
    AResponseContent.Free;
    FDispatchHttp.Disconnect;
    FDispatchHttp.RedirectMaximum := OldRedirectMaximum;
  end;
end;

function TWorkThread.GetJLServerID(AGameServer: string): string;
var
  AResponseContent:TStringStream;
  szHtml: string;
begin
  Result := '0';
  FDispatchHttp.Request.Clear;
  AResponseContent := TStringStream.Create();
  try
    FDispatchHttp.Get('http://gameact.qq.com/comm-htdocs/js/game_area/bns_server_select.js', AResponseContent);
    szHtml := AResponseContent.DataString;
    szHtml := GetRightStr(FGameArea, szHtml);
    szHtml := GetRightStr(AGameServer, szHtml);
    szHtml := GetRightStr('v: "', szHtml);
    szHtml := GetLeftStr('",', szHtml);
    Result := szHtml;
    ManSoy.Global.DebugInf('MS - [GetJLServerID] %s', [szHtml]);
  finally
    AResponseContent.Free;
    FDispatchHttp.Disconnect;
  end;
end;

function TWorkThread.GetMBPageUrl(AGameServer: string): string;
var
  wParam            : TStrings;
  AResponseContent  : TStringStream;
begin
  Result :='';
  try
    wParam := TStringList.Create;
    FDispatchHttp.Request.Clear;
    FDispatchHttp.Request.Accept := 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8';
    FDispatchHttp.Request.AcceptLanguage := 'zh-cn,zh;q=0.8,en-us;q=0.5,en;q=0.3';
    FDispatchHttp.Request.UserAgent :='Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20100101 Firefox/15.0.1';
    FDispatchHttp.Request.Connection :='keep-alive';
    FDispatchHttp.Request.Referer := URL_Safe_Main_Page;
    FDispatchHttp.Request.CustomHeaders.Text := 'Cookie: ' + FCookie;
    try
//      if FGameID = 2 then begin
//        AResponseContent := TStringStream.Create();
//        try
//          FDispatchHttp.Get(Format(URL_Get_DynPwd_Page, [GetJLServerID(AGameServer)]), AResponseContent);
//          Result := AResponseContent.DataString;
//        finally
//          FreeAndNil(AResponseContent);
//        end;
//      end else
        Result := FDispatchHttp.Post(URL_Get_DynPwd_Page, wParam);
    except
    end;
    case FGameID of
      0,2: begin
        if Pos('"err":0', Result) > 0 then
        begin
          Result := GetRightStr('"err":0,"url":"',Result);
          Result := GetLeftStr('"});',Result);
          Result := StringReplace(Result, '\', '', [rfReplaceAll]);
        end;
      end;
      1: begin
        Result := GetRightStr('self.location.href=''',Result);
        Result := GetLeftStr('''',Result);
      end;
//      2: begin
//        Result := GetRightStr('"show_url":"',Result);
//        Result := GetLeftStr('",',Result);
//      end;
      3: begin
        Result := GetRightStr('"url":"',Result);
        Result := GetLeftStr('"}',Result);
        Result := StringReplace(Result, '\', '', [rfReplaceAll]);
      end;
    end;

    FQuitSafePageUrl := Result;
    ManSoy.Global.DebugInf('MS - [GetMBPageUrl] %s', [Result]);
  finally
    wParam.Free;
    FDispatchHttp.Disconnect;
  end;
end;

function TWorkThread.GetMBType(AGameServer: string): Integer;
  procedure SetSmsInfo(sRet: string);
  var
    smsContent,recPhoneNumber:string;
  begin
    smsContent := GetRightStr('�����ţ�', sRet);
    smsContent := GetRightStr('<dd>', smsContent);
    smsContent := GetLeftStr('</dd>', smsContent);

    recPhoneNumber := GetRightStr('�����룺', sRet);
    recPhoneNumber := GetRightStr('<dd>', recPhoneNumber);
    recPhoneNumber := GetLeftStr('</dd>', recPhoneNumber);
    recPhoneNumber := StringReplace(recPhoneNumber, '&nbsp;', '', [rfReplaceAll]);

    SafeData.CommType := TCommType.ctUnSafe;
    SafeData.QQ := FAccount;
    SafeData.PhoneNum := recPhoneNumber;
    SafeData.MsgContent := smsContent;

    ManSoy.Global.DebugInf('MS - [GetMBType-SetSmsInfo] recPhoneNumber=%s;smsContent=%s', [recPhoneNumber,smsContent]);
  end;
var
  QuitPageUrl ,szTemp,szHtml,url: string;
  AResponseContent:TStringStream;
  I: Integer;
  szTempCookie: string;
begin
  Result := 0;
  QuitPageUrl := GetMBPageUrl(AGameServer);

  if QuitPageUrl = '' then Exit;
  try
    AResponseContent:=TStringStream.Create('',TEncoding.UTF8);
    FDispatchHttp.Request.Clear;
    FDispatchHttp.Request.Accept := 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8';
    FDispatchHttp.Request.AcceptLanguage := 'zh-cn,zh;q=0.8,en-us;q=0.5,en;q=0.3';
    FDispatchHttp.Request.UserAgent :='Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20100101 Firefox/15.0.1';
    FDispatchHttp.Request.Connection :='keep-alive';
    FDispatchHttp.Request.Referer := URL_Safe_Main_Page;//URL_Get_DynPwd_Page;
    FDispatchHttp.Request.CustomHeaders.Text := 'Cookie: ' + FCookie;
    try
      FDispatchHttp.Get(QuitPageUrl, AResponseContent);
      szHtml := AResponseContent.DataString;
      if szHtml = '' then Exit;

      {$IFDEF DEBUG}
      AResponseContent.SaveToFile('1.html');
      FDispatchHttp.Response.RawHeaders.SaveToFile('1.txt');
      {$ENDIF}
      //colin 2015-05-15
      for I := 0 to FDispatchHttp.Response.RawHeaders.Count - 1 do
      begin
        if Pos('aq_base_sid',FDispatchHttp.Response.RawHeaders[I]) > 0 then
        begin
          szTempCookie := GetLeftStr(';',GetRightStr('Set-Cookie: ',FDispatchHttp.Response.RawHeaders[I])) + '; ';
          Break;
        end;
      end;
      if szTempCookie <> '' then
      begin
        if Pos('aq_base_sid',FCookie) > 0 then
        begin
          FCookie := ReplaceStr('aq_base_sid','; ',szTempCookie,FCookie);
        end
        else
        begin
          FCookie := FCookie + szTempCookie;
        end;
      end;

      if Pos('6λ���ֶ�̬����', szHtml) > 0 then
      begin
        Result := 10000;
        Exit;
      end;
      if Pos('�����ţ�',szHtml) > 0 then
      begin
        Result := 20000;
        SetSmsInfo(szHtml);
        Exit;
      end;
      if Pos('һ����֤',szHtml) > 0 then
      begin
        szTempCookie := FCookie;
        szTempCookie := szTempCookie + 'ts_uid=9785249985; ';

        FDispatchHttp.Request.CustomHeaders.Clear;
        FDispatchHttp.Request.CustomHeaders.Text := 'Cookie: ' + szTempCookie;
        url := 'http://aq.qq.com/cn2/unionverify/pc/pc_uv_show?type=';
        AResponseContent.Clear;
        AResponseContent.Seek(0, soBeginning);
        FDispatchHttp.Get(url+'4',AResponseContent);
        szHtml := AResponseContent.DataString;
        {$IFDEF DEBUG}
        AResponseContent.SaveToFile('1.html');
        FDispatchHttp.Response.RawHeaders.SaveToFile('1.txt');
        {$ENDIF}
        if Pos('6λ���ֶ�̬����',szHtml) > 0 then
        begin
          Result := 10000;
          Exit;
        end;
        AResponseContent.Clear;
        AResponseContent.Seek(0, soBeginning);
        FDispatchHttp.Get(url+'2',AResponseContent);
        {$IFDEF DEBUG}
        AResponseContent.SaveToFile('1.html');
        FDispatchHttp.Response.RawHeaders.SaveToFile('1.txt');
        {$ENDIF}
        szHtml := AResponseContent.DataString;
        if Pos('������֤',szHtml) > 0 then
        begin
          Result := 20000;
          SetSmsInfo(szHtml);
          Exit;
        end;
      end;
    except on e:Exception do
      ManSoy.Global.DebugInf('MS - [GetMBType] %s', [e.Message]);
    end;
  finally
    AResponseContent.Free;
    FDispatchHttp.Disconnect;
  end;
end;

function TWorkThread.GetToken(AMBType: Integer): string;
var
  hKEmulator,dwDealyTimes: HWND;
  tokenSrc_dir,tokenSrcZip_file,
  tokenDir_old,kemulatorDir_old,kemulatorCfg_old,
  tokenDir_new,kemulatorDir_new,kemulatorCfg_new: string;
  I: Integer;
  dwTickCount: DWORD;
  pt: TPoint;
  s, subPic: string;
begin
  Result := '';
  tokenSrc_dir     := Format(TOKEN_SRC_DIR,  [ExtractFileDir(ParamStr(0)), FAccount]);
  tokenSrcZip_file := Format(TOKEN_SRC_ZIP_FILE,  [ExtractFileDir(ParamStr(0)), FAccount]);

  tokenDir_old     := Format(TOKEN_DIR_OLD,     [ExtractFileDir(ParamStr(0))]);
  kemulatorDir_old := Format(KEMULATOR_DIR_OLD, [ExtractFileDir(ParamStr(0))]);

  tokenDir_new     := Format(TOKEN_DIR_NEW,     [ExtractFileDir(ParamStr(0))]);
  kemulatorDir_new := Format(KEMULATOR_DIR_NEW, [ExtractFileDir(ParamStr(0))]);

  try
  try
    case AMBType of
      40: //KM(new)
      begin
        ManSoy.Global.DebugInf('���ֻ�����ģ����...', []);
        ShellExecute(0, nil, PChar(KEMULATOR_BAT), nil, PChar(kemulatorDir_new), SW_HIDE);
        dwDealyTimes := GetTickCount;
        while GetTickCount - dwDealyTimes < 1 * 60 * 1000 do
        begin
          hKEmulator := FindWindow(nil, 'KEmulator Lite v0.9.8');
          if not IsWindow(hKEmulator) then continue;
          pt := DmUtils.fnFindWordOnWindow(hKEmulator, '��̬����', 'ffffff-000000', SYS_DICT);
          if (pt.X <> -1) and (pt.Y <> -1) then Break;
        end;
        if (pt.X = -1) or (pt.Y = -1) then
        begin
          ManSoy.Global.DebugInf('���ֻ�����ģ������ʱ���˳�...', []);
          Exit;
        end;
        ManSoy.Global.DebugInf('��ȡ�ֻ�����...', []);
        s := '';
        subPic := ExtractFilePath(ParamStr(0)) + 'Bmp\%d.bmp';
        //��1λ
        for I := 0 to 9 do
        begin
          if DmUtils.fnPicExistOnWindowArea(hKEmulator, 49,128,75,177, Format(subPic, [I])) then
          //if DmUtils.fnPicExistOnWindowArea(hKEmulator, 46,87,72,126,ExtractFilePath(ParamStr(0))+Format('Bmp\%d.bmp', [I])) then
          begin  s := s + IntToStr(I); Break; end;
        end;
        //��2λ
        for I := 0 to 9 do
        begin
          if DmUtils.fnPicExistOnWindowArea(hKEmulator, 74,128,100,177,Format(subPic, [I])) then
          //if DmUtils.fnPicExistOnWindowArea(hKEmulator, 71,87,97,126,ExtractFilePath(ParamStr(0))+Format('Bmp\%d.bmp', [I])) then
          begin  s := s + IntToStr(I); Break; end;
        end;
        //��3λ
        for I := 0 to 9 do
        begin
          if DmUtils.fnPicExistOnWindowArea(hKEmulator, 99,128,125,177,Format(subPic, [I])) then
          //if DmUtils.fnPicExistOnWindowArea(hKEmulator, 96,87,122,126,ExtractFilePath(ParamStr(0))+Format('Bmp\%d.bmp', [I])) then
          begin  s := s + IntToStr(I); Break; end;
        end;
        //��4λ
        for I := 0 to 9 do
        begin
          if DmUtils.fnPicExistOnWindowArea(hKEmulator, 124,128,150,177,Format(subPic, [I])) then
          //if DmUtils.fnPicExistOnWindowArea(hKEmulator, 121,87,147,126,ExtractFilePath(ParamStr(0))+Format('Bmp\%d.bmp', [I])) then
          begin  s := s + IntToStr(I); Break; end;
        end;
        //��5λ
        for I := 0 to 9 do
        begin
          if DmUtils.fnPicExistOnWindowArea(hKEmulator, 149,128,175,177,Format(subPic, [I])) then
          //if DmUtils.fnPicExistOnWindowArea(hKEmulator, 146,87,172,126,ExtractFilePath(ParamStr(0))+Format('Bmp\%d.bmp', [I])) then
          begin  s := s + IntToStr(I); Break; end;
        end;
        //��6λ
        for I := 0 to 9 do
        begin
          if DmUtils.fnPicExistOnWindowArea(hKEmulator, 174,128,200,177,Format(subPic, [I])) then
          //if DmUtils.fnPicExistOnWindowArea(hKEmulator, 171,87,197,126,ExtractFilePath(ParamStr(0))+Format('Bmp\%d.bmp', [I])) then
          begin  s := s + IntToStr(I); Break; end;
        end;
        SendMessage(hKEmulator, WM_CLOSE, 0, 0);
        ManSoy.Global.DebugInf('�õ����ƣ�%s', [s]);
        if Length(s) <> 6 then
        begin
          ManSoy.Global.DebugInf('�ֻ����ƴ����˳�...', []);
          Exit;
        end;
        TokenPackData.szDnyPsw := s;
      end;
      50: //KM(old)
      begin
        ManSoy.Global.DebugInf('���ֻ�����ģ����...', []);
        ShellExecute(0, nil, PChar(KEMULATOR_BAT), nil, PChar(kemulatorDir_old), SW_HIDE);
        dwDealyTimes := GetTickCount;
        while GetTickCount - dwDealyTimes < 1 * 60 * 1000 do
        begin
          hKEmulator := FindWindow(nil, 'KEmulator Lite v0.9.8');
          if IsWindow(hKEmulator) then Break;
        end;
        if not IsWindow(hKEmulator) then
        begin
          ManSoy.Global.DebugInf('���ֻ�����ģ������ʱ���˳�...', []);
          Exit;
        end;
        ManSoy.Global.DebugInf('��ȡ�ֻ�����...', []);
        TokenPackData.szDnyPsw := DmUtils.fnFindWordByColor(hKEmulator, 50, 60, 200, 110, 'ffffff-000000', DIGIT_DICT, 0.8, 10);
        ManSoy.Global.DebugInf('�õ����ƣ�%s', [TokenPackData.szDnyPsw]);
        SendMessage(hKEmulator, WM_CLOSE, 0, 0);
        if StrToIntDef(TokenPackData.szDnyPsw, -1) = -1 then
        begin
          //LogOut('�ֻ����ƴ����˳�...', []);
          ManSoy.Global.DebugInf('MS - �ֻ����ƴ����˳�...', []);
          Exit;
        end;
      end;
    else //9891 KJava
      begin
        try
          IdTCPClient := TIdTCPClient.Create(nil);

          IdTCPClient.Host := FTokenServerIp;        //113.140.30.46
          IdTCPClient.Port := FTokenServerPort;      //59998
          ManSoy.Global.DebugInf('MS - %s,%d', [FTokenServerIp, FTokenServerPort]);
          IdTCPClient.Connect;   //�����м��\
          if IdTCPClient.Connected then
          begin
            try
              s := Base64ToStr(IdTCPClient.IOHandler.ReadLn());  //�����м����������Ϣ
              ManSoy.Global.DebugInf('MS - %s', [s]);
              try
                s := 'DATA:' + FAccount+'|'+FKey;
                ManSoy.Global.DebugInf('MS - %s', [s]);
                IdTCPClient.IOHandler.WriteLn(s);  //��������
                s := Base64ToStr(IdTCPClient.IOHandler.ReadLn());   //����token
                ManSoy.Global.DebugInf('MS - %s', [s]);
                if Pos('token:', s) > 0 then
                begin
                  s := copy(s, 7, length(s) - 6);
                  TokenPackData.szDnyPsw := s;
                end;
              except
                //logout('Reauest Middle-Server failed!', []);
                ManSoy.Global.DebugInf('MS - [GetToken] Reauest Middle-Server failed!', []);
                IdTCPClient.Disconnect();
              end;
            except
              //logout('Middle-Server no response!', []);
              ManSoy.Global.DebugInf('MS - [GetToken] Middle-Server no response!', []);
              IdTCPClient.Disconnect();
            end;
          end else
          begin
            ManSoy.Global.DebugInf('MS - [GetToken] Middle-Server no response!', []);
            Exit;
          end;
        except
          //logout('Connect Middle-Server failed!', []);
          ManSoy.Global.DebugInf('MS - [GetToken] Connect Middle-Server failed!', []);
        end;
      end;
    end;
    Result := TokenPackData.szDnyPsw;
    ManSoy.Global.DebugInf('MS - [GetToken] %s', [Result]);
  except on e:Exception do
    //LogOut('��ȡ�����쳣[%s]', [e.message]);
    ManSoy.Global.DebugInf('MS - [GetToken] %s', [e.Message]);
  end;
  finally
    if IdTCPClient <> nil then
      FreeAndNil(IdTCPClient);
    DeleteFile(tokenSrcZip_file); //ɾ������ѹ���ļ�
    DelDir(tokenSrc_dir);         //ɾ�����ƽ�ѹ����ļ���
    ClearDir(tokenDir_new);       //���������ļ�Ŀ¼
    ClearDir(tokenDir_old);       //���������ļ�Ŀ¼
    if IsWindow(hKEmulator) then
      SendMessage(hKEmulator, WM_CLOSE, 0, 0);
  end;
end;

function TWorkThread.QuitSafeByToken(ATokenCode: string): string;
var
  sRet   : string;
  wParam : TStrings;
  AResponseContent:TStringStream;
begin
  Result := '�ⰲȫʧ�ܣ�';
  wParam := TStringList.Create;
  AResponseContent := TStringStream.Create('', TEncoding.UTF8);
  wParam.Add('type=4');
  wParam.Add('token_code=' + ATokenCode);
  try
    try
      FDispatchHttp.Request.Clear;
      FDispatchHttp.Request.CustomHeaders.Clear;
      FDispatchHttp.Request.Accept := 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8';
      FDispatchHttp.Request.AcceptLanguage := 'zh-cn,zh;q=0.8,en-us;q=0.5,en;q=0.3';
      FDispatchHttp.Request.UserAgent :='Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20100101 Firefox/15.0.1';
      FDispatchHttp.Request.Connection :='keep-alive';
      //FDispatchHttp.Request.Referer := FQuitSafePageUrl;
      FDispatchHttp.Request.CustomHeaders.Text := 'Cookie: ' + FCookie;
      FDispatchHttp.Post(URL_QuitSafe1, wParam, AResponseContent);
      sRet := AResponseContent.DataString;
      //{$IFDEF DEBUG}
      AResponseContent.SaveToFile('1.html');
      FDispatchHttp.Request.CustomHeaders.SaveToFile('1.txt');
      //{$ENDIF}
      if sRet = '' then Exit;

      if Pos('�޷�ͨ����֤', sRet) > 0 then
      begin
        Result := '����֤�������࣬���Ժ��ٽ�����֤��';
        Exit;
      end;

      if Pos('������֤�ɹ�', sRet) > 0 then
      begin
        sRet := GetLeftStr('''',GetRightStr('top.location.href=''', sRet));
        AResponseContent.Clear;
        AResponseContent.Seek(0, soBeginning);
        sRet := StringReplace(sRet, 'safe_mode_remove.shtml?', 'json.php?', [rfReplaceAll]);
        sRet := sRet + '&mod=SafeMode&act=confirmRemove&callback=safeModeRemove.confirmRemoveCallback';
        FDispatchHttp.Get(sRet, AResponseContent);

        ManSoy.Global.DebugInf('MS - [QuitSafeByToken] success', []);
      end;
      Result := 'OK';
    except on e: Exception do
      ManSoy.Global.DebugInf('MS - [QuitSafeByToken] %s', [e.message]);
    end;
  finally
    FDispatchHttp.Disconnect;
    AResponseContent.Free;
    wParam.Free;
  end;
end;

function TWorkThread.QuitSafeBySms: Boolean;
var
  szHtml, sRet: string;
  wParam : TStrings;
  AResponseContent: TStringStream;
  dwTickcount: DWORD;
begin
  Result := False;

  //�����˷��ͽⰲȫ����

  ResetEvent(GSmsEvent);
  if not SendUnsafe() then Exit;
  //LogOut('���ڷ��Ͷ��Žⰲȫ(QQ=%s�����պ���=%s����������=%s)�����Ժ�...', [SafeData.QQ, SafeData.PhoneNum,SafeData.MsgContent]);
  WaitForSingleObject(GSmsEvent, 60 * 1000);  //--��һ����
  //��ҳ�ύ
  wParam := TStringList.Create;
  AResponseContent := TStringStream.Create('', TEncoding.UTF8);
  wParam.Add('type=2');
  try
    try
      FDispatchHttp.Request.Clear;
      FDispatchHttp.Request.CustomHeaders.Clear;
      FDispatchHttp.Request.Accept := 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8';
      FDispatchHttp.Request.AcceptLanguage := 'zh-cn,zh;q=0.8,en-us;q=0.5,en;q=0.3';
      FDispatchHttp.Request.UserAgent :='Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20100101 Firefox/15.0.1';
      FDispatchHttp.Request.Connection :='keep-alive';
      FDispatchHttp.Request.Referer := FQuitSafePageUrl;
      FDispatchHttp.Request.CustomHeaders.Text := 'Cookie: ' + FCookie;

      dwTickcount := GetTickCount;
      while GetTickCount - dwTickcount < 0.5 * 60 * 1000 do  //1����ʱ���������Ͷ���
      begin
        AResponseContent.Clear;
        AResponseContent.Seek(0, soBeginning);
        FDispatchHttp.Post(URL_QuitSafe1, wParam, AResponseContent);
        szHtml := AResponseContent.DataString;
        {$IFDEF DEBUG}
        AResponseContent.SaveToFile('Temp.html');
        {$ENDIF}
        if szHtml <> '' then
        begin
          if Pos('������֤�ɹ�',szHtml) > 0 then
          begin
            sRet := GetLeftStr('''',GetRightStr('top.location.href=''',szHtml));
            FDispatchHttp.Request.CustomHeaders.SaveToFile('PostRequest.txt');
            AResponseContent.Clear;
            AResponseContent.Seek(0, soBeginning);

            sRet := StringReplace(sRet, 'safe_mode_remove.shtml?', 'json.php?', [rfReplaceAll]);
            sRet := sRet + '&mod=SafeMode&act=confirmRemove&callback=safeModeRemove.confirmRemoveCallback';

            FDispatchHttp.Get(sRet, AResponseContent);
            szHtml := AResponseContent.DataString;
            Result := True;
            ManSoy.Global.DebugInf('MS - [QuitSafeBySms] success', []);
            //LogOut('�ⰲȫ���', []);
            Break;
          end else
          begin
            Sleep(5*1000);
            Continue;
          end;
        end;
      end;
      if not Result then
        //LogOut('�ⰲȫ��ʱ', []);
        ManSoy.Global.DebugInf('MS - �ⰲȫ��ʱ', []);
    except on e:Exception do
      ManSoy.Global.DebugInf('MS - [QuitSafeBySms] %s', [e.message]);
    end;
  finally
    FDispatchHttp.Disconnect;
    AResponseContent.Free;
    wParam.Free;
  end;
end;


function TWorkThread.RunJavaScript(const JsCode, JsVar: string): string;
var
  vScriptObject: OleVariant;
begin
  CoInitialize(nil);
  try
    try
      vScriptObject := CreateOleObject('ScriptControl');
      vScriptObject.Language := 'JavaScript';
      vScriptObject.ExecuteStatement(JsCode);
      Result := vScriptObject.Eval(JsVar);
    except
      Result := '';
    end;
  finally
    vScriptObject := Unassigned;
    CoUninitialize;
  end;
end;

procedure TWorkThread.OnRedirect(Sender: TObject; var dest: string;
  var NumRedirect: Integer; var Handled: Boolean; var VMethod: string);
begin
  FQuitSafePageUrl := dest;
end;

//==============================================================================

function OnSend(dwConnID: DWORD; const pData: Pointer; iLength: Integer): En_HP_HandleResult; stdcall;
begin
  //LogOut('[%d,OnSend] -> (%d bytes)', [dwConnID, iLength]);
  ManSoy.Global.DebugInf('MS - [%d,OnSend] -> (%d bytes)', [dwConnID, iLength]);
  Result := HP_HR_OK;
end;

function OnReceive(dwConnID: DWORD; const pData: Pointer; iLength: Integer): En_HP_HandleResult; stdcall;
var
  doRec: TDoClientRec;
begin
  SetEvent(GSmsEvent);
  ManSoy.Global.DebugInf('MS - [%d,OnReceive] -> (%d bytes)', [dwConnID, iLength]);
  //LogOut('[%d,OnReceive] -> (%d bytes)', [dwConnID, iLength]);
  doRec := TDoClientRec.Create(pClient, pData, iLength);
  doRec.Resume;
  Result := HP_HR_OK;
end;

function OnConnect(dwConnID: DWORD): En_HP_HandleResult; stdcall;
begin
  ManSoy.Global.DebugInf('MS - [%d,OnConnect]', [dwConnID]);
  //LogOut('[%d,OnConnect]', [dwConnID]);
  Result := HP_HR_OK;
end;

function OnCloseConn(dwConnID: DWORD): En_HP_HandleResult; stdcall;
begin
  ManSoy.Global.DebugInf('MS - [%d,OnCloseConn]', [dwConnID]);
  //LogOut('[%d,OnCloseConn]', [dwConnID]);
  Result := HP_HR_OK;
end;

function OnError(dwConnID: DWORD; enOperation: En_HP_SocketOperation; iErrorCode: Integer): En_HP_HandleResult; stdcall;
begin
  ManSoy.Global.DebugInf('MS - [%d,OnError] -> OP:%d,CODE:%d', [dwConnID, Integer(enOperation), iErrorCode]);
  //LogOut('[%d,OnError] -> OP:%d,CODE:%d', [dwConnID, Integer(enOperation), iErrorCode]);
  Result := HP_HR_OK;
end;

function TWorkThread.ConnectServer(AIP: string; APort: Integer): Boolean;
var
  ini: TIniFile;
  fileName: string;
  ip: PWideChar;
  port: USHORT;
begin
  Result := False;
  if (HP_Client_Start(pClient, PWideChar(AIP), APort, False)) then
  begin
    Result := True;
    ManSoy.Global.DebugInf('MS - Client connected -> (%s:%d)', [AIP, APort]);
    //LogOut('Client connected -> (%s:%d)', [AIP, APort]);
  end else
  begin
    ManSoy.Global.DebugInf('MS - Client connect error -> (%s:%d)',
      [HP_Client_GetLastErrorDesc(pClient), Integer( HP_Client_GetLastError(pClient))]);
    //LogOut('Client connect error -> (%s:%d)', [HP_Client_GetLastErrorDesc(pClient),
    //Integer( HP_Client_GetLastError(pClient))]);
  end;
end;

function TWorkThread.DisconnectServer: Boolean;
begin
  Result := False;
  if (HP_Client_Stop(pClient)) then
  begin
    Result := True;
    ManSoy.Global.DebugInf('MS - Client Disconnected', []);
    //LogOut('Client Disconnected', [])
  end else
  begin
    ManSoy.Global.DebugInf('MS - Client Disconnected Error -> %s(%d)',
      [HP_Client_GetLastErrorDesc(pClient), Integer(HP_Client_GetLastError(pClient))]);
    //LogOut('Client Disconnected Error -> %s(%d)', [HP_Client_GetLastErrorDesc(pClient),
    //          Integer(HP_Client_GetLastError(pClient))]);
  end;
end;

function TWorkThread.SendData(pData: Pointer; ALen: Integer): Boolean;
begin
  Result := HP_Client_Send(pClient, pData, ALen);
end;

function TWorkThread.SendUnsafe: Boolean;
var
  dwConnID: DWORD;
  vData: PSafeData;
begin
  Result := False;
  if not ConnectServer(FSmsServerIp, FSmsServerPort) then Exit;

  dwConnID := HP_Client_GetConnectionID(pClient);
  //New(vData);
  GetMem(vData, SizeOf(vData));
  try
    vData.CommType := TCommType.ctUnSafe;
    vData.QQ := SafeData.QQ;                 //QQ��
    vData.PhoneNum := SafeData.PhoneNum;     //�ռ��ֻ�
    vData.MsgContent := SafeData.MsgContent; //��������
    if SendData(vData, SizeOf(TSafeData)) then
    begin
      ManSoy.Global.DebugInf('MS - ConnId=%d, Send unsafe cmmand successful, QQ=%s', [dwConnID, vData.QQ]);
      //LogOut('ConnId=%d, Send unsafe cmmand successful, QQ=%s', [dwConnID, vData.QQ]);
    end else
    begin
      ManSoy.Global.DebugInf('MS - ConnId=%d, Send unsafe cmmand failed, QQ=%s', [dwConnID, vData.QQ]);
      //LogOut('ConnId=%d, Send unsafe cmmand failed, QQ=%s', [dwConnID, vData.QQ]);
      Exit;
    end;
  finally
    FreeMem(vData);
  end;
  Result := True;
end;

{ TDoClientRec }

constructor TDoClientRec.Create(AClient, AData: Pointer; ALen: Integer);
begin
  inherited Create(True);
  pClient := AClient;
  Len := ALen;
  GetMem(pData, Len);
  CopyMemory(pData, AData, Len);
  FreeOnTerminate := True;
end;

procedure TDoClientRec.DealResultMsg;
var
  vResultInfo: TResultInfo;
  isSucc: Boolean;
begin
  //�ӵ����񷵻ص���Ϣ
  vResultInfo := TResultInfo(pData^);
  ResultInfo.ResultState :=  vResultInfo.ResultState;
  ResultInfo.ResuleMsg := vResultInfo.ResuleMsg;
  ManSoy.Global.DebugInf('MS - %s',[vResultInfo.ResuleMsg]);
  //LogOut(vResultInfo.ResuleMsg, []);
end;

destructor TDoClientRec.Destroy;
begin
  FreeMem(pData, Len);
  inherited;
end;

procedure TDoClientRec.Execute;
var
  vCmdType: TCommType;
begin
  if Len <= 0 then Exit;
  try
    try
      vCmdType := TCommType(pData^);
      case vCmdType of
        ctNone     : ;
        ctResult   : DealResultMsg;
        ctGroupName: ;
        ctSendMsg  : ;
        ctRecvMsg  : ;
        ctUnSafe   : ;
      end;
    except
    end;
  finally
  end;
end;

initialization
  GSmsEvent := CreateEvent(nil, True, False, 'SmsEvent');

finalization
  CloseHandle(GSmsEvent);

end.
