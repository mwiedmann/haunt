const fs = require("fs");

const rawText = fs.readFileSync("haunt.ldtk");
const d = JSON.parse(rawText);

const createLevelCode = (level) => {
  let data = []
  level.layerInstances[0].intGridCsv.forEach(tileIndex => data.push(tileIndex - 1))
  return data
};

const mapBaseData = createLevelCode(d.levels[0]);

fs.writeFileSync(`build/LEVEL0.BIN`, new Uint8Array([...mapBaseData]), "binary");
