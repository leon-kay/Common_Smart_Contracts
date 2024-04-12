// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

/*
英式拍卖，英文为 English Auction。这是一种最为常见的拍卖形式，参与者通过竞价不断提高价格，拍卖会以最高价出售商品或服务。
英式拍卖是一种开放式拍卖。在英式拍卖中，拍卖师会逐渐提高价格，参与者可以选择是否继续竞标。竞价最高的人将以其出价获得拍卖物品或服务。
英式拍卖因其竞争性和公开性而受到欢迎，常用于各种拍卖场景，包括艺术品、房地产、古董、珠宝等。它提供了一个公平且透明的方式，让参与者根据市场需求和供给情况来确定价格。
英式拍卖的主要算法是逐步提高价格，直到只有一个竞标者愿意出更高的价格，然后以该价格成交。

我们把英式拍卖结合区块链技术，并根据实际情况，编写成一个智能合约，算法可以分为以下步骤：
1）起拍
拍卖者首先确定一个起拍价，参与者的投标不能低于这个价格。
2）提价
参与者根据自己的意愿提高价格，进行投标，每次提价不小于一定的幅度。
3）结束
每次拍卖都限定时间，一旦到达这个时间，投标结束。
4）成交
投标结束后，与最后一个有效的投标者成交，他也是本次拍卖出价最高的竞标者。
英式拍卖合约包括 3 个函数：开始拍卖函数 startAuction、结束拍卖函数 endAuction，以及竞价函数 bid。

其中，开始拍卖和结束拍卖函数，只有合约拥有者有权调用， 而竞价函数 bid 可以由任何人调用。
在英式拍卖合约中，结束拍卖必须由人工操作，它无法做到自动结束，而荷兰拍卖是可以做到自动结束的。 
*/

import "@openzeppelin/contracts/access/Ownable.sol";

contract EnglishAuction is Ownable {
    uint constant START_PRICE = 1 ether; // 起拍价
    uint constant DURATION = 60 seconds; // 拍卖持续时间
    uint constant MIN_INCREMENT = 0.1 ether; // 最小竞价幅度

    uint public startTime; // 拍卖开始时间
    address public highestBidder; // 当前最高出价者
    uint public highestBid; // 当前最高出价
   
    // 拍卖开始事件
    event AuctionStarted(uint startPrice, uint startTime);
    // 拍卖结束事件
    event AuctionEnded(address winner, uint winningBid);
    // 竞拍事件
    event Bid(address bidder, uint bidAmount);
    // 退款事件
    event Refund(address bidder, uint bidAmount, bool success);

    // 构造函数，设置合约拥有者
    constructor() Ownable(msg.sender) {
    }

    // 开始拍卖，仅合约拥有者可调用
    function startAuction() public onlyOwner {
        // 确保拍卖还未开始
        require(startTime == 0, "auction already started"); 

        // 记录拍卖开始时间为当前时间戳
        startTime = block.timestamp; 
        // 将最高出价者清零
        highestBidder = address(0); 
        // 最高出价初始化为起拍价
        highestBid = START_PRICE;
        // 触发拍卖开始事件，传入起拍价和开始时间
        emit AuctionStarted(START_PRICE, block.timestamp); 
    }

    // 竞拍出价
    function bid() public payable {
        // 当前竞拍者
        address bidder = msg.sender; 
        // 当前竞拍出价
        uint amount = msg.value;

        // 确保处于拍卖有效期：拍卖已经开始且未结束
        require(startTime > 0 && 
            block.timestamp < startTime + DURATION, 
            "invalid auction time"); 
        // 出价必须高于当前最高出价，且加价不小于最小幅度
        require(amount > highestBid && 
            amount - highestBid >= MIN_INCREMENT, 
            "invalid auction bid");

       if (highestBidder != address(0)) {
            // 退还之前最高出价者的款项
            bool sent = payable(highestBidder).send(highestBid);
            // 触发 Refund 事件，记录退款是否成功
            emit Refund(highestBidder, highestBid, sent);
        }

        // 更新最高出价者为当前竞拍者
        highestBidder = bidder; 
        // 更新最高出价为竞拍出价
        highestBid = amount;
        // 触发出价事件
        emit Bid(msg.sender, msg.value); 
    }

    // 结束拍卖，仅合约拥有者可调用
    function endAuction() public onlyOwner {
        // 确保超过拍卖有效期
        require(startTime > 0 && 
            block.timestamp >= startTime + DURATION, 
            "invalid auction time"); 

        // 触发拍卖结束事件
        emit AuctionEnded(highestBidder, highestBid); 
        // 拍卖开始时间清零
        startTime = 0;
        // 将合约余额转给合约拥有者
        uint amount = address(this).balance;
       if (amount > 0) {
            payable(owner()).transfer(amount); 
        }

        //这里可以加入对竞拍成功者的任意操作
        //.....
    }
}
/*
注意：这个合约 bid 函数代码中有一句：
bool sent = payable(highestBidder).send(highestBid);
为什么使用了send 转账，而不是 tranfer 呢？这是为了避免被 DOS 拒绝服务攻击。
 */