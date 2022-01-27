// SPDX-License-Identifier: MIT
pragma solidity ^0.6.6;

import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";
import "@chainlink/contracts/src/v0.6/vendor/SafeMathChainlink.sol";

contract FundMe {
    using SafeMathChainlink for uint256;
    mapping(address => uint256) public donaciones;
    address[] fundadores;
    address public owner;
    AggregatorV3Interface public pricefeed;

    constructor(address _pricefeed) public {
        pricefeed = AggregatorV3Interface(_pricefeed);
        owner = msg.sender;
    }

    function fund() public payable {
        uint256 minimo = 50 * 10**18;
        require(
            convert(msg.value) >= minimo,
            "Do not be a cheap bastard, 50 dollars minimum"
        );
        donaciones[msg.sender] += msg.value;
        fundadores.push(msg.sender);
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function getPrice() public view returns (uint256) {
        (, int256 answer, , , ) = pricefeed.latestRoundData();
        return uint256(answer * 10000000000);
    }

    function convert(uint256 cantidad) public view returns (uint256) {
        uint256 precio = getPrice();
        uint256 precioEthUsd = (precio * cantidad) / (1000000000000000000);
        return precioEthUsd;
    }

    function getEntranceFee() public view returns (uint256) {
        //MinimumUSD
        uint256 minimumUsd = 50 * 10**18;
        uint256 price = getPrice();
        uint256 precision = 1 * 10**18;
        return (minimumUsd * precision) / price;
    }

    function withdraw() public payable onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
        for (
            uint256 fundIndex = 0;
            fundIndex < fundadores.length;
            fundIndex++
        ) {
            address fundador = fundadores[fundIndex];
            donaciones[fundador] = 0;
        }
        fundadores = new address[](0);
    }

    function displayBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
