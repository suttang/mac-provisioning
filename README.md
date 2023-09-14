```
# Create .ssh symlink to iCloud drive
ln -s ~/Library/Mobile\ Documents/com\~apple\~CloudDocs/Documents/setting/.ssh/ ~/.ssh

# Clone setup scripts
mkdir -p ~/workspace; git clone git@github.com:suttang/mac-provisioning.git ~/workspace/mac-provisioning; ~/workspace/mac-provisioning/setup.sh
```

## Setup


```
make
```

## Dump Brewfile

```
brew bundle dump
```
