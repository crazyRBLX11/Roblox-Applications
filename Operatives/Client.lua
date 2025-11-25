--!strict
local ClientController = {}
ClientController.__index = ClientController

local SoundService = game:GetService("SoundService")
local UserInputService = game:GetService("UserInputService")

local Remotes = require(game:GetService("ReplicatedStorage").Remotes.Blink.Client)

local function UI(Player: Player)
	local HasTheCharacterBeenMade = false

	local Fusion = require(script.Parent.Parent.Packages.Fusion)
	local scoped = Fusion.scoped
	local OnEvent = Fusion.OnEvent

	local scope = scoped({
		New = Fusion.New,
		doCleanup = Fusion.doCleanup,
		innerScope = Fusion.innerScope,
		Value = Fusion.Value,
		Children = Fusion.Children,
		Computed = Fusion.Computed,
	})

	local CharacterParts = {}
	for i, v in ipairs(workspace:GetChildren()) do
		if v:IsA("Model") then
			for _, players in ipairs(game:GetService("Players"):GetChildren()) do
				if v.Name == players.Name then
					for index, part in ipairs(v:GetChildren()) do
						if part:IsA("BasePart") then
							table.insert(CharacterParts, part)
							part.Transparency = 1
						end
					end
				end
			end
		end
	end

	-- Welcome Sequence
	if HasTheCharacterBeenMade == false then
		local ScreenGui = scope:New("ScreenGui")({
			Name = "ClientUIHandle",
			Parent = Player.PlayerGui,

			ResetOnSpawn = false,
			IgnoreGuiInset = true,
		})

		local BackgroundFrame = scope:New "Frame" {
			Name = "BackgroundFrame",
			Parent = ScreenGui,

			Size = UDim2.fromScale(1, 1),
			Transparency = 0.7
		}

		local CurrentCamera, Part = workspace.CurrentCamera, workspace.Lobby:WaitForChild("MenuCamera")  
		CurrentCamera.CameraType = Enum.CameraType.Scriptable
		CurrentCamera.CFrame = Part.CFrame

		local WelcomeScreenScope = scope:innerScope()

		local BlurEffect = Instance.new("BlurEffect")
		BlurEffect.Size = 10
		BlurEffect.Parent = game:GetService("Lighting")

		local GameTitle = WelcomeScreenScope:New "TextLabel" {
			Name = "GameTitle",
			Text = "Operatives",

			AnchorPoint = Vector2.new(0.5, 0.25),
			Size = UDim2.new(0.4, 0, 0.4, 0),
			Position = UDim2.fromScale(0.5, 0.25),

			Parent = BackgroundFrame
		}

		local PlayButton = WelcomeScreenScope:New "TextButton" {
			Name = "Play",
			Text = "Play.",

			AnchorPoint = Vector2.new(0.5, 0.75),
			Size = UDim2.new(0.1, 0, 0.1, 0),
			Position = UDim2.fromScale(0.5, 0.75),

			Parent = BackgroundFrame
		}

		PlayButton.MouseButton1Click:Connect(function()
			for i, v in ipairs(CharacterParts) do
				if v.Name ~= "HumanoidRootPart" then
					v.Transparency = 0
				end
			end
			
			BlurEffect:Destroy()
			WelcomeScreenScope:doCleanup()

			local CharacterCustomizationFrame = scope:New("Frame")({
				Name = "CharacterDesigner",
				Parent = BackgroundFrame,

				Size = UDim2.fromScale(1, 1),
				BackgroundColor3 = Color3.fromRGB(223, 209, 209),
			})

			local ViewportFrame = scope:New("ViewportFrame")({
				Name = "CharacterFrame",
				Parent = CharacterCustomizationFrame,

				Size = UDim2.fromScale(0.4, 1),
			})

			local WorldModel = scope:New("WorldModel")({
				Name = "Character",
				Parent = ViewportFrame,
			})

			local Character = Player.Character or Player.CharacterAdded:Wait()

			local ViewportCamera = scope:New("Camera")({
				Parent = ViewportFrame,

				CFrame = CFrame.new(0, 0, 0),
			})

			ViewportFrame.CurrentCamera = ViewportCamera

			repeat
				task.wait(0.1)
			until game:IsLoaded()

			Character.Archivable = true

			Character.Parent = WorldModel
			Character.Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
			Character:SetPrimaryPartCFrame(CFrame.new(Vector3.new(0, 0, -9.5), Vector3.new(0, 0, 0)))

			local IsTheMouseInDisplay = false
			local IsTheMouseHeldInDisplay = false
			local CurrentX

			UserInputService.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					if IsTheMouseInDisplay then
						IsTheMouseHeldInDisplay = true
						CurrentX = nil
					else
						IsTheMouseHeldInDisplay = false
					end
				end
			end)

			ViewportFrame.MouseMoved:Connect(function(X, Y)
				if IsTheMouseHeldInDisplay == false then
					return
				end

				if CurrentX ~= nil then
					Character.PrimaryPart.CFrame *= CFrame.fromEulerAnglesXYZ(0, (X - CurrentX) * 0.025, 0)
				end

				CurrentX = X
			end)

			ViewportFrame.MouseEnter:Connect(function()
				IsTheMouseInDisplay = true
			end)
			ViewportFrame.MouseLeave:Connect(function()
				IsTheMouseInDisplay = false
			end)

			local GenderScope = scope:innerScope({
				New = Fusion.New,
				doCleanup = Fusion.doCleanup,
				innerScope = Fusion.innerScope,
				Value = Fusion.Value,
				Children = Fusion.Children,
				Computed = Fusion.Computed,
			})

			local PostGender = coroutine.create(function()
				local SkinScope = scope:innerScope({
					New = Fusion.New,
					doCleanup = Fusion.doCleanup,
					innerScope = Fusion.innerScope,
					Value = Fusion.Value,
					Children = Fusion.Children,
					Computed = Fusion.Computed,
				})
				GenderScope:doCleanup()

				local SkinTones = {
					Color3.fromRGB(255, 220, 197), -- White
					Color3.fromRGB(241, 199, 150), -- Medium Light
					Color3.fromRGB(75, 48, 0), -- Dark
					Color3.fromRGB(54, 29, 0), -- Black
				}

				local DefaultTone = SkinScope:Value(SkinTones[1])

				local function SelectSkinTone(SkinTone: number)
					Remotes.SortTone.Fire(SkinTone)
				end

				local SkinFrame = SkinScope:New "Frame" {
					Name = "SkinToneSelector",
					Parent = CharacterCustomizationFrame,

					Size = UDim2.fromScale(0.6, 1),
					Position = UDim2.fromScale(0.4, 0),
					BackgroundColor3 = Color3.fromRGB(255, 202, 202),
				}
				
				local SkinToneOptions = SkinScope:New "Frame" {
					Name = "SkinToneOptions",

					Size = UDim2.fromScale(0.5, 0.5),
					Position = UDim2.fromScale(0.25, 0.25),
					Parent = SkinFrame
				}
				
				for i, color in ipairs(SkinTones) do
					SkinScope:New "TextButton" {
						Parent = SkinToneOptions,
						Size = UDim2.fromScale(0.25, 1),
						Position = UDim2.fromScale(0.25 * (i - 1), 0),
						BackgroundColor3 = color,
						Text = "",
						Name = "Color",
						TextSize = 12,						
						[Fusion.OnEvent("MouseButton1Click")] = function()
							SelectSkinTone(i)
						end,
					}
				end
				
				local NextButton = SkinScope:New "TextButton" {
					Name = "NextButton",
					Parent = SkinFrame,
					
					Size = UDim2.fromScale(0.1, 0.1),
					Position = UDim2.fromScale(0.45, 0.8),
					
					Text = "Next.",
					
					[OnEvent("Activated")] = function()
						local ClothingScope = scope:innerScope({
							New = Fusion.New,
							doCleanup = Fusion.doCleanup,
							innerScope = Fusion.innerScope,
							Value = Fusion.Value,
							Children = Fusion.Children,
							Computed = Fusion.Computed,
						})
						SkinScope:doCleanup()
						Remotes.AvatarSearchQuery.Invoke("start")
					end,
				}
			end)

			local GenderFrame = GenderScope:New("Frame")({
				Name = "GenderPicker",
				Parent = CharacterCustomizationFrame,

				Size = UDim2.fromScale(0.6, 1),
				Position = UDim2.fromScale(0.4, 0),
				BackgroundColor3 = Color3.fromRGB(255, 202, 202),
			})

			GenderScope:New("TextButton")({
				Name = "Male",
				Parent = GenderFrame,

				Size = UDim2.fromScale(0.2, 0.5),
				Position = UDim2.fromScale(0.2, 0.25),
				Text = "Male",
				TextScaled = true,

				[OnEvent("Activated")] = function()
					Remotes.SortGender.Fire(1)
					coroutine.resume(PostGender)
				end,
			})

			GenderScope:New("TextButton")({
				Name = "Female",
				Parent = GenderFrame,

				Size = UDim2.fromScale(0.2, 0.5),
				Position = UDim2.fromScale(0.6, 0.25),
				Text = "Female",
				TextScaled = true,

				[OnEvent("Activated")] = function()
					Remotes.SortGender.Fire(2)
					coroutine.resume(PostGender)
				end,
			})
		end)
	end
end

function ClientController.new(Player: Player)
	local self = {}

	local PlayerContext = Instance.new("InputContext")
	PlayerContext.Name = "PlayerContext"
	PlayerContext.Parent = Player.PlayerGui

	self.Fusion = require(script.Parent.Parent.Packages.Fusion)

	UI(Player)

	local PlayerGui = Player.PlayerGui
	local Handle = PlayerGui:WaitForChild("ClientUIHandle")

	local WidthAspectRatio: UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
	WidthAspectRatio.Parent = Handle

	local HeightAspectRatio: UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
	HeightAspectRatio.Parent = Handle

	local TextChatService = game:GetService("TextChatService")
	local TextChatCommands = TextChatService:WaitForChild("TextChatCommands")
	TextChatCommands:WaitForChild("RBXVersionCommand"):Destroy()
	TextChatCommands:WaitForChild("RBXHelpCommand"):Destroy()
	TextChatCommands:WaitForChild("RBXEmoteCommand"):Destroy()
	TextChatCommands:WaitForChild("RBXTeamCommand"):Destroy()
	local RBXGeneral_Channel: TextChannel = TextChatService:FindFirstChild("RBXGeneral", true)
	local Message = "Operatives Public Tech Demo - Stage 5 - 3D Lobby, Character Customization, UI Redesign, and Development Overhaul."

	TextChatService.OnIncomingMessage = function(msg: TextChatMessage)
		local Prefix = Instance.new("TextChatMessageProperties")
		if not msg.TextSource then
			local TagColour = Color3.new(0.960784, 0.803922, 0.188235):ToHex()
			Prefix.PrefixText = "<font color='#" .. TagColour .. "'>[System]:</font> " .. msg.PrefixText
		end
		return Prefix
	end

	RBXGeneral_Channel:DisplaySystemMessage("Welcome, " .. Player.Name .. ", to Operatives.")
	RBXGeneral_Channel:DisplaySystemMessage(Message)

	local ShouldMusicPlay = true
	local Soundtracks = SoundService.Soundtracks
	Soundtracks:GetChildren()[math.random(1, #Soundtracks:GetChildren())]:Play()
	local MuteCooldown = false
	local MuteAction = Instance.new("InputAction")
	MuteAction.Name = "MuteAction"
	MuteAction.Parent = PlayerContext
	local MutePC = Instance.new("InputBinding")
	MutePC.Name = "MutePC"
	MutePC.KeyCode = Enum.KeyCode.U
	MutePC.Parent = MuteAction
	local MuteConsole = Instance.new("InputBinding")
	MuteConsole.Name = "MuteConsole"
	MuteConsole.KeyCode = Enum.KeyCode.ButtonL1
	MuteConsole.Parent = MuteAction
	--local MuteMobile = Instance.new("InputBinding")
	--MuteMobile.Name = "MuteMobile"
	--MuteMobile
	--MuteMobile.Parent = MuteAction
	MuteAction.Pressed:Connect(function()
		if MuteCooldown then
			task.wait(1)
			MuteCooldown = false
		else
			if ShouldMusicPlay then
				for i: number, v: Sound in ipairs(game:GetService("SoundService").Soundtracks:GetChildren()) do
					if v:IsA("Sound") and v.Playing then
						v:Pause()
					end
				end
				ShouldMusicPlay = false
				MuteCooldown = true
			elseif ShouldMusicPlay == false then
				for i: number, v: Sound in ipairs(game:GetService("SoundService").Soundtracks:GetChildren()) do
					if v:IsA("Sound") and v.Paused and v.TimePosition ~= 0 then
						v:Resume()
					end
				end
				ShouldMusicPlay = true
				MuteCooldown = true
			end
		end
	end)

	coroutine.resume(coroutine.create(function()
		while task.wait(30) do
			RBXGeneral_Channel:DisplaySystemMessage(Message)
		end
	end))

	return self
end

return ClientController