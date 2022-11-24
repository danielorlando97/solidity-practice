const main = async () => {
  const [owner, randomPerson] = await hre.ethers.getSigners();
  const contractFactory = await hre.ethers.getContractFactory("FundMe");
  const contract = await contractFactory.deploy();
  await contract.deployed();

  let contractBalance = await hre.ethers.provider.getBalance(contract.address);

  console.log("Contract deployed to:", contract.address);
  console.log("Contract deployed by:", owner.address);
  console.log("Contract deployed balance:", contractBalance);
  console.log(
    "Contract deployed memory:",
    await contract.mappingAddressFundAmount()
  );

  let Txn = await contract.connect(randomPerson).fund({
    value: ethers.utils.parseEther("1.0"),
  });
  await Txn.wait();

  console.log("Contract deployed to:", contract.address);
  console.log("Contract deployed by:", owner.address);
  console.log("Contract deployed balance:", contractBalance);

  let address = await contract.mappingAddressFundAmount();
  console.log("Contract deployed memory:", address);
  console.log(
    "Contract deployed value:",
    await contract.addressFundAmount(address[0])
  );

  Txn = await contract.connect(randomPerson).fund({
    value: ethers.utils.parseEther("1.0"),
  });
  await Txn.wait();

  console.log("Contract deployed to:", contract.address);
  console.log("Contract deployed by:", owner.address);
  console.log("Contract deployed balance:", contractBalance);

  address = await contract.mappingAddressFundAmount();
  console.log("Contract deployed memory:", address);
  console.log(
    "Contract deployed value:",
    await contract.addressFundAmount(address[0])
  );

  const usdPrice = await contract.getCurrentPrice();

  console.log("current price", usdPrice);
};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

runMain();
