//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

//create token for the donators
contract THXToken is ERC20 {
    constructor(uint256 initialSupply) ERC20("Thanks", "THX") {
        _mint(msg.sender, initialSupply);
    }
}
