local M = {}
local TITLE = "Format"

function M.info(msg)  vim.notify(msg, vim.log.levels.INFO,  { title = TITLE }) end
function M.warn(msg)  vim.notify(msg, vim.log.levels.WARN,  { title = TITLE }) end
function M.error(msg) vim.notify(msg, vim.log.levels.ERROR, { title = TITLE }) end

return M
