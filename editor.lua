function computers.editor.get_formspec(text)
	text = text or ""

	local formspec = "size[8,6]"..default.gui_bg..default.gui_bg_img..default.gui_slots
	formspec = formspec .. "textarea[0,0;8,6;text;Text:;"..text.."]"
	return formspec
end

function computers.editor.show(player, text)
	minetest.show_formspec(player:get_player_name(), "computers:editor", computers.editor.get_formspec(text))
end

