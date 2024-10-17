contract := "sample-crate-104.testnet"
default := ''
# export GOOGLE_QUERY := 'https://www.google.com/search?q=google+translate&sca_esv=3c150c50f502bc5d'
# export KEY := 'VALUE'
export RUST_LOG := 'cargo_near=info'

[group('tempalte-create-deploy')]
_create_dev_acc target additional_args=default:
    near account create-account sponsor-by-faucet-service {{ target }} autogenerate-new-keypair save-to-keychain network-config testnet create || true
    cargo near deploy {{ additional_args }} {{ target }} without-init-call network-config testnet sign-with-keychain send

[group('deploy')]
deploy_docker: (_create_dev_acc contract)

[group('deploy')]
deploy_no_docker: (_create_dev_acc contract "--no-docker")

_download_abi target:
    near contract download-abi {{ target }} save-to-file {{ contract }}.json network-config testnet now

download_abi: (_download_abi contract)

[group('test-nep330-meta')]
_test_meta target:
    near contract call-function as-read-only {{ target }} contract_source_metadata json-args {} network-config testnet now

[group('test-nep330-meta')]
test_meta: (_test_meta contract)

[group('test')]
_call_get_beneficiary target:
    near contract call-function as-read-only {{ target }} get_beneficiary json-args {} network-config testnet now

[group('test')]
call_get_beneficiary: (_call_get_beneficiary contract)
