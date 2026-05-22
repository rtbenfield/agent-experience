#!/usr/bin/env bash
set -euo pipefail

LATEST_TAG=$(curl -s --fail https://api.github.com/repos/gitleaks/gitleaks/releases/latest | grep -Po '"tag_name": "\K.*?(?=")')
VERSION=${1:-$LATEST_TAG}

echo "Installing gitleaks ${VERSION}..."

# Asset filenames strip the "v" prefix from the version tag
VER_NUM="${VERSION#v}"

OS="linux"
ARCH=$(uname -m | sed 's/x86_64/x64/; s/aarch64/arm64/')
FILENAME="gitleaks_${VER_NUM}_${OS}_${ARCH}.tar.gz"
URL="https://github.com/gitleaks/gitleaks/releases/download/${VERSION}/${FILENAME}"

TMPDIR=$(mktemp -d)
trap "rm -rf ${TMPDIR}" EXIT

curl -sL --fail "$URL" -o "${TMPDIR}/${FILENAME}"
tar -xzf "${TMPDIR}/${FILENAME}" -C "${TMPDIR}"
sudo install "${TMPDIR}/gitleaks" /usr/local/bin/

echo "gitleaks installed to /usr/local/bin/gitleaks"

HOOK_DIR="${HOME}/.git/hooks"
mkdir -p "${HOOK_DIR}"

cat > "${HOOK_DIR}/pre-commit" << 'HOOK'
#!/usr/bin/env bash
set -euo pipefail

echo "Running gitleaks protect --staged..."
gitleaks protect --staged
HOOK

chmod +x "${HOOK_DIR}/pre-commit"
git config --global core.hooksPath "${HOOK_DIR}"

echo "Global git pre-commit hook installed at ${HOOK_DIR}/pre-commit"
