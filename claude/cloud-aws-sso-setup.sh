#!/usr/bin/env bash
# Claude Code cloud container setup: AWS CLI + AWS SSO (Hudl) with device-code login.
#
# Use as (or from) the environment's setup script. It:
#   1. installs AWS CLI v2 if missing
#   2. writes ~/.aws/config (sso-session Hudl + AIReadOnly profiles)
#   3. installs an `aws-sso-login` helper that does a device-code login
#
# Then ask the agent: "run aws-sso-login" -> it prints a URL + code, you open the
# URL in your own browser, approve, and the container session is authenticated.
#
# Optional env vars:
#   AWS_SSO_DEFAULT_PROFILE  profile used when none is passed (default: AIReadOnly_Main_0493)
set -euo pipefail

DEFAULT_PROFILE="${AWS_SSO_DEFAULT_PROFILE:-AIReadOnly_Main_0493}"
BIN_DIR="${HOME}/.local/bin"
mkdir -p "$BIN_DIR" "$HOME/.aws"

# --- 1. AWS CLI v2 -----------------------------------------------------------
if ! command -v aws >/dev/null 2>&1; then
  echo "Installing AWS CLI v2..."
  tmp="$(mktemp -d)"
  arch="$(uname -m)"   # x86_64 or aarch64
  curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-${arch}.zip" -o "$tmp/awscliv2.zip"
  unzip -q "$tmp/awscliv2.zip" -d "$tmp"
  "$tmp/aws/install" --bin-dir "$BIN_DIR" --install-dir "$HOME/.local/aws-cli" --update
  rm -rf "$tmp"
fi

# --- 2. ~/.aws/config --------------------------------------------------------
cat > "$HOME/.aws/config" <<'CFG'
[sso-session Hudl]
sso_start_url = https://hudl.awsapps.com/start
sso_region = us-east-1
sso_registration_scopes = sso:account:access

[profile AIReadOnly_Main_0493]
sso_session = Hudl
sso_account_id = 761584570493
sso_role_name = AIReadOnly_Main_0493
region = us-east-1
output = json

[profile AIReadOnly_Theo_9447]
sso_session = Hudl
sso_account_id = 881490109447
sso_role_name = AIReadOnly_Theo_9447
region = us-east-1
output = json

[profile AIReadOnly_BlueFrame_8980]
sso_session = Hudl
sso_account_id = 558042398980
sso_role_name = AIReadOnly_BlueFrame_8980
region = us-east-1
output = json

[profile AIReadOnly_Thor_2276]
sso_session = Hudl
sso_account_id = 988906592276
sso_role_name = AIReadOnly_Thor_2276
region = us-east-1
output = json

[profile AIReadOnly_Prod_5857]
sso_session = Hudl
sso_account_id = 184181125857
sso_role_name = AIReadOnly_Prod_5857
region = us-east-1
output = json
CFG
chmod 600 "$HOME/.aws/config"

# --- 3. aws-sso-login helper -------------------------------------------------
cat > "$BIN_DIR/aws-sso-login" <<HELPER
#!/usr/bin/env bash
# Device-code AWS SSO login. Usage: aws-sso-login [profile]
# Prints a verification URL and user code; open the URL in your own browser.
set -euo pipefail
profile="\${1:-\${AWS_PROFILE:-$DEFAULT_PROFILE}}"

# Route through the container's proxy CA if present.
[ -f /root/.ccr/ca-bundle.crt ] && export AWS_CA_BUNDLE="\${AWS_CA_BUNDLE:-/root/.ccr/ca-bundle.crt}"

# Already signed in? Nothing to do.
if aws sts get-caller-identity --profile "\$profile" >/dev/null 2>&1; then
  echo "Already authenticated as profile \$profile:"
  aws sts get-caller-identity --profile "\$profile"
  exit 0
fi

echo "Starting AWS SSO device-code login for profile: \$profile"
echo "Open the URL below in YOUR browser and enter the code if prompted."
aws sso login --profile "\$profile" --use-device-code --no-browser

echo
aws sts get-caller-identity --profile "\$profile"
echo "Use it with: export AWS_PROFILE=\$profile   (or pass --profile \$profile)"
HELPER
chmod +x "$BIN_DIR/aws-sso-login"

# --- 4. PATH + defaults for future shells -----------------------------------
marker="# >>> aws-sso (claude cloud) >>>"
if ! grep -qF "$marker" "$HOME/.bashrc" 2>/dev/null; then
  cat >> "$HOME/.bashrc" <<RC
$marker
export PATH="\$HOME/.local/bin:\$PATH"
export AWS_PROFILE="\${AWS_PROFILE:-$DEFAULT_PROFILE}"
[ -f /root/.ccr/ca-bundle.crt ] && export AWS_CA_BUNDLE="\${AWS_CA_BUNDLE:-/root/.ccr/ca-bundle.crt}"
# <<< aws-sso (claude cloud) <<<
RC
fi

echo "AWS SSO setup done. Run: aws-sso-login [profile]   (default: $DEFAULT_PROFILE)"
