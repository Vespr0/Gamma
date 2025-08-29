# MainWorkflow.md

Workflow for Project Gamma

## Steps

1. Project gamma is a multiplayer sandbox FPS.

2. both Mobs and Players use a lot of the same code. In fact both Mobs and players use the same weapons and the same weapons code.

3. Entities are the physical manifestation of either a Mob or a player, entities are composed of the Rig and other physical parts or related logic.

4. Players are abstract instances that identify and describe the actual machine (with it's own ip address and location) used by someone to play the game.
The ClientAnima and ServerAnima classes refer to the player, so if you make something like recoil or camera movement it should be in ClientAnima.

5. Mobs are abstract instances that have a corresponding entity and are controlled by artificial intelligence and are able to use weapons thanks to the `mindController` signal and make requests the same way Players can, their requests also get replicated to players so that players can see the client effects/logic of the ability.

6. Weapons have abilities , the logic for abilities is divided in Client and Server.
