extends Camera3D
## Caméra qui garde les deux joueurs à l'écran, sans écran partagé.
## Elle vise le point au milieu des deux joueurs, et recule quand ils s'éloignent
## l'un de l'autre. Ses mouvements sont lissés pour ne pas donner le mal de mer.

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
## Douceur du suivi : plus c'est petit, plus la caméra est lente à suivre.
@export var lissage: float = 4.0

# Le point que la caméra regarde, lissé d'une image à l'autre.
var _point_vise: Vector3


func _ready() -> void:
	_point_vise = _milieu()
	global_position = _position_voulue(_point_vise)
	look_at(_point_vise)


func _process(delta: float) -> void:
	if joueur_a == null or joueur_b == null:
		return
	# On rapproche doucement le point visé du vrai milieu (lerp = mélange entre deux valeurs).
	var poids := 1.0 - exp(-lissage * delta)
	_point_vise = _point_vise.lerp(_milieu(), poids)
	global_position = global_position.lerp(_position_voulue(_point_vise), poids)
	look_at(_point_vise)


## Le milieu entre les deux joueurs, un peu au-dessus du sol (hauteur du torse).
func _milieu() -> Vector3:
	return (joueur_a.global_position + joueur_b.global_position) / 2.0 + Vector3(0, 1, 0)


## Où placer la caméra pour bien voir les deux joueurs autour de ce point.
func _position_voulue(point: Vector3) -> Vector3:
	var ecart := joueur_a.global_position.distance_to(joueur_b.global_position)
	var distance := clampf(distance_min + ecart * recul_par_metre, distance_min, distance_max)
	return point + direction_vue.normalized() * distance
