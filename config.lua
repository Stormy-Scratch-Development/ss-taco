Config = {};

Config.Invincible = true -- Is the ped going to be invincible?

Config.Frozen = true -- Is the ped frozen in place?

Config.Stoic = true -- Will the ped react to events around them?

Config.FadeIn = true -- Will the ped fade in and out based on the distance. (Looks a lot better.)

Config.DistanceSpawn = 20.0 -- Distance before spawning/despawning the ped. (GTA Units.)

Config.MinusOne = true -- Leave this enabled if your coordinates grabber does not -1 from the player coords.

Config.UseBlips = true -- Want to use blip on map?

Config.BlipLocation = {
    {title = "Taco", colour = 5, id = 209, x = 12.04, y = -1602.41, z = 29.37},  --Taco Blip
}

Config.GenderNumbers = { -- No reason to touch these.
	['male'] = 4,
	['female'] = 5
}

Config.PedList = {
	{   -- Taco
		model = `cs_solomon`, -- Model name as a hash.
		coords = vector4(26.46, -1603.4, 29.28, 49.14), -- Hawick Ave (X, Y, Z, Heading)
		gender = 'male' -- The gender of the ped, used for the CreatePed native.
	},
}

Config.Items = {
    [1] = {
        name = "tortilla",
        price = 0,
        amount = 10,
        info = {},
        type = "item",
        slot = 1,
    },
    [2] = {
        name = "salad",
        price = 0,
        amount = 10,
        info = {},
        type = "item",
        slot = 2,
    },
    [3] = {
        name = "minced-meat",
        price = 0,
        amount = 10,
        info = {},
        type = "item",
        slot = 3,
    },
}
