-- broom.moon
-- SFZILabs 2021

class Broom
	tasks = {}
	
	__newindex: (K, V) =>
		old = tasks[K]
		return if old == V

		tasks[K] = V
		return if old == nil
	
		switch type old
			when 'function'
				return old!
			when 'table'
				assert old.Destroy, 'cant destroy a table without .Destroy!'
				return old.Destroy!

		if typeof
			if 'RBXScriptConnection' == typeof old
				return old\Disconnect!

		error 'don\'t know how to clean: '..tostring old

	clean: =>
		while true
			iter = pairs tasks
			k = iter tasks
			@[k] = nil
			break unless iter tasks

	give: (T) =>
		assert T, ':give expects a cleanable value'
		table.insert tasks, T
		#tasks

	Destroy: => @clean!

	DoCleaning: => @clean! -- for interop with Nevermore maids
	GiveTask: (T) => @give T -- for interop with Nevermore maids
