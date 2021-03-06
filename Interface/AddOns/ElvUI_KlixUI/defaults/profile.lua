local KUI, E, L, V, P, G = unpack(select(2, ...))

if P["KlixUI"] == nil then P["KlixUI"] = {} end

--Create a unique table for our plugin
P['KlixUI'] = {
	-- General
    ["general"] = {
        ["loginMessage"] = true,
		["GameMenuScreen"] = true, -- Enable the Styles GameMenu
		["AFK"] = true,
		['splashScreen'] = true,
		["Movertransparancy"] = .75,
		["style"] = true, -- Styling function
		["shadowOverlay"] = true, -- Screen overlay
    },
	
	-- ActionBars
	['actionbars'] = {
		['transparent'] = true,
		['cleanButton'] = false,
		["SEBar"] = {
			["enable"] = true,
			["mouseover"] = false,
			["malpha"] = 1,
			["hideInCombat"] = false,
			["hideInOrderHall"] = false,
		},
		["glow"] = {
			["enable"] = true,
			["color"] = {r = 0.95, g = 0.95, b = 0.32, a = 1},
			["number"] = 8,
			["frequency"] = 0.45,
			["lenght"] = 8,
			["thickness"] = 2,
			["xOffset"] = 0,
			["yOffset"] = 0,
		},
	},
	
	-- AddonPanel
	["addonpanel"] = {
		["Enable"] = true,
		["NumAddOns"] = 30,
		['FrameWidth'] = 550,
		['Font'] = "Expressway",
		['FontSize'] = 12,
		['FontFlag'] = "OUTLINE",
		['ButtonHeight'] = 15,
		['ButtonWidth'] = 15,
		['CheckColor'] = {249/255, 96/255, 217/255},
		['ClassColor'] = true,
		['CheckTexture'] = "Klix",
		['FontColor'] = 2,
		['FontCustomColor'] = {r = 1, g = 1, b = 1},
	},
	
	-- Armory
	["armory"] = {
		["enable"] = true,
		["azeritebtn"] = true,
		["naked"] = true,
		["durability"] = {
			["enable"] = true,
			["onlydamaged"] = false,
			["font"] = "Expressway",
			["textSize"] = 12,
			["fontOutline"] = "OUTLINE",
		},
		["ilvl"] = {
			["enable"] = true,
			["font"] = "Expressway",
			["textSize"] = 12,
			["fontOutline"] = "OUTLINE",
			["colorStyle"] = "RARITY",
			["color"] = {r = 1, g = 1, b = 0},
		},
		["stats"] = {
			["IlvlFull"] = true,
			["IlvlColor"] = false,
			["AverageColor"] = {r = 0, g = 1, b = .59},
			["OnlyPrimary"] = true,
			["ItemLevel"] = {
				["font"] = "Expressway",
				["size"] = 20,
				["outline"] = "OUTLINE",
			},
			["statFonts"] = {
				["font"] = "Expressway",
				["size"] = 12,
				["outline"] = "OUTLINE",
			},
			["catFonts"] = {
				["font"] = "Expressway",
				["size"] = 12,
				["outline"] = "OUTLINE",
			},
			["List"] = {
				["HEALTH"] = false,
				["POWER"] = false,
				["ALTERNATEMANA"] = false,
				["ATTACK_DAMAGE"] = false,
				["ATTACK_AP"] = false,
				["ATTACK_ATTACKSPEED"] = false,
				["SPELLPOWER"] = false,
				["ENERGY_REGEN"] = false,
				["RUNE_REGEN"] = false,
				["FOCUS_REGEN"] = false,
				["MOVESPEED"] = false,
			},
		},
	},
	
	-- Better Reputation Colors
	["betterreputationcolors"] = {
		[1] = {r = 0.63, g = 0, b = 0},
		[2] = {r = 0.63, g = 0, b = 0},
		[3] = {r = 0.63, g = 0, b = 0},
		[4] = {r = 0.82, g = 0.67, b = 0},
		[5] = {r = 0.32, g = 0.67, b = 0},
		[6] = {r = 0.32, g = 0.67, b = 0},
		[7] = {r = 0.32, g = 0.67, b = 0},
		[8] = {r = 0, g = 0.75, b = 0.44},
	},
	
	-- Chat
	["chat"] = {
		["voicemenu"] = true,
		["socialbutton"] = true,
		["panelHeight"] = 162, -- Expand function
		["select"] = false,
		["styleTab"] = "SQUARE",
		["colorTab"] = {r = 0.97647058823529, g = 0.37647058823529, b = 0.85098039215686},
		['fadeChatTabs'] = false,
		['fadedChatTabAlpha'] = 0.5,
		['forceShow'] = false,
		['forceShowBelowAlpha'] = 0.1,
		['forceShowToAlpha'] = 1,
		['chatTabSeparator'] = 'HIDEBOTH',
		['chatDataSeparator']= 'HIDEBOTH',
	},
	
	-- CoolDown Flash
	["cooldownFlash"] = {
		["enable"] = false,
		["fadeInTime"] = 0.3,
		["fadeOutTime"] = 0.6,
		["maxAlpha"] = 0.8,
		["animScale"] = 1.5,
		["iconSize"] = 50,
		["holdTime"] = 0.3,
		["enablePet"] = false,
		["showSpellName"] = false,
		["x"] = UIParent:GetWidth()/2,
		["y"] = UIParent:GetHeight()/2,
	},
	
	-- DataBars
	["databars"] = {
		["enable"] = true,
		["style"] = true,
		["experienceBar"] = {
			["capped"] = true,
			["progress"] = true,
			["xpColor"] = {r = 0, g = 0.4, b = 1, a = 0.8},
			["restColor"] = {r = 1, g = 0, b = 1, a = 0.2},
		},
		["reputationBar"] = {
			["capped"] = true,
			["progress"] = true,
			["color"] = "ascii",
			--["textFormat"] = "Paragon",
			["autotrack"] = true,
		},
		["honorBar"] = {
			["progress"] = true,
			["color"] = {r = 240/255, g = 114/255, b = 65/255},
		},
		["azeriteBar"] = {
			["progress"] = true,
			["color"] = {r = 0.901, g = 0.8, b = 0.601},
		},
	},
	
	-- DataTexts
	['datatexts'] = {
		["timeSize"] = 1.8,
		['chat'] = {
			['enable'] = true,
			['transparent'] = true,
			['editBoxPosition'] = 'BELOW_CHAT',
			['backdrop'] = true,
			['style'] = true,
			['strata'] = "BACKGROUND"
		},
		['middle'] = {
			['enable'] = true,
			['transparent'] = true,
			['backdrop'] = true,
			['style'] = true,
			['width'] = 371,
			['height'] = 22,
			['strata'] = "BACKGROUND"
		},
		['colors'] = {
			['customColor'] = 2,
			['userColor'] = { r = 1, g = 1, b = 1 },
		},
		--["panels"] = {
			--["KuiLeftChatDTPanel"] = {
				--["left"] = "Spec Switch (KUI)",
				--["middle"] = "Item Level (KUI)",
				--["right"] = "Classhall (KUI)",
			--},
			--["KuiRightChatDTPanel"] = {
				--["left"] = "System (KUI)",
				--["middle"] = "Bags",
				--["right"] = "Gold",
			--},
			--["Left_ChatTab_Panel"] = {
				--["left"] = "",
				--["middle"] = "",
				--["right"] = "Mail (KUI)",
			--},
			--["Right_ChatTab_Panel"] = {
				--["left"] = "",
				--["middle"] = "",
				--["right"] = "Mail (KUI)",
			--},
		--},
		["leftChatTabDatatextPanel"] = {
			["enable"] = false,
		},
		["rightChatTabDatatextPanel"] = {
			["enable"] = false,
		},
	},
	
	-- DataTexts Continued
	["currencyDT"] = {
		["Archaeology"] = false,
		--["Jewelcrafting"] = false,
		["PvP"] = true,
		["Raid"] = true,
		--["Cooking"] = false,
		["Miscellaneous"] = true,
		["BFA"] = true,
		["LEGION"] = false,
		["WOD"] = false,
		["MOP"] = false,
		["CATA"] = false,
		["WOLK"] = false,
		["WoWToken"] = true,
		["Zero"] = true,
		["Icons"] = true,
		["Faction"] = true,
		["Unused"] = true,
		["gold"] = {
			["direction"] = "normal",
			["method"] = "name",
		},
		["cur"] = {
			["direction"] = "normal",
			["method"] = "name",
		},
	},
	["systemDT"] = {
		["maxAddons"] = 25, -- Sets how many Addons to show
		["showFPS"] = true, -- Show Frames per seconds
		["showMS"] = true, -- Show Ping
		["latency"] = "home", -- Set the latency type ("home", "world")
		["showMemory"] = false, -- Show Memory usage
		["announceFreed"] = true, -- Enable the Garbage Message in Chat
	},
	
	["titlesDT"] = {
		["useName"] = true,
	},
	
	-- Enhanced Friends List
	["efl"] = {
		["enable"] = true,
		["NameFont"] = "Expressway",
		["NameFontSize"] = 11,
		["NameFontFlag"] = "OUTLINE",
		["InfoFont"] = "Expressway",
		["InfoFontSize"] = 10,
		["InfoFontFlag"] = "OUTLINE",
		["GameIconPack"] = "Launcher",
		["StatusIconPack"] = "D3",
	},
	
	-- GameMenu (chat)
	['gamemenu'] = { 
		['color'] = 2,
		['customColor'] = {r = .9, g = .7, b = 0},
	},
	
	-- LocationPanel
	["locPanel"] = {
		["enable"] = false,
		["style"] = true,
		["autowidth"] = false,
		["width"] = 258,
		["height"] = 21,
		["spacing"] = -1,
		["linkcoords"] = true,
		["template"] = "Transparent",
		["blizzText"] = true,
		["font"] = "Expressway",
		["fontSize"] = 11,
		["fontOutline"] = "OUTLINE",
		["throttle"] = 0.2,
		["format"] = "%.0f",
		["zoneText"] = true,
		["colorType"] = "REACTION",
		["colorType_Coords"] = "DEFAULT",
		["customColor"] = {r = 1, g = 1, b = 1 },
		["customColor_Coords"] = {r = 1, g = 1, b = 1 },
		["combathide"] = false,
		["orderhallhide"] = false,
		["hidecoords"] = false,
		["hidecoordsInInstance"] = true,
		["mouseover"] = false,
		["malpha"] = 1,
		["displayOther"] = "RLEVEL",
		["showicon"] = true,
		["showEngineer"] = true,
		["dtshow"] = true,
		["portals"] = {
			["enable"] = true,
			["HSplace"] = true,
			["customWidth"] = false,
			["customWidthValue"] = 200,
			["justify"] = "LEFT",
			["cdFormat"] = "DEFAULT",
			["ignoreMissingInfo"] = false,
			["showHearthstones"] = true,
			["hsPrio"] = "54452,64488,93672,142542,162973,163045,165669,165670",
			["showToys"] = true,
			["showSpells"] = true,
			["showEngineer"] = true,
		},
		["tooltip"] = {
			['tt'] = true,
			['ttcombathide'] = true,
			['tthint'] = true,
			['ttst'] = true,
			['ttlvl'] = true,
			['fish'] = true,
			['petlevel'] = true,
			['ttinst'] = true,
			['ttreczones'] = true,
			['ttrecinst'] = true,
			['ttcoords'] = true,
			['curr'] = true,
			['prof'] = true,
			['profcap'] = false,
			['tthideraid'] = false,
			['tthidepvp'] = false,
		},
	},
	
	-- Loot
	["loot"] = {
		["bonusFilter"] = {
			[14] = {
				["*"] = false,
			},
			[15] = {
				["*"] = false,
			},
			[16] = {
				["*"] = false,
			},
			[17] = {
				["*"] = false,
			},
			[23] = false,
			[8] = false,
			["disableKeystoneLevelToggle"] = false,
			["disableKeystoneLevel"] = 0,
		},
	},
	
	-- Maps
	["maps"] = {
		["minimap"] = {
			["styleButton"] = true,
			["blink"] = false,
			["hideincombat"] = false,
			["fadeindelay"] = 5,
			["topbar"] = {
				["locationdigits"] = 1,
				["locationtext"] = "VERSION",
			},
			["mail"] = {
				["enhanced"] = true,
				["sound"] = true,
				["hide"] = false,
			},
			["buttons"] = {
				["enable"] = true,
				["barMouseOver"] = false,
				["backdrop"] = true,
				["hideInCombat"] = false,
				["iconSize"] = 20,
				["buttonsPerRow"] = 6,
				["buttonSpacing"] = 2,
				["visibility"] = "[petbattle] hide; show",
				["moveTracker"] = false,
				["moveQueue"] = false,
				["moveMail"] = false,
				["hideGarrison"] = false,
				["moveGarrison"] = false,
			},
			["ping"] = {
				["enable"] = true,
				["position"] = "TOP",
				["xOffset"] = 0,
				["yOffset"] = -20,
			},
			["coords"] = {
				["enable"] = false,
				["display"] = "SHOW",
				["position"] = "BOTTOM",
				["xOffset"] = 0,
				["yOffset"] = 20,
				["format"] = "%.0f",
				["font"] = "Expressway",
				["fontSize"] = 12,
				["fontOutline"] = "OUTLINE",
				["throttle"] = 0.2,
				["color"] = {r = 1,g = 1,b = 1},
			},
			["cardinalPoints"] = {
				["enable"] = true,
				["north"] = true,
				["east"] = true,
				["south"] = true,
				["west"] = true,
				["Font"] = "Expressway",
				["FontSize"] = 12,
				["FontOutline"] = "OUTLINE",
				["color"] = 2,
				["customColor"] = { r = 255/255, g = 227/255, b = 35/255 },
			},
		},
		--[[["worldmap"] = {
			["flightQ"] = true,
		},]]
	},
	
	-- Media
	["media"] = {
		["fonts"] = {
			["zone"] = {
				["font"] = "Expressway",
				["size"] = 32,
				["outline"] = "OUTLINE",
				["width"] = 512,
			},
			["subzone"] = {
				["font"] = "Expressway",
				["size"] = 25,
				["outline"] = "OUTLINE",
				["offset"] = 0,
				["width"] = 512,
			},
			["pvp"] = {
				["font"] = "Expressway",
				["size"] = 22,
				["outline"] = "OUTLINE",
				["width"] = 512,
			},
			["mail"] = {
				["font"] = "Expressway",
				["size"] = 12,
				["outline"] = "NONE",
			},
			["editbox"] = {
				["font"] = "Expressway",
				["size"] = 12,
				["outline"] = "NONE",
			},
			["gossip"] = {
				["font"] = "Expressway",
				["size"] = 12,
				["outline"] = "NONE",
			},
			["objective"] = {
				["font"] = "Expressway",
				["size"] = 12,
				["outline"] = "OUTLINE",
			},
			["objectiveHeader"] = {
				["font"] = "Expressway",
				["size"] = 16,
				["outline"] = "OUTLINE",
			},
			["questFontSuperHuge"] = {
				["font"] = "Expressway",
				["size"] = 24,
				["outline"] = "OUTLINE",
			},
		},
	},
	
	-- MicroBar
	["microBar"] = {
		["enable"] = false,
		['scale'] = 1.0,
		["hideInCombat"] = false,
		["hideInOrderHall"] = false,
		["highlight"] = {
			["enable"] = true,
			["buttons"] = false,
		},
		["text"] = {
			["buttons"] = {
				["position"] = "BOTTOM",
			},
			["friends"] = {
				["enable"] = true,
				["textSize"] = 12,
				["xOffset"] = 0,
				["yOffset"] = 5,
			},
			["guild"] = {
				["enable"] = true,
				["textSize"] = 12,
				["xOffset"] = 0,
				["yOffset"] = 5,
			},
			['colors'] = {
				['customColor'] = 1,
				['userColor'] = { r = 1, g = 1, b = 1 },
			},
		},
	},
	
	-- Miscellaneous
	["misc"] = {
		["gmotd"] = true,
		["combatState"] = false,
		["announce"] = false,
		["buyall"] = true,
		["keystones"] = true,
		["talkingHead"] = false,
		["whistleLocation"] = true,
		["whistleSound"] = true,
		["lootSound"] = true,
		["transmog"] = true,
		["rumouseover"] = false,
		["workorder"] = {
			["orderhall"] = true,
			["nomi"] = true,
		},
		["merchant"] = {
			["style"] = true,
			["subpages"] = 2,
			["itemlevel"] = true,
		},
		["bloodlust"] = {
			["enable"] = true,
			["sound"] = true,
			["text"] = true,
			["faction"] = "HORDE",
			["customSound"] = "",
			["SoundOverride"] = false,
			["UseCustomVolume"] = false,
			["CustomVolume"] = 50,
		},
		["easyCurve"] = {
			["enable"] = true,
			["override"] = false,
			["whispersAchievement"] = false,
			["whispersKeystone"] = false,
		},
		["rolecheck"] = {
			["enable"] = true,
			["confirm"] = true,
			["timewalking"] = true,
			["love"] = true,
			["halloween"] = true,
		},
		["panels"] = {
			["top"] = {
				["show"] = false,
				["style"] = true,
				["transparency"] = true,
				["height"] = 22
			},
			["bottom"] = {
				["show"] = false,
				["style"] = true,
				["transparency"] = true,
				["height"] = 22
			},
		},
		["scrapper"] = {
			["enable"] = true,
			["position"] = "BOTTOM",
			["autoOpen"] = true,
			["equipmentsets"] = true,
			["azerite"] = false,
			["boe"] = false,
			["Itemlvl"] = false,
			["specificilvl"] = false,
			["specificilvlbox"] = " ",
		},
		["zoom"] = {
			["increment"] = 5,
			["speed"] = 50,
			["distance"] = 39,
		},
		["autolog"] = {
			["enable"] = true,
			["curLogging"] = false,
			["allraids"] = false,
			["dungeons"] = false,
			["mythicdungeons"] = false,
			["mythiclevel"] = 1,
			["challenge"] = false,
			["chatwarning"] = true,
			["flex"] = nil,
			["raids10"] = nil,
			["raids25"] = nil,
			["raids10h"] = nil,
			["raids25h"] = nil,
			["lfr"] = {["81UDI"] = true},
			["normal"] = {["81UDI"] = true},
			["heroic"] = {["81UDI"] = true},
			["mythic"] = {["81UDI"] = true},
		},
		["CA"] = {
			["enable"] = true,
			["nextSound"] = 1,
			["soundProbabilityPercent"] = 25,
		},
		["popups"] = {
			["ABANDON_QUEST"] = true,
			["ABANDON_QUEST_WITH_ITEMS"] = true,
			["ACTIVATE_FOLLOWER"] = true,
			["AUTOEQUIP_BIND"] = true,
			["BUYEMALL_CONFIRM"] = false,
			["CONFIM_BEFORE_USE"] = false,
			["CONFIRM_ACCEPT_SOCKETS"] = true,
			["CONFIRM_BINDER"] = false,
			["CONFIRM_BUY_BANK_SLOT"] = true,
			["CONFIRM_BUY_REAGENTBANK_TAB"] = true,
			["CONFIRM_DELETE_EQUIPMENT_SET"] = true,
			["CONFIRM_DELETE_SELECTED_MACRO"] = true,
			["CONFIRM_DELETE_TRANSMOG_OUTFIT"] = true,
			["CONFIRM_FOLLOWER_TEMPORARY_ABILITY"] = true,
			["CONFIRM_FOLLOWER_UPGRADE"] = true,
			["CONFIRM_HIGH_COST_ITEM"] = false, 
			["CONFIRM_LEARN_SPEC"] = true,
			["CONFIRM_LEAVE_INSTANCE_PARTY"] = true,
			["CONFIRM_MAIL_ITEM_UNREFUNDABLE"] = false,
			["CONFIRM_MERCHANT_TRADE_TIMER_REMOVAL"] = true,
			["CONFIRM_PLAYER_CHOICE"] = true,
			["CONFIRM_PURCHASE_NONREFUNDABLE_ITEM"] = false,
			["CONFIRM_PURCHASE_TOKEN_ITEM"] = true,
			["CONFIRM_RECRUIT_FOLLOWER"] = true,
			["CONFIRM_REFUND_TOKEN_ITEM"] = true,
			["CONFIRM_RELIC_REPLACE"] = false,
			["CONFIRM_REMOVE_FRIEND"] = true,
			["CONFIRM_RESET_INSTANCES"] = true,
			["CONFIRM_RESET_TO_DEFAULT_KEYBINDINGS"] = true,
			["CONFIRM_SAVE_EQUIPMENT_SET"] = true,
			["CONFIRM_UPGRADE_ITEM"] = true,
			["DANGEROUS_MISSIONS"] = true,
			["DEACTIVATE_FOLLOWER"] = true,
			["DEATH"] = false,
			["DELETE_GOOD_ITEM"] = false,
			["DELETE_ITEM"] = false,
			["DELETE_QUEST_ITEM"] = false,
			["EQUIP_BIND"] = true,
			["EQUIP_BIND_TRADEABLE"] = false,
			["GOSSIP_CONFIRM"] = true,
			["LOOT_BIND"] = true,
			["LOOT_BIND_CONFIRM"] = true,
			["NOT_ENOUGH_POWER_ARTIFACT_RESPEC"] = true,
			["ORDER_HALL_TALENT_RESEARCH"] = false,
			["OUTFITTER_CONFIRM_SET_CURRENT"] = true,
			["PARTY_INVITE"] = false,
			["PETBM_DELETE_TEAM"] = true,
			["PREMADEFILTER_CONFIRM_CLOSE"] = true,
			["RECOVER_CORPSE"] = false,
			["RESURRECT_NO_TIMER"] = false,
			["SEND_MONEY"] = false,
			["TALENTS_INVOLUNTARILY_RESET"] = true,
			["TRADE_POTENTIAL_REMOVE_TRANSMOG"] = true,
			["TRANSMOG_APPLY_WARNING"] = false,
			["VOID_DEPOSIT_CONFIRM"] = false,
			["VOID_STORAGE_DEPOSIT_CONFIRMATION"] = false,
			["LFG_LIST_ENTRY_EXPIRED_TOO_MANY_PLAYERS"] = false,
			["CALENDAR_ERROR"] = false,
			["CONFIRM_REPORT_SPAM_CHAT"] = false,
			["BATTLE_PET_PUT_IN_CAGE"] = false,
			["WORLD_QUEST_ENTERED_PROMT"] = false,
			["EXPERIMENTAL_CVAR_WARNING"] = false,
			["CONFIRM_RELIC_TALENT"] = false,
			["CONFIRM_SUMMON"] = false,
			["BUYOUT_AUCTION"] = false,
			["CONFIRM_PROFESSION"] = true,
			["CLIENT_RESTART_ALERT"] = true,
			["CONFIRM_AZERITE_EMPOWERED_SELECT_POWER"] = true,
			["PETRENAMECONFIRM"] = true,
		},
	},
	
	-- Notification
	["notification"] = {
		["enable"] = true,
		["raid"] = false,
		["noSound"] = false,
		["message"] = false,
		["mail"] = true,
		["vignette"] = true,
		["invites"] = true,
		["guildEvents"] = true,
		--["quickJoin"] = true,
	},
	
	-- Quest
	["quest"] = {
		["enable"] = true,
		["diskey"] = 2,
		["accept"] = true,
		["complete"] = true,
		["dailiesonly"] = false,
		["pvp"] = true,
		["escort"] = true,
		["inraid"] = true,
		["greeting"] = true,
		["reward"] = false,
		["announce"] = {
			["enable"] = false,
			["every"] = 1,
			["sound"] = true,
			["debug"] = false,
			["To"] = {
				["chatFrame"] = true,
				["raidWarningFrame"] = false,
				["uiErrorsFrame"] = false,
			},
			["In"] = {
				["say"] = true,
				["party"] = true,
				["guild"] = false,
				["officer"] = false,
				["whisper"] = false,
				["whisperWho"] = nil,
			},
		},
		["smart"] = {
			["enable"] = false,
			["RemoveComplete"] = false,
			["AutoRemove"] = true,
			["AutoSort"] = true,
			["ShowDailies"] = false,
		},
		["visibility"] = {
			["enable"] = false,
			["bg"] = "COLLAPSED",
			["arena"] = "COLLAPSED",
			["dungeon"] = "FULL",
			["raid"] = "COLLAPSED",
			["scenario"] = "FULL",
			["rested"] = "FULL",
			["garrison"] = "FULL",
			["orderhall"] = "FULL",
			["combat"] = "NONE",
		},
	},
	
	-- Talents 
	["talents"] = {
		["enable"] = true,
		["DefaultToTalentsTab"] = true,
		["AutoHidePvPTalents"] = false,
	},
	
	-- ToolTip
	["tooltip"] = {
		["tooltip"] = true,
		["achievement"] = true,
		["keystone"] = true,
		["azerite"] = {
			["enable"] = true,
			["RemoveBlizzard"] = true,
			["OnlySpec"] = false,
			["Compact"] = false,
		},
		["progressInfo"] = {
			["enable"] = true,
			["NameStyle"] = "SHORT",
			["DifStyle"] = "SHORT",
			["raids"] = {
				["uldir"] = true,
			},
		},
		["realmInfo"] = {
			["enable"] = true,
			["timezone"] = false,
			["type"] = true,
			["language"] = true,
			["connectedrealms"] = true,
			["countryflag"] = "languageline",
			["finder_counryflag"] = true,
			["communities_countryflag"] = true,
			["ttGrpFinder"] = true,
			["ttPlayer"] = true,
			["ttFriends"] = true,
		},
	},
	
	-- Raid Buff Bar
	["raidBuffs"] = {
		["enable"] = false,
		["visibility"] = "INPARTY",
		["class"] = false,
		["alpha"] = 0.3,
		["size"] = 25,
		["backdrop"] = true,
		["glow"] = true,
		["customVisibility"] = "[noexists, nogroup] hide; show",
	},
	
	-- Raid Marker Bar
	["raidmarkers"] = {
		["enable"] = true,
		["visibility"] = "INPARTY",
		["customVisibility"] = "[noexists, nogroup] hide; show",
		["backdrop"] = true,
		["buttonSize"] = 20,
		["spacing"] = 2,
		["orientation"] = "HORIZONTAL",
		["modifier"] = "shift-",
		["reverse"] = false,
		["raidicons"] = "Anime",
		["mouseover"] = false,
		["notooltip"] = false,
		["automark"] = false,
		["tankMark"] = 2,
		["healerMark"] = 5,
	},
	
	-- UnitFrames
	["unitframes"] = {
		["powerBar"] = true,
		["powerBarBackdrop"] = false,
		["AuraIconText"] = {
			["durationTextPos"] = "CENTER",
			["durationTextOffsetX"] = 1,
			["durationTextOffsetY"] = 0,
			["stackTextPos"] = "BOTTOMRIGHT",
			["stackTextOffsetX"] = 1,
			["stackTextOffsetY"] = 2,
			["hideDurationText"] = false,
			["hideStackText"] = false,
			["durationFilterOwner"] = false,
			["durationThreshold"] = -1,
			["stackFilterOwner"] = false,
		},
		["AuraIconSpacing"] = {
			["spacing"] = 1,
			["units"] = {
				["player"] = true,
				["target"] = true,
				["targettarget"] = true,
				["targettargettarget"] = true,
				["focus"] = true,
				["focustarget"] = true,
				["pet"] = true,
				["pettarget"] = true,
				["arena"] = true,
				["boss"] = true,
				["party"] = true,
				["raid"] = true,
				["raid40"] = true,
				["raidpet"] = true,
				["tank"] = true,
				["assist"] = true,
			},
		},
		["debuffsAlert"] = {
			["enable"] = true,
			["default_color"] = {r = 0.5,g = 0,b = 0},
			["DA_filter"] = {}
		},
		['textures'] = {
			['health'] = E.db.unitframe.statusbar,
			['ignoreTransparency'] = false,
			['power'] = E.db.unitframe.statusbar,
			['castbar'] = E.db.unitframe.statusbar,
		},
		['castbar'] = {
			['text'] = {
				['ShowInfoText'] = true,
				['castText'] = true,
				['forceTargetText'] = false,
				['player'] = {
					['yOffset'] = 0,
					['textColor'] = {r = 1, g = 1, b = 1, a = 1},
				},
				['target'] = {
					['yOffset'] = 0,
					['textColor'] = {r = 1, g = 1, b = 1, a = 1},
				},
			},
		},
		['icons'] = {
			['role'] = "SupervillainUI",
			['rdy'] = "BenikUI",
			['klixri'] = true,
		},
	},
}

-- DataTexts Continued Again
P.datatexts.panels.KuiLeftChatDTPanel = {
	left = E.db.datatexts.panels.LeftChatDataPanel.left,
	middle = E.db.datatexts.panels.LeftChatDataPanel.middle,
	right = E.db.datatexts.panels.LeftChatDataPanel.right,
}

P.datatexts.panels.KuiRightChatDTPanel = {
	left = E.db.datatexts.panels.RightChatDataPanel.left,
	middle = E.db.datatexts.panels.RightChatDataPanel.middle,
	right = E.db.datatexts.panels.RightChatDataPanel.right,
}

P.datatexts.panels.KuiMiddleDTPanel = {
	left = 'Haste',
	middle = 'Crit Chance',
	right = 'Mastery',
}

P.datatexts.panels.Left_ChatTab_Panel = {
	left = '',
	middle = '',
	right = 'Titles (KUI)',
}

P.datatexts.panels.Right_ChatTab_Panel = {
	left = '',
	middle = '',
	right = '',
}

P.datatexts.panels.RightCoordDtPanel = 'Time'
P.datatexts.panels.LeftCoordDtPanel = 'Durability'