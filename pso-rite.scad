// 1 = inch


actualPeakHeight = 5;
smoothing = 0.1;

peakHeight = actualPeakHeight - smoothing * 2;
peakWidth = 0.2*actualPeakHeight - smoothing*2;
triangleBase = 0.7*peakHeight;

depth = peakHeight;

peakSpace = 6;
innerSpace = peakSpace - peakWidth - 2 * smoothing;
podium = 1;

sphereRadius = peakWidth/2;
smallSphereRadius = sphereRadius/2;


profileRadius = depth/2 * 0.75;

triangleBaseOffset = peakWidth/4;

// $fn=40;
$fn=16;


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
			cube([small, podium, depth - sphereRadius*2]);
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
			cube([20, podium, 20]);
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


minkowski () {
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

	sphere(smallSphereRadius);
};
