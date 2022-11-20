// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./ArtCollection.sol";

contract ArtGallery is Ownable {
    // 
    // Initial Statements
    // 

    /**
     * @dev instance of the ArtCollection smart contract
     */

    ArtCollection artCollection;

    /**
     * @dev declaration of the events
     */

    event withdraw(uint256 amount, address owner);
    event nftSell(address seller, address buyer, uint256 nftId);

    /**
     * @dev data structure with the propierties of the artwork
     */

    struct Art {
        string name;
        uint256 id;
        uint256 dna;
        uint8 level;
        uint8 rarity;
    }

    /**
     * @dev mapping for the prices of the ArtWorks
     */

    mapping(uint256 => uint256) nftPrices;


    /**
     * @dev Smart Contract Constructor
     */
    
    constructor(){
      artCollection = new ArtCollection("Art Nft", "AFT");
    }

    /**
     * @dev Publish an artwork being an user
     */
    function publishArtWork(string memory _tokenUri, uint256 _tokenPrice, address to) public onlyOwner {
      uint256 _tokenId = artCollection.mintTo(_tokenUri, 1000 ,to);
      nftPrices[_tokenId] = _tokenPrice;
    }

    /**
     * @dev Publish an artwork to owner 
     */

    function publishArtWorkToOwner(string memory _tokenUri, uint256 _tokenPrice) public onlyOwner {
      uint256 _tokenId = artCollection.mintOwner(_tokenUri, 1000);
      nftPrices[_tokenId] = _tokenPrice;
    }


    /**
     * @dev Sell an artwork if the artwork have a price
     */

    function sellArtWork(uint256 _tokenId, uint256 _tokenPrice) public {
      require(artCollection.ownerOf(_tokenId) == msg.sender, "You are trying to sell something that is not yours");
      nftPrices[_tokenId] = _tokenPrice;
    }

   
    // Creation of a random number (required for NFT token properties)
    bytes32 has_randomNum = keccak256(abi.encodePacked(block.timestamp,msg.sender));


    /**
     * @dev Extraction of ethers from the Smart Contract to the Owner
     */
    
    function Withdraw() public payable {
      uint256 SC_balance = address(this).balance;
      payable(msg.sender).transfer(SC_balance);
      emit withdraw(SC_balance, msg.sender);
    }
    

}