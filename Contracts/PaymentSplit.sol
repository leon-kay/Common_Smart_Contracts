/*
分账合约（Split Payment Contract）是一种智能合约，它允许将接收到的资金按照预设的规则自动分配给多个账户。

比如：可以按照每个受益人所占的份额比例进行分配。

分账合约在需要将收入或捐款等资金，分配给多个参与者的场景中非常有用。

比如：项目众筹、合伙企业利润分配、作者版税分享等。

1. 分账合约的实现要点
1）累积资金的管理
若资金是分批次存入合约的，必须确保每次的资金分配都是基于合约的总收入。

合约中应维护一个“已领取金额”的记录。用户可领取的金额等于其应得的总金额（按份额计算）减去已经领取的部分。

2）防范重入攻击
在资金分配之前，首先更新合约内部的状态变量，以防止重入攻击。这一做法遵循了被称为“检查-生效”（Check-Effects）模式的智能合约编程原则。

3）事件日志记录
通过记录关键操作事件，可以方便地追踪和核实合约的活动情况，增强合约的透明度和可追溯性。

这些要点是确保分账合约安全、高效并且符合预期行为的关键。在设计和实施这样的合约时，对这些细节的周密考虑至关重要。
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PaymentSplit {
    uint256 public totalShares; // 总份额
    uint256 public totalReleased; // 已领取的总金额
    address[] public payees; // 受益人集合

    // 记录每个受益人的份额
    mapping(address => uint256) public shares; 
    // 记录已支付给每个受益人的金额
    mapping(address => uint256) public released; 

    // 增加受益人事件
    event PayeeAdded(address account, uint256 shares); 
    // 受益人提款事件
    event PaymentReleased(address to, uint256 amount); 
    // 合约收款事件
    event PaymentReceived(address from, uint256 amount); 

    // 初始化受益人集合和分账份额映射
    constructor(address[] memory _payees, uint256[] memory _shares) payable {
        // 受益人数量必须大于 0
        require(_payees.length > 0, "PaymentSplitter: no payees");
        // 受益人数组和分账份额数组长度必须相同
        require(_payees.length == _shares.length, 
          "PaymentSplitter: payees and shares length mismatch");
        
        for (uint256 i = 0; i < _payees.length; i++) {
            // 检查账号地址不能为 0
            address payee = _payees[i];
            require(payee != address(0), "PaymentSplitter: payee is the zero address");
            // 检查份额不能为 0
            uint256 payeeShares = _shares[i];
            require(payeeShares > 0, "PaymentSplitter: shares are 0");
            // 检查账号地址不重复
            require(shares[payee] == 0, "PaymentSplitter: payee already has shares");

            // 添加到受益人数组
            payees.push(payee);
            // 添加到受益人份额映射中
            shares[payee] = payeeShares;
            // 计算总份额
            totalShares += payeeShares;
            // 触发增加受益人事件
            emit PayeeAdded(payee, payeeShares);
        }
    }

    // 受益人领取分配的资金
    function claim(address payable _account) public virtual {
        // 检查是否是有效受益人
        require(shares[_account] > 0, "PaymentSplitter: account has no shares");
        // 计算受益人应得的 ETH
       uint256 payment = _calcPayment(_account);
        // 分配所得的 ETH 不能为 0
        require(payment != 0, "PaymentSplitter: account is not due payment");
        
        // 更新总支付金额
        totalReleased += payment;
        // 更新当前受益人已领取的金额
        released[_account] += payment;
        // 转账
        _account.transfer(payment);
        // 触发受益人提款事件
        emit PaymentReleased(_account, payment);
    }

    // 计算特定账户能够领取的资金
    function _calcPayment(address _account) private view returns (uint256) {
        // 计算分账合约总收入，也就是累积的总金额
        uint256 totalReceived = address(this).balance + totalReleased;
        // 受益人应得金额 = 总应得金额 - 已领取金额
        return (totalReceived * shares[_account]) / totalShares - released[_account];
    }

    // 接收 ETH 函数，并触发 PaymentReceived 事件
    receive() external payable virtual {
        emit PaymentReceived(msg.sender, msg.value);
    }
}