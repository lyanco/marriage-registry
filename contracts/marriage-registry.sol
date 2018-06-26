pragma solidity ^0.4.24;

import "./safemath.sol";
import "./ownable.sol";

contract MarriageRegistry is Ownable {

  using SafeMath for uint256;

  event NewMarriage(string person1name, string person2name, address person1address, address person2address);
  //event NewDivorce

  modifier noActiveMarriage(address _person1address, address _person2address) {
    require (marriageIdByAddress[_person1address] == 0);
    require (marriageIdByAddress[_person2address] == 0);
    _;
   }

  struct Marriage {
    string person1name;
    string person2name;
    address person1address;
    address person2address;
  }

  Marriage[] public marriages;

  mapping (address => uint256) public marriageIdByAddress;

  //step1: create marriage by submitting 2 addresses. look up any marriage by an address.
  //step2: create marriage by submitting from address, 2nd person approves
  //step3: divorces

  //function getMarriageId(address _address) public view returns (uint256) {
  //  return marriageIdByAddress(_address);
  //}

  function execCreateMarriage(string _person1name, string _person2name,
    address _person1address, address _person2address)
  external
  onlyOwner
  noActiveMarriage(_person1address, _person2address) {
    //Marriage memory marriage = Marriage(_person1name, _person2name,
    //  _person1address, _person2address);
    _createMarriage(_person1name, _person2name, _person1address, _person2address);
  }

  function _createMarriage(string _person1name, string _person2name,
    address _person1address, address _person2address) internal {
    //uint id = marriages.push(_marriage) - 1;
    uint id = marriages.push(Marriage(_person1name, _person2name, _person1address, _person2address)) - 1;
    marriageIdByAddress[_person1address] = id;
    marriageIdByAddress[_person2address] = id;
    emit NewMarriage(_person1name, _person2name, _person1address, _person2address);
  }

}
