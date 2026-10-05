Windows Server 2022 Active Directory lab: domain controller, DNS, DHCP, Group Policy, and help desk scenarios

# Active Directory Home Lab

A virtual Windows domain I built to practise the tasks an IT help desk handles every day: managing users and groups, resetting passwords, fixing access problems, troubleshooting DNS, and applying Group Policy.

## Environment

| Machine | Role | Details |
|---|---|---|
| DC01 | Windows Server 2022 | Domain controller for `lab.local`, DNS, DHCP (192.168.50.10) |
| CLIENT01 | Windows 11 Enterprise | Domain-joined workstation (address from DHCP) |

Both run in VirtualBox on a private NAT network (192.168.50.0/24).

## What I built

**DHCP and DNS.** DC01 hands out addresses and points clients to itself for DNS.

![DHCP scope options](screenshots/01-dhcp-scope-options.png)
![Client IP and ping](screenshots/02-client-ip-and-ping.png)

**Domain join.** CLIENT01 joined to `lab.local`.

![Client joined](screenshots/03-client-joined-domain.png)

**Organizational units, groups, and users.** One OU and one security group per department (IT, HR, Sales, Finance), plus OUs for workstations and disabled accounts.

![OU structure](screenshots/04-ou-structure.png)
![HR users and group](screenshots/05-hr-users-and-group.png)

**Bulk user creation with PowerShell.** [`create-users.ps1`](create-users.ps1) and [`create-managers.ps1`](create-managers.ps1) create users from CSV data, place them in the right OU, and add them to the right group.

![PowerShell bulk users](screenshots/06-powershell-bulk-users.png)
![IT users](screenshots/07-it-users-with-titles.png)

## Help desk scenarios

### 1. New hire's first login
New accounts must change their password at first sign-in.

![First login](screenshots/08-first-login-password-change.png)

### 2. Forgotten password
Reset the password with a temporary one and force a change at next logon.

![Password reset](screenshots/09-password-reset.png)

### 3. Locked account
After five wrong passwords the account locks. I found the lockout in Active Directory and unlocked it.

![Locked, user view](screenshots/10-account-locked-user-view.png)
![Locked, admin view](screenshots/11-account-locked-admin-view.png)

### 4. Shared folder access
The HR share is restricted to the `GRP-HR` security group. A Sales user was denied, then given access by adding them to the group. The change only took effect after they signed out and back in.

![Folder permissions](screenshots/12-hr-folder-permissions.png)
![HR user access](screenshots/13-hr-user-access.png)
![Access denied](screenshots/14-access-denied.png)
![Access granted](screenshots/15-access-granted.png)

### 5. Offboarding
Disabled the leaver's account, removed group memberships, and moved it to a Disabled Users OU.

![Disabled Users OU](screenshots/16-disabled-users-ou.png)
![Account disabled](screenshots/17-account-disabled.png)

### 6. DNS troubleshooting
With the wrong DNS server, the client could ping the server by IP but not by name. Setting DNS back to the domain controller and flushing the cache fixed it.

![DNS broken](screenshots/18-dns-broken.png)
![DNS fixed](screenshots/19-dns-fixed.png)

## Group Policy

- **Default Domain Policy:** account lockout after 5 invalid attempts
- **Sales - Restrict Control Panel:** blocks Control Panel and Settings for Sales users
- **HR - Map H Drive:** maps the HR share as H: for HR users

![Group Policy objects](screenshots/20-group-policy-objects.png)
![Control Panel blocked](screenshots/21-control-panel-blocked.png)
![gpresult](screenshots/22-gpresult.png)
![Mapped drive](screenshots/23-mapped-h-drive.png)

## What I learned

- OUs organize objects and receive Group Policy; security groups grant access to resources.
- Group membership is applied at sign-in, so access changes need a sign-out and sign-in.
- A 169.254.x.x address means the machine could not reach a DHCP server.
- "Ping by IP works, ping by name fails" points to DNS, and the DNS cache can hide the real state until it is flushed.
- `gpresult /r` shows which policies and groups apply to a user.

## Tools

Windows Server 2022, Windows 11 Enterprise, Active Directory Domain Services, DNS, DHCP, Group Policy, PowerShell, VirtualBox
