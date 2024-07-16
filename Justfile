contract := "sample-crate-33.testnet"
default := ''

create-dev-acc:
    near account create-account sponsor-by-faucet-service {{contract}} autogenerate-new-keypair save-to-keychain network-config testnet create

# additional_args can most often be `--no-docker`
deploy additional_args=default: create-dev-acc
    cargo near deploy {{additional_args}} {{contract}} without-init-call network-config testnet sign-with-keychain send

test-meta:
    near contract call-function as-read-only {{contract}} contract_source_metadata json-args {} network-config testnet now
