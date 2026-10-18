# Revue de code d'IWinEnhanced

- Commit relu : `e5908a2` (10/04/2026), version 2.5. Cela représente 60 fichiers Lua et environ 8 700 lignes.
- Date de la revue : 17/10/2026. Tous les numéros de ligne renvoient à `e5908a2`.
- Périmètre : `core/` et les quatre classes implémentées (guerrier, druide, paladin, voleur). Les modules squelettes (chasseur, mage, prêtre, chaman, démoniste) n'ont été vérifiés que pour le point M-2.
- Méthode : lecture du code et vérification avec l'API 1.12. **Rien n'a été testé en jeu.**

Statuts :
- **Corrigé** : un commit de cette pull request modifie le code.
- **Retiré** : ce n'est pas un bug, d'après le retour de l'auteur.
- **Non modifié** : signalé seulement.

## Résumé

| # | Constat | Statut |
|---|---|---|
| I-1 | `/iwin consumableaoe` n'a aucun effet | Corrigé |
| I-2 | `GetTimeToEnergyMax` renvoie une heure, pas une durée | Corrigé |
| I-3 | Les événements enregistrent les fenêtres avec l'heure de l'appui précédent | Corrigé |
| I-4 | Erreur Lua du paladin avec PallyPowerTW sans assignation | Corrigé |
| I-5 | Priorité `and`/`or` du sélénien dans Starfire/Wrath | Retiré (voulu) |
| M-1 | Bonus Genesis (T2.5) testé avec les pièces Stormrage (T2) | Corrigé |
| M-2 | Les commandes communes plantent sur les classes squelettes | Corrigé |
| M-3 | `_G` utilisé dans `GetWeaponSpeed` | Corrigé |
| M-4 | Bonus 2 pièces Dreadnaught jamais détecté | Corrigé |
| M-5 | `GetCooldownRemaining` renvoie `false`, une comparaison non protégée | Corrigé |
| m-1 | Noms d'objets traités comme des motifs Lua | Corrigé |
| m-2 | Choix de la boisson et double utilisation dans `/ihydrate` | Corrigé |
| m-3 | Variables globales involontaires ou jamais définies | Corrigé (sauf `queueTime`) |
| m-4 | Messages de debug construits même quand le debug est désactivé | Corrigé là où un `nil` est possible |
| m-5 | `"BOOKTYPE_SPELL"` passé comme texte | Corrigé |
| m-6 | Charges des buffs du joueur et ID de sorts négatifs | Corrigé |
| m-7 | Maul du druide écrit l'anti-rebond dans la mauvaise table | Corrigé |
| m-8 | Talent Shield Wall lu une seule fois au chargement | Non modifié |
| m-9 | Validation des paramètres de `/iwin` | Corrigé en partie |
| m-10 | `energyPerSecondPrediction` du voleur | Erreur corrigée, le reste non modifié |
| m-11 | Estimation de la rage du druide en fin de combat | Retiré (même comportement que le guerrier) |
| m-12 | `targettarget` gardé dans le cache de la cible, ordre des commandes du druide | Corrigé |

## Important : effet visible en jeu

### I-1 `/iwin consumableaoe` n'a aucun effet (Corrigé)

`core/condition.lua:1484`, `core/event.lua:16`, commande `consumableaoe` dans `*/setup.lua`

La commande et la valeur par défaut écrivent `IWin_Settings["consumableAOE"]`. `IsItemConsumableAOEOffensiveTarget` lit `IWin_Settings["consumableAOEOffensive"]`, qui vaut toujours `nil`. Aucun des tests `off`/`boss`/`elite` ne peut passer, donc la fonction renvoie `true` pour toutes les cibles, sauf les mannequins d'entraînement.

Le réglage par défaut `elite` est ignoré lui aussi. Les charges de sapeur, l'huile d'immolation, l'eau bénite et la dynamite dense partent sur n'importe quel groupe assez nombreux, même réglées sur `off`.

Correction : lire `IWin_Settings["consumableAOE"]`.

### I-2 `GetTimeToEnergyMax` renvoie une heure, pas une durée (Corrigé)

`druid/condition.lua:78`, `rogue/condition.lua:72`. La fonction est utilisée dans `druid/action.lua:445, 510` et `rogue/action.lua:112, 179, 300, 370, 402`.

`energyNextTickTime` est une heure absolue (`GetTime() + tickTime`, écrite dans le gestionnaire `UNIT_ENERGY`). `energyNextTickTime + tics × tickTime` vaut donc plusieurs milliers de secondes dès le premier tic détecté. Conséquences :
- `GetTimeToEnergyMax() < playerReactionDelay` n'est jamais vrai, sauf énergie déjà pleine ;
- `> GCDEnergy` est toujours vrai.

La protection contre le plafonnement de l'énergie ne fonctionne pas pour le félin et le voleur. `druid/action.lua:444` fait d'ailleurs déjà la bonne soustraction.

Correction : calculer d'abord le temps restant avant le prochain tic, `math.max(0, energyNextTickTime - IWin:GetTime(false))`, puis ajouter les tics restants.

### I-3 Les événements enregistrent les fenêtres avec l'heure de l'appui précédent (Corrigé)

- `warrior/event.lua:60, 64, 68, 72, 89, 93`
- `rogue/event.lua:32, 36, 40, 50`
- `druid/event.lua:51, 60, 64`

`IWin:GetTime()` met l'heure en cache dans `IWin_CombatVar["time"]`. Cette table n'est reconstruite qu'au prochain appui de touche, par `InitializeRotationCore`. Dans un gestionnaire `OnEvent`, elle renvoie donc l'heure du dernier appui, pas l'heure de l'événement. Les calculs touchés :
- les fenêtres d'Overpower, de Revenge, de Riposte et de Surprise Attack ;
- la fin d'incantation de Slam ;
- le prochain tic d'énergie.

Le module voleur mélange d'ailleurs les deux : les fenêtres sont écrites avec l'heure en cache, et relues avec le vrai `GetTime()` dans `rogue/condition.lua`.

**Retour de l'auteur :** « pour utiliser la fenêtre, le joueur va appuyer sur une touche et donc mettre à jour l'heure. »

C'est vrai pour la *lecture* : la comparaison se fait pendant un appui, avec une heure à jour. Le problème est à l'*écriture* : la fin de la fenêtre est calculée au moment de l'événement, à partir de l'heure gardée depuis l'appui précédent.

Exemple :
1. Dernier appui à t = 100.
2. La cible esquive à t = 103, sans appui pendant ces 3 secondes.
3. Le gestionnaire enregistre `overpowerAvailable = 100 + 4 = 104`, au lieu de 107.
4. Le joueur appuie à t = 104,5 : Overpower est considéré comme expiré, alors qu'il est utilisable jusqu'à 107.

Si on spamme la touche toutes les 0,2 s, l'écart est d'au plus 0,2 s, ce qui explique qu'on le remarque rarement. Il compte en début de combat, après une pause ou pendant qu'on accumule de l'énergie.

`GetTime()` renvoie la même valeur pendant toute l'image, donc l'appeler directement dans les gestionnaires ne coûte rien. Cette correction est un commit séparé, qu'on peut retirer seul.

Correction : `GetTime()` au lieu de `IWin:GetTime(false)` dans les trois fichiers d'événements.

### I-4 Erreur Lua du paladin avec PallyPowerTW sans assignation (Corrigé)

`paladin/action.lua:33, 45, 61, 77, 90, 107`

Les fonctions de bénédiction lisent `PallyPower_Assignments[nom][4]`. Si PallyPowerTW est chargé mais n'a pas encore d'entrée pour ce paladin, `PallyPower_Assignments[nom]` vaut `nil`, et l'indexer provoque une erreur à chaque appui. Ça arrive avec une installation neuve, un nouveau personnage, ou quand aucune assignation n'a jamais été faite. Les tests d'aura (`PallyPower_AuraAssignments[nom] == x`) n'ont pas ce problème.

Correction : une petite fonction, `IWin:GetPallyPowerBlessingAssignment()`, qui renvoie `nil` quand il n'y a pas d'entrée.

### I-5 Priorité `and`/`or` du sélénien dans Starfire/Wrath (Retiré)

`druid/action.lua:753-765` (Starfire) et `796-808` (Wrath)

La condition s'écrit `dernier == "Wrath" and A and B and (pas de Solstice) or (deux Solstices)`. Comme `and` passe avant `or`, la clause « deux Solstices » suffit à elle seule, quel que soit le dernier sort lancé. Wrath est testé en premier dans `/iblast`, donc il est lancé à chaque fois tant que les deux Solstices sont actifs. Ça ne se produit qu'hors Éclipse arcanique, grâce à la garde extérieure `not Arcane Eclipse`.

**Retour de l'auteur :** Wrath est le meilleur sort de DPS et le sort de remplissage, donc ce comportement est voulu. Aucun changement.

Pour que l'intention saute aux yeux des futurs lecteurs, on peut sortir la clause « deux Solstices » des parenthèses et en faire une branche `or` à part.

## Moyen : bonus mal calculés, erreurs dans des cas précis

### M-1 Bonus Genesis (T2.5) testé avec les pièces Stormrage (T2) (Corrigé)

`druid/data.lua:23`

`GetGenesisFeral3P` compte `IWin_ItemSet["StormrageFeral"]` au lieu de `["GenesisFeral"]`, sans doute un copier-coller de la fonction du dessus. Le bonus T2.5 n'est jamais vu, et 3 pièces de T2 le déclenchent à tort : les coûts en énergie de Claw, Rake et Shred sont faux.

### M-2 Les commandes communes plantent sur les classes squelettes (Corrigé)

`core/rotation.lua` : `/inuke`, `/itrinket`, `/iconsumable`, `/iconsumableaoe`, `/icdshort`, `/icdlong`

Ces commandes sont enregistrées pour toutes les classes. Elles appellent des fonctions que seuls les modules guerrier, druide, paladin et voleur définissent, comme `UseItemTrinketOffensivePrepull` ou `CastCDShortOffensiveGCD`. Sur un chasseur, un mage, un prêtre, un chaman ou un démoniste, elles donnent l'erreur « attempt to call method ... (a nil value) ».

Correction : des fonctions vides par défaut à la fin de `core/action.lua`. Les fichiers d'action des classes sont chargés après, d'après le `.toc`, et les remplacent.

### M-3 `_G` utilisé dans `GetWeaponSpeed` (Corrigé)

`core/condition.lua:1533-1534`

Le client 1.12 ne garantit pas de table globale `_G` : SuperCleveRoidMacros se protège lui-même avec `local _G = _G or getfenv(0)`. `GetWeaponSpeed` est appelée à chaque appui du paladin, via le Sceau d'autorité (`paladin/action.lua:521`). Si `_G` vaut `nil`, le premier appel plante avant que le résultat soit mis en cache, et l'erreur revient donc à chaque appui. Le reste du code utilise `getglobal`.

Correction : `getglobal("IWin_TTextLeft" .. i)` et `getglobal("IWin_TTextRight" .. i)`.

### M-4 Bonus 2 pièces Dreadnaught jamais détecté (Corrigé)

`warrior/data.lua:75` utilise la clé `"Dreadnaught"`, alors que `core/data.lua:325` définit `"DreadnaughtDPS"`.

`CountEquippedSetItems(nil)` renvoie 0 sans erreur (vérifié dans SuperCleveRoidMacros), donc l'erreur est silencieuse : Death Wish et Sweeping Strikes gardent leur coût en rage complet.

### M-5 `GetCooldownRemaining` renvoie `false`, une comparaison non protégée (Corrigé)

`core/condition.lua:320`, appel non protégé dans `warrior/action.lua:925`

Comparer `false` à un nombre provoque une erreur. Presque tous les appels vérifient `IsSpellLearnt` avant, sauf `ShieldBlock`, qui compare directement le temps de recharge de Revenge. Revenge (niveau 14) arrive avant Shield Block (niveau 16), donc ça ne touche qu'un guerrier qui n'a pas appris Revenge, mais c'est un piège.

Correction : `IWin:IsSpellLearnt("Revenge")` avant la comparaison.

## Mineur : robustesse et qualité

### m-1 Noms d'objets traités comme des motifs Lua (Corrigé)

`core/action.lua:135`, `core/condition.lua:1426, 1441`

`strfind(lienObjet, objet)` traite le nom comme un motif. Dans « Freshly-Squeezed Lemonade » et « Sun-Parched Waterskin », le `-` est un quantificateur, donc ces objets ne sont jamais trouvés. `GetItemCountInBag` comptait aussi des emplacements, pas des objets.

Correction :
- recherche littérale, `string.find(lien, objet, 1, true)`, qui garde les noms partiels, comme dans `IsItemInBag("Firestone")` ;
- les piles sont additionnées avec `GetContainerItemInfo` ;
- `UseItem` renvoie `true` quand il a utilisé un objet.

### m-2 Choix de la boisson et double utilisation dans `/ihydrate` (Corrigé)

`core/action.lua:147-161`

Les tables de boissons sont parcourues dans l'ordre de `pairs`, qui est arbitraire. Le buff « Drink » n'apparaît qu'après la réponse du serveur, donc la boucle pouvait utiliser une deuxième boisson dans le même appui.

Correction : boissons invoquées d'abord, puis celles des marchands, niveau requis le plus haut d'abord, et arrêt après la première boisson utilisée.

### m-3 Variables globales involontaires ou jamais définies (Corrigé, sauf `queueTime`)

`core/condition.lua:87, 489-491, 654, 709`

- `spellID` (87) et `spellNameMaxRank` (489) étaient globales. Pour un sort sans « Rank 1 », `GetSpellNameMaxRank` renvoyait le nom calculé pour un sort précédent, ou plantait sur `nil`. Les deux sont maintenant locales.
- Le message de debug de `GetTimeToExecute` affichait `ttd` au lieu de `tte`.
- `IsPowerAvailable` utilisait une variable `unit` jamais définie. Cette fonction n'est appelée nulle part.
- **Non modifié :** `queueTime` est passé à `IsSpellSkip` dans environ 80 appels, mais n'est jamais défini. Il vaut donc `nil`, sauf si un autre addon crée une globale de ce nom. On dirait un paramètre resté en route. Je n'y ai pas touché, faute de connaître l'intention.

### m-4 Messages de debug construits même quand le debug est désactivé (Corrigé là où un `nil` est possible)

`core/condition.lua:662-667` et les fonctions de ressource

Le message est assemblé avant l'appel à `IWin:Debug`. Pour une unité dont le type de ressource n'est pas dans `IWin_PowerType` (focus = 2, bonheur = 4), `GetPowerType` concaténait `nil` et plantait, debug activé ou non.

Correction : `tostring()` autour du type de ressource dans `GetPowerType`, `GetPower`, `GetPowerMax`, `GetPowerPercent` et `IsPowerAvailable`. Ne construire les messages que si le debug est actif ferait aussi gagner du temps à chaque appui, mais ça touche toutes les fonctions et ça n'a pas été fait.

### m-5 `"BOOKTYPE_SPELL"` passé comme texte (Corrigé)

`core/condition.lua:301, 303, 321, 425`

La constante `BOOKTYPE_SPELL` vaut `"spell"`. Ces lignes passaient la chaîne `"BOOKTYPE_SPELL"`, ce qui ne fonctionne que parce que le client se rabat sur le grimoire du joueur. La ligne 370 utilise déjà la constante.

### m-6 Charges des buffs du joueur et ID de sorts négatifs (Corrigé)

`core/condition.lua:43, 87-89, 210`

- Le repli de `GetBuffStack` appelait `UnitBuff(unit, index)` avec un index venant de `GetPlayerBuff`. Cet index commence à 0 et suit une autre liste, donc on obtenait les charges d'un autre buff, ou 0. La fonction utilise maintenant `GetPlayerBuffApplications(index)`.
- `GetBuffRemaining` ne corrigeait pas les ID de sorts négatifs (au-delà de 32 767, ce qui inclut certains sorts de Turtle), contrairement à `GetPlayerBuffIndex` ligne 43. C'est fait maintenant.

### m-7 Maul du druide écrit l'anti-rebond dans la mauvaise table (Corrigé)

`druid/action.lua:368`

Maul écrivait `IWin_CombatVar["startAttackThrottle"]`. Cette table est remise à zéro à chaque appui, et `StartAttack` lit `IWin_RotationVar["startAttackThrottle"]`, là où Heroic Strike et Cleave du guerrier l'écrivent. L'anti-rebond après Maul était sans effet.

### m-8 Talent Shield Wall lu une seule fois au chargement (Non modifié)

`core/data.lua:269, 309`

`GetTalentRank("Shield Wall")` est appelé pendant le chargement du fichier, quand les talents ne sont pas forcément disponibles, et la valeur n'est jamais recalculée, même après une réinitialisation des talents. En vanilla, le talent s'appelle « Improved Shield Wall » et il allonge la durée au lieu de réduire le temps de recharge. Je n'y ai pas touché : les règles de Turtle WoW sont à vérifier d'abord.

### m-9 Validation des paramètres de `/iwin` (Corrigé en partie)

`warrior/setup.lua`, et les fichiers setup du druide, du paladin et du voleur

Corrigé :
- `tonumber(arguments[2]) < 0` plantait si l'on tapait autre chose qu'un nombre, par exemple `/iwin sapper abc`. Ces valeurs reçoivent maintenant le message « Possible values ».
- Les messages de `dtbattle` et `dtberserker` citent maintenant `execute` et `whirlwind`, que ces commandes acceptent.

Non modifié :
- `overpower`, `berserkerrage` et `rend` acceptent n'importe quelle valeur. Seul `off` les désactive, donc une faute de frappe sur `off` revient à « on ».
- `rageinfo` calcule des valeurs de réserve qu'il n'affiche jamais (lignes 252-259).

### m-10 `energyPerSecondPrediction` du voleur (Erreur corrigée, le reste non modifié)

`rogue/action.lua:5-8`

`IWin_Settings["energyPerSecondPrediction"]` n'est jamais initialisé, donc `nil * 2` planterait si un buff nommé exactement « Adrenaline » était actif. La valeur vaut maintenant 0 par défaut.

Non modifié : le buff de la technique du voleur s'appelle « Adrenaline Rush », et `IWin_CombatVar["energyPerSecondPrediction"]` n'est lu nulle part. Ces lignes peuvent sans doute être supprimées, ou le nom du buff corrigé, selon ce qui était prévu.

### m-11 Estimation de la rage du druide en fin de combat (Retiré)

`druid/event.lua:46-48`

Contrairement au guerrier, le druide ne remet pas `IWin_RLS` à `nil` en fin de combat. À la relecture, le résultat est le même : `IWin_RLS_lastRage = nil` arrête les mesures de rage, donc `IWin_RLS` garde la dernière estimation. `GetRagePerSecond` renvoie alors `max(réglage, w1)`, exactement comme le `IWin_RLS_lastValue` du guerrier. Aucun changement.

### m-12 `targettarget` gardé dans le cache de la cible, ordre des commandes du druide (Corrigé)

`core/condition.lua:1260-1282`, `druid/rotation.lua:134, 144, 155`

- `IWin_Target["exists"]` et `["name"]` ne sont vidés que sur `PLAYER_TARGET_CHANGED`. `IsInRange` leur passe aussi `"targettarget"` (Intervene du guerrier), qui change sans que le joueur change de cible : son existence restait figée à la première réponse. `IsExists` et `GetName` ne gardent maintenant en cache que `"target"` et `"player"`.
- Les commandes `/ichase`, `/irun` et `/itaunt` du druide appelaient `TargetEnemy` avant `InitializeRotation`, donc `TargetEnemy` lisait le cache de l'appui précédent. Elles suivent maintenant le même ordre que toutes les autres commandes.

## Ce qui est bien fait

- Découpage clair et cohérent par classe : data, condition, action, event, setup, rotation.
- Mise en cache systématique à chaque appui, donc peu d'appels répétés à l'API quand on spamme.
- Mode debug détaillé, très utile pour comprendre une décision de la rotation.
- Réservation de rage et d'énergie pour les prochains gros sorts : une vraie gestion des ressources plutôt qu'une simple liste de priorités.
- Estimation de la rage par seconde par moindres carrés récursifs : bien vu.
- Idiomes Lua 5.0 respectés (`string.gfind`, `arg`, pas de `#` ni de `select`), et vérifications `IsSpellLearnt` presque partout.

## Limites de cette revue

- Lecture du code uniquement, au commit `e5908a2`. Les comportements décrits se déduisent du code et de l'API 1.12 ; ils n'ont pas été observés en jeu.
- La syntaxe a été vérifiée avec `luac -p` de Lua 5.1, faute de compilateur Lua 5.0 sous la main. Ça ne détecte que les erreurs de syntaxe.
- Les règles propres à Turtle WoW n'ont pas toutes été vérifiées. L'auteur a confirmé que Pummel s'utilise en posture de combat sur Turtle WoW : passer de Défensive à Combat avant Pummel est donc correct.
- L'addon ne fonctionne qu'avec un client en anglais : textes du journal de combat (« dodge », « parry », « blocked »), infobulles (« sec cast », « Speed »), sous-types d'objets (« Shields », « Daggers ») et noms de sorts. Ce n'est pas un bug, mais on pourrait le mentionner dans le README.
- Les modules chasseur, mage, prêtre, chaman et démoniste sont des squelettes et n'ont pas été relus au-delà du point M-2.
