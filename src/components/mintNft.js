import React, { useEffect, useState } from "react";
import MyContract from "../web3/myContract";
import web3 from "../web3/web3";

const styles = {
  nftImage: {
    height: "200px",
    width: "200px",
    display: "flex",
    flexDirection: "row",
  },
  mintButtonContainer: {
    width: "100%",
    marginTop: "3%",
  },
  mintButton: {
    backgroundColor: "dodgerblue",
    color: "white",
    padding: "15px",
    textAlign: "center",
    textDecoration: "none",
    display: "block",
    width: "43%",
    margin: "auto",
    fontSize: "26px",
    marginTop: "10px",
    fontWeight: "bold",
    borderRadius: "6px",
    cursor: "pointer",
  },
  notOwnerText: {
    textAlign: "center",
    marginTop: "5%",
    backgroundColor: "pink",
    width: "20%",
    display: "block",
    marginLeft: "auto",
    marginRight: "auto",
    paddingTop: "10px",
    paddingBottom: "10px",
    borderRadius: "5px",
  },
};

export default function MintNft() {
  const [ipfsImages, setIpfsImages] = useState([
    {
      id: 1,
      metaData:
        "https://ipfs.io/ipfs/bafyreibuvn7oa2juwi5yvrnvs75edysun63sedqtcaiawmmqsug343jdua/metadata.json",
      image:
        "https://ipfs.io/ipfs/bafybeihmpxlkrgvqa25kgsv3crkewn5hl7icmvmjoen6betmzra2zgmnom/p8.png",
    },
    {
      id: 2,
      metaData:
        "https://ipfs.io/ipfs/bafyreif5vmtnp25cj3bbzrhhye7cfcxetx2hw4n3ikatafe4l734kawm7i/metadata.json",
      image:
        "https://ipfs.io/ipfs/bafybeigppjsxml2chkcdxpf5wmotgv2upjlhbabuhdlajx6wkdktjoz2pq/p5.png",
    },
    {
      id: 3,
      metaData:
        "https://ipfs.io/ipfs/bafyreictae6jhz3hddskcwphk6yh2xbin42ilebh23q3fm7m7fy2mn6njy/metadata.json",
      image:
        "https://ipfs.io/ipfs/bafybeiekc3v3q6ghmvwql6phs4j64o6pvooh6ghmg6theulxuipb4thl2i/p13.png",
    },
  ]);
  const [contractOwner, setContractOwner] = useState(null);
  const [mintInProgress, setMintInProgress] = useState(false);
  const [accounts, setAccounts] = useState([]);

  useEffect(() => {
    const init = async () => {
      // Just Get a String from the Contract
      const contractOwner = await MyContract.methods.getOwner().call();
      setContractOwner(contractOwner);
      console.log("Contract Owner Address: ", contractOwner);
      // Get & set accounts of who is going to mint
      const accounts = await web3.eth.getAccounts();
      setAccounts(accounts);
      // Time to reload your interface with accounts[0]!
      window.ethereum.on("accountsChanged", async function (accounts) {
        accounts = await web3.eth.getAccounts();
        setAccounts(accounts);
      });
    };
    init();
  }, []);

  async function mint() {
    try {
      setMintInProgress(true);
      if (accounts[0] == contractOwner) {
        const mintResponse = await MyContract.methods
          .mint(accounts[0], ipfsImages[0].metaData)
          .send({
            from: accounts[0],
          });
      } else {
        // IF not owner
        await web3.eth.sendTransaction({
          from: accounts[0],
          to: contractOwner,
          value: web3.utils.toWei(String(0.1), "ether"),
          gasLimit: 21000,
          gasPrice: 20000000000,
        });
        const mintResponse = await MyContract.methods
          .mint(accounts[0], ipfsImages[0].metaData)
          .send({
            from: accounts[0],
          });
      }
      let newIpsImagesArray = ipfsImages;
      newIpsImagesArray.shift();
      console.log("CCCCCC:", newIpsImagesArray);
      setIpfsImages(newIpsImagesArray);
      setMintInProgress(false);
    } catch (error) {
      setMintInProgress(false);
    }
  }

  return (
    <div>
      <div style={styles.nftImage}>
        {ipfsImages &&
          ipfsImages.map((data) => {
            return <img key={data.id} src={data.image} alt="nftImage" />;
          })}
      </div>
      {accounts[0] != contractOwner && (
        <div style={styles.notOwnerText}>Pay for Owner 0.1 Matic</div>
      )}
      <div style={styles.mintButtonContainer}>
        <button onClick={() => mint()} style={styles.mintButton}>
          {mintInProgress ? "Minting...." : "MINT"}
        </button>
      </div>
    </div>
  );
}
