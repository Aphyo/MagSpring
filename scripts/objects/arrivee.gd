extends Area3D
## L'arrivée du niveau : une zone posée au sol.
## Quand les deux joueurs (groupe « joueurs ») sont dedans en même temps,
## le niveau est réussi : on affiche « Bravo ! » et on envoie le signal « reussi ».

signal reussi

@onready var bravo: Label3D = $Bravo

var termine := false


func _ready() -> void:
	bravo.visible = false


func _physics_process(_delta: float) -> void:
	if termine:
		return
	# On compte les joueurs présents dans la zone.
	var nombre := 0
	for corps in get_overlapping_bodies():
		if corps.is_in_group("joueurs"):
			nombre += 1
	if nombre >= 2:
		termine = true
		bravo.visible = true
		print("Mag & Spring : niveau réussi !")
		reussi.emit()
