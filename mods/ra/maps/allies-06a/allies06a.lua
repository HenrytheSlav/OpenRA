AlliedReinforcementsA = {
	hard = { "e1", "e1", "e1" },
	normal = { "e1", "e1", "e1", "e1", "e1" },
	easy = { "e1", "e1", "e1", "e1", "e1" }
}

AlliedReinforcementsB = {
	hard = { "e3", "e3", "e3" },
	normal = { "e3", "e3", "e3", "e3", "e3" },
	easy = { "e3", "e3", "e3", "arty" }
}

AlliedReinforcementsC = {
	hard = { "1tnk", "1tnk", "e3" },
	normal = { "2tnk", "2tnk" },
	easy = { "2tnk", "2tnk", "e3", "e3" }
}

BadGuys = { BadGuy1, BadGuy2, BadGuy3 }

SovietDogPatrols =
{
	{ Patrol_1_e1, Patrol_1_dog },
	{ Patrol_2_e1, Patrol_2_dog },
	{ Patrol_3_e1, Patrol_3_dog },
	{ Patrol_4_e1, Patrol_4_dog }
}

SovietDogPatrolPaths =
{
	{ Patrol6.Location, Patrol7.Location, Patrol8.Location, Patrol1.Location, Patrol2.Location, Patrol3.Location, Patrol4.Location, Patrol5.Location },
	{ Patrol8.Location, Patrol1.Location, Patrol2.Location, Patrol3.Location, Patrol4.Location, Patrol5.Location, Patrol6.Location, Patrol7.Location },
	{ Patrol1.Location, Patrol2.Location, Patrol3.Location, Patrol4.Location, Patrol5.Location, Patrol6.Location, Patrol7.Location, Patrol8.Location },
	{ Patrol2.Location, Patrol3.Location, Patrol4.Location, Patrol5.Location, Patrol6.Location, Patrol7.Location, Patrol8.Location, Patrol1.Location }
}

Mammoths = { Mammoth1, Mammoth2, Mammoth3 }

SovietMammothPaths =
{
	{ TnkPatrol1.Location, TnkPatrol2.Location,TnkPatrol3.Location, TnkPatrol4.Location, TnkPatrol5.Location, TnkPatrol6.Location, TnkPatrol7.Location, TnkPatrol8.Location },
	{ TnkPatrol5.Location, TnkPatrol6.Location, TnkPatrol7.Location, TnkPatrol8.Location,  TnkPatrol1.Location, TnkPatrol2.Location, TnkPatrol3.Location, TnkPatrol4.Location },
	{ TnkPatrol8.Location, TnkPatrol1.Location, TnkPatrol2.Location, TnkPatrol3.Location, TnkPatrol4.Location, TnkPatrol5.Location,  TnkPatrol6.Location, TnkPatrol7.Location }
}

SovietSubPath = { SubPatrol3_1.Location, SubPatrol3_2.Location, SubPatrol3_3.Location }

ParadropWaypoints =
{
	easy = { UnitBStopLocation },
	normal = { UnitBStopLocation, UnitAStopLocation },
	hard = { UnitBStopLocation, MCVStopLocation, UnitAStopLocation }
}

SovietTechLabs = { TechLab1, TechLab2, TechLab3 }
TechLabCams = { TechCam1, TechCam2, TechCam3 }

GroupPatrol = function(units, waypoints, delay)
	local i = 1
	local stop = false

	Utils.Do(units, function(unit)
		Trigger.OnIdle(unit, function()
			if stop then
				return
			end
			if unit.Location == waypoints[i] then
				local bool = Utils.All(units, function(actor) return actor.IsIdle end)
				if bool then
					stop = true
					i = i + 1
					if i > #waypoints then
						i = 1
					end
					Trigger.AfterDelay(delay, function() stop = false end)
				end
			else
				unit.AttackMove(waypoints[i])
			end
		end)
	end)
end

InitialSovietPatrols = function()
	-- Dog Patrols
	for i = 1, 4 do
		GroupPatrol(SovietDogPatrols[i], SovietDogPatrolPaths[i], DateTime.Seconds(5))
	end

	-- Mammoth Patrols
	for i = 1, 3 do
		Trigger.AfterDelay(DateTime.Seconds(6 * (i - 1)), function()
			Trigger.OnIdle(Mammoths[i], function()
				Mammoths[i].Patrol(SovietMammothPaths[i])
			end)
		end)
	end

	-- Sub Patrols
	Patrol1Sub.Patrol({ SubPatrol1_1.Location, SubPatrol1_2.Location })
	Patrol2Sub.Patrol({ SubPatrol2_1.Location, SubPatrol2_2.Location })
	Patrol3Sub1.Patrol(SovietSubPath)
	Patrol3Sub2.Patrol(SovietSubPath)
end

InitialAlliedReinforcements = function()
	local camera = Actor.Create("Camera", true, { Owner = player, Location = DefaultCameraPosition.Location })
	Trigger.AfterDelay(DateTime.Seconds(30), camera.Destroy)

	Reinforcements.Reinforce(player, AlliedReinforcementsA, { AlliedEntry1.Location, UnitBStopLocation.Location }, 2)
	Trigger.AfterDelay(DateTime.Seconds(2), function()
		Reinforcements.Reinforce(player, AlliedReinforcementsB, { AlliedEntry2.Location, UnitAStopLocation.Location }, 2)
	end)
	Trigger.AfterDelay(DateTime.Seconds(3), function()
		Reinforcements.Reinforce(player, AlliedReinforcementsC, { AlliedEntry3.Location, MCVStopLocation.Location })
	end)
end

CaptureRadarDome = function()
	Trigger.OnKilled(Radar, function()
		player.MarkFailedObjective(CaptureRadarDomeObj)
	end)

	Trigger.OnCapture(Radar, function()
		player.MarkCompletedObjective(CaptureRadarDomeObj)
		MCVWaterTransport()
		Trigger.AfterDelay(DateTime.Seconds(5), cam.Destroy)
		Trigger.AfterDelay(DateTime.Seconds(5), function()
			Media.DisplayMessage("You can disable the Radar Dome to stop it from draining your power and slowing your production for now. Use the icon of the lightning in the top right corner. Don't forget to power it back up later!","Hint")
		end)
	end)
end

MCVWaterTransport = function()
	local mcvreinf = Reinforcements.ReinforceWithTransport(player, "lst.in", { "mcv" }, { WaterUnloadEntry1.Location, WaterUnload2.Location }, { WaterUnload2.Location, WaterUnloadEntry1.Location })[2]
	Utils.Do(mcvreinf, function(units)
		Trigger.OnAddedToWorld(units, function()
			units.Move(SovietMiniBaseCam.Location)
		end)
	end)
end

infiltrated = false
InfiltrateTechCenter = function()
	Utils.Do(SovietTechLabs, function(a)
		Trigger.OnInfiltrated(a, function()
			if infiltrated then
				return
			end
			infiltrated = true
			DestroySovietsObj = player.AddPrimaryObjective("Destroy all Soviet buildings and units in the area.")
			player.MarkCompletedObjective(InfiltrateTechCenterObj)

			local Proxy = Actor.Create("powerproxy.paratroopers", false, { Owner = ussr })
			Utils.Do(ParadropWaypoints[Map.LobbyOption("difficulty")], function(waypoint)
				Proxy.SendParatroopers(waypoint.CenterPosition, false, Facing.South)
			end)
			Proxy.Destroy()
		end)
	end)

	Trigger.OnAllKilled(SovietTechLabs, function()
		if not player.IsObjectiveCompleted(InfiltrateTechCenterObj) then
			player.MarkFailedObjective(InfiltrateTechCenterObj)
		end
	end)
end

InfiltrateRef = function()
	Trigger.OnInfiltrated(Refinery, function()
		player.MarkCompletedObjective(InfiltrateRefObj)
	end)
	Trigger.OnKilled(Refinery, function()
		if not player.IsObjectiveCompleted(InfiltrateRefObj) then
			player.MarkFailedObjective(InfiltrateRefObj)
		end
	end)
end

spyHelp = false
Tick = function()
	if DateTime.GameTime > DateTime.Seconds(10) and player.HasNoRequiredUnits() then
		player.MarkFailedObjective(InfiltrateTechCenterObj)
	end

	if DestroySovietsObj and ussr.HasNoRequiredUnits() then
		player.MarkCompletedObjective(DestroySovietsObj)
	end

	if not spyHelp then
		if #Utils.Where(Map.ActorsInWorld, function(self) return self.Owner == player and self.Type == "spy" end) < 1 then
			return
		else
			spyHelp = true
			Trigger.AfterDelay(0, function()
				Media.DisplayMessage("To disguise your spy, select him first, them right-click any enemy infantry (at any range). Undisguised spies are easy prey to the enemy!","Hint")
			end)
		end
	end
end

WorldLoaded = function()
	player = Player.GetPlayer("Greece")
	ussr = Player.GetPlayer("USSR")

	Trigger.OnObjectiveAdded(player, function(p, id)
		Media.DisplayMessage(p.GetObjectiveDescription(id), "New " .. string.lower(p.GetObjectiveType(id)) .. " objective")
	end)

	Trigger.OnObjectiveCompleted(player, function(p, id)
		Media.DisplayMessage(p.GetObjectiveDescription(id), "Objective completed")
	end)

	Trigger.OnObjectiveFailed(player, function(p, id)
		Media.DisplayMessage(p.GetObjectiveDescription(id), "Objective failed")
	end)

	Trigger.OnPlayerLost(player, function()
		Media.PlaySpeechNotification(player, "MissionFailed")
	end)
	Trigger.OnPlayerWon(player, function()
		Media.PlaySpeechNotification(player, "MissionAccomplished")
	end)

	InfiltrateTechCenterObj = player.AddPrimaryObjective("Infiltrate one of the Soviet tech centers.")
	CaptureRadarDomeObj = player.AddSecondaryObjective("Capture the Radar Dome at the shore.")
	InfiltrateRefObj = player.AddSecondaryObjective("Infiltrate the Refinery for money.")

	Camera.Position = DefaultCameraPosition.CenterPosition

	if Map.LobbyOption("difficulty") ~= "hard" then
		Utils.Do(TechLabCams, function(a)
			Actor.Create("TECH.CAM", true, { Owner = player, Location = a.Location })
		end)

		if Map.LobbyOption("difficulty") == "easy" then
			Actor.Create("Camera", true, { Owner = player, Location = Weapcam.Location })
		end
	end

	Utils.Do(BadGuys, function(a)
		a.AttackMove(MCVStopLocation.Location)
	end)

	Trigger.AfterDelay(DateTime.Seconds(1), function()
		InitialAlliedReinforcements()
		InitialSovietPatrols()
	end)

	Trigger.OnEnteredProximityTrigger(SovietMiniBaseCam.CenterPosition, WDist.New(1024 * 10), function(a, id)
		if a.Owner == player then
			Trigger.RemoveProximityTrigger(id)
			cam = Actor.Create("Camera", true, { Owner = player, Location = SovietMiniBaseCam.Location })
		end
	end)

	CaptureRadarDome()
	InfiltrateTechCenter()
	InfiltrateRef()
	Trigger.AfterDelay(0, ActivateAI)
	Trigger.AfterDelay(0, DiffRecalc)
end

DiffRecalc = function()
	local difficulty = Map.LobbyOption("difficulty")
	AlliedReinforcementsA = AlliedReinforcementsA[difficulty]
	AlliedReinforcementsB = AlliedReinforcementsB[difficulty]
	AlliedReinforcementsC = AlliedReinforcementsC[difficulty]
end
