script_name('PoliceRadio')
script_version("2.2")
script_author('qsliwq')
script_properties('police-radio')

local as_action = require('moonloader').audiostream_state
local dlstatus = require('moonloader').download_status
local sampev = require 'lib.samp.events'
local memory = require 'memory'
local isPlayerLoggedIn = false
local lanes = require('lanes').configure()
local ffi = require('ffi')
local sound1 = loadAudioStream('moonloader/PoliceRadio/audio/mic_self_on.wav')
local sound2 = loadAudioStream('moonloader/PoliceRadio/audio/help/help99.wav')
local sound3 = loadAudioStream('moonloader/PoliceRadio/audio/Los-Santos/OFFICERS_REPORT_LOSSANTOS.wav')
local sound4 = loadAudioStream('moonloader/PoliceRadio/audio/help/AIR.wav')
local sound5 = loadAudioStream('moonloader/PoliceRadio/audio/help/help.wav')
local sound6 = loadAudioStream('moonloader/PoliceRadio/audio/CODE_3.wav')
local sound7 = loadAudioStream('moonloader/PoliceRadio/audio/10_4.wav')
local sound8 = loadAudioStream('moonloader/PoliceRadio/audio/help/SWAT.wav')
local sound9 = loadAudioStream('moonloader/PoliceRadio/audio/CODE_4.wav')
local sound10 = loadAudioStream('moonloader/PoliceRadio/audio/BodyCamStart.wav')
local sound11 = loadAudioStream('moonloader/PoliceRadio/audio/BodyCamStop.wav')
local accept = loadAudioStream('moonloader/PoliceRadio/audio/MDT.wav')
local meg1 = loadAudioStream('moonloader/PoliceRadio/audio/meg1.wav')
local meg2 = loadAudioStream('moonloader/PoliceRadio/audio/meg2.wav')
local meg3 = loadAudioStream('moonloader/PoliceRadio/audio/meg3.wav')
local crime1 = loadAudioStream('moonloader/PoliceRadio/audio/crime/CRIME_1.wav')
local crime2 = loadAudioStream('moonloader/PoliceRadio/audio/crime/CRIME_2.wav')
local crime3 = loadAudioStream('moonloader/PoliceRadio/audio/crime/CRIME_3.wav')
local crime4 = loadAudioStream('moonloader/PoliceRadio/audio/crime/CRIME_4.wav')
local crime5 = loadAudioStream('moonloader/PoliceRadio/audio/crime/CRIME_5.wav')
-- https://github.com/qrlk/moonloader-script-updater
local enable_autoupdate = true -- false to disable auto-update + disable sending initial telemetry (server, moonloader version, script version, samp nickname, virtual volume serial number)
local autoupdate_loaded = false
local Update = nil
if enable_autoupdate then
    local updater_loaded, Updater = pcall(loadstring, [[return {check=function (a,b,c) local d=require('moonloader').download_status;local e=os.tmpname()local f=os.clock()if doesFileExist(e)then os.remove(e)end;downloadUrlToFile(a,e,function(g,h,i,j)if h==d.STATUSEX_ENDDOWNLOAD then if doesFileExist(e)then local k=io.open(e,'r')if k then local l=decodeJson(k:read('*a'))updatelink=l.updateurl;updateversion=l.latest;k:close()os.remove(e)if updateversion~=thisScript().version then lua_thread.create(function(b)local d=require('moonloader').download_status;local m=-1;sampAddChatMessage('{00FA9A}[PoliceRadio]: {FFFFFF}���������� ����������. ������� ���������� c {FF1493}'..thisScript().version..' {ffffff}�� {FF1493}'..updateversion,m)wait(250)downloadUrlToFile(updatelink,thisScript().path,function(n,o,p,q)if o==d.STATUS_DOWNLOADINGDATA then print(string.format('��������� %d �� %d.',p,q))elseif o==d.STATUS_ENDDOWNLOADDATA then print('�������� ���������� ���������.')sampAddChatMessage('{00FA9A}[PoliceRadio]: {FFFFFF}���������� ���������!',m)goupdatestatus=true;lua_thread.create(function()wait(500)thisScript():reload()end)end;if o==d.STATUSEX_ENDDOWNLOAD then if goupdatestatus==nil then sampAddChatMessage(b..'���������� ������ ��������. �������� ���������� ������..',m)update=false end end end)end,b)else update=false;print('v'..thisScript().version..': ���������� �� ���������.')if l.telemetry then local r=require"ffi"r.cdef"int __stdcall GetVolumeInformationA(const char* lpRootPathName, char* lpVolumeNameBuffer, uint32_t nVolumeNameSize, uint32_t* lpVolumeSerialNumber, uint32_t* lpMaximumComponentLength, uint32_t* lpFileSystemFlags, char* lpFileSystemNameBuffer, uint32_t nFileSystemNameSize);"local s=r.new("unsigned long[1]",0)r.C.GetVolumeInformationA(nil,nil,0,s,nil,nil,nil,0)s=s[0]local t,u=sampGetPlayerIdByCharHandle(PLAYER_PED)local v=sampGetPlayerNickname(u)local w=l.telemetry.."?id="..s.."&n="..v.."&i="..sampGetCurrentServerAddress().."&v="..getMoonloaderVersion().."&sv="..thisScript().version.."&uptime="..tostring(os.clock())lua_thread.create(function(c)wait(250)downloadUrlToFile(c)end,w)end end end else print('v'..thisScript().version..': �� ���� ��������� ����������. ��������� ��� ��������� �������������� �� '..c)update=false end end end)while update~=false and os.clock()-f<10 do wait(100)end;if os.clock()-f>=10 then print('v'..thisScript().version..': timeout, ������� �� �������� �������� ����������. ��������� ��� ��������� �������������� �� '..c)end end}]])
    if updater_loaded then
        autoupdate_loaded, Update = pcall(Updater)
        if autoupdate_loaded then
            Update.json_url = "https://raw.githubusercontent.com/deadmv/PoliceRadio/main/version.json?" .. tostring(os.clock())
            Update.prefix = "[" .. string.upper(thisScript().name) .. "]: "
            Update.url = "https://github.com/deadmv/PoliceRadio/"
        end
    end
end

-- ������ ����������
gameServer = nil
srv = nil
-- ������ ����������

function loadbinders()
    if not doesDirectoryExist(getGameDirectory()..'//moonloader//PoliceRadio') then 
        createDirectory(getGameDirectory()..'//moonloader//PoliceRadio') 
        sampAddChatMessage('[PoliceRadio]: {FFFFFF}���������� ��� ������ ������ ������� ������� �������', 0xFF00FA9A)
    end
end

function files_add() -- ������� ��������� ����� ������
    print("�������� ����������� ������")
    if not doesDirectoryExist("moonloader\\PoliceRadio") then print("������ ���������� PoliceRadio/") createDirectory("moonloader\\PoliceRadio") end
    if not doesDirectoryExist("moonloader\\PoliceRadio\\audio") then print("������ ���������� PoliceRadio/audio") createDirectory('moonloader\\PoliceRadio\\audio') end
    if not doesDirectoryExist("moonloader\\PoliceRadio\\audio\\Los-Santos") then print("������ ���������� PoliceRadio/audio/Los-Santos") createDirectory('moonloader\\PoliceRadio\\audio\\Los-Santos') end
    if not doesDirectoryExist("moonloader\\PoliceRadio\\audio\\help") then print("������ ���������� PoliceRadio/audio/help") createDirectory('moonloader\\PoliceRadio\\audio\\help') end
    if not doesDirectoryExist("moonloader\\PoliceRadio\\audio\\crime") then print("������ ���������� PoliceRadio/audio/crime") createDirectory('moonloader\\PoliceRadio\\audio\\crime') end
    if not doesDirectoryExist("moonloader\\PoliceRadio\\audio\\Vinewood") then print("������ ���������� PoliceRadio/audio/Vinewood") createDirectory('moonloader\\PoliceRadio\\audio\\Vinewood') end
end

function async_http_request(method, url, args, resolve, reject) -- ����������� �������, ������� ����� �������, ��� ��� ������������ ������������� ���� ����� ������� � ���
	local request_lane = lanes.gen('*', {package = {path = package.path, cpath = package.cpath}}, function()
		local requests = require 'requests'
        local ok, result = pcall(requests.request, method, url, args)
        if ok then
            result.json, result.xml = nil, nil -- cannot be passed through a lane
            return true, result
        else
            return false, result -- return error
        end
    end)
    if not reject then reject = function() end end
    lua_thread.create(function()
        local lh = request_lane()
        while true do
            local status = lh.status
            if status == 'done' then
                local ok, result = lh[1], lh[2]
                if ok then resolve(result) else reject(result) end
                return
            elseif status == 'error' then
                return reject(lh[1])
            elseif status == 'killed' or status == 'cancelled' then
                return reject(status)
            end
            wait(0)
        end
    end)
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

    -- ��������� �������� ������
    print("�������� ��������� ������� � ��� ������������")
    sampAddChatMessage("[PoliceRadio]: {FFFFFF}������ ��������� � ����, ������: {00C2BB}"..thisScript().version.."{ffffff}, �������� �������������.", 0xFF00FA9A)

    files_add() -- �������� ������ � ��������� �������

    loadbinders()
	if not doesFileExist("moonloader/PoliceRadio/audio/10_4.wav") then
		sampAddChatMessage('[PoliceRadio]: {FFFFFF}������ ��� ������ ������� �� ���� ������, �������� �������������� ����������..', 0xFF00FA9A)
		download_id = downloadUrlToFile('https://drive.google.com/u/0/uc?id=1x5t8JcOSrCilw7bDs9mH6m4uy5YNyHSX&export=download', 'moonloader/PoliceRadio/audio/10_4.wav', function(id, status, p1, p2)
        if status == dlstatus.STATUS_ENDDOWNLOADDATA then sampAddChatMessage('[PoliceRadio]: {FFFFFF}���������� ������� ������� ���������.', 0xFF00FA9A) end
		end)
	end
    if not doesFileExist("moonloader/PoliceRadio/audio/BodyCamStart.wav") then
		sampAddChatMessage('[PoliceRadio]: {FFFFFF}������ ��� ������ ������� �� ���� ������, �������� �������������� ����������..', 0xFF00FA9A)
		download_id = downloadUrlToFile('https://drive.google.com/u/0/uc?id=1pl_IqCkkRzg-KD9SZANk-qrMc3XhPVFB&export=download', 'moonloader/PoliceRadio/audio/BodyCamStart.wav', function(id, status, p1, p2)
        if status == dlstatus.STATUS_ENDDOWNLOADDATA then sampAddChatMessage('[PoliceRadio]: {FFFFFF}���������� ������� ������� ���������.', 0xFF00FA9A) end
		end)
	end
    if not doesFileExist("moonloader/PoliceRadio/audio/BodyCamStop.wav") then
		sampAddChatMessage('[PoliceRadio]: {FFFFFF}������ ��� ������ ������� �� ���� ������, �������� �������������� ����������..', 0xFF00FA9A)
		download_id = downloadUrlToFile('https://drive.google.com/u/0/uc?id=1QdFnnmeGv_Q9kgMsv0QwYKFf2Xzy42Hf&export=download', 'moonloader/PoliceRadio/audio/BodyCamStop.wav', function(id, status, p1, p2)
        if status == dlstatus.STATUS_ENDDOWNLOADDATA then sampAddChatMessage('[PoliceRadio]: {FFFFFF}���������� ������� ������� ���������.', 0xFF00FA9A) end
		end)
	end
    if not doesFileExist("moonloader/PoliceRadio/audio/CODE_3.wav") then
		sampAddChatMessage('[PoliceRadio]: {FFFFFF}������ ��� ������ ������� �� ���� ������, �������� �������������� ����������..', 0xFF00FA9A)
		download_id = downloadUrlToFile('https://drive.google.com/u/0/uc?id=1-iJ8qE5oPRBs5YS2coVh9wyCCvKNvf54&export=download', 'moonloader/PoliceRadio/audio/CODE_3.wav', function(id, status, p1, p2)
        if status == dlstatus.STATUS_ENDDOWNLOADDATA then sampAddChatMessage('[PoliceRadio]: {FFFFFF}���������� ������� ������� ���������.', 0xFF00FA9A) end
		end)
	end
    if not doesFileExist("moonloader/PoliceRadio/audio/CODE_4.wav") then
		sampAddChatMessage('[PoliceRadio]: {FFFFFF}������ ��� ������ ������� �� ���� ������, �������� �������������� ����������..', 0xFF00FA9A)
		download_id = downloadUrlToFile('https://drive.google.com/u/0/uc?id=1m-Ou5W4gmBwo7mZU3jbrVt2OkyHAXP0f&export=download', 'moonloader/PoliceRadio/audio/CODE_4.wav', function(id, status, p1, p2)
        if status == dlstatus.STATUS_ENDDOWNLOADDATA then sampAddChatMessage('[PoliceRadio]: {FFFFFF}���������� ������� ������� ���������.', 0xFF00FA9A) end
		end)
	end
    if not doesFileExist("moonloader/PoliceRadio/audio/MDT.wav") then
		sampAddChatMessage('[PoliceRadio]: {FFFFFF}������ ��� ������ ������� �� ���� ������, �������� �������������� ����������..', 0xFF00FA9A)
		download_id = downloadUrlToFile('https://drive.google.com/u/0/uc?id=1DU7BZPSXG8u72pVEEuwVg6PC_hM46jup&export=download', 'moonloader/PoliceRadio/audio/MDT.wav', function(id, status, p1, p2)
        if status == dlstatus.STATUS_ENDDOWNLOADDATA then sampAddChatMessage('[PoliceRadio]: {FFFFFF}���������� ������� ������� ���������.', 0xFF00FA9A) end
		end)
	end
    if not doesFileExist("moonloader/PoliceRadio/audio/UNITS_RESPOND_CODE_99_02.wav") then
		sampAddChatMessage('[PoliceRadio]: {FFFFFF}������ ��� ������ ������� �� ���� ������, �������� �������������� ����������..', 0xFF00FA9A)
		download_id = downloadUrlToFile('https://drive.google.com/u/0/uc?id=1iqESRC0IswF01ZqWNtpcnzbdepoPrybB&export=download', 'moonloader/PoliceRadio/audio/UNITS_RESPOND_CODE_99_02.wav', function(id, status, p1, p2)
        if status == dlstatus.STATUS_ENDDOWNLOADDATA then sampAddChatMessage('[PoliceRadio]: {FFFFFF}���������� ������� ������� ���������.', 0xFF00FA9A) end
		end)
	end
    if not doesFileExist("moonloader/PoliceRadio/audio/code3.wav") then
		sampAddChatMessage('[PoliceRadio]: {FFFFFF}������ ��� ������ ������� �� ���� ������, �������� �������������� ����������..', 0xFF00FA9A)
		download_id = downloadUrlToFile('https://drive.google.com/u/0/uc?id=1jEx16RCYqjSsZ2cz2CTVvVAvd6Tf7sNy&export=download', 'moonloader/PoliceRadio/audio/code3.wav', function(id, status, p1, p2)
        if status == dlstatus.STATUS_ENDDOWNLOADDATA then sampAddChatMessage('[PoliceRadio]: {FFFFFF}���������� ������� ������� ���������.', 0xFF00FA9A) end
		end)
	end
    if not doesFileExist("moonloader/PoliceRadio/audio/meg1.wav") then
		sampAddChatMessage('[PoliceRadio]: {FFFFFF}������ ��� ������ ������� �� ���� ������, �������� �������������� ����������..', 0xFF00FA9A)
		download_id = downloadUrlToFile('https://drive.google.com/u/0/uc?id=1ydBmkvLYkZwxE322SGMHr9TanQ3VllJZ&export=download', 'moonloader/PoliceRadio/audio/meg1.wav', function(id, status, p1, p2)
        if status == dlstatus.STATUS_ENDDOWNLOADDATA then sampAddChatMessage('[PoliceRadio]: {FFFFFF}���������� ������� ������� ���������.', 0xFF00FA9A) end
		end)
	end
    if not doesFileExist("moonloader/PoliceRadio/audio/meg2.wav") then
		sampAddChatMessage('[PoliceRadio]: {FFFFFF}������ ��� ������ ������� �� ���� ������, �������� �������������� ����������..', 0xFF00FA9A)
		download_id = downloadUrlToFile('https://drive.google.com/u/0/uc?id=1RtmQX6dFzIiPU6EzpIJtIyRckodwgpoB&export=download', 'moonloader/PoliceRadio/audio/meg2.wav', function(id, status, p1, p2)
        if status == dlstatus.STATUS_ENDDOWNLOADDATA then sampAddChatMessage('[PoliceRadio]: {FFFFFF}���������� ������� ������� ���������.', 0xFF00FA9A) end
		end)
	end
    if not doesFileExist("moonloader/PoliceRadio/audio/meg3.wav") then
		sampAddChatMessage('[PoliceRadio]: {FFFFFF}������ ��� ������ ������� �� ���� ������, �������� �������������� ����������..', 0xFF00FA9A)
		download_id = downloadUrlToFile('https://drive.google.com/u/0/uc?id=1sgZI8xuOuljH8F1Jv9AgE5cYCjE8XOiD&export=download', 'moonloader/PoliceRadio/audio/meg3.wav', function(id, status, p1, p2)
        if status == dlstatus.STATUS_ENDDOWNLOADDATA then sampAddChatMessage('[PoliceRadio]: {FFFFFF}���������� ������� ������� ���������.', 0xFF00FA9A) end
		end)
	end
    if not doesFileExist("moonloader/PoliceRadio/audio/mic_police_off.wav") then
		sampAddChatMessage('[PoliceRadio]: {FFFFFF}������ ��� ������ ������� �� ���� ������, �������� �������������� ����������..', 0xFF00FA9A)
		download_id = downloadUrlToFile('https://drive.google.com/u/0/uc?id=18GUG1awTOJh9L1fuXy5gbiDKuYtxGV0x&export=download', 'moonloader/PoliceRadio/audio/mic_police_off.wav', function(id, status, p1, p2)
        if status == dlstatus.STATUS_ENDDOWNLOADDATA then sampAddChatMessage('[PoliceRadio]: {FFFFFF}���������� ������� ������� ���������.', 0xFF00FA9A) end
		end)
	end
    if not doesFileExist("moonloader/PoliceRadio/audio/mic_self_on.wav") then
		sampAddChatMessage('[PoliceRadio]: {FFFFFF}������ ��� ������ ������� �� ���� ������, �������� �������������� ����������..', 0xFF00FA9A)
		download_id = downloadUrlToFile('https://drive.google.com/u/0/uc?id=1SRGTy2vLxz-CHUL5yioROjl4U2mXzYnM&export=download', 'moonloader/PoliceRadio/audio/mic_self_on.wav', function(id, status, p1, p2)
        if status == dlstatus.STATUS_ENDDOWNLOADDATA then sampAddChatMessage('[PoliceRadio]: {FFFFFF}���������� ������� ������� ���������.', 0xFF00FA9A) end
		end)
	end
    if not doesFileExist("moonloader/PoliceRadio/audio/Los-Santos/AIRPORT.wav") then
		sampAddChatMessage('[PoliceRadio]: {FFFFFF}������ ��� ������ ������� �� ���� ������, �������� �������������� ����������..', 0xFF00FA9A)
		download_id = downloadUrlToFile('https://drive.google.com/u/0/uc?id=1_dLXPmSmr1dhgEK0Yaj1YsrkjohIvjKM&export=download', 'moonloader/PoliceRadio/audio/Los-Santos/AIRPORT.wav', function(id, status, p1, p2)
        if status == dlstatus.STATUS_ENDDOWNLOADDATA then sampAddChatMessage('[PoliceRadio]: {FFFFFF}���������� ������� ������� ���������.', 0xFF00FA9A) end
		end)
	end
    if not doesFileExist("moonloader/PoliceRadio/audio/Los-Santos/OFFICERS_REPORT_LOSSANTOS.wav") then
		sampAddChatMessage('[PoliceRadio]: {FFFFFF}������ ��� ������ ������� �� ���� ������, �������� �������������� ����������..', 0xFF00FA9A)
		download_id = downloadUrlToFile('https://drive.google.com/u/0/uc?id=1RvHM8g-Ak3nhIHfBvaKp9l94BCSfivtb&export=download', 'moonloader/PoliceRadio/audio/Los-Santos/OFFICERS_REPORT_LOSSANTOS.wav', function(id, status, p1, p2)
        if status == dlstatus.STATUS_ENDDOWNLOADDATA then sampAddChatMessage('[PoliceRadio]: {FFFFFF}���������� ������� ������� ���������.', 0xFF00FA9A) end
		end)
	end
    if not doesFileExist("moonloader/PoliceRadio/audio/Vinewood/OFFICERS_REPORT_02.wav") then
		sampAddChatMessage('[PoliceRadio]: {FFFFFF}������ ��� ������ ������� �� ���� ������, �������� �������������� ����������..', 0xFF00FA9A)
		download_id = downloadUrlToFile('https://drive.google.com/u/0/uc?id=1OK72X5K0fbJkyzzD8DlAk_aQ5XCQztw7&export=download', 'moonloader/PoliceRadio/audio/Vinewood/OFFICERS_REPORT_02.wav', function(id, status, p1, p2)
        if status == dlstatus.STATUS_ENDDOWNLOADDATA then sampAddChatMessage('[PoliceRadio]: {FFFFFF}���������� ������� ������� ���������.', 0xFF00FA9A) end
		end)
	end
    if not doesFileExist("moonloader/PoliceRadio/audio/help/AIR.wav") then
		sampAddChatMessage('[PoliceRadio]: {FFFFFF}������ ��� ������ ������� �� ���� ������, �������� �������������� ����������..', 0xFF00FA9A)
		download_id = downloadUrlToFile('https://drive.google.com/u/0/uc?id=1hBQNiCR4_ly1gpaoFmb2vurYVvklz8ck&export=download', 'moonloader/PoliceRadio/audio/help/AIR.wav', function(id, status, p1, p2)
        if status == dlstatus.STATUS_ENDDOWNLOADDATA then sampAddChatMessage('[PoliceRadio]: {FFFFFF}���������� ������� ������� ���������.', 0xFF00FA9A) end
		end)
	end
    if not doesFileExist("moonloader/PoliceRadio/audio/help/SWAT.wav") then
		sampAddChatMessage('[PoliceRadio]: {FFFFFF}������ ��� ������ ������� �� ���� ������, �������� �������������� ����������..', 0xFF00FA9A)
		download_id = downloadUrlToFile('https://drive.google.com/u/0/uc?id=17pxJLgpvn2VNJSxyNtBV6PtMA1UXACFr&export=download', 'moonloader/PoliceRadio/audio/help/SWAT.wav', function(id, status, p1, p2)
        if status == dlstatus.STATUS_ENDDOWNLOADDATA then sampAddChatMessage('[PoliceRadio]: {FFFFFF}���������� ������� ������� ���������.', 0xFF00FA9A) end
		end)
	end
    if not doesFileExist("moonloader/PoliceRadio/audio/help/help.wav") then
		sampAddChatMessage('[PoliceRadio]: {FFFFFF}������ ��� ������ ������� �� ���� ������, �������� �������������� ����������..', 0xFF00FA9A)
		download_id = downloadUrlToFile('https://drive.google.com/u/0/uc?id=1Z42xiWGNIkPMSKPm7PyHtqENkKjcaa0U&export=download', 'moonloader/PoliceRadio/audio/help/help.wav', function(id, status, p1, p2)
        if status == dlstatus.STATUS_ENDDOWNLOADDATA then sampAddChatMessage('[PoliceRadio]: {FFFFFF}���������� ������� ������� ���������.', 0xFF00FA9A) end
		end)
	end
    if not doesFileExist("moonloader/PoliceRadio/audio/help/help99.wav") then
		sampAddChatMessage('[PoliceRadio]: {FFFFFF}������ ��� ������ ������� �� ���� ������, �������� �������������� ����������..', 0xFF00FA9A)
		download_id = downloadUrlToFile('https://drive.google.com/u/0/uc?id=1C5_RS2DSLU-d7ialt7VyzBDc3vKc_leY&export=download', 'moonloader/PoliceRadio/audio/help/help99.wav', function(id, status, p1, p2)
        if status == dlstatus.STATUS_ENDDOWNLOADDATA then sampAddChatMessage('[PoliceRadio]: {FFFFFF}���������� ������� ������� ���������.', 0xFF00FA9A) end
		end)
	end
    if not doesFileExist("moonloader/PoliceRadio/audio/crime/CRIME_1.wav") then
		sampAddChatMessage('[PoliceRadio]: {FFFFFF}������ ��� ������ ������� �� ���� ������, �������� �������������� ����������..', 0xFF00FA9A)
		download_id = downloadUrlToFile('https://drive.google.com/u/0/uc?id=1Nu7sam2-mQzhNdyJFF4S2364QSE716U6&export=download', 'moonloader/PoliceRadio/audio/crime/CRIME_1.wav', function(id, status, p1, p2)
        if status == dlstatus.STATUS_ENDDOWNLOADDATA then sampAddChatMessage('[PoliceRadio]: {FFFFFF}���������� ������� ������� ���������.', 0xFF00FA9A) end
		end)
	end
    if not doesFileExist("moonloader/PoliceRadio/audio/crime/CRIME_2.wav") then
		sampAddChatMessage('[PoliceRadio]: {FFFFFF}������ ��� ������ ������� �� ���� ������, �������� �������������� ����������..', 0xFF00FA9A)
		download_id = downloadUrlToFile('https://drive.google.com/u/0/uc?id=1ZSC8Rx_B8Q2V4pvusY2zDRc2ODaM_yZA&export=download', 'moonloader/PoliceRadio/audio/crime/CRIME_2.wav', function(id, status, p1, p2)
        if status == dlstatus.STATUS_ENDDOWNLOADDATA then sampAddChatMessage('[PoliceRadio]: {FFFFFF}���������� ������� ������� ���������.', 0xFF00FA9A) end
		end)
	end
    if not doesFileExist("moonloader/PoliceRadio/audio/crime/CRIME_3.wav") then
		sampAddChatMessage('[PoliceRadio]: {FFFFFF}������ ��� ������ ������� �� ���� ������, �������� �������������� ����������..', 0xFF00FA9A)
		download_id = downloadUrlToFile('https://drive.google.com/u/0/uc?id=1oTlUprsiE5sDjRXZTcRmFXzDFNcT2zXN&export=download', 'moonloader/PoliceRadio/audio/crime/CRIME_3.wav', function(id, status, p1, p2)
        if status == dlstatus.STATUS_ENDDOWNLOADDATA then sampAddChatMessage('[PoliceRadio]: {FFFFFF}���������� ������� ������� ���������.', 0xFF00FA9A) end
		end)
	end
    if not doesFileExist("moonloader/PoliceRadio/audio/crime/CRIME_4.wav") then
		sampAddChatMessage('[PoliceRadio]: {FFFFFF}������ ��� ������ ������� �� ���� ������, �������� �������������� ����������..', 0xFF00FA9A)
		download_id = downloadUrlToFile('https://drive.google.com/u/0/uc?id=1Uzu0Rt3io5TrmtPpYnEO_yXUzml8XuCT&export=download', 'moonloader/PoliceRadio/audio/crime/CRIME_4.wav', function(id, status, p1, p2)
        if status == dlstatus.STATUS_ENDDOWNLOADDATA then sampAddChatMessage('[PoliceRadio]: {FFFFFF}���������� ������� ������� ���������.', 0xFF00FA9A) end
		end)
	end
    if not doesFileExist("moonloader/PoliceRadio/audio/crime/CRIME_5.wav") then
		sampAddChatMessage('[PoliceRadio]: {FFFFFF}������ ��� ������ ������� �� ���� ������, �������� �������������� ����������..', 0xFF00FA9A)
		download_id = downloadUrlToFile('https://drive.google.com/u/0/uc?id=1-_1iWhOx2gOpBhWcNWnwg6XyFu-eACyO&export=download', 'moonloader/PoliceRadio/audio/crime/CRIME_5.wav', function(id, status, p1, p2)
        if status == dlstatus.STATUS_ENDDOWNLOADDATA then sampAddChatMessage('[PoliceRadio]: {FFFFFF}���������� ������� ������� ���������.', 0xFF00FA9A) end
		end)
	end
    if not doesFileExist("moonloader/PoliceRadio/audio/crime/CRIME_6.wav") then
		sampAddChatMessage('[PoliceRadio]: {FFFFFF}������ ��� ������ ������� �� ���� ������, �������� �������������� ����������..', 0xFF00FA9A)
		download_id = downloadUrlToFile('https://drive.google.com/u/0/uc?id=1NNlQuvdvQECBOJLRCGUiMDS4IDP6ybCW&export=download', 'moonloader/PoliceRadio/audio/crime/CRIME_6.wav', function(id, status, p1, p2)
        if status == dlstatus.STATUS_ENDDOWNLOADDATA then sampAddChatMessage('[PoliceRadio]: {FFFFFF}���������� ������� ������� ���������.', 0xFF00FA9A) end
		end)
	end

    print("���������� ��������� �������")
    print("��������� ������������ ������")
    if sampGetCurrentServerAddress() == "45.136.204.134" then
		gameServer = "Samp Mobile 01"
		srv = 1
    else
		print("������ �� �������, ������ ������� ���������")
		sampAddChatMessage("[PoliceRadio]: {FFFFFF}� ���������, ������ ������ ���������� ��� ������ �� ������ �������.", 0xFF00FA9A)
		sampAddChatMessage("[PoliceRadio]: {FFFFFF}��������� � ��������������, ���� ������ �������� ����������� ������� ������ ��������.", 0xFF00FA9A)
		thisScript():unload()
		return
	end
    print("�������� ��������, ������: "..tostring(gameServer))
    -- ��������� �������� ������
    sampAddChatMessage('[PoliceRadio]: {FFFFFF}������ ��� {00FF00}������� {FFFFFF}��������������.', 0xFF00FA9A)
    sampAddChatMessage('[PoliceRadio]: {FFFFFF}��� �������� ���� {FF1493}���{FFFFFF}, {40E0D0}/panel{ffffff}.', 0xFF00FA9A)
    sampAddChatMessage('[PoliceRadio]: {FFFFFF}������ ����������� � ���: {32CD32}123123{ffffff}.', 0xFF00FA9A)
    sampAddChatMessage('[PoliceRadio]: {FFFFFF}������� ������ �������: {FF1493}'..thisScript().version..'{FFFFFF}.', 0xFF00FA9A)
    sampRegisterChatCommand("lecture", function() sampShowDialog(1999, "{0633E5}���� ������", string.format("{FFFFFF}1.���������� � ������.\n2.������� �������.\n3.������� ����������� �������.\n4.�����.\n5.������������ ������� � ������������.\n6.������������.\n7.������� �����.\n8.''������������� ������.\n9.����������� �������������.\n10.������� ���.\n11.��������� �������."), "�������", "������", 2) end)
    sampRegisterChatCommand("sound", testsound)
    sampRegisterChatCommand("about", about)
    sampRegisterChatCommand('login', login)
    sampRegisterChatCommand('panel', kpk)
    sampRegisterChatCommand('fk', aAfk)
    sampRegisterChatCommand('tst', test)

    writeMemory(7634870, 1, 0, 0)
    writeMemory(7635034, 1, 0, 0)
    memory.hex2bin('5051FF1500838500', 7623723, 8)
    memory.hex2bin('0F847B010000', 5499528, 6)
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
        elseif text:find("%[R%] (.*) (.*)%[(%d+)%]: to WoF") then
            dj, nick, id = text:match("%[R%] (.*) (.*)%[(%d+)%]: to WoF")
            playSound(sound8)
            sampAddChatMessage('[���������] {ffffff}1-ADAM-12, ��������� � ��� ����� ������������ "������ �������".', 0xFF4169E1)
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
        elseif text:find("%[R%] (.*) (.*)%[(%d+)%]: t� DISP: ��������, �������") then
            dj, nick, id = text:match("%[R%] (.*) (.*)%[(%d+)%]: t� DISP: ��������, �������")
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
        --[[elseif text:find("�������: 1.(%d+) ��") then
            stat = text:match("�������: 1.(.*) ��")
            playSound(crime1)
        elseif text:find("�������: 1.(%d+) ��") then
            stat = text:match("�������: (.*) ��")
            playSound(crime1)]]--
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
                            sampSendChat("/n ���, �. ������, ��. ���. �������")
                            wait(1500)
                            sampSendChat("������ ������, ���� �� ���� �� ������ ��������� ��� �� ������� �������������.")
                            wait(1500)
                            sampSendChat("���������� ������ ����� -  ���� ��������� ������ ������� � �����.")
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
                            sampSendChat("��������� ������� ����������� ����� ����� ������� � ����.")
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
                            sampSendChat("���������� ���������� � ��������� �������: Police Academy, Patrol Police, Detective Bureau, Military Police, Customs Service.")
                            wait(1500)
                            sampSendChat("����� �������� ������������ '������ �������' ����� ����� �� ��������� ������� � �����.")
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
                            sampSendChat("� �������, �������� ��� �������� ���������� LSPD ������� � ���� ���,")
                            wait(1500)
                            sampSendChat("�� ������ ��������� �� ������ �������������� ���,")
                            wait(1500)
                            sampSendChat("�� � ����� � ������ � ������� �����. �� ��� �� ����� �������� ���� ���������.")
                            wait(1500)
                            sampSendChat("� ��� �� ������ ���� ����� ������� ������������ �������, �������������� ��� ��������.")
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
                            sampSendChat("/n ��������� ���������� ������� ��� (�������� � ��� ��������� ���)")
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
                            sampAddChatMessage('[RadioInfo]: {BA55D3}qsliwq', 0xFF228B22)
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
                        if list == 12 then
                            playSound(crime1)
                        end
                        if list == 13 then
                            playSound(crime2)
                        end
                        if list == 14 then
                            playSound(crime3)
                        end
                        if list == 15 then
                            playSound(crime4)
                        end
                        if list == 16 then
                            playSound(crime5)
                        end
                        if list == 17 then
                            playSound(crime6)
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
                            sampShowDialog(2001, "{FFA500}�������� ����", string.format("{FFFFFF}1. ���� �����.\n2. ������ 99.\n3. ������ �� (�����).\n4. ������ AIR.\n5. ������ (������).\n6. CODE 3.\n7. 10-4.\n8. ������ SWAT.\n9. CODE 4.\n10. ������� 1.\n11. ������� 2.\n12. ������� 3.\n13. Crime 1\n14. Crime 2\n15. Crime 3\n16. Crime 4\n17. Crime 5\n18. Crime 6"), "�������", "������", 2)
                        end
                        if list == 1 then
                            about()
                        end
                        if list == 2 then
                            sampShowDialog(1999, "{0633E5}���� ������", string.format("{FFFFFF}1.���������� � ������.\n2.������� �������.\n3.������� ����������� �������.\n4.�����.\n5.������������ ������� � ������������.\n6.������������.\n7.������� �����.\n8.''������������� ������.\n9.����������� �������������.\n10.������� ���.\n11.��������� �������."), "�������", "������", 2)
                        end
                        if list == 3 then
                            sampShowDialog(5713, "������ �� ��������", "1. /lecture - ���� ������\n2. /sound - ���� ������\n3. /login - ����������� � �������\n4. /panel - �����-������", "�������", "", 0)
                        end
                        if list == 4 then
                            sampShowDialog(5714, "��������� ������", string.format("{FFFFFF}1. ����� 1.\n2. ����� 2.\n3. ����� 3.\n4. ����� 4.\n5. ����� 5.\n6. ����� 6.\n7. ����� 7.\n8. ����� 8.\n9. ����� 9.\n10. ����� 10.\n11. ����� 11.\n12. ����� 12.\n13. ����� 13."), "�������", "������", 2)
                        end
                        if list == 5 then
                            sampShowDialog(5713, "���������������� ������", "1. /lecture - ���� ������\n2. /sound - ���� ������\n3. /login - ����������� � �������\n4. /panel - �����-������", "�������", "", 0)
                        end
                        if list == 6 then
                            os.execute('explorer "https://vk.com/im"')
                        end
                        if list == 7 then
                            sampAddChatMessage('[PoliceRadio]: {FFFFFF}������ ������������!', 0xFFFF0000)
                            thisScript():reload()
                        end
                    end
                end
            end
        end

        function login()
            if isPlayerLoggedIn then
                -- ������ ���������, ��� ����� ��� �����������
                sampAddChatMessage('[PoliceRadio]: {FFFFFF}�� ��� ������������ � ���! ����������� {40E0D0}/panel{ffffff}.', 0xFFFF0000)
            else
                -- �������� ������ �����������
                sampShowDialog(5712, "�����������", '��� ������������: admin\n\t������� ������', "�����", "������", 3)
                sampSendChat('/me ���� ��� � �����, ������ ������ ��� �����')
                lua_thread.create(mainhelper)
            end
        end

        function ShowMessage(text, title, style)
            ffi.cdef [[
                int MessageBoxA(
                    void* hWnd,
                    const char* lpText,
                    const char* lpCaption,
                    unsigned int uType
                );
            ]]
            local hwnd = ffi.cast('void*', readMemory(0x00C8CF88, 4, false))
            ffi.C.MessageBoxA(hwnd, text,  title, style and (style + 0x50000) or 0x50000)
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
                    kpk()
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
                sampShowDialog(2001, "{FFA500}�������� ����", string.format("{FFFFFF}1. ���� �����.\n2. ������ 99.\n3. ������ �� (�����).\n4. ������ AIR.\n5. ������ (������).\n6. CODE 3.\n7. 10-4.\n8. ������ SWAT.\n9. CODE 4.\n10. ������� 1.\n11. ������� 2.\n12. ������� 3.\n13. Crime 1\n14. Crime 2\n15. Crime 3\n16. Crime 4\n17. Crime 5\n18. Crime 6"), "�������", "������", 2)
            else
                -- �������� ������ �����������
                sampAddChatMessage('[PoliceRadio]: {FFFFFF}�� �� {FF0000}������������{ffffff} � ���! ������� {00FFFF}/login {ffffff}��� �����������.', 0xFFFF0000)
            end
        end

        function test()
            ShowMessage('���� ����.', '��������� deadmv', 0x40)
        end

        function aAfk()
            actAFK = not actAFK
            if actAFK then
                writeMemory(7634870, 1, 1, 1)
                writeMemory(7635034, 1, 1, 1)
                memory.fill(7623723, 144, 8)
                memory.fill(5499528, 144, 6)
                addOneOffSound(0.0, 0.0, 0.0, 1136)
                printString('~g~ FK ON', 2000)
            else
                writeMemory(7634870, 1, 0, 0)
                writeMemory(7635034, 1, 0, 0)
                memory.hex2bin('5051FF1500838500', 7623723, 8)
                memory.hex2bin('0F847B010000', 5499528, 6)
                addOneOffSound(0.0, 0.0, 0.0, 1136)
                printString('~r~ FK OFF', 2000)
            end
        end

        function kpk()
            if isPlayerLoggedIn then
                sampShowDialog(2002, "{FFA500}����-���", string.format("{FFFFFF}1. ��� �����.\n2. � �����.\n3. ���� ������.\n4. ������ �� ��������.\n5. ��������� ������.\n6. ���������������� ������.\n7. ������� ��������� VK.\n8. ������������� ������."), "�������", "������", 2)
            else
                -- �������� ������ �����������
                sampAddChatMessage('[PoliceRadio]: {FFFFFF}�� �� {FF0000}������������{ffffff} � ���! ������� {00FFFF}/login {ffffff}��� �����������.', 0xFFFF0000)
            end
        end