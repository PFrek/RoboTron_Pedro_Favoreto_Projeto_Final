* Settings *
Documentation    Arquivo contendo as keywords exclusivas para o Endpoint /login.
Resource         ../support/base.robot


* Keywords *

Tentar Login
    [Documentation]         Realiza uma tentativa de login com os dados json informados.
    ...                     Não faz validações dentro da keyword.
    ...                     \nReturn: \${response} -- a resposta da tentativa de login.
    [Arguments]             ${json_login}

    ${login}                Set Variable     ${json["dados_teste"][${json_login}]}
    ${response}             Enviar POST      /login    ${login}
    [Return]                ${response}
