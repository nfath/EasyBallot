// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract EasyBallotToken is ERC20 {
    address public owner;

    struct Voting{
        uint[5] options;
        uint deadline;
        bool votingState;
    }
    Voting public votings;

    constructor(uint deadlineTime) ERC20("EasyBallotToken", "EBT") {
        owner = msg.sender;
        _mint(msg.sender, 1000 * 10 ** 18);
        votings.deadline = block.timestamp + deadlineTime * 1 days;
        votings.votingState = true;
    }

    modifier isOwner(){
        require(msg.sender == owner,"You are not owner!");
        _;
    }

    modifier isVoterValid(address _voter) {
        require(this.balanceOf(_voter) > 0,"There is not any balance space!");
        _;
    }

    modifier isVotingOpen(){
        require(block.timestamp >= votings.deadline, "Voting is closed!");
        //votings.votingState = false;
        _;
    }

    function doVote(uint _option) public isVoterValid(msg.sender) isVotingOpen(){
        require( _option < votings.options.length, "voting is valid for 5 options that start with 0");
        transfer(address(this), 1);
        uint curOpt = votings.options[_option];
        curOpt ++;
        votings.options[_option] = curOpt;
    }

    function getVotingState() public view returns(bool){
        if(votings.votingState){
            return true;
        }
        else {
            return false;
        }
    }

    function getVotes() public view returns(uint[5] memory){
        return votings.options;
    }
}
