* Settings *
Documentation        Keywords e Variáveis para Ações Gerais.
Library              OperatingSystem

* Keywords *

Validar Status Code "${statuscode}"
    Should Be True    ${response.status_code} == ${statuscode}


Validar Se Mensagem Contem "${palavra}"
    Should Contain    ${response.json()["message"]}    ${palavra}

Importar JSON Estatico
    [Arguments]    ${nome_arquivo}
    ${arquivo}     Get File    ${EXEC_DIR}/support/fixstures/static/${nome_arquivo}
    ${data}        Evaluate    json.loads('''${arquivo}''')    json
    [Return]       ${data}