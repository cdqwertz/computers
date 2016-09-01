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
	connects_to = {"computers:io_cable","computers:computer","computers:display","computers:keyboard"},
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
