# Pandora asset creation tutorial

Follow these steps to make all your Pandora item dreams a reality:

# Terminology:

## Asset
An asset is a code blueprint on how an item can be created and configured from it. It consists of two parts:
- the logic of the asset - like default colors, modules, asset attributes, effects, etc. - created using code
- the graphics of the asset - images and `graphics.json` file created using Pandora's asset editor, defining how the asset is displayed

### Attribute

Assets can have many "attributes". They are generic things like "Body", "Hair", "Collar", "Collar with front ring", ...

Asset attributes allow for two main things:
- Assets can require or forbid other assets below them (like leash can require collar with front ring in order to be equipable)
- Assets can hide other assets below them (a hood can use attributes to fully hide any hair) - this is possible using alpha masks too, but attributes are more efficient, and therefore preferred, way

You can find a detailed list of attributes at the top of the [pandora-assets/src/attributes.ts](https://github.com/Project-Pandora-Game/pandora-assets/blob/master/src/attributes.ts) file.

### Effect

Equipped items can apply some effects to the character wearing it. Some example are: Blindfold applying blindness, gags limiting speech, some restraints preventing usage of arms, ...

You can find a detailed list of effects at the top of the [pandora-common/src/assets/effects.ts](https://github.com/Project-Pandora-Game/pandora/blob/master/pandora-common/src/assets/effects.ts) file.

### Module

Modules are what makes items dynamic and changeable by users - they allow changing how the item looks or even works based on conditions or states the user can change.

_Note: Modules are being actively developed and improved, currently evolving too quickly to write a full tutorial on what they are currently capable of doing and will be getting even more powerful the more work is done on them. Meanwhile, please write on Discord if you want to give your assets more variants or options or have questions on module usage._

## Item
An item is a configured creation spawned from an asset to be used inside Pandora,
e.g. worn on a character or located in an inventory or on the room floor. 

## Point
**Advanced topic; point changes are not needed for general asset creation**

Points define how graphics change with a character's pose change.

They automatically link together with nearby points to form many small triangles.
These triangle areas of an image are then skewed, rotated, moved or scaled based on how the points move, deforming the original image in the process, which
leads to pose changes transforming the character and all equipped items.

Each point has one or more definitions of how it should move. - "Transformations"

_Note 1: Point transformations can be quite hard to write. For typical assets, it should be sufficient to only use already existing "point templates"._

_Note 2: More points (and therefore triangles) will lead to a higher quality of the image deformation. This is the reason why the base body asset was defined with many points, especially in areas that move a lot (like elbows)._

## Bone
Bones have two functions:
- They specify the value of a specific pose used for point transformations (e.g. how much a character's hand is raised; or how thick arms are)
- They are (optionally) a point around which any other point can rotate

Bones are the same for all assets and therefore cannot be modified, as doing so would most likely break every single asset using it.

## Layer

Pandora combines multiple assets by layering their layers in a specific order. An asset can contain any number of layers.

Each layer defines its image file, points, draw priority (order of images being behind or on top of other images) and a few other settings independently of other layers. 

# Development tools installation

While the graphics part of the asset creation process does not require any tools except Pandora's graphics editor, currently there are limitations as Pandora is early in development, making creation of assets slightly harder. We expect the asset creation to become easier as more development will be done and more features become stable, not changing as frequently.

Feel free to ask on [our Discord](https://discord.gg/EnaPvuQf8d) for help with this process. It is even possible to find someone to help you with the code parts while creating only graphics yourself. This tutorial will assume you will be doing both parts of the asset.

For creating your asset (from nothing to PR) you will need the following tools:
- [Visual Studio Code](https://code.visualstudio.com/download) - The editor used to write logic in.
	- *Note: While not strictly necessary, this tutorial expects you to use VSCode. If you are experienced with JavaScript development you can skip it and look at the manual instruction at the end of this section.*
- [Git](https://git-scm.com/downloads) - For both cloning the needed repositories and contributing your asset
- [Node.js (version 18.x - LTS)](https://nodejs.org/en/download/) - Runtime for running JavaScript code outside of a browser - necessary for all the tools
  - Alternative: If you known what you are doing and what the benefits and drawbacks are, you can install `pnpm` yourself, without the use of corepack.

## Initial setup

The following steps have to be done only once to setup your development and test environment.

### Install Visual Studio Code

- Download it here: https://code.visualstudio.com/download
- Run the downloaded installer
- Click "Next >" all the way

### Install Git

- Download it here: https://git-scm.com/downloads (for Windows use "64-bit Git for Windows Setup.")
- Run the downloaded installer
- "Information" -> Next
- "Select Destination Location" -> Next
- "Select Components" -> [recommended] Enable "Check daily for Git for Windows updates" (it may somtimes show you a prompt where you click Yes to update) -> Next
- "Select Start Menu Folder" -> Next
- "Choosing the default editor used by Git" -> Select "Use Visual Studio Code" -> Next
- "Adjusting name of initial branch ..." -> Next
- "Adjusting your PATH environment" -> [important] **keep recommended option** -> Next
- "Choosing SSH executable" -> Next
- "Choosing HTTPS transport backend" -> Next
- "Configuring the line ending coversions" -> [important] **Change to** "Checkout as-is, commit as-is" (otherwise you will get a lot of warnings) -> Next
- "Configuring the terminal ..." -> Next
- "Choose the default behaviour of `git pull`" -> [recommended] Select "Rebase" (makes it easier to work on a single branch cooperatively) -> Next
- "Choose credential helper" -> Next
- "Extra configuration options" -> Next
- "Experimental options" -> Next
- Install

### Install Node.js and enable corepack

- Download it here: https://nodejs.org/en/download/ (for Windows use ".msi" installer)
- Run the downloaded installer
- Click "Next >" all the way, keeping the defaults

- After installing it, open the Windows PowerShell **as administrator**. (search for "powershell", right-click, "Run as administrator")
  - Yes, if you are on Windows you **must** do this in PowerShell, doing it in cmd won't work
  - If you are not on Windows, skip the next step, but
- Allow running of scripts
```
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
```
- Use the following command to verify Node.js was installed correctly: (expected output: `v18.x.x`)
```
node --version
```
- Enable corepack (this makes `pnpm` available)
```
corepack enable
```
- Verify pnpm is available (expected output: The version of pnpm as `7.x.x`)
```
pnpm --version
```
- You can now close the administrator command prompt

### Cloning the asset repository and initial setup

- Open Visual Studio Code (restart it if you had it open)
- On the left panel select third icon (Source Control)
- If you see "Install Git, a popular ...", close VSCode and open it again
- Copy the following link:
```
https://github.com/Project-Pandora-Game/pandora-assets.git
```
- Press clone repository, paste it and press enter. Select any **empty** directory where you want to store your Pandora projects
- You will get a prompt to login to GitHub, do so
- Wait for it to finish and select "Open"
- On the bottom right you will get a prompt, select "Install"
- You might get asked to confirm trust, select "Trust" or "Trust & Install" or "Trust & Enable"
- On the bottom, a terminal should open, performing the remaining setup automatically. Wait for it to finish (it will close automatically when done)

## Running the local asset server

After finishing all previous steps, you can always open `pandora-assets` in VSCode and start the local asset server by pressing "F5"

If everything worked, you should see that it builds assets, ending with the following two lines:
```
[Main] Done!
[Watch] Waiting for changes...
```

You can stop the server by either closing the window or pressing the red "Disconnect" button on a pane that showed up

The server will always be up to date with all changes you do, **except when you CREATE a new `.ts` file or DELETE an existing `.ts` file** - due to a bug (not our bug) you will need to stop the dev server and start it again.

It will also check for any errors and report them to you.

Later, there will also be support for directly uploading your asset for testing to the testing server. However, this functionality is not yet ready.

## Running without VSCode (__skip if you used VSCode__)

One-time setup:
- Make sure Git, NodeJS v18 and pnpm are in path
- Clone either recursively or after cloning run:
```
git submodule update --init --recursive
```
- Open terminal in `pandora-assets` folder and run:
```
pnpm i
```

Running dev server:
- Run:
```
pnpm dev
```

# Understanding the code behind assets

All assets are in `src/assets/` of the pandora-assets repository.\
For instance in `src/assets/bottoms/jeans_shorts/`, you can find the `jeans_shorts.asset.ts` file with the asset's code.

_Note: The name of the `.asset.ts` file **must** match the name of the folder it is inside._

The file typically has the following parts:
- name
- the according graphics definition file in the same folder
- information about default colors
- ownership information about the images the asset uses

In the case of restraints, it may also define actionMessages and effects in this file (e.g. `cloth_blindfold.asset.ts`)

Just for information: Asset definitions may also describe attributes (e.g. that a collar is a collar), requirements (e.g. that this asset requires a collar on the body to be used), and modules (more on that later).

# Pandora's asset editor and graphics

Next, we recommend to look into graphical part of the asset creation inside Pandora's custom asset editor.
The asset editor is a graphical tool to integrate asset images with the pose system Pandora has.

This is done by creating "Asset layers", assigning them images, point templates and a few more other settings that can be changed to make your asset work well. All of these things can be aligned and set up in the editor and then exported for inclusion into the asset code (via the `graphics.json` file that can be exported from the editor).

You can find the latest stable version of the editor here: [https://project-pandora.com/editor](https://project-pandora.com/editor)

## Getting familiar with the asset editor

First, you will be greeted by three buttons:
- First one ('Load Assets From File System') uses your browser's file system access API (if available) to let you load ~~and save~~ from your hard disk directly. (Note that this method was superseded by the second one as it has far fewer drawbacks.)
- Second one ('Load Assets From Local Development Server') loads the definitions from your local asset server, but saving changes downloads a zip file, which you will need to extract and place its contents into the correct spot manually. **This is the preferred method**
- Third one ('Load Assets From Official Link') loads assets from the stable version, not requiring you to run your own asset server, but also not allowing the creation of new asset fully.

For the sake of this tutorial, we will assume you will pick the second button.

The asset editor screen itself consists of three tabs in the default configuration. From left to right:
- the items tab - used for equipping and editing assets (editing an asset changes the tab to the layer management tab)
- the layer tab - which is currently empty as you there is no layer selected in the layer management tab
- a view of the character model after transformations by changing poses (in the poses tab) - used for checking how the character would look in-game

Navigation is done via the top bar in each tab, where you can create a new tab, close one or change the contents the tab shall show to customize the editor to your preferred work flow. You can switch what any tab shows at any time without losing the progress in those tabs. **Please make extensive use of the (?) buttons that give you contextual help about most elements.**

In the following sections, all available commons tabs will be explained briefly.

### The "Items" tab

The "Items" tab provides an overview of the body and all items/assets available, edited, or visible on the body.

In the following, some assets will be highlighted that are worth looking at to get familiar with how assets are defined and what options an asset creator has.

Let's start with a very simple one:
Expand the category `headwear` (with the "[+]" area) and find the `headwear/lace_headband` asset. First, press the "+" button to add it. That way, you will see your changes (you should see the item appear on your character and in the middle section of the items-tab). Afterwards, press the "pen"-button to start editing it. This will switch the current tab from items-tab to the asset-tab automatically.

### The Asset-tab

The Asset-tab lets you edit, export, and import a single asset as well as manage its layers and the images used by the asset.

You can see that the lace_headband asset consists of only one layer with the name "band" and one image `maid_headband1.png`.

NOTE: Asset images for a character are in the size 1000 x 1500 pixels, as the editor will then overlap 
them perfectly to the layers of other assets as well as onto the body.

Select the layer "band" so that it is highlighted and this action should now fill the layer-tab, to the right of the current tab, with content.

### The Layer-tab

Several properties can be edited on this tab, such as:
- changing the layer name (for your convenience to identify this layer easier in the asset-tab)
- tinting the layer's image in a specific color
- selecting the priority of this layer, so that it is ordered correctly into the numerous body layers
- selecting the point template for this layer, so the engine knows how to (or not to) transform this layer when the character changes poses
- assigning one of the added image files from the Asset-tab to this layer
- setting conditions when the default layer image shall be overwritten with other images

You can see that the asset has the layer priority type 'Above body'. The names of all available layers should be quite self-explanatory.

The point template used is "static", which means that the asset will not scale with body changes/movements in any way.

Under "layer image asset", the uploaded layer image `maid_headband1.png` was selected to be shown for this layer.

All other setting were left empty and are of no importance right now.

This is as simple as an asset can be. Let's look at another important tab.

### The "Poses" tab

The "Poses"-tab enables you to manipulate the pose of the editor character from the preview-tab. 

### The "Wardrobe" tab

The "Wardrobe"-tab acts like the in-game wardrobe and lets you for instance use asset modules or quickly add random clothes onto your character for testing. 

# Looking at more advanced assets

In the following section, let's have a look at increasingly more complex assets that are good examples of what assets can (currently already) do and how.

## Jeans shorts: Multiple layers and alpha masks

Expand the category `bottoms` (with the "[+]" area) and find the `bottoms/jeans_shorts` asset. Now first press the "+" button to add it - so you will
see your changes (you should see it appear in "Equipped" section) - and then the "pen"-button to start editing it.

In the asset-tab you can see that this asset has three layers:
- one for the front view of the jeans shorts
- one for the back view of the jeans
- one for the button of the jeans to be able to color it separately

The white square behind the first two layer names indicates that these two layers use alpha masks. Alpha masks are separate image files that
make this asset, which has the alpha masks added, hide certain parts of the images of another asset on the same layer priority ordered below
that asset.
In this concrete example, the jeans shorts are on the layer priority type 'Above body', same as most clothes, like for instance the t-shirt asset.
If you wear your jeans shorts above the t-shirt in the wardrobe (or on the items-tab of the editor), the alpha mask would hide the t-shirt parts
that would be tugged into the shorts. Without the alpha mask, the t-shirt would clip along the edges behind the jeans shorts. You can try it out
in the editor as all changes are not persistent, so you will not break anything by playing around.

The image asset management part on the bottrom of the asset-tab lists 4 image files for the jeans shorts:
- one for the front view of the jeans shorts
- one for the back view of the jeans
- one for the button of the jeans
- one which is the image file for the alpha mask (as mentioned before)

Note: If you use an image as alpha mask, the solid black parts of the image will hide what it covers, whereas transparent or white parts will not hide anything.

Next, select the first layer 'jeans back' and look into the layer-tab.

As this layer represents the back view of the asset (the jeans from behind), the layer priority type is 'Below body', which means that it is ordered
behind the body. The point template selected here is the most common one: Body. The body template makes sure that asset images will be transformed
alongside body changes (e.g. weight sliders or arm movements). As mentioned, selecting the right template is important for making an asset work.

The selected image for this layer is of course `Jeans_Shorts_Back.png` and further below on the tab, the special alpha mask image file was selected.

The layer for the front view is pretty similar, aside from the layer priority type 'Above body' and the different asset image used.
The image for the alpha mask is exactly the same as for the back view. It is not always the case, that you can use the same alpha mask for 
front and back view. Sometimes you may need different images for front and back view alpha masks (e.g. for the high heels asset).

The button layer is again similar to the other front view laxer, but it uses the 'static' point template as the button does not need to
transform/move/scale with the body in any way.

IMPORTANT NOTE: The order of the layers on the asset-tab matters! Only the correct order will get the desired visual results. Feel free to change
the order of the layers of the jeans shorts to get a feeling for it. Changes to any assets are reset when you reload the editor.

## T-Shirt: Overrides and splits

Here is another asset example that is important to understand if you want to do any asset that covers breasts or has sleeves.

Expand the category `tops` (with the "[+]" area) and find the `tops/t-shirt1` asset. Now first press the "+" button to add it - so you will
see your changes (you should see it appear in "Equipped" section) - and then the "pen"-button to start editing it.

In the asset-tab you can see that this asset has three layers:
- 'base' for the front view of the torso
- 'arms' for the front view of the sleeves
- 'back' for the back view of the torso
- 'back_arms' for the back view of the sleeves
- 'print' for showing an optional print on the front view via the according module that this asset has defined in the `t-shirt1.asset.ts` file.

Let's start with the 'print' layer. The new part here is the text field under 'Image overrides'. The ?-button explains what it is about.
In the example of the t-shirt, there are two lines:
```
m_prints=crown t-shirt_print_crown.png
m_prints=noPrint
```
The first line means that the default print of the t-shirt, the kissing smilie is replaced by the crown print image, when the module with
the name `prints` (defined in the `t-shirt1.asset.ts` file) is set by the user to the state `crown`.
The second line means that when the state `noPrint` is set, this layer will show no image, making the asset a t-shirt without print.

Hint: For more examples of how image overrides are used, the following assets may be interesting: `footwear/high_heels`
or the `bras/style1` bra, which does not show for flat breasts due to bone-based image overrides.

Now back to the layers 'base' and 'arms': If you look at these two layers, you can see that they use the same image file, which is a
t-shirt with sleeves, but they use a different priority layer and point filters. This is called a split, that is needed so the
sleeves of the t-shirt show correctly in the various possible arm-related poses. The torso part of the body is of course on the 'Body' priority
layer and uses the 'body' points and the 'bodyarms' points, whereas the arms layer uses the 'Above Arms' priority layer and filters only
points of the 'arms' and the few 'bodyarms' points which are used by both the body and the arms for a seemless connection of the image sections.

In addition, both layers use the feature 'Select image based on value of a bone' (see ?-Button for more details).
This is used here to override the image of the t-shirt with the flat variant (also used by the back view layers), for just the breast bone
stop point 'small', which means that this override is used also for the breast stop point 'flat'.

Hint: For a more complex example on this topic, have a look at the `dresses/maid_dress` asset. It for instance shows that your overrides can use more
complex conditions which chain statements with an `&` (and) or `|` (or), like so:
```
m_skirtState=up&backView=0 maid_f_skirt_up_l2.png
```
You can also combine this with bone values to make overrides pose dependant, e.g.
```
m_cuffState=normal&leg_r>=0 cuffs_closed.png
```

# Creating your first asset

When you want to make a new asset, there is is an according button on the items-tab. Pressing it opens a dialogue.

Choose a fitting category for your asset. Body for instance is the category for parts of the body, such as eyes or hair.

You also need to give it an identifier that should be similar to the name, but [lowercase and with "_" instead of space characters](https://en.wikipedia.org/wiki/Snake_case), e.g.
`jeans_shorts`. The name would in this example of course be 'Jeans Shorts'.

Only in case the asset will be a body part (e.g. eyes or hair), you need to select something in the according drop-down dialogue.

After proceeding, you will the be prompted to download a `*.zip` file with your asset so that you can save its contents in the pandora-asset repository for
committing it when it is ready. This file consists of a minimal `*.asset.ts` file for you to build upon and a placeholder version of the `graphics.json`.

The tab view will immediately switch to the asset-tab with your new item loaded, automatically equipping it on the editor character, too.

Please be aware that your asset is not saved in the editor, as the editor resets when it reloads or refreshes. Please make sure to
export the asset you are making regularly and overwrite the `graphics.json` of the new asset with the one from the exported package, ~~unless you started the editor in the 'Load Assets From File System' mode~~ [Work In Progress - doesn't autosave yet].

Hint: An alternative way to make your asset, and the potentially easier way when you are new to the process, is to edit an existing asset in the editor that is very similar to what you want to make. Basically, you look for an asset under the "Items"-tab that has a similar amount of layers and images and potentially similar modules and start editing it. In the most ideal case you just have to replace the images and export the graphics.json for usage in your new asset. More realistically, you may need to do more changes, but it may still be the fastest way to make your new asset, especially as you get more experience. 

## Making the asset images

For now, when making images for your own assets, please make sure they are all in the size 1000 x 1500 pixels, as the editor will then overlap 
them perfectly to other layers as well as onto the body. Also remember to make a front view and a back view of your asset, if that is needed.

If your asset is for a female body and covers the breasts, you likely need to make several sized variants for the front view layer that covers the breasts. For this purpose, you can download a [set of body templates for different breast sizes on GitHub](https://github.com/Project-Pandora-Game/Documentation/tree/master/asset_creation/templates/). Note the `readme.txt` in the body-sub-folder. 
Alternatively, you can simply download the character preview with the chosen pose in the editor as image to draw over yourself. There is a black download button above the character view in the editor for that. Please keep the body slider values at default level before drawing over such an image or your asset images will not fit in-game.

To dive a bit more into the topic of how amny images you likely need:

- 1 image for things like a hair flower, which needs no dedicated back view as the item is only on the front side of the body (`ABOVE_BODY` layer) and is half visible from behind.
- 2 images for something like a hat or skirt that is covering both the front and back side of the head (`ABOVE_BODY` as well as `BELOW_BODY` layer). If the asset looks exactly the same from both sides, then you could even use the same image for both asset layers and only need to make one image.
- 6 images for something like a bra: one image for the back side of the body (`BELOW_BODY` layer) and 5 images for the breast sizes small, medium, large, huge, and extreme, covering the bust above and below  (`BREASTS` [Note: If you are making something like a corset or tight top that is covering more parts of the body than only the breasts, use the `ABOVE_BODY` layer instead of the `BREASTS` one.] and the same five images reused again on the `BELOW_BREASTS` layer to cover them from the back view, too)

Hint: It is likely extremely helpful to go look up existing (similar) assets to the one you want to make. You can simply load it in the editor and start editing it so you can see how it was done. In many cases you just need to do some small changes, like exchanging image files and renaming things, but can otherwise completely reuse the existing definitions and code. Even advanced features outside the asset editor, like modules, can mostly be copied and reused from the code of existing examples with only minor changes. 

# Advanced topics

The following topics are needed extremely rarely and even in the case that what is currently offered isn't enough for the asset you want to create, it is best to ask on Discord first, as synchronizing with others might allow other assets to reuse work needed for what your asset needs - thus making creation of similar assets easier in the future.

## ADVANCED: The Points-tab

The Points-tab lets you manage the points for all layers.

There are three options to get points for the currently selected layer of your asset:
- you can select a premade point template that fits to your asset
- you can mirror all points from another layer of the same asset to be used also for the currently selected layer (preferred)
- in rare cases, especially for exotic or complex assets, you can define your own points.

NOTE: Defining your own points is a fairly advanced topic and needs some practice. For the sake of this tutorial, this will only 
be briefly touched at the end of this section and we recommend to get someone to help you with this option if you are new to defining points.

Typically, it is enough to use points from a suitable template to the first layer and then mirror this layer to all other layers.
If you select another layer to mirror points from, it will show which layer the current layer mirrors at the top of the tab, as well as 
an unlink button. 

// TODO - REWRITE: If you selected a template, nothing is shown, as There is one exception to this, though: If you mirror points from a 
'Template' it will just copy the points without creating a link which you can unlink again.

NOTE: Between selecting points from a template and mirroring points from another layer that uses the same points (e.g. from the same 
template), you should choose mirroring the points of another layer, as it keeps the graphics definitions file much smaller, compared 
to copying all the points from the template into the currently selected layer.

## ADVANCED: Defining new points in the points-tab

Reminder: The left body is the one where you modify points, the right body only shows the points after they have been transformed by
changes in one or more bones. Therefore, the points on the right body are slightly transparent to indicate non interactivity.

Now some advanced notes on how points work and how to create and interact with them:

The individual points can either be dragged around on the body model (zoom in on them) or positioned more precisely via the values of the 
point's X and Y coordinates.
The color of a point is also important. Potentially, you need to zoom in to see them better.
- White is a normal point you can drag around and edit
- Yellow is a white point you have currently selected for editing
- Green is a point that has been mirrored along the body axis from a white point on the other side of the body via the toggle 
'Mirror point to the opposing character half'
- Light green is a green point you have currently selected

You can also edit the point type this point is a part of. Every point needs ot be of exactly one point type. These point types 
are referenced for each layer on the Layer-tab.

In the text field you can add all transformations a point should perform when the according point is affected one or more of the listed bones.
Available transformations are for instance point shifts or rotations around the specified bone.

INFO: Some examples of point transformations that could be writting into the according text field and what they mean:
```
// Slides the point up to 6 units along the positive x-axis when the bone 'Leg Width' is changed towards +180 degrees and up to 6 units along 
the negative x-axis when the bone is moved towards -180 degrees. No changes on the y-axis.
shift leg_width 6 0

// Slides the point up to 16 units along the negative x-axis when the bone 'Hips' is changed towards -180 degrees, but does not move  
along the positive x-axis, as there is a condition added at the end. 'hips<0' means that the point is only shifted while the bone is set to 
a negative value. No changes on the y-axis.
shift hips 16 0 hips<0

// Another shift applied on changes to the same bone as above. There is no limit to the number of transformations per point and per bone.
shift hips 2 0

// Slides the point up to 40 units along the negative y-axis when the bone 'Sitting' is changed towards +180 degrees and up to 40 units along 
the positive y-axis when the bone is moved towards -180 degrees. No changes on the x-axis.
shift sitting 0 -40

// Rotates the point around the bone 'Leg Right' with factor 0.7 (slower) compared to the original angle of the bone slider (-180 to +180 degrees).
rotate leg_r 0.7
```

