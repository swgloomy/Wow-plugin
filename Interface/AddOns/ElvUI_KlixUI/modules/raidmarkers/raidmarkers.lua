--Credits: Shadow&Light and Merathilis
local KUI, E, L, V, P, G = unpack(select(2, ...))
local RMA = KUI:NewModule("RaidMarkers", "AceHook-3.0", "AceEvent-3.0")
RMA.modName = L["Raid Markers"]

-- Cache global variables
-- Lua functions
local _G = _G
local ipairs = ipairs
local format = string.format
-- WoW API / Variables
local GameTooltip = GameTooltip
local RegisterStateDriver = RegisterStateDriver
local UnregisterStateDriver = UnregisterStateDriver

--GLOBALS: CreateFrame

RMA.VisibilityStates = {
	["DEFAULT"] = "[noexists, nogroup] hide; show",
	["INPARTY"] = "[group] show; [petbattle] hide; hide",
	["ALWAYS"] = "[petbattle] hide; show",
}

local layouts = {
	[1] = {RT = 1, WM = 5}, -- Star
	[2] = {RT = 2, WM = 6}, -- Circle
	[3] = {RT = 3, WM = 3}, -- Diamond
	[4] = {RT = 4, WM = 2}, -- Triangle
	[5] = {RT = 5, WM = 7}, -- Moon
	[6] = {RT = 6, WM = 1}, -- Square
	[7] = {RT = 7, WM = 4}, -- Cross
	[8] = {RT = 8, WM = 8}, -- Skull
	[9] = {RT = 0, WM = 0}, -- clear target/worldmarker
}

function RMA:Make(name, command, description)
	_G["BINDING_NAME_CLICK "..name..":LeftButton"] = description
	local btn = CreateFrame("Button", name, nil, "SecureActionButtonTemplate")
	btn:SetAttribute("type", "macro")
	btn:SetAttribute("macrotext", command)
	btn:RegisterForClicks("AnyDown")
end

function RMA:Bar_OnEnter()
	RMA.frame:SetAlpha(1)
end

function RMA:Bar_OnLeave()
	if RMA.db.mouseover then RMA.frame:SetAlpha(0) end
end

function RMA:CreateButtons()
	for k, layout in ipairs(layouts) do
		local button = CreateFrame("Button", format("KUI_RaidMarkerBarButton%d", k), RMA.frame, "SecureActionButtonTemplate")
		button:SetHeight(RMA.db.buttonSize)
		button:SetWidth(RMA.db.buttonSize)
		button:SetTemplate('Transparent')
		button:Styling()

		local image = button:CreateTexture(nil, "ARTWORK")
		image:SetAllPoints()
		if RMA.db.raidicons == "Classic" then
			image:SetTexture(k == 9 and "Interface\\BUTTONS\\UI-GroupLoot-Pass-Up" or format("Interface\\TargetingFrame\\UI-RaidTargetingIcon_%d", k))
		elseif RMA.db.raidicons == "Anime" then
			image:SetTexture(k == 9 and "Interface\\BUTTONS\\UI-GroupLoot-Pass-Up" or format("Interface\\Addons\\ElvUI_KlixUI\\media\\textures\\raidmarkers\\anime\\UI-RaidTargetingIcon_%d", k))
		elseif RMA.db.raidicons == "Aurora" then
			image:SetTexture(k == 9 and "Interface\\BUTTONS\\UI-GroupLoot-Pass-Up" or format("Interface\\Addons\\ElvUI_KlixUI\\media\\textures\\raidmarkers\\aurora\\UI-RaidTargetingIcon_%d", k))
		elseif RMA.db.raidicons == "Myth" then
			image:SetTexture(k == 9 and "Interface\\BUTTONS\\UI-GroupLoot-Pass-Up" or format("Interface\\Addons\\ElvUI_KlixUI\\media\\textures\\raidmarkers\\myth\\UI-RaidTargetingIcon_%d", k))
		end

		local target, worldmarker = layout.RT, layout.WM

		if target then
			button:SetAttribute("type1", "macro")
			button:SetAttribute("macrotext1", format("/tm %d", k == 9 and 0 or k))
		end

		button:RegisterForClicks("AnyDown")
		self.frame.buttons[k] = button
	end
end

function RMA:UpdateWorldMarkersAndTooltips()
	for i = 1, 9 do
		local target, worldmarker = layouts[i].RT, layouts[i].WM
		local button = self.frame.buttons[i]

		if target and not worldmarker then
			button:SetScript("OnEnter", function(self)
				self:SetBackdropBorderColor(.7, .7, 0)
				if RMA.db.notooltip then return end
				GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
				GameTooltip:SetText(L["Raid Markers"])
				GameTooltip:AddLine(i == 9 and L["Click to clear the mark."] or L["Click to mark the target."], 1, 1, 1)
				GameTooltip:Show()
			end)
		else
			local modifier = RMA.db.modifier or "shift-"
			button:SetAttribute(format("%stype1", modifier), "macro")
			button.modifier = modifier
			button:SetAttribute(format("%smacrotext1", modifier), worldmarker == 0 and "/cwm all" or format("/cwm %d\n/wm %d", worldmarker, worldmarker))

			button:SetScript("OnEnter", function(self)
				self:SetBackdropBorderColor(.7, .7, 0)
				if RMA.db.notooltip then return end
				GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
				GameTooltip:SetText(L["Raid Markers"])
				GameTooltip:AddLine(i == 9 and format("%s\n%s", L["Click to clear the mark."], format(L["%sClick to remove all worldmarkers."], button.modifier:upper()))
					or format("%s\n%s", L["Click to mark the target."], format(L["%sClick to place a worldmarker."], button.modifier:upper())), 1, 1, 1)
				GameTooltip:Show()
				RMA.frame:SetAlpha(1)
			end)
		end

		button:SetScript("OnLeave", function(self)
			self:SetBackdropBorderColor(0, 0, 0)
			GameTooltip:Hide()
			if RMA.db.mouseover then
				RMA.frame:SetAlpha(0)
			end
		end)
	end
end

function RMA:UpdateBar(update)
	local height, width

	if RMA.db.orientation == "VERTICAL" then
		width = RMA.db.buttonSize + 4
		height = (RMA.db.buttonSize * 9) + (RMA.db.spacing * 8) + 4
	else
		width = (RMA.db.buttonSize * 9) + (RMA.db.spacing * 8) + 4
		height = RMA.db.buttonSize + 4
	end

	self.frame:SetWidth(width)
	self.frame:SetHeight(height)
	local head, tail
	for i = 9, 1, -1 do
		local button = self.frame.buttons[i]
		local prev = self.frame.buttons[i + 1]
		button:ClearAllPoints()

		button:SetWidth(RMA.db.buttonSize)
		button:SetHeight(RMA.db.buttonSize)
		
		if RMA.db.orientation == "VERTICAL" then
			head = RMA.db.reverse and "BOTTOM" or "TOP"
			tail = RMA.db.reverse and "TOP" or "BOTTOM"
			if i == 9 then
				button:SetPoint(head, 0, (RMA.db.reverse and 2 or -2))
			else
				button:SetPoint(head, prev, tail, 0, RMA.db.spacing*(RMA.db.reverse and 1 or -1))
			end
		else
			head = RMA.db.reverse and "RIGHT" or "LEFT"
			tail = RMA.db.reverse and "LEFT" or "RIGHT"
			if i == 9 then
				button:SetPoint(head, (RMA.db.reverse and -2 or 2), 0)
			else
				button:SetPoint(head, prev, tail, RMA.db.spacing*(RMA.db.reverse and -1 or 1), 0)
			end
		end
	end

	if RMA.db.enable then self.frame:Show() else self.frame:Hide() end
end

function RMA:Visibility()
	if RMA.db.enable then
		RegisterStateDriver(self.frame, "visibility", RMA.db.visibility == 'CUSTOM' and RMA.db.customVisibility or RMA.VisibilityStates[RMA.db.visibility])
		E:EnableMover(self.frame.mover:GetName())
	else
		UnregisterStateDriver(self.frame, "visibility")
		self.frame:Hide()
		E:DisableMover(self.frame.mover:GetName())
	end
end

function RMA:UpdateMouseover()
	RMA:Bar_OnEnter()
	RMA:Bar_OnLeave()
end

function RMA:Backdrop()
	if RMA.db.backdrop then
		self.frame.backdrop:Show()
		self.frame.backdrop:Styling()
	else
		self.frame.backdrop:Hide()
	end
end

function RMA:AutoMark()
	if KUI._Compatibility["DejaAutoMark"] or not RMA.db.automark then return end
	if IsInRaid() then 
		return
	elseif IsInGroup() then
		local ROLEMARKS={["TANK"]=RMA.db.tankMark,["HEALER"]=RMA.db.healerMark}
		for i=1,5 do 
			local role=UnitGroupRolesAssigned("party"..i)
			if ROLEMARKS[role]then 
				SetRaidTarget("party"..i,ROLEMARKS[role])
				--print(i, role)
			end 
		end
		local currentSpecID, currentSpecName = GetSpecializationInfo(GetSpecialization())
		--print("Your current spec:", currentSpecName)
		--print("Your current spec ID:", currentSpecID)
		local roleToken = GetSpecializationRoleByID(currentSpecID)
		--print(roleToken)
		if ROLEMARKS[roleToken]then 
			SetRaidTarget("player", ROLEMARKS[roleToken])
		end
	else
		SetRaidTarget("player", 0)
	end
end

function RMA:GROUP_ROSTER_UPDATE()
	RMA:AutoMark()
end

function RMA:INSPECT_READY()
	RMA:AutoMark()
end

function RMA:Initialize()
	RMA.db = E.db.KlixUI.raidmarkers

	RMA:Make("Kui_RaidFlare1", "/clearworldmarker 1\n/worldmarker 1", "Blue Flare")
	RMA:Make("Kui_RaidFlare2", "/clearworldmarker 2\n/worldmarker 2", "Green Flare")
	RMA:Make("Kui_RaidFlare3", "/clearworldmarker 3\n/worldmarker 3", "Purple Flare")
	RMA:Make("Kui_RaidFlare4", "/clearworldmarker 4\n/worldmarker 4", "Red Flare")
	RMA:Make("Kui_RaidFlare5", "/clearworldmarker 5\n/worldmarker 5", "Yellow Flare")
	RMA:Make("Kui_RaidFlare6", "/clearworldmarker 6\n/worldmarker 6", "Orange Flare")
	RMA:Make("Kui_RaidFlare7", "/clearworldmarker 7\n/worldmarker 7", "White Flare")
	RMA:Make("Kui_RaidFlare8", "/clearworldmarker 8\n/worldmarker 8", "Skull Flare")

	RMA:Make("Kui_ClearRaidFlares", "/clearworldmarker 0", "Clear All Flares")

	RMA:RegisterEvent("GROUP_ROSTER_UPDATE")
    RMA:RegisterEvent("INSPECT_READY")
	
	self.frame = CreateFrame("Frame", KUI.Title.."RaidMarkerBar", E.UIParent, "SecureHandlerStateTemplate")
	self.frame:SetResizable(false)
	self.frame:SetClampedToScreen(true)
	self.frame:SetFrameStrata('LOW')
	self.frame:CreateBackdrop('Transparent')
	self.frame:ClearAllPoints()
	self.frame:Point("BOTTOMRIGHT", E.UIParent, "BOTTOMRIGHT", -10, 194)
	self.frame.buttons = {}
	
	self:HookScript(self.frame, 'OnEnter', 'Bar_OnEnter');
	self:HookScript(self.frame, 'OnLeave', 'Bar_OnLeave');

	self.frame.backdrop:SetAllPoints()

	E:CreateMover(self.frame, "Kui_RaidMarkerBarAnchor", L["Raid Marker Bar"], nil, nil, nil, "ALL,PARTY,RAID,KLIXUI", nil, "KlixUI,modules,raidmarkers")

	self:CreateButtons()

	function RMA:ForUpdateAll()
		RMA.db = E.db.KlixUI.raidmarkers
		self:Visibility()
		self:Backdrop()
		self:UpdateBar()
		self:UpdateWorldMarkersAndTooltips()
		self:UpdateMouseover()
		self:AutoMark()
	end

	self:ForUpdateAll()
end

KUI:RegisterModule(RMA:GetName())