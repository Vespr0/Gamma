In the Configs folder inside shared the configs of various things in the game are stored.

Item Config example:

```
return {
	-- Generic --
	Type = "Dropper",
	DisplayName = "Coal Mine",
	Description = "Everyone starts somewhere. Weak but small, can be placed in small spaces.",
	
	-- Shop --
	Price = 40,
	LevelRequirement = 1,
	InMarket = true,
	InOffers = true,
	
	-- Dropper --
	DropDelay = 5,
	DropPropieties = {
		name = "Coal",
		value = 1,
		size = 0.4,
		color = Color3.fromRGB(22, 22, 22),
		mesh = "PartS",
		heighBias = 1/2,
	},
	
	-- Product Properties
	ProductType = "Coal",
	ProductQuantity = 1,
	CanPlaceOnGround = true,
	CanPlaceOnWater = false,
}
```

Tile Config Example:

return {
	Type = "Ground";
	DisplayName = "Grass";

	CanPlace = true,

	Color = Color3.fromRGB(172, 214, 82),
	Material = Enum.Material.Grass,
}


Lootbox Config example:

```
return {
	DisplayName = "Test Box",
	StarburstColor = Color3.fromRGB(225, 255, 94),
	
	Description = "",
	
	Weights = {
		["CoalMine"] = 10,
		["OldBelt"] = 9,
		["SmallTree"] = 1,
	}
}
```