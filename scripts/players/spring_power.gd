extends Node3D
## Le pouvoir du Ressort, à placer comme enfant du joueur Ressort.
## Touche maintenue au sol : le Ressort se tasse et charge son saut.
## Touche relâchée : il bondit, d'autant plus haut que la charge était longue.
## Il fait aussi partie du groupe « lourd » : c'est lui qui peut enfoncer les boutons lourds.

## Vitesse de départ sans charge (comme un saut normal).
@export var force_min: float = 9.5
## Vitesse de départ à pleine charge : 16 donne un saut d'environ 5 m.
@export var force_max: float = 16.0
## Temps pour charger complètement, en secondes.
@export var temps_charge: float = 0.8
## À quel point le corps s'écrase à pleine charge (1 = pas du tout).
@export var ecrasement_max: float = 0.6

@onready var joueur: CharacterBody3D = get_parent()
@onready var corps: Node3D = get_parent().get_node("Corps")

# Charge actuelle, entre 0 (rien) et 1 (pleine charge).
var charge: float = 0.0
var _en_charge := false


func _ready() -> void:
	joueur.add_to_group("lourd")


func _physics_process(delta: float) -> void:
	var touche: String = joueur.action("grand_saut")

	# On commence à charger seulement si on est au sol.
	if Input.is_action_pressed(touche) and joueur.is_on_floor():
		_en_charge = true
		charge = minf(charge + delta / temps_charge, 1.0)
	elif _en_charge and not Input.is_action_pressed(touche):
		# Touche relâchée : on saute ! lerp mélange force_min et force_max selon la charge.
		if joueur.is_on_floor():
			joueur.velocity.y = lerpf(force_min, force_max, charge)
		_en_charge = false
		charge = 0.0
	elif not joueur.is_on_floor():
		_en_charge = false
		charge = 0.0

	# Le corps se tasse pendant la charge, pour qu'on voie qu'il se prépare.
	var hauteur := lerpf(1.0, ecrasement_max, charge)
	corps.scale = Vector3(1.0 / sqrt(hauteur), hauteur, 1.0 / sqrt(hauteur))
