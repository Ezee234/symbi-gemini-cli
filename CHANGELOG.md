# Changelog

## [0.3.0] - 2026-03-08

### Added
- **Three-tier governance model**: Awareness (default), Protection (local deny list), Governance (Cedar)
- `policy-guard.sh` blocking hook -- blocks destructive commands, force pushes, writes to sensitive files
- `.symbiont/local-policy.toml` deny list support -- developer-configurable path, command, and branch blocking
- Cedar policy evaluation in hooks when `symbi` is on PATH
- `excludeTools` in manifest for zero-config destructive command blocking
- Native `policies/symbi-guard.toml` for Gemini CLI platform-level enforcement
- Defense-in-depth: three independent enforcement layers (manifest, native policies, hooks)

### Changed
- Hooks now run `policy-guard.sh` (blocking) before `policy-log.sh` (advisory)
- Updated GEMINI.md and README.md to document governance tiers

## [0.2.0] - 2026-03-07

### Added

- Extension manifest (`gemini-extension.json`) with inline MCP server config
- `GEMINI.md` context file with dual-mode documentation
- Skills:
  - `/symbi-init` -- scaffold a governed agent project
  - `/symbi-policy` -- create/edit Cedar authorization policies
  - `/symbi-verify` -- SchemaPin MCP tool verification
  - `/symbi-audit` -- query cryptographic audit logs
  - `/symbi-dsl` -- parse/validate DSL agent definitions
  - `/symbi-agent-sdk` -- Gemini CLI + ORGA governance boilerplate
- Commands (TOML format):
  - `/symbi:status` -- runtime health check
  - `/symbi:init` -- quick project scaffold
  - `/symbi:verify` -- verify MCP tools
- Hooks:
  - `policy-log.sh` -- PreToolUse advisory policy logging (dual-mode aware)
  - `audit-log.sh` -- PostToolUse audit logging (dual-mode aware)
  - `install-check.sh` -- symbi binary verification (dual-mode aware)
  - `mcp-wrapper.sh` -- MCP transport switching (stdio/HTTP)
- Native Gemini CLI policies:
  - `symbi-governance.toml` -- MCP tool and shell command warnings
  - `tool-safety.toml` -- dangerous pattern blocking (rm -rf, force push)
- Agents (preview):
  - `symbi-governor` -- governance-aware coding agent
  - `symbi-dev` -- DSL development specialist
- Dual-mode architecture: Mode A (standalone) and Mode B (ORGA-managed)
- Examples: standalone, cli-executor, agent-sdk
- Documentation: README, ROADMAP, CHANGELOG
- Install script for symbi binary
