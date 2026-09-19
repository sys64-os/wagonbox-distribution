# WagonBox GPG Public Key
# This is the official WagonBox GPG public key for package verification

## Key Information
- Algorithm: ECDSA P-256
- Fingerprint: [A-B-C-D...]

## Usage
1. Download the public key:
   curl -fsSL https://raw.githubusercontent.com/sys64-os/wagonbox-key/main/wagonbox.gpg > wagonbox.gpg
2. Import the key:
   gpg --dearmor < wagonbox.gpg
3. Add to your package manager's keyring
