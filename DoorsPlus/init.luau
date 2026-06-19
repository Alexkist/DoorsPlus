--[[ Build Island ModKit V2 by Toybox Development

roblox.com/groups/7712711/Toybox-Development#!/about

Build Island ModKit V2 made by Blockdown64

]]

-- The modkit name is the name of this ModuleScript

local modkit = {
	description = "Detailed and feature rich doors"; -- Description of the modkit
	thumbnail = "rbxassetid://13832154002"; -- Thumbnail that will appear in the import menu
	credit = { -- User IDs of the creator(s) of the modkit
		650334491, 1179738915;
	}
}

--[[ This kit contains objects named "Assets" and "Tools"

The children of "Assets" will be imported into the Stamper Tool when
the modkit is loaded.

The children of "Tools" will be imported into lighting when the modkit is 
loaded, where they will be accessible via admin commands, etc.

Other objects may be added in the future.

]]

-- This function is called when the mod is loaded
function modkit.Load(mods)
	--[[ 
	you do not need to add anything here, but you can add code here if you
	want to modify the mod in some way after it has been loaded.
	
	mods is a table that contains all of the loaded mods
	
	ex:
	local mymod = mods["#mymod"]
	local description = mymod.description
	]]
end

-- This function is called when the mod is unloaded
function modkit.Unload(mods)
	--[[
	you do not need to add anything here, but you can add code here if you
	want to modify the mod in some way before it is unloaded.
	]]
end

--[[ You can define code in this module outside of the start function,
as well as member variables for your module, but any yielding code
outside of the start function may cause issues in the server loading
your mod.
]]

return modkit

--[[ To submit this modkit, join our communications server under Social Links!

NOTE: TO JOIN OUR COMMUNICATIONS SERVER AND TO SUBMIT MODKITS YOU MUST BE AT LEAST 13 YEARS OF AGE!]]