local QBCore = exports['qb-core']:GetCoreObject()

isLoggedIn = true

local onDuty = true

local spawnedPeds = {}

PlayerJob = {}



----------------
-- Handlers
----------------

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
	QBCore.Functions.GetPlayerData(function(PlayerData)
		PlayerJob = PlayerData.job
	end)
end)

RegisterNetEvent('QBCore:Client:SetDuty')
AddEventHandler('QBCore:Client:SetDuty', function(duty)
    onDuty = duty
end)


-----------
--- Blip
-----------

Citizen.CreateThread(function()
	for _, info in pairs(Config.BlipLocation) do
		if Config.UseBlips then
			info.blip = AddBlipForCoord(info.x, info.y, info.z)
			SetBlipSprite(info.blip, info.id)
			SetBlipDisplay(info.blip, 4)
			SetBlipScale(info.blip, 0.6)	
			SetBlipColour(info.blip, info.colour)
			SetBlipAsShortRange(info.blip, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(info.title)
			EndTextCommandSetBlipName(info.blip)
		end
	end	
end)

-----------
--- Ped
-----------

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(500)
		for k,v in pairs(Config.PedList) do
			local playerCoords = GetEntityCoords(PlayerPedId())
			local distance = #(playerCoords - v.coords.xyz)

			if distance < Config.DistanceSpawn and not spawnedPeds[k] then
				local spawnedPed = NearPed(v.model, v.coords, v.gender, v.animDict, v.animName, v.scenario)
				spawnedPeds[k] = { spawnedPed = spawnedPed }
			end

			if distance >= Config.DistanceSpawn and spawnedPeds[k] then
				if Config.FadeIn then
					for i = 255, 0, -51 do
						Citizen.Wait(50)
						SetEntityAlpha(spawnedPeds[k].spawnedPed, i, false)
					end
				end
				DeletePed(spawnedPeds[k].spawnedPed)
				spawnedPeds[k] = nil
			end
		end
	end
end)

------------
-- Events
------------

RegisterNetEvent("ss-taco:Duty")
AddEventHandler("ss-taco:Duty", function()
    TriggerServerEvent("QBCore:ToggleDuty")
end)

RegisterNetEvent("ss-taco:shop", function(index)
    TriggerServerEvent("inventory:server:OpenInventory", "shop", "taco", {
        label = "Taco",
        items = Config.Items,
        slots = #Config.Items,
    })
end);

RegisterNetEvent("ss-taco:Tray1")
AddEventHandler("ss-taco:Tray1", function()
    TriggerEvent("inventory:client:SetCurrentStash", "tacotray1")
    TriggerServerEvent("inventory:server:OpenInventory", "stash", "tacotray1", {
        maxweight = 10000,
        slots = 6,
    })
end)

RegisterNetEvent("ss-taco:Tray2")
AddEventHandler("ss-taco:Tray2", function()
    TriggerEvent("inventory:client:SetCurrentStash", "tacotray2")
    TriggerServerEvent("inventory:server:OpenInventory", "stash", "tacotray2", {
        maxweight = 10000,
        slots = 6,
    })
end)

RegisterNetEvent("ss-taco:Storage")
AddEventHandler("ss-taco:Storage", function()
    TriggerEvent("inventory:client:SetCurrentStash", "tacostorage")
    TriggerServerEvent("inventory:server:OpenInventory", "stash", "tacostorage", {
        maxweight = 250000,
        slots = 40,
    })
end)

RegisterNetEvent('ss-taco:garage:SpawnVehicle')
AddEventHandler('ss-taco:garage:SpawnVehicle', function(taco)
    print("Made by Stormy Scratch")
    local vehicle = taco.vehicle 
    local coords = { ['x'] = 24.95, ['y'] = -1590.2, ['z'] = 29.09, ['h'] = 229.33 }
    QBCore.Functions.SpawnVehicle(vehicle, function(veh)
        SetVehicleNumberPlateText(veh, "TACO"..tostring(math.random(1000, 9999)))
        exports['LegacyFuel']:SetFuel(veh, 100.0)
        SetEntityHeading(veh, coords.h)
        SetVehicleModKit(Veh, 0)        
        SetVehicleLivery(Veh, 1)
        SetVehicleMod(Veh, 48, 3, false)
        TriggerEvent("vehiclekeys:client:SetOwner", QBCore.Functions.GetPlate(veh))
        SetVehicleEngineOn(veh, false, false)
    end, coords, true)
end)

RegisterNetEvent('ss-taco:garage:StoreVehicle')
AddEventHandler('ss-taco:garage:StoreVehicle', function()
    print("Made by Stormy Scratch")
    QBCore.Functions.Notify('Vehicle Stored!')
    local car = GetVehiclePedIsIn(PlayerPedId(),true)
    DeleteVehicle(car)
    DeleteEntity(car)
end)

RegisterNetEvent("ss-taco:Taco")
AddEventHandler("ss-taco:Taco", function()
    if onDuty then
    	QBCore.Functions.TriggerCallback('ss-taco:server:get:Taco', function(HasItems)  
    		if HasItems then
				QBCore.Functions.Progressbar("make_taco", "Making Taco", 4000, false, true, {
					disableMovement = true,
					disableCarMovement = true,
					disableMouse = false,
					disableCombat = true,
				}, {
					animDict = "mp_common",
					anim = "givetake1_a",
					flags = 8,
				}, {}, {}, function() -- Done
					TriggerServerEvent('QBCore:Server:RemoveItem', "cooked-minced-meat", 1)
					TriggerServerEvent('QBCore:Server:RemoveItem', "salad", 1)
					TriggerServerEvent('QBCore:Server:RemoveItem', "tortilla", 1)
					TriggerServerEvent('QBCore:Server:AddItem', "taco", 1)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["taco"], "add",1)
                    QBCore.Functions.Notify("You made a Taco", "success")
				end, function()
					QBCore.Functions.Notify("Cancelled..", "error")
				end)
			else
   				QBCore.Functions.Notify("You dont have the ingredients to make this", "error")
			end
		end)
	else 
		QBCore.Functions.Notify("You must be On Duty", "error")
	end
end)

RegisterNetEvent("ss-taco:Shake")
AddEventHandler("ss-taco:Shake", function()
    if onDuty then
		QBCore.Functions.Progressbar("make_shake", "Making Shake", 4000, false, true, {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		}, {
            animDict = "anim@amb@nightclub@mini@drinking@drinking_shots@ped_a@normal",
            anim = "idle",
            flags = 49,
		}, {}, {}, function() -- Done
			TriggerServerEvent('QBCore:Server:AddItem', "taco-shake", 1)
            TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["taco-shake"], "add",1)
            QBCore.Functions.Notify("You made a Shake", "success")
		end, function()
			QBCore.Functions.Notify("Cancelled..", "error")
		end)
	else 
		QBCore.Functions.Notify("You must be Clocked into work", "error")
	end
end)


RegisterNetEvent("ss-taco:Meat")
AddEventHandler("ss-taco:Meat", function()
    if onDuty then
    QBCore.Functions.TriggerCallback('QBCore:HasItem', function(HasItem)
        if HasItem then
            MakeMeat()
        else
            QBCore.Functions.Notify("You don't have any minced meat..", "error")
        end
      end, 'minced-meat')
    else
        QBCore.Functions.Notify("You must be Clocked into work", "error")
    end
end)

----------------
-- Functions
----------------

function MakeMeat()
    TriggerServerEvent('QBCore:Server:RemoveItem', "minced-meat", 1)
    QBCore.Functions.Progressbar("pickup", "Cooking the Meat..", 4000, false, true, {
        disableMovement = true,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = false,
    },{
        animDict = "amb@prop_human_bbq@male@base",
        anim = "base",
        flags = 8,
    }, {
        model = "prop_cs_fork",
        bone = 28422,
        coords = { x = -0.005, y = 0.00, z = 0.00 },
        rotation = { x = 175.0, y = 160.0, z = 0.0 },
    }    
)
    Citizen.Wait(4000)
    TriggerServerEvent('QBCore:Server:AddItem', "cooked-minced-meat", 1)
    QBCore.Functions.Notify("You cooked the meat", "success")
    StopAnimTask(PlayerPedId(), "amb@prop_human_bbq@male@base", "base", 1.0)
end

function NearPed(model, coords, gender, animDict, animName, scenario)
	RequestModel(model)
	while not HasModelLoaded(model) do
		Citizen.Wait(50)
	end

	if Config.MinusOne then
		spawnedPed = CreatePed(Config.GenderNumbers[gender], model, coords.x, coords.y, coords.z - 1.0, coords.w, false, true)
	else
		spawnedPed = CreatePed(Config.GenderNumbers[gender], model, coords.x, coords.y, coords.z, coords.w, false, true)
	end

	SetEntityAlpha(spawnedPed, 0, false)

	if Config.Frozen then
		FreezeEntityPosition(spawnedPed, true)
	end

	if Config.Invincible then
		SetEntityInvincible(spawnedPed, true)
	end

	if Config.Stoic then
		SetBlockingOfNonTemporaryEvents(spawnedPed, true)
	end

	if animDict and animName then
		RequestAnimDict(animDict)
		while not HasAnimDictLoaded(animDict) do
			Citizen.Wait(50)
		end

		TaskPlayAnim(spawnedPed, animDict, animName, 8.0, 0, -1, 1, 0, 0, 0)
	end

    if scenario then
        TaskStartScenarioInPlace(spawnedPed, scenario, 0, true)
    end

	if Config.FadeIn then
		for i = 0, 255, 51 do
			Citizen.Wait(50)
			SetEntityAlpha(spawnedPed, i, false)
		end
	end

	return spawnedPed
end

-------------
-- Target
-------------

Citizen.CreateThread(function()

	exports['qb-target']:AddBoxZone("Duty", vector3(20.65, -1601.46, 29.38), 0.8, 2, {
		name = "Duty",
		heading = 32,
		debugPoly = false,
		minZ=28.0,
		maxZ=30.0,
	}, {
		options = {
		    {  
			    event = "ss-taco:Duty",
			    icon = "far fa-clipboard",
			    label = "Clock On/Off",
			    job = "taco",
		    },
		},
		distance = 1.5
	})

    exports['qb-target']:AddBoxZone("MakeShake", vector3(13.5, -1595.69, 29.38), 1, 1, {
		name = "MakeShake",
		heading = 32,
		debugPoly = false,
		minZ=28.0,
		maxZ=30.0,
	}, {
		options = {
		    {  
			    event = "ss-taco:Shake",
			    icon = "fas fa-glass-cheers",
			    label = "Make Shake",
			    job = "taco",
		    },
		},
		distance = 1.5
	})

    exports['qb-target']:AddBoxZone("CookMeat", vector3(10.7, -1599.02, 29.35), 1.8, 0.7, {
		name = "CookMeat",
		heading = 32,
		debugPoly = false,
		minZ=28.0,
		maxZ=30.0,
	}, {
		options = {
		    {  
			    event = "ss-taco:Meat",
			    icon = "fas fa-bacon",
			    label = "Cook the meat",
			    job = "taco",
		    },
		},
		distance = 1.5
	})

	exports['qb-target']:AddBoxZone("Tray1", vector3(10.73, -1605.0, 29.37), 1, 1, {
		name = "Tray1",
		heading = 35.0,
		debugPoly = false,
		minZ=29.5,
		maxZ=29.57,
	}, {
		options = {
		    {
			    event = "ss-taco:Tray1",
			    icon = "far fa-clipboard",
			    label = "Open Tray",
		    },
		},
		distance = 1.5
	})
    
    exports['qb-target']:AddBoxZone("Tray2", vector3(6.51, -1605.04, 29.37), 1, 1, {
		name="Tray2",
		heading=318,
		debugPoly=false,
		minZ=29.5,
		maxZ=29.57,
	}, {
		options = {
		    {
			    event = "ss-taco:Tray2",
			    icon = "far fa-clipboard",
			    label = "Open Tray",
		    },
		},
		distance = 1.5
	})

    exports['qb-target']:AddBoxZone("tacofridge", vector3(17.03, -1599.7, 29.38), 0.7, 1, {
        name="tacofridge",
        heading=50,
        debugPoly=false,
        minZ=29.0,
        maxZ=30.6,
    }, {
        options = {
            {
                event = "qb-menu:OrderMenuTaco",
                icon = "fas fa-carrot",
                label = "Order Ingredients!",
                job = "taco",
            },
        },
        distance = 1.5
    })

    exports['qb-target']:AddBoxZone("tacoStorage", vector3(12.67, -1600.28, 29.38), 1.3, 1.0, {
        name="tacoStorage",
        heading=50,
        debugPoly=false,
        minZ=28.0,
        maxZ=30.0,
    }, {
        options = {
            {
                event = "ss-taco:Storage",
                icon = "fas fa-box",
                label = "Storage",
                job = "taco",
            },
        },
        distance = 1.5
    })

    exports['qb-target']:AddBoxZone("crafttaco", vector3(16.14, -1597.64, 29.38), 0.7, 2, {
        name="crafttaco",
        heading=140,
        debugPoly=false,
        minZ=28.0,
        maxZ=30.0,
    }, {
        options = {
            {
                event = "qb-menu:Taco",
                icon = "fas fa-box",
                label = "Make Taco",
                job = "taco",
            },
        },
        distance = 1.5
    })

    exports['qb-target']:AddBoxZone("garage", vector3(26.34, -1603.39, 29.28), 1, 1, {
        name="garage",
        heading=140,
        debugPoly=false,
        minZ=28.0,
        maxZ=30.0,
    }, {
        options = {
            {
                event = "qb-menu:TacoGarage",
                icon = "fas fa-car",
                label = "Taco Garage",
                job = "taco",
            },
        },
        distance = 3.5
    })

end)


------------
-- QB Menu
------------

RegisterNetEvent('qb-menu:Taco', function(data)
    TriggerEvent('qb-menu:client:openMenu', {
        {
            id = 0,
            header = "🌮 | Available Tacos | 🌮",
            txt = "",
        },
        {
            id = 1,
            header = "• Make a Taco",
            txt = "Tortilla , Cooked Meat , Salad",
            params = {
                event = "ss-taco:Taco"
            }
        },
        {
            id = 2,
            header = "⬅ Close",
            txt = '',
            params = {
                event = 'qb-menu:closeMenu',
            }
        }
    })
end)

RegisterNetEvent('qb-menu:OrderMenuTaco', function(data)
    TriggerEvent('qb-menu:client:openMenu', {
        {
            id = 0,
            header = "🧊 | Taco Fridge Menu | 🧊",
            txt = "",
        },
        {
            id = 1,
            header = "🍱 • Order Items",
            txt = "Order New Ingredients!",
            params = {
                event = "ss-taco:shop"
            }
        },
        {
            id = 2,
            header = "🥶 • Open Fridge",
            txt = "See what you have in storage",
            params = {
                event = "ss-taco:Storage"
            }
        },
        {
            id = 3,
            header = "⬅ Close Menu",
            txt = "",
            params = {
                event = "qb-menu:client:closeMenu"
            }
        },
    })
end)

RegisterNetEvent('qb-menu:TacoGarage', function()
    TriggerEvent('qb-menu:client:openMenu', {
        {
            id = 1,
            header = "🌮 | Taco Garage | 🌮",
            txt = ""
        },
        {
            id = 2,
            header = "🚘 • Taco Van",
            txt = "Taco Van",
            params = {
                event = "ss-taco:garage:SpawnVehicle",
                args = {
                    vehicle = 'taco',
                    
                }
            }
        },
        {
            id = 3,
            header = "🅿 Store Vehicle",
            txt = "Store Vehicle Inside Garage",
            params = {
                event = "ss-taco:garage:StoreVehicle",
                args = {
                    
                }
            }
        },      
        {
            id = 4,
            header = "⬅ Close Menu",
            params = {
                event = "qb-menu:client:closeMenu", 
            }
        },  
    })
end)
