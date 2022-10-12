// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Tickets {
    address public owner = msg.sender;
    uint256 constant TOTAL_TICKETS = 10;
    uint public rand = 1;

    struct Ticket {
        uint256 id;
        uint256 price;
        bool isSold;
        address owner;
    }

    Ticket[TOTAL_TICKETS] public tickets;

    constructor() public {
        for(uint256 i = 0; i < TOTAL_TICKETS; i++) {
            tickets[i].id = i;
            tickets[i].price = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, i))) % 100; // random
            tickets[i].owner = address(0x0);
        }
    }

    function buyTicket(uint256 _index) external payable {
        require(_index < TOTAL_TICKETS && _index >= 0);
        require(tickets[_index].owner == address(0x0));
        require(msg.value >= tickets[_index].price);
        tickets[_index].owner = msg.sender;
        
    }

}