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
    model: Model,
    owner: Player
}

return types