// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {UUPSUpgradeable} from "@openzeppelin/contracts/proxy/utils/UUPSUpgradeable.sol";
import {Initializable} from "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract BoxV2  is UUPSUpgradeable,Initializable,OwnableUpgradeable{
    uint256 internal otherNumber;
    uint256 internal number;

  constructor() {
        _disableInitializers();
    }

    function initialize() public initializer {
        __Ownable_init(msg.sender);
    }
    
    function setNumber(uint256 _number) external {
        number = _number;
    }

    function getNumber() external view returns(uint256){
        return number;
    }

    function version() external pure returns(uint256){
        return 2;
    }

    function _authorizeUpgrade(address newImplementation) internal override {}

}