extends Node3D
## Scène de départ du jeu.
## Elle charge la salle de test (scenes/levels/test_room.tscn).
## Elle place aussi les deux joueurs, l'Aimant (joueur 1) et le Ressort (joueur 2).


func _ready() -> void:
	# Ce message s'affiche dans le panneau « Output » en bas de l'éditeur.
	print("Mag & Spring : la salle de test et les joueurs sont chargés.")
