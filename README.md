[![hackmd-github-sync-badge](https://hackmd.io/jUhzIyWHQOOC0E9gd2kuCw/badge)](https://hackmd.io/jUhzIyWHQOOC0E9gd2kuCw)

# Project Pandora


## Technology Stack/Language Choices

Questions to answer:
* Repository setup/structure (monorepo, separate server/UI repos, separate repo for assets?)
* Coding standards/review process/style guide ([prettier](https://prettier.io/)?)

### Front end

| Category | Status | Tech/Options | Notes |
| --- | --- | --- | --- |
| Primary Language | Confirmed | [TypeScript](https://www.typescriptlang.org/) | |
| Build tooling/bundling | TBC | [Webpack](https://webpack.js.org/), [Rollup](https://rollupjs.org/guide/en/), ~~[Parcel](https://parceljs.org/)~~ | |
| Drawing/rendering library | Likely | [PixiJS](https://www.pixijs.com/), <br/> ~~[Three.js](https://threejs.org/) (probably only for 3D in browser)~~ | Will likely depend on choice of [asset framework](#Asset-Framework)<br/><br/>[A collection of WebGL and WebGPU frameworks and libraries](https://gist.github.com/dmnsgn/76878ba6903cf15789b712464875cfdc) |
| Linting | Confirmed | ESLint | Plugins to consider: <br /> [`@typescript-eslint`](https://www.npmjs.com/package/@typescript-eslint/eslint-plugin) <br /> [`eslint-plugin-react`](https://www.npmjs.com/package/eslint-plugin-react) <br /> [`eslint-plugin-unicorn`](https://github.com/sindresorhus/eslint-plugin-unicorn) |
| Unit testing | Yes | [Jest](https://jestjs.io/), [Mocha](https://mochajs.org/) | Libraries to consider: <br/> [Testing Library](https://testing-library.com/) (for DOM/HTML components) |
| HTML framework | Likely | [React](https://reactjs.org/) | |
| Translation | TBC | ??? | Potential libraries: <br /> [`i18n`](https://www.npmjs.com/package/i18n) <br /> [`node-gettext`](https://www.npmjs.com/package/node-gettext) (works in browser, despite the name) <br /> [`globalize`](https://www.npmjs.com/package/globalize) |
### Server

| Category | Status | Tech/Options | Notes |
| --- | --- | --- | --- |
| Primary Language | TBC | TypeScript (Node.js), Java, C# | |
| Build tooling | TBC | Depends on language choice | |
| Databases/caches | TBC | Will depend on features/requirements | |

## Security/Account Management

Things to consider:
* Password handling/encryption
* Account spam prevention
* Allowing multiple characters per account

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
        * [DragonBones](http://dragonbones.com/en/index.html#.YQp33FVKhhE)
* Generated 2D views from 3D models
    * __\+__ Lots of flexibility for creating new poses - should be simple to re-generate assets if the base models are checked into the repo
    * __\+__ Using the same rendering engine means consistent look & feel
    * __\-__ New software - people will need to work with 3D modelling software rather than hand-drawing
    * __\-__ Development of assets will probably be slower, as everything will need to be 3D modelled
    * Possible tech:
        * 3DCG
            * probably a bit outdated/hard to get set up nowadays
            * is in japanese
        * [Vroid engine](https://vroid.com/en)
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

* Nothing set in stone just yet

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

Questions to answer:
* Should players have inventories (should they be able to earn items, or have access to everything)?
* If players can earn items, how does money/the economy work? How can players earn money fairly without being able to abuse the system?
* Where would money come from/how would players spend it?
* How do we avoid the BC problem (i.e. getting items for multiplayer requires players to grind money in single player for long periods)?
* Could we have themed sandbox areas where all items in a particular category are available (e.g. shibari dojo where players can always use as much rope as they want, but can't take it outside)

## Chatrooms

* Hierarchical chatroom structure: World -> regions (?) -> areas -> rooms
    * Might be too much nesting?
* Regions/areas have themes (e.g. sci-fi, medieval, fantasy, etc.)
* Developer area that can only be created by devs, resets player to previous state on exit
* Restrictions on who can make rooms in areas (e.g. a bot-only area)

## General ideas

Feel free to stick anything here that doesn't fit into a category: ideas, concepts, cool things we couldn't do with BC that would be nice to add, anything goes! We can sift through later to pull out features that we might like.

* Sandbox Room- Customize an NPC and tie them up.
* Things to do besides roleplay?
* Global message warnings before server restart with some state saves
* Server sharding, so server can restart in steps without downtime