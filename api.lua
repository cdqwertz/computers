function computers.os.new()
	return ({
		filesystem = {
			["home"] = {
			},
			
			["users"] = {
			}
		},

		messages = {},
		events = {},

		info = {
			system_name = "?",
			system_version = "0.0.0",
			system_author = "cdqwertz"
		}
	})
end

function computers.os.get_path(os,path)
	local output = os.filesystem
	for i,v in ipairs(path:split("/")) do
		output = output[v]
	end
	return output
end

function computers.os.set_path(os,path,x)
	local output = os.filesystem
	for i,v in ipairs(path:split("/")) do
		output = output[v]
	end
	output = x
	return output
end

function computers.os.set_file(os,path,file)
	local output = os.filesystem
	local file_name = path:split("/")[#path:split("/")]
	for i,v in ipairs(path:split("/")) do
		if i == #path:split("/") then
			break
		end
		output = output[v]
	end
	output[file_name] = file
	return output
end

function computers.os.trigger_event(os,pos,event)
	if not(os) then
		return
	end

	if not(event) or not(os.events[event]) then
		return
	end

	return computers.terminal.run(os.events[event], pos)
end

function computers.terminal.new(name,pos)
	do
		local found = false
		for p,v in pairs(computers.os.instances) do
			if vector.equals(pos,p) then
				found = true
				pos = p
			end
		end
		if not(found) then
			computers.os.instances[pos] = computers.os.new()
		end
	end

	if not(computers.os.instances[pos].filesystem["home"][name]) then
		computers.os.instances[pos].filesystem["home"][name] = {}
		computers.os.instances[pos].filesystem["users"][name] = {["home"] = {is_file = true, readonly = true, content = "home/"..name}}
	end

	return({
		user = name,
		path = "home",
		history = {},
	
		os = pos,
	})
end

function computers.terminal.register_command(name,def)
	computers.terminal.commands[name] = def
end

function computers.terminal.run(cmd, player_name)
	if not(cmd) then
		return
	end

	cmd = cmd .. " "

	local name = ""
	local params = {}

	local a = 1
	local b = 1
	local c = 1
	local cmd2 = ""

	local str = ""
	local is_str = false
	local counter = 1
	string.gsub(cmd, ".", function(v)
		if c == 1 then
			if b == 1 then
				if a == 1 then
					if not(is_str) then
						if v == "(" then
							if a == 1 then
								cmd2 = ""
							end
							a = a + 1
						elseif v == "{" then
							b = b + 1
							str = ""
						elseif v == "\"" then
							is_str = true
						elseif v == " " then
							if counter == 1 then
								name = str
								str = ""
								counter = counter + 1
							else
								if (str ~= "") then
									table.insert(params, str)
									str = ""
									counter = counter + 1
								end
							end
						elseif v == ";" then
							if counter == 1 then
								name = str
								str = ""
								counter = counter + 1
							else
								if (str ~= "") then
									table.insert(params, str)
									str = ""
									counter = counter + 1
								end
							end

							c = 2
							str = ""
						else
							str = str..v
						end
					else
						if v == "\"" then
							is_str = false
						else
							str = str..v
						end
					end
				else
					if v == "(" then
						if a == 1 then
							cmd2 = ""
						else
							cmd2 = cmd2 .. v
						end
						a = a + 1
					elseif v == ")" then
						a = a - 1	
						if a == 1 then
							table.insert(params, computers.terminal.run(cmd2, player_name))
						else
							cmd2 = cmd2 .. v
						end
					else
						cmd2 = cmd2 .. v
					end
				end
			else
				if v == "{" then
					if b == 1 then
						str = " "
					else
						str = str .. v
					end
					b = b +1
				elseif v == "}" then
					b = b -1
					if b == 1 then
						table.insert(params, str)
						str = ""
					else
						str = str .. v
					end
				else
					str = str .. v
				end
			end
		else
			str = str .. v
		end
	end)

	if not(computers.terminal.commands[name]) then
		return "Command \"" ..name .."\" not found"
	end

	local meta = {}

	if player_name.x or player_name.y or player_name.z then
		meta = {
			player_name = "",
			os_pos = player_name
		}
	else
		meta = {
			player_name = player_name,
			os_pos = computers.terminal.instances[player_name].os
		}
	end
	
	local output = computers.terminal.commands[name].run(params, meta)

	print("[computers] run command : " .. name .. " Output : " .. tostring(output))

	if c ~= 1 then
		return computers.terminal.run(string.trim(str), player_name)
	else
		return output
	end
end

function computers.get_terminal_formspec(name,pos)
	if not(computers.terminal.instances[name]) then
		computers.terminal.instances[name] = computers.terminal.new(name,pos)
	end

	local s = "size[8,6]"..default.gui_bg..default.gui_bg_img..default.gui_slots
	if computers.is_connected("computers:display",pos,pos) then
		s = s.."label[0,0;".. minetest.formspec_escape(table.concat(computers.terminal.instances[name].history, "\n")) .."]"
	end
	if computers.is_connected("computers:keyboard",pos,pos) then
		s = s.."field[0.3,5.5;7,1;input;Input;;false]"
		s = s.."button[7,5.2;1,1;btn_run;Run]"
	end
	return s
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname == "computers:terminal" then
		local name = player:get_player_name()
		if fields.btn_run or fields.key_enter_field == "input" then
			if fields.input then
				table.insert(computers.terminal.instances[name].history,">>> "..fields.input)
				local output = computers.terminal.run(fields.input, name)
				if output ~= nil then
					table.insert(computers.terminal.instances[name].history,tostring(output))
				end
				while #computers.terminal.instances[name].history > 12 do
					table.remove(computers.terminal.instances[name].history,1)
				end
			end
			minetest.show_formspec(name, "computers:terminal", computers.get_terminal_formspec(name,computers.terminal.instances[name].os))
		elseif fields.quit then
			computers.terminal.instances[name] = nil
		end
	end
end)

function computers.is_connected(block,pos,from)
	local dirs = {
		vector.new(1,0,0),
		vector.new(-1,0,0),

		vector.new(0,1,0),
		vector.new(0,-1,0),

		vector.new(0,0,1),
		vector.new(0,0,-1),
	}

	local found = false
	local out = {}
	for i,v in ipairs(dirs) do
		if not(vector.equals(vector.add(v,pos),from)) then
			local name = minetest.get_node(vector.add(v,pos)).name
			if name == block then
				table.insert(out,vector.add(v,pos))
				found = true
			elseif name == "computers:io_cable" then
				if computers.is_connected(block,vector.add(v,pos),pos) then
					local p = computers.is_connected(block,vector.add(v,pos),pos)
					for i,v in ipairs(p) do
						table.insert(out,v)
					end
					found = true
				end
			end
		end
	end

	if found then
		return out
	end

	return nil
end

function computers.network.get_computers(pos,from)
	local dirs = {
		vector.new(1,0,0),
		vector.new(-1,0,0),

		vector.new(0,1,0),
		vector.new(0,-1,0),

		vector.new(0,0,1),
		vector.new(0,0,-1),
	}

	local found = false
	local out = {}
	for i,v in ipairs(dirs) do
		if not(vector.equals(vector.add(v,pos),from)) then
			local name = minetest.get_node(vector.add(v,pos)).name
			if name == "computers:computer" then
				local add_item = true

				for _,v2 in ipairs(out) do
					if vector.equals(vector.add(v,pos), v2) then
						add_item = false
						break
					end
				end
				
				if add_item then
					table.insert(out,vector.add(v,pos))
				end

				found = true
			elseif name == "computers:network_cable" then
				if computers.network.get_computers(vector.add(v,pos),pos) then
					local p = computers.network.get_computers(vector.add(v,pos),pos)
					for i,v in ipairs(p) do
						table.insert(out,v)
					end
					found = true
				end
			end
		end
	end

	if found then
		return out
	end

	return nil
end

function computers.network.send(pos,msg)
	local clients = computers.network.get_computers(pos,pos)
	for i,v in ipairs(clients) do
		local os = nil
		for p,_ in pairs(computers.os.instances) do
			if vector.equals(v,p) then
				os = p
			end
		end

		if os then
			table.insert(computers.os.instances[os].messages, msg)
			computers.os.trigger_event(computers.os.instances[os],os,"network:new_message")
		end
	end
end
