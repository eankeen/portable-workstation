function write_config_comments($json, $var) {
    $msg = "Do not edit this file. This file is auto-generated and replaced by scripts in $(get_directory `"./`")"
    write_comment_line_to_file $var $var.bashConfig "#!/bin/bash/env bash"
    write_comment_line_to_file $var $var.allConfig $msg
    write_line_to_file $var $var.allConfig ""
}

function write_config_variables($json, $var) {

}

function write_config_paths($json, $var) {
    $json.paths | ForEach-Object -Process {
        $relativePathToBin = $_.Name
        $absolutePathToBin = normalize_path $var.binDir $relativePathToBin

        write_path_line_to_file $var $var.bashConfig $absolutePathToBin
        write_path_line_to_file $var $var.psConfig $absolutePathToBin
        write_path_line_to_file $var $var.cmdConfig $absolutePathToBin

        if($json.config.verbose -eq $true) {
            Write-Host "Adding `"$absolutePathToBin`" to PATH for `"$($var.bashConfig)`""
            Write-Host "Adding `"$absolutePathToBin`" to PATH for `"$($var.psConfig)`""
            Write-Host "Adding `"$absolutePathToBin`" to PATH for `"$($var.cmdConfig)`""
        }
        else {
            Write-Host "Adding `"$relativePathToBin`" to PATH for `"$($var.bashConfig)`""
            Write-Host "Adding `"$relativePathToBin`" to PATH for `"$($var.psConfig)`""
            Write-Host "Adding `"$relativePathToBin`" to PATH for `"$($var.cmdConfig)`""
        }
        Write-Host "`r`n"
    }
}

function write_config_aliases($json, $var) {

}

function cmder_config_write($json, $var) {
    write_config_comments $json $var
    write_config_variables $json $var
    write_config_paths $json $var
    write_config_aliases $json $var
}

# Creates / overwrites config files
function create_config_files($json, $var) {
    # Remove config files if they already exist
    if (Test-Path $var.bashConfig -PathType Leaf) {
        Remove-Item -Path $var.bashConfig
    }
    if (Test-Path $var.psConfig -PathType Leaf) {
        Remove-Item -Path $var.psConfig
    }
    if (Test-Path $var.cmdConfig -PathType Leaf) {
        Remove-Item -Path $var.cmdConfig
    }

    # Create new config items (none should exist in dir now)
    New-Item $var.bashConfig | Out-Null
    New-Item $var.psConfig | Out-Null
    New-Item $var.cmdConfig | Out-Null
}
 
function ask_to_create_cmder_config($json, $var) {
    if ((Test-Path -Path $var.cmdConfig) -or
        (Test-Path -Path $var.psConfig) -or
        (Test-Path -Path $var.bashConfig)) {
        print_warning "You alrady have Cmder config files. Overwrite them?"

        $key = $Host.UI.RawUI.ReadKey()
        Write-Host "`r`n"
        if ($key.Character -eq 'y') {
            # Yes, overwrite existing config files
            create_config_files $json $var
            $true
        }
        elseif ($key.Character -eq 'n') {
            # No, don't want to overwrite existing config files, do nothing
            $false
        }
        else {
            # Any other character, repeat input
            ask_to_create_cmder_config $json $var
        }
    }
    else {
        # No config files exist, make and write to them
        create_config_files $json $var
        $true
    }
}
