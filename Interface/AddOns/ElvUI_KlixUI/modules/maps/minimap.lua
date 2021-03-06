local KUI, E, L, V, P, G = unpack(select(2, ...))
local KS = KUI:GetModule("KuiSkins")
local LSM = LibStub('LibSharedMedia-3.0')
local M = E:GetModule('Minimap')
local MM = KUI:NewModule("KuiMinimap", "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0")
MM.modName = L["MiniMap"]

--Cache global variables
--Lua functions
local _G = _G
local select, unpack = select, unpack
local format = string.format
--WoW API / Variables
local C_Calendar_GetNumPendingInvites = C_Calendar.GetNumPendingInvites
local CreateFrame = CreateFrame
local GetInstanceInfo = GetInstanceInfo
local GetUnitName = GetUnitName
local Minimap = _G["Minimap"]
local cluster = _G["MinimapCluster"]

--Global variables that we do

--Global variables that we don't cache, list them here for mikk's FindGlobals script
-- GLOBALS:

function MM:CheckMail()
	local inv = C_Calendar_GetNumPendingInvites()
	local mail = _G["MiniMapMailFrame"]:IsShown() and true or false
	if inv > 0 and mail then -- New invites and mail
		Minimap.backdrop:SetBackdropBorderColor(242, 5/255, 5/255)
		KUI:CreatePulse(Minimap.backdrop, 1, 1)
	elseif inv > 0 and not mail then -- New invites and no mail
		Minimap.backdrop:SetBackdropBorderColor(1, 30/255, 60/255)
		KUI:CreatePulse(Minimap.backdrop, 1, 1)
	elseif inv == 0 and mail then -- No invites and new mail
		Minimap.backdrop:SetBackdropBorderColor(unpack(E["media"].rgbvaluecolor))
		KUI:CreatePulse(Minimap.backdrop, 1, 1)
	else -- None of the above
		Minimap.backdrop:SetScript("OnUpdate", nil)
		if not E.PixelMode then
			Minimap.backdrop:SetAlpha(1)
		else
			Minimap.backdrop:SetAlpha(0)
		end
		Minimap.backdrop:SetBackdropBorderColor(unpack(E["media"].bordercolor))
	end
end

function MM:ChangeMiniMapButtons()
	if E.db.KlixUI.maps.minimap.styleButton ~= true then return end

	local r, g, b = unpack(E["media"].rgbvaluecolor)
	
	--Garrison Icon
	if _G["GarrisonLandingPageMinimapButton"] then
		local scale = E.db.general.minimap.icons.classHall.scale or 1

		_G["GarrisonLandingPageMinimapButton"]:SetScale(scale) -- needs to be set.
		_G["GarrisonLandingPageMinimapButton"].LoopingGlow:Size(_G["GarrisonLandingPageMinimapButton"]:GetSize()*1)
		_G["GarrisonLandingPageMinimapButton"]:HookScript("OnEvent", function(self)
			self:GetNormalTexture():SetAtlas(nil)
			self:SetNormalTexture("Interface\\AddOns\\ElvUI_KlixUI\\media\\textures\\Home")
			self:GetNormalTexture():SetBlendMode("ADD")
			self:GetNormalTexture():ClearAllPoints()
			self:GetNormalTexture():SetPoint("CENTER", 0, 1)
			self:GetNormalTexture():SetVertexColor(r, g, b)

			self:SetHighlightTexture("")
			
			self:SetPushedTexture("Interface\\AddOns\\ElvUI_KlixUI\\media\\textures\\Home")
			self:GetPushedTexture():SetBlendMode("ADD")
			self:GetPushedTexture():ClearAllPoints()
			self:GetPushedTexture():SetPoint("CENTER", 1, 0)
			self:GetPushedTexture():SetVertexColor(r, g, b)
		end)
	end
end

function MM:GarrisonButtonPosition()
	if E.db.KlixUI.maps.minimap.styleButton then
		E.db["general"]["minimap"]["icons"]["classHall"]["scale"] = 0.7
		E.db["general"]["minimap"]["icons"]["classHall"]["xOffset"] = 0
		E.db["general"]["minimap"]["icons"]["classHall"]["yOffset"] = -4
	else
		E.db["general"]["minimap"]["icons"]["classHall"]["scale"] = 0.6
		E.db["general"]["minimap"]["icons"]["classHall"]["xOffset"] = -4
		E.db["general"]["minimap"]["icons"]["classHall"]["yOffset"] = 0
	end
end

function MM:MiniMapPing()
	if E.db.KlixUI.maps.minimap.ping.enable ~= true then return end

	local pos = E.db.KlixUI.maps.minimap.ping.position or "TOP"
	local xOffset = E.db.KlixUI.maps.minimap.ping.xOffset or 0
	local yOffset = E.db.KlixUI.maps.minimap.ping.yOffset or 0
	
	MM.pingpanel = CreateFrame('Frame', "KUI_PingPanel", _G["Minimap"])
	MM.pingpanel:SetAllPoints()
	MM.pingpanel.text = KS:CreateFS(MM.pingpanel, 10, "", false, pos, xOffset, yOffset)

	local anim = MM.pingpanel:CreateAnimationGroup()
	anim:SetScript("OnPlay", function() MM.pingpanel:SetAlpha(1) end)
	anim:SetScript("OnFinished", function() MM.pingpanel:SetAlpha(0) end)

	anim.fader = anim:CreateAnimation("Alpha")
	anim.fader:SetFromAlpha(1)
	anim.fader:SetToAlpha(0)
	anim.fader:SetDuration(3)
	anim.fader:SetSmoothing("OUT")
	anim.fader:SetStartDelay(3)

	KUI:RegisterEvent("MINIMAP_PING", function(_, unit)
		local _, unitClass = UnitClass(unit)
		local class = ElvUF.colors.class[unitClass]
		local name = GetUnitName(unit)

		anim:Stop()
		MM.pingpanel.text:SetText(name)
		MM.pingpanel.text:SetTextColor(class[1], class[2], class[3])
		anim:Play()
	end)
end

function MM:UpdateCoords(elapsed)
	MM.coordspanel.elapsed = (MM.coordspanel.elapsed or 0) + elapsed
	if MM.coordspanel.elapsed < E.db.KlixUI.maps.minimap.coords.throttle then return end
	if E.MapInfo then
		local x, y = E.MapInfo.x, E.MapInfo.y
		if x then x = format(E.db.KlixUI.maps.minimap.coords.format, x * 100) else x = "0" end
		if y then y = format(E.db.KlixUI.maps.minimap.coords.format, y * 100) else y = "0" end
		if x == "0" or x == "0.0" or x == "0.00" then x = "-" end
		if y == "0" or y == "0.0" or y == "0.00" then y = "-" end
		MM.coordspanel.Text:SetText(x.." , "..y)
	else 
		MM.coordspanel.Text:SetText("-")
	end
	MM:CoordsSize()
	MM.coordspanel.elapsed = 0
end

function MM:CoordFont()
	MM.coordspanel.Text:SetFont(E.LSM:Fetch('font', E.db.KlixUI.maps.minimap.coords.font), E.db.KlixUI.maps.minimap.coords.fontSize, E.db.KlixUI.maps.minimap.coords.fontOutline)
end

function MM:CoordsSize()
	local size = MM.coordspanel.Text:GetStringWidth()
	if size ~= MM.coordspanel.WidthValue then
		MM.coordspanel:Size(size + 4, E.db.KlixUI.maps.minimap.coords.fontSize + 2)
		MM.coordspanel.WidthValue = size + 4
	end
end

function MM:UpdateCoordinatesPosition()
	MM.coordspanel:ClearAllPoints()
	MM.coordspanel:SetPoint(E.db.KlixUI.maps.minimap.coords.position, E.db.KlixUI.maps.minimap.coords.xOffset, E.db.KlixUI.maps.minimap.coords.yOffset, _G["Minimap"])
end

function MM:CreateCoordsFrame()
	MM.coordspanel = CreateFrame('Frame', "KUI_CoordsPanel", _G["Minimap"])
	MM.coordspanel:Point("BOTTOM", _G["Minimap"], "BOTTOM", 0, 0)
	MM.coordspanel.WidthValue = 0

	MM.coordspanel.Text = MM.coordspanel:CreateFontString(nil, "OVERLAY")
	MM.coordspanel.Text:SetPoint("CENTER", MM.coordspanel)
	MM.coordspanel.Text:SetWordWrap(false)

	_G["Minimap"]:HookScript('OnEnter', function(self)
		if E.db.KlixUI.maps.minimap.coords.display ~= 'MOUSEOVER' or not E.private.general.minimap.enable or not E.db.KlixUI.maps.minimap.coords.enable then return; end
		MM.coordspanel:Show()
	end)

	_G["Minimap"]:HookScript('OnLeave', function(self)
		if E.db.KlixUI.maps.minimap.coords.display ~= 'MOUSEOVER' or not E.private.general.minimap.enable or not E.db.KlixUI.maps.minimap.coords.enable then return; end
		MM.coordspanel:Hide()
	end)

	MM:UpdateCoordinatesPosition()
end

function MM:SetCoordsColor()
	local color = E.db.KlixUI.maps.minimap.coords.color
	MM.coordspanel.Text:SetTextColor(color.r, color.g, color.b)
end

function MM:UpdateSettings()
	if not MM.coordspanel then
		MM:CreateCoordsFrame()
	end
	MM:CoordFont()
	MM:SetCoordsColor()
	MM:CoordsSize()

	MM.coordspanel:SetPoint(E.db.KlixUI.maps.minimap.coords.position, _G["Minimap"])
	MM.coordspanel:SetScript('OnUpdate', MM.UpdateCoords)

	MM:UpdateCoordinatesPosition()
	if E.db.KlixUI.maps.minimap.coords.display ~= 'SHOW' or not E.private.general.minimap.enable or not E.db.KlixUI.maps.minimap.coords.enable then
		MM.coordspanel:Hide()
	else
		MM.coordspanel:Show()
	end
end

function MM:CreateCardinalFrame()
	local cardinals = CreateFrame("Frame", "MMD_Frame", _G["Minimap"]);
	cardinals:SetAllPoints();
	
	cardinals.n = cardinals:CreateFontString("$parentText","ARTWORK","GameFontNormal");
	cardinals.n:SetText("N")
	cardinals.n:SetPoint("CENTER", cardinals, "TOP")
	
	cardinals.e = cardinals:CreateFontString("$parentText","ARTWORK","GameFontNormal");
	cardinals.e:SetText("E")
	cardinals.e:SetPoint("CENTER", cardinals, "RIGHT")

	cardinals.s = cardinals:CreateFontString("$parentText","ARTWORK","GameFontNormal");
	cardinals.s:SetText("S")
	cardinals.s:SetPoint("CENTER", cardinals, "BOTTOM")
	
	cardinals.w = cardinals:CreateFontString("$parentText","ARTWORK","GameFontNormal");
	cardinals.w:SetText("W")
	cardinals.w:SetPoint("CENTER", cardinals, "LEFT")
end

function MM:UpdateCardinalFrame()
	if not E.db.KlixUI.maps.minimap.cardinalPoints.enable then
		MMD_Frame:Hide()
	else
		MMD_Frame:Show()
	end
	
	if not E.db.KlixUI.maps.minimap.cardinalPoints.north then
		MMD_Frame.n:Hide()
	else
		MMD_Frame.n:Show()
	end
	
	if not E.db.KlixUI.maps.minimap.cardinalPoints.east then
		MMD_Frame.e:Hide()
	else
		MMD_Frame.e:Show()
	end
	
	if not E.db.KlixUI.maps.minimap.cardinalPoints.south then
		MMD_Frame.s:Hide()
	else
		MMD_Frame.s:Show()
	end
	
	if not E.db.KlixUI.maps.minimap.cardinalPoints.west then
		MMD_Frame.w:Hide()
	else
		MMD_Frame.w:Show()
	end
end

function MM:ColorCardinalFrame()
	if E.db.KlixUI.maps.minimap.cardinalPoints.color == 1 then
		MMD_Frame.n:SetTextColor(KUI.r, KUI.g, KUI.b)
		MMD_Frame.e:SetTextColor(KUI.r, KUI.g, KUI.b)
		MMD_Frame.s:SetTextColor(KUI.r, KUI.g, KUI.b)
		MMD_Frame.w:SetTextColor(KUI.r, KUI.g, KUI.b)
	elseif E.db.KlixUI.maps.minimap.cardinalPoints.color == 2 then
		MMD_Frame.n:SetTextColor(KUI:unpackColor(E.db.KlixUI.maps.minimap.cardinalPoints.customColor))
		MMD_Frame.e:SetTextColor(KUI:unpackColor(E.db.KlixUI.maps.minimap.cardinalPoints.customColor))
		MMD_Frame.s:SetTextColor(KUI:unpackColor(E.db.KlixUI.maps.minimap.cardinalPoints.customColor))
		MMD_Frame.w:SetTextColor(KUI:unpackColor(E.db.KlixUI.maps.minimap.cardinalPoints.customColor))
	else
		MMD_Frame.n:SetTextColor(KUI:unpackColor(E.db.general.valuecolor))
		MMD_Frame.e:SetTextColor(KUI:unpackColor(E.db.general.valuecolor))
		MMD_Frame.s:SetTextColor(KUI:unpackColor(E.db.general.valuecolor))
		MMD_Frame.w:SetTextColor(KUI:unpackColor(E.db.general.valuecolor))
	end
end

function MM:FontCardinalFrame()
	MMD_Frame.n:FontTemplate(E.LSM:Fetch("font", E.db.KlixUI.maps.minimap.cardinalPoints.Font), E.db.KlixUI.maps.minimap.cardinalPoints.FontSize, E.db.KlixUI.maps.minimap.cardinalPoints.FontOutline)
	MMD_Frame.e:FontTemplate(E.LSM:Fetch("font", E.db.KlixUI.maps.minimap.cardinalPoints.Font), E.db.KlixUI.maps.minimap.cardinalPoints.FontSize, E.db.KlixUI.maps.minimap.cardinalPoints.FontOutline)
	MMD_Frame.s:FontTemplate(E.LSM:Fetch("font", E.db.KlixUI.maps.minimap.cardinalPoints.Font), E.db.KlixUI.maps.minimap.cardinalPoints.FontSize, E.db.KlixUI.maps.minimap.cardinalPoints.FontOutline)
	MMD_Frame.w:FontTemplate(E.LSM:Fetch("font", E.db.KlixUI.maps.minimap.cardinalPoints.Font), E.db.KlixUI.maps.minimap.cardinalPoints.FontSize, E.db.KlixUI.maps.minimap.cardinalPoints.FontOutline)
end

-- Hide/fade minimap in combat
local function FadeFrame(frame, direction, startAlpha, endAlpha, time, func)
	UIFrameFade(frame, {
		mode = direction,
		finishedFunc = func,
		startAlpha = startAlpha,
		endAlpha = endAlpha,
		timeToFade = time,
	})
end

local function HideMinimap()
	cluster:Hide()
end

local function FadeInMinimap()
	if not InCombatLockdown() then
		FadeFrame(cluster, "IN", 0, 1, .5, function() if not InCombatLockdown() then cluster:Show() end end)
	end
end

local function ShowMinimap()
	if E.db.KlixUI.maps.minimap.fadeindelay == 0 then
		FadeInMinimap()		
	else
		E:Delay(E.db.KlixUI.maps.minimap.fadeindelay, FadeInMinimap)
	end
end

function MM:HideMinimapRegister()
	if E.db.KlixUI.maps.minimap.hideincombat then
		M:RegisterEvent("PLAYER_REGEN_DISABLED", HideMinimap)	
		M:RegisterEvent("PLAYER_REGEN_ENABLED", ShowMinimap)
	else
		M:UnregisterEvent("PLAYER_REGEN_DISABLED")	
		M:UnregisterEvent("PLAYER_REGEN_ENABLED")
	end
end

function MM:Initialize()
	if E.private.general.minimap.enable ~= true then return end

	-- Add a check if the backdrop is there
	if not Minimap.backdrop then
		Minimap:CreateBackdrop("Default", true)
		Minimap.backdrop:SetBackdrop({
			edgeFile = E.LSM:Fetch("statusbar", "KlixGradient"), edgeSize = E:Scale(2),
			insets = {left = E:Scale(2), right = E:Scale(2), top = E:Scale(2), bottom = E:Scale(2)},
		})
	end
	
	hooksecurefunc(M, 'UpdateSettings', MM.UpdateSettings)

	MM:UpdateSettings()
	MM:ChangeMiniMapButtons()
	MM:GarrisonButtonPosition()
	MM:MiniMapPing()
	MM:HideMinimapRegister()
	if not IsAddOnLoaded("ElvUI_CompassPoints") then
		MM:CreateCardinalFrame()
		MM:UpdateCardinalFrame()
		MM:ColorCardinalFrame()
		MM:FontCardinalFrame()
	end
	
	if E.db.KlixUI.maps.minimap.blink then
		self:RegisterEvent("CALENDAR_UPDATE_PENDING_INVITES", "CheckMail")
		self:RegisterEvent("UPDATE_PENDING_MAIL", "CheckMail")
		self:RegisterEvent("PLAYER_ENTERING_WORLD", "CheckMail")
		self:HookScript(_G["MiniMapMailFrame"], "OnHide", "CheckMail")
		self:HookScript(_G["MiniMapMailFrame"], "OnShow", "CheckMail")
	end
end

KUI:RegisterModule(MM:GetName())