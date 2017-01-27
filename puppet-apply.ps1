param(
    $role,
	[switch]$build,
	[switch]$debug
)


try {
    if ($build) {
        write-host "Fetching all environments with R10K...."
        & r10k deploy environment -pv
    } else {
        Get-Content "c:\ProgramData\PuppetLabs\puppet\etc\puppet.conf" | ForEach-Object -Begin {$settings=@{}} -Process {$store = [regex]::split($_,'='); if(($store[0].CompareTo("") -ne 0) -and ($store[0].StartsWith("[") -ne $True) -and ($store[0].StartsWith("#") -ne $True)) {$settings.Add($store[0], $store[1])}}
        $environment = $settings.Get_Item("Environment")

        # Create empty folder with environment name - otherwise puppet apply fails
        New-Item "C:\ProgramData\PuppetLabs\code\environments\$environment" -type directory -force | Out-Null

        # Set the role on the agent
        New-Item "c:\ProgramData\PuppetLabs\facter\facts.d\role.txt" -type file -force -value "role=$role" | Out-Null

        # Required for puppet-apply to work locally on Vagrant
        New-Item "c:\ProgramData\PuppetLabs\facter\facts.d\dsc.txt" -type file -force -value "powershell_version=$($psversiontable.psversion.tostring())" | Out-Null
        $debugMode = ""
        if ($debug) {
            $debugMode = "--debug"
        }

        Write-Host "Running Puppet Apply for environment $environment...."
        & puppet config set strict_variables true
        & puppet apply --hiera_config=hiera.yaml --modulepath environments/$environment/modules environments/local/manifests/default.pp $debugMode
    }
}
}
Catch
{
    throw $_
}
