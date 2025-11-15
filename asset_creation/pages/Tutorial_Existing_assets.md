
# Pandora asset creation tutorial: Looking at existing assets

In the following section, let's have a look at increasingly more complex assets that are good examples of what assets can (currently already) do and how.

> [!TIP]
> You can experiment as much as you like, change existing assets and see how the change is reflected on the character in the preview tab.
> None of your changes are persistent, so you will not break anything by playing around.
> On the other hand, this also means that refreshing or closing your browser will reset any work you do on a new asset creation, so please make sure to not forget exporting an edited asset, if you want to use the changes (more on that later).

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

> [!IMPORTANT]
> Always use the "automatic image layer" type when creating the layers of your new asset, whenever possible!

The selected "jeans back" layer represents the back view of the asset (the jeans from behind).
Let's focus on the four tabs of this automesh layer, which are typically worked on in the following order during asset creation:

The first one, "Template", lets you select the point template used for this layer and its variant.
The point template selected for the shorts is the most common one: 'Body'. The body template makes sure that asset images will be transformed
alongside body changes (e.g. weight sliders or arm movements). As mentioned, selecting the right template is important for making an asset work.
The template variant is of layer priority 'Below body', which means that it is ordered behind the body. 
The enabled parts of the template are body and legs, as part of the used image of the jeans shorts already reaches into the point mesh of the legs.

The next tab, "Graphical layers" lets you define if the automesh layer shall generate a single or more graphical layers, so the actual layers used by Pandora.
This is convenient and efficient if different, separately colorable parts of an image shall be directly layered over each other, such as a belt and a belt buckle.
The tab also lets you assign a color group defined in the asset code file of the asset for each graphical layer.
Optionally, you can define a name for each graphical layer, which is useful if you have more than one.
In the example of the jeans shorts, there is only one graphical layer with a default name and the color group "Pants" from the `bottoms/jeans_shorts/jeans_shorts.asset.ts` file.

> [!TIP]
> "Graphical layers" were created to work well if you use layers in your favorite image editing tool.\
> If you have 3 layers in your image editor that you want to combine together to produce the resulting image (e.g. "base", "shadows", and "shine"), the easiest approach is to export each of them as an separate `.png` and then in the Editor create a single "Automatic image layer" with three "Graphical layers" - "base", "shadows", and "shine".

The third tab, "Variables", lets you select variables based on which different images shall be conditionally used by the graphical layers.
If you press on "Add variable" you can see that there are different kinds of possible variables that image override conditions can be based on. The most commonly used one is "based on typed module", followed by "based on front/back view".
Our current example is a simple asset that uses no variables, so this tab is empty.

The last tab "Images", lets you assign the images uploaded or pre-existing in the "image management" section of the "Asset" tab to each graphical layer, based on the conditions derived from the selected variables from the previous tab.
For the jeans shorts, you have no conditions, so only one image can be selected for the single graphical layer of the automesh layer. The selected image for this layer is of course `Jeans_Shorts_Back.png`.

The layer "jeans front" for the front view is pretty similar, aside from the template variant 'Above body' and the different asset image used.
Try to click this layer and then in the "Template" tab, remove the template part "legs" as a test. You should notice that in the "preview" view, the bottom part of the jeans short image is suddenly cut off a bit on the front facing character, as the reduced number of points altered the applied mesh and therefore cut the image where the torso (body) mesh above the legs ends.
Remembering this can help you to decide which template parts you need to enable on a new asset. No worries, though, the editor will warn you when you use a template part that is not necessary to be enabled, as it would span a mesh over parts where the used image is empty. So for example, if you would enable the "arms" part here, you could see a warning icon in the middle of the "Asset" tab and can click on "View log" to check why (more on warnings later).

The button layer is again similar to the other front view layer, but it uses the 'static' point template as the button does not need to
transform/move/scale with the body in any way.

> [!IMPORTANT]
> The order of the layers on the asset-tab matters! Only the correct order will get the desired visual results. Feel free to change
> the order of the layers of the jeans shorts to get a feeling for it. Changes to any assets are reset when you reload the editor.

## T-Shirt: Using variables

Here is another asset example that is important to understand if you want to make any asset that covers breasts or has sleeves.

Expand the category `tops` (with the "[+]" area) and find the `tops/t-shirt1` asset. Now press the "pen+" button to make the character wear it and also start editing it at the same time.

In the asset-tab you can see that this asset has five layers:
- 'Front' for the front view of the torso
- 'bust' for the front view of the breasts, allowing for the shirt to adapt to different breast sizes
- 'bust back' same as 'bust', but for covering breasts from the back view (if using brest size that is wider than the body)
- 'Back' for the back view of the torso
- 'Print' for showing an optional print on the front view via the according module that this asset has defined in the `t-shirt1.asset.ts` file.

Let's start with the 'Print' layer. The new part here is that the "Variable" tab uses a variable "based on typed module" with the module name `prints` that this asset has defined in the `t-shirt1.asset.ts` file.
This also changed how the "Images" tab looks: There, you can see the possibility to select an image representing one of the t-shirt prints for each state of the `prints`-module.
An outlier is the state `No Print`, where this layer will show no image, making the asset a t-shirt without print.

_Note 1: An automesh layer can use more than one variable to define image override conditions for the "Images" tab. You could take a look at the `toys/dildo` asset for a complex example that uses 4 variables, together allowing to pick the layer image based on a combination of material, tip design, insertion depth, and front or back view of the asset. So therefore, if an entry under the "Images" tab in this example has the heading "Rubber | Smooth | Outside | Front", it means the drop-down below selects the image that should be used if the 4 variables have this exact state combination. It is not uncommon that some of the possible combinations require no image and the dropdown selector value should stay '[None]'._

_Note 2: For an example of how image overrides are used in the case of non-automesh layers, so old "image layers", the following asset may be interesting: the `bras/style1` bra, which does not show the asset for flat breasts due to bone-based image overrides._

Now back to the layers 'Front' and 'Back': If you look at these two automesh layers, you can see that they use the same image file, which is a
t-shirt with sleeves, but they each use a different template variant.
The enabled template parts here are "body" and "arms" as the t-shirt image reaches into the mesh over the arms.

Finally, the image layer "bust" shows an example of how the bust part of a clothing item is defined using a special (point) template and only two images!
This same approach can be copied and reused for most clothing assets, e.g. the asian dress (`dresses/asian_dress`).
On Pandora's Discord there is a small how-to that documents how this asset was made: https://discord.com/channels/872284471611760720/872569272780607518/1411953336764338197

> [!TIP]
> The recommended way to tackle breast sizing if you want a perfect fit is to create a full torso image for each of the 5 possible breast sizes.
