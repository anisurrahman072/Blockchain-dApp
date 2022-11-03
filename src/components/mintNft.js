import React, { useEffect, useState } from "react";
import MyContract from "../web3/myContract";

const nftMetadataIpfsUrl =
  "https://ipfs.io/ipfs/bafyreibuvn7oa2juwi5yvrnvs75edysun63sedqtcaiawmmqsug343jdua/metadata.json";

const styles = {
  nftImage: {
    height: "100px",
    width: "100px",
  },
};

export default function MintNft() {
  useEffect(() => {
    const init = async () => {
      const stringMessage = await MyContract.methods
        .interactionFromDapp()
        .call();
      console.log("KKKKKK: ", stringMessage);
    };
    init();
  }, []);

  async function mint() {
    console.log("ANIS");
    await MyContract.methods.mint(nftMetadataIpfsUrl).call();
  }

  return (
    <div>
      <div style={styles.nftImage}>
        <img
          src="https://ipfs.io/ipfs/bafybeihmpxlkrgvqa25kgsv3crkewn5hl7icmvmjoen6betmzra2zgmnom/p8.png"
          alt="nftImage"
        />
        <button onClick={() => mint()}>MINT</button>
      </div>
    </div>
  );
}
