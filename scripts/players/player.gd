extends CharacterBody3D
## Un personnage jouable : il marche, saute et se tourne vers où il va.
## La même scène sert pour l'Aimant et le Ressort : seuls le numéro du joueur,
## le nom et la couleur changent (réglés dans l'Inspecteur, dans main.tscn).
## Les pouvoirs arriveront aux étapes 5 et 6.

## Numéro du joueur : 1 lit les actions « p1_... », 2 lit « p2_... »
## (voir Projet > Paramètres du projet > Contrôles).
## Plus tard, en réseau, c'est ce numéro qui dira quel joueur est distant.
@export_range(1, 2) var player_id: int = 1
## Nom affiché au-dessus de la tête.
@export var nom: String = "Joueur"
## Couleur du corps.
@export var couleur: Color = Color.WHITE

## Vitesse de marche, en mètres par seconde.
@export var vitesse: float = 5.0
## Vitesse de départ du saut : 9,5 donne un saut d'environ 1,8 m avec la gravité renforcée.
@export var force_saut: float = 9.5
## Gravité multipliée : la gravité réelle paraît trop « lunaire » dans un jeu.
@export var multiplicateur_gravite: float = 2.5
## En redescendant, on tombe encore plus vite : le saut paraît plus nerveux.
@export var multiplicateur_chute: float = 1.6
## Vitesse à laquelle le personnage se tourne vers sa direction.
@export var vitesse_rotation: float = 12.0

# La gravité réglée dans le projet (9,8 m/s² par défaut).
var gravite: float = ProjectSettings.get_setting("physics/3d/default_gravity")

# Point de départ, pour y revenir si le joueur tombe hors de la salle.
var _depart: Vector3

@onready var corps: MeshInstance3D = $Corps
@onready var etiquette: Label3D = $Etiquette


func _ready() -> void:
	# Chaque joueur reçoit son propre matériau, pour que les couleurs ne se mélangent pas.
	var materiau := StandardMaterial3D.new()
	materiau.albedo_color = couleur
	corps.material_override = materiau
	etiquette.text = nom
	etiquette.modulate = couleur.lightened(0.4)
	_depart = global_position
	# Le groupe « joueurs » permet à l'arrivée de reconnaître les deux personnages.
	add_to_group("joueurs")


func _physics_process(delta: float) -> void:
	# 1. Gravité : on tombe tant qu'on ne touche pas le sol.
	#    Elle est renforcée, et encore plus quand on redescend.
	if not is_on_floor():
		var g := gravite * multiplicateur_gravite
		if velocity.y < 0.0:
			g *= multiplicateur_chute
		velocity.y -= g * delta

	# 2. Saut : seulement si on est posé au sol.
	if Input.is_action_just_pressed(action("saut")) and is_on_floor():
		velocity.y = force_saut

	# 3. Déplacement : get_vector renvoie une direction (x, y) entre -1 et 1.
	#    Le y de l'écran devient le z du monde 3D (avant = -z, vers le fond de la salle).
	var entree := Input.get_vector(action("gauche"), action("droite"), action("avant"), action("arriere"))
	var direction := Vector3(entree.x, 0.0, entree.y)
	velocity.x = direction.x * vitesse
	velocity.z = direction.z * vitesse

	# 4. Se tourner doucement vers la direction de marche.
	if direction.length() > 0.1:
		var angle_vise := atan2(-direction.x, -direction.z)
		rotation.y = lerp_angle(rotation.y, angle_vise, vitesse_rotation * delta)

	# 5. move_and_slide déplace le personnage et gère les collisions (murs, marches...).
	move_and_slide()

	# 6. Filet de sécurité : si on tombe dans le vide (le devant de la salle est ouvert),
	#    on revient au point de départ.
	if global_position.y < -10.0:
		global_position = _depart
		velocity = Vector3.ZERO


## Construit le nom complet d'une action pour ce joueur, ex. « p1_saut ».
func action(nom_action: String) -> String:
	return "p%d_%s" % [player_id, nom_action]
