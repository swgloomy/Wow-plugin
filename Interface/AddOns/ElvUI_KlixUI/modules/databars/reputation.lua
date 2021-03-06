local KUI, E, L, V, P, G = unpack(select(2, ...))
local KDB = KUI:GetModule("KuiDatabars")
local EDB = E:GetModule("DataBars")

-- Cache global variables
-- Lua functions
local find, gsub, format = string.find, string.gsub, string.format
-- WoW API / Variables
local GetGuildInfo = GetGuildInfo
local GetWatchedFactionInfo = GetWatchedFactionInfo
local GetNumFactions = GetNumFactions
local GetFactionInfo = GetFactionInfo
local SetWatchedFactionIndex = SetWatchedFactionIndex
local IsFactionInactive = IsFactionInactive
-- Global variables that we don"t cache, list them here for the mikk"s Find Globals script

local incpat = gsub(gsub(FACTION_STANDING_INCREASED, "(%%s)", "(.+)"), "(%%d)", "(.+)")
local changedpat = gsub(gsub(FACTION_STANDING_CHANGED, "(%%s)", "(.+)"), "(%%d)", "(.+)")
local decpat = gsub(gsub(FACTION_STANDING_DECREASED, "(%%s)", "(.+)"), "(%%d)", "(.+)")
local standing = ('%s:'):format(STANDING)
local reputation = ('%s:'):format(REPUTATION)

-- local variables ------------------------------------------------------------
-- Blizzard's FACTION_BAR_COLORS only has 8 entries but we'll fix that
local KDB_REP_BAR_COLORS = {
    [1] = {r = 1, g = 0, b = 0, a = 1},             -- hated
    [2] = {r = 1, g = 0.55, b = 0, a = 1},          -- hostile
    [3] = {r = 1, g = 1, b = 0, a = 1},             -- unfriendly
    [4] = {r = 1, g = 1, b = 1, a = 1},             -- neutral
    [5] = {r = 0, g = 1, b = 0, a = 1},             -- friendly
    [6] = {r = 0.25,  g = 0.4,  b = 0.9, a = 1},    -- honored
    [7] = {r = 0.6, g = 0.2, b = 0.8, a = 1},       -- revered
    [8] = {r = 0.9, g = 0.8,  b = 0.5, a = 1},      -- exalted
    [9] = {r = 0.75,  g = 0.75, b = 0.75, a = 1},   -- paragon
}
local BACKUP = FACTION_BAR_COLORS[1]

-- helper function ------------------------------------------------------------
local function CheckRep(standingID, factionID, friendID, nextFriendThreshold)
    local isCapped = false
    local isParagon = C_Reputation.IsFactionParagon(factionID)

    if standingID == MAX_REPUTATION_REACTION then
        isCapped = true
    elseif isParagon then
        isCapped = false
    elseif nextFriendThreshold then
        isCapped = false
    elseif not nextFriendThreshold and friendID then
        isCapped = true
    end

    return isCapped, isParagon
end

-- local functions called via hooking -----------------------------------------
local function ReputationBar_OnEnter()
    local name, standingID, minimum, maximum, value, factionID = GetWatchedFactionInfo()
    local friendID, friendRep, friendMaxRep, friendName, friendText, friendTexture, friendTextLevel, friendThreshold, nextFriendThreshold = GetFriendshipReputation(factionID)
    local isCapped, isParagon = CheckRep(standingID, factionID, friendID, nextFriendThreshold)


    if name and E.db.KlixUI.databars.reputationBar.capped then
        if isCapped and not isParagon then
            GameTooltip:ClearLines()

            if friendID then
                GameTooltip:AddLine(friendName)
            elseif not isParagon then
                GameTooltip:AddLine(name)
            end

            GameTooltip:AddLine(" ")
            GameTooltip:AddDoubleLine(REPUTATION .. ":", L["Capped"])
            GameTooltip:Show()
        elseif isParagon then
            local replacement = L[E.db.KlixUI.databars.reputationBar.textFormat == "P" and "P" or "Paragon"]

            for line = 1, GameTooltip:NumLines() do
                local lineTextRight = _G["GameTooltipTextRight" .. line]
                local lineTextRightText = lineTextRight:GetText()
                if lineTextRightText then
                    lineTextRight:SetText(gsub(lineTextRightText, FACTION_STANDING_LABEL8, replacement))
                end
            end
            GameTooltip:Show()
        end
    end
end

local function UpdateReputation(self)
    local bar = self.repBar
    local name, standingID, minimum, maximum, value, factionID = GetWatchedFactionInfo()
    local friendID, friendRep, friendMaxRep, friendName, friendText, friendTexture, friendTextLevel, friendThreshold, nextFriendThreshold = GetFriendshipReputation(factionID)
    local isCapped, isParagon = CheckRep(standingID, factionID, friendID, nextFriendThreshold)

    if isCapped and not isParagon then
        -- don't want a blank bar at non-Paragon Exalted
        bar.statusBar:SetMinMaxValues(0, 1)
        bar.statusBar:SetValue(1)
    end

    if name then -- only do stuff if name has value
        if E.db.KlixUI.databars.reputationBar.capped then
            if isCapped and not isParagon then
                if friendID then
                    bar.text:SetText(friendName .. ": " .. L["Capped"])
                elseif not isParagon then
                    bar.text:SetText(name .. ": " .. L["Capped"])
                end
            --[[elseif isParagon then
                local replacement
				if E.db.KlixUI.databars.reputationBar.textFormat == "P" then
					replacement = L["P"]
				else
					replacement = L["Paragon"]
				end
                replacement = "[" .. replacement .. "]"
                local barText = bar.text:GetText()
                barText = gsub(barText, "%[(.+)%]", replacement)
                bar.text:SetText(barText)]]
            end
        end

        -- color the rep bar
        if E.db.KlixUI.databars.reputationBar.color == "ascii" then
            if isParagon then
                standingID = standingID + 1
            end

            local color = KDB_REP_BAR_COLORS[standingID] or BACKUP
            bar.statusBar:SetStatusBarColor(color.r, color.g, color.b)
        else
            local color = FACTION_BAR_COLORS[standingID] or BACKUP
            bar.statusBar:SetStatusBarColor(color.r, color.g, color.b)
        end

        -- blend the bar
        local avg = value / maximum
        avg = KDB:Round(avg, 2)
        if E.db.KlixUI.databars.reputationBar.progress then
            bar.statusBar:SetAlpha(avg)
        else
            bar.statusBar:SetAlpha(1)
        end
    end
end

-- Auto change reputation
function KDB:SetWatchedFactionOnReputationBar(event, msg)
	if not E.db.KlixUI.databars.reputationBar.autotrack then return end
	
	local _, _, faction, amount = find(msg, incpat)
	if not faction then _, _, faction, amount = find(msg, changedpat) or find(msg, decpat) end
	if faction then
		if faction == GUILD then
			faction = GetGuildInfo("player")
		end

		local active = GetWatchedFactionInfo()
		for factionIndex = 1, GetNumFactions() do
			local name = GetFactionInfo(factionIndex)
			if name == faction and name ~= active then
				-- check if watch has been disabled by user
				local inactive = IsFactionInactive(factionIndex) or SetWatchedFactionIndex(factionIndex)
				break
			end
		end
	end
end

function KDB:LoadWatchedFaction()
	if E.db.KlixUI.databars.reputationBar.autotrack then
		self:RegisterEvent('CHAT_MSG_COMBAT_FACTION_CHANGE', 'SetWatchedFactionOnReputationBar')
	else
		self:UnregisterEvent('CHAT_MSG_COMBAT_FACTION_CHANGE')
	end
end

-- hooking fuctions -----------------------------------------------------------
function KDB:HookRepTooltip()
    if E.db.KlixUI.databars.enable and EDB.repBar then
        if not KDB:IsHooked(_G["ElvUI_ReputationBar"], "OnEnter") then
            KDB:SecureHookScript(_G["ElvUI_ReputationBar"], "OnEnter", ReputationBar_OnEnter)
        end
    elseif not E.db.KlixUI.databars.enable or not EDB.repBar then
        if KDB:IsHooked(_G["ElvUI_ReputationBar"], "OnEnter") then
            KDB:Unhook(_G["ElvUI_ReputationBar"], "OnEnter")
        end
    end
end

function KDB:HookRepText()
    if E.db.KlixUI.databars.enable and EDB.repBar then
        if not KDB:IsHooked(EDB, "UpdateReputation") then
            KDB:SecureHook(EDB, "UpdateReputation", UpdateReputation)
        end
    elseif not E.db.KlixUI.databars.enable or not EDB.repBar then
        if KDB:IsHooked(EDB, "UpdateReputation") then
            KDB:Unhook(EDB, "UpdateReputation")
        end
        KDB:RestoreRepColors()
    end
    EDB:UpdateReputation()
end

function KDB:RestoreRepColors()
    local bar = EDB.repBar
    if bar then
        local _, standingID = GetWatchedFactionInfo()
        local color = FACTION_BAR_COLORS[standingID] or BACKUP

        bar.statusBar:SetStatusBarColor(color.r, color.g, color.b)
        bar.statusBar:SetAlpha(1)
    end
end

-- Character Reputation Colors
function KDB:UpdateFactionColors()
	E:CopyTable(FACTION_BAR_COLORS, E.db.KlixUI.betterreputationcolors);
end