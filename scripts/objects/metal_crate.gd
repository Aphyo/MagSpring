extends RigidBody3D
## Une caisse en métal : la physique de Godot la fait tomber, glisser et rebondir.
## Elle est dans le groupe « metal » : c'est ce groupe que l'Aimant cherche
## autour de lui. Le Ressort, lui, ne sait rien faire avec le métal.


func _ready() -> void:
	add_to_group("metal")
