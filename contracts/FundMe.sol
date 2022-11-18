// SPDX-License-Identifier:MIT

pragma solidity ^0.8.0;

import "./PriceConsumer.sol";
import "hardhat/console.sol";

// import "@chainlink/contracts/src/v0.8/vendor/SafeMathChainlink.sol";

contract FundMe {
    mapping(address => uint256) public addressFundAmount;
    mapping(address => uint256) public addressFundGas;
    address[] public senders;
    address public immutable owner;
    uint256 public constant MIN_USD = 50 * 10**18;

    PriceConsumerV3 internal priceConsumer;

    constructor() payable {
        priceConsumer = new PriceConsumerV3();
        owner = msg.sender;
    }

    function fund() public payable {
        // Check if sender fund me already
        if (addressFundAmount[msg.sender] == 0) {
            // Check the minimun amount to fund me

            require(
                priceConsumer.convert(msg.value) >= MIN_USD,
                "You need to spend more ETH!"
            );
            // Save people fund me
            addressFundAmount[msg.sender] = msg.value;
            addressFundAmount[msg.sender] = gasleft();
            senders.push(msg.sender);
        }
    }

    function mappingAddressFundAmount() public view returns (address[] memory) {
        return senders;
    }

    function getCurrentPrice() public view returns (uint256) {
        uint256 result = priceConsumer.getLatestPrice();
        return result;
    }

    modifier admin() {
        require(msg.sender == owner);
        _;
    }

    function withDraw() public payable admin {
        // The global variables tx.origin and msg.sender
        // have the type address instead of address payable.
        //One can convert them into address payable by using
        //an explicit conversion, i.e., payable(tx.origin) or payable(msg.sender).
        payable(msg.sender).transfer(address(this).balance);
    }

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }
}
