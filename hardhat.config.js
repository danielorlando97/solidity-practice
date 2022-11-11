require("@nomiclabs/hardhat-waffle");

module.exports = {
  solidity: "0.8.4",
  networks: {
    rinkeby: {
      url: "https://morning-frosty-spree.rinkeby.discover.quiknode.pro/af6f514fd37c69f9f929e79bdd3c078a598134a7/",
      accounts: [
        "7130387641843e7c67d5ba430ef8296ad3c8fcbfaea957eeabe23d7036d58e0b",
      ],
    },
  },
};

// // This is a sample Hardhat task. To learn how to create your own go to
// // https://hardhat.org/guides/create-task.html
// task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
//   const accounts = await hre.ethers.getSigners();

//   for (const account of accounts) {
//     console.log(account.address);
//   }
// });

// // You need to export an object to set up your config
// // Go to https://hardhat.org/config/ to learn more

// /**
//  * @type import('hardhat/config').HardhatUserConfig
//  */
// module.exports = {
//   solidity: "0.8.4",
// };
