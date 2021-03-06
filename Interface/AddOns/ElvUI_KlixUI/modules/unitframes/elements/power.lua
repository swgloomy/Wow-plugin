local KUI, E, L, V, P, G = unpack(select(2, ...))
local KUF = KUI:GetModule("KUIUnits")
local UF = E:GetModule('UnitFrames');
local LSM = LibStub("LibSharedMedia-3.0");
UF.LSM = LSM

local _G = _G
local pairs, select = pairs, select

function KUF:Configure_Power(frame)
	local power = frame.Power

	if frame.USE_POWERBAR then
		if frame.POWERBAR_DETACHED then
			if frame.POWER_VERTICAL then
				power:SetOrientation('VERTICAL')
			else
				power:SetOrientation('HORIZONTAL')
			end
			if power.backdrop.shadow then
				power.backdrop.shadow:Show()
			end
		else
			if power.backdrop.shadow then
				power.backdrop.shadow:Hide()
			end
		end
	end
end

-- Units
function KUF:ChangeUnitPowerBarTexture()
	local bar = LSM:Fetch("statusbar", E.db.KlixUI.unitframes.textures.power)
	for _, unitName in pairs(UF.units) do
		local frameNameUnit = E:StringTitle(unitName)
		frameNameUnit = frameNameUnit:gsub("t(arget)", "T%1")

		local unitframe = _G["ElvUF_"..frameNameUnit]
		if unitframe and unitframe.Power and not unitframe.Power.isTransparent then unitframe.Power:SetStatusBarTexture(bar) end
	end
end
hooksecurefunc(UF, "Update_AllFrames", KUF.ChangeUnitPowerBarTexture)

-- Raid
function KUF:ChangeRaidPowerBarTexture()
	local header = _G['ElvUF_Raid']
	local bar = LSM:Fetch("statusbar", E.db.KlixUI.unitframes.textures.power)
	for i = 1, header:GetNumChildren() do
		local group = select(i, header:GetChildren())

		for j = 1, group:GetNumChildren() do
			local unitbutton = select(j, group:GetChildren())
			if unitbutton.Power and not unitbutton.Power.isTransparent then
				unitbutton.Power:SetStatusBarTexture(bar)
			end
		end
	end
end
hooksecurefunc(UF, 'Update_RaidFrames', KUF.ChangeRaidPowerBarTexture)

-- Raid-40
function KUF:ChangeRaid40PowerBarTexture()
	local header = _G['ElvUF_Raid40']
	local bar = LSM:Fetch("statusbar", E.db.KlixUI.unitframes.textures.power)
	for i = 1, header:GetNumChildren() do
		local group = select(i, header:GetChildren())

		for j = 1, group:GetNumChildren() do
			local unitbutton = select(j, group:GetChildren())
			if unitbutton.Power and not unitbutton.Power.isTransparent then
				unitbutton.Power:SetStatusBarTexture(bar)
			end
		end
	end
end
hooksecurefunc(UF, 'Update_Raid40Frames', KUF.ChangeRaid40PowerBarTexture)

-- Party
function KUF:ChangePartyPowerBarTexture()
	local header = _G['ElvUF_Party']
	local bar = LSM:Fetch("statusbar", E.db.KlixUI.unitframes.textures.power)
	for i = 1, header:GetNumChildren() do
		local group = select(i, header:GetChildren())

		for j = 1, group:GetNumChildren() do
			local unitbutton = select(j, group:GetChildren())
			if unitbutton.Power and not unitbutton.Power.isTransparent then
				unitbutton.Power:SetStatusBarTexture(bar)
			end
		end
	end
end
hooksecurefunc(UF, 'Update_PartyFrames', KUF.ChangePartyPowerBarTexture)

-- Arena
function KUF:ChangeArenaPowerBarTexture()
	local bar = LSM:Fetch("statusbar", E.db.KlixUI.unitframes.textures.power)
	for i = 1, 5 do
		local unitbutton = _G["ElvUF_Arena"..i]
		if unitbutton.Power and not unitbutton.Power.isTransparent then
			unitbutton.Power:SetStatusBarTexture(bar)
		end
	end
end
hooksecurefunc(UF, 'Update_ArenaFrames', KUF.ChangeArenaPowerBarTexture)

-- Boss
function KUF:ChangeBossPowerBarTexture()
	local bar = LSM:Fetch("statusbar", E.db.KlixUI.unitframes.textures.power)
	for i = 1, 5 do
		local unitbutton = _G["ElvUF_Boss"..i]
		if unitbutton.Power and not unitbutton.Power.isTransparent then
			unitbutton.Power:SetStatusBarTexture(bar)
		end
	end
end
hooksecurefunc(UF, 'Update_BossFrames', KUF.ChangeBossPowerBarTexture)


function KUF:ChangePowerBarTexture()
	KUF:ChangeUnitPowerBarTexture()
	KUF:ChangeRaidPowerBarTexture()
	KUF:ChangeRaid40PowerBarTexture()
	KUF:ChangePartyPowerBarTexture()
	KUF:ChangeArenaPowerBarTexture()
	KUF:ChangeBossPowerBarTexture()
end
hooksecurefunc(UF, 'Update_StatusBars', KUF.ChangePowerBarTexture)