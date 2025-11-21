local config = {
	ignoreInstances = {},
	ignorePlayerCharacters = true,
	ignoreTools = true,
	noMesh = true,
	noTexture = true,
	destroyMeshes = false,
	imagesInvisible = true,
	imagesDestroy = false,
	explosionsSmaller = true,
	explosionsInvisible = false,
	explosionsDestroy = false,
	particlesInvisible = true,
	particlesDestroy = false,
	textLowerQuality = false,
	textInvisible = false,
	textDestroy = false,
	meshPartsLowerQuality = true,
	meshPartsInvisible = false,
	meshPartsNoTexture = false,
	meshPartsNoMesh = false,
	meshPartsDestroy = false,
	noClothes = true,
	lowQualityParts = true,
	lowQualityModels = true,
	clearNilInstances = false,
	lightingMode = "B"
}

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local MaterialService = game:GetService("MaterialService")
local particleClasses = {ParticleEmitter=true,Trail=true,Smoke=true,Fire=true,Sparkles=true}

local function isDescendantOfAny(inst, list)
	for _,v in ipairs(list) do
		if v and inst:IsDescendantOf(v) then
			return true
		end
	end
	return false
end

local function isPlayerCharacterDescendant(inst)
	for _,p in ipairs(Players:GetPlayers()) do
		local c = p.Character
		if c and inst:IsDescendantOf(c) then
			return true
		end
	end
	return false
end

local function inIgnoreList(inst)
	if type(config.ignoreInstances) ~= "table" or #config.ignoreInstances == 0 then
		return false
	end
	return isDescendantOfAny(inst, config.ignoreInstances)
end

local function applyToInstance(inst)
	if inIgnoreList(inst) then return end
	if config.ignorePlayerCharacters and isPlayerCharacterDescendant(inst) then return end
	if config.ignoreTools and (inst:IsA("BackpackItem") or inst:FindFirstAncestorWhichIsA("BackpackItem")) then return end
	if inst:IsA("SpecialMesh") or inst:IsA("DataModelMesh") or inst:IsA("Mesh") then
		if config.noMesh and pcall(function() inst.MeshId = "" end) then end
		if config.noTexture and pcall(function() inst.TextureId = "" end) then end
		if config.destroyMeshes and pcall(function() inst:Destroy() end) then end
		return
	end
	if inst:IsA("FaceInstance") then
		if config.imagesInvisible then pcall(function() inst.Transparency = 1 inst.Shiny = 1 end) end
		if config.imagesDestroy then pcall(function() inst:Destroy() end) end
		return
	end
	if inst:IsA("ShirtGraphic") then
		if config.imagesInvisible then pcall(function() inst.Graphic = "" end) end
		if config.imagesDestroy then pcall(function() inst:Destroy() end) end
		return
	end
	if particleClasses[inst.ClassName] then
		if config.particlesInvisible then pcall(function() inst.Enabled = false end) end
		if config.particlesDestroy then pcall(function() inst:Destroy() end) end
		return
	end
	if inst:IsA("Explosion") then
		if config.explosionsSmaller then pcall(function() inst.BlastPressure = 1 inst.BlastRadius = 1 end) end
		if config.explosionsInvisible then pcall(function() inst.Visible = false inst.BlastPressure = 1 inst.BlastRadius = 1 end) end
		if config.explosionsDestroy then pcall(function() inst:Destroy() end) end
		return
	end
	if inst:IsA("Clothing") or inst:IsA("SurfaceAppearance") or inst:IsA("BaseWrap") then
		if config.noClothes then pcall(function() inst:Destroy() end) end
		return
	end
	if inst:IsA("BasePart") and not inst:IsA("MeshPart") then
		if config.lowQualityParts then pcall(function() inst.Material = Enum.Material.Plastic inst.Reflectance = 0 end) end
		return
	end
	if inst:IsA("TextLabel") and inst:IsDescendantOf(workspace) then
		if config.textLowerQuality then pcall(function() inst.Font = Enum.Font.SourceSans inst.TextScaled = false inst.RichText = false inst.TextSize = 14 end) end
		if config.textInvisible then pcall(function() inst.Visible = false end) end
		if config.textDestroy then pcall(function() inst:Destroy() end) end
		return
	end
	if inst:IsA("Model") then
		if config.lowQualityModels then pcall(function() inst.LevelOfDetail = Enum.ModelLevelOfDetail.Disabled end) end
		return
	end
	if inst:IsA("MeshPart") then
		if config.meshPartsLowerQuality then pcall(function() inst.RenderFidelity = Enum.RenderFidelity.Automatic inst.Material = Enum.Material.Plastic inst.Reflectance = 0 end) end
		if config.meshPartsInvisible then pcall(function() inst.Transparency = 1 inst.RenderFidelity = Enum.RenderFidelity.Automatic inst.Reflectance = 0 inst.Material = Enum.Material.Plastic end) end
		if config.meshPartsNoTexture then pcall(function() inst.TextureID = "" end) end
		if config.meshPartsNoMesh then pcall(function() inst.MeshId = "" end) end
		if config.meshPartsDestroy then pcall(function() inst:Destroy() end) end
		return
	end
end

local function scanAll()
	local list = game:GetDescendants()
	for i=1,#list do
		local v = list[i]
		local ok, err = pcall(applyToInstance, v)
		if not ok then end
	end
end

local function onAdded(inst)
	task.wait(0.5)
	pcall(applyToInstance, inst)
end

scanAll()
game.DescendantAdded:Connect(onAdded)

if config.clearNilInstances and type(getnilinstances) == "function" then
	pcall(function()
		for _,v in ipairs(getnilinstances()) do
			pcall(function() v:Destroy() end)
		end
	end)
end

if config.lightingMode == "B" then
	pcall(function()
		Lighting.Brightness = 0
		Lighting.Ambient = Color3.new(1,1,1)
		Lighting.OutdoorAmbient = Color3.new(1,1,1)
		Lighting.ColorShift_Bottom = Color3.new(1,1,1)
		Lighting.ColorShift_Top = Color3.new(1,1,1)
		Lighting.EnvironmentDiffuseScale = 0
		Lighting.EnvironmentSpecularScale = 0
		Lighting.ShadowSoftness = 0
		Lighting.FogStart = 0
		Lighting.FogEnd = 1
		Lighting.FogColor = Color3.new(1,1,1)
	end)
elseif config.lightingMode == "A" then
	pcall(function()
		Lighting.Brightness = 0
		Lighting.Ambient = Color3.new(0,0,0)
		Lighting.OutdoorAmbient = Color3.new(0,0,0)
		Lighting.ColorShift_Bottom = Color3.new(0,0,0)
		Lighting.ColorShift_Top = Color3.new(0,0,0)
		Lighting.EnvironmentDiffuseScale = 0
		Lighting.EnvironmentSpecularScale = 0
		Lighting.ShadowSoftness = 0
		Lighting.FogStart = 0
		Lighting.FogEnd = 1e9
		Lighting.FogColor = Color3.new(0,0,0)
	end)
else
	pcall(function()
		Lighting.Brightness = 0
		Lighting.Ambient = Color3.new(0.5,0.5,0.5)
		Lighting.OutdoorAmbient = Color3.new(0.5,0.5,0.5)
		Lighting.ColorShift_Bottom = Color3.new(0.5,0.5,0.5)
		Lighting.ColorShift_Top = Color3.new(0.5,0.5,0.5)
		Lighting.EnvironmentDiffuseScale = 0
		Lighting.EnvironmentSpecularScale = 0
		Lighting.ShadowSoftness = 0
		Lighting.FogStart = 0
		Lighting.FogEnd = 1
		Lighting.FogColor = Color3.new(0.5,0.5,0.5)
	end)
end

pcall(function()
	for _,m in ipairs(MaterialService:GetChildren()) do
		pcall(function() m:Destroy() end)
	end
	MaterialService.Use2022Materials = false
end)
