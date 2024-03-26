// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract MoodNft is ERC721{
    uint256 public s_tokenCounter;
    string private s_sadSvgImageUri;
    string private s_happtSvgImageUri;

    error MoodNft__CantFlipMoodIfNotOwner();
    
    enum Mood{
        HAPPY,
        SAD
    }

    mapping(uint256 => Mood) s_tokenIdToMood;
      
    //here is imageUri not tokenUri
    constructor(string memory sadSvgImageUri, string memory happySvgImageUri) ERC721("Mood NFT", "MM"){
        s_tokenCounter = 0;
        s_sadSvgImageUri = sadSvgImageUri;
        s_happtSvgImageUri = happySvgImageUri;
    } 

    function mintNft() public {
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenIdToMood[s_tokenCounter] = Mood.HAPPY;
        s_tokenCounter++;
    }

     function flipMood(uint256 tokenId) public {
        if (getApproved(tokenId) != msg.sender && ownerOf(tokenId) != msg.sender) {
            revert MoodNft__CantFlipMoodIfNotOwner();
        }

        if (s_tokenIdToMood[tokenId] == Mood.HAPPY) {
            s_tokenIdToMood[tokenId] = Mood.SAD;
        } else {
            s_tokenIdToMood[tokenId] = Mood.HAPPY;
        }
    }
       
    
    //to json
    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,";
    }

    //tokenURI -> metadata
    function tokenURI(uint256 tokenId) public view override returns(string memory) {
        string memory imageURI;
        if(s_tokenIdToMood[tokenId] == Mood.HAPPY){
            imageURI = s_happtSvgImageUri;
        } else {
            imageURI = s_sadSvgImageUri;
        }
        
        return 
          string(
            abi.encodePacked(//hash
            _baseURI(),
              Base64.encode(//base64
                bytes(//bytes
                  //string
                  abi.encodePacked('{"name": "',name(),'", "description": "An NFT that reflects the owners mood.", "attributes": [{"trait_type": "moodiness", "value": "100"}], "image":"',imageURI,'"}'))
                )
              )
            );
    }
}