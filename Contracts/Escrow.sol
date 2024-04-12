/*
托管合约（Escrow Contract）是一种在交易双方之间起中介作用的智能合约，用于确保交易的安全和公平。

我们用一个电商交易的例子，来说明托管合约的使用场景。

比如：买家向卖家购买商品，双方都希望确保交易安全进行。买家希望在确认收到商品后支付，而卖家则希望确保发货后能收到款项。

所以，在这种情况下，就需要一个中立的第三方来确保双方的交易安全，这个第三方就是托管合约就派上用场。

托管合约在去中心化应用中，尤其是在去中心化金融 DeFi 领域，起着非常关键的作用。

这种合约提供了一种自动化、透明且可信的方式来处理交易，尤其是在缺乏信任的环境中。

1. 托管合约示例
我们编写一个电商交易中使用的托管合约。

它的工作流程如下：

a) 买家向合约存入货款；

b) 当买家收货后，需要将资金释放给卖家；

c) 如果取消交易，那么卖家需要将资金退还买家；

d) 如果双方有争议，那么由仲裁者进行干预，它可以将资金释放给卖家，也可以将资金退还给卖家。

2. 托管合约的特点
1) 中立的第三方
托管合约充当中立的第三方，它根据合约逻辑自动执行操作，而不是由单一的实体控制。

2) 资金保存
托管合约会在特定条件满足之前，会保存资金。资金被锁定在托管合约中，直到达成预定条件。

3) 条件触发
资金的释放基于预定义的条件。这些条件可以是截止时间、事件发生，或其他合约的状态。

4) 去中心化
作为区块链应用的一部分，托管合约是去中心化的，减少了对传统中介机构的依赖。

3. 托管合约的应用场景
1) 交易和支付
在买卖双方之间进行交易时，托管合约确保资金只有在货物或服务交付后才会释放。

2) 贸易融资
在国际贸易中，托管合约可以在货物到达目的地后释放支付。

3) 智能财产权管理
例如，版权费用可以通过托管合约自动分配给相关方。

4) 去中心化金融 DeFi
在 DeFi 平台上，托管合约常用于贷款、保险、衍生品等金融工具。

5) 众筹和赞助
托管合约可以确保资金只在达成特定目标或条件时才被用于项目资助。

4. 需要注意的问题
开发托管合约需要高度的专业知识，以确保合约具有正确的逻辑，保证资金的安全。

托管合约的安全性至关重要，因为缺陷或漏洞就可能导致资金损失。

因此，托管合约需要经过严格的审核和测试。
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Escrow {
  address public buyer; // 买家地址
  address public seller; // 卖家地址
  address public arbiter; // 仲裁者地址

  // 初始化合约参数
  constructor(address _buyer, address _seller, address _arbiter) {
    // 设置买家、卖家和仲裁者地址
    buyer = _buyer;
    seller = _seller;
    arbiter = _arbiter;
  }

  // 买家存入资金
  function deposit() external payable {
    // 只有买家允许存入资金
    require(msg.sender == buyer);
  }

  // 释放资金给卖家
  function releaseToSeller() external {
    // 只有买家和仲裁者允许释放资金
    require(msg.sender == buyer || msg.sender == arbiter);
    // 将所有资金转账给卖家
    payable(seller).transfer(address(this).balance);
  }

  // 退款给买家
  function refundToBuyer() external {
    // 只有卖家和仲裁者允许退款
     require(msg.sender == seller || msg.sender == arbiter);
    // 将所有资金转账给买家
     payable(buyer).transfer(address(this).balance);
  }

  // 查看合约资金余额
  function getBalance() external view returns(uint256) {
    return address(this).balance;
  }
}