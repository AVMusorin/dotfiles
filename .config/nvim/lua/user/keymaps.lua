local opts = { noremap = true, silent = true }

local term_opts = { silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap

-- Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- File explorer
keymap("n", "<leader>e", ":Lex 30<cr>", opts)

-- Resize with arrows
keymap("n", "<C-Up>", ":resize -2<CR>", opts)
keymap("n", "<C-Down>", ":resize +2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize +2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize -2<CR>", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)
-- NOTE: important to return to any buffer manually, otherwise with several opened windows
--       active window will be switched
keymap("n", "<leader>bc", ":bdelete<CR> <BAR> :bprevious<CR>", opts) -- close current buffer
keymap("n", "<leader>bp", ":b#<CR>", opts) -- toggle between the last two buffers

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move text up and down
keymap("v", "<A-j>", ":m '>+1<CR>gv=gv", opts)
keymap("v", "<A-k>", ":m '<-2<CR>gv=gv", opts)
keymap("i", "<A-j>", "<Esc>:m .+1<CR>==gi", opts)
keymap("i", "<A-k>", "<Esc>:m .-2<CR>==gi", opts)

-- Do not replace yanked text after past
keymap("v", "p", '"_dP', opts)

keymap("n", "<leader>ff", "<cmd>lua require'telescope.builtin'.find_files(require('telescope.themes').get_dropdown({ previewer = false }))<CR>", opts)
keymap("n", "<leader>fg", "<cmd>lua require'telescope.builtin'.git_files()<CR>", opts)
keymap("n", "<leader>fw", "<cmd>lua require'search'.open({ tab_name = 'Grep' })<CR>", opts)
keymap("n", "<leader>fb", "<cmd>lua require'telescope.builtin'.buffers()<CR>", opts)
keymap("n", "<leader>fh", "<cmd>lua require'telescope.builtin'.help_tags()<CR>", opts)
keymap('n', '<leader>fr', "<cmd>lua require('telescope.builtin').oldfiles()<CR>", opts)


-- Terminal --
-- Better terminal navigation
keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)

-- Nvimtree
keymap("n", "<leader>e", ":NvimTreeToggle<cr>", opts)

-- Lazygit
keymap("n", "<leader>gg", ":LazyGit<CR>", opts)

-- Spell checking
keymap("n", "<leader>ss", ":set spell!<CR>", opts)

-- Nvim spectre replacing tool
keymap("n", '<leader>S', '<cmd>lua require("spectre").open_file_search()<CR>', opts)
keymap("n", '<leader>sw', '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', opts)
keymap("v", '<leader>sw', '<esc><cmd>lua require("spectre").open_file_search({select_word=true})<CR>', opts)
