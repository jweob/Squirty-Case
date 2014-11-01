// Squirty Case
// 1st Nov 2014
// by jweob, www.jweoblog.com


//SmD is a small number used to make sure parts attach/detach properly and that edges render
SmD = 0.001;

CaseX = 376;
CaseY = 353;
CaseZ = 308;
CaseT = 3;
HandleSpace = 265;
HandleThick = 18;
VentLength = 40;

PerspexColor = [176/255,196/255,222/255,.5];
PLAColor = "red";

use <HandleMod.scad>;
use <VentMod.scad>;
use <VentMiddleMod.scad>;
//Slider, VentTopBox, VentTopBox, SlideBox

//ASSEMBLY MODULES

//Perspex Lid
//Produce case lid perspex
module CaseLidPersp(xdim, ydim, zdim, tdim){
	//Origin is bottom left outside corner

	//Front sheet
	translate([tdim,0,0])
		color(PerspexColor)
		cube([xdim-2*tdim-SmD, tdim, zdim-tdim-SmD]);

	//Back sheet
	translate([tdim, ydim-tdim, 0])
		cube([xdim-2*tdim-SmD, tdim, zdim-tdim-SmD]);

	//Right sheet
	translate([xdim-tdim,0,0])
		cube([tdim, ydim, zdim-tdim]);

	//Top sheet
	translate([0,0,zdim-tdim])
		cube([xdim, ydim, tdim]);
}

//Handle Assembly
module HandleAssembly(){
	HandleHeight = (80-35/2);
	HandleLen = 254;
	HandleRad = 10;
	HandleThick = 2;


	module HandlePersp(){
		difference(){
			cylinder(h=HandleLen, r=HandleRad);
			translate([0,-SmD,0])
				cylinder(h=HandleLen+SmD*2, r=(HandleRad-HandleThick));
		}
	}

	translate([0,0,0])
	rotate([90,0,90])
		color("red") Handle();

	translate([HandleSpace, 0, 0])
		rotate([90,0,-90])
			color("red") Handle();

	translate([(HandleSpace-HandleLen)/2, 0, HandleHeight])
		rotate([0, 90, 0])
			color(PerspexColor)
				HandlePersp();

}

color(PerspexColor)
	CaseLidPersp(CaseX,CaseY,CaseZ,CaseT);


translate([(CaseX-HandleSpace)/2,CaseY/2,CaseZ])
	HandleAssembly();

module VentAssembly(){
	VentWidth = 110;
	VentHeight1 = 5;

	module VentSide(){
		nVanes = 20;
		VentGuide = 2;
		VentFrame = 2;
		VentSpace = .7;
		VentSkew = .8;
		FitTol = 0.3;
		SlideTol = 0.3;
		PerspexWidth = 3;
		SmallNum = 0.001;
		HandleWidth = 10;
	
		translate([VentFrame+FitTol,VentFrame*2+FitTol*2, VentHeight1])
			rotate([0,0,0])
				Slider(nVanes, VentWidth-VentFrame*2-FitTol*2, VentLength-VentFrame*2, VentHeight1-FitTol-VentFrame, VentFrame, HandleWidth, VentGuide);
	
		translate([0,VentLength,2*VentHeight1]) 
			rotate([180,0,0])	
				SlideBox(nVanes,VentWidth, VentLength, VentHeight1, VentFrame,VentGuide);
	
		translate([0,VentLength,VentHeight1]) 
			rotate([180,0,0])
			VentTopBox(nVanes,VentWidth, VentLength, VentHeight1, VentFrame,VentGuide);
	
	}

	color(PLAColor) 
			translate([VentHeight1,VentWidth+CaseT, 0])
				rotate([90,0,-90])
					VentSide();
	color(PLAColor) 
			translate([VentHeight1,(CaseY-CaseT)-VentWidth,VentLength])
				rotate([90,180,-90])
					VentSide();
	color(PLAColor) 
		translate([+3.5-VentHeight1,CaseY-VentWidth-CaseT,0])
			rotate([90,0,-90])
				Middle();
	
	color(PLAColor) 
		translate([VentHeight1,CaseY-VentWidth-CaseT,0])
			rotate([90,0,-90])
				Middle();

	color(PerspexColor)
		translate([-1.5,VentWidth+CaseT,0])
			cube([CaseT, (CaseY-2*CaseT) - 2*VentWidth, VentLength]);


};

translate([0,0,CaseZ-VentLength-CaseT])
	rotate([0,0,0])
		VentAssembly();



