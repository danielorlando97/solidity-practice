// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;

import "./PriceConsumer.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

enum LOTTERY_STATE {
    OPEN,
    CLOSE,
    CALCULATING_WINNERS
}

contract Lottery is Ownable {
    address[] public players; // address payable[] public players
    uint256 internal minimalFee; // x USD * 10 ** 8
    PriceConsumerV3 internal priceFeed;
    LOTTERY_STATE internal lottery_state;

    constructor(address _priceFeed, uint256 _minimalFee) {
        priceFeed = new PriceConsumerV3(_priceFeed);
        minimalFee = _minimalFee * 10**8;
        lottery_state = LOTTERY_STATE.CLOSE;
    }

    function enterNewPlayer() public payable {
        require(lottery_state == LOTTERY_STATE.OPEN, "the lottery is close");
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

    function start() public onlyOwner {
        require(lottery_state == LOTTERY_STATE.CLOSE, "it has already started");
        lottery_state = LOTTERY_STATE.OPEN;
    }

    function end() public {}

    function distributionOfPrices() public {}
}
