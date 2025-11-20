# Architecture Report

This report highlights the core architecture of the project.

Last updated: Thursday, November 21, 2025

## Summary of Findings

The project is highly modular, dividing CLIENT, SERVER and SHARED modules.

The project gives a lot of power to CONFIG modules (src/Shared/Config) since the project will have a lot of content and most of that contant should not have dedicated code but
rather it should be made using simple config files, otherwise the project would become a mess.

The project has important core concepts:

- Concept of ENTITY: An entity is the physical body, the rig of an NPC or player, it's a vessel, the players and npcs both have an entity associated to them.

- Concept of BACKPACK: The backpack is an abstract concept that allows both NPCS and players to have tools , equip them, unequip them and just have them in general.

- Concept of ABILITY: Tools have one or more abilities. Abilities let you do something when you have a certain tool equipped. Both NPCS and Players use the same abilities code,
  however players have extra code for stuff like inputs.

- Concept of VIEWMODEL: Only players have viewmodels, and they only exist on the client, they mirror the entities movement, animations and tools equipped. It's the classic FPS viewmodel.

- Concept of ANIMA: Animas are only for players, they rappresent the players , so they handle stuff like client cameras.
