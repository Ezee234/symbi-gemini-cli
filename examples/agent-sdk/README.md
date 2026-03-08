# Headless Agent Example

Use Gemini CLI programmatically from within Symbiont's runtime.
This pattern is for building headless agents that run without interactive sessions.

## Pattern

```rust
use symbi_runtime::orchestrator::Orchestrator;
use symbi_runtime::security::SecurityTier;

async fn run_governed_agent(task: &str) -> Result<String> {
    let orchestrator = Orchestrator::new().await?;

    let result = orchestrator.execute_code(
        SecurityTier::Tier1,
        &format!(
            "gemini --prompt '{}'",
            task
        ),
        vec![
            ("SYMBIONT_MANAGED", "true"),
            ("SYMBIONT_MCP_URL", &orchestrator.mcp_url()),
            ("SYMBIONT_SESSION_ID", &uuid::Uuid::new_v4().to_string()),
        ],
    ).await?;

    Ok(result.stdout)
}
```

## DSL Definition

```symbiont
metadata {
    version = "1.0.0"
    description = "Headless agent using Gemini CLI via CliExecutor"
}

agent feature_builder(input: FeatureSpec) -> Implementation {
    capabilities = ["read", "write", "analyze", "test"]

    executor {
        type = "gemini_cli"
        allowed_tools = ["read_file", "write_file", "run_shell_command", "glob", "search_file_content", "symbi__*"]
        extension = "symbi"
        model = "gemini-2.5-pro"
    }

    policy build_policy {
        allow: read(any) if true
        allow: write(source_code) if input.approved
        deny: write(config) if not input.is_admin
        audit: all_operations
    }

    with sandbox = "tier1", timeout = "60m", budget_tokens = 100000 {
        implementation = build(input)
        return implementation
    }
}
```

## When to Use This Pattern

- Automated CI/CD pipelines that need governed code generation
- Batch processing of development tasks
- Dark factory deployments where agents run without human interaction
- Any scenario requiring programmatic ORGA governance over Gemini CLI
