local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local Teams = game:GetService("Teams")
local Players = game:GetService("Players")

local Constants = require(ReplicatedStorage.Modules.Shared.Constants)

-- Setup RemoteEvents
local remoteFolder = ReplicatedStorage:WaitForChild("RemoteEvents")

local function getRemote(name)
	local remote = remoteFolder:FindFirstChild(name)
	if not remote then
		remote = Instance.new("RemoteEvent")
		remote.Name = name
		remote.Parent = remoteFolder
	end
	return remote
end

local MatchStateChanged = getRemote("MatchStateChanged")
local ScoreChanged = getRemote("ScoreChanged")

-- Setup Teams
local function setupTeams()
	for _, teamData in pairs(Constants.TEAMS) do
		local team = Teams:FindFirstChild(teamData.Name)
		if not team then
			team = Instance.new("Team")
			team.Name = teamData.Name
			team.TeamColor = BrickColor.new(teamData.Color)
			team.AutoAssignable = false
			team.Parent = Teams
		end
	end
end

-- Game State
local GameState = {
	CurrentState = Constants.MATCH_STATE.WAITING,
	Timer = 0,
	Scores = { Red = 0, Blue = 0 }
}

-- Helper: Balance Teams
local function assignTeam(player)
	local redTeam = Teams:FindFirstChild(Constants.TEAMS.RED.Name)
	local blueTeam = Teams:FindFirstChild(Constants.TEAMS.BLUE.Name)
	
	local redCount = #redTeam:GetPlayers()
	local blueCount = #blueTeam:GetPlayers()
	
	if redCount <= blueCount then
		player.Team = redTeam
		player:SetAttribute("Team", "Red")
	else
		player.Team = blueTeam
		player:SetAttribute("Team", "Blue")
	end
	
	print(string.format("[GameManager] Assigned %s to %s", player.Name, player.Team.Name))
end

-- Match Loop
local function setMatchState(newState)
	GameState.CurrentState = newState
	MatchStateChanged:FireAllClients(newState, GameState.Timer)
	print("[GameManager] State changed to: " .. newState)
end

local function gameLoop()
	while true do
		-- WAITING
		setMatchState(Constants.MATCH_STATE.WAITING)
		while #Players:GetPlayers() < Constants.MIN_PLAYERS_TO_START do
			task.wait(1)
		end
		
		-- COUNTDOWN
		setMatchState(Constants.MATCH_STATE.COUNTDOWN)
		for i = Constants.INTERMISSION_DURATION, 1, -1 do
			GameState.Timer = i
			MatchStateChanged:FireAllClients(Constants.MATCH_STATE.COUNTDOWN, i)
			task.wait(1)
		end
		
		-- START MATCH
		setMatchState(Constants.MATCH_STATE.PLAYING)
		-- Reset Scores
		GameState.Scores.Red = 0
		GameState.Scores.Blue = 0
		ScoreChanged:FireAllClients(GameState.Scores)
		
		-- Respawn all players
		for _, player in ipairs(Players:GetPlayers()) do
			player:LoadCharacter()
		end
		
		-- Game Timer
		for i = Constants.MATCH_DURATION, 1, -1 do
			GameState.Timer = i
			-- Optional: Sync timer every few seconds or let client handle countdown
			if i % 10 == 0 then
				MatchStateChanged:FireAllClients(Constants.MATCH_STATE.PLAYING, i)
			end
			
			-- Check win condition (if any)
			task.wait(1)
		end
		
		-- ENDED
		setMatchState(Constants.MATCH_STATE.ENDED)
		task.wait(5)
	end
end

-- Initialize
setupTeams()

Players.PlayerAdded:Connect(function(player)
	assignTeam(player)
end)

task.spawn(gameLoop)

return {}
