// 1 = inch


actualPeakHeight = 4;
smoothing = 0.1;

peakHeight = actualPeakHeight - smoothing * 2;
peakWidth = 0.2*peakHeight;
triangleBase = 0.7*peakHeight;

depth = peakHeight;

peakSpace = 6;
innerSpace = peakSpace - peakWidth - 2 * smoothing;
podium = 0.3;


$fn=50;

module triangle (size) {
	translate([-size/2, 0, 0]) // centered X
	scale([size, size, 1])
	polygon([
		[0,0],
		[0.5, sqrt(3)/2],
		[1,0],
	]);
}

triangleBaseOffset = peakWidth/4;

module nub() {
	translate([triangleBaseOffset, 0, 0])
		triangle(triangleBase);

	square([peakWidth, peakHeight-peakWidth/2]);

	translate([peakWidth/2, peakHeight-peakWidth/2])
		circle(peakWidth/2);
}

module leftNub() {
	translate([-peakWidth, 0, 0])
		nub();
}

module rightNub() {
	translate([peakWidth, 0, 0])
		mirror([1,0,0])
		nub();
}

module top() {
	leftNub();
	translate([innerSpace, 0, 0])
		rightNub();

	square([innerSpace, peakWidth]);
}


// module bottom() {
// 	translate([-peakWidth + triangleBaseOffset - triangleBase/2, -podium])
// 	square([innerSpace + peakWidth * 2 + (triangleBase/2 - triangleBaseOffset)*2, podium]);
// }


big = 20;
profileRadius = depth/2 * 0.75;

module profile() {
	hull() {
		translate([-big/2, 0, 0])
		translate([0, peakHeight - profileRadius, depth/2])
		rotate([0, 90, 0])
		cylinder(big, profileRadius, profileRadius);

		translate([-big/2, 0, 0])
		cube([big, podium, depth]);
	};
};



// color("#e08b60")
// minkowski() {

// 	intersection() {
// 		linear_extrude(depth)
// 		top();

// 		profile();
// 	};

// 	sphere(smoothing);
// };


// r = peakWidth / 2;
// dx = 0.02;

// module peakHalf () {
// 	for (i = [0:dx:r]) {
// 		rr = profileRadius - i;
// 		translate([i,0,0])
// 		hull() {
// 			translate([-dx/2, 0, 0])
// 			translate([0, peakHeight - rr  -  sin(i * (90/r) - 90)/2, depth/2])
// 			rotate([0, 90, 0])
// 			cylinder(dx, rr, rr);

// 			translate([-dx/2, 0, 0])
// 			cube([dx, podium, depth]);
// 		};
// 	};
// };

// peakHalf();
// mirror([1,0,0])
// peakHalf();






sphereRadius = peakWidth/2;

module roundNub() {
	small = 0.00001;
	translate([sphereRadius, 0, 0])
	minkowski () {

		hull() {
			translate([-small/2, 0, 0])
			translate([0, peakHeight - profileRadius, depth/2])
			rotate([0, 90, 0])
			cylinder(small, profileRadius - sphereRadius, profileRadius - sphereRadius);

			translate([-small/2, 0, sphereRadius])
			cube([small, podium, depth - sphereRadius*2]);
		};

		sphere(sphereRadius);
	};
};




smallSphereRadius = sphereRadius/2;

module profile2() {
	hull() {
		translate([-big/2, 0, 0])
		translate([0, peakHeight - profileRadius, depth/2])
		rotate([0, 90, 0])
		cylinder(big, profileRadius - smallSphereRadius, profileRadius - smallSphereRadius);

		translate([-big/2, 0, smallSphereRadius])
		cube([big, podium, depth - smallSphereRadius*2]);
	};
};



module support() {
	minkowski()  {
		intersection() {
			linear_extrude(depth)
				translate([triangleBaseOffset, 0, 0])
				triangle(triangleBase);

			profile2();
		};

		sphere(sphereRadius/2);
	};
}

module nub2() {

	support();

	// color("green", 0.5)
	difference() {
		roundNub();
		translate([-3, -1, -3])
		cube([10,1, 10]);
	};

}

// nub2();



module support2() {
	minkowski()  {
		intersection() {
			linear_extrude(depth)
				translate([triangleBaseOffset, 0, 0])
				triangle(triangleBase);

			profile2();
		};

		sphere(sphereRadius/2);
	};
}






module nubDisk() {
	difference() {
		roundNub();
		translate([-3, -1, -3])
		cube([10,1, 10]);
	};

}


module nubBase() {
	difference() {
		hull() {
			minkowski() {
				color("green")
				translate([
					-triangleBase/2 + triangleBaseOffset,
					0,
					smallSphereRadius
				])
				cube([
					triangleBase - smallSphereRadius*2,
					0.01,
					depth - smallSphereRadius*2]);

				sphere(smallSphereRadius);
			};

			intersection() {
				translate([-3, peakHeight*0.55 - 0.01, -3])
					cube([10,0.01, 10]);
				nubDisk();
			};
		};

		translate([-3, -1, -3])
			cube([10,1, 10]);
	};

};

module nubTop() {
	intersection() {
		translate([-3, peakHeight*0.55, -3])
			cube([10,10, 10]);
		nubDisk();
	};
};


module betterNub() {
	union() {
		nubBase();
		nubTop();
	};
};

betterNub();

// translate([-3, peakHeight*0.4, -3])
// 	cube([10,0.01, 10]);
	// nubDisk();

// color("blue", 0.5) nub();