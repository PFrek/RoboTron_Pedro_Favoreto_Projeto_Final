* Settings *
Documentation        Keywords e variáveis para Ações do endpoint de produtos.


* Variables *
${token_auth}        Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImZ1bGFub0BxYS5jb20uYnIiLCJwYXNzd29yZCI6InRlc3RlIiwiaWF0IjoxNjYwNTU5NzkzLCJleHAiOjE2NjA1NjAzOTN9.DQ9JvkshbKH2b7M96eIsh1Hn9PBs8Yd7_yhqxdu7_a4


* Keywords *
POST Endpoint /produtos
    ${header}               Create Dictionary    Authorization=${token_auth}
    &{payload}              Create Dictionary    nome=MouseTech    preco=400    descricao=Mouse    quantidade=100
    ${response}             POST On Session    serverest    /produtos    data=&{payload}    headers=${header}
    Log To Console          Resonse: ${response.content}
    Set Global Variable     ${response}