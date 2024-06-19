# Lynis Scan Role

This role will install Lynis and run a scan on the target host. The results will be saved to a file in the user's tmp directory.

## Features

- Installs Lynis
- Runs a scan on the target host
- Saves the results to a file in the user's tmp directory

## How to use

```bash
ansible-galaxy install farisc0de.lynisscan
```

```yml
- hosts: all
  roles:
    - role: farisc0de.lynisscan
```

## License

MIT
