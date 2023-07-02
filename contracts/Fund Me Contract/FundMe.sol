  // SPDX-License-Identifier: MIT
 pragma solidity ^0.8.18;

 contract FundMe {
     function fund() public payable {
         //allow users to send money
         // have a minimum sending amount
         require(msg.value > 1e18, "didn't send enough eth"); // 1e18 = 1 eth

        // What is revert?
        // undo any actions that have been done, and send remaining gas back
        // chainlink oracles 
     }
 }
