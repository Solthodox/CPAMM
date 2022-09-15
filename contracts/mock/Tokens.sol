// SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract token0 is ERC20 {
    constructor() ERC20("Token0", "T0") {
        _mint(msg.sender, 500000 * 10**18);
    }
}

contract token1 is ERC20 {
    constructor() ERC20("Token1", "T1") {
        _mint(msg.sender, 500000 * 10**18);
    }
}
