unit uFrmLogs;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Winapi.TlHelp32
  , uGlobal, IdBaseComponent, IdComponent, IdIPWatch;

type
  TFrmLogs = class(TForm)
    LstLog: TListBox;
    Panel2: TPanel;
    btnClear: TButton;
    btnSelAll: TButton;
    btnCopy: TButton;
    Timer1: TTimer;
    IdIPWatch1: TIdIPWatch;
    chkAutoConn: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure btnSelAllClick(Sender: TObject);
    procedure btnCopyClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure chkAutoConnClick(Sender: TObject);
  private
    { Private declarations }
    function HookOn(dwProcessID: DWORD): Boolean;
    procedure WMAddLog(var Mes: TMessage); message WM_ADD_LOG;
    procedure WMHookOn(var Mes: TMessage); message WM_HOOK_ON;
  protected
    procedure CreateParams(var Parames:TCreateParams); override;
  public
    { Public declarations }
  end;

  TWorkThread = class(TThread)
  private
    function ConnConsole: Boolean;
  protected
    procedure Execute; override;
  public
    constructor Create(); overload;
    destructor Destroy; override;
  end;

var
  FrmLogs: TFrmLogs;

implementation

uses
   Vcl.Clipbrd
  , ManSoy.Global
  , ManSoy.MsgBox
  , uTradeClient
  , HPSocketSDKUnit
  , uCommand
  , uCommFuns
  ;

{$R *.dfm}

procedure TFrmLogs.btnClearClick(Sender: TObject);
begin
  LstLog.Clear;
end;

procedure TFrmLogs.btnCopyClick(Sender: TObject);
var
  I: Integer;
  sText: string;
begin
  for I := 0 to LstLog.Count - 1 do
  begin
    if LstLog.Selected[I] then
    begin
      sText := sText + LstLog.Items.Strings[i] + #13;
    end;
  end;
  Clipboard.SetTextBuf(PWideChar(sText));
end;

procedure TFrmLogs.btnSelAllClick(Sender: TObject);
begin
  LstLog.SelectAll;
end;

procedure TFrmLogs.chkAutoConnClick(Sender: TObject);
begin
  GSharedInfo.ClientSet.AutoConn := chkAutoConn.Checked;
end;

procedure TFrmLogs.CreateParams(var Parames: TCreateParams);
var
  sClassName: string;
  sCaption: string;
begin
  inherited CreateParams(Parames);
  sClassName := ManSoy.Global.GetGUID;
  sCaption := ManSoy.Global.GetOnlyOneString;
  Parames.Caption := PWideChar(sCaption);
  lstrcpyn(Parames.WinClassName, PWideChar(sClassName), SizeOf(Parames.WinClassName));
end;

procedure TFrmLogs.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if GSharedInfo.bWork then
  begin
    CanClose := ManSoy.MsgBox.AskMsg(Self.Handle, '���ڴ�������ȷ���˳�?', []) = IDYES;
  end;
  if CanClose then
  begin
    PostQuitMessage(0);
  end;
end;

procedure TFrmLogs.FormCreate(Sender: TObject);
var
  hWnd: THandle;
begin
  //LoadCfg;
  GSharedInfo.MainFormHandle := Self.Handle;
  SystemParametersInfo(SPI_SETFONTSMOOTHING, 0, 0, 1);

  //LoadLibrary(PWideChar(GSharedInfo.AppPath + 'test.dll'));

  Self.Left := Screen.WorkAreaWidth - Self.Width;
  Self.Top  := Screen.WorkAreaHeight - Self.Height;

  GSharedInfo.MainFormHandle  := Self.Handle;
  GSharedInfo.bWork           := False;
  GSharedInfo.LocalIP         := IdIPWatch1.LocalIP;
  if GSharedInfo.LocalIP = '' then GSharedInfo.LocalIP := '0.0.0.0';
  AddLogMsg('Local IP: %s', [GSharedInfo.LocalIP], True);
  chkAutoConn.Checked := GSharedInfo.ClientSet.AutoConn;
  TWorkThread.Create;
  LstLog.Clear;

  //--�ر�������
  hWnd := FindWindow('TFrmMain', 'DToolClient');
  if IsWindow(hWnd) then
  begin
    SendMessage(hWnd, WM_CLOSE, 0, 0);
  end;
end;

procedure TFrmLogs.FormDestroy(Sender: TObject);
begin
  SystemParametersInfo(SPI_SETFONTSMOOTHING, 1, 0, 1);
  GAppQuit := True;
  ExitProcess(0);
end;

function TFrmLogs.HookOn(dwProcessID: DWORD): Boolean;
type
  THookOn = function(APID: DWORD): Boolean;
var
  hLib: THandle;
  PHoonOn: THookOn;
begin
  Result := False;
  try
    hLib := LoadLibrary(PWideChar(GSharedInfo.AppPath + 'KillProcess.dll'));
    if hLib <> 0 then
    begin
      @PHoonOn := GetProcAddress(hLib, 'HookOn');
      if Assigned(PHoonOn) then
      begin
        Result := PHoonOn(dwProcessID);
      end;
      FreeLibrary(hLib);
    end;
  except on E: Exception do
    AddLogMsg('MS - HookOn Fail[%s]', [E.Message]);
  end;
end;

procedure TFrmLogs.WMAddLog(var Mes: TMessage);
begin
  if LstLog.Count > 100 then
  begin
    LstLog.Items.Delete(0);
  end;
  LstLog.Items.Add(string(Mes.LParam));
  LstLog.ClearSelection;
  LstLog.Selected[LstLog.Count - 1] := True;
end;

procedure TFrmLogs.WMHookOn(var Mes: TMessage);
var
  hGame: HWND;
begin
  GCommFuns.BeginVMP;
  try
    EnabledDebugPrivilege();
    hGame := HWND(Mes.LParam);
    if IsWindow(hGame) then
    begin
      HookOn(hGame);
    end;
  except
  end;
  GCommFuns.EndVMP;
end;

{ TWorkThread }

function TWorkThread.ConnConsole: Boolean;
begin
  Result := False;
  try
    if GSharedInfo.ClientSet.AutoConn and (TradeClient.AppState = ST_STOPED) then
    begin
      GSharedInfo.bConnOK := False;
      TradeClient.Host := GSharedInfo.ClientSet.ConsoleHost;
      TradeClient.Port := GSharedInfo.ClientSet.ConsolePort;
      TradeClient.Start;
      if TradeClient.AppState = ST_STARTED then
        uCommand.Cmd_Conn(TradeClient.Client, GSharedInfo.ClientSet.GroupName);
    end;

    if (not GSharedInfo.ClientSet.AutoConn) and (TradeClient.AppState = ST_STARTED) then
    begin
      TradeClient.Stop;
      GSharedInfo.bConnOK := False;
    end;
    Result := False;
  except
  end;
end;

constructor TWorkThread.Create;
begin
  FreeOnTerminate := True;
  inherited Create(False);
end;

destructor TWorkThread.Destroy;
begin
  inherited;
end;

procedure TWorkThread.Execute;
  procedure KillAdditionalProcess;
  var
    lppe: TProcessEntry32;
    SsHandle: Thandle;
    FoundAProc: boolean;
    sProcessName: string;
    hGame: HWND;
  begin
    { ����ϵͳ���� }
    SsHandle := CreateToolHelp32SnapShot(TH32CS_SnapProcess, 0);

    { ȡ�ÿ����еĵ�һ������ }
    { һ��Ҫ���ýṹ�Ĵ�С,���򽫷���False }
    lppe.dwSize := sizeof(TProcessEntry32);
    FoundAProc := Process32First(Sshandle, lppe);
    hGame := FindWindow(nil, '���³�����ʿ��¼����');
    if IsWindow(hGame) then Exit;
    hGame := FindWindow('���³�����ʿ', '���³�����ʿ');
    if not IsWindow(hGame) then Exit;
    if not IsWindowVisible(hGame) then Exit;
    while FoundAProc do
    begin
      Sleep(1);
      sProcessName := ExtractFilename(lppe.szExefile);
      if (sProcessName = 'tgp_gamead.exe') or (sProcessName = 'CrossProxy.exe') or (sProcessName = 'QQProtect.exe') or (sProcessName = 'BackgroundDownloader.exe') or (sProcessName = 'TenioDL.exe') then
      begin
        AddLogMsg(sProcessName, [], True);
        KillProcessByID(lppe.th32ProcessID);
        Break;
      end;
      { δ�ҵ�,������һ������ }
      FoundAProc := Process32Next(SsHandle, lppe);
    end;
    CloseHandle(SsHandle);
  end;

  function EnumWindowsProc(hWnd: HWND; lParam: LPARAM): Boolean; stdcall;
  var
    sProcessName: string;
    TempClassName: array[0..255] of Char;
    TempWindowText: array[0..255] of Char;
    dwPid: DWORD;
  begin
    Result := true;
    dwPid := GetProcessIdByHandle(hWnd);
    sProcessName := ExtractFileName(GetProcessName(hWnd));

    GetClassName(hWnd, TempClassName , 256);
    GetWindowText(hWnd, TempWindowText, 256);

    if ((sProcessName = 'QQMusicExternal.exe') or
        (sProcessName = 'QQMusicService.exe') or
        (sProcessName = 'QQMusicIE.exe')) and
        ((string(TempClassName) <> 'Progman') and (string(TempWindowText) <> 'Program Manager')) and
        ((string(TempClassName) <> 'SysListView32') and (string(TempWindowText) <> 'FolderView')) and
        ((string(TempClassName) <> 'SysHeader32')) and
        ((string(TempClassName) <> 'SHELLDLL_DefView')) and
        IsWindowVisible(hWnd) then
    begin
      //CloseWindow(hWnd);
      //SendMessage(hWnd, WM_CLOSE, 0, 0);
      ShowWindow(hWnd, SW_HIDE);
      Result := False;
    end;

    if (sProcessName = 'QQMusic.exe') and (lstrcmp('TXGuiFoundation', TempClassName) = 0) and IsWindowVisible(hWnd) then
    begin
      ShowWindow(hWnd, SW_HIDE);
      Result := False;
    end;

    if (lstrcmp('����', TempWindowText) = 0) and (lstrcmp('#32770', TempClassName) = 0) then
    begin
      SendMessage(hWnd, WM_CLOSE, 0, 0);
      Result := False;
    end;

    if (lstrcmp('DNF��Ƶ������', TempWindowText) = 0) and (lstrcmp('TWINCONTROL', TempClassName) = 0) then
    begin
      SendMessage(hWnd, WM_CLOSE, 0, 0);
      Result := False;
    end;

    if (lstrcmp('<����> ����汾:3.1233', TempWindowText) = 0) then
    begin
      SendMessage(hWnd, WM_CLOSE, 0, 0);
      Result := False;
    end;

    if (lstrcmp('Dungeon & Fighter', TempWindowText) = 0) then
    begin
      SendMessage(hWnd, WM_CLOSE, 0, 0);
      Result := False;
    end;

    if (lstrcmp('TASLogin Application', TempWindowText) = 0) then
    begin
      SendMessage(hWnd, WM_CLOSE, 0, 0);
      Result := False;
    end;
  end;
var
  bConned : Boolean;
  //vAutoSend: TAutoSend;
  I: Integer;
begin
  //asm
  //  db $EB,$10,'VMProtect begin',0       //��ǿ�ʼ��.
  //end;
  while not Terminated do
  try
    Sleep(200);
    if GAppQuit then Break;
    {$IFNDEF _MS_DEBUG}
//    SendMessage(FindWindow(nil, '<����> ����汾:3.1233'), WM_CLOSE, 0, 0);
//    SendMessage(FindWindow(nil, 'Dungeon & Fighter'), WM_CLOSE, 0, 0);
//    SendMessage(FindWindow(nil, 'TASLogin Application'), WM_CLOSE, 0, 0);
    EnumWindows(@EnumWindowsProc, 0);
    //colin20150707
    //KillAdditionalProcess;
    {$ENDIF}
    ConnConsole;
    //--���������û�����ӵ�����̨���򲻽��д���
    if TradeClient.AppState <> ST_STARTED then Continue;
    if not GSharedInfo.bConnOK then Continue;
    if GConsoleSet = nil then
    begin
      TradeClient.GetParam(GSharedInfo.ClientSet.GroupName);
      Sleep(1000);
    end;

    if GConsoleSet = nil then Continue;

    if GSharedInfo.bWork then
    begin
      Continue;
    end;
    //--������������У����ȡ�������з���
    TradeClient.GetTask(GSharedInfo.ClientSet.GroupName);
  except
  end;
  //asm
  //  db $EB,$0E,'VMProtect end',0       //��ǿ�ʼ��.
  //end;
end;

end.
