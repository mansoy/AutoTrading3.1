unit uFrmOrderItem;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer,
  cxEdit, cxTextEdit, cxMemo, Vcl.ExtCtrls, Vcl.StdCtrls, uJsonClass, uTaskManager, uGlobal;

type
  TFrmOrderItem = class(TForm)
    Panel1: TPanel;
    cxMemo1: TcxMemo;
    btnOk: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmOrderItem: TFrmOrderItem;

function fnShowOrderItem(AConnItem: TConnItem): Boolean;

implementation

{$R *.dfm}

function fnShowOrderItem(AConnItem: TConnItem): Boolean;
var
  F: TFrmOrderItem;
  vRoleItem: TRoleItem;
  function fnGet��������(ACmdType: TTaskType): string;
  begin
    Result := '';
    case ACmdType of
      tt����: Result := '����';
      tt�ֲ�: Result := '�ֲ�';
      tt���: Result := '���';
      tt�ʼ�: Result := '�ʼ�';
    end;
  end;
begin
  Result := True;
  if AConnItem.OrderItem = nil then Exit;
  F := TFrmOrderItem.Create(Application);
  try
    F.cxMemo1.Lines.Clear;
    F.cxMemo1.Lines.Add(Format('��������: %s', [fnGet��������(TTaskType(AConnItem.OrderItem.taskType))]));

    F.cxMemo1.Lines.Add(Format('�� �� ʶ: %s', [AConnItem.GroupName]));
    F.cxMemo1.Lines.Add(Format('�������: %s', [AConnItem.OrderItem.orderNo]));
    F.cxMemo1.Lines.Add(Format('��    ��: %s', [AConnItem.OrderItem.GameArea]));
    F.cxMemo1.Lines.Add(Format('��    ��: %s', [AConnItem.OrderItem.GameSvr]));
    for vRoleItem in AConnItem.OrderItem.roles do
    begin
      if AConnItem.OrderItem.taskType = Integer(tt�ֲ�) then
      begin
        if vRoleItem.isMain then
          F.cxMemo1.Lines.Add('ת��ת��: ת��')
        else
          F.cxMemo1.Lines.Add('ת��ת��: ת��');
      end;
      F.cxMemo1.Lines.Add(Format('�� �� ID: %d', [vRoleItem.rowId]));
      F.cxMemo1.Lines.Add(Format('��Ϸ�˺�: %s', [vRoleItem.Account]));
      F.cxMemo1.Lines.Add(Format('��Ϸ��ɫ: %s', [vRoleItem.Role]));
      F.cxMemo1.Lines.Add(Format('��    ��: %d', [vRoleItem.stock]));
      F.cxMemo1.Lines.Add(Format('�Է���ɫ: %s', [vRoleItem.receiptRole]));
      F.cxMemo1.Lines.Add(Format('�Է��ȼ�: %d', [vRoleItem.receiptLevel]));
      F.cxMemo1.Lines.Add(Format('��    ��: %d', [vRoleItem.sendNum]));
      F.cxMemo1.Lines.Add(Format('����״̬: %d', [Integer(vRoleItem.taskState)]));
      AddLogMsg('//-------------------------------------------------------------------', []);
    end;
    F.ShowModal;
  finally
    FreeAndNil(F);
  end;
end;

end.
