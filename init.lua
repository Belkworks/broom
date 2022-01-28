local Broom
do
  local _class_0
  local _base_0 = {
    __newindex = function(self, Name, Task)
      local old = self.tasks[Name]
      if old == Task then
        return 
      end
      self.tasks[Name] = Task
      if old == nil then
        return 
      end
      local _exp_0 = type(old)
      if 'function' == _exp_0 then
        return old()
      elseif 'table' == _exp_0 then
        assert(old.Destroy, 'cant destroy a table without .Destroy!')
        return old:Destroy()
      end
      if typeof then
        local _exp_1 = typeof(old)
        if 'RBXScriptConnection' == _exp_1 then
          return old:Disconnect()
        elseif 'Instance' == _exp_1 then
          return old:Destroy()
        end
      end
      return error('don\'t know how to clean: ' .. tostring(old))
    end,
    clean = function(self)
      local tasks = self.tasks
      while true do
        local key = (pairs(tasks))(tasks)
        if key == nil then
          break
        end
        self[key] = nil
      end
    end,
    cleaner = function(self)
      return function()
        return self:clean()
      end
    end,
    cleanAfter = function(self, time)
      return task.delay(time, self:cleaner())
    end,
    connectClean = function(self, Signal)
      return Signal:Connect(self:cleaner())
    end,
    count = function(self)
      return #(function()
        local _accum_0 = { }
        local _len_0 = 1
        for key in pairs(self.tasks) do
          _accum_0[_len_0] = key
          _len_0 = _len_0 + 1
        end
        return _accum_0
      end)()
    end,
    give = function(self, Task)
      assert(Task, ':give expects a cleanable value')
      return table.insert(self.tasks, Task)
    end,
    connect = function(self, Signal, Callback)
      return self:give(Signal:Connect(Callback))
    end,
    signal = function(self, Signal)
      return self:give(function()
        return Signal:Disconnect()
      end)
    end,
    hook = function(self, Object, Property, Value)
      local Old = Object[Property]
      Object[Property] = Value
      return self:give(function()
        Object[Property] = Old
      end)
    end,
    alive = function(self)
      local Alive = true
      self:give(function()
        Alive = false
      end)
      return function()
        return Alive
      end
    end,
    apply = function(self, Callback)
      local Args = { }
      self:give(function()
        return Callback(unpack(Args))
      end)
      return function(...)
        Args = {
          ...
        }
      end
    end,
    namecall = function(self, Object, Method)
      return self:give(function()
        return Object[Method](Object)
      end)
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self)
      local Properties = {
        tasks = { },
        Destroy = self.clean,
        DoCleaning = self.clean,
        GiveTask = self.give,
        Connect = self.connect
      }
      for K, V in pairs(Properties) do
        rawset(self, K, V)
      end
    end,
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
  Broom = _class_0
  return _class_0
end
