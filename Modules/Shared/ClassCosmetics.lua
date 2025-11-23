local ServerStorage = game:GetService("ServerStorage")
local CollectionService = game:GetService("CollectionService")

local ClassCosmetics = {}

local ASSETS_FOLDER = ServerStorage:WaitForChild("ClassAssets")
local TAG = "ClassCosmetic"

local function clearOld(character)
	for _, inst in ipairs(character:GetDescendants()) do
		if CollectionService:HasTag(inst, TAG) then
			inst:Destroy()
		end
	end
	for _, inst in ipairs(character:GetChildren()) do
		if CollectionService:HasTag(inst, TAG) then
			inst:Destroy()
		end
	end
end

local function makeWrapper(character)
	local wrapper = Instance.new("Model")
	wrapper.Name = "ClassArmor"
	CollectionService:AddTag(wrapper, TAG)
	wrapper.Parent = character
	return wrapper
end

local function weldTo(part, target, worldCFrame)
	part.CFrame = worldCFrame
	local w = Instance.new("Weld")
	w.Part0 = target
	w.Part1 = part
	w.C0 = target.CFrame:ToObjectSpace(worldCFrame)
	w.C1 = CFrame.new()
	w.Parent = target
end

local function makePart(wrapper, target, size, offset, color, material, shape, rot, transparency, reflectance)
	local p = Instance.new("Part")
	p.Size = size
	p.Anchored = false
	p.CanCollide = false
	p.Massless = true
	p.Color = color
	p.Material = material or Enum.Material.Metal
	p.Shape = shape or Enum.PartType.Block
	p.TopSurface = Enum.SurfaceType.Smooth
	p.BottomSurface = Enum.SurfaceType.Smooth
	p.CastShadow = false
	if transparency then p.Transparency = transparency end
	if reflectance then p.Reflectance = reflectance end
	local cf = target.CFrame * CFrame.new(offset)
	if rot then cf = cf * rot end
	p.Parent = wrapper
	CollectionService:AddTag(p, TAG)
	weldTo(p, target, cf)
	return p
end

local function makeCylinder(wrapper, target, size, offset, color, material, rot, transparency, reflectance)
	return makePart(wrapper, target, size, offset, color, material, Enum.PartType.Cylinder, rot, transparency, reflectance)
end

local function makeBall(wrapper, target, size, offset, color, material, rot, transparency, reflectance)
	return makePart(wrapper, target, size, offset, color, material, Enum.PartType.Ball, rot, transparency, reflectance)
end

local function attachArmor(source, character)
	local defaultTarget = character:FindFirstChild("HumanoidRootPart")
	if not defaultTarget then return end
	local wrapper = makeWrapper(character)

	local function processBasePart(originalPart)
		if originalPart:FindFirstAncestorWhichIsA("Accessory") then
			return
		end

		local part = originalPart:Clone()
		part.Anchored = false
		part.CanCollide = false
		part.Massless = true
		part.TopSurface = Enum.SurfaceType.Smooth
		part.BottomSurface = Enum.SurfaceType.Smooth
		part.CastShadow = false

		local target = character:FindFirstChild(part.Name) or defaultTarget
		if target and target:IsA("BasePart") then
			local offset = part:GetAttribute("Offset")
			local cf
			if typeof(offset) == "Vector3" then
				cf = target.CFrame * CFrame.new(offset)
			else
				cf = target.CFrame
			end
			part.Parent = wrapper
			CollectionService:AddTag(part, TAG)
			weldTo(part, target, cf)
		else
			part:Destroy()
		end
	end

	local function processAccessory(originalAcc)
		local acc = originalAcc:Clone()
		acc.Parent = character
		CollectionService:AddTag(acc, TAG)
		for _, d in ipairs(acc:GetDescendants()) do
			if d:IsA("BasePart") or d:IsA("Attachment") then
				CollectionService:AddTag(d, TAG)
				if d:IsA("BasePart") then
					d.Anchored = false
					d.CanCollide = false
					d.Massless = true
					d.TopSurface = Enum.SurfaceType.Smooth
					d.BottomSurface = Enum.SurfaceType.Smooth
					d.CastShadow = false
				end
			end
		end
	end

	for _, inst in ipairs(source:GetDescendants()) do
		if inst:IsA("Accessory") then
			processAccessory(inst)
		elseif inst:IsA("BasePart") then
			processBasePart(inst)
		end
	end
end

local ProceduralBuilders = {}

ProceduralBuilders.Scout = function(character)
	local head = character:FindFirstChild("Head")
	local ut = character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")
	local lt = character:FindFirstChild("LowerTorso")
	if not head or not ut then return end
	local wrapper = makeWrapper(character)

	local black = Color3.fromRGB(12,12,14)
	local dark = Color3.fromRGB(35,35,40)
	local grey = Color3.fromRGB(70,70,75)
	local cyan = Color3.fromRGB(0,200,255)
	local glass = Color3.fromRGB(160,235,255)

	local hs = head.Size
	local lensSize = Vector3.new(hs.X*0.36, hs.Y*0.16, hs.Z*0.06)
	makePart(wrapper, head, lensSize, Vector3.new(-hs.X*0.22, hs.Y*0.05, -hs.Z*0.55), glass, Enum.Material.Glass, Enum.PartType.Block, nil, 0.25, 0.05)
	makePart(wrapper, head, lensSize, Vector3.new(hs.X*0.22, hs.Y*0.05, -hs.Z*0.55), glass, Enum.Material.Glass, Enum.PartType.Block, nil, 0.25, 0.05)
	makePart(wrapper, head, Vector3.new(hs.X*0.9, hs.Y*0.08, hs.Z*0.08), Vector3.new(0, hs.Y*0.05, -hs.Z*0.58), black, Enum.Material.SmoothPlastic)

	local ts = ut.Size
	makePart(wrapper, ut, Vector3.new(ts.X*1.12, ts.Y*1.05, ts.Z*0.28), Vector3.new(0, ts.Y*0.02, -ts.Z*0.52), dark, Enum.Material.Metal)
	makePart(wrapper, ut, Vector3.new(ts.X*0.9, ts.Y*0.7, ts.Z*0.18), Vector3.new(0, ts.Y*0.18, -ts.Z*0.68), grey, Enum.Material.Metal)

	makePart(wrapper, ut, Vector3.new(ts.X*0.95, ts.Y*0.9, ts.Z*0.45), Vector3.new(0, ts.Y*0.05, ts.Z*0.55), dark, Enum.Material.Metal)
	makeCylinder(wrapper, ut, Vector3.new(ts.X*0.18, ts.Y*0.45, ts.X*0.18), Vector3.new(-ts.X*0.38, -ts.Y*0.1, ts.Z*0.95), cyan, Enum.Material.Neon, CFrame.Angles(math.rad(90),0,0))
	makeCylinder(wrapper, ut, Vector3.new(ts.X*0.18, ts.Y*0.45, ts.X*0.18), Vector3.new(ts.X*0.38, -ts.Y*0.1, ts.Z*0.95), cyan, Enum.Material.Neon, CFrame.Angles(math.rad(90),0,0))
	makePart(wrapper, ut, Vector3.new(ts.X*0.2, ts.Y*0.2, ts.Z*0.2), Vector3.new(0, 0, ts.Z*1.05), cyan, Enum.Material.Neon)

	if lt then
		local lts = lt.Size
		makePart(wrapper, lt, Vector3.new(lts.X*1.05, lts.Y*0.65, lts.Z*0.25), Vector3.new(0, -lts.Y*0.08, -lts.Z*0.45), black, Enum.Material.Metal)
	end
end

ProceduralBuilders.Heavy = function(character)
	local head = character:FindFirstChild("Head")
	local ut = character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")
	local lt = character:FindFirstChild("LowerTorso")
	local ll = character:FindFirstChild("LeftLowerLeg")
	local rl = character:FindFirstChild("RightLowerLeg")
	local lf = character:FindFirstChild("LeftFoot")
	local rf = character:FindFirstChild("RightFoot")
	if not head or not ut then return end
	local wrapper = makeWrapper(character)

	local red = Color3.fromRGB(170,0,0)
	local black = Color3.fromRGB(10,10,12)
	local metal = Color3.fromRGB(70,70,75)
	local glow = Color3.fromRGB(255,60,60)

	local ts = ut.Size
	makePart(wrapper, ut, Vector3.new(ts.X*1.55, ts.Y*1.35, ts.Z*0.9), Vector3.new(0, ts.Y*0.02, -ts.Z*0.25), metal, Enum.Material.Metal, Enum.PartType.Block, nil, nil, 0.1)
	makePart(wrapper, ut, Vector3.new(ts.X*1.35, ts.Y*1.1, ts.Z*0.55), Vector3.new(0, ts.Y*0.1, ts.Z*0.35), black, Enum.Material.Metal)

	makePart(wrapper, ut, Vector3.new(ts.X*1.65, ts.Y*0.45, ts.Z*0.6), Vector3.new(0, ts.Y*0.55, -ts.Z*0.15), red, Enum.Material.Metal)

	if lt then
		local lts = lt.Size
		makePart(wrapper, lt, Vector3.new(lts.X*1.45, lts.Y*0.9, lts.Z*0.8), Vector3.new(0, -lts.Y*0.05, -lts.Z*0.15), black, Enum.Material.Metal)
	end

	if ll then
		local s = ll.Size
		makePart(wrapper, ll, Vector3.new(s.X*1.25, s.Y*1.15, s.Z*1.2), Vector3.new(0, -s.Y*0.05, 0), metal, Enum.Material.Metal)
	end
	if rl then
		local s = rl.Size
		makePart(wrapper, rl, Vector3.new(s.X*1.25, s.Y*1.15, s.Z*1.2), Vector3.new(0, -s.Y*0.05, 0), metal, Enum.Material.Metal)
	end
	if lf then
		local s = lf.Size
		makePart(wrapper, lf, Vector3.new(s.X*1.4, s.Y*0.9, s.Z*1.7), Vector3.new(0, s.Y*0.1, s.Z*0.2), black, Enum.Material.Metal)
	end
	if rf then
		local s = rf.Size
		makePart(wrapper, rf, Vector3.new(s.X*1.4, s.Y*0.9, s.Z*1.7), Vector3.new(0, s.Y*0.1, s.Z*0.2), black, Enum.Material.Metal)
	end

	local hs = head.Size
	makeBall(wrapper, head, Vector3.new(hs.X*1.25, hs.Y*1.2, hs.Z*1.25), Vector3.new(0, 0, 0), black, Enum.Material.Metal)
	makeBall(wrapper, head, Vector3.new(hs.X*1.05, hs.Y*0.9, hs.Z*1.05), Vector3.new(0, hs.Y*0.05, -hs.Z*0.05), red, Enum.Material.Metal)
	makePart(wrapper, head, Vector3.new(hs.X*0.9, hs.Y*0.22, hs.Z*0.12), Vector3.new(0, hs.Y*0.02, -hs.Z*0.68), glow, Enum.Material.Neon, Enum.PartType.Block, nil, 0, 0)
end

ProceduralBuilders.Support = function(character)
	local head = character:FindFirstChild("Head")
	local ut = character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")
	if not head or not ut then return end
	local wrapper = makeWrapper(character)

	local white = Color3.fromRGB(245,245,245)
	local gold = Color3.fromRGB(215,195,120)
	local red = Color3.fromRGB(180,0,0)

	local ts = ut.Size
	makePart(wrapper, ut, Vector3.new(ts.X*1.2, ts.Y*1.15, ts.Z*0.25), Vector3.new(0, ts.Y*0.02, -ts.Z*0.55), white, Enum.Material.SmoothPlastic)
	makePart(wrapper, ut, Vector3.new(ts.X*0.12, ts.Y*0.65, ts.Z*0.05), Vector3.new(0, ts.Y*0.02, -ts.Z*0.7), red, Enum.Material.SmoothPlastic)
	makePart(wrapper, ut, Vector3.new(ts.X*0.5, ts.Y*0.12, ts.Z*0.05), Vector3.new(0, ts.Y*0.18, -ts.Z*0.7), red, Enum.Material.SmoothPlastic)

	for side = -1, 1, 2 do
		makePart(wrapper, ut, Vector3.new(ts.X*0.12, ts.Y*0.9, ts.Z*1.25), Vector3.new(side*ts.X*0.65, ts.Y*0.2, ts.Z*0.85), white, Enum.Material.SmoothPlastic, Enum.PartType.Block, CFrame.Angles(0, math.rad(side*20), math.rad(side*10)), 0.05)
		makePart(wrapper, ut, Vector3.new(ts.X*0.12, ts.Y*0.7, ts.Z*1.0), Vector3.new(side*ts.X*0.9, ts.Y*0.35, ts.Z*0.9), white, Enum.Material.SmoothPlastic, Enum.PartType.Block, CFrame.Angles(0, math.rad(side*35), math.rad(side*15)), 0.08)
	end

	local hs = head.Size
	makeBall(wrapper, head, Vector3.new(hs.X*1.18, hs.Y*1.1, hs.Z*1.18), Vector3.new(0, 0, 0), white, Enum.Material.SmoothPlastic)
	makePart(wrapper, head, Vector3.new(hs.X*0.18, hs.Y*0.9, hs.Z*1.1), Vector3.new(0, hs.Y*0.45, 0), gold, Enum.Material.Metal)
end

ProceduralBuilders.Assault = function(character)
	local head = character:FindFirstChild("Head")
	local ut = character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")
	local lt = character:FindFirstChild("LowerTorso")
	local lua = character:FindFirstChild("LeftUpperArm")
	local rua = character:FindFirstChild("RightUpperArm")
	if not head or not ut then return end
	local wrapper = makeWrapper(character)

	local dark = Color3.fromRGB(28,30,35)
	local blue = Color3.fromRGB(45,85,150)
	local grey = Color3.fromRGB(80,82,90)
	local visor = Color3.fromRGB(255,120,60)

	local ts = ut.Size
	makePart(wrapper, ut, Vector3.new(ts.X*1.25, ts.Y*1.15, ts.Z*0.35), Vector3.new(0, ts.Y*0.02, -ts.Z*0.55), dark, Enum.Material.Metal)
	makePart(wrapper, ut, Vector3.new(ts.X*0.9, ts.Y*0.75, ts.Z*0.2), Vector3.new(0, ts.Y*0.15, -ts.Z*0.72), blue, Enum.Material.Metal)

	if lt then
		local lts = lt.Size
		makePart(wrapper, lt, Vector3.new(lts.X*1.1, lts.Y*0.7, lts.Z*0.3), Vector3.new(0, -lts.Y*0.05, -lts.Z*0.4), grey, Enum.Material.Metal)
	end

	if lua then
		local s = lua.Size
		makeBall(wrapper, lua, Vector3.new(s.X*1.05, s.Y*0.95, s.Z*1.05), Vector3.new(0, 0, -s.Z*0.05), dark, Enum.Material.Metal)
	end
	if rua then
		local s = rua.Size
		makeBall(wrapper, rua, Vector3.new(s.X*1.05, s.Y*0.95, s.Z*1.05), Vector3.new(0, 0, -s.Z*0.05), dark, Enum.Material.Metal)
	end

	local hs = head.Size
	makeBall(wrapper, head, Vector3.new(hs.X*1.15, hs.Y*1.08, hs.Z*1.15), Vector3.new(0, 0, 0), dark, Enum.Material.Metal)
	makePart(wrapper, head, Vector3.new(hs.X*0.95, hs.Y*0.25, hs.Z*0.12), Vector3.new(0, hs.Y*0.02, -hs.Z*0.68), visor, Enum.Material.Neon, Enum.PartType.Block)
end

function ClassCosmetics.Apply(className, character)
	if not character then return end
	clearOld(character)

	local classFolder = ASSETS_FOLDER:FindFirstChild(className)
	if classFolder then
		local desc = classFolder:FindFirstChild("Description")
		if desc and desc:IsA("HumanoidDescription") then
			local humanoid = character:FindFirstChildOfClass("Humanoid")
			if humanoid then
				humanoid:ApplyDescription(desc)
			end
		end
		local armor = classFolder:FindFirstChild("Armor")
		if armor and #armor:GetChildren() > 0 then
			attachArmor(armor, character)
			return
		end
	end

	local builder = ProceduralBuilders[className]
	if builder then
		builder(character)
	end
end

function ClassCosmetics.Clear(character)
	if not character then return end
	clearOld(character)
end

return ClassCosmetics
