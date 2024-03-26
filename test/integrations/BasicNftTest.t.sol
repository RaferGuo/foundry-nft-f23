// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {BasicNft} from "../../src/BasicNft.sol";
import {Test} from "lib/forge-std/src/Test.sol";
import {DeployBasicNft} from "../../script/DeployScript.s.sol";

contract BasicNftTest is Test { 
      DeployBasicNft public deployer;
      BasicNft public basicNft;
      address public USER = makeAddr("user");
      //from git repo inter.s.sol
      string public constant PUG =
        "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";
      
      function setUp() public {
         deployer = new DeployBasicNft(); 
         basicNft = deployer.run();
      }

      function testNameIsCorrect() public view {
        string memory expectedName = "Dogie";
        string memory actualName = basicNft.name();
        /*cuz string are array of bytes,we cant use 
        assert(expectedName == actualName), use for loop to do or abi.encode.
        only can compare primitive types                 */
        assert(
            keccak256(abi.encodePacked(expectedName)) == keccak256(abi.encodePacked(actualName))
        );
        // assertEq(expectedName, actualName);
      }

      function testCanMintAndHaveBalance() public {
          vm.prank(USER);
          basicNft.mintNft(PUG);

         assert(basicNft.balanceOf(USER) == 1);
         assert(
            keccak256(abi.encodePacked(PUG)) == keccak256(abi.encodePacked(basicNft.tokenURI(0)))
        );
     }
}