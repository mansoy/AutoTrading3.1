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
  ManSoy.Global.DebugInf('MS - �ⰲȫģ���Ѽ���...', []);
end;

/// <summary>
/// AMBType: 40-KM(new)  50-KM(old) 60-SMS other(9891 KJava)
/// </summary>
function QQSafe(AGameID  : Integer;   //��ϷID  0-���³�����ʿ 1-�������� 2-���� 3-��ս��
                AAccount : PAnsiChar; //��Ϸ�˺�
                APassWord: PAnsiChar; //��Ϸ����
                AArea    : PAnsiChar; //��Ϸ-��
                AServer  : PAnsiChar; //��Ϸ-��
                AMBType  : Integer;   //�ܱ�����
                AKey     : PAnsiChar  //OAУ��Key (AMBTypeΪ9891��������ʱ����Ҫ����˲���)
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
    if not OpenLoginPage then  //��ȡlogin_sig
    begin
      sRet := Format('[%s]-[%d]�򿪰�ȫ��¼ҳ��ʧ��!', [sAccount, AMBType]);
      Result := PAnsiChar(AnsiString(sRet));
      Exit;
    end;
    if not CheckVC() then
    begin
      sRet := Format('[%s]-[%d]����˺��Ƿ���Ҫ��֤��ʧ��!', [sAccount, AMBType]);
      Result := PAnsiChar(AnsiString(sRet));
      Exit;
    end;
    if not GetCheckCode() then
    begin
      sRet := Format('[%s]-[%d]��ȡ��֤��ʧ��!', [sAccount, AMBType]);
      Result := PAnsiChar(AnsiString(sRet));
      Exit;
    end;
    if not LoginQQ() then
    begin
      sRet := Format('[%s]-[%d]��¼ʧ��!', [sAccount, AMBType]);
      Result := PAnsiChar(AnsiString(sRet));
      Exit;
    end;
    //--��ȡQQ�󶨷�ʽ
    iBind := GetBindType;
    if (iBind <> 20000) and (iBind <> 10000) then
    begin
      sRet := Format('[%s]-[%d]û�а��ֻ����ƻ��ֻ�����!', [sAccount, AMBType]);
      Result := PAnsiChar(AnsiString(sRet));
      Exit;
    end;
    //--��ȡ�ֻ�����Token
    if (iBind = 10000) then
    begin
      if StrToIntDef(GetToken(AMBType), -1) = -1 then
      begin
        sRet := Format('[%s]-[%d]��ȡ�ֻ����ƴ���!', [sAccount, AMBType]);
        Result := PAnsiChar(AnsiString(sRet));
        Exit;
      end;
    end;

    //Post�ⰲȫ
    if AMBType = 60 then
    begin
      //���Žⰲȫ
      if not QuitsafeBySms() then
      begin
        sRet := Format('[%s]-[%d]�ⰲȫʧ��!', [string(AAccount^), AMBType]);
        Result := PAnsiChar(AnsiString(sRet));
        Exit;
      end;
    end else
    begin
      //���ƽⰲȫ
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
