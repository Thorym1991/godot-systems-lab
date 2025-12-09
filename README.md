# Godot Systems Lab

A modular playground and framework for building 2D games in Godot 4.x.  
The goal of this project is to provide reusable systems (player state machines, interaction, inventory, UI, etc.) plus small demos that show how everything works.

---

## Features (current state)

- ✅ **Player State System (shared core)**
  - Platformer player with idle / move / air states
  - Topdown player with 4 / 8-way movement
- ✅ **Demo Hub**
  - Main menu to launch each demo
  - Back-to-hub overlay inside every demo
- 🧪 **Demos**
  - Platformer player demo
  - Topdown player demo
- 🚧 **Planned systems**
  - Interaction system demo
  - Inventory system demo
  - Save/Load, UI widgets, and more

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
