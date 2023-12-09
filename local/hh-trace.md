npx hardhat test --traceError # prints calls for failed txs
npx hardhat test --fulltraceError # prints calls and storage ops for failed txs
npx hardhat test --trace # prints calls for all txs
npx hardhat test --fulltrace # prints calls and storage ops for all txs

npx hardhat test --v    # same as --traceError
npx hardhat test --vv   # same as --fulltraceError
npx hardhat test --vvv  # same as --trace
npx hardhat test --vvvv # same as --fulltrace

# specify opcode
npx hardhat test --v --opcodes ADD,SUB   # shows any opcode specified for only failed txs
npx hardhat test --vvv --opcodes ADD,SUB # shows any opcode specified for all txs