unit uFrmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, Vcl.Dialogs, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.StdCtrls, uGlobal, Vcl.ExtCtrls;

type
  TFrmMain = class(TForm)
    btnStart: TButton;
    btnConfig: TButton;
    Timer1: TTimer;
    procedure btnConfigClick(Sender: TObject);
    procedure btnStartClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
    //function HookOn(AProcessId: DWORD): Boolean;
    procedure WmHookOn(var Msg: TMessage); message WM_HOOK_ON;
  public
    { Public declarations }
    //property TheHostHandle: HWND read FTheHostHandle write FTheHostHandle;
  end;

  TWorkThread = class(TThread)
  private
    FTheHostHandle: HWND;

  protected
    procedure Execute; override;
  public
    constructor Create(); overload;
    destructor Destroy; override;
  end;

var
  FrmMain: TFrmMain;

function HookOn(dwProcessID: DWORD): Boolean; stdcall; external 'TradeModule.dll' name 'HookOn';

implementation

uses
  System.IniFiles
  , ManSoy.Global
  , ManSoy.MsgBox
  , uFrmConfig
  ;

{$R *.dfm}

function EnumWindowsProc(hWnd: HWND; lParam: LPARAM): Boolean; stdcall;
var
  TempClassName : array[0..255] of Char;
  sProcessName: string;
  dwPid: DWORD;
begin
  Result := true;
  GetClassName(hWnd, TempClassName , 256);
  if (lstrcmp('TXGuiFoundation', TempClassName) = 0) then
  //if (lstrcmp('RCMainWnd', TempClassName) = 0) then
  begin
    dwPid := GetProcessIdByHandle(hWnd);
    sProcessName := ExtractFileName(GetProcessName(hWnd));
    if (sProcessName = 'QQMusic.exe') and IsWindowVisible(hWnd) then
    //if (sProcessName = 'HaoZip.exe') and IsWindowVisible(hWnd) then
    begin
      //FrmMain.TheHostHandle := hWnd;
      THandle(Pointer(lParam)^) := hWnd;
      Result := False;
    end;
  end;
end;

//function TFrmMain.HookOn(AProcessId: DWORD): Boolean;
//type
//  THookOn = function(APID: DWORD): Boolean of object;
//var
//  hLib: THandle;
//  pHookOn: THookOn;
//begin
//  Result := False;
//  try
//    hLib := LoadLibrary('TradeModule.dll');
//    if hLib <> 0 then
//    begin
//      @pHookOn := GetProcAddress(hLib, 'HookOn');
//      if Assigned(pHookOn) then
//      begin
//        pHookOn(AProcessId);
//      end;
//      FreeLibrary(hLib);
//      Result := True;
//    end;
//  except
//  end;
//end;

procedure TFrmMain.btnConfigClick(Sender: TObject);
var
  F: TFrmConfig;
begin
  F := TFrmConfig.Create(Self);
  try
    F.ShowModal;
  finally
    FreeAndNil(F);
  end;
end;

procedure TFrmMain.btnStartClick(Sender: TObject);
begin
  TWorkThread.Create;
end;

procedure TFrmMain.Timer1Timer(Sender: TObject);
begin
  try
    btnStart.Click;
  finally
    TTimer(Sender).Enabled := False;
  end;
end;

procedure TFrmMain.WmHookOn(var Msg: TMessage);
var
  hWindow: HWND;
begin
  //GCommFuns.BeginVMP;
  try
    EnabledDebugPrivilege();
    hWindow := HWND(Msg.LParam);
    if IsWindow(hWindow) then
    begin
      if HookOn(hWindow) then
      begin
      end;
    end;
  except
  end;
  //GCommFuns.EndVMP;
end;

{ TWorkThread }

constructor TWorkThread.Create;
begin
  FrmMain.btnStart.Enabled := False;
  FreeOnTerminate := True;
  inherited Create(False);
end;

destructor TWorkThread.Destroy;
begin
  FrmMain.btnStart.Enabled := True;
  inherited;
end;

procedure TWorkThread.Execute;
var
  hTheHost: HWND;
begin
  while True do
  try
    //ShowMessage(GSharedInfo.AppPath);
    if not FileExists(GSharedInfo.ClientSet.TheHost) then
    begin
      ManSoy.MsgBox.WarnMsg(Self.Handle, '请先设置宿主程序路径', []);
      Exit;
    end;

    EnumWindows(@EnumWindowsProc, LPARAM(@hTheHost));

    if IsWindow(hTheHost) then
    begin
      SendMessage(FrmMain.Handle, WM_HOOK_ON, 0, LPARAM(hTheHost));
      Break;
    end else
    begin
      //ShowMessage(GSharedInfo.ClientSet.TheHost);
      WinExec(PAnsiChar(AnsiString(GSharedInfo.ClientSet.TheHost)), SW_NORMAL);
      Sleep(3000);
    end;
    Sleep(1000);
  except
  end;
end;

//function TWorkThread.GetTheHostHandle: HWND;
//begin
//  FTheHostHandle := INVALID_HANDLE_VALUE;
//  EnumWindows(@EnumWindowsProc, 0);
//  Result := FTheHostHandle;
//end;
//
//function TWorkThread.Inject(hWnd: HWND): Boolean;
//begin
//
//end;

end.
