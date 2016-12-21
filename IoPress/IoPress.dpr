program IoPress;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  uMsKm in '..\Comm\uMsKm.pas',
  ManSoy.Encode in '..\Global\ManSoy.Encode.pas';

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
      uMsKm.MsKmPressPassword(hPwd, PAnsiChar(AnsiString(sPwd)));
    end;

    if iCmd = 2 then
    begin
      uMsKm.MsKmKeyPress(StrToIntDef(ParamStr(2), 0));
    end;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
