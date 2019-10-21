local addon = LibStub("AceAddon-3.0"):NewAddon("Lootr", "AceConsole-3.0")
local _, core = ...
core.addon = {}
core.addon = addon
core.BagFrame = {}
local LootrLDB = LibStub("LibDataBroker-1.1"):NewDataObject("Lootr!", {
    type = "data source",
    text = "Lootr!",
    icon = "Interface\\ICONS\\inv_box_03",
    OnClick = function() 
        BagFrame = core.Frames:CreateGuildBag()
        core.BagFrame = BagFrame
        success = BagFrame:RegisterEvent("ITEM_LOCKED")
        success = BagFrame:RegisterEvent("ITEM_UNLOCKED")
        BagFrame:SetScript("OnEvent", function(self, event, bagID, slot)      
            if event == "ITEM_LOCKED" then
                local itemId = GetContainerItemID(bagID, slot);
                local texture, itemCount, locked, quality, readable, lootable, itemLink = GetContainerItemInfo(bagID, slot)
                if core.BagAPI:isItemInBagSoulbound(bagID, slot) == false then
                    addon.selectedItem = {id = itemId, count = itemCount, texture = texture}
                    addon.selectedBagSlot = bagID..""..slot -- checks if item from given bagSlot from player's bag is already inside guid bag
                else
                    print("|cFFFFFF00 [Lootr]: Cannot select item: "..itemLink.." |cFFFFFF00 is Soulbound");
                end
            end
            if event == "ITEM_UNLOCKED" then
                    addon.selectedItem = nil
                    addon.selectedBagSlot= nil
            end
        end)
    end,
})
local icon = LibStub("LibDBIcon-1.0")

function addon:OnInitialize() -- Obviously you'll need a ## SavedVariables: BunniesDB line in your TOC, duh! 
    self.db = LibStub("AceDB-3.0"):New("LootrDB", 
        { 
            profile = 
            { 
                minimap = 
                { 
                    hide = false, 
                }, 
            }, 
        }) 
    icon:Register("Lootr!", LootrLDB, self.db.profile.minimap) 
    self:RegisterChatCommand("lootr", "lootrCommand") 
end



function addon:lootrCommand() 
    print("-------GUILD BAG ITEMS-------")
    for key, item in pairs(core.BagFrame.items) do
        print(key..": "..item.id.." "..item.count)
    end
    print("-----------------------------")
end 