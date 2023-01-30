from brownie import accounts, config, SimpleStorage, network


def read_deployed_contract():
    contract = SimpleStorage[-1]
    print(contract.retrieve())

def get_account():
    if network.show_active() == 'development':
        return accounts[0]
    
    return accounts.add(config['wallets']['from_key'])

def deploy_SS(): 
    # by yaml config 
    # account = accounts.add(config['wallets']['from_key'])

    account = get_account()
    contract = SimpleStorage.deploy({'from': account})
    stored_value = contract.retrieve()
    print(stored_value)
    tx = contract.store(15, {'from': account})
    tx.wait(1)
    update_store = contract.retrieve()
    print(update_store)

def main():
    deploy_SS()