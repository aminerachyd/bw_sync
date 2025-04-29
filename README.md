# Mirror content between Bitwarden instances

This script serves the purpose of mirroring the content of a Bitwarden instance to another instance.

This is compatible with Vaultwarden.

The export is saved locally after the script is ran.

Credentials can be provided as env variables, check the script for more info.

This doesn't perform a cleanup/purge of the destination Bitwarden instance, duplicates can be created.

It is advised to save the destination content for backup purposes. Use at your own risk.
