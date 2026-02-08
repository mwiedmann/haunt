const fs = require("fs")

const rawText = fs.readFileSync("haunt.ldtk")
const d = JSON.parse(rawText)

const createUICode = (level) => {
  let mapbase = []

  const convertFlip = (f) =>
    f === 1 ? 0b100 : f === 2 ? 0b1000 : f === 3 ? 0b1100 : 0
  let tileCount = 0
  for (let y = 0; y < 30; y++) {
    for (let x = 0; x < 64; x++) {
      mapbase.push(
        level.layerInstances[0].gridTiles[tileCount].t,
        convertFlip(level.layerInstances[0].gridTiles[tileCount].f),
      )
      tileCount++
    }
  }

  return mapbase
}

const data = createUICode(d.levels.find((l) => l.identifier === "UI"))

fs.writeFileSync(`build/UI.BIN`, new Uint8Array([...data]), "binary")
