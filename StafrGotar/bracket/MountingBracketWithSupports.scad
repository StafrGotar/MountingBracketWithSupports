/****************************************************************************************************************************
*
* Description.
* ============
* A Generic and parametered 'Mounting Bracket with Supports' object
* to be used either separately or as part of a greater model.
*
* How to better describe the object provided by this module?
* The best I can come up with is this:
*
* Open the module in an empty OpenSCAD session.
* It will make a demo object with some decent default values.
* Turn it around and study it.
* Decide if it's of any use in your project(s).
*
*
* Author: Stafr Gotar
*
* The latest version can be found at:
* https://github.com/StafrGotar/MountingBracketWithSupports
*
*
* How to use it.
* ==============
* If you 'include' this module into your OpenSCAD file, the default demo object will be produced.
* This is probably not what you want long term.
* But it's a good way to visualize what the module can provide.
* If you 'use' this module from your OpenSCAD file, then the module will *not* be instantiated,
* but you must instantiate it from your own code.
* That's when you'll have to start studying the parameters and their influence on the Mounting Bracket object.
* Tip: Take advantage of named parameters. It'll make your own calling code easier to read.
*
*
* XYZ-orientation.
* ================
* The object will allways be placed in the first quadrant, with what could be called
* "the lower left corner" on the origin at Z=0 and stretching "to the right" into X.
*
* The face-plate wall, where we imagine to attach 'things' to the bracket, will be turned 'forward'
* into a default camera position.
*
* By default, no holes will be made either in the footer or in the face-plate wall.
* Holes must be explicitly requested in the calling parameters.
*
*
* Parameters.
* ===========
* l => Length. That's a lower case 'L'. Size from origin along the X axis.
*      Must be greater than zero.
*      Must be at least twice the wall_thickness (see below).
*
* w => Width. Size from the origin along the Y axis, as measured on Z=0.
*      Must be greater than zero.
*
* h => Height. Size above Z=0.
*      Must be a positive number.
*      If 'h' is exactly zero, then a gentle reminder warning is issued in OpenSCAD's monitor and no bracket is created.
*      See that as a possibility to temporary suppress the creation of the Bracket object.
*
* wall_thickness => The thickness of the face-plate wall and the two triangular supports.
*                   Must be greater than zero.
*
* wall_holes_xzd_matrix => A matrix, a vector of vectors.
*                          For each hole to punch through the face wall, a vector of 3 to 5 elements [x,z,d,fn,rot].
*                          Details:
*                          'x' position on the face-plate wall, mandatory
*                          'z' position on the face-plate hole, mandatory
*                          'd' hole diameter, mandatory, may be zero for no hole, but can't be negative
*                          'fn' fragment number for hole (like $fn), optional
*                          'rot' degrees of rotation of the hole (useful for triangular or square holes), optional
*
*                          Three different holes at given positions could be provided as:
*                          wall_holes_xzd_matrix=[ [10,15,3], [50,25,10], [90,15,3] ]
*
*                          Default value is 'no holes', i.e. an empty matrix.  (A vector of no vectors.)
*                          Like this: wall_holes_xzd_matrix=[]
*
* footer_thickness => The thickness of the footer. If set to zero, then no footer is produced.
*                     May not be negative.
*                     A footer makes sense for instance if the Mounting Bracket is going to be 3D-printed as a separate
*                     part and then bolted to some 'main object' of yours.
*                     If the Mounting Bracket will be 3D-printed together with some 'main object', in one combined print,
*                     then the footer can be omitted by setting its thickness to zero.
*
* footer_holes_xyd_matrix => A matrix, a vector of vectors.
*                            For each mounting hole to punch through the footer, a vector of 3 to 5 elements [x,y,d,fn,rot].
*                            Details:
*                            'x' position from the origin, mandatory
*                            'y' position from the origin, mandatory
*                            'd' hole diameter, mandatory, may be zero for no hole, but can't be negative
*                            'fn' fragment number for hole (like $fn), optional
*                            'rot' degrees of rotation of the hole (useful for triangular or square holes), optional
*
*                            Three holes for M3 screws at given positions could be provided as:
*                            footer_holes_xyd_matrix=[ [20,6,3.2], [45,6,3.2], [80,6,3.2] ]
*
*                            Default value is 'no footer holes', i.e. an empty matrix. (A vector of no vectors.)
*                            Like this: footer_holes_xyd_matrix=[]
*
* verbosity => A positive integer value to request 'debug' information to be displayed in OpenSCAD's monitor
*              during the instantiation of the object.
*              Default is '0' (zero), which is equal to 'quiet'.
*              Currently, the highest value is '2'.
*
* $fn => The module will listen to the global $fn variable, if it's set.
*        For all holes in the bracket where the caller has *not* provided an explicit 'fn' value, the global $fn will be used.
*        Where hole-specific 'fn' values are given, those will be used.
*        If no $fn is set and no hole-specific 'fn' is set, then the default 'fn' value of 8 will be used.
*
****************************************************************************************************************************/

/*
 The external calling interface. Reasonable default values are set.
 By default, there are no mounting holes in the footer and no holes in the face-plate wall.
*/
module Mounting_Bracket_With_Supports(l=100,
				      w=10,
				      h=50,
				      wall_thickness=1,
				      wall_holes_xzd_matrix=[],
				      footer_thickness=1,
				      footer_holes_xyd_matrix=[],
				      verbosity=0) {
     //  Simple verification of some input variables.
     assert(l > 0,"You must provide a positive 'X' length greater than zero!");
     assert(w > 0,"You must provide a positive 'Y' width greater than zero!");
     assert(h >= 0,"Height (h) may not be negative. Set to zero to suppress instantiation of the Mounting Bracket.");
     assert(wall_thickness > 0,"Wall Thickness must be > 0.");
     assert(footer_thickness >= 0,"Footer Thickness may not be negative. Set to zero to suppress the Footer.");
     assert(h >= footer_thickness,"Footer Thickness may not be > total height (h).");
     assert(l >+ (wall_thickness*2),"The length (l) must be at least 2 times the wall thickness.");

     pass_through=0.001; // To avoid having a hole flush with a surface.
     height_ratio=0.75;  // Could become a parameter one day.

     // Calling the original 'cylinder()' without a valid '$fn' makes a cylinder with 8 fragments.
     // Calling the original 'cylinder()' with a '$fn < 3' makes a triangle shaped cylinder.
     
     default_fn=8; // In case it's missing or holds an 'illegal' value.
     minimum_fn=3; // A triangular cylinder is made from the smallest possible number of fragments.
     
     // Private module, 'protected' by scope.
     module local_support_wall_triangle(h=30,w=10,t=wall_thickness) {
	  linear_extrude(height=t)
	       polygon(points=[ [0,0], [w,0], [0,h] ]);
     }
     
     // Private module, 'protected' by scope.
     module local_cylinder_hole(height,radius,fn) {
	  // Outer (circumscribed) cylinder polygon.
	  // https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/undersized_circular_objects
	  fudge = 1/cos(180/fn);
	  cylinder(h=height,r=radius*fudge,$fn=fn,center=false);
     }

     if((h-footer_thickness) <= 0) {
	  echo(str("WARNING: Mounting Bracket has no height over its footer. No Mounting Bracket will be produced."));
     }
     else {
	  // Union between the footer and the face-plate (with supports).
	  union() {
	       // The footer.
	       if (footer_thickness > 0) {
		    // If footer is requested, i.e. thicker than 0.
		    difference() {
			 // Create the footer itself.
			 cube([l,w,footer_thickness]);
			 // If screwholes are requested for the footer, punch the holes.
			 for(hole=footer_holes_xyd_matrix) {
			      // Verify the footer hole specification.
			      assert(!is_undef(hole[2]),
				   str("Footer hole diameter is mandatory."));
			      assert(hole[2] >= 0, // If zero, cylinder() will not create any object. I.e. no hole.
				   str("Footer hole diameter (",
				       hole[2],
				       ") may not be negative."));
			      // Verify that no footer hole becomes 'invisible' by being put beyond the footer area.
			      assert(hole[0] >= 0,
				     str("Footer hole 'x' (",
					 hole[0],
					 ") may not be negative."));
			      assert(hole[0] < l,
				     str("Footer hole 'x' (",
					 hole[0],
					 ") may not be set beyond bracket length 'l' (",
					 l,")."));
			      if(verbosity > 0) {
				   // Only upon explicit request.
				   echo(str("Footer hole vector: [",hole[0], // X pos.
					    ",",hole[1],  // Y pos.
					    ",",hole[2],  // Diam.
					    ",",hole[3],  // fn.
					    ",",hole[4],  // Rotate.
					    "]."));
			      }
			      footer_cylinder_fn =
				   is_undef(hole[3]) || !is_num(hole[3]) ?  // Nothing valid specified ?
				   is_undef($fn) ? default_fn :             // Missing $fn, take default, else look for $fn.
				   $fn >= minimum_fn ? $fn : minimum_fn :   // Too small $fn, take minimum.
				   hole[3] ;                                // Take the specified value.
			      if(verbosity > 1) {
				   echo(str("Footer hole fn: ",footer_cylinder_fn));
			      }
			      // Did the caller request we rotate the footer hole? (Useful for triangular, square, etc. holes.)
			      footer_hole_rot =
				   is_undef(hole[4]) || !is_num(hole[4]) ?
				   0 :                                      // Not given or invalid, so ignore.
				   hole[4];                                 // Use it.
			      if(verbosity > 1) {
				   echo(str("Footer hole rotate: ",footer_hole_rot));
			      }
			      translate([hole[0],hole[1],-pass_through])
				   rotate([0,0,footer_hole_rot])            // As per caller's request.
				   local_cylinder_hole(height=footer_thickness+(2*pass_through),
						       radius=hole[2]/2,
						       fn=footer_cylinder_fn);
			 }
		    }
	       }
	       // The face-plate wall.
	       translate([0,0,footer_thickness])
		    // Lift the wall and the supports to give z-place for the footer.
		    // If footer_thickness == 0, then the lift becomes null.
		    difference() {
		    // Build the face-plate...
		    union() {
		    // The main 'standing' wall, i.e. the face-plate.
		    cube([l,
			  wall_thickness,
			  h-footer_thickness]); // If there was a footer, we'll have to reduce the face-plate height accordingly.
		    // Left triangular support.
		    translate([0,wall_thickness,0]) // So the support doesn't 'enter', becomes part of,  the main wall.
			 rotate([0,0,90]) // Twist around Z.
			 rotate([90,0,0]) // Stand up.
			 local_support_wall_triangle(h=h*height_ratio,
						     w=w-wall_thickness);
		    // Right triangular support.
		    translate([l-wall_thickness,  // Off to the right.
			       wall_thickness,  // So it doesn't 'enter' the main wall.
			       0])
			 rotate([0,0,90]) // Twist around Z.
			 rotate([90,0,0]) // Stand up.
			 local_support_wall_triangle(h=h*height_ratio,
						     w=w-wall_thickness);
		    }
		    // Remove any requested holes from the face-plate wall.
		    for(wall_hole=wall_holes_xzd_matrix) {
			 // Verify the wall hole specification.
			 assert(!is_undef(wall_hole[2]),
				str("Wall hole diameter is mandatory."));
			 assert(wall_hole[2] >= 0, // If zero, cylinder() will not create any object. I.e. no hole.
				str("Wall hole diameter (",
				    wall_hole[2],
				    ") may not be negative."));
			 // Verify that no wall hole becomes 'invisible' by being put beyond the wall area.
			 assert(wall_hole[0] >= 0,
				str("Wall hole 'x' (",
				    wall_hole[0],
				    ") may not be negative."));
			 assert(wall_hole[0] < l,
				str("Wall hole 'x' (",
				    wall_hole[0],
				    ") may not be set beyond bracket length 'l' (",
				    l,")."));
			 if(verbosity > 0) {
			      // Only upon explicit request.
			      echo(str("Wall hole vector: [",wall_hole[0],
				       ",",wall_hole[1],
				       ",",wall_hole[2],
				       ",",wall_hole[3],
				       ",",wall_hole[4],
				       "]."));
			 }
			 wall_cylinder_fn =
			      is_undef(wall_hole[3]) || !is_num(wall_hole[3]) ? // Nothing valid specified ?
			      is_undef($fn) ? default_fn :                      // Missing $fn, take default, else look for $fn.
			      $fn >= minimum_fn ? $fn : minimum_fn :            // Too small $fn, take minimum.
			      wall_hole[3] ;                                    // Take the specified value.
			 if(verbosity > 1) {
			      echo(str("Wall hole fn: ",wall_cylinder_fn));
			 }
			 // Did the caller request we rotate the wall hole? (Useful for triangular, square, etc. holes.)
			 wall_hole_rot =
			      is_undef(wall_hole[4]) || !is_num(wall_hole[4]) ?
			      0 :                                               // Not given or invalid, so ignore.
			      wall_hole[4];                                     // Use it.
			 if(verbosity > 1) {
			      echo(str("Wall hole rotate: ",wall_hole_rot));
			 }
			 translate([wall_hole[0],wall_thickness+pass_through,wall_hole[1]])
			      rotate([0,wall_hole_rot,0])                       // As per caller's request.
			      rotate([90,0,0])                                  // Put the cylinder horizontal, through the wall.
			      local_cylinder_hole(height=wall_thickness+(2*pass_through),
						  radius=wall_hole[2]/2,
						  fn=wall_cylinder_fn);
		    }
	       }
	  }
     }
}


/****************************************************************************************************************************
 Demo driver, activated by 'include <StafrGotar/bracket/MountingBracketWithSupports.scad>'.
 Specify 'use <StafrGotar/bracket/MountingBracketWithSupports.scad>' to suppress the demo object.

 This demo driver call is explicitly written as a very long list of arguments
 to permit explicit comments on the example parameters.

 Values are here hardcoded, but the caller will most likely create the dimensions and positions dynamically.

 Lot's of examples for creating holes in the bracket are provided, some pretty odd ones.
****************************************************************************************************************************/
Mounting_Bracket_With_Supports(l=100,  // X length.
			       h=50,   // Z height.
			       wall_thickness=1.6,
			       wall_holes_xzd_matrix=[ [10,    // X position on the face-plate wall.
							15,    // Z position on the face-plate wall.
							3,     // Diameter.
							8,     // Fragment number (fn) for this hole.
							0],    // Rotate degrees +/- (0 - 259)
						       
						       [20,    // X pos.
							25,    // Z pos.
							6],    // Diameter. (No fn specified, so undef. No rotate, so undef.)

						       [30,    // X pos.
							25,    // Z pos.
							6,     // Diameter.
							3,     // Fragments fn. Explicit triangle.
							90],   // Rotate 90 degrees.
						       
						       [40,    // X pos.
							25,    // Z pos.
							6,     // Diameter.
							3,     // Fragments fn. Explicit triangle.
							-110], // Rotate -110 degrees.
						       
						       [60,    // X pos.
							25,    // Z pos.
							6,     // Diameter.
							4],    // Fragments fn. Explicit square.
						       
						       [70,    // X pos.
							25,    // Z pos.
							6,     // Diameter.
							4,     // Fragments fn. Explicit square.
							45],   // Rotate 45 degrees.
						       
						       [90,    // X.
							15,    // Z.
							3,     // D.
							5,     // fn.
							-90],  // Can rotate positive or negative.

						       // A 'round' hole. No need to rotate a round hole.
						       [50,
							35,
							12,
							128], // fn=128, Smooth finish.

						       // Combine three holes to make an oddly shaped hole.
						       [50,10,10,128], // A round hole.
						       [45,10,5,4,45], // Rotate a square 45 degrees.
						       [55,10,5,48]    // Given 48 fractions but no rotate.
				    ],
			       footer_thickness=2,
			       footer_holes_xyd_matrix=[ [20,     // X position on footer.
							  6,      // Y position on footer.
							  3.2,    // Hole Diameter.
							  12,     // Fragment number (fn) for this footer hole.
							  undef], // Rotate degrees.

							 // A hole with no fn, will become triangular since no $fn exists.
							 [40,
							  6,
							  3.2], // Diameter. No fn, so undef. No rotate, so undef.

							 // A hexagonal hole.
							 [50,
							  6,
							  5.5,
							  6],  // Hexagonal.
							 
							 // A triangular hole, but rotated 180 degrees.
							 [60,
							  6,
							  3.2,
							  3,     // fn=3 makes triangular.
							  180],  // Rotate 180 degrees.
							 
							 [80,
							  6,
							  3.2,
							  24,
							  0]    // Rotate zero degrees.
				    ],
			       verbosity=2); // Could add $fn here, to be used when no specific 'fn' is given for a hole.


// EOF.
