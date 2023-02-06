// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;

import "./PriceConsumer.sol";

contract Lottery {
    address[] public players; // address payable[] public players
    uint256 internal minimalFee; // x USD * 10 ** 8
    PriceConsumerV3 internal priceFeed;

    constructor(address _priceFeed, uint256 _minimalFee) {
        priceFeed = new PriceConsumerV3(_priceFeed);
        minimalFee = _minimalFee * 10**8;
    }

    function enterNewPlayer() public payable {
        checkMinimalFee();

        players.push(msg.sender);
    }

    function getEntranceFee() public view returns (uint256) {
        uint256 result = uint256(priceFeed.convertUsdToWei(minimalFee));
        return result;
    }

    function checkMinimalFee() internal {
        uint256 minimalWei = uint256(priceFeed.convertUsdToWei(minimalFee));
        uint256 userUsdFee = uint256(priceFeed.convertWeiToUsd(msg.value));

        require(
            msg.value >= minimalWei || userUsdFee >= minimalFee,
            "Not enough ETH!"
        );
    }

    function start() public {}

    function end() public {}

    function distributionOfPrices() public {}
}
