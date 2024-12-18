// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";

/**
 * @title SkyToken
 * @dev Sky Token (SKY) 的主要合约实现
 * 实现了可升级的 ERC20 代币标准，包含完整的安全特性和扩展功能
 */
contract SkyToken is 
    Initializable, 
    ERC20Upgradeable, 
    OwnableUpgradeable, 
    ERC20PausableUpgradeable,
    ReentrancyGuardUpgradeable 
{
    // 状态变量声明
    uint256 private constant INITIAL_SUPPLY = 100_000_000 ether;  // 1亿初始供应量
    uint256 private constant MAX_TOTAL_SUPPLY = 1_000_000_000 ether;    // 10亿最大供应量
    uint256 private constant CURRENT_VERSION = 1;
    
    uint256 public currentVersion;
    uint256 public maxTokenSupply;
    
    // 代币经济参数
    uint256 public constant MINT_LIMIT_PER_TX = 1_000_000 ether;  // 每次铸造限额：100万代币
    uint256 public constant BURN_LIMIT_PER_TX = 500_000 ether;    // 每次销毁限额：50万代币
    
    // 权限管理
    mapping(address => bool) public isBlacklisted;
    mapping(address => bool) public isMinterRole;
    
    // 事件声明
    event BlacklistStatusUpdated(address indexed account, bool status);
    event MinterRoleUpdated(address indexed account, bool status);
    event TokensBurnedBy(address indexed burner, uint256 amount);
    event TokensMintedTo(address indexed recipient, uint256 amount);
    
    // 自定义错误
    error SupplyExceedsMax();
    error ExceedsMintLimit();
    error ExceedsBurnLimit();
    error AccountIsBlacklisted();
    error InvalidTokenAmount();
    error InvalidAddress();
    error NotAuthorizedMinter();

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    /**
     * @dev 初始化 Sky Token 合约
     * 设置代币名称、符号，并分配初始供应量
     */
    function initialize() public initializer {
        __ERC20_init("Sky Token", "SKY");
        __Ownable_init(msg.sender);
        __ERC20Pausable_init();
        __ReentrancyGuard_init();
        
        maxTokenSupply = MAX_TOTAL_SUPPLY;
        currentVersion = CURRENT_VERSION;
        
        // 初始化代币供应量
        _mint(msg.sender, INITIAL_SUPPLY);
        
        // 设置部署者为铸币者
        isMinterRole[msg.sender] = true;
        emit MinterRoleUpdated(msg.sender, true);
    }

    /**
     * @dev 重写 _update 函数以实现黑名单检查和暂停功能
     * @param from 发送方地址
     * @param to 接收方地址
     * @param value 转账金额
     */
    function _update(
        address from,
        address to,
        uint256 value
    ) internal virtual override(ERC20Upgradeable, ERC20PausableUpgradeable) {
        // 黑名单检查
        if (isBlacklisted[from] || isBlacklisted[to]) revert AccountIsBlacklisted();
        
        // 调用父合约的实现
        super._update(from, to, value);
    }
    
    /**
     * @dev 铸造新代币（仅授权铸币者）
     * @param recipient 接收地址
     * @param amount 铸造数量
     */
    function mint(address recipient, uint256 amount) external nonReentrant {
        if (!isMinterRole[msg.sender]) revert NotAuthorizedMinter();
        if (recipient == address(0)) revert InvalidAddress();
        if (amount == 0) revert InvalidTokenAmount();
        if (amount > MINT_LIMIT_PER_TX) revert ExceedsMintLimit();
        if (totalSupply() + amount > maxTokenSupply) revert SupplyExceedsMax();
        
        _mint(recipient, amount);
        emit TokensMintedTo(recipient, amount);
    }
    
    /**
     * @dev 销毁代币
     * @param amount 销毁数量
     */
    function burn(uint256 amount) public virtual nonReentrant {
        if (amount == 0) revert InvalidTokenAmount();
        if (amount > BURN_LIMIT_PER_TX) revert ExceedsBurnLimit();
        
        _burn(_msgSender(), amount);
        emit TokensBurnedBy(_msgSender(), amount);
    }
    
    /**
     * @dev 设置铸币权限（仅所有者）
     * @param account 目标地址
     * @param status 是否授予铸币权限
     */
    function setMinterRole(address account, bool status) external onlyOwner {
        if (account == address(0)) revert InvalidAddress();
        isMinterRole[account] = status;
        emit MinterRoleUpdated(account, status);
    }
    
    /**
     * @dev 更新黑名单状态（仅所有者）
     * @param account 目标地址
     * @param status 是否加入黑名单
     */
    function updateBlacklistStatus(address account, bool status) external onlyOwner {
        if (account == address(0)) revert InvalidAddress();
        isBlacklisted[account] = status;
        emit BlacklistStatusUpdated(account, status);
    }

    /**
     * @dev 暂停所有代币转移（仅所有者）
     */
    function pause() external onlyOwner {
        _pause();
    }

    /**
     * @dev 恢复代币转移（仅所有者）
     */
    function unpause() external onlyOwner {
        _unpause();
    }
    
    /**
     * @dev 检查地址是否具有铸币权限
     * @param account 要检查的地址
     * @return bool 是否是铸币者
     */
    function hasMinterRole(address account) public view returns (bool) {
        return isMinterRole[account];
    }
}