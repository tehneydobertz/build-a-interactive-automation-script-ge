pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/access/Roles.sol";

contract InteractiveAutomationScriptGenerator {
    // Mapping of automation scripts
    mapping (address => mapping (string => string)) public automationScripts;

    // Event emitted when a new automation script is generated
    event NewAutomationScript(address indexed user, string scriptName, string scriptCode);

    // Role for administrators
    Roles.Role private administrators;

    // Modifier to restrict access to administrators
    modifier onlyAdministrator() {
        require(administrators.has(msg.sender), "Only administrators can generate automation scripts");
        _;
    }

    // Function to generate a new automation script
    function generateAutomationScript(string memory _scriptName, string memory _scriptCode) public onlyAdministrator {
        // Generate a unique identifier for the script
        string memory scriptId = uint2str(uint(keccak256(abi.encodePacked(block.timestamp, _scriptName))) % (10**8));

        // Store the script in the mapping
        automationScripts[msg.sender][scriptId] = _scriptCode;

        // Emit the event
        emit NewAutomationScript(msg.sender, scriptId, _scriptCode);
    }

    // Function to retrieve an automation script
    function getAutomationScript(string memory _scriptId) public view returns (string memory) {
        return automationScripts[msg.sender][_scriptId];
    }
}