unit HPSocketSDKUnit;

interface

uses
    Windows;

const
  HPSocketDLL = 'MsSocket.dll'; //'HPSocket4C_UD.dll';

type
{$Z4}
  SOCKET = Pointer;
  PVOID = Pointer;

  WSABUF = packed record
    len: ULONG; { the length of the buffer }
    buf: PChar; { the pointer to the buffer }
  end { WSABUF };

  PWSABUF = ^WSABUF;
  LPWSABUF = PWSABUF;

  WSABUFArray = array of WSABUF;

  PInteger = ^Integer;
  PUShort = ^USHORT;
  { /************************************************************************
    ���ƣ����� ID ��������
    �������������� ID ����������
    ************************************************************************/ }
  HP_CONNID = DWORD;
  PHP_CONNID = ^HP_CONNID;
  HP_CONNIDArray = array of HP_CONNID;
  { /************************************************************************
    ���ƣ����� Socket ����ָ�����ͱ���
    �������� Socket ����ָ�붨��Ϊ��ֱ�۵ı���
    ************************************************************************/ }
  HP_Object = PVOID;

  HP_Server = HP_Object;
  HP_Agent = HP_Object;
  HP_Client = HP_Object;
  HP_TcpServer = HP_Object;
  HP_TcpAgent = HP_Object;
  HP_TcpClient = HP_Object;
  HP_PullSocket = HP_Object;
  HP_PullClient = HP_Object;
  HP_TcpPullServer = HP_Object;
  HP_TcpPullClient = HP_Object;
  HP_TcpPullAgent = HP_Object;
  HP_UdpServer = HP_Object;
  HP_UdpClient = HP_Object;
  HP_UdpCast = HP_Object;

  HP_Listener = HP_Object;
  HP_ServerListener = HP_Object;
  HP_ClientListener = HP_Object;
  HP_AgentListener = HP_Object;
  HP_TcpServerListener = HP_Object;
  HP_TcpClientListener = HP_Object;
  HP_PullSocketListener = HP_Object;
  HP_TcpAgentListener = HP_Object;
  HP_TcpPullServerListener = HP_Object;
  HP_TcpPullClientListener = HP_Object;
  HP_TcpPullAgentListener = HP_Object;
  HP_UdpServerListener = HP_Object;
  HP_UdpClientListener = HP_Object;
  HP_UdpCastListener = HP_Object;

  { /*****************************************************************************************************/
    /******************************************** �����ࡢ�ӿ� ********************************************/
    /*****************************************************************************************************/ }

  { /************************************************************************
    ���ƣ�ͨ���������״̬
    ������Ӧ�ó������ͨ��ͨ������� GetState() ������ȡ�����ǰ����״̬
    ************************************************************************/ }
  EnAppState = (ST_STARTING, ST_STARTED, ST_STOPING, ST_STOPED);

  { /************************************************************************
    ���ƣ�ͨ���������״̬
    ������Ӧ�ó������ͨ��ͨ������� GetState() ������ȡ�����ǰ����״̬
    ************************************************************************ }
  En_HP_ServiceState = (HP_SS_STARTING = 0, // ��������
    HP_SS_STARTED = 1, // �Ѿ�����
    HP_SS_STOPING = 2, // ����ֹͣ
    HP_SS_STOPED = 3 // �Ѿ�����
    );

  { ************************************************************************
    ���ƣ�Socket ��������
    ������Ӧ�ó���� OnErrror() �¼���ͨ���ò�����ʶ�����ֲ������µĴ���
    ************************************************************************ }
  En_HP_SocketOperation = (HP_SO_UNKNOWN = 0, // Unknown
    HP_SO_ACCEPT = 1, // Acccept
    HP_SO_CONNECT = 2, // Connnect
    HP_SO_SEND = 3, // Send
    HP_SO_RECEIVE = 4 // Receive
    );

  { ************************************************************************
    ���ƣ��¼�֪ͨ������
    �������¼�֪ͨ�ķ���ֵ����ͬ�ķ���ֵ��Ӱ��ͨ������ĺ�����Ϊ
    ************************************************************************ }
  En_HP_HandleResult = (HP_HR_OK = 0, // �ɹ�
    HP_HR_IGNORE = 1, // ����
    HP_HR_ERROR = 2 // ����
    );

  { /************************************************************************
    ���ƣ�����ץȡ���
    ����������ץȡ�����ķ���ֵ
    ************************************************************************/ }
  En_HP_FetchResult = (HP_FR_OK = 0, // �ɹ�
    HP_FR_LENGTH_TOO_LONG = 1, // ץȡ���ȹ���
    HP_FR_DATA_NOT_FOUND = 2 // �Ҳ��� ConnID ��Ӧ������
    );

  { /************************************************************************
    ���ƣ����ݷ��Ͳ���
    ������Server ����� Agent ��������ݷ��Ͳ���

    * ���ģʽ��Ĭ�ϣ�	�������Ѷ�����Ͳ��������������һ���ͣ����Ӵ���Ч��
    * ��ȫģʽ			�������Ѷ�����Ͳ��������������һ���ͣ������ƴ����ٶȣ����⻺�������
    * ֱ��ģʽ			����ÿһ�����Ͳ�����ֱ��Ͷ�ݣ������ڸ��ز��ߵ�Ҫ��ʵʱ�Խϸߵĳ���

    ************************************************************************/ }
  En_HP_SendPolicy = (HP_SP_PACK = 0, // ���ģʽ��Ĭ�ϣ�
    HP_SP_SAFE = 1, // ��ȫģʽ
    HP_SP_DIRECT = 2 // ֱ��ģʽ
    );

  { /************************************************************************
    ���ƣ����ݽ��ղ���
    ������Server ����� Agent ��������ݽ��ղ���

    * ����ģʽ��Ĭ�ϣ�	�����ڵ������ӣ�˳�򴥷� OnReceive �� OnClose/OnError �¼���
    ����Ӧ�ó�����ĸ��Ӷȣ���ǿ��ȫ�ԣ���ͬʱ��ʧһЩ�������ܡ�
    * ����ģʽ			�����ڵ������ӣ�ͬʱ�յ� OnReceive �� OnClose/OnError �¼�ʱ��
    ���ڲ�ͬ�� ͨ���߳���ͬʱ������Щ�¼���ʹ�������ܵõ���������Ӧ�ó���
    ��Ҫ������ OnReceive ���¼���������У�ĳЩ�����������ܱ� OnClose/OnError
    ���¼����������Ļ��ͷŵ����Σ���������߼����ø��ӣ�������ʱ�����������ȱ��

    ************************************************************************/ }
  En_HP_RecvPolicy = (HP_RP_SERIAL = 0, // ����ģʽ��Ĭ�ϣ�
    HP_RP_PARALLEL = 1 // ����ģʽ
    );

  { ************************************************************************
    ���ƣ������������
    ������Start() / Stop() ����ִ��ʧ��ʱ����ͨ�� GetLastError() ��ȡ�������
    ************************************************************************ }
  En_HP_SocketError = (HP_SE_OK = 0, // �ɹ�
    HP_SE_ILLEGAL_STATE = 1, // ��ǰ״̬���������
    HP_SE_INVALID_PARAM = 2, // �Ƿ�����
    HP_SE_SOCKET_CREATE = 3, // ���� SOCKET ʧ��
    HP_SE_SOCKET_BIND = 4, // �� SOCKET ʧ��
    HP_SE_SOCKET_PREPARE = 5, // ���� SOCKET ʧ��
    HP_SE_SOCKET_LISTEN = 6, // ���� SOCKET ʧ��
    HP_SE_CP_CREATE = 7, // ������ɶ˿�ʧ��
    HP_SE_WORKER_THREAD_CREATE = 8, // ���������߳�ʧ��
    HP_SE_DETECT_THREAD_CREATE = 9, // ��������߳�ʧ��
    HP_SE_SOCKE_ATTACH_TO_CP = 10, // ����ɶ˿�ʧ��
    HP_SE_CONNECT_SERVER = 11, // ���ӷ�����ʧ��
    HP_SE_NETWORK = 12, // �������
    HP_SE_DATA_PROC = 13, // ���ݴ������
    HP_SE_DATA_SEND = 14 // ���ݷ���ʧ��
    );

  {
    /************************************************************************
  ���ƣ�����ģʽ
  ������UDP ����Ĳ���ģʽ���鲥��㲥��
  ************************************************************************/
  }
  En_HP_CastMode = (
    HP_CM_MULTICAST	= 0,	// �鲥
    HP_CM_BROADCAST	= 1 	// �㲥
  );

  { /****************************************************/
    /************** HPSocket4C.dll �ص����� **************/ }

  { **************************************************** }

  { /* �����ص����� */ }
  HP_FN_OnSend = function(dwConnID: HP_CONNID; const pData: Pointer; iLength: Integer): En_HP_HandleResult; stdcall;
  HP_FN_OnReceive = function(dwConnID: HP_CONNID; const pData: Pointer; iLength: Integer): En_HP_HandleResult; stdcall;
  HP_FN_Client_OnReceive = function(dwConnID: HP_CONNID; const pData: Pointer; iLength: Integer): En_HP_HandleResult; stdcall;
  HP_FN_OnPullReceive = function(dwConnID: HP_CONNID; iLength: Integer): En_HP_HandleResult; stdcall;
  HP_FN_OnClose = function(dwConnID: HP_CONNID): En_HP_HandleResult; stdcall;
  HP_FN_OnError = function(dwConnID: HP_CONNID; enOperation: En_HP_SocketOperation; iErrorCode: Integer) : En_HP_HandleResult; stdcall;

  { /* ����˻ص����� */ }
  HP_FN_OnPrepareListen = function(soListen: Pointer): En_HP_HandleResult; stdcall;
  // ���Ϊ TCP ���ӣ�pClientΪ SOCKET ��������Ϊ UDP ���ӣ�pClientΪ SOCKADDR_IN ָ�룻
  HP_FN_OnAccept = function(dwConnID: HP_CONNID; pClient: Pointer): En_HP_HandleResult; stdcall;
  HP_FN_OnServerShutdown = function(): En_HP_HandleResult; stdcall;

  { /* �ͻ��˺� Agent �ص����� */ }
  HP_FN_OnPrepareConnect = function(dwConnID: HP_CONNID; SOCKET: Pointer): En_HP_HandleResult; stdcall;
  HP_FN_OnConnect = function(dwConnID: HP_CONNID): En_HP_HandleResult; stdcall;

  { /* Agent �ص����� */ }
  HP_FN_OnAgentShutdown = function(): En_HP_HandleResult; stdcall;

  { /****************************************************/
    /************** HPSocket4C.dll �������� **************/ }

  // ���� HP_TcpServer ����
function Create_HP_TcpServer(pListener: HP_TcpServerListener): HP_TcpPullServer;
  stdcall; external HPSocketDLL;
// ���� HP_TcpClient ����
function Create_HP_TcpClient(pListener: HP_TcpClientListener): HP_TcpClient;
  stdcall; external HPSocketDLL;
// ���� HP_TcpAgent ����
function Create_HP_TcpAgent(pListener: HP_TcpAgentListener): HP_TcpAgent;
  stdcall; external HPSocketDLL;
// ���� HP_TcpPullServer ����
function Create_HP_TcpPullServer(pListener: HP_TcpPullServerListener)
  : HP_TcpPullServer; stdcall; external HPSocketDLL;
// ���� HP_TcpPullClient ����
function Create_HP_TcpPullClient(pListener: HP_TcpPullClientListener)
  : HP_TcpPullClient; stdcall; external HPSocketDLL;
// ���� HP_TcpPullAgent ����
function Create_HP_TcpPullAgent(pListener: HP_TcpPullAgentListener)
  : HP_TcpPullAgent; stdcall; external HPSocketDLL;
// ���� HP_UdpServer ����
function Create_HP_UdpServer(pListener: HP_UdpServerListener): HP_UdpServer;
  stdcall; external HPSocketDLL;
// ���� HP_UdpClient ����
function Create_HP_UdpClient(pListener: HP_UdpClientListener): HP_UdpClient;
  stdcall; external HPSocketDLL;

// ���� HP_TcpServer ����
procedure Destroy_HP_TcpServer(pServer: HP_TcpServer); stdcall;
  external HPSocketDLL;
// ���� HP_TcpClient ����
procedure Destroy_HP_TcpClient(pClient: HP_TcpClient); stdcall;
  external HPSocketDLL;
// ���� HP_TcpAgent ����
procedure Destroy_HP_TcpAgent(pAgent: HP_TcpAgent); stdcall;
  external HPSocketDLL;
// ���� HP_TcpPullServer ����
procedure Destroy_HP_TcpPullServer(pServer: HP_TcpPullServer); stdcall;
  external HPSocketDLL;
// ���� HP_TcpPullClient ����
procedure Destroy_HP_TcpPullClient(pClient: HP_TcpPullClient); stdcall;
  external HPSocketDLL;
// ���� HP_TcpPullAgent ����
procedure Destroy_HP_TcpPullAgent(pAgent: HP_TcpPullAgent); stdcall;
  external HPSocketDLL;
// ���� HP_UdpServer ����
procedure Destroy_HP_UdpServer(pServer: HP_UdpServer); stdcall;
  external HPSocketDLL;
// ���� HP_UdpClient ����

// ���� HP_TcpServerListener ����
function Create_HP_TcpServerListener(): HP_TcpServerListener; stdcall;
  external HPSocketDLL;
// ���� HP_TcpClientListener ����
function Create_HP_TcpClientListener(): HP_TcpClientListener; stdcall;
  external HPSocketDLL;
// ���� HP_TcpAgentListener ����
function Create_HP_TcpAgentListener(): HP_TcpAgentListener; stdcall;
  external HPSocketDLL;
// ���� HP_TcpPullServerListener ����
function Create_HP_TcpPullServerListener(): HP_TcpPullServerListener; stdcall;
  external HPSocketDLL;
// ���� HP_TcpPullClientListener ����
function Create_HP_TcpPullClientListener(): HP_TcpPullClientListener; stdcall;
  external HPSocketDLL;
// ���� HP_TcpPullAgentListener ����
function Create_HP_TcpPullAgentListener(): HP_TcpPullAgentListener; stdcall;
  external HPSocketDLL;
// ���� HP_UdpServerListener ����
function Create_HP_UdpServerListener(): HP_UdpServerListener; stdcall;
  external HPSocketDLL;
// ���� HP_UdpClientListener ����
function Create_HP_UdpClientListener(): HP_UdpClientListener; stdcall;
  external HPSocketDLL;

// ���� HP_TcpServerListener ����
procedure Destroy_HP_TcpServerListener(pListener: HP_TcpServerListener);
  stdcall; external HPSocketDLL;
// ���� HP_TcpClientListener ����
procedure Destroy_HP_TcpClientListener(pListener: HP_TcpClientListener);
  stdcall; external HPSocketDLL;
// ���� HP_TcpAgentListener ����
procedure Destroy_HP_TcpAgentListener(pListener: HP_TcpAgentListener); stdcall;
  external HPSocketDLL;
// ���� HP_TcpPullServerListener ����
procedure Destroy_HP_TcpPullServerListener(pListener: HP_TcpPullServerListener);
  stdcall; external HPSocketDLL;
// ���� HP_TcpPullClientListener ����
procedure Destroy_HP_TcpPullClientListener(pListener: HP_TcpPullClientListener);
  stdcall; external HPSocketDLL;
// ���� HP_TcpPullAgentListener ����
procedure Destroy_HP_TcpPullAgentListener(pListener: HP_TcpPullAgentListener);
  stdcall; external HPSocketDLL;
// ���� HP_UdpServerListener ����
procedure Destroy_HP_UdpServerListener(pListener: HP_UdpServerListener);
  stdcall; external HPSocketDLL;
// ���� HP_UdpClientListener ����
procedure Destroy_HP_UdpClientListener(pListener: HP_UdpClientListener);
  stdcall; external HPSocketDLL;

{ ***************************** Server �ص��������÷��� ***************************** }
procedure HP_Set_FN_Server_OnPrepareListen(pListener: HP_TcpServerListener;
  fn: HP_FN_OnPrepareListen); stdcall; external HPSocketDLL;
procedure HP_Set_FN_Server_OnAccept(pListener: HP_TcpServerListener;
  fn: HP_FN_OnAccept); stdcall; external HPSocketDLL;
procedure HP_Set_FN_Server_OnSend(pListener: HP_TcpServerListener;
  fn: HP_FN_OnSend); stdcall; external HPSocketDLL;
procedure HP_Set_FN_Server_OnReceive(pListener: HP_TcpServerListener;
  fn: HP_FN_OnReceive); stdcall; external HPSocketDLL;
procedure HP_Set_FN_Server_OnPullReceive(pListener: HP_TcpServerListener;
  fn: HP_FN_OnPullReceive); stdcall; external HPSocketDLL;
procedure HP_Set_FN_Server_OnClose(pListener: HP_TcpServerListener;
  fn: HP_FN_OnClose); stdcall; external HPSocketDLL;
procedure HP_Set_FN_Server_OnError(pListener: HP_TcpServerListener;
  fn: HP_FN_OnError); stdcall; external HPSocketDLL;
procedure HP_Set_FN_Server_OnShutdown(pListener: HP_TcpServerListener;
  fn: HP_FN_OnServerShutdown); stdcall; external HPSocketDLL;

{ /***************************** Client �ص��������÷��� *****************************/ }
procedure HP_Set_FN_Client_OnPrepareConnect(pListener: HP_TcpClientListener;
  fn: HP_FN_OnPrepareConnect); stdcall; external HPSocketDLL;
procedure HP_Set_FN_Client_OnConnect(pListener: HP_TcpClientListener;
  fn: HP_FN_OnConnect); stdcall; external HPSocketDLL;
procedure HP_Set_FN_Client_OnSend(pListener: HP_TcpClientListener;
  fn: HP_FN_OnSend); stdcall; external HPSocketDLL;
procedure HP_Set_FN_Client_OnReceive(pListener: HP_TcpClientListener;
  fn : HP_FN_Client_OnReceive); stdcall; external HPSocketDLL;
procedure HP_Set_FN_Client_OnPullReceive(pListener: HP_TcpClientListener;
  fn: HP_FN_OnPullReceive); stdcall; external HPSocketDLL;
procedure HP_Set_FN_Client_OnClose(pListener: HP_TcpClientListener;
  fn: HP_FN_OnClose); stdcall; external HPSocketDLL;
procedure HP_Set_FN_Client_OnError(pListener: HP_TcpClientListener;
  fn: HP_FN_OnError); stdcall; external HPSocketDLL;

{ /****************************** Agent �ص��������÷��� *****************************/ }
procedure HP_Set_FN_Agent_OnPrepareConnect(pListener: HP_AgentListener;
  fn: HP_FN_OnPrepareConnect); stdcall; external HPSocketDLL;
procedure HP_Set_FN_Agent_OnConnect(pListener: HP_AgentListener;
  fn: HP_FN_OnConnect); stdcall; external HPSocketDLL;
procedure HP_Set_FN_Agent_OnSend(pListener: HP_AgentListener; fn: HP_FN_OnSend);
  stdcall; external HPSocketDLL;
procedure HP_Set_FN_Agent_OnReceive(pListener: HP_AgentListener;
  fn: HP_FN_OnReceive); stdcall; external HPSocketDLL;
procedure HP_Set_FN_Agent_OnPullReceive(pListener: HP_AgentListener;
  fn: HP_FN_OnPullReceive); stdcall; external HPSocketDLL;
procedure HP_Set_FN_Agent_OnClose(pListener: HP_AgentListener;
  fn: HP_FN_OnClose); stdcall; external HPSocketDLL;
procedure HP_Set_FN_Agent_OnError(pListener: HP_AgentListener;
  fn: HP_FN_OnError); stdcall; external HPSocketDLL;
procedure HP_Set_FN_Agent_OnAgentShutdown(pListener: HP_AgentListener;
  fn: HP_FN_OnAgentShutdown); stdcall; external HPSocketDLL;

{ /**************************************************************************/ }

{ /***************************** Server �������� *****************************/ }

{ /*
  * ���ƣ�����ͨ�����
  * ���������������ͨ�������������ɺ�ɿ�ʼ���տͻ������Ӳ��շ�����
  *
  * ������		pszBindAddress	-- ������ַ
  *			usPort			-- �����˿�
  * ����ֵ��	TRUE	-- �ɹ�
  *			FALSE	-- ʧ�ܣ���ͨ�� GetLastError() ��ȡ�������
  */ }
function HP_Server_Start(pServer: HP_Server; pszBindAddress: PWideChar;
  usPort: USHORT): BOOL; stdcall; external HPSocketDLL;

{ /*
  * ���ƣ��ر�ͨ�����
  * �������رշ����ͨ��������ر���ɺ�Ͽ����пͻ������Ӳ��ͷ�������Դ
  *
  * ������
  * ����ֵ��	TRUE	-- �ɹ�
  *			FALSE	-- ʧ�ܣ���ͨ�� GetLastError() ��ȡ�������
  */ }
function HP_Server_Stop(pServer: HP_Server): BOOL; stdcall;
  external HPSocketDLL;

{ /*
  * ���ƣ���������
  * �������û�ͨ���÷�����ָ���ͻ��˷�������
  *
  * ������		dwConnID	-- ���� ID
  *			pBuffer		-- �������ݻ�����
  *			iLength		-- �������ݳ���
  * ����ֵ��	TRUE	-- �ɹ�
  *			FALSE	-- ʧ��
  */ }
function HP_Server_Send(pServer: HP_Server; dwConnID: HP_CONNID;
  const pBuffer: Pointer; iLength: Integer): BOOL; stdcall;
  external HPSocketDLL;

{ /*
  * ���ƣ���������
  * ��������ָ�����ӷ�������
  *
  * ������		dwConnID	-- ���� ID
  *			pBuffer		-- ���ͻ�����
  *			iLength		-- ���ͻ���������
  *			iOffset		-- ���ͻ�����ָ��ƫ����
  * ����ֵ��	TRUE	-- �ɹ�
  *			FALSE	-- ʧ�ܣ���ͨ�� Windows API ���� ::GetLastError() ��ȡ Windows �������
  */ }
function HP_Server_SendPart(pServer: HP_Server; dwConnID: HP_CONNID;
  const pBuffer: Pointer; iLength: Integer; iOffset: Integer): BOOL; stdcall;
  external HPSocketDLL;

{ /*
  * ���ƣ����Ͷ�������
  * ��������ָ�����ӷ��Ͷ�������
  *		TCP - ˳�����������ݰ�
  *		UDP - ���������ݰ���ϳ�һ�����ݰ����ͣ����ݰ����ܳ��Ȳ��ܴ������õ� UDP ����󳤶ȣ�
  *
  * ������		dwConnID	-- ���� ID
  *			pBuffers	-- ���ͻ���������
  *			iCount		-- ���ͻ�������Ŀ
  * ����ֵ��	TRUE	-- �ɹ�
  *			FALSE	-- ʧ�ܣ���ͨ�� Windows API ���� ::GetLastError() ��ȡ Windows �������
  */ }
function HP_Server_SendPackets(pServer: HP_Server; dwConnID: HP_CONNID;
  const pBuffers: WSABUFArray; iCount: Integer): BOOL; stdcall;
  external HPSocketDLL;

{ /*
  * ���ƣ��Ͽ�����
  * �������Ͽ���ĳ���ͻ��˵�����
  *
  * ������		dwConnID	-- ���� ID
  *			bForce		-- �Ƿ�ǿ�ƶϿ�����
  * ����ֵ��	TRUE	-- �ɹ�
  *			FALSE	-- ʧ��
  */ }
function HP_Server_Disconnect(pServer: HP_Server; dwConnID: HP_CONNID;
  bForce: LongInt): BOOL; stdcall; external HPSocketDLL;

{ /*
  * ���ƣ��Ͽ���ʱ����
  * �������Ͽ�����ָ��ʱ��������
  *
  * ������		dwPeriod	-- ʱ�������룩
  *			bForce		-- �Ƿ�ǿ�ƶϿ�����
  * ����ֵ��	TRUE	-- �ɹ�
  *			FALSE	-- ʧ��
  */ }
function HP_Server_DisconnectLongConnections(pServer: HP_Server;
  dwPeriod: LongInt; bForce: BOOL): BOOL; stdcall; external HPSocketDLL;

{ /******************************************************************************/
  /***************************** Server ���Է��ʷ��� *****************************/ }

{ /*
  * ���ƣ��������ӵĸ�������
  * �������Ƿ�Ϊ���Ӱ󶨸������ݻ��߰�ʲô�������ݣ�����Ӧ�ó���ֻ�����
  *
  * ������		dwConnID	-- ���� ID
  *			pv			-- ����
  * ����ֵ��	TRUE	-- �ɹ�
  *			FALSE	-- ʧ�ܣ���Ч������ ID��
  */ }
function HP_Server_SetConnectionExtra(pServer: HP_Server; dwConnID: HP_CONNID;
  pExtra: PVOID): BOOL; stdcall; external HPSocketDLL;

{ /*
  * ���ƣ���ȡ���ӵĸ�������
  * �������Ƿ�Ϊ���Ӱ󶨸������ݻ��߰�ʲô�������ݣ�����Ӧ�ó���ֻ�����
  *
  * ������		dwConnID	-- ���� ID
  *			ppv			-- ����ָ��
  * ����ֵ��	TRUE	-- �ɹ�
  *			FALSE	-- ʧ�ܣ���Ч������ ID��
  */ }
function HP_Server_GetConnectionExtra(pServer: HP_Server; dwConnID: HP_CONNID;
  ppExtra: PPVOID): BOOL; stdcall; external HPSocketDLL;

{ /* ���ͨ������Ƿ������� */ }
function HP_Server_HasStarted(pServer: HP_Server): BOOL; stdcall;
  external HPSocketDLL;
{ /* �鿴ͨ�������ǰ״̬ */ }
function HP_Server_GetState(pServer: HP_Server): En_HP_ServiceState; stdcall;
  external HPSocketDLL;
{ /* ��ȡ���һ��ʧ�ܲ����Ĵ������ */ }
function HP_Server_GetLastError(pServer: HP_Object): En_HP_SocketError; stdcall;
  external HPSocketDLL;
{ /* ��ȡ���һ��ʧ�ܲ����Ĵ������� */ }
function HP_Server_GetLastErrorDesc(pServer: HP_Server): PWideChar; stdcall;
  external HPSocketDLL;
{ /* ��ȡ������δ�������ݵĳ��� */ }
function HP_Server_GetPendingDataLength(pServer: HP_Server; dwConnID: HP_CONNID;
  piPending: PInteger): BOOL; stdcall; external HPSocketDLL;
{ /* ��ȡ�ͻ��������� */ }
function HP_Server_GetConnectionCount(pServer: HP_Server): LongInt; stdcall;
  external HPSocketDLL;
{ /* ��ȡ�������ӵ� CONNID */ }
function HP_Server_GetAllConnectionIDs(pServer: HP_Server; pIDs: HP_CONNIDArray;
  pdwCount: PLongint): BOOL; stdcall; external HPSocketDLL;
{ /* ��ȡĳ���ͻ�������ʱ�������룩 */ }
function HP_Server_GetConnectPeriod(pServer: HP_Server; dwConnID: HP_CONNID;
  pdwPeriod: PLongint): BOOL; stdcall; external HPSocketDLL;
{ /* ��ȡ���� Socket �ĵ�ַ��Ϣ */ }
function HP_Server_GetListenAddress(pServer: HP_Server; lpszAddress: PWideChar;
  piAddressLen: PInteger; pusPort: PUShort): BOOL; stdcall;
  external HPSocketDLL;
{ /* ��ȡĳ�����ӵ�Զ�̵�ַ��Ϣ */ }
function HP_Server_GetRemoteAddress(pServer: HP_Server; dwConnID: HP_CONNID;
  lpszAddress: PWideChar; piAddressLen: PInteger; pusPort: PUShort): BOOL;
  stdcall; external HPSocketDLL;

{ /* �������ݷ��Ͳ��� */ }
procedure HP_Server_SetSendPolicy(pServer: HP_Server;
  enSendPolicy: En_HP_SendPolicy); stdcall; external HPSocketDLL;
{ /* �������ݽ��ղ��� */ }
procedure HP_Server_SetRecvPolicy(pServer: HP_Server;
  enRecvPolicy: En_HP_RecvPolicy); stdcall; external HPSocketDLL;
{ /* ���� Socket �����������ʱ�䣨���룬�������ڼ�� Socket ��������ܱ���ȡʹ�ã� */ }
procedure HP_Server_SetFreeSocketObjLockTime(pServer: HP_Server;
  dwFreeSocketObjLockTime: LongInt); stdcall; external HPSocketDLL;
{ /* ���� Socket ����ش�С��ͨ������Ϊƽ���������������� 1/3 - 1/2�� */ }
procedure HP_Server_SetFreeSocketObjPool(pServer: HP_Server;
  dwFreeSocketObjPool: LongInt); stdcall; external HPSocketDLL;
{ /* �����ڴ�黺��ش�С��ͨ������Ϊ Socket ����ش�С�� 2 - 3 ���� */ }
procedure HP_Server_SetFreeBufferObjPool(pServer: HP_Server;
  dwFreeBufferObjPool: LongInt); stdcall; external HPSocketDLL;
{ /* ���� Socket ����ػ��շ�ֵ��ͨ������Ϊ Socket ����ش�С�� 3 ���� */ }
procedure HP_Server_SetFreeSocketObjHold(pServer: HP_Server;
  dwFreeSocketObjHold: LongInt); stdcall; external HPSocketDLL;
{ /* �����ڴ�黺��ػ��շ�ֵ��ͨ������Ϊ�ڴ�黺��ش�С�� 3 ���� */ }
procedure HP_Server_SetFreeBufferObjHold(pServer: HP_Server;
  dwFreeBufferObjHold: LongInt); stdcall; external HPSocketDLL;
{ /* ���ù����߳�������ͨ������Ϊ 2 * CPU + 2�� */ }
procedure HP_Server_SetWorkerThreadCount(pServer: HP_Server;
  dwWorkerThreadCount: LongInt); stdcall; external HPSocketDLL;
{ /* ���ùرշ���ǰ�ȴ����ӹرյ��ʱ�ޣ����룬0 �򲻵ȴ��� */ }
procedure HP_Server_SetMaxShutdownWaitTime(pServer: HP_Server;
  dwMaxShutdownWaitTime: LongInt); stdcall; external HPSocketDLL;

{ /* ��ȡ���ݷ��Ͳ��� */ }
function HP_Server_GetSendPolicy(pServer: HP_Server): En_HP_SendPolicy; stdcall;
  external HPSocketDLL;
{ /* ��ȡ���ݽ��ղ��� */ }
function HP_Server_GetRecvPolicy(pServer: HP_Server): En_HP_RecvPolicy; stdcall;
  external HPSocketDLL;
{ /* ��ȡ Socket �����������ʱ�� */ }
function HP_Server_GetFreeSocketObjLockTime(pServer: HP_Server): LongInt;
  stdcall; external HPSocketDLL;
{ /* ��ȡ Socket ����ش�С */ }
function HP_Server_GetFreeSocketObjPool(pServer: HP_Server): LongInt; stdcall;
  external HPSocketDLL;
{ /* ��ȡ�ڴ�黺��ش�С */ }
function HP_Server_GetFreeBufferObjPool(pServer: HP_Server): LongInt; stdcall;
  external HPSocketDLL;
{ /* ��ȡ Socket ����ػ��շ�ֵ */ }
function HP_Server_GetFreeSocketObjHold(pServer: HP_Server): LongInt; stdcall;
  external HPSocketDLL;
{ /* ��ȡ�ڴ�黺��ػ��շ�ֵ */ }
function HP_Server_GetFreeBufferObjHold(pServer: HP_Server): LongInt; stdcall;
  external HPSocketDLL;
{ /* ��ȡ�����߳����� */ }
function HP_Server_GetWorkerThreadCount(pServer: HP_Server): LongInt; stdcall;
  external HPSocketDLL;
{ /* ��ȡ�رշ���ǰ�ȴ����ӹرյ��ʱ�� */ }
function HP_Server_GetMaxShutdownWaitTime(pServer: HP_Server): LongInt; stdcall;
  external HPSocketDLL;

{ /**********************************************************************************/
  /******************************* TCP Server �������� *******************************/ }

{ /*
  * ���ƣ�����С�ļ�
  * ��������ָ�����ӷ��� 4096 KB ���µ�С�ļ�
  *
  * ������		dwConnID		-- ���� ID
  *			lpszFileName	-- �ļ�·��
  *			pHead			-- ͷ����������
  *			pTail			-- β����������
  * ����ֵ��	TRUE	-- �ɹ�
  *			FALSE	-- ʧ�ܣ���ͨ�� Windows API ���� ::GetLastError() ��ȡ Windows �������
  */ }
function HP_TcpServer_SendSmallFile(pServer: HP_Server; dwConnID: HP_CONNID;
  lpszFileName: PWideChar; const pHead: LPWSABUF; const pTail: LPWSABUF): BOOL;
  stdcall; external HPSocketDLL;

{ /**********************************************************************************/
  /***************************** TCP Server ���Է��ʷ��� *****************************/ }

{ /* ���ü��� Socket �ĵȺ���д�С�����ݲ������������������ã� */ }
procedure HP_TcpServer_SetSocketListenQueue(pServer: HP_TcpServer;
  dwSocketListenQueue: LongInt); stdcall; external HPSocketDLL;
{ /* ���� Accept ԤͶ�����������ݸ��ص������ã�Accept ԤͶ������Խ����֧�ֵĲ�����������Խ�ࣩ */ }
procedure HP_TcpServer_SetAcceptSocketCount(pServer: HP_TcpServer;
  dwAcceptSocketCount: LongInt); stdcall; external HPSocketDLL;
{ /* ����ͨ�����ݻ�������С������ƽ��ͨ�����ݰ���С�������ã�ͨ������Ϊ 1024 �ı����� */ }
procedure HP_TcpServer_SetSocketBufferSize(pServer: HP_TcpServer;
  dwSocketBufferSize: LongInt); stdcall; external HPSocketDLL;
{ /* ������������������룬0 �򲻷����������� */ }
procedure HP_TcpServer_SetKeepAliveTime(pServer: HP_TcpServer;
  dwKeepAliveTime: LongInt); stdcall; external HPSocketDLL;
{ /* ��������ȷ�ϰ�����������룬0 ������������������������ɴ� [Ĭ�ϣ�WinXP 5 ��, Win7 10 ��] ��ⲻ������ȷ�ϰ�����Ϊ�Ѷ��ߣ� */ }
procedure HP_TcpServer_SetKeepAliveInterval(pServer: HP_TcpServer;
  dwKeepAliveInterval: LongInt); stdcall; external HPSocketDLL;

{ /* ��ȡ Accept ԤͶ������ */ }
function HP_TcpServer_GetAcceptSocketCount(pServer: HP_TcpServer): LongInt;
  stdcall; external HPSocketDLL;
{ /* ��ȡͨ�����ݻ�������С */ }
function HP_TcpServer_GetSocketBufferSize(pServer: HP_TcpServer): LongInt;
  stdcall; external HPSocketDLL;
{ /* ��ȡ���� Socket �ĵȺ���д�С */ }
function HP_TcpServer_GetSocketListenQueue(pServer: HP_TcpServer): LongInt;
  stdcall; external HPSocketDLL;
{ /* ��ȡ���������� */ }
function HP_TcpServer_GetKeepAliveTime(pServer: HP_TcpServer): LongInt; stdcall;
  external HPSocketDLL;
{ /* ��ȡ��������� */ }
function HP_TcpServer_GetKeepAliveInterval(pServer: HP_TcpServer): LongInt;
  stdcall; external HPSocketDLL;

{ /**********************************************************************************/
  /***************************** UDP Server ���Է��ʷ��� *****************************/ }

{ /* �������ݱ�����󳤶ȣ������ھ����������²����� 1472 �ֽڣ��ڹ����������²����� 548 �ֽڣ� */ }
procedure HP_UdpServer_SetMaxDatagramSize(pServer: HP_UdpServer;
  dwMaxDatagramSize: LongInt); stdcall; external HPSocketDLL;
{ /* ��ȡ���ݱ�����󳤶� */ }
function HP_UdpServer_GetMaxDatagramSize(pServer: HP_UdpServer): LongInt;
  stdcall; external HPSocketDLL;

{ /* ���� Receive ԤͶ�����������ݸ��ص������ã�Receive ԤͶ������Խ���򶪰�����ԽС�� */ }
procedure HP_UdpServer_SetPostReceiveCount(pServer: HP_UdpServer;
  dwPostReceiveCount: LongInt); stdcall; external HPSocketDLL;
{ /* ��ȡ Receive ԤͶ������ */ }
function HP_UdpServer_GetPostReceiveCount(pServer: HP_UdpServer): LongInt;
  stdcall; external HPSocketDLL;

{ /* ���ü������Դ�����0 �򲻷��ͼ�������������������Դ�������Ϊ�Ѷ��ߣ� */ }
procedure HP_UdpServer_SetDetectAttempts(pServer: HP_UdpServer;
  dwDetectAttempts: LongInt); stdcall; external HPSocketDLL;
{ /* ���ü������ͼ�����룬0 �����ͼ����� */ }
procedure HP_UdpServer_SetDetectInterval(pServer: HP_UdpServer;
  dwDetectInterval: LongInt); stdcall; external HPSocketDLL;
{ /* ��ȡ���������� */ }
function HP_UdpServer_GetDetectAttempts(pServer: HP_UdpServer): LongInt;
  stdcall; external HPSocketDLL;
{ /* ��ȡ��������� */ }
function HP_UdpServer_GetDetectInterval(pServer: HP_UdpServer): LongInt;
  stdcall; external HPSocketDLL;

{ /******************************************************************************/
  /***************************** Client ����������� *****************************/ }

{ /*
  * ���ƣ�����ͨ�����
  * �����������ͻ���ͨ����������ӷ���ˣ�������ɺ�ɿ�ʼ�շ�����
  *
  * ������		pszRemoteAddress	-- ����˵�ַ
  *			usPort				-- ����˶˿�
  *			bAsyncConnect		-- �Ƿ�����첽 Connect
  * ����ֵ��	TRUE	-- �ɹ�
  *			FALSE	-- ʧ�ܣ���ͨ�� GetLastError() ��ȡ�������
  */ }
function HP_Client_Start(pClient: HP_Client; pszRemoteAddress: PWideChar;
  usPort: USHORT; bAsyncConnect: BOOL): BOOL; stdcall; external HPSocketDLL;

{ /*
  * ���ƣ��ر�ͨ�����
  * �������رտͻ���ͨ��������ر���ɺ�Ͽ������˵����Ӳ��ͷ�������Դ
  *
  * ������
  * ����ֵ��	TRUE	-- �ɹ�
  *			FALSE	-- ʧ�ܣ���ͨ�� GetLastError() ��ȡ�������
  */ }
function HP_Client_Stop(pClient: HP_Client): BOOL; stdcall;
  external HPSocketDLL;

{ /*
  * ���ƣ���������
  * �����������˷�������
  *
  * ������		pBuffer		-- ���ͻ�����
  *			iLength		-- ���ͻ���������
  * ����ֵ��	TRUE	-- �ɹ�
  *			FALSE	-- ʧ�ܣ���ͨ�� Windows API ���� ::GetLastError() ��ȡ Windows �������
  */ }
function HP_Client_Send(pClient: HP_Client; const pBuffer: Pointer;
  iLength: Integer): BOOL; stdcall; external HPSocketDLL;

{ /*
  * ���ƣ���������
  * �����������˷�������
  *
  * ������		pBuffer		-- ���ͻ�����
  *			iLength		-- ���ͻ���������
  *			iOffset		-- ���ͻ�����ָ��ƫ����
  * ����ֵ��	TRUE	-- �ɹ�
  *			FALSE	-- ʧ�ܣ���ͨ�� Windows API ���� ::GetLastError() ��ȡ Windows �������
  */ }
function HP_Client_SendPart(pClient: HP_Client; const pBuffer: Pointer;
  iLength: Integer; iOffset: Integer): BOOL; stdcall; external HPSocketDLL;

{ /*
  * ���ƣ����Ͷ�������
  * �����������˷��Ͷ�������
  *		TCP - ˳�����������ݰ�
  *		UDP - ���������ݰ���ϳ�һ�����ݰ����ͣ����ݰ����ܳ��Ȳ��ܴ������õ� UDP ����󳤶ȣ�
  *
  * ������		pBuffers	-- ���ͻ���������
  *			iCount		-- ���ͻ�������Ŀ
  * ����ֵ��	TRUE	-- �ɹ�
  *			FALSE	-- ʧ�ܣ���ͨ�� Windows API ���� ::GetLastError() ��ȡ Windows �������
  */ }
function HP_Client_SendPackets(pClient: HP_Client; const pBuffers: WSABUFArray;
  iCount: Integer): BOOL; stdcall; external HPSocketDLL;

{ /******************************************************************************/
  /***************************** Client ���Է��ʷ��� *****************************/ }

{ /* ���ͨ������Ƿ������� */ }
function HP_Client_HasStarted(pClient: HP_Client): BOOL; stdcall;
  external HPSocketDLL;
{ /* �鿴ͨ�������ǰ״̬ */ }
function HP_Client_GetState(pClient: HP_Client): En_HP_ServiceState; stdcall;
  external HPSocketDLL;
{ /* ��ȡ���һ��ʧ�ܲ����Ĵ������ */ }
function HP_Client_GetLastError(pClient: HP_Client): En_HP_SocketError; stdcall;
  external HPSocketDLL;
{ /* ��ȡ���һ��ʧ�ܲ����Ĵ������� */ }
function HP_Client_GetLastErrorDesc(pClient: HP_Client): PWideChar; stdcall;
  external HPSocketDLL;
{ /* ��ȡ�������������� ID */ }
function HP_Client_GetConnectionID(pClient: HP_Client): HP_CONNID; stdcall;
  external HPSocketDLL;
{ /* ��ȡ Client Socket �ĵ�ַ��Ϣ */ }
function HP_Client_GetLocalAddress(pClient: HP_Client; lpszAddress: PWideChar;
  piAddressLen: PInteger; pusPort: PUShort): BOOL; stdcall;
  external HPSocketDLL;
{ /* ��ȡ������δ�������ݵĳ��� */ }
function HP_Client_GetPendingDataLength(pClient: HP_Client; piPending: PInteger)
  : BOOL; stdcall; external HPSocketDLL;
{ /* �����ڴ�黺��ش�С��ͨ������Ϊ -> PUSH ģ�ͣ�5 - 10��PULL ģ�ͣ�10 - 20 �� */ }
procedure HP_Client_SetFreeBufferPoolSize(pClient: HP_Client;
  dwFreeBufferPoolSize: LongInt); stdcall; external HPSocketDLL;
{ /* �����ڴ�黺��ػ��շ�ֵ��ͨ������Ϊ�ڴ�黺��ش�С�� 3 ���� */ }
procedure HP_Client_SetFreeBufferPoolHold(pClient: HP_Client;
  dwFreeBufferPoolHold: LongInt); stdcall; external HPSocketDLL;
{ /* ��ȡ�ڴ�黺��ش�С */ }
function HP_Client_GetFreeBufferPoolSize(pClient: HP_Client): LongInt; stdcall;
  external HPSocketDLL;
{ /* ��ȡ�ڴ�黺��ػ��շ�ֵ */ }
function HP_Client_GetFreeBufferPoolHold(pClient: HP_Client): LongInt; stdcall;
  external HPSocketDLL;
{ // ��ȡ���һ��ʧ�ܲ����Ĵ������ }

{ /**********************************************************************************/
  /******************************* TCP Client �������� *******************************/ }

{ /*
  * ���ƣ�����С�ļ�
  * �����������˷��� 4096 KB ���µ�С�ļ�
  *
  * ������		lpszFileName	-- �ļ�·��
  *			pHead			-- ͷ����������
  *			pTail			-- β����������
  * ����ֵ��	TRUE	-- �ɹ�
  *			FALSE	-- ʧ�ܣ���ͨ�� Windows API ���� ::GetLastError() ��ȡ Windows �������
  */ }
function HP_TcpClient_SendSmallFile(pClient: HP_Client; lpszFileName: PWideChar;
  const pHead: LPWSABUF; const pTail: LPWSABUF): BOOL; stdcall;
  external HPSocketDLL;

{ /**********************************************************************************/
  /***************************** TCP Client ���Է��ʷ��� *****************************/ }

{ /* ����ͨ�����ݻ�������С������ƽ��ͨ�����ݰ���С�������ã�ͨ������Ϊ��(N * 1024) - sizeof(TBufferObj)�� */ }
procedure HP_TcpClient_SetSocketBufferSize(pClient: HP_TcpClient;
  dwSocketBufferSize: LongInt); stdcall; external HPSocketDLL;
{ /* ������������������룬0 �򲻷����������� */ }
procedure HP_TcpClient_SetKeepAliveTime(pClient: HP_TcpClient;
  dwKeepAliveTime: LongInt); stdcall; external HPSocketDLL;
{ /* ��������ȷ�ϰ�����������룬0 ������������������������ɴ� [Ĭ�ϣ�WinXP 5 ��, Win7 10 ��] ��ⲻ������ȷ�ϰ�����Ϊ�Ѷ��ߣ� */ }
procedure HP_TcpClient_SetKeepAliveInterval(pClient: HP_TcpClient;
  dwKeepAliveInterval: LongInt); stdcall; external HPSocketDLL;

{ /* ��ȡͨ�����ݻ�������С */ }
function HP_TcpClient_GetSocketBufferSize(pClient: HP_TcpClient): LongInt;
  stdcall; external HPSocketDLL;
{ /* ��ȡ���������� */ }
function HP_TcpClient_GetKeepAliveTime(pClient: HP_TcpClient): LongInt; stdcall;
  external HPSocketDLL;
{ /* ��ȡ��������� */ }
function HP_TcpClient_GetKeepAliveInterval(pClient: HP_TcpClient): LongInt;
  stdcall; external HPSocketDLL;

{ /**********************************************************************************/
  /***************************** UDP Client ���Է��ʷ��� *****************************/ }

{ /* �������ݱ�����󳤶ȣ������ھ����������²����� 1472 �ֽڣ��ڹ����������²����� 548 �ֽڣ� */ }
procedure HP_UdpClient_SetMaxDatagramSize(pClient: HP_UdpClient;
  dwMaxDatagramSize: LongInt); stdcall; external HPSocketDLL;
{ /* ��ȡ���ݱ�����󳤶� */ }
function HP_UdpClient_GetMaxDatagramSize(pClient: HP_UdpClient): LongInt;
  stdcall; external HPSocketDLL;

{ /* ���ü������Դ�����0 �򲻷��ͼ�������������������Դ�������Ϊ�Ѷ��ߣ� */ }
procedure HP_UdpClient_SetDetectAttempts(pClient: HP_UdpClient;
  dwDetectAttempts: LongInt); stdcall; external HPSocketDLL;
{ /* ���ü������ͼ�����룬0 �����ͼ����� */ }
procedure HP_UdpClient_SetDetectInterval(pClient: HP_UdpClient;
  dwDetectInterval: LongInt); stdcall; external HPSocketDLL;
{ /* ��ȡ���������� */ }
function HP_UdpClient_GetDetectAttempts(pClient: HP_UdpClient): LongInt;
  stdcall; external HPSocketDLL;
{ /* ��ȡ��������� */ }
function HP_UdpClient_GetDetectInterval(pClient: HP_UdpClient): LongInt;
  stdcall; external HPSocketDLL;

{ /**************************************************************************/
  /***************************** Agent �������� *****************************/ }

{ /*
  * ���ƣ�����ͨ�����
  * ����������ͨ�Ŵ��������������ɺ�ɿ�ʼ����Զ�̷�����
  *
  * ������		pszBindAddress	-- ������ַ
  *			bAsyncConnect	-- �Ƿ�����첽 Connect
  * ����ֵ��	TRUE	-- �ɹ�
  *			FALSE	-- ʧ�ܣ���ͨ�� GetLastError() ��ȡ�������
  */ }
function HP_Agent_Start(pAgent: HP_Agent; pszBindAddress: PWideChar;
  bAsyncConnect: BOOL): BOOL; stdcall; external HPSocketDLL;

{ /*
  * ���ƣ��ر�ͨ�����
  * �������ر�ͨ��������ر���ɺ�Ͽ��������Ӳ��ͷ�������Դ
  *
  * ������
  * ����ֵ��	TRUE	-- �ɹ�
  *			FALSE	-- ʧ�ܣ���ͨ�� GetLastError() ��ȡ�������
  */ }
function HP_Agent_Stop(pAgent: HP_Agent): BOOL; stdcall; external HPSocketDLL;

{ /*
  * ���ƣ����ӷ�����
  * ���������ӷ����������ӳɹ��� IAgentListener ����յ� OnConnect() �¼�
  *
  * ������		pszRemoteAddress	-- ����˵�ַ
  *			usPort				-- ����˶˿�
  *			pdwConnID			-- ���� ID��Ĭ�ϣ�nullptr������ȡ���� ID��
  * ����ֵ��	TRUE	-- �ɹ�
  *			FALSE	-- ʧ�ܣ���ͨ������ SYS_GetLastError() ��ȡ Windows �������
  */ }
function HP_Agent_Connect(pAgent: HP_Agent; pszRemoteAddress: PWideChar;
  usPort: USHORT; pdwConnID: PHP_CONNID): BOOL; stdcall; external HPSocketDLL;

{ /*
  * ���ƣ���������
  * ��������ָ�����ӷ�������
  *
  * ������		dwConnID	-- ���� ID
  *			pBuffer		-- ���ͻ�����
  *			iLength		-- ���ͻ���������
  * ����ֵ��	TRUE	-- �ɹ�
  *			FALSE	-- ʧ�ܣ���ͨ�� Windows API ���� ::GetLastError() ��ȡ Windows �������
  */ }
function HP_Agent_Send(pAgent: HP_Agent; dwConnID: HP_CONNID;
  const pBuffer: Pointer; iLength: Integer): BOOL; stdcall;
  external HPSocketDLL;

{ /*
  * ���ƣ���������
  * ��������ָ�����ӷ�������
  *
  * ������		dwConnID	-- ���� ID
  *			pBuffer		-- ���ͻ�����
  *			iLength		-- ���ͻ���������
  *			iOffset		-- ���ͻ�����ָ��ƫ����
  * ����ֵ��	TRUE	-- �ɹ�
  *			FALSE	-- ʧ�ܣ���ͨ�� Windows API ���� ::GetLastError() ��ȡ Windows �������
  */ }
function HP_Agent_SendPart(pAgent: HP_Agent; dwConnID: HP_CONNID;
  const pBuffer: Pointer; iLength: Integer; iOffset: Integer): BOOL; stdcall;
  external HPSocketDLL;

{ /*
  * ���ƣ����Ͷ�������
  * ��������ָ�����ӷ��Ͷ�������
  *		TCP - ˳�����������ݰ�
  *		UDP - ���������ݰ���ϳ�һ�����ݰ����ͣ����ݰ����ܳ��Ȳ��ܴ������õ� UDP ����󳤶ȣ�
  *
  * ������		dwConnID	-- ���� ID
  *			pBuffers	-- ���ͻ���������
  *			iCount		-- ���ͻ�������Ŀ
  * ����ֵ��	TRUE	-- �ɹ�
  *			FALSE	-- ʧ�ܣ���ͨ�� Windows API ���� ::GetLastError() ��ȡ Windows �������
  */ }
function HP_Agent_SendPackets(pAgent: HP_Agent; dwConnID: HP_CONNID;
  const pBuffers: WSABUFArray; iCount: Integer): BOOL; stdcall;
  external HPSocketDLL;

{ /*
  * ���ƣ��Ͽ�����
  * �������Ͽ�ĳ������
  *
  * ������		dwConnID	-- ���� ID
  *			bForce		-- �Ƿ�ǿ�ƶϿ�����
  * ����ֵ��	TRUE	-- �ɹ�
  *			FALSE	-- ʧ��
  */ }
function HP_Agent_Disconnect(pAgent: HP_Agent; dwConnID: HP_CONNID;
  bForce: BOOL): BOOL; stdcall; external HPSocketDLL;

{ /*
  * ���ƣ��Ͽ���ʱ����
  * �������Ͽ�����ָ��ʱ��������
  *
  * ������		dwPeriod	-- ʱ�������룩
  *			bForce		-- �Ƿ�ǿ�ƶϿ�����
  * ����ֵ��	TRUE	-- �ɹ�
  *			FALSE	-- ʧ��
  */ }
function HP_Agent_DisconnectLongConnections(pAgent: HP_Agent; dwPeriod: LongInt;
  bForce: BOOL): BOOL; stdcall; external HPSocketDLL;

{ /******************************************************************************/
  /***************************** Agent ���Է��ʷ��� *****************************/ }

{ /*
  * ���ƣ��������ӵĸ�������
  * �������Ƿ�Ϊ���Ӱ󶨸������ݻ��߰�ʲô�������ݣ�����Ӧ�ó���ֻ�����
  *
  * ������		dwConnID	-- ���� ID
  *			pv			-- ����
  * ����ֵ��	TRUE	-- �ɹ�
  *			FALSE	-- ʧ�ܣ���Ч������ ID��
  */ }
function HP_Agent_SetConnectionExtra(pAgent: HP_Agent; dwConnID: HP_CONNID;
  pExtra: PVOID): BOOL; stdcall; external HPSocketDLL;

{ /*
  * ���ƣ���ȡ���ӵĸ�������
  * �������Ƿ�Ϊ���Ӱ󶨸������ݻ��߰�ʲô�������ݣ�����Ӧ�ó���ֻ�����
  *
  * ������		dwConnID	-- ���� ID
  *			ppv			-- ����ָ��
  * ����ֵ��	TRUE	-- �ɹ�
  *			FALSE	-- ʧ�ܣ���Ч������ ID��
  */ }
function HP_Agent_GetConnectionExtra(pAgent: HP_Agent; dwConnID: HP_CONNID;
  ppExtra: PPVOID): BOOL; stdcall; external HPSocketDLL;

{ /* ���ͨ������Ƿ������� */ }
function HP_Agent_HasStarted(pAgent: HP_Agent): BOOL; stdcall;
  external HPSocketDLL;
{ /* �鿴ͨ�������ǰ״̬ */ }
function HP_Agent_GetState(pAgent: HP_Agent): En_HP_ServiceState; stdcall;
  external HPSocketDLL;
{ /* ��ȡ������ */ }
function HP_Agent_GetConnectionCount(pAgent: HP_Agent): LongInt; stdcall;
  external HPSocketDLL;
{ /* ��ȡ�������ӵ� CONNID */ }
function HP_Agent_GetAllConnectionIDs(pAgent: HP_Agent; pIDs: HP_CONNIDArray;
  pdwCount: PLongint): BOOL; stdcall; external HPSocketDLL;
{ /* ��ȡĳ������ʱ�������룩 */ }
function HP_Agent_GetConnectPeriod(pAgent: HP_Agent; dwConnID: HP_CONNID;
  pdwPeriod: PLongint): BOOL; stdcall; external HPSocketDLL;
{ /* ��ȡĳ�����ӵı��ص�ַ��Ϣ */ }
function HP_Agent_GetLocalAddress(pAgent: HP_Agent; dwConnID: HP_CONNID;
  lpszAddress: PWideChar; piAddressLen: PInteger; pusPort: PUShort): BOOL;
  stdcall; external HPSocketDLL;
{ /* ��ȡĳ�����ӵ�Զ�̵�ַ��Ϣ */ }
function HP_Agent_GetRemoteAddress(pAgent: HP_Agent; dwConnID: HP_CONNID;
  lpszAddress: PWideChar; piAddressLen: PInteger; pusPort: PUShort): BOOL;
  stdcall; external HPSocketDLL;
{ /* ��ȡ���һ��ʧ�ܲ����Ĵ������ */ }
function HP_Agent_GetLastError(pAgent: HP_Agent): En_HP_SocketError; stdcall;
  external HPSocketDLL;
{ /* ��ȡ���һ��ʧ�ܲ����Ĵ������� */ }
function HP_Agent_GetLastErrorDesc(pAgent: HP_Agent): PWideChar; stdcall;
  external HPSocketDLL;
{ /* ��ȡ������δ�������ݵĳ��� */ }
function HP_Agent_GetPendingDataLength(pAgent: HP_Agent; dwConnID: HP_CONNID;
  piPending: PInteger): BOOL; stdcall; external HPSocketDLL;

{ /* �������ݷ��Ͳ��� */ }
procedure HP_Agent_SetSendPolicy(pAgent: HP_Agent;
  enSendPolicy: En_HP_SendPolicy); stdcall; external HPSocketDLL;
{ /* �������ݽ��ղ��� */ }
procedure HP_Agent_SetRecvPolicy(pAgent: HP_Agent;
  enRecvPolicy: En_HP_RecvPolicy); stdcall; external HPSocketDLL;
{ /* ���� Socket �����������ʱ�䣨���룬�������ڼ�� Socket ��������ܱ���ȡʹ�ã� */ }
procedure HP_Agent_SetFreeSocketObjLockTime(pAgent: HP_Agent;
  dwFreeSocketObjLockTime: LongInt); stdcall; external HPSocketDLL;
{ /* ���� Socket ����ش�С��ͨ������Ϊƽ���������������� 1/3 - 1/2�� */ }
procedure HP_Agent_SetFreeSocketObjPool(pAgent: HP_Agent;
  dwFreeSocketObjPool: LongInt); stdcall; external HPSocketDLL;
{ /* �����ڴ�黺��ش�С��ͨ������Ϊ Socket ����ش�С�� 2 - 3 ���� */ }
procedure HP_Agent_SetFreeBufferObjPool(pAgent: HP_Agent;
  dwFreeBufferObjPool: LongInt); stdcall; external HPSocketDLL;
{ /* ���� Socket ����ػ��շ�ֵ��ͨ������Ϊ Socket ����ش�С�� 3 ���� */ }
procedure HP_Agent_SetFreeSocketObjHold(pAgent: HP_Agent;
  dwFreeSocketObjHold: LongInt); stdcall; external HPSocketDLL;
{ /* �����ڴ�黺��ػ��շ�ֵ��ͨ������Ϊ�ڴ�黺��ش�С�� 3 ���� */ }
procedure HP_Agent_SetFreeBufferObjHold(pAgent: HP_Agent;
  dwFreeBufferObjHold: LongInt); stdcall; external HPSocketDLL;
{ /* ���ù����߳�������ͨ������Ϊ 2 * CPU + 2�� */ }
procedure HP_Agent_SetWorkerThreadCount(pAgent: HP_Agent;
  dwWorkerThreadCount: LongInt); stdcall; external HPSocketDLL;
{ /* ���ùر����ǰ�ȴ����ӹرյ��ʱ�ޣ����룬0 �򲻵ȴ��� */ }
procedure HP_Agent_SetMaxShutdownWaitTime(pAgent: HP_Agent;
  dwMaxShutdownWaitTime: LongInt); stdcall; external HPSocketDLL;

{ /* ��ȡ���ݷ��Ͳ��� */ }
function HP_Agent_GetSendPolicy(pAgent: HP_Agent): En_HP_SendPolicy; stdcall;
  external HPSocketDLL;
{ /* ��ȡ���ݽ��ղ��� */ }
function HP_Agent_GetRecvPolicy(pAgent: HP_Agent): En_HP_RecvPolicy; stdcall;
  external HPSocketDLL;
{ /* ��ȡ Socket �����������ʱ�� */ }
function HP_Agent_GetFreeSocketObjLockTime(pAgent: HP_Agent): LongInt; stdcall;
  external HPSocketDLL;
{ /* ��ȡ Socket ����ش�С */ }
function HP_Agent_GetFreeSocketObjPool(pAgent: HP_Agent): LongInt; stdcall;
  external HPSocketDLL;
{ /* ��ȡ�ڴ�黺��ش�С */ }
function HP_Agent_GetFreeBufferObjPool(HpAgent: HP_Agent): LongInt; stdcall;
  external HPSocketDLL;
{ /* ��ȡ Socket ����ػ��շ�ֵ */ }
function HP_Agent_GetFreeSocketObjHold(pAgent: HP_Agent): LongInt; stdcall;
  external HPSocketDLL;
{ /* ��ȡ�ڴ�黺��ػ��շ�ֵ */ }
function HP_Agent_GetFreeBufferObjHold(pAgent: HP_Agent): LongInt; stdcall;
  external HPSocketDLL;
{ /* ��ȡ�����߳����� */ }
function HP_Agent_GetWorkerThreadCount(pAgent: HP_Agent): LongInt; stdcall;
  external HPSocketDLL;
{ /* ��ȡ�ر����ǰ�ȴ����ӹرյ��ʱ�� */ }
function HP_Agent_GetMaxShutdownWaitTime(pAgent: HP_Agent): LongInt; stdcall;
  external HPSocketDLL;

{ /**********************************************************************************/
  /******************************* TCP Agent �������� *******************************/ }

{ /*
  * ���ƣ�����С�ļ�
  * ��������ָ�����ӷ��� 4096 KB ���µ�С�ļ�
  *
  * ������		dwConnID		-- ���� ID
  *			lpszFileName	-- �ļ�·��
  *			pHead			-- ͷ����������
  *			pTail			-- β����������
  * ����ֵ��	TRUE	-- �ɹ�
  *			FALSE	-- ʧ�ܣ���ͨ�� Windows API ���� ::GetLastError() ��ȡ Windows �������
  */ }
function HP_TcpAgent_SendSmallFile(pAgent: HP_Agent; dwConnID: HP_CONNID;
  lpszFileName: PWideChar; const pHead: LPWSABUF; const pTail: LPWSABUF): BOOL;
  stdcall; external HPSocketDLL;

{ /**********************************************************************************/
  /***************************** TCP Agent ���Է��ʷ��� *****************************/ }

{ /* �����Ƿ����õ�ַ���û��ƣ�Ĭ�ϣ������ã� */ }
procedure HP_TcpAgent_SetReuseAddress(pAgent: HP_TcpAgent; bReuseAddress: BOOL);
  stdcall; external HPSocketDLL;
{ /* ����Ƿ����õ�ַ���û��� */ }
function HP_TcpAgent_IsReuseAddress(pAgent: HP_TcpAgent): BOOL; stdcall;
  external HPSocketDLL;

{ /* ����ͨ�����ݻ�������С������ƽ��ͨ�����ݰ���С�������ã�ͨ������Ϊ 1024 �ı����� */ }
procedure HP_TcpAgent_SetSocketBufferSize(pAgent: HP_TcpAgent;
  dwSocketBufferSize: LongInt); stdcall; external HPSocketDLL;
{ /* ������������������룬0 �򲻷����������� */ }
procedure HP_TcpAgent_SetKeepAliveTime(pAgent: HP_TcpAgent;
  dwKeepAliveTime: LongInt); stdcall; external HPSocketDLL;
{ /* ��������ȷ�ϰ�����������룬0 ������������������������ɴ� [Ĭ�ϣ�WinXP 5 ��, Win7 10 ��] ��ⲻ������ȷ�ϰ�����Ϊ�Ѷ��ߣ� */ }
procedure HP_TcpAgent_SetKeepAliveInterval(pAgent: HP_TcpAgent;
  dwKeepAliveInterval: LongInt); stdcall; external HPSocketDLL;

{ /* ��ȡͨ�����ݻ�������С */ }
function HP_TcpAgent_GetSocketBufferSize(pAgent: HP_TcpAgent): LongInt; stdcall;
  external HPSocketDLL;
{ /* ��ȡ���������� */ }
function HP_TcpAgent_GetKeepAliveTime(pAgent: HP_TcpAgent): LongInt; stdcall;
  external HPSocketDLL;
{ /* ��ȡ��������� */ }
function HP_TcpAgent_GetKeepAliveInterval(pAgent: HP_TcpAgent): LongInt;
  stdcall; external HPSocketDLL;

{ /***************************************************************************************/
  /***************************** TCP Pull Server ����������� *****************************/ }

{ /*
  * ���ƣ�ץȡ����
  * �������û�ͨ���÷����� Socket �����ץȡ����
  *
  * ������		dwConnID	-- ���� ID
  *			pBuffer		-- ����ץȡ������
  *			iLength		-- ץȡ���ݳ���
  * ����ֵ��	En_HP_FetchResult
  */ }
function HP_TcpPullServer_Fetch(pServer: HP_TcpPullServer; dwConnID: HP_CONNID;
  pBuffer: Pointer; iLength: Integer): En_HP_FetchResult; stdcall;
  external HPSocketDLL;

{ /***************************************************************************************/
  /***************************** TCP Pull Server ���Է��ʷ��� *****************************/ }

{ /***************************************************************************************/
  /***************************** TCP Pull Client ����������� *****************************/ }

{ /*
  * ���ƣ�ץȡ����
  * �������û�ͨ���÷����� Socket �����ץȡ����
  *
  * ������		dwConnID	-- ���� ID
  *			pBuffer		-- ����ץȡ������
  *			iLength		-- ץȡ���ݳ���
  * ����ֵ��	En_HP_FetchResult
  */ }
function HP_TcpPullClient_Fetch(pClient: HP_TcpPullClient; dwConnID: HP_CONNID;
  pBuffer: Pointer; iLength: Integer): En_HP_FetchResult; stdcall;
  external HPSocketDLL;

{ /***************************************************************************************/
  /***************************** TCP Pull Client ���Է��ʷ��� *****************************/ }

{ /***************************************************************************************/
  /***************************** TCP Pull Agent ����������� *****************************/ }

{ /*
  * ���ƣ�ץȡ����
  * �������û�ͨ���÷����� Socket �����ץȡ����
  *
  * ������		dwConnID	-- ���� ID
  *			pBuffer		-- ����ץȡ������
  *			iLength		-- ץȡ���ݳ���
  * ����ֵ��	En_HP_FetchResult
  */ }
function HP_TcpPullAgent_Fetch(pAgent: HP_TcpPullAgent; dwConnID: HP_CONNID;
  pBuffer: Pointer; iLength: Integer): En_HP_FetchResult; stdcall;
  external HPSocketDLL;

{ /***************************************************************************************/
  /***************************** TCP Pull Agent ���Է��ʷ��� *****************************/ }

{ /***************************************************************************************/
  /*************************************** �������� ***************************************/ }

{ /* ��ȡ���������ı� */ }
function HP_GetSocketErrorDesc(enCode: En_HP_SocketError): PWideChar; stdcall;
  external HPSocketDLL;
{ /* ����ϵͳ�� ::GetLastError() ������ȡϵͳ������� */ }
function SYS_GetLastError(): LongInt; stdcall; external HPSocketDLL;
// ����ϵͳ�� ::WSAGetLastError() ������ȡͨ�Ŵ������
function SYS_WSAGetLastError(): Integer; stdcall; external HPSocketDLL;
// ����ϵͳ�� setsockopt()
function SYS_SetSocketOption(sock: SOCKET; level: Integer; name: Integer;
  val: LPVOID; len: Integer): Integer; stdcall; external HPSocketDLL;
// ����ϵͳ�� getsockopt()
function SYS_GetSocketOption(sock: SOCKET; level: Integer; name: Integer;
  val: LPVOID; len: PInteger): Integer; stdcall; external HPSocketDLL;
// ����ϵͳ�� ioctlsocket()
function SYS_IoctlSocket(sock: SOCKET; cmd: LongInt; arg: PULONG): Integer;
  stdcall; external HPSocketDLL;
// ����ϵͳ�� ::WSAIoctl()
function SYS_WSAIoctl(sock: SOCKET; dwIoControlCode: LongInt;
  lpvInBuffer: LPVOID; cbInBuffer: LongInt; lpvOutBuffer: LPVOID;
  cbOutBuffer: LongInt; lpcbBytesReturned: LPDWORD): Integer; stdcall;
  external HPSocketDLL;

implementation

end.
