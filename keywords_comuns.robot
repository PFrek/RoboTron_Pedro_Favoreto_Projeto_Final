* Settings *
Documentation    Arquivo contendo keywords comuns que são reutilizadas em vários endpoints.
Library          RequestsLibrary
Library          OperatingSystem
Library          FakerLibrary

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
    ...                 \Return: \${response} - a resposta recebida.

    [Arguments]         ${endpoint}    ${headers}=&{EMPTY}
    ${response}=        DELETE On Session    serverest    ${endpoint}    headers=${headers}    expected_status=any
    [Return]            ${response}

Enviar GET
    [Documentation]     Envia uma requisição GET para o endpoint escolhido.
    ...                 Necessita que uma sessão com alias 'serverest' já tenha sido criada.
    ...                 \nReturn: \${response} - a resposta recebida.

    [Arguments]         ${endpoint}    ${headers}=&{EMPTY}
    ${response}=        GET On Session    serverest    ${endpoint}    headers=${headers}    expected_status=any
    [Return]            ${response}

Enviar POST
    [Documentation]         Envia uma requisição POST contendo o argumento body para o endpoint escolhido.
    ...                     Necessita que uma sessão com alias 'serverest' já tenha sido criada.
    ...                     \nReturn: \${response} - a resposta recebida.

    [Arguments]             ${endpoint}    ${json}    ${headers}=&{EMPTY}
    ${response}=            POST On Session    serverest    ${endpoint}    json=${json}    headers=${headers}    expected_status=any
    [Return]                ${response}

Enviar PUT
    [Documentation]         Envia uma requisição PUT contendo o argumento body para o endpoint escolhido.
    ...                     Necessita que uma sessão com alias 'serverest' já tenha sido criada.
    ...                     \nReturn: \${response} - a resposta recebida.

    [Arguments]             ${endpoint}    ${json}    ${headers}=&{EMPTY}
    ${response}=           PUT On Session    serverest    ${endpoint}    json=${json}    headers=${headers}    expected_status=any
    [Return]                ${response}


Obter Dados Login
    [Documentation]         Obtém os campos de email e password de um usuário existente,
    ...                     a partir de sua id.
    ...                     \nReturn: \&{dados_login}
    [Arguments]             ${id_usuario}
    ${response}             Enviar GET    /usuarios/${id_usuario}
    &{dados_login}          Create Dictionary    email=${response.json()["email"]}
    ...                                          password=${response.json()["password"]}
    [Return]                &{dados_login}

Fazer Login
    [Documentation]         Realiza login com o usuário da id informada.
    ...                     Faz validações dentro da keyword.
    ...                     \nReturn: \${token_auth} -- o token de autenticação do usuário logado.
    [Arguments]             ${id_usuario}
    &{login}                Obter Dados Login    ${id_usuario}
    ${response}=            Enviar POST    /login    ${login}
    Validar Login           ${response}
    [Return]                ${response.json()["authorization"]}

Validar Login
    [Documentation]         Valida se um login foi realizado com sucesso.
    [Arguments]             ${response}
    Validar Status Code     200    ${response}
    Validar Mensagem        Login realizado com sucesso    ${response}
    Should Not Be Empty     ${response.json()["authorization"]}

Cadastrar Usuario Estatico
    [Documentation]               Cadastra um novo usuário com os dados json informados.
    ...                           Faz validações dentro da keyword.
    ...                           \nReturn: \${id} -- a id do usuário cadastrado
    [Arguments]                   ${dados_usuario}
    ${response}                   Enviar POST    /usuarios    ${dados_usuario}
    Validar Usuario Cadastrado    ${response}
    [Return]                      ${response.json()["_id"]}

Cadastrar Usuario Dinamico
    [Documentation]               Cadastra um novo usuário com dados dinâmicos.
    ...                           Faz validações dentro da keyword.
    ...                           \nReturn: \${id} -- a id do usuário cadastrado
    [Arguments]                   ${administrador}=true
    ${nome}                       FakerLibrary.Name
    ${email}                      FakerLibrary.Email
    ${password}                   FakerLibrary.Password
    ${dados_usuario}              Create Dictionary    nome=${nome}    email=${email}
    ...                           password=${password}    administrador=${administrador}
    ${id}                         Cadastrar Usuario Estatico    ${dados_usuario}
    [Return]                      ${id}


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

Cadastrar Produto Estatico
    [Documentation]               Cadastra um novo produto com os dados json informados.
    ...                           Faz validações dentro da keyword.
    ...                           \nReturn: \${id} -- a id do produto cadastrado
    [Arguments]                   ${dados_produto}    ${token_auth}
    &{headers}                    Create Dictionary    Authorization=${token_auth}
    ${response}                   Enviar POST    /produtos    ${dados_produto}    headers=${headers}
    Validar Produto Cadastrado    ${response}
    [Return]                      ${response.json()["_id"]}

Cadastrar Produto Dinamico
    [Documentation]               Cadastra um novo produto com dados dinâmicos.
    ...                           Faz validações dentro da keyword.
    ...                           \nReturn: \${id} -- a id do produto cadastrado
    [Arguments]                   ${token_auth}    ${quantidade}=100
    ${nome}                       FakerLibrary.Sentence    nb_words=4
    ${preco}                      FakerLibrary.Random Int    min=1    max=9999
    ${descricao}                  FakerLibrary.Sentence    nb_words=10
    &{dados_produto}              Create Dictionary    nome=${nome}    preco=${preco}
    ...                           descricao=${descricao}    quantidade=${quantidade}
    ${id}                         Cadastrar Produto Estatico    ${dados_produto}    ${token_auth}
    [Return]                      ${id}


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
    [Arguments]                   ${id_produto}    ${token_auth}    ${quantidade}=${3}

    &{produto}                    Create Dictionary    idProduto=${id_produto}    quantidade=${quantidade}
    @{lista}                      Create List          ${produto}
    &{carrinho}                   Create Dictionary    produtos=${lista}

    &{headers}                    Create Dictionary    Authorization=${token_auth}
    ${response}                   Enviar POST    /carrinhos    ${carrinho}    headers=${headers}

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