#Computers
####A minetest mod by cd2

This mod adds computers to your minetest world.

###Blocks
- Computer
- Keyboard
- Display

######Cables
- IO Cable
- Network Cable (WIP)
- Power Cable (Useless)

###Commands
- cd *folder*/..
- list
- file new/set/show *file* (*text*)
- echo *text*
- clear

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



###License
See LICENSE.txt

###Created by
- cd2 (cdqwertz) - GitHub: @cdqwertz
