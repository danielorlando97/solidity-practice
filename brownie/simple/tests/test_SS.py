from brownie import accounts, SimpleStorage

def test_deploy():
    # Arrange
    account = accounts [0]
    # Act
    ss_contract = SimpleStorage.deploy({"from": account})
    starting_value = ss_contract.retrieve( )
    expected = 0
    # Assert
    assert starting_value == expected