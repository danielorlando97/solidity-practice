// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;

import "@chainlink/contracts/src/v0.7/interfaces/AggregatorV3Interface.sol";

contract PriceConsumerV3 {
    AggregatorV3Interface internal priceFeed;
    uint256 public mathFactor;

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
        uint256 inUSD = (ethPrice * weiFundedAmount) / (10**18);
        return inUSD;
    }

    function convertUsdToWei(uint256 usdValue) public view returns (uint256) {
        uint256 usd = usdValue * 10**26;
        uint256 ethPrice = getLatestPrice();
        return usd / ethPrice;
    }
}
