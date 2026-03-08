metadata {
    version = "1.0.0"
    description = "Code reviewer that runs Gemini CLI inside ORGA governance"
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
