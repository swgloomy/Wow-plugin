local KUI, E, L, V, P, G = unpack(select(2, ...))
local KS = KUI:GetModule("KuiSkins")
local S = E:GetModule("Skins")

-- Cache global variables
-- Lua functions
local _G = _G

-- WoW API

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

local function styleWarfrontPartyPose()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.IslandsPartyPose ~= true or E.private.KlixUI.skins.blizzard.IslandsPartyPose ~= true then return end

	local WarfrontsPartyPoseFrame = _G["WarfrontsPartyPoseFrame"]
	WarfrontsPartyPoseFrame:Styling()

	local rewardFrame = WarfrontsPartyPoseFrame.RewardAnimations.RewardFrame
	-- Hide ElvUI's backdrop
	if rewardFrame.backdrop then rewardFrame.backdrop:Hide() end

	local bg = KS:CreateBDFrame(rewardFrame)
	bg:SetPoint("TOPLEFT", -5, 5)
	bg:SetPoint("BOTTOMRIGHT", rewardFrame.NameFrame, 0, -5)

	KS:CreateBDFrame(rewardFrame.Icon)
end

S:AddCallbackForAddon("Blizzard_WarfrontsPartyPoseUI", "KuiWarfrontPartyPose", styleWarfrontPartyPose)