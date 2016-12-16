unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.IniFiles, Vcl.StdCtrls,
  Winapi.ShellAPI, System.Zip, uQQLogin,
  uData;

type
  TFrmMain = class(TForm)
    btnOn: TButton;
    edtGameId: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    edtAccount: TEdit;
    Label3: TLabel;
    edtPwd: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    edtArea: TEdit;
    edtServer: TEdit;
    Label6: TLabel;
    cbbMBType: TComboBox;
    edtIType: TEdit;
    edtKey: TEdit;
    procedure btnOnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }

  public
    { Public declarations }
  end;

var
  FrmMain: TFrmMain;
  account: string;
  password: string;
  gameId: Integer;
  area  : string;
  server: string;
  mbType: Integer;
  itype : string;
  key   : string;
  cookies:string;
  isLogin: boolean;

implementation

uses Properties, uDispatchThread, uFun, DmUtils, activeX,ManSoy.MsgBox;

{$R *.dfm}

procedure TFrmMain.btnOnClick(Sender: TObject);
var
  DispatchThread: TDispatchThread;
  cookies: string;
  i: Integer;
begin
  //---
  gameId  := StrToIntDef(edtGameId.Text, -1);//Game ID (0-地下城与勇士 1-御龙在天 2-剑灵 3-斗战神)
  account := edtAccount.Text; //Account
  password:= edtPwd.Text; //Password
  area    := edtArea.Text;   //Area
  server  := edtServer.Text;   //Server
  mbType  := StrToIntDef(cbbMBType.Text, -1); //not in [40, 50]-9891 40-KM_New 50-KM_Old
  itype   := edtIType.Text;   //Area
  key     := edtKey.Text;   //Server

  DispatchThread := TDispatchThread.Create(gameId, account, password, area, server, mbType, itype, key);
  //DispatchThread.Resume;
  //WaitForSingleObject(DispatchThread.Handle, INFINITE);
end;

procedure TFrmMain.FormCreate(Sender: TObject);
begin
  uData.GMainHandle := self.Handle;
end;

end.
