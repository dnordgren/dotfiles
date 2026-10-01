#!/usr/bin/env bash
# Claude Code cloud container setup: AWS CLI + AWS SSO (Hudl) with device-code login.
# No heredocs on purpose: every config line is a quoted printf argument, so a
# partial/mangled paste can never be executed as shell commands.
#
# Afterwards ask the agent: "run aws-sso-login" -> it prints a URL + code, you
# approve in your own browser, and the container session is authenticated.
#
# Optional env var: AWS_SSO_DEFAULT_PROFILE (default: AIReadOnly_Main_0493)
set -eu

DEFAULT_PROFILE="${AWS_SSO_DEFAULT_PROFILE:-AIReadOnly_Main_0493}"
BIN_DIR="$HOME/.local/bin"
mkdir -p "$BIN_DIR" "$HOME/.aws"

# --- 1. AWS CLI v2 -----------------------------------------------------------
if ! command -v aws >/dev/null 2>&1 && [ ! -x "$BIN_DIR/aws" ]; then
  echo "Installing AWS CLI v2..."
  tmp="$(mktemp -d)"
  curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-$(uname -m).zip" -o "$tmp/awscliv2.zip"
  unzip -q "$tmp/awscliv2.zip" -d "$tmp"
  "$tmp/aws/install" --bin-dir "$BIN_DIR" --install-dir "$HOME/.local/aws-cli" --update
  rm -rf "$tmp"
fi

# --- 2. ~/.aws/config --------------------------------------------------------
{
  printf '%s\n' \
    '[sso-session Hudl]' \
    'sso_start_url = https://hudl.awsapps.com/start' \
    'sso_region = us-east-1' \
    'sso_registration_scopes = sso:account:access' \
    ''
  # profile name | account id
  for p in AIReadOnly_Main_0493:761584570493 AIReadOnly_Theo_9447:881490109447 \
           AIReadOnly_BlueFrame_8980:558042398980 AIReadOnly_Thor_2276:988906592276 \
           AIReadOnly_Prod_5857:184181125857; do
    name="${p%%:*}"; acct="${p##*:}"
    printf '%s\n' \
      "[profile $name]" \
      'sso_session = Hudl' \
      "sso_account_id = $acct" \
      "sso_role_name = $name" \
      'region = us-east-1' \
      'output = json' \
      ''
  done
} > "$HOME/.aws/config"
chmod 600 "$HOME/.aws/config"

# --- 3. aws-sso-login helper -------------------------------------------------
{
  printf '%s\n' '#!/usr/bin/env bash' 'set -eu'
  printf '%s\n' "DEFAULT_PROFILE='$DEFAULT_PROFILE'"
  printf '%s\n' \
    'profile="${1:-${AWS_PROFILE:-$DEFAULT_PROFILE}}"' \
    'export PATH="$HOME/.local/bin:$PATH"' \
    '[ -f /root/.ccr/ca-bundle.crt ] && export AWS_CA_BUNDLE="${AWS_CA_BUNDLE:-/root/.ccr/ca-bundle.crt}"' \
    'if aws sts get-caller-identity --profile "$profile" >/dev/null 2>&1; then' \
    '  echo "Already authenticated as profile $profile:"' \
    '  aws sts get-caller-identity --profile "$profile"' \
    '  exit 0' \
    'fi' \
    'echo "Starting AWS SSO device-code login for profile: $profile"' \
    'echo "Open the URL below in YOUR browser and enter the code if prompted."' \
    'echo "[AGENT: as soon as the URL appears, paste the full https://...user_code=... URL verbatim to the user, then wait for approval.]"' \
    'aws sso login --profile "$profile" --use-device-code --no-browser' \
    'aws sts get-caller-identity --profile "$profile"' \
    'echo "Use it with: export AWS_PROFILE=$profile  (or --profile $profile)"'
} > "$BIN_DIR/aws-sso-login"
chmod +x "$BIN_DIR/aws-sso-login"

# --- 4. PATH + defaults for future shells -----------------------------------
if ! grep -qF 'aws-sso (claude cloud)' "$HOME/.bashrc" 2>/dev/null; then
  printf '%s\n' \
    '# aws-sso (claude cloud)' \
    'export PATH="$HOME/.local/bin:$PATH"' \
    "export AWS_PROFILE=\"\${AWS_PROFILE:-$DEFAULT_PROFILE}\"" \
    '[ -f /root/.ccr/ca-bundle.crt ] && export AWS_CA_BUNDLE="${AWS_CA_BUNDLE:-/root/.ccr/ca-bundle.crt}"' \
    >> "$HOME/.bashrc"
fi

# --- 5. Standing instructions for the agent (user-level CLAUDE.md) ----------
mkdir -p "$HOME/.claude"
if ! grep -qF 'aws-sso (claude cloud)' "$HOME/.claude/CLAUDE.md" 2>/dev/null; then
  printf '%s\n' \
    '' \
    '<!-- aws-sso (claude cloud) -->' \
    '## AWS access' \
    'When asked to sign in to AWS, or when an aws command fails with an expired/missing SSO token, run `aws-sso-login [profile]` (default profile: '"$DEFAULT_PROFILE"').' \
    'Run it so its output is visible to you (not silently in the background), and IMMEDIATELY send the user the full verification URL it prints, including the user_code, as a clickable link plus the code in plain text. Never just mention the code: the user should not have to ask for the URL.' \
    'Then wait for the user to confirm approval before running any further aws commands. Only use AIReadOnly profiles; never attempt write operations.' \
    >> "$HOME/.claude/CLAUDE.md"
fi

echo "AWS SSO setup done. Run: aws-sso-login [profile]  (default: $DEFAULT_PROFILE)"
