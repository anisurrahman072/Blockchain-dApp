// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.17;
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract MyContract is ERC721, ERC721Enumerable, ERC721URIStorage {
    address private owner;
    mapping(address => string[]) publicAddressesWithMintedNftMetadataUrls;
    address[] private allMinterPublicAddresses;
    string[] private allMintedNftMetadataUrls;

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override(ERC721, ERC721Enumerable) {
        // This bellow method is just transferring the controll to the parent class
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function _burn(uint256 tokenId)
        internal
        override(ERC721, ERC721URIStorage)
    {
        // This bellow method is just transferring the controll to the parent class
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    // This bellow ERC721 inside constructor will create a ERC721 Token named as "Baseball 2" and symbol as "anis_symbol" once the Contract deployed for the first time in the Blockchain
    constructor() ERC721("demo_mainnet", "DEMO") {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(
            owner == msg.sender,
            "Mint can only done by the owner of the Contract"
        );
        _;
    }

    function alreadyMinted(
        string[] memory mintedNftMetadataUrls,
        string memory _metadataUrl
    ) internal pure returns (bool) {
        for (uint256 i = 0; i < mintedNftMetadataUrls.length; i++) {
            if (
                keccak256(abi.encodePacked(mintedNftMetadataUrls[i])) ==
                keccak256(abi.encodePacked(_metadataUrl))
            ) {
                return true;
            }
        }
        return false;
    }

    // Demo AddMINT
    function addMint(address _address, string memory _metadataUrl) public {
        string[]
            storage mintedNftMetadataUrls = publicAddressesWithMintedNftMetadataUrls[
                _address
            ];
        if (mintedNftMetadataUrls.length > 0) {
            // Above IF logic --> Already MINTED some NFTs before
            if (!alreadyMinted(mintedNftMetadataUrls, _metadataUrl)) {
                // Above IF logic --> MINTED some other NFTs, but didn't MINT this NFT
                mintedNftMetadataUrls.push(_metadataUrl);
                publicAddressesWithMintedNftMetadataUrls[
                    _address
                ] = mintedNftMetadataUrls;
                // ***** Store the METADATA url
                allMintedNftMetadataUrls.push(_metadataUrl);
            }
        } else {
            // Above ELSE Logic --> Totally FRESH user, want to MINT for first time
            publicAddressesWithMintedNftMetadataUrls[_address] = [_metadataUrl];
            // Store the Public Adress as a MINTER
            allMinterPublicAddresses.push(_address);
            // ***** Store the METADATA url
            allMintedNftMetadataUrls.push(_metadataUrl);
        }
    }

    // Get all minted NFTs
    function getAllMintedNftMetadataUrls()
        public
        view
        returns (string[] memory)
    {
        return allMintedNftMetadataUrls;
    }

    // Get all minter for this Contract - Collection
    function getAllMinterPublicAddresses()
        public
        view
        returns (address[] memory)
    {
        return allMinterPublicAddresses;
    }

    // Get all Minted NFTs for an address
    function getAllMintedNftMetadataUrlsForAPublicAddress(address _address)
        public
        view
        returns (string[] memory)
    {
        return publicAddressesWithMintedNftMetadataUrls[_address];
    }

    // Get Owner of Contract
    function getOwner() public view returns (address) {
        return owner;
    }

    // TODO: add all the functions of addMint()
    function mint(address _to_mint, string memory _uri)
        public
        payable
        onlyOwner
    {
        uint256 mintIndex = totalSupply(); // totalSupply() is a function of IERC721Enumerable which Returns the total amount of tokens stored by the contract.
        _safeMint(_to_mint, mintIndex); // Here "_to_mint" is the public address of whoever is calling this smart Contract mint() method
        _setTokenURI(mintIndex, _uri); // This _setTokenURI() method will add all the metadata to thi specific Token
    }

    // TODO: add all the functions of addMint()
    function mintMultipleNfts(address _to_mint, string[] memory _urls)
        public
        payable
        onlyOwner
    {
        for (uint256 i = 0; i < _urls.length; i++) {
            uint256 mintIndex = totalSupply();
            _safeMint(_to_mint, mintIndex);
            _setTokenURI(mintIndex, _urls[i]);
        }
    }
}
