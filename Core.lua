local addon = LibStub("AceAddon-3.0"):NewAddon("Lootr", "AceConsole-3.0")
local _, core = ...
local LootrLDB = LibStub("LibDataBroker-1.1"):NewDataObject("Lootr!", {
    type = "data source",
    text = "Lootr!",
    icon = "Interface\\ICONS\\inv_box_03",
    OnClick = function() 
        core.Frames:CreateGuildBag()
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

-- function addon:lootrCommand() 
--     self.db.profile.minimap.hide = not self.db.profile.minimap.hide 
--     if self.db.profile.minimap.hide then 
--         icon:Hide("Lootr!") 
--     else 
--         icon:Show("Lootr!") 
--     end 
-- end 