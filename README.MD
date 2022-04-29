## Dependencies :

QBCore Framework - https://github.com/QBCore-framework/qb-core

PolyZone - https://github.com/mkafrin/PolyZone

qb-target - https://github.com/BerkieBb/qb-target / https://github.com/loljoshie/qb-target

qb-menu - https://github.com/QBCore-framework/qb-menu / https://github.com/loljoshie/qb-menu

taco mlo - https://www.gta5-mods.com/maps/taco-restaurant-mlo-add-on-fivem-pablitomamutopaputo

## Credits : 

ss-taco Job  - https://discord.gg/BZnUFcUKRT
ss-taco job script by Stormy Scratch

## Insert into #qb-core --> shared
1. Insert this lines to your qb-core/shared/items.lua

	--Taco
	["minced-meat"] 				 = {["name"] = "minced-meat", 			 	  	["label"] = "Minced Meat", 				["weight"] = 125, 		["type"] = "item", 		["image"] = "minced-meat.png", 		    ["unique"] = false, 	["useable"] = false, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "An Ingredient"},
	["cooked-minced-meat"] 			 = {["name"] = "cooked-minced-meat", 			["label"] = "Cooked Minced Meat", 		["weight"] = 125, 		["type"] = "item", 		["image"] = "cooked-minced-meat.png", 	["unique"] = false, 	["useable"] = false, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "An Ingredient"},
	["salad"] 			 			 = {["name"] = "salad", 						["label"] = "Salad", 					["weight"] = 125, 		["type"] = "item", 		["image"] = "salad.png", 				["unique"] = false, 	["useable"] = false, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "An Ingredient"},
	["taco"] 			 			 = {["name"] = "taco", 							["label"] = "Taco", 					["weight"] = 125, 		["type"] = "item", 		["image"] = "taco.png", 				["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Taco"},
	["tortilla"] 			 		 = {["name"] = "tortilla", 						["label"] = "Tortilla", 				["weight"] = 125, 		["type"] = "item", 		["image"] = "tortilla.png", 			["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Tortilla"},
	["taco-shake"] 			 		 = {["name"] = "taco-shake", 					["label"] = "Taco Shake", 				["weight"] = 125, 		["type"] = "item", 		["image"] = "taco-shake.png", 			["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Taco Shake"},

2. Insert this lines to your qb-core/shared/jobs.lua

    ["taco"] = {
		label = "Taco Employee",
		defaultDuty = true,
		grades = {
			['1'] = {
                name = "Employee",
                payment = 75
            },
			['2'] = {
                name = "Shift Manager",
                payment = 100
            },
			['3'] = {
                name = "Manager",
                payment = 125
            },
			['4'] = {
                name = "CEO",
				isboss = true,
                payment = 150
            },
        },
	},


## Inventory images

drag and drop the image from ss-taco/images to qb-inventory\html\images

## Insert into #qb-smallresources --> config.lua

Consumeables = {

--Food 

["taco"] = math.random(40, 60),

}

ConsumeablesDrink = {

--Drinks
["taco-shake"] = math.random(40, 50),

}

restart your server and you are done! enjoy❤
