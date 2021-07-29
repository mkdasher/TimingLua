State = {
		currentState = 0,
		m64 = {},
		m64List = {},
		counter = 0,

		fileCounter = 0,

		SETUP = 0,
		PENDING = 1,
		LOAD_M64 = 2,
		LOAD_ST = 3,
		RUN_M64 = 4,
		FINISHED = 5,
		RESULTS = 6,
		LUAEND = 7
}

function State.init()
		State.currentState = 0
		State.m64 = {
		  m64Name = "",
		  stName = "",
			fileSize = 0,
			rawInput = nil,
			frameCount = 0,
			rerecords = 0
		}
		State.counter = 0
		State.m64.m64Name = State.m64List[State.fileCounter]
		State.m64.stName = Utils.stringsplit(State.m64.m64Name, "%.")[1] .. ".st"
end
