// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract VotingSystem {

    enum State { Initialized, Opened, Closed }

    struct Election {
        uint64 id;
        string proposal;
        State state;
        uint256 agrees;
        uint256 disagrees;
    }

    address immutable public Coordinator;
    Election private _election;

    mapping (address => mapping (uint64 => bool)) private _voters;


    event AddProposal(uint64 indexed id, string propsal);
    event AddVoter(uint64 indexed id, address voter);
    event StartVoting(uint64 indexed id);
    event EndVoting(uint64 indexed id, uint256 agrees, uint256 disagrees);


    modifier onlyCoordinator {
        require(msg.sender == Coordinator, "Voting System: Not authorized.");
        _;
    }

    modifier isState(State state) {
        require(_election.state == state, "Voting System: Invalid State.");
        _;
    }
    

    constructor () {
        Coordinator = msg.sender;
        _election.state = State.Closed;
    }


    function addProposal(string calldata proposal) 
    external 
    onlyCoordinator 
    isState(State.Closed) 
    {
        _election = Election(_election.id + 1, proposal, State.Initialized, 0, 0);

        emit AddProposal(_election.id, proposal);
    }


    function addVoter(address voter) 
    external onlyCoordinator
    isState(State.Initialized)
    {
        _voters[voter][_election.id] = true;

        emit AddVoter(_election.id, voter);
    }


    function startVoting() 
    external 
    onlyCoordinator 
    isState(State.Initialized)
    {
        _election.state = State.Opened;
        emit StartVoting(_election.id);
    }


    function vote(bool agree) 
    external 
    isState(State.Opened)
    {
        require(_voters[msg.sender][_election.id], "Voting System: You don't have permission to vote.");

        _voters[msg.sender][_election.id] = false;

        if (agree)
            _election.agrees++;
        else
            _election.disagrees++;
    }

    
    function endVoting() 
    external 
    onlyCoordinator
    isState(State.Opened)
    {
        _election.state = State.Closed;

        emit EndVoting(_election.id, _election.agrees, _election.disagrees);
    }


    function getCurrentElection() external view returns (Election memory) { 
        return _election; 
    }

}

