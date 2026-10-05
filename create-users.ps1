Import-Module ActiveDirectory
$pw = ConvertTo-SecureString "Welcome2026!" -AsPlainText -Force

$users = @"
First,Last,Username,Dept
Alex,Chen,alex.chen,IT
Sara,Khan,sara.khan,IT
Omar,Haddad,omar.haddad,Sales
Lena,Novak,lena.novak,Sales
Mia,Rossi,mia.rossi,Finance
David,Park,david.park,Finance
"@ | ConvertFrom-Csv

foreach ($u in $users) {
    New-ADUser -Name "$($u.First) $($u.Last)" -GivenName $u.First -Surname $u.Last -SamAccountName $u.Username -UserPrincipalName "$($u.Username)@lab.local" -Path "OU=$($u.Dept),DC=lab,DC=local" -AccountPassword $pw -ChangePasswordAtLogon $true -Enabled $true
    Add-ADGroupMember -Identity "GRP-$($u.Dept)" -Members $u.Username
    Write-Host "Created $($u.Username) in $($u.Dept)"
}