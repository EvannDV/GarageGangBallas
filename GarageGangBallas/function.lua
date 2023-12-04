ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function SpawnVehicle(vehicle, plate)
    x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))

	ESX.Game.SpawnVehicle(vehicle.model, {
		x = Config.XspawnVeh,
		y = Config.YspawnVeh,
		z = Config.ZspawnVeh 
	}, GetEntityHeading(PlayerPedId()), function(callback_vehicle)
		ESX.Game.SetVehicleProperties(callback_vehicle, vehicle)
		SetVehRadioStation(callback_vehicle, "OFF")
		SetVehicleFixed(callback_vehicle)
		SetVehicleDeformationFixed(callback_vehicle)
		SetVehicleUndriveable(callback_vehicle, false)
		SetVehicleEngineOn(callback_vehicle, true, true)
		--SetVehicleEngineHealth(callback_vehicle, 1000) -- Might not be needed
		--SetVehicleBodyHealth(callback_vehicle, 1000) -- Might not be needed
		TaskWarpPedIntoVehicle(GetPlayerPed(-1), callback_vehicle, -1)
	end)
	TriggerServerEvent('ev:breakVehicleSpawn', plate, false)
end

function ReturnVehicle()
	local playerPed  = GetPlayerPed(-1)
	if IsPedInAnyVehicle(playerPed,  false) then
		local playerPed    = GetPlayerPed(-1)
		local coords       = GetEntityCoords(playerPed)
		local vehicle      = GetVehiclePedIsIn(playerPed, false)
		local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
		local current 	   = GetPlayersLastVehicle(GetPlayerPed(-1), true)
		local engineHealth = GetVehicleEngineHealth(current)
		local plate        = vehicleProps.plate

		ESX.TriggerServerCallback('ev:returnVehicle', function(valid)
			if valid then
                BreakReturnVehicle(vehicle, vehicleProps)
			else
				ESX.ShowNotification('Tu ne peux pas garer ce véhicule')
			end
		end, vehicleProps)
	else
		ESX.ShowNotification('Il n y a pas de véhicule à ranger dans le garage.')
	end
end


function ReturnVehicle222()
	local playerPed  = GetPlayerPed(-1)
	if IsPedInAnyVehicle(playerPed,  false) then
		local playerPed    = GetPlayerPed(-1)
		local coords       = GetEntityCoords(playerPed)
		local vehicle      = GetVehiclePedIsIn(playerPed, false)
		local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
		local current 	   = GetPlayersLastVehicle(GetPlayerPed(-1), true)
		local engineHealth = GetVehicleEngineHealth(current)
		local plate        = vehicleProps.plate

		ESX.TriggerServerCallback('ev:returnVehicle222', function(valid)
			if valid then
                BreakReturnVehicle(vehicle, vehicleProps)
			else
				print("pas à toi")
			end
		end, vehicleProps)

		ESX.TriggerServerCallback('ev:returnVehicle', function(valid)
			if valid then
                BreakReturnVehicle(vehicle, vehicleProps)
			else
				print("pas à toi")
			end
		end, vehicleProps)


	else
		ESX.ShowNotification('Il n y a pas de véhicule à ranger dans le garage.')
	end
end

function BreakReturnVehicle(vehicle, vehicleProps)
	ESX.Game.DeleteVehicle(vehicle)
	TriggerServerEvent('ev:breakVehicleSpawn', vehicleProps.plate, true)
	ESX.ShowNotification("Tu viens de ranger un ~r~véhicule ~s~!")
end