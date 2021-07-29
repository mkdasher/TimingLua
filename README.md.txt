Settings will be read on file "config.json"
Settings variables:

m64_path (string) : path where LUA will search for the .m64 files to replay.
	m64_path : "C:\\TAS\\Round 1"
	
m64_replay_file (string) : filename of the .m64 file you want to replay. Type "all" if you want to replay every 	single file in the folder.
	m64_replay_file : "TASCompetitionTask1byMKDasher.m64"
	m64_replay_file : "all"
	
print_results (boolean) : true if you want to create a results file in .txt with all the .m64 replayed.
	print_results : true

results_file_name (string) : results filename
	results_file_name : "results.txt"

show_logs (boolean) : true if you want to show logs on lua console
	show_logs : true

start_condition (table) : lists conditions that are required for the TAS to start.
end_condition (table) : lists conditions that are required for the TAS to end.
dq_condition (table) : lists conditions that will DQ a TAS.
	

