# Mag & Spring

Jeu 3D de plateforme et d'énigmes en coop à deux, fait avec Godot 4 (GDScript).

- **L'Aimant** attire ou repousse les objets métalliques (touche maintenue).
- **Le Ressort** fait de grands sauts et active les boutons lourds, mais ne peut rien faire avec le métal.

Nom de travail en français : « Aimant & Ressort ».

## Ouvrir le projet

1. Installer **Godot 4.5** (ou plus récent), version **standard** (pas la version .NET) : <https://godotengine.org/download>.
2. Dans le gestionnaire de projets de Godot : **Importer**, choisir le fichier `project.godot` de ce dossier.
3. Appuyer sur **F5** pour lancer le jeu.

## Rangement des dossiers

| Dossier | Contenu |
| --- | --- |
| `scenes/` | Les scènes Godot (`.tscn`). `main.tscn` est la scène lancée au démarrage. |
| `scenes/levels/` | Les salles du jeu (salle de test à l'étape 2). |
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
| Violet | Plateforme haute, réservée au grand saut du Ressort |
| Bleu | L'Aimant (étape 3) |
| Orange | Le Ressort (étape 3) |

## Feuille de route de la v0

1. Projet initialisé, dossiers rangés. ✅
2. Salle de test en blocs simples. ✅
3. Deux personnages : déplacement, saut, touches séparées.
4. Caméra qui suit les deux joueurs.
5. Pouvoir de l'Aimant sur une caisse métallique.
6. Grand saut du Ressort et bouton lourd qui ouvre une porte.

Après la v0 : export Web servi par un VPS et jeu en ligne à deux via un relais WebSocket.
