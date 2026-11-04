extends Node3D
## Scène de départ du jeu.
## Elle charge le niveau choisi, et contient les deux joueurs, l'Aimant (joueur 1)
## et le Ressort (joueur 2), ainsi que la caméra commune.
## Tous les niveaux commencent au même endroit : les joueurs n'ont pas à bouger.

## Le niveau à jouer. Pour en changer : clique sur « Main » dans l'arbre de la
## scène, puis dans l'Inspecteur, choisis un autre fichier de scenes/levels/.
@export var niveau: PackedScene


func _ready() -> void:
	# « instantiate » fabrique le niveau à partir de son fichier, puis on l'ajoute.
	add_child(niveau.instantiate())
	# Ce message s'affiche dans le panneau « Output » en bas de l'éditeur.
	print("Mag & Spring : le niveau et les joueurs sont chargés.")
