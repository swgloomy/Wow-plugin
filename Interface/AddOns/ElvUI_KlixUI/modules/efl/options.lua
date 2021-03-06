local KUI, E, L, V, P, G = unpack(select(2, ...))
local EFL = KUI:GetModule("EnhancedFriendsList")
local COMP = KUI:GetModule("KuiCompatibility")

--Cache global variables

--WoW API / Variables

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: AceGUIWidgetLSMlists, FONT_SIZE, FACTION_ALLIANCE, FACTION_HORDE, FACTION_STANDING_LABEL4
-- GLOBALS: FRIENDS_LIST_ONLINE, FRIENDS_LIST_OFFLINE, DEFAULT_DND_MESSAGE, DEFAULT_AFK_MESSAGE
-- GLOBALS: FriendsFrame_UpdateFriends

local function EnhancedFriendsListTable()
	E.Options.args.KlixUI.args.modules.args.efl = {
		type = "group",
		name = EFL.modName..E.NewSign,
		order = 12,
		disabled = function() return COMP.PA and _G.ProjectAzilroka.db["EnhancedFriendsList"] end,
		hidden = function() return COMP.PA and _G.ProjectAzilroka.db["EnhancedFriendsList"] end,
		get = function(info) return E.db.KlixUI.efl[ info[#info] ] end,
		set = function(info, value) E.db.KlixUI.efl[ info[#info] ] = value; end,
		args = {
			header1 = {
				type = "header",
				name = KUI:cOption(EFL.modName),
				order = 1
			},
			credits = {
				order = 2,
				type = "group",
				name = L["Credits"],
				guiInline = true,
				args = {
					tukui = {
						order = 1,
						type = "description",
						fontSize = "medium",
						name = "|cFF16C3F2Enhanced|r |cFFFFFFFFFriends List|r - |cFF16C3F2Project|r|cFFFFFFFFAzilroka|r",
					},
				},
			},
			general = {
				order = 3,
				type = "group",
				name = L["General"],
				guiInline = true,
				get = function(info) return E.db.KlixUI.efl[info[#info]] end,
				set = function(info, value) E.db.KlixUI.efl[info[#info]] = value; FriendsFrame_UpdateFriends() end, -- causes an error if the FriendsFrame isnt open
				args = {
					enable = {
						order = 1,
						type = "toggle",
						name = L["Enable"],
						get = function(info) return E.db.KlixUI.efl.enable end,
						set = function(info, value) E.db.KlixUI.efl.enable = value; E:StaticPopup_Show("PRIVATE_RL"); end,
					},
					NameFont = {
						type = "select", dialogControl = 'LSM30_Font',
						order = 2,
						name = L["Name Font"],
						values = AceGUIWidgetLSMlists.font,
						hidden = function() return not E.db.KlixUI.efl.enable end,
					},
					NameFontSize = {
						order = 3,
						name = FONT_SIZE,
						type = "range",
						min = 6, max = 22, step = 1,
						hidden = function() return not E.db.KlixUI.efl.enable end,
					},
					NameFontFlag = {
						name = L["Font Outline"],
						order = 4,
						type = "select",
						values = {
							['NONE'] = 'None',
							['OUTLINE'] = 'OUTLINE',
							['MONOCHROME'] = 'MONOCHROME',
							['MONOCHROMEOUTLINE'] = 'MONOCROMEOUTLINE',
							['THICKOUTLINE'] = 'THICKOUTLINE',
						},
						hidden = function() return not E.db.KlixUI.efl.enable end,
					},
					InfoFont = {
						type = "select", dialogControl = 'LSM30_Font',
						order = 5,
						name = L["Info Font"],
						values = AceGUIWidgetLSMlists.font,
						hidden = function() return not E.db.KlixUI.efl.enable end,
					},
					InfoFontSize = {
						order = 6,
						name = FONT_SIZE,
						type = "range",
						min = 6, max = 22, step = 1,
						hidden = function() return not E.db.KlixUI.efl.enable end,
					},
					InfoFontFlag = {
						order = 7,
						name = L["Font Outline"],
						type = "select",
						values = {
							['NONE'] = 'None',
							['OUTLINE'] = 'OUTLINE',
							['MONOCHROME'] = 'MONOCHROME',
							['MONOCHROMEOUTLINE'] = 'MONOCROMEOUTLINE',
							['THICKOUTLINE'] = 'THICKOUTLINE',
						},
						hidden = function() return not E.db.KlixUI.efl.enable end,
					},
					GameIconPack = {
						name = L["Game Icon Pack"],
						order = 8,
						type = "select",
						values = {
							['Default'] = 'Default',
							['BlizzardChat'] = 'Blizzard Chat',
							['Flat'] = 'Flat Style',
							['Gloss'] = 'Glossy',
							['Launcher'] = 'Launcher'
						},
						hidden = function() return not E.db.KlixUI.efl.enable end,
					},
					StatusIconPack = {
						name = L["Status Icon Pack"],
						order = 9,
						type = "select",
						values = {
							['Default'] = 'Default',
							['Square'] = 'Square',
							['D3'] = 'Diablo 3',
						},
						hidden = function() return not E.db.KlixUI.efl.enable end,
					},
				},
			},
			GameIcons = {
				order = 4,
				type = "group",
				name = L["Game Icon Preview"],
				guiInline = true,
				get = function(info) return E.db.KlixUI.efl[info[#info]] end,
				set = function(info, value) E.db.KlixUI.efl[info[#info]] = value; FriendsFrame_UpdateFriends() end,
				args = {
					Alliance = {
						order = 1,
						type = "execute",
						name = FACTION_ALLIANCE,
						func = function() return end,
						image = function(info) return EFL.GameIcons[E.db.KlixUI.efl["GameIconPack"]][info[#info]], 32, 32 end,
					},
					Horde = {
						order = 2,
						type = "execute",
						name = FACTION_HORDE,
						func = function() return end,
						image = function(info) return EFL.GameIcons[E.db.KlixUI.efl["GameIconPack"]][info[#info]], 32, 32 end,
					},
					Neutral = {
						order = 3,
						type = "execute",
						name = FACTION_STANDING_LABEL4, --Neutral
						func = function() return end,
						image = function(info) return EFL.GameIcons[E.db.KlixUI.efl["GameIconPack"]][info[#info]], 32, 32 end,
					},
					D3 = {
						order = 4,
						type = "execute",
						name = L["Diablo 3"],
						func = function() return end,
						image = function(info) return EFL.GameIcons[E.db.KlixUI.efl["GameIconPack"]][info[#info]], 32, 32 end,
					},
					WTCG = {
						order = 5,
						type = "execute",
						name = L["Hearthstone"],
						func = function() return end,
						image = function(info) return EFL.GameIcons[E.db.KlixUI.efl["GameIconPack"]][info[#info]], 32, 32 end,
					},
					S1 = {
						order = 6,
						type = "execute",
						name = L["Starcraft"],
						func = function() return end,
						image = function(info) return EFL.GameIcons[E.db.KlixUI.efl["GameIconPack"]][info[#info]], 32, 32 end,
					},
					S2 = {
						order = 6,
						type = "execute",
						name = L["Starcraft 2"],
						func = function() return end,
						image = function(info) return EFL.GameIcons[E.db.KlixUI.efl["GameIconPack"]][info[#info]], 32, 32 end,
					},
					App = {
						order = 7,
						type = "execute",
						name = L["App"],
						func = function() return end,
						image = function(info) return EFL.GameIcons[E.db.KlixUI.efl["GameIconPack"]][info[#info]], 32, 32 end,
					},
					BSAp = {
						order = 8,
						type = "execute",
						name = L["Mobile"],
						func = function() return end,
						image = function(info) return EFL.GameIcons[E.db.KlixUI.efl["GameIconPack"]][info[#info]], 32, 32 end,
					},
					Hero = {
						order = 9,
						type = "execute",
						name = L["Hero of the Storm"],
						func = function() return end,
						image = function(info) return EFL.GameIcons[E.db.KlixUI.efl["GameIconPack"]][info[#info]], 32, 32 end,
					},
					Pro = {
						order = 10,
						type = "execute",
						name = L["Overwatch"],
						func = function() return end,
						image = function(info) return EFL.GameIcons[E.db.KlixUI.efl["GameIconPack"]][info[#info]], 32, 32 end,
					},
					DST2 = {
						order = 11,
						type = "execute",
						name = L["Destiny 2"],
						func = function() return end,
						image = function(info) return EFL.GameIcons[E.db.KlixUI.efl["GameIconPack"]][info[#info]], 32, 32 end,
					},
					VIPR = {
						order = 11,
						type = "execute",
						name = L["Call of Duty 4"],
						func = function() return end,
						image = function(info) return EFL.GameIcons[E.db.KlixUI.efl["GameIconPack"]][info[#info]], 32, 32 end,
					},
				},
			},
			StatusIcons = {
				order = 5,
				type = "group",
				name = L["Status Icon Preview"],
				guiInline = true,
				get = function(info) return E.db.KlixUI.efl[info[#info]] end,
				set = function(info, value) E.db.KlixUI.efl[info[#info]] = value; FriendsFrame_UpdateFriends() end,
				args = {
					Online = {
						order = 1,
						type = "execute",
						name = FRIENDS_LIST_ONLINE,
						func = function() return end,
						image = function(info) return EFL.StatusIcons[E.db.KlixUI.efl["StatusIconPack"]][info[#info]], 16, 16 end,
					},
					Offline = {
						order = 2,
						type = "execute",
						name = FRIENDS_LIST_OFFLINE,
						func = function() return end,
						image = function(info) return EFL.StatusIcons[E.db.KlixUI.efl["StatusIconPack"]][info[#info]], 16, 16 end,
					},
					DND = {
						order = 3,
						type = "execute",
						name = DEFAULT_DND_MESSAGE,
						func = function() return end,
						image = function(info) return EFL.StatusIcons[E.db.KlixUI.efl["StatusIconPack"]][info[#info]], 16, 16 end,
					},
					AFK = {
						order = 4,
						type = "execute",
						name = DEFAULT_AFK_MESSAGE,
						func = function() return end,
						image = function(info) return EFL.StatusIcons[E.db.KlixUI.efl["StatusIconPack"]][info[#info]], 16, 16 end,
					},
				},
			},
		},
	}
end
tinsert(KUI.Config, EnhancedFriendsListTable)