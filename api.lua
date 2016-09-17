function computers.os.new()
	return ({
		filesystem = {
			["home"] = {
				["root"] = {
					
				}
			},
			
			["users"] = {
				["root"] = {
					["home"] = "home/root"
				}
			}

			
		},

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
		computers.os.instances[pos].filesystem["users"][name] = {["home"] = "home/"..name}
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
	local cmd2 = ""

	local str = ""
	local is_str = false
	local counter = 1
	string.gsub(cmd, ".", function(v)
		if a == b then
			if not(is_str) then
				if v == "(" then
					if a == b then
						cmd2 = ""
					end
					a = a + 1
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
				if a == b then
					cmd2 = ""
				else
					cmd2 = cmd2 .. v
				end
				a = a + 1
			elseif v == ")" then
				a = a - 1	
				if a == b then
					table.insert(params, computers.terminal.run(cmd2, player_name))
				else
					cmd2 = cmd2 .. v
				end
			else
				cmd2 = cmd2 .. v
			end
		end
	end)

	if not(computers.terminal.commands[name]) then
		return "Command \"" ..name .."\" not found"
	end

	local meta = {
		player_name = player_name,
		os_pos = computers.terminal.instances[player_name].os
	}
	
	return computers.terminal.commands[name].run(params, meta)
end

function computers.get_terminal_formspec(name,pos)
	if not(computers.terminal.instances[name]) then
		computers.terminal.instances[name] = computers.terminal.new(name,pos)
	end

	local s = "size[8,6]"..default.gui_bg..default.gui_bg_img..default.gui_slots
	if computers.is_connected("computers:display",pos,pos) then
		s = s.."label[0,0;".. table.concat(computers.terminal.instances[name].history, "\n") .."]"
	end
	if computers.is_connected("computers:keyboard",pos,pos) then
		s = s.."field[0.3,5.5;7,1;input;Input;]"
		s = s.."button[7,5.2;1,1;btn_run;Run]"
	end
	return s
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname == "computers:terminal" then
		local name = player:get_player_name()
		if fields.btn_run then
			if fields.input then
				table.insert(computers.terminal.instances[name].history,">>> "..fields.input)
				if #computers.terminal.instances[name].history > 10 then
					table.remove(computers.terminal.instances[name].history,1)
				end
				local output = computers.terminal.run(fields.input, name)
				table.insert(computers.terminal.instances[name].history,tostring(output))
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
