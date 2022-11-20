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
    constructor() ERC721("anis_1", "DEMO") {
        owner = msg.sender;
    }

    // CHECK OWNER or not
    modifier onlyOwner() {
        require(
            owner == msg.sender,
            "Mint can only done by the owner of the Contract"
        );
        _;
    }

    // CHECK an NFT already MINTED or not
    function alreadyMinted(string memory _metadataUrl)
        private
        view
        returns (bool)
    {
        for (uint256 i = 0; i < allMintedNftMetadataUrls.length; i++) {
            if (
                keccak256(abi.encodePacked(allMintedNftMetadataUrls[i])) ==
                keccak256(abi.encodePacked(_metadataUrl))
            ) {
                return true;
            }
        }
        return false;
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

    // BLOCKCHAIN single minting
    function mint(address _address, string memory _metadataUrl)
        public
        payable
        onlyOwner
    {
        // ERROR if ALREADY minted the NFT by anyone
        if (alreadyMinted(_metadataUrl)) {
            revert("The NFT has been minted already");
        }

        // Now we know, NFT is available
        string[]
            storage mintedNftMetadataUrls = publicAddressesWithMintedNftMetadataUrls[
                _address
            ];
        if (mintedNftMetadataUrls.length > 0) {
            // Above IF logic --> Already MINTED some NFTs before
            // ###### Keep previous values safely & Store in MAP
            mintedNftMetadataUrls.push(_metadataUrl);
            publicAddressesWithMintedNftMetadataUrls[
                _address
            ] = mintedNftMetadataUrls;
            // ***** Store the METADATA url
            allMintedNftMetadataUrls.push(_metadataUrl);
        } else {
            // Above ELSE Logic --> Totally FRESH user, want to MINT for first time
            // ###### Store in MAP
            publicAddressesWithMintedNftMetadataUrls[_address] = [_metadataUrl];
            // +++++ Store the Public Adress as a MINTER
            allMinterPublicAddresses.push(_address);
            // ***** Store the METADATA url
            allMintedNftMetadataUrls.push(_metadataUrl);
        }

        // MINT NFT in BLOCKCHAIN + Opensea
        uint256 mintIndex = totalSupply(); // totalSupply() is a function of IERC721Enumerable which Returns the total amount of tokens stored by the contract.
        _safeMint(_address, mintIndex); // Here "_address" is the public address of whoever is going to MINT the NFT
        _setTokenURI(mintIndex, _metadataUrl); // This _setTokenURI() method will add all the metadata to the specific Token
    }

    // BLOCKCHAIN multiple minting
    function mintMultipleNfts(address _address, string[] memory _urls)
        public
        payable
        onlyOwner
    {
        for (uint256 i = 0; i < _urls.length; i++) {
            string memory _metadataUrl = _urls[i];

            // SKIP if ALREADY minted the NFT by anyone
            if (!alreadyMinted(_metadataUrl)) {
                // Now we know, NFT is available
                string[]
                    storage mintedNftMetadataUrls = publicAddressesWithMintedNftMetadataUrls[
                        _address
                    ];

                if (mintedNftMetadataUrls.length > 0) {
                    // Above IF logic --> Already MINTED some NFTs before
                    // ###### Keep previous values safely & Store in MAP
                    mintedNftMetadataUrls.push(_metadataUrl);
                    publicAddressesWithMintedNftMetadataUrls[
                        _address
                    ] = mintedNftMetadataUrls;
                    // ***** Store the METADATA url
                    allMintedNftMetadataUrls.push(_metadataUrl);
                } else {
                    // Above ELSE Logic --> Totally FRESH user, want to MINT for first time
                    // ###### Store in MAP
                    publicAddressesWithMintedNftMetadataUrls[_address] = [
                        _metadataUrl
                    ];
                    // +++++ Store the Public Adress as a MINTER
                    allMinterPublicAddresses.push(_address);
                    // ***** Store the METADATA url
                    allMintedNftMetadataUrls.push(_metadataUrl);
                }

                // MINT NFT in BLOCKCHAIN + Opensea
                uint256 mintIndex = totalSupply(); // totalSupply() is a function of IERC721Enumerable which Returns the total amount of tokens stored by the contract.
                _safeMint(_address, mintIndex); // Here "_address" is the public address of whoever is going to MINT the NFT
                _setTokenURI(mintIndex, _metadataUrl); // This _setTokenURI() method will add all the metadata to the specific Token
            }
        }
    }
}
