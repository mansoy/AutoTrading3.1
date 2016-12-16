--������������
TLuaFuns = require "TLuaFuns";

--������״̬
tsNormal 	   = 100;
tsStart 	   = 0; 
tsSuccess 	 = 1;
tsDoing 	   = 2;
tsSuspend 	 = 3;
tsTargetFail = 4;
tsFail 		   = 5;
tsKillTask   = 6;

--��������

local GCapturePath = '';
local GPassWord = '';
local GAccount = '';

local VK_RETURN = 13;
local VK_ESCAPE = 27;
local VK_LEFT   = 37;
local VK_UP     = 38;
local VK_RIGHT  = 39;
local VK_DOWN   = 40;

--�ָ��ַ���
function string.split(str, delimiter)
	if str==nil or str=='' or delimiter==nil then
		return nil;
	end
	
    local result = {}
    for match in (str..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match)
    end
    return result;
end

--���ݴ��ڱ���رոô���
function CloseWindowByTitle(title)
    local cmd = [[taskkill /F /FI "WINDOWTITLE eq %s"]];
    cmd = string.format(cmd, title);
    os.execute(cmd)
end

--���ݽ������رմ���
function CloseWindowByProcessName(name)
    local cmd  = [[taskkill /F /FI "IMAGENAME eq %s"]];
    cmd = string.format(cmd, name);
    os.execute(cmd);
end

--ȡ�����
function fnGetRandom(iFrom, iEnd)
	math.randomseed(os.time());
	local rand = math.random(iFrom, iEnd);
	if (rand < iFrom) or (rand > iEnd) then
		return -1;
	end
	return rand;
end

function fnOpenMenu()
	local iRet = 0;
	local iX = -1;
	local iY = -1;
	for i = 1,9 do
		iRet = TLuaFuns:MsFindString('��Ϸ�˵�(Esc)', 'ffffff-000000|b3b3b3-000000');
		if iRet ~= 0 then return 1; end
		TLuaFuns:MsPressEsc();
		TLuaFuns:MsSleep(500);
	end
	return 0;
end

--�������Ŀ��0: ������ʱ 1����¼���� 2���޸�����
function fnCheckStartTarget()
	print('�������Ŀ��...');
	local hDengLu = 0; 
	local hXiuFu = 0;
	local dwTickCount = TLuaFuns:MsGetTickCount();
	local dwWaitTick = TLuaFuns:MsGetDelay('������Ϸ�ȴ�') * 1000;
	print(string.format('CurTick: %d WaitTick: %d', dwTickCount, dwWaitTick));	
	while TLuaFuns:MsGetTickCount() - dwTickCount <= dwWaitTick do
		TLuaFuns:MsSleep(100);
		if TLuaFuns:MsCheck(0) == 0 then
			return -1, 0;
		end
		hXiuFu = TLuaFuns:MsFindWindow('', '���³�����ʿ�޸�����');
		if TLuaFuns:MsIsWindow(hXiuFu) == 1 then
			break;	
		end	
			
		hDengLu = TLuaFuns:MsFindWindow('', '���³�����ʿ��¼����');
		if TLuaFuns:MsIsWindow(hDengLu) == 1 then
			break;	
		end
	end
	
	if (TLuaFuns:MsIsWindow(hDengLu) == 0) and (TLuaFuns:MsIsWindow(hXiuFu) == 0) then      
		TLuaFuns:MsPostStatus('������Ϸ��ʱ', tsFail);
        return 0, 0;
    end

	if (TLuaFuns:MsIsWindow(hDengLu) == 1) then      
        print('�򿪵��ǵ�¼����');
        return hDengLu, 1;
    end 
	
	if TLuaFuns:MsIsWindow(hXiuFu) == 1 then      
        print('�򿪵����޸�����');
        return hXiuFu, 2;
    end
end

--�޸���Ϸ
function fnRepairGame()
	TLuaFuns:MsPostStatus('��ʼ�޸���Ϸ�ļ�');
	local dwTickCount = TLuaFuns:MsGetTickCount();
	local dwWaitTick = TLuaFuns:MsGetDelay('��ȫ��֤�ȴ�') * 1000;
	local bRepairOK = false;
	local hXiufu = TLuaFuns:MsGetGameHandle();
	while TLuaFuns:MsGetTickCount() - dwTickCount < dwWaitTick do
		TLuaFuns:MsSleep(100);
		if TLuaFuns:MsCheck() == 0 then
			return 0;
		end
		if TLuaFuns:MsFindImg('RepairOk.bmp') ~= 0 then
			--���ȥ����ť
			TLuaFuns:MsSleep(1000);
			break;
		end
	end
	if not bRepairOK then
		TLuaFuns.MsPostStatus('��Ϸ�ļ��޸���ʱ', tsFail);
        return 0;
	end
	print('�޸��ļ����');
	return 1;
end

--��½ʱ��ⵯ�������ر�
function fnCloseLoginPopupWindow()
	local hPopup = 0;
	
	hPopup = TLuaFuns:MsFindWindow('TWINCONTROL', 'DNF��Ƶ������');
	if 1 == TLuaFuns:MsIsWindow(hPopup) then
	end  
end

--������Ϸ
function fnStartGame()
	local iRet = 0;
	local hGame = 0;
	TLuaFuns:MsPostStatus('������Ϸ...');
	while true do
		TLuaFuns:MsSleep(100);
		iRet = TLuaFuns:MsStartGame();
		if (0 == iRet) then
			print('������Ϸʧ��');
			return 0;
		end 
		
		hGame, iRet = fnCheckStartTarget();
		if -1 == hGame then
			return 0;
		end
		if (0 == iRet) and (TLuaFuns:MsIsWindow(hGame) == 0) then
			TLuaFuns:MsPostStatus('������Ϸ��ʱ', tsFail);
			return 0;
		end
		
		TLuaFuns:MsSetGameHandle(hGame);
				
		if iRet == 1 then
			return 1;	
		end 
		
		if iRet == 2 then 
			fnRepairGame();
		end
	end
end

--ѡ������
function fnSelGameArea()
	TLuaFuns:MsPostStatus('�ȴ���Ϸ����');
	local dwTickCount = TLuaFuns:MsGetTickCount();
	local dwWaitTick = TLuaFuns:MsGetDelay('��Ϸ���µȴ�') * 1000;
	local X = -1;
	local Y = -1;
	local iRet = -1;
	local bRet = false;
	local hLogin = TLuaFuns:MsGetGameHandle();	
	while TLuaFuns:MsGetTickCount() - dwTickCount <= dwWaitTick do
		TLuaFuns:MsSleep(100);
		if TLuaFuns:MsCheck() == 0 then
			return 0;
		end
		X, Y = TLuaFuns:MsFindImgEx('InSelArea.bmp', 0.8);
		if (X ~= -1) and (Y ~= -1) then 
			break;
		end
	end
	
	if (X == -1) or (Y == -1) then 
		TLuaFuns:MsPostStatus('��Ϸ���³�ʱ', tsFail);
		return 0;
	end	

	TLuaFuns:MsPostStatus('�ȴ�ѡ������');
	
	dwTickCount = TLuaFuns:MsGetTickCount();
	dwWaitTick = TLuaFuns:MsGetDelay('ѡ�������ȴ�') * 1000;

	while TLuaFuns:MsGetTickCount() - dwTickCount <= dwWaitTick do
		TLuaFuns:MsSleep(100);
		if TLuaFuns:MsCheck() == 0 then
			return 0;
		end
		
		if (0 == TLuaFuns:MsFindString('�������ӷ�����...', 'ffffff-000000')) then  
			bRet = true;
			break;
		end
	end
	
	if not bRet then
		TLuaFuns:MsPostStatus('ѡ���������ʱ', tsFail);
		return 0;
	end
	
	--�����½��Ϸ��ť
    	TLuaFuns:MsClick(X, Y, 100, 10);
	
	bRet = false;
	while TLuaFuns:MsGetTickCount() - dwTickCount <= dwWaitTick do
		TLuaFuns:MsSleep(100);
		if TLuaFuns:MsCheck() == 0 then
			return 0;
		end
		
		X, Y, iRet = TLuaFuns:MsFindStringEx('��ѡ��Ĵ����ӳٹ���|�÷���������ά�����޷�����|�÷������Ѿ�����', 'ffffff-000000');
		if 0 == iRet then
			TLuaFuns:MsClick(X + 100, Y + 120, 10, 5);
		end
		if 1 == iRet then
			TLuaFuns:MsPostStatus('�÷���������ά�����޷�����', tsFail);
			return 0;
		end
		if 2 == iRet then
			TLuaFuns:MsClick(X + 70, Y + 120, 10, 5);
		end
		
		X, Y, iRet = TLuaFuns:MsFindImgEx('DelayBig.bmp|InLogin.bmp|InSelArea.bmp', 0.8);
		if 0 == iRet then
			print('������ʱ����');
			TLuaFuns:MsClick(X + 80, Y + 110, 10, 5);
			TLuaFuns:MsPressEnter();
		end	
		if 1 == iRet then 
			bRet = true;
			break;
		end
		if 2 == iRet then 
			TLuaFuns:MsClick(X, Y, 60, 12);
		end
	end
	
	if not bRet then
		TLuaFuns:MsPostStatus('ѡ���������ʱ', tsFail);
		return 0;
	end
	
	TLuaFuns:MsPostStatus('ѡ��������ɹ�');
	TLuaFuns:MsPostStatus('�ȴ���ȫ���...');

	bRet = false;
	local dwTickCount = TLuaFuns:MsGetTickCount();
	local dwWaitTick = TLuaFuns:MsGetDelay('��ȫ��֤�ȴ�') * 1000;
	while TLuaFuns:MsGetTickCount() - dwTickCount <= dwWaitTick do
		TLuaFuns:MsSleep(100);
		if TLuaFuns:MsCheck() == 0 then
			return 0;
		end
		
		if TLuaFuns:MsFindImg('WaitCheck.bmp', 0.8) == 0 then
			bRet = true;
			break;
		end
	end	
	
	if not bRet then
		TLuaFuns:MsPostStatus('��ȫ��鳬ʱ', tsFail);
		return 0;
	end
	
	TLuaFuns:MsPostStatus('��ȫ������');
	return 1;
end

--��¼�ж�
function fnLoginValidate()
	print('��¼�ж�...');
	local hGame = 0;
	local bRet = false;
	local bNeedDaMa = false;
	local iRet = 0;
	local iX = -1;
	local iY = -1;
	local sCode = '';
	local dwTickCount = TLuaFuns:MsGetTickCount();
	local dwWaitTick = TLuaFuns:MsGetDelay('��ص�½���ȴ�') * 1000;
	local hLogin = TLuaFuns:MsGetGameHandle();
	while TLuaFuns:MsGetTickCount() - dwTickCount <= dwWaitTick do
		TLuaFuns:MsSleep(100);
		--�����ڳ��֣���¼���
		hGame = TLuaFuns:MsFindWindow('���³�����ʿ','���³�����ʿ');
		if TLuaFuns:MsIsWindow(hGame) ~= 0 then
			TLuaFuns:MsSetGameHandle(hGame);
			return 1;
		end
		
		if 0 == TLuaFuns:MsCheck() then
			return 0;
		end
		
		iX, iY, iRet = TLuaFuns:MsFindStringEx('�������ʺ�|����������|�ͻ��˰�ȫ|����QQ��ʱ�޷���¼', 'f4dcaf-000000|fcc45c-000000|ffffff-000000|ffffff-000000', 1.0, 2);			
		if 0 == iRet then
			TLuaFuns:MsPostStatus('QQ�˺�Ϊ��', tsFail, false);
			return 0;
		elseif 1 == iRet then
			TLuaFuns:MsPostStatus('����Ϊ��', tsFail, false);
			return 0;
		elseif 2 == iRet then
			TLuaFuns:MsPostStatus('�ͻ��˰�ȫ�������ʧ��', tsFail, false);
			return 0;
		elseif 3 == iRet then
			TLuaFuns:MsPostStatus('����QQ��ʱ�޷���¼����ָ�����ʹ��', tsFail, false);
			return 0;
		end
		bNeedDaMa = false;
		iX, iY, iRet = TLuaFuns:MsFindImgEx('PwdError.bmp|NeedDm.bmp', 0.8, 2);
		if 0 == iRet then
			TLuaFuns:MsClick(iX + 128, iY + 125, 10, 5);			
			return 99;
		end
		if 1 == iRet then
			bNeedDaMa = true;
			bRet = false;
			TLuaFuns:MsPostStatus('������ص�¼��֤����');
			--��ȡ��֤��ͼƬ
			print('��ȡ��֤��ͼƬ');
			iRet = TLuaFuns:MsCaptureArea(iX, iY - 70, iX + 125, iY - 20, 'CheckCode.bmp');
			if iRet ~= 0 then
				--�����ô���
				print('��ʼ����...');
				sCode = TLuaFuns:MsDaMa('CheckCode.bmp', 12);
				print(string.format('��֤��: %s', sCode));
				if sCode ~= '' then
					TLuaFuns:MsPostStatus(string.format('���������������ֵ: %s', sCode));
					--������֤��
					print('������֤��...');
					TLuaFuns:MsClick(iX + 300, iY - 40, 10, 5);
					TLuaFuns:MsSleep(500);
					TLuaFuns:MsPressString(hLogin, sCode);
					TLuaFuns:MsSleep(500);
					TLuaFuns:MsPressEnter();
					print('��֤���������');
					bRet = true;
				end
			end
			dwTickCount = TLuaFuns:MsGetTickCount();
		end
	end
	if bNeedDaMa and (bRet == false) then
		TLuaFuns:MsPostStatus('�����ô���ʧ��', tsFail);
		return 0;
	end
end

--��¼��Ϸ
function fnLoginGame()
	TLuaFuns:MsPostStatus('�ȴ������˺�����...');
	local hGameHandle = 0; -- = TLuaFuns:MsGetGameHandle();
	local hPwd = 0;
	local X1 = 0;
	local X2 = 0;
	local Y1 = 0;
	local Y2 = 0;
	local iTop = 0;
	local iLeft = 0;
	local iCount = 0;
	print(1);
	--�ر���Ϸ���
	--CloseWindowByTitle('DNF��Ƶ������');
	--CloseWindowByProcessName('AdvertDialog.exe');
	--TLuaFuns:MsPostStatus('�رչ�浯��...');
	local hAdvert = TLuaFuns:MsFindWindow('','DNF��Ƶ������');
	if 0 ~= TLuaFuns:MsIsWindow(hAdvert) then 
		TLuaFuns:MsSendMessage(hAdvert, 16);
	end
	print(2);
	hGameHandle = TLuaFuns:MsFindWindow('','���³�����ʿ��¼����');
	if 0 == TLuaFuns:MsIsWindow(hGameHandle) then
		TLuaFuns:MsPostStatus('��½�����쳣�˳�', tsFail);
		return 0;
	end
	print(3);
	TLuaFuns:MsSetGameHandle(hGameHandle);
	--TLuaFuns:MsPostStatus('��ʼ�����˺�����...');
	print(4);
	TLuaFuns:MsPostStatus(string.format('��ʼ��¼[%s]...',GAccount));
	if TLuaFuns:MsCheck() == 0 then
		return 0;
	end
	print(5);
	local hTmp = TLuaFuns:MsFindWindowEx(hGameHandle, 0, 'Normal', '');
	local hChild = TLuaFuns:MsFindWindowEx(hTmp, 0, 'Edit', '');

	if TLuaFuns:MsIsWindow(hChild) ~= 0 then
		hPwd = hChild;
		X1, Y1, X2, Y2 = TLuaFuns:MsGetClientRect(hChild);
		iTop = Y1;
		iLeft = X1;
	end

	print(X1, Y1, hPwd);
	hChild = TLuaFuns:MsFindWindowEx(hTmp, hPwd, 'Edit', '');
	if TLuaFuns:MsIsWindow(hChild) ~= 0 then
		X1, Y1, X2, Y2 = TLuaFuns:MsGetClientRect(hChild);
	end

	if iTop < Y1 then
		hPwd = hChild;
		iLeft = X1;
		iTop = Y1;
	end
	print(X1, Y1, hPwd);
	iLeft = iLeft + 30;
	iTop = iTop + 5;
	print(iLeft, iTop);
	::lbPwdRePress::
	TLuaFuns:MsFrontWindow(hGameHandle);
	TLuaFuns:MsClick(iLeft, iTop);
	TLuaFuns:MsSleep(500);
	TLuaFuns:MsPressPassWord(GPassWord);
	TLuaFuns:MsSleep(500);
	TLuaFuns:MsPressEnter();
	TLuaFuns:MsPostStatus('����������ɣ���ʼ��½У��...');
	--��¼�ж�
	iRet = fnLoginValidate();
	if 0 == iRet then
		return 0;
	elseif 99 == iRet then
		if iCount >= 2 then
			TLuaFuns:MsPostStatus(string.format('�˺Ż����벻��ȷ'), tsFail, false);
			return 0;
		end
		iCount = iCount + 1;
		goto lbPwdRePress;
	end
	return 1;
end

--ѡ���ɫ
function fnSelRole()
	local iX = -1;
	local iY = -1;
	local iRet = -1;
	local IsEnterRolePage = false;
	local dwTickCount = TLuaFuns:MsGetTickCount();
	--ѡ��Ƶ������ȡ���ˣ� ������Ϸ�����ɫ���滹����Ҫʱ�䣬 ���ԣ� ��ʱ��ӵ�������
	local dwSelRoleDelay = TLuaFuns:MsGetDelay('ѡ���ɫ�ȴ�') * 1000;
	local dwSelChannelDelay = TLuaFuns:MsGetDelay('ѡ��Ƶ���ȴ�') * 1000;
	local dwWaitTick = dwSelRoleDelay + dwSelChannelDelay;
	TLuaFuns:MsPostStatus(string.format('�ȴ�ѡ���ɫ[%s]...',GRoleName));
	while TLuaFuns:MsGetTickCount() - dwTickCount <= dwWaitTick do
		::lblSelRole::
		TLuaFuns:MsSleep(100);
		if TLuaFuns:MsCheck() == 0 then
			return 0;
		end
		iX, iY, iRet = TLuaFuns:MsFindImgEx('SelRole.bmp', 1.0, 5);
		if -1 == iRet then
			goto lblSelRole;
		end
		
		IsEnterRolePage = true;
		iX, iY = TLuaFuns:MsFindImgEx('Cancel.bmp', 0.8);
		if (iX ~= -1) and (iY ~= -1) then
			TLuaFuns:MsClick(iX + 5, iY + 5, 10, 5);
			TLuaFuns:MsSleep(100);
			TLuaFuns:MsClick(iX + 5, iY + 5, 10, 5);
			TLuaFuns:MsSleep(100);
		end
		
		iX, iY, iRet = TLuaFuns:MsFindStringEx('��ID������Ϸ��|����ʧ�ܣ�|ȡ�����޷����Ƽ�|�������ӷ�����', 'ffffff-000000');
		
		if 0 == iRet then
			TLuaFuns:MsPostStatus('��ID������Ϸ��', tsFail, false);
			return 0;
		end
		
		if 1 == iRet then
			TLuaFuns:MsPostStatus('����ʧ��', tsFail);
			return 0;
		end
		if 2 == iRet then
			TLuaFuns:MsClick(iX + 40, iY + 60, 10, 5);
			TLuaFuns:MsSleep(100);
			TLuaFuns:MsClick(iX + 40, iY + 60, 10, 5);
			TLuaFuns:MsSleep(100);
		end
		if 3 == iRet then
			goto lblSelRole;
		end
		
		iX, iY, iRet = TLuaFuns:MsFindImgEx('frozen.bmp', 1.0, 5);
		if -1 == iRet then
			goto lblSelRole;
		end
	end
	
	if not IsEnterRolePage then
		print('�����ɫҳ�泬ʱ');
		return 0;
	end
	print('У�����');
	return 1;
end
---------------------------------------------------------------------------------
function fnDispatchOrder()

	print('��ʼִ�нű�');
	
	GAccount = '275175822';
	GPassWord = 'a09137320286';

	--�����ϷOnLine���򷵻ؽ�ɫ����ѡȡ��ɫ
	local iRet = 0;
	print('��ʼִ�нű�1');
	local bRet = false;

	iRet = fnStartGame();
	if 0 == iRet then
		return 0;
	end    
	print('��ʼִ�нű�3');
	iRet = fnSelGameArea();
	if 0 == iRet then
		return 0;
	end
	print('��ʼִ�нű�4');
	iRet = fnLoginGame();
	if 0 == iRet then
		return 0;
	end

	print('��ʼִ�нű�6');
	iRet = fnSelRole();
	if 0 == iRet then
		return 0;
	end

	return 1;
end

fnDispatchOrder();

--[[
function Test()
	TLuaFuns:MsCreateBmp('���˺ű�ͣ��','AccFengTing',255,255,255);
end
 
Test();
--]]

