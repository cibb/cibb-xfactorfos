local sfHandle
local loaded = false
duiObj = false

-- Load functions
function LoadFos()
    sfHandle = RequestScaleformMovie(Config.screen.sfName);
    duiObj = CreateDui('nui://cibb-xfactorfos/client/html/screen.html', Config.screen.width, Config.screen.height);
    while not IsDuiAvailable(duiObj) or not HasScaleformMovieLoaded(sfHandle) do
        Wait(0)
    end

    local txd = CreateRuntimeTxd('cibbfos');
    local dui = GetDuiHandle(duiObj);
    CreateRuntimeTextureFromDuiHandle(txd, 'equis', dui);
    
    PushScaleformMovieFunction(sfHandle, 'SET_TEXTURE');
    PushScaleformMovieMethodParameterString('cibbfos'); 
    PushScaleformMovieMethodParameterString('equis'); 
    PushScaleformMovieFunctionParameterInt(0);
    PushScaleformMovieFunctionParameterInt(0);
    PushScaleformMovieFunctionParameterInt(Config.screen.width);
    PushScaleformMovieFunctionParameterInt(Config.screen.height);
    PopScaleformMovieFunctionVoid();

    Wait(500)
    SendDuiMessage(duiObj, json.encode({
        type = "startup",
        judges = Config.judges
    }))
    
    loaded = true
end

-- Main thread for screen
CreateThread(function ()
    local tablePossition = vector3(Config.tablePossition.x, Config.tablePossition.y, Config.tablePossition.z)
    local waitTime = 1000;
    while true do
        if #(GetEntityCoords(PlayerPedId()) - tablePossition) < 50 then
            if loaded then                            
                DrawScaleformMovie_3dNonAdditive(sfHandle,Config.screen.coords.x,Config.screen.coords.y,Config.screen.coords.z,
                0, Config.screen.coords.yRotation, 0,
                2, 2, 2,Config.screen.scale * 1, Config.screen.scale * (9/16), 1,2);
            else
                LoadFos()
            end
            waitTime = 0

        else            
            waitTime = 1000
        end

        Wait(waitTime)
    end
end)

-- Cleanup
AddEventHandler('onResourceStop', function (resource)
	if resource == GetCurrentResourceName() and duiObj then
        SetDuiUrl(duiObj, 'about:blank')
		DestroyDui(duiObj)
	end
end)