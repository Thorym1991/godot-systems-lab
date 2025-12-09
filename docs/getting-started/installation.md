# Installation & Setup

This guide explains how to download, open, and run the **Godot Systems Lab** project.
The goal is to help you quickly start exploring the demo scenes and the modular systems included.

---

## 📦 Requirements

Before you begin, make sure you have:

- **Godot 4.2+** (recommended: latest stable)
- A system that supports Godot’s Vulkan backend
- Git (optional, only needed if you want to clone the repository)

Download Godot here:  
https://godotengine.org/download

---

## 1. 📥 Download the Project

You can obtain the project in two ways:


### **Option A – Clone via Git**
\`\`\`bash
git clone https://github.com/Thorym1991/godot-systems-lab.git
\`\`\`


### **Option B – Download ZIP**
1. Open the repository page  
2. Click **Code → Download ZIP**  
3. Extract the folder anywhere on your computer  

---

## 2. 📂 Open the Project in Godot

1. Start Godot 4  
2. Click **Import**  
3. Navigate to the folder:
	godot-systems-lab/project.godot
4. Select it and press **Import & Edit**

Godot will index the files, import textures, and display the project tree.

---

## 3. ▶️ Run the Demo Hub

This project includes a central Demo Hub for launching all test scenes.

To start it:

Open in the Godot editor:
	res://Demo/DemoHub.tscn


Click **Play Scene** (F6)  
—or press F5 to run the full project.

The Demo Hub allows you to quickly open:

- Topdown Player Demo  
- Platformer Player Demo  
- Interaction System Demo  
- Future systems (Inventory, Dialogue, Combat, etc.)  

---

## 4. 🎨 Adjusting Project Settings (Optional)
### Custom Boot Splash

This project includes a custom splash screen image:
	res://Assets/gsl_splash_full_1280x720.png

To enable it:

Project → Project Settings → Application → **Boot Splash**

Set:

- **Image:** the splash PNG  
- **Show Godot Logo:** OFF  
- **BG Color:** `#0d1a14`  

---

## 5. 🧪 Running Individual Demos

Each system includes its own test scenes:
	res://Demo/player_state_demo/
	res://Demo/interaction_demo/
	res://Demo/platformer/
	res://Demo/topdown/


Open any `.tscn` file and press **F6** to run it directly.

---

## 🎉 You're ready!

You now have the project installed and running.  
Continue with the next page:

📄 **folder-structure.md**  
to understand how the framework is organized internally.
