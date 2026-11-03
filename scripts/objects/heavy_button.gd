extends Node3D
## Un bouton lourd posé au sol. Seul un joueur du groupe « lourd » (le Ressort)
## peut l'enfoncer : l'Aimant est trop léger, il peut marcher dessus sans effet.
## Une fois enfoncé, le bouton reste enfoncé et envoie le signal « active ».
## Dans main.tscn, ce signal est branché sur la fonction ouvrir() de la porte
## (onglet « Nœud » > Signaux, dans l'éditeur).

signal active

const COULEUR_ENFONCE := Color(0.2, 0.8, 0.35)

@onready var zone: Area3D = $Zone
@onready var dessus: MeshInstance3D = $Dessus

var enfonce := false


func _physics_process(_delta: float) -> void:
	if enfonce:
		return
	for corps in zone.get_overlapping_bodies():
		if corps.is_in_group("lourd"):
			_enfoncer()
			return


func _enfoncer() -> void:
	enfonce = true
	# Le dessus du bouton descend et passe au vert.
	dessus.position.y -= 0.12
	var materiau := StandardMaterial3D.new()
	materiau.albedo_color = COULEUR_ENFONCE
	dessus.material_override = materiau
	active.emit()
