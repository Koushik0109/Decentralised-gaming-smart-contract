pragma solidity ^0.8.0;

contract Game {
    struct Item {
        address owner;
        string name;
        string description;
    }
    mapping(uint256 => Item) public items;
    mapping(address => mapping(uint256 => bool)) public itemOwnership;
    uint256 public nextItemId;
    event NewItem(uint256 itemId, address creator, string name, string description);
    event ItemTransfer(uint256 itemId, address from, address to);

    constructor() public {
        nextItemId = 0;
    }

    function createItem(string memory _name, string memory _description) public {
        items[nextItemId] = Item(msg.sender, _name, _description);
        itemOwnership[msg.sender][nextItemId] = true;
        emit NewItem(nextItemId, msg.sender, _name, _description);
        nextItemId++;
    }

    function transferItem(uint256 _itemId, address _to) public {
        require(itemOwnership[msg.sender][_itemId], "You do not own this item.");
        itemOwnership[msg.sender][_itemId] = false;
        itemOwnership[_to][_itemId] = true;
        emit ItemTransfer(_itemId, msg.sender, _to);
    }

        function getItem(uint256 _itemId) public view returns (address, string memory, string memory) {
        return (items[_itemId].owner, items[_itemId].name, items[_itemId].description);
    }
     function isItemOwner(uint256 _itemId) public view returns (bool) {
        return itemOwnership[msg.sender][_itemId];
    }
}

