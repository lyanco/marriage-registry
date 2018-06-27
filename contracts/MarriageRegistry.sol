pragma solidity ^0.4.24;

import "./safemath.sol";
import "./ownable.sol";

contract MarriageRegistry is Ownable {

  using SafeMath for uint256;

  event NewMarriage(uint256 id, string person1name, string person2name, address person1address, address person2address);
  //event NewDivorce

  modifier noActiveMarriage(address _address) {
    require(!isActiveMarriageAddress[_address]);
    _;
   }

  modifier hasActiveMarriage(address _address) {
    require(isActiveMarriageAddress[_address]);
    _;
   }

  modifier noSelfLove(address _person1address, address _person2address) {
    require (_person1address != _person2address);
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
  mapping (address => bool) public isActiveMarriageAddress;


  //step1: create marriage by submitting 2 addresses. look up any marriage by an address.
  //step2: create marriage by submitting from address, 2nd person approves
  //step3: divorces

  function getMarriageId(address _address) public view
  hasActiveMarriage(_address)
  returns (uint256) {
    return marriageIdByAddress[_address];
  }

  function getMarriageById(uint _id) public view returns (string, string, address, address) {
    Marriage memory m = marriages[_id];
    return (m.person1name, m.person2name, m.person1address, m.person2address);
  }

  function getMarriageByAddress(address _address) public view
  hasActiveMarriage(_address)
  returns (string, string, address, address) {
    Marriage memory m = marriages[marriageIdByAddress[_address]];
    return (m.person1name, m.person2name, m.person1address, m.person2address);
  }

  function execCreateMarriage(string _person1name, string _person2name,
    address _person1address, address _person2address)
  external
  onlyOwner
  noActiveMarriage(_person1address)
  noActiveMarriage(_person2address)
  noSelfLove(_person1address, _person2address)
  {
    //Marriage memory marriage = Marriage(_person1name, _person2name,
    //  _person1address, _person2address);
    _createMarriage(_person1name, _person2name, _person1address, _person2address);
  }

  function _createMarriage(string _person1name, string _person2name,
    address _person1address, address _person2address) internal {
    uint id = marriages.push(Marriage(_person1name, _person2name, _person1address, _person2address)) - 1;
    _setMarriageArray(_person1address, id);
    _setMarriageArray(_person2address, id);
    emit NewMarriage(id, _person1name, _person2name, _person1address, _person2address);
  }

  function _setMarriageArray(address _address, uint _id) internal {
    marriageIdByAddress[_address] = _id;
    isActiveMarriageAddress[_address] = true;
  }

}
