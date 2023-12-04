ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


RegisterServerEvent('ev:gotoga')
AddEventHandler('ev:gotoga', function (playerId, vehicleProps, name, veh)


    local source = source
    local EVPlayer = GetPlayerPed(source)
    local vehi = GetVehiclePedIsIn(EVPlayer, false)
    local phpveh = "Vehicule Boutique"
    local pl = GetVehicleNumberPlateText(vehi)
    print(pl)
	local ledonneur = ESX.GetPlayerFromId(source)
    MySQL.Async.execute('INSERT INTO ganggarage (gang, plate, vehicle, name) VALUES (@gang, @plate, @vehicle, @name)',
    {
        ['@gang']   = ledonneur.identifier,
        ['@plate']   = pl,
        ['@vehicle'] = phpveh,
        ['@name'] = phpveh
    }, function (rowsChanged)
    TriggerClientEvent('esx:showNotification', ledonneur.source, "Ton véhicule a été ~g~ajouté~s~ au garage de gang !")
    end)
end)


RegisterServerEvent('ev:getveh')
AddEventHandler('ev:getveh', function (playerId, vehicleProps, name, veh)


    local source = source
    MySQL.Async.fetchAll('SELECT * FROM ganggarage WHERE owner = @owner AND `stored` = @stored', { 
			['@owner'] = xPlayer.identifier,
			['@stored'] = true
		}, function(data)
    end)
end)

ESX.RegisterServerCallback('ev:vehiclelist', function(source, cb)
	local ownedCars = {}
	local xPlayer = ESX.GetPlayerFromId(source)
		MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE job = @job', { 
            ['@job'] = Config.name,
		}, function(data)
			for _,v in pairs(data) do
				local vehicle = json.decode(v.vehicle)
				table.insert(ownedCars, {vehicle = vehicle, stored = v.stored, plate = v.plate})
			end
			cb(ownedCars)
		end)
end)


ESX.RegisterServerCallback('ev:returnVehicle', function (source, cb, vehicleProps)
	local ownedCars = {}
	local vehplate = vehicleProps.plate:match("^%s*(.-)%s*$")
	local vehiclemodel = vehicleProps.model
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND @plate = plate', {
		['@owner'] = xPlayer.identifier,
		['@plate'] = vehicleProps.plate
	}, function (result)
		if result[1] ~= nil then
			local originalvehprops = json.decode(result[1].vehicle)
			if originalvehprops.model == vehiclemodel then
				MySQL.Async.execute('UPDATE owned_vehicles SET job = @job WHERE owner = @owner AND plate = @plate', {
					['@owner'] = xPlayer.identifier,
					['@vehicle'] = json.encode(vehicleProps),
					['@plate'] = vehicleProps.plate,
                    ['@job'] = Config.name
				}, function (rowsChanged)
					if rowsChanged == 0 then
						print(('ev : tente de ranger un véhicule non à lui '):format(xPlayer.identifier))
					end
					cb(true)
				end)
			else
				cb(false)
			end
		else
			cb(false)
		end
	end)
end)


------------Test en dessous


ESX.RegisterServerCallback('ev:returnVehicle222', function (source, cb, vehicleProps)
	local ownedCars = {}
	local vehplate = vehicleProps.plate:match("^%s*(.-)%s*$")
	local vehiclemodel = vehicleProps.model
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE job = @job', {
		['@job'] = Config.name
	}, function (result)
		if result[1] ~= nil then
			local originalvehprops = json.decode(result[1].vehicle)
			if originalvehprops.model == vehiclemodel then
				MySQL.Async.execute('UPDATE owned_vehicles SET job = @job WHERE owner = @owner AND plate = @plate', {
					['@owner'] = xPlayer.identifier,
					['@vehicle'] = json.encode(vehicleProps),
					['@plate'] = vehicleProps.plate,
                    ['@job'] = Config.name
				}, function (rowsChanged)
					if rowsChanged == 0 then
						print(('ev : tente de ranger un véhicule non à lui '):format(xPlayer.identifier))
					end
					cb(true)
				end)
			else
				cb(false)
			end
		else
			cb(false)
		end
	end)
end)



RegisterServerEvent('ev:breakVehicleSpawn')
AddEventHandler('ev:breakVehicleSpawn', function(plate, state)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.execute('UPDATE owned_vehicles SET `stored` = @stored WHERE plate = @plate', {
		['@stored'] = state,
		['@plate'] = plate
	}, function(rowsChanged)
		if rowsChanged == 0 then
			print(('esx_advancedgarage: %s exploited the garage!'):format(xPlayer.identifier))
		end
	end)
end)


RegisterServerEvent('ev:NobugMaCaille')
AddEventHandler('ev:NobugMaCaille', function(plate)
	local xPlayer = ESX.GetPlayerFromId(source)


	MySQL.Async.execute('UPDATE owned_vehicles SET `job` = @job WHERE owner = @owner AND plate = @plate', {
		['@owner'] = xPlayer.identifier,
		['plate'] = plate,
		['@job'] = "normal"
	}, function(rowsChanged)
		TriggerClientEvent('esx:showNotification', xPlayer.source, "Véhicule retiré du garage de Gang")
	end)
end)