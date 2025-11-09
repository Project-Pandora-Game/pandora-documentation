# Pandora asset creation tutorial

Follow these steps to make all your Pandora item dreams a reality:

# Terminology:

You do not need to study the following terms in detail, but know that they are explained here. These terms will be used throughout this tutorial.

## Asset
An asset is a code blueprint on how an item can be created and configured from it. It consists of two parts:
- the logic of the asset - like default colors, modules, asset attributes, effects, etc. - created using simple, defined code
- the graphics of the asset - images and `graphics.json` file created using Pandora's asset editor, defining how the asset is displayed

### Attribute

Assets can have many "attributes". They are generic things like "Body", "Hair", "Collar", "Collar with front ring", ...

Asset attributes allow for two main things:
- Assets can require or forbid other assets below them (like a leash can require a collar with a front ring in order to equip it on a character)
- Assets can hide other assets below them (a hood can use attributes to fully hide any hair) - this is possible using alpha masks too, but attributes are more efficient, and therefore preferred

You can find a detailed list of attributes at the top of the [pandora-assets/src/attributes.ts](https://github.com/Project-Pandora-Game/pandora-assets/blob/master/src/attributes.ts) file.

### Effect

Equipped items can apply some effects to the character wearing it. Some example are: Blindfold applying blindness, gags limiting speech, some restraints preventing usage of arms, etc.

You can find a detailed list of effects at the top of the [pandora-common/src/assets/effects.ts](https://github.com/Project-Pandora-Game/pandora/blob/master/pandora-common/src/assets/effects.ts) file.

### Module

Modules are what makes items dynamic and changeable by users - they allow changing how the item looks or even works based on conditions or states the user can change.

_Note: Modules are being actively developed and improved, currently evolving too quickly to write a full tutorial on what they are currently capable of doing. They will surely get even more powerful over time. Meanwhile, please write on Discord if you want to give your assets more variants or options or have questions on module usage._

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

## Mesh

All point-based triangles in an area together are called a mesh.

## Bone
Bones have two functions:
- They specify the value of a specific pose used for point transformations (e.g. how much a character's hand is raised; or how thick arms are)
- They are (optionally) a point around which any other point can rotate

Bones are the same for all assets and therefore cannot be modified, as doing so would most likely break every single asset using it.

## Layer

Pandora combines multiple assets by layering their layers in a specific order. An asset can contain any number of layers.

Each layer defines its image file, points, draw priority (order of images being behind or on top of other images) and a few other settings independently of other layers. 

# Deciding how you want to go about asset creation

This step might be the most important one:

Do you feel comfortable enough to set up a local development environment of Pandora on your computer, so you can create assets end-to-end and commit them yourselves?
If so, the next chapter contains detailed instructions on how to do that. This is the most common and recommended approach.
Note that the coding part of an asset is relatively simple and you do not need to be a programmer or experienced coder to create it. Just look at the examples of other assets and ask for help when you have trouble understanding a part of the single asset code file you need to define per asset.

The other option is to only use the online hosted version of Pandora's asset creation editor, hosted under: [https://project-pandora.com/editor](https://project-pandora.com/editor)
This allows you to do the graphics part of your asset and test it to some degree in the editor, while you team up with someone else to do the asset code. You can also ask us for help with that. There is no installation of any tools on your computer needed for this option - aside from the image editing tools of your choice.
Note, though, that this approach will limit you if you want to create a more complex asset that changes the used images for instance based on module states (e.g. stockings that have an option to show them also half pulled down). The reason is that asset modules need to first be defined in the asset code, before you can use the module states as a condition in the asset editor to display the different image variants. In such a case, your collaboration partner would need to also do the graphics definition fully or at least partially using your images.
If you decide to go that route, you can ignore the next chapter and continue directly with the section "Pandora's asset editor and graphics" further down.

# Development tools installation

_Note: If, besides asset creation, you also want to work on Pandora feature development itself, or want to test your assets (e.g. complex room devices with several character slots) with several characters at once in a locally running full instance of Pandora, skip the the following installation instructions, and instead follow the similar but extended steps described here:_ https://github.com/Project-Pandora-Game/pandora-documentation/blob/master/Getting_started.md
_Also skip these steps if you already have installed a full local development environment according to the instructions linked above._

While the graphics part of the asset creation process does not require any tools except Pandora's graphics editor, currently there are still limitations of what you can do with this approach, as for instance the code part of an asset still needs to be defined outside of the editor in code. We expect that asset creation will become even easier and more convenient as further development will be done and more features become stable, not changing as frequently.

Feel free to ask on [our Discord](https://discord.gg/EnaPvuQf8d) for help with this process. It is even possible to find someone to help you with the code parts while only creating the graphics yourself. This tutorial will assume you will be doing both parts of the asset.

For creating your asset (from nothing to PR) you will need the following tools:
- [Visual Studio Code](https://code.visualstudio.com/download) - The editor used to write logic in.
	- *Note: While not strictly necessary, this tutorial expects you to use VSCode. If you are experienced with JavaScript development you can skip it and look at the manual instruction at the end of this section.*
- [Git](https://git-scm.com/downloads) - For both cloning the needed repositories and contributing your asset
- [Node.js (version 20.x - LTS)](https://nodejs.org/) - Runtime for running JavaScript code outside of a browser - necessary for all the tools

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
- "Select Components" -> [recommended] Enable "Check daily for Git for Windows updates" (it may sometimes show you a prompt where you click Yes to update) -> Next
- "Select Start Menu Folder" -> Next
- "Choosing the default editor used by Git" -> Select "Use Visual Studio Code" -> Next
- "Adjusting name of initial branch ..." -> Next
- "Adjusting your PATH environment" -> [important] **keep recommended option** -> Next
- "Choosing SSH executable" -> Next
- "Choosing HTTPS transport backend" -> Next
- "Configuring the line ending conversions" -> [important] **Change to** "Checkout as-is, commit as-is" (otherwise you will get a lot of warnings) -> Next
- "Configuring the terminal ..." -> Next
- "Choose the default behavior of `git pull`" -> [recommended] Select "Rebase" (makes it easier to work on a single branch cooperatively) -> Next
- "Choose credential helper" -> Next
- "Extra configuration options" -> Next
- "Experimental options" -> Next
- Install

### Install Node.js and enable corepack

- Download it here: https://nodejs.org/ (for Windows use ".msi" installer)
- Run the downloaded installer
- Click "Next >" all the way, keeping the defaults

- After installing it, open the Windows PowerShell **as administrator**. (search for "powershell", right-click, "Run as administrator")
  - Yes, if you are on Windows you **must** do this in PowerShell, doing it in cmd won't work
  - If you are not on Windows, skip the next step
- Allow running of scripts
```
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
```
- Use the following command to verify Node.js was installed correctly: (expected output: `v20.x.x`)
```
node --version
```
- Enable corepack (this makes `pnpm` available)
```
corepack enable
```
- Verify pnpm is available (expected output: The version of pnpm as `9.x.x`)
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
- Make sure Git and NodeJS are in path and that you are using corepack
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
For instance in `src/assets/collars/heart_choker/`, you can find the `heart_choker.asset.ts` file with the asset's code.

_Note: The name of the `.asset.ts` file **must** match the name of the folder it is inside._

The file typically has the following parts:
- name
- the according graphics definition file in the same folder
- information about default colors
- ownership information about the images the asset uses

In the case of restraints, it may also define actionMessages and effects in this file (e.g. `cloth_blindfold.asset.ts`)

Just for information: Asset definitions may also describe attributes (e.g. that a collar is a collar), requirements (e.g. that this asset requires a collar on the body to be used), and modules (more on that later).

# Pandora's asset editor and graphics

Next, we recommend to look into the graphical part of the asset creation inside Pandora's custom asset editor.
The asset editor is a graphical tool to integrate asset images with the pose system Pandora has.

This is done by creating "Asset layers", assigning them images, point templates and a few more other settings that can be changed to make your asset work well. All of these things can be aligned and set up in the editor and then exported for inclusion into the asset code (via the `graphics.json` file that can be exported from the editor).

You can find the latest stable version of the editor here: [https://project-pandora.com/editor](https://project-pandora.com/editor)

## Getting familiar with the asset editor

First, you will be greeted by two buttons:
- First one ('Load Assets From Local Development Server') loads the definitions from your local asset server. **This is the preferred method, but requires you to install the development tools, as described further above**
- Second one ('Load Assets From Official Link') loads assets from the stable version, not requiring you to run your own asset server, but also not allowing the creation of new asset fully.
In both cases, you need to manually export changes, either the graphics definition string for replacing the original content of the `graphics.json` file, or by downloads a zip file, which you will need to extract and where you will need to place its contents into the correct spot manually.

For the sake of this tutorial, we will assume you will pick the first button.

The asset editor screen itself consists of three tabs/columns in the default configuration. From left to right:
- the items tab - used for equipping and editing assets (editing an asset changes the tab to the layer management tab)
- the layer tab - which is currently empty as you there is no layer selected in the layer management tab
- a view of the character model after transformations by changing poses (in the poses tab) - used for checking how the character would look in-game

Navigation is done via the top bar in each tab, where you can create a new tab, close one or change the contents the tab shall show to customize the editor to your preferred work flow. You can switch what any tab shows at any time without losing the progress in those tabs. **Please make extensive use of the (?) buttons that give you contextual help about most elements.**

In the following sections, all available tab options will be explained briefly.

### "Items" tab

The "Items" tab provides an overview of the body and all items/assets available, edited, or visible on the body.

In the following, some assets will be highlighted that are worth looking at to get familiar with how assets are defined and what options an asset creator has.

Let's start with a very simple one:
Expand the category `headwear` (with the "[+]" area) and find the `headwear/lace_headband` asset. First, press the "+" button to add it. That way, you will see your changes (you should see the item appear on your character and in the middle section of the items-tab). Afterwards, press the "pen"-button to start editing it. This will switch the current tab from items-tab to the asset-tab automatically.

### "Asset" tab

The "Asset" tab lets you edit, export, and import a single asset as well as manage its layers and the images used by the asset.

You can see that the lace_headband asset consists of only one layer with the name "band" and one image `maid_headband1.png`.

NOTE: Asset images for a character are in the size 1000 x 1500 pixels, as the editor will then overlap 
them perfectly to the layers of other assets as well as onto the body, without requiring manual positioning.

Select the layer "band" so that it is highlighted and this action should now fill the layer-tab, to the right of the current tab, with content.

### "Layer" tab

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

This is as simple as an asset can be. Let's look at other important tabs next.

### "Poses" tab

The "Poses"-tab enables you to manipulate the pose and body sizes of the editor character from the preview-tab. 

### "Wardrobe" tab

The "Wardrobe"-tab acts like the in-game wardrobe and lets you for instance use asset modules or quickly add random clothes onto your character for testing. 

### "Pandora" tab

This tab lets you open a feature-restricted simulation of Pandora within the editor to test your asset creation (changes) and especially room-level assets, for instance room devices with character slots.
It should be self explanatory how to use it.

### "Setup" tab

This tab shows the character before any transformations or poses are applied to the character and any worn assets. An asset creator does not typically need to use this tab and would only use the "Preview" tab instead.

### "Points" tab

This tab is only needed for a very advanced topic described at the end of this tutorial. Most asset creators will never need to use this tab.

# Looking at more advanced assets

In the following section, let's have a look at increasingly more complex assets that are good examples of what assets can (currently already) do and how.

_Note, that you can experiment as much as you like, change existing assets and see how the change is reflected on the character in the preview tab._
_None of your changes are persistent, so you will not break anything by playing around._
_On the other hand, this also means that refreshing or closing your browser will reset any work you do on a new asset creation, so please make sure to not forget exporting an edited asset, if you want to use the changes (more on that later)._

## Jeans shorts: Multiple layers and automesh layers

Expand the category `bottoms` (with the "[+]" area) and find the `bottoms/jeans_shorts` asset. Now first press the "+" button to add it - so you will
see your changes (you should see it appear in the "Equipped" section) - and then the "pen"-button to start editing it.
_Note: You can also directly us the "pen"-button next to the "+"-button to do both steps at once._

In the asset-tab you can see that this asset has three layers:
- one for the front view of the jeans shorts
- one for the back view of the jeans
- one for the button of the jeans to be able to color it separately

The image asset management part at the bottom of the asset-tab lists three image files for the jeans shorts:
- one for the front view of the jeans shorts
- one for the back view of the jeans
- one for the button of the jeans

Note that while in this case, each layer uses exactly one image, this is not always the case as a layer can use and switch between many different images based variables/conditions (more on that later). 

Next, select the first layer 'jeans back' and look into the layer-tab.

The contents of the "layer"-tab may look a bit different than the layer tabs of other assets you may have seen. The reason is that this layer is of the more recently added layer type "automatic image layer" (also nicknamed "automesh" layer). You can easily identify this layer type by the four characteristic tabs near the bottom.
Automesh layers are a kind of meta layer for asset creators to more easily define the layer structure with a lower risk of making mistakes, while Pandora will then automatically translate this definition into one or more "image layers" (the other common layer type used by assets) during deployment, which is the raw definition of the actual layers used by Pandora's engine.

IMPORTANT: Therefore, please always use the "automatic image layer" type when creating the layers of your new asset, whenever possible!

The selected "jeans back" layer represents the back view of the asset (the jeans from behind).
Let's focus on the four tabs of this automesh layer, which are typically worked on in the following order during asset creation:

The first one, "Template, lets you select the point template used for this layer and its variant.
The point template selected for the shorts is the most common one: 'Body'. The body template makes sure that asset images will be transformed
alongside body changes (e.g. weight sliders or arm movements). As mentioned, selecting the right template is important for making an asset work.
The template variant is of layer priority 'Below body', which means that it is ordered behind the body. 
The enabled parts of the template are body and legs, as part of the used image of the jeans shorts already reaches into the point mesh of the legs.

The next tab, "Graphical layers" lets you define if the automesh layer shall generate a single or more graphical layers, so the actual layers used by Pandora.
This is convenient and efficient if different, separately colorable parts of an image shall be directly layered over each other, such as a belt and a belt buckle.
The tab also lets you assign a color group defined in the asset code file of the asset for each graphical layer.
Optionally, you can define a name for each graphical layer, which is useful if you have more than one.
In the example of the jeans shorts, there is only one graphical layer with a default name and the color group "Pants" from the `bottoms/jeans_shorts/jeans_shorts.asset.ts` file.

The third tab, "Variables", lets you select variables based on which different images shall be conditionally used by the graphical layers.
If you press on "Add variable" you can see that there are different kinds of possible variables that image override conditions can be based on. The most commonly used one is "based on typed module", followed by "based on front/back view".
Our current example is a simple asset that uses no variables, so this tab is empty.

The last tab "Images", lets you assign the images uploaded or pre-existing in the "image management" section of the "Asset" tab to each graphical layer, based on the conditions derived from the selected variables from the previous tab.
For the jeans shorts, you have no conditions, so only one image can be selected for the single graphical layer of the automesh layer. The selected image for this layer is of course `Jeans_Shorts_Back.png`.

The layer "jeans front" for the front view is pretty similar, aside from the template variant 'Above body' and the different asset image used.
Try to click this layer and then in the "Template" tab, remove the template part "legs" as a test. You should notice that in the "preview" view, the bottom part of the jeans short image is suddenly cut off a bit on the front facing character, as the reduced number of points altered the applied mesh and therefore cut the image where the torso (body) mesh above the legs ends.
Remembering this can help you to decide which template parts you need to enable on a new asset. No worries, though, the editor will warn you when you use a template part that is not necessary to be enabled, as it would span a mesh over parts where the used image is empty. So for example, if you would enable the "arms" part here, you could see a warning icon in the middle of the "Asset" tab and can click on "View log" to check why. (more on warnings later)

The button layer is again similar to the other front view layer, but it uses the 'static' point template as the button does not need to
transform/move/scale with the body in any way.

IMPORTANT NOTE: The order of the layers on the asset-tab matters! Only the correct order will get the desired visual results. Feel free to change
the order of the layers of the jeans shorts to get a feeling for it. Changes to any assets are reset when you reload the editor.

## T-Shirt: Using variables

Here is another asset example that is important to understand if you want to make any asset that covers breasts or has sleeves.

Expand the category `tops` (with the "[+]" area) and find the `tops/t-shirt1` asset. Now press the "pen+" button to make the character wear it and also start editing it at the same time.

In the asset-tab you can see that this asset has five layers:
- 'base' for the front view of the torso
- 'arms' for the front view of the sleeves
- 'back' for the back view of the torso
- 'back_arms' for the back view of the sleeves
- 'print' for showing an optional print on the front view via the according module that this asset has defined in the `t-shirt1.asset.ts` file.

Let's start with the 'print' layer. The new part here is that the "Variable" tab uses a variable "based on typed module" with the module name `prints` that this asset has defined in the `t-shirt1.asset.ts` file.
This also changed how the "Images" tab looks: There, you can see the possibility to select an image representing one of the t-shirt prints for each state of the `prints`-module.
An outlier is the  state `noPrint`, where this layer will show no image, making the asset a t-shirt without print.

_Note 1: An automesh layer can use more than one variable to define image override conditions for the "Images" tab. You could take a look at the `toys/dildo` asset for a complex example that uses 4 variables, together allowing to pick the layer image based on a combination of material, tip design, insertion depth, and front or back view of the asset. So therefore, if an entry under the "Images" tab in this example has the heading "Rubber | Smooth | Outside | Front", it means the drop-down below selects the image that should be used if the 4 variables have this exact state combination. It is not uncommon that some of the possible combinations require no image and the dropdown selector value should stay '[None]'._

_Note 2: For an example of how image overrides are used in the case of non-automesh layers, so old "image layers", the following asset may be interesting: the `bras/style1` bra, which does not show the asset for flat breasts due to bone-based image overrides._

Now back to the layers 'Front' and 'Back': If you look at these two automesh layers, you can see that they use the same image file, which is a
t-shirt with sleeves, but they each use a different template variant.
The enabled template parts here are "body" and "arms" as the t-shirt image reaches into the mesh over the arms.

Finally, the image layer "bust" shows an example of how the bust part of a clothing item is defined using a special (point) template and only two images!
This same approach can be copied and reused for most clothing assets, e.g. the asian dress (`dresses/asian_dress`).
On Pandora's Discord there is a small how-to that documents how this asset was made: https://discord.com/channels/872284471611760720/872569272780607518/1411953336764338197

# Creating your first asset

When you want to make a new asset, there is an according button on the "items" tab. Pressing it opens a dialogue.

Choose a fitting category for your asset. Body for instance is the category for parts of the body, such as eyes or hair.

You also need to give it an identifier that should be similar to the name, but [lowercase and with "_" instead of space characters](https://en.wikipedia.org/wiki/Snake_case), e.g.
`jeans_shorts`. The name would in this example of course be 'Jeans Shorts'.

Only in case the asset will be a body part (e.g. eyes or hair), you need to select something in the according drop-down dialogue.

After pressing the "Create" button, you will the be prompted to download a `*.zip` file with your asset so that you can save its contents in the pandora-asset repository for
committing it when it is ready. This file consists of a minimal `*.asset.ts` file for you to build upon and a placeholder version of the `graphics.json`.

If you did not set up a local development environment as part of this tutorial, and cannot place these files in the according `src` folder of your locally checked out pandora-assets repository, so you can edit the `*.asset.ts` file in your coding editor (e.g. Visual Studio Code or VSCodium), then you simply hand the files in that ZIP archive over, together with the images you made and the ready `graphics.json`, to the person whom you are collaborating with on the asset for the coding part.

After that, the tab view will immediately switch to the "Asset" tab with your new item loaded, automatically equipping it on the editor character, too.

Please be aware that your asset is not saved in the editor, as the editor resets when it reloads or refreshes. Please make sure to
export the asset definition regularly and overwrite the content of the `graphics.json` of the new asset from the exported package on your local device.
You can do this on the "asset" tab with the button "Export definition to clipboard". Or use "Export archive" to download another ZIP file , which will additionally include the images you added, besides the edited `graphics.json` file.

## Making the asset images

For now, when making images for your own assets, please make sure they are all in the size 1000 x 1500 pixels, as the editor will then overlap 
them perfectly to other layers as well as onto the body. Also remember to make a front view and a back view of your asset, if that is needed.

If your asset is for a female body and covers the breasts, you likely need to make several sized variants for the front view layer that covers the breasts. 
For that, you can simply download the character preview with the chosen pose in the editor as image to draw over yourself. There is a black download button above the character view in the editor for that. Please keep the body slider values at default level before drawing over such an image or your asset images will not fit in-game. Also, you typically want the arms in the default t-pose to draw over them.
On Pandora's Discord there is also a small how-to on the topic of downloading body shape template images for asset creation: https://discord.com/channels/872284471611760720/872569272780607518/1411967926524710963

To dive a bit more into the topic of how many images you will likely need for the asset you want to create:

- 1 image for things like a hair flower, which needs no dedicated back view as the item is only on the front side of the body (`Above body` template variant / layer priority) and is half visible from behind.
- 2 images for something like a hat or skirt that is covering both the front and back side of the head (`Above body` as well as `Below body` template variant / layer priority). If the asset looks exactly the same from both sides, then you could even use the same image for both asset layers and only need to make one image.
- 4 images for something like a bra: one image for the back side of the body (`Below body` template variant / layer priority), one for the base of the front side, and 2 images (or one more for the flat variant) for the breast sizes "small" and "medium", covering the bust above and below (use `Above body` template variant / layer priority and then the same two images reused again on the `Below breasts` template variant / layer priority to cover them from the back view, too, as some breast sizes can be wider than the body and are thus visible from behind)

Hint: It is extremely helpful to go look up existing (similar) assets to the one you want to make. You can simply load it in the editor and start editing it so you can see how it was done. In many cases you just need to do some small changes, like exchanging image files and renaming things, but can otherwise completely reuse the existing definitions and code. Even advanced features outside the asset editor, like modules in `*.asset.ts` files, can mostly be copied and reused from the code of existing examples with only minor changes. 

## Check for warnings in the "Asset" tab

IMPORTANT: While you make changes to the layers of an asset in the editor, the asset is built in real-time in the background. The "Asset" tab contains a section "Graphics build result" that should show a green checkmark icon and "No problems" when you have completed your asset. Please always make sure this is the case before you export the definition for committing it as a pull request on GitHub (or give it to your asset creation partner)!
In case the icon is not green, you can press on "View log" to see which layers have problems and then make changes and see how the issue count changes in real-time.

# Advanced topics

The following topics are needed extremely rarely and even in the case that the currently available tools and templates are not enough for the asset you want to create, it is best to ask on Discord first, as synchronizing with others might allow other assets to reuse work needed for what your asset needs - thus making creation of similar assets easier in the future.

## ADVANCED: The Points-tab

> __OUTDATED__: This section is outdated as of the body rework and is pending rewrite.
> 
> Reason: The body rework included a change that layers can no longer have their own points.
> All points are now managed and assigned through templates and the tab edits templates directly.

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

INFO: Some examples of point transformations that could be written into the according text field and what they mean:
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

