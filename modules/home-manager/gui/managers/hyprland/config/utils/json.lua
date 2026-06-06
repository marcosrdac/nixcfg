local M = {}

local function json_escape(s)
  return '"' .. s
    :gsub('\\', '\\\\')
    :gsub('"', '\\"')
    :gsub('\n', '\\n')
    :gsub('\r', '\\r')
    :gsub('\t', '\\t') .. '"'
end

local function is_array(t)
  local n = 0

  for k, _ in pairs(t) do
    if type(k) ~= "number" then
      return false
    end
    if k > n then
      n = k
    end
  end

  for i = 1, n do
    if t[i] == nil then
      return false
    end
  end

  return true
end

function M.encode(v)
  local tv = type(v)

  if tv == "string" then
    return json_escape(v)

  elseif tv == "number" or tv == "boolean" then
    return tostring(v)

  elseif tv == "table" then
    local out = {}

    if is_array(v) then
      for i = 1, #v do
        out[#out + 1] = M.encode(v[i])
      end
      return "[" .. table.concat(out, ",") .. "]"
    end

    for k, val in pairs(v) do
      if type(k) ~= "string" then
        error("json object keys must be strings")
      end
      out[#out + 1] = json_escape(k) .. ":" .. M.encode(val)
    end

    return "{" .. table.concat(out, ",") .. "}"

  elseif tv == "nil" then
    return "null"

  else
    error("unsupported json type: " .. tv)
  end
end

return M
