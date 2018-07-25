pragma solidity ^0.4.4;
import "openzeppelin-solidity/contracts/math/SafeMath.sol";

contract MPresto {
  using SafeMath for uint256;

  struct Item {
    string name;
    uint quantity;
  }

  mapping(uint => address) public itemToOwner;
  mapping(address => uint) ownerItemCount;

  Item[] public items;

  function createItem(string _name, uint _quantity) public {
    uint id = items.push(Item(_name, _quantity)) - 1;
    itemToOwner[id] = msg.sender;
    ownerItemCount[msg.sender]++;
    emit NewItem(id, _name, _quantity);
  }

  function getItemsByOwner(address _owner) public view returns (uint[]) {
    uint[] memory result = new uint[](ownerItemCount[_owner]);
    uint counter = 0;
    for (uint i = 0; i < items.length; i++) {
      if (itemToOwner[i] == _owner) {
        result[counter] = i;
        counter++;
      }
    }

    return result;
  }

  function transfer(address _to, uint _itemId) public {
    require(itemToOwner[_itemId] == msg.sender, 'Deny');
    ownerItemCount[_to] = ownerItemCount[_to].add(1);
    ownerItemCount[msg.sender] = ownerItemCount[msg.sender].sub(1);
    itemToOwner[_itemId] = _to;
    emit Transfer(msg.sender, _to, _itemId);
  }

  event NewItem(uint id, string name, uint quantity);
  event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
}
