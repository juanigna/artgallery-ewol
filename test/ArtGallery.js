const {expect} = require("chai");
const {ethers} = require("hardhat");


let ArtGalleryInstance;
let ArtCollectionFactory;
let ArtCollectionInstance;

let signers = {};

describe("Art Gallery", function(){
    describe("Deploy", function(){
        it("Should deploy the smart contract", async function(){
            const {deployer, firstUser, secondUser} = await ethers.getSigners();
            signers.deployer = deployer;
            signers.firstUser = firstUser;
            signers.secondUser = secondUser;

            ArtCollectionFactory = await ethers.getContractFactory("ArtCollection");
            ArtCollectionInstance = await ArtCollectionFactory.deploy();
            await ArtCollectionInstance.deployed();

            ArtGalleryFactory = await ethers.getContractFactory("ArtGallery", signers.deployer);
            ArtGalleryInstance = await ArtGalleryFactory.deploy();
            await ArtGalleryInstance.deployed();
        })
    })
    

    describe("Publish Artwork", function(){
        it("Should allow to publish an artwork", async function(){
            let setArtworkTx = await ArtGalleryInstance.publishArtWorkToOwner("https://juani.com/id/", 5);
            await setArtworkTx.wait();
        })

        it("Should the art 0 have a price of 5 ethers", async function(){
            expect(await ArtGalleryInstance.nftPrices(0)).to.equal(5000000000000000000n);
        })
    })

    describe("Buy an artwork", function(){
        it("Should allow to buy an artowork", async function(){
            let firstUserInstance = await ArtGalleryInstance.connect(signers.firstUser);
            let buyArtworkTx = await firstUserInstance.buyArtWork(0, { value: ethers.utils.parseEther("5.0")});
        })
    })
})