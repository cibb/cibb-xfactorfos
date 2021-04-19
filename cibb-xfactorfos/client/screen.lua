local sfHandle
local loaded = false
duiObj = false

function LoadFos()
    print("Loading starterd internally")
    
    duiObj = CreateDui('nui://cibb-xfactorfos/client/html/screen.html', Config.screen.width, Config.screen.height);
    while not IsDuiAvailable(duiObj) do
        Wait(0)
    end
    
    local txd = CreateRuntimeTxd('cibbfos');
    Wait(500)
    local dui = GetDuiHandle(duiObj);        
    Wait(500)
    CreateRuntimeTextureFromDuiHandle(txd, 'equis', dui);
    Wait(500)

    sfHandle = RequestScaleformMovie(Config.screen.sfName);
    while not HasScaleformMovieLoaded(sfHandle) or not txd do            
        Wait(0)
    end

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

    Wait(1000)
    loaded = true
    print("Loaded")
end

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
                print("Loading")
                LoadFos()
            end
            waitTime = 0
        else
            print("Not here")
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