# github-clone
A small bash script to quickly clone repositories matching a regex from a specific user or organization.

## Dependencies
+ jq: <https://stedolan.github.io/jq/>

## How to use
+ To clone all repositories from a specific user:

  ```
  github-clone https://api.github.com/users/crispydrone/repos <target-dir> <regex>
  ```

+ To clone all repositories from a specific organization:

  ```
  github-clone https://api.github.com/orgs/<organization-name>/repos <target-dir> <regex>
  ```

## Examples
1. Clone all my repositories having "notes" in the repository name into a NOTES directory

   ```
   github-clone https://api.github.com/users/crispydrone/repos NOTES notes
   ```
