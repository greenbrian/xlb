# Setup steps

Vault requires a couple manual steps to be performed.   
First it needs to be initialized.

    # vault init -address=http://localhost:8200
    Unseal Key 1 (hex)   : 6a78f5e83bced8c4a565f6d69a47df9475c9c746bcfbfb8b36c556bb1f9b8a4701
    Unseal Key 1 (base64): anj16DvO2MSlZfbWmkfflHXJx0a8+/uLNsVWux+bikcB
    Unseal Key 2 (hex)   : 4016bb769f19039fcd743b92ac1702842962384b657b7c449fb80a63409f1a8602
    Unseal Key 2 (base64): QBa7dp8ZA5/NdDuSrBcChCliOEtle3xEn7gKY0CfGoYC
    Unseal Key 3 (hex)   : 0774b3626ba76377116c9307d4c6aef05e16b4559ba1b34d693a1a8deda187a003
    Unseal Key 3 (base64): B3SzYmunY3cRbJMH1Mau8F4WtFWbobNNaToaje2hh6AD
    Unseal Key 4 (hex)   : 560f324dd59a22aa568b2c57b06f592e6dc476c2216cbd68e80f75d0b7d2bd2e04
    Unseal Key 4 (base64): Vg8yTdWaIqpWiyxXsG9ZLm3EdsIhbL1o6A910LfSvS4E
    Unseal Key 5 (hex)   : 116d3a59212442428a9384c2c8bef55a1ab0fadcdfb672611e8d653e1aec200805
    Unseal Key 5 (base64): EW06WSEkQkKKk4TCyL71Whqw+tzftnJhHo1lPhrsIAgF
    Initial Root Token: b9356be3-0816-d51b-7a5e-b19425b48012

    Vault initialized with 5 keys and a key threshold of 3. Please
    securely distribute the above keys. When the Vault is re-sealed,
    restarted, or stopped, you must provide at least 3 of these keys
    to unseal it again.

    Vault does not store the master key. Without at least 3 keys,
    your Vault will remain permanently sealed.

Then it needs to be unsealed using 3 of the above 5 addresses, on *each* Vault server in the cluster

    # vault unseal -address=http://localhost:8200 6a78f5e83bced8c4a565f6d69a47df9475c9c746bcfbfb8b36c556bb1f9b8a4701
    Sealed: true
    Key Shares: 5
    Key Threshold: 3
    Unseal Progress: 1
    # vault unseal -address=http://localhost:8200 4016bb769f19039fcd743b92ac1702842962384b657b7c449fb80a63409f1a8602
    Sealed: true
    Key Shares: 5
    Key Threshold: 3
    Unseal Progress: 2
    # vault unseal -address=http://localhost:8200 0774b3626ba76377116c9307d4c6aef05e16b4559ba1b34d693a1a8deda187a003
    Sealed: false
    Key Shares: 5
    Key Threshold: 3
    Unseal Progress: 0

    # vault status -address=http://localhost:8200
    Sealed: false
    Key Shares: 5
    Key Threshold: 3
    Unseal Progress: 0
    Version: Vault v0.6.1
    Cluster Name: vault-cluster-4199c80b
    Cluster ID: 51340d90-017c-15cc-7504-d4efb77656da

    High-Availability Enabled: true
	    Mode: active
	    Leader: http://127.0.0.1:8200

    # curl -s http://127.0.0.1:8200/v1/sys/init
    {"initialized":true}


    # Curl post secret to vault
    export ROOT_TOKEN=$(cat /tmp/vault.init | grep 'Root' | awk '{print $4}')
    curl \
    -H "X-Vault-Token: $ROOT_TOKEN" \
    -H "Content-Type: application/json" \
    -X POST \
    -d '{"value":"MySomewhatLongPassword"}' \
    http://127.0.0.1:8200/v1/secret/passwordvault

    # Curl retrieve secret from vault
    curl -s \
    -H "X-Vault-Token: $ROOT_TOKEN" \
    -X GET \
    http://127.0.0.1:8200/v1/secret/passwordvault | jq
