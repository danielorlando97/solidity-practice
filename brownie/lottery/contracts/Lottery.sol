// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;

import "./PriceConsumer.sol";

contract Lottery {
    address[] public players; // address payable[] public players
    uint256 minimalFee;
    PriceConsumerV3 internal priceFeed;

    constructor(address _priceFeed, uint256 _minimalFee) {
        priceFeed = PriceConsumerV3(priceFeed);
        minimalFee = minimalFee * (10**18);
    }

    function enterNewPlayer() public payable {
        players.push(msg.sender);
    }

    function getEntranceFee() public view returns (uint256) {
        uint256 price = priceFeed.getLatestPrice();
        return (minimalFee * 10**18) / (price * 10**10);
    }

    function start() public {}

    function end() public {}

    function distributionOfPrices() public {}
}
