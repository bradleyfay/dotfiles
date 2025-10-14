# Security & Secret Protection

This dotfiles repository has **multiple layers of protection** to prevent accidentally committing secrets to the public repository.

## 🛡️ Layer 1: Automatic Encryption (.chezmoiattributes)

Files matching certain patterns are **automatically encrypted** when added to chezmoi:

```bash
# Example: This will automatically encrypt because of the pattern match
chezmoi add ~/.ssh/id_ed25519
# Result: encrypted_private_dot_ssh/private_id_ed25519.age

# No --encrypt flag needed! The .chezmoiattributes rules handle it
```

**Patterns that auto-encrypt:**
- SSH keys: `id_*`, `*_rsa`, `*_ed25519`, `config`
- AWS credentials: `.aws/credentials`, `.aws/config`
- Secrets files: `*secret*`, `*credential*`, `secrets.zsh`
- Key files: `*.key`, `*.pem`, `*token*`, `*apikey*`
- GPG keys: `.gnupg/**`

See [`.chezmoiattributes`](.chezmoiattributes) for the complete list.

## 🛡️ Layer 2: Git Ignore (.gitignore)

The `.gitignore` file **prevents unencrypted secret files from being staged**:

```bash
# These files will never be added to git
.env
.env.local
*.key
*.pem
id_rsa
id_ed25519
credentials
*secret*
*token*
```

**Important:** Encrypted files (`.age` suffix) are explicitly allowed:
```gitignore
!**/*.age  # Encrypted files are safe
!*.pub     # Public keys are safe
```

## 🛡️ Layer 3: Pre-Commit Hooks

Pre-commit hooks **scan for secrets before commits** and block them:

### Hook 1: detect-secrets
Scans all files for secret patterns (API keys, tokens, passwords):
```bash
# Automatically runs on every commit
# Will fail if secrets are detected
```

### Hook 2: detect-private-key
Checks for SSH/GPG private keys:
```bash
# Blocks commits containing private keys
# Excludes .age files (encrypted)
```

### Hook 3: check-encryption
Ensures files that should be encrypted are encrypted:
```bash
# Fails if you try to commit:
# - id_rsa, id_ed25519 without .age suffix
# - credentials, secret, .key, .pem files without .age suffix
```

## 🛡️ Layer 4: .chezmoiignore

Prevents certain files from being applied (additional safety):
```bash
# Never apply these to home directory
.env
.env.local
**/secrets/**
*.key (unless .age)
```

## How It Works Together

### Adding a Secret File

```bash
# 1. Try to add SSH key
chezmoi add ~/.ssh/id_ed25519

# 2. .chezmoiattributes sees "id_ed25519" pattern
#    → Automatically adds as encrypted

# 3. File becomes: encrypted_private_dot_ssh/private_id_ed25519.age
#    → Safe to commit!

# 4. When committing:
#    → .gitignore allows *.age files
#    → detect-secrets scans and approves (encrypted)
#    → check-encryption verifies .age suffix exists
#    → Commit succeeds ✅
```

### Accidentally Adding Unencrypted Secret

```bash
# 1. You forget to encrypt
echo "export API_KEY=secret" > ~/.zshrc

# 2. Try to add it
chezmoi add ~/.zshrc

# 3. .chezmoiattributes doesn't match pattern
#    → Added as plaintext (uh oh!)

# 4. Try to commit
git add .
git commit -m "Update zshrc"

# 5. Pre-commit hooks run:
#    → detect-secrets FINDS secret pattern
#    → Commit BLOCKED ❌
#
#    ERROR: Secret found in file!
#    Remove the secret or add it to .secrets.baseline
```

### The Right Way

```bash
# 1. Create a secrets-specific file
chezmoi edit ~/.config/zsh/env/secrets.zsh

# 2. Add your secret
export API_KEY="secret"

# 3. The filename matches "*secrets*" pattern
#    → Auto-encrypted by .chezmoiattributes ✅

# 4. File becomes: encrypted_private_dot_config_private_zsh_private_env_private_secrets.zsh.age

# 5. Commit succeeds - it's encrypted! ✅
```

## Testing the Protection

### Test 1: Try to commit a secret file

```bash
# Create unencrypted secret
echo "GITHUB_TOKEN=ghp_secret123" > test_secret.txt
git add test_secret.txt
git commit -m "test"

# Result: ❌ Blocked by detect-secrets
```

### Test 2: Try to add unencrypted SSH key

```bash
# Create fake SSH key
ssh-keygen -t ed25519 -f /tmp/test_key -N ""
chezmoi add /tmp/test_key

# If it doesn't auto-encrypt (outside home):
cd ~/.local/share/chezmoi
git add .
git commit -m "test"

# Result: ❌ Blocked by check-encryption hook
```

### Test 3: Encrypted file should work

```bash
# Add with encryption
chezmoi add --encrypt ~/secret.txt

# Commit
cd ~/.local/share/chezmoi
git add .
git commit -m "Add encrypted secret"

# Result: ✅ Success - .age suffix is allowed
```

## Bypassing Protection (When Needed)

### Updating .secrets.baseline

If you have a **false positive** (not actually a secret):

```bash
# 1. Add to baseline
cd ~/.local/share/chezmoi
detect-secrets scan --baseline .secrets.baseline

# 2. Commit the updated baseline
git add .secrets.baseline
git commit -m "Update secrets baseline"
```

### Temporary Bypass (NOT RECOMMENDED)

```bash
# Skip pre-commit hooks (DANGEROUS!)
git commit --no-verify -m "message"

# Only use for:
# - Updating the hooks themselves
# - Emergency situations
# - You know what you're doing
```

## Best Practices

### ✅ DO:
1. **Use secrets.zsh** for environment variables with secrets
2. **Let chezmoi auto-encrypt** - use pattern-matching filenames
3. **Test locally** before pushing to GitHub
4. **Backup your age key** (`~/.config/age/key.txt`)
5. **Review what's staged** before committing:
   ```bash
   git diff --staged
   ```

### ❌ DON'T:
1. **Don't add secrets to regular config files** (use secrets.zsh instead)
2. **Don't use `--no-verify`** unless absolutely necessary
3. **Don't commit `.env` files** with secrets
4. **Don't share your age key** publicly
5. **Don't push unencrypted secrets** even in a branch

## Checking Current Protection Status

```bash
# Check .chezmoiattributes patterns
cat ~/.local/share/chezmoi/.chezmoiattributes

# Check .gitignore rules
cat ~/.local/share/chezmoi/.gitignore

# Check pre-commit hooks status
cd ~/.local/share/chezmoi
pre-commit run --all-files

# Test encryption on a file
chezmoi add --dry-run --verbose ~/.ssh/id_ed25519
```

## What Happens on New Machine

When you run `chezmoi init` on a new machine:

1. **age key required** - You'll need your age key to decrypt
2. **Secrets decrypt** - Encrypted files become readable
3. **Pre-commit installs** - Protection is ready immediately
4. **Patterns active** - .chezmoiattributes rules apply

```bash
# Setup on new machine
chezmoi init git@github.com:bradleyfay/dotfiles.git

# Restore age key first!
mkdir -p ~/.config/age
# Copy key from password manager to ~/.config/age/key.txt

# Apply dotfiles (will decrypt secrets)
chezmoi apply
```

## Emergency: Secret Accidentally Committed

If a secret makes it into git history:

### 1. Remove from current commit (not yet pushed)
```bash
git reset HEAD~1
# Remove the secret, re-encrypt, commit again
```

### 2. Remove from git history (already pushed)
```bash
# Use git-filter-repo or BFG Repo-Cleaner
# See: https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/removing-sensitive-data-from-a-repository

# Then: Rotate the exposed secret immediately!
```

### 3. Rotate the exposed secret
- Change API keys
- Regenerate tokens
- Update passwords
- Revoke compromised credentials

## Summary

**4 Layers of Protection:**

1. **Auto-encryption** - Pattern matching in .chezmoiattributes
2. **Git ignore** - Blocks unencrypted secrets from staging
3. **Pre-commit hooks** - Scans and blocks secrets before commit
4. **Chezmoi ignore** - Additional safety for applying files

**Multiple checks at different stages = Hard to accidentally leak secrets!**

Need help? See [SECRETS.md](SECRETS.md) for encryption documentation.
