# GNOME DeBloater (GDB)

Debloater for supported distros on GNOME, will leave you with a fairly bare-bones GNOME app selection
WARNING: will also remove firefox, make sure you have another browser installed or ready to be installed before running this script

**Prerequisites:**
- wget (you probably have it unless you didn't select standard system utilities for debian, in which case: `sudo apt install wget -y`)

```
cd; wget https://raw.githubusercontent.com/agustux/GDB/main/gdb.sh && bash gdb.sh
```

Both these tables come from testing in VMs:

### RAM Savings
| Distros Supported | Bloated RAM Usage | Debloated RAM Usage |
|-------------------|-------------------|---------------------|
| Ubuntu 26.04 | 1250 MB used/1700 MB buff/cache | 1050 MB used/900 MB buff/cache |
| Ubuntu 24.04 | 1150 MB used/1700 MB buff/cache | 900 MB used/800 MB buff/cache |
| Fedora 44 | 1400 MB used/1400 MB buff/cache | 1250 MB used/1150 MB buff/cache |
| Fedora 43 | 1600 MB used/1850 MB buff/cache | 1300 MB used/1450 MB buff/cache |
| Debian 13 | 1000 MB used/600 MB buff/cache | 850 MB used/550 MB buff/cache |
| Manjaro | 1300 MB used/1700 MB buff/cache | 1000 MB used/1400 MB buff/cache |
| Arch | 1150 MB used/1000 MB buff/cache | 900 MB used/900 MB buff/cache |

### Disk Savings (Without Swap file)
| Distros Supported | Bloated Disk Usage | Debloated Disk Usage |
|-------------------|--------------------|----------------------|
| Ubuntu 26.04 | 7.5 GB | 4.9 GB |
| Ubuntu 24.04 | 6.5 GB | 4.9 GB |
| Fedora 44 | 6.6 GB | 5.0 GB |
| Fedora 43 | 9.3 GB | 6.3 GB |
| Debian 13 | 5.1 GB | 4.1 GB |
| Manjaro | 8.1 GB | 6.3 GB |
| Arch | 5.7 GB | 4.0 GB |

