util.AddNetworkString("gmod_buddies")
local function updateBuds(ply)
	local buds = {}
	for bud,_ in pairs(ply.buddies or {}) do
		if bud.buddies and bud.buddies[ply] then buds[bud] = true end
	end
	net.Start("gmod_buddies")
		net.WriteTable(buds)
	net.Send(ply)
end

hook.Add("PlayerSay", "buddies", function(ply, msg, public)
	local cmdName = "!bud "
	if msg:sub(1, #cmdName):lower() == cmdName:lower() then
		local plyName = msg:sub(#cmdName+1)
		local targets = {}
		for _,ply in pairs(player.GetAll()) do
			if ply:Name():lower():find(plyName:lower()) then table.insert(targets, ply) end
		end
		if #targets == 1 then
			local target = targets[1]
			ply.buddies = ply.buddies or {}
			ply.buddies[target] = not ply.buddies[target]
			if target:Name() == ply:Name() then
				ply:ChatPrint("You can't add yourself as a buddy.")
				return ""
			end
			if ply.buddies[target] then
				ply:ChatPrint("You've added "..target:Name().." to your buddy list.")
			else
				ply:ChatPrint("You removed "..target:Name().." from your buddy list.")
				ply.buddies[target] = nil
			end
			updateBuds(ply)
			updateBuds(target)
		else
			ply:ChatPrint("Multiple people have those characters in their name. Enter more to add them as a buddy.")
		end
		return ""
	end
	local cmdName = "!buds"
	if msg:sub(1, #cmdName):lower() == cmdName:lower() then
		if not ply.buddies or table.Count(ply.buddies) == 0 then
			ply:ChatPrint("You have no buddies :(")
		else
			local str = ""
			for buddy,isbuddy in pairs(ply.buddies) do
				if not IsValid(buddy) then
					ply.buddies[buddy] = nil
				else
					str = str..buddy:Nick()..", "
				end
			end
			str = str:sub(1, -3)
			ply:ChatPrint("You're buddies with: "..str)
		end
		return ""
	end
end)