# Pandora asset creation tutorial

> [!TIP]
> Most terms used throughout this tutorial can be found in the [Glossary](Glossary.md).

Follow these steps to make all your Pandora item dreams a reality:

# Deciding how you want to go about asset creation

This step might be the most important one:

Do you feel comfortable enough to set up a local development environment of Pandora on your computer, so you can create assets end-to-end and commit them yourself?
If so, the next chapter links to detailed instructions on how to do that. This is the most common and recommended approach.
Note that the coding part of an asset is relatively simple and you do not need to be a programmer or experienced coder to create it - there is only a bit of a learning curve to understand how other assets define this code and then you can essentially reuse code from existing assets with smaller edits. So just look at the examples of other assets and ask for help when you have trouble understanding a part of the single asset code file you need to define per asset.

The other option is to only use the online hosted version of Pandora's asset creation editor, hosted under: [https://project-pandora.com/editor](https://project-pandora.com/editor).
This allows you to do the graphics part of your asset and test it to some degree in the editor, while you team up with someone else to do the asset code. You can also ask us for help with that. There is no installation of any tools on your computer needed for this option - aside from the image editing tools of your choice.
Note, though, that this approach will limit you if you want to create a more complex asset that changes the used images for instance based on module states (e.g. stockings that have an option to show them also half pulled down). The reason is that asset modules need to first be defined in the asset code, before you can use the module states as a condition in the asset editor to display the different image variants. In such a case, your collaboration partner would need to also do the graphics definition fully or at least partially using your images.
If you decide to go that route, you can ignore the next chapter and continue directly with the section "Pandora's asset editor and graphics" further down.

# Development environment setup

To setup fully working local development environment on your computer, follow the [development environment setup tutorial](Tutorial_Development_environment.md).

# Understanding the code behind assets

All assets are in `src/assets/` of the pandora-assets repository.\
For instance in `src/assets/collars/heart_choker/`, you can find the `heart_choker.asset.ts` file with the asset's code.

> [!IMPORTANT]
> The name of the `.asset.ts` file **must** match the name of the folder it is inside.

The file typically has the following parts:
- `Define*` macro that decides the [type of asset](Glossary.md#asset-types).
- Name, as shown to the users.
- The according [graphics definition](Glossary.md#asset-graphics) file in the same folder.
- Information about coloring, including default colors
- Any properties the asset has, such as [Effects](Glossary.md#effects) or [Attributes](Glossary.md#attributes).
- Definition of [modules](Glossary.md#modules), if the asset has any.
- Ownership information about the images the asset uses.

# Pandora's asset editor and graphics

Next, we recommend to look into the graphical part of the asset creation inside Pandora's custom asset editor.
The asset editor is a graphical tool to integrate asset images with the pose system Pandora has.

This is done by creating "[Layers](Glossary.md#layer)", assigning them images, [point templates](Glossary.md#point-templates) and a few more other settings that can be changed to make your asset work well. All of these things can be aligned and set up in the editor and then exported for inclusion into the asset code (via the `graphics.json` or `roomDeviceGraphics.json` file that can be exported from the editor).

You can find the latest stable version of the editor here: [https://project-pandora.com/editor](https://project-pandora.com/editor)

## Getting familiar with the asset editor

First, you will be greeted by two buttons:
- First one ('Load Assets From Local Development Server') loads the definitions from your local asset server. **This is the preferred method, but requires you to install the development tools, as described in the [development environment setup tutorial](Tutorial_Development_environment.md).**
- Second one ('Load Assets From Official Link') loads assets from the stable version, not requiring you to run your own asset server, but also not allowing the creation of new asset fully.
In both cases, you need to manually export changes, either the graphics definition string for replacing the original content of the `graphics.json` (or `roomDeviceGraphics.json`) file, or by downloading a zip file, which you will need to extract and place its contents into the correct spot manually.

> [!NOTE]
> For the sake of this tutorial, we will assume you have a working local development environment and use the 'Local Development Server' option.

The asset editor screen itself consists of three tabs/columns in the default configuration. From left to right:
- the items tab - used for equipping and editing assets (editing an asset changes the tab to the layer management tab)
- the layer tab - which is currently empty as you there is no layer selected in the layer management tab
- a view of the character model after transformations by changing poses (in the poses tab) - used for checking how the character would look in-game

Navigation is done via the top bar in each tab, where you can create a new tab, close one or change the contents the tab shall show to customize the editor to your preferred workflow. You can switch what any tab shows at any time without losing the progress in those tabs.

> [!TIP]
> Many elements in the Editor have a (?) button that shows contextual help about them. We recommend using this often.

In the following sections, all available tab options will be explained briefly.

### "Items" tab

The "Items" tab provides an overview of the body and all items/assets available, edited, or visible on the body.

In the following, some assets will be highlighted that are worth looking at to get familiar with how assets are defined and what options an asset creator has.

Let's start with a very simple one:
Expand the category `headwear` (with the "[+]" area) and find the `headwear/lace_headband` asset. First, press the "+" button to add it. That way, you will see your changes (you should see the item appear on your character and in the middle section of the items-tab). Afterwards, press the "pen"-button to start editing it. This will switch the current tab from items-tab to the asset-tab automatically.

### "Asset" tab

The "Asset" tab lets you edit, export, and import a single asset, as well as manage its layers and the images used by the asset.

You can see that the lace_headband asset consists of only one layer with the name "band" and one image `maid_headband1.png`.

Select the layer "band" so that it is highlighted and this action should now fill the layer-tab, to the right of the current tab, with content.

### "Layer" tab

> [!NOTE]
> Contents of this tab differs significantly based on the selected [layer's type](Glossary.md#layer).
>
> Usually you will encounter "Automatic image" layers ("automesh"), which are the current recommended way to add images. There are, however, many older assets that use simple, low-level "Image" layers. This type allows for more fine-tuning, but generally has fewer tools and it is easy to make mistakes when using it.\
> We strongly recommend using the new "Automatic image" layer type.

Several properties can be edited on this tab, such as:
- Changing the layer name (for your convenience to identify this layer easier in the asset-tab; it is also displayed in any error/warning messages that help you fix problems)
- Setting width, heigh and offset of the layer (usually you should leave these at the default values)
- selecting the Template and its Variant for this layer, so the engine knows how to (or not to) transform this layer when the character changes poses and how to order this layer among the layers of other assets
- Assigning one of the added image files from the Asset-tab to this layer

The point template used is "static", which means that the asset will not scale with body changes/movements in any way.
The template variant has the layer priority type 'Above body', meaning that it is not on the same layer as the body itself, but shall be worn above it. The names of all available layers should be quite self-explanatory.

Under the "Images" tab, the uploaded layer image `maid_headband1.png` was selected to be shown for this layer.

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

> [!IMPORTANT]
> This section also explains many mechanisms you are likely to encounter during asset creation, using practical examples.\
> If this is your first time diving into the depths of asset creation for Project Pandora, we strongly recommend reading it.

Often, assets are a bit more complex than the "Lace Headband" example. Looking at a few more existing assets may help you to learn by example. Therefore, we recommend you to now read this section dedicated to [Looking at existing assets](Tutorial_Existing_assets.md).

# Creating your first asset

When you want to make a new asset, there is an according button on the "items" tab. Pressing it opens a dialogue.

Choose a fitting category for your asset.\
Example: `body` is the category for parts of the body, such as eyes or hair.

You also need to give it an identifier that should be similar to the name, but [lowercase and with "_" instead of space characters](https://en.wikipedia.org/wiki/Snake_case), e.g.
`jeans_shorts`. The asset name would in this example of course be 'Jeans Shorts'.

> [!NOTE]
> While renaming your asset in the future is easy, changing the identifier or category is hard.\
> To change the identifier or category, you will need to manually move the generated asset folder _and_ rename the `.asset.ts` file.
>
> Changing identifier or category will also cause any item created from this asset to be deleted from all user wardrobes and rooms, as Pandora will no longer recognize it.
> Saved item templates will also no longer work.

Only in case the asset will be a body part (e.g. eyes or hair), you need to select something in the according drop-down dialogue.

After pressing the "Create" button, you will the be prompted to download a `*.zip` file with your asset so that you can save its contents in the pandora-asset repository for
committing it when it is ready. This file consists of a minimal `*.asset.ts` file for you to build upon and a placeholder version of the `graphics.json`.

If you did not set up a local development environment as part of this tutorial, you cannot place these files in the according `src` folder of your locally checked out pandora-assets repository, so you can edit the `*.asset.ts` file in your coding editor (e.g. Visual Studio Code or VSCodium).
In that case, you simply hand the files in that ZIP archive over, together with the images you made and the ready `graphics.json`, to the person whom you are collaborating with on the asset for the coding part.

After that, the tab view will immediately switch to the "Asset" tab with your new item loaded, automatically equipping it on the editor character, too.

Please be aware that your asset is not saved in the editor, as the editor resets when it reloads or refreshes. Please make sure to
export the asset definition regularly and overwrite the content of the `graphics.json` of the new asset from the exported package on your local device.
You can do this on the "asset" tab with the button "Export definition to clipboard". Or use "Export archive" to download another ZIP file , which will additionally include the images you added, besides the edited `graphics.json` file.

## Making the asset images

> [!TIP]
> The easiest way to align your asset images to the character is by making them in the size 1000 x 1500 pixels.\
> Handheld items are an exception to this and should be created with size 1500 x 1500 pixels, shifted by 250 pixels to the left, relative to the character image.

> [!IMPORTANT]
> We strongly recommend using the following settings when exporting images from whichever image editing tool you use:
> - Export as `.png` file
> - Do not include any metadata (comment, creation time, color space, …)
> - Use the `RGBA 8` pixel format (different tools call this differently)
> - Export with maximum compression (9), to save space on the server and to make loading the images faster

> [!TIP]
> Pandora contains its own image optimization techniques, so while using 1000x1500 pixel image might seem excessive, Pandora will detect which parts of the image are actually non-empty and cut out only the useful part of each image.\
> Note, however, that for this to work properly, it is important that you clean up your images - not leaving any stray almost-transparent pixels at random places.

If your asset is for a female body and covers the breasts, you likely need to make several sized variants for the front view layer that covers the breasts. 
For that, you can simply download the character preview with the chosen pose in the editor as image to draw over yourself. There is a black download button above the character view in the editor for that. Please keep the body slider values at their default level ("0") before drawing over such an image, or your asset images will not fit in-game. Also, you typically want the arms in the default T-pose to draw over them.
On Pandora's Discord there is a small how-to on the topic of downloading body shape template images for asset creation: https://discord.com/channels/872284471611760720/872569272780607518/1411967926524710963

To dive a bit more into the topic of how many images you will likely need for the asset you want to create:

- 1 image for things like a hair flower, which needs no dedicated back view as the item is only on the front side of the body (`Above body` template variant / layer priority) and is half visible from behind.
- 2 images for something like a hat or skirt that is covering both the front and back side of the head (`Above body` as well as `Below body` template variant / layer priority). If the asset looks exactly the same from both sides, then you could even use the same image for both asset layers and only need to make one image.
- 4 images for something like a bra: one image for the back side of the body (`Below body` template variant / layer priority), one for the base of the front side, and 2 images (or one more for the flat variant) for the breast sizes "small" and "medium", covering the bust above and below (use `Above body` template variant / layer priority and then the same two images reused again on the `Below breasts` template variant / layer priority to cover them from the back view, too, as some breast sizes can be wider than the body and are thus visible from behind)

> [!TIP]
> It is extremely helpful to go look up existing (similar) assets to the one you want to make. You can simply load it in the editor and start editing it so you can see how it was done. In many cases you just need to do some small changes, like exchanging image files and renaming things, but can otherwise completely reuse the existing definitions and code. Even advanced features outside the asset editor, like modules in `*.asset.ts` files, can mostly be copied and reused from the code of existing examples with only minor changes.
>
> Note, that assets creators also define their desired `reusePolicy` in the `.asset.ts` file to signal that their stance is on you reusing their asset for new a new asset - some are even "Free to use" - letting you copy the whole asset as a base for your new one, if you want to.

## Check for warnings in the "Asset" tab

> [!IMPORTANT]
> While you make changes to the layers of an asset in the editor, the asset is built in real-time in the background.
> The "Asset" tab contains a section "Graphics build result" that should show a green checkmark icon and "No problems" when you have completed your asset.
> Please always make sure this is the case before you export the definition for committing it as a pull request on GitHub (or give it to your asset creation partner)!\
> In case the icon is not green, you can press on "View log" to see which layers have problems and then make changes and see how the detected issues change in real-time.

# Advanced topics

There are several more advanced topics, that you will rarely encounter during asset creation.
These are described in a separate [Advanced topics](Tutorial_Advanced.md) section.
