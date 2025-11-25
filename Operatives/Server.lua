local ServerHandler = {}
ServerHandler.__index = ServerHandler

local Players = game:GetService("Players")
local BadgeService = game:GetService("BadgeService")
local DataStoreService = game:GetService("DataStoreService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RoProxy = require(ReplicatedStorage.Atom.Packages.RoProxy)

local Atom = require(ReplicatedStorage.Atom.Atom.AtomServer)

local Remotes = require(ReplicatedStorage.Remotes.Blink.Server)
local CharacterCustomizationRemote = Remotes.CharacterCustomization
local RefferalReceivedEvent = Remotes.RefferalReceivedEvent

function ServerHandler.new()
	local RefferedPlayers = {}

	local self = {}
	function self.Init()
		print("Operatives Server Side Init.")
	end

	function self.Start()
		print("Operatives Server Side started.")
	end

	function self.AnchorPlayer(Character)
		local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
		if HumanoidRootPart then
			HumanoidRootPart.Anchored = true
		end
	end
	
	local existingPlayers = Players:GetPlayers()
	for i, player in existingPlayers do
		player.CharacterAdded:Connect(function(character)
			self.AnchorPlayer(player)
		end)
	end
	
	game:GetService("Players").PlayerAdded:Connect(function(player)
		local leaderstats = Instance.new("Folder")
		leaderstats.Name = "leaderstats"
		leaderstats.Parent = player		

		local Money = Instance.new("IntValue")
		Money.Name = "Money"
		Money.Parent = leaderstats

		local PlayerData = player:GetJoinData()
		local ReferredByPlayerID = PlayerData.ReferredByPlayerId
		if ReferredByPlayerID and ReferredByPlayerID ~= 0 and not RefferedPlayers[player.UserId] then
			table.insert(RefferedPlayers, player.UserId)
			local ReferralRemote = ReplicatedStorage:WaitForChild("AtomRemotes").RemoteEvents:WaitForChild("RefferalReceivedEvent")
			RefferalReceivedEvent:FireClient(player, ReferredByPlayerID)
			print(ReferredByPlayerID)
		end

		player.CharacterAdded:Connect(function(Character)
			local function applyAccessory(AssetID, character, AssetType:string?)
				local Accessory = Instance.new("Accessory")
				Accessory.Name = AssetType or "RunTime_"..AssetID

				local handle = Instance.new("Part")
				handle.Transparency = 1
				handle.CanCollide = false
				handle.Anchored = false
				handle.Parent = Accessory
				handle.Name = "Handle"

				local Attachment = Instance.new("Attachment")
				Attachment.Parent = handle

				local Asset = game:GetService("InsertService"):LoadAsset(AssetID)
				if Asset and Asset:IsA("Model") then
					for _, child in ipairs(Asset:GetChildren()) do
						if child:IsA("BasePart") then
							child.Parent = handle
						elseif child:IsA("Attachment") then
							Attachment.CFrame = child.CFrame
							Attachment.Name = child.Name
						end
					end
					Asset:Destroy()
				end

				--Accessory.Handle = handle
				Accessory.Parent = character
			end

			local SkinTones = {
				Color3.fromRGB(255, 220, 197), -- White
				Color3.fromRGB(241, 199, 150), -- Medium Light
				Color3.fromRGB(75, 48, 0), -- Dark
				Color3.fromRGB(54, 29, 0), -- Black
			}

			local Humanoid = Character:WaitForChild("Humanoid")
			Remotes.SortGender.On(function(player, gender:number)
				if gender == 1 then
					Humanoid:ApplyDescription(script.Male)
					for i, v in ipairs(Character:GetChildren()) do
						if v:IsA("BasePart") then
							v.Color = SkinTones[1]
						end
					end
				elseif gender == 2 then
					Humanoid:ApplyDescription(script.Female)
					for i, v in ipairs(Character:GetChildren()) do
						if v:IsA("BasePart") then
							v.Color = SkinTones[1]
						end
					end
				else
					player:Kick("Invalid Data Parsed.")
				end
			end)

			Remotes.SortTone.On(function(player, tone:number)
				for i, v in ipairs(Character:GetChildren()) do
					if v:IsA("BasePart") then
						v.Color = SkinTones[tone]
					end
				end
			end)
			
			Remotes.AvatarSearchQuery.On(function(Player, Value)
				local CatalogAPIEndpoint = "https://catalog.roblox.com/v1/search/items"
				local ResponseData = RoProxy.fetchJsonUrl(CatalogAPIEndpoint)
				print(ResponseData)
			end)
		end)

		coroutine.resume(coroutine.create(function()
			task.wait(60)
			table.clear(RefferedPlayers)
		end))

		if BadgeService:UserHasBadgeAsync(player.UserId, 180565921959882) == false then
			if Money == 0 then
				Money.Value = 10000
			end
			BadgeService:AwardBadge(player.UserId, 180565921959882)
		end

		if BadgeService:UserHasBadgeAsync(player.UserId, 1606848678060673) == false then
			BadgeService:AwardBadge(player.UserId, 1606848678060673)
		end

		local MissionsDataStore = DataStoreService:GetDataStore("MissionsDataStore")
		local tutorialsuccess, tutorialstatus = pcall(function()
			return MissionsDataStore:GetAsync("TutorialCompleted")
		end)
		if tutorialsuccess then
			if tutorialstatus == true and BadgeService:UserHasBadgeAsync(player.UserId, 1501816530080121) == false then
				BadgeService:AwardBadge(player.UserId, 1501816530080121)
			end
		end
	end)
	return self
end

return ServerHandler