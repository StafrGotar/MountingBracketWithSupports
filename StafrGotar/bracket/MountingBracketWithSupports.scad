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
* How to use it.
* ==============
* If you <include> this module into your OpenSCAD file, the default demo object will be produced.
* This is probably not what you want long term.
* But it's a good way to visualize what the module can provide.
* If you <use> this module from your OpenSCAD file, then the module will *not* be instantiated,
* but you must instantiate it from your own code.
*
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
* in a default camera position.
*
*
* Parameters.
* ===========
* l => Length. That's a lower case 'L'. Size from origin along the X axis.
*      Must be greater than zero.
*      Must be at least 2 times the wall_thickness (see below).
*
* w => Width. Size from the origin along the Y axis, as measured on Z=0.
*      Must be greater than zero.
*
* h => Height. Size above Z=0.
*      Must be a positive number.
*      If 'h' is exactly zero, then a gentle reminder warning is issued and no bracket is created.
*      See that as a possibility to temporary suppress the creation of the Bracket object.
*
* wall_thickness => The thickness of the face-plate and the two triangular supports.
*                   Must be greater than zero.
*
* wall_holes_xzd_matrix => Matrix, a vector of vectors.
*                          For each hole to punch through the face wall, a vector of 3 elements [x,z,d].
*                          'x' position, 'z' position, hole 'd'iameter.
*                          Three different holes at given positions could be provided as:
*                          wall_holes_xzd_matrix=[ [10,15,3], [50,25,10], [90,15,3] ]
*                          Default is 'no holes', i.e. an empty vector. Like this: wall_holes_xzd_matrix=[]
*
* footer_thickness => The thickness of the footer. If set to zero, then no footer is produced.
*                     May not be negative.
*                     A footer makes sense for instance if the Mounting Bracket is going to be 3D-printed as a separate
*                     part and then bolted to some 'main object' of yours.
*                     If the Mounting Bracket will be 3D-printed together with some 'main object', in one combined print,
*                     then the footer can be omitted by setting its thickness to zero.
*
* footer_holes_xyd_matrix => Matrix, a vector of vectors.
*                            For each mounting hole to punch through the footer, a vector of 3 elements [x,y,d].
*                            'x' position, 'y' position, hole 'd'iameter.
*                            Three holes for M3 screws at given positions could be provided as:
*                            footer_holes_xyd_matrix=[ [20,6,3.2], [45,6,3.2], [80,6,3.2] ]
*                            Default is 'no footer holes', i.e. an empty vector. Like this: footer_holes_xyd_matrix=[]
*
* verbosity => A positive integer value to request 'debug' information to be displayed during the instantiation of the object.
*              Default is '0' (zero), which is equal to 'quiet'.
*
****************************************************************************************************************************/

/*
 Demo driver, activated by <include>.
 Use <use> to not show the demo.
*/
Mounting_Bracket_With_Supports(l=100,
			       w=10,
			       h=50,
			       wall_thickness=1,
			       wall_holes_xzd_matrix=[ [10,15,3], [50,25,10], [90,15,3] ],
			       footer_thickness=1,
			       footer_holes_xyd_matrix=[ [20,6,3.2],[80,6,3.2] ],
			       verbosity=1,
			       $fn=24);


/*
 The external calling interface. Reasonable default values are set.
 By default, there are no mounting holes in the footer.
 To see footer holes, activate the demo above, using <include>.
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
     height_ratio=0.75;  // Could become a parameter.
     
     // Private module, 'protected' by scope.
     module Support_Wall_Triangle(h=30,w=10,t=wall_thickness) {
	  linear_extrude(height=t)
	       polygon(points=[ [0,0], [w,0], [0,h]]);
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
				   echo(str("Footer hole vector: [",hole[0],",",hole[1],",",hole[2],"]."));
			      }
			      translate([hole[0],hole[1],-pass_through])
				   cylinder(h=footer_thickness+(2*pass_through),
					    d=hole[2],
					    center=false);
			 }
		    }
	       }
	       // The face-plate.
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
			 Support_Wall_Triangle(h=h*height_ratio,w=w-wall_thickness);
		    // Right triangular support.
		    translate([l-wall_thickness,  // Off to the right.
			       wall_thickness,  // So it doesn't 'enter' the main wall.
			       0])
			 rotate([0,0,90]) // Twist around Z.
			 rotate([90,0,0]) // Stand up.
			 Support_Wall_Triangle(h=h*height_ratio,w=w-wall_thickness);
		    }
		    // Remove 'wall' holes from the face-plate.
		    // If screwholes are requested for the wall, punch the holes.
		    for(wall_hole=wall_holes_xzd_matrix) {
			 if(verbosity > 0) {
			      // Only upon explicit request.
			      echo(str("Wall hole vector: [",wall_hole[0],",",wall_hole[1],",",wall_hole[2],"]."));
			 }
			 translate([wall_hole[0],wall_thickness+pass_through,wall_hole[1]])
			      rotate([90,0,0])
			      cylinder(h=wall_thickness+(2*pass_through),
				       d=wall_hole[2],
				       center=false);
		    }
	       }
	  }
     }
}

// EOF.
