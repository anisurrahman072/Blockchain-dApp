const HDWalletProvider = require("@truffle/hdwallet-provider");
const Web3 = require("web3");
const fs = require("fs");
const path = require("path");

// Getting the output of our compiled Solidity Contract

const { contracts } = require("./compile");

console.log("AAAAA", contracts["MyContract.sol"]);

const provider = new HDWalletProvider({
  mnemonic:
    "danger demand trial coast kid hungry book eye future lab crunch alcohol",
  providerOrUrl:
    "https://rpc-mumbai.maticvigil.com/v1/606ecc3eeab13b51437cc68d6477cd694f349c3d",
});
// `$YOUR_METAMASK_RECOVERY_CODE`,
// `$RINKEBY_INFURA_API`

const web3 = new Web3(provider);

const deploy = async () => {
  // getting accounts from our Metamask wallet
  const accounts = await web3.eth.getAccounts();

  console.log("Attempting to deploy from account", accounts);

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
    .send({ gas: "5000000", from: accounts[0] });

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
};
deploy();
