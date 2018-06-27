const MarriageRegistry = artifacts.require("./MarriageRegistry.sol");
module.exports = function(deployer) {
  deployer.deploy(MarriageRegistry);
};
