local Broom
do
  local _class_0
  local tasks
  local _base_0 = {
    __newindex = function(self, K, V)
      local old = tasks[K]
      if old == V then
        return 
      end
      tasks[K] = V
      if old == nil then
        return 
      end
      local _exp_0 = type(old)
      if 'function' == _exp_0 then
        return old()
      elseif 'table' == _exp_0 then
        assert(old.Destroy, 'cant destroy a table without .Destroy!')
        return old.Destroy()
      end
      if typeof then
        if 'RBXScriptConnection' == typeof(old) then
          return old:Disconnect()
        end
      end
      return error('don\'t know how to clean: ' .. tostring(old))
    end,
    clean = function(self)
      while true do
        local iter = pairs(tasks)
        local k = iter(tasks)
        self[k] = nil
        if not (iter(tasks)) then
          break
        end
      end
    end,
    give = function(self, T)
      assert(T, ':give expects a cleanable value')
      table.insert(tasks, T)
      return #tasks
    end,
    Destroy = function(self)
      return self:clean()
    end,
    DoCleaning = function(self)
      return self:clean()
    end,
    GiveTask = function(self, T)
      return self:give(T)
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function() end,
    __base = _base_0,
    __name = "Broom"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  local self = _class_0
  tasks = { }
  Broom = _class_0
  return _class_0
end
