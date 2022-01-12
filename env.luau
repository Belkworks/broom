
type Cleanable = RBXScriptSignal | {
	Destroy: () -> any
}

type Function = (...any) -> any

type Task = Cleanable | Instance |  (...any) -> any

type Signal = RBXScriptSignal | ( Cleanable & {
	Connect: ((...any) -> any) -> any
})

type Broom = {
	-- Cleaning	
	clean: () -> nil,
	Destroy: () -> nil,
	DoCleaning: () -> nil,
	cleaner: () -> () -> nil,
	connectClean: (signal: RBXScriptSignal) -> nil,
	
	-- Giving
	give: (task: Task) -> nil,
	connect: (signal: Signal, callback: Function) -> nil,
	signal: (signal: Signal) -> nil,
	
	-- Utility
	count: () -> number,
	hook: (object: {}, property: string, value: any) -> nil,
	alive: () -> () -> boolean,
	apply: (Function) -> (...any) -> nil,
	namecall: (object: {}, method: string) -> nil
}

type PKG = () -> Broom
