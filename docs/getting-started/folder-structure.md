# 📁 Project Folder Structure

This page explains how the **Godot Systems Lab** project is organized internally.  
Understanding the structure will help you navigate the framework, find systems quickly,  
and extend modules cleanly.

---

## 🧱 High-Level Overview
	res://
		project.godot
		icon.png
		core/
		Systems/
		Demo/
		Assets/
		docs/


Each major folder has a dedicated purpose:

- **core/** – Global systems shared by everything (signals, autoloads)
- **Systems/** – All reusable gameplay modules
- **Demo/** – Example scenes that demonstrate how each system works
- **Assets/** – Graphics used for demos (e.g., Ninja Adventure pack)
- **docs/** – Full documentation for the framework
- **project.godot** – Main project definition file

---

## 🧩 `core/` — Global Shared Functionality
core/
	utils
	globals/
		GlobalSignals.gd

### 📌 Purpose  
Contains **engine-level shared tools**, mainly:

- **GlobalSignals.gd**  
  Autoload singleton for decoupled communication  
  (UI events, player events, scene changes, etc.)

This folder should stay small and focused.

---

## 🛠 `Systems/` — All Reusable Gameplay Modules
Systems/
	player_state/
	Interaction/
	inventory/
	save_load/
	ui/

Each system is independent and can be plugged into other projects.

### Included Systems:

---

### 🎮 Player State System (`player_state/`)
player_state/
	StateMachine.gd
	PlayerState.gd
	platformer/
		PlatformerPlayer.gd
		states/
			IdleState.gd
			MoveState.gd
			AirState.gd
	topdown/
		TopdownPlayer2D.gd
		states/
			TopdownIdle.gd
			TopdownMove.gd
			TopdownMove8way.gd


Handles:

- State machine architecture  
- Shared base logic  
- Platformer + Topdown movement controllers  
- Clean state separation (idle/move/air…)

---

### 🕹 Interaction System (`Interaction/`)
Interaction/
	Lever.gd
	Interactable.gd


Provides:

- Base class for interactable objects  
- Example: Lever with state toggle and signal output  

---

### 🎒 Inventory System (`inventory/`)

*(Planned — placeholder for future modules)*

---

### 🖥 UI System (`ui/`)
ui/
	DemoBackHUD.tscn

Contains:

- Overlay UI used inside demo scenes  
- Back-to-hub button logic

---

## 🧪 `Demo/` — All Test Scenes & Playgrounds
Demo/
	DemoHub.tscn
	DemiHub.gd
	DemoBackHUD.gd
	player_state_demo/
		Platformer/
			PlayerDemoPF.tscn
			TestWorldPF.tscn
		Topdown/
			PlayerDemoTD.tscn
			TestWorldTD.tscn
	interaction_demo/
		topdown/
			interaction_TestWorld.tscn
			lever.gd
			lever.tscn
		platformer/
	inventory_demo

### DemoHub.tscn  
The main scene used to launch all test scenes.

### Why this folder exists  
To keep **framework code** separate from **demo implementations** —  
important for clean architecture.

---

## 🎨 `Assets/` — External Art & Resources
Assets/
Ninja Adventure - Asset Pack/
godot-systems-lab-banner.svg
gsl_splash_full_1280x720.png

Used for:

- Demo graphics  
- Custom splash screen  
- Project branding  

Framework logic does **not** depend on these assets.

---

## 📚 `docs/` — Documentation
docs/
	getting-started/
		installation.md
		folder-structure.md
	changelog.md
	roadmap.md
	systems/
	demos/
	reference/
	Archiv/
		demo.md
		Player_state.md
		project_overview.md


Contains the full documentation system.  
You're reading this file from here. 😊  

---

## 🧠 Summary

The project follows a **clear separation of concerns**:

- Framework modules → `Systems/`
- Global helpers → `core/`
- Demo scenes → `Demo/`
- Assets → `Assets/`
- Documentation → `docs/`

This ensures the framework scales cleanly and remains easy to maintain.

---

### ➡ Next recommended page:  
`systems/player-state-machine.md`
