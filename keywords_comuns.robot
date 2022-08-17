* Settings *
Documentation    Arquivo contendo keywords comuns que são reutilizadas em vários endpoints.
Library          RequestsLibrary
Library          OperatingSystem

* Variables *
${url}            http://localhost:3000/


* Keywords *

Criar Sessao
    [Documentation]       Inicia uma sessão na API ServeRest com alias 'serverest'.
    Create Session        serverest    ${url}

Carregar JSON
    [Documentation]       Carrega e retorna um arquivo json.
    ...                   \nReturn: \${json}
    [Arguments]           ${nome_arquivo}
    ${arquivo}=           Get File    ${EXEC_DIR}/${nome_arquivo}
    ${json}=              Evaluate    json.loads('''${arquivo}''')    json
    [Return]              ${json}


Enviar DELETE
    [Documentation]     Envia uma requisição DELETE para o endpoint escolhido.
    ...                 Necessita que uma sessão com alias 'serverest' já tenha sido criada.
    ...                 \nRetorna: \${response} - a resposta recebida.

    [Arguments]         ${endpoint}    ${headers}=&{EMPTY}
    ${response}=        DELETE On Session    serverest    ${endpoint}    headers=${headers}    expected_status=any
    [Return]            ${response}

Enviar GET
    [Documentation]     Envia uma requisição GET para o endpoint escolhido.
    ...                 Necessita que uma sessão com alias 'serverest' já tenha sido criada.
    ...                 \nRetorna: \${response} - a resposta recebida.

    [Arguments]         ${endpoint}    ${headers}=&{EMPTY}
    ${response}=        GET On Session    serverest    ${endpoint}    headers=${headers}    expected_status=any
    [Return]            ${response}

Enviar POST
    [Documentation]         Envia uma requisição POST contendo o argumento body para o endpoint escolhido.
    ...                     Necessita que uma sessão com alias 'serverest' já tenha sido criada.
    ...                     \nRetorna: \${response} - a resposta recebida.

    [Arguments]             ${endpoint}    ${json}    ${headers}=&{EMPTY}
    ${response}=            POST On Session    serverest    ${endpoint}    json=${json}    headers=${headers}    expected_status=any
    [Return]                ${response}

Enviar PUT
    [Documentation]         Envia uma requisição PUT contendo o argumento body para o endpoint escolhido.
    ...                     Necessita que uma sessão com alias 'serverest' já tenha sido criada.
    ...                     \nRetorna: \${response} - a resposta recebida.

    [Arguments]             ${endpoint}    ${json}    ${headers}=&{EMPTY}
    ${response}=           PUT On Session    serverest    ${endpoint}    json=${json}    headers=${headers}    expected_status=any
    [Return]                ${response}

Obter Dados De Produto Existente
    [Documentation]         Retorna os dados do produto de índice index na lista de produtos cadastrados.
    ...                     Necessita que uma sessão com alias 'serverest' já tenha sido criada.
    ...                     \nRetorna: \&{produto} - os dados do produto encontrado.

    [Arguments]             ${index}=0
    ${response}=            GET On Session    serverest    /produtos
    &{produto}=             Create Dictionary    &{response.json()["produtos"][${index}]}
    [Return]                &{produto}

Obter Dados De Usuario Existente
    [Documentation]         Retorna os dados do usuário de índice index na lista de usuários cadastrados.
    ...                     Necessita que uma sessão com alias 'serverest' já tenha sido criada.
    ...                     \nRetorna: \&{usuario} - os dados do usuário encontrado.

    [Arguments]             ${index}=0
    ${response}=            GET On Session    serverest    /usuarios
    &{usuario}=             Create Dictionary    &{response.json()["usuarios"][${index}]}
    [Return]                &{usuario}


Fazer Login
    [Documentation]         Realiza login com os dados de login informados.
    ...                     Faz validações dentro da keyword.
    ...                     \nReturn: \${token_auth} -- o token de autenticação do usuário logado.
    [Arguments]             ${login}
    ${response}=            Enviar POST    /login    ${login}
    Validar Login           ${response}
    [Return]                ${response.json()["authorization"]}

Validar Login
    [Documentation]         Valida se um login foi realizado com sucesso.
    [Arguments]             ${response}
    Validar Status Code     200    ${response}
    Validar Mensagem        Login realizado com sucesso    ${response}
    Should Not Be Empty     ${response.json()["authorization"]}

Cadastrar Usuario
    [Documentation]               Cadastra um novo usuário com os dados json informados.
    ...                           Faz validações dentro da keyword.
    ...                           \nReturn: \${id} -- a id do usuário cadastrado
    [Arguments]                   ${dados_usuario}
    ${response}=                  Enviar POST    /usuarios    ${dados_usuario}
    Validar Usuario Cadastrado    ${response}
    [Return]                      ${response.json()["_id"]}

Validar Usuario Cadastrado
    [Documentation]               Valida se um usuário foi cadastrado com sucesso.
    [Arguments]                   ${response}
    Validar Status Code           201    ${response}
    Validar Mensagem              Cadastro realizado com sucesso    ${response}
    Should Not Be Empty           ${response.json()["_id"]}

Deletar Usuario
    [Documentation]               Deleta um usuário cadastrado com a id informada.
    ...                           Faz validações dentro da keyword.
    [Arguments]                   ${id_usuario}
    ${response}=                  Enviar DELETE    /usuarios/${id_usuario}
    Validar Usuario Deletado      ${response} 

Validar Usuario Deletado
    [Documentation]               Valida se um usuário foi deletado com sucesso.
    [Arguments]                   ${response}
    Validar Status Code           200    ${response}
    Validar Mensagem              Registro excluído com sucesso    ${response}

Cadastrar Produto
    [Documentation]               Cadastra um novo produto com os dados json informados.
    ...                           Faz validações dentro da keyword.
    ...                           \nReturn: \${id} -- a id do produto cadastrado
    [Arguments]                   ${dados_produto}    ${token_auth}
    &{headers}=                   Create Dictionary    Authorization=${token_auth}
    ${response}=                  Enviar POST    /produtos    ${dados_produto}    headers=${headers}
    Validar Produto Cadastrado    ${response}
    [Return]                      ${response.json()["_id"]}

Validar Produto Cadastrado
    [Documentation]               Valida se um produto foi cadastrado com sucesso.
    [Arguments]                   ${response}
    Validar Status Code           201    ${response}
    Validar Mensagem              Cadastro realizado com sucesso    ${response}
    Should Not Be Empty           ${response.json()["_id"]}

Deletar Produto
    [Documentation]               Deleta um produto cadastrado com a id informada.
    ...                           Faz validações dentro da keyword.
    [Arguments]                   ${id_produto}    ${token_auth}
    &{headers}=                   Create Dictionary    Authorization=${token_auth}
    ${response}=                  Enviar DELETE    /produtos/${id_produto}    headers=${headers}
    Validar Produto Deletado      ${response} 

Validar Produto Deletado
    [Documentation]               Valida se um produto foi deletado com sucesso.
    [Arguments]                   ${response}
    Validar Status Code           200    ${response}
    Validar Mensagem              Registro excluído com sucesso    ${response}

Cadastrar Carrinho
    [Documentation]               Cadastra um novo carrinho com os dados json informados.
    ...                           Faz validações dentro da keyword.
    ...                           \nReturn: \${id} -- a id do carrinho cadastrado
    [Arguments]                   ${id_produto}    ${token_auth}

    &{produto}=                   Create Dictionary    idProduto=${id_produto}    quantidade=${3}
    @{lista}=                     Create List    ${produto}
    &{carrinho}=                  Create Dictionary    produtos=${lista}

    &{headers}=                   Create Dictionary    Authorization=${token_auth}
    ${response}=                  Enviar POST    /carrinhos    ${carrinho}    headers=${headers}

    Validar Carrinho Cadastrado   ${response}
    [Return]                      ${response.json()["_id"]}

Validar Carrinho Cadastrado
    [Documentation]               Valida se um carrinho foi cadastrado com sucesso.
    [Arguments]                   ${response}
    Validar Status Code           201    ${response}
    Validar Mensagem              Cadastro realizado com sucesso    ${response}
    Should Not Be Empty           ${response.json()["_id"]}

Concluir Compra
    [Documentation]               Deleta um carrinho cadastrado com o token_auth informado.
    ...                           Indica que a compra foi concluída.
    ...                           Faz validações dentro da keyword.
    [Arguments]                   ${token_auth}
    &{headers}=                   Create Dictionary    Authorization=${token_auth}

    ${response}=                  Enviar DELETE    /carrinhos/concluir-compra    headers=${headers}
    Validar Carrinho Deletado      ${response} 

Cancelar Compra
    [Documentation]               Deleta um carrinho cadastrado com o token_auth informado.
    ...                           Indica que a compra foi cancelada.
    ...                           Faz validações dentro da keyword.
    [Arguments]                   ${token_auth}
    &{headers}=                   Create Dictionary    Authorization=${token_auth}

    ${response}=                  Enviar DELETE    /carrinhos/cancelar-compra    headers=${headers}
    Validar Carrinho Deletado      ${response} 

Validar Carrinho Deletado
    [Documentation]               Valida se um carrinho foi deletado com sucesso.
    [Arguments]                   ${response}
    Validar Status Code           200    ${response}
    Validar Mensagem Contem       Registro excluído com sucesso.    ${response}

Obter Informacoes De Login
    [Documentation]         Extrai somente email e senha de um json contendo todas as informações de um usuário.
    ...                     \nRetorna: \&{login} - dicionário contendo chaves 'email' e 'password'.

    [Arguments]             &{usuario}
    &{login}=               Create Dictionary    email=${usuario["email"]}    password=${usuario["password"]}
    [Return]                &{login}


# Keywords de validação

Validar Mensagem
    [Documentation]                   Verifica se a propriedade 'message' da resposta é a mesma que o esperado.

    [Arguments]                       ${esperado}    ${response}
    Should Be Equal As Strings        ${response.json()["message"]}    ${esperado}

Validar Mensagem Contem
    [Documentation]                Verifica se a propriedade 'message' da resposta contém a frase informada.
    [Arguments]                    ${frase}    ${response}
    Should Contain                 ${response.json()["message"]}    ${frase}

Validar Status Code
    [Documentation]                Verifica se o status code na resposta é o mesmo que o esperado.
    
    [Arguments]                    ${esperado}    ${response}
    Should Be Equal As Integers    ${response.status_code}    ${esperado}