from brownie import accounts, exceptions
from scripts.tools import deploy_lottery_smart_contract, deploy_price_consumer_smart_contract
from scripts.tools import get_minimal_usd_fee

def test_close_state():
    # Arrange
    account  = accounts[0]
    minimal_fee = get_minimal_usd_fee() + 20
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
        """The lottery must be close"""

def test_open_state():
    # Arrange
    account  = accounts[0]
    minimal_fee = get_minimal_usd_fee() + 20
    lottery = deploy_lottery_smart_contract(account)   
    price = deploy_price_consumer_smart_contract(account)

    # Act
    lottery.start()
    tx_value = price.convertUsdToWei(minimal_fee * 10 ** 8)

    # Assert
    try:

        lottery.enterNewPlayer({
            'from': accounts[1],
            'value': tx_value
        })
        
    except exceptions.VirtualMachineError:
        assert False

def test_owner():
    # Arrange
    account  = accounts[0]
    other_user  = accounts[2]
    lottery = deploy_lottery_smart_contract(account)   

    # Act

    # Assert
    try:
        lottery.start({'from': other_user})
        assert False
    except exceptions.VirtualMachineError:
        """Only the owner can start it"""