--// locals
--// Services
local TS = game:GetService("TweenService")

--// Objects
local Container = script.Parent
local Right = Container.Right
local Left = Container.Left

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
	local Left_Main = Left.Main
	local Right_Main = Right.Main
	
	--// Purge Tweens
	Sys:PurgeTweens()
	
	--// Generate Info (this will respect Config values)
	local Info = TweenInfo.new(
		Configuration.TweenTime.Value,
		Enum.EasingStyle.Sine
	)
	
	--// Generate Tween
	local LeftTween = TS:Create(
		Left_Main,
		Info,
		{CFrame = Left_Main.CFrame * CFrame.new(3.25, 0, 0)}
	)
	local RighTween = TS:Create(
		Right_Main,
		Info,
		{CFrame = Right_Main.CFrame * CFrame.new(3.25, 0, 0)}
	)
	
	--// Anchor Doors
	Left_Main.Anchored = true
	Right_Main.Anchored = true
	
	--// Play
	local Left_DoorTween = Sys:PlayTween("Left_Door_Open", LeftTween)
	local Right_DoorTween = Sys:PlayTween("Right_Door_Open", RighTween)
end

--// Tweens the Door to Close
local function CloseDoor()
	--// locals
	local Left_Main = Left.Main
	local Right_Main = Right.Main
	
	--// Purge Tweens
	Sys:PurgeTweens()

	--// Generate Info (this will respect Config values)
	local Info = TweenInfo.new(
		Configuration.TweenTime.Value,
		Enum.EasingStyle.Sine
	)

	--// Generate Tween
	local LeftTween = TS:Create(
		Left_Main,
		Info,
		{CFrame = Sys.Orig["LeftDoor"]}
	)
	local RighTween = TS:Create(
		Right_Main,
		Info,
		{CFrame = Sys.Orig["RightDoor"]}
	)

	--// Play
	local Left_DoorTween = Sys:PlayTween("Left_Door_Open", LeftTween)
	local Right_DoorTween = Sys:PlayTween("Right_Door_Open", RighTween)
	
	--// Connect Complete
	Left_DoorTween.Completed:Connect(function()
		--// Unanchor Doors
		Left_Main.Anchored = false
		Right_Main.Anchored = false
	end)	
end



--// Get OrigValues
local Left_Orig = Left.Main.CFrame
local Right_Orig = Right.Main.CFrame

--// Set System
Sys.Orig["LeftDoor"] = Left_Orig
Sys.Orig["RightDoor"] = Right_Orig




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