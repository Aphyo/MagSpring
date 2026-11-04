extends Camera3D
## Caméra qui garde les deux joueurs à l'écran, sans écran partagé.
## Elle vise le point au milieu des deux joueurs, et recule quand ils s'éloignent
## l'un de l'autre. Ses mouvements sont lissés pour ne pas donner le mal de mer.
##
## Pour éviter qu'elle tangue :
## - elle ne tourne jamais : son angle de vue est fixé au démarrage, elle ne fait
##   que glisser ;
## - elle suit très lentement la hauteur des joueurs, pour ne pas sauter avec eux ;
## - l'écart entre les joueurs est mesuré à plat : un grand saut ne la fait pas reculer.

## Les deux joueurs à suivre (à choisir dans l'Inspecteur).
@export var joueur_a: Node3D
@export var joueur_b: Node3D

## Direction depuis laquelle la caméra regarde : en hauteur et vers l'avant de la salle.
@export var direction_vue: Vector3 = Vector3(0, 8, 15.5)
## Distance quand les joueurs sont collés l'un à l'autre.
@export var distance_min: float = 12.0
## Distance maximale, pour ne pas voir les joueurs minuscules.
@export var distance_max: float = 22.0
## De combien la caméra recule pour chaque mètre d'écart entre les joueurs.
@export var recul_par_metre: float = 0.7
## Douceur du suivi de gauche à droite et d'avant en arrière.
## Plus c'est petit, plus la caméra est lente à suivre.
@export var lissage: float = 3.0
## Douceur du suivi en hauteur : beaucoup plus lent, pour ignorer les sauts.
@export var lissage_hauteur: float = 0.8
## Douceur du recul (zoom).
@export var lissage_distance: float = 1.5

# Le point que la caméra regarde et sa distance, lissés d'une image à l'autre.
var _point_vise: Vector3
var _distance: float


func _ready() -> void:
	_point_vise = _milieu()
	_distance = _distance_voulue()
	global_position = _point_vise + direction_vue.normalized() * _distance
	# On oriente la caméra une seule fois, ensuite elle ne tourne plus.
	look_at(_point_vise)


func _process(delta: float) -> void:
	if joueur_a == null or joueur_b == null:
		return
	# « poids » dit de combien on se rapproche de la cible à cette image
	# (lerp = mélange entre deux valeurs). Cette formule donne la même douceur
	# quel que soit le nombre d'images par seconde.
	var cible := _milieu()
	var poids := 1.0 - exp(-lissage * delta)
	var poids_hauteur := 1.0 - exp(-lissage_hauteur * delta)
	var poids_distance := 1.0 - exp(-lissage_distance * delta)

	_point_vise.x = lerpf(_point_vise.x, cible.x, poids)
	_point_vise.z = lerpf(_point_vise.z, cible.z, poids)
	_point_vise.y = lerpf(_point_vise.y, cible.y, poids_hauteur)
	_distance = lerpf(_distance, _distance_voulue(), poids_distance)

	# La caméra se place derrière le point visé, toujours dans la même direction.
	global_position = _point_vise + direction_vue.normalized() * _distance


## Le milieu entre les deux joueurs, un peu au-dessus du sol (hauteur du torse).
func _milieu() -> Vector3:
	return (joueur_a.global_position + joueur_b.global_position) / 2.0 + Vector3(0, 1, 0)


## La distance voulue selon l'écart entre les joueurs, mesuré à plat (sans la hauteur).
func _distance_voulue() -> float:
	var ecart := Vector2(joueur_a.global_position.x - joueur_b.global_position.x,
		joueur_a.global_position.z - joueur_b.global_position.z).length()
	return clampf(distance_min + ecart * recul_par_metre, distance_min, distance_max)
