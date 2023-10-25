function GetPlayerData(source)
	local Player = ESX.GetPlayerFromId(source)
	return Player
end

function UnpackJob(data)
	local job = {
		name = data.name,
		label = data.label
	}
	local grade = {
		name = data.grade_label,
	}

	return job, grade
end

function PermCheck(src, PlayerData)
	local result = true

	if not Config.AllowedJobs[PlayerData.job.name] then
		print(("UserId: %s(%d) tried to access the mdt even though they are not authorised (server direct)"):format(GetPlayerName(src), src))
		result = false
	end

	return result
end

function ProfPic(gender, profilepic)
	if profilepic then return profilepic end;
	if gender == "f" then return "img/female.png" end;
	return "img/male.png"
end

function IsJobAllowedToMDT(job)
	if Config.PoliceJobs[job] then
		return true
	elseif Config.AmbulanceJobs[job] then
		return true
	elseif Config.DojJobs[job] then
		return true
	else
		return false
	end
end

function GetNameFromPlayerData(xPlayer)
	return ('%s %s'):format(xPlayer.meta.user.firstname, xPlayer.meta.user.lastname)
end

RegisterCommand('callsign', function(source, args)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.job.name == 'police' or xPlayer.job.name == 'sheriff' or xPlayer.job.name == 'ambulance' then
		if tonumber(args[1]) then
			xPlayer.setMeta('callsign', tostring(args[1]))
			xPlayer.showNotification('~g~You changed your callsign to '..tostring(args[1]))
		end
	end
end)
TriggerClientEvent('chat:addSuggestion', -1, 'callsign', 'set callsign', 'number')
