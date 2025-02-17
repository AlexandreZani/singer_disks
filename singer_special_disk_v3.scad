/*************************************************************************
    Singer Special Disc Creator v3
    Andreas Wileur (wileur@gmail.com) 2018

    Inspired by Leila at Grow Your Own Clothes
    https://growyourownclothes.com/2017/10/11/3-step-zig-zag-disc-for-singer-slant-machines/

    I made the hat with an edge to make it easer to pull out. Also, the disc has been designed
    to print well on a FDM printer without using supports.

    Usage:
        Put needle positions in the pattern in a list below.
        Ones represent the needle. Make sure there is only ONE 1 in each row.
        Press F5 to generate a quick render. Note! This doesn't always show the center holes properly.
        Press F6 to render for exporting.
        Save file to STL or OBJ and print on your printer
        If needed round off the edges with a file or sandpaper
        
    Text on disc:
        If you write some text in the name fields it will show up on the disc. Do a quick render
        to make sure it fits.
        
    Rotation:
        You can rotate the pattern by any number of steps. Just change the 0 
        on that line to whatever you like.
        
    Resolution:
        It is possible to change the granularity of the needle position by
        adding or removing positions to each row:
        "1.",
        ".1",
        
        or:
        "..........1...................................",
        ".....................................1........",

        Just make sure each row is the same length.
        
    Pattern handling:
        You can create several patterns in this file. Just copy one and change the first
        line where it says "something = [". Then write the same name further down where 
        it says "pattern = something"
        
        
    Important!
        -Always test a new disc by manually slowly turning the hand wheel.
            The wrong settings here can damage your machine!
        

*************************************************************************/


// This is the same as Singer special disc 22
disc22 = [
"1........",  // 1
"1........",  // 2
"1........",  // 3
"........1",  // 4
"1........",  // 5
"1........",  // 6
"1........",  // 7
"........1",  // 8
"1........",  // 9
"1........",  // 10
"1........",  // 11
"........1",  // 12
"1........",  // 13
"1........",  // 14
"1........",  // 15
"........1",  // 16
"1........",  // 17
"1........",  // 18
"1........",  // 19
"........1",  // 20
"1........",  // 21
"1........",  // 22
"1........",  // 23
"........1",  // 24
"Disc 22",   // Name
"Overcast",     // Name line 2
0               // Number of steps to rotate pattern
];

// Overedge stitch, stretch
overcast_zz_short = [
"1........",  // 1
"..1......",  // 2
"1........",  // 3
"..1......",  // 4
"1........",  // 5
"........1",  // 6
"1........",  // 7
"..1......",  // 8
"1........",  // 9
"..1......",  // 10
"1........",  // 11
"........1",  // 12
"1........",  // 13
"..1......",  // 14
"1........",  // 15
"..1......",  // 16
"1........",  // 17
"........1",  // 18
"1........",  // 19
"..1......",  // 20
"1........",  // 21
"..1......",  // 22
"1........",  // 23
"........1",  // 24
"Overcast",   // Name
"zz short",   // Name line 2
4               // Number of steps to rotate pattern
];


// Two step zig-zag
zz2step = [
".1.......",  // 1
"....1...",  // 2
".......1.",  // 3
"....1....",  // 4
".1.......",  // 5
"....1....",  // 6
".......1.",  // 7
"....1....",  // 8
".1.......",  // 9
"....1....",  // 10
".......1.",  // 11
"....1....",  // 12
".1.......",  // 13
"....1....",  // 14
".......1.",  // 15
"....1....",  // 16
".1.......",  // 17
"....1....",  // 18
".......1.",  // 19
"....1....",  // 20
".1.......",  // 21
"....1....",  // 22
".......1.",  // 23
"....1....",  // 24
"Zig Zag",  // Name
"2 step",   // Name line 2
0             // Number of steps to rotate pattern
];



/*************************************************************************
    Select a pattern to use
    pattern = some_pattern
*************************************************************************/
pattern = overcast_zz_short;
//pattern = zz2step;
//pattern  = disc22;


/*************************************************************************
    These values can be edited carefully depending on printer 
*************************************************************************/
minimum_diameter = 52.8;    // Minimum diamter of disc pattern, default 52.8
maximum_diameter = 58.0;    // Maximum diameter of disc, default 57.7
guide_hole_dia = 10.0;      // The hole for the guide pin, default 10.0
center_dia = 21.4;          // Bottom center hole diameter, measured on disc to be 20.8
center_dia_2 = 14.6;        // Middle center hole diameter, default 14.6


/*************************************************************************
    Do not edit the part below!
*************************************************************************/
$fn = 100;              // Number of segments of a circle
rmin = minimum_diameter/2;
rmax = maximum_diameter/2;
center_dia_3 = 19.6;    // Top part dia
center_hole_offset = 13;    // Bottom offset of top hole
disc_thickness = 3.4;   // Thickness of disc
small_hole_dia = 5.0;   // Hole to the right
small_hole_offset = 21.05;
guide_hole_offset = 18.26;
hat_dia = 27;           // Outer dia of the hat
hat_height = 13.6;
center_hole_depth = 10.4-4;   // From bottom of disc
angle_correction = 85+pattern[26]*15;  // This aligns the pattern properly and puts step one at the top

textX = 0;
textY = -15.5;
textZ = disc_thickness;
textHeight = 0.4;
textSize = 5;

// Calculate range of needle movement, invert since smaller disc means needle movement to the right
needle_range = rmin-rmax;
// Create modifier list based on number of fields in first row of pattern
//modifier = concat([for(n = [0:1/(len(pattern[0])-1):1]) n], 1);
modifier = [for(n = [0:1:len(pattern[0])-1]) n*(1/(len(pattern[0])-1))];
// Create list filled with the minimum radius to offset pattern
minimum = [for(n = [1:1:24]) rmin];
// Create pattern list from strings
pattern_temp = [for(n=[0:1:23]) search("1", pattern[n])]; 
// Remove one layer of vectors
pattern_temp2 = [for(n=[0:1:23]) pattern_temp[n][0]]; 
// Create list of radii
list = [for(n=[0:1:23]) rmax + modifier[pattern_temp2[n]]*needle_range];

// Function to generate points
// Index in needle position list
// Offset from the start angle, should be 10 for the second point in a pair
function point(index, o) = [
    list[index]*cos(index*15+o),
    list[index]*sin(index*15+o),
]; 


// generate list of points 
p1 = [for(i = [0:1:23]) point(i, angle_correction+0)]; 
p2 = [for(i = [0:1:23]) point(i, angle_correction+10)];  
point_list = concat(p1,p2);

// List of paths, connects points in pairs
path_list = [[0,24,1,25,2,26,3,27,4,28,5,29,6,30,7,31,8,32,9,33,10,34,11,35,12,36,13,37,14,38,15,39,16,40,17,41,18,42,19,43,20,44,21,45,22,46,23,47,0]];



module inner() {
    translate([0,0,0]) cylinder(center_hole_depth, center_dia/2, center_dia/2);
    // Inner slope
    translate([0,0,center_hole_depth]) 
        cylinder(4, center_dia/2, center_dia_2/2);
    cylinder(30, center_dia_2/2, center_dia_2/2);
    translate([0,0,center_hole_offset]) cylinder(disc_thickness+hat_height-center_hole_offset+0.1, center_dia_3/2, center_dia_3/2+2);
    
    // Add a little slope to the bottom
    translate([0,0,0]) cylinder(1, center_dia/2+0.5, center_dia/2);
}

// The actual disc
module disc() {
    difference() {
        union() {
            linear_extrude(height=disc_thickness) {
                polygon(point_list, path_list); 
            }
            translate([0,0,disc_thickness]) {
                cylinder(hat_height, hat_dia/2, hat_dia/2);
            }
            
            // "handle"
            translate([0,0,disc_thickness+hat_height-4]) cylinder(3, hat_dia/2, hat_dia/2+1);
            translate([0,0,disc_thickness+hat_height-1]) cylinder(1, hat_dia/2+1, hat_dia/2);
            
        }
        color("green") inner();

        // Upper hole
        hull() {
            translate([0,guide_hole_offset,0]) cylinder(disc_thickness, guide_hole_dia/2, guide_hole_dia/2);
            translate([0,18.5,-1])cylinder(disc_thickness+1, guide_hole_dia/2, guide_hole_dia/2);
        }
        hull() {
            translate([0,guide_hole_offset,0]) cylinder(1, guide_hole_dia/2+0.5, guide_hole_dia/2);
            translate([0,18.5,])cylinder(disc_thickness, guide_hole_dia/2+0.5, guide_hole_dia/2);
        }
        
        // Right hole, only make a shallow indentation
        //translate([small_hole_offset,0,0]) cylinder(30, small_hole_dia/2, small_hole_dia/2);
        translate([small_hole_offset,0,disc_thickness-0.5]) cylinder(30, small_hole_dia/2, small_hole_dia/2);
    }
    
    // Text
    translate([textX, textY, textZ]) rotate([0,0,0]) linear_extrude(height=textHeight) {
        text(text=pattern[24],size=textSize,halign="center", valign="center",font="MV Boli:style=Bold");
    }
    translate([textX, textY-textSize, textZ]) rotate([0,0,0]) linear_extrude(height=textHeight) {
        text(text=pattern[25],size=textSize,halign="center", valign="center",font="MV Boli:style=Bold");
    }
}

disc();
//color("green") inner();