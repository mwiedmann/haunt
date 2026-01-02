const fs = require("fs");

const inputFile = process.argv[2]; // BIN file with coords for each line. Line terminates with 254. EOF=255.
const outputFile = process.argv[3]; // New BIN files with coords and byte count to jump on terminate line.

const coordInput = fs.readFileSync(inputFile)

const tree = new Map()

const treeKey=(x,y)=> `x:${x},y:${y}`

const root = {
  id: 0,
  termId: 0,
  x: 10,
  y: 10,
  paths: []
}

let i=0;
let id=1

let lastNode=root

while (coordInput[i] != 255) {
  const x=coordInput[i]
  const y=coordInput[i+1]

  const existingNode = lastNode.paths.find(p => p.x===x && p.y===y)

  if (!existingNode) {
    const newNode = {
      id: id++, x, y, paths:[]
    }

    lastNode.paths.push(newNode)
    lastNode=newNode
  } else {
    lastNode=existingNode
  }  

  i+=2

  // Check for end of line
  if (coordInput[i]===254) {
    // See if end of file
    if (coordInput[i+1]===255) {
      break;
    }

    i++
    // New line, back to root
    lastNode=root
  }
}

// Assign the term id for where to go if a node hits a wall or ends

const traverseTree=(node) => {
  let termNode
  if (node.termId === undefined) {
    return node
  }
  for (let n=0; n<node.paths.length; n++) {
    if (termNode?.termId !== undefined) {
      return termNode
    }

    if (termNode && termNode.termId === undefined) {
      // term node was returned and still needs the next id to process
      // give it this one and return
      termNode.termId=node.paths[n].id
      return termNode
    }
    termNode = traverseTree(node.paths[n])
  }

  return termNode
}

let testNode

do {
  testNode = traverseTree(root)

  if (testNode && testNode.termId === undefined) {
    testNode.termId = 0
  }
} while (testNode)

const treeJSON=JSON.stringify(root)
fs.writeFileSync("tree.json", treeJSON)

// Create bin data
const bindata = []

const binTraverseTree=(node) => {
  if (node.id !== 0) {
    bindata.push(node.id, node.x, node.y, node.termId)
  }
  for (let n=0; n<node.paths.length; n++) {
    binTraverseTree(node.paths[n])
  }
}

binTraverseTree(root)

// create the final bin data with x,y,termOffset
const finalBin=[]

for (let i=0; i<bindata.length; i+=4) {
  const id=bindata[i]
  const x=bindata[i+1]
  const y=bindata[i+2]
  const termId=bindata[i+3]

  finalBin.push(x,y)

  let offset=0
  if (termId !== 0) {
    for (let f=i+4; f<bindata.length; f+=4) {
      if (bindata[f]===termId) {
        offset=(f-i)
      }
    }
  }

  finalBin.push(offset&255, offset>>8)
}

finalBin.push(255)

output = new Uint8Array(finalBin);
fs.writeFileSync(outputFile, output, "binary");

// console.log(`Generated file ${outputFile}. Length ${coords.length}`);
