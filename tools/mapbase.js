const fs = require("fs");

let data = []

for (let y=0; y<32; y++){
  if (y<=15){
    for (let x=0; x<64; x++){
      let tileVal=x>=20 ? x>=40 ? 0 : (39-x)+(y*20) : x+(y*20)
      let flipVal=x>=20 ? x>=40 ? 0 : 0b00000100 : 0

      if (tileVal>=256) {
        flipVal+=1
      }
      data.push(tileVal)
      data.push(flipVal)
    }
  } else {
    for (let x=0; x<64; x++){
      data.push(300&0xFF)
      data.push(300>>8)
    }
  }
}

let output = new Uint8Array([...data]);
fs.writeFileSync("build/GRIDMAP.BIN", output, "binary");
