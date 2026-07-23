--// locals
--// Services
local TS = game:GetService("TweenService")

--// Objects
local Bulb = script.Parent
local Sound = Bulb.Sound
local Container = Bulb.Parent

local ActivationEvent = Bulb.Activate
local Configuration = Container:WaitForChild("Configuration")

--// TweenService
local Info = TweenInfo.new(
	1.5,
	Enum.EasingStyle.Linear,
	Enum.EasingDirection.InOut,
	-1
)

--// Variables
local AlarmTween = nil



-- functions --

--// Activates the Alarm
local function Active()
	--// Generate Tween
	local Tween = TS:Create(
		Bulb,
		Info,
		{Orientation = Bulb.Orientation + Vector3.new(0, 360, 0)}
	)
	
	--// Set Variable and Play
	AlarmTween = Tween
	AlarmTween:Play()
	
	--// Enable Lights and Apply Config
	Bulb.RightLight.Enabled = true
	Bulb.LeftLight.Enabled = true
	Bulb.RightLight.Brightness = Configuration.Brightness.Value
	Bulb.LeftLight.Brightness = Configuration.Brightness.Value
	
	--// Play Sound and Apply Config
	Sound.SoundId = `rbxassetid://{Configuration["Sound ID"].Value}`
	Sound:Play()
end

--// Deactivates the Alarm
local function Deactivate()
	--// Stop Tween
	AlarmTween:Cancel()

	--// Enable Lights
	Bulb.RightLight.Enabled = false
	Bulb.LeftLight.Enabled = false
	
	--// Stop Sound
	Sound:Stop()
	
	--// Clear Tween
	AlarmTween = nil
end




-- Connections --
ActivationEvent.SourceValueChanged:Connect(function(value)
	if value >= 0.5 then
		Active()
		
	else
		Deactivate()
	end
end)