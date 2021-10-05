-- broom.moon
-- SFZILabs 2021

class Broom
    new: =>
        Properties =
            tasks: {}
            
            -- Broom can clean broom
            Destroy: @clean

            -- Nevermore maid interop
            DoCleaning: @clean
            GiveTask: @give

            -- ROBLOX standard
            Connect: @connect

        rawset @, K, V for K, V in pairs Properties

    __newindex: (Name, Task) =>
        old = @tasks[Name]
        return if old == Task

        @tasks[Name] = Task
        return if old == nil
    
        switch type old
            when 'function'
                return old!
            when 'table'
                assert old.Destroy, 'cant destroy a table without .Destroy!'
                return old\Destroy!

        if typeof
            switch typeof old
                when 'RBXScriptConnection'
                    return old\Disconnect!
                when 'Instance'
                    return old\Destroy!

        error 'don\'t know how to clean: '..tostring old

    clean: =>
        tasks = @tasks
        while true
            key = (pairs tasks) tasks
            break if key == nil
            @[key] = nil

    cleaner: =>
        -> @clean!

    connectClean: (Signal) =>
        Signal\Connect @cleaner!

    count: =>
        #[key for key in pairs @tasks]

    give: (Task) =>
        assert Task, ':give expects a cleanable value'
        table.insert @tasks, Task

    connect: (Signal, Callback) =>
        @give Signal\Connect Callback

    hook: (Object, Property, Value) =>
        Old = Object[Property]
        Object[Property] = Value
        @give -> Object[Property] = Old

    alive: =>
        Alive = true
        @give -> Alive = false
        -> Alive
