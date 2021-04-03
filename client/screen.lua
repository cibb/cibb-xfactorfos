local scale = 1
local screenWidth = math.floor(1280 / scale)
local screenHeight = math.floor(720 / scale)
local screenEntity = 0

-- local screenModel = GetHashKey('v_ilev_mm_screen2')
local screenModel = GetHashKey(Config.screen.model)
local handle = CreateNamedRenderTargetForModel(Config.screen.renderTarget, screenModel)

local txd = CreateRuntimeTxd('video')
local duiObj = CreateDui("nui://cibb-xfactorfos/client/html/screen.html", screenWidth, screenHeight)
local dui = GetDuiHandle(duiObj)
local tx = CreateRuntimeTextureFromDuiHandle(txd, 'test', dui)

CreateThread(function ()
	local playerPed	
	local inRange = false	
	local screenCoords = vector3(Config.screen.coords.x,Config.screen.coords.y,Config.screen.coords.z)

	-- Create screen
	if not DoesEntityExist(GetClosestObjectOfType(screenCoords.x, screenCoords.y, screenCoords.z, 10.0, screenModel, false, false, false)) then		
		LoadModel(screenModel)
		screenEntity = CreateObjectNoOffset(screenModel, screenCoords.x, screenCoords.y, screenCoords.z, 0, true, false)
		SetEntityHeading(screenEntity, Config.screen.coords.heading)
	 	SetEntityCoords(screenEntity, GetEntityCoords(screenEntity))
		SetModelAsNoLongerNeeded(screenModel)
		
		Wait(1000) -- Give some time to create the object
		print("Sending")
		SendDuiMessage(duiObj, json.encode({
			type = "startup",
			judges = Config.judges
		}))
	end

	while true do
		playerPed = PlayerPedId()		
		inRange = GetInteriorFromEntity(playerPed) == Config.screen.interiorId and GetKeyForEntityInRoom(playerPed) == Config.screen.roomId

		if inRange then		
			SetTextRenderId(handle)
			Set_2dLayer(4)
			SetScriptGfxDrawBehindPausemenu(1)
			DrawRect(0.5, 0.5, 1.0, 1.0, 0, 0, 0, 255)
			DrawSprite("video", "test", 0.5, 0.5, 1.0, 1.0, 0.0, 255, 255, 255, 255)
			SetTextRenderId(GetDefaultScriptRendertargetRenderId()) -- reset
			SetScriptGfxDrawBehindPausemenu(0)
		end

		Wait(0)
	end
end)

-- Cleanup
AddEventHandler('onResourceStop', function (resource)
	if resource == GetCurrentResourceName() then
		SetDuiUrl(duiObj, 'about:blank')
		DestroyDui(duiObj)
		ReleaseNamedRendertarget(Config.screen.renderTarget)
		SetEntityAsMissionEntity(screenEntity, false, true)
		DeleteObject(screenEntity)
	end
end)