extends RigidBody3D
## Une caisse en métal : la physique de Godot la fait tomber, glisser et rebondir.
## Elle est dans le groupe « metal » : c'est ce groupe que l'Aimant cherche
## autour de lui. Le Ressort, lui, ne sait rien faire avec le métal.

# Point de départ, pour y revenir si la caisse tombe hors du niveau.
var _depart: Transform3D


func _ready() -> void:
	add_to_group("metal")
	_depart = global_transform


func _physics_process(_delta: float) -> void:
	# Filet de sécurité : sans caisse, l'énigme serait bloquée. Si elle tombe
	# dans le vide, elle réapparaît à sa place de départ, immobile.
	if global_position.y < -10.0:
		global_transform = _depart
		linear_velocity = Vector3.ZERO
		angular_velocity = Vector3.ZERO
