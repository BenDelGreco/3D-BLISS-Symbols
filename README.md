
# Bliss 3D Symbols

A simple OpenSCAD script for creating 3D BLISS symbols for deafblind people with:

-   Customizable base dimensions
-   Custom 3D BLISS symbol integration
-   Text based Symbol description for caregivers and communication partners


## Overview

This OpenSCAD script creates custom 3D BLISS symbols with integrated text. The 3D base can be configured with a BLISS symbol that can be extruded on the base surface to make it accessible for deafblind users.

## Requirements

-   [OpenSCAD](https://openscad.org/) (latest version recommended)
-    Download the [BLISS Symbol Library](https://www.blissymbolics.org/) as SVG files
-   Fonts installed on your system for the integrated text

## Installation

1.  Save the `.scad` file to your computer
2.  Prepare an SVG file for the top symbol image
3.  Open the file in OpenSCAD

## Usage Guide

### Quick Start

1.  Open the `.scad` file in OpenSCAD
2.  Update the `image_path` parameter to point to your SVG file
3.  Set your desired text in `bottom_text_string`
4.  Preview with F5, Render with F6, Export with F7


## Troubleshooting


### Common Issues

1.  **Text Not Appearing or Misplaced**:
    
    -   Verify the font is installed on your system
    -   Ensure `bottom_text_string` contains text
    -   Try adjusting the `bottom_text_size` (may need to be smaller for tight curves)
    -   Check Z value in `bottom_text_pos_offset` (should be larger than cylinder radius)
2.  **SVG Import Errors**:
    
    -   Ensure SVG is properly formatted and has proper paths
    -   Check that the file path in `image_path` is correct
    - For easier use, ensure the .scad file is in the same folder as your svg file
    -   Try simplifying the SVG if it's very complex
3.  **Rendering Performance**:
    
    -   Reduce `render_quality` for faster previews
    -   Use a simpler SVG for testing
    -   For final renders, increase OpenSCAD's memory allocation in preferences



## License

This project is available under the MIT License.


