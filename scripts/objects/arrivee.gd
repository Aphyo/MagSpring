extends Area3D
## L'arrivée du niveau : une dalle au sol, surmontée d'une colonne de lumière
## et d'un panneau « Arrivée », pour qu'on la repère de loin.
## Quand les deux joueurs (groupe « joueurs ») sont dedans en même temps,
## le niveau est réussi : on affiche « Bravo ! » et on envoie le signal « reussi ».

signal reussi

## Vitesse de la pulsation de la colonne (battements par seconde).
@export var vitesse_pulsation: float = 0.8

@onready var bravo: Label3D = $Bravo
@onready var panneau: Label3D = $Panneau
@onready var colonne: MeshInstance3D = $Colonne

var termine := false
var _materiau_colonne: StandardMaterial3D
var _temps := 0.0


func _ready() -> void:
	bravo.visible = false
	# Copie du matériau, pour pouvoir changer sa transparence sans toucher aux autres.
	_materiau_colonne = colonne.get_active_material(0).duplicate()
	colonne.material_override = _materiau_colonne


func _process(delta: float) -> void:
	# La colonne « respire » doucement : sa transparence va et vient (sinus).
	_temps += delta
	_materiau_colonne.albedo_color.a = 0.18 + 0.12 * sin(_temps * TAU * vitesse_pulsation)


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
		panneau.visible = false
		print("Mag & Spring : niveau réussi !")
		reussi.emit()
