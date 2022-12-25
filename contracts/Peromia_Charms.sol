// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";

/// @custom:security-contact 0xfushi
contract Peromia_Charms is ERC1155URIStorage, Ownable, ERC1155Supply {
    constructor() ERC1155("QmbbxiWBagKGZEsTiLsH1jJepAC4Y4EkAjugwMhxEbP7xo") {}

    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
        _setBaseURI(newuri);
    }

    function uri(uint256 _id) external override view returns (string memory){
      if(id == 1){
       return string(abi.encodePacked(_baseURI, "aircharm.json"); 
      }else if(id == 2){
        return string(abi.encodePacked(_baseURI, "firecharm.json");
      }else if(id == 3){
        return string(abi.encodePacked(_baseURI, "watercharm.json");
      }else if(id == 4){
        return string(abi.encodePacked(_baseURI, "naturecharm.json");
      }else if(id == 5){
        return string(abi.encodePacked(_baseURI, "rockcharm.json"); 
      }else{
        return string(abi.encodePacked(_baseURI, "secret.json");
      }
    }

    //This will eventually be controlled by the game engine instead of the owner multisig.
    function ownerBatchCreate(address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
        public
        onlyOwner
    {
        _mintBatch(to, ids, amounts, data);
    }

    function mint()
        external
    {  
      //only available until Jan 25th, 2023
      require(block.timestamp <= 1674622800, "Minting window closed on January 25th, 2023.");
      
      //mint 10 random tokens (id = 0-4)
      uint id = block.hash % 5;
      _mint(msg.sender, id, 10, "");
    }

    function paidMint(uint _id) external{
      //only available until Jan 25th, 2023
      require(block.timestamp <= 1674622800, "Minting window closed on January 25th, 2023.");

      //pay me please
      require(msg.value >= 10000000000000000, "Error: fee amount is not enough. Please send 0.01 ETH");

      //id must be 0-4, so it is correct type of charm.
      require(_id < 5, "Please enter an ID less than 5");

      _mint(msg.sender, _id, 200, "");
    }

    // The following function is an override required by Solidity.
    function _beforeTokenTransfer(address operator, address from, address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
        internal
        override(ERC1155, ERC1155Supply)
    {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
    }

    function ownerWithdraw() public onlyOwner{
      address payable ownerAddress = owner;
      uint256 amount = address(this).balance;
      ownerAddress.call.value(amount)("");
  }

}
