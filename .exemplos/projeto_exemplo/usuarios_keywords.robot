* Settings *
Documentation        Keywords e variáveis para Ações do endpoint de usuários.
Resource             ./common.robot
Resource             ./dynamics.robot

* Variables *
${nome_do_usuario}        herbert richards
${senha_do_usuario}       teste123
${email_do_usuario}       testes@gmail.com

* Keywords *

GET Endpoint /usuarios
    ${response}=            GET On Session    serverest    /usuarios
    Set Global Variable        ${response}

POST Endpoint /usuarios
    ${response}             POST On Session    serverest    /usuarios    json=&{payload}
    Log To Console          Resonse: ${response.content}
    Set Global Variable     ${response}

PUT Endpoint /usuarios
    &{payload}              Create Dictionary    nome=jaras priest    email=test120823@gmail.com    password=123    administrador=true
    ${response}             PUT On Session    serverest    /usuarios/VJ1xMrlgWMriSUad    data=&{payload}
    Log To Console          Response: ${response.content}
    Set Global Variable     ${response}

DELETE Endpoint /usuarios
    ${response}             DELETE On Session    serverest    /usuarios/VJ1xMrlgWMriSUad
    Log To Console          ${response.content}
    Set Global Variable     ${response}

Validar Quantidade "${quantidade}"
    Should Be Equal    ${response.json()["quantidade"]}    ${quantidade}

Validar Se Mensagem Contem "${palavra}"
    Should Contain    ${response.json()["message"]}    ${palavra}

Printar Conteudo Response
    Log To Console    Nome: ${response.json()["usuarios"][1]["nome"]}

Cadastrar Usuario Estatico Valido
    ${json}                Importar JSON Estatico    json_usuario_ex.json
    ${payload}             Set Variable    ${json["user_valido"]}
    Set Global Variable    ${payload}
    POST Endpoint /usuarios

Cadastrar Usuario Dinamico Valido
    ${payload}                Criar Dados Usuario Valido
    Set Global Variable       ${payload}
    POST Endpoint /usuarios