* Settings *
Documentation    Arquivo contendo os casos de teste para o endpoint /carrinhos.
Resource         ../keywords/carrinhos_keywords.robot

Suite Setup      Criar Sessao

* Test Cases *
#########################
#         GET           #
#     CT-C01 ~ CT-C03   #
#########################
CT-C01: GET Todos Os Carrinhos 200
    [Documentation]    Teste de listar todos os carrinhos com sucesso.
    [Tags]             GET    STATUS-2XX
    
    ${response}            Enviar GET    /carrinhos

    Validar Status Code    200    ${response}
    Log To Console         ${response.json()}


CT-C02: GET Buscar Carrinho Existente 200
    [Documentation]    Teste de buscar carrinho por id.
    [Tags]             GET    STATUS-2XX

    [Setup]            Run Keywords
    ...                Preparar Novo Usuario Dinamico    user_admin    administrador=true
    ...    AND         Preparar Novo Produto Dinamico    produto       quantidade=${100}

    ${token_auth}                Fazer Login                     ${registro_usuarios.user_admin}
    &{headers}                   Create Dictionary               Authorization=${token_auth}

    # Criar Carrinho
    &{produto}                   Create Dictionary    idProduto=${registro_produtos.produto}    quantidade=${3}
    @{lista_produtos}            Create List          ${produto}
    &{carrinho}                  Create Dictionary    produtos=${lista_produtos}

    ${response}                  Enviar POST    /carrinhos    ${carrinho}    headers=${headers}
    Validar Status Code          201    ${response}
    ${id_carrinho}               Set Variable    ${response.json()["_id"]}


    ${response}                  Enviar GET    /carrinhos/${id_carrinho}
    
    Validar Status Code          200    ${response}
    Validar Dados De Carrinho    ${response.json()}    ${registro_usuarios.user_admin}    @{lista_produtos}

    [Teardown]        Run Keywords        
    ...               Cancelar Compra    ${token_auth}
    ...    AND        Limpar Registro De Produtos
    ...    AND        Limpar Registro De Usuarios    


CT-C03: GET Buscar Carrinho Inexistente 400
    [Documentation]    Teste de buscar carrinho por id inexistente.
    [Tags]             GET    STATUS-4XX
    
    ${id_carrinho}         Set Variable    naoexiste9283

    ${response}            Enviar GET    /carrinhos/${id_carrinho}

    Validar Status Code    400    ${response}
    Validar Mensagem       Carrinho n??o encontrado    ${response}


#########################
#         POST          #
#     CT-C04 ~ CT-C12   #
#########################
CT-C04: POST Cadastrar Carrinho Como Administrador 201
    [Documentation]    Teste de cadastrar novo carrinho com usu??rio administrador.
    [Tags]             POST    STATUS-2XX
    
    [Setup]            Run Keywords
    ...                Preparar Novo Usuario Dinamico    user_admin    administrador=true
    ...    AND         Preparar Novo Produto Dinamico    produto_1
    ...    AND         Preparar Novo Produto Dinamico    produto_2

    ${token_auth}          Fazer Login                     ${registro_usuarios.user_admin}
    &{headers}             Create Dictionary               Authorization=${token_auth}

    # Criar dados do Carrinho
    &{produto_1}           Create Dictionary    idProduto=${registro_produtos.produto_1}    quantidade=${3}
    &{produto_2}           Create Dictionary    idProduto=${registro_produtos.produto_2}    quantidade=${1}
    @{lista_produtos}      Create List          ${produto_1}    ${produto_2}
    &{carrinho}            Create Dictionary    produtos=${lista_produtos}

    ${response}            Enviar POST    /carrinhos    ${carrinho}    headers=${headers}

    Validar Status Code    201    ${response}
    Validar Mensagem       Cadastro realizado com sucesso    ${response}
    Should Not Be Empty    ${response.json()["_id"]}

    # Verifica se o carrinho foi realmente criado
    Validar Carrinho       ${response.json()["_id"]}    ${registro_usuarios.user_admin}    @{lista_produtos}

    [Teardown]         Run Keywords        
    ...                Cancelar Compra    ${token_auth}
    ...    AND         Limpar Registro De Produtos
    ...    AND         Limpar Registro De Usuarios

CT-C05: POST Cadastrar Carrinho Como Usuario Padrao 201
    [Documentation]    Teste de cadastrar novo carrinho com usu??rio n??o-administrador.
    [Tags]             POST    STATUS-2XX

    [Setup]            Run Keywords
    ...                Preparar Novo Usuario Dinamico    user_padrao    administrador=false
    ...    AND         Preparar Novo Produto Dinamico    produto_1
    ...    AND         Preparar Novo Produto Dinamico    produto_2
    
    # Criar dados do Carrinho
    &{produto_1}           Create Dictionary    idProduto=${registro_produtos.produto_1}    quantidade=${3}
    &{produto_2}           Create Dictionary    idProduto=${registro_produtos.produto_2}    quantidade=${1}
    @{lista_produtos}      Create List          ${produto_1}    ${produto_2}
    &{carrinho}            Create Dictionary    produtos=${lista_produtos}
    
    ${token_auth}          Fazer Login                     ${registro_usuarios.user_padrao}
    &{headers}             Create Dictionary               Authorization=${token_auth}

    ${response}            Enviar POST    /carrinhos    ${carrinho}    headers=${headers}

    Validar Status Code    201    ${response}
    Validar Mensagem       Cadastro realizado com sucesso    ${response}
    Should Not Be Empty    ${response.json()["_id"]}

    # Validar se o carrinho foi realmente criado
    Validar Carrinho       ${response.json()["_id"]}    ${registro_usuarios.user_padrao}    @{lista_produtos}
    
    [Teardown]         Run Keywords        
    ...                Cancelar Compra    ${token_auth}
    ...    AND         Limpar Registro De Produtos
    ...    AND         Limpar Registro De Usuarios


CT-C06: POST Tentar Cadastrar Carrinho Com Produto Duplicado 400
    [Documentation]    Teste de cadastrar um carrinho com produto duplicado.
    [Tags]             POST    STATUS-4XX
    
    [Setup]            Run Keywords
    ...                Preparar Novo Usuario Dinamico    user_admin    administrador=true
    ...    AND         Preparar Novo Produto Dinamico    produto_1

    # Criar dados do Carrinho
    &{produto_1}                   Create Dictionary    idProduto=${registro_produtos.produto_1}    quantidade=${3}
    &{produto_2}                   Create Dictionary    idProduto=${registro_produtos.produto_1}    quantidade=${1}
    @{lista_produtos}              Create List          ${produto_1}    ${produto_2}
    &{carrinho}                    Create Dictionary    produtos=${lista_produtos}

    ${token_auth}                  Fazer Login                     ${registro_usuarios.user_admin}
    &{headers}                     Create Dictionary               Authorization=${token_auth}

    ${num_carrinhos_inicial}       Obter Quantidade De Carrinhos

    ${response}                    Enviar POST    /carrinhos    ${carrinho}    headers=${headers}

    Validar Status Code            400    ${response}
    Validar Mensagem               N??o ?? permitido possuir produto duplicado    ${response}

    # Verifica se a quantidade de carrinhos permanece a mesma.
    ${num_carrinhos_final}         Obter Quantidade De Carrinhos
    Should Be Equal As Integers    ${num_carrinhos_inicial}    ${num_carrinhos_final}

    [Teardown]            Run Keywords
    ...                   Limpar Registro De Produtos
    ...    AND            Limpar Registro De Usuarios


CT-C07: POST Tentar Cadastrar Mais De Um Carrinho Com Um Usuario 400
    [Documentation]    Teste de cadastrar dois carrinhos com um ??nico usu??rio.
    [Tags]             POST    STATUS-4XX
    
    [Setup]            Run Keywords
    ...                Preparar Novo Usuario Dinamico    user_admin    administrador=true
    ...    AND         Preparar Novo Produto Dinamico    produto_1
    ...    AND         Preparar Novo Produto Dinamico    produto_2    

    # Criar dados dos Carrinhos 
    &{produto_1}                   Create Dictionary    idProduto=${registro_produtos.produto_1}    quantidade=${3}
    @{lista_produtos}              Create List          ${produto_1}
    &{carrinho_1}                  Create Dictionary    produtos=${lista_produtos}

    &{produto_2}                   Create Dictionary    idProduto=${registro_produtos.produto_2}    quantidade=${1}
    @{lista_produtos}              Create List          ${produto_2}
    &{carrinho_2}                  Create Dictionary    produtos=${lista_produtos}

    ${token_auth}                  Fazer Login                     ${registro_usuarios.user_admin}
    &{headers}                     Create Dictionary               Authorization=${token_auth}

    ${response}                    Enviar POST    /carrinhos    ${carrinho_1}    headers=${headers}
    Validar Status Code            201    ${response}

    ${num_carrinhos_inicial}       Obter Quantidade De Carrinhos

    ${response}                    Enviar POST    /carrinhos    ${carrinho_2}    headers=${headers}

    Validar Status Code            400    ${response}
    Validar Mensagem               N??o ?? permitido ter mais de 1 carrinho    ${response}

    # Verifica se a quantidade de carrinhos permanece a mesma.
    ${num_carrinhos_final}         Obter Quantidade De Carrinhos
    Should Be Equal As Integers    ${num_carrinhos_inicial}    ${num_carrinhos_final}

    [Teardown]         Run Keywords
    ...                Cancelar Compra    ${token_auth}
    ...    AND         Limpar Registro De Produtos
    ...    AND         Limpar Registro De Usuarios


CT-C08: POST Tentar Cadastrar Um Carrinho Com Produto Inexistente 400
    [Documentation]    Teste de cadastrar um carrinho que cont??m id de produto inexistente.
    [Tags]             POST    STATUS-4XX
    
    [Setup]            Preparar Novo Usuario Dinamico    user_admin    administrador=true
    
    ${id_produto}                  Set Variable    naoexiste123
    
    # Criar dados do Carrinho
    &{produto}                     Create Dictionary    idProduto=${id_produto}    quantidade=${3}
    @{lista_produtos}              Create List          ${produto}
    &{carrinho}                    Create Dictionary    produtos=${lista_produtos}

    ${token_auth}                  Fazer Login                     ${registro_usuarios.user_admin}
    &{headers}                     Create Dictionary               Authorization=${token_auth}

    ${num_carrinhos_inicial}       Obter Quantidade De Carrinhos

    ${response}                    Enviar POST    /carrinhos    ${carrinho}    headers=${headers}

    Validar Status Code            400    ${response}
    Validar Mensagem               Produto n??o encontrado    ${response}

    # Verifica se a quantidade de carrinhos permanece a mesma.
    ${num_carrinhos_final}         Obter Quantidade De Carrinhos
    Should Be Equal As Integers    ${num_carrinhos_inicial}    ${num_carrinhos_final}
    
    [Teardown]         Limpar Registro De Usuarios


CT-C09: POST Tentar Cadastrar Carrinho Sem Quantidade De Produto Suficiente 400
    [Documentation]    Teste de cadastrar novo carrinho com quantidade de produtos maior do que o estoque.
    [Tags]             POST    STATUS-4XX
    
    [Setup]            Run Keywords
    ...                Preparar Novo Usuario Dinamico    user_admin    administrador=true
    ...    AND         Preparar Novo Produto Dinamico    produto_1     quantidade=${5}

    # Criar dados do Carrinho
    &{produto}                     Create Dictionary    idProduto=${registro_produtos.produto_1}    quantidade=${100}
    @{lista_produtos}              Create List          ${produto}
    &{carrinho}                    Create Dictionary    produtos=${lista_produtos}

    ${token_auth}                  Fazer Login                     ${registro_usuarios.user_admin}
    &{headers}                     Create Dictionary               Authorization=${token_auth}

    ${num_carrinhos_inicial}       Obter Quantidade De Carrinhos

    ${response}                    Enviar POST    /carrinhos    ${carrinho}    headers=${headers}

    Validar Status Code            400    ${response}
    Validar Mensagem               Produto n??o possui quantidade suficiente    ${response}
    
    # Verifica se a quantidade de carrinhos permanece a mesma.
    ${num_carrinhos_final}         Obter Quantidade De Carrinhos
    Should Be Equal As Integers    ${num_carrinhos_inicial}    ${num_carrinhos_final}
    
    [Teardown]         Run Keywords
    ...                Limpar Registro De Produtos
    ...    AND         Limpar Registro De Usuarios


CT-C10: POST Tentar Cadastrar Carrinho Sem Login 401
    [Documentation]    Teste de cadastrar novo carrinho sem ter feito login.
    [Tags]             POST    STATUS-4XX

    [Setup]            Preparar Novo Produto Dinamico    produto_1
    
    # Criar dados do Carrinho
    &{produto}                     Create Dictionary    idProduto=${registro_produtos.produto_1}    quantidade=${3}
    @{lista_produtos}              Create List          ${produto}
    &{carrinho}                    Create Dictionary    produtos=${lista_produtos}

    ${num_carrinhos_inicial}       Obter Quantidade De Carrinhos

    ${response}                    Enviar POST    /carrinhos    ${carrinho}

    Validar Status Code            401    ${response}
    Validar Mensagem               Token de acesso ausente, inv??lido, expirado ou usu??rio do token n??o existe mais
    ...                            ${response}

    # Verifica se a quantidade de carrinhos permanece a mesma.
    ${num_carrinhos_final}         Obter Quantidade De Carrinhos
    Should Be Equal As Integers    ${num_carrinhos_inicial}    ${num_carrinhos_final}

    [Teardown]         Limpar Registro De Produtos


CT-C11: POST Tentar Cadastrar Carrinho Vazio 400
    [Documentation]    Teste de cadastrar um carrinho vazio.
    [Tags]             POST    STATUS-4XX

    [Setup]            Preparar Novo Usuario Dinamico    user_admin    administrador=true

    # Criar dados do Carrinho
    @{lista_produtos}              Create List          @{EMPTY}
    &{carrinho}                    Create Dictionary    produtos=${lista_produtos}

    ${token_auth}                  Fazer Login                     ${registro_usuarios.user_admin}
    &{headers}                     Create Dictionary               Authorization=${token_auth}

    ${num_carrinhos_inicial}       Obter Quantidade De Carrinhos

    ${response}                    Enviar POST    /carrinhos    ${carrinho}    headers=${headers}

    Validar Status Code            400    ${response}
    Log To Console                 ${response.json()}

    # Verifica se a quantidade de carrinhos permanece a mesma.
    ${num_carrinhos_final}         Obter Quantidade De Carrinhos
    Should Be Equal As Integers    ${num_carrinhos_inicial}    ${num_carrinhos_final}

    [Teardown]         Limpar Registro De Usuarios


CT-C12: POST Tentar Cadastrar Carrinho Com Dados Invalidos 400
    [Documentation]    Teste para tentativa de cadastro de carrinho com dados inv??lidos.
    ...                Os dados s??o gerados a partir de um modelo v??lido,
    ...                mas com entradas em branco, ou faltando.
    [Tags]             POST    STATUS-4XX

    [Setup]            Run Keywords
    ...                Preparar Novo Usuario Dinamico    user_admin    administrador=true
    ...    AND         Preparar Novo Produto Dinamico    produto_1

    # Criar dados do modelo
    &{produto}             Create Dictionary        idProduto=${registro_produtos.produto_1}    quantidade=${2}

    ${token_auth}          Fazer Login                     ${registro_usuarios.user_admin}
    &{headers}             Create Dictionary               Authorization=${token_auth}

    @{dados_invalidos}     Gerar Dados Invalidos    ${produto}

    FOR  ${produto_invalido}  IN  @{dados_invalidos}
        # Finaliza a constru????o do carrinho
        @{lista_produtos}              Create List          ${produto_invalido}
        &{carrinho}                    Create Dictionary    produtos=${lista_produtos}

        Log To Console                 Testando: ${carrinho}

        ${num_carrinhos_inicial}       Obter Quantidade De Carrinhos

        ${response}                    Enviar POST    /carrinhos    ${carrinho}    headers=${headers}

        Validar Status Code            400    ${response}
        Log To Console                 ${response.json()}

        # Verifica se a quantidade de carrinhos permanece a mesma.
        ${num_carrinhos_final}         Obter Quantidade De Carrinhos
        Should Be Equal As Integers    ${num_carrinhos_inicial}    ${num_carrinhos_final}
    END

    [Teardown]            Run Keywords
    ...                   Limpar Registro De Produtos
    ...    AND            Limpar Registro De Usuarios


#########################
#         DELETE        #
#     CT-C13 ~ CT-C18   #
#########################
CT-C13: DELETE Concluir Compra Com Carrinho Existente 200
    [Documentation]    Teste de concluir compra com carrinho existente com sucesso.
    [Tags]             DELETE    STATUS-2XX
    
    [Setup]            Run Keywords
    ...                Preparar Novo Usuario Dinamico    user_admin    administrador=true
    ...    AND         Preparar Novo Produto Dinamico    produto_1     quantidade=${50}

    ${quantidade_estoque}          Set Variable    ${50}

    ${token_auth}                  Fazer Login                     ${registro_usuarios.user_admin}
    &{headers}                     Create Dictionary               Authorization=${token_auth}

    # Criar Carrinho
    ${quantidade_carrinho}         Set Variable         ${3}
    ${id_carrinho}                 Cadastrar Carrinho    ${registro_produtos.produto_1}    ${token_auth}    ${quantidade_carrinho}

    ${response}                    Enviar DELETE    /carrinhos/concluir-compra    headers=${headers}

    Validar Status Code            200    ${response}
    Validar Mensagem               Registro exclu??do com sucesso    ${response}

    # Verifica se o carrinho foi realmente exclu??do
    ${response}                    Enviar GET    /carrinhos/${id_carrinho}

    Validar Status Code            400    ${response}
    Validar Mensagem               Carrinho n??o encontrado    ${response}

    # Verifica se o estoque N??O foi reabastecido
    ${response}                    Enviar GET      /produtos/${registro_produtos.produto_1}

    ${novo_estoque}                Set Variable    ${response.json()["quantidade"]}
    Should Be Equal As Integers    ${novo_estoque}    ${${quantidade_estoque}-${quantidade_carrinho}}

    [Teardown]         Run Keywords
    ...                Limpar Registro De Produtos
    ...    AND         Limpar Registro De Usuarios


CT-C14: DELETE Cancelar Compra Com Carrinho Existente 200
    [Documentation]    Teste de cancelar compra com carrinho existente com sucesso.
    [Tags]             DELETE    STATUS-2XX
    
    [Setup]            Run Keywords
    ...                Preparar Novo Usuario Dinamico    user_admin    administrador=true
    ...    AND         Preparar Novo Produto Dinamico    produto_1     quantidade=${50}

    ${quantidade_estoque}          Set Variable    ${50}

    ${token_auth}                  Fazer Login                     ${registro_usuarios.user_admin}
    &{headers}                     Create Dictionary               Authorization=${token_auth}

    # Criar Carrinho
    ${quantidade_carrinho}         Set Variable          ${3}
    ${id_carrinho}                 Cadastrar Carrinho    ${registro_produtos.produto_1}    ${token_auth}    ${quantidade_carrinho}

    ${response}                    Enviar DELETE    /carrinhos/cancelar-compra    headers=${headers}

    Validar Status Code            200    ${response}
    Validar Mensagem Contem        Registro exclu??do com sucesso    ${response}

    # Verifica se o carrinho foi realmente exclu??do
    ${response}                    Enviar GET    /carrinhos/${id_carrinho}

    Validar Status Code            400    ${response}
    Validar Mensagem               Carrinho n??o encontrado    ${response}

    # Verifica se o estoque FOI reabastecido
    ${response}                    Enviar GET    /produtos/${registro_produtos.produto_1}

    ${novo_estoque}                Set Variable    ${response.json()["quantidade"]}
    Should Be Equal As Integers    ${novo_estoque}    ${${quantidade_estoque}}

    [Teardown]         Run Keywords
    ...                Limpar Registro De Produtos
    ...    AND         Limpar Registro De Usuarios


CT-C15: DELETE Tentar Concluir Compra Sem Carrinho 200
    [Documentation]    Teste de concluir compra com usu??rio sem carrinho.
    [Tags]             DELETE    STATUS-2XX
    
    [Setup]            Preparar Novo Usuario Dinamico    user_admin    administrador=true

    ${token_auth}                  Fazer Login                     ${registro_usuarios.user_admin}
    &{headers}                     Create Dictionary               Authorization=${token_auth}

    ${num_carrinhos_inicial}       Obter Quantidade De Carrinhos

    ${response}                    Enviar DELETE    /carrinhos/concluir-compra    headers=${headers}

    Validar Status Code            200    ${response}
    Validar Mensagem               N??o foi encontrado carrinho para esse usu??rio    ${response}

    # Verifica se a quantidade de carrinhos permanece a mesma.
    ${num_carrinhos_final}         Obter Quantidade De Carrinhos
    Should Be Equal As Integers    ${num_carrinhos_inicial}    ${num_carrinhos_final}

    [Teardown]         Limpar Registro De Usuarios


CT-C16: DELETE Tentar Cancelar Compra Sem Carrinho 200
    [Documentation]    Teste de cancelar compra com usu??rio sem carrinho.
    [Tags]             DELETE    STATUS-2XX
    
    [Setup]            Preparar Novo Usuario Dinamico    user_admin    administrador=true

    ${token_auth}                  Fazer Login                     ${registro_usuarios.user_admin}
    &{headers}                     Create Dictionary               Authorization=${token_auth}
    
    ${num_carrinhos_inicial}       Obter Quantidade De Carrinhos

    ${response}                    Enviar DELETE    /carrinhos/cancelar-compra    headers=${headers}

    Validar Status Code            200    ${response}
    Validar Mensagem               N??o foi encontrado carrinho para esse usu??rio    ${response}

    # Verifica se a quantidade de carrinhos permanece a mesma.
    ${num_carrinhos_final}         Obter Quantidade De Carrinhos
    Should Be Equal As Integers    ${num_carrinhos_inicial}    ${num_carrinhos_final}

    [Teardown]         Limpar Registro De Usuarios


CT-C17: DELETE Tentar Concluir Compra Sem Login 401
    [Documentation]    Teste de concluir compra sem ter feito login.
    [Tags]             DELETE    STATUS-4XX

    ${num_carrinhos_inicial}       Obter Quantidade De Carrinhos

    ${response}                    Enviar DELETE    /carrinhos/concluir-compra

    Validar Status Code            401    ${response}
    Validar Mensagem               Token de acesso ausente, inv??lido, expirado ou usu??rio do token n??o existe mais
    ...                            ${response}

    # Verifica se a quantidade de carrinhos permanece a mesma.
    ${num_carrinhos_final}         Obter Quantidade De Carrinhos
    Should Be Equal As Integers    ${num_carrinhos_inicial}    ${num_carrinhos_final}


CT-C18: DELETE Tentar Cancelar Compra Sem Login 401
    [Documentation]       Teste de cancelar compra sem ter feito login.
    [Tags]                DELETE    STATUS-4XX
    
    ${num_carrinhos_inicial}       Obter Quantidade De Carrinhos

    ${response}                    Enviar DELETE    /carrinhos/cancelar-compra

    Validar Status Code            401    ${response}
    Validar Mensagem               Token de acesso ausente, inv??lido, expirado ou usu??rio do token n??o existe mais
    ...                            ${response}

    # Verifica se a quantidade de carrinhos permanece a mesma.
    ${num_carrinhos_final}         Obter Quantidade De Carrinhos
    Should Be Equal As Integers    ${num_carrinhos_inicial}    ${num_carrinhos_final}


##########################################################################################