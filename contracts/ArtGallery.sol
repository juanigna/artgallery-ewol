// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./ArtCollection.sol";

contract ArtGallery is Ownable {
    // 
    // Initial Statements
    // 

    uint256 public constant floor_price = 1 ether;

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
        uint256 nftPrice;
    }

    /**
     * @dev mapping for the prices of the ArtWorks
     */

    mapping(uint256 => uint256) public nftPrices;
    mapping(uint256 => Art) artsGallery;

    /**
     * @dev Smart Contract Constructor
     */
    
    constructor(){
      artCollection = new ArtCollection();
    }

    /**
     * @dev Publish an artwork being an user
     */

    function publishArtWork(string memory _tokenUri, uint256 _tokenPrice, address to) public onlyOwner {
      uint256 _tokenId = artCollection.mintTo(_tokenUri, 1000 ,to);
      nftPrices[_tokenId] = _tokenPrice * floor_price;
      artsGallery[_tokenId] = Art(_tokenPrice);
    }

    /**
     * @dev Publish an artwork to owner 
     */

    function publishArtWorkToOwner(string memory _tokenUri, uint256 _tokenPrice) public onlyOwner {
      uint256 _tokenId = artCollection.mintOwner(_tokenUri, 1000);
      nftPrices[_tokenId] = _tokenPrice * floor_price;
      artsGallery[_tokenId] = Art(_tokenPrice);
    }


    /**
     * @dev Sell an artwork 
     */

    function sellArtWork(uint256 _tokenId, uint256 _tokenPrice) public {
      require(artCollection.ownerOf(_tokenId) == msg.sender, "You are trying to sell something that is not yours");
      nftPrices[_tokenId] = _tokenPrice * floor_price;
    }

    /**
     * @dev Buy an artwork if the artwork have a price
     * 
     * If the seller is not the contract, send the sellerAmount
     *
     */

    function buyArtWork(uint256 _tokenId) public payable{
      uint256 tokenPrice = nftPrices[_tokenId];
      require(tokenPrice >= 0, "The Art Work is not for sale");
      require(msg.value == tokenPrice, "Incorrect amount on ether");
      address seller = artCollection.ownerOf(_tokenId);

      artCollection.safeTransferFrom(seller, msg.sender, _tokenId);

      uint256 amountReceived = msg.value;
      (, uint256 royaltyAmount) = artCollection.royaltyInfo(_tokenId, tokenPrice);
      uint256 sellerAmount = amountReceived - royaltyAmount;
      
      if(seller != address(this)){
        payable(seller).transfer(sellerAmount);
      }

      nftPrices[_tokenId] = 0;
    }
   

    /**
     * @dev Extraction of ethers from the Smart Contract to the Owner
     */
    
    function Withdraw() public payable {
      uint256 SC_balance = address(this).balance;
      payable(msg.sender).transfer(SC_balance);
      emit withdraw(SC_balance, msg.sender);
    }
    

    /**
     * @dev Check who is the owner of the _tokenId
     */

    function ownerOfToken(uint256 _tokenId) public view returns(address){
      return artCollection.ownerOf(_tokenId);
    }

    /**
     * @dev Check the balance on ethers of an account
     */

    function balanceOnEthers(address _who) public view returns(uint256){
		  return _who.balance;		
	  }
}