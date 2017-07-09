/*
Crowdsale allows anyone to fund a project.
Backers can change their minds and get refunded at any time.
Once the goal has been reached, the beneficiary may withdraw the funds and close the campaign.
*/
pragma solidity ^0.4.8;

contract Crowdsale {
    modifier open() {
        if (campaignIsOpen) _;
    }
    modifier restricted() {
        if (msg.sender == beneficiary) _;
    }

    address public beneficiary;
    bool public campaignIsOpen;
    uint256 public fundingGoal; 
    uint256 public amountRaised;
    mapping(address => uint256) public fundAmount;

    function Crowdsale(uint _fundingGoal) {
        beneficiary = msg.sender;
        campaignIsOpen = true;
        fundingGoal = _fundingGoal;
        amountRaised = 0;
    }

    function () payable open {
        return Fund(msg.value);
    }
    function Fund(uint256 _value) open {
        
        if (_value > 0) {
            fundAmount[msg.sender] += _value;
            amountRaised += _value;
        }
        
    }
    function GetRefund() open {
        uint256 amount = fundAmount[msg.sender];
        fundAmount[msg.sender] = 0;
        amountRaised -= amount;
        msg.sender.transfer(amount);
    }
    function CloseCrowdSale() restricted{
        if(beneficiary == msg.sender) {
            if(amountRaised >= fundingGoal) {
                campaignIsOpen = false;
                msg.sender.transfer(amountRaised);
            } else {
                campaignIsOpen = true;
            }
        }
    }
}