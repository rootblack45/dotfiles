local o, fn, cmd = vim.o, vim.fn, vim.cmd

local options = {
    sb = true, -- splitting a window will put the new window below the current one
    spr = true, -- splitting a window will put the new window right of the current one
    tm = 500, -- time in milliseconds to wait for a mapped sequence to complete
    ut = 300, -- faster completion (4000ms default)
    cb = 'unnamedplus', -- always use clipboard for all delete, yank, change, put operation
    swf = false, -- creates a swapfile
    ts = 4, -- number of visual space per TAB
    sts = 4, -- number of spaces in tab when editing
    sw = 4, -- number of spaces to use for autoindent
    et = true, -- expand tab to spaces so that tabs are spaces
    nu = true, -- show line number
    rnu = true, -- show relative line number
    ic = true, -- ignore case in search pattern
    scs = true, -- override the 'ic' option if the search pattern contains upper case characters
    lbr = true, -- break line at predefined characters
    sbr = '↪', -- character to show before the lines that have been soft-wrapped
    wim = 'longest,list,full', -- list all matches and complete till longest common string
    so = 8, -- minimum lines to keep above and below cursor when scrolling
    smd = false, -- showing current mode
    cf = true, -- ask for confirmation when handling unsaved or read-only files
    vb = true, -- use visual bell instead of beeping
    eb = false, -- ring the bell (beep or screen flash) for error messages
    hi = 500, -- the number of command and search history to keep
    aw = true, -- auto-write the file based on some condition
    udf = true, -- presistent undo even after you close a file and re-open it
    ph = 10, -- maximum number of items to show in popup menu
    winbl = 5, -- enables pseudo-transparency for a floating window
    sr = true, -- align indent to next multiple value of shiftwidth
    ve = 'block', -- allow virtual editing in Visual block mode
    tgc = true, -- enable 24-bit RGB color in th TUI
    gcr = 'n-v-c:block-Cursor/lCursor,i-ci-ve:ver25-Cursor2/lCursor2,r-cr:hor20,o:hor20', -- set up cursor color and shape in various mode
    scl = 'auto:2', -- resize to accommodate multiple signs up to the given number (maximum 9)
    wrap = false, -- line wrap
}

-- Ignore certail files and folders when globing
cmd [[set wig+=*.o,*.obj,*.dylib,*.bin,*.dll,*.exe]]
cmd [[set wig+=*/.git/*,*/.svn/*,*/__pycache__/*,*/build/**]]
cmd [[set wig+=*.jpg,*.png,*.jpeg,*.bmp,*.gif,*.tiff,*.svg,*.ico]]
cmd [[set wig+=*.pyc,*.pkl]]
cmd [[set wig+=*.DS_Store]]
cmd [[set wig+=*.aux,*.bbl,*.blg,*.brf,*.fls,*.fdb_latexmk,*.synctex.gz,*.xdv]]
o.wic = true -- ignore file and dir name cases in cmd-completion

-- Set up backup directory and skip backup for patterns in options wildignore
o.bdir = fn.stdpath 'data' .. '/backup//'
o.bsk = o.wig
o.bk = true -- create backup for files
o.bkc = 'yes' -- copy the original file to backupdir and overwrite it

-- Do not show ins-completion-menu message
cmd [[set shm+=c]]

-- Completion behaviour
cmd [[set cot+=menuone]] -- show menu even if there is only one item
cmd [[set cot-=preview]] -- disable the preview window

-- Insert mode keyword completion setting
cmd [[set cpt+=kspell cpt-=w cpt-=b cpt-=u cpt-=t]]

-- Maximum number of suggesstions listed
cmd [[set sps+=9]]

for k, v in pairs(options) do
    o[k] = v
end
