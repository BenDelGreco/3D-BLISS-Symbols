// Base Diameter
cyl_diameter = 80;
// Base Heigth
cyl_height = 15;

// Bottom Cut Settings
cut_fraction = 0.75; // Determines WHERE the curved surface starts

// SVG Bliss Symbol
image_path = "example.svg"; // <-- YOUR SVG FILE PATH HERE
// Symbol Height
image_extrude_height = 3;
// Symbol Size
image_scale_factor = 0.6;
// Symbol Thickness
image_line_thickness = 1.0;
// Symbol rotation in degrees (0-360)
image_rotation = 0; // Change this value to rotate the SVG on the top surface

// Bottom Text
bottom_text_string = "EXAMPLE";
// Bottom Text Size
bottom_text_size = 4; // Size might need adjustment for curve
// Bottom Text Font
bottom_text_font = "Liberation Sans"; // Font name (MUST be installed!)
// Bottom Text Dtpth
bottom_text_cut_depth = 1.0; // How deep the text is CUT INTO the surface (mm)

// Text Placement & Orientation
bottom_text_ref_angle = 0; // Degrees

// 2. Position Offset: Fine-tune position relative to ref point [X, Y, Z] (mm)
//    X: Sideways along curve, Y: Up/Down cylinder height, Z: In/Out from surface
bottom_text_pos_offset = [0, 8, 30];

// 3. Rotation Offset: Rotate text relative to surface normal [X, Y, Z] (degrees)
//    X: Tilt Up/Down along the curve
//    Y: Rotate around the normal (spin)
//    Z: Tilt Left/Right along the curve
bottom_text_rot_offset = [-90, 180, 90];

// Render Quality
render_quality = 75; // Higher = smoother






// Module Definitions


// Module for base cylinder with cut
module base_cylinder_with_cut(diameter, height, cut_frac, quality) {
    radius = diameter / 2;
    cut_y_level = cut_frac * radius;
    cut_cube_size = diameter * 1.5;
    difference() {
        cylinder(h = height, r = radius, $fn=quality);
        translate([-cut_cube_size/2, cut_y_level, -1])
            cube([cut_cube_size, cut_cube_size, height + 2]);
    }
}

// Module for top image outline with rotation parameter
module extruded_image_outline(file, extrude_height, scale_factor, line_thickness, rotation, quality) {
    safe_thickness = max(0.01, line_thickness);
    linear_extrude(height = extrude_height) {
        difference() {
            // Apply rotation to the offset shapes
            rotate([0, 0, rotation]) {
                offset(delta = safe_thickness / 2, $fn = quality) {
                    scale([scale_factor, scale_factor, 1]) import(file = file, center = true);
                }
            }
            rotate([0, 0, rotation]) {
                offset(delta = -safe_thickness / 2, $fn = quality) {
                    scale([scale_factor, scale_factor, 1]) import(file = file, center = true);
                }
            }
        }
    }
}


// Module to create the text shape
module cutting_text_tool(text_str, size, font, tool_height, quality) {
    // Make tool tall enough to cut through specified depth + a margin
    actual_tool_height = tool_height;
     linear_extrude(height = actual_tool_height, center = true) { // Center=true is key
        text(text = text_str, size = size, font = font,
             halign = "center", valign = "center", $fn = max(8, quality / 4));
    }
}


// Main


// Text Placement
cyl_radius = cyl_diameter / 2;
cut_angle_max = acos(cut_fraction); // Max angle where cut starts
actual_angle_on_cyl = 90 - clamp(bottom_text_ref_angle, -cut_angle_max, cut_angle_max);

// Ref Point on top edge of cylinder curve
ref_point_x = cyl_radius * cos(actual_angle_on_cyl);
ref_point_y = cyl_radius * sin(actual_angle_on_cyl);
ref_point_z = cyl_height; // Reference Z at the top edge
ref_point = [ref_point_x, ref_point_y, ref_point_z];

// Initial Rotation to align tool's Z axis with surface normal
normal_align_rot_z = actual_angle_on_cyl - 90;
normal_align_rot_y = -90;

// Calculate required height for the cutting tool
cutting_tool_total_height = bottom_text_cut_depth * 2 + 2;

//Create the final object using difference
difference() {
    union() {
        base_cylinder_with_cut(
            diameter = cyl_diameter,
            height = cyl_height,
            cut_frac = cut_fraction,
            quality = render_quality
        );

        translate([0, 0, cyl_height]) {
            extruded_image_outline(
                file = image_path,
                extrude_height = image_extrude_height,
                scale_factor = image_scale_factor,
                line_thickness = image_line_thickness,
                rotation = image_rotation,  
                quality = render_quality
            );
        }
    } 
    translate(ref_point) 
        rotate(bottom_text_rot_offset)
            rotate([0, normal_align_rot_y, normal_align_rot_z])
                translate(bottom_text_pos_offset)
                    cutting_text_tool( 
                        text_str = bottom_text_string,
                        size = bottom_text_size,
                        font = bottom_text_font,
                        tool_height = cutting_tool_total_height, 
                        quality = render_quality
                    );

}
