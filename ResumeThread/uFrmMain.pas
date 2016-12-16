unit uFrmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs;

type
  TFrmMain = class(TForm)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TWorkThread = class(TThread)
  protected
    procedure Execute; override;
  public
    constructor Create(); overload;
    destructor Destroy; override;
  end;

var
  FrmMain: TFrmMain;
  GStop: Boolean = False;
  GThreadIdsFile: string;

function OpenThread(dwDesiredAccess: DWORD; bInheritHandle: BOOL; dwProcessId: DWORD): HWND; stdcall; external 'kernel32.dll' name 'OpenThread';

implementation

uses
  SuperObject;

{$R *.dfm}

{ TWorkThread }

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
var
  hThread: HWND;
  dwPid: DWORD;
  JO: ISuperObject;
  I, ThreadId: Integer;
begin
  while True do
  try
    Sleep(10);
    if GStop then Break;
    //EnterCriticalSection(CS_ThreadIds);
    try
      JO := TSuperObject.ParseFile(GThreadIdsFile, False);
      for I := JO.AsArray.Length - 1 downto 0 do
      begin
        ThreadId := JO.AsArray.I[I];
        hThread := OpenThread(PROCESS_ALL_ACCESS, False, ThreadId);
        if (hThread = INVALID_HANDLE_VALUE) then
        begin
          JO.AsArray.Delete(I);
          Continue;
        end;
        ResumeThread(hThread);
      end;
      JO.SaveTo(GThreadIdsFile);
    finally
      //LeaveCriticalSection(CS_ThreadIds);
    end;
  except
  end;
end;

procedure TFrmMain.FormCreate(Sender: TObject);
begin
  GThreadIdsFile := ExtractFilePath(ParamStr(0)) + 'Config\ThreadIds.json';
  TWorkThread.Create;
end;

end.
