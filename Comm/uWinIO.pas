unit uWinIO;

interface

uses
  Winapi.Windows;

const
  KBC_KEY_CMD = $64;
  KBC_KEY_DATA = $60;

function InitializeWinIo:Boolean;stdcall;external 'WinIo.dll' name'InitializeWinIo';
function InstallWinIoDriver(pszWinIoDriverPath:PWideChar; IsDemandLoaded:boolean=false):Boolean;stdcall;external 'WinIo.dll' name 'InstallWinIoDriver';
function RemoveWinIoDriver:Boolean;stdcall;external 'WinIo.dll' name 'RemoveWinIoDriver';
function GetPortVal(PortAddr:Word; PortVal:PDWORD; bSize: Byte):Boolean;stdcall;external 'WinIo.dll' name 'GetPortVal';
function SetPortVal(PortAddr:Word; PortVal:DWord; bSize:Byte):Boolean;stdcall;external 'WinIo.dll' name 'SetPortVal';
function GetPhysLong(PhysAddr:PByte; PhysVal:PDWord):Boolean;stdcall;external 'WinIo.dll' name 'GetPhysLong';
function SetPhysLong(PhysAddr:PByte; PhysVal:DWord):Boolean;stdcall;external 'WinIo.dll' name 'SetPhysLong';
function MapPhysToLin(PhysAddr:PByte; PhysSize:DWord;PhysMemHandle:PHandle):PByte;stdcall;external 'WinIo.dll' name 'MapPhysToLin';
function UnMapPhysicalMemory(PhysMemHandle:THandle; LinAddr:PByte):Boolean;stdcall;external 'WinIo.dll' name 'UnmapPhysicalMemory';
procedure ShutdownWinIo;stdcall;external 'WinIo.dll' name'ShutdownWinIo';

procedure MsKeyPress(vKeyCode: Integer; AShift: Boolean = False);

implementation

procedure KBCWait4IBE; //µÈ´ý¼üÅÌ»º³åÇøÎª¿Õ
var
  dwVal:DWord;
begin
  repeat
    GetPortVal($64,@dwVal,1);
  until (dwVal and $2)=0;
end;

procedure MyKeyDown(vKeyCoad:Integer);
var
  btScancode:DWord;
begin
  btScancode:=MapVirtualKey(vKeyCoad, 0);
  KBCWait4IBE;
  SetPortVal(KBC_KEY_CMD, $D2, 1);
  KBCWait4IBE;
  //SetPortVal(KBC_KEY_DATA, $E2, 1);
  //KBCWait4IBE;
  SetPortVal(KBC_KEY_CMD, $D2, 1);
  KBCWait4IBE;
  SetPortVal(KBC_KEY_DATA, btScancode, 1);
end;

procedure MyKeyUp(vKeyCoad:Integer);
var
  btScancode:DWord;
begin
  btScancode:=MapVirtualKey(vKeyCoad, 0);
  KBCWait4IBE;
  SetPortVal(KBC_KEY_CMD, $D2, 1);
  KBCWait4IBE;
  //SetPortVal(KBC_KEY_DATA, $E2, 1);
  //KBCWait4IBE;
  SetPortVal(KBC_KEY_CMD, $D2, 1);
  KBCWait4IBE;
  SetPortVal(KBC_KEY_DATA, (btScancode or $80), 1);
end;

procedure MsKeyPress(vKeyCode: Integer; AShift: Boolean);
begin
  if AShift then
  begin
    MyKeyDown(VK_SHIFT);
    Sleep(100);
  end;
  MyKeyDown(vKeyCode);
  Sleep(100);
  MyKeyUp(vKeyCode);
  if AShift then
  begin
    Sleep(100);
    MyKeyUp(VK_SHIFT);
  end;
end;

initialization
  InitializeWinIo;

finalization
  ShutdownWinIo;

end.
