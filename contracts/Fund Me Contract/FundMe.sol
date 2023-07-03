  // SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import {PriceConverter} from "./PriceConverter.sol";

contract FundMe {
    using PriceConverter for uint256;
    uint256 public minimumUSd = 5e18;

    address[] public funders;
    mapping(address funder => uint256 amountFunded) public addressToAmountFunded;

    function fund() public payable {
        // we did not pass any value as msg.value is of uint256 type and it gets passed already

        //allow users to send money
        // have a minimum sending amount
        require(msg.value.getConversionRate() > minimumUSd, "didn't send enough eth"); // 1e18 = 1 eth
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] = addressToAmountFunded[msg.sender] + msg.value;
    // What is revert?
    // undo any actions that have been done, and send remaining gas back
    // chainlink oracles 
    }

    function withdraw() public {
        for(uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++) {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        funders = new address[](0);
        //resetting the funders array to a new empty array starting at zero

        //transfer
        
        //send
        // call
    }


    }
