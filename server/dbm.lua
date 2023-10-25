-- Get CitizenIDs from Player License
function AddLog(text)
    return MySQL.insert.await('INSERT INTO `mdt_logs` (`text`, `time`) VALUES (?,?)', {text, os.time() * 1000})
end

function GetNameFromId(cid)
    local xPlayer = ESX.GetPlayerFromIdentifier(cid)
    local fullname = ''
    if xPlayer then
        fullname = xPlayer.meta.user.firstname..' '..xPlayer.meta.user.lastname
    else
        local user = MySQL.Sync.fetchAll('SELECT `firstname`, `lastname` FROM `users` WHERE identifier = @identifier', {['@identifier'] = cid})
        if user and user[1] then
            fullname = user[1].firstname..' '..user[1].lastname
        end
    end
    return fullname
end

function GetPersonInformation(cid, jobtype)
	local result = MySQL.query.await('SELECT information, tags, gallery, pfp, fingerprint FROM mdt_data WHERE cid = ? and jobtype = ?', { cid,  jobtype})
	return result[1]
end

function GetPfpFingerPrintInformation(cid)
	local result = MySQL.query.await('SELECT pfp, fingerprint FROM mdt_data WHERE cid = ?', { cid })
	return result[1]
end

function GetConvictions(cids)
	return MySQL.query.await('SELECT * FROM `mdt_convictions` WHERE `cid` IN(?)', { cids })
end

function CreateUser(cid, tableName)
	AddLog("A user was created with the CID: "..cid)
	return MySQL.insert.await("INSERT INTO `"..tableName.."` (cid) VALUES (:cid)", { cid = cid })
end

function GetPlayerVehicles(cid, cb)
	return MySQL.query.await('SELECT id, plate, vehicle FROM owned_vehicles WHERE owner=:cid', { cid = cid })
end

function GetBulletins(JobType)
	return MySQL.query.await('SELECT * FROM `mdt_bulletin` WHERE `jobtype` = ? LIMIT 10', { JobType })
end

function GetPlayerProperties(cid, cb)
    local xPlayer = ESX.GetPlayerFromIdentifier(cid)
	local result =  MySQL.query.await("SELECT * FROM allhousing WHERE owned = 1 AND owner = @identifier", {['@identifier'] = cid})
    local housing = {}
    for i = 1, #result do
        local db = json.decode(result[i].address)
        local address = result[i].id..' '
        if db.street then
            address = address..db.street..', '
        end
        if db.area then
            address = address..db.area
        end
        if db.postal then
            address = address..', SA '..db.postal
        end
        housing[i] = {
            label = address,
            entering = result[i].entry,
        }
    end
    return housing
end

function GetPlayerDataById(id)
    local Player = ESX.GetPlayerFromId(id)
    if Player then
		local response = {identifier = Player.identifier, firstname = Player.meta.user.firstname, lastname = Player.meta.user.lastname, meta = Player.meta, job = Player.job, dateofbirth = Player.meta.user.dateofbirth}
        return response
    else
        ESX.Jobs = ESX.GetJobs()
        local player = MySQL.single.await('SELECT identifier, firstname, lastname, job, job_grade, dateofbirth FROM users WHERE identifier = ? LIMIT 1', { id })
        local jobObject, gradeObject = ESX.Jobs[player.job], ESX.Jobs[player.job].grades[tostring(player.job_grade)]
        player.job = {}
        player.job.id = jobObject.id
        player.job.name = jobObject.name
        player.job.label = jobObject.label
        player.job.grade = tonumber(player.job_grade)
        player.job.grade_name = gradeObject.name
        player.job.grade_label = gradeObject.label
        player.job.grade_salary = gradeObject.salary
        return player
    end
end

function GetBoloStatus(plate)
	local result = MySQL.scalar.await('SELECT id FROM `mdt_bolos` WHERE LOWER(`plate`)=:plate', { plate = string.lower(plate)})
	return result
end

function GetVehicleInformation(plate, cb)
    local result = MySQL.query.await('SELECT id, information FROM `mdt_vehicleinfo` WHERE plate=:plate', { plate = plate})
	cb(result)
end

function GetPlayerLicenses(identifier)
    local licenses = {
        ['license_bike'] = false,
        ['license_car'] = false,
        ['license_truck'] = false,
        ['license_pistol'] = false,
        ['license_shotgun'] = false,
        ['license_smg'] = false,
        ['license_ar'] = false,
    }
    for i = 1, #Config.LicenseItems do
        local item = exports['ak47_inventory']:getInventoryItem(identifier, Config.LicenseItems[i])
        if item.count > 0 then
            licenses[Config.LicenseItems[i]] = true
        else
            licenses[Config.LicenseItems[i]] = false
        end
    end
    return licenses
end

