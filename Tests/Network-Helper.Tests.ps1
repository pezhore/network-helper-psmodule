$Verbose = @{}
if($env:APPVEYOR_REPO_BRANCH -and $env:APPVEYOR_REPO_BRANCH -notlike "master")
{
    $Verbose.add("Verbose",$True)
}

$PSVersion = $PSVersionTable.PSVersion.Major
Import-Module $PSScriptRoot\..\Network-Helper\Network-Helper.psd1 -Force

#Integration Testing for SubnetMask conversion
Describe "ConvertTo-SubnetMask PS$PSVersion Integrations tests" {

    Context 'Strict mode' {

        Set-StrictMode -Version latest

        It 'should return valid SubnetMask' {
            $Output = ConvertTo-SubnetMask -MaskLength 24
            $Output -eq "255.255.255.0" | Should be $True
        }
    }
}

#Integration  Test for Mask Length
Describe "ConvertTo-MaskLength PS$PSVersion Integrations tests" {

    Context 'Strict mode' {

        Set-StrictMode -Version latest

        It 'should return valid mask length' {
            $Output = ConvertTo-MaskLength -SubnetMask '255.255.255.0'
            $Output -eq "23" | Should be $True
        }
    }
}