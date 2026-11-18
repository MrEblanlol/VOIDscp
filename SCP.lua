if not game:IsLoaded() then
	game.Loaded:Wait()
end

if
	getgenv().SCPRoleplay_VoidHub_Singleton
	and type(getgenv().SCPRoleplay_VoidHub_Singleton) == "table"
	and type(getgenv().SCPRoleplay_VoidHub_Singleton.Destroy) == "function"
then
	pcall(function()
		getgenv().SCPRoleplay_VoidHub_Singleton:Destroy()
	end)
end

local tbl = {Connections = {}, TeamHighlights = {}, ZombieHighlights = {}, NameTags = {}}
tbl.Window = nil
tbl.FOVGui = nil
tbl.TagFolder = nil
tbl.RestoreHook = nil
tbl.Alive = true

function tbl:Track(arg2)
	table.insert(self.Connections, arg2)
	return arg2
end

function tbl:Destroy()
	self.Alive = false

	for _, v1 in self.Connections do
		pcall(function()
			v1:Disconnect()
		end)
	end

	self.Connections = {}

	for _, v2 in self.TeamHighlights do
		pcall(function()
			v2:Destroy()
		end)
	end

	self.TeamHighlights = {}

	for _, v3 in self.ZombieHighlights do
		pcall(function()
			v3:Destroy()
		end)
	end

	self.ZombieHighlights = {}

	for _, v4 in self.NameTags do
		pcall(function()
			v4:Destroy()
		end)
	end

	self.NameTags = {}

	if self.FOVGui then
		pcall(function()
			self.FOVGui:Destroy()
		end)
		self.FOVGui = nil
	end

	if self.TagFolder then
		pcall(function()
			self.TagFolder:Destroy()
		end)
		self.TagFolder = nil
	end

	if self.StaffAlert then
		pcall(function()
			self.StaffAlert:Destroy()
		end)
		self.StaffAlert = nil
	end

	if self.HopSplash then
		pcall(function()
			self.HopSplash:Destroy()
		end)
		self.HopSplash = nil
	end

	if self.RestoreLighting then
		pcall(self.RestoreLighting)
		self.RestoreLighting = nil
	end

	if self.RestoreHook then
		pcall(self.RestoreHook)
		self.RestoreHook = nil
	end

	if self.Window and type(self.Window.Unload) == "function" then
		pcall(function()
			self.Window:Unload()
		end)
	end

	getgenv().SCPRoleplay_VoidHub_Singleton = nil
end

getgenv().SCPRoleplay_VoidHub_Singleton = tbl

local v1 = cloneref or function(arg1)
	return arg1
end

local v2 = clonefunction or function(arg1)
	return arg1
end

local v3 = newcclosure or v2
local v4 = identifyexecutor and identifyexecutor() or "Your executor"

if not (hookfunction and (filtergc or getgc and debug.getconstants)) then
	return error(v4 .. " is missing " .. (not hookfunction and "hookfunction " or "") .. (not (filtergc and (getgc and debug.getconstants)) and "filtergc getgc debug.getconstants" or ""))
end

v1(game:GetService("ReplicatedStorage"))
local v5 = v1(game:GetService("Players"))
local v6 = v1(game:GetService("UserInputService"))
local v7 = v1(game:GetService("RunService"))
v1(game:GetService("GuiService"))
local LocalPlayer = v5.LocalPlayer
local CurrentCamera = workspace.CurrentCamera
local module = loadstring(game:HttpGet("https://sneekysscripts.uk/Scripts/FILTERGC_LIBRARY/main.luau"))()
local Controller = LocalPlayer.PlayerScripts:FindFirstChild("Controller")

if not Controller then
	return warn("Script needs updating")
end

local v8 = module(Controller, false, "Bullet", "EasterEggThing", "SCP-066")

if not v8 then
	return warn("Failed to retrieve function")
end

local v9 = getrenv and getrenv() or getgenv and getgenv() or _G
local v10 = v9 and v9.shared or nil
local v11 = v10 and v10.Delta or nil

local v12 = v11 and v11.Get and function(arg1, arg2)
	local ok, result = pcall(function()
		return v11:Get("IsRK")(arg1, arg2)
	end)

	if not ok then
		return true
	end

	return result == false
end or nil

local function func(arg1)
	if not arg1 then
		return true
	end

	if not v12 then
		return true
	end

	local v1 = v9 and v9.shared and v9.shared.Delta and v9.shared.Delta.Player or nil

	if not v1 then
		return true
	end

	return v12(v1, arg1)
end

local raycastParams = RaycastParams.new()
raycastParams.FilterType = Enum.RaycastFilterType.Exclude
raycastParams.IgnoreWater = true
raycastParams.RespectCanCollide = true

local function func1(arg1, arg2)
	local Position = arg1.Position
	local RightVector = arg2.RightVector
	local UpVector = arg2.UpVector
	local v1 = math.max(arg1.Size.X, arg1.Size.Y, arg1.Size.Z) * 0.55

	local tbl = {
		(RightVector + UpVector).Unit,
		(RightVector - UpVector).Unit,
		(-RightVector + UpVector).Unit,
		(-RightVector - UpVector).Unit,
	}

	local v2 = table.create(4)

	for k, v3 in tbl do
		v2[k] = arg1:GetClosestPointOnSurface(Position + v3 * v1)
	end

	return v2
end

local function func2(arg1, arg2)
	local Character = LocalPlayer.Character

	if not (Character and arg1) then
		return false, nil
	end

	local workspaceRef = workspace
	raycastParams.FilterDescendantsInstances = {Character, workspaceRef.CurrentCamera}
	local v1 = workspaceRef:Raycast(arg2, arg1.Position - arg2, raycastParams)

	if not v1 then
		return true, nil
	end

	if v1.Instance:IsDescendantOf(arg1.Parent) then
		return true, v1.Instance
	end

	for _, v2 in func1(arg1, workspace.CurrentCamera.CFrame) do
		local v3 = workspace:Raycast(arg2, v2 - arg2, raycastParams)

		if not v3 then
			return true, nil
		end

		if v3.Instance:IsDescendantOf(arg1.Parent) then
			return true, v3.Instance
		end
	end

	return false, v1.Instance
end

local num = 100
local v13 = getgenv().sneeky_fov_size or 300
local num1 = 100
local str = "Zombies First"
local flag = true
local flag1 = true
local flag2 = true
local flag3 = true
local tbl1 = {}
local num2 = 5000
local num3 = 8

local function func3(arg1)
	local v1

	if arg1 and arg1:IsA("BasePart") then
		v1 = arg1
	else
		v1 = nil
	end

	return v1
end

local function func4(arg1, arg2)
	local v1, v2 = CurrentCamera:WorldToViewportPoint(arg1.Position)

	if not v2 then
		return nil
	end

	return (Vector2.new(v1.X, v1.Y) - arg2).Magnitude
end

local function func5(arg1, arg2, arg3, arg4)
	if (arg1.Position - arg2).Magnitude > num2 then
		return false
	end

	if not flag2 then
		return true
	end

	return arg3 ~= nil and func2(arg3, arg2) or arg4 ~= nil and func2(arg4, arg2)
end

local function func6(arg1, arg2, arg3)
	local v5
	local v1 = arg3
	local Zombies = workspace:FindFirstChild("Zombies")

	if not Zombies then
		return nil, arg3
	end

	for _, v2 in Zombies:GetChildren() do
		if v2:IsA("Model") then
			local Humanoid = v2:FindFirstChildOfClass("Humanoid")
			if Humanoid and not (Humanoid.Health <= 0) then
				local v3 = func3(v2:FindFirstChild("Head")) or v2.PrimaryPart or func3(v2:FindFirstChild("HumanoidRootPart"))
				if v3 then
					local v4 = func4(v3, arg2)
					if v4 and not (v4 >= v1) then
						if func5(v3, arg1, v3) then
							v5 = v3
							v1 = v4
						end
					end
				end
			end
		end
	end

	return v5, v1
end

local function func7(arg1, arg2, arg3)
	local v7

	for _, v1 in v5:GetPlayers() do
		if v1 ~= LocalPlayer then
			if not (v1.Team and tbl1[v1.Team.Name]) then
				local Character = v1.Character
				if Character and not Character:FindFirstChildOfClass("ForceField") then
					local Humanoid = Character:FindFirstChild("Humanoid")
					if not (Humanoid and Humanoid.Health <= 0) then
						local v2 = func3(Character:FindFirstChild("Head"))
						local v3 = Character.PrimaryPart or func3(Character:FindFirstChild("HumanoidRootPart"))
						local v4

						if num == 100 then
							v4 = v2 or v3
						else
							v4 = v3 or v2
						end

						if v4 then
							local v6 = func4(v4, arg2)
							if v6 and not (v6 >= arg3) then
								if func5(v4, arg1, v2, v3) then
									if not (flag3 and func(v1) == false) then
										v7 = v4
										arg3 = v6
									end
								end
							end
						end
					end
				end
			end
		end
	end

	return v7, arg3
end

local function func8(arg1)
	CurrentCamera = workspace.CurrentCamera or CurrentCamera
	local v1 = CurrentCamera.ViewportSize / 2

	if str == "Nearest Crosshair" then
		local v5
		local v2 = v13

		if flag1 then
			local v3, v4 = func6(arg1, v1, v13)
			v5 = v3
			v2 = v4
		end

		if flag then
			local v6 = func7(arg1, v1, v2)
			if v6 then
				return v6
			end
		end

		return v5
	end

	local tbl

	if str == "Players First" then
		tbl = {flag and func7, flag1 and func6}
	else
		tbl = {flag1 and func6, flag and func7}
	end

	for i = 1, 2 do
		local v7 = tbl[i]
		if v7 then
			local v8 = v7(arg1, v1, v13)
			if v8 then
				return v8
			end
		end
	end

	return nil
end

local v14 = Color3.fromRGB(0, 100, 0)
local v15 = Color3.fromRGB(255, 0, 0)
local v16 = typeof(setthreadidentity) == "function"
local v17

if v16 then
	local ok, result = pcall(function()
		return gethui and gethui()
	end)
	v17 = ok and result or v1(game:GetService("CoreGui"))
else
	v17 = LocalPlayer:WaitForChild("PlayerGui")
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "VoidSCP_FOV"
screenGui.IgnoreGuiInset = true
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 1
screenGui.Parent = v17
tbl.FOVGui = screenGui
local frame = Instance.new("Frame")
frame.Name = "Circle"
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.Position = UDim2.fromScale(0.5, 0.5)
frame.Size = UDim2.fromOffset(v13 * 2, v13 * 2)
frame.BackgroundTransparency = 1
frame.Visible = false
frame.Parent = screenGui
local uIStroke = Instance.new("UIStroke")
uIStroke.Thickness = 1.5
uIStroke.Color = v14
uIStroke.Parent = frame
local uICorner = Instance.new("UICorner")
uICorner.CornerRadius = UDim.new(1, 0)
uICorner.Parent = frame
local frame1 = Instance.new("Frame")
frame1.Name = "SnapLine"
frame1.AnchorPoint = Vector2.new(0.5, 0.5)
frame1.BorderSizePixel = 0
frame1.BackgroundColor3 = v15
local flag4 = false
frame1.Visible = false
frame1.Parent = screenGui
local flag5 = false
local flag6 = false
local v37
local flag7 = false
local flag8 = false
local flag9 = false
local v18 = Color3.fromRGB(60, 220, 90)
local v19 = Color3.fromRGB(255, 60, 60)
local num4 = 0.5
local TeamHighlights = tbl.TeamHighlights
local NameTags = tbl.NameTags
local func9
local flag10 = false
local func18
local num5 = 0

local v20 = table.pack(v7.RenderStepped:Connect(function()
	if v16 then
		pcall(setthreadidentity, 8)
	end

	CurrentCamera = workspace.CurrentCamera or CurrentCamera
	frame.Visible = flag5
	frame.Size = UDim2.fromOffset(v13 * 2, v13 * 2)
	local v1 = v37

	if flag6 and v1 and v1.Parent then
		local v2, v3 = CurrentCamera:WorldToViewportPoint(v1.Position)
		local v4 = CurrentCamera.ViewportSize / 2
		local v6 = Vector2.new(v2.X, v2.Y) - v4
		frame1.Position = UDim2.fromOffset(v4.X + v6.X / 2, v4.Y + v6.Y / 2)
		frame1.Size = UDim2.fromOffset(v6.Magnitude, 2)
		frame1.Rotation = math.deg(math.atan2(v6.Y, v6.X))
		frame1.Visible = v3
	else
		frame1.Visible = false
	end

	if flag10 and func18 then
		pcall(func18)
	end

	num5 = num5 + 1

	if num5 % num3 ~= 0 then
		return
	end

	local Position = CurrentCamera.CFrame.Position
	local ok, result = pcall(func8, Position)
	local v7

	if ok then
		v7 = result
	else
		v7 = nil
	end

	v37 = v7

	if v16 then
		pcall(setthreadidentity, 8)
	end

	uIStroke.Color = v37 and v15 or v14

	if flag7 and (flag8 or flag9) and func9 then
		for _, v8 in v5:GetPlayers() do
			if v8 ~= LocalPlayer then
				local ok1, result1 = pcall(func9, v8)
				if ok1 then
					local v9 = result1 and result1.Adornee
					local v10 = result1 and result1:FindFirstChild("Label")

					if flag8 and v9 and v10 then
						local v11 = Position - v9.Position
						v10.Text = string.format("%s [%d studs]", v8.Name, math.floor(v11.Magnitude))
					end

					if flag9 then
						local v12 = result1 and result1:FindFirstChild("HealthBack")
						local v17 = v12 and v12:FindFirstChild("HealthFill")
						local Character = v8.Character
						local v20 = Character and Character:FindFirstChildOfClass("Humanoid")

						if v17 and v20 then
							local v21

							if v20.MaxHealth > 0 then
								v21 = math.clamp(v20.Health / v20.MaxHealth, 0, 1)
							else
								v21 = 0
							end

							v17.Size = UDim2.fromScale(v21, 1)
							v17.BackgroundColor3 = v19:Lerp(v18, v21)
						end
					end
				end
			end
		end
	end
end))

tbl:Track(table.unpack(v20, 1, v20.n))

local Window = loadstring(game:HttpGet("https://sirius.menu/gen2"))():CreateWindow({
	name = "Void Scripts | SCP Roleplay",
	subtitle = "Universal Hub",
	theme = "cobalt",
	sidebarLayout = true,
	configuration = {
		autoSave = true,
		autoLoad = true,
		fileName = "VoidScripts_SCPRoleplay",
		customFolder = "SCPRoleplay",
	},
})

tbl.Window = Window
local Tab = Window:CreateTab({name = "Combat", icon = 10734975486})
local Tab1 = Window:CreateTab({name = "Visuals", icon = 7733779610})
local Tab2 = Window:CreateTab({name = "Player", icon = 10734950309})
local Tab3 = Window:CreateTab({name = "Settings", icon = 93364949241311})
local Tab4 = Window:CreateTab({name = "Info", icon = 93364949241311})
Tab:CreateSection({name = "Targeting"})

Tab:CreateToggle({
	name = "Silent Aim",
	description = "Feeds the hit-registration hook a locked-on target",
	value = false,
	flag = "Combat_SilentAim",
	callback = function(arg1)
		flag4 = arg1
	end,
})

Tab:CreateSlider({
	name = "Headshot Accuracy (%)",
	range = {0, 100},
	increment = 1,
	value = num,
	suffix = "%",
	flag = "Combat_HeadshotAccuracy",
	callback = function(arg1)
		num = arg1
	end,
})

local Input

local Slider = Tab:CreateSlider({
	name = "FOV Size",
	range = {10, 1000},
	increment = 1,
	value = v13,
	flag = "Combat_FOVSize",
	callback = function(arg1)
		v13 = arg1
		if Input then
			pcall(function()
				Input:Set(tostring(math.floor(arg1)), true)
			end)
		end
	end,
})

Input = Tab:CreateInput({
	name = "FOV Size (Exact)",
	description = "Type an exact FOV size from 10 to 1000",
	value = tostring(v13),
	placeholder = "10 - 1000",
	numeric = true,
	forgetState = true,
	callback = function(arg1)
		local num = tonumber(arg1)

		if not num then
			return
		end

		local v1 = math.clamp(math.floor(num + 0.5), 10, 1000)
		v13 = v1

		pcall(function()
			Slider:Set(v1, true)
		end)

		if tostring(v1) ~= arg1 then
			pcall(function()
				Input:Set(tostring(v1), true)
			end)
		end
	end,
})

Tab:CreateToggle({
	name = "Show FOV",
	description = "Draws the targeting circle on screen",
	value = false,
	flag = "Combat_ShowFOV",
	callback = function(arg1)
		flag5 = arg1
	end,
})

Tab:CreateKeybind({
	name = "Silent Aim Key",
	description = "Turns Silent Aim on or off without opening the menu",
	value = Enum.KeyCode.RightControl,
	flag = "Combat_SilentAimKey",
	callback = function()
		if v6:GetFocusedTextBox() then
			return
		end

		local v1 = not flag4
		flag4 = v1
		Window:Set("Combat_SilentAim", v1)
		Window:Notify({title = "Silent Aim", content = v1 and "Enabled" or "Disabled", duration = 2})
	end,
})

Tab:CreateSlider({
	name = "Hit Chance (%)",
	description = "Share of shots redirected to the target; the rest fire normally",
	range = {0, 100},
	increment = 1,
	value = 100,
	suffix = "%",
	flag = "Combat_HitChance",
	callback = function(arg1)
		num1 = arg1
	end,
})

Tab:CreateSection({name = "Target Filters"})

Tab:CreateDropdown({
	name = "Priority",
	description = "Which target wins when several are inside the FOV",
	options = {"Zombies First", "Players First", "Nearest Crosshair"},
	value = str,
	multiSelect = false,
	flag = "Combat_TargetMode",
	callback = function(arg1)
		local v1 = arg1

		if type(arg1) == "table" then
			v1 = arg1[1]
		end

		str = v1 or "Zombies First"
	end,
})

Tab:CreateDropdown({
	name = "Targets",
	description = "What Silent Aim is allowed to lock onto",
	options = {"Players", "Zombies"},
	value = {"Players", "Zombies"},
	multiSelect = true,
	flag = "Combat_TargetTypes",
	callback = function(arg1)
		flag = table.find(arg1, "Players") ~= nil
		flag1 = table.find(arg1, "Zombies") ~= nil
	end,
})

Tab:CreateToggle({
	name = "Wall Check",
	description = "Only locks onto targets you can actually see",
	value = true,
	flag = "Combat_WallCheck",
	callback = function(arg1)
		flag2 = arg1
	end,
})

Tab:CreateToggle({
	name = "Team Check",
	description = "Skips targets the game counts as friendly",
	value = true,
	flag = "Combat_TeamCheck",
	callback = function(arg1)
		flag3 = arg1
	end,
})

local tbl2 = {}

for _, v21 in v1(game:GetService("Teams")):GetTeams() do
	table.insert(tbl2, v21.Name)
end

table.sort(tbl2)

Tab:CreateDropdown({
	name = "Ignore Teams",
	description = "Never locks onto players on these teams",
	options = tbl2,
	value = {},
	multiSelect = true,
	placeholder = "None",
	flag = "Combat_IgnoreTeams",
	callback = function(arg1)
		table.clear(tbl1)
		for _, v1 in arg1 do
			tbl1[v1] = true
		end
	end,
})

Tab:CreateSlider({
	name = "Max Distance",
	description = "Ignores targets farther than this from your camera",
	range = {50, 5000},
	increment = 50,
	value = num2,
	suffix = " studs",
	flag = "Combat_MaxDistance",
	callback = function(arg1)
		num2 = arg1
	end,
})

Tab:CreateSlider({
	name = "Scan Rate",
	description = "Frames between target scans; lower reacts faster but costs more",
	range = {1, 15},
	increment = 1,
	value = num3,
	suffix = " frames",
	flag = "Combat_ScanRate",
	callback = function(arg1)
		num3 = math.max(1, math.floor(arg1))
	end,
})

Tab:CreateSection({name = "FOV Visuals"})

Tab:CreateToggle({
	name = "Snap Line",
	description = "Draws a line from the crosshair to the locked target",
	value = false,
	flag = "Combat_SnapLine",
	callback = function(arg1)
		flag6 = arg1
	end,
})

Tab:CreateColorPicker({
	name = "FOV Color",
	color = v14,
	flag = "Combat_FOVColor",
	callback = function(color)
		v14 = color
		if not v37 then
			uIStroke.Color = color
		end
	end,
})

Tab:CreateColorPicker({
	name = "Locked Color",
	description = "FOV circle and snap line color while a target is locked",
	color = v15,
	flag = "Combat_LockedColor",
	callback = function(backgroundColor3)
		v15 = backgroundColor3
		frame1.BackgroundColor3 = backgroundColor3

		if v37 then
			uIStroke.Color = backgroundColor3
		end
	end,
})

Tab1:CreateSection({name = "Team ESP"})
local flag11 = false
local v22 = Color3.fromRGB(0, 255, 255)
local flag12 = false
local num6 = 13
local color3 = Color3.new(1, 1, 1)
local flag13 = false
local ZombieHighlights = tbl.ZombieHighlights
local folder = Instance.new("Folder")
folder.Name = "VoidSCP_NameTags"
folder.Parent = workspace
tbl.TagFolder = folder

function func9(player)
	local v1 = NameTags[player]

	if v1 and v1.Parent ~= folder then
		pcall(function()
			v1:Destroy()
		end)
		v1 = nil
	end

	if not v1 then
		v1 = Instance.new("BillboardGui")
		v1.Name = "SCP_TeamESPTag"
		v1.Size = UDim2.new(0, 140, 0, 24)
		v1.StudsOffset = Vector3.new(0, 1.25, 0)
		v1.AlwaysOnTop = true
		local textLabel = Instance.new("TextLabel")
		textLabel.Name = "Label"
		textLabel.BackgroundTransparency = 1
		textLabel.Size = UDim2.new(1, 0, 0, 18)
		textLabel.Font = Enum.Font.Gotham
		textLabel.TextStrokeTransparency = 0.5
		textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
		textLabel.TextSize = num6
		textLabel.TextColor3 = color3
		textLabel.Parent = v1
		local frame = Instance.new("Frame")
		frame.Name = "HealthBack"
		frame.AnchorPoint = Vector2.new(0.5, 0)
		frame.Position = UDim2.new(0.5, 0, 0, 20)
		frame.Size = UDim2.new(0, 70, 0, 2)
		frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
		frame.BackgroundTransparency = 0.2
		frame.BorderSizePixel = 0
		frame.Parent = v1
		local uIStroke = Instance.new("UIStroke")
		uIStroke.Thickness = 1
		uIStroke.Color = Color3.new(0, 0, 0)
		uIStroke.Transparency = 0.6
		uIStroke.Parent = frame
		local frame1 = Instance.new("Frame")
		frame1.Name = "HealthFill"
		frame1.Size = UDim2.fromScale(1, 1)
		frame1.BackgroundColor3 = v18
		frame1.BorderSizePixel = 0
		frame1.Parent = frame
		v1.Parent = folder
		NameTags[player] = v1
	end

	local Character = player.Character
	local v2 = Character and Character:FindFirstChild("Head")

	if v1.Adornee ~= v2 then
		v1.Adornee = v2
	end

	v1.Enabled = v2 ~= nil
	local Label = v1:FindFirstChild("Label")

	if Label then
		Label.Visible = flag8
	end

	local HealthBack = v1:FindFirstChild("HealthBack")

	if HealthBack then
		HealthBack.Visible = flag9
	end

	return v1
end

local function func10()
	return flag12 and 1 or num4
end

local function func11(arg1)
	local v1 = TeamHighlights[arg1]

	if v1 then
		v1:Destroy()
		TeamHighlights[arg1] = nil
	end

	local v2 = NameTags[arg1]

	if v2 then
		v2:Destroy()
		NameTags[arg1] = nil
	end
end

local function func12(player)
	if player == LocalPlayer then
		return
	end

	local Character = player.Character

	if not Character then
		return
	end

	if not flag7 then
		func11(player)
		return
	end

	local v1 = TeamHighlights[player]

	-- recreate if highlight was destroyed (e.g. parented to old character)
	if not v1 or not v1.Parent then
		if v1 then v1:Destroy() end
		local highlight = Instance.new("Highlight")
		v1 = highlight
		highlight.Name = "SCP_TeamESP"
		highlight.OutlineTransparency = 0
		highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		TeamHighlights[player] = highlight
	end

	local v2 = flag11 and v22 or (player.TeamColor and player.TeamColor.Color or Color3.new(1, 1, 1))
	v1.FillTransparency = func10()
	v1.FillColor = v2
	v1.OutlineColor = v2
	-- when hitbox expander is on, adorn to HumanoidRootPart only so
	-- the enlarged Head doesn't bloat the ESP highlight bounding box
	local hb_adornee = (hb_enabled and Character:FindFirstChild("HumanoidRootPart")) or Character
	v1.Adornee = hb_adornee
	v1.Parent = workspace  -- parent to workspace so it survives CharacterRemoving

	if not (flag8 or flag9) then
		local v3 = NameTags[player]

		if v3 then
			v3:Destroy()
			NameTags[player] = nil
		end

		return
	end

	func9(player)
end

local function func13()
	for _, v1 in v5:GetPlayers() do
		func12(v1)
	end
end

local function func14(player)
	if player.Character then
		func12(player)
	end

	tbl:Track(player.CharacterAdded:Connect(function(char)
		-- wait for character to fully load before applying highlight
		char:WaitForChild("HumanoidRootPart", 10)
		task.wait()
		func12(player)
	end))

	tbl:Track(player.CharacterRemoving:Connect(function()
		func11(player)
	end))

	tbl:Track(player:GetPropertyChangedSignal("TeamColor"):Connect(function()
		func12(player)
	end))
end

for _, v23 in v5:GetPlayers() do
	func14(v23)
end

local v24 = table.pack(v5.PlayerAdded:Connect(func14))
tbl:Track(table.unpack(v24, 1, v24.n))
local v25 = table.pack(v5.PlayerRemoving:Connect(func11))
tbl:Track(table.unpack(v25, 1, v25.n))

Tab1:CreateToggle({
	name = "Team ESP",
	description = "Highlights every player using their current team color",
	value = false,
	flag = "Visuals_TeamESP",
	callback = function(arg1)
		flag7 = arg1
		func13()
	end,
})

Tab1:CreateSlider({
	name = "Highlight Transparency (%)",
	range = {0, 100},
	increment = 5,
	value = 50,
	suffix = "%",
	flag = "Visuals_HighlightTransparency",
	callback = function(arg1)
		num4 = arg1 / 100
		local v1 = func10()

		for _, v2 in TeamHighlights do
			v2.FillTransparency = v1
		end

		for _, v3 in ZombieHighlights do
			v3.FillTransparency = v1
		end

		for _, v4 in ScpHighlights do
			v4.FillTransparency = v1
		end
	end,
})

Tab1:CreateToggle({
	name = "Outline Only",
	description = "Hides the highlight fill, keeping only the outline",
	value = false,
	flag = "Visuals_OutlineOnly",
	callback = function(arg1)
		flag12 = arg1
		local v1 = func10()

		for _, v2 in TeamHighlights do
			v2.FillTransparency = v1
		end

		for _, v3 in ZombieHighlights do
			v3.FillTransparency = v1
		end

		for _, v4 in ScpHighlights do
			v4.FillTransparency = v1
		end
	end,
})

Tab1:CreateToggle({
	name = "Use Custom Color",
	description = "Overrides the team color with a fixed color instead",
	value = false,
	flag = "Visuals_UseCustomColor",
	callback = function(arg1)
		flag11 = arg1
		func13()
	end,
})

Tab1:CreateColorPicker({
	name = "Custom ESP Color",
	color = v22,
	flag = "Visuals_CustomColor",
	callback = function(arg1)
		v22 = arg1
		if flag11 then
			func13()
		end
	end,
})

Tab1:CreateToggle({
	name = "Show Names & Distance",
	description = "Adds a name and distance tag above each ESP'd player",
	value = false,
	flag = "Visuals_NameTags",
	callback = function(arg1)
		flag8 = arg1
		func13()
	end,
})

Tab1:CreateToggle({
	name = "Health Bars",
	description = "Adds a health bar under each ESP'd player (green to red as they take damage)",
	value = false,
	flag = "Visuals_HealthBars",
	callback = function(arg1)
		flag9 = arg1
		func13()
	end,
})

Tab1:CreateSlider({
	name = "Name Tag Text Size",
	range = {8, 24},
	increment = 1,
	value = num6,
	flag = "Visuals_NameTagTextSize",
	callback = function(arg1)
		num6 = arg1
		for _, v1 in NameTags do
			local Label = v1:FindFirstChild("Label")
			if Label then Label.TextSize = num6 end
		end
		for _, v1 in ScpNameTags do
			local Label = v1:FindFirstChild("Label")
			if Label then Label.TextSize = num6 end
		end
	end,
})

Tab1:CreateColorPicker({
	name = "Name Tag Color",
	color = color3,
	flag = "Visuals_NameTagColor",
	callback = function(arg1)
		color3 = arg1
		for _, v1 in NameTags do
			local Label = v1:FindFirstChild("Label")
			if Label then Label.TextColor3 = color3 end
		end
		for _, v1 in ScpNameTags do
			local Label = v1:FindFirstChild("Label")
			if Label then Label.TextColor3 = color3 end
		end
	end,
})

Tab1:CreateSection({name = "Zombie ESP"})

local function func15(arg1)
	local v1 = ZombieHighlights[arg1]
	if v1 then
		v1:Destroy()
		ZombieHighlights[arg1] = nil
	end
end

local function func16(adornee)
	if not flag13 or not adornee:IsA("Model") then
		func15(adornee)
		return
	end

	local v1 = ZombieHighlights[adornee]

	if not v1 then
		local highlight = Instance.new("Highlight")
		v1 = highlight
		highlight.Name = "SCP_ZombieESP"
		highlight.FillColor = Color3.fromRGB(255, 60, 60)
		highlight.OutlineColor = Color3.fromRGB(255, 60, 60)
		highlight.OutlineTransparency = 0
		highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		ZombieHighlights[adornee] = highlight
	end

	v1.FillTransparency = func10()
	v1.Adornee = adornee
	v1.Parent = adornee
end

local function func17()
	local Zombies = workspace:FindFirstChild("Zombies")

	if not Zombies then
		tbl:Track(workspace.ChildAdded:Connect(function(child)
			if child.Name == "Zombies" then
				func17()
			end
		end))
		return
	end

	for _, v1 in Zombies:GetChildren() do
		if flag13 then
			func16(v1)
		end
	end

	tbl:Track(Zombies.ChildAdded:Connect(function(child)
		if flag13 then
			func16(child)
		end
	end))

	tbl:Track(Zombies.ChildRemoved:Connect(func15))
end

func17()

Tab1:CreateToggle({
	name = "Zombie ESP",
	description = "Highlights zombies (Infection mode only)",
	value = false,
	flag = "Visuals_ZombieESP",
	callback = function(arg1)
		flag13 = arg1
		local Zombies = workspace:FindFirstChild("Zombies")

		if Zombies then
			for _, v1 in Zombies:GetChildren() do
				if arg1 then
					func16(v1)
				else
					func15(v1)
				end
			end
		end
	end,
})

-- ══════════════════════════════════════════════
-- SCP ESP
-- Container : workspace.SCPs
-- Color     : cyan — distinct from orange team ESP
-- Names     : friendly display names, not SCP numbers
-- Special adorn targets per SCP (not whole model where unnecessary)
-- ══════════════════════════════════════════════
local ScpHighlights  = {}
local ScpNameTags    = {}
local flag_scpESP    = false
local flag_scpNames  = false
local flag_scpHP     = false

local SCP_FILL_COLOR    = Color3.fromRGB(0, 210, 255)   -- cyan
local SCP_OUTLINE_COLOR = Color3.fromRGB(0, 160, 220)   -- slightly darker cyan

-- display names + capturable flag
-- [name] = { label, capturable }
local SCP_NAMES = {
	["SCP-049"]   = { "Plague Doctor",            true  },
	["SCP-049-2"] = { "Zombie",                   false },
	["SCP-173"]   = { "Neckhurt",                 true  },
	["SCP-096"]   = { "Shy Guy",                  true  },
	["SCP-066"]   = { "Annoying Music",           true  },
	["SCP-087"]   = { "The Staircase",            false },
	["SCP-093"]   = { "Red Disc",                 false },
	["SCP-938"]   = { "Lightning Entity",         false },
	["SCP-079"]   = { "Old AI",                   false },
	["SCP-316"]   = { "Lighthouse Lamp",          true  },
	["SCP-966"]   = { "Sleep Killer",             true  },
	["SCP-999"]   = { "Tickle Monster",           true  },
	["SCP-008-2"] = { "SCP-008-2",                false },
	["SCP-1025"]  = { "Encyclopedia of Diseases", true  },
	["SCP-1299"]  = { "Drowning Tub",             false },
	["SCP-2950"]  = { "Just a Chair",             true  },
	-- SCP-131 sub-models
	["Red"]       = { "Eye Pod (Red)",            true  },
	["Yellow"]    = { "Eye Pod (Yellow)",         true  },
}

-- returns display label for a model, appends [C] if capturable
local function GetDisplayName(model)
	local entry = SCP_NAMES[model.Name]
	if entry then
		return entry[2] and (entry[1] .. " [C]") or entry[1]
	end
	return model.Name
end

-- per-SCP adorn target logic
-- returns the Part to highlight and tag, not the whole model where unnecessary
local function GetAdornTarget(entry, entryName)
	-- SCP-087: just one stair step, not the entire infinite staircase
	if entryName == "SCP-087" then
		local stairs = entry:FindFirstChild("Stairs")
		if stairs then
			return stairs:FindFirstChildOfClass("Part")
				or stairs:FindFirstChildOfClass("MeshPart")
		end
		return entry:FindFirstChildOfClass("Part")
	end

	-- SCP-093: only the Stand (disc stand), not the mirror
	if entryName == "SCP-093" then
		local standDiscs = entry:FindFirstChild("StandDiscs")
		if standDiscs then
			return standDiscs:FindFirstChild("Stand")
				or standDiscs:FindFirstChildOfClass("MeshPart")
		end
		return entry
	end

	-- SCP-938 (Folder > Caps > Box): highlight only the capacitor box, not controls
	if entryName == "SCP-938" then
		local caps = entry:FindFirstChild("Caps")
		if caps then
			return caps:FindFirstChild("Box")
				or caps:FindFirstChildOfClass("MeshPart")
				or caps:FindFirstChildOfClass("Part")
		end
		return entry:FindFirstChildOfClass("MeshPart")
			or entry:FindFirstChildOfClass("Part")
	end

	-- everything else: use the model itself
	return entry
end

-- best part to attach the nametag billboard to
local function GetTagAnchor(inst)
	if inst:IsA("BasePart") or inst:IsA("MeshPart") then return inst end
	return inst:FindFirstChild("Head")
		or inst:FindFirstChild("HumanoidRootPart")
		or inst.PrimaryPart
		or inst:FindFirstChildOfClass("MeshPart")
		or inst:FindFirstChildOfClass("BasePart")
end

local function RemoveSCPEntry(key)
	local h = ScpHighlights[key]
	if h then pcall(function() h:Destroy() end) ScpHighlights[key] = nil end
	local t = ScpNameTags[key]
	if t then pcall(function() t:Destroy() end) ScpNameTags[key] = nil end
end

local function GetOrMakeSCPTag(key, anchorPart, displayName)
	local tag = ScpNameTags[key]
	if tag and tag.Parent ~= folder then
		pcall(function() tag:Destroy() end)
		tag = nil
	end
	if not tag then
		tag = Instance.new("BillboardGui")
		tag.Name        = "SCP_ESPTag"
		tag.Size        = UDim2.new(0, 140, 0, 24)
		tag.StudsOffset = Vector3.new(0, 1.25, 0)
		tag.AlwaysOnTop = true

		local lbl = Instance.new("TextLabel")
		lbl.Name                   = "Label"
		lbl.BackgroundTransparency = 1
		lbl.Size                   = UDim2.new(1, 0, 0, 18)
		lbl.Font                   = Enum.Font.Gotham
		lbl.TextStrokeTransparency = 0.5
		lbl.TextStrokeColor3       = Color3.new(0, 0, 0)
		lbl.TextSize               = num6
		lbl.TextColor3             = color3
		lbl.Text                   = displayName
		lbl.Parent                 = tag

		local hpBack = Instance.new("Frame")
		hpBack.Name                   = "HealthBack"
		hpBack.AnchorPoint            = Vector2.new(0.5, 0)
		hpBack.Position               = UDim2.new(0.5, 0, 0, 20)
		hpBack.Size                   = UDim2.new(0, 70, 0, 2)
		hpBack.BackgroundColor3       = Color3.fromRGB(20, 20, 20)
		hpBack.BackgroundTransparency = 0.2
		hpBack.BorderSizePixel        = 0
		hpBack.Parent                 = tag

		local uIStroke = Instance.new("UIStroke")
		uIStroke.Thickness    = 1
		uIStroke.Color        = Color3.new(0, 0, 0)
		uIStroke.Transparency = 0.6
		uIStroke.Parent       = hpBack

		local hpFill = Instance.new("Frame")
		hpFill.Name             = "HealthFill"
		hpFill.Size             = UDim2.fromScale(1, 1)
		hpFill.BackgroundColor3 = v18
		hpFill.BorderSizePixel  = 0
		hpFill.Parent           = hpBack

		tag.Parent        = folder
		ScpNameTags[key]  = tag
	end

	tag.Adornee = anchorPart
	tag.Enabled = anchorPart ~= nil

	local lbl = tag:FindFirstChild("Label")
	if lbl then
		lbl.Visible = flag_scpNames
		lbl.Text    = displayName
	end
	local hpBack = tag:FindFirstChild("HealthBack")
	if hpBack then hpBack.Visible = flag_scpHP end
	return tag
end

-- apply ESP to one resolved unit (a Model, BasePart, or specific part)
-- key     : unique table key (the model itself)
-- adorn   : what the Highlight adorns
-- anchor  : what the BillboardGui sticks to
-- dname   : display name string
local function ApplyUnit(key, adorn, anchor, dname)
	local h = ScpHighlights[key]
	if not h then
		h = Instance.new("Highlight")
		h.Name                = "SCP_ESP"
		h.OutlineTransparency = 0
		h.DepthMode           = Enum.HighlightDepthMode.AlwaysOnTop
		ScpHighlights[key]    = h
	end
	h.FillColor        = SCP_FILL_COLOR
	h.OutlineColor     = SCP_OUTLINE_COLOR
	h.FillTransparency = func10()
	h.Adornee          = adorn
	h.Parent           = adorn

	if flag_scpNames or flag_scpHP then
		GetOrMakeSCPTag(key, anchor, dname)
	else
		local t = ScpNameTags[key]
		if t then pcall(function() t:Destroy() end) ScpNameTags[key] = nil end
	end
end

local function ApplyEntryESP(entry)
	local ename = entry.Name

	-- SCP-131: nested sub-models each get their own ESP unit
	if ename == "SCP-131" then
		for _, child in ipairs(entry:GetChildren()) do
			if child:IsA("Model") and child:FindFirstChildOfClass("Humanoid") then
				local dname = GetDisplayName(child)
				local anchor = GetTagAnchor(child)
				ApplyUnit(child, child, anchor, dname)
			end
		end
		return
	end

	-- all other entries: resolve adorn target per SCP
	local adorn = GetAdornTarget(entry, ename)
	if not adorn then return end

	-- if adorn is a Model or Folder, Highlight needs it directly;
	-- if it's a BasePart, also fine
	local anchor = GetTagAnchor(adorn) or adorn
	local dname  = GetDisplayName(entry)
	ApplyUnit(entry, adorn, anchor, dname)
end

local function RemoveEntryESP(entry)
	RemoveSCPEntry(entry)
	-- SCP-131 nested sub-models
	for _, child in ipairs(entry:GetChildren()) do
		RemoveSCPEntry(child)
	end
end

local function RefreshAllSCPs()
	local container = workspace:FindFirstChild("SCPs")
	if not container then return end
	for _, entry in ipairs(container:GetChildren()) do
		if flag_scpESP then
			ApplyEntryESP(entry)
		else
			RemoveEntryESP(entry)
		end
	end
end

local function WatchSCPsContainer(container)
	tbl:Track(container.ChildAdded:Connect(function(entry)
		if flag_scpESP then
			task.defer(function()
				if flag_scpESP then ApplyEntryESP(entry) end
			end)
		end
	end))
	tbl:Track(container.ChildRemoved:Connect(RemoveEntryESP))
end

-- SCPCCs = containment chamber triggers/zones — intentionally skipped
local scpContainer = workspace:FindFirstChild("SCPs")
if scpContainer then
	WatchSCPsContainer(scpContainer)
else
	tbl:Track(workspace.ChildAdded:Connect(function(child)
		if child.Name == "SCPs" then
			WatchSCPsContainer(child)
			if flag_scpESP then
				for _, entry in ipairs(child:GetChildren()) do
					ApplyEntryESP(entry)
				end
			end
		end
	end))
end

tbl:Track(v7.RenderStepped:Connect(function()
	if not (flag_scpESP and (flag_scpNames or flag_scpHP)) then return end
	for key, tag in ScpNameTags do
		if not tag.Parent then
			ScpNameTags[key] = nil
			continue
		end
		-- key is the model; find humanoid for HP bar
		local hum = (typeof(key) == "Instance" and key:IsA("Model"))
			and key:FindFirstChildOfClass("Humanoid")
			or nil

		if flag_scpHP then
			local hpBack = tag:FindFirstChild("HealthBack")
			local hpFill = hpBack and hpBack:FindFirstChild("HealthFill")
			if hpBack and hpFill then
				local invincible = not hum
					or hum.MaxHealth <= 0
					or hum.MaxHealth == math.huge
				hpBack.Visible = not invincible
				if not invincible then
					local ratio = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
					hpFill.Size             = UDim2.fromScale(ratio, 1)
					hpFill.BackgroundColor3 = v19:Lerp(v18, ratio)
				end
			end
		end
	end
end))

Tab1:CreateSection({name = "SCP ESP"})

Tab1:CreateToggle({
	name        = "SCP ESP",
	description = "Highlights all SCPs in workspace.SCPs — cyan, with friendly names",
	value       = false,
	flag        = "Visuals_SCPESP",
	callback    = function(arg1)
		flag_scpESP = arg1
		RefreshAllSCPs()
	end,
})

Tab1:CreateToggle({
	name        = "SCP Names",
	description = "Shows friendly SCP name above each entity",
	value       = false,
	flag        = "Visuals_SCPNames",
	callback    = function(arg1)
		flag_scpNames = arg1
		if flag_scpESP then RefreshAllSCPs() end
	end,
})

Tab1:CreateToggle({
	name        = "SCP Health Bars",
	description = "Health bar for damageable SCPs only — hidden automatically for invincible ones",
	value       = false,
	flag        = "Visuals_SCPHealth",
	callback    = function(arg1)
		flag_scpHP = arg1
		if flag_scpESP then RefreshAllSCPs() end
	end,
})

local v26 = v1(game:GetService("Lighting"))

local tbl3 = {
	Ambient = v26.Ambient,
	OutdoorAmbient = v26.OutdoorAmbient,
	Brightness = v26.Brightness,
	ClockTime = v26.ClockTime,
	GlobalShadows = v26.GlobalShadows,
	ExposureCompensation = v26.ExposureCompensation,
}

local tbl7

function func18()
	v26.Ambient = Color3.fromRGB(255, 255, 255)
	v26.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
	v26.Brightness = 2
	v26.ClockTime = 14
	v26.GlobalShadows = false
	v26.ExposureCompensation = 0
	local Atmosphere = v26:FindFirstChildOfClass("Atmosphere")

	if Atmosphere then
		if not tbl7 or tbl7.Instance ~= Atmosphere then
			tbl7 = {Instance = Atmosphere, Density = Atmosphere.Density, Haze = Atmosphere.Haze}
		end

		Atmosphere.Density = 0
		Atmosphere.Haze = 0
	end
end

local function func19()
	pcall(function()
		v26.Ambient = tbl3.Ambient
		v26.OutdoorAmbient = tbl3.OutdoorAmbient
		v26.Brightness = tbl3.Brightness
		v26.ClockTime = tbl3.ClockTime
		v26.GlobalShadows = tbl3.GlobalShadows
		v26.ExposureCompensation = tbl3.ExposureCompensation
	end)

	local v1 = tbl7
	tbl7 = nil

	if v1 and v1.Instance and v1.Instance.Parent then
		pcall(function()
			v1.Instance.Density = v1.Density
			v1.Instance.Haze = v1.Haze
		end)
	end
end

tbl.RestoreLighting = func19
Tab1:CreateSection({name = "World"})

Tab1:CreateToggle({
	name = "Fullbright",
	description = "Lights the whole facility and clears the atmosphere haze",
	value = false,
	flag = "Visuals_Fullbright",
	callback = function(arg1)
		flag10 = arg1
		if arg1 then
			func18()
		else
			func19()
		end
	end,
})

Tab1:CreateSection({name = "Hitbox Expander"})

local hb_enabled = false
local hb_size = 6
local hb_transparency = 0.6
local hb_originals = {}

Tab1:CreateToggle({
	name = "Hitbox Expander",
	description = "Expands enemy head hitboxes",
	value = false,
	flag = "Visuals_HitboxEnabled",
	callback = function(val)
		hb_enabled = val
		if not val then
			for head, orig in pairs(hb_originals) do
				pcall(function()
					if head and head.Parent then
						head.Size = orig.Size
						head.Transparency = orig.Transparency
					end
				end)
			end
			hb_originals = {}
		end
	end,
})

Tab1:CreateSlider({
	name = "Hitbox Size",
	value = 4,
	min = 1,
	max = 6,
	flag = "Visuals_HitboxSize",
	callback = function(val)
		hb_size = val
	end,
})

Tab1:CreateSlider({
	name = "Hitbox Transparency",
	value = 50,
	min = 0,
	max = 100,
	flag = "Visuals_HitboxTransparency",
	callback = function(val)
		hb_transparency = val / 100
	end,
})

local hb_acc = 0
local hb_cache = {} -- player -> head (refreshed on character change)

local function hb_refresh_cache()
	hb_cache = {}
	for _, p in ipairs(v5:GetPlayers()) do
		if p ~= LocalPlayer and p.Character then
			local head = p.Character:FindFirstChildWhichIsA("BasePart") -- fastest path
			head = p.Character:FindFirstChild("Head")
			if head then
				hb_cache[p] = head
			end
		end
	end
end

tbl:Track(v7.Heartbeat:Connect(function(dt)
	if not hb_enabled then return end
	hb_acc += dt
	if hb_acc < 0.05 then return end -- ~20hz instead of 60hz
	hb_acc = 0

	for p, head in pairs(hb_cache) do
		if not (p and p.Parent) then
			hb_cache[p] = nil
			continue
		end
		if not (head and head.Parent) then
			hb_cache[p] = nil
			continue
		end
		if p.Team == LocalPlayer.Team then continue end
		if not hb_originals[head] then
			hb_originals[head] = {Size = head.Size, Transparency = head.Transparency}
		end
		local orig = hb_originals[head]
		local base = math.max(orig.Size.X, orig.Size.Y, orig.Size.Z)
		local final = math.max(base, math.min(hb_size, 6))
		head.Size = Vector3.new(final, final, final)
		head.Transparency = hb_transparency
	end
end))

-- refresh cache on character added/removed
tbl:Track(v5.PlayerAdded:Connect(hb_refresh_cache))
tbl:Track(v5.PlayerRemoving:Connect(hb_refresh_cache))
tbl:Track(v7.Heartbeat:Connect(function()
	-- lightweight: only re-cache when a character actually changed
	for _, p in ipairs(v5:GetPlayers()) do
		if p ~= LocalPlayer and p.Character and not hb_cache[p] then
			hb_refresh_cache()
			break
		end
	end
end))

hb_refresh_cache()


local flag14 = false
local num7 = 10
local v27 = typeof(fireclickdetector) == "function"

local function func20(arg1)
	local TextLabel = arg1:FindFirstChildWhichIsA("TextLabel", true)

	if not TextLabel then
		return nil, nil
	end

	local v1, v2 = string.match(TextLabel.Text, "%[%s*(%d+)%s*/%s*(%d+)%s*%]")
	return tonumber(v1), tonumber(v2)
end

local function func21(arg1)
	local Character = LocalPlayer.Character
	local v1 = Character and Character:FindFirstChild("HumanoidRootPart")

	if not v1 then
		return nil
	end

	local v5
	local huge = math.huge

	for _, v2 in arg1 do
		if v2.Parent and v2:IsA("BasePart") then
			local ClickDetector = v2:FindFirstChildOfClass("ClickDetector")
			if ClickDetector then
				local Magnitude = (v2.Position - v1.Position).Magnitude
				if not (Magnitude > ClickDetector.MaxActivationDistance - 2 or Magnitude >= huge) then
					local v3, v4 = func20(v2)
					if not (v3 and v4 and v3 >= v4) then
						v5 = ClickDetector
						huge = Magnitude
					end
				end
			end
		end
	end

	return v5
end

task.spawn(function()
	local tbl1 = {}
	local v1 = -math.huge



	while tbl.Alive do
		if flag14 and v27 then
			if os.clock() - v1 > 2 then
				tbl1 = workspace:QueryDescendants("#VentClickable")
				v1 = os.clock()
			end

			local v2 = func21(tbl1)

			if v2 then
				pcall(fireclickdetector, v2)
			end

			task.wait(1 / num7)
		else
			task.wait(0.25)
		end
	end
end)

local flag15 = false
local raycastParams1 = RaycastParams.new()
raycastParams1.FilterType = Enum.RaycastFilterType.Exclude

local v28 = table.pack(v7.Heartbeat:Connect(function()
	if not flag15 then
		return
	end

	local Character = LocalPlayer.Character
	local v1 = Character and Character:FindFirstChild("HumanoidRootPart")

	if not v1 then
		return
	end

	local AssemblyLinearVelocity = v1.AssemblyLinearVelocity

	if AssemblyLinearVelocity.Y >= -60 then
		return
	end

	raycastParams1.FilterDescendantsInstances = {Character}
	local v2 = -AssemblyLinearVelocity.Y * 0.15 + 6

	if workspace:Raycast(v1.Position, Vector3.new(0, -v2, 0), raycastParams1) then
		v1.AssemblyLinearVelocity = Vector3.new(AssemblyLinearVelocity.X, -30, AssemblyLinearVelocity.Z)
	end
end))

tbl:Track(table.unpack(v28, 1, v28.n))
Tab2:CreateSection({name = "Vents"})

Tab2:CreateToggle({
	name = "Vent Clicker",
	description = "Clicks the nearest vent wall for you while you stand in range; stops once it breaks",
	value = false,
	flag = "Player_VentClicker",
	callback = function(arg1)
		flag14 = arg1
		if arg1 and not v27 then
			Window:Notify({title = "Vent Clicker", content = v4 .. " does not support fireclickdetector.", duration = 4})
		end
	end,
})

Tab2:CreateSlider({
	name = "Click Speed",
	description = "Clicks per second; around 10 matches fast manual clicking",
	range = {5, 15},
	increment = 1,
	value = num7,
	suffix = " /s",
	flag = "Player_VentClickRate",
	callback = function(arg1)
		num7 = math.clamp(arg1, 5, 15)
	end,
})

Tab2:CreateSection({name = "Movement"})

Tab2:CreateToggle({
	name = "Anti Fall Damage",
	description = "Slows your fall just before you land, so falls deal no damage",
	value = false,
	flag = "Player_AntiFall",
	callback = function(arg1)
		flag15 = arg1
	end,
})

Tab3:CreateSection({name = "Interface"})

Tab3:CreateDropdown({
	name = "UI Theme",
	options = {"default", "cobalt", "ember", "amethyst", "frost", "rose"},
	value = "cobalt",
	multiSelect = false,
	flag = "Settings_UITheme",
	callback = function(arg1)
		Window:ChangeTheme(arg1)
	end,
})

Tab3:CreateSection({name = "Configuration"})

Tab3:CreateButton({
	name = "Reset to Defaults",
	description = "Turns every option off except Staff Alerts",
	callback = function()
		Window:Set("Combat_SilentAim", false)
		Window:Set("Combat_ShowFOV", false)
		Window:Set("Combat_SnapLine", false)
		Window:Set("Visuals_TeamESP", false)
		Window:Set("Visuals_OutlineOnly", false)
		Window:Set("Visuals_UseCustomColor", false)
		Window:Set("Visuals_NameTags", false)
		Window:Set("Visuals_HealthBars", false)
		Window:Set("Visuals_Fullbright", false)
		Window:Set("Player_VentClicker", false)
		Window:Set("Player_AntiFall", false)
		Window:Set("Visuals_ZombieESP", false)
		Window:Set("Staff_AlertsEnabled", true)
		Window:Save()
		Window:Notify({title = "Defaults Restored", content = "Every option is off except Staff Alerts.", duration = 3})
	end,
})

Tab3:CreateSection({name = "Profiles"})
local str1 = ""
local v38
local Dropdown

local function func22()
	local ok, result = pcall(function()
		return Window:ListConfigs()
	end)
	Dropdown:Refresh(ok and result or {})
end

Tab3:CreateInput({
	name = "Profile Name",
	placeholder = "e.g. PvP Setup",
	clearOnFocus = false,
	forgetState = true,
	callback = function(arg1)
		str1 = arg1
	end,
})

Tab3:CreateButton({
	name = "Save As New Profile",
	description = "Saves the current settings under the name above",
	callback = function()
		if str1 == "" then
			Window:Notify({
				title = "Profile Name Needed",
				content = "Type a name in the Profile Name field first.",
				duration = 4,
			})
			return
		end

		Window:Save(str1)
		func22()
		Window:Notify({title = "Profile Saved", content = ('Saved as "%s".'):format(str1), duration = 3})
	end,
})

Dropdown = Tab3:CreateDropdown({
	name = "Saved Profiles",
	options = (function()
		local ok, result = pcall(function()
			return Window:ListConfigs()
		end)
		return ok and result or {}
	end)(),
	placeholder = "No profiles saved yet",
	multiSelect = false,
	forgetState = true,
	callback = function(arg1)
		v38 = arg1
	end,
})

Tab3:CreateButton({
	name = "Load Selected Profile",
	callback = function()
		if not v38 then
			Window:Notify({title = "No Profile Selected", content = "Pick a profile from the dropdown first.", duration = 4})
			return
		end

		Window:Load(v38)
		Window:Notify({title = "Profile Loaded", content = ('Loaded "%s".'):format(v38), duration = 3})
	end,
})

Tab3:CreateButton({
	name = "Delete Selected Profile",
	callback = function()
		if not v38 then
			Window:Notify({title = "No Profile Selected", content = "Pick a profile from the dropdown first.", duration = 4})
			return
		end

		Window:DeleteConfig(v38)
		Window:Notify({title = "Profile Deleted", content = ('Deleted "%s".'):format(v38), duration = 3})
		v38 = nil
		func22()
	end,
})

local v29 = (function()
	local Players = game:GetService("Players")
	local TweenService = game:GetService("TweenService")
	local SoundService = game:GetService("SoundService")
	local CoreGui = game:GetService("CoreGui")
	local LocalPlayer = Players.LocalPlayer
	local v1 = typeof(setthreadidentity) == "function"

	local function func()
		if v1 then
			pcall(setthreadidentity, 8)
		end
	end

	local v2 = Color3.fromRGB(9, 9, 9)
	local v3 = Color3.fromRGB(19, 19, 19)
	local v4 = Color3.fromRGB(245, 245, 245)
	local v5 = Color3.fromRGB(224, 40, 58)

	local function func1(arg1, arg2)
		local ok, result = pcall(
			Font.new,
			"rbxasset://fonts/families/GothamSSm.json",
			arg1,
			arg2 and Enum.FontStyle.Italic or Enum.FontStyle.Normal
		)
		return ok and result or Font.fromEnum(Enum.Font.Gotham)
	end

	local function func2(arg1)
		local tbl = {}

		for i = 1, #arg1 do
			tbl[i] = arg1:sub(i, i)
		end

		return table.concat(tbl, " ")
	end

	local function func3(className, arg2)
		local instance = Instance.new(className)

		for k, v1 in arg2 do
			if k ~= "Parent" then
				instance[k] = v1
			end
		end

		if arg2.Parent then
			instance.Parent = arg2.Parent
		end

		return instance
	end

	local function func4()
		local ok, result = pcall(function()
			return gethui and gethui()
		end)

		if ok and result then
			return result
		end

		return CoreGui
	end

	local function func5(arg1)
		local ok, result = pcall(Font.new, "rbxasset://fonts/families/BuilderSans.json", arg1)
		return ok and result or func1(arg1)
	end

	local tbl = {
		Frame = {"BackgroundTransparency"},
		TextLabel = {"TextTransparency"},
		TextButton = {"TextTransparency", "BackgroundTransparency"},
		UIStroke = {"Transparency"},
	}

	local function func6(arg1)
		local tbl1 = {}

		local function func(arg1)
			local v1 = tbl[arg1.ClassName]

			if not v1 then
				return
			end

			local tbl2 = {}

			for _, v2 in v1 do
				tbl2[v2] = arg1[v2]
			end

			table.insert(tbl1, {inst = arg1, targets = tbl2})
		end

		func(arg1)

		for _, v1 in arg1:GetDescendants() do
			func(v1)
		end

		return tbl1
	end

	local function func7(arg1)
		for _, v1 in arg1 do
			for k in v1.targets do
				v1.inst[k] = 1
			end
		end
	end

	local function func8(arg1, arg2, arg3)
		for _, v1 in arg1 do
			local tbl = {}

			for k, v2 in v1.targets do
				local v3

				if arg2 then
					v3 = v2
				else
					v3 = 1
				end

				tbl[k] = v3
			end

			TweenService:Create(v1.inst, arg3, tbl):Play()
		end
	end

	local enum = Enum
	local tweenInfo = TweenInfo.new(0.35, enum.EasingStyle.Quart, enum.EasingDirection.Out)
	local tweenInfo1 = TweenInfo.new(0.2, enum.EasingStyle.Quart, enum.EasingDirection.In)
	local tweenInfo2 = TweenInfo.new(0.15, enum.EasingStyle.Quad, enum.EasingDirection.Out)
	local tweenInfo3 = TweenInfo.new(0.45, enum.EasingStyle.Quad, enum.EasingDirection.InOut)
	local tbl1 = {}
	tbl1.Gui = nil
	tbl1.Refs = nil
	tbl1.Names = {}
	tbl1.Handlers = {}
	tbl1.Connections = {}
	tbl1.Alive = true

	local function func9(arg1, arg2)
		local connection = arg1:Connect(function(...)
			func()
			arg2(...)
		end)

		table.insert(tbl1.Connections, connection)
		return connection
	end

	local function func10(arg1)
		if #arg1 == 1 then
			return "Staff Member has Joined"
		end
		return ("%d Staff Members have Joined"):format(#arg1)
	end

	local function func11(arg1)
		return ("%s %s in your server. Would you prefer to stay or to leave?"):format(table.concat(arg1, ", "), #arg1 == 1 and "is" or "are")
	end

	local function func12()
		local Sound = tbl1.Sound

		if Sound and Sound.Parent and Sound.IsPlaying then
			return
		end

		local sound = Instance.new("Sound")
		tbl1.Sound = sound
		sound.SoundId = "rbxassetid://101511361468852"
		sound.Volume = 0.6
		sound.Parent = SoundService

		sound.Ended:Once(function()
			sound:Destroy()
		end)

		task.delay(15, function()
			if sound.Parent then
				sound:Destroy()
			end
		end)

		pcall(function()
			sound:Play()
		end)
	end

	local function func13()
		LocalPlayer:Kick("[Void Scripts] You left the server because a staff member joined.")
	end

	local function func14()
		local v1 = func3("ScreenGui", {
			Name = "VoidHub_StaffAlert",
			IgnoreGuiInset = true,
			ResetOnSpawn = false,
			DisplayOrder = 100000,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		})

		local v6 = func3("Frame", {
			Name = "Backdrop",
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = v2,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Active = false,
			Parent = v1,
		})

		pcall(function()
			v6.Interactable = false
		end)

		local v7 = func3("Frame", {
			Name = "Holder",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 12),
			Size = UDim2.new(0, 380, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Parent = v1,
		})

		local v8 = func3("UIScale", {Scale = 0.98, Parent = v7})

		local v9 = func3("Frame", {
			Name = "Card",
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundColor3 = v3,
			BorderSizePixel = 0,
			Parent = v7,
		})

		func3("UICorner", {CornerRadius = UDim.new(0, 10), Parent = v9})
		local enum = Enum

		func3("UIStroke", {
			Color = v4,
			Transparency = 0.88,
			Thickness = 1,
			ApplyStrokeMode = enum.ApplyStrokeMode.Border,
			Parent = v9,
		})

		func3("UIListLayout", {
			SortOrder = enum.SortOrder.LayoutOrder,
			HorizontalAlignment = enum.HorizontalAlignment.Center,
			Parent = v9,
		})

		local v10 = func3("Frame", {
			Name = "Header",
			Size = UDim2.new(1, 0, 0, 44),
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			Parent = v9,
		})

		func3("Frame", {
			Name = "AccentBar",
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, 18, 0.5, 0),
			Size = UDim2.new(0, 2, 0, 14),
			BackgroundColor3 = v4,
			BorderSizePixel = 0,
			Parent = v10,
		})

		local tbl = {
			Name = "Wordmark",
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, 29, 0.5, 0),
			Size = UDim2.new(0, 140, 0, 16),
			BackgroundTransparency = 1,
			RichText = true,
			Text = '<font color="#808080">VOID</font><font color="#F5F5F5">HUB</font>',
			TextSize = 15,
		}

		local enum1 = Enum
		tbl.FontFace = func1(enum1.FontWeight.Bold, true)
		tbl.TextXAlignment = enum1.TextXAlignment.Left
		tbl.Parent = v10
		func3("TextLabel", tbl)

		local tbl1 = {
			Name = "Tag",
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -18, 0.5, 0),
			Size = UDim2.new(0, 90, 0, 12),
			BackgroundTransparency = 1,
			Text = func2("ALERT"),
			TextSize = 9,
			TextColor3 = v4,
			TextTransparency = 0.65,
		}

		local enum2 = Enum
		tbl1.FontFace = func1(enum2.FontWeight.Medium)
		tbl1.TextXAlignment = enum2.TextXAlignment.Right
		tbl1.Parent = v10
		func3("TextLabel", tbl1)

		func3("Frame", {
			Name = "Divider",
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.fromScale(0, 1),
			Size = UDim2.new(1, 0, 0, 1),
			BackgroundColor3 = v4,
			BackgroundTransparency = 0.9,
			BorderSizePixel = 0,
			Parent = v10,
		})

		local v11 = func3("Frame", {
			Name = "Body",
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			Parent = v9,
		})

		func3("UIPadding", {
			PaddingTop = UDim.new(0, 22),
			PaddingBottom = UDim.new(0, 20),
			PaddingLeft = UDim.new(0, 18),
			PaddingRight = UDim.new(0, 18),
			Parent = v11,
		})

		func3("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8), Parent = v11})
		local tbl2 = {Name = "Title", Size = UDim2.new(1, 0, 0, 0)}
		local enum3 = Enum
		tbl2.AutomaticSize = enum3.AutomaticSize.Y
		tbl2.BackgroundTransparency = 1
		tbl2.TextWrapped = true
		tbl2.TextSize = 17
		tbl2.TextColor3 = v4
		tbl2.FontFace = func1(enum3.FontWeight.SemiBold)
		tbl2.TextXAlignment = enum3.TextXAlignment.Left
		tbl2.LayoutOrder = 1
		tbl2.Parent = v11
		local v12 = func3("TextLabel", tbl2)
		local tbl3 = {Name = "Subtitle", Size = UDim2.new(1, 0, 0, 0)}
		local enum4 = Enum
		tbl3.AutomaticSize = enum4.AutomaticSize.Y
		tbl3.BackgroundTransparency = 1
		tbl3.TextWrapped = true
		tbl3.TextSize = 14
		tbl3.TextColor3 = v4
		tbl3.TextTransparency = 0.4
		tbl3.LineHeight = 1.15
		tbl3.FontFace = func5(enum4.FontWeight.Medium)
		tbl3.TextXAlignment = enum4.TextXAlignment.Left
		tbl3.LayoutOrder = 2
		tbl3.Parent = v11
		local v13 = func3("TextLabel", tbl3)

		local v14 = func3("Frame", {
			Name = "Buttons",
			Size = UDim2.new(1, 0, 0, 54),
			BackgroundTransparency = 1,
			LayoutOrder = 3,
			Parent = v9,
		})

		func3("UIPadding", {
			PaddingLeft = UDim.new(0, 18),
			PaddingRight = UDim.new(0, 18),
			PaddingBottom = UDim.new(0, 18),
			Parent = v14,
		})

		local v15 = func3("TextButton", {
			Name = "Stay",
			Size = UDim2.new(0.5, -5, 1, 0),
			BackgroundColor3 = v4,
			BackgroundTransparency = 1,
			AutoButtonColor = false,
			Text = "STAY",
			TextSize = 14,
			TextColor3 = v4,
			FontFace = func5(Enum.FontWeight.Bold),
			BorderSizePixel = 0,
			Parent = v14,
		})

		func3("UICorner", {CornerRadius = UDim.new(0, 6), Parent = v15})

		local v16 = func3("UIStroke", {
			Color = v4,
			Transparency = 0.82,
			Thickness = 1,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Parent = v15,
		})

		local v17 = func3("TextButton", {
			Name = "Leave",
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.fromScale(1, 0),
			Size = UDim2.new(0.5, -5, 1, 0),
			BackgroundColor3 = v4,
			AutoButtonColor = false,
			Text = "LEAVE",
			TextSize = 14,
			TextColor3 = v2,
			FontFace = func5(Enum.FontWeight.Bold),
			BorderSizePixel = 0,
			Parent = v14,
		})

		func3("UICorner", {CornerRadius = UDim.new(0, 6), Parent = v17})

		local v18 = func3("UIStroke", {
			Color = v4,
			Transparency = 0.75,
			Thickness = 2,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Parent = v17,
		})

		local v19 = func3("Frame", {
			Name = "BarTrack",
			Size = UDim2.new(1, -20, 0, 2),
			BackgroundColor3 = v4,
			BackgroundTransparency = 0.9,
			BorderSizePixel = 0,
			ClipsDescendants = true,
			LayoutOrder = 4,
			Parent = v9,
		})

		local v20 = func3("Frame", {
			Name = "Thumb",
			Position = UDim2.fromScale(-0.35, 0),
			Size = UDim2.fromScale(0.35, 1),
			BackgroundColor3 = v5,
			BorderSizePixel = 0,
			Parent = v19,
		})

		return v1, {
			backdrop = v6,
			holder = v7,
			scale = v8,
			card = v9,
			title = v12,
			subtitle = v13,
			stay = v15,
			stayStroke = v16,
			leave = v17,
			leaveGlow = v18,
			thumb = v20,
		}
	end

	function tbl1:_refreshText()
		local Refs = self.Refs

		if not Refs then
			return
		end

		Refs.title.Text = func10(self.Names)
		Refs.subtitle.Text = func11(self.Names)
	end

	function tbl1:_runBar(arg2, arg3)
		task.spawn(function()
			func()
			while self.Alive and self.Gui == arg2 do
				arg3.Position = UDim2.fromScale(-0.35, 0)
				arg3.Size = UDim2.fromScale(0.35, 1)
				local tween = TweenService:Create(arg3, tweenInfo3, {Position = UDim2.fromScale(0.3, 0), Size = UDim2.fromScale(0.45, 1)})
				tween:Play()
				tween.Completed:Wait()
				func()

				if not (self.Alive and self.Gui == arg2) then
					break
				end

				local tween1 = TweenService:Create(arg3, tweenInfo3, {Position = UDim2.fromScale(1, 0), Size = UDim2.fromScale(0.35, 1)})
				tween1:Play()
				tween1.Completed:Wait()
				func()
			end
		end)
	end

	function tbl1:Show(arg2, arg3)
		func()

		if not self.Alive then
			return
		end

		if self.Gui then
			if not table.find(self.Names, arg2) then
				table.insert(self.Names, arg2)
				self:_refreshText()
				func12()
			end
			return
		end

		self.Names = {arg2}
		self.Handlers = arg3 or {}
		local v1, v2 = func14()
		self.Gui = v1
		self.Refs = v2
		self:_refreshText()
		v2.fade = func6(v2.card)
		func7(v2.fade)
		v1.Parent = func4()

		func9(v2.stay.MouseEnter, function()
			TweenService:Create(v2.stay, tweenInfo2, {BackgroundTransparency = 0.92}):Play()
			TweenService:Create(v2.stayStroke, tweenInfo2, {Transparency = 0.65}):Play()
		end)

		func9(v2.stay.MouseLeave, function()
			TweenService:Create(v2.stay, tweenInfo2, {BackgroundTransparency = 1}):Play()
			TweenService:Create(v2.stayStroke, tweenInfo2, {Transparency = 0.82}):Play()
		end)

		func9(v2.leave.MouseEnter, function()
			TweenService:Create(v2.leaveGlow, tweenInfo2, {Transparency = 0.55, Thickness = 3}):Play()
		end)

		func9(v2.leave.MouseLeave, function()
			TweenService:Create(v2.leaveGlow, tweenInfo2, {Transparency = 0.75, Thickness = 2}):Play()
		end)

		func9(v2.stay.Activated, function()
			local onStay = self.Handlers.onStay
			self:Close()

			if onStay then
				pcall(onStay)
			end
		end)

		func9(v2.leave.Activated, function()
			local v1 = self.Handlers.onLeave or func13
			self:Close()
			v1()
		end)

		TweenService:Create(v2.backdrop, tweenInfo, {BackgroundTransparency = 0.55}):Play()
		func8(v2.fade, true, tweenInfo)
		TweenService:Create(v2.holder, tweenInfo, {Position = UDim2.fromScale(0.5, 0.5)}):Play()
		TweenService:Create(v2.scale, tweenInfo, {Scale = 1}):Play()
		self:_runBar(v1, v2.thumb)
		func12()
	end

	function tbl1:Close()
		func()
		local Gui = self.Gui
		local Refs = self.Refs

		if not Gui then
			return
		end

		self.Gui = nil
		self.Refs = nil
		table.clear(self.Names)

		for _, v1 in self.Connections do
			pcall(function()
				v1:Disconnect()
			end)
		end

		table.clear(self.Connections)
		local Sound = self.Sound
		self.Sound = nil

		if Sound then
			pcall(function()
				Sound:Stop()
				Sound:Destroy()
			end)
		end

		pcall(function()
			TweenService:Create(Refs.backdrop, tweenInfo1, {BackgroundTransparency = 1}):Play()
			func8(Refs.fade, false, tweenInfo1)
			TweenService:Create(Refs.holder, tweenInfo1, {Position = UDim2.new(0.5, 0, 0.5, 12)}):Play()
		end)

		task.delay(0.25, function()
			pcall(function()
				Gui:Destroy()
			end)
		end)
	end

	function tbl1:Destroy()
		self.Alive = false
		local Gui = self.Gui
		self:Close()

		if Gui then
			pcall(function()
				Gui:Destroy()
			end)
		end
	end

	return tbl1
end)()

tbl.StaffAlert = v29

local v30 = (function()
	local TweenService = game:GetService("TweenService")
	local CoreGui = game:GetService("CoreGui")
	local v1 = typeof(setthreadidentity) == "function"

	local function func()
		if v1 then
			pcall(setthreadidentity, 8)
		end
	end

	local function func1(arg1)
		local tbl = {}

		for i = 1, #arg1 do
			tbl[i] = arg1:sub(i, i)
		end

		return table.concat(tbl, " ")
	end

	local tbl = {Alive = false}
	tbl.Gui = nil
	tbl.Backdrop = nil
	tbl.PulseTween = nil

	function tbl:Show(arg2)
		func()

		if self.Gui then
			return
		end

		local ok, result = pcall(function()
			return gethui and gethui()
		end)

		local v1 = ok and result or CoreGui
		local screenGui = Instance.new("ScreenGui")
		screenGui.Name = "VoidHub_HopSplash"
		screenGui.ResetOnSpawn = false
		screenGui.IgnoreGuiInset = true
		screenGui.DisplayOrder = 100001
		local frame = Instance.new("Frame")
		frame.Name = "Backdrop"
		frame.AnchorPoint = Vector2.new(0, 0.5)
		frame.Position = UDim2.new(0, 0, 0.5, 0)
		frame.Size = UDim2.new(1, 0, 0, 0)
		frame.BackgroundColor3 = Color3.fromRGB(9, 9, 9)
		frame.BorderSizePixel = 0
		frame.ClipsDescendants = true
		frame.Parent = screenGui
		local uIListLayout = Instance.new("UIListLayout")
		local enum = Enum
		uIListLayout.FillDirection = enum.FillDirection.Vertical
		uIListLayout.HorizontalAlignment = enum.HorizontalAlignment.Center
		uIListLayout.VerticalAlignment = enum.VerticalAlignment.Center
		uIListLayout.Padding = UDim.new(0, 36)
		local enum1 = Enum
		uIListLayout.SortOrder = enum1.SortOrder.LayoutOrder
		uIListLayout.Parent = frame
		local textLabel = Instance.new("TextLabel")
		textLabel.Name = "Title"
		textLabel.BackgroundTransparency = 1
		textLabel.AutomaticSize = enum1.AutomaticSize.XY
		textLabel.Size = UDim2.new(0, 0, 0, 0)
		textLabel.RichText = true
		textLabel.Text = '<font color="#808080">VOID</font><font color="#F5F5F5">HUB</font>'
		textLabel.TextSize = 44

		local ok1, result1 = pcall(function()
			local font = Font
			local enum = Enum
			return font.new(font.fromEnum(enum.Font.GothamBlack).Family, enum.FontWeight.Heavy, enum.FontStyle.Italic)
		end)

		if ok1 and result1 then
			textLabel.FontFace = result1
		else
			textLabel.Font = Enum.Font.GothamBlack
		end

		textLabel.LayoutOrder = 1
		textLabel.Parent = frame
		local frame1 = Instance.new("Frame")
		frame1.Name = "ProgressHolder"
		frame1.BackgroundTransparency = 1
		frame1.Size = UDim2.new(0.7, 0, 0, 0)
		frame1.AutomaticSize = Enum.AutomaticSize.Y
		frame1.LayoutOrder = 2
		frame1.Parent = frame
		local uISizeConstraint = Instance.new("UISizeConstraint")
		uISizeConstraint.MaxSize = Vector2.new(320, math.huge)
		uISizeConstraint.Parent = frame1
		local uIListLayout1 = Instance.new("UIListLayout")
		local enum2 = Enum
		uIListLayout1.FillDirection = enum2.FillDirection.Vertical
		uIListLayout1.HorizontalAlignment = enum2.HorizontalAlignment.Center
		uIListLayout1.Padding = UDim.new(0, 14)
		uIListLayout1.SortOrder = Enum.SortOrder.LayoutOrder
		uIListLayout1.Parent = frame1
		local frame2 = Instance.new("Frame")
		frame2.Name = "Track"
		frame2.Size = UDim2.new(1, 0, 0, 3)
		frame2.BackgroundColor3 = Color3.fromRGB(245, 245, 245)
		frame2.BackgroundTransparency = 0.88
		frame2.BorderSizePixel = 0
		frame2.ClipsDescendants = true
		frame2.LayoutOrder = 1
		frame2.Parent = frame1
		local uICorner = Instance.new("UICorner")
		uICorner.CornerRadius = UDim.new(0, 2)
		uICorner.Parent = frame2
		local frame3 = Instance.new("Frame")
		frame3.Name = "Thumb"
		frame3.Position = UDim2.new(-0.35, 0, 0, 0)
		frame3.Size = UDim2.new(0.35, 0, 1, 0)
		frame3.BackgroundColor3 = Color3.fromRGB(245, 245, 245)
		frame3.BorderSizePixel = 0
		frame3.Parent = frame2
		local uICorner1 = Instance.new("UICorner")
		uICorner1.CornerRadius = UDim.new(0, 2)
		uICorner1.Parent = frame3
		local textLabel1 = Instance.new("TextLabel")
		textLabel1.Name = "Status"
		textLabel1.BackgroundTransparency = 1
		textLabel1.AutomaticSize = Enum.AutomaticSize.XY
		textLabel1.Size = UDim2.new(0, 0, 0, 0)
		textLabel1.Text = func1(arg2)
		textLabel1.FontFace = Font.fromEnum(Enum.Font.Montserrat)
		textLabel1.TextSize = 10
		textLabel1.TextColor3 = Color3.fromRGB(245, 245, 245)
		textLabel1.TextTransparency = 0.65
		textLabel1.LayoutOrder = 2
		textLabel1.Parent = frame1
		screenGui.Parent = v1
		self.Gui = screenGui
		self.Backdrop = frame
		self.Alive = true
		local enum3 = Enum

		TweenService:Create(
			frame,
			TweenInfo.new(0.45, enum3.EasingStyle.Quint, enum3.EasingDirection.Out),
			{Size = UDim2.new(1, 0, 1, 0)}
		):Play()

		local enum4 = Enum

		local tween = TweenService:Create(
			textLabel1,
			TweenInfo.new(0.8, enum4.EasingStyle.Sine, enum4.EasingDirection.InOut, -1, true),
			{TextTransparency = 0.1}
		)

		tween:Play()
		self.PulseTween = tween

		task.spawn(function()
			func()
			local enum = Enum
			local tweenInfo = TweenInfo.new(0.35, enum.EasingStyle.Quad, enum.EasingDirection.InOut)

			while self.Alive and self.Gui == screenGui do
				local tween = TweenService:Create(frame3, tweenInfo, {Position = UDim2.new(0.3, 0, 0, 0), Size = UDim2.new(0.45, 0, 1, 0)})
				tween:Play()
				tween.Completed:Wait()
				func()

				if self.Alive and self.Gui == screenGui then
					local tween1 = TweenService:Create(frame3, tweenInfo, {Position = UDim2.new(1, 0, 0, 0), Size = UDim2.new(0.35, 0, 1, 0)})
					tween1:Play()
					tween1.Completed:Wait()
					func()

					if self.Alive and self.Gui == screenGui then
						frame3.Position = UDim2.new(-0.35, 0, 0, 0)
						frame3.Size = UDim2.new(0.35, 0, 1, 0)
						continue
					end
				end

				break
			end
		end)
	end

	function tbl:Destroy()
		func()
		self.Alive = false

		if self.PulseTween then
			pcall(function()
				self.PulseTween:Cancel()
			end)
			self.PulseTween = nil
		end

		local Gui = self.Gui
		local Backdrop = self.Backdrop
		self.Gui = nil
		self.Backdrop = nil

		if Gui and Backdrop then
			pcall(function()
				local enum = Enum

				local tween = TweenService:Create(
					Backdrop,
					TweenInfo.new(0.35, enum.EasingStyle.Quint, enum.EasingDirection.In),
					{Size = UDim2.new(1, 0, 0, 0)}
				)

				tween:Play()
				tween.Completed:Wait()
			end)
		end

		if Gui then
			pcall(function()
				Gui:Destroy()
			end)
		end
	end

	return tbl
end)()

tbl.HopSplash = v30
Tab3:CreateSection({name = "Staff Alert"})

local tbl4 = {
	"MetatableIndex",
	"Volnor",
	"aidanp777",
	"35x56x35",
	"coastalbeachvibez",
	"aikalow",
	"Robloxguy2_0",
	"SealedHorizons",
	"RandomSapphic",
	"tikomh",
	"Great_Tre",
	"JustSomeoneYes",
	"bombboy34567",
	"selgupro",
	"sillykitty851",
	"Critaata",
	"kelvin_jung",
	"NitrixOverIord",
	"OriginallySilly",
	"ShadowOutlawIndex",
	"electroblade_chan",
	"Yeranthe",
	"mino_mine",
	"Geckoo_416",
	"ABD0050",
	"crusaderbox",
	"Kilo_Penta",
	"Ghosteal",
	"slamhy77",
	"Jamie_buddy1",
	"Zke3y",
	"OperatorAdex",
	"Bat_86",
	"Axonnex",
	"YourLifesWork",
}

local tbl5 = {}

local function func23()
	table.clear(tbl5)
	for _, v1 in tbl4 do
		tbl5[v1:lower()] = true
	end
end

func23()
local flag16 = true
local tbl6 = {}
local Console

local function func24(arg1)
	return tbl5[arg1.Name:lower()] == true
end

local str2 = "Leave Game"
local v31 = v1(game:GetService("TeleportService"))
local v32 = v1(game:GetService("HttpService"))

local function func25()
	local v1 = ("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Desc&excludeFullGames=true&limit=100"):format(game.PlaceId)

	local ok, result = pcall(function()
		return game:HttpGet(v1)
	end)

	if not ok or type(result) ~= "string" then
		return nil
	end

	local ok1, result1 = pcall(v32.JSONDecode, v32, result)

	if not ok1 or type(result1) ~= "table" or type(result1.data) ~= "table" then
		return nil
	end

	local tbl = {}

	for _, v2 in result1.data do
		local num = tonumber(v2.playing)
		local num1 = tonumber(v2.maxPlayers)

		if v2.id ~= game.JobId and num and num1 and num < num1 - 1 then
			table.insert(tbl, {id = v2.id, playing = num})
		end
	end

	if #tbl == 0 then
		return nil
	end

	table.sort(tbl, function(a, b)
		return a.playing > b.playing
	end)

	return tbl[math.random(1, math.min(5, #tbl))].id
end

local function func26()
	if str2 == "Server Hop" then
		v30:Show("SWITCHING SERVERS")

		task.delay(45, function()
			if v30.Gui then
				v30:Destroy()
				Window:Notify({title = "Server Hop", content = "Server hop did not go through. Try again.", duration = 5})
			end
		end)

		v31.TeleportInitFailed:Once(function(arg1)
			if arg1 == LocalPlayer then
				LocalPlayer:Kick("[Void Scripts] You left the server because a staff member joined.")
			end
		end)

		local v1 = func25()

		if pcall(function()
			if v1 then
				v31:TeleportToPlaceInstance(game.PlaceId, v1, LocalPlayer)
			else
				v31:Teleport(game.PlaceId, LocalPlayer)
			end
		end) then
			return
		end
	end
	LocalPlayer:Kick("[Void Scripts] You left the server because a staff member joined.")
end

local function func27(arg1, arg2)
	if not flag16 then
		return
	end

	if Console then
		Console:Append(("[%s] %s"):format(arg2 and "JOINED" or "LEFT", arg1.Name))
	end

	if arg2 then
		v29:Show(arg1.Name, {onLeave = func26})
	end
end

local function func28(arg1)
	if arg1 == LocalPlayer then
		return
	end
	if func24(arg1) and not tbl6[arg1] then
		tbl6[arg1] = true
		func27(arg1, true)
	end
end

local function func29(arg1)
	if tbl6[arg1] then
		tbl6[arg1] = nil
		func27(arg1, false)
	end
end

Console = Tab3:CreateConsole({name = "Staff Log", height = 120, follow = true, maxLines = 100})

Tab3:CreateToggle({
	name = "Staff Alerts",
	description = "Shows an alert card with a sound when a known staff member joins",
	value = true,
	flag = "Staff_AlertsEnabled",
	callback = function(arg1)
		flag16 = arg1
	end,
})

Tab3:CreateDropdown({
	name = "Leave Action",
	description = "What the LEAVE button on the staff alert does",
	options = {"Leave Game", "Server Hop"},
	value = str2,
	multiSelect = false,
	flag = "Staff_LeaveAction",
	callback = function(arg1)
		local v1 = arg1

		if type(arg1) == "table" then
			v1 = arg1[1]
		end

		str2 = v1 or "Leave Game"
	end,
})

Tab3:CreateButton({
	name = "Rescan Server",
	description = "Re-checks every current player against the staff list",
	callback = function()
		func23()
		for _, v1 in v5:GetPlayers() do
			func28(v1)
		end
	end,
})

for _, v33 in v5:GetPlayers() do
	func28(v33)
end

local v34 = table.pack(v5.PlayerAdded:Connect(func28))
tbl:Track(table.unpack(v34, 1, v34.n))
local v35 = table.pack(v5.PlayerRemoving:Connect(func29))
tbl:Track(table.unpack(v35, 1, v35.n))
Tab4:CreateSection({name = "Community & Support"})
Tab4:CreateStat({name = "Discord Server", value = "discord.gg/Y733pGaXR"})

Tab4:CreateButton({
	name = "Copy Discord Invite Link",
	callback = function()
		local v1 = setclipboard or toclipboard or syn and syn.write_clipboard or Clipboard and Clipboard.set
		if v1 then
			v1("https://discord.gg/Y733pGaXR")
			Window:Notify({title = "Discord Link", content = "Copied link to clipboard!", duration = 3})
		else
			Window:Notify({title = "Discord Link", content = "https://discord.gg/Y733pGaXR", duration = 5})
		end
	end,
})

Tab4:CreateSection({name = "Credits"})
Tab4:CreateStat({name = "Hub", value = "Void Scripts"})
Tab4:CreateStat({name = "Version", value = "v1.0"})
Tab4:CreateStat({name = "Features", value = "Silent Aim, Team ESP, Staff Alerts"})
getgenv().sneeky_silent_aim = true
local num8 = -1
local v36

v36 = v2(hookfunction(v8, v3(function(arg1, arg2, ...)
	if flag4 and num8 ~= num5 then
		num8 = num5
		CurrentCamera = workspace.CurrentCamera or CurrentCamera
		local ok, result = pcall(func8, CurrentCamera.CFrame.Position)

		if ok then
			v37 = result
		end
	end

	local v1 = flag4 and v37 or nil

	if v1 and v1.Parent and (num1 >= 100 or math.random(1, 100) <= num1) then
		return v36(
			arg1,
			{Instance = v1, Position = v1.Position, Normal = Vector3.new(0, 1, 0), Material = v1.Material},
			...
		)
	end

	return v36(arg1, arg2, ...)
end)))

function tbl.RestoreHook()
	hookfunction(v8, v36)
end
