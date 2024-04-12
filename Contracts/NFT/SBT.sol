/*
灵魂绑定代币，英文为 Soulbound Tokens，缩写为 SBT。它是由以太坊创始人 Vitalik 提出的一个概念。

灵魂绑定代币是一种与众不同的非同质化代币 NFT。与传统的 NFT不同，灵魂绑定代币不能被买卖或转移，它们永久性地绑定到特定的钱包或身份上。

灵魂绑定代币的概念源于创建数字身份的愿望。这些代币可以用来证明个人的身份、资格、成就或信誉。

例如，大学可以通过灵魂绑定代币来发放数字版的学位证书，这些证书绑定到学生的数字身份上，不能被转让或伪造。

灵魂绑定代币可以增强数字世界中的信任和认证。因为它们是不可转移的，所以可以更准确地代表一个人的信誉和历史。

例如，在去中心化金融 DeFi 领域，灵魂绑定代币可以用来证明用户的信用历史或金融资产，从而在没有中心化信用评分体系的情况下促进信贷活动。

1. SBT 基本合约
灵魂绑定代币实际上是一个特殊类型的 NFT，它被设计为不可转让或交易。

灵魂绑定代币可以使用 ERC-721 标准实现，以下是一个基本合约示例，用于创建灵魂绑定 NFT。

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract SoulboundToken is ERC721, Ownable {
  uint256 private _tokenIds; // 已铸造 SBT 的最大编号

  // 构造函数，设置 SBT 名称、符号和合约拥有者
  constructor(string memory name, string memory symbol)
    ERC721(name, symbol) Ownable(msg.sender)
  {}

  // 铸造 SBT
  function mint(address recipient)
    public onlyOwner returns (uint256) {
    // 计算新铸造的 SBT 的编号
    _tokenIds++; 
    uint256 newItemId = _tokenIds;
    // 铸造新的 SBT
    _mint(recipient, newItemId);
    return newItemId;
  }

  // 禁止转移 SBT
  function transferFrom(address, address, uint256)
    public pure override {
    revert("SoulboundToken: token is non-transferable");
  }

  // 禁止授权 SBT
  function approve(address, uint256)
    public pure override {
    revert("SoulboundToken: token is non-transferable");
  }

  // 禁止全部授权 SBT
  function setApprovalForAll(address, bool)
    public pure override {
    revert("SoulboundToken: token is non-transferable");
  }
}
此合约提供以下功能：

1） 铸造 NFT

mint 函数允许合约所有者为指定的地址创建一个新的 SBT。

2）禁止转移

通过重写 transferFrom 方法，禁止 SBT 的转移。任何尝试转移 SBT 的操作都会失败。

3）禁止授权

通过重写 approve 和 setApprovalForAll 方法来禁止授权操作。

2. SBT 学习证明合约 
我们再举一个实际使用的案例。比如，使用 SBT 为某项课程的学习做一个毕业证明，代表某项课程的学习成就。

我们可以修改前面的合约示例，使其包含额外的数据字段，以便存储与学习成就相关的信息。

在这个场景中，我们可以将 SBT 用作数字化的毕业证书，它记录了完成某个学习课程的信息。

以下是一个修改后的合约示例，该示例在 SBT 中包含了额外的元数据，用来表示学习成就的等级。
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract LearningCertificate is ERC721, Ownable {
  uint256 private _tokenIds;// 已铸造的 SBT 最大编号

  // 存储学习成就的结构体
  struct Achievement {
    string level;
    string courseName;
    string issuer;
    uint256 issueDate;
  }

  // 从 SBT ID 到学习成就的映射
  mapping(uint256 => Achievement) private _achievements;

 // 构造函数，设置 SBT 名称、符号和合约拥有者
  constructor(string memory name, string memory symbol)
    ERC721(name, symbol) Ownable(msg.sender)
  {}

  // 铸造 SBT
  function mint(address recipient, string memory level, 
    string memory courseName, string memory issuer)
    public onlyOwner returns (uint256) {
    // 计算新铸造的 SBT 的编号
    _tokenIds++; 
    uint256 newItemId = _tokenIds;
    // 铸造新的 SBT
    _mint(recipient, newItemId);

    // 保存学习成就数据
    _achievements[newItemId] = Achievement({
      level: level,
      courseName: courseName,
      issuer: issuer,
      issueDate: block.timestamp
    });

    return newItemId;
  }

  // 获取学习成就数据
  function getAchievement(uint256 tokenId)
    public view returns (Achievement memory) {
    require(tokenId>0 && tokenId<=_tokenIds, 
      "LearningCertificate: achievement query for nonexistent token");
    return _achievements[tokenId];
  }

   // 禁止转移 SBT
  function transferFrom(address, address, uint256)
    public pure override {
    revert("LearningCertificate: token is non-transferable");
  }

  // 禁止授权 SBT
  function approve(address, uint256)
 
  public pure override {
    revert("LearningCertificate: token is non-transferable");
  }

  // 禁止全部授权 SBT
  function setApprovalForAll(address, bool)
    public pure override {
    revert("LearningCertificate: token is non-transferable");
  }
}

/*
在这个合约中：

1）数据结构

Achievement 结构体，用于存储学习成就的信息，包括：学习水平、课程名称、发行者和发行日期。

2）铸造证书

mint 函数允许合约所有者为特定的学习成就创建一个 SBT，并将相关信息存储在合约中。

3）查询成就

getAchievement 函数允许任何人查询特定 SBT 的详细学习成就。

4）禁止转移

通过重写相关函数来禁止 SBT 的转移和授权。
*/