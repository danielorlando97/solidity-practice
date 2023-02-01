# Ethereum Lottery

## Objective

- Uses can enter lottery with ETH base on USD fee
- An Admin will choose when the lottery is over
- Lottery select the random winner
- Send a percent of all of ETH to winner
- The rest ETH divide between the admins

## Why an decentralized approach?

## First, define the Smart Contract Lottery

For our main objectives, this contract should permit that the user can enter
to the lottery. In addition, an admin has to can start and end it. And after the end
it has to choose the winner and send him and the admins the ETH. So, the contract should
be like this:

```javascript
contract Lottery {
    function enterNewPlayer() payable {}
    function start() public {}
    function end() public {}
    function distributionOfPrices() public {}
}
```

So, the first task is to permit that new users can enter in our lottery. We need to save
all of user's address to send him the prize if he would be the winner.

```javascript
contract Lottery {
    address[] public players;

    function enterNewPlayer() public payable {
        players.push(msg.sender);
    }
}
```

But, with this approach we don't know how munch ETH users send us. Futhermore, we want to
select a minimal fee to enter to our lottery. This value we think about it in USD, but the ETH
is a very volatile currency, so the change isn't the same at two different moments.

For get the current value of USD in ETH, we can use a [oracles] like [chainlink]. We can import
some chainlink's contract into our lottery contract, but is better to create a new contract as connector
between our main contract and some external service.

```javascript
import "@chainlink/contracts/src/v0.7/interfaces/AggregatorV3Interface.sol";

contract PriceConsumerV3 {
    AggregatorV3Interface internal priceFeed;

    constructor(address _priceFeed) {
        priceFeed = AggregatorV3Interface(_priceFeed);
    }

    function getLatestPrice() public view returns (uint256) {
        (,int256 price,,,) = priceFeed.latestRoundData();
        return uint256(price);
    }
}
```

Whe need to define the github repo when brownie can meet this external service. So, we has to create our
config files brownie-config.yml and to add the next lines

```yml
dependencies:
  # - <organization/repo>@<version>
  - smartcontractkit/chainlink-brownie-contracts@1.1.1

compiler:
  solc:
    remappings:
      - "@chainlink=smartcontractkit/chainlink-brownie-contracts@1.1.1"
```

Now we only have to parametrize our main contract to create a new connection with this contract and after
to ask it the current USD price.

```javascript
import "./PriceConsumer.sol";

contract Lottery {
    address[] public players;
    uint256 minimalFee;
    PriceConsumerV3 internal priceFeed;

    constructor(address priceFeed, uint256 minimalFee) {
        priceFeed = PriceConsumerV3(priceFeed);
        minimalFee = minimalFee * (10**18);
    }
```
