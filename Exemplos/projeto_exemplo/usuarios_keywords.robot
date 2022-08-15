* Settings *
Documentation        Keywords e variáveis para Ações do endpoint de usuários.


* Variables *
${nome_do_usuario}        herbert richards
${senha_do_usuario}       teste123
${email_do_usuario}       testes@gmail.com

* Keywords *

GET Endpoint /usuarios
    ${response}=            GET On Session    serverest    /usuarios
    Set Global Variable        ${response}

POST Endpoint /usuarios
    &{payload}              Create Dictionary    nome=${nome_do_usuario}    email=${email_do_usuario}    password=${senha_do_usuario}    administrador=true
    ${response}             POST On Session    serverest    /usuarios    data=&{payload}
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
