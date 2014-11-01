nVanes = 20;
VentWidth = 110;
VentLength = 40;
VentHeight1 = 5;
VentGuide = 2;
VentFrame = 2;
VentSpace = .7;
VentSkew = .8;
FitTol = 0.3;
SlideTol = 0.3;
PerspexWidth = 3;
SmallNum = 0.001;
HandleWidth = 10;
Frame = VentFrame;

module Vane(Width, Length, Height, Skew){


polyhedron(
	points=	[	[0,0,0],							// 0
					[Width,0,0], 					// 1
					[Width, Length,0],			// 2
					[0, Length, 0],				// 3
					[Skew, 0, Height],			// 4
					[Skew+Width, 0, Height],	// 5
					[Skew+Width, Length, Height], //6
					[Skew, Length, Height]			//7
				],
	faces=	[	[1,2,3,0], //A
					[5,6,2,1], //B
					[6,7,3,2], //C
					[7,4,0,3], // D
					[4,5,1,0], // E
					[7,6,5,4]  // F
					
				]
				);
};

module Chamfer(Width, Length, Height){
	polyhedron(
		points = 	[
							[0,0,0], 		//0
							[Width, 0,0],	//1
							[Width, Length, 0,],	//2
							[0, Length, 0],		//3
							[0,0,Height],
							[Width, 0, Height]
						],

		faces =		[
							[0,1,2,3],		//A
							[1,5,2],			//B
							[4,0,3],			//C
							[5,4,3,2],		//D
							[4,5,1,0]
						]
					);


};


module Slider(nVanes, Width, Length, Height, Frame, HandleWidth, GuideWidth){
	VaneWidth = (Width-Frame*2)/(nVanes*(1+VentSpace));
union(){
//			echo("Slider VaneWidth", VaneWidth);
		//VANES
		for(i = [0:(nVanes-1)]){
			translate([VaneWidth*(1+VentSpace)*(i)+Frame-SmallNum,0,0]) Vane(VaneWidth, Length-SlideTol*2-GuideWidth*2, Height, VaneWidth*VentSkew);
		}; //End For
		//FRAME
		difference(){
			cube([Width, Length-SlideTol*2-GuideWidth*2, Height]);
			translate([Frame, Frame,-SmallNum]) cube([(Width-Frame*2), (Length-Frame*2-GuideWidth*2), Height+SmallNum*2]);
		//Removal key
		translate([0,Length/2,0]) rotate([45,0,0]) translate([-1,-1,-1]) cube([5,2,2]);

		}; //End Difference
		//HANDLE
		translate([Width-SmallNum,0,0]) difference(){
			cube([HandleWidth+SmallNum, Length-SlideTol*2-GuideWidth*2, Height]);
			translate([Frame, Frame, -SmallNum]) cube([(HandleWidth-Frame*2), (Length-Frame*2-GuideWidth*2), Height+SmallNum*2]);
			echo("Slider HandleWidth", Length-SlideTol*2-GuideWidth*2);
		}; //End Diffference 
		//SLIDEGUIDE
		translate([0,-GuideWidth+SlideTol, 0]) cube([Width-Frame-VaneWidth*VentSpace-FitTol,GuideWidth-SlideTol, Height]);
		translate([0,Length-SlideTol*2-GuideWidth*2, 0]) cube([Width-Frame-VaneWidth*VentSpace-FitTol,GuideWidth-SlideTol, Height]);
	};
};

module SlideBox(nVanes, Width, Length, Height, Frame, GuideWidth){
	VaneWidth = (VentWidth-Frame*4-FitTol*2)/(nVanes*(1+VentSpace));
union(){
	difference(){
		cube([Width, Length, Height]);
		translate([Frame, Frame, Frame]) cube([Width-Frame*2, Length-Frame*2, Height-Frame]); //Main Slidey Area
		/*translate([Width-Frame-VaneWidth*VentSpace, Frame+GuideWidth, Frame]) cube([VaneWidth, Length-(GuideWidth+Frame)*2, Height-Frame]); //SlideStopperArea*/
		echo("SlideBox VaneWidth", VaneWidth); //SlideStopperArea
		translate([Frame,Frame+GuideWidth,Frame]) cube([Width-Frame,Length-(Frame+GuideWidth)*2, Height-Frame]);
//	echo("SlideBox HandleWidth", Length-(Frame+GuideWidth)*2); //SlideStopperArea
		translate([Frame*2, Frame*2, 0]) cube([Width-Frame*4,Length-Frame*4,Frame]);
		//Removal key
		translate([0,Length/2,0]) rotate([45,0,0]) translate([-1,-1,-1]) cube([5,2,2]);

	}; //End difference
	};
};

module VentTopBox(nVanes, Width, Length, Height, Frame, GuideWidth){
	VaneWidth = (VentWidth-Frame*4-FitTol*2)/(nVanes*(1+VentSpace));
union(){
			//VANES
		translate([Frame,0,0])
			for(i = [0:(nVanes-1)]){
				translate([VaneWidth*(1+VentSpace)*(i)+Frame+VaneWidth*VentSkew-SmallNum,0,0]) Vane(VaneWidth, Length, Height, -VaneWidth*VentSkew);
			}; //End For
		difference(){
			cube([Width, Length, Height]);
	/*		translate([Frame, Frame, Frame]) cube([Width-Frame*2, Length-Frame*2, Height-Frame]); //Main Slidey Area
	*/
//			echo("SlideBox VaneWidth", VaneWidth); //SlideStopperArea
			translate([Frame*2, Frame*2, -SmallNum]) cube([Width-Frame*4-FitTol*2,Length-Frame*4,Height+SmallNum*2]); //Hole
		//Removal key
		translate([0,Length/2,0]) rotate([45,0,0]) translate([-1,-1,-1]) cube([5,2,2]);

		}; //End difference
		translate([Width-SmallNum,0,0]) cube([PerspexWidth+SmallNum, Length,PerspexWidth]);
	};
};




Slider(nVanes, VentWidth-VentFrame*2-FitTol*2, VentLength-VentFrame*2, VentHeight1-FitTol-VentFrame, VentFrame, HandleWidth, VentGuide);

translate([0,VentLength+2,0]) SlideBox(nVanes,VentWidth, VentLength, VentHeight1, VentFrame,VentGuide);

translate([0,(VentLength+2)*2,0]) VentTopBox(nVanes,VentWidth, VentLength, VentHeight1, VentFrame,VentGuide);

//translate([0,50,0]) Chamfer(100,5,20);

//translate(20,0,0) Vane(5, 30, 10, 2.5);