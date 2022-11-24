const main = async () => {
  const [owner, randomPerson] = await hre.ethers.getSigners();
  const waveContractFactory = await hre.ethers.getContractFactory(
    "StorageFactory"
  );
  const factoryContract = await waveContractFactory.deploy();
  await factoryContract.deployed();

  console.log("Contract deployed to:", factoryContract.address);
  console.log("Contract deployed by:", owner.address);

  let Txn = await factoryContract.createNewStorage();
  await Txn.wait();

  console.log(await factoryContract.listStore());

  Txn = await factoryContract.saveByIndex(0, 20);

  console.log(factoryContract);
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
