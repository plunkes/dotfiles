local group = vim.api.nvim_create_augroup("lunkes", { clear = true })
local au = function(event, opts)
  vim.api.nvim_create_autocmd(event, vim.tbl_extend("force", { group = group }, opts))
end

au("TextYankPost", { callback = function() vim.hl.on_yank() end })

-- Reopen files at the last cursor position.
au("BufReadPost", {
  callback = function(ev)
    local mark = vim.api.nvim_buf_get_mark(ev.buf, '"')
    if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(ev.buf) then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Close helper windows with q.
au("FileType", {
  pattern = { "help", "qf", "man", "checkhealth", "lspinfo", "dbout" },
  callback = function(ev)
    vim.bo[ev.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = ev.buf, silent = true })
  end,
})

-- Python, C++, Rust and CMake use 4 spaces.
au("FileType", {
  pattern = { "python", "c", "cpp", "rust", "cmake" },
  callback = function() vim.bo.shiftwidth = 4; vim.bo.tabstop = 4 end,
})

-- ROS launch/package files are XML.
vim.filetype.add({ extension = { launch = "xml", xacro = "xml", urdf = "xml", sdf = "xml" } })
