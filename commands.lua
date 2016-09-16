computers.terminal.register_command("echo",{
	run = function(params,meta)
		if #params > 0 then
			return params[1]
		end
		return "echo <text>"
	end
})

computers.terminal.register_command("clear",{
	run = function(params,meta)
		if not(computers.terminal.instances[meta.player_name]) then
			return "Error terminal not found"
		end
		computers.terminal.instances[meta.player_name].history = {}
		return ""
	end
})

computers.terminal.register_command("list",{
	run = function(params,meta)
		if not(computers.terminal.instances[meta.player_name]) then
			return "Error terminal not found"
		end
		local path = computers.terminal.instances[meta.player_name].path
		local folder = computers.os.get_path(computers.os.instances[meta.os_pos],path)
		if not(folder) then
			return "Could not find folder \"" .. path .. "\""
		end
		local list = {}
		for k,v in pairs(folder) do
			table.insert(list,k)
		end
		return table.concat(list, ",")
	end
})

computers.terminal.register_command("cd",{
	run = function(params,meta)
		if not(computers.terminal.instances[meta.player_name]) then
			return "Error terminal not found"
		end
		if #params > 0 then
			if params[1] == ".." then
				computers.terminal.instances[meta.player_name].path = ""
			else
				local path = computers.terminal.instances[meta.player_name].path
				local folder = computers.os.get_path(computers.os.instances[meta.os_pos],path)
				if folder and folder[params[1]] then
					computers.terminal.instances[meta.player_name].path = path .. "/" .. params[1]
					return "Done"
				else
					return "Folder \""..params[1].."\" does not exist."
				end
			end
		end
		return "cd <folder>"
	end
})

computers.terminal.register_command("file",{
	run = function(params,meta)
		if not(#params > 1) then
			return
		end
		if not(computers.terminal.instances[meta.player_name]) then
			return "Error terminal not found"
		end
		local path = computers.terminal.instances[meta.player_name].path
		local folder = computers.os.get_path(computers.os.instances[meta.os_pos],path)
		if not(folder) then
			return "Could not find folder \"" .. path .. "\""
		end
		if params[1] == "new" then
			folder[params[2]] = ""
			computers.os.set_path(computers.os.instances[meta.os_pos],path,folder)
			return "Created new file \"" .. params[2] .. "\"" 
		elseif params[1] == "set" then
			if not(#params > 2) then
				return "file set <file> <content>"
			end
			folder[params[2]] = params[3]
			computers.os.set_path(computers.os.instances[meta.os_pos],path,folder)
			return "Done" 
		elseif params[1] == "show" then
			return folder[params[2]]
		end

		return "file <mode> <file> (<content>)"
	end
})

computers.terminal.register_command("sound",{
	run = function(params,meta)
		if not(computers.is_connected("computers:speaker",meta.os_pos,meta.os_pos)) then
			return "You need to connect a speaker to your computer to play sounds."
		end
		if not(#params > 0) then
			return "sound <name>"
		end
		local sounds = {}
		local found = false
		for i,v in ipairs(sounds) do
			if v == params[1] then
				found = true
			end
		end

		if not(found) then
			return "sound " .. table.concat(sounds, "/")
		else
			minetest.sound_play(params[1],{
				pos = meta.os_pos
			})
			return "Done"
		end
	end
})
