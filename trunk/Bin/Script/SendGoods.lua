--������������
TOrderInfo = require "TOrderInfo";
TLuaFuns = require "TLuaFuns";

function inspect(table, name)
  print ("--- " .. name .. " consists of");
  for n,v in pairs(table) do print(n, v) end;
  print();
end

inspect(TOrderInfo, "TOrderInfo");
inspect(TLuaFuns, "TLuaFuns");
--[[
--������״̬
tsNormal 	 = 100;
tsStart 	 = 0; 
tsSuccess 	 = 1;
tsDoing 	 = 2;
tsSuspend 	 = 3;
tsTargetFail = 4
tsFail 		 = 5;
tsKillTask   = 6;

--��������
GEnterGameTick = 0;

--���ݴ��ڱ���رոô���
local function CloseWindowByTitle(title)
    local cmd = [[taskkill /F /FI "WINDOWTITLE eq %s"]]
    cmd = string.format(cmd, title)
    os.execute(cmd)
end

--���ݽ������رմ���
local function CloseWindowByProcessName(name)
    local cmd  = [[taskkill /F /FI "IMAGENAME eq %s"]]
    cmd = string.format(cmd, name)
    os.execute(cmd)
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
			return 0;
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
	print('�޸���Ϸ');
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
	while true do
		TLuaFuns:MsSleep(100);
		iRet = TLuaFuns:MsCreateProcess();
		if (0 == iRet) then
			print('������Ϸʧ��');
			return 0;
		end 
		
		hGame, iRet = fnCheckStartTarget();
		
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
	print('ѡ����Ϸ����');
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
	print('�ȴ�ѡ������');
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
		print('ѡ���������ʱ');
		TLuaFuns:MsPostStatus('ѡ���������ʱ', tsFail);
		return 0;
	end
	
	--�����½��Ϸ��ť
    TLuaFuns:MsClick(X, Y);
	
	bRet = false;
	while TLuaFuns:MsGetTickCount() - dwTickCount <= dwWaitTick do
		TLuaFuns:MsSleep(100);
		if TLuaFuns:MsCheck() == 0 then
			return 0;
		end
		
		X, Y, iRet = TLuaFuns:MsFindStringEx('��ѡ��Ĵ����ӳٹ���|�÷���������ά�����޷�����|�÷������Ѿ�����', 'ffffff-000000');
		if 0 == iRet then
			TLuaFuns:MsClick(X + 100, Y + 120);
		end
		if 1 == iRet then
			TLuaFuns:MsPostStatus('�÷���������ά�����޷�����', tsFail);
			return 0;
		end
		if 2 == iRet then
			TLuaFuns:MsClick(X + 70, Y + 120);
		end
		
		X, Y, iRet = TLuaFuns:MsFindImgEx('DelayBig.bmp|IssnLogin.bmp|InSelArea.bmp', 0.8);
		if 0 == iRet then 
			print('������ʱ����...');
			TLuaFuns:MsClick(X + 100, Y + 120);
			TLuaFuns:MsPressEnter();
		end	
		if 1 == iRet then 
			bRet = true;
			break;
		end
		if 2 == iRet then 
			TLuaFuns:MsClick(X, Y);
		end
	end
	
	if not bRet then
		TLuaFuns:MsPostStatus('ѡ���������ʱ', tsFail);
		return 0;
	end
	
	TLuaFuns:MsPostStatus('ѡ��������ɹ�');
	TLuaFuns:MsPostStatus('�ȴ���ȫ���');

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
	
	print('��ȫ������');
	TLuaFuns:MsPostStatus('��ȫ������');
	return 1;
end

--��¼�ж�
function fnLoginValidate()
	print('��¼�ж�...');
	--local sAccount = TOrderInfo.GetAccount();
	--local sPassword = TOrderInfo.GetPassWord();
	local hGame = 0;
	local bRet = false;
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
		
		iX, iY, iRet = TLuaFuns:MsFindStringEx('�������ʺ�|����������|�ͻ��˰�ȫ', 'f4dcaf-000000|fcc45c-000000|ffffff-000000', 1.0, 2);			
		if 0 == iResult then
			TLuaFuns:MsPostStatus('QQ�˺�Ϊ��', tsFail, false);
			return 0;
		end
		if 1 == iResult then
			TLuaFuns:MsPostStatus('����Ϊ��', tsFail, false);
			return 0;
		end
		if 2 == iResult then
			TLuaFuns:MsPostStatus('�ͻ��˰�ȫ�������ʧ��', tsFail, false);
			return 0;
		end
		
		iX, iY, iRet = TLuaFuns:MsFindImgEx('PwdError.bmp|AccError.bmp|NeedDm.bmp', 0.8, 2);
		if 0 == iRet then
			TLuaFuns:MsPostStatus('�˺Ż����벻��ȷ', tsFail, false);
			return 0;
		end
		if 1 == iRet then
			TLuaFuns:MsPostStatus('����QQ��ʱ�޷���¼����ָ�����ʹ��', tsFail, false);
			return 0;
		end
		if 2 == iRet then
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
					TLuaFuns:MsClick(iX + 300, iY - 40);
					TLuaFuns:MsSleep(500);
					TLuaFuns:MsPressString(hLogin, sCode);
					TLuaFuns:MsSleep(500);
					TLuaFuns:MsPressEnter();
					print('��֤���������');
				end
			end
		end
	end
end


--��¼��Ϸ
function fnLoginGame()
	print('��ʼ��½...');

	local sAccount = TOrderInfo.GetAccount();
	local sAreaName = TOrderInfo.GetAreaName();
	local hGameHandle = 0; -- = TLuaFuns:MsGetGameHandle();
	local hPwd = 0;
	local X1 = 0;
	local X2 = 0;
	local Y1 = 0;
	local Y2 = 0;
	local iTop = 0;
	local iLeft = 0;
	
	--�ر���Ϸ���
	--CloseWindowByTitle('DNF��Ƶ������');
	CloseWindowByProcessName('AdvertDialog.exe');
	
	hGameHandle = TLuaFuns:MsFindWindow('','���³�����ʿ��¼����');
	if 0 == TLuaFuns:MsIsWindow(hGameHandle) then
		TLuaFuns:MsPostStatus('��½�����쳣�˳�', tsFail);
		return 0;
	end
	
	TLuaFuns:MsSetGameHandle(hGameHandle);
	TLuaFuns:MsPostStatus('��ʼ��¼[%s|%s]...', sAccount, sAreaName);

	if TLuaFuns:MsCheck() == 0 then
		return 0;
	end

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
	TLuaFuns:MsFrontWindow(hGameHandle);
	TLuaFuns:MsClick(iLeft, iTop);
	TLuaFuns:MsSleep(500);
	TLuaFuns:MsPressPassWord(TOrderInfo:GetPassWord());
	TLuaFuns:MsSleep(200);
	TLuaFuns:MsPressEnter();
	print('�����������...');
	
	--��¼�ж�
	if 0 == fnLoginValidate() then
		return 0;
	end
	
	return 1;
end

--ѡ��Ƶ��
function fnSelChannel()
	print('������Ϸ,�ȴ�ѡ��Ƶ��.');
	TLuaFuns:MsPostStatus('������Ϸ,�ȴ�ѡ��Ƶ��.');
	local iRet = 0;
	local hGame = 0;
	local hLogin = 0;
	local dwTickCount = TLuaFuns:MsGetTickCount();
	local dwWaitTick = TLuaFuns:MsGetDelay('������Ϸ�ȴ�');
	dwWaitTick = (dwWaitTick + TLuaFuns:MsGetDelay('��ȫ��֤�ȴ�')) * 1000;		
	while TLuaFuns:MsGetTickCount() - dwTickCount <= dwWaitTick do
		TLuaFuns:MsSleep(100);
		--�ҵ������� break;
		hGame = TLuaFuns:MsFindWindow('���³�����ʿ','���³�����ʿ');
		if 0 ~= TLuaFuns:MsIsWindow(hGame) then
			break;
		end
		
		--�����ڻ�û�ҵ�����¼������ʧ�����쳣�˳�
		hLogin = TLuaFuns:MsFindWindow('','���³�����ʿ��¼����');
		if 0 == TLuaFuns:MsIsWindow(hLogin) then
			TLuaFuns:MsPostStatus('��½�����쳣�˳�', tsFail);
			return 0;
		end
	end
	
	if 0 == TLuaFuns:MsIsWindow(hGame) then
		TLuaFuns:PostStatus('ѡ��Ƶ����ʱ...', tsFail);
		return 0;
	end
		
	TLuaFuns:MsSetGameHandle(hGame);
	
	dwTickCount = TLuaFuns:MsGetTickCount();
	dwWaitTick = TLuaFuns:MsGetDelay('ѡ��Ƶ���ȴ�') * 1000;
	print(dwTickCount, dwWaitTick);
	while TLuaFuns:MsGetTickCount() - dwTickCount <= dwWaitTick do
		TLuaFuns:MsSleep(100);
		if TLuaFuns:MsCheck() == 0 then
			return 0;
		end
		iRet = TLuaFuns:MsFindString('˳��|����|��ͨ|ӵ��|����', TLuaFuns:MsGetPianSe('��½_ѡ��Ƶ��'));
		if iRet ~= 0 then
			break;
		end
	end
	
	if iRet == 0 then
		TLuaFuns:PostStatus('ѡ��Ƶ����ʱ...', tsFail);
		return 0;
	end
	
	local iPosX = -1;
	local iPosY = -1;
	print('��ʼѡ��Ƶ��');
	TLuaFuns:MsPostStatus('��ʼѡ��Ƶ��');
	
	for i=0, 3 do
		if i > 0 then
			-- ��һҳ
			TLuaFuns:MsClick(425, 475);
			iRet = TLuaFuns:MsFindString('˳��|����|��ͨ|ӵ��|����', TLuaFuns:MsGetPianSe('��½_ѡ��Ƶ��'), 1.0, 50);			
			if iRet == 0 then
				break;
			end
		end
		iPosX, iPosY = TLuaFuns:MsFindStringEx('˳��|����|��ͨ|ӵ��', TLuaFuns:MsGetPianSe('��½_ѡ��Ƶ��'));
		if (iPosX ~= -1) and (iPosY ~= -1) then
			break;
		end
	end

	if (iPosX == -1) or (iPosY == -1) then
		TLuaFuns:MsPostStatus('����Ƶ������', tsFail);
		return 0;
	end

	print('���Ƶ��...');
	print(iPosX, iPosY);
	TLuaFuns:MsDbClick(iPosX, iPosY);
	TLuaFuns:MsSleep(100);
	TLuaFuns:MsDbClick(iPosX, iPosY);
	TLuaFuns:MsSleep(500);
	--[[
	--���߿���̨,��ѡ���Ƶ����Ϣ
	iRet = TLuaFuns:MsFindString('��ǰƵ����������', 'ffffff-000000', 0.9, 5);
    if iRet == 0 then
		TLuaFuns:Ms:PostStatus('����Ƶ������', tsFail);
		return 0;
    end	
	]]
	return 1;	
end

--ѡ���ɫ
function fnSelRole()
	print('�ȴ�ѡ���ɫ.');
	TLuaFuns:MsPostStatus('�ȴ�ѡ���ɫ.');
	local iX = -1;
	local iY = -1;
	local iRet = -1;
	local dwTickCount = TLuaFuns:MsGetTickCount();
	local dwWaitTick = TLuaFuns:MsGetDelay('ѡ���ɫ�ȴ�') * 1000;
	local sRoleName = TOrderInfo:GetRole();
	while TLuaFuns:MsGetTickCount() - dwTickCount <= dwWaitTick do
		TLuaFuns:MsSleep(100);
		if TLuaFuns:MsCheck() == 0 then
			return 0;
		end
		iX, iY = TLuaFuns:MsFindImgEx('Cancel.bmp', 0.8);
		if (iX ~= -1) and (iY ~= -1) then
			TLuaFuns:MsClick(iX + 5, iY + 5);
			Sleep(100);
			TLuaFuns:MsClick(iX + 5, iY + 5);
			Sleep(100);
		end
		
		iX, iY, iRet = TLuaFuns:MsFindStringEx('����ʧ�ܣ�|ȡ�����޷����Ƽ�|�������ӷ�����', 'ffffff-000000');
		if 0 == iRet then
			TLuaFuns:MsPostStatus('����ʧ��', tsFail);
			return 0;
		end
		if 1 == iRet then
			TLuaFuns:MsClick(iX + 40, iY + 60);
			Sleep(100);
			TLuaFuns:MsClick(iX + 40, iY + 60);
			Sleep(100);
		end
		if 2 ~= iRet then
			TLuaFuns:MsPostStatus(string.format('���ҽ�ɫ[%s]',sRoleName));
			-- TODO  Role.bmp �����ֿ���Ҫ��
			iX, iY = TLuaFuns:MsFindImgEx('Role.bmp');
			if (iX ~= -1) and (iY ~= -1) then
				break;
			end
		end
	end
	
	if (iX == -1) or (iY == -1) then
		TLuaFuns:MsPostStatus(string.format('��ɫ[%s]�����ڣ�', sRoleName), tsFail, False);
		return 0;
    end;
	
	GEnterGameTick = TLuaFuns:MsGetTickCount();
	TLuaFuns:MsPostStatus(string.format('�ҵ���ɫ[%s]λ��%d %d', sRoleName, iX, iY));
	TLuaFuns:MsDbClick(iX, iY);
	TLuaFuns:MsSleep(200);
	TLuaFuns:MsDbClick(iX, iY);
	TLuaFuns:MsSleep(200);
	TLuaFuns:MsDbClick(iX, iY);
	TLuaFuns:MsSleep(200);
	return 1;
end

--�˻ص���ɫ����
function fnBackToRoler()
	local iX, iY;
	local iRet = 0;
	local dwWait = 15 * 1000;
	local dwTickCount = TLuaFuns:MsGetTickCount();
	while TLuaFuns:MsGetTickCount() - dwTickCount <= dwWaitTick do
		TLuaFuns:MsSleep(100);
		if 0 == TLuaFuns:MsCheck() then
			return 0;
		end
		iRet = TLuaFuns:MsFindImg('SelRole.bmp', 0.8, 1);
		if 0 ~= iRet then 
			break;
			return 1;
		end
		TLuaFuns:MsPressEsc();
		TLuaFuns:MsSleep(100);
		if 0 == TLuaFuns:MsFindString('��Ϸ�˵�(Esc)', 'ffffff-000000') then
			iX, iY = TLuaFuns:MsFindString('ѡ���ɫ', TLuaFuns:MsGetPianSe('�˵�_ѡ���ɫ'));
			if (-1 ~= iX) and (-1 ~= iY) then
				TLuaFuns:MsClick(iX + 5, iY + 2);
			end
		end
	end
end

--�ж��Ƿ������Ϸ
function fnIsEnterTheGame(iDelay)
	local hGame = TLuaFuns:MsGetGameHandle();
	if 0 == TLuaFuns:MsIsWindow(hGame) then
		return 0;
	end	
	return TLuaFuns:MsFindImg('LoginSuccess.bmp', 0.7, iDelay);
end

--������Ϸ
function fnEnterTheGame()
	local bRet = false;
	local sRoleName = TOrderInfo:GetRole();
	print(string.format('�ȴ���ɫ[%s]������Ϸ', sRoleName));
	TLuaFuns:MsPostStatus(string.format('�ȴ���ɫ[%s]������Ϸ', sRoleName));
	local iX = -1;
	local iY = -1;
	local dwTickCount = TLuaFuns:MsGetTickCount();
	local dwWaitTick = TLuaFuns:MsGetDelay('������Ϸ�ȴ�') * 1000;
	local IsEnterTheGame = false;
	local iRet = 0;
	local hGame = TLuaFuns:MsGetGameHandle();
	if 0 == TLuaFuns:MsIsWindow(hGame) then
		hGame = TLuaFuns:MsFindWindow('���³�����ʿ', '���³�����ʿ');
		TLuaFuns:MsSetGameHandle(hGame);
	end
	while (TLuaFuns:MsGetTickCount() - dwTickCount <= dwWaitTick) or
		  (TLuaFuns:MsGetTickCount() - GEnterGameTick <= 60 * 1000) do
		TLuaFuns:MsSleep(100);
		bRet = false;
		print(string.format('������Ϸ[%d]...', dwWaitTick));
		if 0 == TLuaFuns:MsCheck() then
			return 0;
		end
		iRet = fnIsEnterTheGame(1);
		IsEnterTheGame = iRet == 1;
		TLuaFuns:MsFrontWindow(hGame);
		TLuaFuns:MsSleep(100);
		TLuaFuns:MsPressEsc();
		TLuaFuns:MsSleep(100);
		TLuaFuns:MsPressEsc();
		
		iX, iY, iRet = TLuaFuns:MsFindImgEx('Ok.bmp|GiveUp.bmp|Enter.bmp|NextStep.bmp', 0.7);
		if -1 ~= iRet then
			TLuaFuns:MsClick(iX + 5, iY + 5);
			bRet = true;
		end  
		----------          -------------------------
		iX, iY, iRet = TLuaFuns:MsFindStringEx('ȷ��|�ر�|��������|����˹������|˽����������', TLuaFuns:MsGetPianSe('��½_�رչ��'));
		if (0 == iRet) or (1 == iRet) then
			TLuaFuns:MsClick(iX + 5, iY + 5);
			bRet = true;
		end
		if 2 == iRet then
			TLuaFuns:MsClick(iX + 150, iY + 10);
			bRet = true;
		end
		if (3 == iRet) or (4 == iRet) then
			TLuaFuns:MsClick(iX + 390, iY + 5);
			bRet = true;
		end
		TLuaFuns:MsSleep(100);
		TLuaFuns:MsPressChar('L');
		TLuaFuns:MsSleep(1000);
		TLuaFuns:MsPressChar('L');
		TLuaFuns:MsSleep(500);
		
		if (not bRet) and (IsEnterTheGame) then 
			break;
		end
		
	end
	
	if not IsEnterTheGame then
		print('��ɫ������Ϸ��ʱ...');
		TLuaFuns:MsPostStatus('��ɫ������Ϸ��ʱ...', tsFail);
		return 0;
	end	
	print('��ɫ������Ϸ...');
	TLuaFuns:MsPostStatus('��ɫ������Ϸ...');
	return 1;
end

--���ʼ���
function fnOpenMailBox()
	local iRet = 0;
	local iX = -1;
	local iY = -1;
	local bRet = false;
	local sPianSe = '';
	iRet = TLuaFuns:MsFindString('��Ϸ�˵�(Esc)|����(L)', TLuaFuns:MsGetPianSe('�˵�_��ͨ����'));
	if 0 ~= iRet then
		TLuaFuns:MsPressEsc();
	end
	
	sPianSe = string.format('%s|%s', TLuaFuns:MsGetPianSe('�ʼ�_�ʼ���_δѡ��'), TLuaFuns:MsGetPianSe('�ʼ�_�ʼ���_NPC'));
	for i=1, 3 do
		TLuaFuns:MsSleep(200);
		iX, iY, iRet = TLuaFuns:MsFindStringEx('�ʼ�������|�ʼ���', sPianSe);
		if 0 == iRet then
			--�Ѿ���
			bRet = true;
			break;
		end
		if 1 == iRet then
			print('����ʼ���X[%d]Y[%d]', iX, iY);
			TLuaFuns:MsClick(iX + 10, iY + 5);
			TLuaFuns:MsSleep(100);
			TLuaFuns:MsClick(iX + 10, iY + 5);
			TLuaFuns:MsSleep(1000);
		end
	end
	
	if not bRet then
		TLuaFuns:MsPostStatus('���ʼ���ʧ��', tsFail);
		return 0;
	end
	return 1;
end

--��������ʼ���ǩ
function fnClickSendMailLabel()
	local iRet = 0;
	local bRet = false;
	local hGame = TLuaFuns:MsGetGameHandle();
	local iX = -1; local iY = -1;
	iX, iY = TLuaFuns:MsGetTopLeft(hGame);
	if (iX == -1) or (iY == -1) then
		TLuaFuns:MsPostStatus('��Ϸ���Զ��ر�', tsFail);
		return 0;
	end
	for i=1, 3 do
		iRet = TLuaFuns:MsFindString('�����ʼ�', TLuaFuns:MsGetPianSe('�ʼ�_�ʼ���_��ѡ��'));
		if 0 ~= iRet then
			bRet = true;
			break;
		end
		TLuaFuns:MsClick(iX + 310, iY + 155);
		TLuaFuns:MsSleep(500);
	end
	
	if not bRet then
		TLuaFuns:MsPostStatus('���ʼ���ʧ��', tsFail);
		return 0;
	end
	return 1;
end

--�����ɫ����
function fnInputRoleName(sRoleName)
	--local iRet = 0;
	local bRet = 0;
	local iX = -1;
	local iY = -1;
	for i=1, 3 do
		bRet = false;
		iX, iY = TLuaFuns:MsFindStringEx('�����ʼ�', TLuaFuns:MsGetPianSe('�ʼ�_�ʼ���_��ѡ��'));
		if (iX ~= -1) and (iY ~= -1) then
			TLuaFuns:MsClick(iX + 75, iY + 25);
			bRet = true;
			break;
		end 
	end
	
	if not bRet then
		TLuaFuns:MsPostStatus('û�д��ʼ���', tsFail);
		return 0;
	end
	
	local hGame = TLuaFuns:MsGetGameHandle(); 
	
	TLuaFuns:MsSleep(500);
	TLuaFuns:MsPressDel(12);
	TLuaFuns:MsSleep(500);
	TLuaFuns:MsPressString(hGame, sRoleName);
	TLuaFuns:MsSleep(500);
	return 1;
end

--������
function fnInputMoney(AX, AY, ANum)
	print('������');
	local hGame = TLuaFuns:MsGetGameHandle();
	local iX = -1;
	local iY = -1;
	local iRet = -1;
	iX, iY = TLuaFuns:MsGetTopLeft(hGame);
	for i=1, 3 do
		if i > 1 then
			iRet = TLuaFuns:MsGetNumber(iX + 290, iY + 380, iX + 410, iY + 410, 'ffffff-000000');
			print(iRet, ANum);
			if ANum == iRet then
				return 1;				
			end
		end
		TLuaFuns:MsClick(AX, AY);
		TLuaFuns:MsSleep(200);
		TLuaFuns:MsClick(AX, AY);
		TLuaFuns:MsSleep(500);
		TLuaFuns:MsPressDel(20);
		TLuaFuns:MsSleep(500);
		local sMoney = string.format('%d', ANum);
		TLuaFuns:MsPressString(hGame, sMoney);
	end
	print('���������');
	return 0;
end

--��ȡ�������
function fnGetBagMoney()
	local iRet = -1;
	local hGame = TLuaFuns:MsGetGameHandle();	
	
	local iX = -1;
	local iY = -1;
	
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
	
	if iRet ~= -1 then
		TLuaFuns:MsPostStatus('��ȡ�������ʧ��', tsFail);
	end 
	
	return iRet;
end

-- TODO �ϴ���ͼ
function fnPostImg()
	local iRet = 0;
	print('��ʼ�ϴ���ͼ...');
	iRet = TLuaFuns:MsPostImg();
	return iRet;
end

--У���ɫ
function fnCheckRoleInfo()
	print('У���ɫ');
	local dwTickCount = TLuaFuns:MsGetTickCount();
	local dwWaitTick = 5 * 1000;
	local iX = -1;
	local iY = -1;
	local sRoleName = TOrderInfo:GetRole();
	while TLuaFuns:MsGetTickCount() - dwTickCount <= dwWaitTick do
		TLuaFuns:MsSleep(100);
		if 0 == TLuaFuns:MsCheck() then
			return 0;
		end
		
		iX, iY = TLuaFuns:MsFindStringEx('�����ʼ�', TLuaFuns:MsGetPianSe('�ʼ�_�ʼ���_��ѡ��'));
		if (iX ~= -1) and (iY ~= -1) then
			break;
		end 
	end
	print(iX, iY);
	dwTickCount = TLuaFuns:MsGetTickCount();
	dwWaitTick = TLuaFuns:MsGetDelay('����ɫ���ڵȴ�') * 1000;
	while TLuaFuns:MsGetTickCount() - dwTickCount <= dwWaitTick do
		TLuaFuns:MsSleep(100);
		if 0 == TLuaFuns:MsCheck() then
			return 0;
		end
		print('У���ɫ��...');
		TLuaFuns:MsClick(iX + 120, iY + 25);
		
		TLuaFuns:MsSleep(1000);
		iX, iY = TLuaFuns:MsFindStringEx('����', TLuaFuns:MsGetPianSe('�˵�_��ͨ����'));
		if (iX ~= -1) and (iY ~= -1) then
			break;
		end
	end
	print(iX, iY);
	if (iX == -1) or (iY == -1) then
		TLuaFuns:MsPostStatus('��ɫ������ʧ��', tsFail);
		return 0;
	end
	
	dwTickCount = TLuaFuns:MsGetTickCount();
	dwWaitTick = 5 * 1000;
	local iRet = -1;
	while TLuaFuns:MsGetTickCount() - dwTickCount <= dwWaitTick do
		TLuaFuns:MsSleep(100);
		if 0 == TLuaFuns:MsCheck() then
			return 0;
		end
		
		iX, iY, iRet = TLuaFuns:MsFindStringEx('��ɫ����|�޷��ҵ��ý�ɫ', 'ffffff-000000');
		if 0 == iRet then
			break;
		end
		if 1 == iRet then
			TLuaFuns:MsPostStatus(string.format('�Է���ɫ[%s]������',sRoleName), tsTargetFail, false);
			return 0;
		end
	end
	if (iX == -1) or (iY == -1) then
		TLuaFuns:MsPostStatus(string.format('�Է���ɫ[%s]������',sRoleName), tsTargetFail, false);
		return 0;
	end	
	
	-- TODO ������������Ҫ����ȼ�	
	if true then
		local iLevel = -1;
		--��ȡ�ȼ�
		for i=1, 3 do
			iLevel = TLuaFuns:MsGetNumber(iX, iY + 5, iX + 100, iY + 30, 'ffffff-000000');
			if iLevel > -1 then
				print(string.format('��ȡ�Է���ɫ�ȼ�Ϊ: %d', iLevel));
				break;
			end
		end
		
		if iLevel == -1 then
			--TODO
			TLuaFuns:MsPostStatus(string.format('��ȡ��ɫ[%s]�ĵȼ�ʧ��', '123'), tsFail);
			return 0;
		end
		--TODO
		if �����ȼ� <> iLevel then
			TLuaFuns:MsPostStatus(string.format('��ɫ[%s]�����ȼ�[%d]��ʵ�ʵȼ�[%d]���������账��', '123'), tsTargetFail, false);
			return 0;
		end
	end
	
	return 1;
end

--�����ʼ�ʱ����
function fnDaMaOfSendMail(hGameHandle)
	local iRet = -1;
	local iX = -1;
	local iY = -1;
	local bRet = false;
	for i=1, 3 do
		if 0 == TLuaFuns:MsCheck() then
			return 0;
		end
		iX, iY = TLuaFuns:MsFindImgEx('MailInputCheckCode.bmp', 0.9);
		
		if (iX ~= -1) and (iY ~= -1) then
			iRet = TLuaFuns:MsCaptureArea(iX - 212, iY - 24, iX - 82, iY + 29, 'CheckCode.bmp');
			if 0 ~= iRet then
				break;
			end
		end		
	end

	if iRet == 0 then
		print('��ȡ��֤��ʧ��...');
		return 0;
	end
	
	for i=1, 3 do
		bRet = false;
		TLuaFuns:MsPostStatus('�����ʼ���֤�뵽�����');
		local sRet = TLuaFuns:MsDaMa('CheckCode.bmp', 12);
		print(sRet);
		if sRet ~= '' then
			print('������֤��...');
			TLuaFuns:MsPressString(hGameHandle, sRet);
			TLuaFuns:MsSleep(500);
			--TODO
			TLuaFuns:MsCaptureGame('3.bmp');
			if 0 == TLuaFuns:MsCheck() then
				return 0;
			end
			print('���ȷ����ť');
			for j=1, 3 do
				TLuaFuns:MsClick(iX - 120, iY + 130);
				TLuaFuns:MsSleep(3000);
				iRet = TLuaFuns:MsFindImg('CheckCode.bmp');
				print(string.format('iRet: %d', iRet));
				if 0 == iRet then
					bRet = true;
					break;
				end
			end	
			if bRet then
				break;
			end
		end
	end
	
	if not bRet then	
		return 0;
	end
	return 1;
end

--�ȴ��ʼ����ͽ�� 
function fnCheckSendResult()
	local iResult = -1;
	local iRet = 0;
	local x, y;
	local hGame = TLuaFuns:MsGetGameHandle();
	local dwTickCount = TLuaFuns:MsGetTickCount();
	local dwWaitTick = TLuaFuns:MsGetDelay('�ʼ���֤�봰�ڵȴ�') * 1000;
	while TLuaFuns:MsGetTickCount() - dwTickCount <= dwWaitTick do
		TLuaFuns:MsSleep(100);
		if 0 == TLuaFuns:MsCheck() then
			return 0;
		end
		
		if 0 ~= TLuaFuns:MsFindImg('MailCheckCodeDlg.bmp', 0.9) then
			iRet = 1;
			break;
		end
		
		x, y, iResult = TLuaFuns:MsFindStringEx('�ѳɹ������ʼ�|���ڶԷ��ĺ�������|�ѳ�����ҵ�ʹ������', 'ffffff-000000');			
		if 0 == iResult then
			iRet = 2;
			break;
		end
		if 1 == iResult then
			TLuaFuns:MsPostStatus('���ڶԷ��ĺ������ڣ��޷����в���', tsFail, False);
			return 0;
		end
		if 2 == iResult then
			TLuaFuns:MsPostStatus('�ѳ�����ҵ�ʹ������', tsFail, False);
			return 0;
		end
	end
	
	if iRet == 0 then
		TLuaFuns:MsPostStatus('�ȴ����ͽ����ʱ', tsFail);
		return 0;
	end
	
	if iRet == 1 then
		iRet = fnDaMaOfSendMail(hGame);
		
		if iRet == 0 then
			print('Զ�̴���ʧ��...');
			return iRet;
		end
		
		local dwTickCount = TLuaFuns:MsGetTickCount();
		local dwWaitTick = TLuaFuns:MsGetDelay('������ȴ�') * 1000;
		while TLuaFuns:MsGetTickCount() - dwTickCount <= dwWaitTick do
			TLuaFuns:MsSleep(100);
			if 0 == TLuaFuns:MsCheck() then
				return 0;
			end
			
			x, y, iResult = TLuaFuns:MsFindStringEx('�ѳɹ������ʼ�|���ڶԷ��ĺ�������|�ѳ�����ҵ�ʹ������', 'ffffff-000000');			
			if 0 == iResult then
				iRet = 2;
				break;
			end
			if 1 == iResult then
				TLuaFuns:MsPostStatus('���ڶԷ��ĺ������ڣ��޷����в���', tsFail, False);
				return 0;
			end
			if 2 == iResult then
				TLuaFuns:MsPostStatus('�ѳ�����ҵ�ʹ������', tsFail, False);
				return 0;
			end
		end
	end
	
	if iRet == 2 then
		--��������
		TLuaFuns:MsPostStatus(string.format('����[%s]�ѷ���[%d]', TOrderInfo.GetOrderNo(), 10000));		
		local iX = -1; local iY = -1;
		iX, iY = TLuaFuns:MsGetTopLeft(hGame);
		TLuaFuns:MsClick(iX + 375, iY + 175);
		TLuaFuns:MsSleep(1000);
		-- TODO ͼƬ·��
		TLuaFuns:MsCaptureGame('2.bmp');
		TLuaFuns:MsSleep(1000);
		TLuaFuns:MsClick(x + 45, y + 35);
		return 1;
	end
	return 0;
end

--�ⰲȫ
--1: �ɹ�������Ҫ�ⰲȫ 2: �ɹ�����Ҫ�ⰲȫ 3: ʧ�ܣ� ��Ҫ�ⰲȫ
function fnQuitSafe()
	local iRet = 3;
	local dwWaitTick = 0;
	local iX,iY;
	TLuaFuns:MsPostStatus('����Ƿ���Ҫ�ⰲȫ...');
	if 0 == TLuaFuns:MsFindString('ȷ�����', 'ddc593-000000') then
		print('����Ҫ�ⰲȫ');
		return 1;
	end
	
	iX,iY = TLuaFuns:MsGetTopLeft(TLuaFuns:MsGetGameHandle());
	TLuaFuns:MsClick(iX + 435, iY + 335);
	TLuaFuns:MsPostStatus('�˺���Ҫ��󣬳���ʼ�ⰲȫ');
	--TODO TLuaFuns:MsQuitSafe()
	iRet = TLuaFuns:MsQuitSafe();
	
	if 0 == iRet then
		print('�ⰲȫʧ��');
		return 3;
	end
	
	dwWaitTick = TLuaFuns:MsGetDelay('���ɹ���ȴ�') * 1000;
	dwTickCount = TLuaFuns:MsGetTickCount();
	while TLuaFuns:MsGetTickCount() - dwTickCount <= dwWaitTick do
		if 0 ~= TLuaFuns:MsFindString('�����˻��ѳɹ��˳���ȫģʽ', 'ffffff-000000') then
			TLuaFuns:MsPressEnter();
			TLuaFuns:MsSleep(100);
		end
	end
	print('�ⰲȫ���');
	return 2;
end

--һ�η����������������ܻ��������
function fnSingleSend(ASendNum, AIsFirst)
	local iRet = 0;	
	if 0 == TLuaFuns:MsCheck() then
		return 0;
	end
	--�ж���û�д��ʼ���
	iRet = TLuaFuns:MsFindString('�ʼ���', 'ffffff-000000', 1.0, 3);
	if 0 == iRet then
		if 0 == fnOpenMailBox() then 
			return 0;
		end
		
		if 0 == fnClickSendMailLabel() then
			return 0;
		end
	end
	
	print('��ʼ��ȡ�����');	
	local iBagMoney = fnGetBagMoney();
	if iBagMoney == -1 then
		TLuaFuns:MsPostStatus('��ȡ�������ʧ��', tsFail);
		return 0;
	end
	
	--iBagMoney = iBagMoney / 10000;
	TLuaFuns:MsPostStatus(string.format('��ǰ���: %d', iBagMoney));
	if iBagMoney - 20000 < ASendNum then 
		TLuaFuns:MsPostStatus(string.format('�������[%d]С����Ҫ���׵Ľ��[%d]', iBagMoney, ASendNum), tsFail, False);
        return 0;
	end
	-- TODO ϵͳ��浽ʱ��ö���, ���вֿ⸡��
	if AIsFirst and (math.abs(iBagMoney - TOrderInfo:GetStock() * 10000) > 1500000) then
		TLuaFuns:MsPostStatus(string.format('ʵ�ʿ��[%d]��ϵͳ���[%d]������ϵͳ�������[%d]', iBagMoney, 10000, 1500000), tsFail, False);
        return 0;
	end	

	if 0 == fnInputRoleName(TOrderInfo:GetReceiptRole()) then
		TLuaFuns:MsPostStatus('�����ɫ��ʧ��', tsFail);
        return 0;
	end
	
	if 0 == fnCheckRoleInfo() then 
		return 0;
	end

	local hGame = TLuaFuns:MsGetGameHandle();
	local iX = -1;
	local iY = -1;
	iX, iY = TLuaFuns:MsGetTopLeft(hGame);
	fnInputMoney(iX + 400, iY + 395, ASendNum());
	TLuaFuns:MsSleep(1000);
	-- TODO ��ͼ����·��
	TLuaFuns:MsCaptureGame('1.bmp');
	for i=1, 3 do
		print(i);
		if 0 == TLuaFuns:MsCheck() then
			return 0;
		end
		
		TLuaFuns:MsClick(iX + 260, iY + 460);
		TLuaFuns:MsSleep(100);
		TLuaFuns:MsClick(iX + 260, iY + 460);
		TLuaFuns:MsSleep(1000);
		if AIsFirst then
			iRet = fnQuitSafe();

			if iRet == 3 then
				-- TODO ��ͣ������ �����ֶ������ȫ
				-- GSharedInfo.AutoSend.Status := 2;
				TLuaFuns:MsPostStatus('�ⰲȫʧ��');
				if 0 == TLuaFuns:MsCheck() then
					return 0;
				end
			end
			
			if iRet == 2 then
				print('��Ҫ�ⰲȫ�����ҽⰲȫ�ɹ��ˣ��ٴε�����Ͱ�ť');  
				TLuaFuns:MsClick(iX + 260, iY + 460);
				Sleep(100);
				TLuaFuns:MsClick(iX + 260, iY + 460);
			end	
		end
		print('������֤�뵯����');
		iRet = fnCheckSendResult();
		if iRet == 1 then
			break;
		end
	end
	return 1;
end

function fnSendMail()
	local iOrderNum = TOrderInfo:GetSendNum();
	local iDispatchNum = TOrderInfo:GetEachNum();
	local iOddNum = 0;
	
	if iDispatchNum >= iOrderNum then
		iDispatchNum = iOrderNum;
	end
	iOddNum = iOrderNum;
	
	while true do
		TLuaFuns:MsSleep(100);
		
		iRet = fnSingleSend(iDispatchNum * 10000, true);
		
		if 0 == iRet then
			return 0;
		end
		iOddNum = iOddNum - iDispatchNum;
		print(string.format('���=%d �ѷ�������= %d ʣ������ = %d �������', iRet, iOrderNum - iOddNum, iOddNum));
				
		if iOddNum <= 0 then
			break;
		end
		
		if iOddNum < iDispatchNum then
			iDispatchNum = iOddNum;
		end
	end
	return 1;
end

function fnDispatchOrder()
	--�����ϷOnLine���򷵻ؽ�ɫ����ѡȡ��ɫ
	local iRet = 0;
--[[	
	local bRet = false;
	if 0 ~= fnIsEnterTheGame(5) then
		if 0 ~= fnBackToRoler() then
			bRet = true;
		end
	end
	
	if not bRet then
--]]	
		iRet = fnStartGame();
		if 0 == iRet then
			return 0;
		end    
--[[
		iRet = fnSelGameArea();
		if 0 == iRet then
			return 0;
		end

		iRet = fnLoginGame();
		if 0 == iRet then
			return 0;
		end
		
		iRet = fnSelChannel();
		if 0 == iRet then
			return 0;
		end
	end
	
	iRet = fnSelRole();
	if 0 == iRet then
		return 0;
	end
	
	iRet = fnEnterTheGame();
	if 0 == iRet then
		return 0;
	end	
	
	iRet = fnSendMail();
	if 0 == iRet then
		return 0;
	end
--]]	
	return 1;
end

fnDispatchOrder();
--]]
print ('��������...');