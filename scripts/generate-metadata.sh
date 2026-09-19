#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DISTROS=(bookworm trixie jammy noble)

echo "[APT] Generating Packages + Release per distro..."
for d in "${DISTROS[@]}"; do
  pool="$ROOT/deb/pool/$d"
  dist="$ROOT/deb/dists/$d"
  mkdir -p "$dist/main/binary-amd64" "$pool/main/w"
  if [ -n "$(ls -A "$pool" 2>/dev/null)" ]; then
    dpkg-scanpackages --multiversion "$pool" > "$dist/main/binary-amd64/Packages" 2>/dev/null || dpkg-scanpackages "$pool" > "$dist/main/binary-amd64/Packages"
    gzip -kf "$dist/main/binary-amd64/Packages"
  else
    echo "Package: wagonbox-placeholder" > "$dist/main/binary-amd64/Packages"
    gzip -kf "$dist/main/binary-amd64/Packages"
  fi
  apt-ftparchive release "$dist" > "$dist/Release"
  # Append required fields if missing
  grep -q "^Origin:" "$dist/Release" || echo "Origin: Wagonbox" >> "$dist/Release"
  grep -q "^Codename:" "$dist/Release" || echo "Codename: $d" >> "$dist/Release"
  # Sign if GPG key available
  if [ -n "${GPG_PRIVATE_KEY:-}" ]; then
    echo "$GPG_PRIVATE_KEY" | gpg --batch --import 2>/dev/null || true
    gpg --batch --yes --detach-sign --armor -o "$dist/InRelease" "$dist/Release" 2>/dev/null || true
    gpg --batch --yes --detach-sign --armor -o "$dist/Release.gpg" "$dist/Release" 2>/dev/null || true
  fi
  echo "  $d OK"
done

echo "[RPM] Generating repodata (requires createrepo_c)..."
for r in el9 el10; do
  if command -v createrepo_c &>/dev/null && [ -d "$ROOT/rpm/$r/x86_64" ]; then
    createrepo_c --update "$ROOT/rpm/$r/x86_64" 2>/dev/null || createrepo_c "$ROOT/rpm/$r/x86_64"
    echo "  $r OK"
  else
    echo "  $r skipped (createrepo_c not found)"
  fi
done
for f in 40 41; do
  if command -v createrepo_c &>/dev/null && [ -d "$ROOT/rpm/fedora/$f/x86_64" ]; then
    createrepo_c --update "$ROOT/rpm/fedora/$f/x86_64" 2>/dev/null || createrepo_c "$ROOT/rpm/fedora/$f/x86_64"
    echo "  fedora/$f OK"
  fi
done

echo "[SHA256SUMS] Regenerating..."
find "$ROOT/deb" "$ROOT/rpm" "$ROOT/keys" -type f \( -name "*.deb" -o -name "*.rpm" -o -name "*.gpg" \) | sort | xargs sha256sum > "$ROOT/keys/SHA256SUMS" 2>/dev/null || true
echo "Done."
