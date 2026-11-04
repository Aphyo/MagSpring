extends Node3D
## Un bouton lourd posé au sol. Seul un corps du groupe « lourd » peut l'enfoncer :
## le Ressort, ou une caisse en métal. L'Aimant est trop léger, il peut marcher
## dessus sans effet.
## Quand il s'enfonce, le bouton envoie le signal « active » ; dans les scènes de
## niveau, ce signal est branché sur la fonction ouvrir() d'une porte
## (onglet « Nœud » > Signaux, dans l'éditeur).
##
## Deux sortes de boutons :
## - normal : une fois enfoncé, il reste enfoncé pour toujours ;
## - maintenu : il remonte dès que plus rien de lourd n'est dessus, et envoie
##   alors le signal « relache » (branché sur fermer() de la porte).

signal active
signal relache

## Coché : le bouton ne reste enfoncé que tant qu'on reste dessus.
@export var maintenu: bool = false

const COULEUR_ENFONCE := Color(0.2, 0.8, 0.35)
## Un bouton maintenu est orange au repos, pour le reconnaître d'un coup d'œil.
const COULEUR_MAINTENU := Color(0.95, 0.55, 0.1)

@onready var dessus: MeshInstance3D = $Dessus

var enfonce := false
var _materiau := StandardMaterial3D.new()
var _couleur_repos: Color


func _ready() -> void:
	# On lit la couleur d'origine (rouge) avant de poser notre propre matériau.
	if maintenu:
		_couleur_repos = COULEUR_MAINTENU
	else:
		_couleur_repos = dessus.get_active_material(0).albedo_color
	_materiau.albedo_color = _couleur_repos
	dessus.material_override = _materiau


func _physics_process(_delta: float) -> void:
	# Un bouton normal déjà enfoncé n'a plus rien à faire.
	if enfonce and not maintenu:
		return

	var charge := _quelque_chose_de_lourd_dessus()
	if charge and not enfonce:
		_enfoncer()
	elif not charge and enfonce:
		_relacher()


func _quelque_chose_de_lourd_dessus() -> bool:
	for corps in $Zone.get_overlapping_bodies():
		if corps.is_in_group("lourd"):
			return true
	return false


func _enfoncer() -> void:
	enfonce = true
	# Le dessus du bouton descend et passe au vert.
	dessus.position.y -= 0.12
	_materiau.albedo_color = COULEUR_ENFONCE
	active.emit()


func _relacher() -> void:
	enfonce = false
	dessus.position.y += 0.12
	_materiau.albedo_color = _couleur_repos
	relache.emit()
