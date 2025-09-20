-- Disable GUI cursor style
vim.opt.guicursor = ""

-- Enable line numbers
vim.opt.nu = true
-- Enable relative numbering
vim.opt.relativenumber = true

-- Tab = 4 spaces
vim.opt.tabstop = 4
vim.opt.softtabstop = 4

-- Indent = 4 spaces
vim.opt.shiftwidth = 4

-- Insert tabs as spaces
vim.opt.expandtab = true

-- Somewhat smart indentation
vim.opt.smartindent = true

-- No line wrapping
vim.opt.wrap = false

-- Enable undo files (see below)
vim.opt.undofile = true

-- Disable hightlight after search is done
vim.opt.hlsearch = false

-- Enable incremental searches
vim.opt.incsearch = true

-- Enable true color support
vim.opt.termguicolors = true

-- Pad the scroll by 8 lines in y direction
vim.opt.scrolloff = 8

-- Make vim feel smoother for CursorHold event
vim.opt.updatetime = 50

-- Highlight a column
vim.opt.colorcolumn = "80"

-- Enable the sign column
vim.opt.signcolumn = "yes"

-- Better window split borders
vim.opt.fillchars = {
    vert = "│",
    horiz = "─",
    horizup = "┴",
    horizdown = "┬",
    vertleft = "┤",
    vertright = "├",
    verthoriz = "┼",
}

-- Always show window separators
vim.opt.laststatus = 3  -- Global statusline
vim.opt.winbar = "%=%m %f"  -- Simple winbar with modified flag and filename

-- Set netrw options
vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25

-- We will move stap files into centralized directories to avoid clashes
-- but still keep them.
local function ensure_dir_exists(dir)
    local uv = vim.loop
    if not uv.fs_stat(dir) then
        uv.fs_mkdir(dir, 448) -- 448 is decimal for 0o700 permissions
    end
end

local backupdir = os.getenv("HOME") .. "/.vim/backupdir//"
local swapdir = os.getenv("HOME") .. "/.vim/swapdir//"
local undodir = os.getenv("HOME") .. "/.vim/undodir//"

ensure_dir_exists(backupdir)
ensure_dir_exists(swapdir)
ensure_dir_exists(undodir)

vim.opt.backupdir = backupdir
vim.opt.directory = swapdir
vim.opt.undodir = undodir
