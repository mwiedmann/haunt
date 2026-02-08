const fs = require("fs");

const rawText = fs.readFileSync("haunt.ldtk");
const d = JSON.parse(rawText);

const createLevelCode = (level) => {
  let floor = []
  level.layerInstances[0].gridTiles.forEach(tile => {
    floor.push(tile.t)
  })
  return floor
};

const mapBaseData = createLevelCode(d.levels[0]);

// Returns true if segment (x1,y1)-(x2,y2) intersects square with top-left (sx,sy) and side length = size
function segmentIntersectsSquare(x1, y1, x2, y2, sx, sy, size) {
  const left = sx,
    top = sy,
    right = sx + size,
    bottom = sy + size;

  // quick bbox reject
  if (
    Math.max(x1, x2) < left ||
    Math.min(x1, x2) > right ||
    Math.max(y1, y2) < top ||
    Math.min(y1, y2) > bottom
  )
    return false;

  // point-in-rect
  const pointInRect = (x, y) =>
    x >= left && x <= right && y >= top && y <= bottom;
  if (pointInRect(x1, y1) || pointInRect(x2, y2)) return true;

  // orientation / cross product
  const orient = (ax, ay, bx, by, cx, cy) =>
    (bx - ax) * (cy - ay) - (by - ay) * (cx - ax);
  const onSegment = (ax, ay, bx, by, cx, cy) =>
    Math.min(ax, bx) <= cx &&
    cx <= Math.max(ax, bx) &&
    Math.min(ay, by) <= cy &&
    cy <= Math.max(ay, by);

  const segsIntersect = (ax, ay, bx, by, cx, cy, dx, dy) => {
    const o1 = orient(ax, ay, bx, by, cx, cy);
    const o2 = orient(ax, ay, bx, by, dx, dy);
    const o3 = orient(cx, cy, dx, dy, ax, ay);
    const o4 = orient(cx, cy, dx, dy, bx, by);

    if (
      (o1 === 0 && onSegment(ax, ay, bx, by, cx, cy)) ||
      (o2 === 0 && onSegment(ax, ay, bx, by, dx, dy)) ||
      (o3 === 0 && onSegment(cx, cy, dx, dy, ax, ay)) ||
      (o4 === 0 && onSegment(cx, cy, dx, dy, bx, by))
    )
      return true;

    return o1 > 0 !== o2 > 0 && o3 > 0 !== o4 > 0;
  };

  // square edges
  const corners = [
    [left, top],
    [right, top],
    [right, bottom],
    [left, bottom],
  ];

  for (let i = 0; i < 4; i++) {
    const [cx, cy] = corners[i];
    const [dx, dy] = corners[(i + 1) % 4];
    if (segsIntersect(x1, y1, x2, y2, cx, cy, dx, dy)) return true;
  }

  return false;
}

const radius = 10;
const hiCheck = 0.95;
const loCheck = 0.05;
const finalBytes = [];
const torchTileId=16

for (let startY = 1; startY <= 62; startY++) {
  for (let startX = 1; startX <= 62; startX++) {
    const checkTile = (x, y) => {
      const dist=Math.trunc(Math.sqrt((x-startX)*(x-startX)+(y-startY)*(y-startY)));
      if (dist>radius-4) {
        // Outside radius
        // See if torch is lighting this square
        let torchFound=0;
        for (let tx=x-2;tx<=x+2 && !torchFound;tx++) {
          for (let ty=y-2;ty<=y+2 && !torchFound;ty++) {
            if (tx<0 || ty<0 || tx>63 || ty>63) continue;
            if (mapBaseData[ty * 64 + tx] === torchTileId) {
              torchFound=1;
            }
          }
        }
        
        if (!torchFound) return 0;
      }
      
      const lineChecks = [true, true, true, true];

      for (let yCheck = startY - radius; yCheck <= startY + radius; yCheck++) {
        for (
          let xCheck = startX - radius;
          xCheck <= startX + radius;
          xCheck++
        ) {
          // Skip checking the middle (start) tile and the end tile for the lint
          if (
            (yCheck === startY && xCheck === startX) || // Skip center tile
            (yCheck === y && xCheck === x) || // Skip tile we are currently checking
            mapBaseData[yCheck * 64 + xCheck] >= 32 // Skip checking tiles that are clear
          ) {
            continue;
          }

          // Check line seg from center tile to 4 spots in the source tile
          // See if any of them overlap with ANY square
          if (
            segmentIntersectsSquare(
              startX + 0.5,
              startY + 0.5,
              x + loCheck,
              y + loCheck,
              xCheck,
              yCheck,
              1
            )
          ) {
            lineChecks[0] = false;
          }

          if (
            segmentIntersectsSquare(
              startX + 0.5,
              startY + 0.5,
              x + hiCheck,
              y + loCheck,
              xCheck,
              yCheck,
              1
            )
          ) {
            lineChecks[1] = false;
          }

          if (
            segmentIntersectsSquare(
              startX + 0.5,
              startY + 0.5,
              x + loCheck,
              y + hiCheck,
              xCheck,
              yCheck,
              1
            )
          ) {
            lineChecks[2] = false;
          }

          if (
            segmentIntersectsSquare(
              startX + 0.5,
              startY + 0.5,
              x + hiCheck,
              y + hiCheck,
              xCheck,
              yCheck,
              1
            )
          ) {
            lineChecks[3] = false;
          }
        }
      }

      return lineChecks[0] || lineChecks[1] || lineChecks[2] || lineChecks[3];
    };

    let bitNum = 0;
    let currentByte = 0;

    for (let y = startY - radius; y <= startY + radius; y++) {
      for (let x = startX - radius; x <= startX + radius; x++) {
        currentByte <<= 1;
        const adjBitNum = () => {
          bitNum++;
          if (bitNum === 8) {
            bitNum = 0;
            finalBytes.push(currentByte);
            currentByte = 0;
          }
        };

        if (x < 0 || y < 0 || x > 63 || y > 63) {
          currentByte |= 1;
          adjBitNum();
        } else if (x === startX && y === startY) {
          adjBitNum();
        } else {
          if (!checkTile(x, y)) {
            currentByte |= 1;
          }
          adjBitNum();
        }
      }
    }

    currentByte <<= 8 - bitNum;
    finalBytes.push(currentByte, 0, 0, 0, 0, 0, 0, 0, 0);
  }
}

fs.writeFileSync(
  `build/PRECALC.BIN`,
  new Uint8Array([...finalBytes]),
  "binary"
);
