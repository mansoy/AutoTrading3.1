unit uData;

interface

uses
  Winapi.Windows, Winapi.Messages, Winapi.ShellAPI, Vcl.FileCtrl, System.SysUtils;

type
  Tdm2 = record
    account : string;
    password: string;
    use     : Boolean;
  end;

const
  WM_ADD_LOG = WM_USER + 1001;

  //
  FLAG_NONE = 0;
  FLAG_SEND = 1; //'���ڷ�����';
  FLAG_RECV = 2; //'�����ն���';

var
  GMainHandle: Hwnd;
  dm2: Tdm2;

implementation

end.
