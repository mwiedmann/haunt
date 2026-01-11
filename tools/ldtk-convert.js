const fs = require("fs");

const rawText = fs.readFileSync("haunt.ldtk");
const d = JSON.parse(rawText);

const createLevelCode = (level) => {
  let floor = []
  let mapbase = []
  level.layerInstances[0].gridTiles.forEach(tile => {
    floor.push(tile.t <24 ? 1 : 0)
    mapbase.push(tile.t, 0)
  })
  return { floor, mapbase }
};

const data = createLevelCode(d.levels[0]);

fs.writeFileSync(`build/L0FLOOR.BIN`, new Uint8Array([...data.floor]), "binary");
fs.writeFileSync(`build/L0MAP.BIN`, new Uint8Array([...data.mapbase]), "binary");
