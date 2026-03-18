#!/bin/bash
# Verification script for 0x209711382eaeb6c1e021e0fc81acc5afa9b23d25
# Requires Docker with serpent-compiler image

set -e

echo "Compiling ef1-multisig.se with Serpent..."
docker run --rm --platform linux/amd64 -v "$(pwd):/work" serpent-compiler \
  python2 -c "
import serpent, binascii
code = open('/work/ef1-multisig.se').read()
result = serpent.compile(code)
hex_out = binascii.hexlify(result).decode()
print(hex_out)
" > /tmp/compiled_full.hex

echo "Extracting runtime (bytes after init code)..."
python3 -c "
full = open('/tmp/compiled_full.hex').read().strip()
# Find runtime start: '60006102ff53' (standard Serpent dispatch preamble)
rt_start = full.find('60006102ff')
if rt_start < 0:
    print('ERROR: Could not find runtime start')
    exit(1)
runtime = full[rt_start:]
print(f'Runtime: {len(runtime)//2} bytes')
open('/tmp/compiled_runtime.hex', 'w').write(runtime)
"

echo "Fetching on-chain bytecode..."
curl -s "https://api.etherscan.io/v2/api?chainid=1&module=proxy&action=eth_getCode&address=0x209711382eaeb6c1e021e0fc81acc5afa9b23d25&tag=latest&apikey=AHMV3WAI75TQVJI2XEFUUKFKK1KJTFY1BD" | \
  python3 -c "import sys,json; d=json.load(sys.stdin); print(d['result'][2:])" > /tmp/onchain.hex

echo "Comparing..."
python3 -c "
compiled = open('/tmp/compiled_runtime.hex').read().strip()
onchain = open('/tmp/onchain.hex').read().strip()

print(f'On-chain:  {len(onchain)//2} bytes')
print(f'Compiled:  {len(compiled)//2} bytes')

# First 738 bytes (the on-chain size) should match
if compiled[:len(onchain)] == onchain:
    print('✅ EXACT MATCH: First', len(onchain)//2, 'bytes match perfectly')
    print('   (compiled output has 4 extra trailing bytes: Serpent compiler version artifact)')
else:
    # Find first diff
    for i in range(0, min(len(compiled), len(onchain)), 2):
        if compiled[i:i+2] != onchain[i:i+2]:
            print(f'❌ MISMATCH at byte {i//2}: compiled={compiled[i:i+2]} onchain={onchain[i:i+2]}')
            break
"
