[![hackmd-github-sync-badge](https://hackmd.io/jUhzIyWHQOOC0E9gd2kuCw/badge)](https://hackmd.io/jUhzIyWHQOOC0E9gd2kuCw)

# Project Pandora

For collaborators unfamiliar with Markdown (the formatting syntax used in this document), see [this summary of Markdown syntax](https://www.markdownguide.org/basic-syntax/) to learn how to format things.

## Technology Stack/Language Choices

Repository structure:
* Individual repositories
    * Documentation ([`Documentation`](https://github.com/Project-Pandora-Game/Documentation))
    * Assets (`pandora-assets`)
    * Template ([`tooling-template`](https://github.com/Project-Pandora-Game/tooling-template)) - changes to linting/configs should be done here and merged to all repos
    * Common ([`pandora-common`](https://github.com/Project-Pandora-Game/pandora-common)) - things shared across most components, for example socket messages definitions
    * Directory server ([`pandora-server-directory`](https://github.com/Project-Pandora-Game/pandora-server-directory))
    * Shard server ([`pandora-server-shard`](https://github.com/Project-Pandora-Game/pandora-server-shard))
    * Web Client ([`pandora-client-web`](https://github.com/Project-Pandora-Game/pandora-client-web))
    * Bot Client (`pandora-client-bot`)
* Standards
    * Not part of this document, enforced by linting; TODO: Writeup
* Review process
    * No direct pushes to master outside of new repository setup
    * 2 Approving reviews required (can be blocked by anyone, requires resolving)
    * Prefered reviews by peers (code things by coders, assets by asset makers)

### Front end

| Category | Status | Tech/Options | Notes |
| --- | --- | --- |:--- |
| Primary Language | Confirmed | [TypeScript](https://www.typescriptlang.org/) | |
| Build tooling/bundling | Confirmed | [Webpack](https://webpack.js.org/) | |
| Drawing/rendering library | Confirmed | [PixiJS](https://www.pixijs.com/) | Will likely depend on choice of [asset framework](#Asset-Framework)<br/><br/>[A collection of WebGL and WebGPU frameworks and libraries](https://gist.github.com/dmnsgn/76878ba6903cf15789b712464875cfdc) |
| Linting | Confirmed | ESLint | Plugins to consider: <br /> [`@typescript-eslint`](https://www.npmjs.com/package/@typescript-eslint/eslint-plugin) <br /> [`eslint-plugin-react`](https://www.npmjs.com/package/eslint-plugin-react) <br /> [`eslint-plugin-unicorn`](https://github.com/sindresorhus/eslint-plugin-unicorn) |
| Unit testing | Confirmed | [Jest](https://jestjs.io/) | Libraries to consider: <br/> [Testing Library](https://testing-library.com/) (for DOM/HTML components) |
| HTML framework | Confirmed | [React](https://reactjs.org/) | Handles most things if possible before deferring to [PixiJS](https://www.pixijs.com/) |
| Translation | TBC| ??? | Needs exploration. Potential libraries: <br /> [`i18n`](https://www.npmjs.com/package/i18n) <br /> [`node-gettext`](https://www.npmjs.com/package/node-gettext) (works in browser, despite the name) <br /> [`globalize`](https://www.npmjs.com/package/globalize) <br /> [`node-polyglot`](https://www.npmjs.com/package/node-polyglot) (React HOC also available in [`react-polyglot`](https://www.npmjs.com/package/react-polyglot)) |
### Server

| Category | Status | Tech/Options | Notes |
| --- | --- | --- | --- |
| Primary Language | Confirmed | TypeScript (Node.js) | Will be sharing definitions with client |
| Build tooling | Confirmed | Just TS | |
| Databases/caches | TBC | [MongoDB](https://www.mongodb.com/) | Will depend on features/requirements |

## Security/Account Management

Things to consider:
* Password handling/encryption
* Account spam prevention
    * Verified email
    * Captcha?
* Allowing multiple characters per account
    * Shared inventory/money
    * Shared friends?

__Information for players__ (according to our approaches below):

> * Your password _and_ email address are both encrypted on our servers
> * If you forget your password, you will be able to reset it using your email address
> * Make sure you remember the email address that your registered with. If you forget/lose access to your email address, we will be **unable** to recover your account, and you could lose access to it permanently

### Email handling approach

Emails are hashed and the hashes are saved against a player's account (but not the plaintext email). During registration, a confirmation email will be sent to you; the email address is not saved after the email has been sent. During password reset, you will be required to enter your email. It will be compared to the saved hash, but not saved after reset OTP is sent.

This means that:
* It is still possible to check uniqueness of emails
* In the case of a DB leak, player emails cannot be read by anyone (even the devs)
* It __will not__ be possible for us to contact players/send push notifications by email

### Password handling approach

Passwords will be hashed on both the client and the server:
1. On the client, the password along with a static salt is hashed using SHA512 (i.e. `SHA512(staticSalt + password)`) and sent to the server
2. On the server, the hashed password is hashed again along with an account-specific salt (i.e. `hash(accountSalt + clientHash)`). This is then what is stored in/compared with the DB. Hashing algorithm on the server TBC.

In particular, hashing the password on the client means that a player's plaintext password is never disclosed, either in transit, or on the server.

### Auth flow

TODO

## Reporting, Moderation & Transparency

* Players should know/be able to easily find out which parts of the game are stored/available to moderators (e.g. chats are not logged)
* Public-facing content (e.g. player/room/area names) can be reported for manual review by moderators
* Moderation & bans uses a voting system - approval from a few (3?) moderators is needed before action can be taken
* Private chatrooms should be free from moderator oversight
* Chatroom admins can ban/kick players from chatrooms
* Players can blacklist/block other players from DMs

## Asset Framework

Considerations:
* Different view angles
* Different poses
* Scalable body parts
* Multiple-people interactions (leashes, large cages, laying in lap, ...)
* Layering + clipping prevention
* Technology choices & learning curves
* Performance (Clients (Mobile phones too), rendering, server load, hosting)

Options suggested so far:

* BC-style pose/asset system (layered 2D images)
    * __\+__ everyone's familiar with it
    * __\+__ easy to add items - everything is just an image
    * __\-__ doesn't scale well - total assets scales with total items * total poses, adding a new pose is loads of work, and with each new pose, adding new assets becomes more work 
    * __\-__ not enough granularity with the current body part splits
    * __\-__ potential for different drawing/photobashing styles
* 2D character framework
    * __\+__ More flexibility for creating new poses (within reason)
    * __\+__ Should still be fairly easy to add items - it's all still mostly 2D images
    * __\+__ Potential for (some limited) animation support
    * __\-__ Major pose angle changes (e.g. back/front/sides) are still a lot of work
    * __\-__ potential for different drawing/photobashing styles
    * Possible tech:
        * ~~[DragonBones](http://dragonbones.com/en/index.html#.YQp33FVKhhE)~~ - too old and unmaintained
        * ~~[Spine](http://esotericsoftware.com/)~~ - paid software, to use meshes we would need full license
        * In-house
* Generated 2D views from 3D models
    * __\+__ Lots of flexibility for creating new poses - should be simple to re-generate assets if the base models are checked into the repo
    * __\+__ Using the same rendering engine means consistent look & feel
    * __\-__ New software - people will need to work with 3D modelling software rather than hand-drawing
    * __\-__ Development of assets will probably be slower, as everything will need to be 3D modelled
    * Possible tech:
        * 3DCG
            * probably a bit outdated/hard to get set up nowadays
            * is in japanese
        * ~~[Vroid engine](https://vroid.com/en)~~
            * **[Bad license terms](https://vroid.com/en/studio/guidelines)**
                * see: *When creating character making tools*
                * even stricter: [Article 5.8](https://policies.pixiv.net/en.html#vroidstudio) 
                * or just no reason at all: [Article 14.28](https://policies.pixiv.net/en.html#terms)
            * easy to set up/is on steam
            * is (mostly) in a native language
            * currently in beta - possibly not fully-featured yet
            * exported .vrm files can't be re-imported into VRoidStudio for editing (can be edited in Unity/Blender though apparently) - might make sharing of models tricky
        * [MMD](https://learnmmd.com/downloads/)
        * [Blender](https://www.blender.org/)
* ~~Full 3D~~
    * ~~__\+__ Lots of flexibility - poses, animation, etc.~~
    * ~~__\+__ Look & feel will be consistent~~
    * ~~__\+__ Possibility of adding physics~~
    * ~~__\-__ People will need to learn new software - probably somewhat harder for new people to contribute~~
    * ~~__\-__ Client performance will probably be an issue in a browser-based game~~
    * ~~__\-__ Everything probably needs to be 3D - not just the character models~~

## Mechanics

### Confirmed Mechanics (Will be in game)

* Most game logic will be handled server-side - this means no cheating money, escaping from owner locks, etc.
* Nothing else set in stone just yet

### Current Ideas

#### Reputation System

* Limit amount that can be given/received by players in a given time. For example:
    * Players can give up to 5 reputation points per day
    * Players can receive a maximum of 5 reputation points per day
    * Players cannot give reputation to the same person more than once
* Does __not__ limit players in any major way
* Give perks to those who have a high Reputation (Rep) - perks should _not_ give players unfair gameplay advantages, but should be geared towards better community moderation/management
* Moderators could potentially give reputation points to players for assisting the community:
    * Making (valid) bug reports
    * Reporting abusive/harmful content
* Ideas for reputation-based perks:
    * Increased report visibility
    * Ability to submit shop items
    * Ability to create a new area
    * Increased room capacity as admin
    * Ability to designate an admin in a room that has been admin-less for more than X minutes/hours
    * Ability to sumbit shop items without them going through manual review
    * Access to bot API features

#### Save state/rollback system

* Players can rollback to their last save state at any time (but will lose any progress/items/money gained during that time as a penalty)
* Everyone gets an immutable save state immediately after character creation
* Save states may be restricted depending on difficulty mode/account type
* Anyone can create a save state at will, and has one (possibly a few) stored
* Anyone can reset their account, rolling back to the immutable post-creation save state (but obviously losing everything in the process)
* Players can delete save states (except the initial save state), or lock them for a time of their choosing
* Players can switch to a 'hardcore' account, which prevents the ability to make save states at all. Backing out of hardcore is possible, but will revert the player to their pre-hardcore state (a single save state that is made before the player switches to hardcore)

## Economy/Inventory

__Questions to answer:__
* Should players have inventories (should they be able to earn items, or have access to everything)?
* If players can earn items, how does money/the economy work? How can players earn money fairly without being able to abuse the system?
* Where would money come from/how would players spend it?
* How do we avoid the BC problem (i.e. getting items for multiplayer requires players to grind money in single player for long periods)?
* Could we have themed sandbox areas where all items in a particular category are available (e.g. shibari dojo where players can always use as much rope as they want, but can't take it outside)
* How do we keep the economy player-driven?

### Ideas

* Login bonus - players earn a fixed amount of currency/number of items when they login
    * "login vouchers", which can be redeemed for certain common items (to give new players a head-start with some basic items), or redeemed for a much smaller amount of cash
    * Ability to pick X items on login
* Ability to buy decorations/items for your chatrooms, e.g. placeable pictures, decorations, or bondage furniture, which could be interacted with by players (see room-based restraints in [General Ideas](#General-ideas))
* Have items be "unique" - buying an item once doesn't allow you to use it infinitely - you can only use an item on one person at any given time - to bind multiple players, you need multiple items
    * Players could choose to apply an item "temporarily" (item is removed and automatically returns to owner if the wearer leaves the room/logs out), or "persistently" (item stays on the wearer even after they leave the room)
* Have sandbox "roleplay" rooms, where players get access to all items, but any items added inside a roleplay room are tracked and removed upon exit
    * How do we prevent players from never leaving roleplay rooms (and should we)?
    * Roleplay rooms could charge a "room hire" fee
    * Roleplay rooms could be themed (e.g. Shibari Dojo has an unlimited supply of ropes, etc.)
* Potentially restrict item colour/customisation - once you've bought an item in a given colour, the item's colour/customisation (e.g. custom text) is fixed (but could be changed for a fee/with special items like dyes)
* Slave-trading (or slave hire/temporary ownership) as a way to earn money
* Adapted versions of some of the single-player content from BC (e.g. drink-serving/club slave), but with a more multiplayer focus (need to work out exactly what that means), have a kidnapping require players to actually kidnap another player
* CYOA/escape/script rooms as a way to earn money (again, should be focused on allowing two or more players to interact within the game)
    * Could allow player-created bots to distribute a limited amount of money to players based on the creator's reputation - see [Reputation System](#Reputation-System)
* Item/material crafting
    * Have professions (e.g. tailoring, smithing, leatherworking, woodworking) - items need materials from multiple professions to encourage players to trade
* Ability for players to steal items from others
* Item durability
* Store sales (e.g. latex items 50% off today)
* Allow players to set up their own storefronts to sell crafted (or bought-on-sale) items (could also hire other players as display models)

## Chatrooms

Hierarchical chatroom structure: World -> Areas -> Rooms
* World
    * Technical based, selected on login, cannot change without logout
    * World:Shards = 1:N (Each shard has assigned world)
    * Examples
        * Normal world - 99% of activity
        * Beta world - Maybe limited access?
        * Development world - For development tests, maybe for Bot/Addon developers
* Areas
    * Themes
        * Logical themes (RP, Fun, AFK, Bots, etc.)
        * Item themes (e.g. sci-fi, medieval, fantasy, etc.)
    * ? Developer area that can only be created by devs, resets player to previous state on exit
    * Restrictions on who can make rooms in areas (e.g. a bot-only area)
    * Persistent areas defined by devs; 
* Rooms

## General ideas

Feel free to stick anything here that doesn't fit into a category: ideas, concepts, cool things we couldn't do with BC that would be nice to add, anything goes! We can sift through later to pull out features that we might like.

* Sandbox Room- Customize an NPC and tie them up.
* Things to do besides roleplay?
* Global message warnings before server restart with some state saves
* Server sharding, so server can restart in steps without downtime
* Room-based restraints (e.g. big devices like the St. Andrews Cross are attached to rooms, rather than "carried around" by players)

# Development status

This is current development status of the features we want for MVP (minimal viable product); more will be added later.

Explanation of the table:
- Categories are bold and marked with a \* symbol in front
- WIP = Someone is actively working on this (at least a bit of work has been done)
- Ready for review = The feature works fully and is being discussed/improved further
- Done = The feature is tested, reviewed and released
- Assignees = People working on this - talk to them about this feature if you want to chip in
- ★ symbol = It is important to get this feature going as soon as possible

| Step                             | WIP | Ready for review | Done | Assignees |
| -------------------------------- | --- | ---------------- | ---- | --------- |
| Environment setup ★ | ✔ | ✔ | ✔ |  |
| Data verification framework ★ | ✔ |  |  | Sekkmer, Jomshir |
| Deployment setup |  |  |  |  |
| Mail server/relay setup | ✔ | ✔ |   | Sekkmer |
| Captcha |  |  |  |  |
| * __Unit testing__ |  |  |  |  |
| Setup ★ | ✔ | ✔ | ✔ | |
| Back-end unit tests | ✔ | Some | | TechTheAwesome |
| Front-end unit tests |  | | | |
| * __Database__ |  |  |  |  |
| In-memory for testing ★ | ✔ | ✔ | ✔ | Jomshir |
| MongoDB connection | ✔ | ✔ | ✔ | Sekkmer |
| Production setup |  |  |  | Sekkmer, Jomshir |
| * __Cross-server communication__ |  |  |  |  |
| Shard-Directory connection ★ | ✔ | ✔ | ✔ | Jomshir, Sekkmer |
| Indirect database access ★ | ✔ |  |  | Sekkmer |
| Shard registration process ★ | ✔ |  |  | Jomshir |
| Timeout and reconnect logic |  |  |  | Jomshir |
| Shard migration for character |  |  |  |  |
| Shard migration for rooms |  |  |  |  |
| * __Client-server communication__ |  |  |  |  |
| Client-Directory connection ★ | ✔ | ✔ | ✔ | Jomshir, Sekkmer |
| Client-Directory reconnect | ✔ |  |  | Jomshir |
| Client-Directory timeout logic |  |  |  | Jomshir |
| Client-Shard connection ★ | ✔ |  |  | Jomshir, Sekkmer |
| Client-Shard reconnect |  |  |  | Jomshir |
| Client-Shard timeout logic |  |  |  | Jomshir |
| Shard switching |  |  |  |  |
| * __Accounts__ |  |  |  |  |
| Login ★ | ✔ | ✔ | ✔ |  |
| Registration | ✔ | ✔ | ✔ |  |
| Email verification | ✔ | ✔ | ✔ |  |
| Password reset | ✔ | ✔ | ✔ |  |
| Friend system |  |  |  |  |
| DM/Beeps system |  |  |  |  |
| * __Characters__ |  |  |  |  |
| Creation |  |  |  | Jomshir, Sekkmer |
| Selection ★ | ✔ |  |  | Jomshir, Sekkmer |
| Data loading/saving ★  | ✔ |  |  | Sekkmer |
| Description / BIO |  |  |  |  |
| Deletion |  |  |  |  |
| * __Rooms__ (and room hubs) |  |  |  |  |
| Creation |  |  |  | Jomshir |
| Listing |  |  |  | Jomshir |
| Admin menu |  |  |  |  |
| Character position in room |  |  |  |  |
| Allow/Block list |  |  |  |  |
| Chat |  |  |  |  |
| * __Assets__ |  |  |  |  |
| Asset repository ★ |  |  |  |  |
| Asset definitions ★ | ✔ |  |  | Claudia, Jomshir |
| Agree on view/perspective ★ | ✔ |  |  |  |
| Agree on poses ★ | ✔ |  |  |  |
| Base body ★ | ✔ |  |  | Claudia, Jomshir |
| Poses system ★ | ✔ |  |  | Claudia, Jomshir |
| * __Items__ |  |  |  |  |
| Item creation/spawning ★ |  |  |  |  |
| Character inventory ★ |  |  |  |  |
| Room inventory |  |  |  |  |
| Equiping ★ |  |  |  |  |
| Transfer between inventories |  |  |  |  |
| * __Mechanics__ |  |  |  |  |
| Item blocks (sensible combinations) |  |  |  |  |
| Item locks |  |  |  |  |
| Safeword/safety mechanics |  |  |  |  |
| Lovership |  |  |  |  |
| Ownership |  |  |  |  |
| Interaction permissions |  |  |  |  |
