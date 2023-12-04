ESX = nil

local PlayerData = {}

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)  
	PlayerData.job = job  
	Citizen.Wait(5000) 
end)

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
    end
    while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
    end
    if ESX.IsPlayerLoaded() then

		ESX.PlayerData = ESX.GetPlayerData()

    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)


RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

RegisterNetEvent('esx:setJob2')
AddEventHandler('esx:setJob2', function(job2)
    ESX.PlayerData.job2 = job2
end)

Garage = {
    vehiclelist = {},
}



Citizen.CreateThread(function()
    while true do 
        local wait = 750
            if ESX.PlayerData.job2 and ESX.PlayerData.job2.name == Config.name then
                for k in pairs {vector3(Config.Xouvrir, Config.Youvrir, Config.Zouvrir)} do 
                local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
                local pos = {vector3(Config.Xouvrir, Config.Youvrir, Config.Zouvrir)}
                local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, pos[k].x, pos[k].y, pos[k].z)

                if dist <= 6 then 
                    wait = 0
                    DrawMarker(6, Config.Xouvrir, Config.Youvrir, Config.Zouvrir-0.99 , 0.0, 0.0, 0.0, -90, 0.0, 0.0, 0.7, 0.7, 0.7, Config.MarkerColorR, Config.MarkerColorG, Config.MarkerColorB, 170, 0, 1, 2, 0, nil, nil, 0)
                end
                if dist <= 1.0 then 
                    wait = 0


                    RageUI.Text({message = "Appuyer sur [~r~E~s~] pour ouvrir le Garage"})
                    if IsControlJustPressed(1, 51) then 
                        ESX.TriggerServerCallback('ev:vehiclelist', function(ownedCars)
                            Garage.vehiclelist = ownedCars
                        end)
						GarageMainEv1()
                    end
                end
                
            end
        end
    Citizen.Wait(wait)
    end
end)

function GarageMainEv1()

    local GarageMainEv = RageUI.CreateMenu("Garage","Véhicules")

    RageUI.Visible(GarageMainEv, not RageUI.Visible(GarageMainEv))

    while GarageMainEv do
        
        Citizen.Wait(0)

        RageUI.IsVisible(GarageMainEv,true,true,true,function()

            RageUI.Separator("↓     ~b~Véhicules     ~s~↓")
                for i = 1, #Garage.vehiclelist, 1 do
                    local hashvehicle = Garage.vehiclelist[i].vehicle.model
                    local modelevehiclespawn = Garage.vehiclelist[i].vehicle
                    local nomvehiclemodele = GetDisplayNameFromVehicleModel(hashvehicle)
                    local nomvehicletexte  = GetLabelText(nomvehiclemodele)
                    local plaque = Garage.vehiclelist[i].plate
        
        
                    RageUI.ButtonWithStyle(nomvehicletexte.." | "..plaque, "Pour sortir le véhicule", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                        if Selected then    
                            SpawnVehicle(modelevehiclespawn, plaque)
                            TriggerServerEvent('ev:NobugMaCaille', plaque)
                            RageUI.CloseAll()
                        end
                    end) 
                end
         

        
        end, function()
        end)

        if not RageUI.Visible(GarageMainEv) then
            GarageMainEv=RMenu:DeleteType("GarageMainEv", true)
        end

    end

end





Citizen.CreateThread(function()
    while true do 
        local wait = 750
            if ESX.PlayerData.job2 and ESX.PlayerData.job2.name == Config.name then
                for k in pairs {vector3(Config.Xranger, Config.Yranger, Config.Zranger)} do 
                local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
                local pos = {vector3(Config.Xranger, Config.Yranger, Config.Zranger)}
                local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, pos[k].x, pos[k].y, pos[k].z)

                if dist <= 6 then 
                    wait = 0
                    DrawMarker(22, Config.Xranger, Config.Yranger, Config.Zranger , 0.0, 0.0, 0.0, 90, 0.0, 0.0, 0.5, 0.5, 0.5, Config.MarkerColorR, Config.MarkerColorG, Config.MarkerColorB, 170, 0, 1, 2, 0, nil, nil, 0)
                end
                if dist <= 1.0 then 
                    wait = 0


                    RageUI.Text({message = "Appuyer sur [~r~E~s~] pour rentrer le véhicule dans le Garage"})
                    if IsControlJustPressed(1, 51) then 
                        ReturnVehicle222()
                    end
                end
                
            end
        end
    Citizen.Wait(wait)
    end
end)