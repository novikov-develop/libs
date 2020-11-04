script_name("Mafia Helper") -- Обозвал скрипт
script_version("0.1b") -- Выдал ему версию
script_description("Помощник для Мафий Arizona Role Play") -- Типо описание сделал ему
script_author("novikov") -- Это я - автор


require "lib.moonloader" -- Подключил мунлоадер

local dlstatus = require('moonloader').download_status
local keys = require "vkeys" -- подключил нажатие клавиш
local inicfg = require "inicfg" -- включил ini cfg
local imgui = require "imgui" -- включил imgui 
local sampev = require "lib.samp.events" -- включил samp events
local notify = import "lib_imgui_notf.lua" -- подключил плагин оповещений 
local encoding = require "encoding" -- включил енкодинг хуйни
encoding.default = "CP1251"
u8 = encoding.UTF8

update_state = false

local tag = ("{FFF000}MafiaHelper: ")

local script_version = 1
local script_version_text = "1"

local update_url = "https://raw.githubusercontent.com/novikov-develop/mafia_helper/main/update.ini" -- ссылку на update.ini 
local update_path = getWorkingDirectory() .. "/config/update.ini" -- путь к файлу

local script_url = "https://github.com/novikov-develop/mafia_helper/blob/main/MafiaHelper.luac?raw=true" -- ссылка на ласт версию
local script_path = thisScript().path





function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(100) end
    
    sampRegisterChatCommand("update", cmd_update)

    sampAddChatMessage(tag.. "успешно загружен. Помощь: /mhelp", -1)

	_, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
    nick = sampGetPlayerNickname(id)

    downloadUrlToFile(update_url, update_path, function(id, status)
        if status == dlstatus.STATUS_ENDDOWNLOADDATA then
            updateIni = inicfg.load(nil, update_path)
            if tonumber(updateIni.info.vers) > script_vers then
                sampAddChatMessage("Есть обновление! Версия: " .. updateIni.info.vers_text, -1)
                update_state = true
            end
            os.remove(update_path)
        end
    end)
    
	while true do
        wait(0)

        if update_state then
            downloadUrlToFile(script_url, script_path, function(id, status)
                if status == dlstatus.STATUS_ENDDOWNLOADDATA then
                    sampAddChatMessage("Скрипт успешно обновлен!", -1)
                    thisScript():reload()
                end
            end)
            break
        end

	end
end

function getGenderBySkinId(skinId)
	local skins = {male = {0, 1, 2, 3, 4, 5, 6, 7, 8, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 32, 33, 34, 35, 36, 37, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 57, 58, 59, 60, 61, 62, 66, 67, 68, 70, 71, 72, 73, 78, 79, 80, 81, 82, 83, 84, 86, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 132, 133, 134, 135, 136, 137, 142, 143, 144, 146, 147, 149, 153, 154, 155, 156, 158, 159, 160, 161, 162, 163, 164, 165, 166, 167, 168, 170, 171, 173, 174, 175, 176, 177, 179, 180, 181, 182, 183, 184, 185, 186, 187, 188, 189, 200, 202, 203, 204, 206, 208, 209, 210, 212, 213, 217, 220, 221, 222, 223, 227, 228, 229, 230, 234, 235, 236, 239, 240, 241, 242, 247, 248, 249, 250, 252, 253, 254, 255, 258, 259, 260, 261, 262, 264, 265, 266, 267, 268, 269, 270, 271, 272, 273, 274, 275, 276, 277, 278, 279, 280, 281, 282, 283, 284, 285, 286, 287, 288, 289, 290, 291, 292, 293, 294, 295, 296, 297, 299, 300, 301, 302, 303, 304, 305, 310, 311},
	female = {9, 10, 11, 12, 13, 31, 38, 39, 40, 41, 53, 54, 55, 56, 63, 64, 65, 69, 75, 76, 77, 85, 87, 88, 89, 90, 91, 92, 93, 129, 130, 131, 138, 139, 140, 141, 145, 148, 150, 151, 152, 157, 169, 172, 178, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199, 201, 205, 207, 211, 214, 215, 216, 218, 219, 224, 225, 226, 231, 232, 233, 237, 238, 243, 244, 245, 246, 251, 256, 257, 263, 298, 306, 307, 308, 309}}
	for k, v in pairs(skins) do
		for m, n in pairs(v) do
			if n == skinId then
				return k
			end
		end
	end
	return "Skin not found"
end

function cmd_invite(id_player)
    local id = string.match(id_player, "(%d+)")
    if id ~= nil then
        if sampIsPlayerConnected(id) then
            local name, surname = sampGetPlayerNickName(id):match("(.+)_(.+)")
            lua_thread.create(function()
                if getGenderBySkinId(getCharModel(PLAYER_PED)) == "male" then
                    sampSendChat("Я мужчина")
            elseif getGenderBySkinId(getCharModel(PLAYER_PED)) == "female" then
                    sampSendChat("Я женщина")
                end
            wait(100)
            sampSendChat("/invite ".. id)
            wait(3000)
            sampSendChat("/f В наш ресторан принят новый сотрудник "..name.." "..surname)
            end)
        end
    else notify.addNotify("{FF0000}Ошибка", "{FFFFFF}Используй: {FFF000}/invite id", 2, 2, 6)
    end
end

function cmd_update(arg)
    sampShowDialog(1000, "Автообновление v2.0", "{FFFFFF}Это урок по обновлению\n{FFF000}Новая версия", "Закрыть", "", 0)
end