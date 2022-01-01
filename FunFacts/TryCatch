// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Fun Fact: 
// Try statement can be used to catch errors in external calls and new contracts call.

// Costum errors are new to solidity
// and for now they can't be cought in a special/filter catch block.

contract Test {
    error MyOwnError1(string message);

    function causeCostumError() external pure {
        revert MyOwnError1("MyOwnError");
    }

    function requireWithText() external pure {
        require(false, "Require with text");
    }

    function requireWithoutText() external pure {
        require(false);
    }

    function causePanic() external pure {
       assert(0 == 1);
    }

    function success() external pure {
    }

}


contract TryCatch {

    function test(uint v) external returns(string memory) {
        Test t = new Test();
        function() external pure func;

        if (v == 0)
            func = t.causeCostumError; 
        else if (v == 1)
            func = t.requireWithText;
        else if (v == 2)
            func = t.requireWithoutText;
        else if (v == 3) 
            func = t.causePanic;
        else 
            func = t.success;

        
        try func() {
            // this is a success block
            // any errors here won't be cought
            return "Success";   
        }
        catch Error(string memory errorMsg) {
            // revert was called and an errorMsg was provided.
            // WARNING: Costum errors dont seem to be cought here...
            return errorMsg;
        }
        catch Panic(uint /*errorCode*/) {
            // This is executed in case of a panic,
            // i.e. a serious error like division by zero or overflow or Assert
            // The error code can be used to determine the kind of error.
            return "Panic error";
        }
        catch {
            // This is executed in case revert() was used or costum error (for now, might change in the future).
            return "Error with no text";
        }

    }
}

