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

function BagAPI:getAllPlayerItens()
    local items = {} --initialize an empty table (object)
    for i = 0, TOTALBAGS - 1 do
        local bagItems = getAllBagItems(BACKPACK_CONTAINER + i) -- get bag object (list of itens)
        items = concatenateTables(items, bagItems) -- insert all bag itens into all itens table  
        i = i + 1
    end
    table.remove(items, 1) --remove bag item
    return items
end

function BagAPI:isItemInBagSoulbound(bagId,slotId)
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
