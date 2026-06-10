# Starship config

Config: `.config/starship.toml` (stowed to `~/.config/starship.toml`).

## gcloud module — show only with an active account

By default Starship's `gcloud` module renders its cloud icon whenever a gcloud
account *or* project is set in the active configuration. To keep the prompt
clean when not using GCP, the module is configured to render the whole block
(icon, `on`, account, region) only when an **account** is present:

```toml
[gcloud]
format = '[(on $symbol$account(@$domain)(\($region\)) )]($style)'
```

The `()` group collapses to nothing when `$account` is empty, so no icon shows.

The global `default` gcloud configuration is kept empty (no account/project) so
the prompt stays clean in normal shells.

## Activate a GCP account for one session only

A named configuration `session-work` holds the account + project. It is **not**
the active config globally — activate it per-shell via env var so it never
leaks into other terminals or persists:

```fish
# turn on for this shell
set -x CLOUDSDK_ACTIVE_CONFIG_NAME session-work

# turn off mid-session
set -e CLOUDSDK_ACTIVE_CONFIG_NAME
```

Starship respects `CLOUDSDK_ACTIVE_CONFIG_NAME`, so the icon + account appear
only while the var is set, and `gcloud` CLI uses that config too. A new shell
starts clean.

Inspect / recreate the named config:

```fish
gcloud config configurations list
gcloud config configurations create session-work --no-activate
gcloud config configurations activate session-work
gcloud config set account <you@example.com>
gcloud config set project <project-id>
gcloud config configurations activate default   # leave default empty/active
```
