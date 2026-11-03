# Mag & Spring

Jeu 3D de plateforme et d'énigmes en coop à deux, fait avec Godot 4 (GDScript).

- **L'Aimant** attire ou repousse les objets métalliques (touche maintenue).
- **Le Ressort** fait de grands sauts et active les boutons lourds, mais ne peut rien faire avec le métal.

Nom de travail en français : « Aimant & Ressort ».

## Ouvrir le projet

1. Installer **Godot 4.5** (ou plus récent), version **standard** (pas la version .NET) : <https://godotengine.org/download>.
2. Dans le gestionnaire de projets de Godot : **Importer**, choisir le fichier `project.godot` de ce dossier.
3. Appuyer sur **F5** pour lancer le jeu.

## Commandes

| | Aimant (joueur 1) | Ressort (joueur 2) |
| --- | --- | --- |
| Se déplacer | Z Q S D | Flèches |
| Sauter | Espace | Entrée |
| Attirer le métal (maintenir) | E | — |
| Repousser le métal (maintenir) | A | — |
| Grand saut (maintenir pour charger, relâcher pour sauter) | — | Maj droite ou 0 du pavé numérique |
| Manette | Manette n°1 : stick gauche + A, gâchettes hautes RB attirer / LB repousser | Manette n°2 : stick gauche + A, B grand saut |

Les touches sont définies par leur position sur le clavier : Z Q S D et A E en AZERTY correspondent à W A S D et Q E en QWERTY.
On peut les changer dans Projet > Paramètres du projet > Contrôles (actions `p1_...` et `p2_...`).

## Rangement des dossiers

| Dossier | Contenu |
| --- | --- |
| `scenes/` | Les scènes Godot (`.tscn`). `main.tscn` est la scène lancée au démarrage. |
| `scenes/levels/` | Les niveaux du jeu : `niveau_1.tscn` (le tutoriel, lancé au démarrage) et `test_room.tscn` (l'ancienne salle de test de la v0, décor seul). |
| `scenes/players/` | Les deux personnages, l'Aimant et le Ressort. |
| `scenes/objects/` | Les objets du décor qui réagissent : caisse métallique, bouton, porte. |
| `scripts/` | Le code GDScript (`.gd`), rangé comme les scènes. |
| `assets/materials/` | Les couleurs et matériaux réutilisés. |

Les fichiers `.uid` et `.import` sont créés par Godot : on les garde dans le dépôt.
Le dossier `.godot/` est un cache local, ignoré par git.

## Choix techniques

- **Rendu « Compatibility »** : le seul qui fonctionne dans un navigateur (WebGL 2), car le jeu visera le Web.
- **Physique Jolt** : moteur physique intégré à Godot, plus stable pour les objets poussés.
- **Fenêtre 1280 × 720** qui s'adapte à la taille de l'écran.

## Code couleur

Chaque type d'objet a sa couleur, pour comprendre la salle d'un coup d'œil.

| Couleur | Objet |
| --- | --- |
| Gris clair | Sol |
| Gris ardoise | Murs |
| Vert | Marches, accessibles avec un saut normal |
| Violet | Bloc haut (4,25 m), réservé au grand saut du Ressort |
| Gris acier, brillant | Objets métalliques, que seul l'Aimant peut déplacer |
| Bleu | L'Aimant (étape 3) |
| Orange | Le Ressort (étape 3) |
| Rouge (vert une fois enfoncé) | Bouton lourd, que seul le Ressort enfonce |
| Jaune | Porte, ouverte par le bouton lourd |
| Blanc lumineux | Arrivée, derrière la porte |

## Feuille de route de la v0

1. Projet initialisé, dossiers rangés. ✅
2. Salle de test en blocs simples. ✅
3. Deux personnages : déplacement, saut, touches séparées. ✅
4. Caméra qui suit les deux joueurs. ✅
5. Pouvoir de l'Aimant sur une caisse métallique. ✅
6. Grand saut du Ressort et bouton lourd qui ouvre une porte. ✅

## Niveau 1 : le tutoriel

Trois salles côte à côte, de gauche à droite. La caméra regarde vers le fond : les murs entre les salles ne cachent donc pas les joueurs.

1. **Salle de l'Aimant** : une caisse en métal bouche le passage vers la salle 2. L'Aimant l'attire (E) pour libérer le chemin. ✅ (étape 1)
2. **Salle du Ressort** : la porte vers la salle 3 s'ouvre avec un bouton lourd posé en haut d'un bloc violet, que seul le grand saut atteint. (étape 2)
3. **Salle « Ensemble »** : l'arrivée est en haut d'un bloc de 2,5 m. Le Ressort ouvre la niche où est enfermée une caisse, l'Aimant s'en sert de marche pour monter. (étape 3)

Le passage de la salle 1 est bas (2,2 m) : on ne peut pas sauter par-dessus la caisse.
Les murs font 8 m de haut : le grand saut monte à environ 5,2 m, et jusqu'à 6,2 m si le Ressort s'élance depuis la caisse. Les murs entre les salles dépassent un peu dans le vide à l'avant, pour qu'on ne puisse pas les contourner en sautant.
Un petit rebord court le long de l'avant du niveau pour que la caisse ne tombe pas dans le vide. Si elle tombe quand même, elle revient à sa place de départ.

Après la v0 : export Web servi par un VPS et jeu en ligne à deux via un relais WebSocket.

## Règle de conception des niveaux

Pas de plateformes qui flottent dans le vide : tout ce qui est en hauteur est un bloc plein posé au sol.
Avec la caméra en perspective, on juge mal où se trouve une plateforme volante et on se cogne la tête dessous.
