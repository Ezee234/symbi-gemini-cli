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
