//SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {BoxV1} from "../src/BoxV1.sol";
import {BoxV2} from "../src/BoxV2.sol";
import {Test,console} from "forge-std/Test.sol";
import {DeployBox} from "../script/DeployBox.s.sol";
import {UpgradeBox} from "../script/UpgradesBox.s.sol";

contract DeployerUpgradeBoxTest is Test {

    DeployBox deployer;
    UpgradeBox upgrader;
address public proxy;
    address  OWNER;
    

    function setUp() public {
        deployer = new DeployBox();
        upgrader = new UpgradeBox();
        proxy =deployer.run();
    }

    function testUpgrade() public {
        BoxV2 boxv2= new BoxV2();
        upgrader.upgradeBox(proxy,address(boxv2));

        uint256 expectedValue=2;

        assertEq(expectedValue,BoxV2(proxy).version());

        BoxV2(proxy).setNumber(42);
        assertEq(42,BoxV2(proxy).getNumber());

    }
     function test_UpgradeKeepsData() public {
        console.log("Starting test:");
        console.log("proxy:", proxy);
        
        // ШАГ 1: Работаем с BoxV1
        BoxV1 v1 = BoxV1(proxy);
        console.log("\n1. Using BoxV1:");
        console.log("   Version:", v1.version());
        
        // Сохраняем данные в V1
        v1.setNumber(777);
        console.log("   set number = 777");
        console.log("   Read:", v1.getNumber());
        
        // ШАГ 2: Апгрейд до BoxV2
        BoxV2 v2Implementation = new BoxV2();
        upgrader.upgradeBox(proxy, address(v2Implementation));
        
        BoxV2 v2 = BoxV2(proxy);
        console.log("\n2. Upgraded to BoxV2:");
        console.log("   New version:", v2.version());
        
        // ВОТ ПРИКОЛ! Данные сохранились!
        console.log("   Number after upgrade:", v2.getNumber());
        assertEq(v2.getNumber(), 777, "Data did not persist after upgrade!");
        
        // ШАГ 3: Используем новую функциональность V2
        v2.setNumber(888);
        console.log("\n3. Using new function V2:");
        console.log("   set new number 888");
        console.log("   Read:", v2.getNumber());
        
        // ШАГ 4: Проверяем что старая функциональность тоже работает
        console.log("\n4. Check backward compatibility:");
        BoxV1 v1Again = BoxV1(proxy); // Кастуем к V1
        console.log("   Through BoxV1 interface:", v1Again.getNumber());
        console.log("   Version through V1 interface:", v1Again.version());
        
        console.log("\n=== finaly ===");
        console.log(" One address:", proxy);
        console.log(" Data persisted: 777 -> 888");
        console.log(" New functions added: setNumber()");
        console.log(" Old functions work: getNumber()");
    }
}