use <write/Write.scad>; //Writing library by HarlanDMii, published	 Jan 18, 2012. From Thingiverse

module Middle(){
	difference(){
		cube([127, 40, 3.5]);
		translate([127/2,40/2,-1])
			write("Squirty",h=20,t=20,font="orbitron.dxf",space=1, center = true);
	};
};

Middle();