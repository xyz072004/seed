local js = require("js")
package.preload["src.seed"] = package.preload["src.seed"] or function(...)
  local js = require("js")
  local seed = {_VERSION = "0.0.1"}
  local Ref = {}
  Ref["__index"] = Ref
  Ref.get = function(self)
    return self.value
  end
  Ref.set = function(self, value)
    local old_value = self.value
    self["value"] = value
    for _, handler in ipairs(self.listeners) do
      handler(self.value, old_value)
    end
    return nil
  end
  Ref.transform = function(self, transform)
    return self:set(transform(self:get()))
  end
  Ref.subscribe = function(self, handler)
    return table.insert(self.listeners, handler)
  end
  seed.ref = function(value)
    local self = {value = value, listeners = {}}
    return setmetatable(self, Ref)
  end
  local function create_node(tag, attr, children)
    _G.assert((nil ~= children), "Missing argument children on ./src/seed.fnl:28")
    _G.assert((nil ~= attr), "Missing argument attr on ./src/seed.fnl:28")
    _G.assert((nil ~= tag), "Missing argument tag on ./src/seed.fnl:28")
    local element = (js.global.document):createElement(tag)
    for key, value in pairs(attr) do
      if (key == "#") then
        local function _2_()
          value["listeners"][#value.listeners] = nil
          return element:replaceWith(create_node(tag, attr, children))
        end
        value:subscribe(_2_)
      else
        local function _3_()
          local reactive = key
          return (reactive:sub(#reactive) == "#")
        end
        if ((nil ~= key) and _3_()) then
          local reactive = key
          element:setAttribute(reactive:sub(1, (#reactive - 1)), value:get())
          value:subscribe(element:setAttribute(reactive:sub(1, (#reactive - 1)), value:get()))
        elseif true then
          local _ = key
          element[key] = value
        else
        end
      end
    end
    for _, child in ipairs(children) do
      local function _6_()
        local _5_ = type(child)
        if (_5_ == "function") then
          return (js.global.document):createTextNode(child())
        elseif (_5_ == "string") then
          return (js.global.document):createTextNode(child)
        elseif true then
          local _0 = _5_
          return child
        else
          return nil
        end
      end
      element:appendChild(_6_())
    end
    return element
  end
  local function create_element(self, tag)
    _G.assert((nil ~= tag), "Missing argument tag on ./src/seed.fnl:50")
    _G.assert((nil ~= self), "Missing argument self on ./src/seed.fnl:50")
    local function _8_(...)
      local _9_ = {...}
      local function _10_(...)
        local attr = (_9_)[1]
        local children = {select(2, (table.unpack or _G.unpack)(_9_))}
        return (type(attr) == "table")
      end
      if (((_G.type(_9_) == "table") and (nil ~= (_9_)[1])) and _10_(...)) then
        local attr = (_9_)[1]
        local children = {select(2, (table.unpack or _G.unpack)(_9_))}
        return create_node(tag, attr, children)
      else
        local function _11_(...)
          local attr = (_9_)[1]
          return (type(attr) == "table")
        end
        if (((_G.type(_9_) == "table") and (nil ~= (_9_)[1])) and _11_(...)) then
          local attr = (_9_)[1]
          return create_node(tag, attr, {})
        elseif true then
          local _ = _9_
          return create_node(tag, {}, {...})
        else
          return nil
        end
      end
    end
    return _8_
  end
  return setmetatable(seed, {__index = create_element})
end
local _local_1_ = require("src.seed")
local ref = _local_1_["ref"]
local p = _local_1_["p"]
local div = _local_1_["div"]
local button = _local_1_["button"]
local function Counter()
  local count = ref(0)
  local function _13_()
    return tostring(count:get())
  end
  local function _14_()
    local function _15_(_241)
      return (_241 + 1)
    end
    return count:transform(_15_)
  end
  local function _16_()
    local function _17_(_241)
      return (_241 - 1)
    end
    return count:transform(_17_)
  end
  return div(p({["id#"] = count, ["#"] = count}, _13_), button({onclick = _14_}, "+1"), button({onclick = _16_}, "-1"))
end
return (js.global.document.body):appendChild(Counter())
