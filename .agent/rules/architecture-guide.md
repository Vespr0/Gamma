---
trigger: always_on
---

You must follow the project architecture.

If you must make changed against the project architecture the user must approve of the changes first.

The project is highly modular, dividing CLIENT, SERVER and SHARED modules.

The project gives a lot of power to CONFIG modules (src/Shared/Config) since the project will have a lot of content and most of that contant should not have dedicated code but
rather it should be made using simple config files, otherwise the project would become a mess.

- The game is MULTIPLAYER: Multiple players can play at once, meaning there can be multiple clients.

- Concept of ENTITY: An entity is the physical body, the rig of an NPC or player, it's a vessel, the players and npcs both have an entity associated to them.

  - The game has a lot of client entities but only one of those entities is the client player's entity.
  - The game has a lot of server entities but only one of those entities is the server player's entity.

- Concept of BACKPACK: The backpack is an abstract concept that allows both NPCS and players to have tools , equip them, unequip them and just have them in general.

- Concept of ABILITY: Tools have one or more abilities. Abilities let you do something when you have a certain tool equipped. Both NPCS and Players use the same abilities code,
  however players have extra code for stuff like inputs.

- Concept of VIEWMODEL: Only players have viewmodels, and they only exist on the client, they mirror the entities movement, animations and tools equipped. It's the classic FPS viewmodel.

- Concept of ANIMA: Animas are only for players, they rappresent the players , so they handle stuff like client cameras.
