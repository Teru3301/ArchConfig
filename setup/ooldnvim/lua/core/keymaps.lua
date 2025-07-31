local keymap = vim.keymap.set

-- Навигация между вкладками (buffer navigation)
keymap('n', 'gbp', ':BufferPrevious<CR>', { noremap = true, silent = true })  -- gb + p (go buffer previous)
keymap('n', 'gbn', ':BufferNext<CR>', { noremap = true, silent = true })     -- gb + n (go buffer next)
keymap('n', 'gbc', ':BufferClose<CR>', { noremap = true, silent = true })    -- gb + c (go buffer close)

-- Файловый менеджер (NvimTree)
-- keymap('n', 'ft', ':NvimTreeToggle<CR>', { noremap = true, silent = true })  -- f + t (file tree)
vim.api.nvim_set_keymap('n', 'ee', ':NvimTreeToggle<CR>', { noremap = true, silent = true })

-- Git интеграция
keymap('n', 'git', ':LazyGit<CR>', { noremap = true, silent = true })       -- g + i + t (git)

-- Просмотр Markdown
keymap('n', 'gm', ':Glow<CR>', { noremap = true, silent = true })           -- g + m (glow markdown)

-- Комментирование
keymap('n', 'gcc', ':CommentToggle<CR>', { noremap = true, silent = true })  -- g + c + c (comment)
keymap('v', 'gcc', ':CommentToggle<CR>', { noremap = true, silent = true })  -- g + c + c (visual mode comment)

-- Дополнительные удобные комбинации
keymap('n', 'qq', ':q<CR>', { noremap = true, silent = true })             -- q + q (quit)
keymap('n', 'ww', ':w<CR>', { noremap = true, silent = true })              -- w + w (write/save)
keymap('n', 'wq', ':wq<CR>', { noremap = true, silent = true })            -- w + q (write and quit)

-- Поиск по файлу
keymap('n', 'ff', '/', { noremap = true })                                 -- f + f (find)
keymap('n', 'fn', ':nohl<CR>', { noremap = true, silent = true })          -- f + n (find none - clear highlight)
