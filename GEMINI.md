# Symbiont Governance Context

This environment uses the Symbiont trust stack for AI agent governance.

## Key Concepts

- **ORGA Loop**: Observe -> Reason -> Gate -> Act. The Gate phase operates outside LLM influence and cannot be bypassed. Phase transitions are enforced at compile time via Rust's type system.
- **Cedar Policies**: Authorization rules controlling what agents and tools can do. Files use `.cedar` extension. Evaluation at <1ms.
- **SchemaPin**: Cryptographic verification of MCP tool schemas (ECDSA P-256). Ensures tools haven't been tampered with. Uses Trust-On-First-Use (TOFU) key pinning.
- **AgentPin**: Domain-anchored cryptographic identity for AI agents (ES256 JWT, 12-step verification).
- **DSL**: Symbiont's domain-specific language for defining agents declaratively. Files use `.dsl` extension.

## Available MCP Tools (via symbi server)

- `invoke_agent` -- Run a Symbiont agent with a prompt (params: agent, prompt, system_prompt?)
- `list_agents` -- List available agents from .dsl files in agents/ directory
- `parse_dsl` -- Parse and validate DSL files (params: file? or content?)
- `get_agent_dsl` -- Read an agent's DSL definition (params: agent)
- `get_agents_md` -- Get the project's AGENTS.md content
- `verify_schema` -- Verify a tool schema with SchemaPin (params: schema, public_key_url)

## File Conventions

- Agent definitions: `agents/*.dsl`
- Cedar policies: `policies/*.cedar`
- Symbiont config: `symbiont.toml`
- Agent manifests: `AGENTS.md`

## Dual-Mode Operation

The extension operates in two modes, detected automatically via environment variables:

### Mode A -- Standalone (extension-first)
Developer installs the extension directly. Gemini CLI loads hooks/MCP/skills.
The extension spawns its own `symbi mcp` server. Policy enforcement is advisory
plus Gemini CLI's native policy engine.

### Mode B -- ORGA-managed (runtime-first)
Symbiont's CliExecutor spawns Gemini CLI as a governed subprocess.
The extension detects `SYMBIONT_MANAGED=true` and defers to the outer
ORGA Gate for hard enforcement. The inner extension provides awareness.

### Environment Variables (Mode B)
- `SYMBIONT_MANAGED=true` -- Signals managed mode
- `SYMBIONT_MCP_URL` -- Parent runtime's MCP endpoint
- `SYMBIONT_RUNTIME_SOCKET` -- Unix socket for runtime communication
- `SYMBIONT_SESSION_ID` -- Audit log correlation ID
- `SYMBIONT_BUDGET_TOKENS` -- Token budget for execution
- `SYMBIONT_BUDGET_TIMEOUT` -- Timeout for execution

## On Session Start
When a session begins, run `scripts/install-check.sh` to verify that `symbi` and `jq` are available. Report any missing dependencies to the user.

## Governance Behavior

Before executing tools that modify external state (file writes, shell commands, API calls, deployments), check if a Cedar policy in `policies/` applies. Use the symbi MCP server's `verify_schema` to validate tool schemas before first use. Important actions are logged to `.symbiont/audit/` for compliance.

## Implementation Plan
See `ROADMAP.md` for the full implementation plan and phase details.
