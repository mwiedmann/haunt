const fs = require("fs");

const rawText = fs.readFileSync("haunt.ldtk");
const d = JSON.parse(rawText);

const convertFlip = (f) =>
    f === 1 ? 0b100 : f === 2 ? 0b1000 : f === 3 ? 0b1100 : 0

const createLevelCode = (level) => {
  let floor = []
  let mapbase = []
  level.layerInstances[0].gridTiles.forEach(tile => {
    floor.push(tile.t)
  })

  let tileCount=0
  for (let y=0; y<128; y++) {
    for (let x=0; x<128; x++) {
      if (y<32 || y>=96 || x<32 || x>=96) {
        mapbase.push(16,0)
      } else {
         mapbase.push(
            level.layerInstances[0].gridTiles[tileCount].t, 
            convertFlip(level.layerInstances[0].gridTiles[tileCount].f)
          )
         tileCount++
      }
    }
  }

  return { floor, mapbase }
};

const data = createLevelCode(d.levels[0]);

fs.writeFileSync(`build/L0FLOOR.BIN`, new Uint8Array([...data.floor]), "binary");
fs.writeFileSync(`build/L0MAP.BIN`, new Uint8Array([...data.mapbase]), "binary");
