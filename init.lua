computers = {}
computers.os = {}
computers.os.instances = {}
computers.terminal = {}
computers.terminal.instances = {}
computers.terminal.commands = {}

local modpath = minetest.get_modpath("computers")
dofile(modpath.."/api.lua")
dofile(modpath.."/commands.lua")
dofile(modpath.."/nodes.lua")
