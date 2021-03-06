local KUI, E, L, V, P, G = unpack(select(2, ...))
local KDB = KUI:NewModule('KuiDatabars', 'AceHook-3.0', 'AceEvent-3.0');
local LSM = LibStub('LibSharedMedia-3.0');
KDB.modName = L["DataBars"]

--Cache global variables
local _G = _G
--WoW API / Variables
local C_Timer_After = C_Timer.After
--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

function KDB:StyleBackdrops()
	local db = E.db.KlixUI.databars
	
	if E.db.KlixUI.general.style then
		if db.style then
			-- Artifact
			local artifact = _G["ElvUI_ArtifactBar"]
			if artifact then
				artifact.statusBar:Styling()
			end
			
			--Azerite
			local azerite = _G["ElvUI_AzeriteBar"]
			if azerite then
				azerite.statusBar:Styling()
			end
			
			-- Experience
			local experience = _G["ElvUI_ExperienceBar"]
			if experience then
				experience.statusBar:Styling()
			end
			
			-- Honor
			local honor = _G["ElvUI_HonorBar"]
			if honor then
				honor.statusBar:Styling()
			end
			
			-- Reputation
			local reputation = _G["ElvUI_ReputationBar"]
			if reputation then
				reputation.statusBar:Styling()
			end
		end
	end
end

function KDB:EnableDisable()
    -- these functions have both enable/disable checks
    KDB:HookXPText()
    KDB:HookXPTooltip()
    KDB:HookRepText()
    KDB:HookRepTooltip()
    KDB:HookHonorBar()
    KDB:HookAzeriteBar()

    if not E.db.KlixUI.databars.enable or IsAddOnLoaded("ElvUI_ProgressiveDataBarsColors") then
        KDB:UnhookAll() -- make sure no hooks are left behind
    end
end

function KDB:Round(num, idp)
    if num <= 0.1 then
        return 0.1
    end
    local mult = 10^(idp or 0)
    return math.floor(num * mult + 0.5) / mult
end

function KDB:Initialize()
	C_Timer_After(1, KDB.StyleBackdrops)
	
	KDB:EnableDisable()
	KDB:LoadWatchedFaction()
	KDB:UpdateFactionColors()
end

local function InitializeCallback()
	KDB:Initialize()
end

KUI:RegisterModule(KDB:GetName(), InitializeCallback)