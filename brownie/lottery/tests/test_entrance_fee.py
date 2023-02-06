from brownie import accounts, exceptions
from scripts.tools import deploy_lottery_smart_contract, deploy_price_consumer_smart_contract
from scripts.tools import get_minimal_usd_fee

def test_get_entrance_fee():
    # Arrange
    account = accounts[0]
    minimal_fee = get_minimal_usd_fee()
    lottery = deploy_lottery_smart_contract(account)
    price = deploy_price_consumer_smart_contract(account)

    # Act
    wei = price.convertUsdToWei(minimal_fee * 10 ** 8)
    entrance_fee = lottery.getEntranceFee()

    # Assert
    assert wei == entrance_fee

def test_success_entrance_fee_checked():
    
    # Arrange
    account  = accounts[0]
    minimal_fee = get_minimal_usd_fee()
    lottery = deploy_lottery_smart_contract(account)   
    price = deploy_price_consumer_smart_contract(account)

    # Act
    tx_value = price.convertUsdToWei(minimal_fee * 10 ** 8)

    # Assert
    lottery.enterNewPlayer({
        'from': accounts[1],
        'value': tx_value
    })

def test_fail_entrance_fee_checked():
    
    # Arrange
    account  = accounts[0]
    minimal_fee = get_minimal_usd_fee() - 1
    lottery = deploy_lottery_smart_contract(account)   
    price = deploy_price_consumer_smart_contract(account)

    # Act
    tx_value = price.convertUsdToWei(minimal_fee * 10 ** 8)

    # Assert
    try:

        lottery.enterNewPlayer({
            'from': accounts[1],
            'value': tx_value
        })
        assert False
    except exceptions.VirtualMachineError:
        pass