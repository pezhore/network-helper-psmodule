Function ConvertTo-MaskLength
{
<#
    .Synopsis
    Returns the length of a subnet mask.
    .Description
    ConvertTo-MaskLength accepts any IPv4 address as input, however the output value
    only makes sense when using a subnet mask.
    .Parameter SubnetMask
    A subnet mask to convert into length
#>

    [CmdletBinding()]
    Param(
          [Parameter(Mandatory = $True, Position = 0, ValueFromPipeline = $True)]
          [Alias("Mask")]
          [Net.IPAddress]$SubnetMask
         )
    BEGIN{}
    PROCESS
    {
        $Bits = "$( $SubnetMask.GetAddressBytes() | ForEach-Object { [Convert]::ToString($_, 2) } )" -Replace '[\s0]'
        Return $Bits.Length
    }
}