const fs = require("fs");

const rawText = fs.readFileSync("haunt.ldtk");
const d = JSON.parse(rawText);

const treasureCheck = []

const convertFlip = (f) =>
    f === 1 ? 0b100 : f === 2 ? 0b1000 : f === 3 ? 0b1100 : 0

const createLevelCode = (level) => {
  const levelNum = parseInt(level.identifier.split("_")[1])
  let floor = []
  let mapbase = []
  level.layerInstances[0].gridTiles.forEach(tile => {
    floor.push(tile.t)
    if (tile.t >= 12 && tile.t <= 47) {
      if (levelNum !== 0) {
        if (treasureCheck[tile.t]) {
          console.error(`On level ${level.identifier} Tile ${tile.t} at (${tile.px[0]/16}, ${tile.px[1]/16}) is a duplicate treasure tile!`)
        } else {
          treasureCheck[tile.t] = true
        }
      }
    }
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
}

for (let i=0; i<d.levels.length; i++) {
  const level = d.levels[i];
  if (level.identifier.startsWith("Level_")) {
    const levelNum = parseInt(level.identifier.split("_")[1])
    const data = createLevelCode(level);
    fs.writeFileSync(`build/L${levelNum.toString().padStart(2, '0')}FLOOR.BIN`, new Uint8Array([...data.floor]), "binary");
    fs.writeFileSync(`build/L${levelNum.toString().padStart(2, '0')}MAP.BIN`, new Uint8Array([...data.mapbase]), "binary");
    console.log(`Created Level ${level.identifier}`)
  }
}

for (let i=12; i<=47; i++) {
  if (!treasureCheck[i]) {
    console.error(`Tile ${i} is a missing treasure tile!`)
  }
}
