use std::fs;
use zed_extension_api::{self as zed, LanguageServerId, Result, settings::LspSettings};

struct InkLanguageServerBinary {
    path: String,
    args: Option<Vec<String>>,
}

struct InkExtension {
    cached_binary_path: Option<String>,
}

impl InkExtension {
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

        if let Some(path) = binary_settings.and_then(|binary_settings| binary_settings.path) {
            return Ok(InkLanguageServerBinary {
                path,
                args: binary_args,
            });
        }

        if let Some(path) = worktree.which("inklecate") {
            return Ok(InkLanguageServerBinary {
                path,
                args: binary_args,
            });
        }

        if let Some(path) = &self.cached_binary_path {
            if fs::metadata(path).map_or(false, |stat| stat.is_file()) {
                return Ok(InkLanguageServerBinary {
                    path: path.clone(),
                    args: binary_args,
                });
            }
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
            .ok_or_else(|| format!("no asset found matching {:?}", asset_name))?;

        let version_dir = format!("inklecate-{}", release.version);
        let binary_name = match platform {
            zed::Os::Windows => "inklecate.exe",
            _ => "inklecate",
        };
        let binary_path = format!("{}/{}", version_dir, binary_name);

        if !fs::metadata(&binary_path).map_or(false, |stat| stat.is_file()) {
            zed::set_language_server_installation_status(
                language_server_id,
                &zed::LanguageServerInstallationStatus::Downloading,
            );

            zed::download_file(
                &asset.download_url,
                &version_dir,
                zed::DownloadedFileType::Zip,
            )
            .map_err(|e| format!("failed to download file: {e}"))?;

            let entries =
                fs::read_dir(".").map_err(|e| format!("failed to list working directory {e}"))?;
            for entry in entries {
                let entry = entry.map_err(|e| format!("failed to load directory entry {e}"))?;
                if entry.file_name().to_str() != Some(&version_dir) {
                    fs::remove_dir_all(entry.path()).ok();
                }
            }

            zed::make_file_executable(&binary_path)?;
        }

        self.cached_binary_path = Some(binary_path.clone());
        Ok(InkLanguageServerBinary {
            path: binary_path,
            args: binary_args,
        })
    }
}

impl zed::Extension for InkExtension {
    fn new() -> Self {
        Self {
            cached_binary_path: None,
        }
    }

    fn language_server_command(
        &mut self,
        language_server_id: &zed::LanguageServerId,
        worktree: &zed::Worktree,
    ) -> Result<zed::Command> {
        let inklecate_binary = self.language_server_binary(language_server_id, worktree)?;
        Ok(zed::Command {
            command: inklecate_binary.path,
            args: inklecate_binary.args.unwrap_or_else(|| vec!["-l".into()]),
            env: Default::default(),
        })
    }
}

zed::register_extension!(InkExtension);
