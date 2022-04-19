buddies = buddies or {}
net.Receive("gmod_buddies", function() buddies = net.ReadTable() end)
local matDot = Material("vgui/circle.vmt")
hook.Add("HUDPaint", "BudPaint", function()
	for buddy,_ in pairs(buddies) do
		if not IsValid(buddy) then
			buddies[buddy] = nil
		else
			local pos = (buddy:GetShootPos()-Vector(0, 0, 16)):ToScreen()
			local name = tostring(buddy:Nick())
			surface.SetMaterial(matDot)
			local s = 6
			surface.SetDrawColor(0, 0, 0, 255)
			surface.DrawTexturedRect(pos.x-s, pos.y-s, s*2, s*2)
			local s = 4
			surface.SetDrawColor(GetHealthColor(buddy:Health()))
			surface.DrawTexturedRect(pos.x-s, pos.y-s, s*2, s*2)

			surface.SetTextColor( 255, 255, 255, 100 )
			surface.SetFont("Trebuchet18")
			surface.SetTextPos( tonumber( pos.x + 10 ), tonumber ( pos.y + 10 ) )
			surface.DrawText("Buddy: "..name )
		end
	end
end)