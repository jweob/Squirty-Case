01_Thick = 18;
02_Height = 80;
03_Full_Width = 80;
04_Central_Width = 35;
05_Bore_Diam = 20.3;
06_Bore_Depth = 15;
07_Base_Height = 12;

Bore_Radius = 05_Bore_Diam/2;
C_Radius = 04_Central_Width /2;
B_Radius = 07_Base_Height;
Fillet_Radius = 6;

04_Angle_A = 0;
05_Angle_B = 38.4093912;
06_Slot = 21;
07_Axis_Depth=25;
BigNum = 99;
SmallNum = 1;

module fillet(f_radius, f_height){
	translate([-f_radius*2,0,0])
		difference(){
			translate([0,-SmallNum,0])
				cube([f_radius*2+SmallNum, f_radius*2+SmallNum, f_height]);
			translate([f_radius, f_radius, -SmallNum])
				cylinder(r1 = f_radius, r2 = f_radius, h = BigNum);
			translate([-SmallNum, -SmallNum, -SmallNum])
				cube([f_radius+SmallNum, BigNum, BigNum]);
			translate([f_radius-SmallNum, f_radius, -SmallNum])
				cube([BigNum, f_radius+SmallNum, BigNum]);
			
		}
};




module Handle() {

	01_Thick = 18;
	02_Height = 80;
	03_Full_Width = 80;
	04_Central_Width = 35;
	05_Bore_Diam = 20.3;
	06_Bore_Depth = 15;
	07_Base_Height = 12;
	
	Bore_Radius = 05_Bore_Diam/2;
	C_Radius = 04_Central_Width /2;
	B_Radius = 07_Base_Height;
	Fillet_Radius = 6;
	
	04_Angle_A = 0;
	05_Angle_B = 38.4093912;
	06_Slot = 21;
	07_Axis_Depth=25;
	BigNum = 99;
	SmallNum = 1;

	// Half handle 
	module Half_Handle(){
		translate ([-03_Full_Width/2,0,0])
			difference(){
				union(){
					cube([03_Full_Width/2, 07_Base_Height, 01_Thick]);
					translate([03_Full_Width/2-04_Central_Width/2,0,0])
						cube([04_Central_Width/2, 02_Height-C_Radius, 01_Thick]);
					translate([03_Full_Width/2, 02_Height-C_Radius, 0])
						cylinder(r1 = C_Radius, r2 = C_Radius, h= 01_Thick);
					//fillet(
					
					translate([03_Full_Width/2-04_Central_Width/2,07_Base_Height,0])
						fillet(f_radius = Fillet_Radius, f_height = 01_Thick);
				
		
				}
				translate([0,07_Base_Height,-SmallNum])
					rotate([0,0,180])
						fillet(f_radius = Fillet_Radius, f_height = 01_Thick+SmallNum*2);
			}
		
	}
	
	
	// Main Shape
	difference(){
		union(){
			Half_Handle();
			mirror([1,0,0])
				Half_Handle();
		}
		translate([0,02_Height-C_Radius,01_Thick-06_Bore_Depth])
			cylinder(r1=05_Bore_Diam/2, r2=05_Bore_Diam/2, h=BigNum);
		union(){
		translate([0,02_Height-04_Central_Width-Bore_Radius,-SmallNum])
			cylinder(r1=Bore_Radius, r2=Bore_Radius, h=BigNum);
		translate([0,07_Base_Height+Bore_Radius,-SmallNum])
			cylinder(r1=Bore_Radius, r2=Bore_Radius, h=BigNum);
		translate([-Bore_Radius, 07_Base_Height+Bore_Radius,-SmallNum])
			cube([05_Bore_Diam, 02_Height-04_Central_Width-Bore_Radius-(07_Base_Height+Bore_Radius), BigNum]);
	
		}
		//Removal key
		translate([0,0,01_Thick/2]) rotate([0,45,0])translate([-1.5,-1.5,-1.5])  cube([3,5,3]);
	}
		
}

Handle(
	01_Thick, 
	02_Height, 
	03_Full_Width,
	04_Central_Width,
	05_Bore_Diam,
	06_Bore_Depth,
	07_Base_Height,
	04_Angle_A,
	05_Angle_B,
	06_Slot,
	07_Axis_Depth);

//Put this in to give little pivot for the removal key
//translate([-5,-6,0])
	//cube([10,5,01_Thick/2-1]);
