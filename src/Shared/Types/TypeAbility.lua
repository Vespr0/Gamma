--!strict
local types = {}

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- Modules
local TypeRig = require(script.Parent.TypeRig)
local Signal = require(ReplicatedStorage.Packages.signal)

export type AbilityInputs = {
    [Enum.KeyCode | Enum.UserInputType]: boolean -- TODO may be wrong idk
}

export type AbilityConfig = {
    name: string,
    cooldownDuration: number,
    inputs: { AbilityInputs }, -- Array of keycodes
}

export type BaseClientAbility = {

}

export type BaseServerAbility = {

}

export type BaseAbility = {
    player: Player,
    userId: number,
    character: TypeRig.Rig,
    humanoid: Humanoid,
    root: BasePart,
    height: number,
    moving: boolean,
    events: {
        Removed: any,
        Added: any,
        CharacterAdded: any,
        EntityDied: any
    }
}

return types
