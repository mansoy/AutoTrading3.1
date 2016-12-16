unit HideModuleUnit;

interface

uses Windows, Messages, SysUtils, Classes, TlHelp32;

type
  TVirtualAlloc = function (lpvAddress: Pointer; dwSize, flAllocationType, flProtect: DWORD): Pointer; stdcall;
  TVirtualProtect = function (lpAddress: Pointer; dwSize, flNewProtect: DWORD; var OldProtect: DWORD): BOOL; stdcall;
  TVirtualFree = function (lpAddress: Pointer; dwSize, dwFreeType: DWORD): BOOL; stdcall;
  TWriteProcessMemory = function (hProcess: THandle; const lpBaseAddress: Pointer; lpBuffer: Pointer; nSize: DWORD; var lpNumberOfBytesWritten: DWORD): BOOL; stdcall;
  TGetCurrentProcess = function : THandle; stdcall;
  TFreeLibrary = function (hLibModule: HMODULE): BOOL; stdcall;

  THideModuleRec = record
    pModule: pointer;
    pVirtualAlloc: TVirtualAlloc;
    pVirtualProtect: TVirtualProtect;
    pVirtualFree: TVirtualFree;
    pWriteProcessMemory: TWriteProcessMemory;
    pGetCurrentProcess: TGetCurrentProcess;
    pFreeLibrary: TFreeLibrary;
  end;
  PHideModuleRec = ^THideModuleRec;

  procedure HideModule(hModule: THandle);

implementation

procedure ExecuteHide(HM: THideModuleRec);
var
  pBakMemory: pointer;
  ImageOptionalHeader: TImageOptionalHeader32;
  ImageDosHeader: TImageDosHeader;
  td: dword;
  i: Integer;
begin
  { ȡ��ӳ������ }
  ImageDosHeader := PImageDosHeader(HM.pModule)^;
  ImageOptionalHeader := PImageOptionalHeader32(Pointer(integer(HM.pModule) + ImageDosHeader._lfanew + SizeOf(dword) + SizeOf(TImageFileHeader)))^;
  { �����ڴ��Ա���ԭʼģ������ }
  pBakMemory := HM.pVirtualAlloc(nil, ImageOptionalHeader.SizeOfImage, MEM_COMMIT or MEM_RESERVE, PAGE_EXECUTE_READWRITE);
  if pBakMemory = nil then
    exit;
  { �޸�ԭʼ�ڴ�Ϊ�ɶ�д���� }
  HM.pVirtualProtect(HM.pModule, ImageOptionalHeader.SizeOfImage,
    PAGE_EXECUTE_READWRITE, td);
  { ����ԭʼģ������ }
  HM.pWriteProcessMemory(HM.pGetCurrentProcess, pBakMemory, HM.pModule,
    ImageOptionalHeader.SizeOfImage, td);
  { �޸�ԭDllEntryPointΪretn,��ֹFreeLibraryʱ��һЩж�ز��� }
  pByte(integer(HM.pModule) + ImageOptionalHeader.AddressOfEntryPoint)^ := $C3;
  { ж��ԭģ��,������ж�ط�ֹ��ΪLoadCount�Ĺ�ϵһ��ж�ز��� }
  //HM.pFreeLibrary(integer(HM.pModule));
  i := 0;
  repeat
    Inc(i);
  until not HM.pFreeLibrary(integer(HM.pModule)) or (i >= 30);
  { ����dllԭʼ���ص�ַ�ռ� }
  HM.pModule := HM.pVirtualAlloc(HM.pModule, ImageOptionalHeader.SizeOfImage,
    MEM_COMMIT or MEM_RESERVE, PAGE_EXECUTE_READWRITE);
  if HM.pModule = nil then
    exit;
  { д��ԭʼ���� }
  HM.pWriteProcessMemory(HM.pGetCurrentProcess, HM.pModule, pBakMemory,
    ImageOptionalHeader.SizeOfImage, td);
  { �ͷű���ʱ�õ��ڴ� }
  HM.pVirtualFree(pBakMemory, 0, MEM_RELEASE);
end;
(*ע��ü������������κδ���, �Ҳ��ܸı�����2������λ��
  ��Ϊ����ʹ����2�����������������һ����Size*)
procedure LockedAllModule(CurrentModuleHandle: THandle);
var
  ModuleList: THandle;
  pm: tagMODULEENTRY32;
begin
  pm.dwSize := sizeof(tagMODULEENTRY32);
  ModuleList := CreateToolhelp32Snapshot(TH32CS_SNAPMODULE, 0);
  if not Module32First(ModuleList, pm) then
  begin
    CloseHandle(ModuleList);
    exit;
  end;
  //�������һ��ģ��,��Ϊ������ģ��
  { ��ÿ��ģ��LoadLibraryһ��,��Ϊ�˰�LoadCount��1 }
  while Module32Next(ModuleList, pm) do
  begin
    if pm.hModule <> CurrentModuleHandle then
      LoadLibrary(PWideChar(@GetModuleName(pm.hModule)[1]));
  end;
  CloseHandle(ModuleList);
end;

type
  TExecuteHide = procedure (HM: THideModuleRec);

procedure HideModule(hModule: THandle);
var
  HM: THideModuleRec;
  pExecuteHide: pointer;
  ExecuteHideSize: integer;
  MyExecuteHide: TExecuteHide;
  td: dword;
  Module_kernel32: integer;
begin
  Module_kernel32 := GetModuleHandle('kernel32.dll');
  HM.pModule := pointer(hModule);
  HM.pVirtualAlloc := GetProcAddress(Module_kernel32, 'VirtualAlloc');
  HM.pVirtualProtect := GetProcAddress(Module_kernel32, 'VirtualProtect');
  HM.pVirtualFree := GetProcAddress(Module_kernel32, 'VirtualFree');
  HM.pWriteProcessMemory := GetProcAddress(Module_kernel32, 'WriteProcessMemory');
  HM.pGetCurrentProcess := GetProcAddress(Module_kernel32, 'GetCurrentProcess');
  HM.pFreeLibrary := GetProcAddress(Module_kernel32, 'FreeLibrary');
  ExecuteHideSize := integer(@LockedAllModule) - Integer(@ExecuteHide);
  pExecuteHide := VirtualAlloc(nil, ExecuteHideSize, MEM_COMMIT or MEM_RESERVE, PAGE_EXECUTE_READWRITE);
  if pExecuteHide = nil then
    Exit;
  { ��ֹϵͳ����Ҫ��Dllж�ص� }
  LockedAllModule(integer(HM.pModule));
  CopyMemory(pExecuteHide, @ExecuteHide, ExecuteHideSize);
  MyExecuteHide := pExecuteHide;
  MyExecuteHide(HM);
end;

end.
