include("shared.lua")

SWEP.PrintName = "Mobile Supplies"
SWEP.Description = "Allows survivors to get ammunition for their current weapon. Each person can only use the box once every so often.\nPress PRIMARY ATTACK to deploy the box.\nPress SECONDARY ATTACK and RELOAD to rotate the box."
SWEP.DrawCrosshair = false

SWEP.Slot = 4
SWEP.SlotPos = 0
SWEP.ViewModelFOV = 80

function SWEP:DrawHUD()
	if GetConVarNumber("crosshair") ~= 1 then return end
	--self:DrawCrosshairDot()
	draw.RoundedBox( 12, w * 0.85, h * 0.9, w * 0.13, h * 0.09, Color(1, 1, 1, 100) )
	
	surface.SetFont("ZSHUDFont2")
	local text = translate.Get("right_click_to_hammer_nail")
	local nails = self:GetPrimaryAmmoCount()
	local nTEXW, nTEXH = surface.GetTextSize(text)

	local w, h = ScrW(), ScrH()	
	draw.SimpleText("Mobile Supplies", "ZSHUDFont2", ScrW() - nTEXW * 0.3 - 20, ScrH() - nTEXH * 2, nails > 0 and COLOR_GREY or COLOR_GREY, TEXT_ALIGN_CENTER)	
end

function SWEP:PrimaryAttack()
end

function SWEP:DrawWeaponSelection(...)
	return self:BaseDrawWeaponSelection(...)
end

function SWEP:Think()
	if self.Owner:KeyDown(IN_ATTACK2) then
		self:RotateGhost(FrameTime() * 60)
	end
	if self.Owner:KeyDown(IN_RELOAD) then
		self:RotateGhost(FrameTime() * -60)
	end
end

function SWEP:Deploy()
	gamemode.Call("WeaponDeployed", self.Owner, self)

	return true
end

local nextclick = 0
function SWEP:RotateGhost(amount)
	if nextclick <= RealTime() then
		surface.PlaySound("npc/headcrab_poison/ph_step4.wav")
		nextclick = RealTime() + 0.3
	end
	RunConsoleCommand("_zs_ghostrotation", math.NormalizeAngle(GetConVarNumber("_zs_ghostrotation") + amount))
end
