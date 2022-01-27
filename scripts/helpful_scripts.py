from brownie import accounts, network, MockV3Aggregator

LOCAL_BLOCKCHAINS = ["development", "ganache-local"]
DECIMALS = 8
STARTING_PRICE = 200000000000


def get_account():
    if network.show_active() in LOCAL_BLOCKCHAINS:
        return accounts[0]
    else:
        return accounts.load("freecodecamp-account")


def deploy_mocks():
    print(f"The active network is {network.show_active()}")
    print("Deploying Mocks...")
    if len(MockV3Aggregator) <= 0:
        MockV3Aggregator.deploy(DECIMALS, STARTING_PRICE, {"from": get_account()})
    print(f"Mocks deployed, using mock price feed at {MockV3Aggregator[-1].address}")
