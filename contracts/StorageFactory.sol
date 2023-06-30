// SPDX-License-Identifier: MIT
pragma solidity  ^0.8.18;

import {SimpleStorage} fromv"./SimpleStorage.sol";

contract StorageFactory {

    //uint256 public favouriteNumber
    //type visibility name
    SimpleStorage public simpleStorage;
    
    function createSimpleStorageContract() public {
        simpleStorage = new SimpleStorage();
    }
}