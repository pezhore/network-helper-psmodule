$Verbose = @{}
if($env:APPVEYOR_REPO_BRANCH -and $env:APPVEYOR_REPO_BRANCH -notlike "master")
{
    $Verbose.add("Verbose",$True)
}
$ModuleName = "Network-Helper"
$PSVersion = $PSVersionTable.PSVersion.Major
Import-Module $PSScriptRoot\..\$ModuleName\$ModuleName.psm1 -Force

#Unit Testing for SubnetMask conversion
Describe "ConvertTo-SubnetMask PS$PSVersion Integrations tests" {

    Context 'Strict mode' {

        Set-StrictMode -Version latest

        It 'should return valid SubnetMask' {
            $Output = ConvertTo-SubnetMask -MaskLength 24
            $Output -eq "255.255.255.0" | Should be $True
        }

        It 'should error with a length SubnetMask over 32' {
            try {
                $Output = ConvertTo-SubnetMask -MaskLength 36 -ErrorAction Stop
            } catch {
                $error[0].exception -match "greater than the maximum allowed range of 32" `
                        | Should be $True
            }
        }

        It 'should error with a non-int subnetmask' {
            try {
                $Output = ConvertTo-SubnetMask -MaskLength "error" -ErrorAction Stop
            } catch {
                $error[0].exception -match "The argument cannot be validated because its type `"String`" is not the same type (Int32)*" `
                        | Should be $True
            }

        }
    }
}

#Integration  Test for Mask Length
Describe "ConvertTo-MaskLength PS$PSVersion Integrations tests" {

    Context 'Strict mode' {

        Set-StrictMode -Version latest

        It 'should return valid mask length' {
            $Output = ConvertTo-MaskLength -SubnetMask '255.255.255.0'
            $Output -eq "24" | Should be $True
        }

        It 'should error when invalid IP is provided' {
            try {
                $Output = ConvertTo-MaskLength -SubnetMask '256.255.255.0' -ErrorAction Stop
            } catch {
                $Error[0].exception -match "Cannot convert .* to type `"System.Net.IPAddress`"" `
                        | Should be $True
            }

        }
    }
}

Describe "Should pass Script Analyzer PS$PSVersion Integrations tests" {
    Context 'Strict mode' {

        Set-StrictMode -Version latest

        It 'Should have no output from Script Analyzer' {
            $Output = Invoke-ScriptAnalyzer -Path $PSScriptRoot\..\$ModuleName -Recurse
            $Output -eq $null | Should be $true
        }
    }
}
