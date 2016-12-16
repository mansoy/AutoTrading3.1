unit uFrmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Forms,
  Vcl.AppEvnts, ShellApi, System.DateUtils,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, dxBarBuiltInMenu, Vcl.Menus,
  cxCustomData, cxStyles, cxTL, cxTextEdit, cxTLdxBarBuiltInMenu, cxFilter, cxData, cxDataStorage, cxEdit, cxNavigator,
  cxContainer, cxEditRepositoryItems, cxClasses, Vcl.ExtCtrls, System.ImageList, Vcl.ImgList, Vcl.Controls,
  System.Actions, Vcl.ActnList, Vcl.ComCtrls, Vcl.ToolWin, Vcl.StdCtrls, cxMaskEdit, cxSpinEdit, cxGridLevel,
  cxGridCustomTableView, cxGridTableView, cxGridBandedTableView, cxGridCustomView, cxGrid, cxSplitter,
  cxInplaceContainer, cxButtons, cxPC,
  uDToolServer,
  uGlobal,
  uTaskManager,
  uJsonClass
  ;
  
type
  TDisaptchTask = procedure of object;

  TFrmMain = class(TForm)
    StatusBar1: TStatusBar;
    cxPageControl1: TcxPageControl;
    tsConsole: TcxTabSheet;
    tsLog: TcxTabSheet;
    ActionList1: TActionList;
    memLog: TMemo;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    ActParamSet: TAction;
    ActModifyPwd: TAction;
    ActExit: TAction;
    N8: TMenuItem;
    N9: TMenuItem;
    ActChangeAccount: TAction;
    PopupMenu1: TPopupMenu;
    ActShowLog: TAction;
    ActKillTask: TAction;
    ActSupperTask: TAction;
    N10: TMenuItem;
    N11: TMenuItem;
    N12: TMenuItem;
    Panel2: TPanel;
    GroupBox5: TGroupBox;
    btnDelTask: TcxButton;
    btnDelAllTask: TcxButton;
    cxSplitter1: TcxSplitter;
    Panel3: TPanel;
    GroupBox2: TGroupBox;
    Panel1: TPanel;
    edtQuery: TcxTextEdit;
    Panel4: TPanel;
    GroupBox4: TGroupBox;
    Label1: TLabel;
    edtPort: TcxSpinEdit;
    chk��ʼ����: TCheckBox;
    GroupBox3: TGroupBox;
    chk����: TCheckBox;
    chk���: TCheckBox;
    N13: TMenuItem;
    N14: TMenuItem;
    ActLogout: TAction;
    ActReStart: TAction;
    ActShutDown: TAction;
    N15: TMenuItem;
    N16: TMenuItem;
    N17: TMenuItem;
    PopupMenu2: TPopupMenu;
    ActShowForm: TAction;
    N18: TMenuItem;
    N19: TMenuItem;
    N20: TMenuItem;
    ActSetEnabled: TAction;
    ActFind: TAction;
    Img16: TImageList;
    ActCleanLog: TAction;
    ActCleanAllLog: TAction;
    N21: TMenuItem;
    N22: TMenuItem;
    N23: TMenuItem;
    Ima32: TImageList;
    ImaDis32: TImageList;
    ActReStartTask: TAction;
    N24: TMenuItem;
    chk�ֲ�: TCheckBox;
    ActOverOrder: TAction;
    N25: TMenuItem;
    ApplicationEvents1: TApplicationEvents;
    ActDelSendMachine: TAction;
    ActForceKillTask: TAction;
    N26: TMenuItem;
    N27: TMenuItem;
    Timer1: TTimer;
    ActRestrore: TAction;
    N28: TMenuItem;
    N29: TMenuItem;
    ActCopyAccount: TAction;
    N30: TMenuItem;
    ActOrderItem: TAction;
    N32: TMenuItem;
    cxStyleRepository1: TcxStyleRepository;
    cxStyle1: TcxStyle;
    ActReStartAll: TAction;
    ActShutDownAll: TAction;
    ActLogoutAll: TAction;
    ActKillTaskAll: TAction;
    ActUpdateSendMachine: TAction;
    ActUpdateGameClient: TAction;
    Img16_1: TImageList;
    cxEditRepository1: TcxEditRepository;
    cxEditRepository1ImageComboBoxItem1: TcxEditRepositoryImageComboBoxItem;
    N33: TMenuItem;
    ActDataProcess: TAction;
    N34: TMenuItem;
    chk�ʼ�: TCheckBox;
    Panel5: TPanel;
    ToolBar1: TToolBar;
    ToolButton5: TToolButton;
    ToolButton10: TToolButton;
    ToolButton7: TToolButton;
    ToolButton9: TToolButton;
    ToolButton8: TToolButton;
    ToolButton4: TToolButton;
    ToolButton2: TToolButton;
    ToolButton15: TToolButton;
    ToolButton13: TToolButton;
    ToolButton11: TToolButton;
    ToolButton1: TToolButton;
    ToolButton12: TToolButton;
    ToolButton6: TToolButton;
    ToolButton3: TToolButton;
    ImgCbSendMachineState: TcxEditRepositoryImageComboBoxItem;
    tlOrders: TcxTreeList;
    tlOrdersSendNum: TcxTreeListColumn;
    tlOrdersAccount: TcxTreeListColumn;
    tlOrdersRole: TcxTreeListColumn;
    tlOrdersReceiptRole: TcxTreeListColumn;
    tlOrdersStock: TcxTreeListColumn;
    cxStyle2: TcxStyle;
    pnlGrid: TPanel;
    ImgRoleState: TcxEditRepositoryImageComboBoxItem;
    Lv: TcxGridLevel;
    cxGrid1: TcxGrid;
    Tv: TcxGridBandedTableView;
    TvGroupName: TcxGridBandedColumn;
    TvOrderNo: TcxGridBandedColumn;
    TvGameSvr: TcxGridBandedColumn;
    TvSaleNum: TcxGridBandedColumn;
    TvState: TcxGridBandedColumn;
    TvLogMsg: TcxGridBandedColumn;
    TvInterval: TcxGridBandedColumn;
    TvConnItem: TcxGridBandedColumn;
    ActShowDetail: TAction;
    LvDetail: TcxGridLevel;
    cxGrid2: TcxGrid;
    TvDetail: TcxGridBandedTableView;
    TvDetailAccount: TcxGridBandedColumn;
    TvDetailSendNum: TcxGridBandedColumn;
    TvDetailStock: TcxGridBandedColumn;
    TvDetailRole: TcxGridBandedColumn;
    TvDetailReceiptRole: TcxGridBandedColumn;
    TvDetailState: TcxGridBandedColumn;
    TvDetailLogMsg: TcxGridBandedColumn;
    TvDetailRoleItem: TcxGridBandedColumn;
    memLogs: TMemo;
    ActSetException: TAction;
    N35: TMenuItem;
    N36: TMenuItem;
    TrayIcon1: TTrayIcon;
    N31: TMenuItem;
    TvAccType: TcxGridBandedColumn;
    N37: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure Action1Execute(Sender: TObject);
    procedure ActParamSetExecute(Sender: TObject);
    procedure ActModifyPwdExecute(Sender: TObject);
    procedure ActExitExecute(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure chk��ʼ����Click(Sender: TObject);
    procedure edtQueryEnter(Sender: TObject);
    procedure edtQueryExit(Sender: TObject);
    procedure edtQueryKeyPress(Sender: TObject; var Key: Char);
    procedure btnDelTaskClick(Sender: TObject);
    procedure chk����Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure ActShowFormExecute(Sender: TObject);
    procedure ActShowLogExecute(Sender: TObject);
    procedure ActLogoutExecute(Sender: TObject);
    procedure ActReStartExecute(Sender: TObject);
    procedure ActShutDownExecute(Sender: TObject);
    procedure ActKillTaskExecute(Sender: TObject);
    procedure ActSupperTaskExecute(Sender: TObject);
    procedure ActSetEnabledExecute(Sender: TObject);
    procedure ActFindExecute(Sender: TObject);
    procedure ActCleanLogExecute(Sender: TObject);
    procedure ActCleanAllLogExecute(Sender: TObject);
    procedure btnDelAllTaskClick(Sender: TObject);
    procedure ActReStartTaskExecute(Sender: TObject);
    procedure pgTaskListChange(Sender: TObject);
    procedure ActOverOrderExecute(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure ActCopyAccountExecute(Sender: TObject);
    procedure ActReStartAllExecute(Sender: TObject);
    procedure ActShutDownAllExecute(Sender: TObject);
    procedure ActLogoutAllExecute(Sender: TObject);
    procedure ActKillTaskAllExecute(Sender: TObject);
    procedure ActUpdateSendMachineExecute(Sender: TObject);
    procedure ActUpdateGameClientExecute(Sender: TObject);
    procedure ActDataProcessExecute(Sender: TObject);
    procedure TvDataControllerNewRecord(ADataController: TcxCustomDataController; ARecordIndex: Integer);
    procedure TvDblClick(Sender: TObject);
    procedure TvIntervalGetDisplayText(Sender: TcxCustomGridTableItem; ARecord: TcxCustomGridRecord; var AText: string);
    procedure TvCustomDrawCell(Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;
      AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
    procedure TvFocusedRecordChanged(Sender: TcxCustomGridTableView; APrevFocusedRecord,
      AFocusedRecord: TcxCustomGridRecord; ANewItemRecordFocusingChanged: Boolean);
    procedure TvCellClick(Sender: TcxCustomGridTableView; ACellViewInfo: TcxGridTableDataCellViewInfo;
      AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
    procedure ActShowDetailExecute(Sender: TObject);
    procedure ActSetExceptionExecute(Sender: TObject);
    procedure ActOrderItemExecute(Sender: TObject);
    procedure ActDelSendMachineExecute(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    //FIsGetTask: Boolean;
    bSuppend: Boolean;
    FConnItem: TConnItem;
    procedure HideForm(Sender: TObject);
    procedure RestoreForm(Sender: TObject);
    procedure UpdateStatusBar;

    function Get����״̬: string;

    procedure Init;

    //--��ʾ��������¼
    function fnShowLogMemo(): Boolean;
    //--ɾ����־�ؼ�
    //function fnDelLogMemo(AName: string): Boolean;
    //--�����־�ؼ�
    //function fnAddLogMemo(AName: string): Boolean;

    procedure WmAddLogMsg(var Msg: TMessage); message WM_ADD_LOG;

    //--��������
    procedure WmAddOrder(var Msg: TMessage); message WM_ADD_ORDER;
    procedure WmDelOrder(var Msg: TMessage); message WM_DEL_ORDER;

    procedure WmAddSendMachine(var Msg: TMessage); message WM_ADD_SEND_MACHINE;
    procedure WmDelSendMachine(var Msg: TMessage); message WM_DEL_SEND_MACHINE;

    procedure WmUpdateConnUI(var Msg: TMessage); message WM_UPDATE_CONN_UI;
    procedure WmUpdateTaskUI(var Msg: TMessage); message WM_UPDATE_TASK_UI;

    procedure LoadCfg;
    function GetFocuseConnItem: TConnItem;
  public
    { Public declarations }
  end;

  TWorkTask = class(TThread)
  private
    //b������: Boolean;
    function GetOrderNoLst(): string;
    function DispatchFcOrder(AFcOrderItem: TFcOrderItem):Boolean;
    function DispatchOrders(AOrders: string): Boolean;
  protected
    procedure Execute; override;
  public
    DispatchTask: TDisaptchTask;
    constructor Create(); overload;
    destructor Destroy; override;
  end;

var
  FrmMain: TFrmMain;
  NIData      : TNotifyIconData;
  GCloseConsole: Boolean = False;

implementation

uses
  System.StrUtils,
  IdHTTP,
  uCommand,
  uFrmParamSet,
  uFrmUpdateDataBase,
  uFrmOrderItem,
  ManSoy.Global,
  ManSoy.MsgBox,
  ManSoy.Encode,
  HPSocketSDKUnit
  ;

{$R *.dfm}

procedure TFrmMain.btnDelAllTaskClick(Sender: TObject);
var
  i: Integer;
  vOrderItem: TOrderItem;
begin
  bSuppend := True;
  try
    if ManSoy.MsgBox.AskMsg(Self.Handle, 'ȷ��ɾ�����ж����е�������?', []) <> IDYES then Exit;
    if tlOrders.Count = 0 then Exit;
    for I := tlOrders.Count - 1 downto 0 do
    begin
      vOrderItem := TOrderItem(tlOrders.Items[I].Data);
      if vOrderItem = nil then Exit;
      TaskManager.DelByKey(vOrderItem.orderNo);
    end;
  finally
    bSuppend := False;
  end;
end;

procedure TFrmMain.btnDelTaskClick(Sender: TObject);
var
  vOrderItem: TOrderItem;
  I: Integer;
begin
  bSuppend := True;
  try
    if ManSoy.MsgBox.AskMsg(Self.Handle, 'ȷ��ɾ����ǰ�����е�������?', []) <> IDYES then Exit;
    if tlOrders.FocusedNode = nil then Exit;
    vOrderItem := TOrderItem(tlOrders.FocusedNode.Data);
    if vOrderItem = nil then Exit;
    TaskManager.DelByKey(vOrderItem.orderNo);
  finally
    bSuppend := False;
  end;
end;

procedure TFrmMain.Button1Click(Sender: TObject);
begin

end;

{$REGION 'Action�¼�'}

//---�Ҽ��˵�

procedure TFrmMain.ActShowLogExecute(Sender: TObject);
begin
  memLogs.Visible := not memLogs.Visible;
  if memLogs.Visible then
    fnShowLogMemo
  else
    memLogs.Visible := False;
end;

procedure TFrmMain.ActSupperTaskExecute(Sender: TObject);
var
  vConnItem: TConnItem;
begin
  vConnItem := GetFocuseConnItem;
  if vConnItem = nil then Exit;
  if vConnItem.State <> sms��æ then Exit;
  if vConnItem.OrderItem = nil then Exit;
  ConsoleSvr.SuspendTask(vConnItem.ConnID, vConnItem.GroupName);
  vConnItem.Suspend := True;
end;

procedure TFrmMain.ActUpdateGameClientExecute(Sender: TObject);
begin
  //ConnManager.UpdateGameClient;
end;

procedure TFrmMain.ActUpdateSendMachineExecute(Sender: TObject);
begin
  //ConnManager.UpdateClient;
end;

procedure TFrmMain.ActReStartTaskExecute(Sender: TObject);
var
  vConnItem: TConnItem;
begin
  vConnItem := GetFocuseConnItem;
  if vConnItem = nil then Exit;
  if vConnItem.State <> sms��æ then Exit;
  if vConnItem.OrderItem = nil then Exit;
  ConsoleSvr.ResumeTask(vConnItem.ConnID, vConnItem.GroupName);
  vConnItem.Suspend := False;
end;

procedure TFrmMain.ActKillTaskAllExecute(Sender: TObject);
var
  vConnItem: TConnItem;
begin
  vConnItem := GetFocuseConnItem;
  if vConnItem = nil then Exit;
end;

procedure TFrmMain.ActKillTaskExecute(Sender: TObject);
var
  vConnItem: TConnItem;
begin
  vConnItem := GetFocuseConnItem;
  if vConnItem = nil then Exit;
  if vConnItem.State <> sms��æ then Exit;
  if vConnItem.OrderItem = nil then Exit;
  ConsoleSvr.StopTask(vConnItem.ConnID, vConnItem.GroupName);
end;

procedure TFrmMain.ActOrderItemExecute(Sender: TObject);
var
  vConnItem: TConnItem;
begin
  vConnItem := GetFocuseConnItem;
  if vConnItem = nil then Exit;
  if vConnItem.State <> sms��æ then Exit;
  uFrmOrderItem.fnShowOrderItem(vConnItem);
end;

procedure TFrmMain.ActOverOrderExecute(Sender: TObject);
var
  vConnItem: TConnItem;
  sOrderNo: string;
begin
  //==������ǰ��������������====================
  vConnItem := GetFocuseConnItem;
  if vConnItem = nil then Exit;
  if vConnItem.State <> sms��æ then Exit;
  ConnManager.StopAllTask(vConnItem.OrderItem.orderNo);
  TaskManager.DelQueueByOrderNo(vConnItem.OrderItem.orderNo);
end;

procedure TFrmMain.ActLogoutAllExecute(Sender: TObject);
begin
  ConnManager.LogoutAll;
end;

procedure TFrmMain.ActLogoutExecute(Sender: TObject);
var
  vConnItem: TConnItem;
begin
  vConnItem := GetFocuseConnItem;
  if vConnItem = nil then Exit;
  if vConnItem.State = sms��æ then Exit;
  ConsoleSvr.LogOff(vConnItem.ConnID, vConnItem.GroupName);
end;

procedure TFrmMain.ActReStartAllExecute(Sender: TObject);
begin
  ConnManager.ReBootAll;
end;

procedure TFrmMain.ActReStartExecute(Sender: TObject);
var
  vConnItem: TConnItem;
begin
  vConnItem := GetFocuseConnItem;
  if vConnItem = nil then Exit;
  if vConnItem.State = sms��æ then Exit;
  ConsoleSvr.ReBoot(vConnItem.ConnID, vConnItem.GroupName);
end;

procedure TFrmMain.ActShutDownAllExecute(Sender: TObject);
begin
  ConnManager.ShutDownAll;
end;

procedure TFrmMain.ActShutDownExecute(Sender: TObject);
var
  vConnItem: TConnItem;
begin
  vConnItem := GetFocuseConnItem;
  if vConnItem = nil then Exit;
  if vConnItem.State = sms��æ then Exit;
  ConsoleSvr.Shutdown(vConnItem.ConnID, vConnItem.GroupName);
end;

//--���˵�
procedure TFrmMain.ActParamSetExecute(Sender: TObject);
begin
  uFrmParamSet.OpenParamSet(Self);
end;

procedure TFrmMain.ActSetEnabledExecute(Sender: TObject);
var
  vConnItem: TConnItem;
begin
  ActShowLog.Enabled    := False;
  ActSupperTask.Enabled := False;
  ActReStartTask.Enabled:= False;
  ActKillTask.Enabled   := False;
  ActKillTaskAll.Enabled:= False;
  ActLogout.Enabled     := False;
  ActReStart.Enabled    := False;
  ActShutDown.Enabled   := False;
  ActCleanLog.Enabled   := False;
  ActRestrore.Enabled   := False;

  //=======================================
  ActCleanAllLog.Enabled:= Tv.DataController.RecordCount > 0;
  vConnItem := GetFocuseConnItem;
  if vConnItem = nil then Exit;
  ActShowLog.Enabled    := True;
  ActCleanLog.Enabled   := True;
  ActSupperTask.Enabled := (not vConnItem.Suspend) and (vConnItem.State = sms��æ);
  ActReStartTask.Enabled:= vConnItem.Suspend and (vConnItem.State = sms��æ);
  ActKillTask.Enabled   := (vConnItem.State = sms��æ);
  ActKillTaskAll.Enabled:= ActKillTask.Enabled;
  ActLogout.Enabled     := (vConnItem.State = sms����);
  ActCleanLog.Enabled   := False;
  ActReStart.Enabled    := ActLogout.Enabled;
  ActRestrore.Enabled   := vConnItem.State = sms�쳣;
  ActShutDown.Enabled   := ActLogout.Enabled;
  {$IFNDEF _MS_DEBUG}
  ActCopyAccount.Enabled:= (vConnItem.State = sms��æ);
  {$ENDIF}
end;

procedure TFrmMain.ActSetExceptionExecute(Sender: TObject);
var
  I: Integer;
  iTaskType: Integer;
  sRet: string;
begin
  iTaskType := TAction(Sender).ActionComponent.Tag;

  if ConsoleSvr.AppState <> ST_STOPED then
  begin
    ManSoy.MsgBox.WarnMsg(Self.Handle, '������ȡ����������ִ�б��β�����', []);
    Exit;
  end;

  if ConnManager.Count > 0 then
  begin
    ManSoy.MsgBox.WarnMsg(Self.Handle, '��Ͽ����з���������ִ�б��β�����', []);
    Exit;
  end;

  if TaskManager.Count > 0 then
  begin
    ManSoy.MsgBox.WarnMsg(Self.Handle, '�����������񣬲���ִ�б��β�����', []);
    Exit;
  end;

  if ManSoy.MsgBox.AskMsg(Self.Handle, 'ȷ��ִ�����쳣������',[]) <> IDYES then Exit;
  { TODO : ִ���쳣���� }

  sRet := uCommand.SetException(GConsoleSet.ConsoleID, iTaskType, tsFail, '��Ϊ���쳣');
  if '0' <> sRet then
  begin
    ManSoy.MsgBox.InfoMsg(Self.Handle, '���쳣����ʧ��'#13''#13'%s',[sRet]);
    Exit;
  end;

  ManSoy.MsgBox.InfoMsg(Self.Handle, '���쳣�������',[]);
end;

procedure TFrmMain.ActShowDetailExecute(Sender: TObject);
var
  vConnItem: TConnItem;
  vNode: TcxTreeListNode;
  vRoleItem: TRoleItem;
begin
  //--
  vConnItem := GetFocuseConnItem;
  if vConnItem = nil then Exit;
  FConnItem := vConnItem;
  fnShowLogMemo;
  TvDetail.DataController.BeginFullUpdate;
  try
    TvDetail.DataController.RecordCount := 0;

    vConnItem := TConnItem(DWORD(Tv.DataController.Values[Tv.DataController.FocusedRecordIndex, TvConnItem.Index]));
    if vConnItem = nil then Exit;
    if vConnItem.OrderItem = nil then Exit;

    for vRoleItem in vConnItem.OrderItem.roles do
    begin
      TvDetail.DataController.RecordCount := TvDetail.DataController.RecordCount + 1;
      TvDetail.DataController.Values[TvDetail.DataController.RecordCount - 1, TvDetailRoleItem.Index] := DWORD(vRoleItem);
    end;
    SendMessage(GSharedInfo.MainFormHandle, WM_UPDATE_CONN_UI, 0, LPARAM(vConnItem.GroupName));
  finally
    TvDetail.DataController.EndFullUpdate;
  end;
end;

procedure TFrmMain.ActShowFormExecute(Sender: TObject);
begin
  if not Self.Visible then
    RestoreForm(Sender)
  else
    HideForm(Sender);
end;

procedure TFrmMain.ActCleanAllLogExecute(Sender: TObject);
begin
  ConnManager.ClearAllLog;
end;

procedure TFrmMain.ActCleanLogExecute(Sender: TObject);
var
  vConnItem: TConnItem;
  vMemo: TMemo;
begin
  vConnItem := GetFocuseConnItem;
  if vConnItem = nil then Exit;
  ConnManager.ClearLog(vConnItem.GroupName);
end;

procedure TFrmMain.ActCopyAccountExecute(Sender: TObject);
var
  vConnItem: TConnItem;
begin
  //--
  vConnItem := GetFocuseConnItem;
  if vConnItem = nil then Exit;
  if vConnItem.OrderItem = nil then Exit;

  {$IFNDEF _MS_DEBUG}
  ManSoy.Global.WriteClipboard(vConnItem.OrderItem.roles[0].Role);
  {$ELSE}
  ManSoy.Global.WriteClipboard('123456');
  {$ENDIF}
end;

procedure TFrmMain.ActDataProcessExecute(Sender: TObject);
begin
  with TFrmUpdateDataBase.Create(Self) do
  try
    ShowModal;
  finally
    Free;
  end;
end;

procedure TFrmMain.ActDelSendMachineExecute(Sender: TObject);
var
  vConnItem: TConnItem;
  bIsEque: Boolean;
begin
  if Tv.DataController.FocusedRecordIndex = -1 then Exit;
  try
    vConnItem := TConnItem(DWORD(Tv.DataController.Values[Tv.DataController.FocusedRecordIndex, TvConnItem.Index]));
    if vConnItem = nil then Exit;
    //if vConnItem.State = sms��æ then
    //begin
    //  ManSoy.MsgBox.WarnMsg(GSharedInfo.MainFormHandle, '��ǰ״̬�²���ɾ�����������ӣ�', []);
    //  Exit;
    //end;
    if IDYES <> ManSoy.MsgBox.AskMsg(GSharedInfo.MainFormHandle, 'ȷ��ɾ����ǰ������������', []) then Exit;
    if FConnItem <> nil then
      bIsEque := vConnItem.GroupName = FConnItem.GroupName;

    Tv.DataController.BeginFullUpdate;
    try
      Tv.DataController.DeleteRecord(Tv.DataController.FocusedRecordIndex);
      ConnManager.Del(vConnItem.GroupName);
      if bIsEque then FConnItem := nil;
    finally
      Tv.DataController.EndFullUpdate;
    end;
  except
  end;
end;

procedure TFrmMain.ActExitExecute(Sender: TObject);
begin
  raise Exception.Create('����һ���쳣��');
//  if (Tv.DataController.FocusedRecordIndex < 0) then
//  begin
//    Tv.Focused := True;
//  end;
//  Self.Close;
end;

procedure TFrmMain.ActFindExecute(Sender: TObject);
var
  sText: string;
  I: Integer;
begin
  if Tv.DataController.RecordCount <= 0 then Exit;
  sText := Trim(edtQuery.Text);
  if sText = '' then Exit;
  if sText = 'ͨ�����ʶ������������ɫ�ȿ��ٶ�λ������' then Exit;
  try
    for I := Tv.DataController.RecordCount - 1 downto 0 do
    begin
      if (Tv.DataController.Values[I, TvOrderNo.Index] = sText) or
         (Tv.DataController.Values[I, TvGroupName.Index] = sText) or
         (Tv.DataController.Values[I, TvGameSvr.Index] = sText) //or
         //(tvMaster.DataController.Values[i, tvMasterRole.Index] = sText)
      then
      Tv.DataController.FocusedRecordIndex := I;
      Break;
    end;
  except

  end;
end;

procedure TFrmMain.Action1Execute(Sender: TObject);
begin
  //
end;

procedure TFrmMain.ActModifyPwdExecute(Sender: TObject);
begin
  //�������޸�ҳ��
end;

{$ENDREGION}

procedure TFrmMain.chk��ʼ����Click(Sender: TObject);
begin
  ConsoleSvr.Host := '0.0.0.0';
  ConsoleSvr.Port := edtPort.Value;
  if TCheckBox(Sender).Checked then
  begin
    ConsoleSvr.Start;
  end else
  begin
    //ListenerThread.Suspend;
    ConsoleSvr.Stop;

    chk����.Checked := False;
    chk�ֲ�.Checked := False;
    chk���.Checked := False;
    chk�ʼ�.Checked := False;
    GSharedInfo.TaskType := ttNormal;
  end;
  GroupBox3.Enabled := ConsoleSvr.AppState = ST_STARTED;
end;

procedure TFrmMain.chk����Click(Sender: TObject);
var
  iTag: Integer;
  bIsRunning: Boolean;
begin
  iTag := TCheckBox(Sender).Tag;
  if TCheckBox(Sender).Checked then
  begin
    chk����.Checked := iTag = 0;
    chk�ֲ�.Checked := iTag = 1;
    chk���.Checked := iTag = 2;
    chk�ʼ�.Checked := iTag = 3;
    GSharedInfo.TaskType := TTaskType(iTag);
  end;
  bIsRunning := chk����.Checked or chk���.Checked or chk�ֲ�.Checked or chk�ʼ�.Checked;
  if not bIsRunning then GSharedInfo.TaskType := ttNormal;
  TvAccType.Visible := chk�ֲ�.Checked;
end;

procedure TFrmMain.edtQueryEnter(Sender: TObject);
begin
  if TcxTextEdit(Sender).Text = 'ͨ�����ʶ������������ɫ�ȿ��ٶ�λ������' then
  begin
    TcxTextEdit(Sender).Text := '';
    TcxTextEdit(Sender).Style.Font.Color := clWindowText;
  end;
end;

procedure TFrmMain.edtQueryExit(Sender: TObject);
begin
  if TcxTextEdit(Sender).Text = '' then
  begin
    TcxTextEdit(Sender).Text := 'ͨ�����ʶ������������ɫ�ȿ��ٶ�λ������';
    TcxTextEdit(Sender).Style.Font.Color := clBtnShadow;
  end;
end;

procedure TFrmMain.edtQueryKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    ActFind.Execute;
  end;
end;

function TFrmMain.fnShowLogMemo: Boolean;
var
  vMemo: TMemo;
  vConnItem: TConnItem;
begin
  vConnItem := GetFocuseConnItem;
  if not memLogs.Visible then Exit;
  memLogs.Lines.Clear;
  memLogs.Lines.Assign(vConnItem.LogMsgs);
  Result := True;
end;

procedure TFrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
{$IFNDEF _MS_DEBUG}
var
  bCanClose: Boolean;
  i: Integer;
{$ENDIF}
begin
  {$IFNDEF _MS_DEBUG}
  bCanClose := True;
  //--����з�æ�ļ�¼
  bCanClose := ConnManager.GetFreeCount = ConnManager.Count;
  if not bCanClose then
  begin
    ManSoy.MsgBox.WarnMsg(Self.Handle, '��������ִ���е����񣬲����˳�!', []);
    CanClose := bCanClose;
  end;
  {$ELSE}
  CanClose := ManSoy.MsgBox.AskMsg(Self.Handle, 'ȷ���˳�����̨��', []) = IDYES;
  {$ENDIF}
end;

procedure TFrmMain.Init;
begin
  GSharedInfo.MainFormHandle := Self.Handle;
  //cxPageControl.HideTabs := True;
  memLog.Lines.Clear;
  cxPageControl1.ActivePageIndex := 0;
  ConsoleSvr := TConsoleSvr.Create;
//  MainFormHandle := Self.Handle;
  //--------------------------------------------------
//  InitializeCriticalSection(CS_�����);
//  InitializeCriticalSection(CS_����);
//  InitializeCriticalSection(CS_�������);
//  InitializeCriticalSection(CS_�������);
  //--------------------------------------------------
  UpdateStatusBar;
end;

procedure TFrmMain.LoadCfg;
var
  SysCfg: string;
  vLst: TStrings;
begin
  vLst := TStringList.Create;
  try
    SysCfg := ExtractFilePath(ParamStr(0)) + 'Config';
    if not DirectoryExists(SysCfg) then ForceDirectories(SysCfg);
    SysCfg := Format('%s\SvrSysCfg.cfg', [SysCfg]);

    if FileExists(SysCfg) then vLst.LoadFromFile(SysCfg);

    try
      TSerizalizes.AsType<TConsoleSet>(vLst.Text, GConsoleSet);
    except
    end;

    if GConsoleSet = nil  then
    begin
      GConsoleSet := TConsoleSet.Create;
    end;
  finally
    FreeAndNil(vLst);
  end;
end;

procedure TFrmMain.FormCreate(Sender: TObject);
begin
  bSuppend := False;
  with TWorkTask.Create do
  begin
    Resume;
  end;
  Init;
  LoadCfg;
end;

procedure TFrmMain.FormDestroy(Sender: TObject);
begin
//  DeleteCriticalSection(CS_�����);
//  DeleteCriticalSection(CS_����);
//  DeleteCriticalSection(CS_�������);
//  DeleteCriticalSection(CS_�������);
//  ModifyTrayIcon(NIM_DELETE);
  GCloseConsole := True;
  ConsoleSvr.Stop;
end;

procedure TFrmMain.FormShow(Sender: TObject);
begin
  fnShowLogMemo;
end;

function TFrmMain.GetFocuseConnItem: TConnItem;
var
  v: Variant;
begin
  Result := nil;
  if Tv.DataController.RecordCount <= 0 then Exit;
  if Tv.DataController.FocusedRecordIndex < 0 then Exit;

  v := Tv.DataController.Values[Tv.DataController.FocusedRecordIndex, TvConnItem.Index];
  if VarIsNull(v) then Exit;
  Result := TConnItem(DWORD(v));
end;

function TFrmMain.Get����״̬: string;
begin
  if chk��ʼ����.Checked then
    Result := '���ڼ���'
  else
    Result := 'ֹͣ����';
end;

procedure TFrmMain.HideForm(Sender: TObject);
begin
  //Self.Visible := False;
  SetWindowPos(application.Handle,HWND_NOTOPMOST,0,0,0,0,SWP_HIDEWINDOW);
  hide;
end;

procedure TFrmMain.RestoreForm(Sender: TObject);
begin
  //Self.Visible := True;
  Show;
  SetWindowPos(Application.Handle,HWND_NOTOPMOST,0,0,0,0,SWP_HIDEWINDOW);
  //ShowWindow(Self.Handle, SC_RESTORE);
end;

procedure TFrmMain.pgTaskListChange(Sender: TObject);
begin
  //btnDelTask.Enabled    := pgTaskList.ActivePageIndex <> 0;
  //btnDelAllTask.Enabled := btnDelTask.Enabled;
end;

procedure TFrmMain.PopupMenu1Popup(Sender: TObject);
begin
  {$IFNDEF _MS_DEBUG}
  if Tv.DataController.FocusedRecordIndex < 0 then Abort;
  {$ENDIF}
  ActSetEnabled.Execute;
end;

procedure TFrmMain.Timer1Timer(Sender: TObject);
var
  I: Integer;
  vConnItem: TConnItem;
  dwMM, dwSS, dwInterval: DWORD;
begin
  if Tv.DataController.RecordCount <= 0 then Exit;
  Tv.DataController.BeginFullUpdate;
  try
    try
      //--��ʾ��־
      if FConnItem <> nil then
      begin
        if (memLogs.Lines.Count > 0) and (memLogs.Lines.Strings[memLogs.Lines.Count - 1] <> FConnItem.LogMsgs.Strings[FConnItem.LogMsgs.Count - 1])
          or ((memLogs.Lines.Count = 0) and (FConnItem.LogMsgs.Count > 0))
        then
        begin
          memLogs.Lines.BeginUpdate;
          memLogs.Lines.CommaText := FConnItem.LogMsgs.CommaText;
          memLogs.Perform(EM_LINESCROLL, 0, memLogs.Lines.Count);
          memLogs.Lines.EndUpdate;
        end;
      end;

      for I := Tv.DataController.RecordCount  - 1 downto 0 do
      begin
        Vcl.Forms.Application.ProcessMessages;
        vConnItem := TConnItem(DWORD(Tv.DataController.Values[I, TvConnItem.Index]));
        if vConnItem = nil then Continue;
        if vConnItem.State = sms��æ then
        begin
          if vConnItem.Interval = 0 then
          begin
            vConnItem.Interval := GetTickCount;
          end;
          dwInterval := GetTickCount - vConnItem.Interval;
          dwInterval := dwInterval div 1000;        //--�õ�����
          dwMM := dwInterval div 60;
          dwSS := dwInterval mod 60;
          Tv.DataController.Values[I, TvInterval.Index] := Format('%.2d:%.2d',[dwMM, dwSS]);
        end else
        begin
          vConnItem.Interval := 0;
          Tv.DataController.Values[I, TvInterval.Index] := 0;
        end;
      end;
    except
      on E: Exception do
      begin
        //AddLogMsg('��������ʱ��������: %s', [E.Message], True);
      end;
    end;
  finally
    Tv.DataController.EndFullUpdate;
    TTimer(Sender).Enabled := True;
  end;
end;

procedure TFrmMain.TvCellClick(Sender: TcxCustomGridTableView; ACellViewInfo: TcxGridTableDataCellViewInfo;
  AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
begin
  //--
  ActShowDetail.Execute;
end;

procedure TFrmMain.TvCustomDrawCell(Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;
  AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
var
  vConnItem: TConnItem;
begin
  vConnItem := TConnItem(DWORD(AViewInfo.GridRecord.Values[TvConnItem.Index]));
  if vConnItem = nil then Exit;
  if vConnItem.Suspend then
  begin
    ACanvas.Font.Color := clRed;
    ACanvas.Font.Style := ACanvas.Font.Style + [fsBold];
  end else if vConnItem.IsAbnormal then
  begin
    ACanvas.Font.Color := clBlue;
    ACanvas.Font.Style := ACanvas.Font.Style + [fsBold];
  end;
  //ADone := True;
end;

procedure TFrmMain.TvDataControllerNewRecord(ADataController: TcxCustomDataController; ARecordIndex: Integer);
begin
  ADataController.Values[ARecordIndex, TvConnItem.Index] := 0;
end;

procedure TFrmMain.TvDblClick(Sender: TObject);
begin
  ActOrderItem.Execute;
end;

procedure TFrmMain.TvFocusedRecordChanged(Sender: TcxCustomGridTableView; APrevFocusedRecord,
  AFocusedRecord: TcxCustomGridRecord; ANewItemRecordFocusingChanged: Boolean);
begin
  //--
  ActShowDetail.Execute;
end;

procedure TFrmMain.TvIntervalGetDisplayText(Sender: TcxCustomGridTableItem; ARecord: TcxCustomGridRecord;
  var AText: string);
begin
  if AText = '0' then AText := '';
end;

procedure TFrmMain.UpdateStatusBar;
begin
  StatusBar1.Panels[1].Text := Format('IP: %s',['�ȴ���ȡ...']);
//  StatusBar1.Panels[2].Text := Format('��ǰ�˺�: %s', [ParamSet.UserInfo.uiUserName]);
  StatusBar1.Panels[3].Text := Get����״̬;
end;

{$REGION '��Ϣ����'}
procedure TFrmMain.WmAddLogMsg(var Msg: TMessage);
begin
  memLog.Lines.Add(string(Msg.LParam));
end;

//--��������
procedure TFrmMain.WmAddOrder(var Msg: TMessage);
  procedure fnPostQueueState(AOrderItem: TOrderItem; ARoleItem: TRoleItem);
  var vState: TStatusItem;
  begin
    //֪ͨOA�������Ѿ��������̨
    //��������ţ����ø���
    if ARoleItem.isMain then Exit;
    vState := TStatusItem.Create;
    try
      vState.groupName := '';
      vState.rowId := ARoleItem.rowId;
      vState.orderNo := AOrderItem.orderNo;
      vState.taskType := AOrderItem.taskType;
      vState.roleId := ARoleItem.roleID;
      vState.isMain := ARoleItem.isMain;
      vState.state := GetStateNum(tsStart);
      vState.reason := '';
      vState.stock := -1;

      uCommand.PostState(vState, GConsoleSet.StateInterface);

    finally
      FreeAndNil(vState);
    end;
  end;
var
  vOrderItem, vOrderItem1: TOrderItem;
  vRoleItem: TRoleItem;
  vNode, vChildNode: TcxTreeListNode;
  I: Integer;
begin
  tlOrders.BeginUpdate;
  try
    vOrderItem := TOrderItem(Msg.LParam);
    if vOrderItem = nil then Exit;
    for I := 0 to tlOrders.Count - 1 do
    begin
      if tlOrders.Items[I].Level <> 0 then Continue;
      vOrderItem1 := Pointer(tlOrders.Items[I].Data);
      if vOrderItem1 = nil then Continue;
      if vOrderItem1.key = '' then Continue;
      if vOrderItem1.key = vOrderItem.key then Exit;
    end;
    vNode := tlOrders.Add;
    vNode.Data := Pointer(vOrderItem);
    vNode.Values[0] := Format('�������[%s]   ��Ϸ����[%s]   ��������[%d]', [vOrderItem.orderNo, vOrderItem.gameSvr, vOrderItem.saleNum]);
    for vRoleItem in vOrderItem.roles do
    begin
      //--
      {$IFNDEF _MS_DEBUG}
      fnPostQueueState(vOrderItem, vRoleItem);
      {$ENDIF}
      vChildNode := tlOrders.AddChild(vNode, nil);
      vChildNode.Values[tlOrdersSendNum.ItemIndex] := vRoleItem.sendNum;
      vChildNode.Values[tlOrdersAccount.ItemIndex] := vRoleItem.account;
      vChildNode.Values[tlOrdersStock.ItemIndex] := vRoleItem.stock;
      vChildNode.Values[tlOrdersRole.ItemIndex] := vRoleItem.role;
      vChildNode.Values[tlOrdersReceiptRole.ItemIndex] := vRoleItem.receiptRole;
    end;
    SendMessage(GSharedInfo.MainFormHandle, WM_UPDATE_TASK_UI, 0, Msg.LParam);
  finally
    tlOrders.EndUpdate;
  end;
end;

procedure TFrmMain.WmDelOrder(var Msg: TMessage);
var
  I: Integer;
  sKey: string;
  vOrderItem: TOrderItem;

begin
  tlOrders.BeginUpdate;
  try
    sKey := string(Msg.LParam);
    for I := 0 to tlOrders.Count - 1 do
    begin
      vOrderItem := TOrderItem(tlOrders.Items[I].Data);
      if vOrderItem = nil then Continue;
      if (sKey = vOrderItem.key) then
      begin
        tlOrders.Items[I].DeleteChildren;
        tlOrders.Items[I].Delete;
        Break;
      end;
    end;
  finally
    tlOrders.EndUpdate;
  end;
end;

procedure TFrmMain.WmAddSendMachine(var Msg: TMessage);
var
  i: Integer;
  sGroupName: string;
  vConnItem, vConnItem1: TConnItem;
begin
  vConnItem := TConnItem(Msg.LParam);
  if vConnItem = nil then Exit;
  Tv.DataController.BeginFullUpdate;
  try
    for I := 0 to Tv.DataController.RecordCount - 1 do
    begin
      vConnItem1 := TConnItem(DWORD(Tv.DataController.Values[I, TvConnItem.Index]));
      if vConnItem1 = nil then Continue;
      if vConnItem1.GroupName = vConnItem.GroupName then Exit;
    end;
    Tv.DataController.RecordCount := Tv.DataController.RecordCount + 1;
    Tv.DataController.Values[Tv.DataController.RecordCount - 1, TvConnItem.Index] := DWORD(vConnItem);
    SendMessage(GSharedInfo.MainFormHandle, WM_UPDATE_CONN_UI, 0, LPARAM(vConnItem.GroupName));
  finally
    Tv.DataController.EndFullUpdate;
  end;
end;

procedure TFrmMain.WmDelSendMachine(var Msg: TMessage);
var
  i: Integer;
  vConnItem: TConnItem;
  sGroupName: string;
  bIsEque: Boolean;
begin
  Tv.DataController.BeginFullUpdate;
  try
    try
      sGroupName := string(Msg.LParam);
      for I := Tv.DataController.RecordCount - 1 downto 0 do
      begin
        vConnItem := TConnItem(DWORD(Tv.DataController.Values[I, TvConnItem.Index]));
        if vConnItem = nil then Continue;
        if FConnItem <> nil then
          bIsEque := vConnItem.GroupName = FConnItem.GroupName;
        if vConnItem.GroupName = sGroupName then
        begin
          Tv.DataController.DeleteRecord(I);
          ConnManager.Del(sGroupName);
          if bIsEque then FConnItem := nil;
          Break;
        end;
      end;
    except

    end;
  finally
    Tv.DataController.EndFullUpdate;
  end;
end;

procedure TFrmMain.WmUpdateConnUI(var Msg: TMessage);
var
  i: Integer;
  vConnItem: TConnItem;
  sGroupName: string;
  vRoleItem: TRoleItem;
begin
  Tv.DataController.BeginFullUpdate;
  try
    sGroupName := string(Msg.LParam);
    if sGroupName = '' then Exit;

    for I := 0 to Tv.DataController.RecordCount - 1 do
    begin
      vConnItem := TConnItem(DWORD(Tv.DataController.Values[I, TvConnItem.Index]));
      if vConnItem = nil then
      begin
        Continue;
      end;
      if vConnItem.GroupName = sGroupName then
      begin
        if vConnItem.State <> sms��æ then
        begin
          Tv.DataController.Values[I, TvGroupName.index] := vConnItem.GroupName;
          Tv.DataController.Values[I, TvOrderNo.index] := '';
          Tv.DataController.Values[I, TvGameSvr.index] := '';
          Tv.DataController.Values[I, TvSaleNum.index] := 0;
          Tv.DataController.Values[I, TvState.index] := Integer(vConnItem.State);
          Tv.DataController.Values[I, TvLogMsg.index] := '';
          Tv.DataController.Values[I, TvAccType.index] := '';
          //tlConn.Items[I].Values[tlConnInterval.ItemIndex] := 0;
        end else
        begin
          Tv.DataController.Values[I, TvGroupName.index] := vConnItem.GroupName;
          Tv.DataController.Values[I, TvOrderNo.index] := vConnItem.OrderItem.orderNo;
          Tv.DataController.Values[I, TvGameSvr.index] := vConnItem.OrderItem.gameSvr;
          Tv.DataController.Values[I, TvSaleNum.index] := vConnItem.OrderItem.saleNum;
          Tv.DataController.Values[I, TvState.index] := Integer(vConnItem.State);
          if vConnItem.LogMsgs.Count > 0 then
            Tv.DataController.Values[I, TvLogMsg.index] := vConnItem.LogMsgs.Strings[vConnItem.LogMsgs.Count - 1];

          if vConnItem.OrderItem = nil then
          begin
            Tv.DataController.Values[I, TvAccType.index] := '';
          end else
          begin
            if vConnItem.OrderItem.roles[0].isMain then
              Tv.DataController.Values[I, TvAccType.index] := '����'
            else
              Tv.DataController.Values[I, TvAccType.index] := '�Ӻ�';
          end;
        end;
        Break;
      end;
    end;

    for I := 0 to TvDetail.DataController.RecordCount - 1 do
    begin
      vRoleItem := TRoleItem(DWORD(TvDetail.DataController.Values[I, TvDetailRoleItem.Index]));
      if vRoleItem = nil then Continue;
      TvDetail.DataController.Values[I, TvDetailAccount.Index] := vRoleItem.account;
      TvDetail.DataController.Values[I, TvDetailSendNum.Index] := vRoleItem.sendNum;
      TvDetail.DataController.Values[I, TvDetailStock.Index] := vRoleItem.stock;
      TvDetail.DataController.Values[I, TvDetailRole.Index] := vRoleItem.Role;
      TvDetail.DataController.Values[I, TvDetailState.Index] := vRoleItem.taskState;
      TvDetail.DataController.Values[I, TvDetailReceiptRole.Index] := vRoleItem.receiptRole;
      TvDetail.DataController.Values[I, TvDetailLogMsg.Index] := vRoleItem.logMsg;
    end;
  finally
    Tv.DataController.EndFullUpdate;
  end;
end;

procedure TFrmMain.WmUpdateTaskUI(var Msg: TMessage);
begin

end;
{$ENDREGION}

{ TGetTask }

constructor TWorkTask.Create;
begin
  FreeOnTerminate := True;
  //b������   := False;
  inherited Create(True);
end;

destructor TWorkTask.Destroy;
begin
  //AddLogMes('�����߳��˳���', []);
  inherited;
end;

function TWorkTask.DispatchFcOrder(AFcOrderItem: TFcOrderItem): Boolean;
  function fnCopyOrderItem(AFcOrderItem: TFcOrderItem; AAccountItem: TAccountItem): Boolean;
  var
    vOrderItem: TOrderItem;
    vFcRoleItem: TFcRoleItem;
    vRoleItem: TRoleItem;
    vRoles: TArray<TRoleItem>;
  begin
    Result := True;
    try
      vOrderItem := TOrderItem.Create;
      vOrderItem.orderNo := AAccountItem.groupNo;
      vOrderItem.taskType := AFcOrderItem.taskType;
      vOrderItem.gameArea := AFcOrderItem.gameArea;
      vOrderItem.gameSvr := AFcOrderItem.gameSvr;
      vOrderItem.key := AAccountItem.orderNo;
      vOrderItem.consoleId := AFcOrderItem.consoleId;
      vOrderItem.saleNum := 0;
      vOrderItem.isBusy := False;
      vOrderItem.roles := vRoles;
      SetLength(vRoles, 0);
      for vFcRoleItem in AAccountItem.roles do
      begin
        vRoleItem := TRoleItem.Create;
        SetLength(vRoles, Length(vRoles) + 1);
        vRoles[High(vRoles)] := vRoleItem;
        vOrderItem.roles := vRoles;
        vRoleItem.rowId := vFcRoleItem.rowId;
        vRoleItem.isMain := AAccountItem.isMain;
        vRoleItem.account := AAccountItem.account;
        vRoleItem.passWord := AAccountItem.passWord;
        vRoleItem.roleID := vFcRoleItem.roleId;
        vRoleItem.role := vFcRoleItem.role;
        vRoleItem.receiptRole := vFcRoleItem.receiptRole;
        vRoleItem.receiptLevel := 0;
        vRoleItem.checkLevel := False;
        vRoleItem.safetyWay := vFcRoleItem.safetyWay;
        vRoleItem.sendNum := vFcRoleItem.sendNum;
        vRoleItem.eachNum := vFcRoleItem.eachNum;
        vRoleItem.taskState := 15;
        vRoleItem.stock := vFcRoleItem.stock;
        vRoleItem.reStock := -1;
        vRoleItem.logMsg := '';
        if vRoleItem.isMain then
        begin
          vOrderItem.orderNo := AAccountItem.groupNo;
          vRoleItem.receiptRole := '';
          vRoleItem.sendNum := 0;
          vRoleItem.eachNum := 0;
        end;
      end;
      TaskManager.Add(vOrderItem);
      SendMessage(GSharedInfo.MainFormHandle, WM_ADD_ORDER, 0, LPARAM(vOrderItem));
      Result := True;
    except
    end;
  end;
var
  vAccountItem: TAccountItem;
begin
  Result := False;
  try
    if AFcOrderItem = nil then Exit;
    if Length(AFcOrderItem.accounts) = 0 then Exit;
    for vAccountItem in AFcOrderItem.accounts do
    begin
      if Length(vAccountItem.roles) = 0 then Continue;
      if TaskManager.ContainsKey(vAccountItem.orderNo) then Continue;
      DebugInf('MS - %s', [vAccountItem.orderNo]);
      fnCopyOrderItem(AFcOrderItem, vAccountItem);
      DebugInf('MS - %d', [TaskManager.Count]);
    end;
    Result := True;
  except
  end;
end;

function TWorkTask.DispatchOrders(AOrders: string): Boolean;
var
  vOrderItem: TOrderItem;
  vOrders: TArray<TOrderItem>;
  vFcOrderItem: TFcOrderItem;
  vFcOrders: TArray<TFcOrderItem>;
begin
  Result := False;
  if (AOrders = '') or (AOrders = '-1') then Exit;
  try
    case GSharedInfo.TaskType of
      tt����:
      begin
        if not TSerizalizes.AsType<TArray<TOrderItem>>(AOrders, vOrders) then Exit;
        if Length(vOrders) = 0 then Exit;
        for vOrderItem in vOrders do
        begin
          if TaskManager.ContainsKey(vOrderItem.orderNo) then Continue;
          TaskManager.Add(vOrderItem);
          //--�ύ״̬
          SendMessage(GSharedInfo.MainFormHandle, WM_ADD_ORDER, 0, LPARAM(vOrderItem));
        end;
      end;
      tt�ֲ�:
      begin
        if not TSerizalizes.AsType<TArray<TFcOrderItem>>(AOrders, vFcOrders) then Exit;
        if Length(vFcOrders) = 0 then Exit;
        for vFcOrderItem in vFcOrders do
        begin
          if not DispatchFcOrder(vFcOrderItem) then Continue;
        end;
      end;
    end;
    Result := True;
  except
  end;
end;

procedure TWorkTask.Execute;
var
  sOrderNoLst: string;
  dwPriorTick, dwCurTick: DWORD;
begin
  dwPriorTick := 0;
  while not Terminated do
  begin
    if GCloseConsole then Break;
    dwCurTick := GetTickCount;
    //Sleep(5000);
    Sleep(100);
    {$IFNDEF _MS_DEBUG}
    if GSharedInfo.TaskType = ttNormal then Continue;
    {$ENDIF}
    try
      //--��ȡ����
      if TaskManager.Count < GConsoleSet.MaxTaskNum then
      begin
        if dwCurTick - dwPriorTick > 5 * 1000 then
        begin
          dwPriorTick := dwCurTick;
          //--ȡ������¼
          sOrderNoLst := GetOrderNoLst();
          DispatchOrders(sOrderNoLst);
        end;
      end;
      //--���䶩���� ����п��еķ������� �����һ��������������
      uTaskManager.DispatchOrder(GSharedInfo.TaskType);
    except on E: Exception do
      AddLogMsg('��ȡ��������ʱ����! '#13'%s', [E.Message]);
    end;
  end;
end;

function TWorkTask.GetOrderNoLst: string;
var
  vURL: string;
  vHttp: TIdHTTP;
begin
  Result := '-1';
  {$IFDEF _MS_DEBUG}
  with TStringList.Create do
  try
    if GSharedInfo.TaskType = tt���� then
    begin
      LoadFromFile(ExtractFilePath(ParamStr(0)) + 'FHOrders.json');
    end else if GSharedInfo.TaskType = tt�ֲ� then
    begin
      LoadFromFile(ExtractFilePath(ParamStr(0)) + 'FCOrders.json');
    end;
    Result := Text;
  finally
    Free;
  end;
  {$ELSE}
  vHttp := TIdHTTP.Create();
  try
    try
      vURL := Format(GConsoleSet.TaskInterface, [GConsoleSet.ConsoleID, 3, Integer(GSharedInfo.TaskType)]);
      Result := vHttp.Get(vURL);
      Result := Trim(Result);
    except
    end;
  finally
    vHttp.Disconnect;
    FreeAndNil(vHttp);
  end;
  {$ENDIF}
end;

end.
