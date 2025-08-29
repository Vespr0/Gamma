Data stores

The DataStoreService lets you store data that needs to persist between sessions, like items in a player's inventory or skill points. Data stores are consistent per experience, so any place in an experience can access and change the same data, including places on different servers.

If you want to add granular permission control to your data stores and access them outside of Studio or Roblox servers, you can use Open Cloud APIs for data stores.

To view and monitor all the data stores in an experience through the Creator Hub, use the Data Stores Manager.

For temporary data that you need to update or access frequently, use memory stores.
Enable Studio access

By default, experiences tested in Studio can't access data stores, so you must first enable them. Accessing data stores in Studio can be dangerous for live experiences because Studio accesses the same data stores as the client application. To avoid overwriting production data, do not enable this setting for live experiences. Instead, enable it for a separate test version of the experience.

To enable Studio access in a published experience:

    Open Studio's File ⟩ Game Settings window.
    Navigate to Security.
    Enable the Enable Studio Access to API Services toggle.
    Click Save.

Access data stores

To access a data store inside an experience:

    Add DataStoreService to a server-side Script.
    Use the GetDataStore() function and specify the name of the data store you want to use. If the data store doesn't exist, Studio creates one when you save your experience data for the first time.

local DataStoreService = game:GetService("DataStoreService")


local experienceStore = DataStoreService:GetDataStore("PlayerExperience")

The server can only access data stores through Scripts. Attempting client-side access in a LocalScript causes an error.
Create data

A data store is essentially a dictionary, similar to a Luau table. A unique key indexes each value in the data store, like a user's unique Player.UserId or a named string for an experience promo.
User data key	Value
31250608	50
351675979	20
505306092	78000
Promo data key	Value
ActiveSpecialEvent	SummerParty2
ActivePromoCode	BONUS123
CanAccessPartyPlace	true

To create a new entry, call SetAsync() with the key name and a value.

local DataStoreService = game:GetService("DataStoreService")


local experienceStore = DataStoreService:GetDataStore("PlayerExperience")


local success, errorMessage = pcall(function()

	experienceStore:SetAsync("User_1234", 50)

end)

if not success then

	print(errorMessage)

end

Functions like SetAsync() that access a data store's contents are network calls that might occasionally fail. To catch and handle errors, make sure to wrap these calls in pcall().
Update data

To change any stored value in a data store, call UpdateAsync() with the entry's key name and a callback function that defines how you want to update the entry. This callback takes the current value and returns a new value based on the logic you define. If the callback returns nil, the write operation is cancelled and the value isn't updated.

The callback function you pass into UpdateAsync() does not have permission to yield. It can't contain any yielding functions like task.wait().

local DataStoreService = game:GetService("DataStoreService")


local nicknameStore = DataStoreService:GetDataStore("Nicknames")


local function makeNameUpper(currentName)

	local nameUpper = string.upper(currentName)

	return nameUpper

end


local success, updatedName = pcall(function()

	return nicknameStore:UpdateAsync("User_1234", makeNameUpper)

end)

if success then

	print("Uppercase Name:", updatedName)

end

Set vs update

Use set to quickly update a specific key. The SetAsync() function:

    Can cause data inconsistency if two servers try to set the same key at the same time
    Only counts against the write limit

Use update to handle multi-server attempts. The UpdateAsync() function:

    Reads the current key value from the server that last updated it before making any changes
    Is slower because it reads before it writes
    Counts against both the read and write limits

Read data

To read the value of a data store entry, call GetAsync() with the entry's key name.

local DataStoreService = game:GetService("DataStoreService")


local experienceStore = DataStoreService:GetDataStore("PlayerExperience")


local success, currentExperience = pcall(function()

	return experienceStore:GetAsync("User_1234")

end)

if success then

	print(currentExperience)

end

The values you retrieve using GetAsync() sometimes can be out of sync with the backend due to the caching behavior. For more information, see Disabling caching.
Increment data

To increment an integer in a data store, call IncrementAsync() with the entry's key name and a number for how much to change the value. IncrementAsync() is a convenience function that lets you avoid calling UpdateAsync() and manually incrementing the integer.

local DataStoreService = game:GetService("DataStoreService")


local experienceStore = DataStoreService:GetDataStore("PlayerExperience")


local success, newExperience = pcall(function()

	return experienceStore:IncrementAsync("Player_1234", 1)

end)

if success then

	print(newExperience)

end

Remove data

To remove an entry and return the value associated with the key, call RemoveAsync().

local DataStoreService = game:GetService("DataStoreService")


local nicknameStore = DataStoreService:GetDataStore("Nicknames")


local success, removedValue = pcall(function()

	return nicknameStore:RemoveAsync("User_1234")

end)

if success then

	print(removedValue)

end

Metadata

Ordered data stores don't support versioning and metadata, so DataStoreKeyInfo is always nil for keys in an OrderedDataStore. If you need to support versioning and metadata, use DataStore.

There are two types of metadata associated with keys:

    Service-defined: Default read-only metadata, like the most recent update time and creation time. Every object has service-defined metadata.
    User-defined: Custom metadata for tagging and categorization. Defined using the DataStoreSetOptions object and the SetMetadata() function.

To manage metadata, expand the SetAsync(), UpdateAsync(), GetAsync(), IncrementAsync(), and RemoveAsync() functions.

    SetAsync() accepts the optional third and fourth arguments:

        A table of UserIds. This can help with content copyright and intellectual property tracking and removal.

        A DataStoreSetOptions object, where you can define custom metadata using the SetMetadata() function.

local DataStoreService = game:GetService("DataStoreService")


local experienceStore = DataStoreService:GetDataStore("PlayerExperience")


local setOptions = Instance.new("DataStoreSetOptions")

setOptions:SetMetadata({["ExperienceElement"] = "Fire"})


local success, errorMessage = pcall(function()

    experienceStore:SetAsync("User_1234", 50, {1234}, setOptions)

end)

if not success then

    print(errorMessage)

    end

GetAsync(), IncrementAsync(), and RemoveAsync() return a second value in the DataStoreKeyInfo object. This second value contains both service-defined properties and functions to fetch user-defined metadata.

    The GetUserIds() function fetches the table of UserIds that you passed to SetAsync().
    The GetMetadata() function fetches user-defined metadata that you passed to SetAsync() through SetMetadata().
    The Version property fetches the version of the key.
    The CreatedTime property fetches the time the key was created, formatted as the number of milliseconds since epoch.
    The UpdatedTime property fetches the last time the key was updated, formatted as the number of milliseconds since epoch.

local DataStoreService = game:GetService("DataStoreService")


local experienceStore = DataStoreService:GetDataStore("PlayerExperience")


local success, currentExperience, keyInfo = pcall(function()

    return experienceStore:GetAsync("User_1234")

end)

if success then

    print(currentExperience)

    print(keyInfo.Version)

    print(keyInfo.CreatedTime)

    print(keyInfo.UpdatedTime)

    print(keyInfo:GetUserIds())

    print(keyInfo:GetMetadata())

end

The callback function of UpdateAsync() takes an additional parameter in the DataStoreKeyInfo object that describes the current key state. It returns the modified value, the keys associated with UserIds, and the key's metadata.

local DataStoreService = game:GetService("DataStoreService")


local nicknameStore = DataStoreService:GetDataStore("Nicknames")


local function makeNameUpper(currentName, keyInfo)

    local nameUpper = string.upper(currentName)

    local userIDs = keyInfo:GetUserIds()

    local metadata = keyInfo:GetMetadata()

    return nameUpper, userIDs, metadata

end


local success, updatedName, keyInfo = pcall(function()

    return nicknameStore:UpdateAsync("User_1234", makeNameUpper)

end)

if success then

    print(updatedName)

    print(keyInfo.Version)

    print(keyInfo.CreatedTime)

    print(keyInfo.UpdatedTime)

    print(keyInfo:GetUserIds())

    print(keyInfo:GetMetadata())

    end

When calling SetAsync(), IncrementAsync(), and UpdateAsync(), you must always update metadata definitions with a value, even when there are no changes to the current value. If you don't, you lose the current value.

For limits when defining metadata, see the metadata limits.
Ordered data stores

By default, data stores don't sort their content. If you need to get data in an ordered way, like in persistent leaderboard stats, call GetOrderedDataStore() instead of GetDataStore().

local DataStoreService = game:GetService("DataStoreService")


local characterAgeStore = DataStoreService:GetOrderedDataStore("CharacterAges")

Ordered data stores support the same basic functions as default data stores, plus the unique GetSortedAsync() function. This retrieves multiple sorted keys based on a specific sorting order, page size, and minimum/maximum values.

The following example sorts character data into pages with three entries, each in descending order, then loops through the pages and outputs each character's name and age.

local DataStoreService = game:GetService("DataStoreService")


local characterAgeStore = DataStoreService:GetOrderedDataStore("CharacterAges")


-- Populates ordered data store

local characters = {

	Mars = 19,

	Janus = 20,

	Diana = 18,

	Venus = 25,

	Neptune = 62

}

for char, age in characters do

	local success, errorMessage = pcall(function()

		characterAgeStore:SetAsync(char, age)

	end)

	if not success then

		print(errorMessage)

	end

end


-- Sorts data by descending order into pages of three entries each

local success, pages = pcall(function()

	return characterAgeStore:GetSortedAsync(false, 3)

end)

if success then

	while true do

		-- Gets the current (first) page

		local entries = pages:GetCurrentPage()

		-- Iterates through all key-value pairs on page

		for _, entry in entries do

			print(entry.key .. " : " .. tostring(entry.value))

		end

		-- Checks if last page has been reached

		if pages.IsFinished then

			break

		else

			print("----------")

			-- Advances to next page

			pages:AdvanceToNextPageAsync()

		end

	end

end

When you iterate through GetOrderedDataStore() using AdvanceToNextPageAsync(), the limit for requests is the same as the maximum page size you set for an ordered data store. AdvanceToNextPageAsync() always has the same limit as the class that originally requires it.