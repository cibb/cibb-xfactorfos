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

    while true do        
        if isJudge then
            local object, distance = getDesk()

            if distance and distance < 2.5 then
                if not isMenuOpen then
                    DrawText3D(GetEntityCoords(object), Locales[Config.Locale]["press_e_to_open_menu"] , 255, 255, 255, 0.25)
                    if IsControlJustReleased(0, 38) then
                        openJudgeMenu()
                    end
                end
            end
        end
        Wait(0)
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

function getDesk()
    local object, distance
	local coords = GetEntityCoords(GetPlayerPed(-1))

    object = GetClosestObjectOfType(coords, 3.0, GetHashKey("v_62_ecolacup003"), false, false, false)
    distance = #(coords - GetEntityCoords(object))
    if distance < 5 then
        return object, distance
    end

	return nil, nil
end