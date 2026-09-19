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
    └── SHA256SUMS
```

Target matrix: `bookworm` `trixie` `jammy` `noble` `el9` `el10` `fc40` `fc41` — `amd64`/`x86_64` only.

## Client Installation

### APT (Debian/Ubuntu) — per-codename

```bash
# 1. Import GPG key
curl -fsSL https://<org>.github.io/wagonbox-distribution/keys/wagonbox-archive-keyring.gpg | \
  sudo gpg --dearmor -o /usr/share/keyrings/wagonbox-archive-keyring.gpg

# 2. Add repository (ganti CODENAME: bookworm|trixie|jammy|noble)
CODENAME=$( . /etc/os-release && echo $VERSION_CODENAME)
echo "deb [signed-by=/usr/share/keyrings/wagonbox-archive-keyring.gpg] https://<org>.github.io/wagonbox-distribution/deb $CODENAME main" | \
  sudo tee /etc/apt/sources.list.d/wagonbox.list

# 3. Install
sudo apt update
sudo apt install wagonbox-core
```

### DNF (RHEL/Fedora/Rocky/Alma)

```bash
# RHEL 9 / Rocky 9 / Alma 9
sudo dnf config-manager --add-repo https://<org>.github.io/wagonbox-distribution/rpm/el9/x86_64/
# RHEL 10
sudo dnf config-manager --add-repo https://<org>.github.io/wagonbox-distribution/rpm/el10/x86_64/
# Fedora 40 / 41
sudo dnf config-manager --add-repo https://<org>.github.io/wagonbox-distribution/rpm/fedora/40/x86_64/

sudo dnf install wagonbox-core
```

## Automation

`scripts/generate-metadata.sh` regenerates APT (`Packages`, `Release`, `InRelease`/`Release.gpg` jika `GPG_PRIVATE_KEY` ada) dan RPM `repodata` (butuh `createrepo_c`). Dijalankan otomatis oleh `.github/workflows/pages.yml` pada push ke `main` dan publish ke GitHub Pages.

```bash
bash scripts/generate-metadata.sh
```

## GPG Signing

Key aktif: **RSA4096 `AE04CBED318B0A886CBC879C0DCAAC78E02EC2EC`** (`sys64-os <wespoker89@gmail.com>`, subkey `F066DCD7AD19E29E`), public key di `keys/wagonbox-archive-keyring.gpg` (+ `.asc`). Semua `dists` sudah di-sign lokal (`InRelease` + `Release.gpg`).

> **Status:** Repo ini **belum di-push ke GitHub** — masih lokal saja. Setelah push, setup Pages & signing:
> 1. Buat repo GitHub `wagonbox-distribution` (public), `git push -u origin main`.
> 2. **Pages:** Settings → Pages → Build and deployment → Source: **GitHub Actions**.
> 3. **Signing CI:** Settings → Secrets → Actions → New secret `GPG_PRIVATE_KEY` — isi dengan `gpg --export-secret-keys --armor AE04CBED318B0A886CBC879C0DCAAC78E02EC2EC`. Workflow `.github/workflows/pages.yml` akan re-sign `Release` tiap push.

Verifikasi lokal: `gpg --show-keys keys/wagonbox-archive-keyring.gpg` dan `gpg --verify deb/dists/bookworm/InRelease`.
