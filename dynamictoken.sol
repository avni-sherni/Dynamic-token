pragma solidity ^0.8.0;

contract DynamicPricingToken {
    mapping(address => uint256) public balances;
    uint256 public totalSupply;
    uint256 public price = 1 ether; // Initial price per token
    uint256 public volumeFactor = 0.01 ether; // Price change per token
    address public owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    function buy() public payable {
        require(msg.value > 0, "Send ETH to buy tokens");
        uint256 tokensToMint = msg.value / price;
        require(tokensToMint > 0, "Insufficient ETH for tokens");

        balances[msg.sender] += tokensToMint;
        totalSupply += tokensToMint;
        price += tokensToMint * volumeFactor; // Increase price based on volume
    }

    function sell(uint256 amount) public {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        uint256 ethAmount = amount * price;
        require(address(this).balance >= ethAmount, "Contract has insufficient funds");
        
        balances[msg.sender] -= amount;
        totalSupply -= amount;
        price -= amount * volumeFactor; // Decrease price based on volume
        payable(msg.sender).transfer(ethAmount);
    }
    
    function fundContract() public payable onlyOwner {}
}
