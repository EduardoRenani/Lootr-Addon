local _, core = ...

core.QrcodeAPI = {}
local QrcodeAPI = core.QrcodeAPI

function reinit()
	for y=1,40 do
			for x=1,40 do
				_G["qr"..(x).."_"..(y)]:SetAlpha(0);
			end
		end
end

function init(event,arg1)
    WQR_VARS={};
    for y=1,40 do
        for x=1,40 do
            local f=CreateFrame("Frame","qr"..x.."_"..y,QR.viewFrame.dotHolder);
            f:SetFrameStrata("DIALOG");
            f:SetWidth(4);
            f:SetHeight(4);
            f:SetParent(QR.viewFrame.dotHolder);
            f.texture = f:CreateTexture();
            f.texture:SetAllPoints(f);
            f.texture:SetColorTexture(0,0,0);
            f:SetPoint("CENTER",-78+((y-1)*4),-78+((x-1)*4));
            f:Show();
            f:SetAlpha(0);
        end
    end

    local origChatFrame_OnHyperlinkShow = ChatFrame_OnHyperlinkShow; -- (1)
    ChatFrame_OnHyperlinkShow = function(...) -- (2)
    local chatFrame, link, text, button = ...; -- (3)
    local n=nil;
    local s=nil;
    n,s=string.match(link,'player:([^\-]+)\-([^:]+)');
   		
    if (s==nil) then
        n = string.match(link,'player:([^:]+)');
        s = GetRealmName();
        playerLink=n;
    else
        playerLink=n.."\-"..s;
    end
    if(n~=nil and s~=nil) then
        playerLinkPending=true;
        playerName=n;
        playerRealm=s;
    end
      return origChatFrame_OnHyperlinkShow(...);
    end

end

local function qrgen(str)
    reinit();
	a,t=QR:qrcode(str);
	QR.viewFrame:SetWidth((#t*4)+16)
	QR.viewFrame:SetHeight((#t*4)+16)
	local mod = math.floor((40-(#t))/2)
	if(math.fmod(#t,2)~=0)then
		QR.viewFrame.dotHolder:SetPoint("CENTER",2,2);
	else
		QR.viewFrame.dotHolder:SetPoint("CENTER",0,0);
	end
	for y=1,#t do
		for x=1,#t[1] do

			local viewFrame = QR.viewFrame;
			if(t[y][x] < 0)then
				_G["qr"..(x+mod).."_"..(y+mod)]:SetAlpha(0);
				--_G["qr"..x.."_"..y]:SetPoint("BOTTOMLEFT",4+(y*4),8+((#t-x)*4));
			else
				_G["qr"..(x+mod).."_"..(y+mod)]:SetAlpha(1);
				--_G["qr"..x.."_"..y]:SetPoint("BOTTOMLEFT",4+(y*4),8+((#t-x)*4));
			end
		end
	end
end

local function initQR()
	
		
end


local function QrcodeAPI:handler(str)
	print("Generating QR code for bag items");
    initQR();
    viewFrame:Show();
    qrgen(str)
end
