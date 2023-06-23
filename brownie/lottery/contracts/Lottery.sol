// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;

import "./PriceConsumer.sol";
import "./RandomNumber.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

enum LOTTERY_STATE {
    OPEN,
    CLOSE,
    CALCULATING_WINNERS
}

contract Lottery is Ownable {
    address payable[] public players;
    uint256 internal minimalFee; // x USD * 10 ** 8
    PriceConsumerV3 internal priceFeed;
    RandomNumber internal randomNumber;
    LOTTERY_STATE internal lottery_state;
    address payable public recentWinner;

    constructor(
        address _priceFeed,
        uint256 _minimalFee,
        address _vrfCoordinator,
        address _link,
        uint256 _fee,
        bytes32 _keyhash
    ) {
        priceFeed = new PriceConsumerV3(_priceFeed);
        randomNumber = new RandomNumber(_vrfCoordinator, _link, _fee, _keyhash);
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

    function end() public {
        lottery_state = LOTTERY_STATE.CALCULATING_WINNERS;

        // to call a method of contract as delegate we must define it as
        // esternal and we have to refer it as this.delegate_name
        randomNumber.subcribe(this.distributionOfPrices);
        randomNumber.requestRandomValue();
    }

    function distributionOfPrices(uint256 _randomValue) external {
        uint256 indexOfWinner = _randomValue % players.length;
        recentWinner = players[indexOfWinner];
        recentWinner.transfer(address(this).balance);
        // Reset
        players = new address payable[](0);
        lottery_state = LOTTERY_STATE.CLOSE;
    }
}
