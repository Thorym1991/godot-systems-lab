### 🟦 Topdown Demo

**Path:**  
`Demo/player_state_demo/Topdown/PlayerDemoTD.tscn`

The Topdown Player demo showcases:

- 4-way and optional 8-way movement
- State-based movement logic (Idle, Move)
- Smooth directional transitions
- Example test world with obstacles and walkable areas

#### 🎮 Included States
- `TopdownIdle.gd`
- `TopdownMove.gd`
- (Optional) `TopdownMove8way.gd` — if enabled in the player script

#### 🌍 Scene Contents
- A simple, polished test world (`TestWorldTD.tscn`)
- Collision areas for movement testing
- Decorations (trees, grass, tiles)

#### 🧪 What to test
- Move in cardinal directions  
- Verify smooth state transitions  
- Check that collisions behave correctly  
- Try walking diagonally (if 8-way movement is enabled)  

This demo provides a clean playground for exploring how the Topdown Player State System works.
