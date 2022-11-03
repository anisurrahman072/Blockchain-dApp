import web3 from "./web3";
import { contractAddress, abi } from "../utils/credentials";

export default new web3.eth.Contract(abi, contractAddress);
