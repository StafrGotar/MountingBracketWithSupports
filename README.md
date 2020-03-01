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

## Usage

If you `include <StafrGotar/bracket/MountingBracketWithSupports.scad>` in your OpenSCAD file,
then the default demo object will be produced.
This is probably not what you want long term.
But it's a good way to visualize what the module can provide.

If you `use <StafrGotar/bracket/MountingBracketWithSupports.scad>` in your OpenSCAD file,
then the module will **not** be instantiated, but you must instantiate it from your own code.

That's when you'll have to start studying the parameters and their influence on the Mounting Bracket object.
Tip: Take advantage of named parameters. It'll make your own calling code easier to read.

## Parameters
