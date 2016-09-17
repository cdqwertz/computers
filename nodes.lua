minetest.register_node("computers:computer", {
	description = "Computer",
	tiles = {"computers_computer.png","computers_computer.png", "computers_computer_side.png"},
	groups = {cracky = 1},

	on_rightclick = function(pos, node, player, pointed_thing)
		minetest.show_formspec(player:get_player_name(), "computers:terminal", computers.get_terminal_formspec(player:get_player_name(),pos))
	end
})

minetest.register_node("computers:display", {
	description = "Display",
	tiles = {"computers_computer.png","computers_computer.png", "computers_computer.png","computers_computer.png","computers_computer.png", "computers_display.png"},
	paramtype2 = "facedir",	
	groups = {cracky = 1},
})

minetest.register_node("computers:speaker", {
	description = "Speaker",
	tiles = {"computers_computer.png","computers_computer.png", "computers_computer.png","computers_computer.png","computers_computer.png", "computers_speaker.png"},
	paramtype2 = "facedir",	
	groups = {cracky = 1},
})

local chest_formspec = "size[8,11]"
local chest_formspec = chest_formspec .. default.gui_bg
local chest_formspec = chest_formspec .. default.gui_bg_img
local chest_formspec = chest_formspec .. default.gui_slots
local chest_formspec = chest_formspec .. "list[current_name;main;0,0.3;8,6;]"
local chest_formspec = chest_formspec .. "list[current_player;main;0,6.85;8,1;]"
local chest_formspec = chest_formspec .. "list[current_player;main;0,8.08;8,3;8]"
local chest_formspec = chest_formspec .. "listring[current_name;main]"
local chest_formspec = chest_formspec .. "listring[current_player;main]"
local chest_formspec = chest_formspec .. default.get_hotbar_bg(0,6.85)

minetest.register_node("computers:chest", {
	description = "Chest",
	tiles = {"computers_computer.png","computers_computer.png", "computers_computer.png","computers_computer.png","computers_computer.png", "computers_chest.png"},
	paramtype2 = "facedir",	
	groups = {cracky = 1},

	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec", chest_formspec)
		local inv = meta:get_inventory()
		inv:set_size("main", 8*6)
	end,
	can_dig = function(pos,player)
		local meta = minetest.get_meta(pos);
		local inv = meta:get_inventory()
		return inv:is_empty("main")
	end,
})

minetest.register_node("computers:keyboard", {
	description = "Keyboard",
	tiles = {"computers_keyboard.png","computers_computer.png"},
	groups = {cracky = 1},

	paramtype = "light",	
	paramtype2 = "facedir",	
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -3/16, 0.5, -6/16, 0.5}
		},
	},
})

minetest.register_node("computers:power_cable", {
	description = "Power Cable",
	tiles = {"computers_power_cable.png"},
	groups = {cracky = 1},

	paramtype = "light",
	drawtype = "nodebox",
	node_box = {
		type = "connected",
		fixed = {{-2/16, -2/16, -2/16, 2/16, 2/16, 2/16},},
		
		connect_back = {{-2/16, -2/16, -2/16, 2/16, 2/16, 0.5}},
		connect_left = {{-0.5, -2/16, -2/16, 2/16, 2/16, 2/16}},
		connect_front = {{-2/16, -2/16, -0.5, 2/16, 2/16, 2/16}},
		connect_right = {{-2/16, -2/16, -2/16, 0.5, 2/16, 2/16}},
		connect_top = {{-2/16, -2/16, -2/16, 2/16, 0.5, 2/16}},
		connect_bottom = {{-2/16, -0.5, -2/16, 2/16, 2/16, 2/16}},
	},
	connects_to = {"computers:power_cable","computers:computer","computers:display"},
})

minetest.register_node("computers:io_cable", {
	description = "IO Cable",
	tiles = {"computers_io_cable.png"},
	groups = {cracky = 1},

	paramtype = "light",
	drawtype = "nodebox",
	node_box = {
		type = "connected",
		fixed = {{-2/16, -2/16, -2/16, 2/16, 2/16, 2/16},},
		
		connect_back = {{-2/16, -2/16, -2/16, 2/16, 2/16, 0.5}},
		connect_left = {{-0.5, -2/16, -2/16, 2/16, 2/16, 2/16}},
		connect_front = {{-2/16, -2/16, -0.5, 2/16, 2/16, 2/16}},
		connect_right = {{-2/16, -2/16, -2/16, 0.5, 2/16, 2/16}},
		connect_top = {{-2/16, -2/16, -2/16, 2/16, 0.5, 2/16}},
		connect_bottom = {{-2/16, -0.5, -2/16, 2/16, 2/16, 2/16}},
	},
	connects_to = {"computers:io_cable","computers:computer","computers:display","computers:keyboard","computers:speaker","computers:chest"},
})

minetest.register_node("computers:network_cable", {
	description = "Network Cable",
	tiles = {"computers_network_cable.png"},
	groups = {cracky = 1},

	paramtype = "light",
	drawtype = "nodebox",
	node_box = {
		type = "connected",
		fixed = {{-2/16, -2/16, -2/16, 2/16, 2/16, 2/16},},
		
		connect_back = {{-2/16, -2/16, -2/16, 2/16, 2/16, 0.5}},
		connect_left = {{-0.5, -2/16, -2/16, 2/16, 2/16, 2/16}},
		connect_front = {{-2/16, -2/16, -0.5, 2/16, 2/16, 2/16}},
		connect_right = {{-2/16, -2/16, -2/16, 0.5, 2/16, 2/16}},
		connect_top = {{-2/16, -2/16, -2/16, 2/16, 0.5, 2/16}},
		connect_bottom = {{-2/16, -0.5, -2/16, 2/16, 2/16, 2/16}},
	},
	connects_to = {"computers:computer","computers:network_cable"},
})
