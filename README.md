# WagonBox Distribution Repository

Unified public hosting for WagonBox Linux packages (APT + DNF/YUM) and GPG keys. Hosted via GitHub Pages — no token required.

## Structure

```
wagonbox-distribution/
├── deb/
│   ├── pool/<distro>/main/w/          # .deb per distro (bookworm,trixie,jammy,noble)
│   └── dists/<distro>/main/binary-amd64/
│       ├── Packages / Packages.gz
│       ├── Release / InRelease / Release.gpg
├── rpm/
│   ├── el9/x86_64/ + repodata/        # RHEL 9 / Rocky 9 / Alma 9
│   ├── el10/x86_64/ + repodata/       # RHEL 10
│   ├── fedora/40/x86_64/ + repodata/
│   └── fedora/41/x86_64/ + repodata/
└── keys/
    ├── wagonbox-archive-keyring.gpg
    ├── wagonbox-archive-keyring.asc
    └── SHA256SUMS
```

Target matrix: `bookworm` `trixie` `jammy` `noble` `el9` `el10` `fc40` `fc41` — `amd64`/`x86_64` only.

## Client Installation

### APT (Debian/Ubuntu) — per-codename

```bash
# 1. Import GPG key
curl -fsSL https://sys64-os.github.io/wagonbox-distribution/keys/wagonbox-archive-keyring.gpg | \
  sudo gpg --dearmor -o /usr/share/keyrings/wagonbox-archive-keyring.gpg

# 2. Add repository (ganti CODENAME: bookworm|trixie|jammy|noble)
CODENAME=$( . /etc/os-release && echo $VERSION_CODENAME)
echo "deb [signed-by=/usr/share/keyrings/wagonbox-archive-keyring.gpg] https://sys64-os.github.io/wagonbox-distribution/deb $CODENAME main" | \
  sudo tee /etc/apt/sources.list.d/wagonbox.list

# 3. Install
sudo apt update
sudo apt install wagonbox-core
```

### DNF (RHEL/Fedora/Rocky/Alma)

```bash
# RHEL 9 / Rocky 9 / Alma 9
sudo dnf config-manager --add-repo https://sys64-os.github.io/wagonbox-distribution/rpm/el9/x86_64/
# RHEL 10
sudo dnf config-manager --add-repo https://sys64-os.github.io/wagonbox-distribution/rpm/el10/x86_64/
# Fedora 40 / 41
sudo dnf config-manager --add-repo https://sys64-os.github.io/wagonbox-distribution/rpm/fedora/40/x86_64/

sudo dnf install wagonbox-core
```

## GPG Key

**RSA4096 `AE04CBED318B0A886CBC879C0DCAAC78E02EC2EC`** (`sys64-os <wespoker89@gmail.com>`), subkey `F066DCD7AD19E29E`.

Public key: `keys/wagonbox-archive-keyring.gpg` (binary) / `.asc` (armored). Semua `dists` di-sign (`InRelease` + `Release.gpg`).

Verifikasi: `gpg --show-keys keys/wagonbox-archive-keyring.gpg`

## License

Packages are distributed under their respective licenses. Core packages: MIT License.