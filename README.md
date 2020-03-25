# Mounting Bracket With Supports

An OpenSCAD library to easily create a Mounting Bracket with an optional Footer to mount the bracket against another object or surface.

![](https://github.com/StafrGotar/MountingBracketWithSupports/blob/master/images/Bracket-Below-Frontholes.png)

![](https://github.com/StafrGotar/MountingBracketWithSupports/blob/master/images/Bracket-Behind-Left.png)

![](https://github.com/StafrGotar/MountingBracketWithSupports/blob/master/images/Bracket-Below-Right.png)


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
You may use the OpenSCAD application. Open `File - Show Library Folder...` to see where it is.
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

## Parameters

When calling the `MountingBracketWithSupports.scad` module, it is recommended,
though technically not required, to use named parameters.
Using positional parameters could brake your code, should the order of the parameters change in a future version of the module.
The same is true if a new parameter would be introduced in the call of the module.

Current parameters:
* `l` (That's a lower-case 'L'.) Length of the Mounting Bracket from origin along the X axis. Must be greater than zero. Must be at least 2 times the `wall_thickness` (see below for wall_thickness).
* `w` Width of the bracket from the origin along the Y axis, as measured on Z=0. Must be greater than zero.
* `h` Height of the bracket above Z=0. Must be a positive number. If 'h' is exactly zero, then a gentle reminder warning is issued in the monitor and no bracket is created. See that as a possibility to temporary suppress the creation of the Bracket object.
* `wall_thickness` The thickness of the face-plate and the two triangular supports. Must be greater than zero.
* `wall_holes_xzd_matrix` A matrix, a vector of vectors. For each hole to punch through the face wall, a vector of 3 elements [x,z,d] for the 'x' position, the 'z' position, and the hole 'd'iameter for each hole to be made.
Three different holes at given positions could be provided as: `wall_holes_xzd_matrix=[ [10,15,3], [50,25,10], [90,15,3] ]`
Default is 'no holes', i.e. an empty vector. Like this: `wall_holes_xzd_matrix=[]`
* `footer_thickness` The thickness of the footer. If set to zero, then no footer is produced. May not be negative. A footer makes sense for instance if the Mounting Bracket is going to be 3D-printed as a separate part and then bolted to some 'main object' of yours. If the Mounting Bracket will be 3D-printed together with some 'main object', in one combined print, then the footer can be omitted by setting its thickness to zero.
* `footer_holes_xyd_matrix` A matrix, a vector of vectors. For each mounting hole to punch through the footer, a vector of 3 elements [x,y,d], the 'x' position, the 'y' position and the hole 'd'iameter. Three holes for M3 screws at given positions could be provided as: `footer_holes_xyd_matrix=[ [20,6,3.2], [45,6,3.2], [80,6,3.2] ]` Default is 'no footer holes', i.e. an empty vector. Like this: `footer_holes_xyd_matrix=[]`
* `verbosity` A positive integer value to request 'debug' information to be displayed in the monitor during the instantiation of the object. Default is '0' (zero), which is equal to 'quiet'.
