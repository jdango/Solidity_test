// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

/**
 * @title BitMap Library
 * @notice 使用紧凑的位图存储来标记已领取状态，每个存储槽可以存储 256 个布尔值
 */
library BitMap {
    struct Map {
        mapping(uint256 => uint256) bits;
    }

    function get(Map storage map, uint256 index) internal view returns (bool) {
        uint256 bucket = index >> 8;
        uint256 mask = 1 << (index & 0xff);
        return map.bits[bucket] & mask != 0;
    }

    function set(Map storage map, uint256 index) internal {
        uint256 bucket = index >> 8;
        uint256 mask = 1 << (index & 0xff);
        map.bits[bucket] |= mask;
    }
}

/**
 * @title GasOptimizedAirdrop
 * @notice 一个经过 gas 优化的空投合约，使用了多种 gas 优化技术
 */
contract GasOptimizedAirdrop is Ownable(msg.sender), ReentrancyGuard {
    using SafeERC20 for IERC20;
    using BitMap for BitMap.Map;

    // 状态变量
    IERC20 public immutable token;
    uint96 public immutable minEthRequired;
    
    struct AirdropConfig {
        uint96 airdropAmount;
        uint96 maxAirdropSupply;
        uint64 totalAirdropped;
    }
    AirdropConfig public config;
    
    BitMap.Map private claimedBitMap;
    
    uint64 public airdropStartTime;
    uint64 public airdropEndTime;
    
    // 自定义错误
    error NotActive();
    error AlreadyClaimed();
    error InsufficientBalance();
    error MaxSupplyReached();
    error InvalidAddress();
    error InvalidAmount();
    error InvalidTime();
    
    // 事件
    event AirdropClaimed(address indexed user, uint96 amount);
    event AirdropConfigUpdated(uint96 amount, uint96 maxSupply);
    
    /**
     * @notice 构造函数初始化空投合约
     * @param _token 空投代币地址
     * @param _minEthRequired 最小 ETH 持有量要求
     * @param _airdropAmount 每个地址可领取的代币数量
     * @param _maxSupply 最大空投供应量
     * @param _startTime 空投开始时间
     * @param _endTime 空投结束时间
     */
    constructor(
        address _token,
        uint96 _minEthRequired,
        uint96 _airdropAmount,
        uint96 _maxSupply,
        uint64 _startTime,
        uint64 _endTime
    ) {
        // 参数验证
        if (_token == address(0)) revert InvalidAddress();
        if (_airdropAmount == 0) revert InvalidAmount();
        if (_maxSupply < _airdropAmount) revert InvalidAmount();
        if (_startTime >= _endTime) revert InvalidTime();
        if (_startTime < block.timestamp) revert InvalidTime();
        
        // 初始化状态变量
        token = IERC20(_token);
        minEthRequired = _minEthRequired;
        
        config.airdropAmount = _airdropAmount;
        config.maxAirdropSupply = _maxSupply;
        config.totalAirdropped = 0;
        
        airdropStartTime = _startTime;
        airdropEndTime = _endTime;
    }
    
    
    /**
     * @notice 用户领取空投
     * @dev 包含多重检查和状态更新的主要功能
     */
    function claimAirdrop() external nonReentrant {
        _validateClaim(msg.sender);
        
        uint256 userIndex = uint256(uint160(msg.sender));
        claimedBitMap.set(userIndex);
        
        unchecked {
            config.totalAirdropped += uint64(config.airdropAmount);
        }
        
        token.safeTransfer(msg.sender, config.airdropAmount);
        
        emit AirdropClaimed(msg.sender, config.airdropAmount);
    }
    
    /**
     * @notice 验证领取资格
     * @param user 要验证的用户地址
     */
    function _validateClaim(address user) private view {
        if (block.timestamp < airdropStartTime || block.timestamp > airdropEndTime) {
            revert NotActive();
        }
        
        if (claimedBitMap.get(uint256(uint160(user)))) {
            revert AlreadyClaimed();
        }
        
        if (user.balance < minEthRequired) {
            revert InsufficientBalance();
        }
        
        unchecked {
            if (config.totalAirdropped + config.airdropAmount > config.maxAirdropSupply) {
                revert MaxSupplyReached();
            }
        }
    }
    
    /**
     * @notice 批量检查地址是否有资格领取空投
     * @param users 要检查的地址数组
     * @return eligibility 每个地址的资格状态数组
     */
    function checkEligibility(address[] calldata users) external view 
        returns (bool[] memory eligibility) 
    {
        eligibility = new bool[](users.length);
        uint256 currentTime = block.timestamp;
        
        for (uint256 i = 0; i < users.length;) {
            eligibility[i] = _isEligible(users[i], currentTime);
            unchecked { ++i; }
        }
    }
    
    /**
     * @notice 检查单个地址的领取资格
     * @param user 要检查的地址
     * @param currentTime 当前时间戳
     * @return 是否有资格领取
     */
    function _isEligible(address user, uint256 currentTime) private view returns (bool) {
        return 
            currentTime >= airdropStartTime &&
            currentTime <= airdropEndTime &&
            user.balance >= minEthRequired &&
            !claimedBitMap.get(uint256(uint160(user))) &&
            (config.totalAirdropped + config.airdropAmount <= config.maxAirdropSupply);
    }

    /**
     * @notice 紧急提取合约中的代币（仅合约所有者）
     */
    function emergencyWithdraw() external onlyOwner {
        uint256 balance = token.balanceOf(address(this));
        if (balance == 0) revert InsufficientBalance();
        token.safeTransfer(msg.sender, balance);
    }
}