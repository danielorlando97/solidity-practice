from brownie import PriceConsumerV3
from scripts.helpers import get_account, get_price_feed_address
from web3 import Web3

def deploy_fund_me():
    account = get_account()
    # set publish_source = True for use the env var 
    # ETHERSCAN_TOKEN and to verified you contract 
    # in etherscan as easily way
    price = PriceConsumerV3.deploy(
        get_price_feed_address(),
        {'from': account}
    ) 
    print(f"Contract deploy to {price.address}")  

    print(f'One Eth is equal than {price.getLatestPrice() / 10 ** 8} Usd')
    eth = 20
    wei = Web3.toWei(20, "ether")

    print(f'So, {eth} Eth is equal than {price.convertWeiToUsd(wei) / 10 ** 8} Usd')
    usd = 50
    
    print(f'So, {usd} Usd is equal than {price.convertUsdToWei(usd) / 10 ** 18} Eth')

    return price

def main():
    deploy_fund_me()