========================
CODE SNIPPETS
========================
TITLE: Python DataStore Example
DESCRIPTION: Demonstrates how to use the rblx-open-cloud library in Python to interact with Roblox DataStores. Includes initialization, getting data, setting data, and removing keys.

SOURCE: https://github.com/treeben77/rblx-open-cloud/blob/main/__wiki__/DataStoreService.md#_snippet_4

LANGUAGE: Python
CODE:
```
# import the libaray and give it the key; PROTIP: the key should be stored in an environ value
import rblx_opencloud
rblx_opencloud.api_key = "totally-legit-key-right-here"

# create a DataStoreService instance with your universe ID
DataStoreService = rblx_opencloud.DataStoreService(universe=1)

# get the datastore optionally with a scope; scope defaults to global in roblox
experiment = DataStoreService.getDataStore("datastore-name", scope="global")

# this will get a key called 'key-name'
value, metadata = experiment.get("key-name")
print(value, metadata)

# this will set a key called 'key-name' with data 'data' and user IDs as ROBLOX's user ID
version = experiment.set("key-name", "data", users=[1])

# deletes the key
experiment.remove("key-name")
```

----------------------------------------

TITLE: Install rblx-open-cloud Library
DESCRIPTION: Instructions for installing the rblx-open-cloud Python library using pip. It includes commands for installing the stable version from PyPI and the development version directly from GitHub.

SOURCE: https://github.com/treeben77/rblx-open-cloud/blob/main/README.md#_snippet_0

LANGUAGE: shell
CODE:
```
# Stable (PyPi, recommended)
pip install rblx-open-cloud~=2.0

# Development (GitHub)
pip install "rblx-open-cloud @ git+https://github.com/treeben77/rblx-open-cloud@main"
```

----------------------------------------

TITLE: Publish Message Example (Python)
DESCRIPTION: Demonstrates how to initialize the MessagingService and publish a message to a specified topic.

SOURCE: https://github.com/treeben77/rblx-open-cloud/blob/main/__wiki__/MessagingService.md#_snippet_1

LANGUAGE: python
CODE:
```
import rblx_opencloud
rblx_opencloud.api_key = "ur-api-key"

#create a MessagingService object with your universe
MessagingService = rblx_opencloud.MessagingService(1)

# publish the message
MessagingService.publish("topicname", "message")
```

----------------------------------------

TITLE: Get rblx-open-cloud DataStore Object
DESCRIPTION: Shows how to obtain a `rblxopencloud.DataStore` object from an initialized `Experience` object. You specify the datastore name and optionally a scope for data organization.

SOURCE: https://github.com/treeben77/rblx-open-cloud/blob/main/docs/guides/experience.md#_snippet_1

LANGUAGE: python
CODE:
```
datastore = experience.get_datastore("ExampleStore", scope="global")
```

----------------------------------------

TITLE: Initialize OAuth2App with rblx-open-cloud
DESCRIPTION: Demonstrates how to create an instance of the OAuth2App class, which is the primary entry point for OAuth2 operations. It requires your application's client ID, client secret, and the configured redirect URI.

SOURCE: https://github.com/treeben77/rblx-open-cloud/blob/main/docs/guides/oauth2.md#_snippet_0

LANGUAGE: python
CODE:
```
from rblxopencloud import OAuth2App

rblxapp = OAuth2App(0000000000000000000, "your-client-secret", "https://example.com/redirect")
```

----------------------------------------

TITLE: Accessing Data Stores
DESCRIPTION: Demonstrates how to use the rblxopencloud library to interact with Roblox Data Stores. It covers creating an Experience object, getting a specific data store, setting, getting, incrementing, and removing data, along with handling metadata and user information.

SOURCE: https://github.com/treeben77/rblx-open-cloud/blob/main/README.md#_snippet_1

LANGUAGE: python
CODE:
```
import rblxopencloud

# create an Experience object with your experience ID and your api key
# TODO: replace '13058' with your experience ID
experience = rblxopencloud.Experience(13058, api_key="api-key-from-step-2")

# get the data store, using the data store name and scope (defaults to global)
datastore = experience.get_data_store("data-store-name", scope="global")

# sets the key 'key-name' to 68 and provides users and metadata
# DataStore.set does not return the value or an EntryInfo object, instead it returns a EntryVersion object.
datastore.set("key-name", 68, users=[287113233], metadata={"key": "value"})

# get the value with the key 'number'
# info is a EntryInfo object which contains data like the version code, metadata, userids and timestamps.
value, info = datastore.get("key-name")

print(value, info)

# increments the key 'key-name' by 1 and ensures to keep the old users and metadata
# DataStore.increment retuens a value and info pair, just like DataStore.get and unlike DataStore.set
value, info = datastore.increment("key-name", 1, users=info.users, metadata=info.metadata)

print(value, info)

# deletes the key
datastore.remove("key-name")
```

----------------------------------------

TITLE: Install rblx-open-cloud on Windows (pip)
DESCRIPTION: Installs the rblx-open-cloud Python package version 2.0 or higher on Windows systems using pip. This command ensures you have the latest compatible version for your project.

SOURCE: https://github.com/treeben77/rblx-open-cloud/blob/main/docs/index.md#_snippet_0

LANGUAGE: console
CODE:
```
python -m pip install rblx-open-cloud~=2.0 --upgrade
```

----------------------------------------

TITLE: OAuth2 Application Authentication - Python
DESCRIPTION: Illustrates how to set up OAuth2 authentication for an application. This involves providing your client ID, client secret, and redirect URI to initialize the OAuth2App class.

SOURCE: https://github.com/treeben77/rblx-open-cloud/blob/main/docs/guides/basic.md#_snippet_2

LANGUAGE: python
CODE:
```
from rblxopencloud import OAuth2App

rblxapp = OAuth2App(0000000000000000000, "your-client-secret", "https://example.com/redirect")
```

----------------------------------------

TITLE: Flask Login Route for OAuth2 Redirection
DESCRIPTION: Provides a basic Flask route setup to handle user logins by redirecting them to the Roblox consent page. It utilizes the `generate_uri` method from the OAuth2App instance.

SOURCE: https://github.com/treeben77/rblx-open-cloud/blob/main/docs/guides/oauth2.md#_snippet_2

LANGUAGE: python
CODE:
```
from flask import Flask, request, redirect
from rblxopencloud import OAuth2App

rblxapp = OAuth2App(0000000000000000000, "your-client-secret", "https://example.com/redirect")
app = Flask(__name__)

@app.route('/login')
def login():
    return redirect(rblxapp.generate_uri(['openid', 'profile']))
```

----------------------------------------

TITLE: Install rblx-open-cloud on Linux (pip)
DESCRIPTION: Installs the rblx-open-cloud Python package version 2.0 or higher on Linux systems using pip3. This command ensures you have the latest compatible version for your project.

SOURCE: https://github.com/treeben77/rblx-open-cloud/blob/main/docs/index.md#_snippet_1

LANGUAGE: console
CODE:
```
python3 -m pip install rblx-open-cloud~=2.0 --upgrade
```

----------------------------------------

TITLE: API Key Authentication (Multiple Keys) - Python
DESCRIPTION: Demonstrates how to authenticate using multiple distinct API keys for different resources like experiences and groups. This approach is useful when you want to manage access granularly.

SOURCE: https://github.com/treeben77/rblx-open-cloud/blob/main/docs/guides/basic.md#_snippet_0

LANGUAGE: python
CODE:
```
from rblxopencloud import Experience, Group

experience = Experience(experience_id, "api-key-1")
group = Group(group_id, "api-key-2")
```

----------------------------------------

TITLE: Datastore Method Renaming
DESCRIPTION: Demonstrates the renaming of datastore methods from v1 to v2. Methods like 'get', 'set', 'increment', and 'remove' now have '_entry' appended.

SOURCE: https://github.com/treeben77/rblx-open-cloud/blob/main/docs/guides/v2.md#_snippet_1

LANGUAGE: Python
CODE:
```
value, info = datastore.get("287113233")
datastore.remove("287113233")
```

LANGUAGE: Python
CODE:
```
value, info = datastore.get_entry("287113233")
datastore.remove_entry("287113233")
```

----------------------------------------

TITLE: API Key Authentication (Single Key) - Python
DESCRIPTION: Shows how to authenticate using a single API key for all requests. This is a simpler method when one API key is sufficient for all your operations.

SOURCE: https://github.com/treeben77/rblx-open-cloud/blob/main/docs/guides/basic.md#_snippet_1

LANGUAGE: python
CODE:
```
from rblxopencloud import ApiKey

api_key = ApiKey("api-key")

experience = api_key.get_experience(experience_id)
group = api_key.get_group(group_id)
```

----------------------------------------

TITLE: Save Place Example
DESCRIPTION: Demonstrates how to use the PlacePublishing class to save a local .rblx file to a specified Roblox place.

SOURCE: https://github.com/treeben77/rblx-open-cloud/blob/main/__wiki__/PlacePublishing.md#_snippet_1

LANGUAGE: python
CODE:
```
import rblx_opencloud
rblx_opencloud.api_key = "ur-api-key"

#create a PlacePublishing object with your universe
PlacePublishing = rblx_opencloud.PlacePublishing(universe="universe-id-here")

#opens the .rbxl file as 'rb' and saves it to the place
with open("path-to/place-file.rbxl", "rb") as file:
    version = PlacePublishing.savePlace("place-id-here", file)
```

----------------------------------------

TITLE: List User Inventory and Groups with AccessToken
DESCRIPTION: Demonstrates how to fetch lists of inventory items or group memberships associated with the authorized user. These methods are available on the `AccessToken.user` object.

SOURCE: https://github.com/treeben77/rblx-open-cloud/blob/main/docs/guides/oauth2.md#_snippet_6

LANGUAGE: python
CODE:
```
for item in access.user.list_inventory():
    print(item)

for membership in access.user.list_groups():
    print(membership)
```

----------------------------------------

TITLE: Set Data Store Entry (Python/Lua)
DESCRIPTION: Demonstrates how to set or update a key-value pair in a Data Store. Both Python and Lua examples are provided, showing how to specify the key, value, and associated user IDs.

SOURCE: https://github.com/treeben77/rblx-open-cloud/blob/main/docs/guides/experience.md#_snippet_5

LANGUAGE: python
CODE:
```
version = datastore.set_entry("user_287113233", {"xp": 1337, "level": 7}, users=[287113233])
```

LANGUAGE: lua
CODE:
```
local version = datastore:SetAsync("user_287113233", {["xp"] = 1337, ["level"] = 7}, {287113233})
```

----------------------------------------

TITLE: Publish Message to Authorized Experiences
DESCRIPTION: Shows how to send a message to an authorized experience using the `publish_message` method. This requires fetching resources first to identify the authorized experiences.

SOURCE: https://github.com/treeben77/rblx-open-cloud/blob/main/docs/guides/oauth2.md#_snippet_8

LANGUAGE: python
CODE:
```
resources = access.fetch_resources()

for experience in resources.experiences:
    experience.publish_message("exampletopic", "exampledata")
```

----------------------------------------

TITLE: Async DataStore Operations Example
DESCRIPTION: Illustrates common asynchronous operations with rblx-open-cloud, such as retrieving datastore entries and iterating through datastore versions. API calls require the 'await' keyword.

SOURCE: https://github.com/treeben77/rblx-open-cloud/blob/main/docs/asynchronous.md#_snippet_1

LANGUAGE: python
CODE:
```
from rblxopencloudasync import Experience

experience = Experience(0000000000, "api-key")

datastore = experience.get_datastore("playerData")

value, info = await datastore.get_entry("287113233")
print(value, info)

async for version in datastore.list_versions("287113233"):
    print(version)
```

----------------------------------------

TITLE: Uploading Assets
DESCRIPTION: Provides an example of uploading assets to Roblox using the rblx-open-cloud library. It demonstrates uploading a decal file using either a User or Group object, specifying the asset type, name, and description. Currently supports Decal, Audio, and Model (fbx) asset types.

SOURCE: https://github.com/treeben77/rblx-open-cloud/blob/main/README.md#_snippet_3

LANGUAGE: python
CODE:
```
import rblxopencloud

# create an User object with your user ID and your api key
# TODO: replace '13058' with your user ID
user = rblxopencloud.User(13058, api_key="api-key-from-step-2")
# or, create a Group object:
group = rblxopencloud.Group(13058, api_key="api-key-from-step-2")

# this example is for uploading a decal:
with open("path/to/file.png", "rb", encoding="utf-8") as file:
    asset = user.upload_asset(file, rblxopencloud.AssetType.Decal, "name", "description").wait()

print(asset.id)
```

----------------------------------------

TITLE: DataStore Operations and Metadata
DESCRIPTION: Provides API documentation for core DataStore methods: incrementing values, removing keys, listing version history, and retrieving specific versions. Includes details on parameters, return types, and potential exceptions. Also documents the structure of metadata returned by get and getVersion operations.

SOURCE: https://github.com/treeben77/rblx-open-cloud/blob/main/__wiki__/DataStoreService.md#_snippet_3

LANGUAGE: APIDOC
CODE:
```
increment(*key:str, increment:Union[int, float], users:list=None, metadata:dict={}*) -> str
  If the value is a number, you can increase or decrease it without overwriting it.
  Parameters:
    key:str|The key to set.
    increment:int, float|the number to increase it by; can be negative to decrease it
    users:list of ints|table of user ids, highly recommended to assist with [GDPR tracking/removal](https://developer.roblox.com/en-us/articles/managing-personal-information).
    metadata:dict|dictionary of custom metadata. **it'll be removed if not set!**
  Raises:
    InvalidKey|The api key is not valid or doesn't have access to this
    NotFound|*This probably shouldn't be raised*
    RateLimited|You're being rate limited.
    ServiceUnavailable|Roblox, as usual, is having some downtime.

remove(*key:str*) -> str
  Deletes the key, but can still be accessed using version history.
  Parameters:
    key:str|The key to set.
  Raises:
    InvalidKey|The api key is not valid or doesn't have access to this
    NotFound|*This probably shouldn't be raised*
    RateLimited|You're being rate limited.
    ServiceUnavailable|Roblox, as usual, is having some downtime.

listVersions(*key:str, after:int=0, before:int=0, descending:bool=True*) -> list[dict]
  Lists all versions in the past 30 days of a key.
  Parameters:
    key:str|The key to get.
    after:int|Only fetch versions after this epoch timestamp
    before:int|Only fetch versions before this epoch timestamp
    descending:bool|`True` if you want the newest first, otherwise oldest will be first.
  Raises:
    InvalidKey|The api key is not valid or doesn't have access to this
    NotFound|*This probably shouldn't be raised*
    RateLimited|You're being rate limited.
    ServiceUnavailable|Roblox, as usual, is having some downtime.

getVersion(*key:str, version:str*) -> tuple[Union[str, dict, list, int, float], dict]
  returns the value and [[metadata|DataStoreService#metadata]] of a specific version.
  Roblox equivalent: [GlobalDataStore:GetAsync()](https://developer.roblox.com/en-us/api-reference/function/GlobalDataStore/GetAsync)
  Parameters:
    key:str|The key to fetch.
    version:str|The version ID to fetch.
  Raises:
    InvalidKey|The key is not valid or doesn't have access to this
    NotFound|*This probably shouldn't be raised*
    RateLimited|You're being rate limited.
    ServiceUnavailable|Roblox, as usual, is having some downtime.

Metadata Structure:
  Metadata is a dictionary returned in the 2nd value by get and getVersion functions. It contains the current version ID, created & updated timestamp, userids and metadata.
  Keys:
    version:str|the entry's version ID
    created:int|The epoch timestamp of when the key was first created
    updated:int|The timestamp of when this version was created
    userids:list of ints|List of user ids associated with the entry
    metadata:list|Custom metadata set by the developer.
```

----------------------------------------

TITLE: Fetch Authorized Resources with AccessToken
DESCRIPTION: Fetches the specific experiences and accounts (users/groups) that the user has authorized for your application. This is crucial for scopes that apply to resources rather than just the user's profile.

SOURCE: https://github.com/treeben77/rblx-open-cloud/blob/main/docs/guides/oauth2.md#_snippet_7

LANGUAGE: python
CODE:
```
resources = access.fetch_resources()

print(resources.experiences)
print(resources.accounts)
```

----------------------------------------

TITLE: PKCE Authorization Flow: Generate URI
DESCRIPTION: Initiates the PKCE (Proof Key for Code Exchange) authorization flow for applications that cannot securely store a client secret. This involves generating a code verifier and then creating the authorization URI for user redirection.

SOURCE: https://github.com/treeben77/rblx-open-cloud/blob/main/docs/guides/oauth2.md#_snippet_11

LANGUAGE: python
CODE:
```
code_verifier = rblxapp.generate_code_verifier()
rblxapp.generate_uri(['openid', 'profile'], code_verifier=code_verifier)
```

----------------------------------------

TITLE: Remove Data Store Key (Python)
DESCRIPTION: Provides an example of how to remove a key from a Data Store. This operation marks the key as deleted, though previous versions remain accessible for a limited time.

SOURCE: https://github.com/treeben77/rblx-open-cloud/blob/main/docs/guides/experience.md#_snippet_7

LANGUAGE: python
CODE:
```
version = datastore.remove_entry("user_287113233")
```

----------------------------------------

TITLE: Get Datastore Entry Value and Info
DESCRIPTION: Retrieves a specific key's value and associated metadata from a datastore using `datastore.get_entry`. The value can be various data types, and `EntryInfo` contains metadata like version ID and timestamps.

SOURCE: https://github.com/treeben77/rblx-open-cloud/blob/main/docs/guides/experience.md#_snippet_2

LANGUAGE: python
CODE:
```
value, info = datastore.get_entry("user_287113233")
```

----------------------------------------

TITLE: Generate OAuth2 Consent URI
DESCRIPTION: Generates the URI that users must be redirected to for authorizing your application. This function takes a list of scopes as input, defining the permissions your application requests.

SOURCE: https://github.com/treeben77/rblx-open-cloud/blob/main/docs/guides/oauth2.md#_snippet_1

LANGUAGE: python
CODE:
```
rblxapp.generate_uri(['openid', 'profile'])
```

----------------------------------------

TITLE: Flask Redirect Route for OAuth2 Code Exchange
DESCRIPTION: A Flask route designed to capture the authorization code from the redirect URI parameters and exchange it for an access token using the `exchange_code` method.

SOURCE: https://github.com/treeben77/rblx-open-cloud/blob/main/docs/guides/oauth2.md#_snippet_4

LANGUAGE: python
CODE:
```
@app.route('/redirect')
def redirect():
    access = rblxapp.exchange_code(request.args.get('code'))
```

----------------------------------------

TITLE: Get Specific Data Store Version (Python)
DESCRIPTION: Demonstrates fetching the data for a specific version of a Data Store key using its version ID. This is an alternative to listing all versions when the version ID is already known.

SOURCE: https://github.com/treeben77/rblx-open-cloud/blob/main/docs/guides/experience.md#_snippet_9

LANGUAGE: python
CODE:
```
value, info = datastore.get_version("user_287113233", "VERSION_ID")
```

----------------------------------------

TITLE: Manage User Restrictions (Ban/Unban/Fetch) with Open Cloud Python SDK
DESCRIPTION: Provides examples for managing user restrictions, including banning, unbanning, and fetching a user's restriction status. Bans can be temporary (with a duration) or permanent (duration=None). Detected alternative accounts are also banned by default. Fetching returns an object indicating if the user is active and the reason.

SOURCE: https://github.com/treeben77/rblx-open-cloud/blob/main/docs/guides/experience.md#_snippet_12

LANGUAGE: python
CODE:
```
experience.ban_user(
    287113233, duration_seconds=86400,
    display_reason="Breaking the rules.",
    private_reason="Top secret!"
)
```

LANGUAGE: python
CODE:
```
experience.ban_user(287113233)
```

LANGUAGE: python
CODE:
```
restriction = experience.fetch_user_restriction(287113233)

if restriction.active:
    print(f"The user is banned because: {restriction.private_reason}")
else:
    print(f"The user is not banned right now!")
```

----------------------------------------

TITLE: Access User Profile Data with AccessToken
DESCRIPTION: Retrieves basic user information such as ID, username, and headshot URI from the AccessToken object. This requires the 'openid' and 'profile' scopes to be granted.

SOURCE: https://github.com/treeben77/rblx-open-cloud/blob/main/docs/guides/oauth2.md#_snippet_5

LANGUAGE: python
CODE:
```
access.user.id
access.user.username
access.user.headshot_uri
```

----------------------------------------

TITLE: Exchange OAuth2 Code for Access Token
DESCRIPTION: Exchanges the authorization code received after user consent for an access token. This token is then used to make authenticated requests to Roblox APIs.

SOURCE: https://github.com/treeben77/rblx-open-cloud/blob/main/docs/guides/oauth2.md#_snippet_3

LANGUAGE: python
CODE:
```
access = rblxapp.exchange_code("examplecode")
```

----------------------------------------

TITLE: PKCE Authorization Flow: Exchange Code
DESCRIPTION: Completes the PKCE authorization flow by exchanging the authorization code received after user consent, along with the previously generated code verifier, for a new access token. It's crucial to manage state and code verifiers, especially with multiple concurrent authorizations.

SOURCE: https://github.com/treeben77/rblx-open-cloud/blob/main/docs/guides/oauth2.md#_snippet_12

LANGUAGE: python
CODE:
```
access = rblxapp.exchange_code("examplecode", code_verifier=code_verifier)
```

----------------------------------------

TITLE: Revoke Roblox Access Token
DESCRIPTION: Revokes an active Roblox Access Token and its associated refresh token. This action immediately invalidates both tokens, preventing further use. Users can re-authorize the application to obtain new tokens.

SOURCE: https://github.com/treeben77/rblx-open-cloud/blob/main/docs/guides/oauth2.md#_snippet_10

LANGUAGE: python
CODE:
```
access.revoke()
```

----------------------------------------

TITLE: Refresh Roblox Access Token
DESCRIPTION: Refreshes an expired Roblox Access Token using a stored refresh token. Access Tokens expire every 15 minutes, but refresh tokens are valid for 6 months. The new access token will require fetching user info separately and a new refresh token must be stored.

SOURCE: https://github.com/treeben77/rblx-open-cloud/blob/main/docs/guides/oauth2.md#_snippet_9

LANGUAGE: python
CODE:
```
access = rblxapp.refresh_token("your stored refresh token")
```

----------------------------------------

TITLE: Initialize rblx-open-cloud Experience Object
DESCRIPTION: Demonstrates how to import and create an `rblxopencloud.Experience` object using your universe ID and API key. This object is the entry point for accessing various experience resources.

SOURCE: https://github.com/treeben77/rblx-open-cloud/blob/main/docs/guides/experience.md#_snippet_0

LANGUAGE: python
CODE:
```
from rblxopencloud import Experience

experience = Experience(00000000, "your-api-key")
```

----------------------------------------

TITLE: Initialize DataStoreService
DESCRIPTION: Demonstrates how to create an instance of the DataStoreService by providing the universe ID. This service is used to interact with Roblox data stores.

SOURCE: https://github.com/treeben77/rblx-open-cloud/blob/main/__wiki__/DataStoreService.md#_snippet_0

LANGUAGE: python
CODE:
```
DataStoreService = rblx_opencloud.DataStoreService(universe="universe-id-here")
```

----------------------------------------

TITLE: Create Ordered Data Store (Python)
DESCRIPTION: Shows how to obtain an instance of an Ordered Data Store from an experience object. Ordered Data Stores have different properties than regular Data Stores, such as lack of versioning.

SOURCE: https://github.com/treeben77/rblx-open-cloud/blob/main/docs/guides/experience.md#_snippet_10

LANGUAGE: python
CODE:
```
Datastore = experience.get_ordered_datastore("ExampleStore", scope="global")
```

----------------------------------------

TITLE: Handle Datastore Key Not Found Error
DESCRIPTION: Illustrates how to gracefully handle cases where a requested datastore key does not exist by using a try-except block to catch the `rblxopencloud.NotFound` exception.

SOURCE: https://github.com/treeben77/rblx-open-cloud/blob/main/docs/guides/experience.md#_snippet_3

LANGUAGE: python
CODE:
```
try:
    value, info = datastore.get_entry("user_287113233")
except(rblxopencloud.NotFound):
    print("the key doesn't exist!")
else:
    print(f"the key's value is {value}.")
```

----------------------------------------

TITLE: DataStore Methods
DESCRIPTION: Details operations for a specific DataStore, including listing keys, retrieving data by key, and setting data. It also outlines the properties of a DataStore object and potential exceptions for these operations.

SOURCE: https://github.com/treeben77/rblx-open-cloud/blob/main/__wiki__/DataStoreService.md#_snippet_2

LANGUAGE: APIDOC
CODE:
```
DataStore:
  Properties:
    name: str - the name of the data store.
    scope: str - The scope to separate the data store. Defaults to "global".
    universe: int - the ID of the targeted game/universe.
    created: NoneType/int - timestamp of when the data store was created. Will be NoneType if returned by getDataStore.

  Methods:
    listKeys(prefix: str = "") -> list
      Returns a list of keys within that scope. This method is not optimized and may lead to rate limiting on large data stores.
      Roblox equivalent: DataStore:ListKeysAsync()
      Parameters:
        prefix: str - Filter keys by this prefix. Defaults to "" to not filter.
      Raises:
        InvalidKey: The key is not valid or doesn't have access to this.
        NotFound: This probably shouldn't be raised.
        RateLimited: You're being rate limited.
        ServiceUnavailable: Roblox is having some downtime.

    get(key: str) -> tuple[Union[str, dict, list, int, float], dict]
      Retrieves the value associated with a given key and its metadata.
      Roblox equivalent: GlobalDataStore:GetAsync()
      Parameters:
        key: str - The key to fetch.
      Returns:
        tuple: A tuple containing the value and its metadata dictionary.
      Raises:
        InvalidKey: The key is not valid or doesn't have access to this.
        NotFound: This probably shouldn't be raised.
        RateLimited: You're being rate limited.
        ServiceUnavailable: Roblox is having some downtime.

    set(key: str, value: Union[str, dict, list, int, float], users: list = None, metadata: dict = {}) -> str
      Sets a value for a given key, optionally associating it with specific users for GDPR tracking and including custom metadata. Metadata is removed if not set.
      Roblox equivalent: GlobalDataStore:SetAsync()
      Parameters:
        key: str - The key to set.
        value: Union[str, dict, list, int, float] - The new value to store.
        users: list of ints - Table of user IDs, recommended for GDPR tracking/removal.
        metadata: dict - Dictionary of custom metadata.
      Returns:
        str: A confirmation or status string.
      Raises:
        InvalidKey: The key is not valid or doesn't have access to this.
        NotFound: This probably shouldn't be raised.
        RateLimited: You're being rate limited.
        ServiceUnavailable: Roblox is having some downtime.
```

----------------------------------------

TITLE: List Data Store Versions (Python)
DESCRIPTION: Illustrates how to retrieve and iterate through all historical versions of a Data Store key. Each version object contains metadata and allows fetching the specific data content.

SOURCE: https://github.com/treeben77/rblx-open-cloud/blob/main/docs/guides/experience.md#_snippet_8

LANGUAGE: python
CODE:
```
for version in datastore.list_versions("user_287113233"):
    print(version, version.get_value())
```

----------------------------------------

TITLE: DataStoreService Methods
DESCRIPTION: Provides methods for interacting with Roblox Data Stores, including listing all data stores and retrieving a specific data store by name and scope. Includes details on parameters, return types, and potential exceptions.

SOURCE: https://github.com/treeben77/rblx-open-cloud/blob/main/__wiki__/DataStoreService.md#_snippet_1

LANGUAGE: APIDOC
CODE:
```
DataStoreService:
  Properties:
    universe: int - the ID of the targeted game/universe.

  Methods:
    listDataStores(prefix: str = "") -> list[DataStore]
      Lists all DataStores in the experience, optionally filtered by a prefix. Data Stores returned will have the 'created' property.
      Roblox equivalent: DataStoreService:ListDataStoresAsync()
      Parameters:
        prefix: str - Only list DataStores with this prefix. Defaults to "" to not filter.
      Raises:
        InvalidKey: The key is not valid or doesn't have access to this.
        NotFound: This probably shouldn't be raised.
        RateLimited: You're being rate limited.
        ServiceUnavailable: Roblox is having some downtime.

    getDataStore(name: str, scope: str = "global") -> DataStore
      Returns a DataStore with the provided name and scope. Data Stores returned by this method will **not** have the 'created' property.
      Roblox equivalent: DataStoreService:GetDataStore()
      Parameters:
        name: str - The data store name. Use "" if you're accessing the global data store.
        scope: str - The scope to separate the data store. Defaults to "global".
      Returns:
        DataStore: An object representing the requested data store.
      Raises:
        InvalidKey: The key is not valid or doesn't have access to this.
        NotFound: This probably shouldn't be raised.
        RateLimited: You're being rate limited.
        ServiceUnavailable: Roblox is having some downtime.
```

----------------------------------------

TITLE: rblxopencloud.ProductRestriction API
DESCRIPTION: Documentation for ProductRestriction, detailing any limitations or rules applied to products, such as availability based on user age or region.

SOURCE: https://github.com/treeben77/rblx-open-cloud/blob/main/docs/reference/creator.md#_snippet_7

LANGUAGE: APIDOC
CODE:
```
::: rblxopencloud.ProductRestriction
```

----------------------------------------

TITLE: Update rblx-open-cloud Library
DESCRIPTION: Instructions for upgrading the rblx-open-cloud library to the latest version using pip.

SOURCE: https://github.com/treeben77/rblx-open-cloud/blob/main/docs/guides/v2.md#_snippet_0

LANGUAGE: Windows Console
CODE:
```
py -3 -m pip install rblx-open-cloud --upgrade
```

LANGUAGE: Linux/macOS Console
CODE:
```
python3 -m pip install rblx-open-cloud --upgrade
```

----------------------------------------

TITLE: rblxopencloud.CreatorStoreProduct API
DESCRIPTION: API reference for CreatorStoreProduct, representing products listed in a creator's store. It likely includes information about product details, pricing, and availability.

SOURCE: https://github.com/treeben77/rblx-open-cloud/blob/main/docs/reference/creator.md#_snippet_2

LANGUAGE: APIDOC
CODE:
```
::: rblxopencloud.CreatorStoreProduct
    options:
        merge_init_into_class: true
```

----------------------------------------

TITLE: Publish Message using Open Cloud Python SDK
DESCRIPTION: Demonstrates how to publish string messages to a specified topic for live game servers. Messages are only received by live servers, not Studio. The service only supports string payloads; complex data must be JSON encoded.

SOURCE: https://github.com/treeben77/rblx-open-cloud/blob/main/docs/guides/experience.md#_snippet_11

LANGUAGE: python
CODE:
```
experience.publish_message("topic-name", "this is an example message content.")
```

----------------------------------------

TITLE: List Keys in a Datastore
DESCRIPTION: Demonstrates iterating through all keys within a datastore using `datastore.list_keys`. This method can optionally filter by a prefix and limit the number of results returned.

SOURCE: https://github.com/treeben77/rblx-open-cloud/blob/main/docs/guides/experience.md#_snippet_4

LANGUAGE: python
CODE:
```
for key in datastore.list_keys():
    print(key.key, key.scope)
```

----------------------------------------

TITLE: MessagingService API Reference
DESCRIPTION: Details the MessagingService properties and the publish method, including parameters, return values, and potential exceptions.

SOURCE: https://github.com/treeben77/rblx-open-cloud/blob/main/__wiki__/MessagingService.md#_snippet_0

LANGUAGE: APIDOC
CODE:
```
MessagingService
  Properties:
    universe: int - the ID of the targeted game/universe.

  Methods:
    publish(topic: str, data: str)
      Description: Publishes a message to the given topic. Only live servers will receive these messages, not Studio.
      Parameters:
        topic: str - The topic to publish this message to, can only be alphanumerical.
        data: str - Data to send, can only be string right now.
      Raises:
        InvalidKey: The key is not valid or doesn't have access to this.
        NotFound: This probably shouldn't be raised.
        RateLimited: You're being rate limited.
        ServiceUnavailable: Roblox, as usual, is having some downtime.
```

----------------------------------------

TITLE: User Profile and Settings API
DESCRIPTION: Provides access to user-specific data and settings, including social links, visibility preferences, and experience following status. Assumes methods are part of the rblxopencloud.User class.

SOURCE: https://github.com/treeben77/rblx-open-cloud/blob/main/docs/reference/user.md#_snippet_0

LANGUAGE: APIDOC
CODE:
```
rblxopencloud.User:
  __init__(user_id: int, client: 'RbxOpenCloudClient')
    Initializes the User object with a user ID and an active RbxOpenCloudClient instance.
    Parameters:
      user_id: The unique identifier for the Roblox user.
      client: An authenticated RbxOpenCloudClient instance.

  get_social_links() -> List[rblxopencloud.UserSocialLinks]
    Retrieves the social media links associated with the user.
    Returns: A list of UserSocialLinks objects.

  get_visibility() -> rblxopencloud.UserVisibility
    Retrieves the user's visibility settings.
    Returns: A UserVisibility object detailing privacy settings.

  get_following_experience() -> List[rblxopencloud.UserExperienceFollowing]
    Retrieves the list of experiences the user is following.
    Returns: A list of UserExperienceFollowing objects.

  update_social_links(links: List[rblxopencloud.UserSocialLinks]) -> None
    Updates the user's social media links. Requires appropriate permissions.
    Parameters:
      links: A list of UserSocialLinks objects to set as the user's new links.

  update_visibility(visibility: rblxopencloud.UserVisibility) -> None
    Updates the user's visibility settings. Requires appropriate permissions.
    Parameters:
      visibility: A UserVisibility object with the desired settings.

  follow_experience(experience_id: int) -> None
    Marks the user as following a specific experience.
    Parameters:
      experience_id: The ID of the experience to follow.

  unfollow_experience(experience_id: int) -> None
    Marks the user as no longer following a specific experience.
    Parameters:
      experience_id: The ID of the experience to unfollow.
```

----------------------------------------

TITLE: Publishing To Message Service
DESCRIPTION: Shows how to publish messages to a specified topic using the Roblox Open Cloud Message Service via the rblx-open-cloud library. Note that messages are only delivered to live game servers, not Studio.

SOURCE: https://github.com/treeben77/rblx-open-cloud/blob/main/README.md#_snippet_2

LANGUAGE: python
CODE:
```
import rblxopencloud

# create an Experience object with your experience ID and your api key
# TODO: replace '13058' with your experience ID
experience = rblxopencloud.Experience(13058, api_key="api-key-from-step-2")

# publish a message with the topic 'topic-name'
experience.publish_message("topic-name", "Hello World!")
```

----------------------------------------

TITLE: rblxopencloud.AssetVersion API
DESCRIPTION: Documentation for the AssetVersion class, detailing different versions of game assets. This class is crucial for tracking changes and managing asset history.

SOURCE: https://github.com/treeben77/rblx-open-cloud/blob/main/docs/reference/creator.md#_snippet_1

LANGUAGE: APIDOC
CODE:
```
::: rblxopencloud.AssetVersion
```

----------------------------------------

TITLE: rblxopencloud.Creator API
DESCRIPTION: Documentation for the Creator class, representing a user or entity that creates content on Roblox. This module likely provides methods for managing creator profiles and associated data.

SOURCE: https://github.com/treeben77/rblx-open-cloud/blob/main/docs/reference/creator.md#_snippet_3

LANGUAGE: APIDOC
CODE:
```
::: rblxopencloud.Creator
```

----------------------------------------

TITLE: rblxopencloud.Webhook Class API
DESCRIPTION: API documentation for the main Webhook class. This class is central to handling webhook events and configurations within the rblx-open-cloud library.

SOURCE: https://github.com/treeben77/rblx-open-cloud/blob/main/docs/reference/webhook.md#_snippet_0

LANGUAGE: APIDOC
CODE:
```
rblxopencloud.Webhook:
  __init__(self, url: str, secret: str)
    Initializes a Webhook instance.
    Parameters:
      url (str): The URL to send webhook events to.
      secret (str): The secret key used for signature verification.

  send(self, event_type: str, data: dict)
    Sends a webhook event to the configured URL.
    Parameters:
      event_type (str): The type of the event being sent (e.g., 'player_joined').
      data (dict): The payload data for the event.
    Returns:
      requests.Response: The response object from the HTTP POST request.

  verify_signature(self, request_body: str, signature_header: str)
    Verifies the signature of an incoming webhook request.
    Parameters:
      request_body (str): The raw body of the incoming request.
      signature_header (str): The value of the 'X-Rbx-Signature' header.
    Returns:
      bool: True if the signature is valid, False otherwise.
```

----------------------------------------

TITLE: Roblox Open Cloud Group API Reference
DESCRIPTION: This section details the core classes for managing Roblox groups and their associated data. It includes classes for group information, members, roles, shouts, and join requests. The documentation is generated using a tool that merges initialization methods into the class definition where applicable.

SOURCE: https://github.com/treeben77/rblx-open-cloud/blob/main/docs/reference/group.md#_snippet_0

LANGUAGE: APIDOC
CODE:
```
rblxopencloud.Group:
    # Represents a Roblox group and provides methods for group management.
    # Options: merge_init_into_class: true

rblxopencloud.GroupMember:
    # Represents a member of a Roblox group.
    # Options: inherited_members: false

rblxopencloud.GroupRole:
    # Represents a role within a Roblox group.

rblxopencloud.GroupRolePermissions:
    # Represents the permissions associated with a specific group role.

rblxopencloud.GroupShout:
    # Represents the current shout or status message of a Roblox group.

rblxopencloud.GroupJoinRequest:
    # Represents a pending request to join a Roblox group.
    # Options: inherited_members: false
```

----------------------------------------

TITLE: rblxopencloud.Asset API
DESCRIPTION: Documentation for the Asset class, which likely represents game assets within the Roblox ecosystem managed by the rblx-open-cloud library. This includes details on asset properties and methods for interaction.

SOURCE: https://github.com/treeben77/rblx-open-cloud/blob/main/docs/reference/creator.md#_snippet_0

LANGUAGE: APIDOC
CODE:
```
::: rblxopencloud.Asset
    options:
        merge_init_into_class: true
```

----------------------------------------

TITLE: Upload Place Method Update
DESCRIPTION: Shows the change in the 'upload_place' functionality. It has moved from the 'Experience' class to the 'Place' class and been renamed to 'upload_place_file'.

SOURCE: https://github.com/treeben77/rblx-open-cloud/blob/main/docs/guides/v2.md#_snippet_3

LANGUAGE: Python
CODE:
```
# v1
# experience.upload_place(000000, file)
```

LANGUAGE: Python
CODE:
```
# v2
# place = experience.get_place(000000)
# place.upload_place_file(file)
```

----------------------------------------

TITLE: PlacePublishing API Reference
DESCRIPTION: Details the PlacePublishing class, its properties, and methods for saving and publishing Roblox places. Includes parameter types, return values, and potential errors.

SOURCE: https://github.com/treeben77/rblx-open-cloud/blob/main/__wiki__/PlacePublishing.md#_snippet_0

LANGUAGE: APIDOC
CODE:
```
PlacePublishing:
  Properties:
    universe: int - The ID of the targeted game/universe.

  Methods:
    savePlace(place: int, file) -> int
      Description: Uploads an .rblx file to Roblox, saves it as the place, and returns the version number.
      Parameters:
        place: int - The place id to save the file to.
        file: file - .rblx file opened as 'rb'.
      Raises:
        InvalidKey: The key is not valid or doesn't have access to this.
        NotFound: This probably shouldn't be raised.
        RateLimited: You're being rate limited.
        ServiceUnavailable: Roblox, as usual, is having some downtime.

    publishPlace(place: int, file) -> int
      Description: Uploads an .rblx file to Roblox, saves & publishes it as the place, and returns the version number.
      Parameters:
        place: int - The place id to save the file to.
        file: file - .rblx file opened as 'rb'.
      Raises:
        InvalidKey: The key is not valid or doesn't have access to this.
        NotFound: This probably shouldn't be raised.
        RateLimited: You're being rate limited.
        ServiceUnavailable: Roblox, as usual, is having some downtime.
```

----------------------------------------

TITLE: Datastore Retrieval Method Renaming
DESCRIPTION: Illustrates the renaming of datastore retrieval methods in v2. 'get_data_store' is now 'get_datastore', 'list_data_store' is 'list_datastore', and 'get_ordered_data_store' is 'get_ordered_datastore'.

SOURCE: https://github.com/treeben77/rblx-open-cloud/blob/main/docs/guides/v2.md#_snippet_2

LANGUAGE: Python
CODE:
```
# v1
# datastore.get_data_store("my_ds")
# datastore.list_data_store()
# datastore.get_ordered_data_store("my_ods")

# v2
# datastore.get_datastore("my_ds")
# datastore.list_datastore()
# datastore.get_ordered_datastore("my_ods")
```

----------------------------------------

TITLE: Import Asynchronous rblx-open-cloud
DESCRIPTION: Demonstrates the correct import statement for using the asynchronous version of the rblx-open-cloud library in your Python projects.

SOURCE: https://github.com/treeben77/rblx-open-cloud/blob/main/docs/asynchronous.md#_snippet_0

LANGUAGE: python
CODE:
```
from rblxopencloudasync import Experience, APIKey
```

----------------------------------------

TITLE: rblxopencloud.AssetType API
DESCRIPTION: Documentation for the AssetType enum or class, defining the different categories of assets available on Roblox (e.g., 'Image', 'Mesh', 'Audio').

SOURCE: https://github.com/treeben77/rblx-open-cloud/blob/main/docs/reference/creator.md#_snippet_5

LANGUAGE: APIDOC
CODE:
```
::: rblxopencloud.AssetType
```

----------------------------------------

TITLE: Fetch User Information
DESCRIPTION: Retrieves basic information for a specified Roblox user. Requires a user ID and an API key. The fetched information includes display name and username.

SOURCE: https://github.com/treeben77/rblx-open-cloud/blob/main/docs/guides/user.md#_snippet_0

LANGUAGE: python
CODE:
```
import rblxopencloud

# Initialize the User object with user ID and API key
user = rblxopencloud.User(000000, "api-key")

# Fetch the user's information
user.fetch_info()

# Print the user's display name and username
print(user.display_name, user.username)
```

----------------------------------------

TITLE: rblxopencloud.Money API
DESCRIPTION: API documentation for the Money class, which handles currency and financial transactions within the Roblox platform. This class is essential for managing Robux or other in-game currencies.

SOURCE: https://github.com/treeben77/rblx-open-cloud/blob/main/docs/reference/creator.md#_snippet_4

LANGUAGE: APIDOC
CODE:
```
::: rblxopencloud.Money
```

----------------------------------------

TITLE: Inventory Item Management API
DESCRIPTION: Defines the structure and retrieval methods for various types of inventory items owned by a user. These classes represent different asset types within a user's inventory.

SOURCE: https://github.com/treeben77/rblx-open-cloud/blob/main/docs/reference/user.md#_snippet_1

LANGUAGE: APIDOC
CODE:
```
rblxopencloud.InventoryItem:
  asset_id: int
    The unique identifier for the asset.
  name: str
    The name of the inventory item.
  description: str
    A description of the inventory item.
  asset_type: rblxopencloud.InventoryAssetType
    The type of asset (e.g., 'Texture', 'Mesh').
  created: datetime
    The date and time the asset was created.
  updated: datetime
    The date and time the asset was last updated.
  asset_url: str
    The URL to access the asset.

rblxopencloud.InventoryAsset:
  Inherits from rblxopencloud.InventoryItem
  asset_id: int
    The unique identifier for the asset.
  name: str
    The name of the inventory item.
  description: str
    A description of the inventory item.
  asset_type: rblxopencloud.InventoryAssetType
    The type of asset (e.g., 'Texture', 'Mesh').
  created: datetime
    The date and time the asset was created.
  updated: datetime
    The date and time the asset was last updated.
  asset_url: str
    The URL to access the asset.

rblxopencloud.InventoryBadge:
  Inherits from rblxopencloud.InventoryItem
  badge_id: int
    The unique identifier for the badge.
  name: str
    The name of the badge.
  description: str
    A description of the badge.
  icon_url: str
    The URL for the badge's icon.
  created: datetime
    The date and time the badge was created.
  updated: datetime
    The date and time the badge was last updated.
  awarded_date: datetime
    The date and time the user was awarded the badge.

rblxopencloud.InventoryGamePass:
  Inherits from rblxopencloud.InventoryItem
  game_pass_id: int
    The unique identifier for the game pass.
  name: str
    The name of the game pass.
  description: str
    A description of the game pass.
  price: int
    The price of the game pass in Robux.
  is_public_domain: bool
    Indicates if the game pass is publicly available.
  created: datetime
    The date and time the game pass was created.
  updated: datetime
    The date and time the game pass was last updated.

rblxopencloud.InventoryPrivateServer:
  Inherits from rblxopencloud.InventoryItem
  private_server_id: int
    The unique identifier for the private server.
  name: str
    The name of the private server.
  description: str
    A description of the private server.
  max_players: int
    The maximum number of players allowed in the server.
  created: datetime
    The date and time the private server was created.
  updated: datetime
    The date and time the private server was last updated.

rblxopencloud.InventoryItemState:
  asset_id: int
    The unique identifier for the asset.
  name: str
    The name of the inventory item.
  asset_type: rblxopencloud.InventoryAssetType
    The type of asset.
  is_owned: bool
    Indicates if the user owns this item.

rblxopencloud.InventoryAssetType:
  id: int
    The numerical ID representing the asset type.
  name: str
    The string name of the asset type (e.g., 'Texture', 'Mesh', 'Audio').

rblxopencloud.UserSocialLinks:
  type: str
    The type of social link (e.g., 'Facebook', 'Twitter', 'YouTube').
  url: str
    The URL of the social media profile.
  requires_verification: bool
    Indicates if the link requires verification.

rblxopencloud.UserVisibility:
  profile: str
    Visibility setting for the user's profile ('AllUsers', 'FriendsOnly', 'NoOne').
  status: str
    Visibility setting for the user's status ('AllUsers', 'FriendsOnly', 'NoOne').
  inventory: str
    Visibility setting for the user's inventory ('AllUsers', 'FriendsOnly', 'NoOne').

rblxopencloud.UserExperienceFollowing:
  experience_id: int
    The ID of the experience being followed.
  name: str
    The name of the experience.
  root_place_id: int
    The ID of the root place for the experience.
  icon_url: str
    The URL of the experience's icon.
```

----------------------------------------

TITLE: Upload Asset
DESCRIPTION: Uploads an asset (image, audio, model) to the user's account. Requires an API key with read and write Asset API permissions. The method returns an operation object that can be used to track the upload status.

SOURCE: https://github.com/treeben77/rblx-open-cloud/blob/main/docs/guides/user.md#_snippet_3

LANGUAGE: python
CODE:
```
import rblxopencloud

# Initialize the User object
user = rblxopencloud.User(000000, "api-key")

# Open the image file in binary read mode
with open("path-to/image.png", "rb") as file:
    # Upload the asset, specifying file, asset type, name, and description
    operation = user.upload_asset(file, rblxopencloud.AssetType.Decal, "asset name", "asset description")

    # Wait for the upload operation to complete and get the asset details
    asset = operation.wait()
    print(asset)
```

----------------------------------------

TITLE: Exception Renaming and Merging
DESCRIPTION: Lists the changes in exception handling for v2. Several v1 exceptions have been renamed or merged into new classes like 'BaseException', 'HttpException', 'Forbidden', and 'InvalidFile'.

SOURCE: https://github.com/treeben77/rblx-open-cloud/blob/main/docs/guides/v2.md#_snippet_6

LANGUAGE: APIDOC
CODE:
```
Exception Changes in v2:

- rblx_opencloudException -> rblxopencloud.BaseException
- InvalidKey -> rblxopencloud.HttpException
- PermissionDenied -> rblxopencloud.Forbidden
- ServiceUnavailable -> rblxopencloud.HttpException
- InsufficientScope -> rblxopencloud.HttpException
- InvalidAsset -> rblxopencloud.InvalidFile

Note: Some breaking changes might not be documented. Please report any missing ones.
```