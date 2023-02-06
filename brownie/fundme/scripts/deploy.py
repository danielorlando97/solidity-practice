from brownie import FundMe
from scripts.helpers import get_account, get_price_feed_address


def deploy_fund_me():
    account = get_account()
    # set publish_source = True for use the env var 
    # ETHERSCAN_TOKEN and to verified you contract 
    # in etherscan as easily way
    fund_me = FundMe.deploy(
        get_price_feed_address(),
        {'from': account}
    ) 
    print(f"Contract deploy to {fund_me.address}")  
    return fund_me

def main():
    deploy_fund_me()