from brownie import accounts, FundMe
from scripts.helpful_scripts import get_account


def fund():
    fund_me = FundMe[-1]  # Latest contract
    account = get_account()
    # Getting the entrace fee to fund the contract
    entrance_fee = fund_me.getEntranceFee()
    print(f"The current entry fee is {entrance_fee}")
    print("Funding")
    fund_me.fund({"from": account, "value": entrance_fee})


def withdraw():
    fund_me = FundMe[-1]
    account = get_account()
    fund_me.withdraw({"from": account})


def main():
    fund()
    withdraw()
