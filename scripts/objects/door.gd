extends AnimatableBody3D
## Une porte qui coulisse vers le haut quand on appelle ouvrir().
## AnimatableBody3D est un corps solide qu'on peut déplacer par le code :
## il bloque les joueurs tant qu'il est fermé, puis les laisse passer.

## De combien la porte monte en s'ouvrant, en mètres.
@export var hauteur_ouverture: float = 2.9
## Durée de l'ouverture, en secondes.
@export var duree: float = 1.0

var ouverte := false


func ouvrir() -> void:
	if ouverte:
		return
	ouverte = true
	# Un « tween » fait glisser une valeur d'un point à un autre, en douceur.
	var tween := create_tween()
	tween.tween_property(self, "position:y", position.y + hauteur_ouverture, duree) \
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
