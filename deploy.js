const HDWalletProvider = require("@truffle/hdwallet-provider");
const Web3 = require("web3");
const fs = require("fs");
const path = require("path");

// Getting the output of our compiled Solidity Contract

const { contracts } = require("./compile");

console.log("AAAAA", contracts["MyContract.sol"]);

// ######## TRUFFLE HD WALLET START ##########
// ######## TRUFFLE HD WALLET START ##########
// ######## TRUFFLE HD WALLET START ##########

// const provider = new HDWalletProvider({
//   mnemonic:
//     "danger demand trial coast kid hungry book eye future lab crunch alcohol",
//   providerOrUrl:
//     "https://polygon-mumbai.infura.io/v3/d3be9e934a084e4893cc86013ffd8a05",
// });
// // `$YOUR_METAMASK_RECOVERY_CODE`, `$RINKEBY_INFURA_API`;

// const web3 = new Web3(provider);

// const deploy = async () => {
//   // getting accounts from our Metamask wallet
//   const accounts = await web3.eth.getAccounts();

//   console.log("Attempting to deploy from account", accounts);

//   // deploying our contract
//   const result = await new web3.eth.Contract(
//     contracts["MyContract.sol"]["MyContract"].abi,
//     null,
//     {
//       transactionBlockTimeout: 200,
//       transactionConfirmationBlocks: 1000,
//       transactionPollingTimeout: 1000,
//       blockHeaderTimeout: 100,
//     }
//   )
//     .deploy({
//       data: contracts["MyContract.sol"]["MyContract"].evm.bytecode.object,
//     })
//     .send({ gas: "5000000", from: accounts[0] });

//   //   console.log("#### Interface: ", interface);
//   console.log("#### Contract deployed to", result.options.address);

//   //   Store ABI (Application Binary Interface) & Contract Bytecode
//   fs.writeFileSync(
//     path.join(__dirname, "abi.txt"),
//     JSON.stringify(contracts["MyContract.sol"]["MyContract"].abi)
//   );
//   console.log("##### 1");

//   fs.writeFileSync(
//     path.join(__dirname, "bytecode.txt"),
//     contracts["MyContract.sol"]["MyContract"].evm.bytecode.object
//   );
//   console.log("##### 2");
// };
// deploy();

// ######## WEB3 START ##########
// ######## WEB3 START ##########
// ######## WEB3 START ##########

async function main() {
  // Configuring the connection to the Polygon mumbai node
  const web3 = new Web3(
    new Web3.providers.HttpProvider(
      "https://polygon-mumbai.g.alchemy.com/v2/JPmIJ2CRdtfvrHZGVCpRZXpO9K8UVM1m"
    )
  );
  // Creating a signing account from a private key
  const signer = web3.eth.accounts.privateKeyToAccount(
    "80d7473bbc1b5706bdbe27330e75b89d0f55501d6abd380848028277793e7c50"
  );
  web3.eth.accounts.wallet.add(signer);

  // deploying our contract
  const result = await new web3.eth.Contract(
    contracts["MyContract.sol"]["MyContract"].abi,
    null,
    {
      transactionBlockTimeout: 200,
      transactionConfirmationBlocks: 1000,
      transactionPollingTimeout: 1000,
      blockHeaderTimeout: 100,
    }
  )
    .deploy({
      data: contracts["MyContract.sol"]["MyContract"].evm.bytecode.object,
    })
    .send({
      gas: "5000000",
      from: "0x64c58412d3a1aB9e8Ef915EcACdcbF102e05E82f",
    });

  //   console.log("#### Interface: ", interface);
  console.log("#### Contract deployed to", result.options.address);

  //   Store ABI (Application Binary Interface) & Contract Bytecode
  fs.writeFileSync(
    path.join(__dirname, "abi.txt"),
    JSON.stringify(contracts["MyContract.sol"]["MyContract"].abi)
  );

  fs.writeFileSync(
    path.join(__dirname, "bytecode.txt"),
    contracts["MyContract.sol"]["MyContract"].evm.bytecode.object
  );
}

main();
