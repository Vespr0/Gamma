--!strict
local types = {}

local TypeEntity = require(script.Parent.TypeEntity)

export type ItemConfig = {
	displayName : string,
	description : string,
	throwable : boolean,
	animations : { [string]: AnimationTrack },
	mass : number
}

-- Extends item config.
export type Item = ItemConfig & {
	name: string,
	asset: Instance, 
	config: ItemConfig, 
	model: Model,
	motor: Motor6D,
	bodyPart: BasePart,
	C0: CFrame,
	C1: CFrame,
	owner: TypeEntity.BaseEntity,
	equipped: boolean,
	abilities: { [string]: any },
	setupAbilities: (self: Item) -> (),
	destroy: (self: Item) -> (),
}

return types