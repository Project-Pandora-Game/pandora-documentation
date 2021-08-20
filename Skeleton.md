# Skeleton Demo Guide

This is a guide to the design of the proposed skeleton model for Pandora. The skeleton is proposed as a means of incorporating assets (a.k.a items, clothes, restraints, etc) into the game in a way that makes it easy to develop for contributors moving forward.

# Table of Contents
* [Historical Problems]("#historical")
* [Proposed Solutions]("#proposed")
* [The System Itself]("#system")
	* [Segments]("#segments")
		* [Rotating Secments]("#rotating")
	* [Render and Sorting]("#render")
	* [Poses]("#poses")
	* [Animations (TODO)]("#animations")


## Historical Problems <a name="historical"></a>

In BC, the asset model involved static images for every pose that was different from the default pose. This results in exponential multiplication of assets, as separate images are required for:
* Every body type
* Every pose
* Every type/variation of the item that depends on the above

This can lead to single assets requiring hundreds of images, such as the various catsuits, which pushes out content creators who are not willing to spend hours on a single item. Ultimately, this hurts the game ecosystem and lowers the quality of items that are created, as it is easier to redraw simple assets than to edit photo references or rig 3d models.

BC also has issues with a priority system that is inflexible. While not the primary purpose of selecting the skeleton model, the skeleton does have dynamic priority features that allow for defining simple rules for when certain things like hands ought to be over or under bodyparts.

## Proposed Solutions <a name="proposed"></a>

To date, there have been a number of proposed solutions to handle assets in Pandora:
* Use the BC system (this solves none of the problems above, although improvements can still be made such as an improved layering system and architecture)
* Use a 2d skeleton (this document)
* Use 3d models to render all poses, and then import them into Pandora with minimal editing
* Implement a full 3d rendering engine

Within the 2d skeleton concept, there are a number of considerations:
* Use DragonBones, an existing skeletal framework that is no longer maintained
* Use Spline, an industry standard skeleton and animation system that also has steep licensing costs for the average contributor, a minimum of $70 USD to get started.
* Create a home brewed system and maintain it ourselves

This document details a home brewed system created by Ada18980 in an effort to understand the advantages and limitations of a home brewed skeleton system.

## The System Itself <a name="system"></a>

(TODO add a flowchart)

### Segments <a name="segments"></a>

A character is made up entirely of BodySegment objects, referred to simply as segments. Each segment has the following core properties:
* **Name:** The internal handle of the segment
* **Priority:** A list of IPriority objects which contain priority rules related to dynamic priorities (see [Render and Sorting]("#render"))
* **PriorityTag:** A list of tags describing what sort of parts this segment belongs to, such as arms, legs, and/or thighs.
* **PriorityFallback:** A floating point number used to determine the priority in case two objects end up with the same priority. It also (feature currently unfinished) would allow for an object to have a priority rule set up such that it matches another object's priority, at which point the fallback priority is used to determine which objects appear highest.
* **Path:** A link to the sprite for the body segment.
* **Parent:** The parent of this segment. Only one object should lack a parent--that would be the Torso. Every other object will have a parent and its position will be based on its parent's position and rotation.
* **Invert:** A helpful property that inverts most X-values and angles when it comes to position and translation, allowing the left and right versions of a limb to be defined with minimal changes to the data.
* **Position:** An object containing data on where the pivot point of the sprite is, and where the segment is located relative to it's parent's origin (before parent rotation)
* **Rotation:** An object containing data on how the segment will rotate, including max, min angles and also properties on how to translate the object based on rotation (to make joints fit more naturally)
* **Hide:** A function that can be defined, passing the whole skeleton as an argument. If true, the segment is hidden and not rendered, although its children will still be rendered.
* **Ext:** An object containing data on setting an Extension Parent. This is basically an object which the present object will copy a rotation angle from, times a multiplier. Good for creating things like hips and shoulders which don't rotate fully with the arm.

(**Weight** is defined in the code but has no implementation yet)


The above properties are fairly dense and complex to understand. The most important ones to understand are Position and Rotation.

#### Rotating Segments <a name="rotating"></a>

Rather than an absolute angle, segments have a variable known as Extension that basically tracks how extended a body part is from 1 to -1. An extension of 0 means the object is in its default position, 1 means it is at its AngleMax value (defined in the Rotation object), and -1 means it is at AngleMin.

Segments inherit rotation from their parent, and this does not apply to their extension. So if, say, an arm is rotated at 100 degrees, and the hand is at extention 1.0 and rotated 30 degrees by itself, then the total angle (as the sprite would be drawn on the screen) would be 130 degrees.

The parent's rotation also causes the segment to move around. When a segment rotates, all of its children rotate with it, using a recursive matrix transformation in the rendering script. 

### Render and Sorting <a name="render"></a>

A BodySkeleton object is used to store a number of BodySegments. After adding a number of BodySegments to a skeleton, the skeleton calls assignParents("Torso") to resolve parents, set internal pointers, and set the torso as the primary element of the skeleton.

A SkeletonContainer object contains the skeleton, along with drawing elements such as PIXI.js Containers. The primary reason this is separate from a BodySkeleton is to help with serialization (you can serialize the skeleton and create a SkeletonContainer when you deserialize). The SkeletonContainer contains no fields that are not automatically determined from the Skeleton itself, although it does preserve the renderOrder in order to avoid having to sort it every frame.
The other reason why SkeletonContainers are separate from BodySkeleton is to segregate drawing code from the skeleton object. This, again, aids with referencing the skeleton objects as it encapsulates rendering features into the container class.

The `updateExtension()` function updates the entire skeleton tree, setting the locations of segments based on their parents and extension. It also determines whether they are visible or not. Each segment sprite is set within its own container, and then each container has a zIndex which is a PIXI.js variable that allows for dynamic render sorting.
updateExtension() also handles the Hide property.

#### Sorting  <a name="sorting"></a>

SkeletonContainer contains a function called `sortRenderOrder()` which is run whenever a change is made to the skeleton. However, sorting every frame may cause framerate drops. It is recommended to flag a change to the skeleton:
* Every time a pose is added or removed to the skeleton
* Every time a change is made to a segment whose priority depends on or affects its own extension or the extension of a different segment. To avoid framerate drops from this happening every frame during an animation, it is recommended to either run it at the start and end of an animation, or to use different segments with different properties and Hide functions in order to perform extension-based priority changes.

The sorting algorithm is not set in stone. It basically iterates through all of a segment's rules and if a segment is supposed to be over another segment, it nudges the current segment's temp priority up by 1 and pulls the other segment's temp priority down by 1. It uses a `Map` to track the temp priority to enable fast lookup, and will report an error in the console if it's still iterating after 1000 cycles (which means that a contradictory priority rule was detected).

The primary way to determine the render order is by adding Priority rules to a segment's Priority array. A priority rule consists of the following:
* A PriorityRule to determine whether it should be under a target segment, over a target segment, (TODO) if the segment should have an equal priority to another segment, barring PriorityOverride
* A string determining either which segment is targeted by this rule, or which PriorityTag is targeted. If a PriorityTag is targeted, then it will check the priority rule once for each segment that shares that PriorityTag.
* A condition. If undefined, the prorityrule always holds. Otherwise, it is a function with the Skeleton as a parameter, and if it is false then the priority rule will be ignored.

### Poses <a name="poses"></a>

The BodySkeleton object has a PoseTags field which tracks the current pose tags. Unlike BC, a Pose Tag is not a full pose but are rather flags meant to allow creating priority and hiding rules based on what the body is doing. The FIST_LEFT pose, for example, hides the open palm segment and unhides the fist segment. The BOXTIE pose segment is used to hide the forearms in the boxtie pose for the side view, as they aren't rendered due to limitations (but an asset maker could easily add a piece that is rendered when the character is boxtied and hidden otherwise).

### Animations <a name="animations"></a>

IN PROGRESS
