from brownie import network, accounts, config, MockV3Aggregator
from web3 import Web3

DECIMALS = 18
STARING_PRICE = 2000

LOCAL_BLOCKCHAINS = ['development', 'ganache-local']

def get_account():
    if network.show_active() in LOCAL_BLOCKCHAINS:
        return accounts[0]
    else:
        return accounts.add(config["wallets"]['from_key'])

def get_price_feed_address():
    if network.show_active() in LOCAL_BLOCKCHAINS:
        return deploy_price_feed_mock()

    return config['networks'][network.show_active()][
        'eth_usd_price_feed'
    ]

def deploy_price_feed_mock():
    # return "0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e" # an address
    if len(MockV3Aggregator) <= 0:
        print('Deploying MockV3Aggregator')
        MockV3Aggregator.deploy(
            DECIMALS, Web3.toWei(STARING_PRICE, "ether"), 
            {'from': get_account()}
        )
    
    return MockV3Aggregator[-1].address
