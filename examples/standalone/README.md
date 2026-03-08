# Standalone Extension Example (Mode A)

Use the symbi extension directly in Gemini CLI without a Symbiont runtime wrapper.
The extension provides governance awareness, Cedar policy checking via hooks,
native Gemini CLI policies, and access to Symbiont MCP tools.

## Setup

1. Install the symbi binary:
   ```bash
   cargo install symbi
   ```

2. Link the extension for development:
   ```bash
   gemini extensions link /path/to/symbi-gemini-cli
   ```

3. Initialize a governed project:
   ```
   /symbi:init
   ```

## What You Get

- Lightweight Cedar policy awareness via PreToolUse hooks
- Native Gemini CLI policy enforcement (blocks dangerous patterns like `rm -rf`)
- SchemaPin verification of MCP tool schemas
- Local audit logging to `.symbiont/audit/`
- Skills for creating agents, policies, and DSL definitions
- MCP tools: invoke_agent, list_agents, parse_dsl, etc.

## Limitations

- Hook-based policy enforcement is advisory (provides feedback, not hard blocks)
- No sandbox isolation around Gemini CLI itself
- Audit logs are local JSONL files, not cryptographic journals
- No token/cost/time budget enforcement

For full enforcement, use Mode B (CliExecutor-wrapped). See `examples/cli-executor/`.
