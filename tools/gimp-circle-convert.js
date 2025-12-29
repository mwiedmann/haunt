const fs = require("fs");

const inputFile = process.argv[2];
const outputFile = process.argv[3];

const radius = process.argv[4];

const side=(radius*2)+1

const imageData = fs.readFileSync(inputFile)

const coords = [];

for (let y=0; y<side; y++) {
  for (let x=0; x<side; x++) {
    const index=(y*side)+x
    if (imageData[index]) coords.push(x,y)
  }
}

coords.push(255) // Signals end of coords

output = new Uint8Array([...coords]);
fs.writeFileSync(outputFile, output, "binary");

console.log(`Generated file ${outputFile}. Length ${coords.length}`);
