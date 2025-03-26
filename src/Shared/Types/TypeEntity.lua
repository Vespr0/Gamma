--!strict
local types = {}

export type ClientEntity = BaseEntity & {

}

export type ServerEntity = BaseEntity & {
    
}

export type BaseEntity = {
    id: number,
    name: string,
    displayName: string,
    description: string,
    rig: Model,
    root: BasePart,
    player: Player
}

return types