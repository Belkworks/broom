
# Broom
*A reactive task runner inspired by Nevermore's maid class.*

**Importing with [Neon](https://github.com/Belkworks/NEON)**:
```lua
Broom = NEON:github('belkworks', 'broom')
```

## API

To create a **Broom** instance, just call `Broom`.  
```lua
cleaner = Broom()
```

### Assigning Tasks

To assign a named task, set an index.
```lua
cleaner.stuff = function()
    -- do some cleaning...
end
```

Alternatively, you can call the `give` (or `GiveTask`) method to assign an unnamed task.
```lua
cleaner:give(function()
    -- do some cleaning...
end)
```

For usage on ROBLOX `Signals`, you can use the `connect` (or `Connect`) method.
```lua
RunService = game:GetService('RunService')
cleaner:connect(RunService.Heartbeat, function(delta)
    -- Heartbeat callback
end)

-- This is equivalent to
cleaner:give(RunService.Heartbeat:Connect(function(delta)
    -- Heartbeat callback
end)
```

### Cleaning Tasks

To cleanup a specific task, change an index.  
The value can be a new task or `nil`.
```lua
cleaner.stuff = nil -- runs the `stuff` task

-- alternatively,
cleaner.stuff = function() -- cleans the `stuff` task, sets new task.
    -- do some other cleaning
end
```

You can clean all tasks by calling the `clean` (or `DoCleaning`) method.
```lua
cleaner:clean() -- cleans up ALL tasks
```

### Cleanable tasks

You can set any of the following types as a task:
- Functions
- Tables with a `Destroy` function
- Other Broom instances

When running in ROBLOX, you can also set these types as tasks:
- RBXScriptConnections
- Instances

### Tips

- Tasks can create other tasks (which can be cleaned in the same cycle)
- All cleaning functions are done **synchronously**

## Full Example  (Lua)

```lua
cleaner = Broom()

other = Broom()
cleaner:give(other)
other.foo = function()
    -- do something
    other:give(function()
        -- will run when ALL tasks are cleaned
    end
end

cleaner.bar = function()
    -- do something
end

cleaner:give(function()
    -- do something
end)

cleaner.baz = {
    Destroy = function()
        -- do something
    end
}

cleaner.bar = nil -- cleans ONLY bar

cleaner:clean() -- cleans other (and in turn foo) and then baz
```
