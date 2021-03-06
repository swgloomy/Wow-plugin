local KUI, E, L, V, P, G = unpack(select(2, ...))
local KS = KUI:GetModule("KuiSkins")
local S = E:GetModule("Skins")

-- Cache global variables
-- Lua functions
local _G = _G
local select, unpack = select, unpack
-- WoW API
local hooksecurefunc = hooksecurefunc
-- Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

local function styleAuctionhouse()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.auctionhouse ~= true or E.private.KlixUI.skins.blizzard.auctionhouse ~= true then return end

	local r, g, b = unpack(E["media"].rgbvaluecolor)

	local AuctionFrame = _G["AuctionFrame"]
	AuctionFrame.backdrop:Styling()

	--Change ElvUI's backdrop to be Transparent
	if AuctionFrameBrowse.bg1 then AuctionFrameBrowse.bg1:SetTemplate("Transparent") end
	if AuctionFrameBrowse.bg2 then AuctionFrameBrowse.bg2:SetTemplate("Transparent") end
	if AuctionFrameBid.bg then AuctionFrameBid.bg:SetTemplate("Transparent") end
	if AuctionFrameAuctions.bg1 then AuctionFrameAuctions.bg1:SetTemplate("Transparent") end
	if AuctionFrameAuctions.bg2 then AuctionFrameAuctions.bg2:SetTemplate("Transparent") end
	
	AuctionProgressBar.Text:ClearAllPoints()
	AuctionProgressBar.Text:SetPoint("CENTER", 0, 1)

	select(14, AuctionProgressFrameCancelButton:GetRegions()):SetPoint("CENTER", 0, 2)

	BrowseQualitySort:DisableDrawLayer("BACKGROUND")
	BrowseLevelSort:DisableDrawLayer("BACKGROUND")
	BrowseDurationSort:DisableDrawLayer("BACKGROUND")
	BrowseHighBidderSort:DisableDrawLayer("BACKGROUND")
	BrowseCurrentBidSort:DisableDrawLayer("BACKGROUND")
	BidQualitySort:DisableDrawLayer("BACKGROUND")
	BidLevelSort:DisableDrawLayer("BACKGROUND")
	BidDurationSort:DisableDrawLayer("BACKGROUND")
	BidBuyoutSort:DisableDrawLayer("BACKGROUND")
	BidStatusSort:DisableDrawLayer("BACKGROUND")
	BidBidSort:DisableDrawLayer("BACKGROUND")
	AuctionsQualitySort:DisableDrawLayer("BACKGROUND")
	AuctionsDurationSort:DisableDrawLayer("BACKGROUND")
	AuctionsHighBidderSort:DisableDrawLayer("BACKGROUND")
	AuctionsBidSort:DisableDrawLayer("BACKGROUND")
	select(6, BrowseCloseButton:GetRegions()):Hide()
	select(6, BrowseBuyoutButton:GetRegions()):Hide()
	select(6, BrowseBidButton:GetRegions()):Hide()
	select(6, BidCloseButton:GetRegions()):Hide()
	select(6, BidBuyoutButton:GetRegions()):Hide()
	select(6, BidBidButton:GetRegions()):Hide()

	hooksecurefunc("FilterButton_SetUp", function(button)
		button:SetNormalTexture("")
	end)

	local lastSkinnedTab = 1
	AuctionFrame:HookScript("OnShow", function()
		local tab = _G["AuctionFrameTab"..lastSkinnedTab]

		while tab do
			KS:ReskinTab(tab)
			lastSkinnedTab = lastSkinnedTab + 1
			tab = _G["AuctionFrameTab"..lastSkinnedTab]
		end
	end)

	local abuttons = {"BrowseBidButton", "BrowseBuyoutButton", "BrowseCloseButton", "BrowseSearchButton", "BrowseResetButton", "BidBidButton", "BidBuyoutButton", "BidCloseButton", "AuctionsCloseButton", "AuctionsCancelAuctionButton", "AuctionsCreateAuctionButton", "AuctionsNumStacksMaxButton", "AuctionsStackSizeMaxButton"}
	for i = 1, #abuttons do
		KS:Reskin(_G[abuttons[i]])
	end

	BrowseCloseButton:ClearAllPoints()
	BrowseCloseButton:SetPoint("BOTTOMRIGHT", AuctionFrameBrowse, "BOTTOMRIGHT", 66, 13)
	BrowseBuyoutButton:ClearAllPoints()
	BrowseBuyoutButton:SetPoint("RIGHT", BrowseCloseButton, "LEFT", -1, 0)
	BrowseBidButton:ClearAllPoints()
	BrowseBidButton:SetPoint("RIGHT", BrowseBuyoutButton, "LEFT", -1, 0)
	BidBuyoutButton:ClearAllPoints()
	BidBuyoutButton:SetPoint("RIGHT", BidCloseButton, "LEFT", -1, 0)
	BidBidButton:ClearAllPoints()
	BidBidButton:SetPoint("RIGHT", BidBuyoutButton, "LEFT", -1, 0)
	AuctionsCancelAuctionButton:ClearAllPoints()
	AuctionsCancelAuctionButton:SetPoint("RIGHT", AuctionsCloseButton, "LEFT", -1, 0)

	-- Blizz needs to be more consistent
	BrowseBidPriceSilver:SetPoint("LEFT", BrowseBidPriceGold, "RIGHT", 1, 0)
	BrowseBidPriceCopper:SetPoint("LEFT", BrowseBidPriceSilver, "RIGHT", 1, 0)
	BidBidPriceSilver:SetPoint("LEFT", BidBidPriceGold, "RIGHT", 1, 0)
	BidBidPriceCopper:SetPoint("LEFT", BidBidPriceSilver, "RIGHT", 1, 0)
	StartPriceSilver:SetPoint("LEFT", StartPriceGold, "RIGHT", 1, 0)
	StartPriceCopper:SetPoint("LEFT", StartPriceSilver, "RIGHT", 1, 0)
	BuyoutPriceSilver:SetPoint("LEFT", BuyoutPriceGold, "RIGHT", 1, 0)
	BuyoutPriceCopper:SetPoint("LEFT", BuyoutPriceSilver, "RIGHT", 1, 0)

	local function reskinAuctionButtons(button, i)
		local bu = _G[button..i]
		local it = _G[button..i.."Item"]
		local ic = _G[button..i.."ItemIconTexture"]

		if bu and it then
			it:SetNormalTexture("")
			it:SetPushedTexture("")
			it:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
			KS:ReskinIcon(ic)
			it.IconBorder:SetAlpha(0)
			bu:StripTextures()

			local bg = KS:CreateBDFrame(bu, .25)
			bg:SetPoint("TOPLEFT")
			bg:SetPoint("BOTTOMRIGHT", 0, 5)
			KS:CreateGradient(bg)

			bu:SetHighlightTexture(E["media"].normTex)
			local hl = bu:GetHighlightTexture()
			hl:SetVertexColor(r, g, b, .2)
			hl:ClearAllPoints()
			hl:SetPoint("TOPLEFT", 0, -1)
			hl:SetPoint("BOTTOMRIGHT", -1, 6)
		end
	end

	for i = 1, NUM_BROWSE_TO_DISPLAY do
		reskinAuctionButtons("BrowseButton", i)
	end

	for i = 1, NUM_BIDS_TO_DISPLAY do
		reskinAuctionButtons("BidButton", i)
	end

	for i = 1, NUM_AUCTIONS_TO_DISPLAY do
		reskinAuctionButtons("AuctionsButton", i)
	end

	local auctionhandler = CreateFrame("Frame")
	auctionhandler:RegisterEvent("NEW_AUCTION_UPDATE")
	auctionhandler:SetScript("OnEvent", function()
		local AuctionsItemButtonIconTexture = AuctionsItemButton:GetNormalTexture()
		if AuctionsItemButtonIconTexture then
			AuctionsItemButtonIconTexture:SetTexCoord(unpack(E.TexCoords))
			AuctionsItemButtonIconTexture:SetPoint("TOPLEFT", 1, -1)
			AuctionsItemButtonIconTexture:SetPoint("BOTTOMRIGHT", -1, 1)
		end
		AuctionsItemButton.IconBorder:SetTexture("")
	end)

	local _, AuctionsItemButtonNameFrame = AuctionsItemButton:GetRegions()
	AuctionsItemButtonNameFrame:Hide()

	BrowsePrevPageButton:SetPoint("TOPLEFT", 660, -60)
	BrowseNextPageButton:SetPoint("TOPRIGHT", 67, -60)
	BrowsePrevPageButton:GetRegions():SetPoint("LEFT", BrowsePrevPageButton, "RIGHT", 2, 0)

	BrowseDropDownLeft:SetAlpha(0)
	BrowseDropDownMiddle:SetAlpha(0)
	BrowseDropDownRight:SetAlpha(0)

	local a1, p, a2, x, y = BrowseDropDownButton:GetPoint()
	BrowseDropDownButton:SetPoint(a1, p, a2, x, y-4)
	BrowseDropDownButton:SetSize(16, 16)

	-- [[ WoW token ]]
	local BrowseWowTokenResults = _G["BrowseWowTokenResults"]

	KS:Reskin(BrowseWowTokenResults.Buyout)

	-- Tutorial
	local WowTokenGameTimeTutorial = _G["WowTokenGameTimeTutorial"]
	WowTokenGameTimeTutorial:Styling()

	KS:Reskin(StoreButton)
	WowTokenGameTimeTutorial.LeftDisplay.Tutorial1:SetTextColor(1, .8, 0)
	WowTokenGameTimeTutorial.RightDisplay.Tutorial1:SetTextColor(1, .8, 0)

	-- Token
	do
		local Token = BrowseWowTokenResults.Token
		local icon = Token.Icon
		local iconBorder = Token.IconBorder

		Token.ItemBorder:Hide()
		iconBorder:SetTexture(E["media"].normTex)
		iconBorder:SetDrawLayer("BACKGROUND")
		iconBorder:SetPoint("TOPLEFT", icon, -1, 1)
		iconBorder:SetPoint("BOTTOMRIGHT", icon, 1, -1)
		icon:SetTexCoord(unpack(E.TexCoords))
	end
end

S:AddCallbackForAddon("Blizzard_AuctionUI", "KuiAuctionhouse", styleAuctionhouse)