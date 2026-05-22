// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.26;

import "forge-std/Test.sol"; 
import "../contracts/BinhaToken.sol";

/**
 * @title BinhaTokenTest
 * @author felipetojal
 * @notice This contract runs tests on BinhaToken.sol
 */
contract BinhaTokenTest is Test {
    BinhaToken token;

    // Hardhat automatically gives a fake address
    address owner = address(this);

    // Function setUp runs automatically before the tests
    function setup() public {
        token = new BinhaToken();
    }

    // Auxiliary function to compare strings
    function compareString(string memory string1, string memory string2) internal returns (bool) {
        return bytes32(abi.encode(string1)) == bytes32(abi.encode(string2));
    }

    // Testing the name() function 
    function testName() public {
        require(
            compareString(token.name(), "BINHA"),
            "TOKEN NAME IS INCORRECT"
         );
    }

    // Testing the symbol() function
    function testSymbol() public {
        require(
            compareString(token.name(), "BINHA"),
            "TOKEN NAME IS INCORRECT"
        );
    }

    // Testing the decimals() function
    function testDecimals() public {
        assertEq(token.decimals(), 18);
    }

    // Testing the totalSupply() function
    function testTotalSupply() public {
        assertEq(token.totalSupply(), 1_000_000_000 * uint256(10 ** token.decimals()));
    }

    // Testing the balanceOf() function
    function testBalanceOf() public {
        assertEq(token.balanceOf(owner), token.totalSupply());
    }

    // Testing the transfer() function
    function testTransfer() public {
        address nick = address(0x123);
        address playmobil = address (0x789);

        // Transfering tokens from owner to playmobil.
        bool success = token.transfer(playmobil, 4_000_000);
        require (
            success,
            "FAILED TO TRANSFER TOKEN TO PLAYMOBIL"
        );
        assertEq(token.balanceOf(playmobil), 4_000_000 * uint256(10 ** token.decimals()));
        uint256 owner_balance = 1_000_000_000 - 4_000_000;
        assertEq(token.balanceOf(owner), owner_balance * uint256(10 ** token.decimals()));

        // Transfering tokens from owner to nick.
        success = token.transfer(nick, 1_000_000);
        require (
            success,
            "FAILED TO TRANSFER TOKEN TO NICK"
        );
        assertEq(token.balanceOf(nick), 1_000_000 * uint256(10 ** token.decimals()));
        owner_balance -= 1_000_000;
        assertEq(token.balanceOf(owner), owner_balance * uint256(10 ** token.decimals()));
    }

}