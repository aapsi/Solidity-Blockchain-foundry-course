  // SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import {PriceConverter} from "./PriceConverter.sol"; 

error NotOwner();
// saving gas
// -> constant
// -> immutable
// -> custom errors

contract FundMe {
    using PriceConverter for uint256;
    uint256 public constant minimumUSd = 5e18;
    // because it is only declared once and it no longer takes upa storage spot
    // constant -> it saves gas

    address[] public funders;
    mapping(address funder => uint256 amountFunded) public addressToAmountFunded;

    address public immutable i_owner;
    // immutable -> save gas, we directly store them in the bytecode of the contract

    constructor() {
        i_owner = msg.sender;
    }

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
        // only owner can call it
        // require(msg.sender == owner, "Must be owner");

        for(uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++) {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        funders = new address[](0);
        //resetting the funders array to a new empty array starting at zero

        //transfer
        // msg.sender = address
        // payable(msg.sender) = payable address

        // payable(msg.sender).transfer(address(this).balance);

        // this keyword refers to the address of this whole contract
        // transfer (2300 gas, throws error) so when it fails it throws error and reverts the transaction
        
        //send -> it goes through with the transaction and returns a boolean if it fails
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "Send Failed");

        // call -> it returns 2 things
        // call is the recommended way
        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}(""); //("") -> we can call functions from other contracts
        require(callSuccess, "Call failed");

    }

    // modifiers gives us a keyword which we can add in any function to add functionalities
    modifier onlyOwner() {
        // _; this means we will execute other things first and then require
       // require(msg.sender == i_owner, "Sender is not owner");

        if(msg.sender != i_owner) {revert NotOwner();}

        _; // this means we will execute the require first and then whatever else is in the function
        
    }
        // receive()
        // if someone runs  the contract without calling fund function
        receive() external payable {
            fund();
        }
        // fallback()
        fallback() external payable {
            fund();
        }

    }
