from scripts.helpers import get_account, LOCAL_BLOCKCHAINS
from scripts.deploy import deploy_fund_me
import pytest
from brownie import network, accounts, exceptions


# TODO: write a contract to manipulate the wei manipulation 
# contract DecimalWei:
#   def convert(wei) -> wei * factor
#   def get_factor -> factor 
#
# after that all of money value have to div out the blockchain 

def test_fund_and_withdraw():
    account = get_account()
    fund_me = deploy_fund_me()
    entrance_fee = fund_me.getCurrentPrice()
    print(entrance_fee)

    tx = fund_me.fund({'from': account, "value": entrance_fee})
    tx.wait(1)
    assert fund_me.addressFundAmount(account.address) == entrance_fee

def test_only_owner_can_withdraw():
    if network.show_active() not in LOCAL_BLOCKCHAINS:
        pytest.skip("only for local testing")
    
    fund_me = deploy_fund_me()
    bad_actor = accounts.add()

    with pytest.raises(exceptions.VirtualMachineError):
        fund_me.withDraw({'from' : bad_actor})