local Constants = {
	MAX_PLAYERS = 20,
	MIN_PLAYERS_TO_START = 1, -- Set to 2 for real matches
	MATCH_DURATION = 480, -- 8 minutes
	INTERMISSION_DURATION = 10,
	
	JETPACK_MAX_FUEL = 100,
	
	TEAMS = {
		RED = { Name = "Red", Color = Color3.fromRGB(255, 50, 50) },
		BLUE = { Name = "Blue", Color = Color3.fromRGB(50, 50, 255) }
	},
	
	MATCH_STATE = {
		WAITING = "Waiting",
		COUNTDOWN = "Countdown",
		PLAYING = "Playing",
		ENDED = "Ended"
	}
}

return Constants
