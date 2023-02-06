from brownie import config, network, Lottery, PriceConsumerV3

def get_price_feed_address():
    return config['networks'][network.show_active()]['eth_usd_price_feed']

def get_minimal_usd_fee():
    return config['app_config']['minimal_usd_fee']

def deploy_lottery_smart_contract(account):
    # if len(Lottery) > 0:
    #     return Lottery[-1]

    return Lottery.deploy(
        get_price_feed_address(), 
        get_minimal_usd_fee(),
        {'from': account}
    )

def deploy_price_consumer_smart_contract(account):
    if len(PriceConsumerV3) > 0:
        return PriceConsumerV3[-1]

    return PriceConsumerV3.deploy(
        get_price_feed_address(),
        {'from': account}
    )
