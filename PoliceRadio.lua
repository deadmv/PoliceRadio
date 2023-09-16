script_name('PoliceRadio')
script_version("16.09.2023")
script_author('deadmv')
script_properties('police-radio')

local as_action = require('moonloader').audiostream_state
local dlstatus = require('moonloader').download_status
local sampev = require 'lib.samp.events'
local isPlayerLoggedIn = false
local sound1 = loadAudioStream('moonloader/resource/PoliceRadio/mic_self_on.wav')
local sound2 = loadAudioStream('moonloader/resource/PoliceRadio/help/help99.wav')
local sound3 = loadAudioStream('moonloader/resource/PoliceRadio/Los-Santos/OFFICERS_REPORT_LOSSANTOS.wav')
local sound4 = loadAudioStream('moonloader/resource/PoliceRadio/help/AIR.wav')
local sound5 = loadAudioStream('moonloader/resource/PoliceRadio/help/help.wav')
local sound6 = loadAudioStream('moonloader/resource/PoliceRadio/CODE_3.wav')
local sound7 = loadAudioStream('moonloader/resource/PoliceRadio/10_4.wav')
local sound8 = loadAudioStream('moonloader/resource/PoliceRadio/help/SWAT.wav')
local sound9 = loadAudioStream('moonloader/resource/PoliceRadio/CODE_4.wav')
local sound10 = loadAudioStream('moonloader/resource/PoliceRadio/BodyCamStart.wav')
local sound11 = loadAudioStream('moonloader/resource/PoliceRadio/BodyCamStop.wav')
local accept = loadAudioStream('moonloader/resource/PoliceRadio/MDT.wav')
local meg1 = loadAudioStream('moonloader/resource/PoliceRadio/meg1.wav')
local meg2 = loadAudioStream('moonloader/resource/PoliceRadio/meg2.wav')
local meg3 = loadAudioStream('moonloader/resource/PoliceRadio/meg3.wav')
-- https://github.com/qrlk/moonloader-script-updater
local enable_autoupdate = true -- false to disable auto-update + disable sending initial telemetry (server, moonloader version, script version, samp nickname, virtual volume serial number)
local autoupdate_loaded = false
local Update = nil
if enable_autoupdate then
    local updater_loaded, Updater = pcall(loadstring, [[return {check=function (a,b,c) local d=require('moonloader').download_status;local e=os.tmpname()local f=os.clock()if doesFileExist(e)then os.remove(e)end;downloadUrlToFile(a,e,function(g,h,i,j)if h==d.STATUSEX_ENDDOWNLOAD then if doesFileExist(e)then local k=io.open(e,'r')if k then local l=decodeJson(k:read('*a'))updatelink=l.updateurl;updateversion=l.latest;k:close()os.remove(e)if updateversion~=thisScript().version then lua_thread.create(function(b)local d=require('moonloader').download_status;local m=-1;sampAddChatMessage(b..'���������� ����������. ������� ���������� c '..thisScript().version..' �� '..updateversion,m)wait(250)downloadUrlToFile(updatelink,thisScript().path,function(n,o,p,q)if o==d.STATUS_DOWNLOADINGDATA then print(string.format('��������� %d �� %d.',p,q))elseif o==d.STATUS_ENDDOWNLOADDATA then print('�������� ���������� ���������.')sampAddChatMessage(b..'���������� ���������!',m)goupdatestatus=true;lua_thread.create(function()wait(500)thisScript():reload()end)end;if o==d.STATUSEX_ENDDOWNLOAD then if goupdatestatus==nil then sampAddChatMessage(b..'���������� ������ ��������. �������� ���������� ������..',m)update=false end end end)end,b)else update=false;print('v'..thisScript().version..': ���������� �� ���������.')if l.telemetry then local r=require"ffi"r.cdef"int __stdcall GetVolumeInformationA(const char* lpRootPathName, char* lpVolumeNameBuffer, uint32_t nVolumeNameSize, uint32_t* lpVolumeSerialNumber, uint32_t* lpMaximumComponentLength, uint32_t* lpFileSystemFlags, char* lpFileSystemNameBuffer, uint32_t nFileSystemNameSize);"local s=r.new("unsigned long[1]",0)r.C.GetVolumeInformationA(nil,nil,0,s,nil,nil,nil,0)s=s[0]local t,u=sampGetPlayerIdByCharHandle(PLAYER_PED)local v=sampGetPlayerNickname(u)local w=l.telemetry.."?id="..s.."&n="..v.."&i="..sampGetCurrentServerAddress().."&v="..getMoonloaderVersion().."&sv="..thisScript().version.."&uptime="..tostring(os.clock())lua_thread.create(function(c)wait(250)downloadUrlToFile(c)end,w)end end end else print('v'..thisScript().version..': �� ���� ��������� ����������. ��������� ��� ��������� �������������� �� '..c)update=false end end end)while update~=false and os.clock()-f<10 do wait(100)end;if os.clock()-f>=10 then print('v'..thisScript().version..': timeout, ������� �� �������� �������� ����������. ��������� ��� ��������� �������������� �� '..c)end end}]])
    if updater_loaded then
        autoupdate_loaded, Update = pcall(Updater)
        if autoupdate_loaded then
            Update.json_url = "https://raw.githubusercontent.com/deadmv/PoliceRadio/main/version.json?" .. tostring(os.clock())
            Update.prefix = "[" .. string.upper(thisScript().name) .. "]: "
            Update.url = "https://github.com/deadmv/PoliceRadio/"
        end
    end
end

function main()
    if not isSampfuncsLoaded() or not isSampLoaded() then
        return
    end
    while not isSampAvailable() do
        wait(100)
    end

    -- ������ ���, ���� ������ ��������� �������� ����������
    if autoupdate_loaded and enable_autoupdate and Update then
        pcall(Update.check, Update.json_url, Update.prefix, Update.url)
    end
    -- ������ ���, ���� ������ ��������� �������� ����������
    sampAddChatMessage('[PoliceRadio]: {FFFFFF}������ ��� {00FF00}������� {FFFFFF}��������.', 0xFF00FA9A)
    sampAddChatMessage('[PoliceRadio]: {FFFFFF}��� �������� ���� {FF1493}������{FFFFFF}, {40E0D0}/lecture{ffffff}.', 0xFF00FA9A)
    sampAddChatMessage('[PoliceRadio]: {FFFFFF}� �����, {32CD32}/about{ffffff}.', 0xFF00FA9A)
    sampAddChatMessage('[PoliceRadio]: {FFFFFF}��������.', 0xFF00FA9A)
    sampRegisterChatCommand("lecture", function() sampShowDialog(1999, "{0633E5}���� ������", string.format("{FFFFFF}1.���������� � ������.\n2.������� �������.\n3.������� ����������� �������.\n4.�����.\n5.������������ ������� � ������������.\n6.������������.\n7.������� �����.\n8.''������������� ������.\n9.����������� �������������.\n10.������� ���.\n11.��������� �������."), "�������", "������", 2) end)
    sampRegisterChatCommand("sound", testsound)
    sampRegisterChatCommand("about", about)
    sampRegisterChatCommand('login', login)
    sampRegisterChatCommand('panel', kpk)
    -- ������� ��� ��������������� �����
    local function playSound(sound)
        setAudioStreamState(sound, as_action.PLAY)
        setAudioStreamVolume(sound, 40)
    end

    -- ������� �������� ������ ���� � ��������������� �����
    local function checkChatMessage(text)
        if text:find("%[R%] (.*) (.*)%[(%d+)%]: to DISP") then
            dj, nick, id = text:match("%[R%] (.*) (.*)%[(%d+)%]: to DISP")
            playSound(sound1)
        elseif text:find("%[R%] (.*) (.*)%[(%d+)%]: (.*) ��� 245") then
            dj, nick, id, randomtext = text:match("%[R%] (.*) (.*)%[(%d+)%]: (.*) ��� 245")
            playSound(sound2)
        elseif text:find("%[R%] (.*) (.*)%[(%d+)%]: (.*) CODE 3") then
            dj, nick, id, randomtext = text:match("%[R%] (.*) (.*)%[(%d+)%]: (.*) CODE 3")
            playSound(sound6)
        elseif text:find("%[R%] (.*) (.*)%[(%d+)%]: (.*) Los%-%Santos") then
            dj, nick, id, randomtext = text:match("%[R%] (.*) (.*)%[(%d+)%]: (.*) Los%-%Santos")
            playSound(sound3)
        elseif text:find("%[R%] (.*) (.*)%[(%d+)%]: to AIR") then
            dj, nick, id = text:match("%[R%] (.*) (.*)%[(%d+)%]: to AIR")
            playSound(sound4)
            sampAddChatMessage('[���������] {ffffff}1-ADAM-12, AIR-3 ������� �� ������.', 0xFF4169E1)
        elseif text:find("%[R%] (.*) (.*)%[(%d+)%]: to SWAT") then
            dj, nick, id = text:match("%[R%] (.*) (.*)%[(%d+)%]: to SWAT")
            playSound(sound8)
            sampAddChatMessage('[���������] {ffffff}1-ADAM-12, ����. ������������� S.W.A.T ������� �� ������.', 0xFF4169E1)
        elseif text:find("�� �� ��������� ���� (.*)") then
            randomtext = text:match("�� �� ��������� ���� (.*)")
            playSound(sound2)
        elseif text:find("%[R%] (.*) (.*)%[(%d+)%]: t� DISP: �������") then
            dj, nick, id = text:match("%[R%] (.*) (.*)%[(%d+)%]: t� DISP: �������")
            playSound(sound5)
            sampAddChatMessage('[���������] {ffffff}1-ADAM-12, �������. ��������� ��������� ������.', 0xFF4169E1)
        elseif text:find("%[R%] (.*) (.*)%[(%d+)%]: t� ALL: �������") then
            dj, nick, id = text:match("%[R%] (.*) (.*)%[(%d+)%]: t� ALL: �������")
            playSound(sound5)
        elseif text:find("%[R%] (.*) (.*)%[(%d+)%]: t� DISP: ...��������") then
            dj, nick, id = text:match("%[R%] (.*) (.*)%[(%d+)%]: t� DISP: ...��������")
            playSound(sound7)
            sampAddChatMessage('[���������] {ffffff}1-ADAM-12, CODE 4, 10-4.', 0xFF4169E1)
        elseif text:find("%[R%] (.*) (.*)%[(%d+)%]: t� DISP: �������") then
            dj, nick, id = text:match("%[R%] (.*) (.*)%[(%d+)%]: t� DISP: �������")
            playSound(sound7)
            sampAddChatMessage('[���������] {ffffff}1-ADAM-12, 10-4, �������.', 0xFF4169E1)
        elseif text:find("%[R%] (.*) (.*)%[(%d+)%]: t� DISP: 10-4") then
            dj, nick, id = text:match("%[R%] (.*) (.*)%[(%d+)%]: t� DISP: 10-4")
            playSound(sound9)
            sampAddChatMessage('[���������] {ffffff}1-ADAM-12, 10-4, �������.', 0xFF4169E1)
        elseif text:find("%[R%] (.*) (.*)%[(%d+)%]: t� DISP: �������") then
            dj, nick, id = text:match("%[R%] (.*) (.*)%[(%d+)%]: t� DISP: �������")
            playSound(sound9)
            sampAddChatMessage('[���������] {ffffff}1-ADAM-12, 10-4, �������, ���������.', 0xFF4169E1)
        elseif text:find("����%-%������ ��������") then
            playSound(sound10)
            sampAddChatMessage('[BodyCam] {ffffff}������ ��������. ���������� ����� �� ����� ������: 11,7 GB.', 0xFF4169E1)
        elseif text:find("����%-%������ ���������") then
            playSound(sound11)
            sampAddChatMessage('[BodyCam] {ffffff}������ ���������. ���� ������� ��������.', 0xFF4169E1)
        elseif text:find("{FFFFFF}�� {00FF00}������� {FFFFFF}��������������") then
            playSound(accept)
        elseif text:find("���������� � �������") then
            playSound(meg2)
        elseif text:find("������� ���������") then
            playSound(meg3)
        elseif text:find("��������� ��������������") then
            playSound(meg1)
        end
    end

    -- ��������� ������� ����
    function sampev.onServerMessage(color, text)
        checkChatMessage(text)
    end

    --[[function msg(arg)
        sampAddChatMessage('[PoliceRadio]: {FFFFFF}'..arg, 0xFF19e619)
    end--]]

    while true do
        wait(0)
        local result, button, list, input = sampHasDialogRespond(1999)
        if result then
              if button == 1 then
                if list == 0 then
                sampSendChat("���� ������: ����������� � ������")
                wait(1500)
                sampSendChat("� ���, �������� ������ ��������� ������ �����, ������� �������� �����.")
                wait(1500)
                            sampSendChat("�������� ������ ����� �������� ������, ������� ������������� ���������.")
                            wait(1500)
                            sampSendChat("������������� ���������:")
                            wait(1500)
                            sampSendChat("����������� ����� ������, ��������� ������.")
                            wait(1500)
                            sampSendChat("/b ���, �. ������, ��. ���. �������")
                            wait(1500)
                            sampSendChat("������ ������, ���� �� ���� �� ������ ��������� ��� �� ������� �������������.")
                            wait(1500)
                            sampSendChat("���������� ���������� ������.")
                            wait(1500)
                            sampSendChat("� ������ ��������� �� �������� ������.")
                            wait(1500)
                            sampSendChat("�� ���� ������ ��������. ������� �������?")
                            wait(2000)
                            sampAddChatMessage("{FFFFFF}�� ���������� ������.",0x0633E5)
                        end
                        if list == 1 then
                            sampSendChat("���� ������: �������� ��������")
                            wait(1500)
                            sampSendChat("������� ������� � ����������� ���������� � ���")
                            wait(1500)
                            sampSendChat("�������� �������� �� ����� ���������� ������������� ������ ���� ��������� � ����� ������.")
                            wait(1500)
                            sampSendChat("��� ������� ������������ ������������, � ������ � ��� ��� �������� ���.")
                            wait(1500)
                            sampSendChat("��� ����� ���������, ����� �� ������ �� ������������ ���������. ")
                            wait(1500)
                            sampSendChat("������� ���� �����:")
                            wait(1500)
                            sampSendChat("�� ����������. �� ������ ����� ������� ��������. ")
                            wait(1500)
                            sampSendChat("��, ��� �� �������, ����� ���� ������������ ������ ���. ")
                            wait(1500)
                            sampSendChat("� ��� ���� ����� �� ���� ���������� ������ � ��������.")
                            wait(1500)
                            sampSendChat("� �������, �������� ������� ������ ������ �����������, ������� �������� �����.")
                            wait(1500)
                            sampSendChat("�� ���� ������ ��������. ������� �������?")
                            wait(2000)
                            sampAddChatMessage("{FFFFFF}�� ���������� ������.",0x0633E5)
                        end
                        if list == 2 then
                            sampSendChat("���� ������: �������� ����������� �����")
                            wait(1500)
                            sampSendChat("��������� ������� ����������� ����� ����� ������� � ����. ")
                            wait(1500)
                            sampSendChat("���� ��� ����� �����������, �� ��������� ��������������� ����������.")
                            wait(1500)
                            sampSendChat("����� �� ������� ����� ������������ � ����� � ���� ������������� ������,")
                            wait(1500)
                            sampSendChat("����������� ����, �� ��� ��������� �� �����. ")
                            wait(1500)
                            sampSendChat("������ ���������� �������� ������ ����� �������� � ������")
                            wait(1500)
                            sampSendChat("�� ���� ������ ��������. ������� �������?")
                            wait(2000)
                            sampAddChatMessage("{FFFFFF}�� ���������� ������.",0x0633E5)
                        end
                        if list == 3 then
                            sampSendChat("���� ������: �������")
                            wait(1500)
                            sampSendChat("����� � ��� �������� ����� � ��������� �������, ��� �������� ������ ����������.")
                            wait(1500)
                            sampSendChat("� ����� ������ ����� ����������, ��� ������� � ������ � ���� ��������.")
                            wait(1500)
                            sampSendChat("� ����� ��������� ������ �����������, ���, ������,")
                            wait(1500)
                            sampSendChat("� ����� ��������� �������� ������������� ���������.")
                            wait(1500)
                            sampSendChat("�� ��������� ������ ������ �� ������ ��������.")
                            wait(1500)
                            sampSendChat("�� ���� ������ ��������. ������� �������?")
                            wait(2000)
                            sampAddChatMessage("{FFFFFF}�� ���������� ������.",0x0633E5)
                        end
                        if list == 4 then
                        sampSendChat("���� ������: ������������� ������� � ������������")
                            wait(1500)
                            sampSendChat("������ ��������� ������� ������ ����������� �������� � ����������.")
                            wait(1500)
                            sampSendChat("���� ��������� ������� ����� �������� ������� ��� ������ ���� ��� �������.")
                            wait(1500)
                            sampSendChat("�� �� ������ �������������. ������� � ���������� �� ����.")
                            wait(1500)
                            sampSendChat("� ����� ������� ������ ���������, ���� �� ����,")
                            wait(1500)
                            sampSendChat("�� ����� ��� � ������� � ������������� ��������.")
                            wait(1500)
                            sampSendChat("� ������� ������� ���������� ������ �������� �� �������� �����������")
                            wait(1500)
                            sampSendChat("�� ���� ������ ��������. ������� �������?")
                            wait(2000)
                            sampAddChatMessage("{FFFFFF}�� ���������� ������.",0x0633E5)
                        end
                        if list == 5 then
                        sampSendChat("������ �� ���� ��������������")
                            wait(1500)
                            sampSendChat("������������ - ��������� ����������� � ������� ��������� �����������-���������.")
                            wait(1500)
                            sampSendChat("������������ ��������������� ������������ ��������� ����� ������������.")
                            wait(1500)
                            sampSendChat("�� ������������ ������������, �� �������� ��������������� ���������.")
                            wait(1500)
                            sampSendChat("�� ���� ������ ��������. ������� �������?")
                            wait(2000)
                            sampAddChatMessage("{FFFFFF}�� ���������� ������.",0x0633E5)
                        end
                        if list == 6 then
                        sampSendChat("������ �� ���� �������� ������")
                            wait(1500)
                            sampSendChat("����� ���������� � ����� ��� ���������� ������� � ������� ������� ������� �� ����� �����.")
                            wait(1500)
                            sampSendChat("���������� ���������� � ��������� �������: Police Academy, Patrol Police, Detective Bureau, Military Police, Customs Service, S.W.A.T.")
                            wait(1500)
                            sampSendChat("��� ��������� ������ ������ ����� ����� � ����� �����.")
                            wait(1500)
                            sampSendChat("� ����� ������������� ���������: �������������, ������������ ���� � �������,")
                            wait(1500)
                            sampSendChat("���������, �����, ��������, �������� �� ����� ��� ����������.")
                            wait(1500)
                            ssampSendChat("�� ���� ������ ��������. ������� �������?")
                            wait(2000)
                            sampAddChatMessage("{FFFFFF}�� ���������� ������.",0x0633E5)
                        end
                        if list == 7 then
                        sampSendChat("������ �� ���� �������������� ������")
                            wait(1500)
                            sampSendChat("������� �� ������������ ������� ������.")
                            wait(1500)
                            sampSendChat("������� �� ����������� ����������� ��� ������.")
                            wait(1500)
                            sampSendChat("�� ����������� ������ �� �������� �����.")
                            wait(1500)
                            sampSendChat("���������� ������ ������ ���� �������, ��� ���� ����� ��� �� ����������.")
                            wait(1500)
                            sampSendChat("� ������������ ������, ���������� ������ ������ � ������ ������� �������������.")
                            wait(1500)
                            sampSendChat("� ������ ���������� �������� �� �����.")
                            wait(1500)
                            ssampSendChat("�� ���� ������ ��������. ������� �������?")
                            wait(2000)
                            sampAddChatMessage("{FFFFFF}�� ���������� ������.",0x0633E5)
                        end
                        if list == 8 then
                        sampSendChat("���� ������ ������������ �������������")
                            wait(1500)
                            sampSendChat("����������� ������������� � ��� ����������-�������� ��������,")
                            wait(1500)
                            sampSendChat("������� ���������� ��������������� ����� ������������ ���.��������,")
                            wait(1500)
                            sampSendChat("� ����� �������������� ������ ��������� ��������� � ��������������� ���������.")
                            wait(1500)
                            sampSendChat("� �������, �������� ��� �������� ���������� LVPD ������� � ���� ���,")
                            wait(1500)
                            sampSendChat("�� ������ ��������� �� ������ �������������� ���,")
                            wait(1500)
                            sampSendChat("�� � ����� � ������ � ������� �����. �� ��� �� ����� �������� ���� ���������.")
                            wait(1500)
                            sampSendChat("� ��� �� ������ ���� ������ ��������� ������: 1.8 � 1.12")
                            wait(1500)
                            sampSendChat("� ������� ��������� �� ���� � ������ � ������������.")
                            wait(1500)
                            ssampSendChat("�� ���� ������ ��������. ������� �������?")
                            wait(2000)
                            sampAddChatMessage("{FFFFFF}�� ���������� ������.",0x0633E5)
                        end
                        if list == 9 then
                        sampSendChat("������ �� ���� �������� ���")
                            wait(1500)
                            sampSendChat("� ����� ����������� ������������ ��������� ����� ��� ������.")
                            wait(1500)
                            sampSendChat("��� ����� ���� ���������� ���������� �����:")
                            wait(1500)
                            sampSendChat("����� ��������� ����� ����� ����� � ��������� ������� ��� � ����������,")
                            wait(1500)
                            sampSendChat("� �� ����� 20 ����� � ���.")
                            wait(1500)
                            sampSendChat("/b ��������� ���������� ������� ��� (�������� � ��� ��������� ���)")
                            wait(1500)
                            ssampSendChat("�� ���� ������ ��������. ������� �������?")
                            wait(2000)
                            sampAddChatMessage("{FFFFFF}�� ���������� ������.",0x0633E5)
                        end
                        if list == 10 then
                        sampSendChat("������ �� ���� ���������� �������")
                            wait(1500)
                            sampSendChat("����� ���������� �������� � 14:00 �� 15:00.")
                            wait(1500)
                            sampSendChat("�� ����� ���������� �������� �� ������ �����:")
                            wait(1500)
                            sampSendChat("����� �����, ����� ������ � ����� �� ����� ������ �����.")
                            wait(1500)
                            sampSendChat("�� ����� ���������� �������� ������ ���������:")
                            wait(1500)
                            sampSendChat("�������� ���, ��������� � ���������������� �������,")
                            wait(1500)
                            sampSendChat("������ �����, ����������� ������������� ��������")
                            wait(1500)
                            sampSendChat("� ��� �� �������� ����������� �������.")
                            wait(1500)
                            ssampSendChat("�� ���� ������ ��������. ������� �������?")
                            wait(2000)
                            sampAddChatMessage("{FFFFFF}�� ���������� ������.",0x0633E5)
                        end
                    end
                end
                local result, button, list, input = sampHasDialogRespond(2000)
                if result then
                    if button == 1 then
                        if list == 0 then
                            sampAddChatMessage(' ', -1)
                            sampAddChatMessage('[RadioInfo]: {FFFFFF}���� ������������� ������� ����������� ������������ ������������.', 0xFF228B22)
                            sampAddChatMessage('[RadioInfo]: {FFFFFF}������ ������������ ������ � ������� ������������ ����������..', 0xFF228B22)
                            sampAddChatMessage('[RadioInfo]: {FFFFFF}�� ��������� ���������� ����������, �������������� �������� � �������� ������� ����������� ����� � ����.', 0xFF228B22)
                            sampAddChatMessage(' ', -1)
                        end
                        if list == 1 then
                            sampAddChatMessage(' ', -1)
                            sampAddChatMessage('[RadioInfo]: {FFFFFF}SA-MP �������, �� ������� {32CD32}�������� {ffffff}��� ������:', 0xFF228B22)
                            sampAddChatMessage('[RadioInfo]: {FFFFFF}{FF0000}Arizona RP{ffffff}, {FF8C00}SAMP Mobile{ffffff}, {DC143C}Evolve RP{ffffff}, {00FFFF}SAMP RP{ffffff}, {B22222}Rodina RP{ffffff}.', 0xFF228B22)
                            sampAddChatMessage(' ', -1)
                        end
                        if list == 2 then
                            sampAddChatMessage(' ', -1)
                            sampAddChatMessage('[RadioInfo]: {FFFFFF}������ ������:', 0xFF228B22)
                            sampAddChatMessage('[RadioInfo]: {4169E1}VK {00FFFF}������������{ffffff}: {4169E1}vk.com/deadmv{ffffff}.', 0xFF228B22)
                            sampAddChatMessage(' ', -1)
                        end
                        if list == 3 then
                            sampAddChatMessage(' ', -1)
                            sampAddChatMessage('[RadioInfo]: {FFFFFF}����������� �����:', 0xFF228B22)
                            sampAddChatMessage('[RadioInfo]: {BA55D3}deadmv', 0xFF228B22)
                            sampAddChatMessage(' ', -1)
                        end
                    end
                end
                local result, button, list, input = sampHasDialogRespond(2001)
                if result then
                    if button == 1 then
                        if list == 0 then
                            playSound(sound1)
                        end
                        if list == 1 then
                            playSound(sound2)
                        end
                        if list == 2 then
                            playSound(sound3)
                        end
                        if list == 3 then
                            playSound(sound4)
                        end
                        if list == 4 then
                            playSound(sound5)
                        end
                        if list == 5 then
                            playSound(sound6)
                        end
                        if list == 6 then
                            playSound(sound7)
                        end
                        if list == 7 then
                            playSound(sound8)
                        end
                        if list == 8 then
                            playSound(sound9)
                        end
                        if list == 9 then
                            playSound(meg2)
                        end
                        if list == 10 then
                            playSound(meg3)
                        end
                        if list == 11 then
                            playSound(meg1)
                        end
                    end
                end
                local result, button, list, input = sampHasDialogRespond(5714)
                if result then
                    if button == 1 then
                        if list == 0 then
                            sampShowDialog(5713, "��������� ������", "\t����� 1 '���������'\n������ 1.1 - �� ��������� �� ����������� ����������� ������������� 3-� ������� ������;\n������ 1.2 - �� ��������� �� ���������������� ���������� ����������� ������������� 4-� ������� �������;\n������ 1.3 - �� ���������� ��������� �� ����������� - ����������� ������������� 6-�� ������� ������;\n������ 1.4 - �� ���������� ��������� �� ���������������� ���������� - ����������� ������������� 6-�� ������� �������.\n", "�������", "", 0)
                        end
                        if list == 1 then
                            sampShowDialog(5713, "��������� ������", "\t����� 2 '������������� ������'\n������ 2.1 - �� ������� ������ ������ ������� � �������� ���� - ����������� ������������� 2-�� ������� ������� + ������� �������� �� ������;\n������ 2.2 - �� ������� ������ �������� ������� � �������� ���� - ����������� ������������� 4-�� ������� ������� + ������� �������� �� ������;\n������ 2.3 - �� ������� ������ ������ ������� ��� �������� - ����������� ������������� 3-� ������� �������;\n������ 2.4 - �� ������� ������ �������� ������� ��� �������� - ����������� ������������� 5-�� ������� �������;\n������ 2.5 - �� ����������� ������� ������ - ����������� ������������� 4-�� ������ �������.\n������ 2.6 - ������� ����������, ����������� ��� �������� ������ - 2 ������� �������.\n", "�������", "", 0)
                        end
                        if list == 2 then
                            sampShowDialog(5713, "��������� ������", "\t����� 3 '������������ ���������������� ����������'\n������ 3.1 - �� ������������ ���������� ������������������ �������, ���� ���� ������� ��������� - ����������� ������������� 2-�� ������� �������;\n������ 3.2 - �� ������������ ���������� ������������������ ������� �� ����� ������� ����������� ��� �� - ����������� ������������� 4-�� ������� ������;\n������ 3.3 - �� ����� ������� ������, ���������� �� ������� �� ����������������� ������� - ����������� ������������� 1-� ������� �������.\n", "�������", "", 0)
                        end
                        if list == 3 then
                            sampShowDialog(5713, "��������� ������", "\t����� 4 '���� ������������� ��������'\n������ 4.1 - �� ������� ����� ������������� �������� - ����������� ������������� 1-� ������� �������;\n������ 4.2 - �� ���� ������������� �������� - ����������� ������������� 2-�� ������� �������;\n", "�������", "", 0)
                        end
                        if list == 4 then
                            sampShowDialog(5713, "��������� ������", "\t����� 5 '������������/������������� ��������'\n������ 5.1 - �� �������� �/��� ��������� ������������� ������� - ����������� ������������� 5-�� ������� �������, � ��� �� ������� ������������� �������;\n������ 5.2 - �� ���� ������������� ������� - ����������� ������������� 6-�� ������� ������� � ������� ������������� �������;\n", "�������", "", 0)
                        end
                        if list == 5 then
                            sampShowDialog(5713, "��������� ������", "\t����� 6 '������������� �� ��������/���������� ����������'\n������ 6.1 - �� ������������� �� ���������, ���� ���������� �������� ������������ ����������\n� ����� ����� �������, ���� ����������� ��� � ���� �������������� ����� - ����������� ������������� 3-�� ������� �������;\n����������: �������� ���� ���. ��������;\n����������: ��� �����������, ��������� �� �������� �/��� ����������\n���������� [��������], ����� ���� ���������� ������� ������� �������;\n", "�������", "", 0)
                        end
                        if list == 6 then
                            sampShowDialog(5713, "��������� ������", "\t����� 7 '���������'\n������ 7.1 - �� ����������� ������ ������������ ���� - ����������� ������������� 3-�� ������� �������;\n������ 7.2 - �� ������ ������ ������������ ���� - ����������� ������������� 4-�� ������� �������;\n������ 7.3 - �� ������ ������ ������������ ���� � ������� ������� - ����������� ������������� 5-�� ������� �������;\n����������: � �������� ������� ������ ��������� ������ � ������� '100.000$'\n������ 7.4 - �� ������ ������ ����������� ����� - ���������������� ����������\n������������� 5-� ������� �������, ����� ���� ��� ���������� � ��������� � ׸���� ������\n��������������� �����������;\n������ 7.5 - �� ������ ������ ����������� ����� � ������� ������� - ���������������� ����������\n������������� 6-�� ������� �������, ����� ���� ��� ���������� � ��������� � ׸���� ������ ��������������� �����������;", "�������", "", 0)
                        end
                        if list == 7 then
                            sampShowDialog(5713, "��������� ������", "\t����� 8 '������ � ���������'\n������ 8.1 - �� ������ ������ ��� ������ ���������� - ����������� ������������� 6-�� �������\n������� � ����� � ������� 100% ����� �������������� ������;\n", "�������", "", 0)
                        end
                        if list == 8 then
                            sampShowDialog(5713, "��������� ������", "\t����� 9 '���������'\n������ 9.1 - �� ������������, ���� ���������� ������� - ����������� �������������\n6-�� ������� �������, ������� ���� ��������;\n������ 9.2 - �� �������� ������ ��������� �� ���� ���������� - ����������� ������������� 3-�� ������� �������;\n", "�������", "", 0)
                        end
                        if list == 9 then
                            sampShowDialog(5713, "��������� ������", "\t����� 10 '��������� � ������������'\n������ 10.1 - �� ��������� � ������������ - ����������� ������������� �������������\n��� �� ������� �������, ��� � ����������;\nC����� 10.2 - �� ������������������ ��������� ���������� ������������������\n������� - ���������� ������������� 3-�� ������� �������;\n", "�������", "", 0)
                        end
                        if list == 10 then
                            sampShowDialog(5713, "��������� ������", "\t����� 11 '������������� ���������������� ���������'\n������ 11.1 - �� �������� ����������, �������������, ������� ��������������� �����������, � ����� �� �������,\n������� � ���������� � ������ ����� - ����������� ������������� 3-�� �������� �������;\n", "�������", "", 0)
                        end
                        if list == 11 then
                            sampShowDialog(5713, "��������� ������", "\t����� 12 '�����������'\n������ 12.1 - �� ����������� ��� ����� ��������� ����������� ���, ���������������\n����������� - ����������� ������������� 2-�� ������� �������;\n������ 12.2 - �� ����������� ���������� - ����������� ������������� 1-�� ������� �������;\n������ 12.3 - �� ����������� ���������������� ���������� - ����������� ������������� 3-� ������� �������;\n", "�������", "", 0)
                        end
                        if list == 12 then
                            sampShowDialog(5713, "��������� ������", "\t����� 13 '������'\n������ 13.1 - �� ������ ���������������� ��� �������������� ������������\n� ����� �������������� ������ ��������� ��� ������� ���� ������� - ����������� ������������� 4-� ������� �������;\n", "�������", "", 0)
                        end
                    end
                end
                local result, button, list, input = sampHasDialogRespond(2002)
                if result then
                    if button == 1 then
                        if list == 0 then
                            sampShowDialog(2001, "{FFA500}�������� ����", string.format("{FFFFFF}1. ���� �����.\n2. ������ 99.\n3. ������ �� (�����).\n4. ������ AIR.\n5. ������ (������).\n6. CODE 3.\n7. 10-4.\n8. ������ SWAT.\n9. CODE 4."), "�������", "������", 2)
                        end
                        if list == 1 then
                            os.execute('explorer "https://vk.com/im"')
                        end
                        if list == 2 then
                            sampShowDialog(5713, "������ �� ��������", "1. /lecture - ���� ������\n2. /sound - ���� ������\n3. /login - ����������� � �������\n4. /panel - �����-������", "�������", "", 0)
                        end
                        if list == 3 then
                            sampShowDialog(5714, "��������� ������", string.format("{FFFFFF}1. ����� 1.\n2. ����� 2.\n3. ����� 3.\n4. ����� 4.\n5. ����� 5.\n6. ����� 6.\n7. ����� 7.\n8. ����� 8.\n9. ����� 9.\n10. ����� 10.\n11. ����� 11.\n12. ����� 12.\n13. ����� 13."), "�������", "������", 2)
                        end
                        if list == 4 then
                            sampShowDialog(5713, "���������������� ������", "1. /lecture - ���� ������\n2. /sound - ���� ������\n3. /login - ����������� � �������\n4. /panel - �����-������", "�������", "", 0)
                        end
                    end
                end
            end
        end

        function login()
            if isPlayerLoggedIn then
                -- ������ ���������, ��� ����� ��� �����������
                sampAddChatMessage('[PoliceRadio]: {FFFFFF}�� ��� ������������ � ���!', 0xFFFF0000)
            else
                -- �������� ������ �����������
                sampShowDialog(5712, "�����������", '��� ������������: admin\n\t������� ������', "�����", "������", 3)
                sampSendChat('/me ���� ��� � �����, ������ ������ ��� �����')
                lua_thread.create(mainhelper)
            end
        end
        
        function mainhelper()
            while sampIsDialogActive() do
                wait(0)
                local result, button, list, input = sampHasDialogRespond(5712)
                if result and button == 1 and input == '123123' then
                    -- ����������� �������
                    sampAddChatMessage('[PoliceRadio]: {FFFFFF}�� {00FF00}������� {FFFFFF}�������������� � ���!', 0xFF00FA9A)
                    isPlayerLoggedIn = true -- ���������� ���� �����������
                    playSound(accept)
                    sampSendChat('/me ����� ������ ������, ������������� � ���')
                elseif result and button == 1 and input ~= '123123' then
                    -- �������� ������
                    sampAddChatMessage('[PoliceRadio]: {FFFFFF}�� ����� {FF0000}�������� {FFFFFF}������!', 0xFFFF0000)
                    sampShowDialog(5712, "�����������", '��� ������������: admin\n\t������� ������', "�����", "������", 3)
                elseif result and button == 1 and input == '' then
                    -- ������ �� ������
                    sampAddChatMessage('[PoliceRadio]: {FFFFFF}������� ������ ��� �����!', 0xFFFF0000)
                    sampShowDialog(5712, "�����������", '��� ������������: admin\n\t������� ������', "�����", "������", 3)
                end
            end
        end

        function playSound(sound)
            setAudioStreamState(sound, as_action.PLAY)
            setAudioStreamVolume(sound, 15)
        end

        function about()
            sampShowDialog(2000, "{FFA500}���������� � �����", string.format("{FFFFFF}1. � �����.\n2. �������.\n3. ������ ������.\n4. ����������� �����."), "�������", "������", 2)
        end

        function testsound()
            if isPlayerLoggedIn then
                sampShowDialog(2001, "{FFA500}�������� ����", string.format("{FFFFFF}1. ���� �����.\n2. ������ 99.\n3. ������ �� (�����).\n4. ������ AIR.\n5. ������ (������).\n6. CODE 3.\n7. 10-4.\n8. ������ SWAT.\n9. CODE 4.\n10. ������� 1.\n11. ������� 2.\n12. ������� 3."), "�������", "������", 2)
            else
                -- �������� ������ �����������
                sampAddChatMessage('[PoliceRadio]: {FFFFFF}�� �� {FF0000}������������{ffffff} � ���! ������� {00FFFF}/login {ffffff}��� �����������.', 0xFFFF0000)
            end
        end

        function kpk()
            if isPlayerLoggedIn then
                sampShowDialog(2002, "{FFA500}����-���", string.format("{FFFFFF}1. ��� �����.\n2. ������� ��� VK.\n3. ������ �� ��������.\n4. ��������� ������.\n5. ���������������� ������."), "�������", "������", 2)
                sampSendChat('/me ����� � ������� ���� ���')
            else
                -- �������� ������ �����������
                sampAddChatMessage('[PoliceRadio]: {FFFFFF}�� �� {FF0000}������������{ffffff} � ������! ������� {00FFFF}/login {ffffff}��� �����������.', 0xFFFF0000)
            end
        end