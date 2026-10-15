use std::fs;
use zed_extension_api::{
    self as zed, LanguageServerId, Result, process::Command, settings::LspSettings,
};

struct InkLanguageServerBinary {
    path: String,
    args: Option<Vec<String>>,
}

struct InkExtension {
    downloaded_binary_path: Option<String>,
}

fn usage_supports_lsp(stdout: &[u8], stderr: &[u8]) -> bool {
    [stdout, stderr].iter().any(|output| {
        String::from_utf8_lossy(output)
            .lines()
            .any(|line| line.trim_start().starts_with("-l:"))
    })
}

impl InkExtension {
    fn test_lsp_support(&self, worktree: &zed::Worktree) -> bool {
        // With no arguments inklecate prints usage and exits with code 1.
        // Use the manifest-approved name, resolved with the worktree's PATH.
        match Command::new("inklecate")
            .envs(worktree.shell_env())
            .output()
        {
            Ok(output) => usage_supports_lsp(&output.stdout, &output.stderr),
            Err(_) => false,
        }
    }

    fn language_server_binary(
        &mut self,
        language_server_id: &LanguageServerId,
        worktree: &zed::Worktree,
    ) -> Result<InkLanguageServerBinary> {
        let binary_settings = LspSettings::for_worktree("ink-lsp", worktree)
            .ok()
            .and_then(|lsp_settings| lsp_settings.binary);
        let binary_args = binary_settings
            .as_ref()
            .and_then(|binary_settings| binary_settings.arguments.clone());

        // 1. Check user-configured binary (highest priority)
        if let Some(path) = binary_settings.and_then(|binary_settings| binary_settings.path) {
            return Ok(InkLanguageServerBinary {
                path,
                args: binary_args,
            });
        }

        // Recheck the system binary on each launch, even if a download is cached.
        if let Some(path) = worktree.which("inklecate") {
            if self.test_lsp_support(worktree) {
                return Ok(InkLanguageServerBinary {
                    path,
                    args: binary_args,
                });
            }
        }

        // Only extension-managed downloads are cached.
        if let Some(path) = &self.downloaded_binary_path {
            if fs::metadata(path).is_ok_and(|stat| stat.is_file()) {
                return Ok(InkLanguageServerBinary {
                    path: path.clone(),
                    args: binary_args,
                });
            }
            self.downloaded_binary_path = None;
        }

        zed::set_language_server_installation_status(
            language_server_id,
            &zed::LanguageServerInstallationStatus::CheckingForUpdate,
        );

        let release = zed::latest_github_release(
            "yuna0x0/ink-lsp",
            zed::GithubReleaseOptions {
                require_assets: true,
                pre_release: false,
            },
        )?;

        let (platform, arch) = zed::current_platform();
        let platform_name = match platform {
            zed::Os::Mac => "osx",
            zed::Os::Linux => "linux",
            zed::Os::Windows => "win",
        };
        let arch_name = match arch {
            zed::Architecture::Aarch64 => "arm64",
            zed::Architecture::X86 => "x86",
            zed::Architecture::X8664 => "x64",
        };

        let asset_name = format!("inklecate-{}-{}.zip", platform_name, arch_name);

        let asset = release
            .assets
            .iter()
            .find(|asset| asset.name == asset_name)
            .ok_or_else(|| {
                format!(
                    "No LSP-capable inklecate found for platform {}-{}. Available assets: {:?}",
                    platform_name,
                    arch_name,
                    release.assets.iter().map(|a| &a.name).collect::<Vec<_>>()
                )
            })?;

        let version_dir = format!("inklecate-{}", release.version);
        let binary_name = match platform {
            zed::Os::Windows => "inklecate.exe",
            _ => "inklecate",
        };
        let binary_path = format!("{}/{}", version_dir, binary_name);

        if !fs::metadata(&binary_path).is_ok_and(|stat| stat.is_file()) {
            zed::set_language_server_installation_status(
                language_server_id,
                &zed::LanguageServerInstallationStatus::Downloading,
            );

            zed::download_file(
                &asset.download_url,
                &version_dir,
                zed::DownloadedFileType::Zip,
            )
            .map_err(|e| format!("Failed to download LSP-capable inklecate: {}", e))?;

            // Validate the new binary before removing older downloads.
            zed::make_file_executable(&binary_path)?;

            // Clean up old versions
            let entries = fs::read_dir(".")
                .map_err(|e| format!("Failed to list working directory: {}", e))?;
            for entry in entries {
                let entry = entry.map_err(|e| format!("Failed to load directory entry: {}", e))?;
                let name = entry.file_name();
                let name_str = name.to_str().unwrap_or("");
                if name_str.starts_with("inklecate-") && name_str != version_dir {
                    fs::remove_dir_all(entry.path()).ok();
                }
            }
        }

        // Cache only the downloaded binary path.
        self.downloaded_binary_path = Some(binary_path.clone());

        Ok(InkLanguageServerBinary {
            path: binary_path,
            args: binary_args,
        })
    }
}

impl zed::Extension for InkExtension {
    fn new() -> Self {
        Self {
            downloaded_binary_path: None,
        }
    }

    fn language_server_command(
        &mut self,
        language_server_id: &zed::LanguageServerId,
        worktree: &zed::Worktree,
    ) -> Result<zed::Command> {
        let inklecate_binary = self.language_server_binary(language_server_id, worktree)?;

        let args = inklecate_binary.args.unwrap_or_else(|| vec!["-l".into()]);

        Ok(zed::Command {
            command: inklecate_binary.path,
            args,
            env: Default::default(),
        })
    }
}

zed::register_extension!(InkExtension);

#[cfg(test)]
mod tests {
    use super::usage_supports_lsp;

    const LSP_USAGE: &[u8] = b"Usage: inklecate2 <options> <ink file>\n   -p:              Play mode\n   -l:              Launch the language server (ignores other options).\n";

    #[test]
    fn recognizes_upstream_lsp_usage_on_stdout_or_stderr() {
        assert!(usage_supports_lsp(LSP_USAGE, b""));
        assert!(usage_supports_lsp(b"", LSP_USAGE));
    }

    #[test]
    fn rejects_standard_compiler_usage() {
        assert!(!usage_supports_lsp(
            b"Usage: inklecate <options> <ink file>\n   -p: Play mode\n   -k: Keep running\n",
            b"",
        ));
    }

    #[test]
    fn rejects_incidental_lsp_mentions_and_other_flags() {
        for output in [
            "LSP is not supported by this compiler",
            "No language server available",
            "   --language-server: unsupported",
            "   -log: Write logs",
            "Failed to load -l: option",
            "",
        ] {
            assert!(!usage_supports_lsp(output.as_bytes(), b""), "{output}");
        }
    }
}
