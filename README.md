# github-clone
A small bash script to quickly clone repositories matching a regex from a specific user or organization.

## Dependencies
+ jq: <https://stedolan.github.io/jq/>
+ git: <https://git-scm.com/>

## How to use
+ You can specify a github api url for: 
  + A user: <https://api.github.com/users/crispydrone/repos>
  + An organization: <https://api.github.com/orgs/microsoft/repos>

## Examples
+ To clone all repositories from a specific user into a target directory:

  ```
  github-clone.sh https://api.github.com/users/crispydrone <target-dir>
  ```

+ To clone all repositories from a specific organization with current directory as root:

  ```
  github-clone.sh https://api.github.com/orgs/<organization-name>
  ```

+ Clone all repositories having "notes" (case insensitive) in the repository name into a NOTES directory

   ```
   github-clone.sh https://api.github.com/users/crispydrone NOTES notes
   ```

## In the pipeline
1. Support for command line flag `-t <type>` (user or org) so it's not necessary to type the raw url every time.
2. Support for parallel processing
