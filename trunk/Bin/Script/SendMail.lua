--������������
TOrderInfo = require "TOrderInfo";
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
local GEnterGameTick = 0;      --�˺Ž�����Ϸ��ʼʱ��
local GChildInitBagMoney = 0;  --�Ӻų�ʼ���������
local GChildDurability = 0;    --�ӺŸ�ħװ���ָ��;ö�
local GTaskType = 0;		   --��������

local GRoleName = '';
local GTargetRoleName = '';
local GSendNum = 0; --ÿ�ν��׽����
local GEachNum = 0; --�������״���
local GCapturePath = '';

local GFeeX = -1;
local GFeeY = -1;

local VK_RETURN = 13;
local VK_ESCAPE = 27;
local VK_LEFT   = 37;
local VK_UP     = 38;
local VK_RIGHT  = 39;
local VK_DOWN   = 40;

local rsNormal       = 0;
local rsStallFinish  = 1; --�ӺŰ�̯��ɣ����ŵ��︽ħ�ص�
local rsEnchatFinish = 2; --���Ÿ�ħ���
local rsRecMoneyOk   = 3; --�Ӻ��յ����
local rsRecMoneyFail = 4; --�Ӻ�δ�յ����
local rsTargetFail   = 5; --�Է�����ʧ�ܣ�ֱ�ӽ���
local rsFinish       = 6; --�Ӻ��������

function fnGetStepNameById(id)
	local sRet = '';
	if id == 0 then sRet = '��ʼ״̬'; end;
	if id == 1 then sRet = '�ӺŰ�̯��ɣ����ŵ��︽ħ�ص�'; end;
	if id == 2 then sRet = '���Ÿ�ħ���'; end;
	if id == 3 then sRet = '�Ӻ��յ����'; end;
	if id == 4 then sRet = '�Ӻ�δ�յ����'; end;
	if id == 5 then sRet = '�Է�����ʧ�ܣ�ֱ�ӽ���'; end;
	if id == 6 then sRet = '�Ӻ��������'; end;
	
	return sRet;
end

--[[
function inspect(table, name) 
  print ("--- " .. name .. " consists of");
  for n,v in pairs(table) do print(n, v) end;
  print();
end

inspect(TOrderInfo, "TOrderInfo");
inspect(TLuaFuns, "TLuaFuns");
--]]

--[[
	--�ָ��ַ������÷�
	local str = "A,B,C,D,E,F,G,H,I"  
	local ta  = lua_string_split(str,",")  
	
	for key, value in ipairs(ta) do      
		print(key, value, ta[key]);   
	end  
	  
	--local size = table.getn(ta)  
	for i = 1, #ta do  
	  print(ta[i])  
	end 
--]]

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
		--iRet = TLuaFuns:MsFindString('��Ϸ�˵�(Esc)', TLuaFuns:MsGetPianSe('�˵�_��ͨ����'));
		iRet = TLuaFuns:MsFindString('������Ϸ', 'e6c89b-000000');
		if iRet ~= 0 then return 1; end
		TLuaFuns:MsPressEsc();
		TLuaFuns:MsSleep(500);
	end
	return 0;
end

function fnCloseMenu()
	local iRet = 0;
	local iX = -1;
	local iY = -1;
	for i = 1,9 do
		--iRet = TLuaFuns:MsFindString('��Ϸ�˵�(Esc)', TLuaFuns:MsGetPianSe('�˵�_��ͨ����'));
		iRet = TLuaFuns:MsFindString('������Ϸ', 'e6c89b-000000');
		print(i, iRet);
		if iRet == 0 then return 1; end
		TLuaFuns:MsPressEsc();
		TLuaFuns:MsSleep(500);
	end
	return 0;
end

function fnOpenMap()
	local iRet = 0;
	fnCloseMenu();
	for i=0,9 do
		if TLuaFuns:MsFindImg('Map.bmp', 0.8) == 1 then
			iRet = 1;
			break;
		end
		TLuaFuns:MsPressChar('N');
		TLuaFuns:MsSleep(500);
	end
	if (iRet == 0) then
		TLuaFuns:MsPostStatus('�򿪵�ͼδ�ҵ����ڳǣ�', tsFail);
		return 0;
	end
	return 1;
end

function fnCloseMap()
	local iRet = 0;
	for i=0,9 do
		TLuaFuns:MsPressEsc();
		TLuaFuns:MsSleep(500);
		if TLuaFuns:MsFindImg('Map.bmp', 0.8) == 0 then
			iRet = 1;
			break;
		end
	end
	if (iRet == 0) then
		TLuaFuns:MsPostStatus('�رյ�ͼʧ�ܣ�', tsFail);
		return 0;
	end
	return 1;
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
		print('���õ�¼���ھ��');		
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
			print('�����ж�');
			return 0;
		end
		X, Y = TLuaFuns:MsFindImgEx('InSelArea.bmp', 0.8);
		if (X ~= -1) and (Y ~= -1) then 
			print('�������');
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
    TLuaFuns:MsClick(X+30, Y+60, 150, 20);
	
	bRet = false;
	while TLuaFuns:MsGetTickCount() - dwTickCount <= dwWaitTick do
		TLuaFuns:MsSleep(100);
		if TLuaFuns:MsCheck() == 0 then
			return 0;
		end
		
		X, Y, iRet = TLuaFuns:MsFindStringEx('��ѡ��Ĵ����ӳٹ���|�÷���������ά�����޷�����|�÷������Ѿ�����', 'ffffff-000000');
		if 0 == iRet then
			TLuaFuns:MsClick(X + 50, Y + 120, 10, 5);
		end
		if 1 == iRet then
			TLuaFuns:MsPostStatus('�÷���������ά�����޷�����', tsFail);
			return 0;
		end
		if 2 == iRet then
			TLuaFuns:MsClick(X + 70, Y + 120, 10, 5);
		end
		
		X, Y, iRet = TLuaFuns:MsAreaFindImgEx(530, 280, 780, 360, 'DelayBig.bmp', 0.8);
		if 0 == iRet then
			print('������ʱ����');
			TLuaFuns:MsClick(X + 50, Y + 120, 20, 5);
			--TLuaFuns:MsPressEnter();
		end	
		
		X, Y, iRet = TLuaFuns:MsFindImgEx('InLogin.bmp|InSelArea.bmp', 0.9);
		if 0 == iRet then 
			bRet = true;
			break;
		end
		if 1 == iRet then 
			--TLuaFuns:MsClick(X, Y, 60, 12);
			TLuaFuns:MsClick(X+30, Y+60, 100, 20);
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
		--X, Y, iRet = TLuaFuns:MsFindImgEx('WaitCheck.bmp', 0.8, 5);
		X,Y,iRet = TLuaFuns:MsAreaFindImgEx(1210,600,1290,700, 'WaitCheck.bmp', 0.8, 5);
		print(X, Y, iRet);
		if iRet == -1 then
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
	--local sAccount = TOrderInfo.GetAccount();
	--local sPassword = TOrderInfo.GetPassWord();
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
		iRet = TLuaFuns:MsFindImg('ComponentFail.bmp');
		if 0 ~= iRet then
			TLuaFuns:MsPostStatus('�ͻ��˰�ȫ�������ʧ��', tsFail);
			return 0;
		end
		iX, iY, iRet = TLuaFuns:MsFindStringEx('�������ʺ�|����������|����QQ��ʱ�޷���¼', 'f4dcaf-000000|fcc45c-000000|ffffff-000000', 1.0, 2);			
		if 0 == iRet then
			TLuaFuns:MsPostStatus('QQ�˺�Ϊ��', tsFail, false);
			return 0;
		elseif 1 == iRet then
			TLuaFuns:MsPostStatus('����Ϊ��', tsFail, false);
			return 0;
		--elseif 2 == iRet then
		--	TLuaFuns:MsPostStatus('�ͻ��˰�ȫ�������ʧ��', tsFail, false);
		--	return 0;
		elseif 2 == iRet then
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
			--iRet = TLuaFuns:MsCaptureArea(iX, iY - 70, iX + 125, iY - 20, 'CheckCode.bmp');
			iRet = TLuaFuns:MsCaptureArea(iX, iY - 60, iX + 135, iY-5, 'CheckCode.bmp');
			if iRet ~= 0 then
				--�����ô���
				print('��ʼ����...');
				sCode = TLuaFuns:MsDaMa('CheckCode.bmp', 12);
				print(string.format('��֤��: %s', sCode));
				if sCode ~= '' then
					TLuaFuns:MsPostStatus(string.format('���������������ֵ: %s', sCode));
					--������֤��
					print('������֤��...');
					--TLuaFuns:MsClick(iX + 300, iY - 40, 10, 5);
					TLuaFuns:MsClick(iX + 250, iY - 30, 10, 5);
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
	local iCount = 0;
	
	--�ر���Ϸ���
	--CloseWindowByTitle('DNF��Ƶ������');
	--CloseWindowByProcessName('AdvertDialog.exe');
	--TLuaFuns:MsPostStatus('�رչ�浯��...');
	local hAdvert = TLuaFuns:MsFindWindow('','DNF��Ƶ������');
	if 0 ~= TLuaFuns:MsIsWindow(hAdvert) then 
		TLuaFuns:MsSendMessage(hAdvert, 16);
	end
	
	hGameHandle = TLuaFuns:MsFindWindow('','���³�����ʿ��¼����');
	if 0 == TLuaFuns:MsIsWindow(hGameHandle) then
		TLuaFuns:MsPostStatus('��½�����쳣�˳�', tsFail);
		return 0;
	end
	
	TLuaFuns:MsSetGameHandle(hGameHandle);
	TLuaFuns:MsPostStatus(string.format('��ʼ��¼[%s|%s]...',TOrderInfo:GetAccount(), TOrderInfo:GetAreaName()));
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
	::lbPwdRePress::
	
	TLuaFuns:MsSleep(3000);
	TLuaFuns:MsFrontWindow(hGameHandle);
	TLuaFuns:MsClick(iLeft, iTop);
	print('����IoPress.exe����');
	TLuaFuns:MsPressPassWord(hPwd, TOrderInfo:GetPassWord());
	print('����IoPress.exe�������');
	TLuaFuns:MsClick(iLeft, iTop);
	TLuaFuns:MsSleep(5000);
	print('����س�');
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

--ѡ��Ƶ��
function fnSelChannel()
	TLuaFuns:MsPostStatus('������Ϸ,�ȴ�ѡ��Ƶ��...');
	local iRet = 0;
	local hGame = 0;
	local hLogin = 0;
	local dwTickCount = TLuaFuns:MsGetTickCount();
	local dwWaitTick = TLuaFuns:MsGetDelay('������Ϸ�ȴ�');
	dwWaitTick = (dwWaitTick + TLuaFuns:MsGetDelay('��ȫ��֤�ȴ�')) * 1000;	
	--local dwNoLoginWindow = TLuaFuns:MsGetTickCount();
	while TLuaFuns:MsGetTickCount() - dwTickCount <= dwWaitTick do
		TLuaFuns:MsSleep(100);
		--�ҵ������� break;
		hGame = TLuaFuns:MsFindWindow('���³�����ʿ','���³�����ʿ');
		if 0 ~= TLuaFuns:MsIsWindow(hGame) then
			break;
		end
		
		--�����ڻ�û�ҵ�����¼������ʧ�����쳣�˳�
		--[[20160705colin
		hLogin = TLuaFuns:MsFindWindow('','���³�����ʿ��¼����');
		if 0 == TLuaFuns:MsIsWindow(hLogin) then
			TLuaFuns:MsPostStatus('��½�����쳣�˳�', tsFail);
			return 0;
		end
		--]]
		--if TLuaFuns:MsCheck() == 0 then
		--	return 0;
		--end
	end
	if 0 == TLuaFuns:MsIsWindow(hGame) then
		TLuaFuns:MsPostStatus('ѡ��Ƶ����ʱ...', tsFail);
		return 0;
	end
	TLuaFuns:MsSetGameHandle(hGame);
	--[[
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
		TLuaFuns:MsPostStatus('ѡ��Ƶ����ʱ...', tsFail);
		return 0;
	end
	local iPosX = -1;
	local iPosY = -1;
	TLuaFuns:MsPostStatus('��ʼѡ��Ƶ��...');
	
	print('���Ƶ��...');

	if GTaskType == 1 then
		--�ֲֵ���̶�����
		TLuaFuns:MsDbClick(580, 450);
	elseif GTaskType == 0 then
		iRet = 0;
		for i=0, 3 do
			if i > 0 then
				-- ��һҳ
				TLuaFuns:MsClick(425, 475);
				iRet = TLuaFuns:MsFindString('˳��|����|��ͨ|ӵ��|����', TLuaFuns:MsGetPianSe('��½_ѡ��Ƶ��'), 1.0, 50);			
				if iRet == 1 then
					--break;
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
		TLuaFuns:MsDbClick(iPosX, iPosY);
		--TLuaFuns:MsDbClick(iPosX, iPosY);
		--TLuaFuns:MsSleep(500);
	end
	TLuaFuns:MsSleep(100);		
	--]]
	TLuaFuns:MsPostStatus('ѡ��Ƶ�����');
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
	--local dwSelRoleDelay = TLuaFuns:MsGetDelay('ѡ���ɫ�ȴ�') * 1000;
	local dwSelChannelDelay = TLuaFuns:MsGetDelay('ѡ��Ƶ���ȴ�') * 1000;
	--local dwWaitTick = dwSelRoleDelay + dwSelChannelDelay;
	local dwWaitTick = dwSelChannelDelay;
	local sRoleBmpName = TOrderInfo:GetRoleImgName();
	TLuaFuns:MsPostStatus(string.format('�ȴ�ѡ���ɫ[%s]...',GRoleName));
	while TLuaFuns:MsGetTickCount() - dwTickCount <= dwWaitTick do
		::lblSelRole::
		TLuaFuns:MsSleep(100);
		if TLuaFuns:MsCheck() == 0 then
			return 0;
		end
		iX, iY, iRet = TLuaFuns:MsFindImgEx('SelRole.bmp', 1.0, 5);
		if -1 == iRet then
			iX, iY = TLuaFuns:MsFindStringEx('˳��|����|��ͨ|ӵ��|����', TLuaFuns:MsGetPianSe('��½_ѡ��Ƶ��'));
			if (iX ~= -1) and (iY ~= -1) then
				if GTaskType == 1 then
					TLuaFuns:MsDbClick(580, 450);
				elseif GTaskType == 0 then
					TLuaFuns:MsDbClick(iX + 5, iY + 5);
				end				
				TLuaFuns:MsSleep(100);
			end
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
				
		print(string.format('��ɫͼƬ[%s]', sRoleBmpName));
		iX, iY = TLuaFuns:MsFindImgEx(sRoleBmpName);
		if (iX ~= -1) and (iY ~= -1) then
			--20160707colin
			if 0 ~= TLuaFuns:MsFindImg('FreezeMoney.bmp', 1.0, 3) then
				TLuaFuns:MsPostStatus('�ʲ�����', tsFail, False);
				return 0;
			end
			--
			break;
		end
		iX, iY = TLuaFuns:MsFindStringEx(GRoleName, TLuaFuns:MsGetPianSe('��½_ѡ���ɫ'), 0.7);
		if (iX ~= -1) and (iY ~= -1) then
			--20160707colin
			if 0 ~= TLuaFuns:MsFindImg('FreezeMoney.bmp', 1.0, 3) then
				TLuaFuns:MsPostStatus('�ʲ�����', tsFail, False);
				return 0;
			end
			--
			break;
		end
	end
	
	if not IsEnterRolePage then
		TLuaFuns:MsPostStatus('�����ɫҳ�泬ʱ', tsFail);
		return 0;
	end
	
	if (iX == -1) or (iY ==	-1) then
		print('û���ҵ���ɫ������������');
		local hGame = 0;
		local iTop = -1;
		local iLeft = -1;
		hGame = TLuaFuns:MsGetGameHandle();
		
		iLeft, iTop = TLuaFuns:MsGetTopLeft(hGame);
		TLuaFuns:MsClick(iLeft + 580, iTop  + 495);
		iX, iY, iRet = TLuaFuns:MsFindImgEx(sRoleBmpName, 1.0, 5);	
		print(iX, iY, iRet);
	end
	
	if (iX == -1) or (iY == -1) then
		TLuaFuns:MsPostStatus(string.format('���ҽ�ɫ[%s]�����ڣ�', GRoleName), tsFail, False);
		return 0;
    end;
	print(string.format('��ɫλ�� X[%d]Y[%d]', iX, iY));
	GEnterGameTick = TLuaFuns:MsGetTickCount();
	TLuaFuns:MsPostStatus(string.format('�ҵ���ɫ[%s]', GRoleName));		
	TLuaFuns:MsDbClick(iX + math.random(1,20), iY  + math.random(1,20));
	TLuaFuns:MsSleep(300);
	TLuaFuns:MsDbClick(iX + math.random(1,20), iY  + math.random(1,20));
	TLuaFuns:MsSleep(300);
	TLuaFuns:MsDbClick(iX + math.random(1,20), iY  + math.random(1,20));
	TLuaFuns:MsSleep(300);
	TLuaFuns:MsPostStatus('��ɫѡ�����');
	return 1;
end

--�˻ص���ɫ����
function fnBackToRoler()
	TLuaFuns:MsPostStatus('�ȴ����ؽ�ɫ����...');
	local iX, iY;
	local iRet = 0;
	local dwWaitTick = 30 * 1000;
	local dwTickCount = TLuaFuns:MsGetTickCount();
	while TLuaFuns:MsGetTickCount() - dwTickCount <= dwWaitTick do
		TLuaFuns:MsSleep(100);
		if 0 == TLuaFuns:MsCheck() then
			return 0;
		end
		iRet = TLuaFuns:MsFindImg('SelRole.bmp');
		if 0 ~= iRet then 
			TLuaFuns:MsPostStatus('���ؽ�ɫ�������');
			return 1;
		end
		--[[
		--����ǰ�̯�Ļ�����Ҫ�رո�ħ�̵�
		if (GTaskType == 1) then  
			TLuaFuns:MsPressEsc();
			iX, iY, iRet = TLuaFuns:MsFindImgEx('CloseEnchat.bmp', 1.0, 2);
			if (iX ~= -1) and (iY ~= -1) then
				TLuaFuns:MsClick(iX + 35, iY + 30);
				TLuaFuns:MsSleep(500);
				TLuaFuns:MsPressEnter();
				TLuaFuns:MsSleep(500);
			end
		end
		--]]
		
		--��Esc��ѡ��ɫ
		--[[
		TLuaFuns:MsPressEsc();
		TLuaFuns:MsSleep(1000);
		if 0 ~= TLuaFuns:MsFindString('��Ϸ�˵�(Esc)', TLuaFuns:MsGetPianSe('�˵�_��ͨ����')) then
			iX, iY = TLuaFuns:MsFindImgEx('BackToRoler.bmp',0.9);
			if (iX ~= -1) and (iY ~= -1) then
				TLuaFuns:MsClick(iX + 5, iY + 5, 10, 5);
			end
		end
		--]]
		
		--����˵���ѡ��ɫ
		iX, iY, iRet = TLuaFuns:MsFindImgEx('LoginSuccess1.bmp');
		if (iX ~= -1) and (iY ~= -1) then
			TLuaFuns:MsClick(iX + 5, iY + 5, 10, 5);
			TLuaFuns:MsSleep(500);
			iX, iY, iRet = TLuaFuns:MsFindImgEx('CloseGame.bmp');
			if (iX ~= -1) and (iY ~= -1) then
				TLuaFuns:MsClick(iX - 135, iY - 10, 3, 3);
			end
		end
	end
	if 0 == iRet then 
		TLuaFuns:MsPostStatus('���ؽ�ɫ���泬ʱ', tsFail);
		return 0;
	end
end

--�ж��Ƿ������Ϸ
function fnIsEnterTheGame(iDelay)	
	local hGame = TLuaFuns:MsFindWindow('���³�����ʿ', '���³�����ʿ');
	if 0 == TLuaFuns:MsIsWindow(hGame) then
		return -1;
	end	
	TLuaFuns:MsSetGameHandle(hGame);
	local iRet = -1;
	local iX = -1;
	local iY = -1;
	iX, iY, iRet = TLuaFuns:MsFindImgEx('CloseGame.bmp|LoginSuccess.bmp|LoginSuccess1.bmp', 0.9, iDelay);
	print('IsEnterTheGame:', iRet);
	return iRet;
end

--������Ϸ
function fnEnterTheGame()
	TLuaFuns:MsPostStatus('�ȴ���ɫ������Ϸ...');
	local bRet = false;
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
	while (TLuaFuns:MsGetTickCount() - dwTickCount <= dwWaitTick) do
		bRet = false;
		if 0 == TLuaFuns:MsCheck() then
			return 0;
		end
		
		TLuaFuns:MsSleep(100);
		TLuaFuns:MsPressEsc();
		TLuaFuns:MsSleep(200);
		TLuaFuns:MsPressEsc();
		
		iX, iY, iRet = TLuaFuns:MsFindImgEx('Ok.bmp|GiveUp.bmp|Enter.bmp|NextStep.bmp');
		if -1 ~= iRet then
			TLuaFuns:MsClick(iX + 5, iY + 5, 10, 5);
			bRet = true;
		end  
		----------          -------------------------
		iX, iY, iRet = TLuaFuns:MsFindStringEx('ȷ��|�ر�|��������|����˹������|˽����������', TLuaFuns:MsGetPianSe('��½_�رչ��'));
		if (0 == iRet) or (1 == iRet) then
			TLuaFuns:MsClick(iX + 5, iY + 5, 10, 5);
			bRet = true;
		end
		if 2 == iRet then
			TLuaFuns:MsClick(iX + 150, iY + 10, 10, 5);
			bRet = true;
		end
		if (3 == iRet) or (4 == iRet) then
			TLuaFuns:MsClick(iX + 390, iY + 5, 10, 5);
			bRet = true;
		end
		TLuaFuns:MsSleep(100);
		TLuaFuns:MsPressChar('L');
		TLuaFuns:MsSleep(200);
		TLuaFuns:MsPressChar('L');
		TLuaFuns:MsSleep(100);
		
		iRet = fnIsEnterTheGame(1);
		IsEnterTheGame = iRet ~= -1;

		fnCloseMenu();
		if (not bRet) and IsEnterTheGame then 
			if (TLuaFuns:MsGetTickCount() - dwTickCount > 15 * 1000) then break; end
		end
	end
	
	if not IsEnterTheGame then
		TLuaFuns:MsPostStatus('��ɫ������Ϸ��ʱ', tsFail);
		return 0;
	end	

	TLuaFuns:MsPostStatus('��ɫ������Ϸ���');
	return 1;
end


--���ʼ��䡣���ڷ����ʱ��Esc���ʼ���
function fnOpenMailBoxByEsc()
	local iRet = 0;
	local iX = -1;
	local iY = -1;
	local bOpen = false;
	iX, iY, iRet = TLuaFuns:MsFindImgEx('NoSet.bmp');
	TLuaFuns:MsClick(iX, iY);
	for i=1, 5 do
		iX, iY, iRet = TLuaFuns:MsFindImgEx('CloseGame.bmp');
		if (iX ~= -1) and (iY ~= -1) then
			TLuaFuns:MsClick(iX-135, iY-220);
			--TLuaFuns:MsPostStatus(string.format('�ʼ���λ��(%d,%d)', iX-135, iY-220));
			TLuaFuns:MsSleep(500);
			iX, iY, iRet = TLuaFuns:MsFindStringEx('�ʼ�������', TLuaFuns:MsGetPianSe('�ʼ�_�ʼ���_δѡ��'));
			if (0 == iRet) then
				bOpen = true;
				break;
			end
		end
		TLuaFuns:MsPressEsc();
		TLuaFuns:MsSleep(500);
	end	
	
	if not bOpen then
		TLuaFuns:MsPostStatus('���ʼ���ʧ��', tsFail);
		return 0;
	end
	--�ر���ʾ��
	iX, iY, iRet = TLuaFuns:MsFindStringEx('�����д���δ���յ��ʼ�', 'ffffff-000000');
	if (iX ~= -1) and (iY ~= -1) then
		TLuaFuns:MsClick(iX + 75, iY + 65, 10, 5);
	end
	TLuaFuns:MsPostStatus('���ʼ������');
	return 1;
end

--[[
--���ʼ�
function fnRecMail()
	local iRet = 0;
	local iX = -1;
	local iY = -1;
	iRet = fnOpenMailBoxByEsc();
	if (iRet == 0) then 
		return 0;
	end
	iRet = TLuaFuns:MsFindString('ѡ�����', '8c8c8c-000000');
	if (iRet == 1) then
		TLuaFuns:MsPostStatus('û�п��Խ��յ��ʼ���', tsFail);
		return 0;
	end
	iX, iY, iRet = TLuaFuns:MsFindStringEx('ѡ�����', 'ddc593-000000');
	if (iRet ~= -1) then
		TLuaFuns:MsClick(iX + 20, iY + 10);
		TLuaFuns:MsSleep(100);
		TLuaFuns:MsClick(iX + 20, iY + 10);
		TLuaFuns:MsSleep(1000);
		fnCloseMenu();
		TLuaFuns:MsPostStatus('�����ʼ���ɣ�');
		return 1;
	end
	TLuaFuns:MsPostStatus('�����ʼ�ʧ�ܣ�', tsFail);
	return 0;
end
--]]

--���ʼ���
function fnOpenMailBox()
	TLuaFuns:MsPostStatus('�ȴ����ʼ���...');
	local iRet = 0;
	local iX = -1;
	local iY = -1;
	local bRet = false;
	local sPianSe = '';
	--iRet = TLuaFuns:MsFindString('��Ϸ�˵�(Esc)|����(L)', TLuaFuns:MsGetPianSe('�˵�_��ͨ����'));
	iRet = TLuaFuns:MsFindString('������Ϸ|����(L)', TLuaFuns:MsGetPianSe('�˵�_��ͨ����'));
	if 0 ~= iRet then
		TLuaFuns:MsPressEsc();
	end	
	--fnCloseMenu();
	
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
			print(string.format('����ʼ���X[%d]Y[%d]', iX, iY));
			TLuaFuns:MsClick(iX + 20, iY + 50, 10, 5);
			TLuaFuns:MsSleep(100);
			TLuaFuns:MsClick(iX + 20, iY + 50, 10, 5);
			TLuaFuns:MsSleep(1000);
		end
	end
	
	if not bRet then
		TLuaFuns:MsPostStatus('���ʼ���ʧ��', tsFail);
		return 0;
	end
	--�ر���ʾ��
	iX, iY, iRet = TLuaFuns:MsFindStringEx('�����д���δ���յ��ʼ�', 'ffffff-000000');
	if (iX ~= -1) and (iY ~= -1) then
		TLuaFuns:MsClick(iX + 75, iY + 65, 10, 5);
	end
	TLuaFuns:MsPostStatus('���ʼ������');
	return 1;
end

--��������ʼ���ǩ
function fnClickSendMailLabel()
	TLuaFuns:MsPostStatus('�ȴ���������ʼ�ҳǩ...');
	local iRet = 0;
	local bRet = false;
	local iX = -1; local iY = -1;
	iX, iY = TLuaFuns:MsFindStringEx('�����ʼ�', TLuaFuns:MsGetPianSe('�ʼ�_�ʼ���_δѡ��'), 1.0, 5);
	if (iX == -1) or (iY == -1) then
		TLuaFuns:MsPostStatus('��Ϸ���Զ��ر�', tsFail);
		return 0;
	end
	for i=1, 3 do
		iRet = TLuaFuns:MsFindImg('SendMail_1.bmp');
		if 0 ~= iRet then
			bRet = true;
			break;
		end
		TLuaFuns:MsClick(iX, iY, 40, 8);
		TLuaFuns:MsSleep(2200);
	end
	
	if not bRet then
		TLuaFuns:MsPostStatus('��������ʼ�ҳǩʧ��', tsFail);
		return 0;
	end
	TLuaFuns:MsPostStatus('��������ʼ�ҳǩ���');
	return 1;
end

--�����ɫ��
function fnInputRoleName(sRoleName)
	TLuaFuns:MsPostStatus('�ȴ�����Է���ɫ��...');
	local bRet = false;
	local iX = -1;
	local iY = -1;
	for i=1, 3 do
		bRet = false;
		iX, iY = TLuaFuns:MsFindImgEx('SendMail_1.bmp');
		if (iX ~= -1) and (iY ~= -1) then
			bRet = true;
			break;
		end 
	end
	
	if not bRet then
		TLuaFuns:MsPostStatus('û�д��ʼ���', tsFail);
		return 0;
	end
	local hGame = TLuaFuns:MsGetGameHandle();
	local sReceiptRoleImg = TOrderInfo:GetReceiptRoleImgName();	
	for i=1, 3 do		
		--�����ɫ��
		TLuaFuns:MsClick(iX + 50, iY + 27, 20, 5);
		TLuaFuns:MsSleep(500);
		TLuaFuns:MsPressDel(12);
		TLuaFuns:MsSleep(500);
		TLuaFuns:MsPressString(hGame, sRoleName);
		TLuaFuns:MsSleep(500);
		
		iRet = TLuaFuns:MsFindImg(sReceiptRoleImg);
		if (iRet ~= 0) then
			TLuaFuns:MsPostStatus('�Է���ɫ���������');
			return 1;
		end
		TLuaFuns:MsSleep(500);
	end
	TLuaFuns:MsPostStatus('�Է���ɫ������ʧ��');
	return 0;
end

--������
function fnInputMoney(ANum)
	TLuaFuns:MsPostStatus('�ȴ�������...');
	local hGame = TLuaFuns:MsGetGameHandle();
	local iX = -1;
	local iY = -1;
	local iRet = -1;
	for i=1, 3 do
		iX, iY, iRet = TLuaFuns:MsFindImgEx('SendMoney.bmp');
		
		if i > 1 then
			TLuaFuns:MsPostStatus('�ȴ�����Ľ���붩�������֤...');
			iRet = TLuaFuns:MsGetNumber(iX + 50, iY - 5, iX + 170, iY + 15, 'ffffff-000000');
			print(iRet, ANum);
			if ANum == iRet then
				TLuaFuns:MsPostStatus('����Ľ���붩�������֤���');
				return 1;				
			end
		end
		TLuaFuns:MsClick(iX + 140, iY + 6);
		TLuaFuns:MsSleep(500);
		TLuaFuns:MsClick(iX + 140, iY + 6);
		TLuaFuns:MsSleep(500);
		TLuaFuns:MsClick(iX + 100, iY + 6, 60, 1);
		TLuaFuns:MsSleep(500);
		TLuaFuns:MsPressDel(20);
		TLuaFuns:MsSleep(500);
		local sMoney = string.format('%d', ANum);
		TLuaFuns:MsPressString(hGame, sMoney);
		TLuaFuns:MsPostStatus('����������');
	end
	return 0;
end

--��ȡ�������
function fnGetBagMoney()
	local iRet = -1;
	local iMoney = -1;
	local iX = -1;
	local iY = -1;
	
	for i=0, 9 do
		iX, iY, iRet = TLuaFuns:MsFindStringEx('װ����(I)', TLuaFuns:MsGetPianSe('�˵�_��ͨ����'));
		if (iX ~= -1) and (iY ~= -1) then
			iMoney = TLuaFuns:MsGetNumber(iX + 30, iY + 475, iX + 130, iY + 505, TLuaFuns:MsGetPianSe('�ʼ�_�������'));
			if iMoney ~= -1 then
				TLuaFuns:MsPostStatus('��ȡ����������');
				break;
			end
		end	
		TLuaFuns:MsPressChar('I');
		TLuaFuns:MsSleep(500);
	end
	return iMoney;
end

--У��Է���ɫ
function fnCheckRoleInfo(ASendNum, IsCheckRole)
	TLuaFuns:MsPostStatus('�ȴ�У��Է���ɫ��...');
	local dwTickCount = TLuaFuns:MsGetTickCount();
	local dwWaitTick = 5 * 1000;
	local iX = -1;
	local iY = -1;
	local iPosX = -1;
	local iPosY = -1;
	
	while TLuaFuns:MsGetTickCount() - dwTickCount <= dwWaitTick do
		TLuaFuns:MsSleep(100);
		if 0 == TLuaFuns:MsCheck() then
			return 0;
		end
		
		iX, iY = TLuaFuns:MsFindStringEx('ȷ��', TLuaFuns:MsGetPianSe('�ʼ�_�ʼ���_δѡ��'));
		if (iX ~= -1) and (iY ~= -1) then
			TLuaFuns:MsClick(iX + 10, iY + 5);
			TLuaFuns:MsSleep(1000);
		end 
		
		iX, iY = TLuaFuns:MsFindStringEx('�����ʼ�', TLuaFuns:MsGetPianSe('�ʼ�_�ʼ���_��ѡ��'));
		if (iX ~= -1) and (iY ~= -1) then
			break;
		end 
	end
	
	dwTickCount = TLuaFuns:MsGetTickCount();
	dwWaitTick = TLuaFuns:MsGetDelay('����ɫ���ڵȴ�') * 1000;
	while TLuaFuns:MsGetTickCount() - dwTickCount <= dwWaitTick do		
		TLuaFuns:MsSleep(100);
		if 0 == TLuaFuns:MsCheck() then
			return 0;
		end		
		TLuaFuns:MsClick(iX + 120, iY + 25);
		
		TLuaFuns:MsSleep(1000);
		
		iPosX, iPosY = TLuaFuns:MsFindStringEx('ѡ��', 'ffffff-000000')
		
		if (iPosX ~= -1) and (iPosY ~= -1) then			
			--TLuaFuns:MsClick(iPosX + 65, iPosY + 10);
			TLuaFuns:MsPressEnter();
			TLuaFuns:MsSleep(500);
			TLuaFuns:MsPressEnter();
		else
			iPosX, iPosY = TLuaFuns:MsFindStringEx('����', TLuaFuns:MsGetPianSe('�˵�_��ͨ����'));
			if (iPosX ~= -1) and (iPosY ~= -1) then
				break;			
			end
		end
		iPosX = -1; iPosY = -1;
	end
	
	if (iPosX == -1) or (iPosY == -1) then
		TLuaFuns:MsPostStatus('��ɫ������ʧ��', tsFail);
		return 0;
	end
	
	if not IsCheckRole then
		return 1;
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
			TLuaFuns:MsPostStatus(string.format('�Է���ɫ[%s]������',GTargetRoleName), tsTargetFail, false);
			return 0;
		end
	end
	if (iX == -1) or (iY == -1) then
		TLuaFuns:MsPostStatus(string.format('�Է���ɫ[%s]������',GTargetRoleName), tsTargetFail, false);
		return 0;
	end	
	
	--��ȡ�ȼ�
	local iLevel = 0;
	for i=1, 3 do
		iLevel = TLuaFuns:MsGetNumber(iX, iY + 5, iX + 100, iY + 30, 'ffffff-000000');
		if iLevel > -1 then
			print(string.format('��ȡ�Է���ɫ�ȼ�Ϊ: %d', iLevel));
			break;
		end
	end
	
	if iLevel == -1 then
		TLuaFuns:MsPostStatus(string.format('��ȡ��ɫ[%s]�ĵȼ�ʧ��', GTargetRoleName), tsFail);
		return 0;
	end
	
	if iLevel <= 20 then		
		TLuaFuns:MsPostStatus(string.format('�Է���ɫ[%s]�ȼ����ͣ�����Я�������뻻��', GTargetRoleName), tsFail);
		return 0;
	end
	
	TLuaFuns:MsPostStatus('�ж�Я����');
	if iLevel > 0 then
		--�ж�Я����
		local iCarry = TLuaFuns:MsGetCarryAmount(iLevel);
		print(iCarry);
		print(ASendNum);
		if iCarry > 0 then
			if iCarry < ASendNum then
				TLuaFuns:MsPostStatus('�������������Է���Я������������ֹ', tsFail, False);
				return 0;
			end
		end
	end
	
	TLuaFuns:MsPostStatus('У��Է���ɫ�����');
		
	if 1 == TOrderInfo:GetCheckLevel() then
		TLuaFuns:MsPostStatus('�ȴ�У��Է���ɫ�ȼ�...');
		local iReceiptLevel = TOrderInfo:GetReceiptLevel();
		TLuaFuns:MsPostStatus(string.format('�ȴ�У��Է���ɫ�ȼ�,�Լ��ĵȼ�[%d]�Է��ȼ�[%d]...',iLevel,iReceiptLevel));
		if iLevel ~= iReceiptLevel then
			TLuaFuns:MsPostStatus(string.format('��ɫ[%s]�����ȼ�[%d]��ʵ�ʵȼ�[%d]���������账��', GTargetRoleName, iReceiptLevel, iLevel), tsTargetFail, false);
			return 0;
		end
		TLuaFuns:MsPostStatus('У��Է���ɫ�ȼ����');
	end
	
	return 1;
end


--[[
--У��Է���ɫ
function fnCheckRoleInfo(ASendNum, IsCheckRole)
	TLuaFuns:MsPostStatus('�ȴ�У��Է���ɫ��...');
	local dwTickCount = TLuaFuns:MsGetTickCount();
	local dwWaitTick = 5 * 1000;
	local iX = -1;
	local iY = -1;
	local iX2 = -1;
	local iY2 = -1;
	local iPosX = -1;
	local iPosY = -1;
	local iRet = -1;
	
	while TLuaFuns:MsGetTickCount() - dwTickCount <= dwWaitTick do
		TLuaFuns:MsSleep(100);
		if 0 == TLuaFuns:MsCheck() then
			return 0;
		end
		
		iX, iY = TLuaFuns:MsFindImgEx('OK_1.bmp');
		if (iX ~= -1) and (iY ~= -1) then
			print('OK_1');
			TLuaFuns:MsClick(iX + 5, iY + 2, 10, 8);
			TLuaFuns:MsSleep(1000);
		end 
		
		iX, iY = TLuaFuns:MsFindImgEx('SendMail_1.bmp');
		if (iX ~= -1) and (iY ~= -1) then
			print('SendMail_1');
			iX2=iX; iY2=iY;
			break;
		end 
	end
	if (iX == -1) or (iY == -1) then
		TLuaFuns:MsPostStatus('���ʼ���ʧ�ܣ�', tsFail);
		return 0;
	end
	
	
	dwTickCount = TLuaFuns:MsGetTickCount();
	dwWaitTick = TLuaFuns:MsGetDelay('����ɫ���ڵȴ�') * 1000;
	while TLuaFuns:MsGetTickCount() - dwTickCount <= dwWaitTick do		
		TLuaFuns:MsSleep(100);
		if 0 == TLuaFuns:MsCheck() then
			return 0;
		end	
			
		TLuaFuns:MsClick(iX2 + 120, iY2 + 25);
		TLuaFuns:MsSleep(900, 200);
		
		iPosX, iPosY = TLuaFuns:MsFindImgEx('Notice_1.bmp|Notice_2.bmp');
		if (iPosX ~= -1) and (iPosY ~= -1) then
			break;			
		end
	end
	print('fnCheckRoleInfo-2');
	if (iPosX == -1) or (iPosY == -1) then
		TLuaFuns:MsPostStatus('��ɫ������ʧ��', tsFail);
		return 0;
	end
	
	--ѡ������˵Ĵ���
	dwWaitTick = 10 * 1000;
	dwTickCount = TLuaFuns:MsGetTickCount();
	while TLuaFuns:MsGetTickCount() - dwTickCount <= dwWaitTick do		
		iX, iY, iRet = TLuaFuns:MsFindImgEx('SelRecRoleArea.bmp', 1.0, 2);		
		if (iX == -1) or (iY == -1) then
			break;
		end
		TLuaFuns:MsClick(iX + 55, iY + 55, 30, 10);
		TLuaFuns:MsSleep(1);
	end
	
	if not IsCheckRole then
		return 1;
	end
	
	print('��ʼУ��Է���ɫ...');
	dwTickCount = TLuaFuns:MsGetTickCount();
	dwWaitTick = 10 * 1000;
	while TLuaFuns:MsGetTickCount() - dwTickCount <= dwWaitTick do
		TLuaFuns:MsSleep(100);
		if 0 == TLuaFuns:MsCheck() then
			return 0;
		end
	
		TLuaFuns:MsClick(iX2 + 120, iY2 + 28, 20, 3);
		TLuaFuns:MsSleep(900, 200);
		
		
		iX, iY, iRet = TLuaFuns:MsFindImgEx('RoleName.bmp|NotFindRole.bmp', 1.0, 3);
		print(iX, iY, iRet);
		if 0 == iRet then
			break;
		end
		if 1 == iRet then
			TLuaFuns:MsPostStatus(string.format('�Է���ɫ[%s]������',GTargetRoleName), tsTargetFail, false);
			return 0;
		end
	end
	if (iX == -1) or (iY == -1) then
		TLuaFuns:MsPostStatus(string.format('�Է���ɫ[%s]������2',GTargetRoleName), tsTargetFail, false);
		return 0;
	end	
	
	--��ȡ�ȼ�
	local iLevel = 0;
	for i=1, 3 do
		iLevel = TLuaFuns:MsGetNumber(iX, iY + 5, iX + 100, iY + 30, 'ffffff-000000');
		if iLevel > -1 then
			print(string.format('��ȡ�Է���ɫ�ȼ�Ϊ: %d', iLevel));
			break;
		end
		TLuaFuns:MsSleep(1);
	end
	
	if iLevel == -1 then
		TLuaFuns:MsPostStatus(string.format('��ȡ��ɫ[%s]�ĵȼ�ʧ��', GTargetRoleName), tsFail);
		return 0;
	end
	
	if iLevel <= 20 then		
		TLuaFuns:MsPostStatus(string.format('�Է���ɫ[%s]�ȼ����ͣ�����Я�������뻻��', GTargetRoleName), tsFail);
		return 0;
	end
	
	TLuaFuns:MsPostStatus('�ж�Я����');
	if iLevel > 0 then
		--�ж�Я����
		local iCarry = TLuaFuns:MsGetCarryAmount(iLevel);
		print(iCarry);
		print(ASendNum);
		if iCarry > 0 then
			if iCarry < ASendNum then
				TLuaFuns:MsPostStatus('�������������Է���Я������������ֹ', tsFail, False);
				return 0;
			end
		end
	end
	
	if 1 == TOrderInfo:GetCheckLevel() then
		TLuaFuns:MsPostStatus('�ȴ�У��Է���ɫ�ȼ�...');
		local iReceiptLevel = TOrderInfo:GetReceiptLevel();
		TLuaFuns:MsPostStatus(string.format('�ȴ�У��Է���ɫ�ȼ�,�Լ��ĵȼ�[%d]�Է��ȼ�[%d]...',iLevel,iReceiptLevel));
		if iLevel ~= iReceiptLevel then
			TLuaFuns:MsPostStatus(string.format('��ɫ[%s]�����ȼ�[%d]��ʵ�ʵȼ�[%d]���������账��', GTargetRoleName, iReceiptLevel, iLevel), tsTargetFail, false);
			return 0;
		end
		TLuaFuns:MsPostStatus('У��Է���ɫ�ȼ����');
	end
	
	--���ѡ��ť
	--colin2016-07-14
	dwWaitTick = 5 * 1000;
	while TLuaFuns:MsGetTickCount() - dwTickCount <= dwWaitTick do
		TLuaFuns:MsSleep(100);
		if 0 == TLuaFuns:MsCheck() then
			return 0;
		end
		--colin2016-07-14
		--iPosX, iPosY = TLuaFuns:MsFindImgEx('Select.bmp');
		iPosX, iPosY = TLuaFuns:MsAreaFindImgEx(350,400,600,450, 'Select.bmp');
		print(string.format('Select.bmp����[%d,%d]',iPosX, iPosY));
		
		if (iPosX ~= -1) and (iPosY ~= -1) then	
			TLuaFuns:MsPressEnter();
			TLuaFuns:MsSleep(500,600);
			TLuaFuns:MsPressEnter();
			TLuaFuns:MsSleep(500,600);
			while true do
				iRet = TLuaFuns:MsFindImg('near.bmp');
				if iRet == 0 then
					break;
				end
				TLuaFuns:MsPressEnter();
				TLuaFuns:MsSleep(500,600);
			end
		end
	end
		
	TLuaFuns:MsPostStatus('У��Է���ɫ�����');
	TLuaFuns:MsClick(iX2 + 120, iY2 + 28, 20, 3);
	TLuaFuns:MsSleep(500);	
	
	return 1;
end
--]]

--�����ʼ�ʱ����
function fnDaMaOfSendMail(hGameHandle, ATimes)
	local iRet = 0;
	local iX = -1;
	local iY = -1;
	local bRet = false;
	for i=1, 3 do
		if 0 == TLuaFuns:MsCheck() then
			return 0;
		end
		iX, iY = TLuaFuns:MsFindImgEx('MailCheckCodeDlg.bmp', 0.8);
		print(iX,iY);
		if (iX ~= -1) and (iY ~= -1) then
			iRet = TLuaFuns:MsCaptureArea(iX - 205, iY - 148, iX - 82, iY - 97, 'CheckCode.bmp');
			print(iRet);
			if 0 ~= iRet then
				break;
			end
		end			
	end

	if iRet == 0 then
		print('��ȡ��֤��ʧ��...');
		return 0;
	end
	
	for i=1, 9 do
		bRet = false;
		TLuaFuns:MsPostStatus('�����ʼ���֤�뵽�����');
		local sRet = TLuaFuns:MsDaMa('CheckCode.bmp', 12);
		print(sRet);
		if sRet ~= '' then
			print('������֤��...');
			TLuaFuns:MsPressString(hGameHandle, sRet);
			TLuaFuns:MsSleep(500);
			
			--��ͼ1��������֤�룩
			local sCaptureName = string.format('%s%s_%d_%d_1.bmp', GCapturePath, TOrderInfo:GetOrderNo(), TOrderInfo:GetRoleID(), ATimes+1);
			TLuaFuns:MsCaptureGame(sCaptureName);
			print(string.format('������֤��_��ͼ1_%s', sCaptureName));
			
			if 0 == TLuaFuns:MsCheck() then
				return 0;
			end
			print('���ȷ����ť');
			for j=1, 3 do
				TLuaFuns:MsClick(iX - 150, iY + 2, 50, 10);
				TLuaFuns:MsPostStatus(string.format('�����ʼ���ť����[X=%d,Y=%d]',iX - 150, iY + 2));
				TLuaFuns:MsSleep(2000);
				iRet = TLuaFuns:MsFindImg('MailCheckCodeDlg.bmp', 0.8, 2);
				if 0 == iRet then
					bRet = true;
					break;
				end
			end	
			if bRet then
				break;
			end
		end
		TLuaFuns:MsSleep(1);
	end
	
	if not bRet then
		TLuaFuns:MsPostStatus('�����ô���ʧ��', tsFail);
		return 0;
	end
	return 1;
end

--�ȴ��ʼ����ͽ�� 
function fnCheckSendResult(ATimes)
	TLuaFuns:MsPostStatus('�ȴ��ȴ��ʼ����ͽ��...');
	local iResult = -1;
	local iRet = 0;
	local x, y;
	local hGame = TLuaFuns:MsGetGameHandle();
	local dwTickCount = TLuaFuns:MsGetTickCount();
	local dwWaitTick = TLuaFuns:MsGetDelay('�ʼ���֤�봰�ڵȴ�') * 1000;
	dwWaitTick = dwWaitTick + 5000;
	while TLuaFuns:MsGetTickCount() - dwTickCount <= dwWaitTick do
		TLuaFuns:MsSleep(100);
		if 0 == TLuaFuns:MsCheck() then
			return 0;
		end
		
		if 0 ~= TLuaFuns:MsFindImg('MailCheckCodeDlg.bmp', 0.8, 2) then
			iRet = 1;
			break;
		end
		x, y, iResult = TLuaFuns:MsFindStringEx('�ѳɹ������ʼ�|���ڶԷ��ĺ�������|�ѳ�����ҵ�ʹ������|����ռ��˵�', 'ffffff-000000');			
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
		if 3 == iResult then
			TLuaFuns:MsPostStatus('�������������Է���Я������������ֹ', tsFail, False);
			return 0;
		end
	end
	
	if iRet == 0 then
		TLuaFuns:MsPostStatus('�ȴ����ͽ����ʱ', tsFail);
		return 0;
	end
	
	if iRet == 1 then
		iRet = fnDaMaOfSendMail(hGame, ATimes);
		
		if iRet == 0 then
			print('Զ�̴���ʧ��...');
			return 99;  --���ﷵ��99�Ļ��� ˵���Ͳ��ڼ�������
		end
		iRet = 0;
		local dwTickCount = TLuaFuns:MsGetTickCount();
		local dwWaitTick = TLuaFuns:MsGetDelay('������ȴ�') * 1000;
		while TLuaFuns:MsGetTickCount() - dwTickCount <= dwWaitTick do
			TLuaFuns:MsSleep(100);
			if 0 == TLuaFuns:MsCheck() then
				return 0;
			end
			
			x, y, iResult = TLuaFuns:MsFindStringEx('�ѳɹ������ʼ�|���ڶԷ��ĺ�������|�ѳ�����ҵ�ʹ������|����ռ��˵�', 'ffffff-000000');			
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
			if 3 == iResult then
				TLuaFuns:MsPostStatus('�������������Է���Я������������ֹ', tsFail, False);
				return 0;
			end
		end            
	end
	
	if iRet == 2 then		
		--��ͼ2���ʼ����ͳɹ���
		local sCaptureName = string.format('%s%s_%d_%d_2.bmp', GCapturePath, TOrderInfo:GetOrderNo(), TOrderInfo:GetRoleID(), ATimes+1);
		TLuaFuns:MsCaptureGame(sCaptureName);
		TLuaFuns:MsPostStatus(string.format('�ʼ����ͳɹ�_��ͼ2_%s', sCaptureName));
		--TLuaFuns:MsSleep(1000);
		--TLuaFuns:MsClick(x + 45, y + 35, 10, 5);
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
	local sRet;
	TLuaFuns:MsPostStatus('����Ƿ���Ҫ�ⰲȫ...');
	iX, iY = TLuaFuns:MsFindStringEx('ȷ�����', 'ddc593-000000');
	if (iX == -1) or (iY == -1) then
		print('����Ҫ�ⰲȫ');
		return 1;
	end
	--iX,iY = TLuaFuns:MsGetTopLeft(TLuaFuns:MsGetGameHandle());
	TLuaFuns:MsClick(iX + 100, iY + 5);
	TLuaFuns:MsPostStatus('�˺���Ҫ��󣬳���ʼ�ⰲȫ...');
	sRet = TLuaFuns:MsQuitSafe();

	if 'OK' ~= sRet then
		TLuaFuns:MsPostStatus(sRet, tsSuspend);
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
	TLuaFuns:MsPostStatus('�ⰲȫ���');
	return 2;
end

--[[
function fnCloseZhuangBeiLan()
	local iX = -1;
	local iY = -1;
	local iRet = -1;
	
	for i = 1, 5 do
		iX, iY, iRet = TLuaFuns:MsFindStringEx('װ����(I)', TLuaFuns:MsGetPianSe('�˵�_��ͨ����'));
		if (iX == -1) or (iY == -1) then
			return 1;
		end
		TLuaFuns:MsClick(iX + 140, iY + 5, 5, 5);
		TLuaFuns:MsSleep(500);
	end
	return 0;
end

function fnDragMailBox()
	local iX = -1;
	local iY = -1;
	local iRet = -1;
	
	for i = 1, 5 do
		iX, iY, iRet = TLuaFuns:MsFindStringEx('����(��)', TLuaFuns:MsGetPianSe('�˵�_��ͨ����'));
		if (iX > 650) and (iY > 200) then
			return 1;
		end
		TLuaFuns:MsDragMouse(iX, iY, 670, 220);
		TLuaFuns:MsSleep(500);
	end
	return 0;
end

function fnDragRoleBox()
	local iX = -1;
	local iY = -1;
	local iRet = -1;
	
	for i = 1, 5 do
		iX, iY, iRet = TLuaFuns:MsFindStringEx('����', TLuaFuns:MsGetPianSe('�˵�_��ͨ����'));
		if (iX > 650) and (iY > 300) then
			return 1;
		end
		TLuaFuns:MsDragMouse(iX, iY, 670, 340);
		TLuaFuns:MsSleep(500);
	end
	return 0;
end
--]]

--һ�η����������������ܻ��������
function fnSingleSend(ASendNum, ATimes)
	local iRet = 0;	
	local iSysStock = TOrderInfo:GetStock() * 10000;
	if 0 == TLuaFuns:MsCheck() then
		return 0;
	end
	--�ж���û�д��ʼ���
	iRet = TLuaFuns:MsFindImg('CloseGame.bmp', 1.0, 3);
	if 0 == iRet then
		if 0 == fnOpenMailBoxByEsc() then 
			return 0;
		end
		
		if 0 == fnClickSendMailLabel() then
			return 0;
		end
	end
	
	print('��ȡ�����');	
	local iBagMoney = fnGetBagMoney();
	if iBagMoney == -1 then
		TLuaFuns:MsPostStatus('��ȡ�������ʧ��', tsFail);
		return 0;
	end
	
	--iBagMoney = iBagMoney / 10000;
	local iStockFloat = TOrderInfo:GetStockFloat() * 10000;
	TLuaFuns:MsPostStatus(string.format('��ǰ���: %d ϵͳ���: %d', iBagMoney, iSysStock));
	if iBagMoney - 20000 < ASendNum then 
		TLuaFuns:MsPostStatus(string.format('�������[%d]С����Ҫ���׵Ľ��[%d]', iBagMoney, ASendNum), tsFail, False);
        return 0;
	end

	if (ATimes == 0) and (math.abs(iBagMoney - iSysStock) > iStockFloat) then
		TLuaFuns:MsPostStatus(string.format('ʵ�ʿ��[%d]��ϵͳ���[%d]������ϵͳ�������[%d]', iBagMoney, iSysStock, iStockFloat), tsFail, False);
        return 0;
	end	
	
	--����Է���ɫ��
	TLuaFuns:MsPostStatus('��ʼУ��Է���ɫ������...');
	if 12 < string.len(GTargetRoleName) then
		TLuaFuns:MsPostStatus('�Է���ɫ�����Ȳ����Ϲ涨', tsTargetFail, false);
		return 0;
	end
	if 0 == fnInputRoleName(GTargetRoleName) then
		--TLuaFuns:MsPostStatus('��ɫ������ʧ��', tsFail);
        return 0;
	end
	if 0 == fnCheckRoleInfo(ASendNum, true) then 
		return 0;
	end
	
	--������
	--local hGame = TLuaFuns:MsGetGameHandle();
	--local iX = -1;
	--local iY = -1;
	--iX, iY = TLuaFuns:MsGetTopLeft(hGame);
	--if 0 == fnInputMoney(iX + 320, iY + 412, ASendNum) then
	if 0 == fnInputMoney(ASendNum) then
		TLuaFuns:MsPostStatus('������ʧ��', tsFail);
		return 0;
	end
	
	--[[
	--�˶ԶԷ���ɫ�����Ƿ�Ͷ���һ��
	local custRolerImg = TOrderInfo:GetReceiptRoleImgName();
	TLuaFuns:MsPostStatus(string.format('У������ĶԷ���ɫ��[%s]�Ͷ����Ƿ�һ��...',GTargetRoleName));
	iRet = TLuaFuns:MsFindImg(custRolerImg);
	if 0 == iRet then
		TLuaFuns:MsPostStatus(string.format('����ĶԷ���ɫ[%s]�Ͷ�����һ��',GTargetRoleName), tsTargetFail, false);
		return 0;
	end
	--]]
	
	
	--��ͼ0�������
	local sCaptureName = string.format('%s%s_%d_%d_0.bmp', GCapturePath, TOrderInfo:GetOrderNo(), TOrderInfo:GetRoleID(), ATimes+1);
	TLuaFuns:MsCaptureGame(sCaptureName);
	print(string.format('������_��ͼ0_%s', sCaptureName));
	
	for i=1, 9 do
		print(i);
		if 0 == TLuaFuns:MsCheck() then
			return 0;
		end
		
		if 0 == ATimes then
			TLuaFuns:MsPostStatus('60�밲ȫ�ȴ���ʼ...');
			while TLuaFuns:MsGetTickCount() - GEnterGameTick < 55000 do
				TLuaFuns:MsSleep(10);
			end
			TLuaFuns:MsPostStatus('60�밲ȫ�ȴ�����...');
		end
		
		if i > 1 then
			if 0 == fnCheckRoleInfo(0, false) then
				return 0;
			end
		end
		
		--�� ���� ��ť
		print('�����꣬�����ʼ�');
		--TLuaFuns:MsSleep(5000);
		
		--fnCloseZhuangBeiLan();		
		--fnDragMailBox();
		--fnDragRoleBox();
		
		iX, iY, iRet = TLuaFuns:MsFindImgEx('SendMoney.bmp', 1.0, 5);
		print(iX, iY, iRet);
		TLuaFuns:MsClick(iX + 15, iY + 50, 20, 10);
		TLuaFuns:MsSleep(100);
		TLuaFuns:MsClick(iX + 15, iY + 50, 20, 10);
		--TLuaFuns:MsClick(iX + 260, iY + 465, 10, 5);
		--TLuaFuns:MsSleep(100);
		--TLuaFuns:MsClick(iX + 260, iY + 465, 10, 5);
		TLuaFuns:MsSleep(1000);
		if 0 == ATimes then
			iRet = fnQuitSafe();

			if iRet == 3 then
				if 0 == TLuaFuns:MsCheck() then
					return 0;
				end
			end
			
			if iRet == 2 then
				print('��Ҫ�ⰲȫ�����ҽⰲȫ�ɹ��ˣ��ٴε�����Ͱ�ť');  
				if 0 == fnCheckRoleInfo(0, false) then
					return 0;
				end
				TLuaFuns:MsSleep(100);
				TLuaFuns:MsClick(iX + 15, iY + 50, 20, 10);
				TLuaFuns:MsSleep(100);
				TLuaFuns:MsClick(iX + 15, iY + 50, 20, 10);
				--TLuaFuns:MsClick(iX + 260, iY + 465, 10, 5);
				--TLuaFuns:MsSleep(100);
				--TLuaFuns:MsClick(iX + 260, iY + 465, 10, 5);
			end	
		end
		print('������֤�뵯����');
		iRet = fnCheckSendResult(ATimes);
		if 99 == iRet then
			--����ʧ��
			--TLuaFuns:MsPostStatus(string.format('����[%s]�ѷ���[%d]', TOrderInfo.GetOrderNo(), ASendNum));
			return 0;
		end;
		
		if 0 ~= iRet then
			TLuaFuns:MsPostStatus(string.format('����[%s]�ѷ���[%d]', TOrderInfo.GetOrderNo(), ASendNum));
			return 1;
		end;
	end
	return 0;
end

function fnSendMail()
	local iOrderNum = TOrderInfo:GetSendNum();
	local iDispatchNum = TOrderInfo:GetEachNum();
	local iOddNum = 0;
	local iTimes = 0;
	if iDispatchNum >= iOrderNum then
		iDispatchNum = iOrderNum;
	end
	iOddNum = iOrderNum;
	while true do
		TLuaFuns:MsSleep(100);
		iRet = fnSingleSend(iDispatchNum * 10000, iTimes);
		
		if 0 == iRet then
			return 0;
		end
		iOddNum = iOddNum - iDispatchNum;
		print(string.format('���=%d �ѷ�������= %d ʣ������ = %d', iRet, iOrderNum - iOddNum, iOddNum));	
		if iOddNum <= 0 then
			break;
		end
		
		if iOddNum < iDispatchNum then
			iDispatchNum = iOddNum;
		end
		
		iTimes = iTimes + 1;
	end
	
	local iBagMoney = fnGetBagMoney();
	if iBagMoney ~= -1 then
		local iNewBagMoney = math.floor(iBagMoney/10000);
		TOrderInfo:SetReStock(iNewBagMoney);
	end
	TLuaFuns:MsPostStatus('�������...', tsSuccess, False);
	return 1;
end

---------------------------------------------------------------------------------
function fnDispatchOrder()

	print('��ʼִ�нű�');
	
	GRoleName = TOrderInfo:GetRole();
	GTargetRoleName = TOrderInfo:GetReceiptRole();
	GSendNum = TOrderInfo:GetSendNum()*10000; --ÿ�ν��׽����
	GEachNum = TOrderInfo:GetEachNum();       --�������״���
	GTaskType = TOrderInfo:GetTaskType();
	GCapturePath = TOrderInfo:GetCapturePath();

	--�����ϷOnLine���򷵻ؽ�ɫ����ѡȡ��ɫ
	local iRet = 0;
	print('��ʼִ�нű�1');
	local bRet = false;
	if -1 ~= fnIsEnterTheGame(5) then
		if 0 ~= fnBackToRoler() then
			bRet = true;
		end
	end
	print('��ʼִ�нű�2');
	if not bRet then
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
		print('��ʼִ�нű�5');
		iRet = fnSelChannel();
		if 0 == iRet then
			return 0;
		end
	end
	print('��ʼִ�нű�6');
	iRet = fnSelRole();
	if 0 == iRet then
		return 0;
	end
	print('��ʼִ�нű�7');
	iRet = fnEnterTheGame();
	if 0 == iRet then
		return 0;
	end	

	print('��ʼ����');
	iRet = fnSendMail();
	return iRet;
end

fnDispatchOrder();

--[[
function Test()
	print('��ʼ����...');
	--os.execute("start IoPress.exe 1 a2V5YX4hQCMkfiUkfiVeKiYoKCkpeWEiOiIuPzwvLg==");
	--TLuaFuns:MsPressPassWord(TOrderInfo:GetPassWord());

	local hGame = 0;
	local iY = -1; 
	local iX = -1; 
	local iRet = -1;
	--TLuaFuns:MsCreateBmp('������Ϸ','CloseGame',230,200,155);
	
	hGame = TLuaFuns:MsFindWindow('','���³�����ʿ��¼����');
	if TLuaFuns:MsIsWindow(hGame) == 0 then
		print('��Ϸû�д�');
		return;
	end
	TLuaFuns:MsSetGameHandle(hGame);
	print('������Ϸ������');
	

	fnLoginGame();
	
end

Test();
--]]

