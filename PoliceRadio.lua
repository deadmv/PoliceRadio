script_name('PoliceRadio')
script_author('deadmv')
script_properties('police-radio')

local as_action = require('moonloader').audiostream_state
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

function main()
    repeat wait(0) until isSampAvailable()
    sampAddChatMessage('[PoliceRadio]: {FFFFFF}������ ��� {00FF00}������� {FFFFFF}��������.', 0xFF00FA9A)
    sampAddChatMessage('[PoliceRadio]: {FFFFFF}��� �������� ���� {FF1493}������{FFFFFF}, {40E0D0}/lecture{ffffff}.', 0xFF00FA9A)
    sampAddChatMessage('[PoliceRadio]: {FFFFFF}� �����, {32CD32}/about{ffffff}.', 0xFF00FA9A)
    sampRegisterChatCommand("lecture", function() sampShowDialog(1999, "{0633E5}���� ������", string.format("{FFFFFF}1.���������� � ������.\n2.������� �������.\n3.������� ����������� �������.\n4.�����.\n5.������������ ������� � ������������.\n6.������������.\n7.������� �����.\n8.''������������� ������.\n9.����������� �������������.\n10.������� ���.\n11.��������� �������."), "�������", "������", 2) end)
    sampRegisterChatCommand("testsound", testsound)
    sampRegisterChatCommand("about", about)
    sampRegisterChatCommand('login', login)
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
        elseif text:find("%[R%] (.*) (.*)%[(%d+)%]: (.*) CODE 1") then
            dj, nick, id, randomtext = text:match("%[R%] (.*) (.*)%[(%d+)%]: (.*) CODE 1")
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
                    end
                end
            end
        end
        function login()
            if isPlayerLoggedIn then
                -- ������ ���������, ��� ����� ��� �����������
                sampAddChatMessage('[PoliceRadio]: {FFFFFF}�� ��� ������������ � �����-������!', 0xFFFF0000)
            else
                -- �������� ������ �����������
                sampShowDialog(5712, "�����������", "������� ������", "�����", "������", 3)
                lua_thread.create(mainhelper)
            end
        end
        
        function mainhelper()
            while sampIsDialogActive() do
                wait(0)
                local result, button, list, input = sampHasDialogRespond(5712)
                if result and button == 1 and input == '123123' then
                    -- ����������� �������
                    sampAddChatMessage('[PoliceRadio]: {FFFFFF}�� {00FF00}������� {FFFFFF}��������������!', 0xFF00FA9A)
                    isPlayerLoggedIn = true -- ���������� ���� �����������
                    playSound(accept)
                elseif result and button == 1 and input ~= '123123' then
                    -- �������� ������
                    sampAddChatMessage('[PoliceRadio]: {FFFFFF}�� ����� {FF0000}�������� {FFFFFF}������!', 0xFFFF0000)
                    sampShowDialog(5712, "�����������", "������� ������", "�����", "������", 3)
                elseif result and button == 1 and input == '' then
                    -- ������ �� ������
                    sampAddChatMessage('[PoliceRadio]: {FFFFFF}������� ������ ��� �����!', 0xFFFF0000)
                    sampShowDialog(5712, "�����������", "������� ������", "�����", "������", 3)
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
                sampShowDialog(2001, "{FFA500}�������� ����", string.format("{FFFFFF}1. ���� �����.\n2. ������ 99.\n3. ������ �� (�����).\n4. ������ AIR.\n5. ������ (������).\n6. CODE 3.\n7. 10-4.\n8. ������ SWAT.\n9. CODE 4."), "�������", "������", 2)
            else
                -- �������� ������ �����������
                sampAddChatMessage('[PoliceRadio]: {FFFFFF}�� �� {FF0000}������������{ffffff} � �����-������! ������� {00FFFF}/login {ffffff}��� �����������.', 0xFFFF0000)
            end
        end