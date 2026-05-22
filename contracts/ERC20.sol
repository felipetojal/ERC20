// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.26;

/**
 * @title ERC20 contract.
 * @author felipetojal
 * @notice ERC20 is an ERC-20 interface created for educational purposes.
*/
contract ERC20 {
    string internal token_name;
    string internal token_symbol;
    uint256 internal token_total_supply;
    /**
     * @notice Returns the number of decimals the token uses.
     */
    uint8 internal token_decimals;

    /**
     * @dev Maps account address to account balance.
     */
    mapping(address => uint256) internal balances;

    /**
     * @dev Maps the account address to a map of account address mapped to a balance.
            This structure allows us to keep track os all the allowances in the smart contract.
     */
    mapping(address => mapping(address => uint256)) internal allowances;

    constructor(string memory _token_name, string memory _token_symbol, uint8 _token_decimals, uint256 _token_total_supply) {
        token_name = _token_name;
        token_symbol = _token_symbol;
        token_decimals = _token_decimals;
        token_total_supply = _token_total_supply;
    }
    
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    error TransferFailed(address _from, address _to, uint256 _value);

    /**
     * @return token_name
     */
    function name() public view returns (string memory) {
        return token_name;
    }

    /**
     * @return token_symbol
     */
    function symbol() public view returns (string memory) {
        return token_symbol;
    } 

    /**
     * @return token_decimals
     */
    function decimals() public view returns (uint8) {
        return token_decimals;
    }

    /**
     * @return token_total_supply
     */
    function total_supply() public view returns (uint256) {
        return token_total_supply;
    }

    /**
     * @param _owner It is some account address.
     * @dev Uses the balance mapping to retrieve the account balance.
     */
    function balanceOf(address _owner) public view returns (uint256 balance) {
        balance = balances[_owner]; 
        return balance;
    } 

    /**
     * @dev Getter function to check a spender allowance in some account address.
     * @param owner The account address of the account owner.
     * @param spender The account address of the account allowed to spend;
     * @return _allowance The value allowed for the spender to spend.
     */
    function allowance(address owner, address spender) external view returns (uint256 _allowance) {
        _allowance = allowances[owner][spender];
        return _allowance;
    }

    /**
     * @dev Checks the balance of the sender comparing it to the value to be transfered.
            If it is ok, proceeds to perform the transfer.
     * @notice Transfers value from the callee to the account address _to.
     * @param _to The receiver account address.
     * @param _value The amount to be transfered from the origin account to the receiver account.
     * @return success Boolean that represents the success or failure of the transfer.
     */
    function transfer(address _to, uint256 _value) public returns (bool success) {
        uint256 _from_balance = balances[msg.sender];
        
        require(
            _from_balance > 0, 
            "ORIGIN ACCOUNT BALANCE IS 0"
        );
        require(
            _from_balance >= _value,
            "ORIGINAL ACCOUNT BALANCE IS LESS THAN TRANSFERED AMOUNT"
        );

        _from_balance -= _value;
        balances[msg.sender] = _from_balance;
        balances[_to] += _value;

        (success, ) = payable(_to).call{value: _value}("");
        if (!success) {
            revert TransferFailed(msg.sender, _to, _value);
        }

        return success;
    }

    function transferFrom(address _from, address _to, uint256 value) public returns (bool success) {

    }
}