local str = require("utils.str")
local json = require("utils.json")

local M = {}

local hl = assert(hl, "utils.bindings: global hl is missing")

function M.cat_keys(s)
  return (s:gsub("%s*%+%s*", " + "):gsub("%s+", " + "))
end

local function split_flags(flags)
  local out = {}

  if type(flags) ~= "string" then
    return out
  end

  for flag in flags:gmatch("[^:%s]+") do
    out[#out + 1] = flag:upper()
  end

  return out
end

local function bind_opts(flags)
  if flags == nil then
    return {}
  end

  if type(flags) == "table" then
    return flags
  end

  local opts = {}

  for _, flag in ipairs(split_flags(flags)) do
    if flag == "MOUSE" then
      opts.mouse = true

    elseif flag == "HOLD" or flag == "HOLDS" or flag == "REPEAT" or flag == "REPEATING" then
      opts.repeating = true

    elseif flag == "LOCK" or flag == "LOCKED" or flag == "SAFE" then
      opts.locked = true

    elseif flag == "PRESS" or flag == "CLICK" then
      opts.click = true
      opts.release = false

    elseif flag ~= "" then
      error("unknown bind option: " .. flag)
    end
  end

  return opts
end

local function is_empty_table(t)
  return type(t) == "table" and next(t) == nil
end

local function normalize_seq_tree(tree)
  if type(tree) ~= "table" then
    return nil
  end

  local out = {}

  for key, value in pairs(tree) do
    if type(key) == "string" then
      if type(value) == "string" then
        out[key] = value

      elseif type(value) == "table" then
        local child = normalize_seq_tree(value)

        if child and not is_empty_table(child) then
          out[key] = child
        end
      end
    end
  end

  if is_empty_table(out) then
    return nil
  end

  return out
end

local function collect_tree_keys(tree, out, seen)
  out = out or {}
  seen = seen or {}

  if type(tree) ~= "table" then
    return out
  end

  for key, value in pairs(tree) do
    if type(key) == "string" and not seen[key] then
      out[#out + 1] = key
      seen[key] = true
    end

    if type(value) == "table" then
      collect_tree_keys(value, out, seen)
    end
  end

  return out
end

local function append_keys(out, keys)
  local seen = {}

  for _, key in ipairs(out or {}) do
    seen[key] = true
  end

  for _, key in ipairs(keys or {}) do
    if not seen[key] then
      out[#out + 1] = key
      seen[key] = true
    end
  end

  return out
end

function M.cmd(k, dispatcher, opts)
  opts = bind_opts(opts)

  if type(k) == "table" then
    for _, key in ipairs(k) do
      hl.bind(M.cat_keys(key), dispatcher, opts)
    end
  else
    hl.bind(M.cat_keys(k), dispatcher, opts)
  end
end

function M.exe(k, cmd, opts)
  M.cmd(k, hl.dsp.exec_cmd(cmd), opts)
end

function M.shl(k, cmd, opts)
  M.exe(k, "sh -c " .. str.quote(cmd), opts)
end

local script = "bindseq.sh"
local submap = "seq"
local timeout_default = 2
local catchall = true

local registered_seq_keys = {}

local function bind_seq_key(key)
  if registered_seq_keys[key] then
    return
  end

  hl.define_submap(submap, function()
    M.shl(key, str.quote(script) .. " key " .. str.quote(key))
  end)

  registered_seq_keys[key] = true
end

local function bind_seq_keys(keys)
  for _, key in ipairs(keys or {}) do
    bind_seq_key(key)
  end
end

hl.define_submap(submap, function()
  M.shl("escape", str.quote(script) .. " cancel")
end)

function M.seq(k, tree, opts)
  opts = opts or {}

  local normalized = normalize_seq_tree(tree)

  if not normalized then
    return
  end

  local seq_keys = collect_tree_keys(normalized)
  append_keys(seq_keys, opts.extra_keys)
  bind_seq_keys(seq_keys)

  local timeout = opts.timeout or timeout_default
  local initial_bind_opts = opts.bind or opts.opts

  local ok, encoded = pcall(json.encode, normalized)

  if not ok then
    M.shl(k, "notify-send 'json_encode failed'")
    return
  end

  M.shl(
    k,
    "SEQ_TIMEOUT=" .. tostring(timeout) ..
    " SEQ_SUBMAP=" .. str.quote(submap) ..
    " " .. str.quote(script) ..
    " start " .. str.quote(encoded),
    initial_bind_opts
  )
end

return M
