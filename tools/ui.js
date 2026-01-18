const fs = require("fs")

const rawText = fs.readFileSync("haunt.ldtk")
const d = JSON.parse(rawText)

const createUICode = (level) => {
  let mapbase = []

  let tileCount = 0
  for (let y = 0; y < 30; y++) {
    for (let x = 0; x < 64; x++) {
      mapbase.push(level.layerInstances[0].gridTiles[tileCount].t, 0)
      tileCount++
    }
  }

  return mapbase
}

const data = createUICode(d.levels.find((l) => l.identifier === "UI"))

fs.writeFileSync(`build/UI.BIN`, new Uint8Array([...data]), "binary")
