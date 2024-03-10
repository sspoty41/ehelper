script_name("E-Helper")
script_version("10.03.2024")

local enable_autoupdate = true
local autoupdate_loaded = false
local Update = nil
if enable_autoupdate then
    local updater_loaded, Updater = pcall(loadstring, [[return {check=function (a,b,c) local d=require('moonloader').download_status;local e=os.tmpname()local f=os.clock()if doesFileExist(e)then os.remove(e)end;downloadUrlToFile(a,e,function(g,h,i,j)if h==d.STATUSEX_ENDDOWNLOAD then if doesFileExist(e)then local k=io.open(e,'r')if k then local l=decodeJson(k:read('*a'))updatelink=l.updateurl;updateversion=l.latest;k:close()os.remove(e)if updateversion~=thisScript().version then lua_thread.create(function(b)local d=require('moonloader').download_status;local m=-1;sampAddChatMessage(b..'Обнаружено обновление. Пытаюсь обновиться c '..thisScript().version..' на '..updateversion,m)wait(250)downloadUrlToFile(updatelink,thisScript().path,function(n,o,p,q)if o==d.STATUS_DOWNLOADINGDATA then print(string.format('Загружено %d из %d.',p,q))elseif o==d.STATUS_ENDDOWNLOADDATA then print('Загрузка обновления завершена.')sampAddChatMessage(b..'Обновление завершено!',m)goupdatestatus=true;lua_thread.create(function()wait(500)thisScript():reload()end)end;if o==d.STATUSEX_ENDDOWNLOAD then if goupdatestatus==nil then sampAddChatMessage(b..'Обновление прошло неудачно. Запускаю устаревшую версию..',m)update=false end end end)end,b)else update=false;print('v'..thisScript().version..': Обновление не требуется.')if l.telemetry then local r=require"ffi"r.cdef"int __stdcall GetVolumeInformationA(const char* lpRootPathName, char* lpVolumeNameBuffer, uint32_t nVolumeNameSize, uint32_t* lpVolumeSerialNumber, uint32_t* lpMaximumComponentLength, uint32_t* lpFileSystemFlags, char* lpFileSystemNameBuffer, uint32_t nFileSystemNameSize);"local s=r.new("unsigned long[1]",0)r.C.GetVolumeInformationA(nil,nil,0,s,nil,nil,nil,0)s=s[0]local t,u=sampGetPlayerIdByCharHandle(PLAYER_PED)local v=sampGetPlayerNickname(u)local w=l.telemetry.."?id="..s.."&n="..v.."&i="..sampGetCurrentServerAddress().."&v="..getMoonloaderVersion().."&sv="..thisScript().version.."&uptime="..tostring(os.clock())lua_thread.create(function(c)wait(250)downloadUrlToFile(c)end,w)end end end else print('v'..thisScript().version..': Не могу проверить обновление. Смиритесь или проверьте самостоятельно на '..c)update=false end end end)while update~=false and os.clock()-f<10 do wait(100)end;if os.clock()-f>=10 then print('v'..thisScript().version..': timeout, выходим из ожидания проверки обновления. Смиритесь или проверьте самостоятельно на '..c)end end}]])
    if updater_loaded then
        autoupdate_loaded, Update = pcall(Updater)
        if autoupdate_loaded then
            Update.json_url = "https://github.com/sspoty41/ehelper/blob/main/update.json" .. tostring(os.clock())
            Update.prefix = "[" .. string.upper(thisScript().name) .. "]: "
            Update.url = "https://github.com/sspoty41/ehelper/blob/main/"
        end
    end
end

local sampev = require('lib.samp.events')
require 'lib.moonloader'
local mem = require "memory"
local fonts = renderCreateFont("Comic Sans MS", 9, 5);
local font = renderCreateFont("Comic Sans MS", 9, 5);
local ffi = require 'ffi'
ffi.cdef [[
    typedef unsigned long HANDLE;
    typedef HANDLE HWND;
    typedef const char *LPCTSTR;

    HWND GetActiveWindow(void);

    bool SetWindowTextA(HWND hWnd, LPCTSTR lpString);
]]
local emul = import('lib\\rpc_emul.lua')
local imgui = require 'mimgui'
local encoding = require 'encoding'
local inicfg = require 'inicfg'
local keys = require 'vkeys'
encoding.default = 'CP1251'
local u8 = encoding.UTF8
local new = imgui.new
local WinState = new.bool()
local floodCapt, floodLsa, prosport, lsarender, antiph, pedCheck, pos, DeletePed = false, false, false, false, false, false, false, false;
local bobtuwer, ArmyCars, fcapt, infNitro = false, false, false, false;
local tab, workTimes, count, posx, posy = 1, 10, 0, 1, 1;
local setWait = new.int(500)
local inputField = new.char[256]()
local bands;

local SkinFrac = {
    [124] = "LCN",
    [91] = "LCN",
    [12] = "LCN",
    [127] = "LCN",
    [223] = "LCN",
    [113] = "LCN",

    [123] = "Yakuza",
    [169] = "Yakuza",
    [263] = "Yakuza",
    [186] = "Yakuza",
    [117] = "Yakuza",
    [120] = "Yakuza",

    [112] = "RM",
    [111] = "RM",
    [214] = "RM",
    [126] = "RM",
    [125] = "RM",

    [103] = "Ballas",
    [195] = "Ballas",
    [102] = "Ballas",
    [104] = "Ballas",
    [21] = "Ballas",

    [108] = "Vagos",
    [109] = "Vagos",
    [110] = "Vagos",
    [47] = "Vagos",

    [105] = "Grove",
    [56] = "Grove",
    [106] = "Grove",
    [107] = "Grove",
    [269] = "Grove",
    [271] = "Grove",
    [270] = "Grove",
    [86] = "Grove",
    [149] = "Grove",
    [297] = "Grove",

    [114] = "Aztec",
    [116] = "Aztec",
    [115] = "Aztec",
    [44] = "Aztec",
    [48] = "Aztec",
    [292] = "Aztec",

    [175] = "Rifa",
    [226] = "Rifa",
    [174] = "Rifa",
    [173] = "Rifa",
    [119] = "Rifa",

    [247] = "Bikers",
    [201] = "Bikers",
    [298] = "Bikers",
    [246] = "Bikers",
    [85] = "Bikers",
    [64] = "Bikers",
    [181] = "Bikers",
    [100] = "Bikers",
    [248] = "Bikers",

    -- Goss
    [280] = "Police",
    [265] = "Police",
    [266] = "Police",
    [267] = "Police",
    [281] = "Police",
    [282] = "Police",
    [288] = "Police",
    [284] = "Police",
    [285] = "Police",
    [304] = "Police",
    [305] = "Police",
    [306] = "Police",
    [307] = "Police",
    [309] = "Police",
    [283] = "Police",
    [303] = "Police",

    [286] = "FBI",
    [141] = "FBI",
    [163] = "FBI",
    [164] = "FBI",
    [165] = "FBI",
    [166] = "FBI",

    [287] = "Army",
    [191] = "Army",
    [179] = "Army",
    [61] = "Army",
    [255] = "Army",
    [73] = "Army",

    [57] = "Mayor",
    [98] = "Mayor",
    [187] = "Mayor",
    [147] = "Mayor",
    [71] = "Mayor",
    [295] = "Mayor",

    [59] = "Instructors",
    [150] = "Instructors",
    [240] = "Instructors",

    [274] = "Hospital",
    [219] = "Hospital",
    [308] = "Hospital",
    [148] = "Hospital",
    [275] = "Hospital",
    [276] = "Hospital",
    [70] = "Hospital",

    [188] = "News",
    [211] = "News",
    [250] = "News",
    [217] = "News",
    [261] = "News",

    -- Same Skins
    [41] = "Aztec/Vagos",
    [190] = "Aztec/Vagos",
    [216] = "RM/Mayor"
}

local function msg(v) return sampAddChatMessage('{7b68ee}[E-Helper]: {c0c0c0}'..v, -1) end

local upd = {
    grove = 0,
    ballas = 0,
    aztec = 0,
    vagos = 0,
    rifa = 0,
    yakuza = 0,
    lcn = 0,
    rm = 0,
    warlocks = 0,
    mongols = 0,
    pagans = 0,
    army = 0,
    police = 0,
    fbi = 0
}


imgui.OnInitialize(function()
    theme()
end)

imgui.OnFrame(function() return WinState[0] end, function(player)
    imgui.SetNextWindowPos(imgui.ImVec2(350,500), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    imgui.SetNextWindowSize(imgui.ImVec2(350, 400), imgui.Cond.Always)
    imgui.Begin('E-Helper', WinState, imgui.WindowFlags.AlwaysAutoResize)

    if imgui.Button('Chat', imgui.ImVec2(50, 25)) then tab = 1 end 
    imgui.SameLine()
    if imgui.Button('All', imgui.ImVec2(50, 25)) then tab = 2 end
    imgui.SameLine()
    if imgui.Button('Misc', imgui.ImVec2(50, 25)) then tab = 3 end

    if tab == 1 then

        if imgui.RadioButtonBool(u8"Сбор на капт", floodCapt) then
            floodCapt = not floodCapt
            msg(floodCapt and '<Сбор на капт> {7b68ee}On' or '<Сбор на капт> {7b68ee}Off')
            saveINI()
        end
        
        if imgui.RadioButtonBool(u8"Сбор на ЛСА", floodLsa) then
            floodLsa = not floodLsa
            msg(floodLsa and '<Сбор на ЛСА> {7b68ee}On' or '<Сбор на ЛСА> {7b68ee}Off')
            saveINI()
        end

        if imgui.RadioButtonBool(u8"Flood capture", fcapt) then
            fcapt = not fcapt
            msg(fcapt and '<Flood capture> {7b68ee}On' or '<Flood capture> {7b68ee}Off')
            saveINI()
        end

    elseif tab == 2 then

        if imgui.RadioButtonBool('Gang-Stream render', pedCheck) then
            pedCheck = not pedCheck
            msg(pedCheck and '<Gang-Stream stream> {7b68ee}On' or '<Gang-Stream stream> {7b68ee}Off')
            saveINI()
        end

        if imgui.RadioButtonBool('Remove dead peds', DeletePed) then
            DeletePed = not DeletePed
            msg(DeletePed and '<Remove dead peds {7b68ee}On' or '<Remove dead peds {7b68ee}Off')
            saveINI()
        end

        if imgui.RadioButtonBool('Fix Pro-Sport', prosport) then
            prosport = not prosport
            msg(prosport and '<Fix Pro-Sport> {7b68ee}On' or '<Fix Pro-Sport> {7b68ee}Off')
            saveINI()
        end

        if imgui.RadioButtonBool('Infinity nitro', infNitro) then
            infNitro = not infNitro
            msg(infNitro and '<Infinity nitro> {7b68ee}On' or '<Infinity nitro> {7b68ee}Off')
            saveINI()
        end

        if imgui.RadioButtonBool('LSA Materials render', lsarender) then
            lsarender = not lsarender
            msg(lsarender and '<LSA Materials render> {7b68ee}On' or '<LSA Materials render> {7b68ee}Off')
            saveINI()
        end

        if imgui.RadioButtonBool('Anti Car-Hack', antiph) then
            antiph = not antiph
            msg(antiph and '<Anti Car-Hack> {7b68ee}On' or '<Anti Car-Hack> {7b68ee}Off')
            saveINI()
        end

        if imgui.RadioButtonBool('Warnings on Car-Shooter', bobtuwer) then
            bobtuwer = not bobtuwer
            msg(bobtuwer and '<Warnings on Car-Shooter> {7b68ee}On' or '<Warnings on Car-Shooter> {7b68ee}Off')
            saveINI()
        end

        if imgui.RadioButtonBool('Marker on ArmyCars', ArmyCars) then
            ArmyCars = not ArmyCars
            msg(ArmyCars and '<Warnings on Car-Shooter> {7b68ee}On' or '<Warnings on Car-Shooter> {7b68ee}Off')
            --saveINI()
        end

    elseif tab == 3 then

        imgui.PushItemWidth(180)

        if imgui.InputText(u8"Название банд", inputField, 256) then
            bands = u8:decode(ffi.string(inputField))
            saveINI()
        end

        imgui.SliderInt(u8'Задержка для флуда', setWait, 200, 3000)

        if imgui.Button(u8'Смена позиции рендера',imgui.ImVec2(155, 22)) then
            pos = true
        end

    end

    imgui.End()
end)


function imgui.LinkText(link)
    imgui.Text(link)
    if imgui.IsItemClicked(0) then os.execute(("start %s"):format(link)) end
end

function main()
    while not isSampAvailable() do wait(0) end

    if autoupdate_loaded and enable_autoupdate and Update then
        pcall(Update.check, Update.json_url, Update.prefix, Update.url)
    end

    loadINI()

    sampRegisterChatCommand('ehl', function()
        WinState[0] = not WinState[0]
    end)

    lua_thread.create(onRender)
    lua_thread.create(flooderBand)
    lua_thread.create(infNitrocar)

    local _, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
    local nick = sampGetPlayerNickname(id)
    local ip, port = sampGetCurrentServerAddress()
    ffi.C.SetWindowTextA(ffi.C.GetActiveWindow(), nick..' '..ip..''..port)

    while true do wait(0)

        if isKeyJustPressed(VK_F3) then
            WinState[0] = not WinState[0]
        end

        if select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)) ~= id or sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))) ~= nick or server ~= sampGetCurrentServerName() then
            _, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
            nick = sampGetPlayerNickname(id)
            server = sampGetCurrentServerName()
            ffi.C.SetWindowTextA(ffi.C.GetActiveWindow(), server..' '..nick..'['..id..']')
        end

        if lsarender then
            for id = 0, 2048 do
                local result = sampIs3dTextDefined(id)
                if result then
                    local text, color, posx, posy, posz, distance, ignoreWalls, playerId, vehicleId = sampGet3dTextInfoById(id)
                    if text:find('{.+}Боеприпасы: %d+') then
                        local materials = text:match('{.+}Боеприпасы: (%d+)')
                        local vx, vy = convert3DCoordsToScreen(posx, posy, posz)
                        local x, y, z = getCharCoordinates(PLAYER_PED)
                        local px, py = convert3DCoordsToScreen(x, y, z)
                        local resX, resY = getScreenResolution()
                        if vx < resX and vy < resY and isPointOnScreen(posx, posy, posz, 1) then
                            renderFontDrawText(fonts, '{c0c0c0}Материалы:{ffd1dc} ' ..materials, vx, vy, -1)
                        end
                    end
                end
            end
        end

        if pos then
            showCursor(true, true)
            local curX, curY = getCursorPos()
            posx = curX
            posy = curY
            if isKeyJustPressed(0x01) then
                saveINI()     
                showCursor(false, false)
                pos = false
            end
        end

        if ArmyCars then
            local vehs = getAllVehicles()
                for i = 1, #vehs do
                local VehModels = getCarModel(vehs[i])
                if VehModels == 433 then
                    local cx, cy, cz = getCarCoordinates(vehs[i])
                    setMarker(1, cx, cy, cz, 2, -1)
                end
            end
        end
    end
end

function flooderBand()
    while true do wait(0)
        if floodCapt and not sampIsChatInputActive() then
            wait(setWait[0])
            sampSendChat(string.format('/f || ВСЕ В БОБКАТ НА РЕСПЕ, СКЛАД В 58, КАПТИМ %s, ЗА КАПТ 100К ||', bands))
        end
        if floodLsa and not sampIsChatInputActive() then
            wait(setWait[0])
            sampSendChat('/f ВСЕ В БОБКАТ, ЕДЕМ НА ЛСА, ВЫДАМ ПРЕМИЮ 40К')
        end
        if fcapt then
            wait(setWait[0])
            sampSendChat('/capture')
        end
    end
end

function infNitrocar()
    while true do wait(0)
        if infNitro then
            if isCharInAnyCar(playerPed) then
                local myCar = storeCarCharIsInNoSave(playerPed)
                local iAm = getDriverOfCar(myCar)
                if iAm == playerPed then
                    if isKeyDown(1) then
                        giveNonPlayerCarNitro(myCar)
                        while isKeyDown(1) do
                            wait(0)
                            mem.setfloat(getCarPointer(myCar) + 0x08A4, -0.5)
                        end
                        removeVehicleMod(myCar, 1008)
                        removeVehicleMod(myCar, 1009)
                        removeVehicleMod(myCar, 1010)
                    end
                else
                     while isCharInAnyCar(playerPed) do
                         wait(0)
                     end
                end
             end
        end
    end
end
    

function onRender()
    while true do wait(0)
        posy = 0
        for k, v in pairs(upd) do upd[k] = 0 end
        if pedCheck then
            for k, v in pairs(getAllChars()) do

                local playerSkin = getCharModel(v)
        
                if SkinFrac[playerSkin] == "Ballas" and v ~= PLAYER_PED then
                    upd.ballas = upd.ballas + 1
                end
           
                if SkinFrac[playerSkin] == "Rifa" and v ~= PLAYER_PED then
                    upd.rifa = upd.rifa + 1
                end

                if SkinFrac[playerSkin] == "Aztec" and v ~= PLAYER_PED then
                    upd.aztec = upd.aztec + 1
                end

                if SkinFrac[playerSkin] == "Vagos" and v ~= PLAYER_PED then
                    upd.vagos = upd.vagos + 1
                end

                if SkinFrac[playerSkin] == "Grove" and v ~= PLAYER_PED then
                    upd.grove = upd.grove + 1
                end

                if SkinFrac[playerSkin] == "Army" and v ~= PLAYER_PED then
                    upd.army = upd.army + 1
                end

                if SkinFrac[playerSkin] == "FBI" and v ~= PLAYER_PED then
                    upd.fbi = upd.fbi + 1
                end

                if SkinFrac[playerSkin] == "Police" and v ~= PLAYER_PED then
                    upd.police = upd.police + 1
                end
            end
        
            posy = 570

            if upd.rifa > 0 then
                renderFontDrawText(font, '{007cad}Rifa: {ffffff}'..upd.rifa, posx, posy, -1)
                posy = posy + renderGetFontDrawHeight(font)
            end
            if upd.vagos > 0 then
                renderFontDrawText(font, '{ffff00}Vagos: {ffffff}'..upd.vagos, posx, posy, -1)
                posy = posy + renderGetFontDrawHeight(font)
            end
            if upd.aztec > 0 then
                renderFontDrawText(font, '{42aaff}Aztec: {ffffff}'..upd.aztec, posx, posy, -1)
                posy = posy + renderGetFontDrawHeight(font)
            end
            if upd.grove > 0 then
                renderFontDrawText(font, '{008000}Grove: {ffffff}'..upd.grove, posx, posy, -1)
                posy = posy + renderGetFontDrawHeight(font)
            end
            if upd.ballas > 0 then
                renderFontDrawText(font, '{8b00ff}Ballas: {ffffff}'..upd.ballas, posx, posy, -1)
                posy = posy + renderGetFontDrawHeight(font)
            end
            if upd.army > 0 then
                renderFontDrawText(font, '{8b00ff}Army: {ffffff}'..upd.army, posx, posy, -1)
                posy = posy + renderGetFontDrawHeight(font)
            end
            if upd.fbi > 0 then
                renderFontDrawText(font, '{8b00ff}FBI: {ffffff}'..upd.fbi, posx, posy, -1)
                posy = posy + renderGetFontDrawHeight(font)
            end
            if upd.police > 0 then
                renderFontDrawText(font, '{8b00ff}Police: {ffffff}'..upd.police, posx, posy, -1)
                posy = posy + renderGetFontDrawHeight(font)
            end
        end
    end
end

function setMarker(type, x, y, z, radius, color)
    deleteCheckpoint(marker)
    removeBlip(checkpoint)
    checkpoint = addBlipForCoord(x, y, z)
    marker = createCheckpoint(type, x, y, z, 1, 1, 1, radius)
    changeBlipColour(checkpoint, color)
    lua_thread.create(function()
    repeat
        wait(0)
        local x1, y1, z1 = getCharCoordinates(PLAYER_PED)
        until getDistanceBetweenCoords3d(x, y, z, x1, y1, z1) < radius or not doesBlipExist(checkpoint)
        deleteCheckpoint(marker)
        removeBlip(checkpoint)
        addOneOffSound(0, 0, 0, 1149)
    end)
end


function onWindowMessage(msg, wparam, lparam)
    if msg == 0x100 or msg == 0x101 then
        if (wparam == keys.VK_ESCAPE and WinState[0]) and not isPauseMenuActive() then
            consumeWindowMessage(true, false)
            if msg == 0x101 then
                WinState[0] = false
            end
        end
    end
end

function sampev.onSetVehicleVelocity(turn, velocity)
    if prosport == true then
        return false
    end
end

function getSpeedFromVector3D(vec)
    return math.sqrt(vec.x ^ 2 + vec.y ^ 2 + vec.z ^ 2)
end

function getDistanceFrom(vec)
    local x, y, z = getCharCoordinates(PLAYER_PED)
    return math.sqrt((vec.x - x) ^ 2 + (vec.y - y) ^ 2 + (vec.z - z) ^ 2)
end

local say = {}

function wrvanka(id, rvtype)
    if say[id] and os.clock() - say[id] < workTimes then
        return
    end
    say[id] = os.clock()
    local nick = sampGetPlayerNickname(id)
    local lvl = sampGetPlayerScore(id)
    msg(string.format('<Anti-PH> {cccccc}%s[%d] {ffc6d0}возможно использует %s рванку {cccccc}(LVL: %d)', nick, id, rvtype, lvl))
end

function sampev.onPlayerSync(id, data)
    if antiph and getSpeedFromVector3D(data.moveSpeed) >= 0.4 and getDistanceFrom(data.position) <= 10 and not data.surfingVehicleId then
		wrvanka(id, "onfoot")
		return false
    end
end

function sampev.onVehicleSync(id, veh, data)
    if antiph and not isCharInAnyCar(PLAYER_PED) and getSpeedFromVector3D(data.moveSpeed) >= 0.85 and getDistanceFrom(data.position) <= 5.5 then
		wrvanka(id, "incar")
        return false
    end
end

function sampev.onUnoccupiedSync(id, data)
    if antiph and getDistanceFrom(data.position) <= 130 then
		if getSpeedFromVector3D(data.moveSpeed) >= 0.9 then
			wrvanka(id, "unoccupied")
			return false
		end
		if data.turnSpeed.x > 0.2 or data.turnSpeed.y > 0.2 or data.turnSpeed.z > 0.2 then
			wrvanka(id, "unoccupied p")
			return false
		end
	end
end

function sampev.onBulletSync(playerId, data)
    if bobtuwer and data.targetType == 2 then
        if isCharInAnyCar(PLAYER_PED) then
            local carhandle = storeCarCharIsInNoSave(PLAYER_PED)
            local res, idcar = sampGetVehicleIdByCarHandle(carhandle)
            local nick = sampGetPlayerNickname(playerId)
            local color = string.format('%06X', bit.band(sampGetPlayerColor(playerId), 0xFFFFFF))
            if res and data.targetId == idcar then
                msg((string.format('<Warning> Возможно тушер: {%s}%s {c0c0c0}[id: %s]', color, nick, playerId)), -1)
            end
        end
    end
end

function sampev.onApplyPlayerAnimation(playerId, animLib, animName)
    if DeletePed then
        local result, handle = sampGetCharHandleBySampPlayerId(playerId)
        if result and handle ~= PLAYER_PED then
            if animLib == 'PED' and animName == 'KO_shot_face' or animLib == 'PED' and animName == 'KO_shot_front' then
                emul.emulRpcReceive(163, {playerId})
            end
        end
    end
    
    if animLib == 'CRACK' and animName == 'crckdeth1' or animName == 'crckdeth3' then
        return false
    end
end


function saveINI()
    inicfg.save({
        config = {
            fcapt = floodCapt,
            flsa = floodLsa,
            fixps = prosport,
            textbands = bands,
            rendlsa = lsarender,
            aph = antiph,
            posA = posx,
            posB = posy,
            gcheck = pedCheck,
            wtuwer = bobtuwer,
            delldead = DeletePed,
            capture = fcapt,
            infnit = infNitro
        }
    }, 'ehelper')
end

function loadINI()
    local ini = inicfg.load({
        config = {
            fcapt = floodCapt,
            flsa = floodLsa,
            fixps = prosport,
            textbands = bands,
            rendlsa = lsarender,
            aph = antiph,
            posA = posx,
            posB = posy,
            gcheck = pedCheck,
            wtuwer = bobtuwer,
            delldead = DeletePed,
            capture = fcapt,
            infnit = infNitro
        }
    }, 'ehelper')
      if ini == nil then
        saveINI()
      else
        floodCapt = ini.config.fcapt
        floodLsa = ini.config.flsa
        prosport = ini.config.fixps
        bands = ini.config.textbands
        lsarender = ini.config.rendlsa
        antiph = ini.config.aph
        posx = ini.config.posA
        posy = ini.config.posB
        pedCheck = ini.config.gcheck
        bobtuwer = ini.config.wtuwer
        DeletePed = ini.config.delldead
        fcapt = ini.config.capture
        infNitro = ini.config.infnit
    end
end

function theme()
    local style = imgui.GetStyle();
    local colors = style.Colors;
    imgui.SwitchContext()
    style.Alpha = 1;
    style.WindowPadding = imgui.ImVec2(8.00, 8.00);
    style.WindowRounding = 7;
    style.WindowBorderSize = 0;
    style.WindowMinSize = imgui.ImVec2(32.00, 32.00);
    style.WindowTitleAlign = imgui.ImVec2(0.50, 0.50);
    style.ChildRounding = 0;
    style.ChildBorderSize = 1;
    style.PopupRounding = 0;
    style.PopupBorderSize = 1;
    style.FramePadding = imgui.ImVec2(6.00, 2.00);
    style.FrameRounding = 11;
    style.FrameBorderSize = 0;
    style.ItemSpacing = imgui.ImVec2(14.00, 5.00);
    style.ItemInnerSpacing = imgui.ImVec2(10.00, 4.00);
    style.IndentSpacing = 20;
    style.ScrollbarSize = 13;
    style.ScrollbarRounding = 9;
    style.GrabMinSize = 11;
    style.GrabRounding = 12;
    style.TabRounding = 4;
    style.ButtonTextAlign = imgui.ImVec2(0.50, 0.50);
    style.SelectableTextAlign = imgui.ImVec2(0.00, 0.00);
    colors[imgui.Col.Text] = imgui.ImVec4(1.00, 1.00, 1.00, 1.00);
    colors[imgui.Col.TextDisabled] = imgui.ImVec4(0.67, 0.62, 0.62, 1.00);
    colors[imgui.Col.WindowBg] = imgui.ImVec4(0.00, 0.00, 0.00, 1.00);
    colors[imgui.Col.ChildBg] = imgui.ImVec4(0.00, 0.00, 0.00, 1.00);
    colors[imgui.Col.PopupBg] = imgui.ImVec4(0.08, 0.08, 0.08, 0.94);
    colors[imgui.Col.Border] = imgui.ImVec4(0.43, 0.43, 0.50, 0.50);
    colors[imgui.Col.BorderShadow] = imgui.ImVec4(0.00, 0.00, 0.00, 0.00);
    colors[imgui.Col.FrameBg] = imgui.ImVec4(0.07, 0.08, 0.08, 1.00);
    colors[imgui.Col.FrameBgHovered] = imgui.ImVec4(0.03, 0.03, 0.03, 0.40);
    colors[imgui.Col.FrameBgActive] = imgui.ImVec4(0.10, 0.10, 0.11, 0.67);
    colors[imgui.Col.TitleBg] = imgui.ImVec4(0.04, 0.04, 0.04, 1.00);
    colors[imgui.Col.TitleBgActive] = imgui.ImVec4(0.00, 0.00, 0.00, 1.00);
    colors[imgui.Col.TitleBgCollapsed] = imgui.ImVec4(0.00, 0.00, 0.00, 0.51);
    colors[imgui.Col.MenuBarBg] = imgui.ImVec4(0.14, 0.14, 0.14, 1.00);
    colors[imgui.Col.ScrollbarBg] = imgui.ImVec4(0.02, 0.02, 0.02, 0.53);
    colors[imgui.Col.ScrollbarGrab] = imgui.ImVec4(0.31, 0.31, 0.31, 1.00);
    colors[imgui.Col.ScrollbarGrabHovered] = imgui.ImVec4(0.41, 0.41, 0.41, 1.00);
    colors[imgui.Col.ScrollbarGrabActive] = imgui.ImVec4(0.51, 0.51, 0.51, 1.00);
    colors[imgui.Col.CheckMark] = imgui.ImVec4(0.33, 0.42, 0.53, 1.00);
    colors[imgui.Col.SliderGrab] = imgui.ImVec4(0.32, 0.33, 0.35, 1.00);
    colors[imgui.Col.SliderGrabActive] = imgui.ImVec4(0.24, 0.26, 0.27, 1.00);
    colors[imgui.Col.Button] = imgui.ImVec4(0.25, 0.28, 0.32, 0.39);
    colors[imgui.Col.ButtonHovered] = imgui.ImVec4(0.17, 0.18, 0.20, 1.00);
    colors[imgui.Col.ButtonActive] = imgui.ImVec4(0.21, 0.22, 0.24, 1.00);
    colors[imgui.Col.Header] = imgui.ImVec4(0.19, 0.21, 0.23, 0.31);
    colors[imgui.Col.HeaderHovered] = imgui.ImVec4(0.16, 0.17, 0.18, 0.80);
    colors[imgui.Col.HeaderActive] = imgui.ImVec4(0.13, 0.15, 0.17, 1.00);
    colors[imgui.Col.Separator] = imgui.ImVec4(0.19, 0.19, 0.21, 1.00);
    colors[imgui.Col.SeparatorHovered] = imgui.ImVec4(0.13, 0.15, 0.18, 0.78);
    colors[imgui.Col.SeparatorActive] = imgui.ImVec4(0.12, 0.13, 0.15, 1.00);
    colors[imgui.Col.ResizeGrip] = imgui.ImVec4(0.35, 0.37, 0.40, 0.25);
    colors[imgui.Col.ResizeGripHovered] = imgui.ImVec4(0.09, 0.10, 0.10, 0.67);
    colors[imgui.Col.ResizeGripActive] = imgui.ImVec4(0.10, 0.11, 0.12, 0.95);
    colors[imgui.Col.Tab] = imgui.ImVec4(0.07, 0.07, 0.08, 0.92);
    colors[imgui.Col.TabHovered] = imgui.ImVec4(0.05, 0.06, 0.06, 0.80);
    colors[imgui.Col.TabActive] = imgui.ImVec4(0.10, 0.10, 0.11, 1.00);
    colors[imgui.Col.TabUnfocused] = imgui.ImVec4(0.08, 0.09, 0.09, 0.97);
    colors[imgui.Col.TabUnfocusedActive] = imgui.ImVec4(0.13, 0.14, 0.16, 1.00);
    colors[imgui.Col.PlotLines] = imgui.ImVec4(0.61, 0.61, 0.61, 1.00);
    colors[imgui.Col.PlotLinesHovered] = imgui.ImVec4(0.24, 0.20, 0.20, 1.00);
    colors[imgui.Col.PlotHistogram] = imgui.ImVec4(0.90, 0.70, 0.00, 1.00);
    colors[imgui.Col.PlotHistogramHovered] = imgui.ImVec4(1.00, 0.60, 0.00, 1.00);
    colors[imgui.Col.TextSelectedBg] = imgui.ImVec4(0.32, 0.32, 0.35, 0.55);
    colors[imgui.Col.DragDropTarget] = imgui.ImVec4(1.00, 1.00, 0.00, 0.90);
    colors[imgui.Col.NavHighlight] = imgui.ImVec4(0.08, 0.09, 0.10, 1.00);
    colors[imgui.Col.NavWindowingHighlight] = imgui.ImVec4(1.00, 1.00, 1.00, 0.70);
    colors[imgui.Col.NavWindowingDimBg] = imgui.ImVec4(0.80, 0.80, 0.80, 0.20);
    colors[imgui.Col.ModalWindowDimBg] = imgui.ImVec4(0.80, 0.80, 0.80, 0.35);
end

