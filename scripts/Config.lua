-- Default config variables

Config = {
  Settings = {
    m64_path = "C:\\m64",
    m64_replay_file = "all",
    print_result = false,
    results_file_name = "results.txt",
    show_logs = true,
    close_on_end = false,
    start_condition = {
  		{
  			action = "spinning enter",
  			transition_progress = 2
  		},
  		{
  			action = "neutral enter",
  			transition_progress = 2
  		}
	  },
    end_condition = {
  		{
  			action = "star dance ground (exits)",
  			action_timer = 1
  		},
  		{
  			action = "disappeared",
  			transition_state = 4
  		}
	  },
    dq_condition = {},
    timing_correction = 0,
    timeout = 10000
  }
}

function Config.load()
  jsonfile = File.loadJSON("config.json")

  -- Load into Config.Settings, and keeping default variables if they don't appear on config.json
  for k, v in pairs(jsonfile) do
    Config.Settings[k] = v
  end
end
