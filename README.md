# WagonBox Distribution Repository

Unified public hosting for WagonBox Linux packages (APT + DNF) and GPG keys.

## Structure

```
wagonbox-distribution/
├── deb/                          # APT Repository (Debian/Ubuntu)
│   ├── pool/main/w/              # .deb packages by module
│   └── dists/stable/main/binary-amd64/
│       ├── Packages              # Package index
│       ├── Packages.gz           # Compressed index
│       ├── Release               # Repository metadata
│       └── InRelease             # GPG-signed Release (auto-generated)
├── rpm/                          # DNF/YUM Repository (RHEL/Fedora/Rocky/Alma)
│   ├── fedora/40/x86_64/         # Fedora 40 packages + repodata/
│   └── el9/x86_64/               # RHEL 9 / Rocky 9 / Alma 9 packages + repodata/
└── keys/                         # GPG Public Keys
    └── wagonbox-archive-keyring.gpg
```

## Client Installation

### APT (Debian/Ubuntu)

```bash
# 1. Import GPG key
curl -fsSL https://sys64-os.github.io/wagonbox-distribution/keys/wagonbox-archive-keyring.gpg | \
  sudo gpg --dearmor -o /usr/share/keyrings/wagonbox-archive-keyring.gpg

# 2. Add repository
echo "deb [signed-by=/usr/share/keyrings/wagonbox-archive-keyring.gpg] \
  https://sys64-os.github.io/wagonbox-distribution/deb/ stable main" | \
  sudo tee /etc/apt/sources.list.d/wagonbox.list

# 3. Install
sudo apt update
sudo apt install wagonbox-core wagonbox-ui wagonbox-iam-advance wagonbox-network-advance wagonbox-storage-advance wagonbox-hosting
```

### DNF (RHEL/Fedora/Rocky/Alma)

```bash
# Fedora 40+
sudo dnf config-manager --add-repo \
  https://sys64-os.github.io/wagonbox-distribution/rpm/fedora/40/x86_64/

# RHEL 9 / Rocky 9 / Alma 9
sudo dnf config-manager --add-repo \
  https://sys64-os.github.io/wagonbox-distribution/rpm/el9/x86_64/

# Install
sudo dnf install wagonbox-core wagonbox-ui
```

## Automation

This repository is **automatically updated** by GitHub Actions from private source repositories when new releases are tagged. Do not manually commit to this repository.

## License

Packages are distributed under their respective licenses. Core packages: MIT License.
