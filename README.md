res://
│── icon.svg
│
├── 📂 assets/
│   ├── sprites/
│   │   ├── bridge/          # Beams, joints, anchor points
│   │   ├── vehicles/        # Car, truck, bus (low poly style)
│   │   ├── environment/     # Mountains, ground, water
│   │   └── ui/              # Buttons, grid icons
│   ├── sounds/              # Click, place beam, stress crack, crash
│   ├── fonts/               # Budget & HUD text
│   └── materials/           # Low-poly shaders, stress color gradients
│
├── 📂 scenes/
│   ├── main/
│   │   ├── MainMenu.tscn
│   │   ├── Game.tscn          # Main simulation scene
│   │   └── LevelSelect.tscn
│   │
│   ├── bridge/
│   │   ├── Beam.tscn          # Placeable beam
│   │   ├── Joint.tscn         # Connection node
│   │   ├── Anchor.tscn        # Fixed world anchors
│   │   └── BridgeBuilder.tscn # Grid + snapping system
│   │
│   ├── vehicles/
│   │   ├── Vehicle.tscn       # Base vehicle scene
│   │   ├── Car.tscn
│   │   ├── Truck.tscn
│   │   └── Bus.tscn
│   │
│   ├── environment/
│   │   ├── Terrain.tscn
│   │   ├── Water.tscn
│   │   └── Background.tscn
│   │
│   └── ui/
│       ├── HUD.tscn           # Budget, stress meter, tools
│       ├── BuildToolbar.tscn  # Build / delete / move tools
│       ├── Feedback.tscn      # Success/fail messages
│       └── PauseMenu.tscn
│
├── 📂 scripts/
│   ├── core/
│   │   ├── GameManager.gd
│   │   ├── LevelManager.gd
│   │   └── InputManager.gd
│   │
│   ├── bridge/
│   │   ├── Beam.gd
│   │   ├── Joint.gd
│   │   ├── Anchor.gd
│   │   └── BridgeBuilder.gd
│   │
│   ├── vehicles/
│   │   ├── Vehicle.gd
│   │   ├── Car.gd
│   │   ├── Truck.gd
│   │   └── Bus.gd
│   │
│   ├── physics/
│   │   ├── FEA.gd             # Stress/strain solver
│   │   ├── EulerSolver.gd     # Time-step simulation
│   │   └── StressVisualizer.gd
│   │
│   └── ui/
│       ├── HUD.gd
│       ├── BuildToolbar.gd
│       └── Feedback.gd
│
├── 📂 levels/
│   ├── Level1.tscn
│   ├── Level2.tscn
│   └── ...
│
└── 📂 tests/
    ├── TestFEA.tscn
    ├── TestBridgeStress.tscn
    └── TestVehicles.tscn
