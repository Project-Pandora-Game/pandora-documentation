# Pandora asset creation: Glossary

This page contains a glossary of various terms used during asset creation.

You do not need to study the following terms in detail, but know that they are explained here. These terms are used throughout asset creation tutorial, the asset repository, and the Editor.

# Asset

An asset is a code blueprint on how an item can be created and configured from it. It consists of two parts, both defined in the asset repository:
- the logic of the asset - like default colors, modules, asset attributes, effects, etc. - created using simple, defined code
- the graphics of the asset - images and `graphics.json` (or `roomDeviceGraphics.json`) file created using Pandora's asset editor, defining how the asset is displayed

## Asset types

There are a few types of assets that are treated fundamentally differently in some parts of Pandora.
When defining an asset, the type is determined by what `Define*` macro you use in the `.asset.ts` file.

Currently Pandora differentiates between these types:

### Personal item

Type: `personal`

The most common type - any item that can be worn, held, or stored (note: it is possible to forbid wearing items of an asset altogether, but not commonly used).

Personal assets are defined using the `DefineAsset` macro.

### Body part

Type: `bodypart`

An item that is part of the body and shown in the "Body" tab of the wardrobe. For example base body, eyes, or hair.

Body part assets are defined using the `DefineBodypart` macro.

### Room device

Type: `roomDevice`

An item that can be displayed in a room. Some room devices can also allow characters to enter inside.
Room devices are sometimes also described as "room-level items".

Room devices are defined using the `DefineRoomDeviceAsset` macro.

### Room device wearable part

Type: `roomDeviceWearablePart`

This is a fake asset automatically created by Pandora when a character enters a room device.

When a character is inside a room device, one can seemingly see the room device equipped in that character's wardrobe.
This item actually is a "Room device wearable part" and it is specific to the slot the character is in. It provides a mechanism for applying effects on this character.

Assets of this type cannot be manually defined - they are defined automatically for each slot of any Room device.

### Lock

Type: `lock`

Locks are special items put in lock slots.

For more details see existing locks in [pandora-assets/src/assets/locks](https://github.com/Project-Pandora-Game/pandora-assets/blob/master/src/assets/locks)

Locks are defined using the `DefineLockAsset` macro.

## Item size

Allows other bits of Pandora logic to determine where this item fits. Most notably used for storage modules to prevent things such as storing a table in a purse.

Items can have the following sizes:
- `bodypart` - Exclusively used by body parts, as it makes no sense to consider them as anything else than part of the body.
- `small` - Items that fit into a box (20cm x 20cm).
- `medium` - Items that fit into a backpack.
- `large` - Items that fit into a 1m x 1m crate.
- `huge` - Anything bigger

## Attributes

Assets can have many "attributes". They are generic things like "Body", "Hair", "Collar", "Collar with front ring", ...

Asset attributes allow for three main things:
- Assets can require or forbid other assets below them (like a leash can require a collar with a front ring in order to equip it on a character, or an insert-able gag can forbid anything that covers mouth under it)
- Assets can cover other assets of a certain attribute below them (like a mitten can cover a rubber glove), which makes the covered items unable to be removed, before the covering item is.
- Assets can hide other assets below them (a hood can use attributes to fully hide any hair) - this is possible using alpha masks too, but these are currently experimental, unfinished and with heavy performance cost

You can find a detailed list of attributes at the top of the [pandora-assets/src/attributes.ts](https://github.com/Project-Pandora-Game/pandora-assets/blob/master/src/attributes.ts) file.

## Effects

Equipped items can apply some effects to the character wearing it. Some example are: Blindfold applying blindness, gags limiting speech, some restraints preventing usage of arms, etc.

You can find possible effects in these files:
- Generic effects in [pandora-common/src/assets/effects.ts](https://github.com/Project-Pandora-Game/pandora/blob/master/pandora-common/src/assets/effects.ts)
- Muffling (gag) effects in [pandora-common/src/chat/muffling.ts](https://github.com/Project-Pandora-Game/pandora/blob/master/pandora-common/src/chat/muffling.ts)
- Hearing impairment effects in [pandora-common/src/assets/effects.ts](https://github.com/Project-Pandora-Game/pandora/blob/master/pandora-common/src/chat/hearingImpairment.ts)

## Modules

Modules are what makes items dynamic and changeable by users - they allow changing how the item looks or even works based on conditions or states the user can change.

Each asset can have as many modules as wanted, each identified by unique `id`. The effects from the modules are combined, but the order of modules is not important (except for the order of how they are displayed in the wardrobe UI).

There are several types of modules currently supported:

### "Typed" module

This is the most common module type.
It has a simple purpose: It allows the user to select one of the presented "variants".

Exactly one variant of each typed module is active at a time.
While a variant is active, any properties defined on it (attributes, effects, pose limits) are applied on the asset, same as if you would define them for the asset directly.
On the other hand, non-selected variants have no effect on the item\*.

[*] Note: Non-selected variant attributes contribute to item filters and affect item permissions, if a user limits items based on attributes.

### "Storage" module

A storage module allows storing different items inside it.
The stored items do not have any effect\* on either the item storing them, or on the character.

Storage modules have two main settings:
- `maxCount` sets the maximum number of items that can be stored inside.
- `maxAcceptedSize` sets the maximum "item size" that fits inside. Note, that this must be strictly _lower_ than the size of the item that has this module. This is also done to prevent infinite nesting of items (no matryoshka dolls, thank you).

[*] Note: Items stored inside storage modules are still considered by permissions. Some interactions with an item (e.g. moving it or deleting it) require being allowed to also do the same with all items stored inside.

### "Lock Slot" module

Lock slot allows a single `lock` type item to be inserted inside and possibly locked.

It also allows applying additional effects when the lock is locked (or not present/unlocked).
The most common effect is `blockAddRemove: true`, which prevents the item from being removed (or added) if it is locked.
The second most common effect is to use `blockModules: ['...']` to lock specific other modules while the lock is locked.

### "Text" module

Text module allows the user to input arbitrary custom text, along with additional metadata such as alignment or font, allowing it to be displayed on the asset's graphics.

This module is meant to be paired with the [Text layer](#text-layer) for worn items or with [Room device: Text layer](#room-device-text-layer) for room devices.

# Item

An item is a configured creation spawned from an asset to be used inside Pandora,
e.g. worn on a character or located in an inventory or on the room floor. 

# Asset graphics

In Pandora asset "logic" and "graphics" are strictly separated, for several reasons.

Logic is the main definition of an asset (present in `.asset.ts` file) and "asset graphics" must follow the logic definition, explaining to Pandora's client how to display items of said asset.

The following terms are specific to asset graphics.

## Layer

Pandora combines multiple assets by layering their layers in a specific order. Asset graphics can contain any number of layers.

Each layer defines its image file, points, layer priority (order of images being behind or on top of other images) and a few other settings independently of other layers.

There are several types of layers, different for worn items and for room devices:

### Automatic image layer (automesh)

The most common layer type for worn items.

This layer allows selecting a point template, variables and images to show a specific `.png` image on the character, transforming it as the character's pose changes.

The image selection works by defining "variables" the layer depends on (e.g. aspects of a pose, or state of a module).
The layer then asks for an image for each variable combination.
This is especially useful for when asset definition changes, as it produces a warning when a new combination needs attention.

### Text layer

A layer that is meant to be combined with the ["Text" module](#text-module) for worn items.

It displays text that a user enters into the text module.

### Image layer

An old layer type from the very beginnings of Project Pandora, used for worn items.
This layer type describes details to Pandora's rendering engine, allowing for fine-tuning of how things are displayed.

> [!NOTE]
> It is not recommended to use this layer when creating new assets, as it has much fewer protections against mistakes and doesn't handle changes to assets well, compared to the Automatic image layer.

### Alpha image layer

This layer is very similar to "Image layer", except that images used by it are not rendered, but instead act as an "alpha mask" for lower layers of the same priority.

> [!NOTE]
> It is not recommended to use this layer.
>
> Alpha masks in their current implementation have heavy performance hit and we are planning a rework of how alpha masks work.

### Room device: Simple image layer

This layer displays an image in the room. It allows defining "image overrides" based on various conditions, but otherwise doesn't do anything fancy.

### Room device: Character slot layer

This layer acts as a proxy for positioning a character.
It is used for displaying character in a room device slot and allows for layering the room device images both above and below the character.

> [!TIP]
> You can also use standard worn item layers with room devices.
> By defining these for a specific slot, you can achieve image layering even within a character (e.g. above body, but below arms), same as worn items can.

### Room device: Text layer

A layer that is meant to be combined with the ["Text" module](#text-module) for room devices.

It displays text that user enters into the text module.

### Room device: Custom mesh layer

> [!NOTE]
> It is not recommended to use this layer.
>
> Custom mesh layer is an experimental, unfinished feature, that will have backwards-incompatible changes in the near future.

## Layer Priority

Sometimes also called "Priority layer" or simply "priority".

Layer priority defines in what order layers from different items should be drawn on the character. This ordering can also change with the character's pose (e.g. arms can move in front or behind the body).

## Point templates

Point templates define how asset graphics are deformed when a character's pose changes.
This is done, as Pandora allows too many poses for it to be possible to draw each of them manually (unless you are creating an asset that severely limits those, e.g. a Yoke).

There are many point templates defined in Pandora's asset repository.
You can see the full list in [pandora-assets/src/templates/](https://github.com/Project-Pandora-Game/pandora-assets/blob/master/src/templates)

> [!IMPORTANT]
> Existing point templates should **never** be changed while creating an asset.
> Changing a point template is likely to break all existing assets that use it.
> It is also generally not recommended to create a new, custom point template, as their creation is complex and makes maintaining assets harder for us as Pandora's internals change.

The most notable point templates are:
- `static` - Displays the image without any change. Useful for layers that are either not affected by posing (e.g. hair, head items, or decorative bow), or when your item forces a single pose (e.g. a Yoke).
- `body` - The most common point template. Any item that is shaped like a body and follows the body as it moves.
- `body_soles_back` - For anything that should be displayed under soles, while kneeling, in the back view.
- `handheld` - For item that is held in hand, but that doesn't change with pose (other than following the hand).
- `skirt_short`, `skirt_long`, `skirt_tight` - For various types of skirts. We recommend testing each of these to see which works best for your asset.

Other point templates have specific usecases for specific kinds of assets. If you have any questions about point templates, feel free to ask on our Discord!

Point templates are made out of "Points".

## Mesh

Layers based on Point Templates are commonly referred to as "Meshes".

## Bone

Bones have two functions:
- They specify the value of a specific pose used for point transformations (e.g. how much a character's hand is raised; or how thick arms are)
- They are (optionally) a point around which any point template point can rotate

Bones are the same for all assets and therefore cannot be modified, as doing so would most likely break every single asset using it.

## Point template "Point"

**Advanced topic; point changes are not needed for general asset creation**

Points define how graphics change with a character's pose change.

They automatically link together with nearby points to form many small triangles.
These triangle areas of an image are then skewed, rotated, moved or scaled based on how the points move, deforming the original image in the process, which
leads to pose changes transforming the character and all equipped items.

Each point has one or more definitions of how it should move. - "Transformations"

_Note 1: Point transformations can be quite hard to write. We are also working on reworking how transformations happen internally, to make them more performant and compatible with existing tools and programs outside Pandora._

_Note 2: More points (and therefore triangles) will lead to a higher quality of the image deformation. This is the reason why the base body asset was defined with many points, especially in areas that move a lot (like elbows)._

