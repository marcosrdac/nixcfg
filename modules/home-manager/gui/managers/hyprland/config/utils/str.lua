local M = {}

function M.cat_keys(s)
  return (s:gsub("%s*%+%s*", " + "):gsub("%s+", " + "))
end

function M.quote(s)
  return "'" .. s:gsub("'", [['"'"']]) .. "'"
end

return M
