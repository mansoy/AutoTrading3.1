unit uPublic;

interface

uses Windows, Messages;

type

  TMsgContent = string[100];
  TGroupName = string[50];
  TComName = string[20];
  TQQNum = string[20];
  TPhoneNum = string[20];

  TCommType = (
    ctNone,             //--������
    ctResult,           //--���ؽ��
    ctGroupName,        //--�豸�˸����м���Լ������ʶ
    ctSendMsg,          //--���Ͷ���
    ctRecvMsg,          //--���ն��ţ��豸���յ����ź󷵻ظ������
    ctUnSafe            //--�ⰲȫ
    );

  //--������
  TResultState = (
    rsSuccess,          //--�ɹ�
    rsFail              //--ʧ��
  );

  PResultInfo = ^TResultInfo;
  TResultInfo = packed record
    CommType      : TCommType;        //--��ʶ�ǽ���ṹ��
    PriorCommType : TCommType;        //--��ʶ���Ǹ�����ķ��ؽ��
    ResultState   : TResultState;     //--��ʶ����ɹ�����ʧ��
    ClientConnID  : DWORD;            //--�ͻ��˵�����ID
    ResuleMsg     : string[200];      //--�������
  end;

  //--��¼�豸������Ϣ
  PDeviceInfo = ^TDeviceInfo;
  TDeviceInfo = record
    IsDevice: Boolean;      //--��ʶ���豸�ˣ� ���ǿͻ��ˣ�
    ConnectID: DWORD;       //--Socket
    GroupName: TGroupName;
    IP: string[20];
    Port: Word;
  end;

  //--���͡����ն��ŵĽṹ��
  PSmsData = ^TSmsData;
  TSmsData = packed record
    CommType    : TCommType;
    ClientConnID: DWORD;
    MsgContent  : TMsgContent;
    SendPhoneNum: TPhoneNum;
    RecvPhoneNum: TPhoneNum;
    ComName     : TComName;
    GroupName   : TGroupName;
  end;

  //--���÷����ʶ
  PGroupData = ^TGroupData;
  TGroupData = packed record
    CommType : TCommType;
    GroupName: TGroupName;
  end;

  //�ⰲȫ����
  PSafeData = ^TSafeData;
  TSafeData = packed record
    CommType  : TCommType;
    QQ        : TQQNum;
    PhoneNum  : TPhoneNum;
    MsgContent: TMsgContent;
  end;


var
  GFrmMainHwnd: HWND;

const
  WM_ADD_LOG    = WM_USER + 1001;
  WM_ADD_DEVICE = WM_USER + 1002;

implementation

end.
