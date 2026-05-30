const fs = require("fs");

const rawText = fs.readFileSync("haunt.ldtk");
const d = JSON.parse(rawText);

const createLevelCode = (level) => {
  let floor = new Map()

  level.layerInstances[0].gridTiles.forEach(tile => {
    const x = tile.px[0] / 16;
    const y = tile.px[1] / 16;

    floor.set(x + "," + y, tile.t)
  })
  return floor
};

const calcData = (level) => {
  const levelNum = parseInt(level.identifier.split("_")[1])
  const floor = createLevelCode(level);

  const gasFloor = new Map()

  const startX = 16
  const startY = 15
  const blocksGasTileIdStart=60

  let maxIteration = 0

  const checkSpot = (x, y, iteration) => {
    if (iteration > maxIteration) {
      maxIteration = iteration
    }
    if (x < 0 || x > 64 || y < 0 || y > 64) return
    const key = x + "," + y
    if (!gasFloor.has(key) || gasFloor.get(key) > iteration) {
      // See if this tile blocks gas
      if (floor.get(key) >= blocksGasTileIdStart) {
        gasFloor.set(key, iteration)
        checkSpot(x+1, y, iteration+1)
        checkSpot(x-1, y, iteration+1)
        checkSpot(x, y+1, iteration+1)
        checkSpot(x, y-1, iteration+1)
      }
    }
  }

  checkSpot(startX, startY, 1)

  // Sort by iteration
  let sortedGas = [...gasFloor.entries()].sort((a,b) => a[1] - b[1])

  console.log("Max iteration: " + maxIteration)

  let finalBytes = []
  let lastIteration = 1
  const iterationChangeMarker = 99

  // The final bytes are the iteration number (if it changes)
  // followed by the x and y of each tile in that iteration
  sortedGas.forEach(([key, iteration]) => {
    const [x,y] = key.split(",").map(Number)
    if (iteration !== lastIteration) {
      finalBytes.push(iterationChangeMarker)
      lastIteration = iteration
    }
    finalBytes.push(x, y)
  })
  finalBytes.push(255) // End marker

  console.log(`Final bytes(length): ${finalBytes.length}`)
  fs.writeFileSync(
    `build/L${levelNum.toString().padStart(2, '0')}GAS.BIN`,
    new Uint8Array([...finalBytes]),
    "binary"
  );
}


for (let i=0; i<d.levels.length; i++) {
  const level = d.levels[i];
  if (level.identifier.startsWith("Level_")) {
    calcData(level);
    console.log(`Calculated data for Level ${level.identifier}`)
  }
}
