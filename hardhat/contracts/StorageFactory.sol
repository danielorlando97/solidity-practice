// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./SimpleStorage.sol";

// Contract to deplot dynamic contracts
// Import others contracts and it runs its function, to create
// contract and save the new contract address
contract StorageFactory is SimpleStorage {
    SimpleStorage[] public storeList;

    function createNewStorage() public {
        SimpleStorage store = new SimpleStorage();
        storeList.push(store);
    }

    function listStore() public view returns (SimpleStorage[] memory) {
        return storeList;
    }

    function saveByIndex(uint256 index, uint256 age)
        public
        returns (SimpleStorage)
    {
        SimpleStorage store = SimpleStorage(address(storeList[index]));
        store.store(age);
        return store;
    }
}
