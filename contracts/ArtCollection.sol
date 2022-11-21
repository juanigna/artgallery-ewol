// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;


import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Royalty.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract ArtCollection is  ERC721,ERC721Enumerable, ERC721Royalty, ERC721URIStorage, Ownable {
    /**
     * @dev Smart Contract Constructor
     */
    constructor() ERC721("ART GALLERY", "AGNFT"){}

    /**
     * @dev Mint to an address
     */

    function mintTo(string memory _tokenUri, uint96 _royaltyNumerator, address to) public onlyOwner returns (uint256) {
		uint256 _newTokenId = totalSupply();
		_safeMint(to, _newTokenId);
		_setTokenURI(_newTokenId, _tokenUri);
		_setTokenRoyalty(_newTokenId, msg.sender, _royaltyNumerator);
		_setApprovalForAll(to, msg.sender, true);
		return _newTokenId;	
	}

    /**
     * @dev Mint to owner
     */
	function mintOwner(string memory _tokenUri, uint96 _royaltyNumerator) public onlyOwner returns (uint256) {
		uint256 _newTokenId = totalSupply();
		_mint(msg.sender, _newTokenId);
		_setTokenURI(_newTokenId, _tokenUri);
		_setTokenRoyalty(_newTokenId, msg.sender, _royaltyNumerator);
		return _newTokenId;
	}

    /**
     * @dev overriding functions
     */

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage, ERC721Royalty){
        super._burn(tokenId);
    }

     function _beforeTokenTransfer(address from, address to,uint256 amount, uint256 batchSize) internal virtual override(ERC721, ERC721Enumerable){
        super._beforeTokenTransfer(from, to, amount, batchSize);
    }

    function supportsInterface(bytes4 interfaceId)public view virtual override(ERC721, ERC721Enumerable, ERC721Royalty) returns (bool){
        return super.supportsInterface(interfaceId);
    }

    function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory){
        return super.tokenURI(tokenId);
    }
}