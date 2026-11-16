# NVIDIA overclock examples

```bash
# Inspect current settings
./nekominer --oc-info -d 0
```

```bash
# Validate without applying
sudo ./nekominer -d 0 --lock-cclock 1560 --lock-mclock 405 --oc-dry-run
```

```bash
# Apply settings and exit
sudo ./nekominer -d 0 --lock-cclock 1560 --lock-mclock 405
```

```bash
# Mine with OC and restore settings on exit
sudo ./nekominer -a <ALGO> -o <POOL> -u <ADDRESS>.<WORKER> -d 0 --lock-cclock 1560 --lock-mclock 405 --cclock 180 --oc-exit restore
```

```bash
# Set different values per GPU (-d 1,0)
sudo ./nekominer -a <ALGO> -o <POOL> -u <ADDRESS>.<WORKER> -d 1,0 --lock-cclock 1650,1560 --lock-mclock 6001,810 --cclock 180.125,150 --mclock 500,0 --pl 150,120 --fan 65,auto
```

```bash
# Reset selected GPUs and exit
sudo ./nekominer --reset-oc -d 0
```
