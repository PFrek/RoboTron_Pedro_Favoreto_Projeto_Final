* Settings *
Documentation        Keywords e variáveis para Ações do endpoint de usuários.
Resource             ../support/base.robot


* Keywords *

GET Endpoint /usuarios
    ${response}=            GET On Session    serverest    /usuarios
    Set Global Variable        ${response}

POST Endpoint /usuarios
    ${response}             POST On Session    serverest    /usuarios    json=&{payload}
    Log To Console          Resonse: ${response.content}
    Set Global Variable     ${response}

PUT Endpoint /usuarios
    ${response}             PUT On Session    serverest    /usuarios/${response.json()["_id"]}    json=&{payload}
    Log To Console          Response: ${response.content}
    Set Global Variable     ${response}

DELETE Endpoint /usuarios
    ${response}             DELETE On Session    serverest    /usuarios/${response.json()["_id"]}
    Log To Console          ${response.content}
    Set Global Variable     ${response}

Validar Quantidade "${quantidade}"
    Should Be Equal    ${response.json()["quantidade"]}    ${quantidade}

Pegar Dados Usuario Estatico Valido
    ${json}                Importar JSON Estatico    json_usuario_ex.json
    ${payload}             Set Variable    ${json["user_valido"]}
    Set Global Variable    ${payload}
