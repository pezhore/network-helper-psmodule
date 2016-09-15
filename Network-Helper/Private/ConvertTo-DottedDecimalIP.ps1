Function ConvertTo-DottedDecimalIP
{
<#
    .Synopsis
    Returns a dotted decimal IP address from either an unsigned 32-bit integer or a dotted binary string.
    .Description
    ConvertTo-DottedDecimalIP uses a regular expression match on the input string to convert to an IP address.
    .Parameter IPAddress
    A string representation of an IP address from either UInt32 or dotted binary.
#>

    [CmdletBinding()]
    Param(
          [Parameter(Mandatory = $True, Position = 0, ValueFromPipeline = $True)]
          [String]$IPAddress
         )

    BEGIN{}
    PROCESS {
        Switch -RegEx ($IPAddress)
        {
            "([01]{8}\.){3}[01]{8}"
            {
                Return [String]::Join('.', $( $IPAddress.Split('.') | ForEach-Object { [Convert]::ToUInt32($_, 2) } ))
            }
            "\d"
            {
                $IPAddress = [UInt32]$IPAddress
                $DottedIP = $( For ($i = 3; $i -gt -1; $i--) {
                    $Remainder = $IPAddress % [Math]::Pow(256, $i)
                    ($IPAddress - $Remainder) / [Math]::Pow(256, $i)
                    $IPAddress = $Remainder
                })

                Return [String]::Join('.', $DottedIP)
            }
            default
            {
                Write-Error "Cannot convert this format"
            }
        }
    }
}
