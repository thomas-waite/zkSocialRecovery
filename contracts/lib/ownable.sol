pragma solidity ^0.5.15;


/// @title Ownable has an owner address and provides basic authorization control functions.
/// This contract is modified version of the MIT OpenZepplin Ownable contract
/// This contract allows for the transferOwnership operation to be made impossible
/// https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/ownership/Ownable.sol
contract Ownable {
    event TransferredOwnership(address _from, address _to);
    event LockedOwnership(address _locked);

    address payable private _owner;
    bool private _isTransferable;

    /// @notice Constructor sets the original owner of the contract and whether or not it is one time transferable.
    constructor(address payable _account_, bool _transferable_) internal {
        _owner = _account_;
        _isTransferable = _transferable_;
        // Emit the LockedOwnership event if no longer transferable.
        if (!_isTransferable) {
            emit LockedOwnership(_account_);
        }
        emit TransferredOwnership(address(0), _account_);
    }

    /// @notice Reverts if called by any account other than the owner.
    modifier onlyOwner() {
        require(_isOwner(msg.sender), "sender is not owner");
        _;
    }

    /// @notice check if the ownership is transferable.
    /// @return true if the ownership is transferable.
    function isTransferable() external view returns (bool) {
        return _isTransferable;
    }

    /// @notice Find out owner address
    /// @return address of the owner.
    function owner() public view returns (address payable) {
        return _owner;
    }

    /// @notice Check if owner address
    /// @return true if sender is the owner of the contract.
    function _isOwner(address _address) internal view returns (bool) {
        return _address == _owner;
    }

    /// @notice Allows the current owner to transfer control of the contract to a new address.
    /// @param _account address to transfer ownership to.
    /// @param _transferable indicates whether to keep the ownership transferable.
    function _transferOwnership(address payable _account, bool _transferable) internal {
        // Require that the ownership is transferable.
        require(_isTransferable, "ownership is not transferable");
        // Require that the new owner is not the zero address.
        require(_account != address(0), "owner cannot be set to zero address");
        // Set the transferable flag to the value _transferable passed in.
        _isTransferable = _transferable;
        // Emit the LockedOwnership event if no longer transferable.
        if (!_transferable) {
            emit LockedOwnership(_account);
        }
        // Emit the ownership transfer event.
        emit TransferredOwnership(_owner, _account);
        // Set the owner to the provided address.
        _owner = _account;
    }

}
