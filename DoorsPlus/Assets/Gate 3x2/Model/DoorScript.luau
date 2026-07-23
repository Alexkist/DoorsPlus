--// locals
--// Services
local TS = game:GetService("TweenService")

--// Objects
local Container = script.Parent
local Gate = Container.Gate

local Configuration = Container:WaitForChild("Configuration")

local OpenDoorEvent = Container.OpenDoor

--// System Table
local Sys = {
	--// Connections
	Orig = {}, -- ["DoorName"] = OrigCFrame
	Active_Tweens = {}, -- ["TweenName"] = Tween
	-- The only Job of Active_Tweens is literally to be able to cancel a Tween, at any time.
}

-- System functions --

--// Plays a Tween within Sys.Tweens, and clears it after
-- This also returns the Tween if you need it!
function Sys:PlayTween(Name : string, Tween : Tween)
	--// Move to active Tweens
	Sys.Active_Tweens[Name] = Tween

	--// Play
	Tween:Play()

	--// Purge Tween
	task.defer(function()
		Tween.Completed:Connect(function()
			Sys.Active_Tweens[Name] = nil
		end)
	end)

	--// Export
	return Tween
end

--// Clears all Tweens
function Sys:PurgeTweens()
	--// Clear Tweens
	for Name, Tween in pairs(Sys.Active_Tweens) do
		if Tween:IsA("Tween") then
			--// Cancel Tween
			Tween:Cancel()
			
			--// Remove from Table
			Sys.Active_Tweens[Name] = nil
		end
	end
end



-- functions --

--// Tweens the Door to Open
local function OpenDoor()
	--// locals
	local Gate_Main = Gate.Main
	
	--// Purge Tweens
	Sys:PurgeTweens()
	
	--// Generate Info (this will respect Config values)
	local Info = TweenInfo.new(
		Configuration.TweenTime.Value,
		Enum.EasingStyle.Sine
	)
	
	--// Generate Tween
	local GateTween = TS:Create(
		Gate_Main,
		Info,
		{CFrame = Gate_Main.CFrame * CFrame.new(0, 7, 0)}
	)
	
	--// Anchor Doors
	Gate_Main.Anchored = true
	
	--// Play
	local Gate_DoorTween = Sys:PlayTween("Gate_Open", GateTween)
end

--// Tweens the Door to Close
local function CloseDoor()
	--// locals
	local Gate_Main = Gate.Main
	
	--// Purge Tweens
	Sys:PurgeTweens()

	--// Generate Info (this will respect Config values)
	local Info = TweenInfo.new(
		Configuration.TweenTime.Value,
		Enum.EasingStyle.Sine
	)

	--// Generate Tween
	local GateTween = TS:Create(
		Gate_Main,
		Info,
		{CFrame = Sys.Orig["Gate"]}
	)

	--// Play
	local Gate_DoorTween = Sys:PlayTween("Gate_Close", GateTween)
	
	--// Connect Complete
	Gate_DoorTween.Completed:Connect(function()
		--// Unanchor Doors
		Gate_Main.Anchored = false
	end)	
end



--// Get OrigValues
local Gate_Orig = Gate.Main.CFrame

--// Set System
Sys.Orig["Gate"] = Gate_Orig




-- Connections --
OpenDoorEvent.SourceValueChanged:Connect(function(value)
	if value >= 0.5 then
		--// Open Doors
		OpenDoor()
	else
		CloseDoor()
	end
end)

--// Complete
print(`[DoorsPlus : {Container:GetFullName()}]: Set up!`)