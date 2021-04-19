-- Fire sound event if the user into the room
function FireSoundEvent(event,file)
    local isInRoom = GetInteriorFromEntity(PlayerPedId()) == Config.screen.interiorId and GetKeyForEntityInRoom(PlayerPedId()) == Config.screen.roomId;    
    
    if(isInRoom) then
        SendNUIMessage({
            transactionType     = event,
            transactionFile     = file,
            transactionVolume   = Config.sound.volume
        })
    end
end