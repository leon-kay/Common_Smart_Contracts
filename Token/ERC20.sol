/*
ERC-20 是以太坊区块链上被广泛采用的代币标准，旨在规范和简化代币的发行与交易流程。

ERC-20 代币可用于代表分红权、治理权、投票权、交易媒介、实物资产份额等，具有交易便捷、流动性高等优势。

ERC-20 标准是在 2015 年提出来的，它定义了一系列的智能合约接口，为以太坊生态系统中的代币发行和交易提供了一种标准化的方式。

只有遵循 ERC-20 标准编写的智能合约，才能被钱包软件、其它合约或者应用程序识别为一种特定代币。如果智能合约不符合 ERC-20 标准，那么它创建的代币就不能被主流钱包所识别，也不会被认为是合法的代币。

ERC-20 标准要求必须实现 6 个方法和 2 个事件，分别用于：查询总供应量、查询余额、转账，以及授权转账 等等。

另外，合约还可以选择性地提供代币名称、代币符号 和 小数位数 的接口。虽然这部分信息是非强制性的，但是合约里通常都会提供这些功能。

ERC-20 代币合约使用非常广泛，是去中心化金融 DeFi 中最基础的合约。

对于一个 Web3 从业者，无论是从事开发、设计、运营还是进行投资，都应该熟练掌握它。

1. ERC-20 标准方法
ERC-20 标准方法，是提供给外部应用或者其它合约可以调用的函数。ERC-20 代币合约必须实现 6 个特定的方法。

1. totalSupply
function totalSupply() public view returns (uint256)
获取代币的总供应量。

2. balanceOf
function balanceOf(address account) external view returns (uint256)
获取指定地址 account 的代币余额。

3. transfer
function transfer(address to, uint256 amount) external returns (bool)
从调用者的地址，向目标地址 to 转移指定数量 amount 的代币。

4. allowance
function allowance(address owner, address spender) external view returns (uint256)
获取一个地址 owner 授权给另一个地址 spender 能够转移的代币数量。

5. approve
function approve(address spender, uint256 amount) external returns (bool)
授权指定地址 spender 能够从调用者的地址转移一定数量 amount 的代币。

6. transferFrom
function transferFrom(address from, address to, uint256 amount) external returns (bool)
在授权的情况下，从一个地址 from 向另一个地址 to 转移指定数量 amount 的代币。

 

注意：与授权相关的 3 个函数是一组委托操作的方法，可以实现将某个地址的特定数量的代币授权给第三方操作。比如：在去中心化交易所进行交易时，用户不需要把自己的代币转入交易所的账户，而是将一定数量的代币授权给交易所操作即可，而且还可以随时收回权限。这种机制允许用户在保持控制权的同时进行交易，非常安全和灵活。

2. ERC-20 标准事件
在 Solidity 中，事件是一种通知机制，智能合约用来向外部程序或其它合约通知某个事件的发生。

触发一个事件后，事件中携带的数据就会存储到收据中，并与交易关联，记录在区块链上，以便外部应用监听和处理。

ERC-20 标准规定：代币合约必须实现 2 个特定的事件。

区块浏览器就是使用 ERC-20 代币合约的事件，对交易数据进行统计和更新。

1. Transfer
event Transfer(address indexed from, address indexed to, uint256 value)
当代币被成功转移时，就会触发该事件，它记录转移的发起地址、目标地址和转移的数量。

2. Approval
event Approval(address indexed owner, address indexed spender, uint256 value)
当一个地址授权另一个地址，能够转移一定数量的代币时，就会触发该事件，它记录所有者、被授权者和授权数量的变化。

3. 编写 ERC-20 代币合约
编写 ERC-20 合约有两种方法：继承 OpenZepplin 合约 和 自行实现。

1. 继承 OpenZepplin 合约
继承 OpenZepplin 库中的 ERC-20 合约，只需要几行代码就可以实现自己的代币合约，这也是最常用的方法。

假如，我们要发行一个代币，它的名称为 BinSchool Coin，符号为 BC，发行总量 100 个，归属于合约部署者，那么就可以这样编写：

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
其中，100*10**18 实际代表 100 个代币 BC，10**18 是代币的精度。
自己从头编写一个 ERC-20 代币合约的技术难度不高，就是一些简单的变量操作，需要实现标准中规定的 6 个方法。

编写 ERC-20 合约首先需要理解两个变量：balances 和 allowances，这两个变量都是 mapping 数据类型。

a) 变量 balances

balances 用来存放所有持币地址对应的持币数量。比如： bob 的地址为 0x1111...2222，他持有 100 wei个代币，那么在 balances 中会产生这样一条记录：

balances[0x1111...2222] = 100
b) 变量 allowances

allowances 存放特定地址对应的授权地址和授权数量。 比如：交易所的地址为 0xaaaa...bbbb，bob 的地址为 0x1111...2222，bob 授权给交易所，可以转移他持有的 100 wei个代币，那么在 allowances 中会产生这样一条记录：

allowances[0x1111...2222][0xaaaa...bbbb] = 100
以下是完整的代币合约和注释：
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IERC20} from "./IERC20.sol";
import {IERC20Metadata} from "./extensions/IERC20Metadata.sol";
import {Context} from "../../utils/Context.sol";
import {IERC20Errors} from "../../interfaces/draft-IERC6093.sol";

abstract contract ERC20 is Context, IERC20, IERC20Metadata, IERC20Errors {
    mapping(address account => uint256) private _balances;

    mapping(address account => mapping(address spender => uint256))
        private _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;

    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    /**
    NOTE:返回代币名称
     */
    function name() public view virtual returns (string memory) {
        return _name;
    }

    /**
    NOTE:返回代币符号
     */
    function symbol() public view virtual returns (string memory) {
        return _symbol;
    }

    /**
    NOTE:返回代币小数点后位数
     */
    function decimals() public view virtual returns (uint8) {
        return 18;
    }

    /**
    NOTE:返回总共的代币数量。
     */
    function totalSupply() public view virtual returns (uint256) {
        return _totalSupply;
    }

    /**
   NOTE:返回 account 地址拥有的代币数量。
    */
    function balanceOf(address account) public view virtual returns (uint256) {
        return _balances[account];
    }

    /**
    NOTE:将 amount 数量的代币发送给 to 地址，返回布尔值告知是否执行成功。
     */
    function transfer(address to, uint256 value) public virtual returns (bool) {
        address owner = _msgSender();
        _transfer(owner, to, value);
        return true;
    }

    /**
  NOTE:返回授权花费者 spender 通过 transferFrom 代表所有者花费的剩余代币数量。

    */
    function allowance(
        address owner,
        address spender
    ) public view virtual returns (uint256) {
        return _allowances[owner][spender];
    }

    /**
   NOTE:授权 spender 可以花费 amount 数量的代币，返回布尔值告知是否执行成功。
    */
    function approve(
        address spender,
        uint256 value
    ) public virtual returns (bool) {
        address owner = _msgSender();
        _approve(owner, spender, value);
        return true;
    }

    /**
  NOTE:将 amount 数量的代币从 from 地址发送到 to 地址，返回布尔值告知是否执行成功。将 amount 数量的代币从 from 地址发送到 to 地址，返回布尔值告知是否执行成功。
   */
    function transferFrom(
        address from,
        address to,
        uint256 value
    ) public virtual returns (bool) {
        address spender = _msgSender();
        _spendAllowance(from, spender, value);
        _transfer(from, to, value);
        return true;
    }

    function _transfer(address from, address to, uint256 value) internal {
        if (from == address(0)) {
            revert ERC20InvalidSender(address(0));
        }
        if (to == address(0)) {
            revert ERC20InvalidReceiver(address(0));
        }
        _update(from, to, value);
    }

    /**
    NOTE:会根据转账情况对发送者和接收者的余额进行更新。如果发送者地址是零地址，表示创建新代币，所以会增加总供应量（_totalSupply）。如果接收者地址是零地址，表示销毁代币，所以会减少总供应量（_totalSupply）。如果转账中涉及的地址不是零地址，则会更新对应地址的余额信息。
     */
    function _update(address from, address to, uint256 value) internal virtual {
        if (from == address(0)) {
            // Overflow check required: The rest of the code assumes that totalSupply never overflows
            _totalSupply += value;
        } else {
            uint256 fromBalance = _balances[from];
            if (fromBalance < value) {
                revert ERC20InsufficientBalance(from, fromBalance, value);
            }
            unchecked {
                // Overflow not possible: value <= fromBalance <= totalSupply.
                _balances[from] = fromBalance - value;
            }
        }

        if (to == address(0)) {
            unchecked {
                // Overflow not possible: value <= totalSupply or value <= fromBalance <= totalSupply.
                _totalSupply -= value;
            }
        } else {
            unchecked {
                // Overflow not possible: balance + value is at most totalSupply, which we know fits into a uint256.
                _balances[to] += value;
            }
        }

        emit Transfer(from, to, value);
    }

    function _mint(address account, uint256 value) internal {
        if (account == address(0)) {
            revert ERC20InvalidReceiver(address(0));
        }
        _update(address(0), account, value);
    }

    function _burn(address account, uint256 value) internal {
        if (account == address(0)) {
            revert ERC20InvalidSender(address(0));
        }
        _update(account, address(0), value);
    }

    function _approve(address owner, address spender, uint256 value) internal {
        _approve(owner, spender, value, true);
    }

    function _approve(
        address owner,
        address spender,
        uint256 value,
        bool emitEvent
    ) internal virtual {
        if (owner == address(0)) {
            revert ERC20InvalidApprover(address(0));
        }
        if (spender == address(0)) {
            revert ERC20InvalidSpender(address(0));
        }
        _allowances[owner][spender] = value;
        if (emitEvent) {
            emit Approval(owner, spender, value);
        }
    }

    function _spendAllowance(
        address owner,
        address spender,
        uint256 value
    ) internal virtual {
        uint256 currentAllowance = allowance(owner, spender);
        if (currentAllowance != type(uint256).max) {
            if (currentAllowance < value) {
                revert ERC20InsufficientAllowance(
                    spender,
                    currentAllowance,
                    value
                );
            }
            unchecked {
                _approve(owner, spender, currentAllowance - value, false);
            }
        }
    }
}
