---

kanban-plugin: board

---

## Backlog

- [ ] #Account Ability to change username
- [ ] #Account Account deletion
- [ ] #Assets Allow rotating room devices and deployed personal items. Allow specifying default rotation for deployment.
- [ ] #Assets "Space role"-based lock
- [ ] #Assets Add checks for priority layer assignments, relative to item being or not being a bodypart
- [ ] #Assets Character size [pandora#71](https://github.com/Project-Pandora-Game/pandora/issues/71)
- [ ] #Assets Consider dropping typed module change memory
- [ ] #Assets Graphics: Add way to programatically mirror image (usage: back view in room device)
- [ ] #Assets Graphics: Text module curved text
- [ ] #Assets Improve the point transformations of the leg width slider
- [ ] #Assets Prerequisites on body sizes for assets
- [ ] #Assets Recheck height offset calculation for standing, kneeling and sitting. Consider allowing assets to offset this (e.g. heels, things to stand on, wearable devices)
- [ ] #Assets Repository: Check snake_case filenaming
- [ ] #Assets Rework how kneeling and sitting works, explore using actual 3D transforms, fix back sitting being extremely weird
- [ ] #Assets Room devices: "Isolation" toggle, similar to Bound Usage, that prevents characters inside from interacting with outside of the device (log 11/10/2025 with Zara)
- [ ] #Assets Room devices: Ability to scale if there is no character slot
- [ ] #Assets Add new flat kneeling state ([#332](https://github.com/Project-Pandora-Game/pandora-assets/issues/332))
- [ ] #Assets Split arms at elbow and add 6 new layer priorities for hands, lower_arms, and upper_arms ([#36](https://github.com/Project-Pandora-Game/pandora-assets/issues/36)), ([#269](https://github.com/Project-Pandora-Game/pandora/issues/269))
- [ ] #Assets Split legs control
- [ ] #Assets Stop points for sizes sliders (mainly only specific breasts sizes)
- [ ] #Chat Add a `/wardrobe` command that opens the wardrobe of the specified character (or self if no name is specified)
- [ ] #Chat Better error and progress output for chat
- [ ] #Chat Hide original message if all of it is covered by embeds
- [ ] #Chat Interactive embeds need buttons instead of being clickable themselves
- [ ] #Chat Setting to always roll chat
- [ ] #Chat Some way to show chat also in other views, such as wardrobe: e.g. moving it into an overlay that survives view changes, or splitting the screen into two parts when switching to different views so that the chat always remains visible (but could possibly be resized), or some way to open the chat in a new browser tab ([Livie idea](https://i.imgur.com/OCiluRe.png))
- [ ] #Chat Use UTF (( for OOC
- [ ] #Core Bots
- [ ] #Core Invite someone along to another space
- [ ] #Core Join space from inside current one
- [ ] #Editor Button to reorder automesh graphical layers
- [ ] #Modifiers Modifier idea: "tinting" the screen of a user in certain colors, like pink, green or blue
- [ ] #Modifiers Modifier idea: setting up bone rotation limits, so people can't for example force you into an impossible leg split you can't handle
- [ ] #Performance Load logical asset definition asynchronously
- [ ] #UI #Performance Throttle space search list updates
- [ ] #Room Add ability to make the directional path squares larger
- [ ] #Room Allow customizing if room level device shows interactable icon.
- [ ] #Room Character label and room device buttons hitscanning
- [ ] #Room Option to display character labels and room device buttons as overlay level. Optionally triggerable by an key (Alt proposed).
- [ ] #Room special space setting for admins: "dark room" -> the light is out so everyone has a blindness effect of a configurable strength on them
- [ ] #Room Think about what to do with the random toggles at the end
- [ ] #Server Framework: A new framework for minigames (log 25/06/03)
- [ ] #Server Services: Convert server code to use service manager
- [ ] #UI Add "debug" settings and hide debug options altogether unless enabled there
- [ ] #UI Character selection: Current state labels rework
- [ ] #UI Collect character names for id resolution from items (particularly locks)
- [ ] #UI Consider local character/account name cache
- [ ] #UI Contacts: Split into contacts and DM subscreens
- [ ] #UI Contacts: Think about what to use instead of tables (might be fine by now~ )
- [ ] #UI Permission prompt should better show currently granted permissions and already denied ones
- [ ] #UI Room settings: Show number of room settings overrides
- [ ] #UI See spaces list from space
- [ ] #UI Tutorials: Highlighting of character name on canvas
- [ ] #Wardrobe Add the option to show the chat also while in the wardrobe view (kinda done with notifications?)
- [ ] #Wardrobe Module Type Split & Allow freezing item's setup
- [ ] #Wardrobe Alternative layout for mobile and TVs (portrait variant, overlapping panes)
- [ ] #Wardrobe Change asset creation to default to grid mode, revisit how many columns to show for which screens, save the list/grid toggle state locally
- [ ] #Wardrobe Consider overview buttons for "Body"
- [ ] #Wardrobe Differentiate between state and setup asset modules, separate UI for item setup
- [ ] #Wardrobe Display IK posing UI when switched to the Pose tab
- [ ] #Wardrobe Expressions / typed modules need images
- [ ] #Wardrobe Preview graphics - add setting whether it should be movable or not


## Up Next

- [ ] #Bug #Chat Messages from other rooms should not trigger notifications while in focus mode.
- [ ] #UI In-room wearable items context menu: Add button to wear the item
- [ ] #Editor Ability to set conditions for a layer to be enabled (mainly related to text layers)
- [ ] #Bug #Editor Creating new asset doesn't work for bodyparts or room devices. Revise the template mechanism.
- [ ] #Safety Check what blocking does, write it up
- [ ] #Safety Settings for who can DM, who can request contact
- [ ] #Bug #Assets Bed bottom ropes look weird when laying face down
- [ ] #Bug #Assets Linen blouse can have breasts peek from the back
- [ ] #Bug #Assets Cup/Mug force above hair arms, instead of standard front arms
- [ ] #Bug #Assets Party dress: When arm is lifted upwards, the front separates (causes gaps)
- [ ] #Documentation Update Node.js versions mentioned (maybe just make it a link?)
- [ ] #Wardrobe Consider allowing more characters for item names
- [ ] #Dev Make Zod into peer dependency or avoid needing it in asset repository (often causes breaks on updates, which resolve themselves, but are annoying and noisy)


## In Progress



## Done

**Complete**


## On Hold

- [ ] #ESLint member-ordering
- [ ] #ESLint {} for `for` (seems ESLint doesn't have enough configurability for this)
- [ ] #ESLint method-signature-style (maybe consider later)
- [ ] #Bug #Room Double-click triggers from single-click buttons [Discord](https://discord.com/channels/872284471611760720/872568378190086174/1441954493208989728)
	→ A bit hard to do, the handlers don't interact well and preventing default on click doesn't stop doubleclick event


## Rejected



***

## Archive

- [x] #Editor Show coordinates on mouse hover over graphics
- [x] #UI DMs should remember chat input text across reloads
- [x] #Wardrobe Highlight items visible inside room (devices and items)
- [x] #Chat Action log needs filters expanded to deployed item movement and to room device repositioning
- [x] #Safety Add option to hide characters of blocked accounts
- [x] #Chat Add a way to manually link items in chat messages
- [x] #UI Hitscan for graphics elements
- [x] #Logic Allow wearable items to be visible in room when in room inventory

%% kanban:settings
```
{"kanban-plugin":"board","list-collapse":[false,false,false,false,false,false],"new-line-trigger":"shift-enter","new-card-insertion-method":"prepend","tag-colors":[{"tagKey":"#Safety","color":"rgba(0, 0, 0, 1)","backgroundColor":"rgba(255, 136, 0, 1)"},{"tagKey":"#Core","color":"rgba(204, 204, 204, 1)","backgroundColor":"rgba(0, 0, 0, 1)"},{"tagKey":"#Bug","color":"rgba(221, 149, 156, 1)","backgroundColor":"rgba(61, 22, 22, 1)"}]}
```
%%