// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Auction {
    address payable public owner;
    uint public startTime;
    uint public endTime;
    uint public extensionWindow = 10 minutes;

    struct Bid {
        address bidder;
        uint amount;
    }

    Bid[] public bids;
    mapping(address => uint) public deposits;
    mapping(address => uint[]) public userBids;

    Bid public highestBid;
    bool public ended = false;

    event NewBid(address indexed bidder, uint amount);
    event AuctionEnded(address winner, uint amount);

    constructor(uint _durationMinutes) {
        owner = payable(msg.sender);
        startTime = block.timestamp;
        endTime = startTime + (_durationMinutes * 1 minutes);
    }

    modifier auctionActive() {
        require(block.timestamp < endTime && !ended, "Auction not active");
        _;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    function bid() external payable auctionActive {
        require(msg.value > 0, "Must send ETH");
        require(msg.value >= highestBid.amount * 105 / 100 || highestBid.amount == 0, "Bid must be at least 5% higher");

        deposits[msg.sender] += msg.value;
        userBids[msg.sender].push(msg.value);

        bids.push(Bid(msg.sender, msg.value));
        highestBid = Bid(msg.sender, msg.value);

        if (endTime - block.timestamp <= extensionWindow) {
            endTime += extensionWindow;
        }

        emit NewBid(msg.sender, msg.value);
    }

    function showWinner() external view returns (address, uint) {
        require(ended, "Auction not ended yet");
        return (highestBid.bidder, highestBid.amount);
    }

    function showBids() external view returns (Bid[] memory) {
        return bids;
    }

    function partialRefund() external {
        uint[] storage bidsOfUser = userBids[msg.sender];
        uint totalRefund = 0;

        for (uint i = 0; i < bidsOfUser.length - 1; i++) {
            totalRefund += bidsOfUser[i];
            bidsOfUser[i] = 0;
        }

        require(totalRefund > 0, "No refundable bids");
        deposits[msg.sender] -= totalRefund;
        payable(msg.sender).transfer(totalRefund);
    }

    function finalizeAuction() external onlyOwner {
        require(!ended, "Auction already ended");
        require(block.timestamp >= endTime, "Auction still running");

        ended = true;
        uint commission = highestBid.amount * 2 / 100;
        owner.transfer(highestBid.amount - commission);

        for (uint i = 0; i < bids.length; i++) {
            if (bids[i].bidder != highestBid.bidder) {
                uint amount = deposits[bids[i].bidder];
                if (amount > 0) {
                    deposits[bids[i].bidder] = 0;
                    payable(bids[i].bidder).transfer(amount);
                }
            }
        }

        emit AuctionEnded(highestBid.bidder, highestBid.amount);
    }
}
