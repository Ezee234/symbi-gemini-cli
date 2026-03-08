# CliExecutor-Wrapped Example (Mode B)

Run Gemini CLI inside Symbiont's ORGA governance loop. Symbiont is the security
perimeter; Gemini CLI is the execution engine inside it. The extension becomes the
bridge between the two layers.

## Architecture

```
Symbiont Runtime (ORGA: Observe -> Reason -> Gate -> Act)
  |
  +-> CliExecutor (Docker/gVisor sandbox, resource limits)
        |
        +-> Gemini CLI (with symbi extension loaded)
              |
              +-> Extension hooks detect SYMBIONT_MANAGED=true
              +-> MCP connects back to parent via SYMBIONT_MCP_URL
              +-> Inner extension = awareness layer (not enforcement)
              +-> Outer ORGA Gate = enforcement layer (cannot bypass)
```

## Agent DSL

Define a Gemini CLI agent in Symbiont DSL:

```symbiont
metadata {
    version = "1.0.0"
    description = "Code reviewer that runs inside ORGA governance"
}

agent code_reviewer(input: PullRequest) -> ReviewResult {
    capabilities = ["read", "analyze"]

    executor {
        type = "gemini_cli"
        allowed_tools = ["read_file", "search_file_content", "glob", "symbi__*"]
        extension = "symbi"
        model = "gemini-2.5-pro"
    }

    policy review_policy {
        allow: read(any) if true
        deny: write(any) if not input.is_draft
        audit: all_operations
    }

    with sandbox = "tier1", timeout = "15m" {
        review = analyze(input)
        return review
    }
}
```

## Running

```bash
# Run the agent with a prompt
symbi run code_reviewer --prompt "Review PR #42 for security issues"

# Or via CliExecutor
SYMBIONT_MANAGED=true SYMBIONT_MCP_URL=http://localhost:PORT \
  gemini --prompt "Review PR #42 for security issues"
```

## What You Get (beyond Mode A)

- ORGA Gate enforcement -- compile-time guaranteed, cannot bypass
- Sandbox isolation (Docker/gVisor/Firecracker) around Gemini CLI
- Cryptographic audit trail from Symbiont's journal
- Token/cost/time budget enforcement
- Circuit breakers on tool failures
- Single MCP server instance (extension connects back to parent)
