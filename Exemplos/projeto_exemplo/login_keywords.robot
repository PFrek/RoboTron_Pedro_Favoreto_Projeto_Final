* Settings *
Documentation        Keywords e variáveis para Ações do endpoint de login.


* Variables *
${email_para_login}                fulano@qa.com.br
${password_para_login}             teste

* Keywords *

POST Endpoint /login
    &{payload}              Create Dictionary    email=${email_para_login}    password=${password_para_login}
    ${response}             POST On Session    serverest    /login    data=&{payload}
    Log To Console          Resonse: ${response.content}
    Set Global Variable     ${response}