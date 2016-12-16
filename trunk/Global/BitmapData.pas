unit BitmapData;

//
// λͼ���ݴ�����Ҫ����λͼ����ͼ��ɫ
// ���ߣ�yeye55��2009��5��29��
//
// ��Ȩ 2009���� yeye55 ӵ�У���������Ȩ����
// ���ļ��еĴ�������ѳ��������κ���Ȩ����ɼ������ڸ��˺���ҵĿ�ġ�ʹ����һ�к���Ը���
//
// �����ת���˱��ļ��еĴ��룬��ע����������ʹ������ߣ�
// ������޸��˱��ļ��еĴ��룬��ע���޸�λ�ú��޸����ߡ�
//
// ���ļ�������http://www.programbbs.com/bbs/�Ϸ���
//

interface

uses
  Windows, Classes, SysUtils, Graphics;

const
  BD_COLORLESS = -1; // ��ɫ
  BD_BITCOUNT = 24; // ͼ��λ��
  BD_BYTECOUNT = BD_BITCOUNT shr 3; // ÿ����ռ���ֽ���
  BD_LINEWIDTH = 32; // ÿ�����ݶ����ȣ�λ��

type
  // �ֽ�����
  TByteAry = array [0 .. 0] of Byte;
  PByteAry = ^TByteAry;

  // ��ɫ�仯��Χ��R��G��B����ͨ���ľ��Բ�ֵ
  TBDColorRange = record
    R: Integer;
    G: Integer;
    B: Integer;
  end;

  TBDColor = Integer; // BGR��ʽ��ɫ

  // ת������
function BGR(B, G, R: Byte): TBDColor;
function RGBtoBGR(C: TColor): TBDColor;
function BGRtoRGB(C: TBDColor): TColor;
// �Ƚ���ɫ
function BDCompareColor(C1, C2: TBDColor; const Range: TBDColorRange): Boolean;

type
  TBDBitmapData = class; // λͼ����

  // ö����ͼ�ص����������Ҷ����ͼʱ�ص��������Ƿ����ö�٣�
  // Left���ҵ���ͼ����߾ࣻ
  // Top���ҵ���ͼ�Ķ��߾ࣻ
  // Bmp���ҵ���ͼ���ݣ�
  // lParam������ʱ���õĲ�����
  TBDEnumImageProc = function(Left, Top: Integer; Bmp: TBDBitmapData;
    lParam: Integer): Boolean;

  // ö����ɫ�ص����������Ҷ����ɫʱ�ص��������Ƿ����ö�٣�
  // Left���ҵ���ɫ����߾ࣻ
  // Top���ҵ���ɫ�Ķ��߾ࣻ
  // Color���ҵ�����ɫ��
  // lParam������ʱ���õĲ�����
  TBDEnumColorProc = function(Left, Top: Integer; Color: TBDColor;
    lParam: Integer): Boolean;

  // λͼ����
  TBDBitmapData = class
  private
    FName: String; // λͼ����
    FWidth: Integer; // λͼ��ȣ����أ�
    FHeight: Integer; // λͼ�߶ȣ����أ�
    FBackColor: TBDColor; // ������ɫ��BGR��ʽ��
    FLineWidth: Integer; // �����ÿ�����ݿ�ȣ��ֽڣ�
    FSpareWidth: Integer; // �����ÿ�����ݶ����ȣ��ֽڣ�
    FSize: Integer; // λͼ���ݳ���
    FBufSize: Integer; // ������ʵ�ʳ���
    FBits: PByteAry; // λͼ���ݻ�����
    function InitData(AWidth, AHeight: Integer): Boolean;
    function GetPixels(Left, Top: Integer): TBDColor;
    procedure SetPixels(Left, Top: Integer; Value: TBDColor);
  public
    Error: String;
    constructor Create(const AName: String = '');
    destructor Destroy; override;
    procedure Clear;
    function LoadFromStream(Stream: TStream;
      ABackColor: TBDColor = BD_COLORLESS): Boolean;
    function SaveToStream(Stream: TStream): Boolean;
    function LoadFromFile(const FileName: string;
      ABackColor: TBDColor = BD_COLORLESS): Boolean;
    function SaveToFile(const FileName: string): Boolean;
    function LoadFromBitmap(Bitmap: TBitmap): Boolean;
    function SaveToBitmap(Bitmap: TBitmap): Boolean;
    function CopyFormScreen(Left: Integer = -1; Top: Integer = -1;
      AWidth: Integer = -1; AHeight: Integer = -1): Boolean;
    function CopyFormCursor: Boolean;
    function Compare(Bmp: TBDBitmapData; Left: Integer = 0; Top: Integer = 0)
      : Boolean; overload;
    function Compare(Bmp: TBDBitmapData; const Range: TBDColorRange;
      Left: Integer = 0; Top: Integer = 0): Boolean; overload;
    //function FindImage(Bmp: TBDBitmapData; var Left, Top: Integer): TPoint; overload;
    function FindImage(Bmp: TBDBitmapData; var Left, Top: Integer): Boolean; overload;
    function FindImage(Bmp: TBDBitmapData; const Range: TBDColorRange;
      var Left, Top: Integer): Boolean; overload;
    function FindCenterImage(Bmp: TBDBitmapData; var Left, Top: Integer)
      : Boolean; overload;
    function FindCenterImage(Bmp: TBDBitmapData; const Range: TBDColorRange;
      var Left, Top: Integer): Boolean; overload;
    function EnumImage(Bmp: TBDBitmapData; EnumImageProc: TBDEnumImageProc;
      lParam: Integer = 0): Boolean; overload;
    function EnumImage(Bmp: TBDBitmapData; const Range: TBDColorRange;
      EnumImageProc: TBDEnumImageProc; lParam: Integer = 0): Boolean; overload;
    function FindColor(Color: TBDColor; var Left, Top: Integer)
      : Boolean; overload;
    function FindColor(Color: TBDColor; const Range: TBDColorRange;
      var Left, Top: Integer): Boolean; overload;
    function FindCenterColor(Color: TBDColor; var Left, Top: Integer)
      : Boolean; overload;
    function FindCenterColor(Color: TBDColor; const Range: TBDColorRange;
      var Left, Top: Integer): Boolean; overload;
    function EnumColor(Color: TBDColor; EnumColorProc: TBDEnumColorProc;
      lParam: Integer = 0): Boolean; overload;
    function EnumColor(Color: TBDColor; const Range: TBDColorRange;
      EnumColorProc: TBDEnumColorProc; lParam: Integer = 0): Boolean; overload;
    property Name: String read FName write FName; // λͼ����
    property Width: Integer read FWidth; // λͼ��ȣ����أ�
    property Height: Integer read FHeight; // λͼ�߶ȣ����أ�
    property BackColor: TBDColor read FBackColor write FBackColor;
    // ������ɫ��BGR��ʽ��
    property LineWidth: Integer read FLineWidth; // �����ÿ�����ݿ�ȣ��ֽڣ�
    property SpareWidth: Integer read FSpareWidth; // �����ÿ�����ݶ����ȣ��ֽڣ�
    property Size: Integer read FSize; // λͼ���ݳ���
    property Bits: PByteAry read FBits; // λͼ���ݻ�����
    property Pixels[Left, Top: Integer]: TBDColor read GetPixels
      write SetPixels; default;
  end;

implementation

type
  // �����������
  TAspect = (asLeft, asRight, asUp, asDown);

const
  // �ƶ��������ھ������
  MoveVal: array [asLeft .. asDown] of TPoint = ((X: - 1; Y: 0), // asLeft
    (X: 1; Y: 0), // asRight
    (X: 0; Y: - 1), // asUp
    (X: 0; Y: 1) // asDown
    );

var
  ScreenWidth: Integer;
  ScreenHeight: Integer;
  IconWidth: Integer;
  IconHeight: Integer;

  // ����B��G��R����ͨ����ֵ����һ��BGR��ʽ��ɫ��
function BGR(B, G, R: Byte): TBDColor;
begin
  result := (B or (G shl 8) or (R shl 16));
end;

// RGB��ɫ��ʽת����BGR��ɫ��ʽ��
function RGBtoBGR(C: TColor): TBDColor;
begin
  result := ((C and $FF0000) shr 16) or (C and $00FF00) or
    ((C and $0000FF) shl 16);
end;

// BGR��ɫ��ʽת����RGB��ɫ��ʽ��
function BGRtoRGB(C: TBDColor): TColor;
begin
  result := ((C and $FF0000) shr 16) or (C and $00FF00) or
    ((C and $0000FF) shl 16);
end;

// ������ɫ��ΧRange�Ƚ���ɫC1��C2������C1��C2�Ƿ����ƣ�
// C1,C2��BGR��ʽ��ɫ��
// Range��Ϊ��ɫ�仯��Χ��
function BDCompareColor(C1, C2: TBDColor; const Range: TBDColorRange): Boolean;
var
  C: Integer;
begin
  result := false;
  // B
  C := (C1 and $FF) - (C2 and $FF);
  if (C > Range.B) or (C < -Range.B) then
    exit;
  // G
  C := ((C1 and $FF00) shr 8) - ((C2 and $FF00) shr 8);
  if (C > Range.G) or (C < -Range.G) then
    exit;
  // R
  C := ((C1 and $FF0000) shr 16) - ((C2 and $FF0000) shr 16);
  if (C > Range.R) or (C < -Range.R) then
    exit;
  //
  result := true;
end;

{ TBDBitmapData } // λͼ����

constructor TBDBitmapData.Create(const AName: String);
begin
  self.FName := AName;
  self.FWidth := 0;
  self.FHeight := 0;
  self.FBackColor := BD_COLORLESS;
  self.FLineWidth := 0;
  self.FSize := 0;
  self.FBufSize := 0;
  self.FBits := nil;
  self.Error := '';
end;

destructor TBDBitmapData.Destroy;
begin
  self.Clear;
end;

// ���ݵ�ǰ��AWidth��AHeight��ʼ�����ݣ������ڴ棬�����Ƿ�ɹ���
// ���ʧ�ܽ�����self.Error˵�������
// AWidth��λͼ�Ŀ�ȣ�
// AHeight��λͼ�ĸ߶ȡ�
function TBDBitmapData.InitData(AWidth, AHeight: Integer): Boolean;
var
  Align: Integer;
begin
  self.Error := '';
  result := true;
  if (self.FWidth = AWidth) and (self.FHeight = AHeight) then
    exit;
  // ���������ÿ�����ݿ��
  self.FWidth := AWidth;
  self.FHeight := AHeight;
  Align := BD_LINEWIDTH - 1;
  self.FLineWidth := (((self.FWidth * BD_BITCOUNT) + Align) and
    ($7FFFFFFF - Align)) shr 3;
  self.FSpareWidth := self.FLineWidth - (self.FWidth * BD_BYTECOUNT);
  self.FSize := self.FLineWidth * self.FHeight;
  // �����ڴ�
  if self.FSize <= self.FBufSize then
    exit;
  if self.FBits <> nil then
    FreeMem(self.FBits);
  try
    GetMem(self.FBits, self.FSize);
  except
    on EOutOfMemory do
    begin
      self.FSize := 0;
      self.FBufSize := 0;
      self.FBits := nil;
      self.Error := '�ڴ治�㣡';
      result := false;
      exit;
    end;
  end;
  self.FBufSize := self.FSize;
end;

// ��ȡָ��λ�����ص���ɫֵ��
// Left�����ص���߾ࣻ
// Top�����صĶ��߾ࡣ
function TBDBitmapData.GetPixels(Left, Top: Integer): TBDColor;
begin
  if (Left < 0) or (Left >= self.FWidth) or (Top < 0) or (Top >= self.FHeight)
  then
  begin
    result := 0;
    exit;
  end;
  result := ((PInteger(@(self.FBits[((self.FHeight - Top - 1) * self.FLineWidth)
    + (Left * BD_BYTECOUNT)])))^ and $FFFFFF);
end;

// ����ָ��λ�����ص���ɫֵ��
// Left�����ص���߾ࣻ
// Top�����صĶ��߾ࣻ
// Value��BGR��ʽ��ɫ��
procedure TBDBitmapData.SetPixels(Left, Top: Integer; Value: TBDColor);
var
  Off: Integer;
begin
  if (Left < 0) or (Left >= self.FWidth) or (Top < 0) or (Top >= self.FHeight)
  then
    exit;
  Off := ((self.FHeight - Top - 1) * self.FLineWidth) + (Left * BD_BYTECOUNT);
  // B
  self.FBits[Off] := Byte(Value and $FF);
  // G
  self.FBits[Off + 1] := Byte((Value and $FF00) shr 8);
  // R
  self.FBits[Off + 2] := Byte((Value and $FF0000) shr 16);
end;

// �����ǰ��λͼ���ݡ�
procedure TBDBitmapData.Clear;
begin
  self.FWidth := 0;
  self.FHeight := 0;
  self.FBackColor := BD_COLORLESS;
  self.FLineWidth := 0;
  self.FSize := 0;
  self.FBufSize := 0;
  if self.FBits <> nil then
  begin
    FreeMem(self.FBits);
    self.FBits := nil;
  end;
  self.Error := '';
end;

// ���������е���λͼ���ݣ������Ƿ�ɹ���
// ���ʧ�ܽ�����self.Error˵�������
// �������е����ݱ�����24λBMP��ʽ�ļ����ݣ�
// Stream����������
// ABackColor��λͼ�ı�����ɫ����ʡ�ԡ�
function TBDBitmapData.LoadFromStream(Stream: TStream;
  ABackColor: TBDColor): Boolean;
var
  FileHeader: TBitmapFileHeader;
  InfoHeader: TBitmapInfoHeader;
begin
  if Stream = nil then
  begin
    self.Error := 'û��ָ����������';
    result := false;
    exit;
  end;
  // ��ȡ�ļ�ͷ
  Stream.Read(FileHeader, SizeOf(TBitmapFileHeader));
  Stream.Read(InfoHeader, SizeOf(TBitmapInfoHeader));
  with FileHeader, InfoHeader do
  begin
    // ȷ��λͼ��ʽ
    if (bfType <> $4D42) or (biSize <> SizeOf(TBitmapInfoHeader)) or
      (biBitCount <> BD_BITCOUNT) or (biCompression <> BI_RGB) then
    begin
      self.Error := '��������ݸ�ʽ��';
      result := false;
      exit;
    end;
    // ���ݳ�ʼ��
    self.FBackColor := ABackColor;
    if not self.InitData(biWidth, biHeight) then
    begin
      result := false;
      exit;
    end;
  end;
  // ��������
  result := Stream.Read((self.FBits)^, self.FSize) = self.FSize;
  if result then
    self.Error := ''
  else
    self.Error := '��ȡ�����ݲ�������';
end;

// ����ǰ��λͼ���ݵ������������У������Ƿ�ɹ���
// ���ʧ�ܽ�����self.Error˵�������
// ���ݰ�24λBMP�ļ����ݸ�ʽ�������������У�
// Stream����������
function TBDBitmapData.SaveToStream(Stream: TStream): Boolean;
var
  FileHeader: TBitmapFileHeader;
  InfoHeader: TBitmapInfoHeader;
  HeaderLen, n: Integer;
begin
  if Stream = nil then
  begin
    self.Error := 'û��ָ����������';
    result := false;
    exit;
  end;
  // ��ʼ���ļ�ͷ
  HeaderLen := SizeOf(TBitmapFileHeader) + SizeOf(TBitmapInfoHeader);
  with FileHeader, InfoHeader do
  begin
    bfType := $4D42;
    bfSize := self.FSize + HeaderLen;
    bfReserved1 := 0;
    bfReserved2 := 0;
    bfOffBits := HeaderLen;
    biSize := SizeOf(TBitmapInfoHeader);
    biWidth := self.FWidth;
    biHeight := self.FHeight;
    biPlanes := 1;
    biBitCount := BD_BITCOUNT;
    biCompression := BI_RGB;
    biSizeImage := self.FSize;
    biXPelsPerMeter := $EC4;
    biYPelsPerMeter := $EC4;
    biClrUsed := 0;
    biClrImportant := 0;
  end;
  // д������
  n := 0;
  n := n + Stream.Write(FileHeader, SizeOf(TBitmapFileHeader));
  n := n + Stream.Write(InfoHeader, SizeOf(TBitmapInfoHeader));
  n := n + Stream.Write((self.FBits)^, self.FSize);
  result := n = (self.FSize + HeaderLen);
  if result then
    self.Error := ''
  else
    self.Error := 'д������ݲ�������';
end;

// ���ļ��е���λͼ���ݣ������Ƿ�ɹ���
// ���ʧ�ܽ�����self.Error˵�������
// �ļ�������24λBMP��ʽ�ļ���
// FileName��BMP�ļ�����
// ABackColor��λͼ�ı�����ɫ����ʡ�ԡ�
function TBDBitmapData.LoadFromFile(const FileName: string;
  ABackColor: TBDColor): Boolean;
var
  Stream: TFileStream;
begin
  Stream := TFileStream.Create(FileName, fmOpenRead);
  result := self.LoadFromStream(Stream, ABackColor);
  Stream.Free;
end;

// ����ǰ��λͼ���ݵ������ļ��У������Ƿ�ɹ���
// ���ʧ�ܽ�����self.Error˵�������
// ���ݰ�24λBMP�ļ����ݸ�ʽ�������ļ��У�
// FileName��BMP�ļ�����
function TBDBitmapData.SaveToFile(const FileName: string): Boolean;
var
  Stream: TFileStream;
begin
  Stream := TFileStream.Create(FileName, fmCreate);
  result := self.SaveToStream(Stream);
  Stream.Free;
end;

// ��һ��TBitmap�����е������ݣ������Ƿ�ɹ���λͼ�ı�����ɫ��
// TBitmap.Transparent��TBitmap.TransparentColor������
// ���ʧ�ܽ�����self.Error˵�������
// Bitmap��TBitmap����
function TBDBitmapData.LoadFromBitmap(Bitmap: TBitmap): Boolean;
var
  Stream: TMemoryStream;
  ABackColor: TBDColor;
begin
  if Bitmap = nil then
  begin
    self.Error := 'û��ָ��λͼ��';
    result := false;
    exit;
  end;
  if Bitmap.Transparent then
    ABackColor := RGBtoBGR(Bitmap.TransparentColor)
  else
    ABackColor := BD_COLORLESS;
  Stream := TMemoryStream.Create;
  Bitmap.SaveToStream(Stream);
  Stream.Position := 0;
  result := self.LoadFromStream(Stream, ABackColor);
  Stream.Free;
end;

// ����ǰ��λͼ���ݵ�����һ��TBitmap�����У������Ƿ�ɹ������ݵ�ǰ
// �ı�����ɫ����TBitmap.Transparent��TBitmap.TransparentColor��Ա��
// ���ʧ�ܽ�����self.Error˵�������
// Bitmap��TBitmap����
function TBDBitmapData.SaveToBitmap(Bitmap: TBitmap): Boolean;
var
  Stream: TMemoryStream;
begin
  if Bitmap = nil then
  begin
    self.Error := 'û��ָ��λͼ��';
    result := false;
    exit;
  end;
  Stream := TMemoryStream.Create;
  result := self.SaveToStream(Stream);
  if not result then
  begin
    Stream.Free;
    exit;
  end;
  Stream.Position := 0;
  Bitmap.LoadFromStream(Stream);
  if self.FBackColor <> BD_COLORLESS then
  begin
    Bitmap.TransparentColor := BGRtoRGB(self.FBackColor);
    Bitmap.Transparent := true;
  end
  else
    Bitmap.Transparent := false;
  Stream.Free;
end;

// ����Ļ�ϵ�ָ����Χ�н�ͼ�����������ݣ������Ƿ�ɹ���
// ���ʧ�ܽ�����self.Error˵�������
// Left����ͼ����߾࣬��ʡ�ԣ�
// Top����ͼ�Ķ��߾࣬��ʡ�ԣ�
// AWidth����ͼ�Ŀ�ȣ���ʡ�ԣ�
// AHeight����ͼ�ĸ߶ȣ���ʡ�ԡ�
function TBDBitmapData.CopyFormScreen(Left, Top, AWidth,
  AHeight: Integer): Boolean;
var
  Wnd: HWND;
  DC, MemDC: HDC;
  Bitmap, OldBitmap: HBITMAP;
  BitInfo: TBitmapInfo;
begin
  // ��������
  if (Left < 0) or (Left >= ScreenWidth) then
    Left := 0;
  if (Top < 0) or (Top >= ScreenHeight) then
    Top := 0;
  if AWidth <= 0 then
    AWidth := ScreenWidth - Left;
  if AHeight <= 0 then
    AHeight := ScreenHeight - Top;
  // ���ݳ�ʼ��
  self.FBackColor := BD_COLORLESS;
  if not self.InitData(AWidth, AHeight) then
  begin
    result := false;
    exit;
  end;
  // ��ͼ
  Wnd := GetDesktopWindow();
  DC := GetWindowDC(Wnd);
  MemDC := CreateCompatibleDC(DC);
  Bitmap := CreateCompatibleBitmap(DC, self.FWidth, self.FHeight);
  OldBitmap := SelectObject(MemDC, Bitmap);
  result := BitBlt(MemDC, 0, 0, self.FWidth, self.FHeight, DC, Left,
    Top, SRCCOPY);
  Bitmap := SelectObject(MemDC, OldBitmap);
  if not result then
  begin
    DeleteDC(MemDC);
    DeleteObject(Bitmap);
    ReleaseDC(Wnd, DC);
    self.Error := '��ͼʧ�ܣ�';
    exit;
  end;
  // λͼ��Ϣ��ʼ��
  with BitInfo.bmiHeader do
  begin
    biSize := SizeOf(TBitmapInfoHeader);
    biWidth := self.FWidth;
    biHeight := self.FHeight;
    biPlanes := 1;
    biBitCount := BD_BITCOUNT;
    biCompression := BI_RGB;
    biSizeImage := 0;
    biXPelsPerMeter := 0;
    biYPelsPerMeter := 0;
    biClrUsed := 0;
    biClrImportant := 0;
  end;
  // ��ȡ����
  result := GetDIBits(DC, Bitmap, 0, self.FHeight, Pointer(self.FBits), BitInfo,
    DIB_RGB_COLORS) <> 0;
  if result then
    self.Error := ''
  else
    self.Error := '��ȡ����ʧ�ܣ�';
  DeleteDC(MemDC);
  DeleteObject(Bitmap);
  ReleaseDC(Wnd, DC);
end;

// ��ȡ���ָ���λͼ�����������ݣ������Ƿ�ɹ���
// ���ʧ�ܽ�����self.Error˵�������
// ������ָ���Ƕ���ָ�룬Ĭ�Ͻ�ȡ��һ֡���档
function TBDBitmapData.CopyFormCursor: Boolean;
var
  Wnd: HWND;
  DC, MemDC: HDC;
  Bitmap, OldBitmap: HBITMAP;
  CurInfo: TCursorInfo;
  BitInfo: TBitmapInfo;
begin
  // ���ݳ�ʼ��
  self.FBackColor := BD_COLORLESS;
  self.InitData(IconWidth, IconHeight);
  // ��ȡ���ָ����Ϣ
  FillChar(CurInfo, SizeOf(TCursorInfo), 0);
  CurInfo.cbSize := SizeOf(TCursorInfo);
  if not GetCursorInfo(CurInfo) then
  begin
    self.Error := '��ȡ���ָ����Ϣʧ�ܣ�';
    result := false;
    exit;
  end;
  // ��ȡ���ָ��λͼ
  Wnd := GetDesktopWindow();
  DC := GetWindowDC(Wnd);
  MemDC := CreateCompatibleDC(DC);
  Bitmap := CreateCompatibleBitmap(DC, self.FWidth, self.FHeight);
  OldBitmap := SelectObject(MemDC, Bitmap);
  result := DrawIconEx(MemDC, 0, 0, CurInfo.hCursor, 0, 0, 0, 0, DI_IMAGE);
  Bitmap := SelectObject(MemDC, OldBitmap);
  if not result then
  begin
    DeleteDC(MemDC);
    DeleteObject(Bitmap);
    ReleaseDC(Wnd, DC);
    self.Error := '��ȡ���ָ��λͼʧ�ܣ�';
    exit;
  end;
  // λͼ��Ϣ��ʼ��
  with BitInfo.bmiHeader do
  begin
    biSize := SizeOf(TBitmapInfoHeader);
    biWidth := self.FWidth;
    biHeight := self.FHeight;
    biPlanes := 1;
    biBitCount := BD_BITCOUNT;
    biCompression := BI_RGB;
    biSizeImage := 0;
    biXPelsPerMeter := 0;
    biYPelsPerMeter := 0;
    biClrUsed := 0;
    biClrImportant := 0;
  end;
  // ��ȡ����
  result := GetDIBits(DC, Bitmap, 0, self.FHeight, Pointer(self.FBits), BitInfo,
    DIB_RGB_COLORS) <> 0;
  if result then
    self.Error := ''
  else
    self.Error := '��ȡ����ʧ�ܣ�';
  DeleteDC(MemDC);
  DeleteObject(Bitmap);
  ReleaseDC(Wnd, DC);
end;

// �ڵ�ǰλͼ��ָ��λ�ñȽ�Bmpλͼ�������Ƿ�һ�£�
// �����Ƿ�һ�¶������޸�self.Error��
// Bmpλͼ���ҪС�ڵ��ڵ�ǰλͼ�������Bmpλͼ���ܳ�����ǰλͼ��
// Bmp��λͼ���ݣ�
// Left���Ƚ�ʱ����߾࣬��ʡ�ԣ�
// Top���Ƚ�ʱ�Ķ��߾࣬��ʡ�ԡ�
function TBDBitmapData.Compare(Bmp: TBDBitmapData; Left, Top: Integer): Boolean;
var
  X, Y, Off1, Off2: Integer;
  C1, C2: TBDColor;
begin
  if ((Left + Bmp.FWidth) > self.FWidth) or ((Top + Bmp.FHeight) > self.FHeight)
  then
  begin
    result := false;
    exit;
  end;
  Off1 := ((self.FHeight - Bmp.FHeight - Top) * self.FLineWidth) +
    (Left * BD_BYTECOUNT);
  Off2 := 0;
  result := true;
  for Y := 0 to Bmp.FHeight - 1 do
  begin
    for X := 0 to Bmp.FWidth - 1 do
    begin
      C1 := ((PInteger(@(self.FBits[Off1])))^ and $FFFFFF);
      C2 := ((PInteger(@(Bmp.FBits[Off2])))^ and $FFFFFF);
      if (C1 <> self.FBackColor) and (C2 <> Bmp.FBackColor) and (C1 <> C2) then
      begin
        result := false;
        break;
      end;
      Off1 := Off1 + 3;
      Off2 := Off2 + 3;
    end;
    if not result then
      break;
    Off1 := Off1 + (self.FLineWidth - Bmp.FLineWidth) + Bmp.FSpareWidth;
    Off2 := Off2 + Bmp.FSpareWidth;
  end;
end;

// �ڵ�ǰλͼ��ָ��λ��ģ���Ƚ�Bmpλͼ�������Ƿ�һ�£�
// �����Ƿ�һ�¶������޸�self.Error��
// Bmpλͼ���ҪС�ڵ��ڵ�ǰλͼ�������Bmpλͼ���ܳ�����ǰλͼ��
// Bmp��λͼ���ݣ�
// Range��Ϊ��ɫ�仯��Χ
// Left���Ƚ�ʱ����߾࣬��ʡ�ԣ�
// Top���Ƚ�ʱ�Ķ��߾࣬��ʡ�ԡ�
function TBDBitmapData.Compare(Bmp: TBDBitmapData; const Range: TBDColorRange;
  Left, Top: Integer): Boolean;
var
  X, Y, Off1, Off2: Integer;
  C1, C2: TBDColor;
begin
  if ((Left + Bmp.FWidth) > self.FWidth) or ((Top + Bmp.FHeight) > self.FHeight)
  then
  begin
    result := false;
    exit;
  end;
  Off1 := ((self.FHeight - Bmp.FHeight - Top) * self.FLineWidth) +
    (Left * BD_BYTECOUNT);
  Off2 := 0;
  result := true;
  for Y := 0 to Bmp.FHeight - 1 do
  begin
    for X := 0 to Bmp.FWidth - 1 do
    begin
      C1 := ((PInteger(@(self.FBits[Off1])))^ and $FFFFFF);
      C2 := ((PInteger(@(Bmp.FBits[Off2])))^ and $FFFFFF);
      if (C1 <> self.FBackColor) and (C2 <> Bmp.FBackColor) and
        (not BDCompareColor(C1, C2, Range)) then
      begin
        result := false;
        break;
      end;
      Off1 := Off1 + 3;
      Off2 := Off2 + 3;
    end;
    if not result then
      break;
    Off1 := Off1 + (self.FLineWidth - Bmp.FLineWidth) + Bmp.FSpareWidth;
    Off2 := Off2 + Bmp.FSpareWidth;
  end;
end;

// �ӵ�ǰλͼ�в�����Bmpһ�µ���ͼ�������Ƿ��ҵ���
// �����Ƿ��ҵ��������޸�self.Error��
// �������ң����ϵ��µ�˳����ң�
// �ҵ�����true������Left��TopΪ�ҵ���ͼ��λ�ã�
// û�ҵ�����false������Left��TopΪ-1��
// Bmp����ͼ���ݣ�
// Left���ҵ���ͼ����߾ࣻ
// Top���ҵ���ͼ�Ķ��߾ࡣ
function TBDBitmapData.FindImage(Bmp: TBDBitmapData;
  var Left, Top: Integer): Boolean;
var
  X, Y: Integer;
begin
  result := false;
  X := 0;
  for Y := 0 to self.FHeight - Bmp.FHeight - 1 do
  begin
    for X := 0 to self.FWidth - Bmp.FWidth - 1 do
    begin
      if self.Compare(Bmp, X, Y) then
      begin
        result := true;
        break;
      end;
    end;
    if result then
      break;
  end;
  if result then
  begin
    Left := X;
    Top := Y;
  end
  else
  begin
    Left := -1;
    Top := -1;
  end;
end;

// �ӵ�ǰλͼ��ģ��������Bmpһ�µ���ͼ�������Ƿ��ҵ���
// �����Ƿ��ҵ��������޸�self.Error��
// �������ң����ϵ��µ�˳����ң�
// �ҵ�����true������Left��TopΪ�ҵ���λ�ã�
// û�ҵ�����false������Left��TopΪ-1��
// Bmp����ͼ���ݣ�
// Range��Ϊ��ɫ�仯��Χ��
// Left���ҵ���ͼ����߾ࣻ
// Top���ҵ���ͼ�Ķ��߾ࡣ
function TBDBitmapData.FindImage(Bmp: TBDBitmapData; const Range: TBDColorRange;
  var Left, Top: Integer): Boolean;
var
  X, Y: Integer;
begin
  result := false;
  X := 0;
  for Y := 0 to self.FHeight - Bmp.FHeight - 1 do
  begin
    for X := 0 to self.FWidth - Bmp.FWidth - 1 do
    begin
      if self.Compare(Bmp, Range, X, Y) then
      begin
        result := true;
        break;
      end;
    end;
    if result then
      break;
  end;
  if result then
  begin
    Left := X;
    Top := Y;
  end
  else
  begin
    Left := -1;
    Top := -1;
  end;
end;

// �ӵ�ǰλͼ�в�����Bmpһ�µ���ͼ�������Ƿ��ҵ���
// �����Ƿ��ҵ��������޸�self.Error��
// �ԣ�Left��Top��Ϊ���㣬�����������ܲ��ң�
// �ҵ�����true������Left��TopΪ�ҵ���ͼ��λ�ã�
// û�ҵ�����false������Left��TopΪ-1��
// Bmp����ͼ���ݣ�
// Left���ҵ���ͼ����߾ࣻ
// Top���ҵ���ͼ�Ķ��߾ࡣ
function TBDBitmapData.FindCenterImage(Bmp: TBDBitmapData;
  var Left, Top: Integer): Boolean;
var
  Aspect: TAspect;
  VisitCount, Count, i: Integer;
begin
  result := false;
  VisitCount := 0;
  Aspect := asUp;
  Count := 1;
  while VisitCount < (self.FWidth * self.FHeight) do
  begin
    for i := 0 to Count - 1 do
    begin
      if (Left >= 0) and (Left < self.FWidth) and (Top >= 0) and
        (Top < self.FHeight) then
      begin
        if self.Compare(Bmp, Left, Top) then
        begin
          result := true;
          break;
        end;
        VisitCount := VisitCount + 1;
      end;
      Left := Left + MoveVal[Aspect].X;
      Top := Top + MoveVal[Aspect].Y;
    end;
    if result then
      break;
    case Aspect of
      asLeft:
        begin
          Aspect := asUp;
          Count := Count + 1;
        end;
      asRight:
        begin
          Aspect := asDown;
          Count := Count + 1;
        end;
      asUp:
        begin
          Aspect := asRight;
        end;
      asDown:
        begin
          Aspect := asLeft;
        end;
    end;
  end;
  if not result then
  begin
    Left := -1;
    Top := -1;
  end;
end;

// �ӵ�ǰλͼ��ģ��������Bmpһ�µ���ͼ�������Ƿ��ҵ���
// �����Ƿ��ҵ��������޸�self.Error��
// �ԣ�Left��Top��Ϊ���㣬�����������ܲ��ң�
// �ҵ�����true������Left��TopΪ�ҵ���ͼ��λ�ã�
// û�ҵ�����false������Left��TopΪ-1��
// Bmp����ͼ���ݣ�
// Range��Ϊ��ɫ�仯��Χ��
// Left���ҵ���ͼ����߾ࣻ
// Top���ҵ���ͼ�Ķ��߾ࡣ
function TBDBitmapData.FindCenterImage(Bmp: TBDBitmapData;
  const Range: TBDColorRange; var Left, Top: Integer): Boolean;
var
  Aspect: TAspect;
  VisitCount, Count, i: Integer;
begin
  result := false;
  VisitCount := 0;
  Aspect := asUp;
  Count := 1;
  while VisitCount < (self.FWidth * self.FHeight) do
  begin
    for i := 0 to Count - 1 do
    begin
      if (Left >= 0) and (Left < self.FWidth) and (Top >= 0) and
        (Top < self.FHeight) then
      begin
        if self.Compare(Bmp, Range, Left, Top) then
        begin
          result := true;
          break;
        end;
        VisitCount := VisitCount + 1;
      end;
      Left := Left + MoveVal[Aspect].X;
      Top := Top + MoveVal[Aspect].Y;
    end;
    if result then
      break;
    case Aspect of
      asLeft:
        begin
          Aspect := asUp;
          Count := Count + 1;
        end;
      asRight:
        begin
          Aspect := asDown;
          Count := Count + 1;
        end;
      asUp:
        begin
          Aspect := asRight;
        end;
      asDown:
        begin
          Aspect := asLeft;
        end;
    end;
  end;
  if not result then
  begin
    Left := -1;
    Top := -1;
  end;
end;

// �ӵ�ǰλͼ�в���������Bmpһ�µ���ͼ�������Ƿ��ҵ���
// �����Ƿ��ҵ��������޸�self.Error��
// �������ң����ϵ��µ�˳����ң�
// ÿ�ҵ�һ����ͼ���͵��ûص�����EnumImageProc�����EnumImageProc
// ����false��ֹͣ���ң�����������
// Bmp����ͼ���ݣ�
// EnumImageProc���ص�������
// lParam�����ûص�����ʱ�����Ĳ�������ʡ�ԡ�
function TBDBitmapData.EnumImage(Bmp: TBDBitmapData;
  EnumImageProc: TBDEnumImageProc; lParam: Integer): Boolean;
var
  X, Y: Integer;
  Res: Boolean;
begin
  result := false;
  Res := true;
  for Y := 0 to self.FHeight - Bmp.FHeight - 1 do
  begin
    for X := 0 to self.FWidth - Bmp.FWidth - 1 do
    begin
      if self.Compare(Bmp, X, Y) then
      begin
        result := true;
        Res := EnumImageProc(X, Y, Bmp, lParam);
        if not Res then
          break;
      end;
    end;
    if not Res then
      break;
  end;
end;

// �ӵ�ǰλͼ��ģ������������Bmpһ�µ���ͼ�������Ƿ��ҵ���
// �����Ƿ��ҵ��������޸�self.Error��
// �������ң����ϵ��µ�˳����ң�
// ÿ�ҵ�һ����ͼ���͵��ûص�����EnumImageProc�����EnumImageProc
// ����false��ֹͣ���ң�����������
// Bmp����ͼ���ݣ�
// Range��Ϊ��ɫ�仯��Χ��
// EnumImageProc���ص�������
// lParam�����ûص�����ʱ�����Ĳ�������ʡ�ԡ�
function TBDBitmapData.EnumImage(Bmp: TBDBitmapData; const Range: TBDColorRange;
  EnumImageProc: TBDEnumImageProc; lParam: Integer): Boolean;
var
  X, Y: Integer;
  Res: Boolean;
begin
  result := false;
  Res := true;
  for Y := 0 to self.FHeight - Bmp.FHeight - 1 do
  begin
    for X := 0 to self.FWidth - Bmp.FWidth - 1 do
    begin
      if self.Compare(Bmp, Range, X, Y) then
      begin
        result := true;
        Res := EnumImageProc(X, Y, Bmp, lParam);
        if not Res then
          break;
      end;
    end;
    if not Res then
      break;
  end;
end;

// �ӵ�ǰλͼ�в���ָ������ɫ������self.FBackColor���ã������Ƿ��ҵ���
// �����Ƿ��ҵ��������޸�self.Error��
// �������ң����ϵ��µ�˳����ң�
// �ҵ�����true������Left��TopΪ�ҵ���ɫ��λ�ã�
// û�ҵ�����false������Left��TopΪ-1��
// Color��BGR��ʽ��ɫ��
// Left���ҵ���ɫ����߾ࣻ
// Top���ҵ���ɫ�Ķ��߾ࡣ
function TBDBitmapData.FindColor(Color: TBDColor;
  var Left, Top: Integer): Boolean;
var
  X, Y, LineOff, Off: Integer;
begin
  result := false;
  LineOff := self.FSize;
  X := 0;
  for Y := 0 to self.FHeight - 1 do
  begin
    LineOff := LineOff - self.FLineWidth;
    Off := LineOff;
    for X := 0 to self.FWidth - 1 do
    begin
      result := ((PInteger(@(self.FBits[Off])))^ and $FFFFFF) = Color;
      if result then
        break;
      Off := Off + 3;
    end;
    if result then
      break;
  end;
  if result then
  begin
    Left := X;
    Top := Y;
  end
  else
  begin
    Left := -1;
    Top := -1;
  end;
end;

// �ӵ�ǰλͼ��ģ������ָ������ɫ������self.FBackColor���ã������Ƿ��ҵ���
// �����Ƿ��ҵ��������޸�self.Error��
// �������ң����ϵ��µ�˳����ң�
// �ҵ�����true������Left��TopΪ�ҵ���ɫ��λ�ã�
// û�ҵ�����false������Left��TopΪ-1��
// Color��BGR��ʽ��ɫ��
// Range��Ϊ��ɫ�仯��Χ��
// Left���ҵ���ɫ����߾ࣻ
// Top���ҵ���ɫ�Ķ��߾ࡣ
function TBDBitmapData.FindColor(Color: TBDColor; const Range: TBDColorRange;
  var Left, Top: Integer): Boolean;
var
  X, Y, LineOff, Off: Integer;
begin
  result := false;
  LineOff := self.FSize;
  X := 0;
  for Y := 0 to self.FHeight - 1 do
  begin
    LineOff := LineOff - self.FLineWidth;
    Off := LineOff;
    for X := 0 to self.FWidth - 1 do
    begin
      result := BDCompareColor(((PInteger(@(self.FBits[Off])))^ and $FFFFFF),
        Color, Range);
      if result then
        break;
      Off := Off + 3;
    end;
    if result then
      break;
  end;
  if result then
  begin
    Left := X;
    Top := Y;
  end
  else
  begin
    Left := -1;
    Top := -1;
  end;
end;

// �ӵ�ǰλͼ�в���ָ������ɫ������self.FBackColor���ã������Ƿ��ҵ���
// �����Ƿ��ҵ��������޸�self.Error��
// �ԣ�Left��Top��Ϊ���㣬�����������ܲ��ң�
// �ҵ�����true������Left��TopΪ�ҵ���ɫ��λ�ã�
// û�ҵ�����false������Left��TopΪ-1��
// Color��BGR��ʽ��ɫ��
// Left���ҵ���ɫ����߾ࣻ
// Top���ҵ���ɫ�Ķ��߾ࡣ
function TBDBitmapData.FindCenterColor(Color: TBDColor;
  var Left, Top: Integer): Boolean;
var
  Aspect: TAspect;
  VisitCount, Count, i: Integer;
begin
  result := false;
  VisitCount := 0;
  Aspect := asUp;
  Count := 1;
  while VisitCount < (self.FWidth * self.FHeight) do
  begin
    for i := 0 to Count - 1 do
    begin
      if (Left >= 0) and (Left < self.FWidth) and (Top >= 0) and
        (Top < self.FHeight) then
      begin
        if self.GetPixels(Left, Top) = Color then
        begin
          result := true;
          break;
        end;
        VisitCount := VisitCount + 1;
      end;
      Left := Left + MoveVal[Aspect].X;
      Top := Top + MoveVal[Aspect].Y;
    end;
    if result then
      break;
    case Aspect of
      asLeft:
        begin
          Aspect := asUp;
          Count := Count + 1;
        end;
      asRight:
        begin
          Aspect := asDown;
          Count := Count + 1;
        end;
      asUp:
        begin
          Aspect := asRight;
        end;
      asDown:
        begin
          Aspect := asLeft;
        end;
    end;
  end;
  if not result then
  begin
    Left := -1;
    Top := -1;
  end;
end;

// �ӵ�ǰλͼ��ģ������ָ������ɫ������self.FBackColor���ã������Ƿ��ҵ���
// �����Ƿ��ҵ��������޸�self.Error��
// �ԣ�Left��Top��Ϊ���㣬�����������ܲ��ң�
// �ҵ�����true������Left��TopΪ�ҵ���ɫ��λ�ã�
// û�ҵ�����false������Left��TopΪ-1��
// Color��BGR��ʽ��ɫ��
// Range��Ϊ��ɫ�仯��Χ��
// Left���ҵ���ɫ����߾ࣻ
// Top���ҵ���ɫ�Ķ��߾ࡣ
function TBDBitmapData.FindCenterColor(Color: TBDColor;
  const Range: TBDColorRange; var Left, Top: Integer): Boolean;
var
  Aspect: TAspect;
  VisitCount, Count, i: Integer;
begin
  result := false;
  VisitCount := 0;
  Aspect := asUp;
  Count := 1;
  while VisitCount < (self.FWidth * self.FHeight) do
  begin
    for i := 0 to Count - 1 do
    begin
      if (Left >= 0) and (Left < self.FWidth) and (Top >= 0) and
        (Top < self.FHeight) then
      begin
        if BDCompareColor(self.GetPixels(Left, Top), Color, Range) then
        begin
          result := true;
          break;
        end;
        VisitCount := VisitCount + 1;
      end;
      Left := Left + MoveVal[Aspect].X;
      Top := Top + MoveVal[Aspect].Y;
    end;
    if result then
      break;
    case Aspect of
      asLeft:
        begin
          Aspect := asUp;
          Count := Count + 1;
        end;
      asRight:
        begin
          Aspect := asDown;
          Count := Count + 1;
        end;
      asUp:
        begin
          Aspect := asRight;
        end;
      asDown:
        begin
          Aspect := asLeft;
        end;
    end;
  end;
  if not result then
  begin
    Left := -1;
    Top := -1;
  end;
end;

// �ӵ�ǰλͼ�в�������ָ������ɫ������self.FBackColor���ã������Ƿ��ҵ���
// �����Ƿ��ҵ��������޸�self.Error��
// �������ң����ϵ��µ�˳����ң�
// ÿ�ҵ�һ����ɫ���͵��ûص�����EnumColorProc�����EnumColorProc
// ����false��ֹͣ���ң�����������
// Color��BGR��ʽ��ɫ��
// EnumColorProc���ص�������
// lParam�����ûص�����ʱ�����Ĳ�������ʡ�ԡ�
function TBDBitmapData.EnumColor(Color: TBDColor;
  EnumColorProc: TBDEnumColorProc; lParam: Integer): Boolean;
var
  X, Y, LineOff, Off: Integer;
  Res: Boolean;
  C: TBDColor;
begin
  result := false;
  LineOff := self.FSize;
  Res := true;
  for Y := 0 to self.FHeight - 1 do
  begin
    LineOff := LineOff - self.FLineWidth;
    Off := LineOff;
    for X := 0 to self.FWidth - 1 do
    begin
      C := ((PInteger(@(self.FBits[Off])))^ and $FFFFFF);
      result := C = Color;
      if result then
      begin
        Res := EnumColorProc(X, Y, C, lParam);
        if not Res then
          break;
      end;
      Off := Off + 3;
    end;
    if not Res then
      break;
  end;
end;

// �ӵ�ǰλͼ��ģ����������ָ������ɫ������self.FBackColor���ã������Ƿ��ҵ���
// �����Ƿ��ҵ��������޸�self.Error��
// �������ң����ϵ��µ�˳����ң�
// ÿ�ҵ�һ����ɫ���͵��ûص�����EnumColorProc�����EnumColorProc
// ����false��ֹͣ���ң�����������
// Color��BGR��ʽ��ɫ��
// Range��Ϊ��ɫ�仯��Χ��
// EnumColorProc���ص�������
// lParam�����ûص�����ʱ�����Ĳ�������ʡ�ԡ�
function TBDBitmapData.EnumColor(Color: TBDColor; const Range: TBDColorRange;
  EnumColorProc: TBDEnumColorProc; lParam: Integer): Boolean;
var
  X, Y, LineOff, Off: Integer;
  Res: Boolean;
  C: TBDColor;
begin
  result := false;
  LineOff := self.FSize;
  Res := true;
  for Y := 0 to self.FHeight - 1 do
  begin
    LineOff := LineOff - self.FLineWidth;
    Off := LineOff;
    for X := 0 to self.FWidth - 1 do
    begin
      C := ((PInteger(@(self.FBits[Off])))^ and $FFFFFF);
      result := BDCompareColor(C, Color, Range);
      if result then
      begin
        Res := EnumColorProc(X, Y, C, lParam);
        if not Res then
          break;
      end;
      Off := Off + 3;
    end;
    if not Res then
      break;
  end;
end;

// ��Ԫ��ʼ��
initialization

begin
  ScreenWidth := GetSystemMetrics(SM_CXSCREEN);
  ScreenHeight := GetSystemMetrics(SM_CYSCREEN);
  IconWidth := GetSystemMetrics(SM_CXICON);
  IconHeight := GetSystemMetrics(SM_CYICON);
end;

end.
