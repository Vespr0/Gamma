Update: This project is no longer actively supported, however the methodology and coded examples should be more than enough to guide you in setting up your own spinner. Have fun!
What is a Crate System?

Playing around a few front-page games, you’ll notice a popular method for earning items: spinners! Generally, they contain a collection of items of varying rarities which are rewarded randomly after purchasing a crate.

In this tutorial I’ll be covering how to setup such a system, along with examples of the most effective (and not so effective) methods I’ve discovered over time! Hopefully you’ll find the process an enjoyable challenge and learn a few tips about UI Design, client-server relationships, etc along the way!
Overview

We can split the crate system into three core componments:

    Requesting a spin
    Generating and Rewarding results
    Displaying results

Requesting a Spin

First, lets create a TextButton.

image
image1500×500 345 KB

Once pressed, we want to carry out the following tasks on the client:

    Verify the user can activate the spinner (e.g. do they have enough cash?)
    Display a loading message
    Invoke the server (via a remote function)
    Begin the spinner or display any appropriate error messages
    Include a debounce to prevent the user double-spinning

I recommend writing the verification function in a separate Module script (aka ‘contents’ in this example) so both the client and server can utilise the same code, reducing data redundancy.

contents["Price"] = 1

function contents:PermissionToSpin(player)
	local leaderstats = player:FindFirstChild("leaderstats")
	if leaderstats and leaderstats.Cash.Value >= contents.Price then
		return true
	else
		return false
	end
end

In this example, I’m using the standard Roblox leaderboard; feel free to adapt to your own data systems.

Once completed, your activation code will look something like the following:

spin.MouseButton1Down:Connect(function()
	if spinDe then
		spinDe = false
		local originalSpinText = spin.TextLabel.Text
		--Check user has permission to spin
		if not contents:PermissionToSpin(player) then
			spin.TextLabel.Text = "Not enough cash!"
			wait(1)
		else
			spin.TextLabel.Text = "Loading..."
			--Invoke server
			local spinDetails, errorMessage = rfunction:InvokeServer()
			if not spinDetails then
				if not errorMessage then
					errorMessage = "Error!"
				end
				spin.TextLabel.Text = errorMessage
				wait(1)
			else
				--Begin spinner
				SpinFunction(spinDetails)
			end
		end
		spin.TextLabel.Text = originalSpinText
		spinDe = true
	end
end)

Generating Results and Rewarding the User

Now, lets generate the results on the server. Often, inexperienced developers will generate the items on the client then request the server to give them that particular item. This is a huge no no which will open your server to a tsunami of vulnerabilities. Remember, never trust the client.

First, lets setup some tables to store information on our items. We’ll use the same module again so both server and client can access the data:

function contents:GetItemTypes()
	local itemTypes = {
		-----------------------------------
		{
		Rarity = {Name = "Common",		Chance = 0.589, 	Color = Color3.fromRGB(0,85,127),	DuplicateReward = 20};
		Items = {
			
			{Name = "Item1", ImageId = 2419083546};
			{Name = "Item2", ImageId = 1468821126};
			{Name = "Item3", ImageId = 2643944686};
			{Name = "Item4", ImageId = 1468821305};
			{Name = "Item5", ImageId = 1468822149};
			}
		
		};
		-----------------------------------
		{
		Rarity = {Name = "Uncommon",	Chance = 0.300, 	Color = Color3.fromRGB(43,125,43),	DuplicateReward = 50};
		Items = {
			
			{Name = "Item6", ImageId = 1468821620};
			{Name = "Item7", ImageId = 1801056307};
			{Name = "Item8", ImageId = 2419083419};
			{Name = "Item9", ImageId = 1468820879};
			{Name = "Item10", ImageId = 2643944712};
			}
		
		};
		-----------------------------------
		{
		Rarity = {Name = "Rare",		Chance = 0.100, 	Color = Color3.fromRGB(210,85,0),	DuplicateReward = 100};
		Items = {
			
			{Name = "Item11", ImageId = 1471365373};
			{Name = "Item12", ImageId = 1468818998};
			{Name = "Item13", ImageId = 1468820407};
			{Name = "Item14", ImageId = 2570569323};
			{Name = "Item15", ImageId = 1468820383};
			}
		
		};
		-----------------------------------
		{
		Rarity = {Name = "Legendary",	Chance = 0.010, 	Color = Color3.fromRGB(170,0,0),	DuplicateReward = 200};
		Items = {
			
			{Name = "Item16", ImageId = 2419084522};
			{Name = "Item17", ImageId = 1468819804};
			{Name = "Item18", ImageId = 2419083272};
			{Name = "Item19", ImageId = 1468820065};
			{Name = "Item20", ImageId = 1468821559};
			}
		
		};
		-----------------------------------
		{
		Rarity = {Name = "Mythical",	Chance = 0.001, 	Color = Color3.fromRGB(170,0,225),	DuplicateReward = 500};
		Items = {
			
			{Name = "Item21", ImageId = 2987584671};
			}
		
		};
		-----------------------------------
	};
	
	-- Records the group the item belongs to. This can be used to retreive data on the item's group (such as it's rarity, color, etc) when we only have info for the item.
	for groupIndex, group in pairs(itemTypes) do
		for i, item in pairs(group.Items) do
			item.GroupIndex = groupIndex
		end
	end
	
	return itemTypes
end

In this case, ‘chance’ is a number between 0 and 1 defining the likelihood of the items from that group being added to the spinner. It’s essential that the chance values total to 1.

To generate the spin-items (crates):

    Specify how many we wish to generate; in this case 45.
    Generate a random number between 0 and 1. We will use the math.random() to achieve this.
    Iterate through each rarity group. If the random number (we’ll define as ‘randomChance’) is less than or equal to the group’s chance (‘chance’), then break and return the group’s rarity, else repeat, adding chance to a cumulativeChance variable, until randomChance is less than or equal to cumulativeChance.

--Eliminate already-owned items (Optional)
local modifiedItemTypes = contents:GetItemTypes()
--[[
if contents.EliminateOwnedItems then
	--Get table of currently owned items
	local ownedItems = {}
	for i,v in pairs(player.leaderstats.Inventory:GetChildren()) do
		ownedItems[v.Name] = true
	end
	--Iterate through each group
	for groupIndex, group in pairs(modifiedItemTypes) do
		local totalItems = #group.Items
		local totalItemsPlusOne = totalItems + 1
		-- Iterate though Items back-to-front so the items remain in the same position if one is removed
		for i = 1, totalItems do
			local itemIndex = totalItemsPlusOne - i
			local item = group.Items[itemIndex]
			if ownedItems[item.Name] then
				table.remove(group.Items, itemIndex)
			end
		end
	end
end
--]]

--Generate Items
local items = {}
for i = 1, contents.Crates do
	--Determine rarity
	local cumulativeChance = 0
	local rarityGroup
	local randomChance = math.random()
	for groupIndex, group in pairs(modifiedItemTypes) do
		local chance = group.Rarity.Chance
		cumulativeChance = cumulativeChance + chance
		if randomChance <= cumulativeChance and #group.Items > 0 then
			rarityGroup = group
			break
		end
	end
	
	--If user has collected all items, return error message
	if not rarityGroup then
		return nil, "Error: unlocked all possible items!"
	end
	
	--Select random item from rarity group and add to 'items' table
	local newItemsGroup = rarityGroup.Items
	local newItemPos = math.random(1,#newItemsGroup)
	local newItem = newItemsGroup[newItemPos]
	table.insert(items, newItem)
end

Now we have a table of 45 randomly generated items with varying rarity… lets pick the winner!

This is in-fact a lot easier than you might expect. We’re simply going to say the 40th crate (5 from the end) is the winner. This enables the client to spin through plenty of crates before stopping while giving the illusion of plenty to come.

local winningCrateId = totalCrates - 5
local winningItem = items[winningCrateId]

Finally, we want to reward the user. This can be as simple as inserting a stat into their inventory, or additionally checking whether the item is a duplicate, and rewarding them cash accordingly:

local duplicate = false
if leaderstats.Inventory:FindFirstChild(winningItem.Name) then
	duplicate = true
	leaderstats.Cash.Value = leaderstats.Cash.Value + itemTypes[winningItem.GroupIndex].Rarity.DuplicateReward
else
	local newStat = Instance.new("ObjectValue")
	newStat.Name = winningItem.Name
	newStat.Parent = leaderstats.Inventory
end

Once rewarded, return the data back to the client so they can begin their spinner effect.

return {
	["Items"] = items;
	["WinningCrateId"] = winningCrateId;
	["WinningItem"] = winningItem;
	["Duplicate"] = duplicate;
}

Displaying Results

Alright, now for the fun bit - the crate spinner!

I’m going to split this section into two sub-categories:

    Designing the Spinner
    Programming the Spinner

Designing the Spinner

Imagine the spinner as a launch coaster:

image
image1755×1008 897 KB

You have the station, track and coaster to hold you in place, while you have the launch pad and gravity to shoot you off and slow you down. Right now we’re designing the station, track and breaks:

The components to make up the spinner include:

    Spinner framework
    Crate template
    Reward frame

For the framework I’ve created the frames: ‘Main’ to act as the border, ‘Crates’ as the black background, and ‘Holder’ (with a completely transparent background) to hold and spin the crates:

image
image2706×705 676 KB

You may have noticed a property within frames called ‘ClipsDescendants’. When set to true, this prevents descendant GUI objects from being rendered outside the frame. We want this enabled in our case so that crates remain within the black frame:

image
image2510×1300 1.27 MB

I’ve also added a centre-line (for cosmetic purposes) and a Skip button.

For the crate, I’ve included an ImageLabel for the item’s image, two TextLabels to display the item’s name and rarity, and a ‘SpinClick’ sound effect.

image
image800×412 53.3 KB


Programming the Spinner

Now before we delve into the SpinFunction(), we first need to create the crates. "Why do this before retrieving the spin-details?". This saves the client the trouble of having to clear and generate a fresh batch of crates every single time the user spins, ultimately improving performance and reducing time spent loading the spinner. Instead, we’ll create them now and toggle their visibility and details when necessary.

To do this, we need to calculate the sum of the box’s width and gap we want between the crates, then multiply this number by the crate ID-1 to evenly spread them out. You can find the width of an object using the AbsoluteSize property.

local crateSizeX = template.AbsoluteSize.X
local crateGapX = 10
local crateTotalGapX = crateSizeX + crateGapX
for i = 1, contents.Crates do
	local crate = template:Clone()
	crate.Name = "Crate"..i
	crate.Position = crate.Position + UDim2.new(0, crateTotalGapX*(i-1), 0, 0)
	crate.Parent = holder
end

Remember when we invoked the server beforehand? Now that the server has returned the spin-details and the crates are setup, we can continue off of the client…

function SpinFunction(spinDetails)

end

First things first, lets:

    Iterate through all items [spinDetails.Items] and update their corresponding crate accordingly
    Calculate the distance between the centre-line and the mid-point of the 40th [spinDetails.WinningCrateId] crate, then subtract this from the holder’s position to get the ‘land position’.

To find the mid-point of a UI object, divide it’s X and Y size values by 2 then add these to the absolute position (alternatively you could set the anchor point scale to 0.5 if you’re good at manipulating GUIs).

image
image2500×500 233 KB

Now we’re down to one final key component: the spinning of the crates.

This is the stage where multiple developers, including myself, initially attempt really complex and long-winded methods, only for them to be too slow/laggy/inefficient when it comes to final execution. For example:

    Using a loop to move the crates and performing all sorts of math to make it slow down.
    Using a loop and updating the position of each individual crate over 30 times a second. Please please please do not do this!
    Only using 4-5 crates but shifting the lead-crate back to the start when it disappears out of view. As mentioned before, this is extremely expensive on the client (as you’re having to constantly update images, labels, positions, etc) and is quite frankly too complex and time-consuming.

Instead, we’re going to use TweenService and Easing Styles to achieve our desired movement, and only move the crate holder instead of each individual crate.

local tweenTime = math.random(7,8) -- The time the crates will spin for
local tweenInfo = TweenInfo.new(tweenTime, Enum.EasingStyle.Quart) -- The way in which the crates reach their destination (e.g. Quart will make it spin really fast then slow down quite rapidly)
local tween = tweenService:Create(holder, tweenInfo, {Position = landPosition}) -- landPosition is the position we calculated previously
tween:Play() -- Run the tween
tween.Completed:Wait() -- Wait until the tween is completed

And last but not least, wait for the spin tween to complete and display the reward frame!

image
image1078×944 243 KB

Remember to toggle the visibility of frames as needed throughout the whole process (e.g. hide the ‘activate’ frame when players clicks Spin and show once again when they have claimed their reward).
Summary

Here’s a rough breakdown of everything we’ve covered:

    Setup

    Design the spinner framework, crate template and reward frame
    Setup the crates when the player joins the game

        On the client

    Press ‘Spin’ and verify the user
    Invoke the server, letting it know you’re ready to spin

        On the server

    Verify the user and deduct the cost of the spin from their cash
    Retrieve the list of spin items and remove any duplicates as appropriate
    Randomly generate a table of items to be used in the spinner
    Select the winning item from this list
    Reward the user
    Return data back to client

        Back on the client

    Update the crates with the data retrieved from the server
    Calculate the distance between the start centre-point and end centre-point
    Setup sound effects
    Use TweenService and Easing Styles to achieve the spin effect
    Display the reward frame

I’ve created an open-source place with the completed project if you’re interested in playing around: Crate/Spin System - Roblox