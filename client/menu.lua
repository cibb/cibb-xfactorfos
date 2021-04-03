local isJudge = false
local isMenuOpen = false
ESX = nil
-- -------------------------------------------------------------
-- |                  EVENTS HANDLER                           |
-- -------------------------------------------------------------
RegisterNetEvent('cibb-xfactorfos:youAreAJudge')
AddEventHandler('cibb-xfactorfos:youAreAJudge', function()    
    isJudge = true
end)

-- -------------------------------------------------------------
-- |                       MENUS                               |
-- -------------------------------------------------------------
Citizen.CreateThread(function()
    TriggerServerEvent("cibb-xfactorfos:AmIAJudge",GetPlayerServerId(PlayerId()))

    while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

    local waitTime = 1000
    local showNotification = false;

    while true do           
        if isJudge then
            local inRange = GetInteriorFromEntity(GetPlayerPed(-1)) == Config.screen.interiorId and GetKeyForEntityInRoom(GetPlayerPed(-1)) == Config.screen.roomId            

            if inRange then
                if showNotification then
                    print("Sent")
                    BeginTextCommandThefeedPost("STRING")
                    AddTextComponentSubstringPlayerName(Locales[Config.Locale]["press_e_to_open_menu"])
                    EndTextCommandThefeedPostTicker(true, true)
                    showNotification = false
                end
                waitTime = 0
                if not isMenuOpen then
                    -- DrawText3D(vector3(Config.screen.coords.x,Config.screen.coords.y,Config.screen.coords.z), Locales[Config.Locale]["press_e_to_open_menu"] , 255, 255, 255, 0.25)
                    if IsControlJustReleased(0, 38) then
                        openJudgeMenu()
                    end
                end
            else                
                waitTime = 1000
                showNotification = true
            end
        end
        Wait(waitTime)
    end
end)

function openJudgeMenu()
    isMenuOpen = true

    local elements = {
		{label = Locales[Config.Locale]["cta_press_x"],          value = 'x'},
		{label = Locales[Config.Locale]["cta_press_golden"],     value = 'gold'},
		{label = Locales[Config.Locale]["cta_press_reset"],      value = 'reset'},
	}

    ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'judge_actions', {
		title    = Locales[Config.Locale]["judge_menu_tile"],
		align    = 'bottom-right',
		elements = elements
	}, function(data, menu)
        TriggerServerEvent('cibb-xfactorfos:pressButton', GetPlayerServerId(PlayerId()), data.current.value)
        isMenuOpen = false
        menu.close()
    end, function(data, menu)
        isMenuOpen = false
		menu.close()
	end)
end