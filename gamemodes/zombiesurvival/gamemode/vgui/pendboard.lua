function GM:AddHonorableMention(pl, mentionid, ...)
	if not (pEndBoard and pEndBoard:Valid()) then
		MakepEndBoard(ROUNDWINNER)
	end
	
	local mentiontab = self.HonorableMentions[mentionid]
	if not mentiontab then return end

	local pan = vgui.Create("DEndBoardPlayerPanel", pEndBoard.List)
	pan:SetPlayer(pl, mentiontab.Color, string.format(mentiontab.String, mentiontab.Callback(pl, ...)), nil, mentiontab.Name)
	pEndBoard.List:AddItem(pan)
end


function MakepEndBoard(winner)
	if pEndBoard and pEndBoard:IsValid() then
		pEndBoard:Remove()
		pEndBoard = nil
	end

	local localwin = winner == TEAM_HUMAN and LocalPlayer():Team() == winner

	local wid = 640
	local wid2 = 2000

	local w, h = ScrW(), ScrH()
	
	local frame = vgui.Create("DFrame")
	frame:SetWide(wid)
	frame:SetKeyboardInputEnabled()
	frame:SetDeleteOnClose(false)
	frame:ShowCloseButton( false )
	frame:SetTitle(" ")
		
	pEndBoard = frame

	local y = 8

	local heading
	local subheading
	if localwin then
		surface.PlaySound("beams/beamstart5.wav")
		heading = EasyLabel(frame, "Your Squad Has Survived", "ZSHUDFont", COLOR_DARKRED)
		subheading = EasyLabel(frame, "The humans have survived for now", "ZSHUDFontSmall", COLOR_WHITE)
	else
		surface.PlaySound("ambient/levels/citadel/strange_talk"..math.random(3, 11)..".wav")
		heading = EasyLabel(frame, "Your Squad Has Been Wiped Out", "ZSHUDFont", COLOR_RED)
		subheading = EasyLabel(frame, "The undead army grows stronger", "ZSHUDFontSmall", COLOR_WHITE)
	end
	heading:SetPos(wid * 0.5 - heading:GetWide() * 0.5, y)
	y = y + heading:GetTall() + 4

	subheading:SetPos(wid * 0.5 - subheading:GetWide() * 0.5, y)
	y = y + subheading:GetTall() + 8

	local starty = y

	local svpan = EasyLabel(frame, "Honorable Mentions", "ZSHUDFontSmall", COLOR_WHITE)
	svpan:SetPos(wid * 0.5 - svpan:GetWide() * 0.5, y)
	y = y + svpan:GetTall() + 4

	local list = vgui.Create("DPanelList", frame)
	list:SetSize(wid2 - 16, 400)
	list:SetPos(8, y + 110)
	list:SetPadding(2)
	list:SetSpacing(2)
	list:EnableVerticalScrollbar()
	list.Paint = function()
		surface.SetDrawColor(0,0,0,0)	
	end

	y = y + list:GetTall() + 8

	frame.List = list

	frame:SetTall(y)
	frame:Center()

	frame:MakePopup()
	frame:SetKeyboardInputEnabled()
	return frame
end

local PANEL = {}
function PANEL:OnMousePressed(mc)
	if mc == MOUSE_LEFT then
		local pl = self:GetPlayer()
		if pl:IsValid() then
			gamemode.Call("ClickedEndBoardPlayerButton", pl, self)
		end
	end
end

function PANEL:Init()
	self:SetSize(200, 40)
end

function PANEL:GetPlayer()
	return self.m_Player or NULL
end

function PANEL:SetPlayer(pl, col, misc, misccol, overridename)
	--[[if self.m_pAvatar then
		self.m_pAvatar:Remove()
		self.m_pAvatar = nil
	end]]--
	if self.m_pName then
		self.m_pName:Remove()
		self.m_pName = nil
	end
	if self.m_pMisc then
		self.m_pMisc:Remove()
		self.m_pMisc = nil
	end

	if pl:IsValid() and pl:IsPlayer() then
		local name = overridename or pl:Name()

		--[[local avatar = vgui.Create("AvatarImage", self)
		avatar:SetPos(4, 4)
		avatar:SetSize(32, 32)
		avatar:SetPlayer(pl)
		avatar:SetTooltip("Click here to view their Steam Community profile.")
		self.m_pAvatar = avatar]]--

		--local namelab = EasyLabel(self, name, "ZSHUDFontTiny", col)
		local namelab = EasyLabel(self, name, "ZSHUDFontSmall", col)
		--namelab:SetPos(40, 4)
		namelab:Center()
		namelab.Paint = function()
			surface.SetDrawColor(0,0,0,0)	
		end
		self.m_pName = namelab

		if misc then
			--local misclab = EasyLabel(self, misc, nil, misccol)
			local misclab = EasyLabel(self, misc, "ZSHUDFontSmall", misccol)
			misclab:SetPos(40, self:GetTall() - 4 - misclab:GetTall())
			misclab.Paint = function()
				surface.SetDrawColor(0,0,0,0)	
			end
		end
	end
end
vgui.Register("DEndBoardPlayerPanel", PANEL, "DPanel")
