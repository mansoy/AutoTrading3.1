--������������
TOrderInfo = require "TOrderInfo";
TLuaFuns = require "TLuaFuns";

function inspect(table, name)
  print ("--- " .. name .. " consists of");
  for n,v in pairs(table) do print(n, v) end;
  print();
end


local VK_RETURN = 13;
local VK_ESCAPE = 27;
local VK_LEFT   = 37;
local VK_DOWN   = 40;

--��ȡ��Ϸ���
function fnGetGameHandle()
	local hGame = 0;
	hGame = TLuaFuns:MsFindWindow('���³�����ʿ','���³�����ʿ');
		if 0 == TLuaFuns:MsIsWindow(hGame) then
			TLuaFuns:MsPostStatus('��Ϸ�����쳣�˳���', tsFail);
			return 0;
		end
	TLuaFuns:MsSetGameHandle(hGame);
	return 1;
end

--�߳�����
function fnWalkOutOfRoom() 
	local iRet = 0;
	local dwTickCount = TLuaFuns:MsGetTickCount();
	local dwWaitTick = 20 * 1000;
	while TLuaFuns:MsGetTickCount() - dwTickCount < dwWaitTick do
		TLuaFuns:MsSleep(100);
		if TLuaFuns:MsCheck() == 0 then
			return 0;
		end
		TLuaFuns:MsTheKeysWalk(VK_DOWN, 500);	
		TLuaFuns:MsSleep(2000);
		
		iRet = TLuaFuns:MsFindString('������', TLuaFuns:MsGetPianSe('��ħ_������'));
    if iRet == 1 then
			break;	
    end
	end
	
	if iRet == 0 then
		TLuaFuns:MsPostStatus('�߳����䳬ʱ', tsFail);
		return 0;
	end
	
	TLuaFuns:MsTheKeysWalk(VK_DOWN, 1000);	
	return 1;
end

--�ߵ���̯�ص�
function fnWalkToStallPlace()
	local iRet = 0;
	local dwTickCount = TLuaFuns:MsGetTickCount();
	local dwWaitTick = 20 * 1000;
	while TLuaFuns:MsGetTickCount() - dwTickCount < dwWaitTick do
		TLuaFuns:MsSleep(100);
		if TLuaFuns:MsCheck() == 0 then
			return 0;
		end
		TLuaFuns:MsTheKeysWalk(VK_LEFT, 500);	
		TLuaFuns:MsSleep(2000);
		
		iRet = TLuaFuns:MsFindString('�ߵ����������', TLuaFuns:MsGetPianSe('��ħ_����'));
    if iRet == 1 then
			break;	
    end
	end
	
	if iRet == 0 then
		TLuaFuns:MsPostStatus('�ߵ���̯�ص㳬ʱ', tsFail);
		return 0;
	end
	
	TLuaFuns:MsTheKeysWalk(VK_DOWN, 1000);
	TLuaFuns:MsSleep(100);
	TLuaFuns:MsTheKeysWalk(VK_LEFT, 1200);	
	return 1;
end

--��̯
function fnStall()
	local iX = -1;
	local iY = -1; 
	local iRet = 0;
	local iRoleX = 0;  
	local iRoleY = 0;
	local sRole = TOrderInfo:GetRole();
	
	iX,iY,iRet = TLuaFuns:MsFindStringEx(sRole, 'ffffff-000000');
	if (-1 ~= iX) and (-1 ~= iY) then
		TLuaFuns:MsPostStatus('��ɫ������', tsFail, false);
		return 0;
	end
	
	--��¼��ɫ����
	iRoleX = iX;
	iRoleY = iY + 130;
	
	--�ڽ�ɫ���ϵ��
	TLuaFuns:MsClick(iX, iY+50);
	iX,iY,iRet = TLuaFuns:MsFindStringEx('��ְҵ', 'ffffff-000000');
	if (-1 ~= iX) and (-1 ~= iY) then
		TLuaFuns:MsPostStatus('��̯-�ڽ�ɫ���ϵ��ʧ�ܣ�', tsFail);
		return 0;
	end
	
	--�������ְҵ��
	TLuaFuns:MsClick(iX+30, iY+10);
	TLuaFuns:MsSleep(1000);
	iX,iY,iRet = TLuaFuns:MsFindStringEx('���踽ħ�̵�', TLuaFuns:MsGetPianSe('��ħ_���踽ħ�̵�'));
	if (-1 ~= iX) and (-1 ~= iY) then
		TLuaFuns:MsPostStatus('��̯-�򿪸�ְҵʧ�ܣ�', tsFail);
		return 0;
	end
  
	--��������踽ħ�̵ꡱ
  TLuaFuns:MsClick(iX+30, iY+10);
	TLuaFuns:MsSleep(1000);
	iX,iY,iRet = TLuaFuns:MsFindStringEx('������', 'ffffff-000000');
	if (-1 ~= iX) and (-1 ~= iY) then
		TLuaFuns:MsPostStatus('��̯-�򿪸�ħ�̵�ʧ�ܣ�', tsFail);
		return 0;
	end

	--����������
	local hGame = TLuaFuns:MsGetGameHandle();
	TLuaFuns:MsPressString(hGame, '10000000');
	TLuaFuns:MsSleep(500);
	TLuaFuns:MsPressEnter();

	--�����ڵ��ϰ�̯
	local r = 30;       --�뾶
	local a = 30;       --�Ƕ� 30�� 60�� 90�� 120�� 150��
  local x0 = 0;       --����ԭ��(0,0)
	local y0 = 0; 
	local i = 0;
	local j = 0;
	local bOk = false;
	for i = 1, 5 do
		r = r+20;
    j = 0;
    a = 30; 
		for j = 1, 5 do
			if j*a ~= 90 then
				x1= Round(cos(j*a*math.pi/180)*r);
				y1= Round(sin(j*a*math.pi/180)*r);
				x1= iRoleX + x1;
				y1= iRoleY - y1;
				TLuaFuns:MsClick(x1, y1);
				TLuaFuns:MsSleep(2000);
				--����㵽��ĵط��ˣ���һ��Esc
				iX,iY,iRet = TLuaFuns:MsFindStringEx('��ְҵ|����|��NPC̫���ӽ�|�������', 'ffffff-000000|68d5ed-000000');
				if iRet ~= -1 then
					TLuaFuns:MsPressEsc();
				end
				iRet = TLuaFuns:MsFindString('������', TLuaFuns:MsGetPianSe('��ħ_��ħ'));
				if iRet == 1 then
					bOk = true;
					break;	
				end
			end
		end
		if bOk then break; end
	end

	if iRet == 0 then
		TLuaFuns:MsPostStatus('û���ҵ���̯λ�ã�', tsFail);
		return 0;
	end 

	TLuaFuns:MsPostStatus('��̯��ɣ�');
	return 1;
end

--��̯�˺Ź���
function fnStallDoWork()
	local iRet = 0;
	TLuaFuns:MsSleep(5000);
	
	iRet = fnGetGameHandle();
	if iRet == 0 then return 0; end
	
	iRet = fnWalkOutOfRoom();
	if iRet == 0 then return 0; end
	
	iRet = fnWalkToStallPlace();
	if iRet == 0 then return 0; end
	
	iRet = fnStall();
	if iRet == 0 then return 0; end
	
	return 1;
end

-----------------------------------��ħ-----------------------------------------------------
--�ߵ���ħ�ص�
function fnWalkToEnchantPlace()
	local iRet = 0;
	local dwTickCount = TLuaFuns:MsGetTickCount();
	local dwWaitTick = 20 * 1000;
	while TLuaFuns:MsGetTickCount() - dwTickCount < dwWaitTick do
		TLuaFuns:MsSleep(100);
		if TLuaFuns:MsCheck() == 0 then
			return 0;
		end
		TLuaFuns:MsTheKeysWalk(VK_LEFT, 500);	
		TLuaFuns:MsSleep(2000);
		
		iRet = TLuaFuns:MsFindString('�ߵ����������', TLuaFuns:MsGetPianSe('��ħ_����'));
    if iRet == 1 then
			break;	
    end
	end
	
	if iRet == 0 then
		TLuaFuns:MsPostStatus('�����̯�ص㳬ʱ', tsFail);
		return 0;
	end
	
	--�ߵ���̯����Ҹ�ǰ
	TLuaFuns:MsTheKeysWalk(VK_DOWN, 500);
	TLuaFuns:MsSleep(100);
	TLuaFuns:MsTheKeysWalk(VK_LEFT, 800);	
	return 1;
end

--��ȡ��ħ��ɫ�������
function fnGetEnchatBagMoney()
	local iRet = -1;
	local hGame = TLuaFuns:MsGetGameHandle();	
	
	local iX = -1;
	local iY = -1;
	
	TLuaFuns:MsPressChar('I');
	TLuaFuns:MsSleep(1000);
	iX, iY = TLuaFuns:MsGetTopLeft(hGame);
	for i=0, 9 do
		iRet = TLuaFuns:MsFindString('װ����(I)', TLuaFuns:MsGetPianSe('�˵�_��ͨ����'));
		if 0 ~= iRet then
			iRet = TLuaFuns:MsGetNumber(iX + 580, iY + 520, iX + 710, iY + 550, TLuaFuns:MsGetPianSe('�ʼ�_�������'));
			if iRet ~= -1 then
				break;
			end
		end	
		TLuaFuns:MsSleep(500);
	end
	TLuaFuns:MsPressEsc();
	return iRet;
end

--��鸽ħ��ɫ��������Ƿ��㹻��ħ
function fnCheckEnchatRoleBagMoney()
	local iEnchatRoleBagMoney = fnGetBagMoney(); --��ħ��ɫ�������
	if iBagMoney == -1 then
		TLuaFuns:MsPostStatus('��ȡ��ħ��ɫ������', tsFail);
		return 0;
	end;
	local iEnchatNum = TOrderInfo:GetSendNum(); --��ħ����
	local iEnchatMoney = iEnchatNum * 10000000; --��ħ�ܽ��
	
	if iEnchatRoleBagMoney < iEnchatMoney then
		TLuaFuns:MsPostStatus('��ħ��ɫ��������ǲ��㣡', tsFail, false);
		return 0;
	end
	return 1;
end

--���ø�ħ����
function fnResetEnchat()
	if TLuaFuns:MsFindString('����븽ħ�õ���װ����Ƭ', 'ffffff-000000', 0.9, 3) == 0 then
		return 0;
	end
	TLuaFuns:MsPressEsc();
	TLuaFuns:MsSleep(500);
	return 1;
end

--��ħ
function fnEnchant()
	local iX = -1;
	local iY = -1; 
	local iRet = 0;
	local sStallRole = '�ܳݡ����뱴';
	
	if TLuaFuns:MsCheck() == 0 then
		return 0;
	end
		
	--�����
	iX,iY,iRet = TLuaFuns:MsFindString(sStallRole, 'ffffff-000000', 0.9, 3);
	if iRet == 0 then
		TLuaFuns:MsPostStatus(string.format('û���ҵ���̯�����[%s]', sStallRole), tsFail);	
		return 0;
	end
	
	--����ҵ�̯λ
	iX,iY,iRet = TLuaFuns:MsAreaFindString(iX-5, iY-80, iX+50, iY, '������', TLuaFuns:MsGetPianSe('��ħ_��ħ'), 0.9, 3);
	if iRet == 0 then
		TLuaFuns:MsPostStatus('���[%s]û�а�̯', tsFail);	
		return 0;
	end

	--�򿪸�ħ����
	TLuaFuns:MsClick(iX, iY);
	TLuaFuns:MsSleep(2000);
	iX, iY, iRet = TLuaFuns:MsFindString('����븽ħ�õ���װ����Ƭ', 'ffffff-000000', 0.9, 3);
	if iRet == 0 then
		TLuaFuns:MsPostStatus('�򿪸�ħ����ʧ�ܣ�', tsFail);	
		return 0;
	end
	
	local iEnchatRoleBagMoney_before = fnGetBagMoney(); --��ħǰ�������
	
	--���װ����1��װ����2���޸�ħ��װ���Ϳ�Ƭ
	if TLuaFuns:MsFindImg('Bar1IsNull.bmp', 1.0) ~= 0 then
		TLuaFuns:MsPostStatus('װ����1û��װ����', tsFail, false);
		return 0
	end
	if TLuaFuns:MsFindImg('Bar2IsNull.bmp', 1.0) ~= 0 then
		TLuaFuns:MsPostStatus('װ����2û�п�Ƭ��', tsFail, false);
		return 0
	end
	
	--�϶�װ����1(iX+10, iY+360)��װ����ָ��λ��(iX+30, iY-20)
	TLuaFuns:MsDragMouse(iX+10, iY+360, iX+30, iY-20);
	TLuaFuns:MsSleep(1000);
	if TLuaFuns:MsFindString('ֻ�ܷ���װ��', 'ffffff-000000') ~= 0 then
		TLuaFuns:MsPostStatus('װ����1����Ʒ����װ����', tsFail, false);
		TLuaFuns:MsPressEnter();
		return 0;
	end
	if TLuaFuns:MsFindString('��װ��ԭ�еĸ�ħЧ��������ʧ', 'ffffff-000000') ~= 0 then
		TLuaFuns:MsPressEnter();
	end
	
	--�϶�װ����2(iX+40, iY+360)�Ŀ�Ƭ��ָ��λ��(iX+130, iY-20)
	TLuaFuns:MsDragMouse(iX+40, iY+360, iX+130, iY-20);
	TLuaFuns:MsSleep(1000);
	if TLuaFuns:MsFindString('ֻ�ܷ�����￨Ƭ', 'ffffff-000000') ~= 0 then
		TLuaFuns:MsPostStatus('װ����2����Ʒ���ǹ��￨Ƭ��', tsFail, false);
		TLuaFuns:MsPressEnter();
		return 0;
	end
	if TLuaFuns:MsFindString('���￨Ƭ��װ����𲻷�', 'ffffff-000000') ~= 0 then
		TLuaFuns:MsPostStatus('���￨Ƭ��װ����𲻷���', tsFail, false);
		TLuaFuns:MsPressEnter();
		return 0;
	end
	
	--�������ħ����ť
	iX,iY = TLuaFuns:MsFindImg('Enchant.bmp');
	if (-1 == iX) or (-1 == iY) then
		TLuaFuns:MsPostStatus('û���ҵ���ħ��ť��', tsFail, false);
		return 0;
	end
	TLuaFuns:MsClick(iX, iY);
	TLuaFuns:MsSleep(1000);
	iX,iY,iRet = TLuaFuns:MsFindStringEx('ȷ��Ҫ��ħ����װ����', 'ffffff-000000');
	if (-1 == iX) or (-1 == iY) then
		TLuaFuns:MsPostStatus('�򿪸�ħȷ������ʧ�ܣ�', tsFail);
		return 0;
	end
	
	--�жϸ�ħ�����Ƿ��㹻
	if TLuaFuns:MsFindImg('OkGray.bmp') ~= 0 then
		TLuaFuns:MsPostStatus('��ħ���ϲ��㣡', tsFail);
		return 0;
	end
	
	--ȷ��
	TLuaFuns:MsClick(iX+30, iY+185);
	TLuaFuns:MsSleep(1000);
	
	--ȷ��
	iX,iY,iRet = TLuaFuns:MsFindStringEx('ȷ��Ҫ��ħ����װ����', 'ffffff-000000');
	if (-1 == iX) or (-1 == iY) then
		TLuaFuns:MsPostStatus('�򿪸�ħȷ�Ͻ���ʧ�ܣ�', tsFail);
		return 0;
	end
	TLuaFuns:MsClick(iX+20, iY+150);
	TLuaFuns:MsSleep(1000);
	
	--�жϸ�ħ�Ƿ�ɹ�
	local iEnchatRoleBagMoney_after = fnGetBagMoney(); --��ħ��ı������
	if iEnchatRoleBagMoney_after == iEnchatRoleBagMoney_before then
		TLuaFuns:MsPostStatus('��ħʧ�ܣ�', tsFail);
		return 0;
	end
	
	TLuaFuns:MsPostStatus('��ħ�ɹ���');
	return 1;
end

--��ħ�˺Ź���
function fnEnchantDoWork()
	TLuaFuns:MsSleep(5000);
	
	if fnGetGameHandle() == 0 then return 0; end
	
	if fnWalkOutOfRoom() == 0 then return 0; end
	
	if fnWalkToEnchantPlace() == 0 then return 0; end
	
	if fnCheckEnchatRoleBagMoney() == 0 then return 0; end
	
	local iEnchatNum = TOrderInfo:GetSendNum();
	for i=1,iEnchatNum do
		fnResetEnchat();
		if fnEnchant() == 0 then return 0; end
	end
end

--fnStallDoWork();
--fnEnchantDoWork();


inspect(TLuaFuns,'func');