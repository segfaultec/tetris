
function math.wrap(x, a, b)
    while x > b do x = x - (b-a+1) end
    while x < a do x = x + (b-a+1) end
    return x
end

function math.clamp(x, a, b)
    if x > b then return b end
    if x < a then return a end
    return x
end

function math.isinrange(x, a, b)
    if x > b then return false end
    if x < a then return false end
    return true
end

function table.shallow_copy(t)
  local t2 = {}
  for k,v in pairs(t) do
    t2[k] = v
  end
  setmetatable(t2, getmetatable(t))
  return t2
end

function table.print(t)
  for k, v in pairs(t) do
    print(k, v)
  end
end

function table.print2(t)
  for k, v in pairs(t) do
    print(k)
    table.print(v)
  end
end

---@generic T
---@param class T
---@param obj T | nil
---@return T
function construct(class, obj)
  obj = obj or {}
  setmetatable(obj, {__index = class})
---@diagnostic disable-next-line: undefined-field
  if class.construct ~= nil then class:construct(obj) end
  return obj
end

function bool2str(bool)
  if bool then return "true" else return "false" end
end