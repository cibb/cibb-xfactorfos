local xPressed = {}
local buttonsEvents = {
    x =  "cibb-xfactorfos:xPressed",
    gold = "cibb-xfactorfos:goldPressed",
    reset = "cibb-xfactorfos:reset"
}

-- -------------------------------------------------------------
-- |                    EVENT HANDLERS                         |
-- -------------------------------------------------------------
-- Interaction Event
RegisterNetEvent('cibb-xfactorfos:pressButton')
AddEventHandler('cibb-xfactorfos:pressButton', function(judgeId, button)
    if not CheckPlayerCanInteract(judgeId) then
        return
    end

    if buttonsEvents[button] ~= nill then
        if UpdatePressedCache(judgeId,button) then
            SendFOSVisualEvent(buttonsEvents[button])
        end
    end
end)

-- Check if the user is Judge
RegisterNetEvent('cibb-xfactorfos:AmIAJudge')
AddEventHandler('cibb-xfactorfos:AmIAJudge', function(source)
    if CheckPlayerCanInteract(source) then
        TriggerClientEvent("cibb-xfactorfos:youAreAJudge", source)
    end
end)

-- Update cache and broadcast to all the users
function UpdatePressedCache(judgeId,button)
    local internalID = GetInternalJudgeIdentifier(judgeId);

    if button == "reset" then
        xPressed = nil
        xPressed = {}
    end

    if xPressed[internalID] ~= nil and xPressed[internalID].button == button then
        xPressed[internalID] = nil
        TriggerClientEvent("cibb-xfactorfos:xUpdate", -1, xPressed)
        TriggerClientEvent("cibb-xfactorfos:xRemoved", -1)
        return false
    elseif button == "x" or button == "gold" then
        xPressed[internalID] = {
            button = button,
            internalIdentifier = GetInternalJudgeIdentifier(judgeId)
        }
    end

    TriggerClientEvent("cibb-xfactorfos:xUpdate", -1, xPressed)
    return true
end

-- Send Visual Event
function SendFOSVisualEvent(event)
    TriggerClientEvent(event, -1)
end

-- -------------------------------------------------------------
-- |                    INTERNALS SECTION                      |
-- -------------------------------------------------------------

-- Get identifier
function GetConfiguredIdentifier(source)
    for k,value in pairs(GetPlayerIdentifiers(source)) do
        if string.sub(value, 1, string.len(Config.identifier_used .. ":")) == Config.identifier_used .. ":" then
            return value
        end
    end
end

-- Get judge internal identifier
function GetInternalJudgeIdentifier(source)
    local judgeIdentifier = GetConfiguredIdentifier(source)
    for k,value in pairs(Config.judges) do
        if value.identifier == judgeIdentifier then
            return k
        end
    end
end

-- Check config and return true if the user is authorized to interact
function CheckPlayerCanInteract(Player)
    local identifier = GetConfiguredIdentifier(Player)

    for key,configuredIdentifier in pairs(Config.judges) do
        if configuredIdentifier.identifier == identifier then
            return true
        end
    end

    return false;
end