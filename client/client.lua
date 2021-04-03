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
        if value.button == "x" then
            xCount = xCount + 1
        end
    end

    if goldeIsRunning then
        return
    end

    SendDuiMessage(duiObj, json.encode({
        type = "xUpdate",
        xPressed = xPressed
    }))

    if xCount == 3 then
        reason = "fail"
        shouldLightsRun = true
        runLights()
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
    shouldLightsRun = true
    runConfettiAnimation()
    runLights()

    SendDuiMessage(duiObj, json.encode({
        type = "xUpdate",
        xPressed = xPressed
    }))    
    
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

    SendDuiMessage(duiObj, json.encode({
        type = "xUpdate",
        xPressed = xPressed
    }))

    SendNUIMessage({
        transactionType     = 'cibb-xfactorfos-sound-stop'
    })
end

-- Throw confetti when is required
function runConfettiAnimation()
    Citizen.CreateThread(function()
        RequestNamedPtfxAsset("scr_xs_celebration")
        while not HasNamedPtfxAssetLoaded("scr_xs_celebration") do
            Citizen.Wait(0)
        end

        while throwConfetti do        
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
            Citizen.Wait(0)
        end
    end)
end

-- Check if environment lights should be on
function runLights()
    Citizen.CreateThread(function()
        while shouldLightsRun do            
            local lightsOptions = Config.buzzers[reason]

            for _, item in ipairs(Config.lightsPositions) do
                DrawLightWithRange(item.x,item.y,item.z,lightsOptions.r,lightsOptions.g,lightsOptions.b,10.0,lightsOptions.intensity)
            end
            Wait(0)
        end
    end)
end