# SpiriWorkflow.md

Workflow for working with the Spiri submodule

## Steps

1. Understand the npc you want to make.
2. What spiri components you need.
4. If you need to add a new component
3. If you can leverage logic elsewhere in the codebase
5. Always use the `self.events.get("tick"):Connect(function()` loop and only have one.