pragma solidity ^0.4.4;


contract MPresto {
  struct Item {
    string name;
    uint quantity;
  }

  mapping(uint => address) itemToOwner;
  mapping(address => uint) ownerItemCount;

  Item[] public items;

  function createItem(string _name, uint _quantity) public {
    uint id = items.push(Item(_name, _quantity)) - 1;
    itemToOwner[id] = msg.sender;
    ownerItemCount[msg.sender]++;
    emit NewItem(id, _name, _quantity);
  }

  event NewItem(uint id, string name, uint quantity);
}
