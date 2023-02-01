from brownie import config, network

def get_price_feed_address():
    return config['network'][network.show_active()]['eth_usd_price_feed']