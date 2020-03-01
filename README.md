# Mounting Bracket With Supports

An OpenSCAD library to easily create a Mounting Bracket with an optional Footer to mount the bracket against another object or surface.

![](https://github.com/StafrGotar/MountingBracketWithSupports/blob/master/images/Bracket-Behind-Left.png)

![](https://github.com/StafrGotar/MountingBracketWithSupports/blob/master/images/Bracket-Below-Right.png)


## Requirements

OpenSCAD 2019.05 or later.
Calling parameters are evaluated with the OpenSCAD 'alert()' which was added to OpenSCAD in its version 2019.05.
The library module will most likely fail to compile in earlier versions of OpenSCAD.

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
