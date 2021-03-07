-- Internal vars, please don't touch!
local shouldLightsRun = false
local showGoldenX = false
local reason = ""
local xPressed = {}

-- -------------------------------------------------------------
-- |                  EVENTS HANDLER                           |
-- -------------------------------------------------------------
RegisterNetEvent('cibb-xfactorfos:xUpdate')
AddEventHandler('cibb-xfactorfos:xUpdate', function(serverXPressed)
    xPressed = serverXPressed
end)

RegisterNetEvent('cibb-xfactorfos:xPressed')
AddEventHandler('cibb-xfactorfos:xPressed', function(judgeId, button)   
    local xCount = 0
    for _ in pairs(xPressed) do xCount = xCount + 1 end

    if xCount == 3 then
        AllXBuzzer()
    else
        XBuzzer(judgeId)
    end
end)

RegisterNetEvent('cibb-xfactorfos:goldPressed')
AddEventHandler('cibb-xfactorfos:goldPressed', function(judgeId, button)
    GoldenBuzzer()
end)

RegisterNetEvent('cibb-xfactorfos:reset')
AddEventHandler('cibb-xfactorfos:reset', function(judgeId, button)
    RestartFOS()
end)


-- -------------------------------------------------------------
-- |                VISUAL EFFECTS SECTION                     |
-- -------------------------------------------------------------

function RestartFOS()
    shouldLightsRun = false
end

-- Just one X Pressed
function XBuzzer(judgeId)
    SendNUIMessage({
        transactionType     = 'cibb-xfactorfos-sound',
        transactionFile     = "x",
        transactionVolume   = Config.sound.volume
    })    
end

-- All X Pressed! You are out!
function AllXBuzzer()
    reason = "fail"
    shouldLightsRun = true
    SendNUIMessage({
        transactionType     = 'cibb-xfactorfos-sound',
        transactionFile     = "x_final",
        transactionVolume   = Config.sound.volume
    })    
    Wait(7500)
    RestartFOS()
end

-- Golden Buzzers pressed
function GoldenBuzzer() 
    SendNUIMessage({
        transactionType     = 'cibb-xfactorfos-sound',
        transactionFile     = "gold",
        transactionVolume   = Config.sound.volume
    })

    Wait(7500) -- Previous music
    reason = "gold"
    showGoldenX = true
    shouldLightsRun = true
    Wait(25000) -- Wait until music ends    
    RestartFOS()
end

-- -------------------------------------------------------------
-- |                   DEAMOND ITERATORS                       |
-- -------------------------------------------------------------

-- Check if environment lights should be on
Citizen.CreateThread(function()    
    while true do
        if shouldLightsRun then     
            local lightsOptions = Config.buzzers[reason]
            DrawLightWithRange(-230.0,-2001.00,25.00,lightsOptions.r,lightsOptions.g,lightsOptions.b,10.0,lightsOptions.intensity)
            DrawLightWithRange(-235.0,-2001.00,25.00,lightsOptions.r,lightsOptions.g,lightsOptions.b,7.0,lightsOptions.intensity)
            DrawLightWithRange(-235.0,-2005.45,25.00,lightsOptions.r,lightsOptions.g,lightsOptions.b,9.0,lightsOptions.intensity)            
        end
        Wait(0)
    end
end)

-- Draw an X above judges head when they press the X
Citizen.CreateThread(function()
	Wait(500)
    local r,g,b = 0,0,0

    while true do
        for _, id in ipairs(GetActivePlayers()) do
            local xValue = xPressed[GetPlayerServerId(id)]
            if xValue ~= nil and (xValue ~= "gold" or showGoldenX) then
                local targetPedCords = GetEntityCoords(GetPlayerPed(id))                
                if xValue == "x" then
                    r,g,b = 255,0,0
                else
                    r,g,b = 255,215,0
                end

                DrawText3D(targetPedCords, "X", r,g,b, 1)
            end
        end
        Citizen.Wait(0)
    end
end)