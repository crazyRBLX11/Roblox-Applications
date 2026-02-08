-- [ Note for Reader: This works alongside 2. Locker.lua, this was written by me for the 308th Infantry Battalion's Fort Marcel ] --

--!strict
-- Written by @crazyattaker1.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage.Remotes

-- Constants
local GroupID = 35860030

local Root = script.Parent

local ProximityPromptHolder = Root.ProximityPrompt
local ProximityPrompt = ProximityPromptHolder.ProximityPrompt

local OpenLocker = ProximityPrompt.Triggered:Connect(function(player: Player)
	if player:IsInGroup(GroupID) then	
		local Character = workspace:WaitForChild(player.Name)
		local PlayerUI = player.PlayerGui
		local LockerUI = PlayerUI.LockerUI
		local Background = LockerUI.Background

		Background.Visible = true
		print("Player "..player.Name.." is in group "..GroupID.." and the locker GUI is visible.")
		
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
	end
end)
