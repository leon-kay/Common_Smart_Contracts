/*
包装型代币，英文为 Wrapped Tokens，是一种将原生币包装成符合 ERC-20 标准的代币。比如，WETH、WBNB、WBTC等，都是包装型代币。

我们以 WETH 为例，分析一下包装型代币的作用：

WETH，全名为 Wrapped Ether，旨在将以太坊的原生以太币 ETH 包装成 ERC-20 代币。它使用非常广泛，长期占据以太坊区块链上 gas 消耗量前三名。

与此类似，WBNB 是将币安币 BNB 包装为 ERC-20 代币，WBTC 则是将比特币 BTC 包装为 ERC-20 代币。

那么，为什么需要将原生币 ETH 包装成 WETH 呢？

在去中心化金融应用中，例如 Uniswap、Curve 等，这些应用背后实际上是由一组智能合约构成的。这些智能合约可以方便地实现不同代币之间的交易和兑换。然而，这些智能合约要求交易的代币必须符合 ERC-20 标准，因为 ERC-20 标准定义了一组函数和事件，代币的处理逻辑可以做到统一，而不需要为每一种代币单独编写。

然而，原生以太币 ETH 并不是以智能合约的方式创建的，不符合 ERC-20 标准，因此无法直接与这些智能合约进行交互。为了让 ETH 能够与其他 ERC-20 代币一样进行交易和使用，就产生了 WETH 这个概念。WETH 是将 ETH 包装成一个符合 ERC-20 标准的代币，使得 ETH 也能够在智能合约中和其他代币一样使用。

总而言之，包装型代币的产生是为了使原生币能够符合 ERC-20 标准，从而在智能合约和去中心化金融应用中与其他代币互操作。这样一来，以太坊生态系统中的各种代币都能够按照相同的标准进行处理，从而提高了互操作性和效率。

包装型代币和原生币有各自适应的使用场景，我们希望包装型代币和原生币之间，能够随时按照 1:1 的比例自由兑换。

我们按照上述需求，将其编写为一个智能合约，名称为 WETH。

用户可以将 ETH 存入 WETH 合约，或者从 WETH 合约中提取 ETH，来进行 ETH 和 WETH 之间的转换。这个转换过程是双向的，而且兑换比例是 1:1。
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract WETH is ERC20{
    // 事件：存款和取款
    event  Deposit(address indexed dst, uint wad);
    event  Withdrawal(address indexed src, uint wad);

    // 构造函数，初始化ERC20的名字和代号
    constructor() ERC20("WETH", "WETH"){
    }

    // 回调函数，当用户往WETH合约转ETH时，会触发deposit()函数
    fallback() external payable {
        deposit();
    }
    // 回调函数，当用户往WETH合约转ETH时，会触发deposit()函数
    receive() external payable {
        deposit();
    }

    // 存款函数，当用户存入ETH时，给他铸造等量的WETH
    function deposit() public payable {
        _mint(msg.sender, msg.value);
        emit Deposit(msg.sender, msg.value);
    }
 
    // 提款函数，用户销毁WETH，取回等量的ETH
    function withdraw(uint amount) public {
        require(balanceOf(msg.sender) >= amount);
        _burn(msg.sender, amount);
        payable(msg.sender).transfer(amount);
        emit Withdrawal(msg.sender, amount);
    }
}