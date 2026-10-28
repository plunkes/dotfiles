--- Enter: go into directories, open files. From yazi-rs/plugins (smart-enter).
--- @sync entry
return {
	entry = function()
		local h = cx.active.current.hovered
		ya.emit(h and h.cha.is_dir and "enter" or "open", { hovered = true })
	end,
}
