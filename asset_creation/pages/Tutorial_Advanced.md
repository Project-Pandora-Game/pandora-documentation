# Pandora asset creation tutorial: Advanced topics

The following topics are needed extremely rarely and even in the case that the currently available tools and templates are not enough for the asset you want to create, it is best to ask on Discord first, as synchronizing with others might allow other assets to reuse work needed for what your asset needs - thus making creation of similar assets easier in the future.

## ADVANCED: The Points-tab

> [!CAUTION]
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

> [!WARNING]
> __Deprecated__: This section contains information that will soon become outdated.
> 
> Reason: We are also working on reworking how transformations happen internally, to make them more performant and compatible with existing tools and programs outside Pandora.

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

