local _, core = ...

core.Frames = {}
local Frames = core.Frames

function CmdClick()
    print("click")
    DEFAULT_CHAT_FRAME.editBox:SetText("/click ActionBarButton1 RightButton true") ChatEdit_SendText(DEFAULT_CHAT_FRAME.editBox, 0)
end

function Frames:CreateGuildBag()
    --[[
        CreateFrame Arguments:
        1. The type of frame. (Frame is the default frame)
        2. The global frame name - BagUI
        3. The parent frame (NOT A STRING)
        4. A comma separated list (string list) of XML templates to inherit from  
    ]]

    BagFrame = CreateFrame(
        "Frame", 
        "BagUI", 
        UIParent, 
        "BasicFrameTemplateWithInset"
    )

    BagFrame:SetSize(300, 240) --width, height
    BagFrame:SetPoint("CENTER", UIParent, "CENTER") -- point, relativeFrame (default is UIParent ), relativePoint, xOffset, yOffset
    BagFrame.text = BagFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    BagFrame.text:SetPoint("TOPLEFT", 10, -6)
    BagFrame.text:SetText("Guild Bag")
    BagFrame.title = BagFrame:CreateFontString(nil, "OVERLAY")
    BagFrame.title:SetFontObject("GameFontHighlight")
    BagFrame.items = {}
    BagFrame.bagSlotsOccupied = {}
    for i = 0,1,1 do 
        for j = 0,4,1 do 
            ItemSlot = CreateFrame(
                "Button",
                "Slot"..i..j,
                BagFrame,
                "ItemButtonTemplate"
            )
            ItemSlot.index = i..j
            ItemSlot:SetPoint("TOPLEFT", BagFrame, "TOPLEFT", 30 + 50*j, -50 -60*i) -- point, relativeFrame (default is UIParent ), relativePoint, xOffset, yOffset
            ItemSlot:SetScript("OnClick", function(self, button, down)
                if core.addon.selectedItem ~= nil and core.addon.selectedBagSlot ~= nil then
                    if BagFrame.bagSlotsOccupied[core.addon.selectedBagSlot] == nil then
                        item = core.addon.selectedItem
                        self.icon:SetTexture(item.texture)
                        self.icon.text = self:CreateFontString(nil, "OVERLAY", "NumberFontNormal")
                        self.icon.text:SetPoint("BOTTOMRIGHT", -5, 3)
                        self.icon.text:SetText(item.count)
                        local count = nil
                        if item.count == nil then
                            count = 1
                        else 
                            count = item.count
                        end
                        local item = {id = core.addon.selectedItem, count = count, bagSlot = core.addon.selectedBagSlot}
                        BagFrame.items[self.index] = item.id
                        BagFrame.bagSlotsOccupied[core.addon.selectedBagSlot] = true
                        core.addon.selectedItem = nil
                    else
                        core.addon.selectedItem = nil
                        core.addon.selectedBagSlot = nil
                        print("|cFFFFFF00 [Lootr]: Cannot drop Item: Item already inside the bag");
                    end
                else
                    self.icon:SetTexture(nil)
                    self.icon.text:SetText(nil)
                    itemBagSlot = BagFrame.items[self.index].bagSlot
                    BagFrame.bagSlotsOccupied[itemBagSlot] = nil
                    BagFrame.items[self.index] = nil
                end
            end)
        end
    end

    QRGenButton = CreateFrame(
        "Button",
        "QRGen",
        BagFrame,
        "GameMenuButtonTemplate"
    )

    QRGenButton:SetSize(180, 36)
    QRGenButton:SetPoint("BOTTOM", BagFrame, 0, 30) -- point, relativeFrame (default is UIParent ), relativePoint, xOffset, yOffset
    QRGenButton:SetScript("OnClick", function()
        --generate QRCode function
    end)
    QRGenButton.text = QRGenButton:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    QRGenButton.text:SetPoint("CENTER")
    QRGenButton.text:SetText("Generate QR Code")
    QRGenButton.title = QRGenButton:CreateFontString(nil, "OVERLAY")
    QRGenButton.title:SetFontObject("GameFontHighlight")
    return BagFrame
end

