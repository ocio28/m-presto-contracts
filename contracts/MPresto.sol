pragma solidity ^0.4.24;
import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "openzeppelin-solidity/contracts/token/ERC721/ERC721Full.sol";

contract MPresto is ERC721Full {
  using SafeMath for uint256;

  struct Item {
    string name;
    uint256 quantity;
  }

  Item[] public items;

  mapping(bytes32 => address) public nicknames;
  mapping(address => bytes32) public ownerNickname;

  constructor () ERC721Full("MPresto", "MPTO") public {}

  function createItem(string _name, uint256 _quantity) public {
    uint256 id = items.push(Item(_name, _quantity)).sub(1);
    _mint(msg.sender, id);
    emit NewItem(id, _name, _quantity);
  }

  function getItem(uint256 _id) public view returns (string, uint256, address, bytes32) {
    require(_id < items.length);
    Item storage item = items[_id];
    address owner = ownerOf(_id);
    bytes32 nickname = ownerNickname[owner];
    return (item.name, item.quantity, owner, nickname);
  }

  function getItemsByOwner(address _owner) public view returns (uint256[]) {
    uint256 total = balanceOf(_owner);
    uint256[] memory result = new uint256[](total);

    for (uint256 i = 0; i < total; i++) {
      result[i] = tokenOfOwnerByIndex(_owner, i);
    }

    return result;
  }

  function transfer(address _to, uint256 _id) public {
    transferFrom(msg.sender, _to, _id);
  }

  function setNickname(bytes32 _nickname) public {
    require(nicknames[_nickname] == 0x0);
    bytes32 current = ownerNickname[msg.sender];
    nicknames[_nickname] = msg.sender;
    nicknames[current] = 0x0;
    ownerNickname[msg.sender] = _nickname;
    emit ChangeNickname(current, _nickname, msg.sender);
  }

  event NewItem(uint256 id, string name, uint256 quantity);
  event ChangeNickname(bytes32 _from, bytes32 _to, address indexed _owner);
}
