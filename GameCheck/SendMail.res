        ��  ��                  � 4   T E X T   S E N D M A I L       0         --������������
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
		iRet = TLuaFuns:MsFindString('��Ϸ�˵�(Esc)', 'ffffff-000000|b3b3b3-000000');
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
	print(1);
	for i = 1,9 do
		iRet = TLuaFuns:MsFindString('��Ϸ�˵�(Esc)', TLuaFuns:MsGetPianSe('�˵�_��ͨ����'));
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
	--TLuaFuns:MsPostStatus('��ʼ�����˺�����...');
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
	TLuaFuns:MsFrontWindow(hGameHandle);
	TLuaFuns:MsClick(iLeft, iTop);
	TLuaFuns:MsSleep(500);
	TLuaFuns:MsPressPassWord(TOrderInfo:GetPassWord());
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
		hLogin = TLuaFuns:MsFindWindow('','���³�����ʿ��¼����');
		if 0 == TLuaFuns:MsIsWindow(hLogin) then
			TLuaFuns:MsPostStatus('��½�����쳣�˳�', tsFail);
			return 0;
		end
		
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
		
		local rolerBmpName = TOrderInfo:GetRoleImgName();
		print(string.format('��ɫͼƬ[%s]', rolerBmpName));
		iX, iY = TLuaFuns:MsFindImgEx(rolerBmpName);
		if (iX ~= -1) and (iY ~= -1) then
			break;
		end
		iX, iY = TLuaFuns:MsFindStringEx(GRoleName, TLuaFuns:MsGetPianSe('��½_ѡ���ɫ'), 0.7);
		if (iX ~= -1) and (iY ~= -1) then
			break;
		end
	end
	
	if not IsEnterRolePage then
		TLuaFuns:MsPostStatus('�����ɫҳ�泬ʱ', tsFail);
		return 0;
	end
	
	if (iX == -1) or (iY == -1) then
		TLuaFuns:MsPostStatus(string.format('���ҽ�ɫ[%s]�����ڣ�', GRoleName), tsFail, False);
		return 0;
    end;
	print(string.format('��ɫλ�� X[%d]Y[%d]', iX, iY));
	GEnterGameTick = TLuaFuns:MsGetTickCount();
	TLuaFuns:MsPostStatus(string.format('�ҵ���ɫ[%s]', GRoleName));	
	TLuaFuns:MsDbClick(iX, iY);
	TLuaFuns:MsSleep(300);
	TLuaFuns:MsDbClick(iX, iY);
	TLuaFuns:MsSleep(300);
	TLuaFuns:MsDbClick(iX, iY);
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
		--TLuaFuns:MsPressEsc();
		
		iX,iY,iRet = TLuaFuns:MsFindImgEx('LoginSuccess1.bmp');
		if (iX ~= -1) and (iY ~= -1) then
			TLuaFuns:MsClick(iX + 5, iY + 5, 10, 5);
			TLuaFuns:MsSleep(500);
			if 0 ~= TLuaFuns:MsFindString('��Ϸ�˵�(Esc)', 'ffffff-000000') then
				--iX, iY = TLuaFuns:MsFindStringEx('ѡ���ɫ', TLuaFuns:MsGetPianSe('�˵�_ѡ���ɫ'));
				iX, iY = TLuaFuns:MsFindImgEx('BackToRoler.bmp', 0.9);
				if (iX ~= -1) and (iY ~= -1) then
					TLuaFuns:MsClick(iX + 5, iY + 5, 10, 5);
				end
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
	--TLuaFuns:MsFindImg('LoginSuccess.bmp', 0.7, iDelay);
	iX, iY, iRet = TLuaFuns:MsFindImgEx('LoginSuccess.bmp|LoginSuccess1.bmp', 0.9, iDelay);
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
		
		iX, iY, iRet = TLuaFuns:MsFindImgEx('Ok.bmp|GiveUp.bmp|Enter.bmp|NextStep.bmp', 0.9);
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

--[[
--���ʼ��䡣���ڷ����ʱ��Esc���ʼ���
function fnOpenMailBoxByEsc()
	local iRet = 0;
	local iX = -1;
	local iY = -1;
	local bOpen = false;
	
	for i=1, 5 do
		if 0 ~= TLuaFuns:MsFindString('��Ϸ�˵�(Esc)', 'ffffff-000000|b3b3b3-000000') then
			iX, iY = TLuaFuns:MsFindImgEx('MailBox.bmp', 0.9);
			if (iX ~= -1) and (iY ~= -1) then
				TLuaFuns:MsClick(iX + 5, iY + 5);
				TLuaFuns:MsSleep(500);
				iX, iY, iRet = TLuaFuns:MsFindStringEx('����(��)', 'ffffff-000000|b3b3b3-000000');
				if (-1 ~= iRet) then
					bOpen = true;
					break;
				end
			end
		end
		TLuaFuns:MsPressEsc();
		TLuaFuns:MsSleep(500);
	end	
	
	if (not bOpen) trhen
		TLuaFuns:MsPostStatus('��Esc���ʼ���ʧ�ܣ�', tsFail);
		return 0;
	end
	
	--�ر���ʾ��
	iX, iY, iRet = TLuaFuns:MsFindStringEx('�����д���δ���յ��ʼ�', 'ffffff-000000');
	if (iX ~= -1) and (iY ~= -1) then
		TLuaFuns:MsClick(iX + 75, iY + 65);
	end
	TLuaFuns:MsPostStatus('��Esc���ʼ�����ɣ�');
	return 1;
end;

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
	iRet = TLuaFuns:MsFindString('��Ϸ�˵�(Esc)|����(L)', TLuaFuns:MsGetPianSe('�˵�_��ͨ����'));
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
		TLuaFuns:MsClick(iX + 310, iY + 155, 10, 5);
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
	local iInputX = -1;
	local iInputY = -1;
	for i=1, 3 do
		bRet = false;
		iX, iY = TLuaFuns:MsFindStringEx('�����ʼ�', TLuaFuns:MsGetPianSe('�ʼ�_�ʼ���_��ѡ��'));
		if (iX ~= -1) and (iY ~= -1) then
			iInputX = iX;
			iInputY = iY;
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
		TLuaFuns:MsClick(iInputX + 75, iInputY + 25);
		TLuaFuns:MsSleep(500);
		TLuaFuns:MsPressDel(12);
		TLuaFuns:MsSleep(500);
		TLuaFuns:MsPressString(hGame, sRoleName);
		TLuaFuns:MsSleep(500);
		
		iX, iY = TLuaFuns:MsFindImgEx(sReceiptRoleImg);
		if (iX ~= -1) and (iY ~= -1) then
			TLuaFuns:MsPostStatus('�Է���ɫ���������');
			return 1;
		end
		TLuaFuns:MsSleep(500);
	end
	TLuaFuns:MsPostStatus('�Է���ɫ������ʧ��');
	return 0;
end

--������
function fnInputMoney(AX, AY, ANum)
	TLuaFuns:MsPostStatus('�ȴ�������...');
	local hGame = TLuaFuns:MsGetGameHandle();
	local iX = -1;
	local iY = -1;
	local iRet = -1;
	iX, iY = TLuaFuns:MsGetTopLeft(hGame);
	for i=1, 3 do
		if i > 1 then
			TLuaFuns:MsPostStatus('�ȴ�����Ľ���붩�������֤...');
			iRet = TLuaFuns:MsGetNumber(iX + 290, iY + 400, iX + 410, iY + 425, 'ffffff-000000');
			print(iRet, ANum);
			if ANum == iRet then
				TLuaFuns:MsPostStatus('����Ľ���붩�������֤���');
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
		TLuaFuns:MsPostStatus('����������');
	end
	return 0;
end

--��ȡ�������
function fnGetBagMoney()
	local iRet = -1;
	local iMoney = -1;
	local hGame = TLuaFuns:MsGetGameHandle();	
	
	local iX = -1;
	local iY = -1;
	
	iX, iY = TLuaFuns:MsGetTopLeft(hGame);
	for i=0, 9 do
		iRet = TLuaFuns:MsFindString('װ����(I)', TLuaFuns:MsGetPianSe('�˵�_��ͨ����'));
		if 0 ~= iRet then
			iMoney = TLuaFuns:MsGetNumber(iX + 580, iY + 520, iX + 710, iY + 550, TLuaFuns:MsGetPianSe('�ʼ�_�������'));
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
			TLuaFuns:MsClick(iX + 5, iY + 2, 10, 8);
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
		TLuaFuns:MsClick(iX + 120, iY + 25, 5, 5);
		
		TLuaFuns:MsSleep(1000);
		
		iPosX, iPosY = TLuaFuns:MsFindStringEx('ѡ��', 'ffffff-000000')
		
		if (iPosX ~= -1) and (iPosY ~= -1) then			
			TLuaFuns:MsClick(iPosX + 65, iPosY + 10, 10, 5);
			TLuaFuns:MsPressEnter();
			iPosX = -1; iPosY = -1;
		else
			iPosX, iPosY = TLuaFuns:MsFindStringEx('����', TLuaFuns:MsGetPianSe('�˵�_��ͨ����'));
			if (iPosX ~= -1) and (iPosY ~= -1) then
				break;			
			end
		end
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
		iX, iY = TLuaFuns:MsFindImgEx('MailCheckCodeDlg.bmp', 1.0);
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
				TLuaFuns:MsSleep(3000);
				iRet = TLuaFuns:MsFindImg('CheckCode.bmp');
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
	while TLuaFuns:MsGetTickCount() - dwTickCount <= dwWaitTick do
		TLuaFuns:MsSleep(100);
		if 0 == TLuaFuns:MsCheck() then
			return 0;
		end
		
		if 0 ~= TLuaFuns:MsFindImg('MailCheckCodeDlg.bmp', 1.0) then
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
	
		TLuaFuns:MsSleep(1000);
		TLuaFuns:MsClick(x + 45, y + 35, 10, 5);
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
	if 0 == TLuaFuns:MsFindString('ȷ�����', 'ddc593-000000') then
		print('����Ҫ�ⰲȫ');
		return 1;
	end
	
	iX,iY = TLuaFuns:MsGetTopLeft(TLuaFuns:MsGetGameHandle());
	TLuaFuns:MsClick(iX + 435, iY + 335, 10, 5);
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

--һ�η����������������ܻ��������
function fnSingleSend(ASendNum, ATimes)
	local iRet = 0;	
	local iSysStock = TOrderInfo:GetStock() * 10000;
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
	local hGame = TLuaFuns:MsGetGameHandle();
	local iX = -1;
	local iY = -1;
	iX, iY = TLuaFuns:MsGetTopLeft(hGame);
	if 0 == fnInputMoney(iX + 400, iY + 413, ASendNum) then
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
		TLuaFuns:MsClick(iX + 260, iY + 465, 10, 5);
		TLuaFuns:MsSleep(100);
		TLuaFuns:MsClick(iX + 260, iY + 465, 10, 5);
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
				TLuaFuns:MsClick(iX + 260, iY + 465, 10, 5);
				TLuaFuns:MsSleep(100);
				TLuaFuns:MsClick(iX + 260, iY + 465, 10, 5);
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

-------------------------------------------------�ֲ�------------------------------------------------------------
---------------------------------------------��̯------------------------------------------------------------
--�ߵ���̯�ص�
function fnWalkToStallPlace(AX, AY)
	local iX = -1;
	local iY = -1;
	local iRet = 0;
	local dwTickCount = TLuaFuns:MsGetTickCount();
	while TLuaFuns:MsGetTickCount() - dwTickCount < 3 * 60 * 1000 do
		fnOpenMap();
		TLuaFuns:MsRightClick(AX, AY);
		TLuaFuns:MsSleep(1000);
		fnCloseMap();
		if TLuaFuns:MsCheck() == 0 then
			return 0;
		end
		iRet = TLuaFuns:MsFindString('�ߵ���', TLuaFuns:MsGetPianSe('��ħ_����'));
		if (1 == iRet) then
			break;
		end
		iRet = TLuaFuns:MsFindImg('Wall.bmp', 1.0);
		if (1 == iRet) then
			break;
		end
		TLuaFuns:MsSleep(3000);
	end
	if (0 == iRet) then
		TLuaFuns:MsPostStatus('���﹤���ص㳬ʱ��', tsFail);
		return 0;
	else
		TLuaFuns:MsPostStatus('���﹤���ص㣡');
	end	
end

--��̯ �����֮ǰ
function fnPreDoStall()
	local iX = -1;
	local iY = -1; 
	local iRet = 0;
	local iRoleX = 0;  
	local iRoleY = 0;
	local iIsOpenMenu = 0;
	
	
	iX,iY,iRet = TLuaFuns:MsFindImgEx('Self.bmp');
	if (-1 == iX) or (-1 == iY) then
		print('��̯-���ҽ�ɫ��ʧ�ܣ�');
		return 0;
	end;
	
	--��ESC
	for i = 0,9 do
		iIsOpenMenu = 0;
		if TLuaFuns:MsCheck() == 0 then
			return 0;
		end
		iX,iY,iRet = TLuaFuns:MsFindImgEx('CloseEnchat.bmp');
		if iRet == 0 then 
			TLuaFuns:MsPressEsc();
			print('�Ѿ���̯���');
			return 1; 
		end
		iRet = TLuaFuns:MsFindString('��Ϸ�˵�(Esc)', 'ffffff-000000|b3b3b3-000000');
		if iRet ~= 0 then iIsOpenMenu = 1; break; end
		TLuaFuns:MsPressEsc();
	end
	if iIsOpenMenu == 0 then
		if -1 == fnIsEnterTheGame(1) then
			TLuaFuns:MsPostStatus('��ɫ�Ѿ����ߣ�', tsFail);
			return 99;
		end
		TLuaFuns:MsPostStatus('��̯-û��û�д򿪲˵���');
		return 0;
	end
	iX,iY,iRet = TLuaFuns:MsFindImgEx('Career.bmp', 0.8, 2);
	if (iX == -1) or (iY == -1) then
		TLuaFuns:MsPostStatus('��̯-��ɫû�и�ְҵѡ�', tsSuspend);
		TLuaFuns:MsCheck();
		if TOrderInfo:GetTaskStop() == 1 then
			TLuaFuns:MsPostStatus('������ֹ', tsFail, false);
			return 99;
		end
		return 0;
	end
	print(2);
	--�������ְҵ��
	TLuaFuns:MsClick(iX + 5, iY + 5);
	TLuaFuns:MsSleep(500);
	print(3);
	iX,iY,iRet = TLuaFuns:MsFindStringEx('���踽ħ�̵�', TLuaFuns:MsGetPianSe('��ħ_���踽ħ�̵�'));
	if (-1 == iX) or (-1 == iY) then
		TLuaFuns:MsPostStatus('��̯-�򿪸�ְҵʧ�ܣ�', tsFail);
		return 0;
	end
	print(4);
	--��������踽ħ�̵ꡱ
	TLuaFuns:MsClick(iX+30, iY+10);
	TLuaFuns:MsSleep(500);	
	
	iX,iY,iRet = TLuaFuns:MsFindStringEx('��������������', 'ffffff-000000');
	if (-1 ~= iX) and (-1 ~= iY) then
		for i=0,9 do
			GChildDurability = TLuaFuns:MsGetNumber(iX+55, iY-15, iX+100, iY-2, 'ffffff-000000');
			if GChildDurability ~= -1 then
				TLuaFuns:MsPostStatus(string.format('��ȡ�;ö����[%d]',GChildDurability));
				break;
			end
			TLuaFuns:MsSleep(200); 
		end
		if GChildDurability == -1 then
			TLuaFuns:MsPostStatus('��ȡ�;ö�ʧ�ܣ�', tsFail);
			return 0;
		end
		
		if GChildDurability < 20 then
			TLuaFuns:MsPostStatus('�;öȲ���20�����ܰ�̯��', tsSuspend);
			TLuaFuns:MsCheck();
			if TOrderInfo:GetTaskStop() == 1 then
				TLuaFuns:MsPostStatus('������ֹ', tsFail, false);
				return 99;
			end
			return 0;
		end
		
		--����������
		local hGame = TLuaFuns:MsGetGameHandle();
		TLuaFuns:MsPressString(hGame, GSendNum);
		TLuaFuns:MsSleep(500);
		TLuaFuns:MsPressEnter();
	else
		iRet = TLuaFuns:MsFindImg('ZeroDurable.bmp', 1.0);
		if iRet == 0 then
			TLuaFuns:MsPostStatus('��̯-�򿪸�ħ�̵�ʧ�ܣ�', tsFail);
			return 0;
		else
			TLuaFuns:MsPostStatus('�;ö�Ϊ�㣬�޷������̵�', tsSuspend);
			TLuaFuns:MsCheck();
			if TOrderInfo:GetTaskStop() == 1 then
				TLuaFuns:MsPostStatus('������ֹ', tsFail, false);
				return 99;
			end
			return 0;
		end
	end
	
	return 1;
end

--��̯ �������
function fnDoStall()
	local iX = -1;
	local iY = -1; 
	local iRet = 0;
	local iRoleX = -1;
	local iRoleY = -1;
	local r = 40;       --�뾶
	local a = 30;       --�Ƕ� 30�� 
	local x0 = 0;       --����ԭ��(0,0)
	local y0 = 0; 
	local x1 = 0;  
	local y1 = 0; 
	local i = 0;
	local bOk  = false;
	local bClickErr = false;
	
	--iRoleX,iRoleY,iRet = TLuaFuns:MsFindStringEx(GRoleName, 'ffffff-000000');
	iRoleX,iRoleY,iRet = TLuaFuns:MsFindImgEx('Self.bmp');
	if (iRet ~= -1) then
		iRoleY = iRoleY + 130;
		print(string.format('��ɫ��ʼ����(x1=%d,y1=%d)', iRoleX,iRoleY));
		for i = 1, 2 do  --��30�㣬60�㣬�ܹ���2��
			bRet = false;
			x1= math.ceil(math.cos(i*a*math.pi/180)*r);
			y1= math.ceil(math.sin(i*a*math.pi/180)*r);
			x1= iRoleX + x1;
			y1= iRoleY - y1;
			--���x>590 �п��ܱ������ͼƬ��ס
			if (x1 < 590) then
				TLuaFuns:MsClick(x1, y1);
				TLuaFuns:MsSleep(1000);
				iX,iY,iRet = TLuaFuns:MsFindStringEx('����|�������', 'ffffff-000000|68d5ed-000000');
				if iRet ~= -1 then
					TLuaFuns:MsPressEsc();  
					bClickErr = true;
				end
				iX,iY,iRet = TLuaFuns:MsFindStringEx('��NPC̫���ӽ�|���������̵�', 'ffffff-000000');
				if iRet ~= -1 then
					TLuaFuns:MsPressEnter();
					TLuaFuns:MsSleep(100);		
					TLuaFuns:MsPressEsc(); 			
					return 0;
				end
				if (not bClickErr) then
					--�ж��Ƿ��̯�ɹ�����һ���ҽ�ɫ��������ġ������ѡ�
					iX,iY,iRet = TLuaFuns:MsFindImgEx('Self.bmp', 1.0, 2);
					if (iRet ~= -1) then
						iX,iY,iRet = TLuaFuns:MsAreaFindImgEx(iX-30,iY-120,iX + 50,iY-20, 'Fee.bmp', 1.0, 2);
						print(string.format('��̯0���=%d', iRet));
						if iRet ~= -1 then
							bOk = true;
							break;
						end
					end
				end
			end
			print('x����Խ����...');
		end
		
		if (not bOk) then
			TLuaFuns:MsPostStatus('û���ҵ���̯λ�ã�');
			return 0;
		end 
		return 1;
	end
	return 0;
end

function fnStallLoop()
	local iRet = 0;
	local i = 0;
	--��������һ��û�˵�ס�Լ����ֵ�λ��
	for i = 1,6 do
		fnCloseMenu();
		iRet = fnPreDoStall();
		if (1 == iRet) then
			--��ʼ��̯
			iRet = fnDoStall();
			print(string.format('��̯1���=%d', iRet));				
			if (1 == iRet) then 
				break;
			elseif iRet == 99 then
				return 99;
			end
		elseif iRet == 99 then
			return 99;
		end
		TLuaFuns:MsTheKeysWalk(VK_RIGHT, 300);
	end
	if (1 == iRet) then 
		return 1;
	end
	
	--�ҵ����ұ߻�û�ҵ����ʵ�λ�ã������˵�ס�ˣ�������һ�㣬���ҵ�������һ��û�˵�ס�Լ����ֵ�λ��
	TLuaFuns:MsTheKeysWalk(VK_UP, 300); 
	for i = 1,6 do
		iRet = fnPreDoStall();
		if (1 == iRet) then
			--��ʼ��̯
			iRet = fnDoStall();	
			print(string.format('��̯2���=%d', iRet));
			if (1 == iRet) then 
				break;
			elseif iRet == 99 then
				return 99;
			end
		elseif iRet == 99 then
			return 99;
		end
		TLuaFuns:MsTheKeysWalk(VK_LEFT, 300);
	end
	if (1 == iRet) then 
		return 1;
	end
	
	--�ص�����ߵĳ�ʼλ��
	TLuaFuns:MsTheKeysWalk(VK_DOWN, 1000);
	return 0;
end

--�ӺŸ�ħװ���ָ��;ö�
function fnRecoverDurability(iDurability);
	if (iDurability > 20) then 
		TLuaFuns:MsPostStatus('����Ҫ�ָ��;öȣ�');
		return 1; 
	end;
	--�򿪵�ͼ
	if 0 == fnOpenMap() then return 0; end
	
	--�ӵ�ͼ���ߵ�NPC��ǰ
	TLuaFuns:MsRightClick(370,195);
	TLuaFuns:MsPressChar('N');
	local iX = -1;
	local iY = -1;
	local iRet = -1;
	local dwTickCount = TLuaFuns:MsGetTickCount();
	while TLuaFuns:MsGetTickCount() - dwTickCount < 3 * 60 * 1000 do
		if TLuaFuns:MsCheck() == 0 then
			return 0;
		end
		iX,iY,iRet = TLuaFuns:MsFindStringEx('�Ǳ���', 'f7d65a-000000', 0.9, 3);
		if (-1 ~= iRet) then
			break;
		end
	end
	if (-1 == iRet) then
		TLuaFuns:MsPostStatus('����ָ��;öȵص㳬ʱ��', tsFail, false);
		return 0;
	end
	
	--�����п��ܵ㲻��NPC���ϣ����Գ��Զ�㼸��
	local bOk = false;
	dwTickCount = TLuaFuns:MsGetTickCount();
	while TLuaFuns:MsGetTickCount() - dwTickCount < 3 * 60 * 1000 do
		if TLuaFuns:MsCheck() == 0 then
			return 0;
		end
		TLuaFuns:MsClick(iX + 10, iY + 30);
		TLuaFuns:MsSleep(500);
		iX,iY,iRet = TLuaFuns:MsFindStringEx('�ָ��;ö�', 'e6c89b-000000', 0.9, 3);
		if (-1 ~= iRet) then
			TLuaFuns:MsClick(iX + 10, iY + 5);
			TLuaFuns:MsSleep(500);
			iX,iY = TLuaFuns:MsFindImgEx('Ok.bmp');
			if (-1 ~= iX) and (-1 ~= iY) then
				TLuaFuns:MsClick(iX+5, iY+5);
				fnCloseMenu();
				TLuaFuns:MsPostStatus('�;öȻָ���ɣ�');
				bOk = true;
				break;
			end
		end
	end
	if (not bOk) then
		TLuaFuns:MsPostStatus('�;öȻָ�ʧ�ܣ�', tsFail, false);
		return 0;
	end
	
	return 1;
end

function fnStallDoWork()
	local iRet = 0;
	iRet = fnWalkToStallPlace(222,325);
	if (0 == iRet) then return 0; end
	
	for i = 1, 20 do
		TLuaFuns:MsPostStatus(string.format('��ʼ��̯�����Ե�%d��',i));
		if TLuaFuns:MsCheck() == 0 then
			return 0;
		end
		iRet = fnStallLoop();
		if (1 == iRet) then
			break;
		elseif iRet == 99 then
			return 0;
		end
	end
	if (0 == iRet) then
		TLuaFuns:MsPostStatus('��̯ʧ�ܣ�', tsFail, false);
		return 0;
	end
	--�ύ��̯��ɵ�״̬�����ȴ��Է���ħ��ɵ�״̬
	TLuaFuns:MsPostStatus('��̯��ɣ�');
	TLuaFuns:MsSetRoleStep(rsStallFinish);
	
	GChildInitBagMoney = fnGetBagMoney();
	if (GChildInitBagMoney == -1) then
		TLuaFuns:MsPostStatus('��ȡ�������ʧ��', tsFail);
		return 0;
	end

	local bLog = true;
	local iBagMoneyBefore = GChildInitBagMoney;
	local iBagMoneyAfter = 0;
	local iTargetStep = -1;
	local dwTickCount = TLuaFuns:MsGetTickCount();
	local dwWaitTick = 20 * 60 * 1000;
	while TLuaFuns:MsGetTickCount() - dwTickCount < dwWaitTick do
		if TLuaFuns:MsCheck() == 0 then
			return 0;
		end
		if -1 == fnIsEnterTheGame(1) then 
			TLuaFuns:MsPostStatus('�Ӻ��쳣�Ѿ����ߣ�', tsFail, false);
			return 0;
		end
		
		TLuaFuns:MsSetMasterRecRoleName();
		iTargetStep = TLuaFuns:MsGetTargetRoleStep();
		if iTargetStep == rsTargetFail then
			TLuaFuns:MsPostStatus('�����˳�, ����ʧ��', tsFail, false);
			return 0;
		end
		if (bLog) then 
			TLuaFuns:MsPostStatus('�ȴ����Ÿ�ħ...'); 
			bLog  = false;
		end;
		--1.������Ÿ�ħ���
		if iTargetStep == rsEnchatFinish then	
			local iStep = TLuaFuns:MsGetRoleStep();
			--2.����Ӻ��ǰ�̯���(��Ǯ�ɹ���״̬��ִ��)
			if (iStep == rsStallFinish) then
				for i=0,10 do
					if i == 0 then
						TLuaFuns:MsPostStatus('���Ÿ�ħ��ɣ�����Ӻ��Ƿ��յ�Ǯ...');
					end
					TLuaFuns:MsSleep(3000);
					iBagMoneyAfter = fnGetBagMoney();
					TOrderInfo:SetReStock(math.floor(iBagMoneyAfter/10000));
					if (iBagMoneyAfter == -1) then
						TLuaFuns:MsPostStatus('��ȡ�������ʧ��', tsFail, false);
						return 0;
					end				
					--3.����Ӻ���Ǯ�ɹ�
					if iBagMoneyAfter >= GChildInitBagMoney + GSendNum * GEachNum then
						--4.����Ӻŷֲ����
						print(string.format('�Ӻ���Ǯ���iBagMoneyAfter:%d GChildInitBagMoney:%d GSendNum:%d GEachNum:%d', iBagMoneyAfter, GChildInitBagMoney, GSendNum, GEachNum));
						TLuaFuns:MsSetRoleStep(rsFinish);
						while true do
							if TLuaFuns:MsCheck() == 0 then
								return 0;
							end
							iStep = TLuaFuns:MsGetRoleStep();
							if iStep == rsNormal then					
								TLuaFuns:MsPostStatus(string.format('�Ӻ�[%s]�ֲ�������ɣ�', GRoleName), tsSuccess, False);
								return 1;
							end
						end
						--4
					elseif iBagMoneyAfter >= (iBagMoneyBefore+GSendNum) then
						TLuaFuns:MsSetRoleStep(rsRecMoneyOk);
						TLuaFuns:MsPostStatus(string.format('�Ӻ�[%s]��Ǯ�ɹ���', GRoleName));
						iBagMoneyBefore = iBagMoneyAfter;
						bLog  = true;
						break;
					else 
						if i >= 9 then
							TLuaFuns:MsSetRoleStep(rsFinish);
							while true do
								if TLuaFuns:MsCheck() == 0 then
									return 0;
								end
								iStep = TLuaFuns:MsGetRoleStep();
								if iStep == rsNormal then					
									TLuaFuns:MsPostStatus(string.format('�Ӻ�[%s]��Ǯʧ�ܣ�', GRoleName), tsFail, false);
									return 0;
								end
							end
						end
						TLuaFuns:MsPostStatus(string.format('�Ӻ�[%s]��Ǯʧ��,���¼����', GRoleName));
						fnCloseMenu();
						TLuaFuns:MsSleep(100);						
					end
					--3					
				end
			end		
			--2
		end
		--1
		iRet = 1;
	end
	
	if iRet == 0 then
		TLuaFuns:MsPostStatus('�Է�����ʱ��', tsFail);
		return 0;
	end
	return 1;
end;

------------------------------------------------��ħ-----------------------------------------------------
--��鸽ħ��ɫ��������Ƿ��㹻��ħ
function fnCheckEnchatRoleBagMoney()
	local iBagMoney = fnGetBagMoney(); 
	fnCloseMenu();
	if iBagMoney == -1 then
		TLuaFuns:MsPostStatus('��ȡ��ħ��ɫ�������ʧ�ܣ�', tsFail);
		return 0;
	end;	
	local iTaskMoney = GSendNum * GEachNum; --��ħ�ܽ��
	
	if iBagMoney < iTaskMoney then
		TLuaFuns:MsPostStatus('��ħ��ɫ�������㣡', tsFail, false);
		return 0;
	end
	return 1;
end


--
function fnFindPlayerBooth()
	local iX = -1;
	local iY = -1;
	local iRoleX = -1;
	local iRoleY = -1;
	local iRet = -1;
	GFeeX = -1; GFeeY = -1;
	--�����
	iRoleX,iRoleY,iRet = TLuaFuns:MsFindImgEx('Target.bmp', 1.0, 3);
	if (iRoleX == -1) or (iRoleY == -1) then
		TLuaFuns:MsPostStatus(string.format('û���ҵ���̯�����[%s]', GTargetRoleName));
		GTargetRoleName = '';
		TLuaFuns:MsClearRecvRoleName();		
		return 0;
	end
	iX,iY,iRet = TLuaFuns:MsAreaFindImgEx(iRoleX-30,iRoleY-120,iRoleX + 50,iRoleY-20, 'Fee.bmp', 1.0, 3);
	if (iX == -1) or (iY == -1) then	
		iX,iY,iRet = TLuaFuns:MsAreaFindString(iRoleX-30,iRoleY-120,iRoleX + 50,iRoleY-20, '������', TLuaFuns:MsGetPianSe('��ħ_��ħ'), 0.9, 3);
	end
	if (iX == -1) or (iY == -1) then
		TLuaFuns:MsPostStatus(string.format('û���ҵ����[%s]�İ�̯λ[X:%d Y:%d Ret:%d]', GTargetRoleName, iX, iY, iRet));	
		return 0;
	end
	GFeeX = iX;
	GFeeY = iY;
	TLuaFuns:MsPostStatus(string.format('�Ѿ��ҵ����[%s]�İ�̯λ[X:%d Y:%d Ret:%d]', GTargetRoleName, iX, iY, iRet));	
	return 1;
end

function fnOpenEnchantDlg()
	local iX = -1;
	local iY = -1;
	if (GFeeX == -1) or (GFeeY == -1) then
		return iX, iY;
	end
	for i=1,3 do
		--�򿪸�ħ����------------------------------------------------------
		TLuaFuns:MsClick(GFeeX, GFeeY);
		iX, iY, iRet = TLuaFuns:MsFindStringEx('����븽ħ�õ���װ����Ƭ', 'ffffff-000000', 0.9, 2);
		if iRet ~= -1 then return iX, iY; end
	end
	GFeeX = -1; GFeeY = -1;
	TLuaFuns:MsPostStatus(string.format('�򿪸�ħ����ʧ�ܣ�[%d,%d]', GFeeX,GFeeY));	
	return iX, iY;
end


--��ħ
function fnEnchant(ATimes)
	local iX = -1;
	local iY = -1; 
	local iRoleX = -1;
	local iRoleY = -1;
	local iRet = 0;
	local iStep = 0;
	
	if TLuaFuns:MsCheck() == 0 then
		if TOrderInfo:GetTaskStop() == 1 then
			return 99;
		end
		return 0;
	end
	
	if -1 == fnIsEnterTheGame(1) then
		TLuaFuns:MsPostStatus('��ɫ�Ѿ����ߣ�', tsFail);
		return 99;
	end
	
	if ATimes == 0 then	
		TLuaFuns:MsPostStatus('60�밲ȫ�ȴ���ʼ...');
		while TLuaFuns:MsGetTickCount() - GEnterGameTick < 55000 do
			TLuaFuns:MsSleep(10);
		end
		TLuaFuns:MsPostStatus('60�밲ȫ�ȴ�����...');
	end
	--�򿪸�ħ����------------------------------------------------------
	iX, iY = fnOpenEnchantDlg();
	if (iX == -1) or (iY == -1) then
		fnFindPlayerBooth();
		return 0;
	end;
	
	iEnchatRoleBagMoney_before = fnGetBagMoney();
	--���װ����1��װ����2���޸�ħ��װ���Ϳ�Ƭ
	iRet = TLuaFuns:MsAreaFindImg(80, 555, 150, 590, 'StuffIsNull.bmp', 0.8, 2);
	if iRet == 1 then
		TLuaFuns:MsPostStatus('װ�����߿�Ƭû�а�ָ��λ�ðڷţ�', tsSuspend);
		TLuaFuns:MsCheck();
		if TOrderInfo:GetTaskStop() == 1 then
			TLuaFuns:MsPostStatus('������ֹ', tsFail, false);
			return 99;
		end
		return 0;
	end
	
	--�϶�װ����1��װ����ָ��λ��
	TLuaFuns:MsDragMouse(iX-190, iY+240, iX+30, iY-30);
	if TLuaFuns:MsFindString('ֻ�ܷ���װ��', 'ffffff-000000',1.0,2) ~= 0 then
		TLuaFuns:MsPostStatus('װ����1����Ʒ����װ����', tsSuspend);
		TLuaFuns:MsPressEnter();
		TLuaFuns:MsCheck();
		if TOrderInfo:GetTaskStop() == 1 then
			TLuaFuns:MsPostStatus('������ֹ', tsFail, false);
			return 99;
		end
		return 0;
	end
	if TLuaFuns:MsFindString('��װ��ԭ�еĸ�ħЧ��������ʧ', 'ffffff-000000') ~= 0 then
		TLuaFuns:MsPressEnter();
	end
	
	--�϶�װ����2�Ŀ�Ƭ��ָ��λ��
	TLuaFuns:MsDragMouse(iX-160, iY+240, iX+130, iY-30);
	if TLuaFuns:MsFindString('ֻ�ܷ�����￨Ƭ', 'ffffff-000000',1.0,2) ~= 0 then
		TLuaFuns:MsPostStatus('װ����2����Ʒ���ǹ��￨Ƭ��', tsSuspend);
		TLuaFuns:MsPressEnter();
		TLuaFuns:MsCheck();
		if TOrderInfo:GetTaskStop() == 1 then
			TLuaFuns:MsPostStatus('������ֹ', tsFail, false);
			return 99;
		end
		return 0;
	end
	if TLuaFuns:MsFindString('���￨Ƭ��װ����𲻷�', 'ffffff-000000') ~= 0 then
		TLuaFuns:MsPostStatus('���￨Ƭ��װ����𲻷���', tsSuspend);
		TLuaFuns:MsPressEnter();
		TLuaFuns:MsCheck();
		if TOrderInfo:GetTaskStop() == 1 then
			TLuaFuns:MsPostStatus('������ֹ', tsFail, false);
			return 99;
		end
		return 0;
	end
	
	--�������ħ����ť
	iX,iY = TLuaFuns:MsFindImgEx('Enchant.bmp');
	if (-1 == iX) or (-1 == iY) then
		TLuaFuns:MsPostStatus('û���ҵ���ħ��ť��');
		return 0;
	end
	TLuaFuns:MsClick(iX+5, iY+5);
	iX,iY,iRet = TLuaFuns:MsFindStringEx('ȷ��Ҫ��ħ����װ����', 'ffffff-000000',1.0,2);
	if (-1 == iX) or (-1 == iY) then
		TLuaFuns:MsPostStatus('�򿪸�ħȷ������ʧ�ܣ�');
		return 0;
	end

	--�жϸ�ħ�����Ƿ��㹻
	if TLuaFuns:MsFindImg('OkGray.bmp') ~= 0 then		
		TLuaFuns:MsPostStatus('�ܽ����ᾧ���㣡', tsSuspend);
		TLuaFuns:MsCheck();
		if TOrderInfo:GetTaskStop() == 1 then
			TLuaFuns:MsPostStatus('������ֹ', tsFail, false);
			return 99;
		end
		return 0;
	end
	
	--ȷ��
	TLuaFuns:MsClick(iX+30, iY+185);
	TLuaFuns:MsSleep(1000);
	
	--ȷ��
	iX,iY,iRet = TLuaFuns:MsFindStringEx('��ȷ��Ҫ���и�ħ��', 'ffffff-000000');
	if (-1 == iX) or (-1 == iY) then
		TLuaFuns:MsPostStatus('�򿪸�ħȷ�Ͻ���ʧ�ܣ�', tsFail);
		return 0;
	end
	iX,iY = TLuaFuns:MsFindImgEx('Ok.bmp');
	if (-1 == iX) or (-1 == iY) then
		TLuaFuns:MsPostStatus('��ħȷ��ʧ�ܣ�', tsFail);
		return 0;
	end
	TLuaFuns:MsClick(iX+5, iY+5);
	TLuaFuns:MsSleep(1000);
	
	iX,iY,iRet = TLuaFuns:MsFindStringEx('��Ҫ֧���������Ѳ���', 'ffffff-000000');
	if (-1 ~= iX) and (-1 ~= iY) then
		local iBag = fnGetBagMoney(); --��ħ��ı������
		if iBag ~= -1 then
			TOrderInfo:SetReStock(math.floor(iBag/10000));
		end
		TLuaFuns:MsPostStatus('��Ҫ֧���������Ѳ���', tsFail, false);
		return 99;
	end
	
	if ATimes == 0 then	
		--�ⰲȫ
		iRet = fnQuitSafe();
		
		if iRet == 3 then
			if 0 == TLuaFuns:MsCheck() then
				return 0;
			end
		end
		
		if iRet == 2 then
			print('��Ҫ�ⰲȫ�����ҽⰲȫ�ɹ��ˣ��ٴε�����Ͱ�ť');  
			TLuaFuns:MsSleep(100);
			TLuaFuns:MsClick(iX+30, iY+185);
			TLuaFuns:MsSleep(100);
			TLuaFuns:MsClick(iX+30, iY+185);
		end	
	end
	
	--�жϸ�ħ�Ƿ�ɹ�
	local iEnchatRoleBagMoney_after = fnGetBagMoney(); --��ħ��ı������
	TOrderInfo:SetReStock(math.floor(iEnchatRoleBagMoney_after/10000));
	if (iEnchatRoleBagMoney_after > 0) and (iEnchatRoleBagMoney_after < iEnchatRoleBagMoney_before) then
		TLuaFuns:MsPostStatus('��ħ�ɹ���');		
		return 1;
	end
	
	TLuaFuns:MsPostStatus('��ħʧ�ܣ�', tsFail);
	return 0;
end

--��ħ�˺Ź���
function fnEnchantDoWork()
	local iRet = 0;
	local iStep = -1;
	local iTimes = 0;
	
	local sLastRecvRoleName = '';

	--����ħ��ɫ�������㸽ħ�����˳�
	if fnCheckEnchatRoleBagMoney() == 0 then return 0; end
	
	--�ߵ���ħ�ص�
	if fnWalkToStallPlace(255,302) == 0 then return 0; end
	
	while true do	
		::lblGetRecvRole::
		if TLuaFuns:MsCheck() == 0 then
			return 0;
		end

		iStep = TLuaFuns:MsGetRoleStep();
		if iStep == rsFinish then
			--�����ӽ�ɫ����ħ���
			TLuaFuns:MsPostStatus('��ħ���', tsSuccess, False);
			return 1;
		end
		if (GTargetRoleName == '') then
			GTargetRoleName = TLuaFuns:MsGetMasterRecRoleName(GRoleName);
		end

		if (GTargetRoleName == '') or (GTargetRoleName == '___Error___') or (GTargetRoleName == sLastRecvRoleName) then	
			GTargetRoleName = '';
			goto lblGetRecvRole;
		end	
		sLastRecvRoleName = '';
		--���û�ҵ�̯λ���ȴ�---------------------------------------------
		iStep = TLuaFuns:MsGetTargetRoleStep();
	
		if iStep ~= rsStallFinish then
			goto lblGetRecvRole;
		end

		--��ʼ��ħ
		local i = 1;
		iRet = 0;
		local bIsOk = true;
		while true do	
			if TLuaFuns:MsCheck() == 0 then				
				if TOrderInfo:GetTaskStop() == 1 then
					TLuaFuns:MsPostStatus('����Դ����������...', tsFail, false);
				end
				return 0;
			end
			if -1 == fnIsEnterTheGame(1) then 
				TLuaFuns:MsPostStatus('�����쳣�Ѿ����ߣ�', tsFail);
				return 0;
			end
		
			if bIsOk then
				TLuaFuns:MsCreateBmp(GTargetRoleName,'Target',179,179,179);
				iStep = TLuaFuns:MsGetTargetRoleStep();
	
				if iStep == rsTargetFail then
					TLuaFuns:MsPostStatus(string.format('�Է���ɫ[%s]���˳�', GTargetRoleName));	
					GTargetRoleName = '';
					TLuaFuns:MsClearRecvRoleName();
					GFeeX = -1;
					GFeeY = -1;
					break;
				end
				
				fnCloseMenu();
				TLuaFuns:MsPostStatus(string.format('��ʼ��[%s]���е�[%d]�θ�ħ...',GTargetRoleName, i));
				iRet = fnEnchant(iTimes);		
				fnCloseMenu();				
				TLuaFuns:MsPostStatus(string.format('������[%s]���е�[%d]�θ�ħ...',GTargetRoleName, i));
			end	

			if GTargetRoleName == '' then
				break;
			end
			
			if 1 == iRet then 
				if bIsOk then
					iTimes = iTimes + 1;
					bIsOk = false;
				end
				
				--��ħ���һ�Σ��ύһ��״̬				
				TLuaFuns:MsSetRoleStep(rsEnchatFinish);
				TLuaFuns:MsSleep(100);
				--�ж��Ӻ��յ����û��
				iStep = TLuaFuns:MsGetTargetRoleStep();
				if (iStep == rsTargetFail) or (iStep == rsRecMoneyFail) then
					TLuaFuns:MsPostStatus(string.format('�Ӻ�[%s]����ʧ�ܻ���δ�յ���ң�',GTargetRoleName));
					sLastRecvRoleName = GTargetRoleName;
					GTargetRoleName = '';
					TOrderInfo:ClearRecvRoleName();	
					TLuaFuns:MsClearRecvRoleName();
					GFeeX = -1;
					GFeeY = -1;
					break;
				end
				
				if (iStep == rsFinish) then
					--�ֲ����
					TLuaFuns:MsPostStatus(string.format('��[%s]�ֲ�������ɣ�',GTargetRoleName));
					TLuaFuns:MsResetRoleStep(rsNormal);
					sLastRecvRoleName = GTargetRoleName;
					GTargetRoleName = '';
					TOrderInfo:ClearRecvRoleName();	
					TLuaFuns:MsClearRecvRoleName();	
					GFeeX = -1;
					GFeeY = -1;
					break;
				end
				
				if iStep == rsRecMoneyOk then
					--����					
					TLuaFuns:MsResetRoleStep(rsStallFinish);
					bIsOk = true;
					i = i + 1;
				end
			elseif (99 == iRet) then
				return 0;
			end			
		end
	end
	return 0;
end

function fnDispatchMoney();
	local iRet = 0;
	fnCloseMenu();
	--[[
	if TLuaFuns:MsFindImg('CityFlag.bmp', 1.0, 3) == 0 then
		TLuaFuns:MsPostStatus('��ɫ����ָ������', tsFail, false);
		return 0;
	end
	--]]
	if (1 == TOrderInfo:GetIsMain()) then
		iRet = fnEnchantDoWork();
	else
		TLuaFuns:MsCreateBmp(GRoleName,'Self',255,255,255);
		iRet = fnStallDoWork();
	end
	return iRet;
end;

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

	if (0 == GTaskType) then
		print('��ʼ����');
		iRet = fnSendMail();
	else 
		print('��ʼ�ֲ�');
		iRet = fnDispatchMoney();
	end
	if (0 == iRet) then 
		return 0;
	end
	return 1;
end

fnDispatchOrder();
--[[
function Test()
	local hGame = 0;
	hGame = TLuaFuns:MsFindWindow('���³�����ʿ','���³�����ʿ');
	if TLuaFuns:MsIsWindow(hGame) == 0 then
		print('��Ϸû�д�');
		return 0;
	end
	TLuaFuns:MsSetGameHandle(hGame);	
	TLuaFuns:MsCheck();
	fnCloseMenu();
end

Test();
--]]

