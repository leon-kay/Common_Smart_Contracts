/*
线性释放，英文名称为 “Vesting”，是指代币按照一定速度在一段时间内匀速释放的过程，这种机制通常用于激励机制。

线性释放，既可以限制被激励人员在短时间内大量抛售代币，造成代币价格的不稳定，又可以保证他们具有长期的动力。

我们举个线性释放的使用场景，来帮助您理解线性释放的机制。比如：

某项目方为了激励团队成员，为每个人发放了 10000 个代币，并限制为 4 年内线性释放这些代币。

那么，团队成员在第一年，就可以提取 2500 个代币；第二年，依然可以再提取 2500 个代币，依次类推，4 年后就已经提取了全部代币。

当然，也可以每两年提取一次，每次提取 5000 个代币。

这个具体提取时间，由团队成员自己掌握。团队成员能够提取代币的比例，就是按照“已过去的时间”占“锁定期”的比例。

线性释放过程，既可以直接写入在 ERC20 代币合约中，也可以编写一个独立的智能合约。

锁仓并线性释放ERC20代币的合约TokenVesting。它的逻辑很简单：

项目方规定线性释放的起始时间、归属期和受益人。
项目方将锁仓的ERC20代币转账给TokenVesting合约。
受益人可以调用release函数，从合约中取出释放的代币。

我们首先编写一个 ERC20 代币合约，作为锁仓使用的代币，您可以参考本教程的前面章节，直接复制一份代码。

然后，我们再编写一个锁仓合约 TokenVesting，用于存放锁定的代币。

我们将一定数量的需要锁定的代币，转入线性释放合约 TokenVesting 中，并设定锁定期和受益人。

在锁定期内，受益人可以调用 release 函数，按照“已过去的时间”占“锁定期”的比例，提走已经释放的代币。

1. ERC20 代币合约
代币名称为 BinSchool Coin，符号为 BC，为合约部署者发行 100 个代币：

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// 引入代币合约需要继承的 openzeppelin 的 ERC-20 合约
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MyCoin is ERC20{
  // 构造函数，调用了openzeppelin的ERC-20合约的构造函数，传入代币名称和符号
  constructor() ERC20("BinSchool Coin", "BC") {
    // 铸造 100 个 BC 给合约部署者
    _mint(msg.sender, 100*10**18);
  }
}
2. TokenVesting 线性释放合约 
线性释放合约 TokenVesting 共有3个函数：构造函数、释放函数和计算释放量函数。

构造函数用于指定锁定时间和受益人。

释放函数是提供给受益人提取代币使用的函数。

计算释放量函数用于计算当前可以释放的代币数量。
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract TokenVesting {
    // 状态变量
    mapping(address => uint256) public erc20Released; // 代币地址->释放数量的映射，记录已经释放的代币
    address public immutable beneficiary; // 受益人地址
    uint256 public immutable start; // 起始时间戳
    uint256 public immutable duration; // 归属期

    constructor(address beneficiaryAddress, uint256 durationSeconds) {
        require(beneficiaryAddress != address(0),"VestingWallet: beneficiary is zero address");
        beneficiary = beneficiaryAddress;
        start = block.timestamp;
        duration = durationSeconds;
    }

    function release(address token) public {
        // 调用vestedAmount()函数计算可提取的代币数量
        uint256 releasable = vestedAmount(token, uint256(block.timestamp)) -erc20Released[token];
        // 更新已释放代币数量
        erc20Released[token] += releasable;
        // 转代币给受益人
        emit ERC20Released(token, releasable);
        IERC20(token).transfer(beneficiary, releasable);
    }

    function vestedAmount(address token,uint256 timestamp) public view returns (uint256) {
        // 合约里总共收到了多少代币（当前余额 + 已经提取）
        uint256 totalAllocation = IERC20(token).balanceOf(address(this)) +
            erc20Released[token];
        // 根据线性释放公式，计算已经释放的数量
        if (timestamp < start)
        {
            return 0;
        } 
        else if (timestamp > start + duration) 
        {
            return totalAllocation;
        } 
        else
        {
            return (totalAllocation * (timestamp - start)) / duration;
        }
    }
}
