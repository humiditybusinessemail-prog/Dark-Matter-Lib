# Dark-Matter-Lib
Introducing Dark Matter, the newest competent slick and smooth LUAU Library Hub.

# 🌌 Dark Matter UI Library

<p align="center">
  <img src="https://i.postimg.cc/cJQ521Mk/gptblackbg.png" alt="Dark Matter Logo" width="120" height="120"/>
</p>

<p align="center">
  <strong>A premium, ultra-sleek, charcoal-grey themed Lua GUI Library for Roblox.</strong><br/>
  Designed for speed, dynamic customization, and clean layouts.
</p>

---

## ✨ Features

- 👤 **Professional Design**: Charcoal-grey interface with neon purple accents (`#8A2BE2`).
- 🎨 **Dynamic Logo Downloader**: Automatically downloads and maps the custom space logo using local file-handling (`getcustomasset` / `writefile`).
- 📱 **Fully Responsive Layouts**: Automatically adjusting canvas parameters with zero element-clipping or layout breakage.
- ⚙️ **Interactive Controls**: Includes dynamic Buttons, Toggles, Sliders, Dropdowns, TextBoxes, and Tab-Grouping interfaces.
- 🚀 **Performant Visual Animation**: Hand-tuned transitions using Roblox `TweenService`.
- 🕹️ **Hotkey Hide Toggle**: Quickly hide/unhide the GUI using `RightControl`.

---

## 🚀 Quick Start / Bootstrapper

To run the UI directly using any modern Roblox client-side executor, use the bootstrapper script below:

```lua
-- Bootstrapping the Dark Matter UI
local repoPath = "https://raw.githubusercontent.com/YourUsername/YourRepository/main/DarkMatterLib.lua" -- Change this to your raw GitHub URL
local DarkMatter = loadstring(game:HttpGet(repoPath))()

-- Instantiating Window Frame
local Window = DarkMatter:CreateWindow("DARK MATTER", "v1.0.4 [PUBLIC]")

-- Create Navigation Page Tabs
local MainTab = Window:CreateTab("Main Hub")
local VisualsTab = Window:CreateTab("Visuals")

-- Creating Sections and Sub-elements
local CombatSec = MainTab:CreateSection("Combat Cheats")

CombatSec:CreateToggle("Aimbot Active", false, function(state)
    print("Aimbot Status: ", state)
end)

CombatSec:CreateSlider("FOV Range", 10, 360, 100, function(value)
    print("FOV Range changed: ", value)
end)
