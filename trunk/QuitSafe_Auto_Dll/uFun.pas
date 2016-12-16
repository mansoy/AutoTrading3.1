unit uFun;

interface

uses
  Winapi.Windows, Winapi.ShellAPI, Vcl.FileCtrl, System.SysUtils, System.Zip,
  uData;

  procedure LogToFile(aText: string);
  procedure Unzip(srcFile, destDir: string);

  function DelDir(const Source: string): Boolean;
  function ClearDir(const DirName: string; IncludeSub: Boolean = True; ToRecyle: Boolean = false): Boolean;
  function CopyDir(const srcDir, destDir: string; includeDir: boolean = true): boolean;

  procedure LogOut(aText: string; const Args: array of const; aDebug: Boolean = false);

implementation

{����Ϣд����־�ļ�}
procedure LogToFile(aText: string);
var
  f: TextFile;
  dir, fileName: string;
begin
  dir := ExtractFilePath(ParamStr(0))+'Log\';
  if not DirectoryExists(dir) then ForceDirectories(dir);
  fileName := dir+FormatDateTime('yyyyMMdd',Now)+'.log';
  try
    try
      AssignFile(F, fileName); {���ļ�������� F ����}
      if FileExists(fileName) then
        Append(f) //�ļ����ڣ�����׷�ӷ�ʽ��
      else
        Rewrite(f); //�ļ������ڣ��򴴽�����

      Writeln(F, aText); //���ļ�ĩβ�������
      //Flush(f); //��ջ�������ȷ���ַ����Ѿ�д���ļ�֮��
    except
    end;
  finally
    CloseFile(f);
  end;
end;

{ɾ��Ŀ¼}
function DelDir(const Source: string): Boolean;
var
  fo: TSHFileOpStruct;
begin
  try
    FillChar(fo, SizeOf(fo), 0);
    with fo do
    begin
      Wnd := 0;
      wFunc := FO_DELETE;
      pFrom := PChar(Source + #0);
      pTo := #0#0;
      fFlags := FOF_NOCONFIRMATION + FOF_SILENT;
    end;
    Result := (SHFileOperation(fo) = 0);
  except
  end;
end;

{���Ŀ¼�µ�����}
function ClearDir(const DirName: string; IncludeSub: Boolean; ToRecyle: Boolean): Boolean;
var
  fo: TSHFILEOPSTRUCT;
begin
  try
    FillChar(fo, SizeOf(fo), 0);
    with fo do
    begin
      Wnd := 0;
      wFunc := FO_DELETE;
      pFrom := PChar(DirName + '\*.*' + #0);
      pTo := #0#0;
      fFlags := FOF_SILENT or FOF_NOCONFIRMATION or FOF_NOERRORUI
        or (Ord(not IncludeSub) * FOF_FILESONLY);
      if ToRecyle then
        fFlags := fFlags or FOF_ALLOWUNDO;
    end;
    Result := (SHFileOperation(fo) = 0);
  except
  end;
end;

//��һ��Ŀ¼��������һ��Ŀ¼
function CopyDir(const srcDir, destDir: string; includeDir: boolean): boolean;
var
  fo: TSHFILEOPSTRUCT;
begin
  Result := False;
  if not DirectoryExists(srcDir) then Exit;
  try
    FillChar(fo, SizeOf(fo), 0);
    with fo do
    begin
      Wnd := 0;
      wFunc := FO_COPY;
      if includeDir then
        pFrom := PChar(srcDir+#0)
      else
        pFrom := PChar(srcDir + '\*.*' + #0);
      pTo := PChar(destDir+#0);
      fFlags := FOF_NOCONFIRMATION or FOF_NOCONFIRMMKDIR;
    end;
    Result := (SHFileOperation(fo) = 0);
  except
  end;
end;

procedure Unzip(srcFile, destDir: string);
var
  zip: TZipFile;
begin
  zip := TZipFile.Create;
  zip.Open(srcFile, TZipMode.zmRead);
  zip.ExtractAll(destDir);
  zip.Close;
  zip.Free;
end;

procedure LogOut(aText: string; const Args: array of const; aDebug: Boolean);
var
  sMsg: string;
begin
  //sMsg := System.SysUtils.Format(aText, Args, FormatSettings);
  //sMsg := '['+FormatDateTime('yyyy-MM-dd HH:mm:ss', Now)+']'+sMsg;
  //{$IFDEF DEBUG}
  //SendMessage(GMainHandle, WM_ADD_LOG, 0, LPARAM(sMsg));
  //{$ENDIF}
  //LogToFile(sMsg);
end;

end.
