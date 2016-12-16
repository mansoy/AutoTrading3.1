unit uJsonClass;

interface

uses
  Winapi.Windows, System.SysUtils;

type
  TStatusItem = class
  private
    FGroupName: string;
    FRowId: Integer;
    FOrderNo: string;
    FTaskType: Integer;
    FRoleId: Integer;
    FState: Integer;
    FReason: string;
    FStock: Integer;
    FIsMain: Boolean;
  public
    /// <summary>
    /// ��������ʾ
    /// </summary>
    property groupName: string read FGroupName write FGroupName;
    /// <summary>
    /// RowId, �ӵ�ID
    /// </summary>
    property rowId: Integer read FRowId write FRowId;
    /// <summary>
    /// �������
    /// </summary>
    property orderNo: string read FOrderNo write FOrderNo;
    /// <remarks>
    /// �Ƿ�����
    /// </remarks>
    property isMain: Boolean read FIsMain write FIsMain;
    /// <summary>
    /// �������
    /// </summary>
    property taskType: Integer read FTaskType write FTaskType;
    /// <summary>
    /// ��ɫID
    /// </summary>
    property roleId: Integer read FRoleId write FRoleId;
    /// <summary>
    /// ����״̬��
    /// </summary>
    property state: Integer read FState write FState;
    /// <summary>
    /// �쳣ԭ��
    /// </summary>
    property reason: string read FReason write FReason;
    /// <summary>
    /// ��ǰ��ɫ��ʵ��ʣ����
    /// </summary>
    property stock: Integer read FStock write FStock;
  end;

  TLogItem = class
  private
    FLogType: string;
    FLogLevel: string;
    FOrderNo: string;
    FDetailNo: Integer;
    FAccFlag: string;
    FIP: string;
    FContent: string;
    FGroupName: string;
  public
    /// <summary>
    /// ��������ʾ
    /// </summary>
    property groupName: string read FGroupName write FGroupName;
    /// <summary>
    /// ��־���� ���������� + 1 * 10��
    /// </summary>
    property logType: string read FLogType write FLogType;
    /// <summary>
    /// ��־�ȼ� ��ʱû�ã�Ĭ�ϸ���0
    /// </summary>
    property logLevel: string read FLogLevel write FLogLevel;
    /// <summary>
    /// �������
    /// </summary>
    property orderNo: string read FOrderNo write FOrderNo;
    /// <summary>
    /// ��ϸ��
    /// </summary>
    property detailNo: Integer read FDetailNo write FDetailNo;
    /// <summary>
    /// �˺����ͣ� �ֲ�ʱ����Ϊ10������Ϊ20
    /// </summary>
    property accFlag: string read FAccFlag write FAccFlag;
    /// <summary>
    /// ������IP
    /// </summary>
    property ip: string read FIP write FIP;
    /// <summary>
    /// ��־����
    /// </summary>
    property content: string read FContent write FContent;
  end;

  TRoleItem = class
  private
    FStock: Integer;
    FRowId: Integer;
    FEachNum: Integer;
    FRole: string;
    FIsMain: Boolean;
    FSendNum: Integer;
    FRoleId: Integer;
    FreStock: Integer;
    FTaskState: Integer;
    FPassWord: string;
    FAccount: string;
    FCheckLevel: Boolean;
    FReceiptRole: string;
    FSafetyWay: Integer;
    FReceiptLevel: Integer;
    FLogMsg: string;
  public
    /// <summary>
    /// RowId, �ӵ�ID
    /// </summary>
    property rowId: Integer read FRowId write FRowId;
    /// <summary>
    /// �Ƿ�ֲ�����
    /// </summary>
    property isMain: Boolean read FIsMain write FIsMain;
    /// <summary>
    /// ��Ϸ�˺�
    /// </summary>
    property account: string read FAccount write FAccount;
    /// <summary>
    /// �˺�����
    /// </summary>
    property passWord: string read FPassWord write FPassWord;
    /// <summary>
    /// ��ɫID
    /// </summary>
    property roleID: Integer read FRoleId write FRoleId;
    /// <summary>
    /// ��ɫ��
    /// </summary>
    property role: string read FRole write FRole;
    /// <summary>
    /// �ջ���ɫ��
    /// </summary>
    property receiptRole: string read FReceiptRole write FReceiptRole;
    /// <summary>
    /// �ջ���ɫ�ȼ�
    /// </summary>
    property receiptLevel: Integer read FReceiptLevel write FReceiptLevel;
    /// <summary>
    /// �Ƿ�У���ɫ�ȼ�
    /// </summary>
    property checkLevel: Boolean read FCheckLevel write FCheckLevel;
    /// <summary>
    /// ��ȫ��ʽ
    /// </summary>
    property safetyWay: Integer read FSafetyWay write FSafetyWay;
    /// <summary>
    /// ��ǰ��ɫ��������
    /// </summary>
    property sendNum: Integer read FSendNum write FSendNum;
    /// <summary>
    /// ��������
    /// </summary>
    property eachNum: Integer read FEachNum write FEachNum;
    /// <summary>
    /// ��ǰ��ɫ���
    /// </summary>
    property stock: Integer read FStock write FStock;
    /// <summary>
    /// ��ǰ��ɫʵ�ʿ��
    /// </summary>
    property reStock: Integer read FreStock write FreStock;
    /// <summary>
    /// �����״̬
    /// </summary>
    property taskState: Integer read FTaskState write FTaskState;
    /// <summary>
    /// ������־��Ϣ
    /// </summary>
    property logMsg: string read FLogMsg write FLogMsg;
  end;

  TOrderItem = class
  private
    FGameArea: string;
    FConsoleId: string;
    FGameSvr: string;
    FOrderNo: string;
    FTaskType: Integer;
    FSaleNum: Integer;
    FRoles: TArray<TRoleItem>;
    FisBusy: Boolean;
    Fkey: string;
  public
    /// <summary>
    /// �������
    /// </summary>
    property orderNo: string read FOrderNo write FOrderNo;
    /// <summary>
    /// �������
    /// </summary>
    property taskType: Integer read FTaskType write FTaskType;
    /// <summary>
    /// ��Ϸ����
    /// </summary>
    property gameArea: string read FGameArea write FGameArea;
    /// <summary>
    /// ��Ϸ����
    /// </summary>
    property gameSvr: string read FGameSvr write FGameSvr;
    /// <summary>
    /// Ψһֵ
    /// </summary>
    property key: string read Fkey write Fkey;
    /// <summary>
    /// ����̨���
    /// </summary>
    property consoleId: string read FConsoleId write FConsoleId;
    /// <summary>
    /// ��ǰ�˺ŵ��ܷ�����
    /// </summary>
    property saleNum: Integer read FSaleNum write FSaleNum;
    /// <summary>
    /// ��ʾ�����Ƿ��ڴ�����
    /// </summary>
    property isBusy: Boolean read FisBusy write FisBusy;
    /// <summary>
    /// ������ɫ�б�
    /// </summary>
    property roles: TArray<TRoleItem> read FRoles write FRoles;
  end;


  //---�ֲ���Ϣ-----------------------------
  TFcRoleItem = class
  private
    FStock: Integer;
    FRowId: Integer;
    FEachNum: Integer;
    FRole: string;
    FIsMain: Boolean;
    FSendNum: Integer;
    FRoleId: Integer;
    FPassWord: string;
    FAccount: string;
    FReceiptRole: string;
    FSafetyWay: Integer;
  public
    /// <summary>
    /// RowId, �ӵ�ID
    /// </summary>
    property rowId: Integer read FRowId write FRowId;
    /// <summary>
    /// ��ɫID
    /// </summary>
    property roleId: Integer read FRoleId write FRoleId;
    /// <summary>
    /// ��ɫ��
    /// </summary>
    property role: string read FRole write FRole;
    /// <summary>
    /// �ջ���ɫ��
    /// </summary>
    property receiptRole: string read FReceiptRole write FReceiptRole;
    /// <summary>
    /// ��ȫ��ʽ
    /// </summary>
    property safetyWay: Integer read FSafetyWay write FSafetyWay;
    /// <summary>
    /// ��ǰ��ɫ��������
    /// </summary>
    property sendNum: Integer read FSendNum write FSendNum;
    /// <summary>
    /// ��������
    /// </summary>
    property eachNum: Integer read FEachNum write FEachNum;
    /// <summary>
    /// ��ǰ��ɫ���
    /// </summary>
    property stock: Integer read FStock write FStock;
  end;

  TAccountItem = class
  private
    FIsMain: Boolean;
    FAccount: string;
    FPassWord: string;
    FRoles: TArray<TFcRoleItem>;
    FOrderNo: string;
    FGroupNo: string;
  public
    property isMain: Boolean read FIsMain write FIsMain default False;
    property account: string read FAccount write FAccount;
    property passWord: string read FPassWord write FPassWord;
    /// <summary>
    /// �������
    /// </summary>
    property orderNo: string read FOrderNo write FOrderNo;
    property groupNo: string read FGroupNo write FGroupNo;
    property roles: TArray<TFcRoleItem> read FRoles write FRoles;
  end;

  TFcOrderItem = class
  private
    FTaskType: Integer;
    FGameArea: string;
    FGameSvr: string;
    FConsoleId: string;
    FAccounts: TArray<TAccountItem>;
  public
    /// <remarks>
    /// ��������
    /// </remarks>
    property taskType: Integer read FTaskType write FTaskType;
    /// <remarks>
    /// ��Ϸ����
    /// </remarks>
    property gameArea: string read FGameArea write FGameArea;
    /// <remarks>
    /// ��Ϸ����
    /// </remarks>
    property gameSvr: string read FGameSvr write FGameSvr;
    /// <remarks>
    /// ����̨��ʾ
    /// </remarks>
    property consoleId: string read FConsoleId write FConsoleId;
    /// <remarks>
    /// �˺��б�
    /// </remarks>
    property accounts: TArray<TAccountItem> read FAccounts write FAccounts;
  end;


  //---����
  TConsoleSet = class
  private
    FLackMaterialPause: Boolean;
    FAutoBatch: Boolean;
    FMaxTaskNum: Integer;
    FTaskTimes: Integer;
    FStockFloating: Integer;
    FStockAdditional: Integer;
    FConsoleID: string;
    FLogInterface: string;
    FTaskInterface: string;
    FStateInterface: string;
    FImgInterface: string;
    FSetExceptionInterface: string;
    FGetOrderInterfac: string;
    FCarryInterface: string;
  public
    /// <summary>
    /// ����̨��ʾ
    /// </summary>
    property ConsoleID: string read FConsoleID write FConsoleID;
    /// <summary>
    /// tpȱ������ͣ
    /// </summary>
    property LackMaterialPause: Boolean read FLackMaterialPause write FLackMaterialPause;
    /// <summary>
    /// tp�Զ�����
    /// </summary>
    property AutoBatch: Boolean read FAutoBatch write FAutoBatch;
    /// <summary>
    /// tp�ֲָ���
    /// </summary>
    property StockAdditional: Integer read FStockAdditional write FStockAdditional;
    /// <summary>
    /// tp�ֿ⸡��
    /// </summary>
    property StockFloating: Integer read FStockFloating write FStockFloating;
    /// <summary>
    /// tp����ʧ�ܳ��Դ���
    /// </summary>
    property TaskTimes: Integer read FTaskTimes write FTaskTimes;
    /// <summary>
    /// tp��ǰ���������
    /// </summary>
    property MaxTaskNum: Integer read FMaxTaskNum write FMaxTaskNum;
    /// <summary>
    /// ����ӿڵ�ַ
    /// </summary>
    property TaskInterface: string read FTaskInterface write FTaskInterface;
    /// <summary>
    /// ����ӿڵ�ַ
    /// </summary>
    property StateInterface: string read FStateInterface write FStateInterface;
    /// <summary>
    /// ����ӿڵ�ַ
    /// </summary>
    property LogInterface: string read FLogInterface write FLogInterface;
    /// <summary>
    /// ͼƬ�ӿڵ�ַ
    /// </summary>
    property ImgInterface: string read FImgInterface write FImgInterface;
    /// <summary>
    /// Я�����ӿڵ�ַ
    /// </summary>
    property CarryInterface: string read FCarryInterface write FCarryInterface;
    /// <summary>
    /// ���쳣�ӿڵ�ַ
    /// </summary>
    property SetExceptionInterface: string read FSetExceptionInterface write FSetExceptionInterface;
    /// <summary>
    /// ���쳣�ӿڵ�ַ
    /// </summary>
    property GetOrderInterfac: string read FGetOrderInterfac write FGetOrderInterfac;
  end;

  TDBItem = class
  private
    FCatchReason: string;
    FKcNum: Integer;
    FRoleName: string;
    FSyNum: Integer;
    FOrderNo: string;
    FSaleNum: Integer;
    FAccount: string;
    FSaleState: Integer;
    FRoleId: Integer;
    FRowId: Integer;
  public
    /// <summary>
    /// �������
    /// </summary>
    property orderNo: string read FOrderNo write FOrderNo;
    /// <summary>
    /// ����ID
    /// </summary>
    property rowId: Integer read FRowId write FRowId;
    /// <summary>
    /// ��Ϸ�˺�
    /// </summary>
    property account: string read FAccount write FAccount;
    /// <summary>
    /// ��ɫ����
    /// </summary>
    property roleName: string read FRoleName write FRoleName;
    /// <summary>
    /// ��ɫID
    /// </summary>
    property roleId: Integer read FRoleId write FRoleId;
    /// <summary>
    /// ��������
    /// </summary>
    property saleNum: Integer read FSaleNum write FSaleNum;
    /// <summary>
    /// �������
    /// </summary>
    property kcNum: Integer read FKcNum write FKcNum;
    /// <summary>
    /// ʣ������
    /// </summary>
    property syNum: Integer read FSyNum write FSyNum;
    /// <summary>
    /// ����״̬
    /// </summary>
    property saleState: Integer read FSaleState write FSaleState;
    /// <summary>
    /// �쳣ԭ��
    /// </summary>
    property catchReason: string read FCatchReason write FCatchReason;
  end;

  TFcDBItem = class
  private
    FCatchReason: string;
    FOrderNo: string;
    FSaleNum: Integer;
    FSaleState: Integer;
    FRowId: Integer;
    FGroupNo: string;
    FOutAccount: string;
    FOutRoleName: string;
    FOutRoleId: Integer;
    FInAccount: string;
    FInRoleId: Integer;
    FInRoleName: string;
    FOutSyNum: Integer;
    FOutRoleKc: Integer;
    FOrderState: Integer;
    FOutNum: Integer;
    FInSyNum: Integer;
    FInRoleKc: Integer;
  public
    /// <summary>
    /// �������
    /// </summary>
    property orderNo: string read FOrderNo write FOrderNo;
    /// <summary>
    /// ����
    /// </summary>
    property groupNo: string read FGroupNo write FGroupNo;
    /// <summary>
    /// ����ID
    /// </summary>
    property rowId: Integer read FRowId write FRowId;
    /// <summary>
    /// ������Ϸ�˺�
    /// </summary>
    property outAccount: string read FOutAccount write FOutAccount;
    /// <summary>
    /// ���Ž�ɫ����
    /// </summary>
    property outRoleName: string read FOutRoleName write FOutRoleName;
    /// <summary>
    /// ���Ž�ɫID
    /// </summary>
    property outRoleId: Integer read FOutRoleId write FOutRoleId;
    /// <summary>
    /// ���ſ������
    /// </summary>
    property outRoleKc: Integer read FOutRoleKc write FOutRoleKc;
    /// <summary>
    /// ����ʣ������
    /// </summary>
    property outSyNum: Integer read FOutSyNum write FOutSyNum;
    /// <summary>
    /// �Ӻ���Ϸ�˺�
    /// </summary>
    property inAccount: string read FInAccount write FInAccount;
    /// <summary>
    /// �ӺŽ�ɫ����
    /// </summary>
    property inRoleName: string read FInRoleName write FInRoleName;
    /// <summary>
    /// �ӺŽ�ɫID
    /// </summary>
    property inRoleId: Integer read FInRoleId write FInRoleId;
    /// <summary>
    /// ���ſ������
    /// </summary>
    property inRoleKc: Integer read FInRoleKc write FInRoleKc;
    /// <summary>
    /// ����ʣ������
    /// </summary>
    property inSyNum: Integer read FInSyNum write FInSyNum;
    /// <summary>
    /// ��������
    /// </summary>
    property outNum: Integer read FOutNum write FOutNum;
    /// <summary>
    /// ����״̬
    /// </summary>
    property orderState: Integer read FOrderState write FOrderState;
    /// <summary>
    /// �쳣ԭ��
    /// </summary>
    property catchReason: string read FCatchReason write FCatchReason;
  end;

  TSerizalizes = class
  public
    class function AsJSON<T>(AObject: T; Indent: Boolean = False): string;
    class function AsType<T>(AJsonText: string; var tRet: T): Boolean;
  end;


var
  GOrders: TArray<TOrderItem>;



implementation

uses SuperObject;

{ TSerizalizes }

class function TSerizalizes.AsJSON<T>(AObject: T; Indent: Boolean): string;
var
  Ctx: TSuperRttiContext;
begin
  Ctx := TSuperRttiContext.Create;
  try
    try
      Result := Ctx.AsJson<T>(AObject).AsJSon(Indent, False);
    except
      on E: Exception do
        OutputDebugString(PWideChar(Format('MS - AsJson fail, Err: %s', [E.Message])));
    end;
  finally
    Ctx.Free;
  end;
end;

class function TSerizalizes.AsType<T>(AJsonText: string; var tRet: T): Boolean;
var
  Ctx: TSuperRttiContext;
begin
  Result := False;
  Ctx := TSuperRttiContext.Create;
  try
    try
      tRet := Ctx.AsType<T>(SO(AJsonText));
      Result := True;
    except
      on E: Exception do
      begin
        OutputDebugString(PWideChar(Format('MS - AsType fail, Err: %s', [E.Message])));
      end;
    end;
  finally
    Ctx.Free;
  end;
end;

end.
