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
        token_total_supply = _token_total_supply * (10 ** (uint256(_token_decimals)));

        balances[msg.sender] = token_total_supply;
    }

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    error TransferFailed(address _from, address _to, uint256 _value);
    error NotEnoughFunds(address _from, address _to, uint256 _value);
    error NoAllowanceEnough(address _from, address _spender, uint256 _allowance);

    /**
     * @dev Getter function for the token name.
     * @return token_name
     */
    function name() external view returns (string memory) {
        return token_name;
    }

    /**
     * @dev Getter function for the token symbol.
     * @return token_symbol
     */
    function symbol() external view returns (string memory) {
        return token_symbol;
    }

    /**
     * @dev Getter function for the token decimals.
     * @return token_decimals
     */
    function decimals() external view returns (uint8) {
        return token_decimals;
    }

    /**
     * @dev Getter function for the total supply.
     * @return token_total_supply
     */
    function totalSupply() external view returns (uint256) {
        return token_total_supply;
    }

    /**
     * @dev Uses the balance mapping to retrieve the account balance.
     * @param _owner It is some account address.
     */
    function balanceOf(address _owner) external view returns (uint256 balance) {
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
     * @return bool that represents the success or failure of the transfer.
     */
    function transfer(address _to, uint256 _value) external returns (bool) {
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

        emit Transfer(msg.sender, _to, _value);

        return true;
    }

    /**
     * @dev Gives the _spender account the ability to spend msg.sender _amount of tokens.
     * @param _spender The account address allowed to spend.
     * @param _amount The amount the account address is allowed to spend.
     * @return bool Returns true.
     */
    function approve(address _spender, uint256 _amount) external returns (bool) {
        allowances[msg.sender][_spender] = _amount;

        emit Approval(msg.sender, _spender, _amount);

        return true;
    }

    /**
     * @dev transferFrom run checks to see if the msg.sender is allowed to move this _value.
            After this, checks to see if _from has enough funds to make the transfer.
            At last, the transfer is executed and the balance of _from is updated.
     * @param _from The origin account address.
     * @param _to The receiver account address.
     * @param _value The amount to be transfered.
     * @return bool The status of the transfer
     */
    function transferFrom(address _from, address _to, uint256 _value) external returns (bool) {
        uint256 balance_from = balances[_from]; 

        if (allowances[_from][msg.sender] < _value) {
            revert NoAllowanceEnough(_from, msg.sender, _value);
        }

        if (balance_from < _value) {
            revert NotEnoughFunds(_from, _to, _value);
        }

        balances[_to] += _value;
        balances[_from] -= _value;
        allowances[_from][msg.sender] -= _value;

        emit Transfer(_from, _to, _value);

        return true;
    }
}