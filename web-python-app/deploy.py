from solcx import compile_standard
import json
import web3


with open('../contracts/SimpleStorage.sol', 'r') as f:
    contract = f.read()
    f.close()
# compile our solidity
    compiled_sol = compile_standard(
        {
            "language": "Solidity",
            "sources": {"SimpleStorage.sol": {"content": contract}},
            "settings": {
                "outputSelection": {
                    "*": {
                        "*": ["abi", "metadata", "evm.bytecode", "evm.bytecode. sourceMap"]
                    }
                }
            }
        },
        solc_version="0.8.0"
    )

    print("It's compiled")


with open('compiled.json', 'w') as f:
    json.dump(compiled_sol, f)


tecode = compiled_sol["contracts"]['SimpleStorage.sol']['SimpleStorage']["evm"]["bytecode"]['object']
abi = compiled_sol["contracts"]['SimpleStorage.sol']['SimpleStorage']["abi"]

w3 = web3.Web3(web3.Web3.HTTPProvider('HTTP://127.0.0.1:7545'))
chain_id = 5777
my_address = "0xAf79971d2BAf2a4DEdff14F7ae70e806Efa9077e"
private_key = "50e65e2173039e944c9b4fc97171cc50bf79711160445d12cbe2a06f12d9cf9f"

SimpleStorage = w3.eth.contract(abi = abi, bytecode = tecode)
nonce = w3.eth.getTransactionCount(my_address)

#In web3.py we need to give atleast a couple of parameters.
# We always have to give chainId, from and nonce.

#If we print the transaction, we could see even more parameters.
#We have value which is the ether that we're going to send, gas, gasPrice 
#which we can arbitrarily set if we'd like, chainId, from, nonce, data and 
#to which is just empty because it's sending it to the blockchain.

tx = SimpleStorage.constructor().buildTransaction({
    # "chainId" : chain_id, 
    'from': my_address, 'nonce': nonce,"gasPrice": w3.eth.gas_price
})
print(tx)
print('It born')

# If you encounter the following error:
# - [Transaction must not include unrecognized fields]
#   (https://stackoverflow.com/questions/70458501/typeerror-transaction-must-not-include-unrecognized-value-solidity-python)
# - [ValueError: Method eth_maxPriorityFeePerGas not supported]
#   (https://stackoverflow.com/questions/70104101/valueerror-method-eth-maxpriorityfeepergas-not-supported-web3-py-with-ganache)


signed_tx = w3.eth.account.sign_transaction(tx, private_key = private_key)
# print(signed_tx)
print('Transaction signed')

tx_hash = w3.eth.send_raw_transaction(signed_tx.rawTransaction)
# print(tx_hash)
print('Transaction deployed')
