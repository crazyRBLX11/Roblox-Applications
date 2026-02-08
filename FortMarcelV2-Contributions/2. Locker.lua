-- [ Note for Reader: This works alongside 1. LockerTrigger.lua, this was written by me for the 308th Infantry Battalion's Fort Marcel (however, other developers have contributed with bug fixes ] --
-- [ This script handles the equipping of uniforms and equipment (firearms and binoculars) for both the main 308th Infantry Battalion and it's sub-divisions ] --

--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local GroupIDs = {
	["308"] = 35860030,
	["37CBRN"] = 4939795,
	["308MRU"] = 610104217,
	["NESU"] = 33737700,
	["33SCOUT"] = 409219285
	
}

function LockerUpdate(Player: Player, Uniform:any?, Firearm:any?, RemoveAccessories:boolean?)
	if not Player.Character then return end
	if Uniform then
		if Uniform[1] ~= 0 then
			local shirt = Player.Character:FindFirstChildOfClass("Shirt")
			if not shirt then
				local ShirtInstance = Instance.new("Shirt")
				ShirtInstance.Parent = Player.Character
				ShirtInstance.Name = "Shirt"

				ShirtInstance.ShirtTemplate = Uniform[1]
			else
				shirt.ShirtTemplate = Uniform[1]
			end
		end
		if Uniform[2] ~= 0 then
			local pants = Player.Character:FindFirstChildOfClass('Pants')
			if not pants then
				local PantsInstance = Instance.new("Pants")
				PantsInstance.Parent = Player.Character
				PantsInstance.Name = "Pants"

				PantsInstance.PantsTemplate = Uniform[2]
			else
				pants.PantsTemplate = Uniform[2]
			end
		end
	end
	if Firearm then
		for i, v in ipairs(Firearm) do
			local Tool: Tool = Player.Backpack:FindFirstChild(v) or Player.Character:FindFirstChild(v)
			if not Tool then
				local NewWeapon = ReplicatedStorage:WaitForChild(v):Clone()
				NewWeapon.Parent = Player.Backpack
				print("given")

			-- creating the requipping bug, to be inspected later
				--else
			--	if not Tool:FindFirstAncestorOfClass('Backpack') then
			--		Tool.ManualActivationOnly = true
			--		Tool:Deactivate()
			--		task.wait(0.5)--need to simulate tool deactivation for trek to fix the player
			--	end
			--	Tool:Destroy()
			end
		end
	end
	if RemoveAccessories == true then
		for i, v in ipairs(Player.Character:GetChildren()) do
			if v:IsA("Accessory") then
				v:Destroy()
			end
		end
		RemoveAccessories = false
	end
end

function RegisterPlayer(Player: Player)
	local Background = Player.PlayerGui:WaitForChild('LockerUI').Background
	local DiscardButton = Background:WaitForChild('DiscardButton')
	local ApplyButton = Background:WaitForChild('ApplyButton')
	local RemoveAccessoriesButton = Background:WaitForChild("RemoveAccessories")

	local Remotes = ReplicatedStorage.Remotes
	local LockerEvent = Remotes.RemoteEvent

	local SubmenuButtons = Background:WaitForChild("SubmenuButtons")
	local OthersFrameHolder = Background:WaitForChild("OthersFrameHolder")
	local UniformFrameHolder = Background:WaitForChild("UniformFrameHolder")
	local EquipmentFrameHolder = Background:WaitForChild("EquipmentFrameHolder")

	local SideUniformButton = SubmenuButtons:WaitForChild("1.SmallUniformsButton")
	local SideEquipmentButton = SubmenuButtons:WaitForChild("2.EquipmentButton")
	local MRUStanButton = OthersFrameHolder:WaitForChild("MRUStan")
	local MRUOliveButton = OthersFrameHolder:WaitForChild("MRUOlive")
	local MRUMEDButton = OthersFrameHolder:WaitForChild("MRUMED")
	local MRUOliveMEDButton = OthersFrameHolder:WaitForChild("MRUOliveMED")
	local SCOUTButton = OthersFrameHolder:WaitForChild("SCOUT")
	local NESUButton = OthersFrameHolder:WaitForChild("NESU")
	local LiquidatorButton = OthersFrameHolder:WaitForChild("Liquidator Standard")
	local N51Button = OthersFrameHolder:WaitForChild("Liquidator N51")
	local N53Button = OthersFrameHolder:WaitForChild("Liquidator N53")

	local OthersButton = SubmenuButtons:WaitForChild("3.Others")
	
	-- uniform buttons
	local Standard = Background:WaitForChild("UniformFrameHolder"):WaitForChild("M81")
	local Olive = Background:WaitForChild("UniformFrameHolder"):WaitForChild("Olive")
	local PT = Background:WaitForChild("UniformFrameHolder"):WaitForChild("PT")

	local UniformRankOlive = {
		{"Private", "rbxassetid://94298647128026", "rbxassetid://70481605744517"},
		{"Private First Class", "rbxassetid://94298647128026", "rbxassetid://134079772917699"},
		{"Private Second Class", }, --to be added
		{"Specialist", "rbxassetid://94298647128026", "rbxassetid://134079772917699"}, --using Sn inf
		{"Lance Corporal", }, --to be added
		{"Corporal", "rbxassetid://94298647128026", "rbxassetid://77798785963007"},
		{"Squad Sergeant", "rbxassetid://94298647128026", "rbxassetid://111079742683474"},
		{"Platoon Sergeant", "rbxassetid://94298647128026", "rbxassetid://112646286657126"},
		{"Staff Sergeant", },
		{"Staff Gunnery Sergeant", },
		{"First Sergeant", "rbxassetid://94298647128026", "rbxassetid://89288278043185"},
		{"Master Sergeant", "rbxassetid://94298647128026", "rbxassetid://107960455123696"},
		{"Command Sergeant", "rbxassetid://94298647128026", "rbxassetid://85141892482744"},
	}

	local UniformRankStandard = {
		{"Private", "rbxassetid://129029943209750", "rbxassetid://97451079068806"},
		{"Private First Class", "rbxassetid://129029943209750", "rbxassetid://135179569231094"},
		{"Private Second Class", },
		{"Specialist", "rbxassetid://129029943209750", "rbxassetid://135179569231094"}, -- using Sn inf
		{"Corporal", "rbxassetid://129029943209750", "rbxassetid://125514537333293"},
		{"Lance Corporal", },
		{"Squad Sergeant", "rbxassetid://129029943209750", "rbxassetid://111825093043713"},
		{"Platoon Sergeant", "rbxassetid://129029943209750", "rbxassetid://135689071617982"},
		{"Staff Sergeant", },
		{"Staff Gunnery Sergeant", },
		--{"First Sergeant", "rbxassetid://129029943209750", ""}, full set doesnt exist
		--{"Master Sergeant", "rbxassetid://129029943209750", ""}, full set doesnt exist
		{"Command Sergeant", "rbxassetid://129029943209750", "rbxassetid://132654366078754"},
		{"Lieutenant", "rbxassetid://129029943209750", "rbxassetid://93616433837486"}, -- first or second
		{"Captain", "rbxassetid://129029943209750", "rbxassetid://93022623389446"},
	}
	
	local function CharRemoved()
		Background.Visible = false
		print("discarded")

		LockerEvent:FireClient(Player, true)
	end
	
	local function CharLoaded()
		local rank = Player:GetRoleInGroup(GroupIDs["308"])

		local shirt 
		local pants

		if Player:IsInGroup(GroupIDs["33SCOUT"]) then
			OthersButton.Visible = true
			SCOUTButton.Visible = true
		elseif Player:IsInGroup(GroupIDs["308MRU"]) then
			OthersButton.Visible = true
			MRUStanButton.Visible = true
			MRUOliveButton.Visible = true
			MRUMEDButton.Visible = true
			MRUOliveMEDButton.Visible = true
			
		elseif Player:IsInGroup(GroupIDs["NESU"]) then
			OthersButton.Visible = true
			NESUButton.Visible = true
		elseif Player:IsInGroup(GroupIDs["37CBRN"]) then
			OthersButton.Visible = true
			LiquidatorButton.Visible = true
			N51Button.Visible = true
			N53Button.Visible = true
		end

		--locker buttons
		SideUniformButton.MouseButton1Click:Connect(function()
			EquipmentFrameHolder.Visible = false
			OthersFrameHolder.Visible = false
			UniformFrameHolder.Visible = true
		end)

		SideEquipmentButton.MouseButton1Click:Connect(function()
			EquipmentFrameHolder.Visible = true
			UniformFrameHolder.Visible = false
			OthersFrameHolder.Visible = false
		end)
		
		OthersButton.MouseButton1Click:Connect(function()
			EquipmentFrameHolder.Visible = false
			UniformFrameHolder.Visible = false
			OthersFrameHolder.Visible = true
		end)

		--uniforms
		if Player.Character then
			Standard.MouseButton1Click:Connect(function()
				for _, v in ipairs(UniformRankStandard) do
					if v[1] == rank then
						shirt = v[3]
						pants = v[2]
						return
					end
				end
			end)
		end
		
		if Player.Character then
			Olive.MouseButton1Click:Connect(function()
				for _, v in ipairs(UniformRankOlive) do
					if v[1] == rank then
						shirt = v[3]
						pants = v[2]
						return
					end
				end
			end)
		end
		
		if Player.Character then
			PT.MouseButton1Click:Connect(function()
				shirt = "rbxassetid://129661489304482"
				pants = "rbxassetid://130589272193082"
			end)
		end
		
		--MRU--
		if Player.Character then
			MRUStanButton.MouseButton1Click:Connect(function()
				shirt = "rbxassetid://81503380334512"
				pants = "rbxassetid://100198898069018"
			end)
				
			MRUOliveButton.MouseButton1Click:Connect(function()
				shirt = "rbxassetid://78693532026356"
				pants = "rbxassetid://117631058258256"
			end)
				
			MRUMEDButton.MouseButton1Click:Connect(function()
				shirt = "rbxassetid://92040361387413"
				pants = "rbxassetid://100198898069018"
			end)

			MRUOliveMEDButton.MouseButton1Click:Connect(function()
				shirt = "rbxassetid://74926045940306"
				pants = "rbxassetid://117631058258256"
			end)
		end
		
		if Player.Character then
			SCOUTButton.MouseButton1Click:Connect(function()
				shirt = ""
				pants = ""
			end)
		end
		
		if Player.Character then
			NESUButton.MouseButton1Click:Connect(function()
				shirt = ""
				pants = ""
			end)
		end
		
		--liquidators--
		if Player.Character then
			LiquidatorButton.MouseButton1Click:Connect(function()
				shirt = "rbxassetid://72759149988399"
				pants = "rbxassetid://116091220614099"
			end)
			
			N51Button.MouseButton1Click:Connect(function()
				shirt = "rbxassetid://94453184941711"
				pants = "rbxassetid://116852260514758"
			end)
			
			N53Button.MouseButton1Click:Connect(function()
				shirt = "rbxassetid://86321945562359"
				pants = "rbxassetid://90384000975772"
			end)
		end

		local PendingEquipmentChanges = {}
		-- weapons
		EquipmentFrameHolder.ScrollingFrame:WaitForChild("1.D19").MouseButton1Click:Connect(function()
			table.insert(PendingEquipmentChanges, "D-19")
		end)

		EquipmentFrameHolder.ScrollingFrame:WaitForChild("2.Binoculars").MouseButton1Click:Connect(function()
			table.insert(PendingEquipmentChanges, "Binoculars")
		end)

		local RemoveAccessories = false
		RemoveAccessoriesButton.MouseButton1Click:Connect(function()
			RemoveAccessories = true
		end)
	
		-- Discard and Apply Buttons.
		local Uniform: {any} = {}
		DiscardButton.MouseButton1Click:Connect(function()
			Background.Visible = false
			print("discarded")
			shirt = 0
			pants = 0
			table.clear(Uniform)
			table.clear(PendingEquipmentChanges)
			RemoveAccessories = false
		end)

		ApplyButton.MouseButton1Click:Connect(function()
			Background.Visible = false
			print("closed and saved")
			if shirt then
				table.insert(Uniform, shirt)
			else
				table.insert(Uniform, 0)
			end
			if pants then
				table.insert(Uniform, pants)
			else
				table.insert(Uniform, 0)
			end
			task.wait()
			LockerUpdate(Player, Uniform, PendingEquipmentChanges, RemoveAccessories)
			task.wait()
			table.clear(PendingEquipmentChanges)
			RemoveAccessories = false
		end)
	end
	
	Player.CharacterAdded:Connect(CharLoaded)
	Player.CharacterRemoving:Connect(CharRemoved)
	
	if Player.Character then CharLoaded() end
end

for _, plr in ipairs(Players:GetPlayers()) do
	task.spawn(RegisterPlayer, plr)
end
Players.PlayerAdded:Connect(RegisterPlayer)
