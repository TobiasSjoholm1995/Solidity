// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

abstract contract Guardian {

    // uint256 saves gas comapared to bool
    uint256 private constant _allowed = 1;
    uint256 private constant _not_allowed = 2;

    uint256 private _status;

    constructor() {
        _status = _allowed;
    }

    modifier guard() {
        require(_status == _allowed, "EnterGuard: Not allowed to enter.");
        _status = _not_allowed;
        _;
        _status = _allowed;
    }
}
