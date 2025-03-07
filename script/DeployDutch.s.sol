// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.13;

import "forge-std/console2.sol";
import "forge-std/Script.sol";
import {IPermit2} from "permit2/src/interfaces/IPermit2.sol";
import {DutchOrderReactor} from "../src/reactors/DutchOrderReactor.sol";
import {OrderQuoter} from "../src/lens/OrderQuoter.sol";
import {DeployPermit2} from "../test/util/DeployPermit2.sol";
import {MockERC20} from "../test/util/mock/MockERC20.sol";

struct DutchDeployment {
    IPermit2 permit2;
    DutchOrderReactor reactor;
    OrderQuoter quoter;
}

contract DeployDutch is Script, DeployPermit2 {
    IPermit2 constant PERMIT2 = IPermit2(0xC5f4c7C1C20532CdCB84dcf9A2B4FfB8F431246C);
    address constant UNI_TIMELOCK = 0x1a9C8182C09F50C8318d769245beA52c32BE35BC;

    function setUp() public {}

    function run() public returns (DutchDeployment memory deployment) {
        vm.startBroadcast();
        if (address(PERMIT2).code.length == 0) {
            deployPermit2();
        }

        DutchOrderReactor reactor = new DutchOrderReactor{salt: 0x00}(PERMIT2, UNI_TIMELOCK);
        console2.log("Reactor", address(reactor));

        OrderQuoter quoter = new OrderQuoter{salt: 0x00}();
        console2.log("Quoter", address(quoter));

        vm.stopBroadcast();

        return DutchDeployment(PERMIT2, reactor, quoter);
    }
}
