unit uFrmTest;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Imaging.jpeg
  ,
  VerySimple.Lua.Lib,
  VerySimple.Lua,
  uLuaFuns,
  uGlobal;

type
  TFrmTest = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    LstLog: TMemo;
    btnStart: TButton;
    Button1: TButton;
    procedure btnStartClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    procedure WMAddLog(var Mes: TMessage); message WM_ADD_LOG;
  public
    { Public declarations }
  end;

  TMsLua = class(TVerySimpleLua)
  private
    GlobalFuns: TLuaFuns;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Open; override;
  end;

  TDoCmd = class(TThread)
  private
    FButton: TButton;
  protected
    procedure OnPrint(Msg: String);
    procedure Execute; override;
  public
    constructor Create(ABtn: Pointer);
    destructor Destroy; override;
  end;

var
  FrmTest: TFrmTest;

implementation

{$R *.dfm}

{ TDoCmd }

constructor TDoCmd.Create(ABtn: Pointer);
begin
  inherited Create(False);
  FreeOnTerminate := True;
  FButton := TButton(ABtn);
  FButton.Enabled := False;
end;

destructor TDoCmd.Destroy;
begin
  FButton.Enabled := True;
  inherited;
end;

procedure TDoCmd.Execute;
var
  MsLua: TMsLua;
begin
  try
    MsLua := TMsLua.Create;
    try
      MsLua.OnPrint := OnPrint;
      AddLogMsg('启动脚本...', [], True);
      MsLua.DoFile(GSharedInfo.AppPath + 'Script\GameCheck.lua');
    except on E: Exception do
      AddLogMsg('执行脚本时发生错误:%s', [E.Message]);
    end;
  finally
    FreeAndNil(MsLua);
  end;
end;

procedure TDoCmd.OnPrint(Msg: String);
begin
  AddLogMsg(Msg, []);
end;

procedure TFrmTest.btnStartClick(Sender: TObject);
begin
  try
    TDoCmd.Create(Self.btnStart);
  finally
  end;
end;

procedure TFrmTest.WMAddLog(var Mes: TMessage);
begin
  LstLog.Lines.Add(string(Mes.LParam));
end;

procedure TFrmTest.FormCreate(Sender: TObject);
begin
  uGlobal.LoadCfg;
  GSharedInfo.MainFormHandle := Self.Handle;
  SystemParametersInfo(SPI_SETFONTSMOOTHING, 0, 0, 1);

  //LoadLibrary(PWideChar(GSharedInfo.AppPath + 'test.dll'));

  Self.Left := Screen.WorkAreaWidth - Self.Width;
  Self.Top  := Screen.WorkAreaHeight - Self.Height;

  GSharedInfo.MainFormHandle  := Self.Handle;
  GSharedInfo.bWork           := False;
  GSharedInfo.LocalIP := '0.0.0.0';
  AddLogMsg('Local IP: %s', [GSharedInfo.LocalIP], True);
  LstLog.Clear;
end;

procedure TFrmTest.FormDestroy(Sender: TObject);
begin
  SystemParametersInfo(SPI_SETFONTSMOOTHING, 1, 0, 1);
end;

{ TMsLua }

constructor TMsLua.Create;
begin
  inherited;
  LibraryPath := GSharedInfo.AppPath + LUA_LIBRARY;
  AddLogMsg(LibraryPath, [], True);
  GlobalFuns := TLuaFuns.Create;
end;

destructor TMsLua.Destroy;
begin
  FreeAndNil(GlobalFuns);
  inherited;
end;

procedure TMsLua.Open;
begin
  try
    inherited;
    GlobalFuns.PackageReg(LuaState);
  except on E: Exception do
    AddLogMsg('TMsLua.Open fail[%s]..', [E.Message]);
  end;
end;

end.
