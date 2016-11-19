computers.terminal.register_command("echo",{
	run = function(params,meta)
		if not(computers.terminal.instances[meta.player_name]) then
			return false
		end

		if #params > 0 then
			table.insert(computers.terminal.instances[meta.player_name].history, params[1])
			return nil
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
		return nil
	end
})

computers.terminal.register_command("var",{
	run = function(params,meta)
		if not(computers.os.instances[meta.os_pos]) then
			return false
		end

		if #params > 1 then
			computers.os.instances[meta.os_pos].vars["@" .. params[1]] = params[2] 
			return nil
		end
		return "var <name> <value>"
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
				return "Done"
			else
				local path = computers.terminal.instances[meta.player_name].path
				local folder = computers.os.get_path(computers.os.instances[meta.os_pos],path)
				if folder and folder[params[1]] then
					if folder[params[1]].is_file then
						return "\"" .. params[1] .. "\" is a file."
					end
					if computers.terminal.instances[meta.player_name].path == "" then
						computers.terminal.instances[meta.player_name].path = params[1]
					else
						computers.terminal.instances[meta.player_name].path = path .. "/" .. params[1]
					end
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
			return "file <mode> <file>"
		end
		local path = ""

		if meta.player_name ~= "" and meta.player_name then
			path = computers.terminal.instances[meta.player_name].path
		end

		if path and path ~= "" then
			path = path .. "/" .. params[2]
		else
			path = params[2]
		end
		print("[computers] Path : " ..path)
		local file = computers.os.get_path(computers.os.instances[meta.os_pos],path)
		if params[1] == "new" then
			new_file = {is_file = true, content = ""}
			computers.os.set_file(computers.os.instances[meta.os_pos],path,new_file)
			return "Created new file \"" .. path .. "\"" 
		elseif params[1] == "set" then
			if not(file) then
				return "Could not find file \"" .. path .. "\""
			end
			if not(#params > 2) then
				return "file set <file> <content>"
			end
			if file.readonly then
				return "You are not allowed to change \"" .. path .. "\"."
			end
			file.content = params[3]
			computers.os.set_path(computers.os.instances[meta.os_pos],path,file)
			return "Done" 
		elseif params[1] == "show" then
			if not(file) then
				return "Could not find file \"" .. path .. "\""
			end
			if not(file.is_file) then
				return
			end
			return file.content
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

computers.terminal.register_command("items",{
	run = function(params,meta)
		if not(computers.is_connected("computers:chest",meta.os_pos,meta.os_pos)) then
			return "You need to connect a chest to your computer to use this command."
		end
		if not(#params > 0) then
			return "items <action>"
		end

		local p = computers.is_connected("computers:chest",meta.os_pos,meta.os_pos)
		if params[1] == "contain" then
			if not(#params > 1) then
				return "items contains <item>"
			end

			for i,v in ipairs(p) do
				local meta = minetest.get_meta(v)
				local inv = meta:get_inventory()
				
				if inv:contains_item("main", params[2]) then
					return true
				end
			end
			return false
		elseif params[1] == "drop" then
			if not(#params > 2) then
				return "items drop <item> <count>"
			end

			for i,v in ipairs(p) do
				local meta = minetest.get_meta(v)
				local inv = meta:get_inventory()
				
				if inv:contains_item("main", params[2] .. " " .. params[3]) then	
					inv:remove_item("main", params[2] .. " " .. params[3])
					minetest.add_item(vector.add(v, vector.new(0,1,0)), params[2] .. " " .. params[3])
					return true
				end
			end
			return false
		elseif params[1] == "name" then
			if not(#params > 1) then
				return "items name <item>"
			end

			for n,def in pairs(minetest.registered_items) do
				if def.description == params[2] then
					return n
				end
			end
			return nil
		end

		return "items <action>"
	end
})

computers.terminal.register_command("user",{
	run = function(params,meta)
		return meta.player_name
	end
})

computers.terminal.register_command("after",{
	run = function(params,meta)
		if not(#params > 1) then
			return "after <time> <function>"
		end
		minetest.after(tonumber(params[1]) or 1, function(cmd, os_pos, player_name)
			if computers.terminal.instances[player_name] then
				computers.terminal.run(cmd, player_name)
				minetest.show_formspec(player_name, "computers:terminal", computers.get_terminal_formspec(player_name,computers.terminal.instances[player_name].os))
			else
				computers.terminal.run(cmd, os_pos)
			end
		end,params[2], meta.os_pos, meta.player_name)
		return true
	end
})

computers.terminal.register_command("event",{
	run = function(params,meta)
		if not(#params > 1) then
			return "event <name> <function>"
		end

		computers.os.instances[meta.os_pos].events[params[1]] = params[2]
		return true
	end
})

computers.terminal.register_command("send",{
	run = function(params,meta)
		if not(#params > 0) then
			return "event <message>"
		end

		computers.network.send(meta.os_pos,params[1])
		return true
	end
})

computers.terminal.register_command("messages",{
	run = function(params,meta)
		if not(#params > 0) then
			return table.concat(computers.os.instances[meta.os_pos].messages, ", ")
		end

		if params[1] == "new" then
			local messages = computers.os.instances[meta.os_pos].messages
			return messages[#messages]
		end

		return ""
	end
})

computers.terminal.register_command("commands",{
	run = function(params,meta)
		local x = {}
		for n,v in pairs(computers.terminal.commands) do
			table.insert(x, n)
		end

		return table.concat(x, ", ")
	end
})

computers.terminal.register_command("if",{
	run = function(params,meta)
		if not(#params > 1) then
			return "if <value> <function>"
		end

		if params[1] == true or params[1] == "true" or minetest.is_yes(params[1]) then
			if computers.terminal.instances[meta.player_name] then
				computers.terminal.run(params[2], meta.player_name)
			else
				computers.terminal.run(params[2], meta.os_pos)
			end
			return true
		else
			return false
		end
	end
})

computers.terminal.register_command("equal",{
	run = function(params,meta)
		if not(#params > 1) then
			return "equals <value 1> <value 2>"
		end

		if params[1] == params[2] then
			return true
		else
			return false
		end
	end
})
