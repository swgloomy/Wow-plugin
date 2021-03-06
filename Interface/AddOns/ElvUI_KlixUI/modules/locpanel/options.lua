local KUI, E, L, V, P, G = unpack(select(2, ...))
local LP = KUI:GetModule("LocPanel")
local CLASS, CUSTOM, DEFAULT = CLASS, CUSTOM, DEFAULT

--Cache global variables
local format = string.format
local tinsert = table.insert
local strsplit = strsplit
local match = string.match
local tconcat = table.concat
local tremove = table.remove
--WoW API / Variables

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: AceGUIWidgetLSMlists

local FISH_ICON = "|TInterface\\AddOns\\ElvUI_KlixUI\\media\\textures\\locationpanel\\fish.tga:14:14|t"
local PET_ICON = "|TInterface\\AddOns\\ElvUI_KlixUI\\media\\textures\\locationpanel\\pet.tga:14:14|t"
local LEVEL_ICON = "|TInterface\\AddOns\\ElvUI_KlixUI\\media\\textures\\locationpanel\\levelup.tga:14:14|t"

local function LocPanelTable()
	E.Options.args.KlixUI.args.modules.args.locPanel = {
		type = "group",
		name = LP.modName,
		order = 15,
		childGroups = "tab",
		get = function(info) return E.db.KlixUI.locPanel[ info[#info] ] end,
		args = {
			name = {
				order = 1,
				type = "header",
				name = KUI:cOption(LP.modName),
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
						name = format("|cffff7d0a MerathilisUI - Merathilis|r & |cff9482c9Shadow&Light - Darth Predator|r & ElvUI_LocPlus (by Benik)"),
					},
				},
			},
			general = {
				order = 3,
				type = "group",
				name = L["General"],
				args = {
					enable = {
						type = "toggle",
						name = L["Enable"],
						order = 1,
						set = function(info, value) E.db.KlixUI.locPanel[ info[#info] ] = value; LP:Toggle() end,
					},
					style = {
						order = 2,
						type = "toggle",
						name = L["|cfff960d9KlixUI|r Style"],
						disabled = function() return not E.db.KlixUI.locPanel.enable end,
						hidden = function() return not E.db.KlixUI.locPanel.enable end,
						set = function(info, value) E.db.KlixUI.locPanel[ info[#info] ] = value; E:StaticPopup_Show('PRIVATE_RL'); end,
					},
					space1 = {
						order = 3,
						type = "description",
						name = "",
					},
					linkcoords = {
						type = "toggle",
						name = L["Link Position"],
						desc = L["Allow pasting of your coordinates in chat editbox via holding shift and clicking on the location name."],
						order = 4,
						disabled = function() return not E.db.KlixUI.locPanel.enable end,
						hidden = function() return not E.db.KlixUI.locPanel.enable end,
						set = function(info, value) E.db.KlixUI.locPanel[ info[#info] ] = value; end,
					},
					template = {
						order = 5,
						name = L["Template"],
						type = "select",
						disabled = function() return not E.db.KlixUI.locPanel.enable end,
						hidden = function() return not E.db.KlixUI.locPanel.enable end,
						set = function(info, value) E.db.KlixUI.locPanel[ info[#info] ] = value; LP:Template() end,
						values = {
							["Default"] = DEFAULT,
							["Transparent"] = L["Transparent"],
							["NoBackdrop"] = L["NoBackdrop"],
						},
					},
					autowidth = {
						type = "toggle",
						name = L["Auto Width"],
						desc = L["Change width based on the zone name length."],
						order = 6,
						disabled = function() return not E.db.KlixUI.locPanel.enable end,
						hidden = function() return not E.db.KlixUI.locPanel.enable end,
						set = function(info, value) E.db.KlixUI.locPanel[ info[#info] ] = value; LP:Resize() end,
					},
					width = {
						order = 7,
						type = "range",
						name = L["Width"],
						min = 100, max = E.screenwidth/2, step = 1,
						disabled = function() return not E.db.KlixUI.locPanel.enable or E.db.KlixUI.locPanel.autowidth end,
						hidden = function() return not E.db.KlixUI.locPanel.enable end,
						set = function(info, value) E.db.KlixUI.locPanel[ info[#info] ] = value; LP:Resize() end,
					},
					height = {
						order = 8,
						type = "range",
						name = L["Height"],
						min = 10, max = 50, step = 1,
						disabled = function() return not E.db.KlixUI.locPanel.enable end,
						hidden = function() return not E.db.KlixUI.locPanel.enable end,
						set = function(info, value) E.db.KlixUI.locPanel[ info[#info] ] = value; LP:Resize() end,
					},
					spacing = {
						order = 9,
						type = "range",
						name = L["Spacing"],
						min = -1, max = 5, step = 1,
						disabled = function() return not E.db.KlixUI.locPanel.enable end,
						hidden = function() return not E.db.KlixUI.locPanel.enable end,
						set = function(info, value) E.db.KlixUI.locPanel[ info[#info] ] = value; LP:HideCoords() end,
					},
					throttle = {
						order = 10,
						type = "range",
						name = L["Update Throttle"],
						desc = L["The frequency of coordinates and zonetext updates. Check will be done more often with lower values."],
						min = 0.1, max = 2, step = 0.1,
						disabled = function() return not E.db.KlixUI.locPanel.enable end,
						hidden = function() return not E.db.KlixUI.locPanel.enable end,
						set = function(info, value) E.db.KlixUI.locPanel[ info[#info] ] = value; end,
					},
					combathide = {
						order = 11,
						type = "toggle",
						name = L["Hide In Combat"],
						disabled = function() return not E.db.KlixUI.locPanel.enable end,
						hidden = function() return not E.db.KlixUI.locPanel.enable end,
						set = function(info, value) E.db.KlixUI.locPanel[ info[#info] ] = value; end,
					},
					orderhallhide = {
						order = 12,
						type = "toggle",
						name = L["Hide In Orderhall"],
						disabled = function() return not E.db.KlixUI.locPanel.enable end,
						hidden = function() return not E.db.KlixUI.locPanel.enable end,
						set = function(info, value) E.db.KlixUI.locPanel[ info[#info] ] = value; LP:Toggle() end,
					},
					blizzText = {
						order = 13,
						name = L["Hide Blizzard Zone Text"],
						type = 'toggle',
						disabled = function() return not E.db.KlixUI.locPanel.enable end,
						hidden = function() return not E.db.KlixUI.locPanel.enable end,
						set = function(info, value) E.db.KlixUI.locPanel[ info[#info] ] = value; LP:ToggleBlizZoneText() end,					
					},
					mouseover = {
						order = 14,
						name = L["Mouse Over"],
						desc = L["The frame is not shown unless you mouse over the frame"],
						type = 'toggle',
						disabled = function() return not E.db.KlixUI.locPanel.enable end,
						hidden = function() return not E.db.KlixUI.locPanel.enable end,						
						set = function(info, value) E.db.KlixUI.locPanel[ info[#info] ] = value; LP:MouseOver() end,					
					},
					malpha = {
						order = 15,
						type = "range",
						name = L["Alpha"],
						desc = L["Change the alpha level of the frame."],
						min = 0, max = 1, step = 0.1,
						disabled = function() return not E.db.KlixUI.locPanel.mouseover or not E.db.KlixUI.locPanel.enable end,
						hidden = function() return not E.db.KlixUI.locPanel.enable end,	
						set = function(info, value) E.db.KlixUI.locPanel[ info[#info] ] = value; LP:MouseOver() end,
					},
					displayOther = {
						order = 16,
						name = OTHER,
						type = 'select',
						desc = L["Show additional info in the Location Panel."],
						disabled = function() return not E.db.KlixUI.locPanel.enable end,
						hidden = function() return not E.db.KlixUI.locPanel.enable end,
						set = function(info, value) E.db.KlixUI.locPanel[ info[#info] ] = value; end,
							values = {
								['NONE'] = L['None'],
								['RLEVEL'] = LEVEL_ICON.." "..LEVEL_RANGE,
								['PET'] = PET_ICON.." "..L['Battle Pet Level'],
								['PFISH'] = FISH_ICON.." "..PROFESSIONS_FISHING,
							},						
					},
					showicon = {
						order = 17,
						name = EMBLEM_SYMBOL,
						type = 'toggle',
						disabled = function() return not E.db.KlixUI.locPanel.enable or E.db.KlixUI.locPanel.displayOther == 'NONE' end,
						hidden = function() return not E.db.KlixUI.locPanel.enable end,
						set = function(info, value) E.db.KlixUI.locPanel[ info[#info] ] = value; end,						
					},
				},
			},
			location = {
				order = 20,
				type = "group",
				name = L["Location"],
				hidden = function() return not E.db.KlixUI.locPanel.enable end,
				args = {
					zoneText = {
						type = "toggle",
						name = L["Full Location"],
						order = 1,
						disabled = function() return not  E.db.KlixUI.locPanel.enable end,
						set = function(info, value) E.db.KlixUI.locPanel[ info[#info] ] = value; end,
					},
					colorType = {
						order = 2,
						name = L["Color Type"],
						type = "select",
						disabled = function() return not E.db.KlixUI.locPanel.enable end,
						set = function(info, value) E.db.KlixUI.locPanel[ info[#info] ] = value; end,
						values = {
							["REACTION"] = L["Reaction"],
							["DEFAULT"] = DEFAULT,
							["CLASS"] = CLASS,
							["CUSTOM"] = CUSTOM,
						},
					},
					customColor = {
						type = "color",
						order = 3,
						name = L["Custom Color"],
						disabled = function() return not E.db.KlixUI.locPanel.enable or not E.db.KlixUI.locPanel.colorType == "CUSTOM" end,
						get = function(info)
							local t = E.db.KlixUI.locPanel[ info[#info] ]
							local d = P.KlixUI.locPanel[info[#info]]
							return t.r, t.g, t.b, d.r, d.g, d.b
						end,
						set = function(info, r, g, b)
							E.db.KlixUI.locPanel[ info[#info] ] = {}
							local t = E.db.KlixUI.locPanel[ info[#info] ]
							t.r, t.g, t.b = r, g, b
						end,
					},
				},
			},
			coordinates = {
				order = 21,
				type = "group",
				name = L["Coordinates"],
				hidden = function() return not E.db.KlixUI.locPanel.enable end,
				args = {
					format = {
						order = 1,
						name = L["Format"],
						type = "select",
						disabled = function() return not E.db.KlixUI.locPanel.enable end,
						set = function(info, value) E.db.KlixUI.locPanel[ info[#info] ] = value; end,
						values = {
							["%.0f"] = DEFAULT,
							["%.1f"] = "45.3",
							["%.2f"] = "45.34",
						},
					},
					colorType_Coords = {
						order = 2,
						name = L["Color Type"],
						type = "select",
						disabled = function() return not E.db.KlixUI.locPanel.enable end,
						set = function(info, value) E.db.KlixUI.locPanel[ info[#info] ] = value; end,
						values = {
							["REACTION"] = L["Reaction"],
							["DEFAULT"] = DEFAULT,
							["CLASS"] = CLASS,
							["CUSTOM"] = CUSTOM,
						},
					},
					customColor_Coords = {
						type = "color",
						order = 3,
						name = L["Custom Color"],
						disabled = function() return not E.db.KlixUI.locPanel.enable or not E.db.KlixUI.locPanel.colorType_Coords == "CUSTOM" end,
						get = function(info)
							local t = E.db.KlixUI.locPanel[ info[#info] ]
							local d = P.KlixUI.locPanel[info[#info]]
							return t.r, t.g, t.b, d.r, d.g, d.b
						end,
						set = function(info, r, g, b)
							E.db.KlixUI.locPanel[ info[#info] ] = {}
							local t = E.db.KlixUI.locPanel[ info[#info] ]
							t.r, t.g, t.b = r, g, b
						end,
					},
					hidecoords = {
						order = 4,
						name = L["Hide Coords"],
						desc = L["Show/Hide the coord frames"],
						type = 'toggle',
						set = function(info, value) E.db.KlixUI.locPanel[ info[#info] ] = value; LP:HideCoords() end,					
					},
					hidecoordsInInstance = {
						order = 5,
						name = L["Hide Coords in Instance"],
						type = 'toggle',
						disabled = function() return E.db.KlixUI.locPanel.hidecoords end,
						set = function(info, value) E.db.KlixUI.locPanel[ info[#info] ] = value; LP:HideCoords() end,					
					},
				},
			},
			fontGroup = {
				order = 22,
				type = "group",
				name = L["Fonts"],
				disabled = function() return not E.db.KlixUI.locPanel.enable end,
				hidden = function() return not E.db.KlixUI.locPanel.enable end,
				get = function(info) return E.db.KlixUI.locPanel[ info[#info] ] end,
				set = function(info, value) E.db.KlixUI.locPanel[ info[#info] ] = value; LP:Fonts() end,
				args = {
					font = {
						type = "select", dialogControl = "LSM30_Font",
						order = 1,
						name = L["Font"],
						values = AceGUIWidgetLSMlists.font,
					},
					fontSize = {
						order = 2,
						name = L["Font Size"],
						type = "range",
						min = 6, max = 22, step = 1,
						set = function(info, value) E.db.KlixUI.locPanel[ info[#info] ] = value; LP:Fonts(); LP:Resize() end,
					},
					fontOutline = {
						order = 3,
						name = L["Font Outline"],
						type = "select",
						values = {
							["NONE"] = L["None"],
							["OUTLINE"] = "OUTLINE",
							["MONOCHROMEOUTLINE"] = "MONOCROMEOUTLINE",
							["THICKOUTLINE"] = "THICKOUTLINE",
						},
					},
				},
			},
			portals = {
				order = 23,
				type = "group",
				name = L["Relocation Menu"],
				disabled = function() return not E.db.KlixUI.locPanel.enable end,
				hidden = function() return not E.db.KlixUI.locPanel.enable end,
				get = function(info) return E.db.KlixUI.locPanel.portals[ info[#info] ] end,
				set = function(info, value) E.db.KlixUI.locPanel.portals[ info[#info] ] = value; end,
				args = {
					enable = {
						type = "toggle",
						name = L["Enable"],
						desc = L["Right click on the location panel will bring up a menu with available options for relocating your character (e.g. Hearthstones, Portals, etc)."],
						order = 1,
					},
					customWidth = {
						type = "toggle",
						name = L["Custom Width"],
						desc = L["By default menu's width will be equal to the location panel width. Checking this option will allow you to set own width."],
						order = 2,
						disabled = function() return not E.db.KlixUI.locPanel.portals.enable end,
					},
					customWidthValue = {
						order = 3,
						name = L["Width"],
						type = "range",
						min = 100, max = E.screenwidth, step = 1,
						disabled = function() return not E.db.KlixUI.locPanel.portals.customWidth or not E.db.KlixUI.locPanel.portals.enable or not E.db.KlixUI.locPanel.enable end,
					},
					justify = {
						order = 4,
						name = L["Justify Text"],
						type = "select",
						values = {
							["LEFT"] = L["Left"],
							["CENTER"] = L["Middle"],
							["RIGHT"] = L["Right"],
						},
						disabled = function() return not E.db.KlixUI.locPanel.portals.enable end,
					},
					cdFormat = {
						order = 5,
						name = L["CD format"],
						type = "select",
						values = {
							["DEFAULT"] = [[(10m |TInterface\FriendsFrame\StatusIcon-Away:16|t)]],
							["DEFAULT_ICONFIRST"] = [[( |TInterface\FriendsFrame\StatusIcon-Away:16|t10m)]],
						},
						disabled = function() return not E.db.KlixUI.locPanel.portals.enable end,
					},
					HSplace = {
						type = "toggle",
						order = 6,
						name = L["Hearthstone Location"],
						desc = L["Show the name on location your Heathstone is bound to."],
						disabled = function() return not E.db.KlixUI.locPanel.portals.enable end,
					},
					showHearthstones = {
						type = "toggle",
						order = 7,
						name = L["Show hearthstones"],
						desc = L["Show hearthstone type items in the list."],
						disabled = function() return not E.db.KlixUI.locPanel.portals.enable end,
					},
					hsProprity = KUI:CreateMovableButtons(22, L["Hearthstone Toys Order"], false, E.db.KlixUI.locPanel.portals, "hsPrio"),
					showToys = {
						type = "toggle",
						order = 20,
						name = L["Show Toys"],
						desc = L["Show toys in the list. This option will affect all other display options as well."],
						disabled = function() return not E.db.KlixUI.locPanel.portals.enable end,
					},
					showSpells = {
						type = "toggle",
						order = 30,
						name = L["Show spells"],
						desc = L["Show relocation spells in the list."],
						disabled = function() return not E.db.KlixUI.locPanel.portals.enable end,
					},
					showEngineer = {
						type = "toggle",
						order = 40,
						name = L["Show engineer gadgets"],
						desc = L["Show items used only by engineers when the profession is learned."],
						disabled = function() return not E.db.KlixUI.locPanel.portals.enable end,
					},
					ignoreMissingInfo = {
						type = "toggle",
						order = 50,
						name = L["Ignore missing info"],
						desc = L["KUI_LOCPANEL_IGNOREMISSINGINFO"],
						disabled = function() return not E.db.KlixUI.locPanel.portals.enable end,
					},
				},
			},
			gen_tt = {
				order = 24,
				type = "group",
				name =  L["Tooltip"],
				disabled = function() return not E.db.KlixUI.locPanel.enable end,
				hidden = function() return not E.db.KlixUI.locPanel.enable end,
				get = function(info) return E.db.KlixUI.locPanel.tooltip[ info[#info] ] end,
				set = function(info, value) E.db.KlixUI.locPanel.tooltip[ info[#info] ] = value; end,						
				args = {
					tt_grp = {
					order = 1,
					type = "group",
					name = L["Tooltip"],
					guiInline = true,
						args = {				
							tt = {
								order = 1,
								name = L["Show/Hide tooltip"],
								type = 'toggle',
							},
							ttcombathide = {
								order = 2,
								name = L["Combat Hide"],
								desc = L["Hide tooltip while in combat."],
								type = 'toggle',
								disabled = function() return not E.db.KlixUI.locPanel.tooltip.tt end,			
							},
							tthint = {
								order = 3,
								name = L["Show Hints"],
								desc = L["Enable/Disable hints on Tooltip."],
								type = 'toggle',
								disabled = function() return not E.db.KlixUI.locPanel.tooltip.tt end,			
							},
						},
					},
					tt_options = {
						order = 2,
						type = "group",
						name = SHOW,
						guiInline = true,
						args = {
							ttst = {
								order = 1,
								name = STATUS,
								desc = L["Enable/Disable status on Tooltip."],
								type = 'toggle',
								width = "full",
								disabled = function() return not E.db.KlixUI.locPanel.tooltip.tt end,			
							},
							ttlvl = {
								order = 2,
								name = LEVEL_RANGE,
								desc = L["Enable/Disable level range on Tooltip."],
								type = 'toggle',
								disabled = function() return not E.db.KlixUI.locPanel.tooltip.tt end,		
							},
							fish = {
								order = 3,
								name = L["Area Fishing level"],
								desc = L["Enable/Disable fishing level on the area."],
								type = 'toggle',
								disabled = function() return not E.db.KlixUI.locPanel.tooltip.tt end,				
							},
							petlevel = {
								order = 4,
								name = L["Battle Pet level"],
								desc = L["Enable/Disable battle pet level on the area."],
								type = 'toggle',
								disabled = function() return not E.db.KlixUI.locPanel.tooltip.tt end,				
							},
							spacer2 = {
								order = 5,
								type = "description",
								width = "full",
								name = "",
							},	
							ttreczones = {
								order = 6,
								name = L["Recommended Zones"],
								desc = L["Enable/Disable recommended zones on Tooltip."],
								type = 'toggle',
								width = "full",
								disabled = function() return not E.db.KlixUI.locPanel.tooltip.tt end,		
							},
							ttinst = {
								order = 7,
								name = L["Zone Dungeons"],
								desc = L["Enable/Disable dungeons in the zone, on Tooltip."],
								type = 'toggle',
								disabled = function() return not E.db.KlixUI.locPanel.tooltip.tt end,			
							},
							ttrecinst = {
								order = 8,
								name = L["Recommended Dungeons"],
								desc = L["Enable/Disable recommended dungeons on Tooltip."],
								type = 'toggle',
								disabled = function() return not E.db.KlixUI.locPanel.tooltip.tt end,			
							},
							ttcoords = {
								order = 9,
								name = L["with Entrance Coords"],
								desc = L["Enable/Disable the coords for area dungeons and recommended dungeon entrances, on Tooltip."],
								type = 'toggle',
								disabled = function() return not E.db.KlixUI.locPanel.tooltip.tt or not E.db.KlixUI.locPanel.tooltip.ttrecinst end,			
							},
							spacer3 = {
								order = 10,
								type = "description",
								width = "full",
								name = "",
							},	
							curr = {
								order = 11,
								name = CURRENCY,
								desc = L["Enable/Disable the currencies, on Tooltip."],
								type = 'toggle',
								width = "full",
								disabled = function() return not E.db.KlixUI.locPanel.tooltip.tt end,			
							},
							prof = {
								order = 12,
								name = TRADE_SKILLS,
								desc = L["Enable/Disable the professions, on Tooltip."],
								type = 'toggle',
								disabled = function() return not E.db.KlixUI.locPanel.tooltip.tt end,			
							},
							profcap = {
								order = 13,
								name = L["Hide capped"],
								desc = L["Hides a profession when the player reaches its highest level."],
								type = 'toggle',
								disabled = function() return not E.db.KlixUI.locPanel.tooltip.tt or not E.db.KlixUI.locPanel.tooltip.prof end,			
							},
						},
					},
					tt_filters = {
						order = 3,
						type = "group",
						name = FILTERS,
						guiInline = true,
						get = function(info) return E.db.KlixUI.locPanel.tooltip[ info[#info] ] end,
						set = function(info, value) E.db.KlixUI.locPanel.tooltip[ info[#info] ] = value; end,	
						args = {
							tthideraid = {
								order = 1,
								name = L["Hide Raid"],
								desc = L["Show/Hide raids on recommended dungeons."],
								type = 'toggle',
								disabled = function() return not E.db.KlixUI.locPanel.tooltip.tt end,
							},
							tthidepvp = {
								order = 2,
								name = L["Hide PvP"],
								desc = L["Show/Hide PvP zones, Arenas and BGs on recommended dungeons and zones."],
								type = 'toggle',
								disabled = function() return not E.db.KlixUI.locPanel.tooltip.tt end,
							},
						},
					},
				},
			},
		},
	}
end
tinsert(KUI.Config, LocPanelTable)