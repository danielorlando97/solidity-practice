// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;

import "@chainlink/contracts/src/v0.7/interfaces/AggregatorV3Interface.sol";

contract PriceConsumerV3 {
    AggregatorV3Interface internal priceFeed;

    /**
     * Network: Goerli
     * Aggregator: ETH/USD
     * Address: 0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e
     */
    constructor(address _priceFeed) {
        priceFeed = AggregatorV3Interface(
            _priceFeed
            // 0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e
        );
    }

    /**
     * Returns the latest price
     *  price is (how much USD is igual than a ETH) * 10 ^ 8
     *  So, x Eth * price = y USD * 10 ^ 8
     */
    function getLatestPrice() public view returns (uint256) {
        (, int256 price, , , ) = priceFeed.latestRoundData();
        return uint256(price);
    }

    /**
     * Exprect y ETH * 10 ** 18 => z WEI
     * Returns x USD * 10 ** 8
     */
    function convertWeiToUsd(uint256 weiFundedAmount)
        public
        view
        returns (uint256)
    {
        uint256 ethPrice = getLatestPrice();

        // Here, there's a big unit change, from 10^18 to 10^8
        // So this operation can be unstable
        uint256 inUSD = (ethPrice * weiFundedAmount) / (10**18);
        return inUSD;
    }

    /**
     * Exprect x USD * 10 ** 8
     * Returns x ETH * 10 ** 18 => z WEI
     */
    function convertUsdToWei(uint256 usdValue) public view returns (uint256) {
        uint256 ethPrice = getLatestPrice();

        // Here, the change is upward
        // And in the divition the dimentions keep stable
        // So this operation is more stable and sure
        return (usdValue * 10**18) / ethPrice;
    }
}
