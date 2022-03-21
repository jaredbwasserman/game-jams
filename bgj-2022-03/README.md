# Blizzard Game Jam 2022-03

## Theme
Growth

## Assets Used
- Kenney Particle Pack: https://www.kenney.nl/assets/particle-pack

## TODO
- Bigger spells should do more damage and area damage
- Make it necessary to jump and shoot spell at height peak to damage certain monsters (cyclops perhaps?)
- Make fireball smoke scale with spell power (in additional to the ball part of the fireball)
   - Add smoke trail
   - https://github.com/godotengine/godot/issues/327
- Make lanterns (omni light objects in a rooms) where you shoot fire ball at lantern to make room light up (omni light visibility from off to on)
- Fireballs explode upon impact (closer to explosion center more damage)

## Ideas
- Necromancer concept
- Inspiration
   - The Unliving
   - Gauntlet
   - Merlin's Revenge
   - Legacy of Goku 2
   - Trick-O-Treat-O-Tron
   - Pikmin
- Left click is melee scythe attack
   - high speed, low power if click no hold down
   - low speed, high power as you hold down longer
   - able to move (but more slowly) while charging attack
- Right click is magic attack
   - hold down does not repeat, need to right-click every time
   - casts active magic ability and takes different amount of time depending on spell
- Number keys 1, 2, 3, 4, 5, etc are magic abilities
   - hit key to set active magic ability
   - scroll wheel also changes ability
   - each one has a different effect, cast time, and resourece requirement
- Spells
   - drain health of enemy
      - Requires some mana
      - Channels until mana runs out
   - summon bulwark skeleton (tank, high health, low damage)
      - Requires one human soul and some mana
      - Spawns at mouse location (with max radius from player)
   - summon ninja skeleton (DPS, low health, high damage)
      - Requires one human soul and some mana
      - Spawns at mouse location (with max radius from player)
- Resources
   - Spells require different resources
   - Get one human soul per kill
   - Mana recharge over time (fast out of combat)
   - Health recharge over time (fast out of combat)
- Potions
   - Health potion
   - Mana potion
- Levels
   - First level is a training area with unlimited mana and souls useful for testing combat
- Talents
   - Talents allow to learn everything
      - Charged melee attack, all spells
   - Talents also improve everything depending on play style
   - Talent points from hard challenges
   - Can refund plus respec in safe areas
- Implementation Details
   - Make sure cannot attack with scythe at the same time as cast spell
   - Make sure can only cast one spell at a time
   - Maybe some is_busy variable held by player?
   - Make sure to update current path node to 0 when path recalculated
   - Call `rooms_clear` if making multiple levels https://docs.godotengine.org/en/stable/classes/class_roommanager.html#class-roommanager-method-rooms-clear
   - Update icon of game (upper-left)

## Resources
- https://www.youtube.com/playlist?list=PLaGRTLvEbVzyUMwjUPgrreyRE3AY8jhOK
- https://www.youtube.com/watch?v=S7jBSs5j4-c
- https://www.reddit.com/r/godot/comments/p8tnh7/where_do_you_store_persistent_player_data_between/
- https://godotforums.org/discussion/18681/how-to-convert-mouse-coordinates-to-3d-position
- https://docs.godotengine.org/en/stable/tutorials/3d/portals/index.html
- https://magazine.renderosity.com/article/6392/making-a-nicer-looking-top-down-perspective-in-unity
- https://godotengine.org/qa/19177/define-the-limits-of-a-3d-camera
- https://www.youtube.com/watch?v=DBgIES-CIUI
- https://www.youtube.com/watch?v=DkJ2jYl-ESw
- https://www.youtube.com/watch?v=zua2AfUonYU
- https://www.godotforums.org/discussion/22779/x-at-gltf-import
- https://godotengine.org/qa/72120/how-to-change-the-size-of-the-collision-shape-in-script
