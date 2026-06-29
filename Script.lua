local LINK_URL      = "[https*:*//www.roblox.com/users/3446421502/profile](https://linkurl.pk/kbuE-Q7F)"   -- <-- change this anytime
local VALID_KEYS     = {"FREE-KEY-123", "VIP-KEY-456"} -- <-- your real keys
local WHITELIST_FILE = "MyScript_Key.txt"             -- saved key file (executor only)
local UI_TITLE       = "KEY SYSTEM"
local UI_SUBTITLE    = "To Get Key Copy Link And Go to browser and follow the user"

----------------------------------------------------------------
-- SERVICES
----------------------------------------------------------------
local Players       = game:GetService("Players")
local TweenService  = game:GetService("TweenService")
local LocalPlayer   = Players.LocalPlayer

----------------------------------------------------------------
-- KEY CHECK (replace with your own logic / API call if you want)
----------------------------------------------------------------
local function CheckKeyFunction(key)
	for _, validKey in ipairs(VALID_KEYS) do
		if key == validKey then
			return true
		end
	end
	return false
end

----------------------------------------------------------------
-- SAVE / LOAD KEY (executor environment functions, optional)
----------------------------------------------------------------
local function SaveKey(key)
	pcall(function()
		writefile(WHITELIST_FILE, key)
	end)
end

local function LoadSavedKey()
	local ok, data = pcall(function()
		return readfile(WHITELIST_FILE)
	end)
	if ok then return data end
	return nil
end

----------------------------------------------------------------
-- BUILD UI
----------------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KeySystemUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = game:GetService("CoreGui")

-- Backdrop blur dim
local Backdrop = Instance.new("Frame")
Backdrop.Size = UDim2.fromScale(1, 1)
Backdrop.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Backdrop.BackgroundTransparency = 0.55
Backdrop.BorderSizePixel = 0
Backdrop.ZIndex = 0
Backdrop.Parent = ScreenGui

-- Main window
local Main = Instance.new("Frame")
Main.Size = UDim2.fromOffset(420, 260)
Main.Position = UDim2.fromScale(0.5, 0.5)
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 16)
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(120, 90, 255)
MainStroke.Thickness = 1.5
MainStroke.Transparency = 0.3
MainStroke.Parent = Main

-- Top gradient accent bar
local AccentBar = Instance.new("Frame")
AccentBar.Size = UDim2.new(1, 0, 0, 6)
AccentBar.Position = UDim2.fromOffset(0, 0)
AccentBar.BorderSizePixel = 0
AccentBar.Parent = Main

local AccentGradient = Instance.new("UIGradient")
AccentGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(130, 90, 255)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(90, 160, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 90, 200)),
})
AccentGradient.Parent = AccentBar

-- Title
local Title = Instance.new("TextLabel")
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, 0, 0, 36)
Title.Position = UDim2.fromOffset(0, 18)
Title.Font = Enum.Font.GothamBold
Title.Text = UI_TITLE
Title.TextSize = 22
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Parent = Main

local Subtitle = Instance.new("TextLabel")
Subtitle.BackgroundTransparency = 1
Subtitle.Size = UDim2.new(1, 0, 0, 20)
Subtitle.Position = UDim2.fromOffset(0, 52)
Subtitle.Font = Enum.Font.Gotham
Subtitle.Text = UI_SUBTITLE
Subtitle.TextSize = 13
Subtitle.TextColor3 = Color3.fromRGB(160, 160, 175)
Subtitle.Parent = Main

-- Key input box
local KeyBox = Instance.new("TextBox")
KeyBox.Size = UDim2.new(1, -40, 0, 40)
KeyBox.Position = UDim2.fromOffset(20, 84)
KeyBox.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
KeyBox.PlaceholderText = "Enter your key here..."
KeyBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 135)
KeyBox.Text = LoadSavedKey() or ""
KeyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyBox.Font = Enum.Font.Gotham
KeyBox.TextSize = 14
KeyBox.ClearTextOnFocus = false
KeyBox.Parent = Main

local KeyBoxCorner = Instance.new("UICorner")
KeyBoxCorner.CornerRadius = UDim.new(0, 10)
KeyBoxCorner.Parent = KeyBox

local KeyBoxStroke = Instance.new("UIStroke")
KeyBoxStroke.Color = Color3.fromRGB(90, 90, 110)
KeyBoxStroke.Thickness = 1
KeyBoxStroke.Parent = KeyBox

-- Status label
local StatusLabel = Instance.new("TextLabel")
StatusLabel.BackgroundTransparency = 1
StatusLabel.Size = UDim2.new(1, -40, 0, 18)
StatusLabel.Position = UDim2.fromOffset(20, 128)
StatusLabel.Font = Enum.Font.GothamMedium
StatusLabel.Text = ""
StatusLabel.TextSize = 13
StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.Parent = Main

----------------------------------------------------------------
-- Helper: build a button
----------------------------------------------------------------
local function CreateButton(text, posX, colorTop, colorBottom)
	local Btn = Instance.new("TextButton")
	Btn.Size = UDim2.fromOffset(180, 46)
	Btn.Position = UDim2.fromOffset(posX, 160)
	Btn.AutoButtonColor = false
	Btn.Text = text
	Btn.Font = Enum.Font.GothamBold
	Btn.TextSize = 14
	Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	Btn.BackgroundColor3 = colorTop
	Btn.Parent = Main

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 10)
	Corner.Parent = Btn

	local Gradient = Instance.new("UIGradient")
	Gradient.Color = ColorSequence.new(colorTop, colorBottom)
	Gradient.Rotation = 90
	Gradient.Parent = Btn

	-- hover / click animation
	Btn.MouseEnter:Connect(function()
		TweenService:Create(Btn, TweenInfo.new(0.15), {Size = UDim2.fromOffset(184, 48)}):Play()
	end)
	Btn.MouseLeave:Connect(function()
		TweenService:Create(Btn, TweenInfo.new(0.15), {Size = UDim2.fromOffset(180, 46)}):Play()
	end)
	Btn.MouseButton1Down:Connect(function()
		TweenService:Create(Btn, TweenInfo.new(0.1), {Size = UDim2.fromOffset(174, 44)}):Play()
	end)
	Btn.MouseButton1Up:Connect(function()
		TweenService:Create(Btn, TweenInfo.new(0.1), {Size = UDim2.fromOffset(180, 46)}):Play()
	end)

	return Btn
end

-- Left button: Check Key | Right button: Copy Link
local CheckKeyBtn = CreateButton("🔑 Check Key", 20, Color3.fromRGB(130, 90, 255), Color3.fromRGB(90, 70, 220))
local CopyLinkBtn = CreateButton("🔗 Copy Link", 220, Color3.fromRGB(90, 160, 255), Color3.fromRGB(60, 120, 220))

----------------------------------------------------------------
-- BUTTON LOGIC
----------------------------------------------------------------
local function FlashStatus(text, color)
	StatusLabel.Text = text
	StatusLabel.TextColor3 = color
end

CheckKeyBtn.MouseButton1Click:Connect(function()
	local enteredKey = KeyBox.Text

	if enteredKey == "" then
		FlashStatus("Please enter a key first.", Color3.fromRGB(255, 180, 80))
		return
	end

	if CheckKeyFunction(enteredKey) then
		SaveKey(enteredKey)
		FlashStatus("✅ Key valid! Welcome.", Color3.fromRGB(100, 255, 140))

		-- ============================================
		-- UNLOCK YOUR SCRIPT HERE (loadstring(game:HttpGet("https://raw.githubusercontent.com/rexxymayor-ai/SCRIPTtt/refs/heads/main/script%20automs", true))())
		-- e.g. close the GUI and load your main script
		-- ============================================
		task.wait(0.8)
		TweenService:Create(Main, TweenInfo.new(0.25), {Size = UDim2.fromOffset(420, 0)}):Play()
		task.wait(0.25)
		ScreenGui:Destroy()

		-- loadstring(game:HttpGet("YOUR_MAIN_SCRIPT_URL"))()
	else
		FlashStatus("❌ Invalid key. Try again.", Color3.fromRGB(255, 100, 100))
	end
end)

CopyLinkBtn.MouseButton1Click:Connect(function()
	local ok = pcall(function()
		setclipboard(LINK_URL)
	end)

	if ok then
		FlashStatus("📋 Link copied to clipboard!", Color3.fromRGB(120, 200, 255))
	else
		FlashStatus("Couldn't copy — clipboard not supported.", Color3.fromRGB(255, 180, 80))
	end
end)

----------------------------------------------------------------
-- INTRO ANIMATION
----------------------------------------------------------------
Main.Size = UDim2.fromOffset(420, 0)
TweenService:Create(Main, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
	Size = UDim2.fromOffset(420, 260)
}):Play()
