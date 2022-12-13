# Secret Mask GitHub Action

[![Test JSON secret](https://github.com/matteo-magni/secret-mask-action/actions/workflows/test-json.yml/badge.svg)](https://github.com/matteo-magni/secret-mask-action/actions/workflows/test-json.yml)

[![Test YAML secret](https://github.com/matteo-magni/secret-mask-action/actions/workflows/test-yaml.yml/badge.svg)](https://github.com/matteo-magni/secret-mask-action/actions/workflows/test-yaml.yml)

By default, a GitHub Actions secret gets hidden in workflows outputs by replacing it with `***`.
Each line in the secret is counted in its entirety, which means that if the whole line was to be printed in the output
it would be masked.

However, this does not apply to parts of it like the values in JSON or YAML data,
which might be as well inadvertently printed.

This Action extracts all the values in a JSON or YAML structured secret and masks them.

## Usage

```yaml
- uses: matteo-magni/secret-mask-action@main
  with:
    secret: ${{ secrets.MY_SECRET_JSON }}

```

## Example

In order to run tests against Azure, you tipically need to create a service principal and generate
a JSON client secret holding sensitive information, which is then stored in GitHub secrets and retrieved
by GitHub Actions during workflow execution.

```json
{
  "clientId": "00000000-1111-2222-3333-444444444444",
  "clientSecret": "9ZYMbvrgnPP2jDBTrlKFlUnxZKSdfS4SZfb/K+Fb",
  "subscriptionId": "55555555-6666-7777-8888-999999999999",
  "tenantId": "44444444-3333-2222-1111-000000000000",
  "activeDirectoryEndpointUrl": "https://login.microsoftonline.com",
  "resourceManagerEndpointUrl": "https://management.azure.com/",
  "activeDirectoryGraphResourceId": "https://graph.windows.net/",
  "sqlManagementEndpointUrl": "https://management.core.windows.net:8443/",
  "galleryEndpointUrl": "https://gallery.azure.com/",
  "managementEndpointUrl": "https://management.core.windows.net/"
}
```

Every single line of the secret would get masked whenever the exact same string
was to be printed out, but the single values wouldn't.
This is when this Action comes into play.

The above JSON chuck fed into the action would execute the following commands against GitHub Actions:

```sh
::add-mask::00000000-1111-2222-3333-444444444444
::add-mask::9ZYMbvrgnPP2jDBTrlKFlUnxZKSdfS4SZfb/K+Fb
::add-mask::55555555-6666-7777-8888-999999999999
::add-mask::44444444-3333-2222-1111-000000000000
::add-mask::https://login.microsoftonline.com
::add-mask::https://management.azure.com/
::add-mask::https://graph.windows.net/
::add-mask::https://management.core.windows.net:8443/
::add-mask::https://gallery.azure.com/
::add-mask::https://management.core.windows.net/
```

resulting in those strings being eventually replaced by `***` in workflow output.

**N.B.** the above JSON data has been made up and is invalid.