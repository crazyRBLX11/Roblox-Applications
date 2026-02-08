--!strict
local CollectionService = game:GetService("CollectionService")
local ServerStorage = game:GetService("ServerStorage")
local InsertService = game:GetService("InsertService")
local Players = game:GetService("Players")

for i, Locker in pairs(CollectionService:GetTagged("Locker")) do
	Locker.ProximityPrompt.ProximityPrompt.Triggered:Connect(function(player)
		local PlayerUI = player.PlayerGui
		local LockerUI = PlayerUI.LockerUI
		local Background = LockerUI.Background

		Background.Visible = true
		for i, Label in ipairs(Background.LoadoutFrame:GetChildren()) do
			if Label:IsA("TextLabel") then
				Label:Destroy()
			end
		end
		for index, Tool in ipairs(player.Backpack:GetChildren()) do
			if Tool:IsA("Tool") then
				local LoadoutText = Instance.new("TextLabel")
				LoadoutText.Size = UDim2.fromScale(1, 0.2)
				LoadoutText.TextSize = 20
				LoadoutText.Text = Tool.Name
				LoadoutText.BackgroundColor3 = Color3.fromRGB(26, 24, 22)
				LoadoutText.BackgroundTransparency = 0.5
				LoadoutText.TextColor3 = Color3.fromRGB(255, 255, 255)
				LoadoutText.Parent = Background.LoadoutFrame
			end
		end
	end)
end

local GroupIDs = {
	["377"] = 393710236,
	["NSU"] = 73309057,
	["22MC"] = 187243778,
	["NMP"] = 784410940,
}

local Accessories = {
	CombatsSCOUT = {
		InsertService:LoadAsset(13939084981),
		InsertService:LoadAsset(13936735495),
		InsertService:LoadAsset(13651613898),
		InsertService:LoadAsset(8029381653),
		InsertService:LoadAsset(7214048222),
		InsertService:LoadAsset(15660757281),
		InsertService:LoadAsset(14240528287),
	},
	--unused variant, leave alone for now
	--NSU_accessory = {
	--	InsertService:LoadAsset(12753101622),
	--	InsertService:LoadAsset(14365791976),
	--	InsertService:LoadAsset(13957920696),
	--	InsertService:LoadAsset(18325759243),
	--	InsertService:LoadAsset(93906833203448),
	--	InsertService:LoadAsset(14525344449),
	--},
	--NSU_accessory = {
	--	InsertService:LoadAsset(9676371902),
	--	InsertService:LoadAsset(15912600784),
	--	InsertService:LoadAsset(13939084981),
	--	InsertService:LoadAsset(13936735495),
	--	InsertService:LoadAsset(14240462298),
	--},
	CombatsNSU = {
		InsertService:LoadAsset(12496858421),
		InsertService:LoadAsset(14320195612),
		InsertService:LoadAsset(12586895741),
		InsertService:LoadAsset(6441037335),
		InsertService:LoadAsset(6441037335),
		InsertService:LoadAsset(16457201737),
	},
	N51_Accessory = {
		InsertService:LoadAsset(13720140989),
		InsertService:LoadAsset(10730347272),
		InsertService:LoadAsset(5197237539),
	},
	N53_Accessory = {
		InsertService:LoadAsset(13720134907),
		InsertService:LoadAsset(10738548407),
		InsertService:LoadAsset(5197237539),
	},
	CombatsNMP = {
		InsertService:LoadAsset(97221274937430),
		InsertService:LoadAsset(88080098633505),
		InsertService:LoadAsset(15676650861),
	},
	Grunt_Accessory = {
		InsertService:LoadAsset(15912600784),
	},
}

type Clothes = {
	Shirt: string,
	Pants: string,
}

local Clothing: { UniformIRBU: Clothes, PT: Clothes, CombatsNSU: Clothes, CombatsSCOUT: Clothes, FormalsNSU: Clothes, CombatsNMP: Clothes } =
	{
		-- Main Infantry Forces.
		UniformIRBU = { Shirt = "121739974970865", Pants = "110869534886358" },
		PT = { Shirt = "129661489304482", Pants = "130589272193082" },

		-- Noobic Strike Unit.
		CombatsNSU = { Shirt = "131062285671337", Pants = "116340124450192" },
		CombatsSCOUT = { Shirt = "93227774517598", Pants = "78829868621901" },
		FormalsNSU = { Shirt = "129346115655784", Pants = "95066004436117" },

		CombatsNMP = { Shirt = "126785888126106", Pants = "84160661074033" },
	}

local function RemoveAccessories(Player: Player)
	local Character = Player.Character

	if Character then
		for i, v in ipairs(Character:GetChildren()) do
			if v:IsA("Accessory") and v.AccessoryType ~= Enum.AccessoryType.Hair then
				v:Destroy()
			end
		end
	end
end

local function AddAccessories(Player: Player, data)
	for _, v in ipairs(data) do
		for _, n in ipairs(v:GetChildren()) do
			if n:IsA("Accessory") then
				n:Clone().Parent = Player.Character
			end
		end
	end
end

function UpdateCharacterAndBackpack(Player: Player, Uniform: any?, Firearm: any?)
	if not Player.Character then
		return
	end

	if Uniform then
		if Uniform[1] ~= "0" then
			local shirt = Player.Character:FindFirstChildOfClass("Shirt")
			if not shirt then
				local ShirtInstance = Instance.new("Shirt")
				ShirtInstance.Parent = Player.Character
				ShirtInstance.Name = "Shirt"
				ShirtInstance.ShirtTemplate = "rbxassetid://" .. Uniform[1]
			else
				shirt.ShirtTemplate = "rbxassetid://" .. Uniform[1]
			end
		end
		if Uniform[2] ~= "0" then
			local pants = Player.Character:FindFirstChildOfClass("Pants")
			if not pants then
				local PantsInstance = Instance.new("Pants")
				PantsInstance.Parent = Player.Character
				PantsInstance.Name = "Pants"

				PantsInstance.PantsTemplate = "rbxassetid://" .. Uniform[2]
			else
				pants.PantsTemplate = "rbxassetid://" .. Uniform[2]
			end
		end
	end
	if Firearm then
		for i, v in ipairs(Firearm) do
			local Tool: Tool = Player.Backpack:FindFirstChild(v) or Player.Character:FindFirstChild(v)
			if not Tool then
				local NewWeapon = ServerStorage.Tools:WaitForChild(v):Clone()
				NewWeapon.Parent = Player.Backpack

				-- creating the requipping bug, to be inspected later
				--else
				--	if not Tool:FindFirstAncestorOfClass('Backpack') then
				--		Tool.ManualActivationOnly = true
				--		Tool:Deactivate()
				--		task.wait(0.5)-- TREK needs to fix the player
				--	end
				--	Tool:Destroy()
			end
		end
	end
end

function RegisterPlayer(Player: Player)
	local Background = Player.PlayerGui:WaitForChild("LockerUI").Background
	local DiscardButton = Background:WaitForChild("DiscardButton")
	local ApplyButton = Background:WaitForChild("ApplyButton")
	local RemoveAccessoriesButton = Background:WaitForChild("RemoveAccessories")

	local SubmenuButtons = Background:WaitForChild("SubmenuButtons")
	local OthersFrameHolder = Background:WaitForChild("OthersFrameHolder")
	local UniformFrameHolder = Background:WaitForChild("UniformFrameHolder")
	local EquipmentFrameHolder = Background:WaitForChild("EquipmentFrameHolder")
	local FormalsFrameHolder = Background:WaitForChild("FormalsFrameHolder")

	local SideUniformButton = SubmenuButtons:WaitForChild("1.SmallUniformsButton")
	local SideEquipmentButton = SubmenuButtons:WaitForChild("2.EquipmentButton")
	local SCOUTButton = OthersFrameHolder:WaitForChild("CombatsSCOUT")
	local NSUButton = OthersFrameHolder:WaitForChild("CombatsNSU")
	local NMPButton = OthersFrameHolder:WaitForChild("CombatsNMP")

	local OthersButton = SubmenuButtons:WaitForChild("4.Others")
	--local FormalsButton = SubmenuButtons:WaitForChild("3.Formals")

	local Uniform: { any } = {}
	local shirt: string = "0"
	local pants: string = "0"

	local PendingAccessories: {}? = nil
	local ShouldAccessoriesBeRemoved: boolean = false

	local function CharRemoved()
		Background.Visible = false
	end

	local function CharLoaded()
		local NSUMembership = Player:IsInGroupAsync(GroupIDs["NSU"])
		local NMPMembership = Player:IsInGroupAsync(GroupIDs["NMP"])
		OthersButton.Visible = NSUMembership or NMPMembership
		NSUButton.Visible = NSUMembership
		SCOUTButton.Visible = NSUMembership
		EquipmentFrameHolder.ScrollingFrame["2.Drill Rifle"].Visible = NSUMembership
		NMPButton.Visible = NMPMembership

		--locker buttons
		SideUniformButton.MouseButton1Click:Connect(function()
			EquipmentFrameHolder.Visible = false
			OthersFrameHolder.Visible = false
			UniformFrameHolder.Visible = true
			FormalsFrameHolder.Visible = false
		end)

		SideEquipmentButton.MouseButton1Click:Connect(function()
			EquipmentFrameHolder.Visible = true
			UniformFrameHolder.Visible = false
			OthersFrameHolder.Visible = false
			FormalsFrameHolder.Visible = false
		end)

		--[[FormalsButton.MouseButton1Click:Connect(function()
			EquipmentFrameHolder.Visible = false
			UniformFrameHolder.Visible = false
			OthersFrameHolder.Visible = false
			FormalsFrameHolder.Visible = true
		end) ]]

		OthersButton.MouseButton1Click:Connect(function()
			EquipmentFrameHolder.Visible = false
			UniformFrameHolder.Visible = false
			OthersFrameHolder.Visible = true
			FormalsFrameHolder.Visible = false
		end)

		--uniforms
		if Player.Character then
			for i, v in ipairs(UniformFrameHolder:GetChildren()) do
				if v:IsA("TextButton") then
					v.MouseButton1Click:Connect(function()
						shirt = Clothing[v.Name].Shirt
						pants = Clothing[v.Name].Pants
						ShouldAccessoriesBeRemoved = true
					end)
				end
			end

			for i, v in ipairs(OthersFrameHolder:GetChildren()) do
				if v:IsA("TextButton") then
					v.MouseButton1Click:Connect(function()
						shirt = Clothing[v.Name].Shirt
						pants = Clothing[v.Name].Pants
						PendingAccessories = Accessories[v.Name]
						ShouldAccessoriesBeRemoved = true
					end)
				end
			end
		end

		local PendingEquipmentChanges = {}
		for i, v in ipairs(EquipmentFrameHolder.ScrollingFrame:GetChildren()) do
			if v:IsA("TextButton") then
				v.MouseButton1Click:Connect(function()
					print(string.sub(v.Name, 3))
					table.insert(PendingEquipmentChanges, string.sub(v.Name, 3))
				end)
			end
		end

		RemoveAccessoriesButton.MouseButton1Click:Connect(function()
			ShouldAccessoriesBeRemoved = true
		end)

		DiscardButton.MouseButton1Click:Connect(function()
			Background.Visible = false
			shirt = "0"
			pants = "0"
			table.clear(Uniform)
			table.clear(PendingEquipmentChanges)

			PendingAccessories = nil
			ShouldAccessoriesBeRemoved = false
		end)

		ApplyButton.MouseButton1Click:Connect(function()
			table.clear(Uniform)
			Background.Visible = false

			if ShouldAccessoriesBeRemoved == true then
				RemoveAccessories(Player)
				ShouldAccessoriesBeRemoved = false
			end
			if PendingAccessories then
				AddAccessories(Player, PendingAccessories)
				task.wait()
				PendingAccessories = nil
			end

			if shirt ~= "0" then
				print(shirt)
				table.insert(Uniform, shirt)
			else
				table.insert(Uniform, "0")
			end
			if pants ~= "0" then
				print(pants)
				table.insert(Uniform, pants)
			else
				table.insert(Uniform, "0")
			end
			UpdateCharacterAndBackpack(Player, Uniform, PendingEquipmentChanges)

			table.clear(PendingEquipmentChanges)
		end)
	end

	Player.CharacterAdded:Connect(CharLoaded)
	Player.CharacterRemoving:Connect(CharRemoved)

	if Player.Character then
		CharLoaded()
	end
end

for _, plr in ipairs(Players:GetPlayers()) do
	task.spawn(RegisterPlayer, plr)
end
Players.PlayerAdded:Connect(RegisterPlayer)
