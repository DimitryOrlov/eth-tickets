const Tickets = artifacts.require("Tickets");

module.exports = async function(deployer) {
  deployer.deploy(Tickets);
};
