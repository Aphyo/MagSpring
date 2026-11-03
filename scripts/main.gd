extends Node3D
## Scène de départ du jeu.
## Elle charge la salle de test (scenes/levels/test_room.tscn).
## Les joueurs y seront ajoutés à l'étape 3.


func _ready() -> void:
	# Ce message s'affiche dans le panneau « Output » en bas de l'éditeur.
	print("Mag & Spring : la salle de test est chargée.")
