extends AnimatableBody3D
## Une porte qui coulisse quand on appelle ouvrir(), et revient avec fermer().
## AnimatableBody3D est un corps solide qu'on peut déplacer par le code :
## il bloque les joueurs tant qu'il est fermé, puis les laisse passer.

## De combien la porte bouge en s'ouvrant, en mètres.
## Positif : elle monte dans le mur. Négatif : elle descend sous le sol
## (utile quand le mur au-dessus est trop bas pour la cacher).
@export var hauteur_ouverture: float = 2.9
## Durée de l'ouverture, en secondes.
@export var duree: float = 1.0

var ouverte := false

# Hauteur de la porte fermée, retenue au démarrage.
var _y_fermee: float
# Le mouvement en cours, pour pouvoir l'interrompre si on change d'avis.
var _tween: Tween


func _ready() -> void:
	_y_fermee = position.y


func ouvrir() -> void:
	if ouverte:
		return
	ouverte = true
	_glisser_vers(_y_fermee + hauteur_ouverture)


func fermer() -> void:
	if not ouverte:
		return
	ouverte = false
	_glisser_vers(_y_fermee)


func _glisser_vers(y_cible: float) -> void:
	# Si la porte bougeait déjà dans l'autre sens, on arrête ce mouvement.
	if _tween:
		_tween.kill()
	# Un « tween » fait glisser une valeur d'un point à un autre, en douceur.
	_tween = create_tween()
	_tween.tween_property(self, "position:y", y_cible, duree) \
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
