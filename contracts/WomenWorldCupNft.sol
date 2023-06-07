// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract WomenWorldCupNft2023 is ERC721URIStorage {
    address private owner;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    constructor() ERC721("Women World Cup", "BasementSports") {
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

    function getOwner() public view returns(address) {
        return owner;
    }

    function mint(address _address, string memory _metadataUrl)
        public
        onlyOwner
        returns (uint256)
    {
        uint256 newItemId = _tokenIds.current();
        _safeMint(_address, newItemId);
        _setTokenURI(newItemId, _metadataUrl);

        _tokenIds.increment();
        return newItemId;
    }
}