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
    sampAddChatMessage('[PoliceRadio]: {FFFFFF}Скрипт был {00FF00}успешно {FFFFFF}загружен.', 0xFF00FA9A)
    sampAddChatMessage('[PoliceRadio]: {FFFFFF}Для открытия меню {FF1493}лекций{FFFFFF}, {40E0D0}/lecture{ffffff}.', 0xFF00FA9A)
    sampAddChatMessage('[PoliceRadio]: {FFFFFF}О тулсе, {32CD32}/about{ffffff}.', 0xFF00FA9A)
    sampRegisterChatCommand("lecture", function() sampShowDialog(1999, "{0633E5}Меню лекций", string.format("{FFFFFF}1.Объявление в розыск.\n2.Правило Миранды.\n3.Изьятие запрещенных веществ.\n4.Рация.\n5.Уважительное общение с гражданскими.\n6.Субординация.\n7.Правила строя.\n8.''Огнестрельное оружие.\n9.Федеральное постановление.\n10.Правила сна.\n11.Обеденный перерыв."), "Выбрать", "Отмена", 2) end)
    sampRegisterChatCommand("testsound", testsound)
    sampRegisterChatCommand("about", about)
    sampRegisterChatCommand('login', login)
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
                    end
                end
            end
        end
        function login()
            if isPlayerLoggedIn then
                -- Выдать сообщение, что игрок уже авторизован
                sampAddChatMessage('[PoliceRadio]: {FFFFFF}Вы уже авторизованы в админ-панели!', 0xFFFF0000)
            else
                -- Показать диалог авторизации
                sampShowDialog(5712, "Авторизация", "Введите пароль", "Войти", "Отмена", 3)
                lua_thread.create(mainhelper)
            end
        end
        
        function mainhelper()
            while sampIsDialogActive() do
                wait(0)
                local result, button, list, input = sampHasDialogRespond(5712)
                if result and button == 1 and input == '123123' then
                    -- Авторизация успешна
                    sampAddChatMessage('[PoliceRadio]: {FFFFFF}Вы {00FF00}успешно {FFFFFF}авторизовались!', 0xFF00FA9A)
                    isPlayerLoggedIn = true -- Установить флаг авторизации
                    playSound(accept)
                elseif result and button == 1 and input ~= '123123' then
                    -- Неверный пароль
                    sampAddChatMessage('[PoliceRadio]: {FFFFFF}Вы ввели {FF0000}неверный {FFFFFF}пароль!', 0xFFFF0000)
                    sampShowDialog(5712, "Авторизация", "Введите пароль", "Войти", "Отмена", 3)
                elseif result and button == 1 and input == '' then
                    -- Пароль не введен
                    sampAddChatMessage('[PoliceRadio]: {FFFFFF}Введите пароль для входа!', 0xFFFF0000)
                    sampShowDialog(5712, "Авторизация", "Введите пароль", "Войти", "Отмена", 3)
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
                sampShowDialog(2001, "{FFA500}Тестовое меню", string.format("{FFFFFF}1. Звук рации.\n2. Помощь 99.\n3. Помощь ЛС (Шоссе).\n4. Помощь AIR.\n5. Помощь (Погоня).\n6. CODE 3.\n7. 10-4.\n8. Помощь SWAT.\n9. CODE 4."), "Выбрать", "Отмена", 2)
            else
                -- Показать диалог авторизации
                sampAddChatMessage('[PoliceRadio]: {FFFFFF}Вы не {FF0000}авторизованы{ffffff} в админ-панель! Введите {00FFFF}/login {ffffff}для авторизации.', 0xFFFF0000)
            end
        end