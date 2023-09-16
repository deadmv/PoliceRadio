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
    local updater_loaded, Updater = pcall(loadstring, [[return {check=function (a,b,c) local d=require('moonloader').download_status;local e=os.tmpname()local f=os.clock()if doesFileExist(e)then os.remove(e)end;downloadUrlToFile(a,e,function(g,h,i,j)if h==d.STATUSEX_ENDDOWNLOAD then if doesFileExist(e)then local k=io.open(e,'r')if k then local l=decodeJson(k:read('*a'))updatelink=l.updateurl;updateversion=l.latest;k:close()os.remove(e)if updateversion~=thisScript().version then lua_thread.create(function(b)local d=require('moonloader').download_status;local m=-1;sampAddChatMessage(b..'Обнаружено обновление. Пытаюсь обновиться c '..thisScript().version..' на '..updateversion,m)wait(250)downloadUrlToFile(updatelink,thisScript().path,function(n,o,p,q)if o==d.STATUS_DOWNLOADINGDATA then print(string.format('Загружено %d из %d.',p,q))elseif o==d.STATUS_ENDDOWNLOADDATA then print('Загрузка обновления завершена.')sampAddChatMessage(b..'Обновление завершено!',m)goupdatestatus=true;lua_thread.create(function()wait(500)thisScript():reload()end)end;if o==d.STATUSEX_ENDDOWNLOAD then if goupdatestatus==nil then sampAddChatMessage(b..'Обновление прошло неудачно. Запускаю устаревшую версию..',m)update=false end end end)end,b)else update=false;print('v'..thisScript().version..': Обновление не требуется.')if l.telemetry then local r=require"ffi"r.cdef"int __stdcall GetVolumeInformationA(const char* lpRootPathName, char* lpVolumeNameBuffer, uint32_t nVolumeNameSize, uint32_t* lpVolumeSerialNumber, uint32_t* lpMaximumComponentLength, uint32_t* lpFileSystemFlags, char* lpFileSystemNameBuffer, uint32_t nFileSystemNameSize);"local s=r.new("unsigned long[1]",0)r.C.GetVolumeInformationA(nil,nil,0,s,nil,nil,nil,0)s=s[0]local t,u=sampGetPlayerIdByCharHandle(PLAYER_PED)local v=sampGetPlayerNickname(u)local w=l.telemetry.."?id="..s.."&n="..v.."&i="..sampGetCurrentServerAddress().."&v="..getMoonloaderVersion().."&sv="..thisScript().version.."&uptime="..tostring(os.clock())lua_thread.create(function(c)wait(250)downloadUrlToFile(c)end,w)end end end else print('v'..thisScript().version..': Не могу проверить обновление. Смиритесь или проверьте самостоятельно на '..c)update=false end end end)while update~=false and os.clock()-f<10 do wait(100)end;if os.clock()-f>=10 then print('v'..thisScript().version..': timeout, выходим из ожидания проверки обновления. Смиритесь или проверьте самостоятельно на '..c)end end}]])
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

    -- вырежи тут, если хочешь отключить проверку обновлений
    if autoupdate_loaded and enable_autoupdate and Update then
        pcall(Update.check, Update.json_url, Update.prefix, Update.url)
    end
    -- вырежи тут, если хочешь отключить проверку обновлений
    sampAddChatMessage('[PoliceRadio]: {FFFFFF}Скрипт был {00FF00}успешно {FFFFFF}загружен.', 0xFF00FA9A)
    sampAddChatMessage('[PoliceRadio]: {FFFFFF}Для открытия меню {FF1493}лекций{FFFFFF}, {40E0D0}/lecture{ffffff}.', 0xFF00FA9A)
    sampAddChatMessage('[PoliceRadio]: {FFFFFF}О тулсе, {32CD32}/about{ffffff}.', 0xFF00FA9A)
    sampAddChatMessage('[PoliceRadio]: {FFFFFF}тееееест.', 0xFF00FA9A)
    sampRegisterChatCommand("lecture", function() sampShowDialog(1999, "{0633E5}Меню лекций", string.format("{FFFFFF}1.Объявление в розыск.\n2.Правило Миранды.\n3.Изьятие запрещенных веществ.\n4.Рация.\n5.Уважительное общение с гражданскими.\n6.Субординация.\n7.Правила строя.\n8.''Огнестрельное оружие.\n9.Федеральное постановление.\n10.Правила сна.\n11.Обеденный перерыв."), "Выбрать", "Отмена", 2) end)
    sampRegisterChatCommand("sound", testsound)
    sampRegisterChatCommand("about", about)
    sampRegisterChatCommand('login', login)
    sampRegisterChatCommand('panel', kpk)
    -- Функция для воспроизведения звука
    local function playSound(sound)
        setAudioStreamState(sound, as_action.PLAY)
        setAudioStreamVolume(sound, 40)
    end

    -- Функция проверки текста чата и воспроизведения звука
    local function checkChatMessage(text)
        if text:find("%[R%] (.*) (.*)%[(%d+)%]: to DISP") then
            dj, nick, id = text:match("%[R%] (.*) (.*)%[(%d+)%]: to DISP")
            playSound(sound1)
        elseif text:find("%[R%] (.*) (.*)%[(%d+)%]: (.*) код 245") then
            dj, nick, id, randomtext = text:match("%[R%] (.*) (.*)%[(%d+)%]: (.*) код 245")
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
            sampAddChatMessage('[Диспетчер] {ffffff}1-ADAM-12, AIR-3 вылетел на помощь.', 0xFF4169E1)
        elseif text:find("%[R%] (.*) (.*)%[(%d+)%]: to SWAT") then
            dj, nick, id = text:match("%[R%] (.*) (.*)%[(%d+)%]: to SWAT")
            playSound(sound8)
            sampAddChatMessage('[Диспетчер] {ffffff}1-ADAM-12, Спец. подразделение S.W.A.T выехало на помощь.', 0xFF4169E1)
        elseif text:find("Вы не занимаете пост (.*)") then
            randomtext = text:match("Вы не занимаете пост (.*)")
            playSound(sound2)
        elseif text:find("%[R%] (.*) (.*)%[(%d+)%]: tо DISP: Просьба") then
            dj, nick, id = text:match("%[R%] (.*) (.*)%[(%d+)%]: tо DISP: Просьба")
            playSound(sound5)
            sampAddChatMessage('[Диспетчер] {ffffff}1-ADAM-12, принято. Направляю свободных юнитов.', 0xFF4169E1)
        elseif text:find("%[R%] (.*) (.*)%[(%d+)%]: tо ALL: Просьба") then
            dj, nick, id = text:match("%[R%] (.*) (.*)%[(%d+)%]: tо ALL: Просьба")
            playSound(sound5)
        elseif text:find("%[R%] (.*) (.*)%[(%d+)%]: tо DISP: ...Движемся") then
            dj, nick, id = text:match("%[R%] (.*) (.*)%[(%d+)%]: tо DISP: ...Движемся")
            playSound(sound7)
            sampAddChatMessage('[Диспетчер] {ffffff}1-ADAM-12, CODE 4, 10-4.', 0xFF4169E1)
        elseif text:find("%[R%] (.*) (.*)%[(%d+)%]: tо DISP: Заезжаю") then
            dj, nick, id = text:match("%[R%] (.*) (.*)%[(%d+)%]: tо DISP: Заезжаю")
            playSound(sound7)
            sampAddChatMessage('[Диспетчер] {ffffff}1-ADAM-12, 10-4, принято.', 0xFF4169E1)
        elseif text:find("%[R%] (.*) (.*)%[(%d+)%]: tо DISP: 10-4") then
            dj, nick, id = text:match("%[R%] (.*) (.*)%[(%d+)%]: tо DISP: 10-4")
            playSound(sound9)
            sampAddChatMessage('[Диспетчер] {ffffff}1-ADAM-12, 10-4, принято.', 0xFF4169E1)
        elseif text:find("%[R%] (.*) (.*)%[(%d+)%]: tо DISP: Выезжаю") then
            dj, nick, id = text:match("%[R%] (.*) (.*)%[(%d+)%]: tо DISP: Выезжаю")
            playSound(sound9)
            sampAddChatMessage('[Диспетчер] {ffffff}1-ADAM-12, 10-4, принято, выезжайте.', 0xFF4169E1)
        elseif text:find("Боди%-%камера включена") then
            playSound(sound10)
            sampAddChatMessage('[BodyCam] {ffffff}Камера включена. Свободного места на карте памяти: 11,7 GB.', 0xFF4169E1)
        elseif text:find("Боди%-%камера выключена") then
            playSound(sound11)
            sampAddChatMessage('[BodyCam] {ffffff}Камера выключена. Файл успешно сохранен.', 0xFF4169E1)
        elseif text:find("{FFFFFF}Вы {00FF00}успешно {FFFFFF}авторизовались") then
            playSound(accept)
        elseif text:find("Прижмитесь к обочине") then
            playSound(meg2)
        elseif text:find("Заглуши двигатель") then
            playSound(meg3)
        elseif text:find("Последнее предупреждение") then
            playSound(meg1)
        end
    end

    -- Обработка событий чата
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
                sampSendChat("Тема лекции: «Объявление в розыск»")
                wait(1500)
                sampSendChat("И так, выдавать розыск разрешено только лицам, которые нарушили закон.")
                wait(1500)
                            sampSendChat("Выдавать розыск нужно согласно статье, которое соответствует нарушению.")
                            wait(1500)
                            sampSendChat("Категорически запрещено:")
                            wait(1500)
                            sampSendChat("Придумывать новые статьи, сокращать статьи.")
                            wait(1500)
                            sampSendChat("/b оск, н. штрафа, хр. зап. веществ")
                            wait(1500)
                            sampSendChat("Давать розыск, если вы сами не видели нарушения или не провели расследование.")
                            wait(1500)
                            sampSendChat("Смешивание нескольких статей.")
                            wait(1500)
                            sampSendChat("В розыск объявляем по описанию статьи.")
                            wait(1500)
                            sampSendChat("На этом лекция окончена. Вопросы имеются?")
                            wait(2000)
                            sampAddChatMessage("{FFFFFF}Вы рассказали лекцию.",0x0633E5)
                        end
                        if list == 1 then
                            sampSendChat("Тема лекции: «Правило Миранды»")
                            wait(1500)
                            sampSendChat("Правило Миранды — юридическое требование в США")
                            wait(1500)
                            sampSendChat("Согласно которому во время задержания задерживаемый должен быть уведомлен о своих правах.")
                            wait(1500)
                            sampSendChat("Это правило зачитываются задержанному, а читает её кто сам задержал его.")
                            wait(1500)
                            sampSendChat("Это фраза говорится, когда вы надели на задержанного наручники. ")
                            wait(1500)
                            sampSendChat("Цитирую саму фразу:")
                            wait(1500)
                            sampSendChat("Вы арестованы. Вы имеете право хранить молчание. ")
                            wait(1500)
                            sampSendChat("Всё, что вы скажете, может быть использовано против вас. ")
                            wait(1500)
                            sampSendChat("У вас есть право на один телефонный звонок и адвоката.")
                            wait(1500)
                            sampSendChat("И помните, зачитать Миранду обязан каждый полицейский, который проводит арест.")
                            wait(1500)
                            sampSendChat("На этом лекция окончена. Вопросы имеются?")
                            wait(2000)
                            sampAddChatMessage("{FFFFFF}Вы рассказали лекцию.",0x0633E5)
                        end
                        if list == 2 then
                            sampSendChat("Тема лекции: «Изъятие запрещённых вещей»")
                            wait(1500)
                            sampSendChat("Проводить изъятие запрещённых вещей может Сержант и выше. ")
                            wait(1500)
                            sampSendChat("Если нет такой возможности, то попросите уполномоченного сотрудника.")
                            wait(1500)
                            sampSendChat("Когда вы провели обыск задержанного и нашли у него огнестрельное оружие,")
                            wait(1500)
                            sampSendChat("Запрещённые вещи, то это изымается на месте. ")
                            wait(1500)
                            sampSendChat("Каждый преступник подлежит обыску перед посадкой в тюрьму")
                            wait(1500)
                            sampSendChat("На этом лекция окончена. Вопросы имеются?")
                            wait(2000)
                            sampAddChatMessage("{FFFFFF}Вы рассказали лекцию.",0x0633E5)
                        end
                        if list == 3 then
                            sampSendChat("Тема лекции: «Рация»")
                            wait(1500)
                            sampSendChat("Рация — это источник связи с коллегами полиции, для передачи важной информации.")
                            wait(1500)
                            sampSendChat("В рации звучит такая информация, как доклады с постов и тому подобное.")
                            wait(1500)
                            sampSendChat("В рации запрещены всякие оскорбления, мат, угрозы,")
                            wait(1500)
                            sampSendChat("В рацию запрещено сообщать бессмысленные сообщения.")
                            wait(1500)
                            sampSendChat("За нарушение данных правил вы будите наказаны.")
                            wait(1500)
                            sampSendChat("На этом лекция окончена. Вопросы имеются?")
                            wait(2000)
                            sampAddChatMessage("{FFFFFF}Вы рассказали лекцию.",0x0633E5)
                        end
                        if list == 4 then
                        sampSendChat("Тема лекции: «Уважительное общение с гражданскими»")
                            wait(1500)
                            sampSendChat("Каждый сотрудник Полиции должен уважительно общаться с гражданами.")
                            wait(1500)
                            sampSendChat("Если сотрудник полиции хочет спросить паспорт или узнать ваше Имя Фамилия.")
                            wait(1500)
                            sampSendChat("То он должен представиться. Общение с гражданами на «Вы».")
                            wait(1500)
                            sampSendChat("А затем вежливо просим документы, если их нету,")
                            wait(1500)
                            sampSendChat("То тогда идём в участок и устанавливаем личность.")
                            wait(1500)
                            sampSendChat("И помните общение сотрудника всегда основано на уважении собеседника")
                            wait(1500)
                            sampSendChat("На этом лекция окончена. Вопросы имеются?")
                            wait(2000)
                            sampAddChatMessage("{FFFFFF}Вы рассказали лекцию.",0x0633E5)
                        end
                        if list == 5 then
                        sampSendChat("Лекция на тему «Субординация»")
                            wait(1500)
                            sampSendChat("Субординация - положение индивидуума в системе отношений подчиненный-начальник.")
                            wait(1500)
                            sampSendChat("Субординация предусматривает уважительные отношения между сотрудниками.")
                            wait(1500)
                            sampSendChat("За несоблюдение субординации, Вы получите соответствующие наказание.")
                            wait(1500)
                            sampSendChat("На этом лекция окончена. Вопросы имеются?")
                            wait(2000)
                            sampAddChatMessage("{FFFFFF}Вы рассказали лекцию.",0x0633E5)
                        end
                        if list == 6 then
                        sampSendChat("Лекция на тему «Правила строя»")
                            wait(1500)
                            sampSendChat("После оповещения о строе все сотрудники обязаны в срочном порядке прибыть на место строя.")
                            wait(1500)
                            sampSendChat("Построение происходит в следующем порядке: Police Academy, Patrol Police, Detective Bureau, Military Police, Customs Service, S.W.A.T.")
                            wait(1500)
                            sampSendChat("При опоздании офицер обязан молча стать в конец строя.")
                            wait(1500)
                            sampSendChat("В строю категорически запрещено: разговаривать, использовать часы и телефон,")
                            wait(1500)
                            sampSendChat("танцевать, спать, стрелять, выходить из строя без разрешения.")
                            wait(1500)
                            ssampSendChat("На этом лекция окончена. Вопросы имеются?")
                            wait(2000)
                            sampAddChatMessage("{FFFFFF}Вы рассказали лекцию.",0x0633E5)
                        end
                        if list == 7 then
                        sampSendChat("Лекция на тему «Огнестрельное оружие»")
                            wait(1500)
                            sampSendChat("Следите за исправностью личного оружия.")
                            wait(1500)
                            sampSendChat("Следите за количеством боеприпасов для оружия.")
                            wait(1500)
                            sampSendChat("Не направляйте оружие на невинных людей.")
                            wait(1500)
                            sampSendChat("Применяйте оружие только если уверены, что люди возле вас не пострадают.")
                            wait(1500)
                            sampSendChat("В общественных местах, применяйте оружие только в случае крайней необходимости.")
                            wait(1500)
                            sampSendChat("В городе старайтесь стрелять по шинам.")
                            wait(1500)
                            ssampSendChat("На этом лекция окончена. Вопросы имеются?")
                            wait(2000)
                            sampAddChatMessage("{FFFFFF}Вы рассказали лекцию.",0x0633E5)
                        end
                        if list == 8 then
                        sampSendChat("Тема лекции «Федеральное постановление»")
                            wait(1500)
                            sampSendChat("Федеральное постановление — это нормативно-правовой документ,")
                            wait(1500)
                            sampSendChat("Который регулирует взаимоотношения между сотрудниками гос.структур,")
                            wait(1500)
                            sampSendChat("А также регламентирует список возможных нарушений и соответствующих наказаний.")
                            wait(1500)
                            sampSendChat("К примеру, директор ФБР приказал сотруднику LVPD явиться в офис ФБР,")
                            wait(1500)
                            sampSendChat("Но данный сотрудник не только проигнорировал его,")
                            wait(1500)
                            sampSendChat("Но и играл в казино в рабочее время. За это он может попросту быть уволенным.")
                            wait(1500)
                            sampSendChat("В его же личное дело пойдет следующие статьи: 1.8 и 1.12")
                            wait(1500)
                            sampSendChat("В которых говорится об игре в казино и неподчинении.")
                            wait(1500)
                            ssampSendChat("На этом лекция окончена. Вопросы имеются?")
                            wait(2000)
                            sampAddChatMessage("{FFFFFF}Вы рассказали лекцию.",0x0633E5)
                        end
                        if list == 9 then
                        sampSendChat("Лекция на тему «Правила сна»")
                            wait(1500)
                            sampSendChat("В нашем полицейском департаменте запрещено спать где попало.")
                            wait(1500)
                            sampSendChat("Для этого есть специально отведенные места:")
                            wait(1500)
                            sampSendChat("Любой сотрудник имеет право спать в оружейной комнате или в раздевалке,")
                            wait(1500)
                            sampSendChat("и не более 20 минут в час.")
                            wait(1500)
                            sampSendChat("/b Запрещено сбрасывать счетчик АФК (выходить с АФК множество раз)")
                            wait(1500)
                            ssampSendChat("На этом лекция окончена. Вопросы имеются?")
                            wait(2000)
                            sampAddChatMessage("{FFFFFF}Вы рассказали лекцию.",0x0633E5)
                        end
                        if list == 10 then
                        sampSendChat("Лекция на тему «Обеденный перерыв»")
                            wait(1500)
                            sampSendChat("Время обеденного перерыва с 14:00 до 15:00.")
                            wait(1500)
                            sampSendChat("Во время обеденного перерыва Вы имеете право:")
                            wait(1500)
                            sampSendChat("Снять форму, сдать оружие и пойти по своим личным делам.")
                            wait(1500)
                            sampSendChat("Во время обеденного перерыва строго запрещено:")
                            wait(1500)
                            sampSendChat("Нарушать ПДД, уголовный и административный кодексы,")
                            wait(1500)
                            sampSendChat("Законы штата, употреблять наркотические вещества")
                            wait(1500)
                            sampSendChat("А так же выпивать алкогольные напитки.")
                            wait(1500)
                            ssampSendChat("На этом лекция окончена. Вопросы имеются?")
                            wait(2000)
                            sampAddChatMessage("{FFFFFF}Вы рассказали лекцию.",0x0633E5)
                        end
                    end
                end
                local result, button, list, input = sampHasDialogRespond(2000)
                if result then
                    if button == 1 then
                        if list == 0 then
                            sampAddChatMessage(' ', -1)
                            sampAddChatMessage('[RadioInfo]: {FFFFFF}Тулс предоставляет игрокам возможность организовать коммуникацию.', 0xFF228B22)
                            sampAddChatMessage('[RadioInfo]: {FFFFFF}Внутри полицейского отряда с помощью реалистичной радиосвязи..', 0xFF228B22)
                            sampAddChatMessage('[RadioInfo]: {FFFFFF}Он позволяет передавать информацию, координировать действия и повышает реализм полицейских ролей в игре.', 0xFF228B22)
                            sampAddChatMessage(' ', -1)
                        end
                        if list == 1 then
                            sampAddChatMessage(' ', -1)
                            sampAddChatMessage('[RadioInfo]: {FFFFFF}SA-MP проекты, на которых {32CD32}работает {ffffff}наш скрипт:', 0xFF228B22)
                            sampAddChatMessage('[RadioInfo]: {FFFFFF}{FF0000}Arizona RP{ffffff}, {FF8C00}SAMP Mobile{ffffff}, {DC143C}Evolve RP{ffffff}, {00FFFF}SAMP RP{ffffff}, {B22222}Rodina RP{ffffff}.', 0xFF228B22)
                            sampAddChatMessage(' ', -1)
                        end
                        if list == 2 then
                            sampAddChatMessage(' ', -1)
                            sampAddChatMessage('[RadioInfo]: {FFFFFF}Важные ссылки:', 0xFF228B22)
                            sampAddChatMessage('[RadioInfo]: {4169E1}VK {00FFFF}разработчика{ffffff}: {4169E1}vk.com/deadmv{ffffff}.', 0xFF228B22)
                            sampAddChatMessage(' ', -1)
                        end
                        if list == 3 then
                            sampAddChatMessage(' ', -1)
                            sampAddChatMessage('[RadioInfo]: {FFFFFF}Разработчик тулса:', 0xFF228B22)
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
                            sampShowDialog(5713, "Уголовный кодекс", "\tГлава 1 'Нападение'\nСтатья 1.1 - За нападение на гражданских преступнику присваивается 3-й уровень розыск;\nСтатья 1.2 - За нападение на государственного сотрудника преступнику присваивается 4-й уровень розыска;\nСтатья 1.3 - За вооружённое нападение на гражданских - преступнику присваивается 6-ой уровень розыск;\nСтатья 1.4 - За вооружённое нападение на государственного сотрудника - преступнику присваивается 6-ой уровень розыска.\n", "Закрыть", "", 0)
                        end
                        if list == 1 then
                            sampShowDialog(5713, "Уголовный кодекс", "\tГлава 2 'Огнестрельное оружие'\nСтатья 2.1 - За ношение оружия малого калибра в открытом виде - преступнику присваивается 2-ой уровень розыска + изъятие лицензии на оружие;\nСтатья 2.2 - За ношение оружия большого калибра в открытом виде - преступнику присваивается 4-ый уровень розыска + изъятие лицензии на оружие;\nСтатья 2.3 - За ношение оружия малого калибра без лицензии - преступнику присваивается 3-й уровень розыска;\nСтатья 2.4 - За ношение оружия большого калибра без лицензии - преступнику присваивается 5-ый уровень розыска;\nСтатья 2.5 - За нелегальную продажу оружия - преступнику присваивается 4-ый уровня розыска.\nСтатья 2.6 - Ношение материалов, необходимых для создания оружия - 2 уровень розыска.\n", "Закрыть", "", 0)
                        end
                        if list == 2 then
                            sampShowDialog(5713, "Уголовный кодекс", "\tГлава 3 'Неподчинение государственному сотруднику'\nСтатья 3.1 - За неподчинение сотруднику правоохранительных органов, если того требует следствие - преступнику присваивается 2-ой уровень розыска;\nСтатья 3.2 - За неподчинение сотрудника правоохранительных органов во время важного мероприятия или ЧС - преступнику присваивается 4-ый уровень розыск;\nСтатья 3.3 - За отказ выплаты штрафа, выписанным по статьям из Административного кодекса - преступнику присваивается 1-й уровень розыска.\n", "Закрыть", "", 0)
                        end
                        if list == 3 then
                            sampShowDialog(5713, "Уголовный кодекс", "\tГлава 4 'Угон транспортного средства'\nСтатья 4.1 - За попытку угона транспортного средства - преступнику присваивается 1-й уровень розыска;\nСтатья 4.2 - За угон транспортного средства - преступнику присваивается 2-ой уровень розыска;\n", "Закрыть", "", 0)
                        end
                        if list == 4 then
                            sampShowDialog(5713, "Уголовный кодекс", "\tГлава 5 'Психотропные/наркотические вещества'\nСтатья 5.1 - За хранение и/или перевозку наркотических средств - преступнику присваивается 5-ый уровень розыска, а так же изъятие наркотических средств;\nСтатья 5.2 - За сбыт наркотических средств - преступнику присваивается 6-ый уровень розыска и изъятие наркотических средств;\n", "Закрыть", "", 0)
                        end
                        if list == 5 then
                            sampShowDialog(5713, "Уголовный кодекс", "\tГлава 6 'Проникновение за закрытую/охраняемую территорию'\nСтатья 6.1 - За проникновение на секретную, либо охраняемую органами правопорядка территорию\nс целью кражи техники, либо боеприпасов или с иной противоправной целью - преступнику присваивается 3-ый уровень розыска;\nПримечание: Касается всех гос. структур;\nПримечание: Все преступники, проникшие на закрытую и/или охраняемую\nтерриторию [режимную], могут быть уничтожены охраной данного объекта;\n", "Закрыть", "", 0)
                        end
                        if list == 6 then
                            sampShowDialog(5713, "Уголовный кодекс", "\tГлава 7 'Коррупция'\nСтатья 7.1 - За предложение взятки должностному лицу - преступнику присваивается 3-ой уровень розыска;\nСтатья 7.2 - За выдачу взятку должностному лицу - преступнику присваивается 4-ый уровень розыска;\nСтатья 7.3 - За выдачу взятки должностному лицу в крупном размере - преступнику присваивается 5-ый уровень розыска;\nПримечание: К крупному размеру взятки относится взятка в размере '100.000$'\nСтатья 7.4 - За взятие взятки должностным лицом - государственному сотруднику\nприсваивается 5-й уровень розыска, после чего идёт увольнение и занесение в Чёрный Список\nгосударственных организаций;\nСтатья 7.5 - За взятие взятки должностным лицом в крупном размере - государственному сотруднику\nприсваивается 6-ой уровень розыска, после чего идёт увольнение и занесение в Чёрный список государственных организаций;", "Закрыть", "", 0)
                        end
                        if list == 7 then
                            sampShowDialog(5713, "Уголовный кодекс", "\tГлава 8 'Взятие в заложники'\nСтатья 8.1 - За взятие одного или группы заложников - преступнику присваивается 6-ой уровень\nрозыска и штраф в размере 100% суммы запрашиваемого выкупа;\n", "Закрыть", "", 0)
                        end
                        if list == 8 then
                            sampShowDialog(5713, "Уголовный кодекс", "\tГлава 9 'Терроризм'\nСтатья 9.1 - За планирование, либо совершения теракта - преступнику присваивается\n6-ой уровень розыска, лишение всех лицензии;\nСтатья 9.2 - За заведомо ложное сообщение об акте терроризма - преступнику присваивается 3-ий уровень розыска;\n", "Закрыть", "", 0)
                        end
                        if list == 9 then
                            sampShowDialog(5713, "Уголовный кодекс", "\tГлава 10 'Соучастие в преступление'\nСтатья 10.1 - За соучастие в преступлении - преступнику присваивается присваивается\nтот же уровень розыска, что и преступник;\nCтатья 10.2 - За воспрепятствование действиям сотрудника правоохранительных\nорганов - гражданину присваивается 3-ой уровень розыска;\n", "Закрыть", "", 0)
                        end
                        if list == 10 then
                            sampShowDialog(5713, "Уголовный кодекс", "\tГлава 11 'Использование государственного имущества'\nСтатья 11.1 - За подделку документов, удостоверений, значков государственных организаций, а равно их покупка,\nпродажа и применение в личных целях - преступнику присваивается 3-ой уровнями розыска;\n", "Закрыть", "", 0)
                        end
                        if list == 11 then
                            sampShowDialog(5713, "Уголовный кодекс", "\tГлава 12 'Хулиганство'\nСтатья 12.1 - За хулиганство или порчу имущества гражданских лиц, государственных\nорганизаций - преступнику присваивается 2-ой уровень розыска;\nСтатья 12.2 - За оскорбление гражданина - преступнику присваивается 1-ой уровень розыска;\nСтатья 12.3 - За оскорбление государственного сотрудника - преступнику присваивается 3-й уровень розыска;\n", "Закрыть", "", 0)
                        end
                        if list == 12 then
                            sampShowDialog(5713, "Уголовный кодекс", "\tГлава 13 'Шантаж'\nСтатья 13.1 - За угрозу компрометирующих или клеветнический разоблачений\nс целью вымогательства чужого имущества или разного рода уступок - преступнику присваивается 4-й уровень розыска;\n", "Закрыть", "", 0)
                        end
                    end
                end
                local result, button, list, input = sampHasDialogRespond(2002)
                if result then
                    if button == 1 then
                        if list == 0 then
                            sampShowDialog(2001, "{FFA500}Тестовое меню", string.format("{FFFFFF}1. Звук рации.\n2. Помощь 99.\n3. Помощь ЛС (Шоссе).\n4. Помощь AIR.\n5. Помощь (Погоня).\n6. CODE 3.\n7. 10-4.\n8. Помощь SWAT.\n9. CODE 4."), "Выбрать", "Отмена", 2)
                        end
                        if list == 1 then
                            os.execute('explorer "https://vk.com/im"')
                        end
                        if list == 2 then
                            sampShowDialog(5713, "Помощь по командам", "1. /lecture - меню лекций\n2. /sound - меню звуков\n3. /login - авторизация в скрипте\n4. /panel - админ-панель", "Закрыть", "", 0)
                        end
                        if list == 3 then
                            sampShowDialog(5714, "Уголовный кодекс", string.format("{FFFFFF}1. Глава 1.\n2. Глава 2.\n3. Глава 3.\n4. Глава 4.\n5. Глава 5.\n6. Глава 6.\n7. Глава 7.\n8. Глава 8.\n9. Глава 9.\n10. Глава 10.\n11. Глава 11.\n12. Глава 12.\n13. Глава 13."), "Выбрать", "Отмена", 2)
                        end
                        if list == 4 then
                            sampShowDialog(5713, "Административный кодекс", "1. /lecture - меню лекций\n2. /sound - меню звуков\n3. /login - авторизация в скрипте\n4. /panel - админ-панель", "Закрыть", "", 0)
                        end
                    end
                end
            end
        end

        function login()
            if isPlayerLoggedIn then
                -- Выдать сообщение, что игрок уже авторизован
                sampAddChatMessage('[PoliceRadio]: {FFFFFF}Вы уже авторизованы в КПК!', 0xFFFF0000)
            else
                -- Показать диалог авторизации
                sampShowDialog(5712, "Авторизация", 'Имя пользователя: admin\n\tВведите пароль', "Войти", "Отмена", 3)
                sampSendChat('/me сняв КПК с пояса, вводит данные для входа')
                lua_thread.create(mainhelper)
            end
        end
        
        function mainhelper()
            while sampIsDialogActive() do
                wait(0)
                local result, button, list, input = sampHasDialogRespond(5712)
                if result and button == 1 and input == '123123' then
                    -- Авторизация успешна
                    sampAddChatMessage('[PoliceRadio]: {FFFFFF}Вы {00FF00}успешно {FFFFFF}авторизовались в КПК!', 0xFF00FA9A)
                    isPlayerLoggedIn = true -- Установить флаг авторизации
                    playSound(accept)
                    sampSendChat('/me введя верный пароль, авторизовался в КПК')
                elseif result and button == 1 and input ~= '123123' then
                    -- Неверный пароль
                    sampAddChatMessage('[PoliceRadio]: {FFFFFF}Вы ввели {FF0000}неверный {FFFFFF}пароль!', 0xFFFF0000)
                    sampShowDialog(5712, "Авторизация", 'Имя пользователя: admin\n\tВведите пароль', "Войти", "Отмена", 3)
                elseif result and button == 1 and input == '' then
                    -- Пароль не введен
                    sampAddChatMessage('[PoliceRadio]: {FFFFFF}Введите пароль для входа!', 0xFFFF0000)
                    sampShowDialog(5712, "Авторизация", 'Имя пользователя: admin\n\tВведите пароль', "Войти", "Отмена", 3)
                end
            end
        end

        function playSound(sound)
            setAudioStreamState(sound, as_action.PLAY)
            setAudioStreamVolume(sound, 15)
        end

        function about()
            sampShowDialog(2000, "{FFA500}Информация о тулсе", string.format("{FFFFFF}1. О тулсе.\n2. Проекты.\n3. Важные ссылки.\n4. Разработчик тулса."), "Выбрать", "Отмена", 2)
        end

        function testsound()
            if isPlayerLoggedIn then
                sampShowDialog(2001, "{FFA500}Тестовое меню", string.format("{FFFFFF}1. Звук рации.\n2. Помощь 99.\n3. Помощь ЛС (Шоссе).\n4. Помощь AIR.\n5. Помощь (Погоня).\n6. CODE 3.\n7. 10-4.\n8. Помощь SWAT.\n9. CODE 4.\n10. Мегафон 1.\n11. Мегафон 2.\n12. Мегафон 3."), "Выбрать", "Отмена", 2)
            else
                -- Показать диалог авторизации
                sampAddChatMessage('[PoliceRadio]: {FFFFFF}Вы не {FF0000}авторизованы{ffffff} в КПК! Введите {00FFFF}/login {ffffff}для авторизации.', 0xFFFF0000)
            end
        end

        function kpk()
            if isPlayerLoggedIn then
                sampShowDialog(2002, "{FFA500}мини-КПК", string.format("{FFFFFF}1. Все звуки.\n2. Открыть мой VK.\n3. Помощь по командам.\n4. Уголовный Кодекс.\n5. Административный Кодекс."), "Выбрать", "Отмена", 2)
                sampSendChat('/me вошел в главное меню КПК')
            else
                -- Показать диалог авторизации
                sampAddChatMessage('[PoliceRadio]: {FFFFFF}Вы не {FF0000}авторизованы{ffffff} в панель! Введите {00FFFF}/login {ffffff}для авторизации.', 0xFFFF0000)
            end
        end