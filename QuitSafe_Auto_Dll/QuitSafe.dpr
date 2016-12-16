library QuitSafe;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

uses
  System.SysUtils,
  System.Classes,
  uData in 'uData.pas',
  uWork in 'uWork.pas',
  uDm in 'comm\uDm.pas' {dm: TDataModule},
  uPublic in '..\Comm\uPublic.pas',
  HPSocketSDKUnit in '..\Comm\HPSocketSDKUnit.pas',
  ManSoy.Encode in '..\Global\ManSoy.Encode.pas',
  ManSoy.Global in '..\Global\ManSoy.Global.pas',
  ManSoy.IniFiles in '..\Global\ManSoy.IniFiles.pas',
  ManSoy.MsgBox in '..\Global\ManSoy.MsgBox.pas',
  ManSoy.StrSub in '..\Global\ManSoy.StrSub.pas',
  uCommFuns in '..\Comm\uCommFuns.pas';

{$R *.res}

procedure MyEntry; stdcall;
begin
  ManSoy.Global.DebugInf('MS - 解安全模块已加载...', []);
end;

/// <summary>
/// AMBType: 40-KM(new)  50-KM(old) 60-SMS other(9891 KJava)
/// </summary>
function QQSafe(AGameID  : Integer;   //游戏ID  0-地下城与勇士 1-御龙在天 2-剑灵 3-斗战神
                AAccount : PAnsiChar; //游戏账号
                APassWord: PAnsiChar; //游戏密码
                AArea    : PAnsiChar; //游戏-区
                AServer  : PAnsiChar; //游戏-服
                AMBType  : Integer;   //密保类型
                AKey     : PAnsiChar  //OA校验Key (AMBType为9891数字令牌时，需要传入此参数)
                ): PAnsiChar; stdcall; export;
var
  iBind: Integer;
  sAccount,sPassword,sArea,sServer,sKey: string;
  sRet: string;
begin
  Result := '';
  sAccount := string(AnsiString(AAccount));
  sPassword := ManSoy.Base64.Base64ToStr(AnsiString(APassWord));
  sArea := '';
  if AArea <> '' then
    sArea := string(AnsiString(AArea));
  sServer := '';
  if sServer <> '' then
    sServer := string(AnsiString(AServer));
  sKey := '';
  if AKey <> '' then
    sKey := string(AnsiString(AKey));

  with TWorkThread.Create(AGameID,
                          sAccount,
                          sPassword,
                          sArea,
                          sServer,
                          AMBType,
                          sKey) do
  try
    if not OpenLoginPage then  //获取login_sig
    begin
      sRet := Format('[%s]-[%d]打开安全登录页面失败!', [sAccount, AMBType]);
      Result := PAnsiChar(AnsiString(sRet));
      Exit;
    end;
    if not CheckVC() then
    begin
      sRet := Format('[%s]-[%d]检测账号是否需要验证码失败!', [sAccount, AMBType]);
      Result := PAnsiChar(AnsiString(sRet));
      Exit;
    end;
    if not GetCheckCode() then
    begin
      sRet := Format('[%s]-[%d]获取验证码失败!', [sAccount, AMBType]);
      Result := PAnsiChar(AnsiString(sRet));
      Exit;
    end;
    if not LoginQQ() then
    begin
      sRet := Format('[%s]-[%d]登录失败!', [sAccount, AMBType]);
      Result := PAnsiChar(AnsiString(sRet));
      Exit;
    end;
    //--获取QQ绑定方式
    iBind := GetBindType;
    if (iBind <> 20000) and (iBind <> 10000) then
    begin
      sRet := Format('[%s]-[%d]没有绑定手机令牌或手机短信!', [sAccount, AMBType]);
      Result := PAnsiChar(AnsiString(sRet));
      Exit;
    end;
    //--获取手机令牌Token
    if (iBind = 10000) then
    begin
      if StrToIntDef(GetToken(AMBType), -1) = -1 then
      begin
        sRet := Format('[%s]-[%d]获取手机令牌错误!', [sAccount, AMBType]);
        Result := PAnsiChar(AnsiString(sRet));
        Exit;
      end;
    end;

    //Post解安全
    if AMBType = 60 then
    begin
      //短信解安全
      if not QuitsafeBySms() then
      begin
        sRet := Format('[%s]-[%d]解安全失败!', [string(AAccount^), AMBType]);
        Result := PAnsiChar(AnsiString(sRet));
        Exit;
      end;
    end else
    begin
      //令牌解安全
      sRet := QuitSafeByToken(TokenPackData.szDnyPsw);
    end;
    Result := PAnsiChar(AnsiString(sRet));
  finally
    Free;
  end;
end;

exports
  QQSafe;

begin
  //
end.
