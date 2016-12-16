unit uCommFuns;

interface

uses Winapi.Windows, System.Classes, WinApi.ActiveX, System.SysUtils, Vcl.Forms,
     Vcl.Graphics, Vcl.Imaging.jpeg
     , Winapi.GDIPAPI, Winapi.GDIPOBJ
     , ManSoy.Encode
     , ManSoy.Global
     , uGlobal
     , Dm_TLB;

type
  TFindRet = record
    X: Integer;
    Y: Integer;
    Ret: Integer;
  end;

  TBDColor = Integer; //BGR��ʽ��ɫ

  TCommFuns = class
  private
    FSysCfgFile: string;
    FDm: Idmsoft;
    FDmHandle: THandle;
    function CreateDmComObject(CLSID: TGUID): Idmsoft;
  public
    constructor Create;
    destructor Destroy; override;

    function Init: Boolean;

{$REGION '��Įԭʼ����'}
    function GetClientRect(hwnd: Integer; out x1: OleVariant; out y1: OleVariant; out x2: OleVariant; out y2: OleVariant): Integer; safecall;
    function MoveWindow(hwnd: Integer; x: Integer; y: Integer): Integer; safecall;
    function SetDict(index: Integer; const dict_name: WideString): Integer; safecall;
    function SetPath(const path: WideString): Integer; safecall;
    function FindPic(x1: Integer; y1: Integer; x2: Integer; y2: Integer; const pic_name: WideString; const delta_color: WideString; sim: Double; dir: Integer; out x: OleVariant; out y: OleVariant): Integer; safecall;
    function FreePic(const pic_name: WideString): Integer; safecall;
    function FindStr(x1: Integer; y1: Integer; x2: Integer; y2: Integer; const str: WideString; const color: WideString; sim: Double; out x: OleVariant; out y: OleVariant): Integer; safecall;
    function FindStrFast(x1: Integer; y1: Integer; x2: Integer; y2: Integer; const str: WideString; const color: WideString; sim: Double; out x: OleVariant; out y: OleVariant): Integer; safecall;
    function Capture(x1: Integer; y1: Integer; x2: Integer; y2: Integer; const file_: WideString): Integer; safecall;
    function CaptureGif(x1: Integer; y1: Integer; x2: Integer; y2: Integer; const file_: WideString; delay: Integer; time: Integer): Integer; safecall;
    function GetScreenData(x1: Integer; y1: Integer; x2: Integer; y2: Integer): Integer; safecall;
    function GetScreenDataBmp(x1: Integer; y1: Integer; x2: Integer; y2: Integer; out data: OleVariant; out size: OleVariant): Integer; safecall;
    function KeyPress(vk: Integer): Integer; safecall;
    function KeyDown(vk: Integer): Integer; safecall;
    function KeyUp(vk: Integer): Integer; safecall;
    function KeyPressChar(const key_str: WideString): Integer; safecall;
    function LeftClick: Integer; safecall;
    function RightClick: Integer; safecall;
    function LeftDown: Integer; safecall;
    function LeftUp: Integer; safecall;
    function LeftDoubleClick: Integer; safecall;
    function MoveTo(x: Integer; y: Integer): Integer; safecall;
    function delay(mis: Integer): Integer; safecall;
    function LoadPic(const pic_name: WideString): Integer; safecall;
    function GetWordResultCount(const str: WideString): Integer; safecall;
    function GetWordResultPos(const str: WideString; index: Integer; out x: OleVariant; out y: OleVariant): Integer; safecall;
    function GetWordResultStr(const str: WideString; index: Integer): WideString; safecall;
    function GetWords(x1: Integer; y1: Integer; x2: Integer; y2: Integer; const color: WideString; sim: Double): WideString; safecall;
    function GetWordsNoDict(x1: Integer; y1: Integer; x2: Integer; y2: Integer; const color: WideString): WideString; safecall;
    function Ocr(x1: Integer; y1: Integer; x2: Integer; y2: Integer; const color: WideString; sim: Double): WideString; safecall;
    function OcrEx(x1: Integer; y1: Integer; x2: Integer; y2: Integer; const color: WideString; sim: Double): WideString; safecall;
    function OcrExOne(x1: Integer; y1: Integer; x2: Integer; y2: Integer; const color: WideString; sim: Double): WideString; safecall;
    function OcrInFile(x1: Integer; y1: Integer; x2: Integer; y2: Integer; const pic_name: WideString; const color: WideString; sim: Double): WideString; safecall;
    function SendString(hwnd: Integer; const str: WideString): Integer;
{$ENDREGION}

{$REGION '��Į��չ����'}
    function fnǰ�ô���(HWND: HWND): Boolean;
    function fn����ͼƬ_��������(AImgName: string; ARatio: Single = 1.0; ADealy: Cardinal = 1): TFindRet;
    function fn����ͼƬ(AImgName: string; ARatio: Single = 1.0; ADealy: Cardinal = 1): Boolean;
    function fn����ͼƬ_����(x1, y1, x2, y2: Integer; AImgName: string; ARatio: Single = 1.0; ADealy: Cardinal = 1): Boolean;
    function fn����ͼƬ_��������_����(x1, y1, x2, y2: Integer; AImgName: string; ARatio: Single = 1.0; ADealy: Cardinal = 1): TFindRet;
    function fnȫ������_��������(AText, Aƫɫ, ADict: string; ARation: Single = 1.0; ADealy: Cardinal = 1): TFindRet;
    function fnȫ������(AText, Aƫɫ, ADict: string; ARation: Single = 1.0; ADealy: Cardinal = 1): Boolean;
    function fn��������(x1, y1, x2, y2: Integer; AText, Aƫɫ, ADict: string; ARation: Single = 1.0; ADealy: Cardinal = 1): TFindRet;

    function fn��ȡ����(AX1, AY1, AX2, AY2: Integer; APianSe: string; ARatio: Single = 1.0): Int64;

    procedure pro����ɾ����(ATimes: DWORD = 12);
    procedure pro���������(X: Integer; Y: Integer);
    procedure pro˫��������(X: Integer; Y: Integer);
    procedure pro�������Ҽ�(X: Integer; Y: Integer);
    procedure pro�϶����(x1, y1, x2, y2: Integer);
    procedure pro�ƶ����(X: Integer; Y: Integer);
    function fn��ȡ��Ļ(AFileName: string): Boolean;
    function fn��ȡ��Ļ_����(AX, AY, AX1, AY1: Integer; AFileName: string): Boolean;

    function fn������ȡ��Ļ(ADnfHandle: HWND): Boolean;

    function fn�ƶ�����(AWindowHandle: HWND; X, Y: Integer): Integer;
    function fn��ȡ�ͻ�����(AWindowHandle: HWND; var X, Y, X2, Y2: Integer): Integer;
    function fn����(VK: Integer): Integer;
    /// <remarks>
    /// ���������·
    /// </remarks>
    function fn�������·(VK: Integer; ATime: DWORD): Integer;
{$ENDREGION}

{$REGION 'Other����'}
//    procedure AddLogMsg(AFormat: string; const Args: array of const; AOnlyDebugShow: Boolean = False);
//    procedure DebugInfo(AFormat: string; const Args: array of const; AOnlyDebugShow: Boolean = False);
//    procedure AddLogFile(AFileNam: string; AFormat: string; const Args: array of const);
    function StartProcess(ACmd: String; AIsShow: Boolean = False): Boolean;
    function PressPassWord(AHPwd: HWND; APwd: string; ADealy: Cardinal = 100): Boolean;
    function CompressPic(APicName: string; AQuality: ShortInt = 90): Boolean;
    function GetScreenBmp(AX, AY, AX1, AY1: Integer; AFileName: string): Boolean; overload;
    //function GetScreenBmp(AX, AY, AX1, AY1: Integer; APicName: string; AQuality: Integer = 70): Boolean; overload;
    function CreateRoleBmp(ARoleName: string; ASaveFileName: string): Boolean;
    function CreateBmp(AText: string; R, G, B: Byte; ASaveFileName: string): Boolean;
    function fnУ��(ACheckWindow: Boolean = True): Boolean;
    function CloseGame(ADelay: DWORD): Boolean;
    function WriteGameRegionSvr(AGamePath, ALastSelSvr: string; ALastQQUin: string): Boolean;
    function PostCapture(APath: string): Boolean;
    function GetCarryAmount(ALevel: Integer): Integer;
    function GetPassWord(AAccount: string): string;
{$ENDREGION}

{$REGION 'VMP'}
  procedure BeginVMP(AFlag: string = 'VMProtect'); stdcall;
  procedure EndVMP(AFlag: string = 'VMProtect'); stdcall;
{$ENDREGION}

{$REGION '�ⲿ����'}
  function fnDaMa(ADama2User, ADama2Pwd, AImgFileName: string; ADealyTimes: DWORD): string;
  function fnQuitSate: string;
{$ENDREGION}

  {$REGION '����'}
  function GetDealy(ADealyKey: string): DWORD;
  function GetPianSe(AKey: string): string;
{$ENDREGION}

{$REGION '��ɫת��'}
    //ת������
    function BGR(B,G,R : Byte): TBDColor;
    function RGBtoBGR(C : TColor): TBDColor;
    function BGRtoRGB(C : TBDColor): TColor;
{$ENDREGION}
  end;

function DamaForDnfAutoTrade(AUserName: string; APassWord: string; AFileName: string; ADelay: Integer; AType: Integer; var ARetCheckCode: string): Integer; stdcall; external 'ManSoy.Global.dll' name 'DamaForDnfAutoTrade';
//function QQSafe(AGameID: Integer; AAccount: PAnsiChar; APassWord: PAnsiChar; AArea: PAnsiChar; AServer: PAnsiChar; AMBType: Integer; AKey: PAnsiChar): PAnsiChar; stdcall; external 'QuitSafe.dll';
//function MsKmPressPassWord(szPassWord: PAnsiChar; dwDelay: DWORD): Boolean; stdcall; external 'MsKm.dll' name 'MsKmPressPassword';
//function MsKmKeyPress(AKey: WORD; AShift: Boolean = False; ADelay: DWORD = 100): Boolean; stdcall; external 'MsKm.dll' name 'MsKmKeyPress';
//function MsKmMouseLeftClick(ADelay: DWORD = 100): Boolean; stdcall; external 'MsKm.dll' name 'MsKmMouseLeftClick';
//function MsKmMouseRightClick(ADelay: DWORD = 100): Boolean; stdcall; external 'MsKm.dll' name 'MsKmMouseRightClick';
//function MsKmMouseMiddleClick(ADelay: DWORD = 100): Boolean; stdcall; external 'MsKm.dll' name 'MsKmMouseMiddleClick';
//function MsKmMouseMove(AX: Integer; AY: Integer): Boolean; stdcall; external 'MsKm.dll' name 'MsKmMouseMove';
//---
//function MsPressPassWord(szString: PAnsiChar; dwDelay: DWORD): Boolean;stdcall;external 'MsIo.dll' name 'MsPressPassWord';
//function MsKeyPress(vKeyCode: Integer; AShift: Boolean = False; dwDelay: DWORD = 100): Boolean;stdcall;external 'MsIo.dll' name 'MsPressKey';

var
  GCommFuns: TCommFuns;

implementation

uses
  IdHTTP,
  IdMultipartFormData,
  IdGlobalProtocols,
  SuperObject,
  uJsonClass,
  uLogger,
  uCommand,
  uTradeClient
  ;

constructor TCommFuns.Create;
begin
  inherited;
  FDm := CreateDmComObject(CLASS_dmsoft);
  Init;
end;

function TCommFuns.CreateDmComObject(CLSID: TGUID): Idmsoft;
var
  Factory: IClassFactory;
  DllGetClassObject: function(const CLSID, IID: TGUID; var Obj): HResult; stdcall;
  hr: HRESULT;
begin
  Result := nil;
  EnabledDebugPrivilege();
  DebugInf('MS - %sdm.dll - %s', [GSharedInfo.AppPath, GetProcessName(GetCurrentProcessId)]);
  FDmHandle := LoadLibrary(PWideChar(GSharedInfo.AppPath + 'dm.dll'));
  if FDmHandle < 32 then Exit;
  try
    DllGetClassObject := GetProcAddress(FDmHandle, 'DllGetClassObject');
    if Assigned(DllGetClassObject) then
    begin
      hr := DllGetClassObject(CLSID, IClassFactory, Factory);
      if hr = S_OK then
      try
        hr := Factory.CreateInstance(nil, IUnknown, Result);
        if hr = S_OK then
        begin
          AddLogMsg('��Į������سɹ�', [], True);
          //MessageBox(0, '��Į������سɹ�', 0, 0);
        end;
      except
        AddLogMsg('TCommFuns.CreateDmComObject fail[ErrCode=%d]', [GetLastError]);
      end;
    end;
  finally
    //FreeLibrary(vHandle);
  end;
end;

destructor TCommFuns.Destroy;
begin
  //FreeLibrary(FDmHandle);
  inherited;
end;

{$REGION '��Įԭʼ����'}
function TCommFuns.Capture(x1, y1, x2, y2: Integer; const file_: WideString): Integer;
begin
  FDm.Capture(x1, y1, x2, y2, file_);
end;

function TCommFuns.CaptureGif(x1, y1, x2, y2: Integer; const file_: WideString; delay, time: Integer): Integer;
begin
  FDm.CaptureGif(x1, y1, x2, y2, file_, delay, time);
end;

function TCommFuns.GetScreenData(x1: Integer; y1: Integer; x2: Integer; y2: Integer): Integer;
begin
  Result := FDm.GetScreenData(x1, y1, x2, y2);
end;
function TCommFuns.GetScreenDataBmp(x1: Integer; y1: Integer; x2: Integer; y2: Integer; out data: OleVariant; out size: OleVariant): Integer;
begin
  Result := FDm.GetScreenDataBmp(x1, y1, x2, y2, data, size);
end;

function TCommFuns.GetWordResultCount(const str: WideString): Integer;
begin
  Result := FDm.GetWordResultCount(str);
end;

function TCommFuns.GetWordResultPos(const str: WideString; index: Integer; out x, y: OleVariant): Integer;
begin
  Result := FDm.GetWordResultPos(str, index, x, y);
end;

function TCommFuns.GetWordResultStr(const str: WideString; index: Integer): WideString;
begin
  Result := FDm.GetWordResultStr(str, index);
end;

function TCommFuns.GetWords(x1, y1, x2, y2: Integer; const color: WideString; sim: Double): WideString;
begin
  Result := FDm.GetWords(x1, y1, x2, y2, color, sim);
end;

function TCommFuns.GetWordsNoDict(x1, y1, x2, y2: Integer; const color: WideString): WideString;
begin
  Result := FDm.GetWordsNoDict(x1, y1, x2, y2,color);
end;

function TCommFuns.FindPic(x1, y1, x2, y2: Integer; const pic_name, delta_color: WideString; sim: Double; dir: Integer; out x,
  y: OleVariant): Integer;
begin
  Result := FDm.FindPic(x1, y1, x2, y2, pic_name, delta_color, sim, dir, x, y);
end;

function TCommFuns.FreePic(const pic_name: WideString): Integer;
begin
  Result := FDm.FreePic(pic_name);
end;

function TCommFuns.FindStr(x1: Integer; y1: Integer; x2: Integer; y2: Integer; const str: WideString;
                     const color: WideString; sim: Double; out x: OleVariant; out y: OleVariant): Integer; safecall;
begin
  Result := FDm.FindStr(x1, y1, x2, y2, str, color, sim, x, y);
end;

function TCommFuns.FindStrFast(x1, y1, x2, y2: Integer; const str, color: WideString; sim: Double; out x,
  y: OleVariant): Integer;
begin
  Result := FDm.FindStrFast(x1, y1, x2, y2, str, color, sim, x, y);
end;

function TCommFuns.GetClientRect(hwnd: Integer; out x1, y1, x2, y2: OleVariant): Integer;
begin
  Result := FDm.GetClientRect(hwnd, x1, y1, x2, y2);
end;

function TCommFuns.Init: Boolean;
begin
  FDm.SetPath(GSharedInfo.AppPath);
  FDm.SetDict(0, GSharedInfo.AppPath + CON_SYS_DICT);
  FSysCfgFile := Format('%sConfig\SysCfg.ini', [GSharedInfo.AppPath]);
end;

function TCommFuns.KeyPress(vk: Integer): Integer;
begin
  Result := FDm.KeyPress(vk);
end;

function TCommFuns.KeyDown(vk: Integer): Integer;
begin
  Result := FDm.KeyDown(vk);
end;

function TCommFuns.KeyUp(vk: Integer): Integer;
begin
  Result := FDm.KeyUp(vk);
end;

function TCommFuns.KeyPressChar(const key_str: WideString): Integer; safecall;
begin
  Result := FDm.KeyPressChar(key_str);
end;

function TCommFuns.LeftClick: Integer;
begin
  Result := FDm.LeftClick;
end;

function TCommFuns.RightClick: Integer;
begin
  Result := FDm.RightClick;
end;

function TCommFuns.LeftDoubleClick: Integer;
begin
  Result := FDm.LeftDoubleClick;
end;

function TCommFuns.LeftDown: Integer;
begin
  Result := FDm.LeftDown;
end;

function TCommFuns.LeftUp: Integer;
begin
  Result := FDm.LeftUp;
end;

function TCommFuns.MoveTo(x, y: Integer): Integer;
begin
  Result := FDm.MoveTo(x, y);
end;

function TCommFuns.delay(mis: Integer): Integer; safecall;
begin
  Result := FDm.delay(mis);
end;

function TCommFuns.LoadPic(const pic_name: WideString): Integer; safecall;
begin
  Result := FDm.LoadPic(pic_name);
end;

function TCommFuns.SendString(hwnd: Integer; const str: WideString): Integer;
begin
  Result := FDm.SendString(hwnd, str);
end;

function TCommFuns.MoveWindow(hwnd, x, y: Integer): Integer;
begin
  Result := FDm.MoveWindow(hwnd, x, y);
end;

function TCommFuns.Ocr(x1, y1, x2, y2: Integer; const color: WideString; sim: Double): WideString;
begin
  Result := FDm.Ocr(x1, y1, x2, y2, color, sim);
end;

function TCommFuns.OcrEx(x1, y1, x2, y2: Integer; const color: WideString; sim: Double): WideString;
begin
  Result := FDm.OcrEx(x1, y1, x2, y2,color,sim);
end;

function TCommFuns.OcrExOne(x1, y1, x2, y2: Integer; const color: WideString; sim: Double): WideString;
begin
  Result := FDm.OcrExOne(x1, y1, x2, y2, color, sim);
end;

function TCommFuns.OcrInFile(x1, y1, x2, y2: Integer; const pic_name, color: WideString; sim: Double): WideString;
begin
  Result := FDm.OcrInFile(x1, y1, x2, y2, pic_name, color, sim);
end;

function TCommFuns.SetDict(index: Integer; const dict_name: WideString): Integer;
begin
  Result := FDm.SetDict(index, dict_name);
end;

function TCommFuns.SetPath(const path: WideString): Integer;
begin
  Result := FDm.SetPath(path);
end;

{$ENDREGION}

{$REGION '��Į��չ����'}
function TCommFuns.fnǰ�ô���(HWND: HWND): Boolean;
begin
  BeginVMP;
  ShowWindow(HWND, SW_RESTORE);
  Sleep(100);
  Result := SetForegroundWindow(HWND);
  Sleep(100);
  EndVMP;
end;

function TCommFuns.fn����ͼƬ_��������(AImgName: string; ARatio: Single = 1.0; ADealy: Cardinal = 1): TFindRet;
var
  x1, y1, x2, y2, intX, intY: OleVariant;
  dwDealyTimes: DWORD;
  sImgs: string;
  vList: TStrings;
  I: Integer;
begin
  BeginVMP;
  Result.Y := -1;
  Result.Ret := -1;
  try
    if AImgName = '' then Exit;
    vList := TStringList.Create;
    try
      vList.Delimiter := '|';
      vList.DelimitedText := Trim(AImgName);
      if vList.Count = 0 then Exit;
      sImgs := '';
      for I := 0 to vList.Count - 1 do
      begin
        vList.Strings[i] := Format('%s%s', [CON_BMP_PATH, vList.Strings[i]]);
      end;

      // fn�󶨴���;
      dwDealyTimes := GetTickCount;
      while GetTickCount - dwDealyTimes < ADealy * 1000 do
      begin
        if not IsWindow(GSharedInfo.GameWindow) then
        begin
          Result.Ret := -1;
          Break;
        end;
        if IsWindowVisible(GSharedInfo.GameWindow) then
        begin
          fnǰ�ô���(GSharedInfo.GameWindow);
          Self.GetClientRect(GSharedInfo.GameWindow, x1, y1, x2, y2);
          Result.Ret := Self.FindPic(x1, y1, x2, y2, vList.DelimitedText, '000000', ARatio, 0, intX, intY);
          if Result.Ret <> -1 then
          begin
            Result.X := Integer(intX);
            Result.Y := Integer(intY);
            Break;
          end;
        end;
        Sleep(100);
      end;
      if Result.Ret = -1 then
      begin
        //AddLogMsg('����ͼƬ[%s]ʧ��...', [AImgName], True);
        Exit;
      end;
    finally
      // fn��󴰿�;
      FreeAndNil(vList);
    end;
  except
    on E: Exception do
    begin
      AddLogMsg('����δ֪����: ' + E.Message, []);
    end;
  end;
  EndVMP;
end;

function TCommFuns.fn����ͼƬ(AImgName: string; ARatio: Single = 1.0; ADealy: Cardinal = 1): Boolean;
var
  x1, y1, x2, y2, intX, intY: OleVariant;
  dwDealyTimes: DWORD;
  iRet: Integer;
begin
  BeginVMP;
  Result := False;
  iRet := -1;
  try
    try
      // fn�󶨴���;
      dwDealyTimes := GetTickCount;
      while GetTickCount - dwDealyTimes < ADealy * 1000 do
      begin
        if not IsWindow(GSharedInfo.GameWindow) then
        begin
          iRet := -1;
          Break;
        end;
        if IsWindowVisible(GSharedInfo.GameWindow) then
        begin
          fnǰ�ô���(GSharedInfo.GameWindow);
          Sleep(500);
          Self.GetClientRect(GSharedInfo.GameWindow, x1, y1, x2, y2);
          iRet := Self.FindPic(x1, y1, x2, y2,
            Format('%s%s\%s', [GSharedInfo.AppPath, CON_BMP_PATH,
            AImgName]), '000000', ARatio, 0, intX, intY);
          if iRet <> -1 then
            Break;
        end;
        Sleep(100);
      end;
      if iRet = -1 then
      begin
        //AddLogMsg('����ͼƬ[%s]ʧ��...', [AImgName], True);
        Exit;
      end;
      Result := True;
    finally
      // fn��󴰿�;
    end;
  except
    on E: Exception do
    begin
      AddLogMsg('����δ֪����: ' + E.Message, []);
    end;
  end;
  EndVMP;
end;

function TCommFuns.fn����ͼƬ_����(x1, y1, x2, y2: Integer; AImgName: string; ARatio: Single = 1.0; ADealy: Cardinal = 1): Boolean;
var
  intX, intY: OleVariant;
  dwDealyTimes: DWORD;
  iRet: Integer;
  vRect: TRect;
begin
  BeginVMP;
  Result := False;
  iRet := -1;
  try
    try
      // fn�󶨴���;
      Winapi.Windows.GetClientRect(GSharedInfo.GameWindow, vRect);
      x1 := x1 + vRect.Left;
      y1 := y1 + vRect.Top;
      x2 := x2 + vRect.Left;
      y2 := y2 + vRect.Top;
      dwDealyTimes := GetTickCount;
      while GetTickCount - dwDealyTimes < ADealy * 1000 do
      begin
        if not IsWindow(GSharedInfo.GameWindow) then
        begin
          iRet := -1;
          Break;
        end;
        if IsWindowVisible(GSharedInfo.GameWindow) then
        begin
          fnǰ�ô���(GSharedInfo.GameWindow);
          iRet := Self.FindPic(x1, y1, x2, y2,
            Format('%s%s\%s', [GSharedInfo.AppPath, CON_BMP_PATH,
            AImgName]), '000000', ARatio, 0, intX, intY);
          if iRet <> -1 then
            Break;
        end;
        Sleep(100);
      end;
      if iRet = -1 then
      begin
        //AddLogMsg('����ͼƬ[%s]ʧ��...', [AImgName], True);
        Result := False;
        Exit;
      end;
      Result := True;
    finally
      // fn��󴰿�;
    end;
  except
    on E: Exception do
    begin
      AddLogMsg('����δ֪����: ' + E.Message, []);
    end;
  end;
  EndVMP;
end;

function TCommFuns.fn����ͼƬ_��������_����(x1, y1, x2, y2: Integer; AImgName: string; ARatio: Single = 1.0; ADealy: Cardinal = 1): TFindRet;
var
  intX, intY: OleVariant;
  dwDealyTimes: DWORD;
  i: Integer;
  vRect: TRect;
  sImgs: string;
  vList: TStrings;
begin
  BeginVMP;
  Result.X := -1;
  Result.Y := -1;
  Result.Ret := -1;
  try
    vList := TStringList.Create;
    try
      vList.Delimiter := '|';
      vList.DelimitedText := Trim(AImgName);
      if vList.Count = 0 then Exit;
      sImgs := '';
      for I := 0 to vList.Count - 1 do
      begin
        vList.Strings[i] := Format('%s%s', [CON_BMP_PATH, vList.Strings[i]]);
      end;
      // fn�󶨴���;
      Winapi.Windows.GetClientRect(GSharedInfo.GameWindow, vRect);
      x1 := x1 + vRect.Left;
      y1 := y1 + vRect.Top;
      x2 := x2 + vRect.Left;
      y2 := y2 + vRect.Top;
      dwDealyTimes := GetTickCount;
      while GetTickCount - dwDealyTimes < ADealy * 1000 do
      begin
        if not IsWindow(GSharedInfo.GameWindow) then
        begin
          Break;
        end;
        if IsWindowVisible(GSharedInfo.GameWindow) then
        begin
          fnǰ�ô���(GSharedInfo.GameWindow);
          Result.Ret := Self.FindPic(x1, y1, x2, y2, vList.DelimitedText, '000000', ARatio, 0, intX, intY);
          if Result.Ret <> -1 then
          begin
            Result.X := Integer(intX);
            Result.Y := Integer(intY);
            Break;
          end;
        end;
        Sleep(100);
      end;
      if Result.Ret = -1 then
      begin
        //AddLogMsg('����ͼƬ[%s]ʧ��...', [AImgName], True);
        Exit;
      end;
    finally
      // fn��󴰿�;
      FreeAndNil(vList);
    end;
  except
    on E: Exception do
    begin
      AddLogMsg('����δ֪����: ' + E.Message, []);
    end;
  end;
  EndVMP;
end;

function TCommFuns.fnȫ������_��������(AText, Aƫɫ, ADict: string; ARation: Single = 1.0; ADealy: Cardinal = 1): TFindRet;
var
  x1, y1, x2, y2, intX, intY: OleVariant;
  dwDealyTimes: DWORD;
begin
  BeginVMP;
  Result.Y := -1;
  Result.Ret := -1;
  try
    try
      // fn�󶨴���;
      Self.SetDict(0, ADict);
      dwDealyTimes := GetTickCount;
      while GetTickCount - dwDealyTimes < ADealy * 1000 do
      begin
        if not IsWindow(GSharedInfo.GameWindow) then
        begin
          Result.Ret := -1;
          Break;
        end;
        if IsWindowVisible(GSharedInfo.GameWindow) then
        begin
          Self.GetClientRect(GSharedInfo.GameWindow, x1, y1, x2, y2);
          fnǰ�ô���(GSharedInfo.GameWindow);
          Result.Ret := Self.FindStrFast(x1, y1, x2, y2, AText, Aƫɫ, ARation,
            intX, intY);
          if Result.Ret <> -1 then
            Break;
        end;
        Sleep(300);
      end;
      if Result.Ret = -1 then
      begin
        //AddLogMsg('û���ҵ�����[%s]', [AText], True);
        Exit;
      end;
      // ����󶨴����ˣ����ü�ȥx1��y1
      Result.X := Integer(intX);
      Result.Y := Integer(intY);
    finally
      // fn��󴰿�;
    end;
  except
    on E: Exception do
    begin
      AddLogMsg('����δ֪����: ' + E.Message, []);
    end;
  end;
  EndVMP;
end;

function TCommFuns.fnȫ������(AText, Aƫɫ, ADict: string; ARation: Single = 1.0; ADealy: Cardinal = 1): Boolean;
var
  p: TFindRet;
begin
  p := fnȫ������_��������(AText, Aƫɫ, ADict, ARation, ADealy);
  Result := (p.X <> -1) and (p.Y <> -1);
end;

function TCommFuns.fn��������(x1, y1, x2, y2: Integer; AText, Aƫɫ, ADict: string; ARation: Single = 1.0; ADealy: Cardinal = 1): TFindRet;
var
  intX, intY: OleVariant;
  dwDealyTimes: DWORD;
begin
  BeginVMP;
  Result.X := -1;
  Result.Y := -1;
  Result.Ret := -1;
  try
    try
      // fn�󶨴���;
      Self.SetDict(0, ADict);
      dwDealyTimes := GetTickCount;
      while GetTickCount - dwDealyTimes < ADealy * 1000 do
      begin
        if not IsWindow(GSharedInfo.GameWindow) then
        begin
          Result.Ret := -1;
          Break;
        end;
        if IsWindowVisible(GSharedInfo.GameWindow) then
        begin
          //Self.GetClientRect(GSharedInfo.GameWindow, x1, y1, x2, y2);
          fnǰ�ô���(GSharedInfo.GameWindow);
          Result.Ret := Self.FindStrFast(x1, y1, x2, y2, AText, Aƫɫ, ARation,
            intX, intY);
          if Result.Ret <> -1 then
            Break;
        end;
        Sleep(300);
      end;
      if Result.Ret = -1 then
      begin
        //AddLogMsg('û���ҵ�����[%s]', [AText], True);
        //AddLogMsg('X: %d Y:%d Ret: %d', [Result.X, Result.Y, Result.Ret], True);
        Exit;
      end;
      // ����󶨴����ˣ����ü�ȥx1��y1
      Result.X := Integer(intX);
      Result.Y := Integer(intY);
      //AddLogMsg('X: %d Y:%d Ret: %d', [Result.X, Result.Y, Result.Ret], True);
    finally
      // fn��󴰿�;
    end;
  except
    on E: Exception do
    begin
      AddLogMsg('����δ֪����: ' + E.Message, []);
    end;
  end;
  EndVMP;
end;

function TCommFuns.fn��ȡ����(AX1, AY1, AX2, AY2: Integer; APianSe: string; ARatio: Single = 1.0): Int64;
var
  s: string;
  iRet, I: Integer;
  // liMoney: Int64;
  vRect: TRect;
begin
  BeginVMP;
  Result := -1;
  if not IsWindow(GSharedInfo.GameWindow) then
  begin
    AddLogMsg('��Ϸ�Ѿ��˳�����ȡ�������ʧ�ܣ�', []);
    Exit;
  end;

  try
      // fn�󶨴���;
      Winapi.Windows.GetClientRect(GSharedInfo.GameWindow, vRect);
      AX1 := AX1 + vRect.Left;
      AY1 := AY1 + vRect.Top;
      AX2 := AX2 + vRect.Left;
      AY2 := AY2 + vRect.Top;
      iRet := Self.SetDict(0, GSharedInfo.AppPath + 'Config\DNFDict.txt');
      if iRet = 0 then
      begin
        AddLogMsg('���ô�Į�ֿ����', []);
        Exit;
      end;
      // ������ȡCON_REAPT_TIMES�ν��
      for I := 1 to CON_REAPT_TIMES do
      begin
        // 574,480,716,504
        fnǰ�ô���(GSharedInfo.GameWindow);
        s := Self.Ocr(AX1, AY1, AX2, AY2, APianSe, ARatio);
        //AddLogMsg('��ȡ�Ľ�������ַ���Ϊ��%s��', [s], True);
        Result := StrToInt64Def(s, -1);
        //AddLogMsg('��ȡ�Ľ������Ϊ��%d��', [Result], True);
        //GSharedInfo.OrderInfo.ReStock := Result;
        if Result <> -1 then Break;
        Sleep(1000);
      end;
  except
    on E: Exception do
    begin
      AddLogMsg('��ȡ�������⣬ԭ��%s', [E.Message]);
    end;
  end;
  EndVMP;
end;

procedure TCommFuns.pro����ɾ����(ATimes: DWORD = 12);
var
  I: Integer;
begin
  BeginVMP;
  try
    // fn�󶨴���;
    for I := 0 to ATimes - 1 do
    begin
      Sleep(10);
      Self.KeyPress(VK_BACK);
    end;
    // fn��󴰿�;
  except
    // fn��󴰿�;
  end;
  EndVMP;
end;

procedure TCommFuns.pro���������(X: Integer; Y: Integer);
var
  vRect: TRect;
  iDelay, iX, iY: Integer;
begin
  BeginVMP;
  try
    //GetClientRect(GSharedInfo.GameWindow, vRect);
    //X := X + vRect.Left;
    //Y := Y + vRect.Top;
    if GetForegroundWindow <> GSharedInfo.GameWindow then
      fnǰ�ô���(GSharedInfo.GameWindow);
    // TODO: �������SendInputģʽ
    //Self.MoveTo(X, Y);
    Self.pro�ƶ����(X, Y);
    Randomize;
    iDelay := 100 + Random(100);
    Sleep(iDelay);
    Self.LeftClick;
    Sleep(iDelay);
    iX := Random(5);
    iY := Random(5);
    //Self.MoveTo(iX, iX);
    Self.pro�ƶ����(iX, iX);
  except
  end;
  EndVMP;
end;

procedure TCommFuns.pro˫��������(X: Integer; Y: Integer);
var
  vRect: TRect;
  iDelay, iX, iY: Integer;
begin
  BeginVMP;
  try
    // fn�󶨴���;
    Winapi.Windows.GetClientRect(GSharedInfo.GameWindow, vRect);
    X := X + vRect.Left;
    Y := Y + vRect.Top;
    fnǰ�ô���(GSharedInfo.GameWindow);
    //Self.MoveTo(X, Y);
    Self.pro�ƶ����(X, Y);
    Randomize;
    iDelay := 100 + Random(100);
    Sleep(iDelay);
    LeftDoubleClick();
    iX := Random(5);
    iY := Random(5);
    Sleep(iDelay);
    //Self.MoveTo(iX, iX);
    Self.pro�ƶ����(iX, iY);
    // fn��󴰿�;
  except
    // fn��󴰿�;
  end;
  EndVMP;
end;

procedure TCommFuns.pro�������Ҽ�(X: Integer; Y: Integer);
var
  vRect: TRect;
begin
  BeginVMP;
  try
    //GetClientRect(GSharedInfo.GameWindow, vRect);
    //X := X + vRect.Left;
    //Y := Y + vRect.Top;
    if GetForegroundWindow <> GSharedInfo.GameWindow then
      fnǰ�ô���(GSharedInfo.GameWindow);
    //Self.MoveTo(X, Y);
    Self.pro�ƶ����(X, Y);
    Sleep(200);
    Self.RightClick;
    Sleep(200);
    Self.MoveTo(0, 0);
  except
  end;
  EndVMP;
end;

procedure TCommFuns.pro�϶����(x1, y1, x2, y2: Integer);
var
  vRect: TRect;
begin
  BeginVMP();
  try
    //fn�󶨴���;
    fnǰ�ô���(GSharedInfo.GameWindow);
    //Self.MoveTo(x1, y1);
    Self.pro�ƶ����(x1, y1);
    Sleep(100);
    Self.LeftDown;
    Sleep(500);
    //Self.MoveTo(x2, y2);
    Self.pro�ƶ����(x2, y2);
    Sleep(100);
    Self.LeftUp;
  except
    //fn��󴰿�;
  end;
  EndVMP();
end;

procedure TCommFuns.pro�ƶ����(X: Integer; Y: Integer);
var
  I, iDelay, iCount, iX, iY: Integer;
begin
  BeginVMP();
  try
//    Randomize;
//    iCount := Random(5);
//    for I := 0 to iCount do
//    begin
//      iX := Random(X);
//      iY := Random(Y);
//      Self.MoveTo(iX, iY);
//      iDelay := 100 + Random(50);
//      Sleep(iDelay);
//    end;
    Self.MoveTo(X, Y);
  except
    //fn��󴰿�;
  end;
  EndVMP();
end;

function TCommFuns.fn��ȡ��Ļ(AFileName: string): Boolean;
var
  x1, y1, x2, y2: OleVariant;
  sPath: string;
  i: Integer;
begin
  BeginVMP;
  PostLogFile(AFileName, []);
  Result := False;
  try
    if not IsWindow(GSharedInfo.GameWindow) then
      Exit;
    sPath := ExtractFilePath(AFileName);
    if (sPath <> '') and (not DirectoryExists(sPath)) then
    begin
      ForceDirectories(sPath);
    end;
    fnǰ�ô���(GSharedInfo.GameWindow);
    if 0 = Self.GetClientRect(GSharedInfo.GameWindow, x1, y1, x2, y2) then
    begin
      x1 := 0; y1 := 0;
      x2 := 800; y2 := 600;
    end;

	//--������ȡ��Ļ
    Sleep(10);
    Self.KeyPress(VK_SNAPSHOT);
    Sleep(10);
    Self.KeyPress(VK_SNAPSHOT);
    for I := 0 to 9 do
    begin
      Result := GetScreenBmp(x1, y1, x2, y2, AFileName);
      if Result then Break;
    end;
    //CompressPic(AFileName, 70);
  except
    on E: Exception do
    begin
      AddLogMsg('��ȡ��Ļʱ��������: %s', [E.Message]);
    end;
  end;
  EndVMP;
end;

function TCommFuns.fn��ȡ��Ļ_����(AX, AY, AX1, AY1: Integer; AFileName: string): Boolean;
var
  x1, y1, x2, y2: OleVariant;
  sPath: string;
begin
  BeginVMP;
  Result := False;
  try
    if not IsWindow(GSharedInfo.GameWindow) then
      Exit;
    sPath := ExtractFilePath(AFileName);
    if (sPath <> '') and (not DirectoryExists(sPath)) then
    begin
      ForceDirectories(sPath);
    end;
    fnǰ�ô���(GSharedInfo.GameWindow);
    Result := GetScreenBmp(AX, AY, AX1, AY1, AFileName);
    //CompressPic(AFileName);
  except
    on E: Exception do
    begin
      AddLogMsg('��ȡ��Ļʱ��������: %s', [E.Message]);
    end;
  end;
  EndVMP;
end;

function TCommFuns.fn������ȡ��Ļ(ADnfHandle: HWND): Boolean;
begin
  BeginVMP;
  Result := False;
  if not IsWindow(ADnfHandle) then Exit;
  fnǰ�ô���(ADnfHandle);
  Sleep(200);
  Self.KeyPress(VK_SNAPSHOT);
  EndVMP;
end;

function TCommFuns.fn�ƶ�����(AWindowHandle: HWND; X, Y: Integer): Integer;
begin
  BeginVMP;
  Result := Self.MoveWindow(AWindowHandle, X, Y);
  EndVMP;
end;

function TCommFuns.fn��ȡ�ͻ�����(AWindowHandle: HWND; var X, Y, X2, Y2: Integer): Integer;
var
  vX, vY, vX2, vY2: OleVariant;
begin
  BeginVMP;
  Result := Self.GetClientRect(AWindowHandle, vX, vY, vX2, vY2);
  X := Integer(vX);
  Y := Integer(vY);
  X2 := Integer(vX2);
  Y2 := Integer(vY2);
  EndVMP;
end;

function TCommFuns.fn����(VK: Integer): Integer;
begin
  BeginVMP;
  Result := Self.KeyPress(VK);
  EndVMP;
end;

function TCommFuns.fn�������·(VK: Integer; ATime: DWORD): Integer;
begin
  BeginVMP;
  Result := 0;
  try
    Result := 1;
    Self.KeyDown(vk);
    Sleep(ATime);
    Self.KeyUp(vk);
  except
  end;
  EndVMP;
end;

{$ENDREGION}

{$REGION 'Other����'}

//procedure TCommFuns.AddLogMsg(AFormat: string; const Args: array of const; AOnlyDebugShow: Boolean = False);
//var
//  sMsg: string;
//begin
//  sMsg := System.SysUtils.Format(AFormat, Args, FormatSettings);
//  if sMsg = '' then Exit;
//  sMsg := Format('[%s]%s', [FormatDateTime('yyyy-MM-dd hh:nn:ss', Now), sMsg]);
//  //AddLogFile(Format('%s\Logs\%s.log', [GSharedInfo.AppPath, FormatDatetime('yyyyMMdd', Now)]), AFormat, Args);
//  if IsWindow(GSharedInfo.MainFormHandle) then
//  begin
//    if AOnlyDebugShow then
//    begin
//      {$IFDEF DEBUG}
//      SendMessage(GSharedInfo.MainFormHandle, WM_ADD_LOG, 0, LPARAM(sMsg));
//      {$ENDIF}
//    end else
//    begin
//      SendMessage(GSharedInfo.MainFormHandle, WM_ADD_LOG, 0, LPARAM(sMsg));
////      AddLogFile(Format('%sLogs\%s_%d.txt',[GSharedInfo.AppPath, GSharedInfo.SendEntityLst[GSharedInfo.TaskIndex].OrderNo, GSharedInfo.SendEntityLst[GSharedInfo.TaskIndex].ID]), AFormat, Args);
//    end;
//  end;
//  Application.ProcessMessages;
//end;

//procedure TCommFuns.DebugInfo(AFormat: string; const Args: array of const; AOnlyDebugShow: Boolean = False);
//var
//  sMsg: string;
//begin
//  if AOnlyDebugShow then Exit;
//  sMsg := System.SysUtils.Format(AFormat, Args, FormatSettings);
//  if sMsg = '' then Exit;
//  OutputDebugString(PWideChar(sMsg));
//  Application.ProcessMessages;
//end;

//procedure TCommFuns.AddLogFile(AFileNam: string; AFormat: string; const Args: array of const);
//var
//  sMsg: string;
//  vFile: Text;
//begin
//  sMsg := System.SysUtils.Format(AFormat, Args, FormatSettings);
//  if sMsg = '' then Exit;
//  sMsg := Format('[%s]%s', [FormatDateTime('yyyy-MM-dd hh:nn:ss', Now), sMsg]);
//  EnterCriticalSection(CS_LOG);
//  try
//    try
//      AssignFile(vFile, AFileNam);
//      if FileExists(AFileNam) then
//        Append(vFile)
//      else
//        Rewrite(vFile);
//      if Trim(sMsg) <> '' then
//      begin
//        Writeln(vFile, sMsg);
//      end;
//    except
//
//    end;
//  finally
//    CloseFile(vFile);
//    LeaveCriticalSection(CS_LOG);
//  end;
//end;

function TCommFuns.StartProcess(ACmd: String; AIsShow: Boolean = False): Boolean;
var
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
  bRet: Boolean;
begin
  Result := False;
  try
    FillChar(ProcessInfo, SizeOf(TProcessInformation), 0);
    FillChar(StartupInfo, SizeOf(TStartupInfo), 0);
    StartupInfo.cb := SizeOf(TStartupInfo);
    StartupInfo.dwFlags := STARTF_USESHOWWINDOW;
    if not AIsShow then
      StartupInfo.wShowWindow := SW_HIDE
    else
      StartupInfo.wShowWindow := SW_SHOW;
    bRet := CreateProcess(nil, PWideChar(ACmd), nil, nil, False, NORMAL_PRIORITY_CLASS, nil, nil, StartupInfo, ProcessInfo);
    if not bRet then
    begin
      uGlobal.AddLogMsg('����IoPress.exe����ʧ�ܣ�%d', [GetLastError]);
      Exit;
    end;
    CloseHandle(ProcessInfo.hThread);
    CloseHandle(ProcessInfo.hProcess);
    Result := True;
  except
    on E: Exception do
      uGlobal.AddLogMsg('����IoPress.exe�쳣[%s]',[E.Message]);
  end;
end;

function TCommFuns.PressPassWord(AHPwd: HWND; APwd: string; ADealy: Cardinal): Boolean;
var
  cmd: string;
begin
  cmd:= Format('%sIoPress.exe 1 %d %s', [GSharedInfo.AppPath, AHPwd, APwd]);
  Result := StartProcess(cmd, False);
end;
(*
  procedure MsKeyPress(bVk: BYTE; bShift: Boolean);
  begin
    if (bShift) then
    begin
      keybd_event(VK_SHIFT, 0, 0, 0);
      //Sleep(20);
    end;
    keybd_event(bVk, MapVirtualKey(bVk, 0), 0, 0);
    //Sleep(20);
    keybd_event(bVk, MapVirtualKey(bVk, 0), KEYEVENTF_KEYUP, 0);
    if (bShift) then
    begin
      //Sleep(20);
      keybd_event(VK_SHIFT, MapVirtualKey(VK_SHIFT, 0), KEYEVENTF_KEYUP, 0);
    end;
  end;
var
  nLen, i, iIndex: Integer;
  bCode: Byte;
  bShift: Boolean;
{$IFDEF _MS_DEBUG}
  s: string;
{$ENDIF}
begin
  nLen := Length(APwd);
  if( nLen <= 0 ) then Exit;
  for i := 1 to nLen do
  try
    Sleep(ADealy);
    bShift := False;
    bCode := Word(APwd[i]);
    iIndex := GKeyMapLst.IndexOfName(APwd[i]);
    if iIndex >= 0 then
    begin
      {$IFDEF _MS_DEBUG}
      s := GKeyMapLst.Values[APwd[i]];
      s := GKeyMapLst.Values[APwd[i]][1];
      {$ENDIF}
      bCode := Word(GKeyMapLst.Values[APwd[i]][1]);
      bShift := True;
    end;

    if (bCode >= 65) and (bCode <= 90) then
      bShift := True;

    iIndex := GKeyMapLstCode.IndexOfName(APwd[i]);
    if iIndex >= 0 then
    begin
      bCode := StrToIntDef(GKeyMapLstCode.Values[APwd[i]], 0);
    end;

    MsKeyPress(bCode, bShift);
  except

  end;
end;
*)

function TCommFuns.CompressPic(APicName: string; AQuality: ShortInt = 90): Boolean;
var
  bmp: TBitmap;
  jpg: TJpegImage;
  i: Integer;
  //sTemp:string;
begin
  BeginVMP;
  Result := False;
  bmp := TBitmap.Create;
  jpg := TJPEGImage.Create;
  try
    bmp.LoadFromFile(APicName);
    jpg.Assign(bmp);
    jpg.CompressionQuality := AQuality;
    jpg.Compress;
    //sTemp := APicName;
    jpg.SaveToFile(APicName);
  finally
    FreeAndNil(bmp);
    FreeAndNil(jpg);
  end;
  Result := True;
  EndVMP;
end;

//function TCommFuns.GetScreenBmp(AX, AY, AX1, AY1: Integer; APicName: string; AQuality: Integer = 70): Boolean;
//var
//  dc: HDC;
//  lpPal: PLOGPALETTE;
//  bm: TBitMap;
//  jpg: TJpegImage;
//begin
//  // �������ץ��������
//  Result := False;
//  bm := TBitmap.Create;
//  jpg := TJPEGImage.Create;
//  // ��ȡ�豸������
//  dc := GetDc(0);
//  try
//    try
//      PostLogFile('GetScreenBmp(%s)', [APicName]);
//      bm.Height := AY1 - AY;
//      bm.Width := AX1 - AX;
//      PostLogFile('GetScreenBmp - 01', []);
//      if ((bm.Width = 0) or (bm.Height = 0)) then Exit;
//      PostLogFile('GetScreenBmp - 02', []);
//      if (dc = 0) then Exit;
//      PostLogFile('GetScreenBmp - 03', []);
//      if (GetDeviceCaps(dc, RASTERCAPS) AND RC_PALETTE = RC_PALETTE) then
//      begin
//        PostLogFile('GetScreenBmp - 04', []);
//        GetMem(lpPal, sizeof(TLOGPALETTE) + (255 * sizeof(TPALETTEENTRY)));
//        PostLogFile('GetScreenBmp - 05', []);
//        FillChar(lpPal^, sizeof(TLOGPALETTE) + (255 * sizeof(TPALETTEENTRY)), #0);
//        PostLogFile('GetScreenBmp - 06', []);
//        lpPal^.palVersion := $300;
//        PostLogFile('GetScreenBmp - 07', []);
//        lpPal^.palNumEntries := GetSystemPaletteEntries(dc, 0, 256, lpPal^.palPalEntry);
//        PostLogFile('GetScreenBmp - 08', []);
//        if (lpPal^.palNumEntries <> 0) then
//        begin
//          PostLogFile('GetScreenBmp - 09', []);
//          bm.Palette := CreatePalette(lpPal^);
//        end;
//        PostLogFile('GetScreenBmp - 10', []);
//        FreeMem(lpPal, sizeof(TLOGPALETTE) + (255 * sizeof(TPALETTEENTRY)));
//        PostLogFile('GetScreenBmp - 11', []);
//      end;
//      BitBlt(bm.Canvas.Handle, 0, 0, bm.Width, bm.Height, dc, AX, AY, SRCCOPY);
//      PostLogFile('GetScreenBmp - 12', []);
//
//      jpg.Assign(bm);
//      PostLogFile('GetScreenBmp - 13', []);
//      jpg.CompressionQuality := AQuality;
//      PostLogFile('GetScreenBmp - 14', []);
//      jpg.Compress;
//      PostLogFile('GetScreenBmp - 15', []);
//      //sTemp := APicName;
//      jpg.SaveToFile(APicName);
//      PostLogFile('GetScreenBmp - 16', []);
//      if FileExists(APicName) then
//        PostLogFile('��ͼ�ɹ�(%s)', [APicName])
//      else
//        PostLogFile('��ͼʧ��(%s)', [APicName]);
//      Result := True;
//    except on E: Exception do
//      AddLogMsg('TDmFuns.GetScreenBmp fail[ErrMsg=%s]', [E.Message]);
//    end;
//  finally
//    ReleaseDc(0, dc);
//    FreeAndNil(bm);
//    FreeAndNil(jpg);
//  end;
//end;

function TCommFuns.GetScreenBmp(AX, AY, AX1, AY1: Integer; AFileName: string): Boolean;
var
  vBmp: TBitmap;
  I, J, vPos: Integer;
  dwPos: DWORD;
  jpg: TJpegImage;
begin
  BeginVMP;
  Result := False;
  vBmp := TBitmap.Create;
  jpg := TJPEGImage.Create;
  try
    try
      PostLogFile('X:%d Y:%d X1:%d Y1:%d', [AX, AY, AX1, AY1]);
//      vPos := Self.GetScreenData(AX, AY, AX1, AY1);
//      vBmp.Height := AY1 - AY;
//      vBmp.Width := AX1 - AX;
//      dwPos := 0;
//      for I := 0 to vBmp.Height - 1 do
//        for J := 0 to vBmp.Width - 1 do
//        begin
//          vBmp.Canvas.Pixels[J, I] := RGBtoBGR(DWORD(Pointer(vPos + dwPos)^));
//          dwPos := dwPos + 4;
//        end;
//      //vBmp.SaveToStream();
//      //jpg.LoadFromStream();
//      PostLogFile('GetScreenBmp - 01', []);
//      jpg.CompressionQuality := 70;
//      PostLogFile('GetScreenBmp - 02', []);
//      jpg.Assign(vBmp);
//      PostLogFile('GetScreenBmp - 03 Jpg[W: %d, H: %d]', [jpg.Width, jpg.Height]);
//      jpg.Compress;
//      PostLogFile('GetScreenBmp - 04', []);
//      jpg.SaveToFile(AFileName);
      CaptureGif(AX, AY, AX1, AY1, AFileName, 0, 1);
      //vBmp.SaveToFile(AFileName);
      Result := FileExists(AFileName);
      Result := True;
      if Result then
        PostLogFile('��ͼ�ɹ�(%s)', [AFileName])
      else
        PostLogFile('��ͼʧ��(%s)', [AFileName]);
    except on E: Exception do
      begin
        //--ʧ�ܺ��ȱ���һ�£� ԭʼͼ
        //PostLogFile('GetScreenBmp - 05 Bmp[W: %d, H: %d] ', [vBmp.Width, vBmp.Height]);
        //vBmp.SaveToFile(AFileName);
        //Result := FileExists(AFileName);
        AddLogMsg('TDmFuns.GetScreenBmp fail[ErrMsg=%s]', [E.Message]);
      end;
    end;
  finally
    FreeAndNil(jpg);
    FreeAndNil(vBmp);
  end;
  EndVMP;
end;

function TCommFuns.CreateRoleBmp(ARoleName: string; ASaveFileName: string): Boolean;
begin
   Result := CreateBmp(ARoleName, 209, 185, 148, ASaveFileName);
end;

function TCommFuns.CreateBmp(AText: string; R, G, B: Byte; ASaveFileName: string): Boolean;
  function HasColor(clr: TGPColor; del255: Boolean = true): Boolean;
  var A, R, G, B: ARGB;
  begin
    A := GetAlpha(clr);
    R := GetRed(clr);
    G := GetGreen(clr);
    B := GetBlue(clr);
    Result := (A <> 0) and (((not del255) and (R = 255) and (G = 255) and (B=255)) or (R < 255) or (G < 255) or (B < 255) );
  end;

  function RemoveBlank(bmp: TGPBitmap; Top: Boolean = true; Left: Boolean = true; Right: Boolean = true; Bottom: Boolean = true; del255: Boolean = true): TGPBitmap;
  var
    num, num2, num3, num4, i, j: Integer;
    clr: TGPColor;
    flag: Boolean;
  begin
    num := 0;
    num2 := bmp.GetHeight - 1;
    clr := 0;
    if (Top) then
    begin
      for i := 0 to bmp.GetHeight - 1 do
      begin
        flag := false;
        for j := 0 to bmp.GetWidth -1 do
        begin
          bmp.GetPixel(j, i, clr);
          if (HasColor(clr, del255)) then
          begin
            flag := True;
            Break;
          end;
        end;
        if (flag) then
        begin
          num := i;
          Break;
        end;
      end;
    end;
    if (Bottom) then
    begin
      for i := bmp.GetHeight - 1 downto 0 do
      begin
        flag := false;
        for j := 0 to bmp.GetWidth - 1 do
        begin
          bmp.GetPixel(i, j, clr);
          if HasColor(clr, del255) then
          begin
            flag := true;
            break;
          end;
        end;
        if (flag) then
        begin
          num2 := i;
          break;
        end;
      end;
    end;
    num3 := 0;
    num4 := bmp.GetWidth() - 1;
    if (Left) then
    begin
      for i := 0 to bmp.GetWidth - 1 do
      begin
        flag := false;
        for j := 0 to bmp.GetHeight - 1 do
        begin
          bmp.GetPixel(i, j, clr);
          if HasColor(clr, del255) then
          begin
            flag := true;
            break;
          end;
        end;
        if (flag) then
        begin
          num3 := i;
          break;
        end;
      end;
    end;
    if (Right) then
    begin
      for i := bmp.GetWidth - 1 downto 0 do
      begin
        flag := false;
        for j := 0 to bmp.GetHeight - 1 do
        begin
          bmp.GetPixel(i, j, clr);
          if HasColor(clr, del255) then
          begin
            flag := true;
            break;
          end;
        end;
        if (flag) then
        begin
          num4 := i;
          break;
        end;
      end;
    end;
    Result := bmp.Clone(MakeRect(num3, num, num4 + 1 - num3, num2 + 1 - num), bmp.GetPixelFormat);
  end;
var
  vFont: TGPFont;
  vBrush: TGPSolidBrush;
  vBitmap, vBitmap2: TGPBitmap;
  vColor: TGPColor;
  sRoleName: string;
  vGraphis: TGPGraphics;
  I, iNum, iLastX: Integer;
  vBitList: TArray<TGPBitmap>;
  vBmp: TBitmap;
  hBit: HBITMAP;
begin
  BeginVMP();
  Result := False;
  SetLength(vBitList, 0);
  vFont := TGPFont.Create('����', 12.0, FontStyleRegular, UnitPixel);
  vColor := MakeColor(R, G, B);
  vBrush := TGPSolidBrush.Create(vColor);
  sRoleName := Trim(AText);
  iNum := 0;
  for I := 1 to Length(sRoleName) do
  begin
    vBitmap := TGPBitmap.Create(30, 14);
    vGraphis := TGPGraphics.Create(vBitmap);
    try
      vGraphis.SetSmoothingMode(SmoothingModeDefault);
      vGraphis.SetInterpolationMode(InterpolationModeHighQualityBicubic);
      vGraphis.SetCompositingQuality(CompositingQualityHighQuality);
      //if sRoleName[I] = 'j' then
      //  vGraphis.DrawString(string(''), -1, vFont, MakePoint(0.0, 0.0), vBrush)
      //else
        vGraphis.DrawString(string(sRoleName[I]), -1, vFont, MakePoint(0.0, 0.0), vBrush);
      vBitmap := RemoveBlank(vBitmap, False, True, True, False, False);
      iNum := iNum + vBitmap.GetWidth + 1;
      SetLength(vBitList, Length(vBitList) + 1);
      vBitList[High(vBitList)] := vBitmap;
    finally
      FreeAndNil(vGraphis);
    end;
  end;
  vBitmap2 := TGPBitmap.Create(iNum + 1, 14);
  vGraphis := TGPGraphics.Create(vBitmap2);
  vBmp := TBitmap.Create;
  iLastX := 1;
  try
    for vBitmap in vBitList do
    begin
      vGraphis.DrawImage(vBitmap, MakePoint(iLastX, 1));
      iLastX := iLastX + vBitmap.GetWidth + 1;
    end;
    vBitmap2.GetHBITMAP(aclBlack, hBit);
    vBmp.Handle := hBit;
    vBmp.PixelFormat := pf24bit;
    vBmp.SaveToFile(ASaveFileName);
    //DebugInfo('MS - RoleBmp:%s', [ASaveFileName]);
  finally
    FreeAndNil(vBitmap);
    FreeAndNil(vBmp);
    FreeAndNil(vGraphis);
  end;
  Result := True;
  EndVMP;
end;

function TCommFuns.fnУ��(ACheckWindow: Boolean = True): Boolean;
  function fn����жϼ�����(): Boolean;
  var
    vRet: TFindRet;
  begin
    Result := False;
    //vRet := Self.fn����ͼƬ_��������('NetBreak.bmp|Check3rd.bmp|QuitSafeModel.bmp');
    vRet := Self.fnȫ������_��������('���������ж�|DNF��⵽�зǷ�������ģ��|�����˻��ѳɹ��˳���ȫģʽ', 'ffffff-000000', CON_SYS_DICT, 1.0);
    if vRet.Ret <> -1  then
    begin
      if vRet.Ret = 0 then
      begin
        TradeClient.PostStatus('���������жϣ����β���ʧ��', [], tsFail);
        Exit;
      end;
      if vRet.Ret = 1 then
      begin
        TradeClient.PostStatus('�Ƿ������������β���ʧ��', [], tsFail);
        Exit;
      end;
      if vRet.Ret = 2 then
      begin
        Sleep(100);
        Self.fn����(VK_RETURN);
      end;
    end;
    Result := True;
  end;

  function fn��Ϸ���ڼ��(AIsCheck: Boolean): Boolean;
  begin
    Result := False;
    if AIsCheck then
    begin
      if not IsWindow(GSharedInfo.GameWindow) then
      begin
        TradeClient.PostStatus('��Ϸ�����쳣�˳������β���ʧ��', [], tsFail);
        Exit;
      end;
    end;
    Result := True;
  end;

var
  x1, x2, y1, y2: Integer;
begin
  Result := False;
  try
    { TODO : ��ʱ��Ϊ��ѭ�� }
    while True do
    begin
      Sleep(10);
      if not fn��Ϸ���ڼ��(ACheckWindow) then Exit;
      if IsWindow(GSharedInfo.GameWindow) then
      begin
        Self.fn��ȡ�ͻ�����(GSharedInfo.GameWindow, x1, y1, x2, y2);
        if (x1 <> 0) or (y1 <> 0) then
        begin
          Self.fn�ƶ�����(GSharedInfo.GameWindow, 0, 0);
        end;
      end;

      // --����Ƿ����������ж�
      if not fn����жϼ����� then Exit;

      //--��ֹ����
      if GSharedInfo.bStopTask then
      begin
        TradeClient.PostStatus('��Ϊ��ֹ����', [], tsFail, False);
        GSharedInfo.bSuspendTask := False;
        Exit;
      end;

      //--�����������ͣ״̬�� ��һֱ�ȴ�
      if not GSharedInfo.bSuspendTask then Break;
      AddLogMsg('������ͣ��...', []);
      Sleep(5000);
    end;
    Result := True;
  except
  end;
end;

function TCommFuns.CloseGame(ADelay: DWORD): Boolean;
var
  dwTick, dwTid: DWORD;
  hGame: HWND;
begin
  try
    dwTick := GetTickCount;
    ManSoy.Global.MyWinExec(Format('%sKill.bat',[GSharedInfo.AppPath]));
    Sleep(10);
    //----------------------------
    dwTid := GetProcessIdByName('TASLogin.exe');
    KillProcessByID(dwTid);
    //----------------------------
    dwTid := GetProcessIdByName('TenSafe_1.exe');
    KillProcessByID(dwTid);
    //----------------------------
    dwTid := GetProcessIdByName('QQLogin.exe');
    KillProcessByID(dwTid);
    //----------------------------
    dwTid := GetProcessIdByName('TXPlatform.exe');
    KillProcessByID(dwTid);
    //----------------------------
    dwTid := GetProcessIdByName('Tencentdl.exe');
    KillProcessByID(dwTid);
    //----------------------------
    dwTid := GetProcessIdByName('TenioDL.exe');
    KillProcessByID(dwTid);
    //----------------------------
    dwTid := GetProcessIdByName('DNF.exe');
    KillProcessByID(dwTid);
    //----------------------------
    dwTid := GetProcessIdByName('DNFChina.exe');
    KillProcessByID(dwTid);
    //----------------------------
    dwTid := GetProcessIdByName('Client.exe');
    KillProcessByID(dwTid);

    hGame := FindWindow('���³�����ʿ', '���³�����ʿ');
    if IsWindow(hGame) then
    begin
      SendMessage(GSharedInfo.MainFormHandle, WM_HOOK_ON, 0, LPARAM(hGame));
    end;

    hGame := FindWindow(nil, '���³�����ʿ��¼����');
    if IsWindow(hGame) then
    begin
      SendMessage(GSharedInfo.MainFormHandle, WM_HOOK_ON, 0, LPARAM(hGame));
    end;

    hGame := FindWindow(nil, '���³�����ʿ�޸�����');
    if IsWindow(hGame) then
    begin
      SendMessage(GSharedInfo.MainFormHandle, WM_HOOK_ON, 0, LPARAM(hGame));
    end;

    while GetTickCount - dwTick <=  ADelay * 1000 do
    begin
      Sleep(10);
    end;
    Result := True;
  except

  end;
end;

function TCommFuns.WriteGameRegionSvr(AGamePath, ALastSelSvr: string; ALastQQUin: string): Boolean;
  function GetAreaID(AAreaName: string): Integer;
  var
    szSysCfg: string;
  begin
    BeginVMP;
    Result := -1;
    szSysCfg := Format('%s\Config\GameArea.ini', [GSharedInfo.AppPath]);
    try
      Result := GetPrivateProfileInt('����', PWideChar(AAreaName), -1,
        PWideChar(szSysCfg));
    except
      Exit;
    end;
    EndVMP;
  end;

var
  szGameCfgFile: string;
  iGameID: Integer;
begin
  BeginVMP;
  Result := False;
  try
    iGameID := GetAreaID(ALastSelSvr);
    if iGameID = -1 then
    begin
      TradeClient.PostStatus('û���ҵ���ǰ������%s����Ӧ��ID', [ALastSelSvr], tsFail, False);
      Exit;
    end;
    szGameCfgFile := Format('%s\TCLS\config\LoginQ.dat', [AGamePath]);
    WritePrivateProfileString('NoLoginUserRecord', 'LastLogin', PWideChar(Format('%d', [iGameID])), PWideChar(szGameCfgFile));
    WritePrivateProfileString('Public', 'LastQQUin', PWideChar(ALastQQUin), PWideChar(szGameCfgFile));
    WritePrivateProfileString('OhterInfo', 'IsCloseSound', '1', PWideChar(szGameCfgFile));
    WritePrivateProfileString('AutoRepair', 'RepairResult', '0', PWideChar(szGameCfgFile));
    Result := True;
  except
    on E: Exception do
    begin
      AddLogMsg('д������Ϣ����:%s', [E.Message]);
      Result := False
    end;
  end;
  EndVMP;
end;

function TCommFuns.PostCapture(APath: string): Boolean;
  function UpLoadCapture(AFileName: string): Boolean;
  var
    obj: TIdMultiPartFormDataStream;
    sRet: string;
    IdHttp: TIdHTTP;
  begin
    Result := False;
    obj := TIdMultiPartFormDataStream.Create;
    IdHttp := TIdHTTP.Create(nil);
    try
      try
        IdHttp.ReadTimeout := 30 * 1000;
        sRet := GetMIMETypeFromFile(AFileName);
        obj.AddFile('oa_img', AFileName, GetMIMETypeFromFile(AFileName));
        IdHttp.Request.ContentType := obj.RequestContentType;
        obj.Position := 0;
        sRet := IdHttp.Post(GSharedInfo.ClientSet.Url�ϴ�ͼƬ, obj);
        if sRet <> '1' then
        begin
          AddLogMsg('�ϴ�ͼƬ�ļ�:%s ʧ��', [AFileName]);
          PostLogFile('�ϴ�ͼƬ�ļ�:%s ʧ��', [AFileName]);
        end;
        Result := True;
      except
        on E: Exception do
        begin
          AddLogMsg('�ϴ�ͼƬ�ļ�:%s �쳣', [AFileName]);
          PostLogFile('�ϴ�ͼƬ�ļ�:%s �쳣, ԭ��[%s]', [AFileName, E.Message]);
        end;
      end;
    finally
      obj.Free;
      FreeAndNil(IdHttp);
    end;
  end;
var
  Found: TSearchRec;
  Finished: integer;
begin
  Result := False;
  //fn����״̬����('�ϴ���ͼ��ʼ',[], tsNormal);
  AddLogMsg('�ϴ���ͼ��ʼ', []);
  try
    Finished := FindFirst(APath + '\*.bmp', 63, Found);
    while (Finished = 0) do
    begin
      if (Found.Name <> '.') and (Found.Name <> '..') then
      begin
        AddLogMsg('�����ϴ���ͼ: %s', [Found.Name], True);
//{$IFNDEF DEBUG}
        if UpLoadCapture(APath + '\' + Found.Name) then
        begin
        end;
//{$ENDIF}
      end;
      Finished := FindNext(Found);
    end;
    FindClose(Found);
    Result := True;
    AddLogMsg('�ϴ���ͼ����', []);
  except
  end;
end;

function TCommFuns.GetCarryAmount(ALevel: Integer): Integer;
var
  vIdHttp: TIdHTTP;
  sRet: string;
  iRet, I: Integer;
begin
  Result := -1;
  vIdHttp := TIdHTTP.Create(nil);
  try
    for I := 1 to 3 do
    try
      sRet := vIdHttp.Get(Format(string(GConsoleSet.CarryInterface), [ALevel]));
      iRet := StrToIntDef(sRet, -1);
      if iRet <> -1 then
      begin
        iRet := iRet * 10000;
        Result := iRet;
        AddLogMsg('Я����: %d', [iRet], True);
        Break;
      end;
      Sleep(1000);
    except on E: Exception do
      AddLogMsg('��ȡЯ����ʧ��:%s', [E.Message]);
    end;
  finally
    vIdHttp.Disconnect;
    FreeAndNil(vIdHttp);
  end;
end;

function TCommFuns.GetPassWord(AAccount: string): string;
var
  http: TIdHTTP;
  vResponseContent: TStringStream;
  url, sPwd: string;
  JO: ISuperObject;
  JA: TSuperArray;
begin
  Result := '-1';
  vResponseContent := TStringStream.Create('', TEncoding.UTF8);
  http := TIdHTTP.Create(nil);
  try
    try
      url := Format('http://117.34.5.5:8088/apiImitatorController.do?method=getAccountInfo&account=%s', [AAccount]);//'http://192.168.192.179:8088/apiImitatorController.do?method=getAccountInfo&account='+AAccount;
      http.Get(url, vResponseContent);
      Result := vResponseContent.DataString;
      if Result = '[]' then
      begin
        url := Format('http://117.34.5.5:8672/apiImitatorController.do?method=getAccountInfo&account=%s', [AAccount]);//'http://192.168.192.179:8088/apiImitatorController.do?method=getAccountInfo&account='+AAccount;
        http.Get(url, vResponseContent);
        Result := vResponseContent.DataString;
      end;

      if Result = '[]' then
      begin
        Result := '-1';
        Exit;
      end;

      JO := SO(Result);
      JA := JO.AsArray;
      sPwd := JA[0].S['gamePasswd'];
      sPwd := ManSoy.Encode.Base64ToStr(AnsiString(sPwd));
      Result := sPwd;
    except
    end;
  finally
    FreeAndNil(vResponseContent);
    http.Disconnect;
    FreeAndNil(http);
  end;
end;

{$ENDREGION}

{$REGION 'VMP'}
procedure TCommFuns.BeginVMP(AFlag: string);
asm
  {$IFDEF _VMP}
  db $EB,$10,AFlag + ' begin',0       //��ǿ�ʼ��.
  {$ENDIF}
end;

procedure TCommFuns.EndVMP(AFlag: string);
asm
  {$IFDEF _VMP}
  db $EB,$0E, AFlag + ' end',0       //��ǿ�ʼ��.
  {$ENDIF}
end;
{$ENDREGION}

{$REGION '�ⲿ'}
function TCommFuns.fnDaMa(ADama2User, ADama2Pwd, AImgFileName: string; ADealyTimes: DWORD): string;
type
  //--�����÷��ص���֤����Ϣ
  TDama2Ret = record
    drCodeText: string;
    drCodeID  : Integer;
  end;

//  TD2File = function (pszSoftwareID : LPCSTR;
//    pszUserName : LPCSTR;
//    pszUswrPassword : LPCSTR;
//    pszFileName : LPCSTR;
//    usTimeout : Word;
//    ulVCodeTypeID : Longint;
//    pszVCodeText : LPSTR): Integer;
//
//function D2File(
//    pszSoftwareID : LPCSTR;
//    pszUserName : LPCSTR;
//    pszUswrPassword : LPCSTR;
//    pszFileName : LPCSTR;
//    usTimeout : Word;
//    ulVCodeTypeID : Longint;
//    pszVCodeText : LPSTR) : Integer;
//var
//  hLib: THandle;
//  PD2File: TD2File;
//begin
//  Result := -1;
//  try
//    DebugInf('MS - D2File1', []);
//    hLib := LoadLibrary(PWideChar(GSharedInfo.AppPath + 'CrackCaptchaAPI.dll'));
//    if hLib <> 0 then
//    begin
//      DebugInf('MS - D2File2', []);
//      @PD2File := GetProcAddress(hLib, 'D2File');
//      if Assigned(PD2File) then
//      begin
//        DebugInf('MS - D2File3', []);
//        Result := PD2File(pszSoftwareID, pszUserName, pszUswrPassword, pszFileName, usTimeout, ulVCodeTypeID, pszVCodeText);
//      end;
//      DebugInf('MS - D2File4', []);
//      FreeLibrary(hLib);
//      DebugInf('MS - D2File5', []);
//    end;
//  except on E: Exception do
//    DebugInf('MS - D2File fail[%s]', [E.Message]);
//  end;
//end;
//
//function DamaForDnfAutoTrade(AUserName: string; APassWord: string; AFileName: string; ADelay: Integer; AType: Integer; var ARetCheckCode: string): Integer;
//var
//  iRet: Integer;
//  szRetCodeText : array[0..100] of AnsiChar;
//begin
//  //������� DnfDaMa
//  DebugInf('MS - DamaForDnfAutoTrade1', []);
//  ZeroMemory(@szRetCodeText, SizeOf(szRetCodeText));
//  Result := D2File('341ca3be1f86a2c3cd45386239768fcf',
//      PAnsiChar(AnsiString(AUserName)),
//      PAnsiChar(AnsiString(APassWord)),
//      PAnsiChar(AnsiString(AFileName)),
//      ADelay,
//      AType,
//      szRetCodeText
//      );
//  ARetCheckCode := string(AnsiString(szRetCodeText));
//  DebugInf('MS - DamaForDnfAutoTrade2��%d-%s��', [Result, ARetCheckCode]);
//end;

var
  iRet: Integer;
  Dama2Ret: TDama2Ret;
begin
  BeginVMP;
  Dama2Ret.drCodeText := '';
  Dama2Ret.drCodeID := -1;
  Result := '';
  iRet := DamaForDnfAutoTrade(
    ADama2User,
    ADama2Pwd, AImgFileName
    ,
    ADealyTimes,
    42,
    Dama2Ret.drCodeText
    );
  if iRet < 0 then Exit;
  Result := Dama2Ret.drCodeText;
  DebugInf('MS - �������', []);
  EndVMP;
end;

function TCommFuns.fnQuitSate: string;
begin
  Result := '�ⰲȫ�����쳣';
  try
  //TODO: ��ʱ����
//    Result := QQSafe(
//      0,
//      PAnsiChar(AnsiString(GSharedInfo.OrderItem.roles[GSharedInfo.RoleIndex].account)),
//      PAnsiChar(AnsiString(GSharedInfo.OrderItem.roles[GSharedInfo.RoleIndex].passWord)),
//      PAnsiChar(AnsiString(GSharedInfo.OrderItem.gameArea)),
//      PAnsiChar(AnsiString(GSharedInfo.OrderItem.gameSvr)),
//      GSharedInfo.OrderItem.roles[GSharedInfo.RoleIndex].safetyWay,
//      ''
//    );
    AddLogMsg('���[%s]�˺�[%s]����[%s]����[%s]����[%s]��ȫ����[%d]',[
      Result,
      PAnsiChar(AnsiString(GSharedInfo.OrderItem.roles[GSharedInfo.RoleIndex].account)),
      PAnsiChar(AnsiString(GSharedInfo.OrderItem.roles[GSharedInfo.RoleIndex].passWord)),
      PAnsiChar(AnsiString(GSharedInfo.OrderItem.gameArea)),
      PAnsiChar(AnsiString(GSharedInfo.OrderItem.gameSvr)),
      GSharedInfo.OrderItem.roles[GSharedInfo.RoleIndex].safetyWay
    ], True);
  except
  end;
end;

{$ENDREGION}

{$REGION '����'}
function TCommFuns.GetDealy(ADealyKey: string): DWORD;
begin
  BeginVMP;
  Result := 5;
  try
    Result := GetPrivateProfileInt('Dealy', PWideChar(ADealyKey), 5, PWideChar(FSysCfgFile));
  except on E: Exception do
    AddLogMsg('THandTask.GetDealy fail[%s]...', [E.Message]);
  end;
  EndVMP;
end;

function TCommFuns.GetPianSe(AKey: string): string;
var
  szPianSe: array [0 .. 64] of WideChar;
begin
  BeginVMP;
  Result := 'ffffff-000000';
  try
    ZeroMemory(@szPianSe, SizeOf(szPianSe));
    GetPrivateProfileString('ƫɫ', PWideChar(AKey), 'ffffff-000000', szPianSe, 64, PWideChar(FSysCfgFile));
    Result := string(szPianSe);
    // AddLogMsg('ƫɫ��%s', [Result], True);
  except on E: Exception do
    AddLogMsg('THandTask.Getƫɫ fail[%s]...', [E.Message]);
  end;
  EndVMP;
end;
{$ENDREGION}

{$REGION '��ɫת��'}
//����B��G��R����ͨ����ֵ����һ��BGR��ʽ��ɫ��
function TCommFuns.BGR(B,G,R : Byte): TBDColor;
begin
  result:=(B or (G shl 8) or (R shl 16));
end;

//RGB��ɫ��ʽת����BGR��ɫ��ʽ��
function TCommFuns.RGBtoBGR(C : TColor): TBDColor;
begin
  result:=((C and $FF0000) shr 16) or (C and $00FF00) or ((C and $0000FF) shl 16);
end;

//BGR��ɫ��ʽת����RGB��ɫ��ʽ��
function TCommFuns.BGRtoRGB(C : TBDColor): TColor;
begin
  result:=((C and $FF0000) shr 16) or (C and $00FF00) or ((C and $0000FF) shl 16);
end;
{$ENDREGION}

initialization
  GCommFuns := TCommFuns.Create;

finalization
  GCommFuns.Free;

end.
