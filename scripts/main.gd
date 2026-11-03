extends Node3D
## Scène de départ du jeu.
## Elle charge le niveau 1, le tutoriel (scenes/levels/niveau_1.tscn).
## Elle place aussi les deux joueurs, l'Aimant (joueur 1) et le Ressort (joueur 2),
## au début de la première salle, ainsi que la caméra commune.
## L'ancienne salle de test reste dans scenes/levels/test_room.tscn.


func _ready() -> void:
	# Ce message s'affiche dans le panneau « Output » en bas de l'éditeur.
	print("Mag & Spring : le niveau 1 et les joueurs sont chargés.")
