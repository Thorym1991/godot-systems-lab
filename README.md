<p align="center">
  <img src="Assets/gsl_splash_full_1280x720.png" alt="Godot Systems Lab Banner" width="100%" />
</p>


# Godot Systems Lab

A modular playground and framework for building 2D games in Godot 4.x.  
The goal of this project is to provide reusable systems (player state machines, interaction, inventory, UI, etc.) plus small demos that show how everything works.

---

## Features (current state)

- ✅ **Player State System (shared core)**
  - Platformer player with idle / move / air states
  - Topdown player with 4- / 8-way movement
  - Shared state machine base (`StateMachine.gd`, `PlayerState.gd`) for multiple player types

- ✅ **Interaction System**
  - Base class for interactables (`Interactable.gd`)
  - Example lever implementation (`Lever.gd`)
  - Signal-based, decoupled interaction flow
  - Topdown interaction demo scene

- ✅ **Demo Hub & UI**
  - Central **DemoHub.tscn** scene to launch all demos
  - In-game **Back-to-Hub overlay** (`DemoBackHUD.tscn`) inside every demo
  - Custom green branding & boot splash

- 🧪 **Demos**
  - Platformer player demo level
  - Topdown overworld demo
  - Topdown interaction demo (lever test world)

- 🧪 **Documentation**
  - Getting started: installation & project folder structure
  - System docs: player state machine, interaction system, UI system (WIP)
  - Demo overview + per-demo pages
  - Autoloads & signals reference

- 🚧 **Planned systems**
  - Inventory system (items, equipment, UI)
  - Save/Load & persistence layer
  - Extended UI widgets (menus, options, pause, etc.)
  - More interaction types (doors, chests, triggers, NPCs)
  - Additional systems (dialogue, combat, RPG-style mechanics)


---

## Project structure

```text
res://
  core/
	globals/
	  GlobalSignals.gd
  Systems/
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
	Interaction/
	inventory/
	ui/
	  DemoBackHUD.tscn
  Demo/
	DemoHub.tscn
	player_state_demo/
	  Platformer/
		PlayerDemoPF.tscn
		TestWorldPF.tscn
	  Topdown/
		PlayerDemoTD.tscn
		TestWorldTD.tscn
# Languages  
🇬🇧 [English](#english-version) • 🇩🇪 [Deutsch](#deutsche-version)

---

# 🇬🇧 English Version

## Current Project Status (December 2025)

### Modules / Directories
core/globals

GlobalSignals autoload singleton

Centralized signals for player, UI, and scene flow

Systems/

Player State System

Shared state machine base for multiple player types

States such as idle, move, air, etc.

TopdownPlayer2D

4/8-directional movement

Uses the shared state machine infrastructure

PlatformerPlayer

Running and jumping based on states

Clear grounded/airborne separation

Interaction System

Base class for interactable objects

Example lever demo with signals & state change

Demo/

DemoHub as the main entry

Separate demo scenes for topdown and platformer controllers

Assets/

Ninja Adventure pack (placeholder art)

What already works

Shared player state machine across multiple player types

Functional Topdown and Platformer controllers

GlobalSignals for loose coupling

Interaction system with working lever demo

DemoHub to launch demos

Initial documentation progress

Planned next steps

Further abstraction between framework and demo logic

More docs in /docs/ (how-tos, integration guides)

More demo scenes (inventory, dialogue system, combat)

Clearer namespaces & module structure

# 🇩🇪 Deutsche Version

Aktueller Stand des Projekts (Dezember 2025)

Module / Ordner

core/globals

GlobalSignals als Autoload-Singleton

Zentrale Signale für Spieler, UI und Szenenfluss

Systems/

Player State System

Gemeinsame State-Machine-Basis für mehrere Spielertypen

States wie idle, move, air usw.

TopdownPlayer2D

4-/8-Wege-Bewegung

Basierend auf dem gemeinsamen State-System

PlatformerPlayer

Lauf- und Sprunglogik über States

Trennung zwischen Boden- und Luftzustand

Interaktionssystem

Basisklasse für interaktive Objekte

Beispiel-Hebel mit Signalen & Zustandswechsel

Demo/

DemoHub als Einstiegspunkt

Einzelne Demo-Szenen für Topdown & Platformer

Assets/

Ninja Adventure Asset Pack (Platzhalter-Grafiken)
(kompletter Text aus meiner letzten Nachricht)

Was bereits funktioniert

Gemeinsames Spieler-State-System für verschiedene Player-Typen

Funktionierende Topdown- und Platformer-Bewegung

GlobalSignals für lose gekoppelte Kommunikation

Interaktionssystem mit Beispielhebel

DemoHub zum Starten der Demos

Erste Dokumentationsteile

Geplante nächste Schritte

Saubere Trennung zwischen Framework-Code und Demo-Code

Mehr Dokumentation in /docs/ (How-Tos, Integrationsbeispiele)

Weitere Demos (Inventar, Dialogsystem, Kampfsystem)

Klare Namespaces / Ordnerstruktur für zukünftige Module
