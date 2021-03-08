-- Function to draw X in the judges head
function DrawText3D(position, text, r,g,b, scaleModifcator) 
    local onScreen,_x,_y=World3dToScreen2d(position.x,position.y,position.z+1)
    local dist = #(GetGameplayCamCoords()-position)

    local scale = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov

    if onScreen then
        SetTextScale(0.0*scale, scaleModifcator*scale)        
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(r, g, b, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

-- Get coords and calculate the distance
function CalcSourceDist(sourceId)
    local lCoords = GetEntityCoords(GetPlayerPed(-1))
    local eCoords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(sourceId)))
    return Vdist(lCoords.x, lCoords.y, lCoords.z, eCoords.x, eCoords.y, eCoords.z)    
end

-- Fire sound event
function FireSoundEvent(source, event,file)
    if(CalcSourceDist(source) <= Config.propagation_distance) then
        GoldenBuzzer()
    end

    SendNUIMessage({
        transactionType     = event,
        transactionFile     = file,
        transactionVolume   = Config.sound.volume
    })
end