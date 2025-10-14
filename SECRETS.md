# Secrets Management Strategy

## Quick Start

**Your age encryption is already set up!** 🔐

Your age key location: `~/.config/age/key.txt`
Your public key: `age1y52gpr594kvcs7864pr9vjus9c8acxemzdrc6tg5kjucryf04fusq6mavu`

### Adding Encrypted Secrets

```bash
# 1. Edit the secrets file (auto-encrypted on save)
chezmoi edit ~/.config/zsh/env/secrets.zsh

# 2. Add your secrets (uncomment and fill in the examples)
export OPENAI_API_KEY="sk-..."
export GITHUB_TOKEN="ghp_..."

# 3. Apply changes (file will be encrypted)
chezmoi apply

# 4. Verify it's encrypted in the repo
cat ~/.local/share/chezmoi/encrypted_dot_config_private_zsh_private_env_private_secrets.zsh.age
# Should show: -----BEGIN AGE ENCRYPTED FILE-----
```

**⚠️ IMPORTANT:** Backup your age key (`~/.config/age/key.txt`) to a password manager or secure location!

## Overview

This dotfiles setup uses **chezmoi + age encryption** for managing secrets like SSH keys, API keys, and sensitive configuration files across machines.

## Why age?

- **Simple**: Single command to encrypt/decrypt
- **Modern**: Built specifically for file encryption (unlike GPG)
- **Secure**: Uses modern cryptography (X25519, ChaCha20-Poly1305)
- **Built-in**: Chezmoi has native age support
- **No key servers**: Keys are just files you manage

## Setup (One-Time)

### 1. Install age

```bash
brew install age
```

### 2. Generate your age key

```bash
# Generate a new age key
age-keygen -o ~/.config/age/key.txt

# Your public key will be displayed - save it!
# Public key: age1xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

### 3. Configure chezmoi to use age

```bash
chezmoi cd
cat >> .chezmoi.toml.tmpl << 'EOF'

[encryption]
    command = "age"
    args = ["--decrypt", "--identity", "~/.config/age/key.txt"]
    suffix = ".age"
EOF
```

### 4. Tell chezmoi your public key

```bash
# Edit your chezmoi config
chezmoi edit-config

# Add this:
[age]
    identity = "~/.config/age/key.txt"
    recipient = "age1xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"  # YOUR public key
```

## Usage

### Encrypting Files

#### SSH Private Keys

```bash
# Add an encrypted SSH key
chezmoi add --encrypt ~/.ssh/id_rsa
chezmoi add --encrypt ~/.ssh/id_ed25519

# The files become:
# - private_dot_ssh/private_id_rsa.age (in chezmoi)
# - ~/.ssh/id_rsa (decrypted on your machine)
```

#### Environment Files with Secrets

```bash
# Create a secrets file
chezmoi add --encrypt --template ~/.config/zsh/env/secrets.zsh

# Edit it with chezmoi (auto-encrypts on save)
chezmoi edit ~/.config/zsh/env/secrets.zsh

# Add your secrets:
export OPENAI_API_KEY="sk-..."
export AWS_ACCESS_KEY_ID="AKIA..."
export AWS_SECRET_ACCESS_KEY="..."
export GITHUB_TOKEN="ghp_..."
```

#### Config Files with Mixed Content

Use templates to inject secrets:

```bash
# Example: ~/.gitconfig with email/token
chezmoi edit ~/.config/git/config.tmpl

# Use chezmoi data for secrets:
[user]
    name = {{ .name }}
    email = {{ .email }}
[github]
    token = {{ .github_token }}
```

Store the secret data in chezmoi's data:

```bash
chezmoi data set github_token ghp_xxxxxxxxxxxx
```

### Decrypting on New Machine

```bash
# 1. Clone your dotfiles
chezmoi init --apply git@github.com:yourusername/dotfiles.git

# 2. You'll be prompted for your age key
# Copy ~/.config/age/key.txt from your old machine

# 3. Re-apply to decrypt secrets
chezmoi apply
```

## What to Encrypt

### ✅ Always Encrypt

- SSH private keys (`~/.ssh/id_*` without `.pub`)
- API keys and tokens
- AWS credentials
- Private certificates
- GPG private keys
- `.env` files with secrets
- Database passwords
- OAuth tokens

### ⚠️ Consider Encrypting

- Email addresses (if privacy-sensitive)
- Personal information
- Custom domains
- Internal URLs

### ❌ Don't Encrypt

- SSH public keys (`~/.ssh/*.pub`)
- Public configuration files
- Shell aliases
- Prompt configurations
- Color schemes

## Alternative: Template-Based Secrets

For values that differ per machine but aren't super sensitive:

```bash
# .chezmoi.toml.tmpl
{{- $email := "" -}}
{{- if stdinIsATTY -}}
{{-   $email = promptString "email" -}}
{{- end -}}

[data]
    email = {{ $email | quote }}
```

Then use in templates:

```toml
# ~/.gitconfig.tmpl
[user]
    email = {{ .email }}
```

## Integration with Password Managers

### 1Password (Recommended)

```bash
# Install 1Password CLI
brew install --cask 1password-cli

# Configure chezmoi
chezmoi edit-config

# Add:
[onepassword]
    command = "op"

# Use in templates:
{{ (onepasswordRead "op://Private/API Keys/OpenAI").value }}
```

### Bitwarden

```bash
brew install bitwarden-cli

# In templates:
{{ (bitwardenFields "item-name").api_key.value }}
```

## Security Best Practices

### 1. **Never commit unencrypted secrets**

Add to `.chezmoiignore` if needed:

```
.env
.env.local
**/secrets/**
```

### 2. **Backup your age key**

```bash
# Store in multiple secure locations:
# - Password manager (1Password, Bitwarden)
# - Encrypted USB drive
# - Paper backup (QR code)

# Generate QR code for backup:
cat ~/.config/age/key.txt | qrencode -o ~/age-key-backup.png
```

### 3. **Rotate keys periodically**

```bash
# Generate new key
age-keygen -o ~/.config/age/key-new.txt

# Re-encrypt all secrets with new key
# Update recipient in chezmoi config
# Delete old key
```

### 4. **Use different keys for work vs personal**

```toml
# .chezmoi.toml.tmpl
{{- if eq .machine_type "work" }}
[age]
    identity = "~/.config/age/key-work.txt"
    recipient = "age1work..."
{{- else }}
[age]
    identity = "~/.config/age/key-personal.txt"
    recipient = "age1personal..."
{{- end }}
```

## Common Patterns

### Pattern 1: Encrypted Env File

```bash
# ~/.config/zsh/env/secrets.zsh.age
export OPENAI_API_KEY="sk-..."
export ANTHROPIC_API_KEY="sk-ant-..."
export GITHUB_TOKEN="ghp_..."

# Source in .zshrc.local (not tracked):
if [ -f ~/.config/zsh/env/secrets.zsh ]; then
    source ~/.config/zsh/env/secrets.zsh
fi
```

### Pattern 2: Template with Secrets

```bash
# ~/.aws/credentials.tmpl
[default]
aws_access_key_id = {{ (index (onepasswordDocument "AWS Credentials") "access_key") }}
aws_secret_access_key = {{ (index (onepasswordDocument "AWS Credentials") "secret_key") }}
```

### Pattern 3: Encrypted Directory

```bash
# Encrypt entire .ssh directory
chezmoi add --encrypt --recursive ~/.ssh/

# Results in:
# private_dot_ssh/
#   private_id_ed25519.age
#   private_id_rsa.age
#   private_config.age
#   id_ed25519.pub  # Public keys not encrypted
```

## Testing Your Setup

```bash
# 1. Check encryption is working
chezmoi diff

# 2. Verify files are encrypted in repo
cd $(chezmoi source-path)
file private_dot_ssh/private_id_rsa.age
# Should show: ASCII text (age encrypted data)

# 3. Test decryption
chezmoi apply --dry-run --verbose

# 4. Verify secrets aren't in git
cd $(chezmoi source-path)
git log -p | grep -i "secret\|password\|key"
# Should find nothing sensitive
```

## Troubleshooting

### "age: error: decryption failed"

- Wrong identity file
- Age key not found
- File corrupted

**Fix:**
```bash
# Check key location
ls -la ~/.config/age/key.txt

# Verify it's a valid age key
head -1 ~/.config/age/key.txt
# Should start with: # created: ...
```

### "multiple identities match"

You have multiple age keys.

**Fix:**
```bash
# Specify which identity in chezmoi config
[age]
    identity = "~/.config/age/key-personal.txt"
```

### Forgot to encrypt a secret

```bash
# Remove from git history (if committed)
git filter-branch --force --index-filter \
  "git rm --cached --ignore-unmatch path/to/secret" \
  --prune-empty --tag-name-filter cat -- --all

# Then re-add with encryption
chezmoi forget path/to/file
chezmoi add --encrypt path/to/file
```

## Migration Guide

### From plaintext to encrypted:

```bash
# 1. Forget the file
chezmoi forget ~/.ssh/id_rsa

# 2. Re-add with encryption
chezmoi add --encrypt ~/.ssh/id_rsa

# 3. Verify
cd $(chezmoi source-path)
ls -la private_dot_ssh/
```

### From GPG to age:

```bash
# 1. Decrypt with GPG
gpg -d secret.gpg > secret.txt

# 2. Re-add with age
chezmoi add --encrypt secret.txt

# 3. Update .chezmoiignore to exclude *.gpg
```

## Resources

- [age Documentation](https://github.com/FiloSottile/age)
- [chezmoi Encryption Guide](https://www.chezmoi.io/user-guide/encryption/)
- [1Password CLI](https://developer.1password.com/docs/cli/)
- [Bitwarden CLI](https://bitwarden.com/help/cli/)

## Quick Reference

```bash
# Encrypt a file
chezmoi add --encrypt FILE

# Edit encrypted file
chezmoi edit FILE

# View decrypted content
chezmoi cat FILE

# Apply with decryption
chezmoi apply

# Verify encryption
cd $(chezmoi source-path) && file *.age
```
