* Settings *
Documentation    Arquivo contendo os testes para o endpoint /carrinhos da API ServeRest.
Library          RequestsLibrary
Library          Collections    # Append To List
Resource         ../keywords_comuns.robot


* Variables *
${dados_json}         carrinhos_dados.json

* Test Cases *
#########################
#         GET           #
#     CT-C01 ~ CT-C03   #
#########################
CT-C01: GET Todos Os Carrinhos 200
    [Documentation]        Teste de listar todos os carrinhos com sucesso.
    [Tags]                 GET    STATUS-2XX
    ##########
    # Setup
    Criar Sessao

    ##########
    # Teste
    ${response}            Enviar GET    /carrinhos

    Validar Status Code    200    ${response}
    Log To Console         ${response.json()}


CT-C02: GET Buscar Carrinho Existente 200
    [Documentation]       Teste de buscar carrinho por id.
    [Tags]                GET    STATUS-2XX
    ##########
    # Setup
    Criar Sessao
    ${json}                Carregar JSON    ${dados_json}

    # Criar Usuário
    ${id_usuario}          Cadastrar Usuario Dinamico    administrador=true
    ${token_auth}          Fazer Login                   ${id_usuario}
    &{headers}             Create Dictionary             Authorization=${token_auth}

    # Criar Produto
    ${id_produto}          Cadastrar Produto Dinamico    ${token_auth}

    # Criar Carrinho
    &{produto}             Create Dictionary    idProduto=${id_produto}    quantidade=${3}
    @{lista_produtos}      Create List          ${produto}
    &{carrinho}            Create Dictionary    produtos=${lista_produtos}

    ${response}            Enviar POST    /carrinhos    ${carrinho}    headers=${headers}
    Validar Status Code    201    ${response}
    ${id_carrinho}         Set Variable    ${response.json()["_id"]}

    ##########
    # Teste
    ${response}            Enviar GET    /carrinhos/${id_carrinho}
    
    Validar Status Code    200    ${response}
    Validar Carrinho       ${response.json()}    @{lista_produtos}
    Should Be Equal        ${response.json()["idUsuario"]}    ${id_usuario}


    #########################
    # Limpeza dos dados
    [Teardown]            Run Keywords        Cancelar Compra    ${token_auth}
    ...                   AND                 Deletar Produto    ${id_produto}    ${token_auth}
    ...                   AND                 Deletar Usuario    ${id_usuario}


CT-C03: GET Buscar Carrinho Inexistente 400
    [Documentation]       Teste de buscar carrinho por id inexistente.
    [Tags]                GET    STATUS-4XX
    ##########
    # Setup
    Criar Sessao
    ${json}                Carregar JSON    ${dados_json}

    ${id_carrinho}         Set Variable    naoexiste9283

    ##########
    # Teste
    ${response}            Enviar GET    /carrinhos/${id_carrinho}

    Validar Status Code    400    ${response}
    Validar Mensagem       Carrinho não encontrado    ${response}


#########################
#         POST          #
#     CT-C04 ~ CT-C14   #
#########################
CT-C04: POST Cadastrar Carrinho Como Administrador 201
    [Documentation]        Teste de cadastrar novo carrinho com usuário administrador.
    [Tags]                 POST    STATUS-2XX
    ##########
    # Setup
    Criar Sessao
    ${json}                Carregar JSON    ${dados_json}

    # Criar Usuário
    ${id_usuario}          Cadastrar Usuario Dinamico    administrador=true
    ${token_auth}          Fazer Login                   ${id_usuario}
    &{headers}             Create Dictionary             Authorization=${token_auth}

    # Criar Produtos
    ${id_produto_1}        Cadastrar Produto Dinamico    ${token_auth}
    ${id_produto_2}        Cadastrar Produto Dinamico    ${token_auth}

    # Criar dados do Carrinho
    &{produto_1}           Create Dictionary    idProduto=${id_produto_1}    quantidade=${3}
    &{produto_2}           Create Dictionary    idProduto=${id_produto_2}    quantidade=${1}
    @{lista_produtos}      Create List          ${produto_1}    ${produto_2}
    &{carrinho}            Create Dictionary    produtos=${lista_produtos}


    ##########
    # Teste
    ${response}            Enviar POST    /carrinhos    ${carrinho}    headers=${headers}

    Validar Status Code    201    ${response}
    Validar Mensagem       Cadastro realizado com sucesso    ${response}
    Should Not Be Empty    ${response.json()["_id"]}

    # Validar se o carrinho foi realmente criado
    ${id_carrinho}         Set Variable    ${response.json()["_id"]}

    ${response}            Enviar GET    /carrinhos/${id_carrinho}

    Validar Status Code    200    ${response}
    Validar Carrinho       ${response.json()}    @{lista_produtos}
    Should Be Equal        ${response.json()["idUsuario"]}    ${id_usuario}

    #########################
    # Limpeza dos dados
    [Teardown]            Run Keywords        Cancelar Compra    ${token_auth}
    ...                   AND                 Deletar Produto    ${id_produto_1}    ${token_auth}
    ...                   AND                 Deletar Produto    ${id_produto_2}    ${token_auth}
    ...                   AND                 Deletar Usuario    ${id_usuario}


CT-C05: POST Cadastrar Carrinho Como Usuario Padrao 201
    [Documentation]        Teste de cadastrar novo carrinho com usuário não-administrador.
    [Tags]                 POST    STATUS-2XX
    ##########
    # Setup
    Criar Sessao
    ${json}                Carregar JSON    ${dados_json}

    # Criar usuários
    ${id_user_admin}       Cadastrar Usuario Dinamico    administrador=true
    ${token_auth_admin}    Fazer Login                   ${id_user_admin}

    ${id_user_padrao}      Cadastrar Usuario Dinamico    administrador=false
    ${token_auth_padrao}   Fazer Login                   ${id_user_padrao}
    &{headers}             Create Dictionary             Authorization=${token_auth_padrao}
    
    # Criar produtos
    ${id_produto_1}        Cadastrar Produto Dinamico    ${token_auth_admin}
    ${id_produto_2}        Cadastrar Produto Dinamico    ${token_auth_admin}

    # Criar dados do Carrinho
    &{produto_1}           Create Dictionary    idProduto=${id_produto_1}    quantidade=${3}
    &{produto_2}           Create Dictionary    idProduto=${id_produto_2}    quantidade=${1}
    @{lista_produtos}      Create List          ${produto_1}    ${produto_2}
    &{carrinho}            Create Dictionary    produtos=${lista_produtos}
    

    ##########
    # Teste
    ${response}            Enviar POST    /carrinhos    ${carrinho}    headers=${headers}

    Validar Status Code    201    ${response}
    Validar Mensagem       Cadastro realizado com sucesso    ${response}
    Should Not Be Empty    ${response.json()["_id"]}

    # Validar se o carrinho foi realmente criado
    ${id_carrinho}         Set Variable    ${response.json()["_id"]}

    ${response}            Enviar GET    /carrinhos/${id_carrinho}

    Validar Status Code    200    ${response}
    Validar Carrinho       ${response.json()}    @{lista_produtos}
    Should Be Equal        ${response.json()["idUsuario"]}    ${id_user_padrao}

    #########################
    # Limpeza dos dados
    [Teardown]            Run Keywords        Cancelar Compra    ${token_auth_padrao}
    ...                   AND                 Deletar Produto    ${id_produto_1}    ${token_auth_admin}
    ...                   AND                 Deletar Produto    ${id_produto_2}    ${token_auth_admin}
    ...                   AND                 Deletar Usuario    ${id_user_admin}
    ...                   AND                 Deletar Usuario    ${id_user_padrao}


CT-C06: POST Tentar Cadastrar Carrinho Com Produto Duplicado 400
    [Documentation]        Teste de cadastrar um carrinho com produto duplicado.
    [Tags]                 POST    STATUS-4XX
    ##########
    # Setup
    Criar Sessao
    ${json}                Carregar JSON    ${dados_json}

    # Criar usuário
    ${id_usuario}          Cadastrar Usuario Dinamico    administrador=true
    ${token_auth}          Fazer Login                   ${id_usuario}
    &{headers}             Create Dictionary             Authorization=${token_auth}

    # Criar produto
    ${id_produto}          Cadastrar Produto Dinamico    ${token_auth}

    # Criar dados do Carrinho
    &{produto_1}           Create Dictionary    idProduto=${id_produto}    quantidade=${3}
    &{produto_2}           Create Dictionary    idProduto=${id_produto}    quantidade=${1}
    @{lista_produtos}      Create List          ${produto_1}    ${produto_2}
    &{carrinho}            Create Dictionary    produtos=${lista_produtos}

    ##########
    # Teste
    ${response}            Enviar POST    /carrinhos    ${carrinho}    headers=${headers}

    Validar Status Code    400    ${response}
    Validar Mensagem       Não é permitido possuir produto duplicado    ${response}

    #########################
    # Limpeza dos dados
    [Teardown]            Run Keywords        Deletar Produto    ${id_produto}    ${token_auth}
    ...                   AND                 Deletar Usuario    ${id_usuario}


CT-C07: POST Tentar Cadastrar Mais De Um Carrinho Com Um Usuario 400
    [Documentation]        Teste de cadastrar dois carrinhos com um único usuário.
    [Tags]                 POST    STATUS-4XX
    ##########
    # Setup
    Criar Sessao
    ${json}                Carregar JSON    ${dados_json}

    # Criar usuário
    ${id_usuario}          Cadastrar Usuario Dinamico    administrador=true
    ${token_auth}          Fazer Login                   ${id_usuario}
    &{headers}             Create Dictionary             Authorization=${token_auth}

    # Criar produtos
    ${id_produto_1}        Cadastrar Produto Dinamico    ${token_auth}
    ${id_produto_2}        Cadastrar Produto Dinamico    ${token_auth}

    # Criar dados dos Carrinhos 
    &{produto_1}           Create Dictionary    idProduto=${id_produto_1}    quantidade=${3}
    @{lista_produtos}      Create List          ${produto_1}
    &{carrinho_1}          Create Dictionary    produtos=${lista_produtos}

    &{produto_2}           Create Dictionary    idProduto=${id_produto_2}    quantidade=${1}
    @{lista_produtos}      Create List          ${produto_2}
    &{carrinho_2}          Create Dictionary    produtos=${lista_produtos}

    ${response}            Enviar POST    /carrinhos    ${carrinho_1}    headers=${headers}
    Validar Status Code    201    ${response}

    ##########
    # Teste
    ${response}            Enviar POST    /carrinhos    ${carrinho_2}    headers=${headers}

    Validar Status Code    400    ${response}
    Validar Mensagem       Não é permitido ter mais de 1 carrinho    ${response}

    #########################
    # Limpeza dos dados
    [Teardown]            Run Keywords        Cancelar Compra    ${token_auth}
    ...                   AND                 Deletar Produto    ${id_produto_1}    ${token_auth}
    ...                   AND                 Deletar Produto    ${id_produto_2}    ${token_auth}
    ...                   AND                 Deletar Usuario    ${id_usuario}


CT-C08: POST Tentar Cadastrar Um Carrinho Com Produto Inexistente 400
    [Documentation]        Teste de cadastrar um carrinho que contém id de produto inexistente.
    [Tags]                 POST    STATUS-4XX
    ##########
    # Setup
    Criar Sessao
    ${json}                Carregar JSON    ${dados_json}

    # Criar Usuário
    ${id_usuario}          Cadastrar Usuario Dinamico    administrador=true
    ${token_auth}          Fazer Login                   ${id_usuario}
    &{headers}             Create Dictionary             Authorization=${token_auth}

    # Id de produto inexistente
    ${id_produto_1}        Set Variable    naoexiste123
    
    # Criar dados do Carrinho
    &{produto_1}           Create Dictionary    idProduto=${id_produto_1}    quantidade=${3}
    @{lista_produtos}      Create List          ${produto_1}
    &{carrinho}            Create Dictionary    produtos=${lista_produtos}

    ##########
    # Teste
    ${response}            Enviar POST    /carrinhos    ${carrinho}    headers=${headers}

    Validar Status Code    400    ${response}
    Validar Mensagem       Produto não encontrado    ${response}

    #########################
    # Limpeza dos dados
    [Teardown]            Deletar Usuario    ${id_usuario}


CT-C09: POST Tentar Cadastrar Carrinho Sem Quantidade De Produto Suficiente 400
    [Documentation]        Teste de cadastrar novo carrinho com quantidade de produtos maior do que o estoque.
    [Tags]                 POST    STATUS-4XX
    ##########
    # Setup
    Criar Sessao
    ${json}                Carregar JSON    ${dados_json}

    # Criar Usuário
    ${id_usuario}          Cadastrar Usuario Dinamico    administrador=true
    ${token_auth}          Fazer Login                   ${id_usuario}
    &{headers}             Create Dictionary             Authorization=${token_auth}

    # Criar Produto
    ${id_produto}          Cadastrar Produto Dinamico    ${token_auth}    quantidade=${5}

    # Criar dados do Carrinho
    &{produto}             Create Dictionary    idProduto=${id_produto}    quantidade=${100}
    @{lista_produtos}      Create List          ${produto}
    &{carrinho}            Create Dictionary    produtos=${lista_produtos}

    ##########
    # Teste
    ${response}            Enviar POST    /carrinhos    ${carrinho}    headers=${headers}

    Validar Status Code    400    ${response}
    Validar Mensagem       Produto não possui quantidade suficiente    ${response}
    
    #########################
    # Limpeza dos dados
    [Teardown]            Run Keywords        Deletar Produto    ${id_produto}    ${token_auth}
    ...                   AND                 Deletar Usuario    ${id_usuario}


CT-C10: POST Tentar Cadastrar Carrinho Sem Login 401
    [Documentation]        Teste de cadastrar novo carrinho sem ter feito login.
    [Tags]                 POST    STATUS-4XX
    ##########
    # Setup
    Criar Sessao
    ${json}                Carregar JSON    ${dados_json}

    # Criar Usuário
    ${id_usuario}          Cadastrar Usuario Dinamico    administrador=true
    ${token_auth}          Fazer Login                   ${id_usuario}

    # Criar Produto
    ${id_produto}          Cadastrar Produto Dinamico    ${token_auth}

    # Criar dados do Carrinho
    &{produto}             Create Dictionary    idProduto=${id_produto}    quantidade=${3}
    @{lista_produtos}      Create List          ${produto}
    &{carrinho}            Create Dictionary    produtos=${lista_produtos}

    ##########
    # Teste
    ${response}            Enviar POST    /carrinhos    ${carrinho}

    Validar Status Code    401    ${response}
    Validar Mensagem       Token de acesso ausente, inválido, expirado ou usuário do token não existe mais
    ...                    ${response}

    #########################
    # Limpeza dos dados
    [Teardown]            Run Keywords        Deletar Produto    ${id_produto}    ${token_auth}
    ...                   AND                 Deletar Usuario    ${id_usuario}


##############################################
# CT-C11 ~ CT-C14: Testes de dados inválidos #
##############################################
CT-C11: POST Tentar Cadastrar Carrinho Com IdProduto Em Branco 400
    [Documentation]        Teste de cadastrar novo carrinho com idProduto em branco.
    [Tags]                 POST    STATUS-4XX
    ##########
    # Setup
    Criar Sessao
    ${json}                Carregar JSON    ${dados_json}

    # Criar Usuário
    ${id_usuario}          Cadastrar Usuario Dinamico    administrador=true
    ${token_auth}          Fazer Login                   ${id_usuario}
    &{headers}             Create Dictionary             Authorization=${token_auth}

    # Criar dados do Carrinho
    &{produto}             Create Dictionary    idProduto=""    quantidade=${100}
    @{lista_produtos}      Create List          ${produto}
    &{carrinho}            Create Dictionary    produtos=${lista_produtos}

    ##########
    # Teste
    ${response}            Enviar POST    /carrinhos    ${carrinho}    headers=${headers}

    Validar Status Code    400    ${response}
    Log To Console         ${response.json()}

    #########################
    # Limpeza dos dados
    [Teardown]            Deletar Usuario    ${id_usuario}


CT-C12: POST Tentar Cadastrar Carrinho Sem IdProduto 400
    [Documentation]        Teste de cadastrar novo carrinho sem campo de idProduto.
    [Tags]                 POST    STATUS-4XX
    ##########
    # Setup
    Criar Sessao
    ${json}                Carregar JSON    ${dados_json}

    # Criar Usuário
    ${id_usuario}          Cadastrar Usuario Dinamico    administrador=true
    ${token_auth}          Fazer Login                   ${id_usuario}
    &{headers}             Create Dictionary             Authorization=${token_auth}

    # Criar dados do Carrinho
    &{produto}             Create Dictionary    quantidade=${100}
    @{lista_produtos}      Create List          ${produto}
    &{carrinho}            Create Dictionary    produtos=${lista_produtos}

    ##########
    # Teste
    ${response}            Enviar POST    /carrinhos    ${carrinho}    headers=${headers}

    Validar Status Code    400    ${response}    
    Log To Console         ${response.json()}

    #########################
    # Limpeza dos dados
    [Teardown]            Deletar Usuario    ${id_usuario}


CT-C13: POST Tentar Cadastrar Carrinho Com Quantidade Em Branco 400
    [Documentation]        Teste de cadastrar novo carrinho com quantidade em branco.
    [Tags]                 POST    STATUS-4XX
    ##########
    # Setup
    Criar Sessao
    ${json}                Carregar JSON    ${dados_json}

    # Criar Usuário
    ${id_usuario}          Cadastrar Usuario Dinamico    administrador=true
    ${token_auth}          Fazer Login                   ${id_usuario}
    &{headers}             Create Dictionary             Authorization=${token_auth}

    # Criar Produto
    ${id_produto}          Cadastrar Produto Dinamico    ${token_auth}

    # Criar dados do Carrinho
    &{produto}             Create Dictionary    idProduto=${id_produto}    quantidade=""
    @{lista_produtos}      Create List          ${produto}
    &{carrinho}            Create Dictionary    produtos=${lista_produtos}

    ##########
    # Teste
    ${response}            Enviar POST    /carrinhos    ${carrinho}    headers=${headers}

    Validar Status Code    400    ${response}    
    Log To Console         ${response.json()}

    #########################
    # Limpeza dos dados
    [Teardown]            Run Keywords        Deletar Produto    ${id_produto}    ${token_auth}
    ...                   AND                 Deletar Usuario    ${id_usuario}


CT-C14: POST Tentar Cadastrar Carrinho Sem Quantidade 400
    [Documentation]        Teste de cadastrar novo carrinho sem campo de quantidade.
    [Tags]                 POST    STATUS-4XX
    ##########
    # Setup
    Criar Sessao
    ${json}                Carregar JSON    ${dados_json}

    # Criar Usuário
    ${id_usuario}          Cadastrar Usuario Dinamico    administrador=true
    ${token_auth}          Fazer Login                   ${id_usuario}
    &{headers}             Create Dictionary             Authorization=${token_auth}

    # Criar Produto
    ${id_produto}          Cadastrar Produto Dinamico    ${token_auth}

    # Criar dados do Carrinho
    &{produto}             Create Dictionary    idProduto=${id_produto}
    @{lista_produtos}      Create List          ${produto}
    &{carrinho}            Create Dictionary    produtos=${lista_produtos}

    ##########
    # Teste
    ${response}            Enviar POST    /carrinhos    ${carrinho}    headers=${headers}

    Validar Status Code    400    ${response}
    Log To Console         ${response.json()}    

    #########################
    # Limpeza dos dados
    [Teardown]            Run Keywords        Deletar Produto    ${id_produto}    ${token_auth}
    ...                   AND                 Deletar Usuario    ${id_usuario}


#########################
#         DELETE        #
#     CT-C15 ~ CT-C20   #
#########################
CT-C15: DELETE Concluir Compra Com Carrinho Existente 200
    [Documentation]       Teste de concluir compra com carrinho existente com sucesso.
    [Tags]                DELETE    STATUS-2XX
    ##########
    # Setup
    Criar Sessao
    ${json}                   Carregar JSON    ${dados_json}

    # Criar Usuário
    ${id_usuario}             Cadastrar Usuario Dinamico    administrador=true
    ${token_auth}             Fazer Login                   ${id_usuario}
    &{headers}                Create Dictionary             Authorization=${token_auth}

    # Criar Produto
    ${quantidade_estoque}     Set Variable         ${100}
    ${id_produto}             Cadastrar Produto Dinamico    ${token_auth}    quantidade=${quantidade_estoque}
    

    # Criar Carrinho
    ${quantidade_carrinho}    Set Variable         ${3}
    ${id_carrinho}            Cadastrar Carrinho    ${id_produto}    ${token_auth}    ${quantidade_carrinho}

    ##########
    # Teste
    ${response}                Enviar DELETE    /carrinhos/concluir-compra    headers=${headers}

    Validar Status Code        200    ${response}
    Validar Mensagem           Registro excluído com sucesso    ${response}

    # Verificar se o carrinho foi realmente excluído
    ${response}            Enviar GET    /carrinhos/${id_carrinho}

    Validar Status Code    400    ${response}
    Validar Mensagem       Carrinho não encontrado    ${response}

    # Verificar se o estoque NÃO foi reabastecido
    ${response}             Enviar GET      /produtos/${id_produto}

    ${novo_estoque}         Set Variable    ${response.json()["quantidade"]}
    Should Be Equal As Integers         ${novo_estoque}    ${${quantidade_estoque}-${quantidade_carrinho}}

    #########################
    # Limpeza dos dados
    [Teardown]            Run Keywords        Deletar Produto    ${id_produto}    ${token_auth}
    ...                   AND                 Deletar Usuario    ${id_usuario}


CT-C16: DELETE Cancelar Compra Com Carrinho Existente 200
    [Documentation]       Teste de cancelar compra com carrinho existente com sucesso.
    [Tags]                DELETE    STATUS-2XX
    ##########
    # Setup
    Criar Sessao
    ${json}                   Carregar JSON    ${dados_json}

    # Criar Usuário
    ${id_usuario}             Cadastrar Usuario Dinamico    administrador=true
    ${token_auth}             Fazer Login                   ${id_usuario}
    &{headers}                Create Dictionary             Authorization=${token_auth}

    # Criar Produto
    ${quantidade_estoque}     Set Variable         ${100}
    ${id_produto}             Cadastrar Produto Dinamico    ${token_auth}    quantidade=${quantidade_estoque}

    # Criar Carrinho
    ${quantidade_carrinho}    Set Variable         ${3}
    ${id_carrinho}            Cadastrar Carrinho    ${id_produto}    ${token_auth}    ${quantidade_carrinho}

    ##########
    # Teste
    ${response}                Enviar DELETE    /carrinhos/cancelar-compra    headers=${headers}

    Validar Status Code        200    ${response}
    Validar Mensagem Contem    Registro excluído com sucesso    ${response}

    # Verificar se o carrinho foi realmente excluído
    ${response}            Enviar GET    /carrinhos/${id_carrinho}

    Validar Status Code    400    ${response}
    Validar Mensagem       Carrinho não encontrado    ${response}

    # Verificar se o estoque FOI reabastecido
    ${response}             Enviar GET    /produtos/${id_produto}

    ${novo_estoque}         Set Variable    ${response.json()["quantidade"]}
    Should Be Equal As Integers         ${novo_estoque}    ${${quantidade_estoque}}

    #########################
    # Limpeza dos dados
    [Teardown]            Run Keywords        Deletar Produto    ${id_produto}    ${token_auth}
    ...                   AND                 Deletar Usuario    ${id_usuario}


CT-C17: DELETE Tentar Concluir Compra Sem Carrinho 200
    [Documentation]       Teste de concluir compra com usuário sem carrinho.
    [Tags]                DELETE    STATUS-2XX
    ##########
    # Setup
    Criar Sessao
    ${json}                Carregar JSON    ${dados_json}

    # Criar Usuário
    ${id_usuario}          Cadastrar Usuario Dinamico    administrador=true
    ${token_auth}          Fazer Login                   ${id_usuario}
    &{headers}             Create Dictionary             Authorization=${token_auth}

    ##########
    # Teste
    ${response}            Enviar DELETE    /carrinhos/concluir-compra    headers=${headers}

    Validar Status Code    200    ${response}
    Validar Mensagem       Não foi encontrado carrinho para esse usuário    ${response}

    #########################
    # Limpeza dos dados
    [Teardown]            Deletar Usuario    ${id_usuario}


CT-C18: DELETE Tentar Cancelar Compra Sem Carrinho 200
    [Documentation]       Teste de cancelar compra com usuário sem carrinho.
    [Tags]                DELETE    STATUS-2XX
    ##########
    # Setup
    Criar Sessao
    ${json}                Carregar JSON    ${dados_json}

    # Criar Usuário
    ${id_usuario}          Cadastrar Usuario Dinamico    administrador=true
    ${token_auth}          Fazer Login                   ${id_usuario}
    &{headers}             Create Dictionary             Authorization=${token_auth}
    
    ##########
    # Teste
    ${response}            Enviar DELETE    /carrinhos/cancelar-compra    headers=${headers}

    Validar Status Code    200    ${response}
    Validar Mensagem       Não foi encontrado carrinho para esse usuário    ${response}

    #########################
    # Limpeza dos dados
    [Teardown]            Deletar Usuario    ${id_usuario}


CT-C19: DELETE Tentar Concluir Compra Sem Login 401
    [Documentation]       Teste de concluir compra sem ter feito login.
    [Tags]                DELETE    STATUS-401
    ##########
    # Setup
    Criar Sessao

    ##########
    # Teste
    ${response}                Enviar DELETE    /carrinhos/concluir-compra

    Validar Status Code        401    ${response}
    Validar Mensagem           Token de acesso ausente, inválido, expirado ou usuário do token não existe mais
    ...                        ${response}


CT-C20: DELETE Tentar Cancelar Compra Sem Login 401
    [Documentation]       Teste de cancelar compra sem ter feito login.
    [Tags]                DELETE    STATUS-4XX
    ##########
    # Setup
    Criar Sessao

    ##########
    # Teste
    ${response}                Enviar DELETE    /carrinhos/cancelar-compra

    Validar Status Code        401    ${response}
    Validar Mensagem           Token de acesso ausente, inválido, expirado ou usuário do token não existe mais
    ...                        ${response}


##########################################################################################

* Keywords *
    
Validar Carrinho
    [Documentation]    Verifica se os dados de um carrinho correspondem ao esperado
    [Arguments]    ${carrinho}    @{lista_produtos}    
    ${len_lista}=                   Get Length    ${lista_produtos}
    ${len_produtos}=                Get Length    ${carrinho["produtos"]}
    Should Be Equal As Integers     ${len_lista}    ${len_produtos}

    ${preco_total_lista}=           Set Variable    ${0}
    ${quantidade_total_lista}=      Set Variable    ${0}

    FOR  ${index}  IN RANGE    ${len_lista}
        ${produto_carrinho}=            Set Variable    ${carrinho["produtos"][${index}]}
        ${produto_lista}=               Set Variable    ${lista_produtos[${index}]}
        Should Be Equal                 ${produto_carrinho["idProduto"]}    ${produto_lista["idProduto"]}
        Should Be Equal As Integers     ${produto_carrinho["quantidade"]}    ${produto_lista["quantidade"]}

        ${response}=           Enviar GET    /produtos/${produto_lista["idProduto"]}
        ${preco_produto}=      Set Variable    ${response.json()["preco"]}
        Should Be Equal        ${produto_carrinho["precoUnitario"]}    ${preco_produto}

        ${preco_total_lista}=         Evaluate    ${preco_total_lista}+(${${preco_produto}}*${${produto_lista["quantidade"]}})
        ${quantidade_total_lista}=    Evaluate    ${quantidade_total_lista}+${${produto_lista["quantidade"]}}
    END

    Should Be Equal    ${carrinho["precoTotal"]}    ${preco_total_lista}
    Should Be Equal    ${carrinho["quantidadeTotal"]}    ${quantidade_total_lista}
    