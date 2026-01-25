const fs = require("fs");

const palName = process.argv[2];

console.log(
  `Reading Gimp palette file ${palName}`
);

const palData = fs.readFileSync(palName);

const pal1 = []
const pal2 = []
const pal3 = []
const pal4 = []
const pal5 = []
const pal6 = []

const adjustColor = (c, a=0) => Math.max(Math.min((c>>4)+a, 15), 0)
const adjAmount=[0,-1,0,1,0,-1]

// The raw data is just a long array of R,G and B bytes
// Convert them to G+B and R (4 bytes each)
for (let i = 0,idx=0; i < palData.length; i+=3,idx++) {
  // Make not tranparent black out of grey
  if (palData[i]===88) {
    console.log('Grey')
    palData[i]=1
    palData[i+1]=1
    palData[i+2]=1
  }

  if (idx>1 && idx !== 6) {
    pal1.push((adjustColor(palData[i+1],adjAmount[0])<<4) + adjustColor(palData[i+2],adjAmount[0]))
    pal1.push(adjustColor(palData[i],adjAmount[0]))

    pal2.push((adjustColor(palData[i+1],adjAmount[1])<<4) + adjustColor(palData[i+2],adjAmount[1]))
    pal2.push(adjustColor(palData[i],adjAmount[1]))

    pal3.push((adjustColor(palData[i+1],adjAmount[2])<<4) + adjustColor(palData[i+2],adjAmount[2]))
    pal3.push(adjustColor(palData[i],adjAmount[2]))

    pal4.push((adjustColor(palData[i+1],adjAmount[3])<<4) + adjustColor(palData[i+2],adjAmount[3]))
    pal4.push(adjustColor(palData[i],adjAmount[3]))

    pal5.push((adjustColor(palData[i+1],adjAmount[4])<<4) + adjustColor(palData[i+2],adjAmount[4]))
    pal5.push(adjustColor(palData[i],adjAmount[4]))

    pal6.push((adjustColor(palData[i+1],adjAmount[5])<<4) + adjustColor(palData[i+2],adjAmount[5]))
    pal6.push(adjustColor(palData[i],adjAmount[5]))
  } else {
    pal1.push((adjustColor(palData[i+1])<<4) + adjustColor(palData[i+2]))
    pal1.push(adjustColor(palData[i]))

    pal2.push((adjustColor(palData[i+1])<<4) + adjustColor(palData[i+2]))
    pal2.push(adjustColor(palData[i]))

    pal3.push((adjustColor(palData[i+1])<<4) + adjustColor(palData[i+2]))
    pal3.push(adjustColor(palData[i]))

    pal4.push((adjustColor(palData[i+1])<<4) + adjustColor(palData[i+2]))
    pal4.push(adjustColor(palData[i]))

    pal5.push((adjustColor(palData[i+1])<<4) + adjustColor(palData[i+2]))
    pal5.push(adjustColor(palData[i]))

    pal6.push((adjustColor(palData[i+1])<<4) + adjustColor(palData[i+2]))
    pal6.push(adjustColor(palData[i]))
  }
}

fs.writeFileSync("BUILD/PAL1.BIN", new Uint8Array(pal1), "binary");
fs.writeFileSync("BUILD/PAL2.BIN", new Uint8Array(pal2), "binary");
fs.writeFileSync("BUILD/PAL3.BIN", new Uint8Array(pal3), "binary");
fs.writeFileSync("BUILD/PAL4.BIN", new Uint8Array(pal4), "binary");
fs.writeFileSync("BUILD/PAL5.BIN", new Uint8Array(pal5), "binary");
fs.writeFileSync("BUILD/PAL6.BIN", new Uint8Array(pal6), "binary");

console.log(`Generated CX16 palette files`);
