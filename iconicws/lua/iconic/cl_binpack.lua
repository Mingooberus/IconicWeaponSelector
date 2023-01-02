local rect_mt = {}
function rect_mt.__eq(a, b)
  return a.x == b.x and a.y == b.y and a.w == b.w and a.h == b.h
end
function rect_mt.__index(rect, key)
  return rect_mt[key] or (rect_mt['get_' .. key] and rect_mt['get_' .. key](rect) or nil)
end
function rect_mt.clone(self)
  local nr = {x = self.x, y = self.y, w = self.w, h = self.h}
  setmetatable(nr, rect_mt)
  return nr
end
function rect_mt.contains(self, r)
  return r.x >= self.x and r.y >= self.y and r.right <= self.right and r.bottom <= self.bottom
end
function rect_mt.empty(self)
  return self.w == 0 or self.h == 0
end
function rect_mt.get_right(self)
  return self.x + self.w
end
function rect_mt.get_bottom(self)
  return self.y + self.h
end
function rect_mt.get_width(self) return self.w end
function rect_mt.get_height(self) return self.h end
function rect_mt.get_left(self) return self.x end
function rect_mt.get_top(self) return self.y end

local function new_rect(x, y, w, h)
  local rect = {x = x or 0, y = y or 0, w = w or 0, h = h or 0}
  setmetatable(rect, rect_mt)
  return rect
end

local binpacker_insert_prelude = function(self,w,h)
  w = math.ceil(w)
  h = math.ceil(h)
  return w, h, math.huge
end

local binpacker_funcs = {
  clear = function(self, w, h)
    self.freelist = {new_rect(0, 0, math.floor(w), math.floor(h))}
  end,
  insert = function(self, w, h)
    local maxvalue
    w, h, maxvalue = binpacker_insert_prelude(self, w, h)

    local bestNode = new_rect()
    local bestShortFit = maxvalue
    local bestLongFit = maxvalue

    local count = #self.freelist
    for i = 1,count do
      local rect = self.freelist[i]

      if not (rect.w < w or rect.h < h) then
        local leftoverX = math.abs(rect.w - w)
        local leftoverY = math.abs(rect.h - h)
        local shortFit = math.min(leftoverX, leftoverY)
        local longFit = math.max(leftoverX, leftoverY)

        if shortFit < bestShortFit or (shortFit == bestShortFit and longFit < bestLongFit) then
          bestNode.x = rect.x
          bestNode.y = rect.y
          bestNode.w = w
          bestNode.h = h
          bestShortFit = shortFit
          bestLongFit = longFit
        end
      end
    end

    if bestNode.h == 0 then return nil end

    local i = 1
    while i <= count do
      if self:_splitFreeNode(self.freelist[i], bestNode) then
        table.remove(self.freelist, i)
        i = i - 1
        count = count - 1
      end
      i = i + 1
    end

    i = 1
    while i <= #self.freelist do
      local j = i + 1
      while j <= #self.freelist do
        local idata = self.freelist[i]
        local jdata = self.freelist[j]
        if jdata:contains(idata) then
          table.remove(self.freelist, i)
          i = i - 1
          break
        end

        if idata:contains(jdata) then
          table.remove(self.freelist, j)
          j = j - 1
        end
        j = j + 1
      end
      i = i + 1
    end

    return bestNode.w > 0 and bestNode or nil
  end,
  _splitFreeNode = function(self, freeNode, usedNode)
    local insideX = usedNode.x < freeNode.right and usedNode.right > freeNode.x
    local insideY = usedNode.y < freeNode.bottom and usedNode.bottom > freeNode.y
    if not insideX or not insideY then return false end

    if insideX then
      if usedNode.y > freeNode.y and usedNode.y < freeNode.bottom then
        local newNode = freeNode:clone()
        newNode.h = usedNode.y - newNode.y
        self.freelist[#self.freelist + 1] = newNode
      end

      if usedNode.bottom < freeNode.bottom then
        local newNode = freeNode:clone()
        newNode.y = usedNode.bottom
        newNode.h = freeNode.bottom - usedNode.bottom
        self.freelist[#self.freelist + 1] = newNode
      end
    end

    if insideY then
      if usedNode.x > freeNode.x and usedNode.x < freeNode.right then
        local newNode = freeNode:clone()
        newNode.w = usedNode.x - newNode.x
        self.freelist[#self.freelist + 1] = newNode
      end

      if usedNode.right < freeNode.right then
        local newNode = freeNode:clone()
        newNode.x = usedNode.right
        newNode.w = freeNode.right - usedNode.right
        self.freelist[#self.freelist + 1] = newNode
      end
    end

    return true
  end
}

local binpacker_mt = {__index = binpacker_funcs}

local function binpacker_new(w, h)
  if not w or not h then error('Must provide w, h to binpack new') end
  local binpacker = {freelist = {new_rect(0, 0, math.floor(w), math.floor(h))}}
  setmetatable(binpacker, binpacker_mt)
  return binpacker
end

return binpacker_new
