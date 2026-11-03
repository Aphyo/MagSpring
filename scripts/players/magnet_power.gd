extends Node3D
## Le pouvoir de l'Aimant, à placer comme enfant du joueur Aimant.
## Touche maintenue : attire (E) ou repousse (A) les objets du groupe « metal » proches.
##
## Comment ça marche : pour chaque objet métallique à portée, on calcule la vitesse
## qu'on voudrait lui donner (vers l'Aimant ou à l'opposé), puis on le pousse avec
## une force juste assez forte pour l'en rapprocher. C'est plus stable qu'une
## force fixe, qui ferait partir la caisse comme une fusée.

## Distance maximale d'action, en mètres.
@export var portee: float = 8.0
## Vitesse maximale donnée à un objet attiré ou repoussé, en m/s.
@export var vitesse_max: float = 5.0
## En attirant, l'objet s'arrête à cette distance pour ne pas écraser l'Aimant.
@export var distance_arret: float = 2.0
## Réactivité : plus c'est grand, plus l'objet atteint vite sa vitesse voulue.
@export var reactivite: float = 6.0

## Couleurs du cercle au sol : bleu pour attirer, rouge pour repousser.
const COULEUR_ATTIRE := Color(0.3, 0.6, 1.0, 0.45)
const COULEUR_REPOUSSE := Color(1.0, 0.3, 0.25, 0.45)

@onready var joueur: CharacterBody3D = get_parent()
@onready var cercle: MeshInstance3D = $Cercle
var _materiau_cercle: StandardMaterial3D


func _ready() -> void:
	_materiau_cercle = cercle.get_active_material(0).duplicate()
	cercle.material_override = _materiau_cercle
	cercle.visible = false


func _physics_process(delta: float) -> void:
	# +1 = attirer, -1 = repousser, 0 = rien. Le joueur dit quelles touches sont les siennes.
	var sens := 0
	if Input.is_action_pressed(joueur.action("attirer")):
		sens = 1
	elif Input.is_action_pressed(joueur.action("repousser")):
		sens = -1

	cercle.visible = sens != 0
	if sens == 0:
		return
	_materiau_cercle.albedo_color = COULEUR_ATTIRE if sens == 1 else COULEUR_REPOUSSE

	for objet in get_tree().get_nodes_in_group("metal"):
		if objet is RigidBody3D:
			_agir_sur(objet, sens)


func _agir_sur(objet: RigidBody3D, sens: int) -> void:
	# Vecteur de l'objet vers l'Aimant, à plat (on ne soulève pas les objets).
	var vers_aimant := joueur.global_position - objet.global_position
	vers_aimant.y = 0.0
	var distance := vers_aimant.length()
	if distance > portee or distance < 0.01:
		return

	# La vitesse qu'on voudrait donner à l'objet.
	var vitesse_voulue := Vector3.ZERO
	if sens == 1 and distance > distance_arret:
		vitesse_voulue = vers_aimant.normalized() * vitesse_max
	elif sens == -1:
		# Plus l'objet est proche, plus il est repoussé fort.
		vitesse_voulue = -vers_aimant.normalized() * vitesse_max * (1.0 - distance / portee) * 1.5

	# On compare avec sa vitesse actuelle (à plat) et on pousse pour corriger l'écart.
	var vitesse_actuelle := objet.linear_velocity
	vitesse_actuelle.y = 0.0
	var force := (vitesse_voulue - vitesse_actuelle) * objet.mass * reactivite
	objet.apply_central_force(force)
	objet.sleeping = false
