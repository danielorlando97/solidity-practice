from brownie import Lottery, accounts, config, network
from scripts.tools import get_price_feed_address
from web3 import Web3

def test_get_entrance_fee():
    # Arrange
    account = accounts[0]
    lottery = Lottery.deploy(
        get_price_feed_address(), 50,
        {'from': account}
    )

    # Act
    expected_entrance_fee = Web3.toWei(0.025, "ether")
    entrance_fee = lottery.getEntranceFee()

    # Assert
    assert expected_entrance_fee == entrance_fee