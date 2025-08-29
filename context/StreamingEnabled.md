Source: https://create.roblox.com/docs/workspace/streaming

The game has `workspace.StreamingEnabled` set to `true`

n-experience instance streaming allows the Roblox Engine to dynamically load and unload 3D content and related instances in regions of the world. This can improve the overall player experience in several ways, for example:

Faster join times — Players can start playing in one part of the world while more of the world loads in the background.
Memory efficiency — Experiences can be played on devices with less memory since content is dynamically streamed in and out. More immersive and detailed worlds can be played on a wider range of devices.
Improved performance — Better frame rates and performance, as the server can spend less time and bandwidth synchronizing changes between the world and players in it. Clients spend less time updating instances that aren't currently relevant to the player.
Level of detail — Distant models and terrain remain visible even when they're not streamed to clients, keeping the experience optimized without entirely sacrificing background visuals.

---

Because clients will not typically have the entire Workspace available locally, use the appropriate tool/API to ensure that instances exist before attempting to access them in a LocalScript. For example, utilize per‑model streaming controls, detect instance streaming, or use WaitForChild() on objects that may not exist.

Minimize placement of 3D content outside of Workspace. Content in containers such as ReplicatedStorage or ReplicatedFirst is ineligible for streaming and may negatively impact join time and memory usage.

f you move a player's character by setting its CFrame, do so from a server-side Script and use streaming requests to more quickly load data around the character's new location.

Manually set replication foci only in unique situations such as experiences that don't use a Player.Character or where streaming should occur in multiple areas of the experience. In these cases, make sure the foci are near objects that the player controls or those that should continue simulating physically on the client, and try to minimize the overall number of foci used.

---

### Stream in

By default, when a player joins an experience with instance streaming enabled, instances in the Workspace are replicated to the client, excluding the following:

    Parts or MeshParts
    Atomic, Persistent, or PersistentPerPlayer models
    Descendants of the above instances
    Non-replicating instances

Then, during gameplay, the server may stream necessary instances to the client, as they are needed.

---

### Model behavior

Models set to non-default behavior like Atomic stream in under special rules as outlined in per‑model streaming controls. However, default (nonatomic) models are sent differently based on whether ModelStreamingBehavior is set to Default (Legacy) or Improved.

The ModelStreamingBehavior is set to Improved... this means model streaming behavior varies by whether the model is spatial (contains BasePart descendants) or non‑spatial (contains no BasePart descendants).

Instead of on player join, a spatial model (one containing BasePart descendants) is sent only when one of its BasePart descendants is eligible to stream in. At that point, the model and part are replicated, along with the model's non‑spatial descendants. Then, when eligible, the model's other spatial descendants stream in.

For a non‑spatial model (one without BasePart descendants), the model container and its descendants are replicated to the client soon after the player joins, and all are exempt from streaming out. Assuming the model exists in Workspace when the player joins, this occurs before the Workspace.PersistentLoaded event fires.

If you set ModelStreamingBehavior to Improved, the engine may stream out Default (Nonatomic) models when they're eligible to stream out, potentially freeing up memory on the client and reducing the instances which need property updates.

Under Improved model streaming behavior, streaming out of Default (Nonatomic) models is based on whether the model is spatial (contains BasePart descendants) or non‑spatial (contains no BasePart descendants).

-   A spatial model only streams out completely when its last remaining BasePart descendant streams out, since some of the model's spatial parts may be near to the player/replication focus and some far away.

-   A non‑spatial model only streams out when an ancestor streams out, equivalent to legacy streaming out behavior.


---

### Stream out

During gameplay, a client may stream out (remove from the player's Workspace) regions and the BaseParts contained within them, based on the behavior set by StreamOutBehavior. The process begins with regions furthest away from the replication foci and moves in closer as needed. Regions inside the StreamingMinRadius range never stream out.

When an instance streams out, it is parented to nil so that any existing Luau state will reconnect if the instance streams back in. As a result, removal signals such as ChildRemoved or DescendantRemoving fire on its parent or ancestor, but the instance itself is not destroyed in the same sense as an Instance:Destroy() call.

To further anticipate stream out, examine these scenarios:

---

### Example Scenarios

1a. A part is created locally through Instance.new() in a LocalScript.

1b. In a "capture the flag" game, you create and attach blue helmet parts to all players on the blue team through a LocalScript.

1c. The part is not replicated to the server, and it is exempt from streaming out unless you make it a descendant of a part that exists on the server, such as a part within a player's character model.

2a. A part is cloned locally from ReplicatedStorage through Instance:Clone() in a LocalScript.

2b. A wizard character casts a spell by activating a Tool, upon which an object including several special effects is cloned from ReplicatedStorage and parented to the workspace at the wizard's position.

3c. The part is not replicated to the server, and it is exempt from streaming out unless you make it a descendant of a part that exists on the server.

---

### Timing delay

There may be a slight delay of ~10 milliseconds between when a part is created on the server and when it gets replicated to clients. In each of the following scenarios, you may need to use WaitForChild() and other techniques rather than assuming that events and property updates always occur at the same time as part streaming.

---

### Replication focus

By default, streaming occurs around the local player's character's PrimaryPart, although you can specify a different replication focus point through Player.ReplicationFocus.

You can also add and remove additional replication foci through Player:AddReplicationFocus() and Player:RemoveReplicationFocus() to dynamically enable streaming in multiple areas of the experience.

> Use caution when adding additional replication foci as each additional focus increases the server's workload for streaming and updating regions. For example, a single player with nine dynamically moving foci could generate server networking and streaming processing comparable to ten players moving around the experience.

> On the client, too many foci for a player can limit the engine's ability to adjust to memory limitations and make it more likely for clients to be killed by the OS for using too much memory.

---

### Atomic

If a Model is changed to Atomic, all of its descendants are streamed in together when a descendant BasePart is eligible. As a result, a separate LocalScript that needs to access instances in the model would need to useWaitForChild() on the model itself, but not on a descendant MeshPart or Part since they are sent alongside the model.

An atomic model is only streamed out when all of its descendant parts are eligible for streaming out, at which point the entire model streams out together. If only some parts of an atomic model would typically be streamed out, the entire model and its descendants remain on the client.

---

### Persistent

Persistent models are not subject to normal streaming in or out. They are sent as a complete atomic unit soon after the player joins and before the Workspace.PersistentLoaded event fires. Persistent models and their descendants are never streamed out, but to safely handle streaming in within a separate LocalScript, you should use WaitForChild() on the parent model, or wait for the PersistentLoaded event to fire.

> Persistent models are intended for very rare circumstances, such as when a small number of parts must always be present on clients for LocalScript use. If possible, server-side Scripts should be used, or LocalScripts should be tolerant of parts streaming in and out. Persistent models are not intended to circumvent streaming, and overuse may negatively impact performance.

> Avoid creating catch-all persistent models that have a large number of sub-models. For example, if you're creating an experience with a large number of vehicles, do not create a single persistent model which contains every vehicle in the experience that you want to be persistent. Instead, set each individual vehicle model to be persistent, if necessary.

---

### PersistentPerPlayer

Models set to PersistentPerPlayer behave the same as Persistent for players that have been added using Model:AddPersistentPlayer(). For other players, behavior is the same as Atomic. You can revert a model from player persistence via Model:RemovePersistentPlayer().