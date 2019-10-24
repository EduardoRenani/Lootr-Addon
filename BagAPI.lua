local TOTALBAGS = 5 -- max number of bags a player can carry

local _, core = ...

core.BagAPI = {}
local BagAPI = core.BagAPI

function concatenateTables(t1, t2)
    
    for _, entry in ipairs(t2) do
        table.insert(t1, entry)
    end
    
    return t1
end

function tablelength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end

function getAllBagItems(bagId)
    local numSlots = GetContainerNumSlots(bagId); 
    local items = {} --initialize an empty table (object)

    for i=0, numSlots do -- iterate through bag slots 
        local itemId = GetContainerItemID(bagId, i);
        local texture, itemCount, locked, quality, readable, lootable, itemLink = GetContainerItemInfo(bagId, i);
        if itemId ~= nil then
            local item = {} -- initialize an empty item object
            item.id = itemId -- create item object fields
            item.texture = texture
            item.locked = locked
            item.quality = quality
            item.readable = readable
            if itemCount ~= nil then item.count = itemCount else item.count = 1 end -- if itemCount equals to nil then it's an unique item
            table.insert(items, item)
        end
    end
    return items
end

function GetAllPlayerItems()
    local items = {} --initialize an empty table (object)
    for i = 0, TOTALBAGS - 1 do
        local bagItems = getAllBagItems(BACKPACK_CONTAINER + i) -- get bag object (list of itens)
        items = concatenateTables(items, bagItems) -- insert all bag itens into all itens table  
        i = i + 1
    end
    table.remove(items, 1) --remove bag item
    return items
end

function BagAPI:isItemInBagSoulbound(bagId, slotId)
    --[[ /dump IsItemInBagSoulbound(0,1)
            Return "true" if item is soulbound
            Return "false" if item is BoE, BoA or don't has bound
            Return "nil" if no item at selected location
    --]]
    local iLoc, iLink, isBound, sBound, frame, text, i
    iLoc=ItemLocation:CreateFromBagAndSlot(bagId, slotId)
    if C_Item.DoesItemExist(iLoc) then
        iLink  =C_Item.GetItemLink(iLoc)
        isBound=C_Item.IsBound(iLoc)
        if (isBound==false) then return false end
        sBound=_G["ITEM_SOULBOUND"]
        frame=_G["ContainerFrame"..tostring(bagId+1).."Item"..tostring(slotId)]
        GameTooltip:SetOwner(frame,ANCHOR_NONE)
        GameTooltip:SetBagItem(bagId,slotId)
        for i=1,GameTooltip:NumLines() do
            text=_G["GameTooltipTextLeft"..tostring(i)]:GetText()
            if (text==sBound) then
            GameTooltip:Hide()
            return true
            end
        end
        GameTooltip:Hide()
        return false
    else
        return nil
    end
end

function BagAPI:initialize()
    local items = GetAllPlayerItems()
    BagAPI.availableItems = {}
    local i = 1
    for key, item in pairs(items) do
        BagAPI.availableItems[i] = item.id..":"..item.count
        i = i + 1 
    end
    BagAPI.availableItems.size = i
end

function formateGuildBagList()

    local guildBagItems = {} --creates an array of id:count for all items currently in guild bag
    local i = 1
    for _, item in pairs(core.BagFrame.items) do
    guildBagItems[i] = item.id..":"..item.count
        i = i + 1
    end
    guildBagItems.size = i

    return guildBagItems
end

function BagAPI:updateState()
    local items = GetAllPlayerItems() 
    BagAPI.availableItems = {}
    local i = 1
    for _, item in pairs(items) do -- creates an array of all items inside user bag
        BagAPI.availableItems[i] = item.id..":"..item.count
        i = i + 1 
    end
    BagAPI.availableItems.size = i

    local guildBagItems = formateGuildBagList() 
    for _, item in ipairs(guildBagItems) do -- subtract from player bag all items currently inside the guild bag
        BagAPI:remove(item)
    end

    --now, all items inside the "availableItems" are the remaining set of ALL ITEMS - GUILD BAG ITEMS
    --we will use the availableItems structure to determine if a picked item can be dropped inside guild bag.
end

function BagAPI:remove(element) --try to remove item from list of items inside player bag
    local listSize = BagAPI.availableItems.size
    local i = 1
    while i <= listSize do
        if(element == BagAPI.availableItems[i]) then
            BagAPI.availableItems[i] = nil --if item exists, remove it 
            return true --and tells it existed inside the array
        else
            i = i + 1
        end
    end
    return false -- if item doesnt exist, tells the array doesnt contain it
end

function BagAPI:append(element)
    local listSize = BagAPI.availableItems.size
    local i = 1
    while i <= listSize do
        i = i + 1
    end
    BagAPI.availableItems[i] = element
    BagAPI.availableItems.size = listSize + 1
end
