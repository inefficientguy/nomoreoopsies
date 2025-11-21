task.delay(2.05, function()
	game.Players.RespawnTime = 1
	workspace.Gravity = 196.2
	workspace.AirDensity = 0.1
	workspace.StreamingEnabled = true
	workspace.StreamingMinRadius = 64
	workspace.StreamingTargetRadius = 150
	--workspace.PhysicsSteppingMethod = Enum.PhysicsSteppingMethod.Fixed
	--workspace.PhysicsSimulationRate = 120

	game.Lighting.GlobalShadows = false
	game.Lighting.EnvironmentDiffuseScale = 0
	game.Lighting.EnvironmentSpecularScale = 0
	game.Lighting.Brightness = 2
	game.Lighting.Ambient = Color3.fromRGB(255, 255, 255)

	pcall(function()
		game.Lighting.Technology = Enum.Technology.Compatibility
	end)

	for _, v in ipairs(game.Lighting:GetChildren()) do
		if v:IsA("PostEffect") then
			v.Enabled = false
		end
	end
	print("dbm finished")
end)
