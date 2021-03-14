const { exec } = require("child_process");

const cli = "~/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD";

const widths = [4, 5, 6, 7, 8, 9, 10, 11];

for (const width of widths) {
  const cmd = `${cli} -o stl/pso-${width}.stl -D 'actualPeakSpace = ${width}' pso.scad`;

  console.log("+", cmd);

  exec(cmd, (error, stdout, stderr) => {
    if (error) {
      console.log(`error: ${error.message}`);
      return;
    }
    if (stderr) {
      console.log(`stderr: ${stderr}`);
      return;
    }
    console.log(`stdout: ${stdout}`);
  });
}
