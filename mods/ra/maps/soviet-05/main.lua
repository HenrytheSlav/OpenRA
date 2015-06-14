IdleHunt = function(unit) if not unit.IsDead and not unit.Type == harv then Trigger.OnIdle(unit, unit.Hunt) end end

CheckForBase = function()
	baseBuildings = Map.ActorsInBox(Map.TopLeft, waypoint59.CenterPosition, function(actor)
		return actor.Type == "fact" or actor.Type == "powr"
	end)

	return #baseBuildings >= 2
end

CheckForCYard = function()
	ConYard = Map.ActorsInBox(waypoint78.CenterPosition, waypoint44.CenterPosition, function(actor)
		return actor.Type == "fact" and actor.Owner == GoodGuy
	end)

	return #ConYard >= 1
end

CheckForSPen = function()
	SPens = Map.ActorsInBox(Map.TopLeft, waypoint59.CenterPosition, function(actor)
		return actor.Type == "spen"
	end)

	return #SPens >=1
end

RunInitialActivities = function()
	if Map.Difficulty == "Hard" then
		Expansion()
		ExpansionCheck = true
	else
		ExpansionCheck = false
	end

	Actor.Create("camera", true, { Owner = player, Location = waypoint68.Location })

	if not Harvester.IsDead then
		Trigger.AfterDelay(1, function(harvester)
			Harvester.FindResources()
			Helper.Destroy()
		end)
	end
end

Retreat = function()
    Reinforcements.Reinforce(player, sov1, sov1Path, 0, function(soldier)
		soldier.AttackMove(waypoint1.Location)
	end)

	Runner1.Move(waypoint53.Location)
	Runner2.Move(waypoint53.Location)
	Runner3.Move(waypoint53.Location)

	ProduceInfantry()
	Trigger.AfterDelay(DateTime.Minutes(2), ProduceShips)

	Trigger.Clear(Runner1, "OnDamaged")
	Trigger.Clear(Runner1, "OnDiscovered")

    Media.PlaySpeechNotification(player, "ReinforcementsArrived")

	if not Map.Difficulty == "Easy" then
		Trigger.AfterDelay(DateTime.Seconds(25), Gguy1)
	end
	Trigger.AfterDelay(DateTime.Minutes(2), Gguy1)
	Trigger.AfterDelay(DateTime.Minutes(5), Gguy1)
	Trigger.AfterDelay(DateTime.Minutes(3), function()	reinforceGG = true	end)
end

Expansion = function()
	if not ExpansionCheck then
		mcvtransport.Move(waypoint67.Location)
		mcvGG.Move(waypoint78.Location)
		Reinforcements.Reinforce(GoodGuy, {"dd", "dd"}, {waypoint43.Location, waypoint16.Location}, 0, function(ddsquad)
			ddsquad.AttackMove(waypoint10.Location)
		end)
		Trigger.AfterDelay(DateTime.Seconds(3), function(load)
			mcvGG.IsInWorld = false
			mcvtransport.LoadPassenger(mcvGG)
			mcvtransport.Move(waypoint92.Location)
			Trigger.AfterDelay(DateTime.Seconds(10), function(unload)
				mcvtransport.UnloadPassengers()
				Trigger.AfterDelay(DateTime.Seconds(2), function(move)
					mcvGG.Move(MCVDeploy.Location)
					Trigger.AfterDelay(DateTime.Seconds(4), function(deploy)
						mcvGG.Deploy()
						BuildBase()
						ExpansionCheck = true
						mcvtransport.Move(waypoint43.Location)
						IslandTroops()
						Trigger.AfterDelay(DateTime.Seconds(7), function(leave)
							mcvtransport.Destroy()
						end)
					end)
				end)
			end)
		end)
	else
	end
end

Tick = function()

	if Greece.HasNoRequiredUnits() and GoodGuy.HasNoRequiredUnits() then
		player.MarkCompletedObjective(KillAll)
	end

	if player.HasNoRequiredUnits() then
		player.MarkFailedObjective(CaptureObjective)
		player.MarkFailedObjective(KillAll)
		GoodGuy.MarkCompletedObjective(BeatUSSR)
	end

	-- if DateTime.GameTime % 251 == 0 then Media.DisplayMessage(tostring(GoodGuy.Cash + GoodGuy.Resources)) end

	if Radar.IsDead then
		player.MarkFailedObjective(CaptureObjective)
	end

	if Radar.Owner == player and not Radstop then
		if not ExpansionCheck then
			Expansion()
			ExpansionCheck = true
		end

		player.MarkCompletedObjective(CaptureObjective)
		Reinforcements.Reinforce(Greece, gguy2, {waypoint2.Location, waypoint3.Location, waypoint68.Location}, 0, function(soldier)
			soldier.Hunt()
		end)

		Radstop = true
	end

	if not baseEstablished and CheckForBase() then
		baseEstablished = true
		Para()
	end

	if not SPenEstablished and CheckForSPen() then
		SPenEstablished = true

		local units = Reinforcements.ReinforceWithTransport(Greece, "lst", arty1reinf, { waypoint44.Location, waypoint7.Location, waypoint9.Location, waypoint26.Location, waypoint18.Location, waypoint54.Location }, { waypoint44.Location })[2]
		Utils.Do(units, function(unit) IdleHunt(unit) end)
		if not ExpansionCheck then
			Expansion()
			ExpansionCheck = true
		end
	end

	if reinforceGG then
		reinforceGG = false

		Trigger.AfterDelay(DateTime.Seconds(10), Gguy2)

		if Map.Difficulty == "Easy" then
			Trigger.AfterDelay(DateTime.Minutes(6), function()	reinforceGG = true	end)
		elseif Map.Difficulty == "Medium" then
			Trigger.AfterDelay(DateTime.Minutes(4), function()	reinforceGG = true	end)
		else
			Trigger.AfterDelay(DateTime.Minutes(3), function()	reinforceGG = true	end)
		end
	end
end

WorldLoaded = function()
    player = Player.GetPlayer("USSR")
	GoodGuy = Player.GetPlayer("GoodGuy")
	Greece = Player.GetPlayer("Greece")

	RunInitialActivities()

    CaptureObjective = player.AddPrimaryObjective("Capture the Radar")
    KillAll = player.AddPrimaryObjective("Defeat the Allied Force")
    BeatUSSR = GoodGuy.AddPrimaryObjective("Defeat the USSR Force")

	Trigger.OnDamaged(Runner1, Retreat)
	Trigger.OnDiscovered(Runner1, Retreat)

	Trigger.OnDamaged(mcvGG, Expansion)
	Trigger.OnDamaged(mcvtransport, Expansion)

	Trigger.OnEnteredProximityTrigger(waypoint39.CenterPosition, WRange.New(4 * 1024), function(unit, id)
		if unit.Owner == player and Radar.Owner == player then
			Trigger.RemoveProximityTrigger(id)

			local units = Reinforcements.ReinforceWithTransport(player, "lst", {"mcv", "3tnk", "3tnk", "e1", "e1"}, { waypoint13.Location, waypoint54.Location }, { waypoint13.Location })[2]
			Utils.Do(units, function(unit) Trigger.OnIdle(unit, function(mcv) mcv.Move( waypoint39.Location) end) end)
			Para2()
			ProduceInfantryGG()
			ProduceTanksGG()
		end
	end)

	Trigger.OnPlayerLost(player, function()
		Media.PlaySpeechNotification(player, "Lose")
	end)
	Trigger.OnPlayerWon(player, function()
		Media.PlaySpeechNotification(player, "Win")
	end)

	Camera.Position = waypoint98.CenterPosition
end
