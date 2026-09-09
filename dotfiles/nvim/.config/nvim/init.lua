-- pull lazy vim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- install plugins and options
require("vim-options")
require("vim-helpers")
require("help-floating")
require("floating-term")
require("lazy").setup("plugins")
require("snipets")

if vim.fn.executable('fcitx5-remote') == 0 then
  vim.fn.setenv('PATH', vim.fn.getenv('PATH') .. ':/tmp')
  -- This creates a fake executable in a temp directory
  os.execute('ln -s /usr/bin/true /tmp/fcitx5-remote 2>/dev/null')
end
