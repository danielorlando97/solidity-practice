// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;

import "@chainlink/contracts/src/v0.7/VRFConsumerBase.sol";

contract RandomNumber is VRFConsumerBase {
    bytes32 internal keyhash;
    uint256 public fee;
    bytes32 internal lastRequestId;
    function(uint256) external callback;

    constructor(
        address _vrfCoordinator,
        address _link,
        uint256 _fee,
        bytes32 _keyhash
    ) public VRFConsumerBase(_vrfCoordinator, _link) {
        fee = _fee;
        keyhash = _keyhash;
        // callback = f;
    }

    function requestRandomValue() public returns (bytes32) {
        lastRequestId = requestRandomness(keyhash, fee);
        return lastRequestId;
    }

    function subcribe(function(uint256) external f) public {
        callback = f;
    }

    function fulfillRandomness(bytes32 _requestId, uint256 _randomness)
        internal
        override
    {
        require(_randomness > 0, "random-not-found");
        callback(_randomness);
    }
}
