$pw = ConvertTo-SecureString "Welcome2026!" -AsPlainText -Force

$leaders = @"
First,Last,Username,Dept,Title
Elif,Yilmaz,elif.yilmaz,IT,IT Director
Emre,Demir,emre.demir,Sales,Sales Manager
"@ | ConvertFrom-Csv

foreach ($u in $leaders) {
    New-ADUser -Name "$($u.First) $($u.Last)" -GivenName $u.First -Surname $u.Last -SamAccountName $u.Username -UserPrincipalName "$($u.Username)@lab.local" -Path "OU=$($u.Dept),DC=lab,DC=local" -Title $u.Title -Description $u.Title -AccountPassword $pw -ChangePasswordAtLogon $true -Enabled $true
    Add-ADGroupMember -Identity "GRP-$($u.Dept)" -Members $u.Username
    Write-Host "Created $($u.Username) - $($u.Title)"
}