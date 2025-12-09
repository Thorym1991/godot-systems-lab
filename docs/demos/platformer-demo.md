### 🟦 Platformer Demo

**Path:**  
`Demo/player_state_demo/Platformer/PlayerDemoPF.tscn`

The Platformer demo showcases the 2D side-view movement system using states:

- Idle state  
- Move state  
- Air state  
- Basic gravity & jump behavior  
- Simple test world for evaluation

**Included files:**
Demo/
	player_state_demo/
		Platformer/
			PlayerDemoPF.tscn
			TestWorldPF.tscn

**What this demo demonstrates:**

- How the PlatformerPlayer uses the shared StateMachine  
- Clean separation between grounded and airborne logic  
- How player inputs transition between states  
- How minimal environment tiles are enough to test movement

This demo is intentionally lightweight and is meant to help you quickly test or understand the Player State System in a platformer context.
