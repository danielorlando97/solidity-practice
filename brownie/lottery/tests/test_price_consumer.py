from scripts.tools import deploy_price_consumer_smart_contract
from brownie import accounts

def test_change_ust_to_wei():

    # Arrange
    account = accounts[0]
    price = deploy_price_consumer_smart_contract(account)
    usd = 20 * 10 ** 8

    # Act
    wei = price.convertUsdToWei(usd)
    new_usd = price.convertWeiToUsd(wei)

    # Assert
    
    assert abs(usd - new_usd) < 2


def test_change_wei_to_usd():

    # Arrange
    account = accounts[0]
    price = deploy_price_consumer_smart_contract(account)
    wei = 10 * 10 ** 18

    # Act
    usd = price.convertWeiToUsd(wei)
    new_wei = price.convertUsdToWei(usd)
    

    # Assert
    
    assert wei == new_wei