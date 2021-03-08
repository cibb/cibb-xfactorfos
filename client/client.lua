-- Internal vars, please don't touch!
local shouldLightsRun = false
local showGoldenX = false
local throwConfetti = false
local goldeIsRunning = false
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
AddEventHandler('cibb-xfactorfos:xPressed', function(judgeId)
    local xCount = 0
    for _,value in pairs(xPressed) do
        if value == "x" then
            xCount = xCount + 1
        end
    end

    if goldeIsRunning then
        return
    end

    if xCount == 3 then
        reason = "fail"
        shouldLightsRun = true
        FireSoundEvent(judgeId, "cibb-xfactorfos-sound","x_final")
        Wait(7500)
        RestartFOS()
    else
        FireSoundEvent(judgeId, "cibb-xfactorfos-sound","x")
    end
end)

RegisterNetEvent('cibb-xfactorfos:goldPressed')
AddEventHandler('cibb-xfactorfos:goldPressed', function(judgeId)
    goldeIsRunning = true
    FireSoundEvent(judgeId, "cibb-xfactorfos-sound","gold")
    Wait(7500) -- Previous music
    reason = "gold"
    throwConfetti = true
    showGoldenX = true
    shouldLightsRun = true
    Wait(25000) -- Wait until music ends    
    RestartFOS()
end)

RegisterNetEvent('cibb-xfactorfos:reset')
AddEventHandler('cibb-xfactorfos:reset', function(judgeId)
    RestartFOS()
end)


-- -------------------------------------------------------------
-- |                VISUAL EFFECTS SECTION                     |
-- -------------------------------------------------------------

function RestartFOS()
    shouldLightsRun = false
    showGoldenX = false
    throwConfetti = false
    goldeIsRunning = false

    SendNUIMessage({
        transactionType     = 'cibb-xfactorfos-sound-stop'
    })
end
-- -------------------------------------------------------------
-- |                   DEAMOND ITERATORS                       |
-- -------------------------------------------------------------

-- Throw confetti when is required
Citizen.CreateThread(function()
    RequestNamedPtfxAsset("scr_xs_celebration")
    while not HasNamedPtfxAssetLoaded("scr_xs_celebration") do
        Citizen.Wait(0)
    end

    while true do
        if throwConfetti then
            local a = 0
            while a < 17 and throwConfetti do        
                for _, item in ipairs(Config.confettiPosittions) do
                    Citizen.CreateThread(function()
                        UseParticleFxAssetNextCall("scr_xs_celebration")                
                        StartParticleFxNonLoopedAtCoord("scr_xs_confetti_burst", item.x, item.y, item.z, 0.0, 0.0, 0.0, 1.0, false, false, false)
                    end)
                end
                a = a + 1                
                Citizen.Wait(1500)
            end
            throwConfetti = false
        end
        Citizen.Wait(0)
    end
end)

-- Check if environment lights should be on
Citizen.CreateThread(function()    
    while true do
        if shouldLightsRun then     
            local lightsOptions = Config.buzzers[reason]

            for _, item in ipairs(Config.lightsPositions) do
                DrawLightWithRange(item.x,item.y,item.z,lightsOptions.r,lightsOptions.g,lightsOptions.b,10.0,lightsOptions.intensity)
            end
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
            if(CalcSourceDist(GetPlayerServerId(id)) <= Config.propagation_distance) then 
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
        end
        Citizen.Wait(0)
    end
end)