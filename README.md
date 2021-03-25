

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

To assign a task, set an index.
```lua
cleaner.stuff = function()
    -- do some cleaning...
end
```

Alternatively, you can call the `give` (or `GiveTask`) method.
```lua
cleaner:give(function()
    -- do some cleaning...
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

You can clean all tasks by calling the `clean` (or `DoCleaning`) function.
```lua
cleaner:clean() -- runs up ALL tasks
```

### Cleanable tasks

You can set any of the following types as a task:
- Functions
- Tables with a `Destroy` function
- RBXScriptConnections (when running in ROBLOX)
- Other Broom instances

### Tips

- Tasks can create other tasks (which can be cleaned in the same cycle)
- All cleaning functions are **yielding**

## Full Example  (Lua)

```lua
cleaner = Broom()
other = Broom()
other.foo = function()
    -- do something
    other:give(function()
        -- will run when ALL tasks are cleaned
    end
end

cleaner:give(other)
cleaner.bar = function()
    other = Broom()
    other.clean = function()
        -- when subclean is cleaned, 
    end
    cleaner:give(other)
end

cleaner.baz = {
    Destroy = function()
        -- do something
    end
}

cleaner.bar = nil -- cleans ONLY bar

cleaner:clean() -- cleans other (and in turn foo) and then baz
```
