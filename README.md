#Computers
####A minetest mod by cd2

This mod adds computers to your minetest world.

###Blocks
- Computer
- Keyboard
- Display
- Speaker

######Cables
- IO Cable
- Network Cable (WIP)
- Power Cable (Useless)

###Commands
- commands
- cd *folder*/..
- list
- file new/set/show *file* (*text*)
- echo *text*
- clear
- sound *name*
- user
- items contain/drop *item* *count*
- after *time* *function*

######Strings

```
"I am a string!"
```

######Functions

```
{echo "hi"}
```

###API
If you want to register a new command, you should use this function:
```lua
computers.terminal.register_command(name,def)
```
- name : the commands name

```lua
computers.terminal.register_command("test",{
	run = function(params,meta)
		return "test"
	end
})
```

######params

```lua
computers.terminal.register_command("test",{
	run = function(params,meta)
		return params[1]
	end
})
```

######meta

```lua
computers.terminal.register_command("user",{
	run = function(params,meta)
		return meta.player_name
	end
})
```

###License
See LICENSE.txt

###Created by
- cd2 (cdqwertz) - GitHub: @cdqwertz
