	Title        = "GTE Hub",          -- shown at the top of the GUI
	SubTitle     = "Enter your key to continue",
	KeyLink      = "[https*:*//www.roblox.com/users/3446421502/profile](https://linkurl.pk/kbuE-Q7F)",  -- <-- change this any time
	ValidKeys    = {                      -- <-- put your real key(s) here
		"!Mooda12k",
	},
	AccentColor  = Color3.fromRGB(123, 92, 255),   -- violet
	AccentColor2 = Color3.fromRGB(55, 230, 230),   -- cyan
	BackColor    = Color3.fromRGB(15, 16, 22),
	PanelColor   = Color3.fromRGB(22, 23, 31),
}
_G.KeySystemConfig = CONFIG -- lets you tweak the link/keys live from console

----------------------------------------------------------------
-- SERVICES
----------------------------------------------------------------
local Players       = game:GetService("Players")
local TweenService  = game:GetService("TweenService")
local UserInputServ = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui   = LocalPlayer:WaitForChild("PlayerGui")

----------------------------------------------------------------
-- SMALL HELPERS
----------------------------------------------------------------
local function create(class, props, children)
	local inst = Instance.new(class)
	for prop, value in pairs(props or {}) do
		inst[prop] = value
	end
	for _, child in ipairs(children or {}) do
		child.Parent = inst
	end
	return inst
end

local function tween(obj, props, time, style, dir)
	local t = TweenService:Create(obj, TweenInfo.new(
		time or 0.25,
		style or Enum.EasingStyle.Quad,
		dir or Enum.EasingDirection.Out
	), props)
	t:Play()
	return t
end

local function notify(label, text, color, duration)
	label.Text = text
	label.TextColor3 = color
	label.TextTransparency = 1
	tween(label, { TextTransparency = 0 }, 0.2)
	task.delay(duration or 2.5, function()
		if label.Text == text then
			tween(label, { TextTransparency = 1 }, 0.4)
		end
	end)
end

----------------------------------------------------------------
-- DESTROY OLD GUI (so re-running the script doesn't duplicate it)
----------------------------------------------------------------
local old = PlayerGui:FindFirstChild("KeySystemGui")
if old then old:Destroy() end

----------------------------------------------------------------
-- BUILD GUI
----------------------------------------------------------------
local ScreenGui = create("ScreenGui", {
	Name = "KeySystemGui",
	ResetOnSpawn = false,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	IgnoreGuiInset = true,
	DisplayOrder = 999,
})
ScreenGui.Parent = PlayerGui

-- dim background
local Overlay = create("Frame", {
	Name = "Overlay",
	Size = UDim2.fromScale(1, 1),
	BackgroundColor3 = Color3.fromRGB(0, 0, 0),
	BackgroundTransparency = 1,
	ZIndex = 1,
}, {})
Overlay.Parent = ScreenGui
tween(Overlay, { BackgroundTransparency = 0.45 }, 0.3)

-- main panel
local Main = create("Frame", {
	Name = "Main",
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromScale(0.5, 0.5),
	Size = UDim2.fromOffset(380, 235),
	BackgroundColor3 = CONFIG.PanelColor,
	ZIndex = 2,
	ClipsDescendants = false,
}, {
	create("UICorner", { CornerRadius = UDim.new(0, 14) }),
})
Main.Parent = ScreenGui

-- animated gradient stroke around the panel
local Stroke = create("UIStroke", {
	Thickness = 1.5,
	Color = CONFIG.AccentColor,
	Transparency = 0.2,
})
Stroke.Parent = Main
local StrokeGradient = create("UIGradient", {
	Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, CONFIG.AccentColor),
		ColorSequenceKeypoint.new(0.5, CONFIG.AccentColor2),
		ColorSequenceKeypoint.new(1, CONFIG.AccentColor),
	}),
})
StrokeGradient.Parent = Stroke

task.spawn(function()
	while ScreenGui.Parent do
		StrokeGradient.Rotation = (StrokeGradient.Rotation + 1) % 360
		task.wait(0.02)
	end
end)

-- subtle inner top glow bar
local TopGlow = create("Frame", {
	Size = UDim2.new(1, 0, 0, 3),
	Position = UDim2.fromOffset(0, 0),
	BackgroundColor3 = CONFIG.AccentColor,
	BorderSizePixel = 0,
	ZIndex = 3,
}, {
	create("UICorner", { CornerRadius = UDim.new(1, 0) }),
	create("UIGradient", {
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, CONFIG.AccentColor),
			ColorSequenceKeypoint.new(1, CONFIG.AccentColor2),
		}),
	}),
})
TopGlow.Parent = Main

-- title
local Title = create("TextLabel", {
	Text = CONFIG.Title,
	Font = Enum.Font.GothamBlack,
	TextSize = 20,
	TextColor3 = Color3.fromRGB(240, 240, 245),
	BackgroundTransparency = 1,
	Size = UDim2.new(1, -30, 0, 30),
	Position = UDim2.fromOffset(20, 18),
	TextXAlignment = Enum.TextXAlignment.Left,
	ZIndex = 2,
})
Title.Parent = Main

local SubTitle = create("TextLabel", {
	Text = CONFIG.SubTitle,
	Font = Enum.Font.Gotham,
	TextSize = 13,
	TextColor3 = Color3.fromRGB(150, 152, 165),
	BackgroundTransparency = 1,
	Size = UDim2.new(1, -30, 0, 16),
	Position = UDim2.fromOffset(20, 46),
	TextXAlignment = Enum.TextXAlignment.Left,
	ZIndex = 2,
})
SubTitle.Parent = Main

-- key input box
local InputHolder = create("Frame", {
	Size = UDim2.new(1, -40, 0, 42),
	Position = UDim2.fromOffset(20, 75),
	BackgroundColor3 = CONFIG.BackColor,
	ZIndex = 2,
}, {
	create("UICorner", { CornerRadius = UDim.new(0, 10) }),
	create("UIStroke", { Color = Color3.fromRGB(45, 46, 58), Thickness = 1 }),
})
InputHolder.Parent = Main

local KeyBox = create("TextBox", {
	Size = UDim2.new(1, -20, 1, 0),
	Position = UDim2.fromOffset(10, 0),
	BackgroundTransparency = 1,
	Text = "",
	PlaceholderText = "Paste your key here...",
	PlaceholderColor3 = Color3.fromRGB(110, 112, 125),
	Font = Enum.Font.Code,
	TextSize = 15,
	TextColor3 = Color3.fromRGB(235, 235, 240),
	TextXAlignment = Enum.TextXAlignment.Left,
	ClearTextOnFocus = false,
	ZIndex = 2,
})
KeyBox.Parent = InputHolder

-- status label (feedback text)
local Status = create("TextLabel", {
	Text = "",
	Font = Enum.Font.GothamBold,
	TextSize = 12,
	TextColor3 = Color3.fromRGB(255, 90, 90),
	BackgroundTransparency = 1,
	TextTransparency = 1,
	Size = UDim2.new(1, -40, 0, 16),
	Position = UDim2.fromOffset(20, 121),
	TextXAlignment = Enum.TextXAlignment.Left,
	ZIndex = 2,
})
Status.Parent = Main

-- button factory (used for both buttons so they match)
local function makeButton(text, posX, color)
	local Btn = create("TextButton", {
		Text = "",
		Size = UDim2.new(0.5, -25, 0, 44),
		Position = UDim2.fromOffset(posX, 150),
		BackgroundColor3 = color,
		AutoButtonColor = false,
		ZIndex = 2,
	}, {
		create("UICorner", { CornerRadius = UDim.new(0, 10) }),
	})
	Btn.Parent = Main

	local Label = create("TextLabel", {
		Text = text,
		Font = Enum.Font.GothamBold,
		TextSize = 14,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		ZIndex = 3,
	})
	Label.Parent = Btn

	Btn.MouseEnter:Connect(function()
		tween(Btn, { BackgroundColor3 = color:Lerp(Color3.new(1, 1, 1), 0.15) }, 0.15)
	end)
	Btn.MouseLeave:Connect(function()
		tween(Btn, { BackgroundColor3 = color }, 0.15)
	end)
	Btn.MouseButton1Down:Connect(function()
		tween(Btn, { Size = UDim2.new(0.5, -25, 0, 41) }, 0.08)
	end)
	Btn.MouseButton1Up:Connect(function()
		tween(Btn, { Size = UDim2.new(0.5, -25, 0, 44) }, 0.08)
	end)

	return Btn
end

local CheckBtn = makeButton("Check Key", 20, CONFIG.AccentColor)
local CopyBtn  = makeButton("Copy Link", 200, Color3.fromRGB(40, 41, 52))

----------------------------------------------------------------
-- ENTRANCE ANIMATION
----------------------------------------------------------------
Main.Size = UDim2.fromOffset(380, 0)
Main.BackgroundTransparency = 1
Stroke.Transparency = 1
tween(Main, { Size = UDim2.fromOffset(380, 235), BackgroundTransparency = 0 }, 0.35, Enum.EasingStyle.Back)
tween(Stroke, { Transparency = 0.2 }, 0.5)

----------------------------------------------------------------
-- WHAT HAPPENS WHEN THE KEY IS CORRECT
-- (put / call your real script here)
----------------------------------------------------------------
local function OnKeyAccepted(loadstring(game:HttpGet("https://raw.githubusercontent.com/rexxymayor-ai/SCRIPTtt/refs/heads/main/script%20automs", true))())
	-- >>> YOUR MAIN SCRIPT CODE GOES HERE
 <<<
	print("[KeySystem] Key accepted - loading script...")

	tween(Overlay, { BackgroundTransparency = 1 }, 0.3)
	tween(Main, { BackgroundTransparency = 1, Size = UDim2.fromOffset(380, 0) }, 0.3)
	task.wait(0.35)
	ScreenGui:Destroy()
end

----------------------------------------------------------------
-- BUTTON LOGIC
----------------------------------------------------------------
local function isValidKey(key)
	for _, validKey in ipairs(CONFIG.ValidKeys) do
		if key == validKey then
			return true
		end
	end
	return false
end

CheckBtn.MouseButton1Click:Connect(function()
	local key = KeyBox.Text
	if key == "" then
		notify(Status, "Please enter a key first.", Color3.fromRGB(255, 170, 60))
		return
	end

	if isValidKey(key) then
		notify(Status, "Key accepted! Loading...", Color3.fromRGB(95, 230, 140), 1.2)
		KeyBox.TextEditable = false
		task.wait(0.6)
		OnKeyAccepted()
	else
		notify(Status, "Invalid key. Try again.", Color3.fromRGB(255, 90, 90))
		tween(InputHolder, { Position = UDim2.fromOffset(28, 75) }, 0.06)
		task.wait(0.06)
		tween(InputHolder, { Position = UDim2.fromOffset(12, 75) }, 0.06)
		task.wait(0.06)
		tween(InputHolder, { Position = UDim2.fromOffset(20, 75) }, 0.06)
	end
end)

CopyBtn.MouseButton1Click:Connect(function()
	local link = CONFIG.KeyLink
	local ok = false

	if setclipboard then
		ok = pcall(setclipboard, link)
	elseif toclipboard then
		ok = pcall(toclipboard, link)
	end

	if ok then
		notify(Status, "Link copied to clipboard Paste in browser for key and follow me!", Color3.fromRGB(95, 230, 140))
	else
		-- fallback: drop the link straight into the textbox so the player can copy it manually
		KeyBox.Text = link
		notify(Status, "Clipboard unavailable - link pasted below.", Color3.fromRGB(255, 170, 60), 3)
	end
end)

-- allow pressing Enter in the textbox to submit
KeyBox.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		CheckBtn.MouseButton1Click:Wait()
	end
end)
