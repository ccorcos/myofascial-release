// 1 = inch

// Parameters
actualPeakSpace = 4;
actualPeakHeight = 6;
smoothingSize = 0.4;
podiumHeight = 1;

scaffoldThickness = 0.05;
scaffoldSeparation = 0.3;

$fn=16;


// Derived variables
peakHeight = actualPeakHeight - smoothingSize * 2;
peakWidth = 0.2*actualPeakHeight - smoothingSize*2;
triangleBase = 0.7*peakHeight;

depth = peakHeight - 2*smoothingSize;

innerSpace = actualPeakSpace - peakWidth - 2 * smoothingSize;

sphereRadius = peakWidth/2;

profileRadius = depth/2 * 0.75;

triangleBaseOffset = peakWidth/4;



// ===============================================


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
			cube([small, podiumHeight, depth - sphereRadius*2]);
		};

		sphere(sphereRadius);
	};
};


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
					smoothingSize
				])
				cube([
					triangleBase - smoothingSize*2,
					0.01,
					depth - smoothingSize*2]);

				sphere(smoothingSize);
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

module betterLeftNub() {
	translate([-peakWidth, 0, 0])
	betterNub();
}

module betterRightNub() {
	translate([innerSpace, 0, 0])
	mirror([1,0,0])
	betterLeftNub();
}


module platformPlane() {
	translate([-5, 0, -5])
			cube([20, podiumHeight, 20]);
}

module platform() {
	hull() {
		intersection() {
			platformPlane();
			betterLeftNub();
		};

		intersection() {
			platformPlane();
			betterRightNub();
		};
	};
}

module roughObject() {
	union() {
		platform();

		difference() {
			betterLeftNub();
			platformPlane();
		};

		difference() {
			betterRightNub();
			platformPlane();
		};
	};
}


big = 100;


module lattice() {
	union() {
		for (i = [0:scaffoldSeparation:big-2]) {
			translate([i+1, 0, 0])
			cube([scaffoldThickness, big, big]);
		}

		for (i = [0:scaffoldSeparation:big-2]) {
			translate([0, i+1, 0])
			cube([big, scaffoldThickness, big-2]);
		}

		for (i = [0:scaffoldSeparation:big-2]) {
			translate([0, 0, i+1])
			cube([big, big, scaffoldThickness]);
		}
	}
}

module scaffold() {
	rotate([0, 45, 0])
	rotate([45, 0, 0])
	translate([-big/2, -big/2, -big/2])
	lattice();
}

// lattice();

// rotate([90, 0, 0])
// union() {
// 	difference() {
// 		minkowski () {
// 			roughObject();
// 			sphere(smoothingSize);
// 		};

// 		roughObject();
// 	};

// 	intersection() {
// 		scaffold();
// 		roughObject();
// 	};
// }
