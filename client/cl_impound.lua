local currentGarage = 1

RegisterNetEvent('mdt:client:TakeOutImpound', function(data, id)
    local pos = GetEntityCoords(PlayerPedId())
    print("1")
    currentGarage = data.currentSelection
    local takeDist = Config.ImpoundLocations[data.currentSelection]
    takeDist = vector3(takeDist.x, takeDist.y,  takeDist.z)
    if #(pos - takeDist) <= 150.0 then
        print("2")
        local vehicle = data
        local coords = Config.ImpoundLocations[currentGarage]
        if coords then
            print("3")
	        ESX.Game.SpawnVehicle(vehicle.model, vector3(coords.x, coords.y, coords.z), coords.w, function(veh)
	            ESX.Game.SetVehicleProperties(veh, json.decode(vehicle.vehicle))
	            SetVehicleNumberPlateText(veh, vehicle.plate)
	            SetEntityHeading(veh, coords.w)
	            SetVehicleEngineOn(veh, true, true)
	            TriggerServerEvent('mdt:server:deleteimpound', id, vehicle.plate)
	        end)
	    end
    else
    	ESX.ShowNotification('You are too far away from the impound location!')
    end
end)