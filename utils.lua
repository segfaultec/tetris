
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

function math.sign(x)
  if x > 0 then return 1 end
  if x < 0 then return -1 end
  return 0
end

function math.lerp(a, b, t)
  return a+t*(b-a)
end

function math.invlerp(a, b, x)
  if (b-a)==0 then return 0 end
  return (x-a)/(b-a)
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
  print("===")
  print(t)
  if t ~= nil then
    for k, v in pairs(t) do
      print(k, v)
    end
  end
  print("===")
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

function math.mult_scalar(vec, scalar)
  local out = {}
  for i in pairs(vec) do out[i] = vec[i] * scalar end
  return out
end

function random(min, max)
	local min, max = min or 0, max or 1
	return (min > max and (love.math.random()*(min - max) + max)) or (love.math.random()*(max - min) + min)
end

function partrect(x, y, w, h, hidden)
  if not hidden then hidden = {} end
  if not hidden.up    then lg.line(x-1,  y,x+w,  y) end
  if not hidden.right then lg.line(x+w,y-1,x+w,y+h) end
  if not hidden.down  then lg.line(x+w,y+h,x-1,y+h) end
  if not hidden.left  then lg.line(x  ,y+h,  x,y-1) end
end