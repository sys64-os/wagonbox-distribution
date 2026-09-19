# WagonBox GPG Archive Key

Key aktif: **RSA4096 `AE04CBED318B0A886CBC879C0DCAAC78E02EC2EC`** (`sys64-os <wespoker89@gmail.com>`), subkey `F066DCD7AD19E29E` [SEA], created 2026-09-19.

## Files

- `wagonbox-archive-keyring.gpg` — binary keyring (untuk `signed-by`)
- `wagonbox-archive-keyring.asc` — armored public key
- `SHA256SUMS` — checksum semua artifact

## Verifikasi

```bash
gpg --show-keys keys/wagonbox-archive-keyring.gpg
gpg --verify deb/dists/bookworm/InRelease
sha256sum -c keys/SHA256SUMS
```

## Client usage

```bash
curl -fsSL https://<org>.github.io/wagonbox-distribution/keys/wagonbox-archive-keyring.gpg | \
  sudo gpg --dearmor -o /usr/share/keyrings/wagonbox-archive-keyring.gpg
```
