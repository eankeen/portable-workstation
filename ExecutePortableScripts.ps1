# LOAD HELPER FUNCTIONS
Write-Host "Load helper functions" -BackgroundColor White -ForegroundColor Black
. ./util/PrintToConsole.ps1
. ./util/WriteToConfig.ps1
. ./util/General.ps1

# GENERATE CONFIG FILE
print_title "Create basic config"

. ./GenerateConfig.ps1
# Set-Variable -Name "vars" -Value $(global_vars) -Scope Private
# Set-Variable -Name "config" -Value $(gen_config_obj) -Scope Private

print_error "json" $(generate_config | ConvertTo-Json -Depth 8)
exit_program

# CHECK PATHS EXIST (move to Explicitize-Config.ps1)
. ./ValidatePaths.ps1
. ./GenerateVars
print_title "Check file paths exist"
check_paths_in_config_exist $vars $config
. "$($config.relPathsTo.sourceToAccessHooks)"

# ATTACH VARIABLES TO $VAR (RENAME THIS)
print_title "Create variables"
create_folder_variables $vars $config
create_config_file_variables $vars $config
attempt_to_run_hook "after_create_variables `$config `$var"

# DOWNLOAD BINARIES
# print_title "Create binaries"
# . ./DownloadBinaries.ps1
# attempt_run "after_download_binaries `$config `$var"

# CREATE CMDER CONFIG FILES
print_title "Create Cmder config files"
. ./CreateCmderConfig.ps1
$willWriteCmderConfig = ask_to_create_cmder_config $vars $config
if($willWriteCmderConfig) {
  cmder_config_write $vars $config
}
attempt_to_run_hook "after_create_cmder_files `$config `$var"

# CREATE SHORTCUTS
print_title "Create shortcuts"
. ./CreateShortcuts.ps1
create_shortcuts $vars $config
attempt_to_run_hook "after_create_shortcuts `$config `$var"

# LAUNCH APPLICATIONS
print_title "Launch applications"
. ./LaunchApplications
prompt_to_launch_apps $vars $config
attempt_to_run_hook "after_launch_apps `$config `$var"

exit_program
