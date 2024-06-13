contract := "sample-crate-7.testnet"
contract_no_docker := "sample-crate-no-docker-9.testnet"

create-dev-acc:
    near account create-account sponsor-by-faucet-service {{contract}} autogenerate-new-keypair save-to-keychain network-config testnet create

deploy: create-dev-acc
    cargo near deploy {{contract}} without-init-call network-config testnet sign-with-keychain send

test-meta:
    near contract call-function as-read-only {{contract}} contract_source_metadata json-args {} network-config testnet now

create-dev-acc-no-docker:
    near account create-account sponsor-by-faucet-service {{contract_no_docker}} autogenerate-new-keypair save-to-keychain network-config testnet create

deploy-no-docker: create-dev-acc-no-docker
    sleep 15
    cargo near deploy --no-docker --no-abi {{contract_no_docker}} without-init-call network-config testnet sign-with-keychain send

test-meta-no-docker:
    near contract call-function as-read-only {{contract_no_docker}} contract_source_metadata json-args {} network-config testnet now
