program IoPress;

{$APPTYPE CONSOLE}

{$R *.res}

{$DEFINE USE_WINIO}
//{$DEFINE USE_MSKM}

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  uMsKm in '..\Comm\uMsKm.pas',
  ManSoy.Encode in '..\Global\ManSoy.Encode.pas',
  uWinIO in '..\Comm\uWinIO.pas';

var
  iCmd: Integer;
  sPwd: string;
  hPwd: HWND;
begin
  try
    { TODO -oUser -cConsole Main : Insert code here }
    if ParamCount < 2 then
    begin
      MessageBox(0, '传入参数数量不够', '提示', MB_ICONINFORMATION);
      Exit;
    end;
    iCmd := StrToIntDef(ParamStr(1), 0);
    if (iCmd <> 1) and (iCmd <> 2) then
    begin
      MessageBox(0, '传入参数类型错误', '提示', MB_ICONINFORMATION);
      Exit;
    end;
    Sleep(2000);
    if (iCmd = 1) then
    begin
      sPwd := ManSoy.Encode.Base64ToStr(ParamStr(3));
      hPwd := StrToIntDef(ParamStr(2), 0);
      {$IFDEF USE_MSKM}
      uMsKm.MsKmPressPassword(hPwd, PAnsiChar(AnsiString(sPwd)));
      {$ENDIF}
      {$IFDEF USE_WINIO}
      uWinIo.IoPressPwd(sPwd);
      {$ENDIF}
    end;

    if iCmd = 2 then
    begin
      {$IFDEF USE_MSKM}
      uMsKm.MsKmKeyPress(StrToIntDef(ParamStr(2), 0));
      {$ENDIF}
      {$IFDEF USE_WINIO}
      uWinIo.IoPressKey(StrToIntDef(ParamStr(2), 0));
      {$ENDIF}
    end;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
