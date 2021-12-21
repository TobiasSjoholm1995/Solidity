// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

abstract contract EnterGuard {

    // uint256 saves gas comapared to bool
    uint256 private constant _opened = 1;
    uint256 private constant _closed = 2;

    uint256 private _status;

    constructor() {
        _status = _opened;
    }

    modifier enterOnceOnly() {
        require(_status == _opened, "EnterGuard: Only allowed to enter once.");
        _status = _closed;
        _;
        _status = _opened;
    }
}
