local sfHandle
local txd = CreateRuntimeTxd('cibbfos');        
duiObj = CreateDui('nui://cibb-xfactorfos/client/html/screen.html', Config.screen.width, Config.screen.height);            
local dui = GetDuiHandle(duiObj);        
local tx = CreateRuntimeTextureFromDuiHandle(txd, 'x', dui);    

CreateThread(function ()        
    local playerPed = PlayerPedId()
    local inRange = false
    
    if not HasScaleformMovieLoaded(sfHandle) then
        sfHandle = RequestScaleformMovie(Config.screen.sfName);
        while not HasScaleformMovieLoaded(sfHandle) or not IsDuiAvailable(duiObj) or not txd do            
            Wait(1000)
        end

        PushScaleformMovieFunction(sfHandle, 'SET_TEXTURE');
        PushScaleformMovieMethodParameterString('cibbfos'); 
        PushScaleformMovieMethodParameterString('x'); 
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
    end

    while true do        
        inRange = GetInteriorFromEntity(playerPed) == Config.screen.interiorId and GetKeyForEntityInRoom(playerPed) == Config.screen.roomId

        if inRange then	
            DrawScaleformMovie_3dNonAdditive(sfHandle,Config.screen.coords.x,Config.screen.coords.y,Config.screen.coords.z,
            0, Config.screen.coords.yRotation, 0,
            2, 2, 2,Config.screen.scale * 1, Config.screen.scale * (9/16), 1,2);
        end
        Wait(0)
    end
end)

-- Cleanup
AddEventHandler('onResourceStop', function (resource)
	if resource == GetCurrentResourceName() then
		SetDuiUrl(duiObj, 'about:blank')
		DestroyDui(duiObj)
	end
end)