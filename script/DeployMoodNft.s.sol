// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "lib/forge-std/src/Script.sol";
import {MoodNft} from "../src/MoodNft.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract DeployMoodNft is Script {
     
     function run() external returns(MoodNft) {
     }

     function svgToImageURI(string memory svg) public pure returns(string memory) {
        //example
        //input:<svg width="1024px" height = "1024px" ....>
        //outpute:data:image/svg+xml;base64,PD94bWwg...
        string memory baseURL ="data:image/svg+xml;base64,";
        string memory svgBase64Encode = Base64.encode(bytes(string(abi.encodePacked(svg))));
        return string(abi.encodePacked(baseURL,svgBase64Encode));
     }
     
}