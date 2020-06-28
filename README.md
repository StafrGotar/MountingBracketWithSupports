# Mounting Bracket With Supports

An OpenSCAD **library** to easily create a Mounting Bracket with an optional Footer to mount the bracket against another object or surface.
Parameterized holes (position, diameter and shape of each individual hole) can be created in the footer and/or in the face-plate wall.

![](https://github.com/StafrGotar/MountingBracketWithSupports/blob/master/images/Bracket-Below-Right.png)

The simplest example.


![](https://github.com/StafrGotar/MountingBracketWithSupports/blob/master/images/Bracket-Behind-Left.png)

Seen from the 'back'.


![](https://github.com/StafrGotar/MountingBracketWithSupports/blob/master/images/Bracket-Below-Frontholes.png)

Adding three holes in the face-plate wall.

![](https://github.com/StafrGotar/MountingBracketWithSupports/blob/master/images/Bracket-Frontholes-GoingBerserk.png)

Going berserk with holes of different shapes and positions.


## Requirements

OpenSCAD 2019.05 or later.
Calling parameters are evaluated with the OpenSCAD 'alert()' which was added to OpenSCAD in its version 2019.05.
The library module will most likely fail to compile in earlier versions of OpenSCAD.

## Dependencies

This library does not use any external libraries.

## Installation

The **Mounting Bracket With Supports** module is implemented in a single .scad file.
This file may be copied anywhere it fits in to your current OpenSCAD environment.

Nevertheless, the proposed installation would be to:

* In any directory of your choice, for instance in your home directory,
execute `git clone https://github.com/StafrGotar/MountingBracketWithSupports`
which should create a subdirectory named `MountingBracketWithSupports`
where you will find a copy of this github repository.
* Find any of your OpenSCAD library directories (global or local).
This can be done with the OpenSCAD application itself.
Open `File - Show Library Folder...` to see which library directories are used by your OpenSCAD installation.
* Create the subdirectory `StafrGotar/bracket/` in your library directory, adjusting the access rights to your liking
or according to your local system policies.
* Copy the single file `<home_dir>/MountingBracketWithSupports/StafrGotar/bracket/MountingBracketWithSupports.scad`
to your newly created`<library_dir>/StafrGotar/bracket/` directory.

## Usage

If you `include <StafrGotar/bracket/MountingBracketWithSupports.scad>` in your OpenSCAD file,
then the default demo object will be produced.
This is probably not what you want long term.
But it's a good way to visualize what the module can provide.

If you `use <StafrGotar/bracket/MountingBracketWithSupports.scad>` in your OpenSCAD file,
then the demo object will **not** be instantiated, but you must instantiate it from your own code.

That's when you'll have to start studying the parameters and their influence on the Mounting Bracket object.
Tip: Take advantage of named parameters. It'll make your own calling code easier to read.


## XYZ-orientation.
The object will allways be placed in the first quadrant,
with what could be called "the lower left corner" on the origin at Z=0 and stretching "to the right" into X.

The face-plate wall, where we imagine to attach 'things' to the bracket, will be turned 'forward'
into a default camera position.


## Parameters

When calling the `MountingBracketWithSupports.scad` module, it is recommended,
though technically not required, to use named parameters.
Using positional parameters could brake your code, should the order of the parameters change in a future version of the module.
The same is true if a new parameter would be introduced in the call of the module.

Current parameters:
* `l` (That's a lower-case 'L'.) Length of the Mounting Bracket from origin along the X axis. Must be greater than zero. Must be at least 2 times the `wall_thickness` (see below for wall_thickness).
* `w` Width of the bracket from the origin along the Y axis, as measured on Z=0. Must be greater than zero.
* `h` Height of the bracket above Z=0. Must be a positive number. If 'h' is exactly zero, then a gentle reminder warning is issued in the monitor and no bracket is created. See that as a possibility to temporarily suppress the creation of the Bracket object.
* `wall_thickness` The thickness of the face-plate wall and the two triangular supports. Must be greater than zero.
* `wall_holes_xzd_matrix` A matrix, a vector of vectors. For each hole to be made through the face-plate wall, a vector of 3 to 5 elements [x,z,d,fn,rot] for the 'x' position on the face-plate wall (mandatory), the 'z' position on the face-plate wall (mandatory), the 'd' hole diameter (mandatory, >= 0), 'fn' fragment number (optional, equivalent of $fn) and 'rot' number of degrees to rotate the hole. Rotating a hole could be important when a hole is triangular, square, etc.
Three different holes at given positions could be provided as: `wall_holes_xzd_matrix=[ [10,15,3], [50,25,10], [90,15,3] ]`
One square hole, rotated 45 degrees so the hole becomes horizontal could be provided as: `wall_holes_xzd_matrix=[ [10,15,3,4,45] ]`
Default is 'no holes', i.e. an empty matrix. Like this: `wall_holes_xzd_matrix=[]`
* `footer_thickness` The thickness of the footer. If set to zero, then no footer is produced. May not be negative. A footer makes sense for instance if the Mounting Bracket is going to be 3D-printed as a separate part and then bolted to some 'main object' of yours. If the Mounting Bracket will be 3D-printed together with some 'main object', in one combined print, then the footer can be omitted by setting its thickness to zero.
* `footer_holes_xyd_matrix` A matrix, a vector of vectors. For each mounting hole to punch through the footer, a vector of 3 to 5 elements [x,y,d,fn,rot] for the 'x' position on the footer (mandatory), the 'y' position on the footer (mandatory), the 'd' hole diameter (mandatory, >= 0), 'fn' fragment number (optional, equivalent of $fn) and 'rot' number of degrees to rotate the hole. Three holes for M3 screws at given positions could be provided as: `footer_holes_xyd_matrix=[ [20,6,3.2], [45,6,3.2], [80,6,3.2] ]` Default is 'no footer holes', i.e. an empty matrix. Like this: `footer_holes_xyd_matrix=[]`
* `verbosity` A positive integer value to request 'debug' information to be displayed in the monitor during the instantiation of the object. Default is '0' (zero), which is equal to 'quiet'.
* `$fn` The module will listen to the global `$fn` variable, if it's set.
For all holes in the bracket where the caller has **not** provided an explicit 'fn' value, the global $fn will be used.
Where hole-specific 'fn' values are given, those will be used.
If no `$fn` is set and no hole-specific 'fn' is set, then the default 'fn' value of 8 will be used.
