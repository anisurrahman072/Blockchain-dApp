const path = require("path");
const fs = require("fs");
const solc = require("solc");

const lotteryPath = path.join(__dirname, "contracts", "MyContract.sol");
const source = fs.readFileSync(lotteryPath, "utf8");

var input = {
  language: "Solidity",
  sources: {
    "MyContract.sol": {
      content: `${source}`,
    },
  },
  settings: {
    optimizer: {
      enabled: true,
    },
    evmVersion: "byzantium",
    outputSelection: {
      "*": {
        "*": ["abi", "evm.bytecode.object"],
      },
    },
  },
};

function findImports(_path) {
  if (_path[0] === ".") {
    return {
      contents: fs.readFileSync(path.join(__dirname, _path)).toString(),
    };
  } else {
    return {
      contents: fs
        .readFileSync(path.join(__dirname, "node_modules", _path))
        .toString(),
    };
  }
}

module.exports = JSON.parse(
  solc.compile(JSON.stringify(input), { import: findImports })
);
